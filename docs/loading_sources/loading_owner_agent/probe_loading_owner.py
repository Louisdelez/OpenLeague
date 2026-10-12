"""Execute the original 576280/576410 and loading shared-owner factories.
Only allocation/free/memcpy, Win32 locks and explicit recipient UI terminals supplied.
"""
from pathlib import Path
import sys,json,struct,hashlib,itertools
ROOT=Path('E:/OpenLeague');OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(0x400000,(len(image)+4095)&~4095);u.mem_write(0x400000,image)
H=0x30000000;STACK=0x31000000;END=0x32000000;ARENA=0x35000000
for p,n in [(0,0x10000),(H,0x10000),(STACK,0x10000),(END,0x10000),(ARENA,0x200000)]:u.mem_map(p,n)
G=0x14c761c;SRC=H+0x100;RAWTEXT=H+0x200;PAIR=H+0x400;TMP=H+0x420;RVT=H+0x600
INIT=END+0x100;DEL=END+0x200;CLOSE=END+0x300;DELETE=END+0x400;CUSTOM=END+0x500
def rd(p):return struct.unpack('<I',u.mem_read(p,4))[0]
def wr(p,v):u.mem_write(p,struct.pack('<I',v&0xffffffff))
def rb(p):return u.mem_read(p,1)[0]
def wb(p,v):u.mem_write(p,bytes([v]))
def finish(pop=0,eax=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=rd(sp);u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
active=False;fill=0;cursor=ARENA;live={};ops=[];seen=set();locks=set();wrapper=0;fail16=False;free_mutation=False
def state():return {'blocks':[{'pointer':p,'size':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())],'global':[rd(G),rd(G+4)],'pair':[rd(PAIR),rd(PAIR+4)],'active_global':rd(0x2d77e44),'locks':sorted(locks)}
def alloc(n):
 global cursor
 if n==16 and fail16:ops.append({'op':'allocate','bytes':n,'pointer':0});return 0
 p=cursor;cursor+=(n+31)&~15;assert cursor<ARENA+0x200000;u.mem_write(p,bytes([fill])*n);live[p]=n;ops.append({'op':'allocate','bytes':n,'pointer':p});return p
def free(p,route):
 global free_mutation
 assert p in live,(hex(p),live);n=live.pop(p)
 ops.append({'op':'free','pointer':p,'route':route,'hex':bytes(u.mem_read(p,n)).hex(),'global':[rd(G),rd(G+4)],'pair':[rd(PAIR),rd(PAIR+4)]})
 if free_mutation and route==CUSTOM:wr(0x14bef40,0);free_mutation=False
def code(uc,pc,size,user):
 if not active:return
 seen.add(pc);sp=u.reg_read(UC_X86_REG_ESP)
 if pc==0x9933e0:finish(eax=alloc(rd(sp+4)));return
 if pc in [0xc98528,CUSTOM]:free(rd(sp+4),0 if pc==0xc98528 else CUSTOM);finish();return
 if pc in [0xca1ef0,0xca1f20]:
  dst,src,n=rd(sp+4),rd(sp+8),rd(sp+12);data=bytes(u.mem_read(src,n));u.mem_write(dst,data);finish(eax=dst);return
 if pc==INIT:
  p=rd(sp+4);assert p not in locks;locks.add(p);u.mem_write(p,bytes(24));ops.append({'op':'initialize_lock','pointer':p});finish(4);return
 if pc==DEL:
  p=rd(sp+4);assert p in locks;locks.remove(p);ops.append({'op':'destroy_lock','pointer':p});finish(4);return
 if pc in [CLOSE,DELETE]:
  p=u.reg_read(UC_X86_REG_ECX);ops.append({'op':'recipient','pointer':p,'target':pc,'slot':12 if pc==CLOSE else 16,'flags':None if pc==CLOSE else rd(sp+4),'global':[rd(G),rd(G+4)],'pair':[rd(PAIR),rd(PAIR+4)],'active_global':rd(0x2d77e44)})
  if pc==DELETE:free(p,rd(0x14bef40))
  finish(0 if pc==CLOSE else 4);return
 if pc in [0xce0b9f,0xce0c22,0xca3722]:raise RuntimeError('unqualified native exception '+hex(pc))
u.hook_add(unicorn.UC_HOOK_CODE,code)
def call(entry,ecx=0,args=()):
 global active
 sp=STACK+0xe000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);active=True
 try:u.emu_start(entry,END,count=1000000)
 finally:active=False
 assert u.reg_read(UC_X86_REG_EIP)==END,hex(u.reg_read(UC_X86_REG_EIP));return u.reg_read(UC_X86_REG_EAX)
