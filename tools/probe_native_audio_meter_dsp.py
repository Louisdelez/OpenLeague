from native_x87 import HardwareFyl2x
from pathlib import Path
import json,itertools,hashlib,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
obj=heap+0x1000;param=heap+0x2000;allocator=heap+0x3000;vtable=heap+0x3100;manager=heap+0x4000;fmt=heap+0x5000;buffer=heap+0x6000;data=heap+0x7000;value=heap+0x8000;calls=[]
put(allocator,'I',vtable);put(vtable+4,'I',trap+0x500)
regions=[(0xb3e260,0xb3e29d),(0xb3df60,0xb3df7d),(0xb3e040,0xb3e07d),(0xb3e100,0xb3e1a5),(0xb3e2e0,0xb3e34f),(0xb3e390,0xb3e3dc),(0xb3eb60,0xb3ebba),(0xb3e400,0xb3eaab)]
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
for rate,mask,frames,mode,status,signal in itertools.product([22050,48000],[0,1,3,0x3ff],[0,1,4,8],[0,1],[17,45],[0,1]):
 sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(finit,trap,count=10)
 u.mem_write(obj,bytes(84));u.mem_write(param,bytes(32));assert invoke(0xb3e260,[allocator])==obj;assert invoke(0xb3df60,[allocator])==param;assert invoke(0xb3e040,[allocator,0,0],param)==1;put(value,'I',mode);assert invoke(0xb3e100,[2,value,4],param)==1;put(param+28,'I',100)
 put(0x14a83c4,'I',manager);put(manager,'IIII',allocator,0,0,0);put(fmt,'II',rate,0);assert invoke(0xb3e2e0,[allocator,0x30009900,param,fmt])==1;assert invoke(0xb3e390)==1
 before=bytes(u.mem_read(obj,84)).hex();parameter=bytes(u.mem_read(param,32)).hex();steps=[]
 for step in range(3):
  samples=[0. if signal==0 else([-0.25,0.5,-1.,0.125,0.,-0.75,0.25,1.][i%8]if step==0 else 0.)for i in range(mask.bit_count()*8)];raw=struct.pack('<'+'f'*len(samples),*samples);u.mem_write(data,raw or bytes(4));put(buffer,'IIIHH',data,mask,status,8,frames);buffer_before=bytes(u.mem_read(buffer,16)).hex();calls.clear();invoke(0xb3e400,[buffer]);steps.append({'buffer_before':buffer_before,'buffer_after':bytes(u.mem_read(buffer,16)).hex(),'samples_before':raw.hex(),'samples_after':bytes(u.mem_read(data,len(raw))).hex(),'effect_after':bytes(u.mem_read(obj,84)).hex(),'calls':list(calls)})
 assert bytes(u.mem_read(param,32)).hex()==parameter
 rows.append({'rate':rate,'mask':mask,'frames':frames,'mode':mode,'status':status,'signal':signal,'effect_before':before,'parameter':parameter,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual creators/parameters/Init/Reset and Process B3E400 with native detector B3E490/smoothing B3E700/tail helper B3EA40 execute. Allocation supplies controlled backing; memset helper alone supplies exact byte clear. No detector/smoothing/result adapters.'],'findings':['Controlled native planar buffers have8 maxframes and0/1/4/8 validframes,0/1/2/10 channels,mode0/1,status17/45,22050/48000Hz. Three steps retain actual effect detector/smoothing/tail state.','Parameter data stays unchanged while Process updates raw effect state and may change buffer state/samples.'],'limits':['Preparatory native DSP evidence, no Rust Process/helper port yet.','Only bounded finite silence/pulse inputs, these modes/rates/masks and default other parameters qualify;NaN/Inf,arbitrary frames/rates/channels/parameter ramps and long tails require coverage.','Normal instance/effect-reader/runtime/device and audible mixing remain incomplete.']}
nan_steps=sum(struct.unpack_from('<I',bytes.fromhex(step['effect_after']),32)[0]==0xffc00000 for row in rows for step in row['steps']);assert nan_steps==72
proof['generated_nan_steps']=nan_steps;proof['findings'].append('Zero-channel mode1 with nonzero validframes generates raw negative quiet NaN FFC00000 at effect20 in72 snapshots; output must preserve this native behavior despite finite inputs.')
proof['arithmetic_boundary']=physical_fyl2x.metadata();proof['adapters'].append('FYL2X uses actual processor instruction with80-bit operands due to measured Unicorn zero-domain error; all other DSP bodies remain native PE instruction execution. Hybrid arithmetic reference, not full client hardware acceptance.');physical_fyl2x.close()
(r/'data/4.20/audio_meter_dsp_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Meter DSP cases,',len(rows)*3,'retained processing steps')
