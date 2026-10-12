from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;source=vector+0x11000;reference=vector+0x12000;alloc=True;calls=[]
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+8)==0xb0;calls.append('allocate176');finish(action if alloc else 0)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for alloc,present,fill in itertools.product([False,True],[False,True],[0,0xcc]):
 u.mem_write(action,bytes([fill])*0xb0);u.mem_write(source,bytes(0x20));w(source+0xc,2);w(reference,source if present else 0);calls.clear()
 w(stack,end);u.mem_write(stack+4,struct.pack('<III',0x503,0,reference));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0)
 u.emu_start(0xb1f960,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);assert result==(action if alloc else 0)
 assert read(source+0xc)==2+int(alloc and present)
 if alloc:
  assert read(action)==0xff1c34 and read(action+0x3c)==(source if present else 0)
  assert struct.unpack('<H',u.mem_read(action+0x20,2))[0]==0x503
  assert read(action+0x24)==0xffffffff and read(action+0x9c)==1
 rows.append(dict(allocated=alloc,source_present=present,initial_fill=fill,result_present=bool(result),source_refs=read(source+0xc),storage=bytes(u.mem_read(action,0xb0)).hex(),calls=list(calls)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,case_count=len(rows),findings=['OriginalB1F960 allocates176bytes and executes B1F610/B2D180/B21BB0/AFD490 constructors and B21CF0 registration branch.','Action type503,id0: hash registration skipped; present source retained once by nativeB1D0F0. Allocation failure returnsnull without retaining source.'],adapters=['Allocator supplies mapped storage or null; source reference supplied. Action id0 matches observed derived duration callers.'],limits=['No action execution/destruction or scheduling proof; bytes not initialized by constructor preserved in capture. No audible output.'])
(r/'data/4.20/audio_duration_action_factory_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'native duration action factory cases')
