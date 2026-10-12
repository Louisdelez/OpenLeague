from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil,itertools
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
obj=heap+0x1000;group=heap+0x2000;path=heap+0x2200;float_cell=heap+0x2400;stub=end+0x100;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3');u.mem_write(group,b'TT_Fire_01\0');u.mem_write(path,b'DATA/Particles/TT_Fire_Orange.troybin\0');visited=set();requests=[];global_bits=None;authored_bits=None
def hexfloat(value):return '0x'+struct.pack('<f',value)[::-1].hex()
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x911fcf:uc.emu_stop();return
 if a in (0x8b20f0,0x8b1f50):
  if a==0x8b20f0:
   assert cbytes(u.reg_read(UC_X86_REG_ECX))==b'Hacks' and cbytes(u.reg_read(UC_X86_REG_EDX))==b'default-e-life';default=read32(sp+4);assert default==0xbf800000;result=default if global_bits is None else global_bits;requests.append({'kind':'global-default','default_bits':hex(default),'result_bits':hex(result)})
  else:
   assert cbytes(read32(sp+4))==cbytes(path) and cbytes(read32(sp+8))==cbytes(group) and read32(sp+20)==0
   key=cbytes(read32(sp+12));default=read32(sp+16)
   if key==b'e-timeoffset':assert default==0;result=0;requests.append({'kind':'time-offset','default_bits':hex(default),'result_bits':hex(result)})
   else:assert key==b'e-life';result=default if authored_bits is None else authored_bits;requests.append({'kind':'authored-life','default_bits':hex(default),'result_bits':hex(result)})
  write32(float_cell,result);u.reg_write(UC_X86_REG_EIP,stub);return
 if stub<=a<stub+7:return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
def execute(gbits,abits,label):
 global global_bits,authored_bits,requests
 global_bits=gbits;authored_bits=abits;requests=[];sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);write32(sp+0x10,path);write32(obj+0x2f0,0xa5a5a5a5);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,group);u.reg_write(UC_X86_REG_EDI,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x911f59,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x911fcf
 return {'label':label,'global_authored_bits':None if gbits is None else hex(gbits),'emitter_authored_bits':None if abits is None else hex(abits),'lifetime_bits':hex(read32(obj+0x2f0)),'requests':list(requests)}
for g,a in itertools.product([None,0xbf800000,0,0x41a00000],[None,0xff800000,0xbf800000,0x80000000,0,0x3dcccccd,0x3f800000,0x41a00000,0x7f7fffff,0x7f800000,0x7fc00000]):cases.append(execute(g,a,'boundary'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text(encoding='utf-8'));bindings=json.loads((r/'data/4.20/map_particle_class_bindings.json').read_text(encoding='utf-8'));map_cases=[]
for row in bindings['groups']:
 if row['class']!='Complex':continue
 d=next(v for v in catalog['definitions'] if v['reference']==row['reference']);doc=json.loads((r/d['asset']).read_text(encoding='utf-8'));value=doc['sections'][row['name']].get('e-life');assert value is None or isinstance(value,(int,float));bits=None if value is None else struct.unpack('<I',struct.pack('<f',value))[0];result=execute(None,bits,'Map10');result.update(reference=row['reference'],slot=row['slot'],group=row['name'],authored=value);map_cases.append(result)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x911f59','stop':'0x911fcf','output_offset':'0x2f0','original_instruction_addresses':len(visited),'cases':cases,'map_cases':map_cases,'adapters':['Global8B20F0 and authored8B1F50 getters supply raw f32 fixtures with traced original default arguments; native storage lookup not executed.','Original caller, x87 write/compare and negative-life sentinel branch execute. A fld/ret adapter transports getter results.'],'limits':['e-life constructor value20 is not the reader default. Reader asks Hacks/default-e-life with fallback-1, then reads authored e-life with the resolved fallback.','Negative effective values become maximum finite f32, not infinity. Explicit zero, negative zero, positive infinity and quiet NaN retain native comparator behavior.','27 Map10 Complex groups evaluated with no Hacks override. Actual user-config overrides, full lifetime update/stop path, curves and rendering remain to qualify.']};(r/'data/4.20/complex_emitter_lifetime_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_groups':len(map_cases),'native_addresses':len(visited),'map_lifetimes':sorted({v['lifetime_bits'] for v in map_cases}),'passed':True}))
