from pathlib import Path
import json,struct,subprocess,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exe=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.exe')
models=json.loads((r/'docs/map10_destroyed_asset_recovery.json').read_text(encoding='utf-8'))['models']
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
archive=r/'docs/plan_history'/('destroyed-animation-'+stamp)
archive.mkdir(parents=True)
manifest_path=r/'data/4.20/world_animation_manifest.json'
manifest=json.loads(manifest_path.read_text(encoding='utf-8'))
shutil.copy2(manifest_path,archive/manifest_path.name)
records={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for name,m in models.items():
 folder=Path(m['rig']).parent
 while folder.name.lower()!=name.lower():folder=folder.parent
 blends=list(folder.rglob('*.blnd'));anms=list(folder.rglob('*.anm'))
 assert len(blends)==len(anms)==1,(name,blends,anms)
 blend,anm=blends[0],anms[0];b=blend.read_bytes()
 assert len(b)==580 and b[:8]==b'r3d2blnd' and struct.unpack_from('<II',b,0x18)==(3,3)
 states=[]
 for i,state in enumerate(['Death','Idle1','Attack1']):
  off=0xd8+i*80
  assert struct.unpack_from('<I',b,off+8)[0]==i
  assert b[off+20:].split(b'\0',1)[0].decode()==state
  pointer=off+56+struct.unpack_from('<i',b,off+56)[0]
  assert pointer==0x9c
  assert b[0xac:0xac+8]==b'Default\0'
  states.append(dict(name=state,record_offset=off,shared_descriptor_offset=pointer,shared_descriptor_name='Default',shared_descriptor_semantics_qualified=False))
 strings=b[0x1d4:].split(b'\0')
 path=strings[0].decode();assert path.lower().endswith('/'+anm.name.lower())
 audit_path=archive/(name+'-audit.json')
 proc=subprocess.run([str(exe),'animation-audit',m['rig'],str(audit_path),str(anm)],capture_output=True,text=True)
 assert proc.returncode==0,proc.stdout+proc.stderr
 audit=json.loads(audit_path.read_text(encoding='utf-8-sig'))
 print(json.dumps(dict(model=name,audit=audit,states=states)),flush=True)
 records[name]=dict(blend=str(blend),blend_sha256=sha(blend),clip=str(anm),clip_sha256=sha(anm),states=states,audit=audit,asset=m['asset'])
(r/'docs/destroyed_animation_source_audit.json').write_text(json.dumps(dict(updated_utc=stamp,complete=False,models=records,limits=['Fixed-layout BLND relative state pointers checked against four original files; native BLND reader, event/loop flags and full destruction lifecycle remain unqualified.']),indent=2)+'\n',encoding='utf-8')
