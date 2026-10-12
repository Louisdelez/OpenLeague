from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_replay_stream_ownership.py').read_text().split('\nmoves=[]')[0],'copy assignment prerequisites','exec'))
cases=[]
try:
 for strong,weak,new,old,alias,mutation in itertools.product([0,1,2,0xffffffff],[0,1,2],[0,first_control],[0,first_control,second_control],[False,True],range(4)):
  setup(strong,weak);write32(destination,0x1234);write32(destination+4,old);write32(source_pair,0x87654321);write32(source_pair+4,new)
  src=destination if alias else source_pair;before=words();result=call(0x5bd470,destination,[src]);assert result==destination
  cases.append({'strong':strong,'weak':weak,'new':new,'old':old,'alias':alias,'mutation':mutation,'source':src,'before':before,'result':result,'after':words(),'events':list(events)})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Actual5BD470 copy assignment calls actual5CC070 into a fresh temporary, publishes both destination fields, then decrements/disposes the old control.576 cases cover null/shared/distinct controls, self-assignment, counter boundaries and callbacks mutating source/destination.','Disposal callbacks are explicit supplied observation/mutation stubs. No concrete stream, packet or host lifetime is integrated by this probe. Rust5CC070 copy releases its destination before publishing;5BD470 is a distinct required operation and must not be silently replaced by that copy helper.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP))}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
