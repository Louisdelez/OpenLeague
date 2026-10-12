from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
target=vector+0x10000;params=vector+0x11000;context=vector+0x12000;refobj=vector+0x13000;action=vector+0x14000;pool=vector+0x15000;lock=vector+0x16000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x12100f4,48000);allocs=[];frees=[];cursor=vector+0x19000
manager=vector+0x17000;registry=vector+0x18000;entry=vector+0x18f00;pair=vector+0x18e00
w(0x14a7a08,registry);w(0x14a7a28,manager);w(0x14a79e8,0)
vtable=vector+0x1e000;dispatch=vector+0x1f000;calls=[]
u.mem_write(vtable,bytes(0x140));w(vtable+8,0xb22070);w(vtable+0x13c,dispatch)
def hook(uc,a,size,user):
 global cursor
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  size=read(sp+8);assert size in [8,16,64,176];addr=action if size==176 else cursor;cursor+=256;u.mem_write(addr,bytes(size));allocs.append((size,addr));finish(addr)
 elif a==dispatch:
  p=read(sp+4);calls.append(dict(receiver=uc.reg_read(UC_X86_REG_ECX),mode=read(p),reference=read(p+4),delay=read(p+0x74),bypass=bytes(uc.mem_read(p+0x82,1))[0],copied=bytes(uc.mem_read(p+0x28,72)).hex()));finish(result,4)
 elif a==0xada3e0:frees.append(read(sp+8));finish(0)

u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for delay,has_context,result in itertools.product([.125,.5,1.,2.],[False,True],[1,2,15]):
 for addr,size in [(target,128),(params,176),(context,32),(refobj,176),(action,176),(pool,128)]:u.mem_write(addr,bytes(size))
 u.mem_write(manager,bytes(256));u.mem_write(registry,bytes(0xd00));u.mem_write(entry,bytes(12));u.mem_write(pair,bytes(8));w(context+8,pair);w(manager+0x4c,entry);w(manager+0x7c,100);cursor=vector+0x19000
 w(target,vtable);w(target+12,7);w(registry+0x18+77*4,target);calls.clear()
 w(target+8,77);w(params,9);w(params+4,refobj);w(refobj,0xff1c34);w(refobj+12,2);w(params+0x78,context if has_context else 0)
 payload=bytes((i*13)%256 for i in range(72));u.mem_write(params+0x28,payload);allocs.clear();frees.clear()
 w(stack,end);u.mem_write(stack+4,struct.pack('<fI',delay,params));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,target);u.emu_start(0xaf0500,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==1
 pending=read(entry+8);assert pending and read(pending+4)==action and read(action+12)==1
 assert read(pending+8)==100+(int(delay*48000)>>10) and read(pending+12)==int(delay*48000)%1024
 assert read(refobj+12)==3 and read(manager+0x44)==entry
 source=read(action+0x3c)
 if has_context:assert source==0
 else:assert source and read(source+12)==1
 assert len(frees)==(1 if has_context else 1)
 deadline=read(pending+8);before=list(frees)
 w(manager+0x7c,deadline-1)
 call(0xb07e50,manager)
 assert frees==before and read(manager+0x44)==entry and read(action+12)==1
 w(manager+0x7c,deadline)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb07e50,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(manager+0x44)==0 and read(manager+0x48)==0 and read(manager+0x58)==0 and read(manager+0x4c)==entry

 assert len(calls)==1 and calls[0]==dict(receiver=target,mode=9,reference=refobj,delay=int(delay*48000)%1024,bypass=0,copied=payload.hex())
 assert read(target+12)==7
 assert read(refobj+12)==2
 allocated=[a for size,a in allocs]
 assert sorted(frees)==sorted(allocated),(allocs,frees)
 assert len(frees)==len(set(frees))
 rows.append(dict(delay=delay,has_context=has_context,allocations=allocs.copy(),freed=frees.copy(),reference_count=read(refobj+12),dispatch_result=result,dispatch=calls.copy()))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual scheduling, due-time removal, target lookup, AF1C50 bypass consumption and B1F9B0 dispatch/cleanup compose fully around captured targetvirtual13C.','Correct mode/reference/72byte payload/remainder delivered once; target and external references restored; all allocations freed once for results1/2/15.'],adapters=['Target virtual13C captured, returns supplied1/2/15; target release uses actual B22070 with nonzero retained count.','Mapped allocator/free and lock imports; zero owner/association IDs; explicit manager clock.'],limits=['Target reader/sound generation is not executed: this verifies delivery and cleanup, not audible playback. Multiple dueitems and runtime integration remain open.'])
(r/'data/4.20/audio_deferred_present_target.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'present-target dispatch and cleanup sequences')
