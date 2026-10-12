"""93FB10 and actual6890C0 native attribute lookup, no endpoint adapters."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'native system attribute lookup setup','exec'))
system=heap+0x23000;head=heap+0x31000;buckets=heap+0x32000;nodes=heap+0x33000;stub=heap+0x50000;response=heap+0x51000
# Real x87 return is stored by explicit caller stub after the whole native body.
u.mem_write(stub,b'\xd9\x1d'+struct.pack('<I',response)+b'\xe9'+struct.pack('<i',end-(stub+11)))
keys=[7,42,0x80000001,0xffffffff];queries=[0,6,7,8,42,43,0x7fffffff,0x80000000,0x80000001,0xfffffffe,0xffffffff]
profiles=[[0.,1.,2.,3.],[-0.,-1.,-2.,-3.],[.125,.5,1.5,1000.],[1e-20,1e20,-1e-20,-1e20]]
cases=[]
for count,query,profile in itertools.product([0,1,4],queries,profiles):
 captures=[];entries=[[key,bits(v)] for key,v in zip(keys[:count],profile)]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(system,b'\0'*0x400);u.mem_write(head,b'\0'*0x20)
  attribute_map=system+0x1b8;write32(attribute_map+4,head);write32(attribute_map+0xc,buckets);write32(attribute_map+0x18,0);write32(attribute_map+0x1c,1)
  addresses=[nodes+j*0x20 for j in range(count)]
  write32(head,addresses[0] if count else head);write32(head+4,addresses[-1] if count else head)
  write32(buckets,addresses[0] if count else head);write32(buckets+4,addresses[-1] if count else head)
  for j,(key,value) in enumerate(entries):
   a=addresses[j];write32(a,addresses[j+1] if j+1<count else head);write32(a+4,addresses[j-1] if j else head);write32(a+8,key);write32(a+0xc,value)
  sp=stack+0x8000;write32(sp,stub);write32(sp+4,query);write32(sp+8,0);write32(response,0xdeadbeef)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,system);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93fb10,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+12
  captures.append(dict(value=read32(response)))
 cases.append(dict(entries=entries,key=query,emulator=captures[0],cpu=captures[1]))
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='93FB10/6890C0',cases=cases,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=[],limits=['Whole native lookup with prepared valid one-bucket ordered linked containers and real key hashing/division. Supplied0/1/4entries, present/missing unsigned keys, finite values including signed zero, real x87 return stored through caller stub.','Native insertion/rehash/allocator, source attribute population, nonfinite values and whole emission attribute augmentation remain unqualified. No ordinary graphics/audio acceptance.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/particle_attributes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
