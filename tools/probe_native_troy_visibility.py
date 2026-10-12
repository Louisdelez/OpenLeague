"""Whole8E36B0 six-plane support-point test with actual CPU scalar arithmetic."""
from pathlib import Path
import json,datetime,ctypes,shutil,random,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'0x8e36b0<=a<0x8e371c'")
exec(compile(setup,'visibility setup','exec'))
scratch=heap+0x5000;bounds_ptr=heap+0x6000;rng=random.Random(420)
special=[0,0x80000000,1,0x80000001,0x3f800000,0xbf800000,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234]
inputs=[]
for mode,phase in itertools.product(range(6),range(len(special))):
 planes=[[0]*4 for _ in range(6)];selectors=[[0,1,2] for _ in range(6)];bound=[special[(phase+i)%len(special)] for i in range(6)]
 if mode==1:planes=[[bits(1.),0,0,bits(1.)],[bits(-1.),0,0,bits(1.)],[0,bits(1.),0,bits(1.)],[0,bits(-1.),0,bits(1.)],[0,0,bits(1.),bits(1.)],[0,0,bits(-1.),bits(1.)]];selectors=[[3,4,5],[0,1,2],[3,4,5],[0,1,2],[3,4,5],[0,1,2]]
 if mode>=2:
  for i in range(6):planes[i]=[special[(phase+i+j)%len(special)] for j in range(4)];selectors[i]=[(phase+i+j)%6 for j in range(3)]
  if mode==3:planes[:5]=[[0]*4 for _ in range(5)]
  if mode==4:planes[0]=[0,0,0,bits(-1.)]
  if mode==5:planes[0]=[0,0,0,bits(1.)]
 inputs.append((planes,selectors,bound))
for _ in range(256):inputs.append(([[bits(rng.uniform(-100.,100.)) for j in range(4)] for i in range(6)],[[rng.randrange(6) for j in range(3)] for i in range(6)],[bits(rng.uniform(-10000.,10000.)) for i in range(6)]))
cases=[]
for planes,selectors,bound in inputs:
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(scratch,b'\xa5'*0x12c)
  for i in range(6):
   for j,v in enumerate(planes[i]):write32(scratch+0x6c+i*16+j*4,v)
   for j,v in enumerate(selectors[i]):write32(scratch+0xcc+i*12+j*4,v)
  for i,v in enumerate(bound):write32(bounds_ptr+i*4,v)
  original=bytes(u.mem_read(scratch,0x12c));sp=stack+0x8000;write32(sp,end);write32(sp+4,bounds_ptr);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,scratch);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x8e36b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+8 and bytes(u.mem_read(scratch,0x12c))==original
  captures.append(bool(u.reg_read(UC_X86_REG_EAX)&255))
 cases.append({'planes':[[hex(v) for v in p] for p in planes],'selectors':selectors,'bounds':[hex(v) for v in bound],'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'8E36B0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole8E36B0 executes six-plane indexed bounds test with explicit raw planes/selectors. Stack ret4 and unchanged scratch bytes checked.','Independent actual CPU MULSS/ADDSS operations in original order, including subnormal/NaN/infinity inputs. Original VM result retained.'],'limits':['Production planes/selectors producers, frame93F2F0 and ordinary graphical integration remain incomplete. Selector fixtures0..5 only; arbitrary out-of-bounds native loads not supported.','Default masked arithmetic mode only.']}
(r/'data/4.20/troy_visibility_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
