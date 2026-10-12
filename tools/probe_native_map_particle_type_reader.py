"""Original string-reader chain with cache and raw lookup boundaries supplied."""
from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'))
base=p.OPTIONAL_HEADER.ImageBase;visited=set();requests=[];authored=None;cache_pair=heap+0x100;config=heap+0x200;output=heap+0x600;keyptr=heap+0x3000;filepath=heap+0x3100;passed=[]
write32(cache_pair,config);write32(cache_pair+4,0);u.mem_write(config,b'\0'*0x180);u.mem_write(config+0x148,b'\1');u.mem_write(keyptr,b'GroupPart1Type\0');u.mem_write(filepath,b'DATA/Particles/TT_Fire_Orange.troybin\0')
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==0x8acef0:
  assert cbytes(read32(sp+4))==b'DATA/Particles/TT_Fire_Orange.troybin' and read32(sp+8)==0;requests.append('cache');finish(8,cache_pair);return
 if a==0x8ae6a0:
  assert this==config;key=read32(sp+4);dest=read32(sp+8);assert key==expected_hash;requests.append('raw-string-lookup')
  if authored is not None:put(dest,authored)
  finish(8,int(authored is not None));return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);put(this,bytes(u.mem_read(src,n)).decode('ascii'));finish(8,this);return
 if a==0x564d20:put(this,cbytes(read32(sp+4)).decode('ascii'));finish(4,this);return
 if a==0xc981c0:
  dest,src,n=[read32(sp+i) for i in (4,8,12)];assert n<0x13a0;u.mem_write(dest,bytes(u.mem_read(src,n)));finish(eax=dest);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
expected_hash=0
for c in 'system*grouppart1type':expected_hash=(ord(c)+65599*expected_hash)&0xffffffff
for authored in [None,'','Complex','Simple','simple','SIMPLE','Simplex',' Simple','Simple ','Basic','High','Low','Medium','x'*20]:
 cursor=heap+0x4000;requests=[];write32(0x2d8a9d8,1);write32(0x2d83fb8,1);put(0x2d88138,'');u.mem_write(output,b'\xa5'*0x13a0);sp=stack+0x8000;write32(sp,end)
 for i,v in enumerate([0x10d7e40,output,0x139f,filepath,0]):write32(sp+4+4*i,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,0x108ba08);u.reg_write(UC_X86_REG_EDX,keyptr);u.emu_start(0x8b0630,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=cbytes(output).decode('ascii');expected='Complex' if authored is None else authored;assert result==expected and requests==['cache','raw-string-lookup'],(authored,result,requests)
 passed.append({'authored':authored,'output':result,'lookup_requests':list(requests)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x8b0630','original_chain':['0x8b0630','0x8ad4d0','0x8e51a0','0x8b01c0'],'cases':passed,'original_instruction_addresses':len(visited),'adapters':['Cache8ACEF0 returns a supplied original-shaped primary-config pair; overlay absent.','Raw8AE6A0 string lookup returns decoded fixtures or not-found; original storage lookup not executed.','String assignment, output memory copy and cookie validator adapted; original field hash, default selection and outer reader execute.'],'limits':['Primary binary-enabled config flag supplied, not populated by original loader. Full filesystem/cache/storage execution remains unqualified.','Original caller default literal Complex verified; absent supplied raw-string lookup returns Complex, explicit empty field remains empty. This is reader composition proof, not full native particle rendering.']}
(r/'data/4.20/map_particle_type_reader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(passed),'native_addresses':len(visited),'passed':True}))