def setup(poison,language=b'en_US',custom=False):
 global fill,cursor,live,ops,locks,wrapper,fail16,free_mutation
 fill=poison;cursor=ARENA;live={};ops=[];locks=set();wrapper=0;fail16=False;free_mutation=False
 u.mem_write(H,bytes([fill])*0x10000);u.mem_write(STACK,bytes([fill])*0x10000);wr(0,0)
 for p,v in [(G,0),(G+4,0),(PAIR,0),(PAIR+4,0),(0x2d77e44,0xabcdef01),(0x14bef40,CUSTOM if custom else 0),(0x14bef44,0x11223344),(0x14ae870,0),(0x2d78d08,SRC),(0xfa41a0,INIT),(0xfa41bc,DEL),(RVT+12,CLOSE),(RVT+16,DELETE)]:wr(p,v)
 wr(SRC+16,len(language));wr(SRC+20,15 if len(language)<16 else len(language)|15)
 if len(language)<16:u.mem_write(SRC,language+b'\0')
 else:wr(SRC,RAWTEXT);u.mem_write(RAWTEXT,language+b'\0')
def capture():
 result={'state':state(),'operations':list(ops)};ops.clear();return result
def make_wrapper():
 p=alloc(128);call(0x576280,p);return p
def native_string(p,text):
 wr(p+20,15);wr(p+16,0);wb(p,0);u.mem_write(RAWTEXT,text+b'\0');call(0x564c20,p,[RAWTEXT,len(text)])
def populate_tree(tree,count):
 h=rd(tree);nodes=[alloc(44) for _ in range(count)]
 def link(items,parent):
  if not items:return h
  m=len(items)//2;p=items[m];wr(p+4,parent);wb(p+12,0);wb(p+13,0);wr(p,link(items[:m],p));wr(p+8,link(items[m+1:],p));return p
 if count:
  root=link(nodes,h);wr(h+4,root);wr(h,nodes[0]);wr(h+8,nodes[-1]);wr(tree+4,count)
  for i,p in enumerate(nodes):native_string(p+16,(b'k'+str(i).encode()) if i%2==0 else b'long-loading-node-key-'+str(i).encode())
def recipient():p=alloc(4);wr(p,RVT);return p
cases=[]
for poison,language,populated,custom in itertools.product([0,165],[b'',b'zh_CN',b'ZH_cn',b'en_US',b'long-language-name-for-allocation',b'\xff_CN'],[False,True],[False,True]):
 setup(poison,language,custom);before=state();wrapper=make_wrapper();constructed=capture();assert rb(wrapper+0x5c)==int(language.lower()==b'zh_cn')
 # Input population is explicit fixture data for the destructor, not claimed construction.
 if populated:
  populate_tree(wrapper+0x48,7);populate_tree(wrapper+0x50,3);native_string(wrapper+0x2c,b'long-wrapper-message-for-destruction')
  r=recipient();call(0x5c7d10,wrapper,[r]);wb(wrapper+12,1)
 prepared=capture();call(0x576410,wrapper);destroyed=capture();assert set(live)=={wrapper};call(0xc98528,0,[wrapper]);assert not live and not locks
 cases.append({'fill':poison,'language_hex':language.hex(),'custom':custom,'populated':populated,'wrapper':wrapper,'before':before,'constructed':constructed,'prepared':prepared,'destroyed':destroyed,'shutdown':capture()})
