from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools,math
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m);u.mem_map(0,0x1000)
a=0x40000000;u.mem_map(a,0x50000);result=a;context=a+0x100;source=a+0x200;status=a+0x300;inputdata=a+0x1000;outputdata=a+0x3000;wrapper=a+0x5000;resource=a+0x6000;texture=a+0x7000;default=a+0x8000;manager=a+0x10000;stack=a+0x40000;end=a+0x4f000
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
visited=set();events=[];failure=0
def args(n):return [read(u.reg_read(UC_X86_REG_ESP)+4+i*4) for i in range(n)]
def finish(pop=0,value=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,value)
def hook(uc,addr,size,user):
 if addr==0x983cb0:events.append({'bind_slot3':args(2)});finish(8);return
 if addr==0x9933e0:assert args(1)==[4];events.append({'allocate_wrapper':4});finish(value=0 if failure==1 else wrapper);return
 if addr==0x985e50:events.append({'target_factory':args(5)});finish(20,0 if failure==2 else resource);return
 if addr==0x988870:events.append({'push_target':u.reg_read(UC_X86_REG_ECX),'arguments':args(1)});finish(4);return
 if addr==0x9889d0:events.append({'restore_target':u.reg_read(UC_X86_REG_ECX)});finish(4);return
 if addr==0x980290:events.append({'clear_first_four_args':args(4)});finish(24);return
 if addr==0x983780:events.append({'render_state_flags_blend':args(2)});finish(8);return
 if addr==0x980650:events.append({'shader':bytes(u.mem_read(args(1)[0],80)).split(b'\0')[0].decode()});finish(4);return
 if addr==0x986760:
  rect=list(struct.unpack('<4i',u.mem_read(u.reg_read(UC_X86_REG_ECX),16)));events.append({'draw_rectangle':rect,'context':u.reg_read(UC_X86_REG_EDX),'color_word':read(args(2)[1])});finish();return
 if addr==0x6b64b0:
  vector=u.reg_read(UC_X86_REG_ECX);used=read(vector+4)-read(vector) if read(vector) else 0;w(vector,outputdata);w(vector+4,outputdata+used);w(vector+8,outputdata+used+16);finish(4);return
 if addr==0xc98528:finish();return
 if addr==0xc975f5:finish(value=u.reg_read(UC_X86_REG_EAX));return
 assert (0x95bbe0<=addr<0x95be37) or (0x95ba70<=addr<0x95bbde),hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(0x14bef38,default);w(0x14bef40,0);w(manager+0x20330,a+0x9000);u.reg_write(UC_X86_REG_FPCW,0x037f)
cases=[]
for size,count,failure in itertools.product([(800,600),(803,607),(1,1),(4294967295,2147483648)],[-1,0,1,3],range(4)):
 events=[];rows=[[10+i*5,20+i*7,31+i*5,41+i*7] for i in range(max(count,0))]
 for i,row in enumerate(rows):u.mem_write(inputdata+i*16,struct.pack('<4i',*row))
 w(source,inputdata);w(source+4,inputdata+len(rows)*16);w(source+8,inputdata+len(rows)*16);w(manager+0x20328,size[0]);w(manager+0x2032c,size[1]);w(resource+0x10,0 if failure==3 else texture);w(status,0x12345678);w(result,0)
 w(context+0x60,size[0]);w(context+0x64,size[1]);w(stack,end);w(stack+4,context);w(stack+8,0 if count==-1 else source);w(stack+12,status)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,result);u.emu_start(0x95bbe0,end,count=4000)
 assert events[0]=={'bind_slot3':[default,3]}
 successful=count>0 and failure==0
 if count<=0:assert len(events)==1 and read(status)==0x12345678
 else:
  assert read(status)==(0 if successful else 0x80004005)
  if failure!=1:
   factory=next(e['target_factory'] for e in events if 'target_factory' in e);assert factory[:3]==[size[0]//4,size[1]//4,2],(size,factory)
  draws=[e['draw_rectangle'] for e in events if 'draw_rectangle' in e]
  assert len(draws)==(count if successful else 0)
  if successful:
   assert draws==[[math.trunc(v*.25) for v in row] for row in rows]
   assert events[-1]=={'bind_slot3':[texture,3]}
   assert next(e['clear_first_four_args'] for e in events if 'clear_first_four_args' in e)==[0,0,1,4294967295]
   assert next(e['shader'] for e in events if 'shader' in e)=='PS_COPY_FILTER'
 cases.append({'viewport_size':size,'source_count':count,'failure_adapter':failure,'status_word':read(status),'events':events})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95bbe0','native_addresses':len(visited),'cases':cases,'findings':['Native95BBE0 always binds a supplied default texture to sampler3; null/empty sources skip target construction without writing status.','Nonempty input allocates a type2 target at unsigned viewport dimensions divided by4 and truncated; zero dimensions are passed through to target factory.','Allocation/resource/texture failures report80004005 and retain default binding; success pushes target, clears, scales rectangles with actual95BA70, sets flags0/blend0, selectsPS_COPY_FILTER, draws each rectangle, restores target and binds generated texture to sampler3.','Clear helper first four arguments are0,0,1,FFFFFFFF; draw color pointer begins withFFFFFFFF. Pixel interpretation requires qualifying the driver and quad consumer.'],'runtime_adapters':['Actual producer and95BA70 instructions execute; allocator/factory, target/clear/state/shader/quad/bind consumers and vector allocator are explicit recording adapters.','Failure states injected independently; no actual device allocation or GPU pixels.'],'limits':['Default texture producer, type2 format, driver clear interpretation, PS_COPY_FILTER source/texture,986760/986AD0 quad behavior and GPU mask pixels remain open.','No actual actor/camera sources or live grass mask integrated.']}
proof['x87_control_word']=0x037f
proof['limits'].append('x87 control word037F supplied explicitly. Default Unicorn24-bit precision rounded unsignedFFFFFFFF to100000000 before quarter scaling; historical precision initialization remains open.')
(r/'data/4.20/grass_target_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'success_cases':sum(c['source_count']>0 and c['failure_adapter']==0 for c in cases),'passed':True}))
