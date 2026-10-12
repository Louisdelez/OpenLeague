"""Execute original voice refresh/seconds RTPC/playing record lookup."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
prior=json.loads((r/'data/4.20/audio_emitter_position_contract.json').read_text());b=Path(prior['provenance']['executable']).read_bytes()
assert hashlib.sha256(b).hexdigest()==prior['provenance']['sha256']
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
areas=[(0x706d70,0x706de1),(0x706f00,0x706f8a),(0xaeb2b0,0xaeb2e4),(0xaeb240,0xaeb2ad),(0xaebca0,0xaebcbb),(0xaf48c0,0xaf4935)]
regions=[]
for a,e in areas:
 blob=p.get_data(a-base,e-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert p.get_data(0x10af100-base,8)==b'seconds\0'
assert struct.unpack('<I',p.get_data(0x10af338+0x24-base,4))[0]==0x706f00
param=0x811c9dc5
for ch in b'seconds':param=((param*16777619)^ch)&0xffffffff
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
mutex_in=struct.unpack('<I',p.get_data(0xfa4424-base,4))[0];mutex_out=struct.unpack('<I',p.get_data(0xfa4428-base,4))[0]
u.mem_write(trap+0x100,b'\xb0\x01\xc3') # time manager readiness
u.mem_write(trap+0x110,b'\xd9\x05'+struct.pack('<I',heap+0x900)+b'\xc3') # time getter fld f32
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def ret(value,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
available=True;queue_result=1;packets=[];logs=[]
def hook(uc,a,n,d):
 if a in [mutex_in,mutex_out]:ret(0,4);return
 if a==0xaea6b0:ret(int(available),0);return
 if a==0xaea430:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];assert ptr==0x10af100
  ret(param,0);return
 if a==0x5bfee0:ret(56,0);return
 if a==0xb05ed0:
  ptr,size=read(u.reg_read(UC_X86_REG_ESP)+4,'II');assert size==56
  msg=u.mem_read(ptr,size);assert struct.unpack_from('<H',msg,2)[0]==2
  packets.append({'type':2,'parameter_id':struct.unpack_from('<I',msg,8)[0],
    'value_bits':struct.unpack_from('<I',msg,12)[0],'object_id':struct.unpack_from('<I',msg,16)[0]})
  ret(queue_result,8);return
 if a==0x5642d0:logs.append('format');ret(0,0);return
 if a==0x5fa170:logs.append('log');ret(0,0);return
 assert any(s<=a<e for s,e in areas) or trap+0x100<=a<trap+0x120,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
voice,time_manager,voice_vt,time_vt,playing_manager,node=[heap+i for i in [0,0x200,0x300,0x400,0x1000,0x2000]]
cases=[]
times=[(0.,0.),(0.,0.125),(1000.25,1001.75),(65536.0625,65536.125),(10.,1.)]
for (start,now),(manager_exists,found,observed),expected,flag,obj,available,queue_result in itertools.product(
 times,[(False,False,0),(True,False,0),(True,True,2),(True,True,123)],[0,2,123],[0,1],[-1,0,123],[False,True],[1,2]):
 u.mem_write(heap,b'\0'*0x3000);put(voice,'I',voice_vt);put(voice+4,'3I',62,obj&0xffffffff,expected)
 put(voice+0x44,'f',start);put(voice+0x48,'BB',flag,0x55)
 put(voice_vt+0x24,'I',0x706f00);put(time_manager,'I',time_vt);put(time_vt+4,'I',trap+0x110);put(time_vt+0x20,'I',trap+0x100)
 put(0x2d791a8,'I',time_manager);put(heap+0x900,'f',now)
 put(0x14a7a2c,'I',playing_manager if manager_exists else 0)
 if found:
  # Nonmatching ID31 precedes playing ID62 in bucket0.
  put(playing_manager,'I',node);put(node+0x20,'I',31);put(node+0x34,'I',node+0x80)
  put(node+0x80+0x20,'I',62);put(node+0x80+8,'I',observed)
 packets.clear();logs.clear();sp=stack+0x8000;put(sp,'I',trap)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0x706d70,trap,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==trap
 lookup=observed if manager_exists and found else 0
 alive=lookup==expected;new_flag=flag if alive else 1
 elapsed_bits=struct.unpack('<I',struct.pack('<f',float(now)-float(start)))[0]
 assert u.reg_read(UC_X86_REG_EAX)&0xff==int(alive)
 assert read(voice+0x48,'BB')==(new_flag,0x55)
 assert len(packets)==int(obj!=-1 and available)
 if packets:assert packets[0]=={'type':2,'parameter_id':param,'value_bits':elapsed_bits,'object_id':obj}
 assert logs==(['format','format','log'] if packets and queue_result!=1 else [])
 cases.append({'start':start,'now':now,'manager_exists':manager_exists,'found':found,'observed_raw':observed,
 'expected_raw':expected,'prior_released':flag,'object_id':obj,'engine_available':available,'queue_result':queue_result,
 'elapsed_bits':elapsed_bits,'packets':packets.copy(),'logs':logs.copy(),'native_return':alive,'native_released':new_flag})
out={'passed':True,'cases':cases,'regions':regions,'provenance':prior['provenance'],'parameter_name':'seconds','parameter_id':param,
 'stubs':['Time manager ready/getter supply explicit f32 timestamps; AEA6B0 availability; AEA430 seconds name hash uses separately qualified FNV1;5BFEE0 size56;B05ED0 captures packet/return; mutex enter/leave no-op; logging format/output captured.'],
 'limits':['Playing-record +8 raw value interpretation is not inferred; native comparison and collision lookup qualified, record creation/destruction not executed.',
 'Time manager not-ready fatal assertion branch excluded. Original clock source units/precision beyond f32 getter inputs unqualified.',
 'RTPC queue consumption/curve bindings and downstream PCM not executed; name seconds does not prove all sounds use this parameter.',
 'Voice constructor capture at +44 and expected field initialization not fully emulated; states supplied explicitly.',
 'No live audible acceptance or registration pipeline.'],'complete':False}
(r/'data/4.20/audio_voice_refresh_contract.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print('Native voice refresh:',len(cases),'cases; seconds parameter',param)