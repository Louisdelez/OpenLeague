from pathlib import Path
import json,subprocess,datetime,hashlib
r=Path('E:/OpenLeague');inventory=json.loads((r/'docs/intact_structure_animation_inventory.json').read_text(encoding='utf-8'));exe=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.exe');stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');out=r/'docs/plan_history'/('intact-clip-audit-'+stamp);out.mkdir(parents=True);records=[]
for model in inventory['records']:
 refs=model['authored_graph_references'];rigs=[f for f in refs if f['path'].lower().endswith('.skl')];clips=[f for f in refs if f['path'].lower().endswith('.anm')]
 assert len(rigs)==1 and len(clips)==1 and all(f['exists'] for f in refs)
 report=out/(model['alias']+'.json');proc=subprocess.run([str(exe),'animation-audit',rigs[0]['path'],str(report),clips[0]['path']],capture_output=True,text=True);assert proc.returncode==0,proc.stdout+proc.stderr
 audit=json.loads(report.read_text(encoding='utf-8-sig'));assert len(audit)==1;a=audit[0];assert a['frames']>0 and a['tracks']==a['matching_joints'] and a['invalid_rotation_samples']==0 and not a['unmatched_tracks'],(model['alias'],a)
 record=dict(alias=model['alias'],source_mesh=model['selected_mesh'],rig=rigs[0],clip=clips[0],audit=a);records.append(record);print(json.dumps(dict(alias=model['alias'],frames=a['frames'],tracks=a['tracks'],duration=a['duration'])),flush=True)
(r/'docs/intact_structure_clip_audit.json').write_text(json.dumps(dict(updated_utc=stamp,complete=False,records=records,exporter_sha256=hashlib.sha256(exe.read_bytes()).hexdigest(),limits=['Original graph ANM/SKL pairs read and all sampled rotation tracks valid. Mesh/rig bind transforms and native BLND state/event semantics remain to qualify before integration.','Client still has empty animation roles for these intact structures.']),indent=2)+'\n',encoding='utf-8')
