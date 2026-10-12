from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_replay_stream_initialization.py').read_text().split('\ncases=[]')[0],'stream state prerequisites','exec'))
action_calls=[];event_calls=[];mutate_to=None;mutated=False
action_members={0x66a0ff,0x66a41d,0x5b5e90,0x669de0,0x66a138,0x66a470,0x5ecc60,0x669e50}
def trace_state_calls(uc,address,size,user):
 global mutated
 sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX)
 if address==0x5cce30:
  member=read32(obj+8);owner=read32(obj+4)
  if member in action_members:action_calls.append({'handler':obj,'member':member,'owner':owner,'args':[read32(sp+4),read32(sp+8)]})
  else:event_calls.append({'handler':obj,'member':member,'owner':owner,'event':read32(sp+4)})
 if address==end+0x8400:
  callbacks.append({'method':address,'object':obj,'args':[read32(sp+4),read32(sp+8)]})
  if mutate_to is not None and not mutated:write32(obj+4,mutate_to);mutated=True
  finish(pop=8)
u.hook_add(unicorn.UC_HOOK_CODE,trace_state_calls)
def machine_state():
 value=stream_state();value['action_calls']=list(action_calls);value['event_calls']=list(event_calls);action_calls.clear();event_calls.clear();return value
def build(fill,custom):
 global mutate_to,mutated
 reset(fill,custom);mutate_to=None;mutated=False;callbacks.clear();action_calls.clear();event_calls.clear()
 for off in range(8,40,4):write32(0x10d607c+off,0x56ff60)
 stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);machine=stream+0x40
 nodes=[read32(machine+off) for off in range(0x10,0x24,4)]
 # Borrowed hierarchies exercise unrelated roots and vector growth beyond depth3.
 foreign=heap+0xc000;deep=nodes[0]
 for index in range(9):
  node=foreign+index*32;parent=0 if index==0 else deep
  for off,val in [(0,read32(nodes[2])),(4,read32(nodes[2]+4)),(8,read32(nodes[3]+8)),(12,88+index),(16,parent)]:write32(node+off,val)
  if index:deep=node
 return stream,machine,nodes,foreign,deep
def close(stream):
 call(0x8f67c0,stream,[1]);result=machine_state();assert not live;return result
transitions=[]
for fill,custom,current,target in itertools.product([0,165],[False,True],[-1,0,1,2,3,4],[-1,0,1,2,3,4,5,6]):
 stream,machine,nodes,foreign,deep=build(fill,custom);initial=machine_state()
 before=0 if current==-1 else nodes[current];after=0 if target==-1 else foreign if target==5 else deep if target==6 else nodes[target]
 write32(machine+4,before);call(0x990bb0,machine,[after]);changed=machine_state();observed=read32(machine+4)
 transitions.append({'fill':fill,'custom':custom,'current':current,'target':target,'stream':stream,'nodes':nodes,'foreign':foreign,'deep':deep,'initial':initial,'after':changed,'current_after':observed,'destroyed':close(stream)})
sequences=[]
for fill,custom in itertools.product([0,165],[False,True]):
 stream,machine,nodes,foreign,deep=build(fill,custom);initial=machine_state()
 operations=[['event',255],['event',0],['event',1],['stop'],['stop'],['event',1],['event',256],['event',0xffffffff],['stop']]
 operations += [['event',value] for value in range(256)]
 operations += [['transition',1],['event',0x10000],['event',0],['event',1]]
 steps=[]
 for op in operations:
  if op[0]=='event':call(0x990dc0,machine,[op[1]])
  elif op[0]=='stop':call(0x8f6bc0,stream,[])
  else:call(0x990bb0,machine,[nodes[op[1]]])
  steps.append({'op':op,'current':read32(machine+4),'state':machine_state()})
 sequences.append({'fill':fill,'custom':custom,'stream':stream,'initial':initial,'nodes':nodes,'steps':steps,'destroyed':close(stream)})
mutations=[]
for fill,custom in itertools.product([0,165],[False,True]):
 stream,machine,nodes,foreign,deep=build(fill,custom);initial=machine_state()
 for off in range(8,40,4):write32(0x10d607c+off,end+0x8400)
 mutate_to=nodes[0];call(0x990bb0,machine,[nodes[4]]);assert mutated and read32(machine+4)==nodes[0];changed=machine_state()
 mutations.append({'fill':fill,'custom':custom,'stream':stream,'nodes':nodes,'initial':initial,'after':changed,'destroyed':close(stream)})
proof={'passed':True,'complete':False,'native_sha256':digest,'transitions':transitions,'sequences':sequences,'mutations':mutations,'limits':[
 'Actual990BB0/990DC0,994520/5C2930 pointer vectors,5CCE30 member callbacks, native state thunks and8F6BC0 stop execute.192 direct transitions include null/current/root/leaf/same/unrelated/deep targets, four sequences cover every event byte and high bits, and four supplied virtual-action callbacks mutate current state after publication to verify fresh callback arguments.',
 'State-pointer selections and borrowed deep/unrelated hierarchies are explicit valid storage preconditions. For mutation cases only the terminal virtual action is supplied; actual transition logic, allocations and member dispatch execute unchanged. All normal cases execute original no-op56FF60 actions. Live allocated words, callback order and allocation/free traces are captured.',
 'Stream implementation remains null and base stopped flag remains1. Worker threads, stream I/O, native concurrency, allocator callback mutation, exceptions and OOM/unwind are outside this contract. Existing mutex and OS/memory primitives remain supplied boundaries.'
]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'direct_transitions':len(transitions),'event_sequences':len(sequences),'sequence_operations':sum(len(c['steps']) for c in sequences),'mutation_transitions':len(mutations)}))
