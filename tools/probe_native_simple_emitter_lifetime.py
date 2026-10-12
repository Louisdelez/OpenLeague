from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil,itertools
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
obj=heap+0x1000;group=heap+0x2000;path=heap+0x2200;float_cell=heap+0x2400;stub=end+0x100;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3');u.mem_write(group,b'TT_Fire_01\0');u.mem_write(path,b'DATA/Particles/TT_Fire_Orange.troybin\0');visited=set();requests=[];global_bits=None;authored_bits=None
def hexfloat(value):return '0x'+struct.pack('<f',value)[::-1].hex()
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x91de17:uc.emu_stop();return
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
 global_bits=gbits;authored_bits=abits;requests=[];sp=stack+0x7000;u.mem_write(sp,b'\0'*0x200);write32(sp+0x10,path);write32(obj+0x168,0xa5a5a5a5);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,group);u.reg_write(UC_X86_REG_EDI,path);u.reg_write(UC_X86_REG_EBX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x91ddcc,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x91de17
 return {'label':label,'global_authored_bits':None if gbits is None else hex(gbits),'emitter_authored_bits':None if abits is None else hex(abits),'lifetime_bits':hex(read32(obj+0x168)),'requests':list(requests)}
for g,a in itertools.product([None,0xbf800000,0,0x41a00000],[None,0xff800000,0xbf800000,0x80000000,0,0x3dcccccd,0x3f800000,0x41a00000,0x7f7fffff,0x7f800000,0x7fc00000]):cases.append(execute(g,a,'boundary'))

ambient=[]
for file in sorted((r/'data/4.20/particles').glob('Audio-Emitter_TT_*.json')):
 doc=json.loads(file.read_text());system=doc['sections']['System']
 for slot in range(1,65):
  name=system.get(f'GroupPart{slot}')
  if name is None:continue
  assert system.get(f'GroupPart{slot}Type')=='Simple'
  value=doc['sections'][name].get('e-life');assert value is None or isinstance(value,(int,float))
  abits=None if value is None else struct.unpack('<I',struct.pack('<f',value))[0]
  row=execute(None,abits,'ambient');row.update(file=str(file.relative_to(r)),group=name,source_sha256=doc['source_sha256']);ambient.append(row)
assert len(ambient)==5 and all(v['lifetime_bits']=='0x7f7fffff' for v in ambient)
proof={'passed':True,'native_sha256':digest,'range':['0x91ddcc','0x91de17'],'output_offset':'0x168','cases':cases,'ambient':ambient,'limits':['Native caller and negative-value conversion executed; typed getter values supplied via adapters.','No full particle parser or lifecycle execution. Hacks override absent for actual ambient groups.']}
(r/'data/4.20/simple_emitter_lifetime_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'passed':True,'cases':len(cases),'ambient_groups':len(ambient)}))
