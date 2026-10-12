"""Original PE loading record maps: constructors, insertion/RB and tree dtor.
Only allocator/free primitives are supplied. No tree/record method is hooked.
"""
from pathlib import Path
import sys,struct,json,hashlib,itertools,random
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn,capstone
from unicorn.x86_const import *
OUT=Path(__file__).resolve().parent
EXE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=EXE.read_bytes();sha=hashlib.sha256(raw).hexdigest();assert sha=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
H=0x30000000;STACK=0x31000000;END=0x32000000;ARENA=0x38000000
for a,n in [(0,0x10000),(H,0x10000),(STACK,0x10000),(END,0x10000),(ARENA,0x200000)]:u.mem_map(a,n)
TREE=H+0x100;KEY=H+0x200;OUTPUT=H+0x300;CUSTOM_A=END+0x1000;CUSTOM_B=END+0x2000
ENTRY={'standard':0x5be170,'tutorial':0x5be1f0};CTOR={'standard':(0x57ce5c,0x57ce72,0x1c),'tutorial':(0x5b2bf5,0x5b2c0b,4)}
DTOR={'standard':0x57d1e0,'tutorial':0x5b3090};CLEAR={'standard':0x5c36b0,'tutorial':0x5c3770}
SIZE={'standard':140,'tutorial':96};MAX={'standard':0x1d41d40,'tutorial':0x2aaaaa9}
SPECS=[('standard_lookup',0x5be170,0x77),('tutorial_lookup',0x5be1f0,0x7b),('standard_value',0x576000,0x6d),('tutorial_pair',0x5e3da0,0x5f),('standard_allocate',0x5d5730,0x3a),('tutorial_allocate',0x5d57b0,0x37),('standard_node',0x5d32b0,0x30),('tutorial_node',0x5d34f0,0x3b),('standard_hint',0x5d32e0,0x208),('tutorial_hint',0x5d3530,0x208),('standard_insert',0x5db270,0x1c6),('tutorial_insert',0x5db550,0x1bd),('standard_fallback',0x5db440,0x103),('tutorial_fallback',0x5db710,0x130),('predecessor',0x5ccfe0,0x5e),('successor',0x5c23e0,0x4f),('left_rotation',0x5c64e0,0x60),('right_rotation',0x5c6540,0x58),('standard_pending_delete',0x5d56f0,0x3d),('tutorial_pending_delete',0x5d5770,0x35),('string_destroy',0x564900,0x50),('standard_sentinel',0x5c75c0,0x30),('tutorial_sentinel',0x5c75f0,0x30),('standard_clear_range',0x5c36b0,0x46),('tutorial_clear_range',0x5c3770,0x46),('standard_clear_nodes',0x5c6c10,0xe6),('tutorial_clear_nodes',0x5c6d00,0x9d),('standard_destroy',0x57d1e0,0x3f),('tutorial_destroy',0x5b3090,0x3f),('standard_header_snippet',0x57ce5c,0x16),('tutorial_header_snippet',0x5b2bf5,0x16)]
allowed=[(a,a+n) for _,a,n in SPECS]
active=False;fill=0;cursor=ARENA;live={};events=[];writes=[];helpers=[];seen=set();mutate_key=None;null_next=False;switch_free=False;kind='standard'
HELPERS={a for _,a,_ in SPECS}|{0x5db315,0x5db335,0x5db386,0x5db3a0,0x5db3bf,0x5db5ec,0x5db60c,0x5db65d,0x5db677,0x5db696}
def rd(p):return int.from_bytes(u.mem_read(p,4),'little')
def wr(p,v):u.mem_write(p,struct.pack('<I',v&0xffffffff))
def ret(value=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,rd(sp))
def alloc(n):
 global cursor
 p=cursor;cursor+=(n+15)&~15;assert cursor<ARENA+0x200000;u.mem_write(p,bytes([fill])*n);live[p]=n;return p
