from pathlib import Path
import itertools,json
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'logger prerequisites','exec'))
registrations=[]
def observe_registration(uc,pc,size,user):
 # Observe the caller before the existing c97e4c boundary consumes its stack.
 if pc==0x901aa9:registrations.append(read32(u.reg_read(UC_X86_REG_ESP)))
u.hook_add(unicorn.UC_HOOK_CODE,observe_registration)
cases=[]
for poison,flag1,flag2,replace in itertools.product([0,165],[0,1],[0,1],[False,True]):
 write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,bytes([flag1,flag2]));u.mem_write(0x2d78ed0,bytes([poison])*36)
 snapshot();before=set(live);registrations.clear();steps=[]
 for action in ['initialize','initialize_again']+(['replace_callback'] if replace else [])+['shutdown','reinitialize','shutdown_again']:
  if action in ['initialize','initialize_again','reinitialize']:call(0x901a70,0,[])
  elif action=='replace_callback':call(0x8f9000,0x2d78ed0,[])
  else:call(0x901c00,0,[])
  steps.append({'action':action,'state':snapshot(),'logger_words':[read32(0x2d78ed0+i*4) for i in range(9)],'logger_pointer':read32(0x2d78ec4),'flags':list(u.mem_read(0x2d78ec1,2)),'shutdown_registrations':list(registrations)})
 assert set(live)==before
 assert registrations==([0x901c00] if flag1==flag2==0 else [])
 cases.append({'fill':poison,'initial_flags':[flag1,flag2],'replace_callback':replace,'steps':steps})
default=bytes(u.mem_read(0x573fa0,5));assert default==bytes.fromhex('b001c20400')
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'default_callback':{'address':0x573fa0,'bytes':default.hex(),'behavior':'mov al,1; ret4. No output or side effect; caller ignores the callback result.'},'limits':['16 original901A70/901B80/8F9000/901C00 logger lifetimes, including repeated initialization, optional callback replacement, destruction/reinitialization and both flags, execute with fill0/A5. Every lifetime restores allocations.','The logger default callback573FA0 is an actual no-op returning low-byte1. Do not invent output behavior for this method. Other registered callbacks and8F92B0 timestamp/static-buffer formatting are not qualified here.','Windows critical sections, allocator routing and shutdown registration use the existing supplied platform boundaries. Native callback clone/delete and parent initialization/destruction execute.']}
Path('E:/mapslol3v3/replay_logger_lifetime_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'default_callback':proof['default_callback']}))
