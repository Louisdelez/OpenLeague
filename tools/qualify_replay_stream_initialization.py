from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague');source=(r/'tools/qualify_replay_stream_ownership.py').read_text()
exec(compile(source.split('\nmoves=[]')[0]+source.split('observing_pairs=False;fail=False')[1].split('\nlifetimes=[]')[0],'stream lifecycle native prerequisites','exec'))
observing_pairs=False;fail=False;callbacks=[]
def observe_stream(uc,address,size,user):
 if address==0x56ff60:
  sp=u.reg_read(UC_X86_REG_ESP)
  callbacks.append({'method':address,'object':u.reg_read(UC_X86_REG_ECX),'args':[read32(sp+4),read32(sp+8)]})
u.hook_add(unicorn.UC_HOOK_CODE,observe_stream)
def stream_state():
 result=snapshot();result['callbacks']=list(callbacks);callbacks.clear();return result
cases=[]
for fill,flags,custom,populated in itertools.product([0,165],[0,1,256,257],[False,True],[False,True]):
 reset(fill,custom);callbacks.clear();stream=call(0x9933e0,0,[120]);assert call(0x8f6700,stream,[])==stream
 initial=stream_state();assert len(live)==19
 fields={'vtable':read32(stream),'machine_vtable':read32(stream+0x40),'current':read32(stream+0x44),'state_nodes':[read32(stream+off) for off in range(0x50,0x64,4)],'object_pair':pair_words(stream+0x6c),'implementation_pair':pair_words(stream+0x64)}
 assert fields['object_pair']==fields['implementation_pair']==[0,0]
 if populated:
  obj=new_manager(6);call(0x9019a0,incoming,[obj]);call(0x5bd4e0,stream+0x6c,[incoming])
 attached=stream_state();result=call(0x8f67c0,stream,[flags]);assert result==stream
 destroyed=stream_state();assert len(live)==(0 if flags&1 else 1)
 if not flags&1:assert list(live)==[stream];call(0xc98528,0,[stream])
 final=stream_state();assert not live
 cases.append({'fill':fill,'flags':flags,'custom':custom,'populated_object_manager':populated,'stream':stream,'fields':fields,'initial':initial,'attached':attached,'result':result,'destroyed':destroyed,'caller_cleanup':final})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':[
 'Actual8F6700/8FB3C0/8FB9A0 constructors and8F67C0/8F6800/8FB920/8FB490 destructors run, including five hierarchical state nodes,13 retained cloned callbacks, initial state entry, original allocation classes, shared object-manager disposal and scalar flag behavior. Complete live allocated bytes and ordered allocation/free traces are captured.',
 'Each stream starts with empty implementation and object-manager pairs. Populated object-manager cases are explicit owned-pair attachment preconditions using actual9019A0/5BD4E0 and8F8810 with six native packet objects; they do not claim stream opening or event delivery. All cases keep initialized state1 and no running thread.',
 'Existing engine mutex9941B0/994210 and Windows critical-section/memory primitives are supplied boundaries. Threads, stream I/O, state transitions, exceptions and allocation failures are not qualified. Native no-op56FF60 entry callback executes and is observed, not replaced.'
]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'stream_lifetimes':len(cases),'initial_retained_allocations':19,'state_nodes':5,'retained_callbacks':13}))
