from pathlib import Path
import json,itertools,sys
root=Path('E:/OpenLeague')
source=(root/'tools/probe_whole_announcer_startup.py').read_text().split('\npoison=165;cursor=arena;')[0]
exec(compile(source,'native replay prerequisites','exec'))
poison=165;cursor=arena;fail=False
write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0))
manager=heap+0xa000;packet=heap+0xd000;callback=heap+0xe000;first=callback+0x20
objects=[heap+0xa100+i*0x400 for i in range(6)]
vt=heap+0xf000;events=[];metadata_returns=[];get_equal=False;setter_result=0;mutate=False
slots={0:('data',8,2),1:('state',8,2),2:('five',8,6),3:('six',8,2),4:('done',8,0)}
addresses={}
for i,(kind,slot,count) in slots.items():addresses[end+0x8000+i*0x100]=(i,kind,slot,count)
for slot,count in [(8,2),(12,2),(0x28,4),(0x3c,3)]:addresses[end+0x9000+slot]=(5,'metadata',slot,count)

def string_value(p):
 n=read32(p+16);cap=read32(p+20);return bytes(u.mem_read(read32(p) if cap>=16 else p,n)).hex()

def virtuals(uc,address,size,user):
 if address==0x729e5c:metadata_returns.append(u.reg_read(UC_X86_REG_EAX)&255)
 if address not in addresses:return
 i,kind,slot,count=addresses[address];sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX)
 assert obj==objects[i],(hex(obj),i)
 args=[read32(sp+4+j*4) for j in range(count)];record={'object':obj,'slot':slot,'args':args.copy()}
 if kind=='state':record['args'][1]={'word_ref':read32(args[1])}
 if kind in ['five','six']:
  record['args'][0]={'word_ref':read32(args[0])}
  if kind=='five':record['args'][1]={'word_ref':read32(args[1])}
 if kind=='metadata' and slot in [0x28,0x3c]:record['args'][2]={'string_hex':string_value(args[2])}
 value=0xabcdef00
 if kind=='metadata' and slot==12:
  offset={(100,1):1,(200,1):5,(100,0):0x189,(200,0):0x18d}[tuple(args)]
  value=read32(packet+offset) if get_equal else read32(packet+offset)^0x80000000
 if kind=='metadata' and slot==8:value=setter_result if args[0]==100 else setter_result^1
 record['result']=value;events.append(record)
 if mutate and kind=='metadata' and slot==8:
  write32(objects[5]+0x1a0,2);write32(objects[5]+0x1a4,1)
 finish(eax=value,pop=count*4)
u.hook_add(unicorn.UC_HOOK_CODE,virtuals)

def setup(fill,present=True,has_packet=True,count0=2,count1=1,text=b'Annie',opcode=101):
 global poison,cursor
 poison=fill;cursor=arena+0x80000;events.clear();metadata_returns.clear();allocations.clear();freed.clear()
 u.mem_write(manager,bytes([fill])*0x44);assert call(0x728e20,manager,[])==manager
 for i,obj in enumerate(objects):
  u.mem_write(obj,bytes([fill])*0x220);write32(obj,vt+i*0x80)
 for address,(i,kind,slot,count) in addresses.items():write32(vt+i*0x80+slot,address)
 for off,value in [(0x20,objects[0]),(0x24,objects[1] if present else 0),(0x28,heap+0xef00 if present else 0),(0x2c,objects[4]),(0x34,objects[5])]:write32(manager+off,value)
 write32(heap+0xef04,objects[2]);write32(heap+0xef08,objects[3])
 write32(objects[5]+0x1a0,count0);write32(objects[5]+0x1a4,count1)
 u.mem_write(packet,bytes((i*37+11)&255 for i in range(0x400)))
 u.mem_write(packet,bytes([opcode]));u.mem_write(packet+0x11,text+b'\0')
 write32(0x2d78520,manager);write32(callback,0x10afd08);write32(callback+4,manager);write32(callback+8,0x72c780);write32(callback+12,0);write32(first,0x87654321)
 return packet if has_packet else 0

def snapshot():return {'manager_hex':bytes(u.mem_read(manager,0x44)).hex(),'metadata_hex':bytes(u.mem_read(objects[5],0x220)).hex(),'events':list(events)}

