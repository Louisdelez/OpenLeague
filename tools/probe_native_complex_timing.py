"""Original Complex time-offset/life/active/period caller getter/default paths."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
obj=heap+0x1000;group=heap+0x2000;path=heap+0x2200;float_cell=heap+0x2400;stub=end+0x100;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3');u.mem_write(group,b'TT_Fire_01\0');u.mem_write(path,b'fixture.troy\0');visited=set();requests=[];global_bits=None;fields={}
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x8b20f0:
  assert cbytes(u.reg_read(UC_X86_REG_ECX))==b'Hacks' and cbytes(u.reg_read(UC_X86_REG_EDX))==b'default-e-life';default=read32(sp+4);result=default if global_bits is None else global_bits;key='Hacks/default-e-life'
 elif a==0x8b1f50:
  assert cbytes(read32(sp+4))==cbytes(path) and cbytes(read32(sp+8))==cbytes(group) and read32(sp+20)==0
  key=cbytes(read32(sp+12)).decode();assert key in ('e-timeoffset','e-life','e-active','e-period');default=read32(sp+16);result=fields.get(key,default)
 else:
  if stub<=a<stub+7:return
  assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a);return
 requests.append({'key':key,'default_bits':hex(default),'result_bits':hex(result)});write32(float_cell,result);u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(values,g,name):
 global fields,global_bits,requests
 fields=values;global_bits=g;requests=[];u.mem_write(obj,b'\0'*0x584)
 for start,stop in [(0x911f59,0x911fcf),(0x912070,0x9120c2)]:
  sp=stack+0x7000;u.mem_write(sp-0x200,b'\0'*0x600);write32(sp+0x10,path);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,group);u.reg_write(UC_X86_REG_EDI,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(start,stop,count=1000);assert u.reg_read(UC_X86_REG_EIP)==stop
 return {'name':name,'fields_bits':{k:hex(v) for k,v in values.items()},'global_life_bits':None if g is None else hex(g),'time_offset_bits':hex(read32(obj+0x2ec)),'life_bits':hex(read32(obj+0x2f0)),'active_bits':hex(read32(obj+0x30c)),'period_bits':hex(read32(obj+0x308)),'requests':requests.copy()}
values=[None,0xff800000,0xbf800000,0x80000000,0,0x3dcccccd,0x3f800000,0x41a00000,0x7f7fffff,0x7f800000,0x7fc00000];cases=[]
for v,g in itertools.product(values,[None,0xbf800000,0,0x41a00000]):cases.append(run({} if v is None else {k:v for k in ('e-timeoffset','e-life','e-active','e-period')},g,'boundary'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 doc=json.loads((r/definition['asset']).read_text())
 for emitter in definition['groups']:
  if emitter['declared_type']=='Simple':continue
  values={}
  for k in ('e-timeoffset','e-life','e-active','e-period'):
   v=doc['sections'][emitter['name']].get(k)
   if v is not None:assert isinstance(v,(int,float));values[k]=struct.unpack('<I',struct.pack('<f',v))[0]
  cases.append(run(values,None,'map:'+definition['reference']+':'+emitter['name']))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Original global/raw scalar getter arguments checked; returned f32 bits supplied through fld/ret adapter. Original caller defaults, assignments and negative-life sentinel branch execute.'],'limits':['Original underlying INIBIN/cache/lexical getters not executed. Overrides limited to explicit supplied global life.','Period/active/timeoffset stored without clamping; no full emitter lifecycle/update/render qualification.']}
(r/'data/4.20/complex_emitter_timing_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'defaults':cases[0]['requests'],'passed':True}))
