"""Native7074B0 state setter,707610 height transition and final reference-release fragments."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
prior=json.loads((r/'data/4.20/audio_emitter_position_contract.json').read_text());b=Path(prior['provenance']['executable']).read_bytes()
assert hashlib.sha256(b).hexdigest()==prior['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0x7074b0,0x7074e0),(0x707610,0x7076c6),(0xaeb1c0,0xaeb1da),(0xaeb1e0,0xaeb237),
 (0xaeefd3,0xaef005),(0xb24612,0xb24646)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for a,e in areas:
 blob=p.get_data(a-base,e-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob),(hex(a),hex(e))
 regions.append({'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
wrapper,source=heap,heap+0x1000
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def ret(v,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_EAX,v);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
available=True;messages=[];calls=[]
def hook(uc,a,n,d):
 if a==0xaea6b0:ret(int(available),0);return
 if a==0x87cd10:ret(56,0);return
 if a==0xc975f5:ret(0,0);return
 if a==0xb05ed0:
  ptr,size=read(u.reg_read(UC_X86_REG_ESP)+4,'II');assert size==56 and read(ptr+2,'H')[0]==13
  messages.append({'object_id':read(ptr+8,'I')[0],'position_bits':list(read(ptr+12,'3I')),'opaque_tail':list(read(ptr+24,'3I'))})
  ret(1,8);return
 if a==0xaf5d80:calls.append('destroy_object');ret(0,0);return
 if a==0xada3e0:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+8,'I')[0];assert ptr==source
  calls.append('free_object');ret(0,0);return
 assert any(s<=a<e for s,e in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invoke(start,args):
 sp=stack+0x8000;put(sp,'I',trap)
 for i,v in enumerate(args):put(sp+4+i*4,'I',v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,wrapper)
 u.emu_start(start,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
heights=[-.5,-0.,0.,.25,1.,1.5]
setters=[]
for height,flag,force in itertools.product(heights,[0,1,255],[0,1]):
 put(wrapper+0x14,'f',height);put(wrapper+0x18,'B',0x55);invoke(0x7074b0,[flag,force])
 expected=height if not force else 0. if flag else 1.
 assert read(wrapper+0x14,'I')[0]==bits(expected) and read(wrapper+0x18,'B')[0]==flag
 setters.append({'height_bits':bits(height),'flag':flag,'force':force,'after_height_bits':bits(expected),'after_flag':flag})
ticks=[]
for height,flag,delta,obj,available,seed in itertools.product(heights,[0,1,255],[-.1,0.,.1,.75,1.5],[0,123,0xffffffff],[False,True],[0,0x7fc00000]):
 u.mem_write(stack,struct.pack('<I',seed)*(0x10000//4))
 delta=f32(delta);put(wrapper+4,'I',obj);put(wrapper+8,'3f',7400.,1500.,7700.);put(wrapper+0x14,'f',height);put(wrapper+0x18,'B',flag)
 messages.clear();invoke(0x707610,[bits(delta)])
 changed=False;expected=height
 if flag:
  if height>0:changed=True;expected=0.
 elif height<1:
  changed=True;expected=min(f32(height+delta),1.)
 assert read(wrapper+0x14,'I')[0]==bits(expected);assert read(wrapper+0x18,'B')[0]==flag
 assert len(messages)==int(changed and available and obj!=0)
 if messages:assert messages[0]=={'object_id':obj,'position_bits':[bits(7400.),bits(f32(expected*-2500.)),bits(7700.)],'opaque_tail':[seed]*3}
 ticks.append({'height_bits':bits(height),'flag':flag,'delta':delta,'object_id':obj,'engine_available':available,'stack_seed':seed,
  'after_height_bits':bits(expected),'messages':messages.copy()})
releases=[]
for region,flag in itertools.product(areas[-2:],[0,1,2,0x3fffffff,0x40000000,0x40000001,0x80000001,0xc0000001,0xc0000002,0xffffffff]):
 start,end=region;put(source+0x60,'I',flag);calls.clear()
 u.reg_write(UC_X86_REG_EBX,source);u.reg_write(UC_X86_REG_EDX,source);u.reg_write(UC_X86_REG_EBP,stack+0x7000);put(stack+0x7000-8,'I',source)
 u.reg_write(UC_X86_REG_ESP,stack+0x6000);u.emu_start(start,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 expected=(flag&0xc0000000)|((flag-1)&0x3fffffff);destroyed=expected&0x3fffffff==0
 assert read(source+0x60,'I')[0]==expected
 assert calls==(['destroy_object','free_object'] if destroyed else [])
 releases.append({'region':hex(start),'prior_flags':flag,'after_flags':expected,'destroyed':destroyed,'calls':calls.copy()})
out={'passed':True,'setter_cases':setters,'height_tick_cases':ticks,'final_reference_cases':releases,'regions':regions,'provenance':prior['provenance'],
 'stubs':['Availability/queue size/packet capture/security check. Native setter/height updates and source packetXYZ executed.',
 'Final-release native blocksAE_EFD3..AEF005 andB24612..B24646 execute flag math/destruction decision; AF5D80 destructor andADA3E0 heap free captured, surrounding voice destruction not executed.'],
 'limits':['Field18 byte treated raw (zero/nonzero), without inferring all callers or audibility semantics.',
 'Height tick admits negative delta and negative/above-one supplied states; native behavior preserved, no default clamping invented.',
 'Native object full destructor/PCM/stream callbacks and retained ownership handles remain separate.',
 'No full game-frame scheduling, original clock delta source or live client audio acceptance.'],'complete':False}
(r/'data/4.20/audio_object_height_reference_contract.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print('Native height/ref:',len(setters),'setters;',len(ticks),'ticks;',len(releases),'final reference cases')