from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'transport cleanup prerequisites','exec'))
packet_events=[];host_events=[];mode=0
callback=end+0x6000;free_a=end+0x6100;free_b=end+0x6200
def cleanup_boundary(uc,pc,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if pc==callback:
  p=read32(sp+4);packet_events.append({'op':'callback','packet':p,'method':pc});write32(p+4,read32(p+4)^4);write32(0x122587c,free_b);finish();return
 if pc in [free_a,free_b]:
  p=read32(sp+4);packet_events.append({'op':'free','pointer':p,'method':pc});write32(0x122587c,free_b if pc==free_a else free_a);finish();return
 if pc==0x9007f0:
  host,output,flags=u.reg_read(UC_X86_REG_ECX),u.reg_read(UC_X86_REG_EDX),read32(sp+4);host_events.append({'op':'flush','host':host,'output':output,'flags':flags,'time':read32(host+0x28)})
  if mode:write32(host+0x20,heap+0xee00);write32(host+0x24,2)
  finish(eax=0);return
 if pc==0x8fe700:
  peer,reason=u.reg_read(UC_X86_REG_ECX),u.reg_read(UC_X86_REG_EDX);host_events.append({'op':'reset','peer':peer,'reason':reason})
  if mode:write32(heap+0xe800+0x20,heap+0xf400)
  finish();return
 if pc==0x8fd8a0:
  host_events.append({'op':'destroy','host':u.reg_read(UC_X86_REG_ECX)});finish();return
u.hook_add(unicorn.UC_HOOK_CODE,cleanup_boundary)
queues=[];hosts=[]
try:
 for poison,head,mode in itertools.product([0,165],[0,3,0xffffffff],[0,1,2,3]):
  snapshot();before=set(live);obj=call(0x9933e0,0,[224]);call(0x8fc230,obj,[])
  slots=call(0x9933e0,0,[16]);blocks=[call(0x9933e0,0,[20]) for _ in range(4)]
  write32(obj+0xac,slots);write32(obj+0xb0,4);write32(obj+0xb4,head);write32(obj+0xb8,3)
  for i,block in enumerate(blocks):
   write32(slots+4*i,block)
   for j in range(5):write32(block+4*j,0)
  packets=[]
  for i in range(3):
   packet=heap+0xe000+i*32;payload=heap+0xe100+i*32;flags=4 if mode==2 or mode==3 and i%2 else 0;method=callback if mode==3 else 0
   words=[0,flags,payload,17,method];u.mem_write(packet,struct.pack('<5I',*words));packets.append({'pointer':packet,'words':words});block=blocks[(head+i)&3]
   for j,v in enumerate([0x100+i,0x200+i,0x300+i,0x400+i,0 if mode==0 else packet]):write32(block+4*j,v)
  write32(0x122587c,free_a);prepared=snapshot();packet_events.clear();call(0x8fc930,obj,[]);reset=snapshot();remaining=[bytes(u.mem_read(v['pointer'],20)).hex() for v in packets];route=read32(0x122587c)
  call(0x8fc2d0,obj,[1]);destroyed=snapshot();assert set(live)==before
  queues.append({'fill':poison,'head':head,'mode':mode,'object':obj,'slots':slots,'blocks':blocks,'packets':packets,'free_a':free_a,'free_b':free_b,'callback':callback,'prepared':prepared,'reset':reset,'packet_events':list(packet_events),'packet_bytes_after':remaining,'final_deallocator':route,'destroyed':destroyed})
 for poison,mode,clock_base in itertools.product([0,165],[0,1],[0,0xfffffffe]):
  snapshot();before=set(live);obj=call(0x9933e0,0,[224]);call(0x8fc230,obj,[]);host=heap+0xe800;u.mem_write(host,bytes([poison])*48)
  write32(obj+8,host);write32(host+0x20,heap+0xea00);write32(host+0x24,3);write32(0x2d78ec8,clock_base);prepared=snapshot();host_events.clear()
  call(0x8fc830,obj,[]);flushed=snapshot();host_after=bytes(u.mem_read(host,48)).hex();call(0x8fc2d0,obj,[1]);destroyed=snapshot();assert set(live)==before
  hosts.append({'fill':poison,'mode':mode,'clock_base':clock_base,'object':obj,'host':host,'initial_peers':heap+0xea00,'flush_peers':heap+0xee00,'reset_peers':heap+0xf400,'prepared':prepared,'flushed':flushed,'events':list(host_events),'host_bytes_after':host_after,'destroyed':destroyed})
 result={'passed':True,'native_sha256':digest,'queues':queues,'hosts':hosts,'limits':['Actual8FC930 and deque helper5E1E30 run on supplied nonempty valid queues, followed by actual scalar destructor and5E26A0 storage release. Packet callbacks and allocator bodies are explicitly supplied observers; their calls and mutation-sensitive rereads are qualified, not the unported8FCC80 pool allocator.','24 queue profiles cover two fills, three wraparound heads, null packets, flags0/4 and callbacks toggling flags/deallocator. All4 event blocks remain after reset then are released in reverse slot order by destruction.','8 host flush profiles run actual8FC830 under the actual global mutex.9007F0 and8FE700 are supplied boundaries that optionally change peer-array/count. Elapsed clock subtraction wraps. No networking, packet transmission or actual ENet host destruction is claimed.']}
except Exception as e:
 import traceback
 traceback.print_exc();result={'passed':False,'error':repr(e),'native_sha256':digest,'queue_cases_completed':len(queues),'host_cases_completed':len(hosts),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['queues','hosts','limits']}))
if not result['passed']:sys.exit(1)
