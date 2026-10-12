"""Compose actual loading providers and dual index; no resolver-result adapter."""
from pathlib import Path
import sys,json,hashlib,itertools
ROOT=Path('E:/OpenLeague');OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
exec(compile((ROOT/'tools/probe_replay_metadata.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'existing metadata native prerequisites','exec'))
recorded=[];executed=set()
def observe_resolver(uc,pc,size,user):
 executed.add(pc)
 if pc in [0x729ec0,0x729730,0x8f8cf0]:
  recorded.append({'method':pc,'this':u.reg_read(UC_X86_REG_ECX),'key':read32(u.reg_read(UC_X86_REG_ESP)+4)})
u.hook_add(unicorn.UC_HOOK_CODE,observe_resolver)
cases=[]
for fill in [0,165]:
 poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear();recorded.clear()
 write32(0x14bef40,0);write32(0x14bef58,0)
 parent=call(0x9933e0,0,[68]);call(0x728e20,parent,[]);write32(0x2d78520,parent);assert call(0x728fd0,parent,[])&255==1
 nested=read32(parent+0x30);index=call(0x9933e0,0,[48]);call(0x8f8810,index,[])
 # Real source manager allocation/constructor/control installation. This explicit
 # setup does not claim the unexecuted normal stream-opening producer8F68D0.
 call(0x9019a0,nested+0x6c,[index]);index_control=read32(nested+0x70);metadata=read32(parent+0x34);metadata_control=read32(parent+0x38)
 packet=heap+0xc000;string=heap+0xd000;rawtext=heap+0xe000;output=heap+0xf000
 u.mem_write(string,bytes([fill])*24);write32(string+20,15);write32(string+16,0);u.mem_write(string,b'\0')
 entries=[(73,0xdeadbeef,0x80000000,b'Original loading name longer than fifteen bytes',0x12345678),(74,1,0xffffffff,b'second',0x80000000),(0xffffffff,0xffffffff,0x7fffffff,b'unsigned-key/signed-index',0xffffffff),(0,0,0,b'',7)]
 for identifier,low,high,name,extra in entries:
  u.mem_write(packet,bytes([fill])*16);u.mem_write(packet,b'\0');write32(packet+4,identifier);write32(packet+8,low);write32(packet+12,high)
  assert call(0x72c780,0,[0,0,0,0,packet])&255==1
  u.mem_write(rawtext,name+b'\0');call(0x564c20,string,[rawtext,len(name)]);call(0x7285b0,metadata,[low,high,string,extra])
 call(0x564900,string,[]);initial=capture();recorded.clear();steps=[]
 lookup={identifier:(low|(high<<32),name,extra) for identifier,low,high,name,extra in entries}
 for identifier in [73,74,0xffffffff,9000,0,73,0xfffffffe,74]:
  expected=lookup.get(identifier,(0,b'',0));before_counts=[read32(index_control+4),read32(metadata_control+4)]
  result=call(0x729ec0,metadata,[identifier]);high=u.reg_read(UC_X86_REG_EDX);resolved=result|(high<<32)
  assert resolved==expected[0],(identifier,resolved,expected)
  returned=call(0x72ad90,0,[output,identifier]);assert returned==output
  length=read32(output+16);text=read32(output) if read32(output+20)>=16 else output;name=bytes(u.mem_read(text,length))
  # The source lookup's missing result is0, so a zero-key metadata row is a real
  # match even for absent packet identifiers. This observable alias is retained.
  wanted=expected if identifier in lookup else lookup[0]
  assert name==wanted[1],(identifier,name,wanted)
  extra=call(0x72ae40,0,[identifier]);assert extra==wanted[2]
  call(0x564900,output,[])
  after_counts=[read32(index_control+4),read32(metadata_control+4)];assert before_counts==after_counts==[1,1]
  steps.append({'identifier':identifier,'resolved':resolved,'name_hex':name.hex(),'extra':extra,'before_counts':before_counts,'after_counts':after_counts,'calls':list(recorded),'state':capture()});recorded.clear()
 call(0x728ea0,parent,[1]);shutdown=capture();assert not live,live
 cases.append({'fill':fill,'parent':parent,'nested':nested,'index':index,'index_control':index_control,'metadata':metadata,'metadata_control':metadata_control,'entries':[{'id':i,'low':lo,'high':hi,'name_hex':name.hex(),'extra':extra} for i,lo,hi,name,extra in entries],'initial':initial,'steps':steps,'shutdown':shutdown})
regions=[]
for label,address,size in [('metadata_resolver',0x729ec0,0x27),('parent_resolver',0x729730,0xa4),('nested_pair',0x738ac0,0x32),('object_lookup',0x8f8cf0,0x111),('manager_control_factory',0x9019a0,0xb3),('packet_command',0x72c780,0x277)]:
 data=bytes(img[address-0x400000:address-0x400000+size]);regions.append({'label':label,'address':address,'size':size,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
assert all(p in executed for p in [0x729ec0,0x729730,0x8f8cf0,0x72ad90,0x72ae40,0x728410,0x728500,0x72c780,0x7285b0,0x9019a0,0x901b40])
proof={'passed':True,'complete':False,'native_sha256':digest,'native_resolver_executed':True,'resolver_result_boundary':False,'cases':cases,'source_regions':regions,'executed_instruction_addresses':sorted(executed),'limits':['Actual729EC0,729730,738AC0 and8F8CF0 execute beneath actual72AD90/72AE40 and metadata getters728410/728500. Native72C780 creates packet objects/index entries and7285B0 creates names/extras; no resolver or metadata return is fabricated.','Parent and metadata are actual728E20/728FD0 initialization. Index creation8F8810 and publication9019A0 are explicitly supplied source setup, not evidence of normal8F68D0 stream opening. Full728EA0 parent/stream/index/metadata destruction releases all owned allocations.','Existing allocator/memcpy and single-thread Win32/lock primitives are supplied. No active networking, loading UI, replay decoder or simulation integration is claimed.','Missing identifier returns0 from native object lookup. If metadata contains key64 zero, names/extras for a missing identifier resolve to that actual row; this is original behavior, not invented absent-key filtering.']}
(OUT/'loading_resolver_composition_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'direct_resolver_calls':sum(len(c['steps']) for c in cases),'composed_provider_calls':sum(len(c['steps'])*2 for c in cases),'actual_object_lookup_calls':sum(sum(len([a for a in s['calls'] if a['method']==0x8f8cf0]) for s in c['steps']) for c in cases),'all_owned_allocations_released':True}))
