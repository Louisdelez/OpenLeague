from native_x87 import HardwareFyl2x
from pathlib import Path
import json,itertools,hashlib,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
obj=heap+0x1000;param=heap+0x2000;allocator=heap+0x3000;vtable=heap+0x3100;manager=heap+0x4000;fmt=heap+0x5000;buffer=heap+0x6000;data=heap+0x7000;value=heap+0x8000;calls=[]
put(allocator,'I',vtable);put(vtable+4,'I',trap+0x500)
regions=[(0xb3e260,0xb3e29d),(0xb3df60,0xb3df7d),(0xb3e040,0xb3e07d),(0xb3e100,0xb3e1a5),(0xb3e0b0,0xb3e0ff),(0xb3e2e0,0xb3e34f),(0xb3e390,0xb3e3dc),(0xb3eb60,0xb3ebba),(0xb3e400,0xb3eaab)]
physical_fyl2x=HardwareFyl2x()
finit=trap+0x600;u.mem_write(finit,b'\xdb\xe3\xc3')
def guard(uc,a,n,d):
 if a in [0xb3e570,0xb3e676,0xb3e6b7]:physical_fyl2x.execute(u,a);return
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==trap+0x500:
  size=read(sp+4,'I')[0];assert size in [32,84];ret(obj if size==84 else param,4);return
 if a==0xca1d00:
  dst,val,size=read(sp+4,'3I');u.mem_write(dst,bytes([val&255])*size);calls.append({'kind':'memset','offset':dst-data,'value':val,'size':size});ret(dst,0);return
 if finit<=a<finit+3:return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(entry,args=(),this=obj):
 sp=stack+0x8000;put(sp,'I'*(len(args)+1),trap,*args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(entry,trap,count=40000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
rows=[]
profiles=[(0.,.1,-48.,6.,0.),(.007,.045,-48.,6.,.0017),(.05,0.,-60.,12.,.003)]
for rate,mask,mode,status,profile,maxframes in itertools.product([44100,48000],[1,3],[0,1],[17,45],range(3),[8,256]):
 sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(finit,trap,count=10)
 u.mem_write(obj,bytes(84));u.mem_write(param,bytes(32));assert invoke(0xb3e260,[allocator])==obj;assert invoke(0xb3df60,[allocator])==param;assert invoke(0xb3e040,[allocator,0,0],param)==1;put(value,'I',mode);assert invoke(0xb3e100,[2,value,4],param)==1;initial_payload=struct.pack('<fffffBI',*profiles[profile],mode,100);u.mem_write(value,initial_payload);assert invoke(0xb3e0b0,[value,25],param)==1
 put(0x14a83c4,'I',manager);put(manager,'IIII',allocator,0,0,0);put(fmt,'II',rate,0);assert invoke(0xb3e2e0,[allocator,0x30009900,param,fmt])==1;assert invoke(0xb3e390)==1
 before=bytes(u.mem_read(obj,84)).hex();parameter=bytes(u.mem_read(param,32)).hex();steps=[]
 for step in range(48):
  update_payload=None
  if step in [16,32]:
   settings=(.007,.045,-54.,6.,.0017)if step==16 else profiles[profile];update_payload=struct.pack('<fffffBI',*settings,mode,200 if step==16 else 100);u.mem_write(value,update_payload);assert invoke(0xb3e0b0,[value,25],param)==1
  current_parameter=bytes(u.mem_read(param,32)).hex();frames=[maxframes,maxframes//2,1,0][step%4]
  samples=[([-0.25,0.5,-1.,0.125,0.,-0.75,0.25,1.][i%8]*(1. if step%13==0 else .1))if step<4 or step%13==0 else 0. for i in range(mask.bit_count()*maxframes)];raw=struct.pack('<'+'f'*len(samples),*samples);u.mem_write(data,raw or bytes(4));put(buffer,'IIIHH',data,mask,status,maxframes,frames);buffer_before=bytes(u.mem_read(buffer,16)).hex();calls.clear();invoke(0xb3e400,[buffer]);assert bytes(u.mem_read(param,32)).hex()==current_parameter;steps.append({'parameter_update':update_payload.hex()if update_payload else None,'parameter_before':current_parameter,'buffer_before':buffer_before,'buffer_after':bytes(u.mem_read(buffer,16)).hex(),'samples_before':raw.hex(),'samples_after':bytes(u.mem_read(data,len(raw))).hex(),'effect_after':bytes(u.mem_read(obj,84)).hex(),'calls':list(calls)})
 rows.append({'rate':rate,'mask':mask,'frames':frames,'mode':mode,'status':status,'profile':profile,'maxframes':maxframes,'effect_before':before,'parameter':parameter,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual creators/parameters/Init/Reset and Process B3E400 with native detector B3E490/smoothing B3E700/tail helper B3EA40 execute. Allocation supplies controlled backing; memset helper alone supplies exact byte clear. No detector/smoothing/result adapters.'],'findings':['Controlled native planar buffers have8 maxframes and0/1/4/8 validframes,0/1/2/10 channels,mode0/1,status17/45,22050/48000Hz. Three steps retain actual effect detector/smoothing/tail state.','Parameter data stays unchanged while Process updates raw effect state and may change buffer state/samples.'],'limits':['Preparatory native DSP evidence, no Rust Process/helper port yet.','Only bounded finite silence/pulse inputs, these modes/rates/masks and default other parameters qualify;NaN/Inf,arbitrary frames/rates/channels/parameter ramps and long tails require coverage.','Normal instance/effect-reader/runtime/device and audible mixing remain incomplete.']}
proof['findings']=['Actual48-step retained processing,valid-frame changes,pulses/silence,longer tails and parameter block updates at16/32 execute. Rates44100/48000,1/2 channels,max8/256 frames,mode0/1,status17/45,3 attack/release/window/floor profiles.'];proof['limits']=['Preparatory expanded DSP evidence, no Rust acceptance yet.','Only finite bounded samples/these parameter sequences and frame/rate/channel configurations; normal instance/effect-reader/device acceptance remains open.'];proof['adapters']=['Actual native creator/SetBlock/Init/Reset/Process and all detector/smoothing/tail bodies execute; only allocator and exact byte-clear memory helper are boundaries.']
proof['arithmetic_boundary']=physical_fyl2x.metadata();proof['adapters'].append('FYL2X uses actual processor instruction with80-bit operands due to measured Unicorn zero-domain error; all other DSP bodies remain native PE instruction execution. Hybrid arithmetic reference, not full client hardware acceptance.');physical_fyl2x.close()
(r/'data/4.20/audio_meter_dsp_extended_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Meter DSP cases,',len(rows)*48,'retained processing steps')
