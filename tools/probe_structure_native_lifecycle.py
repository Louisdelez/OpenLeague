from pathlib import Path
import json,struct,math,datetime,hashlib
# Reuse only the standalone PE/Unicorn initialization, with no API substitutions.
exec(Path('E:/mapslol3v3/probe_native_structure_clip_periods.py').read_text().split('sources=[]')[0])
root=Path('E:/OpenLeague')
contract=json.loads((root/'data/4.20/structure_clip_period_contract.json').read_text())
runtime=terrain+0x3000; node=terrain+0x1000
def invalid(uc,access,address,size,value,user):
 print('unmapped',hex(uc.reg_read(UC_X86_REG_EIP)),hex(address),size,flush=True);return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
u.mem_map(0,0x1000);write32(0,0xffffffff) # isolated x86 SEH head, FS base zero
u.mem_map(0x50000000,0x10000);allocation=0x50000000;allocations=[]
def allocate(uc,address,size,user):
 global allocation
 if address!=0x9933e0:return
 esp=uc.reg_read(UC_X86_REG_ESP);count=read32(esp+4);assert count in [8,16],count
 pointer=allocation;allocation+=16;assert allocation<0x50010000
 u.mem_write(pointer,bytes(16));allocations.append(dict(bytes=count,pointer=pointer))
 uc.reg_write(UC_X86_REG_EAX,pointer);uc.reg_write(UC_X86_REG_EIP,read32(esp));uc.reg_write(UC_X86_REG_ESP,esp+4)
u.hook_add(unicorn.UC_HOOK_CODE,allocate)
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def getf(a):return struct.unpack('<f',u.mem_read(a,4))[0]
def call(entry,args=()):
 write32(sp,end)
 for i,v in enumerate(args):write32(sp+4+4*i,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,runtime)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==end,hex(u.reg_read(UC_X86_REG_EIP))
 return u.reg_read(UC_X86_REG_EAX)&255
records=[]
for model in contract['models']:
 raw=Path(model['blend']).read_bytes();assert hashlib.sha256(raw).hexdigest()==model['blend_sha256']
 assert len(raw)<0x2000
 u.mem_write(node,raw)
 for state in model['states']:
  cases=[];ptr=node+state['node_offset'];flags=read32(ptr+4)
  assert state['event_reference_raw']==0
  period=state['native_period_seconds']
  extended_period=(state['frame_end']-state['frame_start'])*state['time_step']
  for stopped in [False,True]:
   for continuation in [0,2]:
    for factor in [0.,.5,1.,1.25,2.5]:
     u.mem_write(runtime,bytes(0x80))
     # Execute the full original base constructor, including its weak-reference initializer.
     call(0x889330,(0,ptr))
     assert read32(runtime+0x20)==ptr and getf(runtime+0x10)==1.
     # Bind the simple-node vtable and atomic payload as its derived constructor does.
     write32(runtime,0x10c8918);write32(runtime+0x2c,node+state['payload_offset'])
     write32(runtime+0x14,continuation)
     if stopped:call(0x8894a0)
     loops=bool(call(0x8894b0));assert loops==bool(flags&2 and not stopped)
     dt=f32(period*factor)
     result=bool(call(0x889180,(struct.unpack('<I',struct.pack('<f',dt))[0],)))
     elapsed=getf(runtime+0xc)
     reached=dt>=extended_period
     expected=f32(math.fmod(dt,extended_period)) if loops and reached else (period if reached else dt)
     assert abs(elapsed-expected)<2e-6,(model['model'],state['name'],factor,elapsed,expected)
     assert result==(not reached or loops or bool(continuation&2)),(result,model['model'],state['name'],factor)
     cases.append(dict(stop_requested=stopped,continuation_flags=continuation,delta_bits=struct.unpack('<I',struct.pack('<f',dt))[0],loop=loops,continue_update=result,elapsed_bits=read32(runtime+0xc)))
  records.append(dict(model=model['model'],state=state['name'],serialized_flags=flags,loop=bool(flags&2),native_period_bits=state['native_period_bits'],cases=cases))
 print(model['model'],flush=True)
report=dict(passed=True,complete=False,updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,constructor_entry='0x889330',loop_entry='0x8894b0',stop_entry='0x8894a0',update_entry='0x889180',native_addresses=len(visited),allocator_boundary=dict(entry='0x9933e0',calls=len(allocations),bytes_per_call=8,adapter='Zeroed isolated emulator heap blocks; native allocator not executed.'),states=records,limits=['Base constructor, native weak reference initialization, loop getter, stop setter and full simple-node update executed on 48 actual serialized states, 960 timing/stop/continuation cases.','Allocator boundary replaced with isolated emulator allocations. Derived vtable and atomic pointer supplied by adapter; full derived constructor, resource loader and state selector not executed.','All actual payloads have no event callback reference. Nonzero continuation flags and stop requests are explicit diagnostic cases; their engine callers remain unqualified.','Native pose interpolation and general blend/state transitions remain open.'])
Path('E:/mapslol3v3/structure_native_lifecycle_contract.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(passed=True,states=len(records),cases=sum(len(s['cases']) for s in records),loop_states=sum(s['loop'] for s in records),native_addresses=len(visited))))
