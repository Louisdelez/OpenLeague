from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
target=vector+0x10000;params=vector+0x11000;context=vector+0x12000;refobj=vector+0x13000;action=vector+0x14000;pool=vector+0x15000;lock=vector+0x16000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x12100f4,48000);allocs=[];frees=[];cursor=vector+0x19000
manager=vector+0x17000;registry=vector+0x18000;entry=vector+0x18f00;pair=vector+0x18e00
w(0x14a7a08,registry);w(0x14a7a28,manager);w(0x14a79e8,0)
def hook(uc,a,size,user):
 global cursor
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  size=read(sp+8);assert size in [8,16,64,176];addr=action if size==176 else cursor;cursor+=256;u.mem_write(addr,bytes(size));allocs.append((size,addr));finish(addr)
 elif a==0xada3e0:frees.append(read(sp+8));finish(0)

u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for delay,has_context in itertools.product([.125,.5,1.,2.],[False,True]):
 for addr,size in [(target,128),(params,176),(context,32),(refobj,176),(action,176),(pool,128)]:u.mem_write(addr,bytes(size))
 u.mem_write(manager,bytes(256));u.mem_write(registry,bytes(0xd00));u.mem_write(entry,bytes(12));u.mem_write(pair,bytes(8));w(context+8,pair);w(manager+0x4c,entry);w(manager+0x7c,100);cursor=vector+0x19000
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
 rows.append(dict(delay=delay,has_context=has_context,allocations=allocs.copy(),freed=frees.copy(),action_refs=read(action+12),source_refs=read(source+12) if source else None,target=read(pending+8),remainder=read(pending+12)))

proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Full AF0500 returns1 through actual construction, property allocation, AF0270 and B05F00/B06140 scheduling, then native action release and temporary source release.','Queued action retains one reference after caller release; source context remains retained by action when constructed locally.'],adapters=['Mapped allocator/free and single-thread lock imports only; supplied zero-ID context and empty queue.'],limits=['Queued action not yet executed or destroyed; RTPC/randomization and nonzero owner associations remain open. No audible output proof.'])
(r/'data/4.20/audio_deferred_end_to_end.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'complete deferred scheduling calls')
