from pathlib import Path
import json,math,hashlib,datetime
exec(Path('E:/mapslol3v3/qualify_structure_native_pose.py').read_text().split('reports=[]')[0])
binding=json.loads((r/'data/4.20/structure_clip_playback.json').read_text())['models'];sources={m['alias']:m for m in sources};prepared={};measurements={}
files=['logs/structure-lifecycle-runtime.jsonl','logs/destroyed-structure-lifecycle-runtime.jsonl'];reports=['docs/structure_lifecycle_runtime.json','docs/destroyed_structure_lifecycle_runtime.json'];client_hash=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
for report in reports:assert json.loads((r/report).read_text())['client_sha256']==client_hash
for file in files:
 for row in [json.loads(line) for line in (r/file).read_text().splitlines()]:
  for actor in row['actors']:
   c=binding.get(actor['model'],{}).get(actor['role'])
   if not c:continue
   model=c['native_model'];source=sources[model]
   if model not in prepared:
    raw=Path(source['clip']).read_bytes();assert hashlib.sha256(raw).hexdigest()==source['clip_sha256'];resource,hashes,frames,step,adapter=parsed_resource(raw);g,b=glb(r/'assets'/source['asset']);names=[g['nodes'][n]['name'] for n in g['skins'][0]['joints']];indices=[hashes.index(elf(name)) for name in names];prepared[model]=(resource,step,names,indices,adapter)
   resource,step,names,indices,adapter=prepared[model];assert len(actor['active_clips'])==1
   clip_state=actor['active_clips'][0];frame=clip_state['seek_time']/c['gltf_time_step'];native_time=f32(frame*step);poses_out=execute(resource,native_time,indices);actual={p['name']:p for p in actor['joint_pose']};measurement=measurements.setdefault(model,dict(samples=0,joint_samples=0,max_translation_error=0.,max_scale_error=0.,max_normalized_quaternion_error=0.,adapter=adapter))
   for name,pose in zip(names,poses_out):
    p=actual[name];t=max(abs(a-b) for a,b in zip(pose[:3],p['translation']));s=max(abs(a-b) for a,b in zip(pose[3:6],p['scale']));nq=normalized(pose[6:]);aq=normalized(p['rotation']);q=min(max(abs(a-b) for a,b in zip(nq,aq)),max(abs(a+b) for a,b in zip(nq,aq)))
    assert t<.001 and s<1e-5 and q<1e-5,(model,name,frame,t,s,q)
    measurement['joint_samples']+=1;measurement['max_translation_error']=max(measurement['max_translation_error'],t);measurement['max_scale_error']=max(measurement['max_scale_error'],s);measurement['max_normalized_quaternion_error']=max(measurement['max_normalized_quaternion_error'],q)
   measurement['samples']+=1
assert len(measurements)==16
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,client_sha256=client_hash,native_sha256=digest,native_entry='0x893c80',native_addresses=len(visited),measurements=measurements,probe_hashes={file:hashlib.sha256((r/file).read_bytes()).hexdigest() for file in files},limits=['Actual loaded joint Transform samples from two diagnostic Vulkan fixtures compared to original uncompressed pose evaluator.','Two original v4 resources and fourteen explicitly adapted v3 resources; native legacy conversion, skeleton loader, full BLND construction/state selection and original effects remain open.','No ordinary full-match victory/results or complete-game fidelity qualification.'])
Path('E:/mapslol3v3/structure_runtime_native_pose_contract.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(passed=True,models=len(measurements),samples=sum(m['samples'] for m in measurements.values()),joint_samples=sum(m['joint_samples'] for m in measurements.values()),max_translation_error=max(m['max_translation_error'] for m in measurements.values()),max_rotation_error=max(m['max_normalized_quaternion_error'] for m in measurements.values()))))
