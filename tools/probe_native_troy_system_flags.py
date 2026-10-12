from pathlib import Path
import json,struct,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_troy_group_vis.py').read_text(encoding='utf-8').split('catalog=json.loads')[0]
source=source.replace('(0x918f74,0x918f9c),(0x921f60,0x922000)','(0x919720,0x919c9d),(0x8afc30,0x8afd10)').replace('a==0x918f9c','a==0x919c9d')
exec(compile(source,'binary loader setup','exec'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());definitions=list(catalog['definitions']);doc=json.loads((r/'data/4.20/particles/annie/Annie_Q_mis.json').read_text());definitions.append(dict(reference='Annie_Q_mis',native_file=doc['native_file'],source_sha256=doc['source_sha256'],asset='data/4.20/particles/annie/Annie_Q_mis.json'));definitions.extend(dict(reference=p.stem,native_file=d['native_file'],source_sha256=d['source_sha256'],asset=str(p.relative_to(r))) for p in sorted((r/'data/4.20/particles').glob('Audio-Emitter_*.json')) for d in [json.loads(p.read_text())]);cases=[]
for definition in definitions:
 source=Path(definition['native_file']);contents=source.read_bytes();assert hashlib.sha256(contents).hexdigest()==definition['source_sha256'];cursor=0;closes=0;opens=[];reads=[]
 u.mem_write(config,bytes(0x180));write32(config+0x71,15);u.mem_write(key_vectors,bytes(14*12));write32(config+0x7c,key_vectors);write32(config+0x80,key_vectors+14*12);write32(config+0x84,key_vectors+14*12)
 u.mem_write(path_buffer,(source.stem+'.troy').encode('ascii')+b'\0');invoke(0x8b0380,config,struct.pack('<I',path_buffer));assert cursor==len(contents) and closes==1
 u.mem_write(config+0x148,b'\1');doc=json.loads((r/definition['asset']).read_text());authored=doc['sections']['System'].get('SimulateWhileOffScreen',False)
 for initial in [0,0x15,0xffffffff]:
  requests=[];conversions=[];write32(metadata+0x1bc,initial);sp=stack+0x8000;u.mem_write(sp,bytes(0x300));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,metadata);u.reg_write(UC_X86_REG_EBX,path_buffer)
  write32(0x2d83fb8,1);u.emu_start(0x919720,0x919c9d,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x919c9d
  actual=read32(metadata+0x1bc)
  cases.append(dict(reference=definition['reference'],source_sha256=definition['source_sha256'],system=doc['sections']['System'],authored=authored,initial_flags=initial,flags=actual,requests=requests.copy(),conversions=conversions.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,cases=cases,entries=['8B0380','919720..919C9D','8AFC30'],adapters=['Original resource binary loader, typed boolean getter and contiguous configuration flags constructor executed.','Inherited file/cache transport; global cache initialized bit supplied as1; no overlays; initial metadata flags varied.'],limits=['Parent instance/source flags are distinct from these configuration flags.','Full resource constructor and startup cache ownership remain separate.'])
(r/'data/4.20/troy_system_flags_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'results':{c['reference']:c['flags'] for c in cases}}))
