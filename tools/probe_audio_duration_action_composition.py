from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
node=vector+0x6000;action=vector+0x10000;pending=vector+0x11000;source=vector+0x12000;owner=vector+0x13000;allocations=[]
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);size=read(sp+8);assert size in [176,64];allocations.append(size);finish(action if size==176 else pending)
 if a==0xb2a4df:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for state,value,owner_present,fill in itertools.product([1,2,5],[50.,100.,1000.],[False,True],[0,0xcc]):
 u.mem_write(node,bytes(0x240));u.mem_write(action,bytes([fill])*176);u.mem_write(pending,bytes([fill])*64);u.mem_write(source,bytes(0x20));u.mem_write(owner,bytes(0x80));w(source+12,2);w(owner+0x60,0xc0000002)
 w(node,0xff27d4);w(node+0x200,state);w(node+0x1fc,1);w(node+0x1a8,source);w(node+0x68,owner if owner_present else 0);u.mem_write(node+0x204,b'\4');allocations.clear()
 w(stack,end);u.mem_write(stack+4,struct.pack('<f',value));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node)
 u.emu_start(0xb2a430,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==0xb2a4df
 assert allocations==[176,64];assert read(action)==0xff1c34 and read(action+0x3c)==source and read(source+12)==3
 assert read(pending)==0xff14f0 and read(pending+0x38)==(owner if owner_present else 0)
 assert read(owner+0x60)==0xc0000002+int(owner_present)
 rows.append(dict(state=state,milliseconds=value,owner_present=owner_present,initial_fill=fill,allocations=list(allocations),source_refs=read(source+12),owner_ref_flags=read(owner+0x60),action_bytes=bytes(u.mem_read(action,176)).hex(),pending_bytes=bytes(u.mem_read(pending,64)).hex()))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['ActualB2A430 gate,virtual44earlyreturn,B1F960 and all action constructors composed with actualB057B0 pending-object constructor.','Allocator calls ordered176then64; source reference retained; pending owner low30-bit count increments preserving high flags.'],adapters=['Allocator supplies two mapped buffers. Node204bit4 bypasses populated refresh.','Stop atB2A4DF before action parameter transfer and scheduling; source/owner objects supplied.'],limits=['Only successful allocations and finite admitted durations; later cleanup/scheduling not executed. No audible playback proof.'])
(r/'data/4.20/audio_duration_action_composition.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'composed derived action/pending construction cases')
