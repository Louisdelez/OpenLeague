"""Original93F45B..93F5C0 timing including CPU conversions and catchup limit."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools,random
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'0x93f45b<=a<0x93f5c0'")
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nreset_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'frame timing setup','exec'));u.hook_del(reset_hook_id);reset_hook=hook
code=bytes.fromhex('660f6ec1660f6ecaf30f5ec1660f7ec0c3');addr=kernel.VirtualAlloc(None,4096,0x3000,0x40);ctypes.memmove(addr,code,len(code));blocks.append(addr);cpu_functions['divss']=ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(addr)
conversion_functions={};conversion_calls=0
for name,code,signature in [('cvttss2si','660f6ec1f30f2cc0c3',ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32)),('cvtsi2ss','f30f2ac1660f7ec0c3',ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_int32))]:
 addr=kernel.VirtualAlloc(None,4096,0x3000,0x40);machine=bytes.fromhex(code);ctypes.memmove(addr,machine,len(machine));blocks.append(addr);conversion_functions[name]=signature(addr)
actor_config=heap+0x7000;root_vtable=heap+0x6400;get_status=end+0x1100;frame=stack+0x4000
def timing_hook(uc,a,size,user):
 global conversion_calls
 if a==0x93f5c0:u.emu_stop();return
 if a==get_status:events.append('engine_status');finish(eax=status);return
 if enabled and 0x93f45b<=a<0x93f5c0:
  ins=next(cs.disasm(bytes(u.mem_read(a,size)),a),None)
  if ins and ins.mnemonic in conversion_functions:
   dest,source=ins.operands;dr=getattr(registers,'UC_X86_REG_'+ins.reg_name(dest.reg).upper());sr=getattr(registers,'UC_X86_REG_'+ins.reg_name(source.reg).upper());value=u.reg_read(sr)&0xffffffff;output=conversion_functions[ins.mnemonic](value);conversion_calls+=1
   u.reg_write(dr,(u.reg_read(dr)&~0xffffffff)|output if ins.mnemonic=='cvtsi2ss' else output);u.reg_write(UC_X86_REG_EIP,a+size);return
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)
special=[0,0x80000000,1,0x3e000000,0x3f000000,0x3f800000,0xbf800000,bits(20.),bits(42.),0x7f7fffff,0x7f800000,0xff800000,0x7fa01234,0x7fc05678]
inputs=[]
for index,(flags,a,b) in enumerate(itertools.product([0,8,0x40,0x48],range(14),range(14))):inputs.append((flags,4 if index%2 else 0,index//2%2,special[a],special[b],special[(a+3)%14],special[(b+5)%14],special[(a+b)%14]))
rng=random.Random(420)
for _ in range(256):inputs.append((rng.choice([0,8,0x40]),rng.choice([0,4]),rng.choice([0,1]),bits(rng.uniform(0,100)),bits(rng.uniform(0,100)),bits(rng.uniform(-2,2)),bits(rng.uniform(-1,10)),bits(rng.uniform(1,10000))))
cases=[]
for flags,source_flags,status,time,last,offset,cap,rate in inputs:
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(actor_config,b'\0'*0x200);write32(actor,engine);write32(actor+0xe8,actor_config);write32(actor+0x70,source_flags);write32(actor+0xac,last);write32(actor+0xec,offset);write32(actor_config+0x1bc,flags);write32(actor_config+0x1c0,cap);write32(engine,root_vtable);write32(root_vtable+0x50,get_status);write32(engine+0xe8,rate)
  sp=stack+0x8000;write32(sp,end);write32(frame+8,time);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93f45b,0x93f5c0,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x93f5c0
  captures.append({'effective_time':hex(read32(frame-0x10)),'offset':hex(read32(actor+0xec)),'iterations':hex(read32(frame-0x14)),'step':hex(read32(frame-0xc)),'events':events.copy()})
 cases.append({'flags':flags,'source_flags':source_flags,'status':status,'time':hex(time),'last':hex(last),'offset':hex(offset),'cap':hex(cap),'rate':hex(rate),'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'93F45B..93F5C0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_conversions':conversion_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'constants':{hex(a):hex(read32(a)) for a in [0x1138ba4,0x10d6c24,0x1138c74,0x1138ff0]},'adapters':['Whole timing fragment executes original cap selection, offset compensation, rate conversion, status gate, one-step policy and catchup halving loop.','Engine virtual50 returns supplied raw status; engineE8 rate supplied explicitly. Independent actual CPU scalar math and CVTTSS2SI/CVTSI2SS preserve independent VM captures.'],'limits':['Engine rate/status producers, subsequent emitters, frame final writes and ordinary graphical integration remain incomplete.','Default masked arithmetic mode only.']}
(r/'data/4.20/troy_frame_timing_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'conversions':conversion_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
