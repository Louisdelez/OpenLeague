from pathlib import Path
import struct,json,itertools,datetime,hashlib,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x8000;frame=stack-0x2000;spell=vector+0x9000;handle=vector+0xa000;iface=vector+0xa100;callback=vector+0xc000
f=lambda a,x:u.mem_write(a,struct.pack('<f',x)); rf=lambda a:struct.unpack('<f',u.mem_read(a,4))[0]
w(handle+0x20,iface);w(handle+0x24,123);w(iface,vt);w(vt+0x10,callback)
captured=[];visited=set()
def hook(uc,a,n,unused):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==123;captured.append(struct.unpack('<2f',u.mem_read(read(sp+8),8)));finish(0,8);return
 assert 0x7d8231<=a<=0x7d82fd or 0x76da30<=a<=0x76da66 or 0x7d69fc<=a<=0x7d6a4b or vector+0xc100<=a<vector+0xc200,hex(a)
 if a<vector:visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
flag=vector+0xb000;w(0x2d789b4,flag)
getters=[]
for alternate,slot,maximum in itertools.product([False,True],range(4),[0,1,3,5,6]):
 u.mem_write(flag,bytes([alternate]));w(owner+0x474+slot*4,maximum);w(stack,end);w(stack+4,slot);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 # Alternate table values are supplied to this native accessor, never guessed from unloaded globals.
 original=read(0x10b29e8+slot*4);w(0x10b29e8+slot*4,maximum)
 u.emu_start(0x76da30,end,count=100);actual=u.reg_read(UC_X86_REG_EAX);assert actual==maximum;w(0x10b29e8+slot*4,original)
 getters.append(dict(alternate=alternate,slot=slot,maximum=maximum,result=actual))
cases=[]
for slot,maximum,rank,width,gap in itertools.product(range(4),[1,3,5,6],range(1,8),[.020625,21.12],[.00125,1.28]):
 if gap*(maximum-1)>=width:continue
 captured.clear();w(owner+0x474+slot*4,handle);w(spell+0x10,rank)
 f(frame-0x13c,0);f(frame-0x134,gap);f(frame-0x108,width)
 for reg,value in [(UC_X86_REG_EBP,frame),(UC_X86_REG_ESP,stack),(UC_X86_REG_ESI,owner),(UC_X86_REG_EBX,spell),(UC_X86_REG_EDI,slot),(UC_X86_REG_EAX,maximum)]:u.reg_write(reg,value)
 u.emu_start(0x7d8231,0x7d82fd,count=200);assert len(captured)==1
 # SSE inputs are f32; subsequent original x87 arithmetic uses extended precision.
 wf=struct.unpack('<f',struct.pack('<f',width))[0];gf=struct.unpack('<f',struct.pack('<f',gap))[0]
 expected=(((wf-gf*(maximum-1))/maximum)*rank+gf*min(max(rank-.5,0),maximum-1))/wf
 assert abs(captured[0][0]-expected)<1e-6 and captured[0][1]==1.0,(captured,expected)
 cases.append(dict(slot=slot,maximum=maximum,rank=rank,width=wf,gap=gf,fraction=captured[0][0],vertical_fraction=1.0))
dividers=[]
for maximum,width,gap,left in itertools.product([3,5,6],[.020625,21.12],[.00125,1.28],[.1,400]):
 if gap*(maximum-1)>=width:continue
 wf=struct.unpack('<f',struct.pack('<f',width))[0];gf=struct.unpack('<f',struct.pack('<f',gap))[0];segment=(wf-gf*(maximum-1))/maximum
 for index in range(1,maximum):
  f(vector+0xc400,gf);f(vector+0xc404,segment)
  thunk=vector+0xc100;code=b'\xd9\x05'+struct.pack('<I',vector+0xc400)+b'\xd9\x05'+struct.pack('<I',vector+0xc404);code+=b'\xe9'+struct.pack('<i',0x7d69fc-(thunk+len(code)+5));u.mem_write(thunk,code)
  f(frame-0x90,left);f(frame-0x5c,.2);f(frame-0x54,.3);w(frame-0x2c,0)
  u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EDI,index);u.emu_start(thunk,0x7d6a4b,count=100)
  rect=[rf(frame-x) for x in [0x70,0x6c,0x68,0x64]]
  expected=left+struct.unpack('<f',struct.pack('<f',segment))[0]*index+gf*(index-1)
  assert abs(rect[0]-expected)<max(1e-6,abs(expected)*1e-6)
  dividers.append(dict(maximum=maximum,width=wf,gap=gf,left=left,index=index,rect=rect))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),getter_function='0x76da30',fraction_slice=['0x7d8231','0x7d82fd'],divider_slice=['0x7d69fc','0x7d6a4b'],getter_cases=getters,fraction_cases=cases,divider_cases=dividers,getter_case_count=len(getters),fraction_case_count=len(cases),divider_case_count=len(dividers),limits=['Native max-rank getter executes both table routes with supplied table contents; original table population and champion-specific schemes remain open.','Fraction math executes original SSE/x87 with supplied rank and dummy rectangle widths; virtual setter adapted to capture fractions. Original visibility branch and source rectangle getters inspected separately, not executed here.','Divider position slice executes original x87 with supplied precomputed segment/gap values; preceding original segment calculation and string/template callbacks remain open.','No original framebuffer identity or complete HUD/champion qualification.'])
(r/'data/4.20/native_hud_ranks_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({k:proof[k] for k in ['getter_case_count','fraction_case_count','divider_case_count','passed']}))