class NativeThrow(Exception):pass
def code(uc,pc,size,user):
 global null_next,mutate_key
 if not active:return
 seen.add(pc)
 if pc in HELPERS:helpers.append(pc)
 sp=u.reg_read(UC_X86_REG_ESP)
 if pc==0x9933e0:
  n=rd(sp+4)
  if null_next:null_next=False;events.append({'op':'allocate_null','bytes':n});ret(0);return
  p=alloc(n);events.append({'op':'allocate','pointer':p,'bytes':n})
  if mutate_key is not None:wr(KEY,mutate_key);events.append({'op':'mutate_key','value':mutate_key});mutate_key=None
  ret(p);return
 if pc in (0xc98528,CUSTOM_A,CUSTOM_B):
  p=rd(sp+4);assert p in live,('invalid free',hex(p),hex(pc));context=0 if pc==0xc98528 else rd(sp+8)
  events.append({'op':'free','pointer':p,'callback':0 if pc==0xc98528 else pc,'context':context,'hex':bytes(u.mem_read(p,live[p])).hex()});del live[p]
  if switch_free and pc==CUSTOM_A:wr(0x14bef40,CUSTOM_B);wr(0x14bef44,0x2222)
  elif switch_free and pc==CUSTOM_B:wr(0x14bef40,0);wr(0x14bef44,0)
  ret();return
 if pc in (0xce0b9f,0xce0c22):raise NativeThrow('bad_alloc' if pc==0xce0b9f else 'length_error')
 assert any(a<=pc<z for a,z in allowed),('unexpected code',hex(pc))
def mem(uc,access,p,size,value,user):
 if not active:return
 if ARENA<=p<ARENA+0x200000:assert any(a<=p and p+size<=a+n for a,n in live.items()),('retired/outside allocation access',hex(p),size,hex(u.reg_read(UC_X86_REG_EIP)))
 if access==unicorn.UC_MEM_WRITE and (TREE<=p<TREE+8 or ARENA<=p<ARENA+0x200000):writes.extend([[p+i,(value>>(8*i))&255] for i in range(size)])
