"""Execute game listener packing, Wwise orthogonalization and table setter."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn,capstone
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
assert struct.unpack('<I',p.get_data(0x10af384+0x74-base,4))[0]==0x705e30
assert struct.unpack('<I',p.get_data(0x10af384+0x70-base,4))[0]==0x586220
assert p.get_data(0xb07569-base,5).hex()=='e8422b0100'
areas=[(0x705e30,0x705f1f),(0x586220,0x586223),(0xaeb0e0,0xaeb177),(0xb05340,0xb0535f),(0xb053f0,0xb05460),(0xb1a0b0,0xb1a15a),(0xb052b0,0xb05310)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob),(hex(start),hex(end),sum(i.size for i in ins),len(blob))
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
u.mem_write(trap+0x100,b'\xdb\xe3');messages=[]
def hook(uc,a,n,d):
 if a in [0xb08990,0xb05ed0,0xc975f5]:
  sp=uc.reg_read(UC_X86_REG_ESP);ret=struct.unpack('<I',uc.mem_read(sp,4))[0];extra=0
  if a==0xb05ed0:
   ptr=struct.unpack('<I',uc.mem_read(sp+4,4))[0];message=uc.mem_read(ptr,0x38);assert struct.unpack('<H',message[2:4])[0]==16
   messages.append({'index':struct.unpack('<I',message[8:12])[0],'frame':list(struct.unpack('<9f',message[12:48]))});extra=8;uc.reg_write(UC_X86_REG_EAX,1)
  elif a==0xb08990:uc.reg_write(UC_X86_REG_EAX,5)
  uc.reg_write(UC_X86_REG_ESP,sp+4+extra);uc.reg_write(UC_X86_REG_EIP,ret);return
 assert any(x<=a<z for x,z in areas) or a==trap+0x100,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(fn,args,this=0):
 u.emu_start(trap+0x100,trap+0x102);sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(fn,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
inputs=[([0.,0.,1.],[0.,1.,0.]),([.3,-.8,.4],[.1,.8,.6]),([2.,3.,4.],[1.,2.,.5]),([1.,0.,0.],[0.,0.,1.]),([0.,0.,0.],[0.,1.,0.]),([0.,1.,0.],[0.,1.,0.]),([1.,2.,3.],[0.,0.,0.]),([.00001,-.00002,.00003],[.25,-.5,1.])]
initial_frame=[0.,0.,1.,0.,1.,0.,100.,200.,300.];initial_basis=[1.,0.,0.,0.,1.,0.,0.,0.,1.];cases=[]
for enabled,index,(forward,up) in itertools.product([False,True],[0,7,8],inputs):
 position=[7400.,500.,7698.671875];forward=list(struct.unpack('<3f',struct.pack('<3f',*forward)));up=list(struct.unpack('<3f',struct.pack('<3f',*up)))
 for i in range(8):
  address=0x14a7e60+i*0x90;u.mem_write(address,b'\0'*0x90);u.mem_write(address,struct.pack('<9f',*initial_frame));u.mem_write(address+0x24,struct.pack('<f',2.));u.mem_write(address+0x50,struct.pack('<9f',*initial_basis))
 before=bytes(u.mem_read(0x14a7e60,8*0x90));u.mem_write(heap,struct.pack('<I',0x10af384));u.mem_write(heap+0xc,bytes([enabled]));u.mem_write(heap+0x100,struct.pack('<3f',*position));u.mem_write(heap+0x200,struct.pack('<3f',*forward));u.mem_write(heap+0x300,struct.pack('<3f',*up));messages.clear();result=call(0x705e30,struct.pack('<4I',heap+0x100,heap+0x200,heap+0x300,index),heap)&255
 assert result==int(enabled)
 table_result=None;message=messages[0] if messages else None
 if message:
  u.mem_write(heap+0x400,struct.pack('<9f',*message['frame']));table_result=call(0xb1a0b0,struct.pack('<II',index,heap+0x400))
 after=bytes(u.mem_read(0x14a7e60,8*0x90));slot=None
 if enabled and index<8:
  address=0x14a7e60+index*0x90;slot={'frame':list(struct.unpack('<9f',u.mem_read(address,36))),'basis':list(struct.unpack('<9f',u.mem_read(address+0x50,36))),'distance_scale':struct.unpack('<f',u.mem_read(address+0x24,4))[0],'dirty':bool(u.mem_read(address+0x80,1)[0])}
  assert table_result==1 and slot['dirty']
  assert after[:index*0x90]==before[:index*0x90] and after[(index+1)*0x90:]==before[(index+1)*0x90:]
 else:assert after==before
 cases.append({'enabled':enabled,'index':index,'position':position,'forward':forward,'up':up,'api_result':bool(result),'message':message,'table_result':table_result,'table_slot':slot,'unchanged_other_slots':True})
result={'passed':True,'cases':cases,'regions':regions,'provenance':c['provenance'],'initial_frame':initial_frame,'initial_basis':initial_basis,'initial_distance_scale':2.,'anchors':{'game_vtable_listener':'10af384+74->705e30','orientation_enabled':'10af384+70->586220','worker_setter_call':{'address':'0xb07569','bytes':'e8422b0100'}},'stubs':['B08990 tick returns5; B05ED0 captures listener message16 and returns successful enqueue; C975F5 security-cookie check returns. No frame preparation/normalization/table setter stubbed.'],'limits':['Successful queue acceptance followed by isolated setter execution; actual queue worker scheduling not executed.','Available and unavailable backend gates, finite orientation including degenerate vectors, and indices0/7/8 tested. API success reflects queue acceptance, not table index validation.','No live client mixer/panning or full-game acceptance.'],'complete':False}
(r/'data/4.20/audio_listener_backend_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native listener backend:',len(cases),'cases')
