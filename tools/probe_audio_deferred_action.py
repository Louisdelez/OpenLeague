from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
target=vector+0x10000;params=vector+0x11000;context=vector+0x12000;refobj=vector+0x13000;action=vector+0x14000;pool=vector+0x15000;lock=vector+0x16000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x12100f4,48000);allocs=[];frees=[]
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  size=read(sp+8);assert size in [16,176];addr=action if size==176 else pool+len(allocs)*32;allocs.append((size,addr));finish(addr)
 elif a==0xada3e0:frees.append(read(sp+8));finish(0)
 elif a==0xaf0270:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for delay,has_context in itertools.product([.125,.5,1.,2.],[False,True]):
 for addr,size in [(target,128),(params,176),(context,32),(refobj,176),(action,176),(pool,128)]:u.mem_write(addr,bytes(size))
 w(target+8,77);w(params,9);w(params+4,refobj);w(refobj,0xff1c34);w(refobj+12,2);w(params+0x78,context if has_context else 0)
 payload=bytes((i*13)%256 for i in range(72));u.mem_write(params+0x28,payload);allocs.clear();frees.clear()
 w(stack,end);u.mem_write(stack+4,struct.pack('<fI',delay,params));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,target);u.emu_start(0xaf0500,end,count=3000)
 assert u.reg_read(UC_X86_REG_EIP)==0xaf0270
 sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+8)==params and read(sp+12)==int(delay*48000) and read(sp+16)==action
 assert read(action)==0xff1c34 and read(action+0x1c)==77 and read(action+0xa4)==refobj and read(refobj+12)==3
 assert bytes(u.mem_read(action+0x40,72))==payload and bytes(u.mem_read(action+0x9a,1))==b'\1' and read(action+0x9c)==9
 assert [s for s,a in allocs]==([16,176] if has_context else [16,16,176])
 assert frees==([] if has_context else [pool])
 rows.append(dict(delay=delay,has_context=has_context,allocations=allocs.copy(),freed=frees.copy(),converted_delay=read(sp+12)))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual AF0500 allocates source context, AF01E0/B1F960 construct action503 and copy parameters; AF2500 converts delay.','B1FC80 actual retained reference; no-context path releases first temporary source before replacement.'],adapters=['Allocator/free mapped buffers; lock imports ret4. Supplied reference object uses action vtable for retain.','Stop before AF0270 scheduling; optional context supplied empty.'],limits=['Allocation failures and subsequent scheduling/cleanup not covered; no output audio proof.'])
(r/'data/4.20/audio_deferred_action.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'deferred action compositions')
