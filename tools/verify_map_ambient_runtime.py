"""Verify full native loop binding, advancing animation poses, suppression and placement."""
from pathlib import Path
import json,struct,hashlib,datetime,numpy as np
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
manifest=read('data/4.20/map_ambient_manifest.json');runtime=read('logs/ambient-runtime.json');source=read('docs/map_ambient_source_validation.json')
assert len(manifest['placements'])==17 and len(manifest['assets'])==8
expected={p['id']:p for p in manifest['placements']};players={p['id']:p for p in runtime['players']};poses={p['id']:p for p in runtime['poses']}
assert len(players)==len(runtime['players'])==17 and set(players)==set(poses)==set(expected)
assert len(runtime['suppressed_roots'])==19 and set(runtime['suppressed_roots'])==set(manifest['hidden_embedded_roots'])
assert set(manifest['excluded_duplicate_altar_roots'])<=set(runtime['suppressed_roots'])
assert runtime['sample_interval_seconds']>=5
for name,a in manifest['assets'].items():
 assert sha('assets/'+a['asset'])==a['sha256']
 assert a['clips'][a['primary_clip']]==a['primary_name'] and a['duration']>0
raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];doc=json.loads(raw[20:20+n]);world={}
def transform(node):
 if 'matrix' in node:return np.array(node['matrix']).reshape(4,4).T
 x,y,z,w=node.get('rotation',[0,0,0,1]);m=np.eye(4);m[:3,:3]=np.array([[1-2*(y*y+z*z),2*(x*y-z*w),2*(x*z+y*w)],[2*(x*y+z*w),1-2*(x*x+z*z),2*(y*z-x*w)],[2*(x*z-y*w),2*(y*z+x*w),1-2*(x*x+y*y)]])@np.diag(node.get('scale',[1,1,1]));m[:3,3]=node.get('translation',[0,0,0]);return m
root=np.diag([.05,.05,-.05,1.]);root[2,3]=15398.6719/20
by_name={node.get('name'):i for i,node in enumerate(doc['nodes'])}
def visit(i,parent):
 world[i]=parent@transform(doc['nodes'][i])
 for child in doc['nodes'][i].get('children',[]):visit(child,world[i])
for i in doc['scenes'][0]['nodes']:visit(i,root)
checks=[]
for id,p in expected.items():
 asset=manifest['assets'][p['native_asset']];player=players[id];pose=poses[id]
 assert player['native_asset']==p['native_asset'] and player['clip']==asset['primary_name']
 assert abs(player['duration']-asset['duration'])<.001 and not player['finished'] and player['elapsed']>=5
 assert pose['changed_local_transforms']>0 and pose['max_local_matrix_delta']>1e-5
 # Runtime root placement agrees with the restored original and preserves its mirror.
 matrix=np.array(p['matrix']);old=world[by_name[id]].T.reshape(-1);live=np.array(pose['world_matrix'])
 original_error=float(np.max(np.abs(matrix-old)));runtime_error=float(np.max(np.abs(matrix-live)))
 assert original_error<1e-5 and runtime_error<.0002,(id,original_error,runtime_error)
 checks.append({'id':id,'primary_clip':player['clip'],'duration':player['duration'],'elapsed':player['elapsed'],'changed_local_transforms':pose['changed_local_transforms'],'max_local_matrix_delta':pose['max_local_matrix_delta'],'original_parent_matrix_error':original_error,'runtime_parent_matrix_error':runtime_error})
frame=r/'logs/ambient-normal-render.png';assert frame.exists()
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'client_sha256':sha('target/debug/openleague-client.exe'),'map_sha256':sha('assets/maps/twisted_treeline.glb'),'manifest_sha256':sha('data/4.20/map_ambient_manifest.json'),'runtime_probe_sha256':sha('logs/ambient-runtime.json'),'frame':str(frame),'frame_sha256':hashlib.sha256(frame.read_bytes()).hexdigest(),'native_models':8,'native_animation_clips':11,'moving_instances':17,'suppressed_roots':runtime['suppressed_roots'],'checks':checks,'passed':True,'complete':False,'limits':manifest['limits']+['Visual capture inspected, but no original native runtime comparison or human fidelity acceptance.','Runtime root matrices preserve restored placement; full native placement/collision not qualified.','Static map Blender source does not include these separately loaded ambient models.']}
(r/'docs/map_ambient_runtime_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS: 17 moving native ambient instances, 19 stale groups hidden, 17 exact restored placements')
