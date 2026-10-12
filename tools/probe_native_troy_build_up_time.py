from pathlib import Path
import json,struct,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_troy_group_vis.py').read_text(encoding='utf-8').split('catalog=json.loads')[0]
source=source.replace('(0x918f74,0x918f9c),(0x921f60,0x922000)','(0x919c9d,0x919cbe),(0x8afc30,0x8afd10)').replace('a==0x918f9c','a==0x919cbe')
exec(compile(source,'binary loader setup','exec'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());definitions=list(catalog['definitions']);doc=json.loads((r/'data/4.20/particles/annie/Annie_Q_mis.json').read_text());definitions.append(dict(reference='Annie_Q_mis',native_file=doc['native_file'],source_sha256=doc['source_sha256'],asset='data/4.20/particles/annie/Annie_Q_mis.json'));cases=[]
for definition in definitions:
 source=Path(definition['native_file']);contents=source.read_bytes();assert hashlib.sha256(contents).hexdigest()==definition['source_sha256'];cursor=0;closes=0;opens=[];reads=[]
 u.mem_write(config,bytes(0x180));write32(config+0x71,15);u.mem_write(key_vectors,bytes(14*12));write32(config+0x7c,key_vectors);write32(config+0x80,key_vectors+14*12);write32(config+0x84,key_vectors+14*12)
 u.mem_write(path_buffer,(source.stem+'.troy').encode('ascii')+b'\0');invoke(0x8b0380,config,struct.pack('<I',path_buffer));assert cursor==len(contents) and closes==1
 u.mem_write(config+0x148,b'\1');doc=json.loads((r/definition['asset']).read_text());authored=doc['sections']['System'].get('build-up-time',0.)
 for initial in [0,0x3f800000,0xffffffff]:
  requests=[];conversions=[];write32(metadata+0x1c0,initial);sp=stack+0x8000;u.mem_write(sp,bytes(0x300));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,metadata);u.reg_write(UC_X86_REG_EBX,path_buffer)
  u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x919c9d,0x919cbe,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x919cbe
  actual=read32(metadata+0x1c0);assert actual==struct.unpack('<I',struct.pack('<f',float(authored)))[0],(definition['reference'],authored,actual)
  cases.append(dict(reference=definition['reference'],source_sha256=definition['source_sha256'],authored=authored,initial_bits=initial,value_bits=actual,requests=requests.copy(),conversions=conversions.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,cases=cases,entries=['8B0380','919C9D..919CBE','8B1F50'],findings=['System/build-up-time is read with default zero into config1C0.','This field supplies resume offset and frame catchup cap; cap is at least 0.5 seconds.'],adapters=['Original binary loader and typed lookup with inherited file/cache transport.','Bounded caller uses actual resource bytes, no overlays.'],limits=['Whole parent runtime integration and engine rate producer remain open.'])
(r/'data/4.20/troy_build_up_time_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(len(cases))