u.hook_add(unicorn.UC_HOOK_CODE,code);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,mem)
def call(pc,this,args=(),stop=END):
 global active
 sp=STACK+0xe000;wr(sp,END)
 for i,v in enumerate(args):wr(sp+4+4*i,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.reg_write(UC_X86_REG_EBP,STACK+0xf000);u.reg_write(UC_X86_REG_EFLAGS,2);wr(0,0)
 active=True
 try:u.emu_start(pc,stop,count=300000)
 finally:active=False
 assert u.reg_read(UC_X86_REG_EIP)==stop
 return u.reg_read(UC_X86_REG_EAX)
def snapshot():
 s={'tree_hex':bytes(u.mem_read(TREE,8)).hex(),'blocks':[{'pointer':p,'bytes':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())],'events':events.copy(),'writes':writes.copy(),'helpers':helpers.copy(),'key':rd(KEY)}
 events.clear();writes.clear();helpers.clear();return s
def validate():
 head=rd(TREE)
 def walk(p,parent,lo,hi):
  if p==head:return (1,[])
  assert rd(p+4)==parent and u.mem_read(p+13,1)[0]==0
  key=rd(p+16);assert lo<key<hi
  c=u.mem_read(p+12,1)[0];assert c in (0,1)
  if c==0:assert all(u.mem_read(rd(p+i)+12,1)[0]==1 for i in (0,8))
  lh,l=walk(rd(p),p,lo,key);rh,r=walk(rd(p+8),p,key,hi);assert lh==rh
  return lh+c,l+[p]+r
 _,nodes=walk(rd(head+4),head,-1,0x100000000)
 assert rd(head)==(nodes[0] if nodes else head) and rd(head+8)==(nodes[-1] if nodes else head)
 return nodes
sequences={'ascending':list(range(24)),'descending':list(reversed(range(24))),'zigzag_left':[30,10,20,5,15,12,14,13,40,35,37,36],'zigzag_right':[10,30,20,35,25,28,26,27,0,5,3,4],'unsigned':[0xffffffff,0,0x80000000,0x7fffffff,1,0xfffffffe,0x80000001,0x7ffffffe,0,0xffffffff],'repeated':[42]*5+[0,0xffffffff,42,0,0xffffffff],'allocator_mutation':[20,10,30,5,15,25,35],'capacity':[11],'null':[11],'long_strings':[20,10,30],'custom_strings':[20,10,30],'empty':[]}
cases=[]
for kind,fill,(profile,keys) in itertools.product(['standard','tutorial'],[0,165],sequences.items()):
 cursor=ARENA;live.clear();events.clear();writes.clear();helpers.clear();u.mem_write(H,bytes([fill])*0x10000);u.mem_write(STACK,bytes([fill])*0x10000);wr(0x14bef40,0);wr(0x14bef44,0);null_next=False;mutate_key=None;switch_free=False
 entry,stop,offset=CTOR[kind];u.reg_write(UC_X86_REG_ESI,TREE-offset);call(entry,0,stop=stop);initial=snapshot();steps=[]
 def invoke(key,mutation=None,count=None,null=False,route=False):
  global mutate_key,null_next
  wr(KEY,key);mutate_key=mutation;null_next=null
  if count is not None:wr(TREE+4,count)
  if route:wr(0x14bef40,CUSTOM_A);wr(0x14bef44,0x1111)
  result=None;error=None
  try:result=call(ENTRY[kind],TREE,[KEY])
  except NativeThrow as e:error=str(e)
  validate();steps.append({'key':key,'mutate_key':mutation,'seed_count':count,'null_allocate':null,'custom_free':route,'result':result,'error':error,'snapshot':snapshot()})
 for key in keys:invoke(key)
 if profile=='allocator_mutation':
  # The lower-bound hint was found using the old key; ctor reloads a new key.
  for before,after in [(12,17),(13,1),(16,40),(14,20),(0,35),(50,0),(18,26),(19,33),(21,12)]:invoke(before,after,route=(before==14));wr(0x14bef40,0)
 if profile=='capacity':
  invoke(12,count=MAX[kind]-1);invoke(11);invoke(13,route=True);wr(0x14bef40,0)
 if profile=='null':invoke(12,null=True)
 seeded=[]
 if profile in ('long_strings','custom_strings'):
  for node in validate():
   for i,offset in enumerate([0x44,0x74] if kind=='standard' else [0x3c]):
    data=(f'{node:08x}-string-{i}-'.encode()*2)+b'\0';p=alloc(len(data));u.mem_write(p,data);wr(node+offset,p);wr(node+offset+16,len(data)-1);wr(node+offset+20,len(data)-1);seeded.append({'node':node,'offset':offset,'pointer':p,'hex':data.hex()})
  if profile=='custom_strings':switch_free=True;wr(0x14bef40,CUSTOM_A);wr(0x14bef44,0x1111)
 before_destroy=snapshot()
 call(DTOR[kind],TREE);destroyed=snapshot();assert not live
 cases.append({'kind':kind,'fill':fill,'profile':profile,'initial':initial,'steps':steps,'seeded_strings':seeded,'before_destroy':before_destroy,'destroyed':destroyed})
regions=[]
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);dis=[]
for role,a,n in SPECS+[('tutorial_construction_byte',0x14c758b,1)]:
 data=image[a-base:a-base+n];regions.append({'role':role,'address':a,'bytes':n,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
 if role!='tutorial_construction_byte':dis.append('FUNCTION '+hex(a)+' '+role+'\n'+'\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in decoder.disasm(data,a)))
proof={'passed':True,'native_sha256':sha,'layout':{'tree':TREE,'key':KEY,'arena':ARENA,'custom_a':CUSTOM_A,'custom_b':CUSTOM_B},'cases':cases,'executed_instruction_addresses':sorted(seen),'limits':['Original native map code is unchanged. Only allocation/free primitive calls are supplied.','Tree-only constructors/destructors are covered; full screen constructors and UI consumers are separate.','Capacity count is seeded near maximum; native exceptions stop at the actual throwing function, without fabricated return or MSVC unwinding.','Long string buffers are explicit owned inputs for destruction, not fabricated provider output.']}
(OUT/'replay_loading_record_tree_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
(OUT/'loading_record_tree_sources.json').write_text(json.dumps({'native_sha256':sha,'regions':regions},indent=2)+'\n')
(OUT/'loading_record_tree_disassembly.txt').write_text('\n\n'.join(dis))
summary={'passed':True,'lifetimes':len(cases),'record_calls':sum(len(c['steps']) for c in cases),'native_instructions':len(seen),'allocations':sum(sum(e['op']=='allocate' for e in s['events']) for c in cases for s in [c['initial']]+[x['snapshot'] for x in c['steps']]),'string_buffers_seeded':sum(len(c['seeded_strings']) for c in cases),'native_sha256':sha}
(OUT/'native_result.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary))
