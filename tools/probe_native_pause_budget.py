from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock_pause.py').read_text().split('\nrows=[]')[0],'setup','exec'))
notification=vector+0xd000;events=[]
def notify(uc,address,size,user):
 if address==notification:
  events.append(read(u.reg_read(UC_X86_REG_ESP)+4));finish(0)
u.hook_add(unicorn.UC_HOOK_CODE,notify)
rows=[]
for paused,limit,used,adjustment,excluded in itertools.product([False,True],[0.,1.,2.],[0.,1.],[-.125,0.,.125],[0.,.25]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);u.mem_write(obj+0x10,struct.pack('<d',0. if paused else 1.))
 u.mem_write(controller,b'\0'*0x50);w(controller,0x10deac4);w(controller+4,obj);w(controller+8,notification);u.mem_write(controller+0x15,bytes([int(paused)]))
 for off,value in [(0x28,1.),(0x2c,limit),(0x30,used),(0x34,adjustment),(0x38,excluded)]:u.mem_write(controller+off,struct.pack('<f',value))
 counter=15000000;calls=0;events.clear();call(0x99c990,controller,struct.pack('<I',0x12345678))
 accepted=bool(u.reg_read(UC_X86_REG_EAX)&255)
 assert events==([0x12345678] if accepted else []);assert (u.mem_read(controller+0x17,1)[0]==0x78)==accepted
 rows.append(dict(paused=paused,limit=limit,used=used,adjustment=adjustment,excluded=excluded,counter=counter,pause_start=1.,accepted=accepted,notification=list(events),qpc_calls=calls,paused_after=u.mem_read(controller+0x15,1)[0]))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),function='0x99c990',cases=rows,limits=['Budget gate and accepted-request notification only; callers determine tournament authorization separately.','QPC deterministic; controller initialization supplied.','Input marker notification retains full32bits while stored marker is low8bits.'])
(r/'data/4.20/game_clock_pause_budget_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(rows),accepted=sum(x['accepted'] for x in rows))))
