"""Bounded original listener updates with stable native orientation cache."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EIP,UC_X86_REG_EAX
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());exe=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
b=exe.read_bytes();p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
def native(a,n):return b[p.get_offset_from_rva(a-base):][:n]
areas=[(0x6f7d30,0x6f7efa),(0x6f7f00,0x6f8204),(0x66d6e0,0x66d72a),(0x705f30,0x705f34),(0x705f40,0x705f44),(0x586220,0x586223),(0x58f1c0,0x58f1c4),(0x8e2550,0x8e25b2)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for a,end in areas:
 blob=native(a,end-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
anchors={0x704b58:'c746100000fa43',0x705f40:'d94110',0x6f7f16:'d98004010000',0x6f7f27:'d9800c010000',0x6f7f4a:'d95e04',0x6f7d45:'0f85ab010000',0x6f7e93:'ff5074',0x6f7fb4:'0f851c020000',0x6f81d6:'8b4508'}
for a,data in anchors.items():assert native(a,len(data)//2).hex()==data,hex(a)
constants={0x1138e98:3.0,0x1138ba4:0.5,0x1138990:1e-9}
for address,value in constants.items():assert native(address,4)==struct.pack('<f',value)
assert struct.unpack('<f',native(0x704b5b,4))[0]==500
assert struct.unpack('<3f',native(0x1110a74,12))==(0.0,1.0,0.0)
assert struct.unpack('<I',native(0x10af384+0x80,4))[0]==0x705f40
heap=0x30000000;stack=0x31000000;tramp=0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,tramp]:u.mem_map(a,0x2000)
u.mem_write(tramp,b'\xf4');u.mem_write(tramp+0x100,b'\xdb\xe3');u.mem_write(tramp+0x200,b'\xc3')
def put(a,fmt,*values):u.mem_write(a,struct.pack('<'+fmt,*values))
put(heap,'I',heap+0x100)
for slot,addr in [(0x7c,0x705f30),(0x70,0x586220),(0x74,tramp+0x200),(0x80,0x705f40)]:put(heap+0x100+slot,'I',addr)
put(0x2d78b98,'I',heap);put(0x2d78d24,'I',heap+0x300);put(heap+0x300,'I',heap+0x400)
calls=[];allow_rotation=False
def guard(uc,a,size,data):
 if a==tramp+0x200:
  sp=uc.reg_read(UC_X86_REG_ESP);ret,pos,forward,up,index=struct.unpack('<5I',uc.mem_read(sp,20));assert index==0
  calls.append({'position':list(struct.unpack('<3f',uc.mem_read(pos,12))),'forward':list(struct.unpack('<3f',uc.mem_read(forward,12))),'up':list(struct.unpack('<3f',uc.mem_read(up,12))),'listener_index':index})
  uc.reg_write(UC_X86_REG_EAX,1);uc.reg_write(UC_X86_REG_ESP,sp+20);uc.reg_write(UC_X86_REG_EIP,ret);return
 # The cached orientation path must never execute yaw/rotation reconstruction.
 assert any(start<=a<end for start,end in areas) or a==tramp+0x100,hex(a)
 assert allow_rotation or not 0x6f7fba<=a<0x6f81d6,('unexpected cache miss',hex(a))
u.hook_add(unicorn.UC_HOOK_CODE,guard)
cases=[]
for position,height,frozen in itertools.product([[0.0,0.0,0.0],[100.0,2400.0,500.0],[-50.0,-200.0,7.5],[7000.0,1500.0,7700.0]],[0.0,500.0,1000.0],[False,True]):
 put(heap+0x10,'f',height);put(heap+0x24,'B',int(frozen));put(heap+0x504,'fff',*position)
 put(0x2d773b4,'fff',0.0,0.0,1.0);put(0x1239614,'fff',0.0,0.0,1.0);put(0x2d77390,'fff',0.0,0.0,1.0);put(0x2d7739c,'fff',0.0,0.0,1.0)
 u.emu_start(tramp+0x100,tramp+0x102);put(stack+0x1800,'I',tramp);u.reg_write(UC_X86_REG_ESP,stack+0x1800);calls.clear();u.emu_start(0x6f7d30,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
 if not frozen:assert calls[0]['position']==[position[0],height,position[2]]
 cases.append({'source_position':position,'listener_height':height,'frozen':frozen,'calls':list(calls)})
orientation_cases=[]
for forward in [[0.,0.,1.],[1.,0.,0.],[0.,1.,0.],[0.,0.,0.],[0.6,-0.8,0.],[0.3,-0.4,0.8660254],[-0.70710677,0.0,0.70710677],[1e-6,0.,0.],[1e-3,0.,0.],[3.,4.,5.],[1000.,-2000.,500.]]:
 put(heap+0x10,'f',500.);put(heap+0x24,'B',0);put(heap+0x504,'fff',100.,2500.,200.)
 put(0x2d773b4,'fff',0.,0.,1.);put(0x1239614,'fff',*forward);put(0x2d77390,'fff',*forward);put(0x2d7739c,'fff',*forward)
 u.emu_start(tramp+0x100,tramp+0x102);put(stack+0x1800,'I',tramp);u.reg_write(UC_X86_REG_ESP,stack+0x1800);calls.clear();u.emu_start(0x6f7d30,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
 assert len(calls)==1
 orientation_cases.append({'cached_forward':forward,'native_up':calls[0]['up'],'native_forward':calls[0]['forward']})
allow_rotation=True
put(heap+0x100+0x84,'I',0x58f1c0)
assert native(0x1139094,4)==struct.pack('<f',90.0)
assert native(0x1138fa8,4)==struct.pack('<f',10.0)
assert native(0x11389ac,4)==struct.pack('<f',1e-5)
table_raw=native(0x10cfab0,3600*4);sin_table=list(struct.unpack('<3600f',table_raw))
rotation_cases=[]
for forward,angle in itertools.product([[0.,0.,1.],[0.3,-0.4,0.8660254],[3.,4.,5.],[0.,0.,0.]],[0.,0.05,0.1,45.,90.,-30.05,360.,721.25,-721.25]):
 previous_input=[4.,5.,6.];previous_forward=[0.,0.,1.]
 put(0x2d77390,'fff',*previous_input);put(0x2d7739c,'fff',*previous_forward);steps=[]
 for vector,pitch in [(forward,angle),(forward,angle+45.),([forward[0]+0.000005,forward[1],forward[2]],angle+90.),([forward[0]+0.01,forward[1],forward[2]],angle+45.)]:
  put(heap+0x14,'f',pitch);put(0x1239614,'fff',*vector)
  put(0x2d773b4,'fff',0.,0.,1.);u.emu_start(tramp+0x100,tramp+0x102);put(stack+0x1800,'I',tramp);u.reg_write(UC_X86_REG_ESP,stack+0x1800);calls.clear();u.emu_start(0x6f7d30,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
  assert len(calls)==1
  steps.append({'input':vector,'angle_degrees':pitch,'native_forward':calls[0]['forward'],'native_up':calls[0]['up'],'cache_input':list(struct.unpack('<3f',u.mem_read(0x2d77390,12)))})
 rotation_cases.append({'initial_input':previous_input,'initial_forward':previous_forward,'steps':steps})
limits=['Native listener update and height getter executed; final audio backend callback stubbed. No audible attenuation or client integration acceptance.','Cached-forward orientation and projected-up normalization qualified; rotation recomputation on cache miss and alternative backend remain unqualified.','Source position is native camera-related object fields +0x104/+0x108/+0x10c; full camera semantics and live Rust coordinate conversion remain to qualify.','Default constructor height 500 is byte-verified; user configuration changes and historical audio settings still to recover.']
limits[1]='Native rotation table and cache recomputation executed for 36 sequences/144 steps. Camera direction source integration and alternative backend remain unqualified.'
result={'schema':1,'default_listener_height':500.0,'cases':cases,'orientation_cases':orientation_cases,'rotation_cases':rotation_cases,'sin_table':sin_table,'sin_table_address':'0x10cfab0','sin_table_sha256':hashlib.sha256(table_raw).hexdigest(),'provenance':{'executable':str(exe),'sha256':hashlib.sha256(b).hexdigest(),'unicorn_version':unicorn.__version__},'limits':limits}
(r/'data/4.20/audio_listener_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
receipt={'passed':True,'native_listener_cases':len(cases),'native_listener_updates':sum(len(c['calls']) for c in cases),'instruction_anchors':len(anchors),'native_cached_orientation_cases':len(orientation_cases),'default_height':500.0,'normalization_constants':{hex(a):native(a,4).hex() for a in constants},'regions':regions,'provenance':result['provenance'],'limits':limits,'complete':False}
receipt.update({'native_rotation_sequences':len(rotation_cases),'native_rotation_steps':sum(len(c['steps']) for c in rotation_cases),'native_sine_table_entries':3600,'native_sine_table_sha256':result['sin_table_sha256']})
(r/'docs/map_ambient_audio_listener_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in receipt.items() if k not in ['regions','provenance','limits']})