cases=[]
profiles=[]
# Every selector byte; native low-byte truncation also tested with high bits set.
for event in range(256):profiles.append((event,2,101,True,True,5,b'Annie',False,0,2,1,False))
for event,sub in itertools.product([2,3,4,5,0x103,0x104],range(9)):
 for opcode in ([100,101,102,103,104,255] if sub==7 else [101]):profiles.append((event,sub,opcode,True,True,0,b'Annie',False,0,2,1,False))
for sub,present,flag in itertools.product([5,6],[False,True],[0,1,2,0xffffffff]):profiles.append((3,sub,101,present,True,flag,b'X',False,0,2,1,False))
for opcode,text in itertools.product([101,102],[b'',b'A'*15,b'B'*16,b'C'*80,b'\xff\xfe A',b'one\0ignored']):profiles.append((3,7,opcode,True,True,1,text,False,0,2,1,False))
for equal,result,n0,n1,change in itertools.product([False,True],[0,1],[0,1,24],[0,2,24],[False,True]):profiles.append((3,7,103,True,True,1,b'Z',equal,result,n0,n1,change))
for event in [0,2,4,5,255]:profiles.append((event,2,101,True,False,1,b'X',False,0,2,1,False))
for index,profile in enumerate(profiles):
 event,sub,opcode,present,has_packet,flag,text,get_equal,setter_result,n0,n1,mutate=profile
 fill=[0,165][index%2];p=setup(fill,present,has_packet,n0,n1,text,opcode);write32(packet+10,flag)
 before=snapshot();args=[0x87654321,event,sub,0x1234fedc,p]
 # Call full734130 ->72C780 ->729370 only when packet bypasses object commands.
 through=sub&255!=0 or p==0
 returned=call(0x734130,callback,[first]+args[1:]) if through else call(0x729370,manager,args)
 assert returned&255==1
 cases.append({'fill':fill,'profile':{'event':event,'sub':sub,'opcode':opcode,'present':present,'has_packet':has_packet,'flag':flag,'text_hex':text.hex(),'get_equal':get_equal,'setter_result':setter_result,'count0':n0,'count1':n1,'mutate':mutate},'through_callback':through,'args':args,'before':before,'after':snapshot(),'result_al':returned&255,'metadata_returns':list(metadata_returns)})

# Member callback preserves exact32-bit return and wraps this-adjustment.
invocations=[];observed=[];target=end+0xa000
def target_boundary(uc,address,size,user):
 if address!=target:return
 sp=u.reg_read(UC_X86_REG_ESP);observed.append({'this':u.reg_read(UC_X86_REG_ECX),'args':[read32(sp+4+i*4) for i in range(5)]});finish(eax=0xf1234500|len(observed),pop=20)
u.hook_add(unicorn.UC_HOOK_CODE,target_boundary)
for owner,adjustment,value in itertools.product([0,manager,0xfffffff0],[0,1,0xffffffff,0x80000000],[0,0xffffffff,0x87654321]):
 write32(callback+4,owner);write32(callback+8,target);write32(callback+12,adjustment);write32(first,value);observed.clear()
 result=call(0x734130,callback,[first,0xabc,0x12345678,0xdef,packet]);invocations.append({'owner':owner,'adjustment':adjustment,'value':value,'result':result,'observed':observed.copy()})

proof={'passed':True,'complete':False,'native_sha256':digest,'manager':manager,'packet':packet,'callback':callback,'first':first,'objects':objects,'vt':vt,'addresses':{str(k):list(v) for k,v in addresses.items()},'jump_table':[hex(read32(0x72955c+i*4)) for i in range(4)],'cases':cases,'invocations':invocations,'limits':['Actual734130,72C780 pass-through,729370,729D70 and native string construction/destruction execute. Supplied terminal virtual callbacks capture semantic arguments and controlled return values; they do not implement game events. Existing primitive allocator/CRT/OS boundaries supplied. No replay dispatcher or metadata helper result adapter.','Opcode0/1 shared-object routing of72C780, manager startup/destruction, replay frame producers, consumers and native virtual metadata implementation are not qualified by these fixtures. Normal-return valid storage only; exception/unwind, native string allocation identity and invalid native-pointer execution not claimed.']}
out=Path(sys.argv[1]) if len(sys.argv)>1 else root/'data/4.20/replay_dispatch_contract.json'
out.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'dispatch_cases':len(cases),'invocations':len(invocations),'jump_table':proof['jump_table']}))