publications=[]
for poison,kind,old_count,weak,fail,custom in itertools.product([0,165],['wrapper','recipient'],[0,1,2],[1,2],[False,True],[False,True]):
 setup(poison,b'en_US',custom);destination=G if kind=='wrapper' else PAIR
 old=make_wrapper() if kind=='wrapper' else recipient();call(0x5c7e30 if kind=='wrapper' else 0x5c7d10,destination,[old]);oldcontrol=rd(destination+4)
 wr(oldcontrol+4,old_count);wr(oldcontrol+8,weak);new=make_wrapper() if kind=='wrapper' else recipient();seed=capture();fail16=fail
 call(0x5c7e30 if kind=='wrapper' else 0x5c7d10,destination,[new]);changed=capture();newcontrol=rd(destination+4)
 # All teardown below is explicit, retaining native ownership of each live object.
 fail16=False
 if old in live:call(0x5ddb80 if kind=='wrapper' else 0x5ddb70,oldcontrol)
 if oldcontrol in live:call(0x5d5b40,oldcontrol)
 if newcontrol:call(0x5ddb80 if kind=='wrapper' else 0x5ddb70,newcontrol);call(0x5d5b40,newcontrol)
 elif kind=='wrapper':call(0x576410,new);call(0xc98528,0,[new])
 else:call(DELETE,new,[1])
 assert not live and not locks
 publications.append({'fill':poison,'kind':kind,'old_count':old_count,'weak':weak,'allocation_null':fail,'custom':custom,'old':old,'new':new,'oldcontrol':oldcontrol,'destination':destination,'seed':seed,'changed':changed,'shutdown':capture()})
specs=[('construct',0x576280,0x183),('destroy',0x576410,0x118),('head',0x5c74a0,0x31),('clear',0x5c2ab0,0x46),('erase_subtree',0x5c1ed0,0x9d),('global_publish',0x5c7e30,0x66),('nested_publish',0x5c7d10,0x60),('global_replace',0x5d7750,0xab),('nested_replace',0x5d7680,0xab),('wrapper_dispose',0x5ddb80,0x31),('recipient_dispose',0x5ddb70,15),('control_release',0x5d5b40,12),('control_scalar_delete',0x5d6840,60),('control_vtables',0x1085e5c,32),('language_literal',0x1088ab0,6),('c_locale_compare',0xc9cef8,0x39),('compare_entry',0xc9cf31,0x47),('string_assign',0x564c20,0xf7),('string_growth',0x564f30,0x130),('string_destroy',0x564900,0x50)]
regions=[]
for label,p,n in specs:
 data=image[p-0x400000:p-0x400000+n];regions.append({'label':label,'address':p,'size':n,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'publications':publications,'source_regions':regions,'executed_instruction_addresses':sorted(seen),'limits':['Actual constructors, both ownership factories, wrapper/control destruction,44-byte-tree destruction and native SSO string helpers execute unchanged. Alloc/free/memcpy and single-thread Win32 lock primitives are supplied.','Recipient close/delete terminal calls are explicit observable fixture boundaries, not real UI implementation. No factory or real screen is initialized.','Tree population before destruction is caller-supplied fixture state; native tree insertion is not claimed. C locale comparator branch only. Allocation-null is qualified for control factories, not constructor exception unwinding.','Seeded old strong0 is arithmetic parity for invalid input, not legitimate owning state. Explicit cleanup retires remaining caller-owned objects after reference-count edge cases. Single-thread emulation does not qualify synchronization.']}
(OUT/'loading_owner_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'publications':len(publications),'source_regions':len(regions)}))
