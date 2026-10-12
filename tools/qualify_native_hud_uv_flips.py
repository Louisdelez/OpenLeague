from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD UV flips prerequisites','exec'))
obj=vector+0x8000
def flip_hook(uc,a,size,user):
 assert 0x9a1d10<=a<=0x9a1e34,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,flip_hook)
cases=[]
for kind,flags,values in itertools.product([1,2,3],[0,0x400,0x800,0xc00,0xffffffff],[[0.,.125,.25,.5,.75,1.,1.25,1.5],[-2.,-.5,0.,1.,-1.,.25,2.,3.]]):
 initial=bytearray(b'\xa5'*0x30c);struct.pack_into('<I',initial,0x40,kind);struct.pack_into('<I',initial,0x48,flags)
 for off in [0x204,0x264]:struct.pack_into('<8f',initial,off,*values)
 u.mem_write(obj,bytes(initial));w(stack,end);w(stack+4,obj);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x027f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x9a1d10,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=bytearray(initial)
 if kind in [1,2]:
  offset=0x204 if kind==1 else 0x264;v=list(struct.unpack_from('<8I',initial,offset))
  if flags&0x400:v[0],v[2]=v[2],v[0];v[4],v[6]=v[6],v[4]
  if flags&0x800:v[1],v[3]=v[3],v[1];v[5],v[7]=v[7],v[5]
  struct.pack_into('<8I',expected,offset,*v)
 output=bytes(u.mem_read(obj,len(initial)));assert output==expected
 cases.append(dict(kind=kind,flags=flags,initial_hex=bytes(initial).hex(),output_hex=output.hex()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a1d10',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,findings=['Flags400/800 swap x/y pairs respectively in both current/ranged UV quads for Icon/Effect; Text untouched.','Original SSE/x87 instructions execute; whole field storage compared to independent bit permutation for supplied finite values.'],runtime_adapters=['No function adapters; storage and x87CW027f supplied.'],limits=['Finite UV values only; exceptional/nonfinite x87 behavior not qualified.','Native contract only; Rust port/runtime post-validation integration still pending.'])
(r/'data/4.20/native_hud_uv_flips_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),rust_ported=False)))
