from pathlib import Path
import json,struct,subprocess,hashlib,datetime,shutil,math
r=Path('E:/OpenLeague');exe=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.exe')
audit=json.loads((r/'docs/destroyed_animation_source_audit.json').read_text(encoding='utf-8'))
recovery=json.loads((r/'docs/map10_destroyed_asset_recovery.json').read_text(encoding='utf-8'))
mp=r/'data/4.20/world_animation_manifest.json';manifest=json.loads(mp.read_text(encoding='utf-8'))
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');archive=r/'docs/plan_history'/('destroyed-animation-bind-'+stamp);archive.mkdir(parents=True)
shutil.copy2(mp,archive/mp.name);records={}
for name,source in audit['models'].items():
 m=recovery['models'][name];a=source['audit'][0]
 assert a['frames']>0 and a['tracks']==a['matching_joints'] and a['invalid_rotation_samples']==0 and not a['unmatched_tracks']
 assert {s['shared_descriptor_offset'] for s in source['states']}=={156}
 target=r/'assets'/m['asset'];shutil.copy2(target,archive/target.name)
 clip_name=Path(source['clip']).stem
 proc=subprocess.run([str(exe),m['mesh'],m['rig'],m['texture'],str(target),clip_name,source['clip']],capture_output=True,text=True)
 assert proc.returncode==0,proc.stdout+proc.stderr
 b=target.read_bytes();g=json.loads(b[20:20+struct.unpack_from('<I',b,12)[0]])
 assert len(g['animations'])==1 and g['animations'][0]['name']==clip_name
 assert all('bufferView' in image for image in g['images'])
 animation=g['animations'][0];assert animation['channels'] and animation['samplers']
 bin_start=20+struct.unpack_from('<I',b,12)[0]+8;payload=b[bin_start:]
 times=[]
 for sampler in animation['samplers']:
  ac=g['accessors'][sampler['input']];view=g['bufferViews'][ac['bufferView']]
  assert ac['componentType']==5126 and ac['type']=='SCALAR'
  start=view.get('byteOffset',0)+ac.get('byteOffset',0);stride=view.get('byteStride',4)
  t=[struct.unpack_from('<f',payload,start+i*stride)[0] for i in range(ac['count'])]
  assert t and all(math.isfinite(v) for v in t) and t==sorted(t)
  times.extend(t)
 duration=max(times);assert duration>0
 aliases=[]
 for alias in recovery['aliases']:
  if alias['selected_model']!=name:continue
  entry=manifest[alias['alias']];assert entry['asset']==m['asset']
  entry.update(clips=[clip_name],roles={'idle':0,'death':0,'attack':0},duration_ticks={role:math.ceil(duration*30) for role in ['idle','death','attack']})
  aliases.append(alias['alias'])
 records[name]=dict(asset=m['asset'],glb_sha256=hashlib.sha256(b).hexdigest(),clip=clip_name,channels=len(animation['channels']),samplers=len(animation['samplers']),duration_seconds=duration,aliases=aliases,source=source)
 print(json.dumps(dict(model=name,channels=len(animation['channels']),duration=duration,aliases=len(aliases))),flush=True)
mp.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
report=dict(updated_utc=stamp,complete=False,models=records,manifest_sha256=hashlib.sha256(mp.read_bytes()).hexdigest(),limits=['Native animation tracks and original BLND state aliases exported; runtime loop flags, native BLND reader/events and full destruction transition remain unqualified.','No complete gameplay destruction or six-client victory/results proof.'])
(r/'docs/destroyed_animation_binding.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
