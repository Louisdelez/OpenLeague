from pathlib import Path
import sys,json,struct,hashlib,math
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from unicorn import Uc,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EAX,UC_X86_REG_EIP
p=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');pe=pefile.PE(str(p));base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();u=Uc(UC_ARCH_X86,UC_MODE_32);u.mem_map(base,(len(image)+4095)//4096*4096);u.mem_write(base,image);u.mem_map(0x3000000,0x100000);u.mem_map(0x3100000,4096);u.mem_map(0x3200000,0x100000)
camera=0x3001000;controller=camera+0xe0;service=0x3004000;source=0x3005000;target=source+32;vector=0x3006000;stack=0x300f000;sentinel=0x3100000;allocator=[0x3200000];calls=[]
def f(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def write(a,*v):u.mem_write(a,struct.pack('<'+'I'*len(v),*v))
def floats(a,v):u.mem_write(a,struct.pack('<'+'f'*len(v),*v))
def hook(uc,address,size,user):
 if address not in [0x9933e0,0xc98528]:return
 esp=uc.reg_read(UC_X86_REG_ESP);ret,arg=struct.unpack('<II',bytes(uc.mem_read(esp,8)));calls.append((hex(address),arg))
 if address==0x9933e0:assert arg==16;ptr=allocator[0];allocator[0]+=32;uc.mem_write(ptr,bytes(32));uc.reg_write(UC_X86_REG_EAX,ptr)
 uc.reg_write(UC_X86_REG_ESP,esp+4);uc.reg_write(UC_X86_REG_EIP,ret)
u.hook_add(UC_HOOK_CODE,hook)
write(0x2d78d24,0x3000100);write(0x3000100,camera);write(0x2d78a44,service);u.mem_write(service+0x1e,b'\x01');write(0x14bef40,0);write(0x14bef44,0)
def call(address,args):write(stack,sentinel,*args);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,controller);u.emu_start(address,sentinel,count=10000)
cases=[]
paths=[([7400.,0.,7700.],[2100.,0.,8300.]),([7400.,0.,7700.],[13100.,0.,8200.]),([123.25,-40.,951.75],[-555.,88.,27.5]),([8000.,0.,8000.],[8000.,0.,8000.])]
for start,end in paths:
 for duration in [0.,0.5,3.,7.25]:
  for elapsed in [0.,0.001,0.125,0.5,1.,1.5,2.25,2.999,3.,7.25,10.]:
   allocator[0]=0x3200000;u.mem_write(camera,bytes(512));u.mem_write(vector,bytes(32));write(controller+4,vector,vector,vector+16);floats(source,start);floats(target,end);floats(0x2d78dfc,[100.]);first=len(calls)
   call(0x565e00,[source,target,struct.unpack('<I',struct.pack('<f',duration))[0],1,0]);initial=bytes(u.mem_read(controller,36)).hex();floats(0x2d78dfc,[f(100.+elapsed)]);call(0x5663b0,[])
   actual=list(struct.unpack('<3f',bytes(u.mem_read(camera+0x104,12))));done=bytes(u.mem_read(controller,1))[0]!=0
   now=f(100.+elapsed);deadline=f(100.+duration)
   if duration<=0 or now>=deadline:expected=end
   else:
    t=f(f(now-100.)/f(deadline-100.));t=min(1.,max(0.,t));weight=f(f(3.-f(t*2.))*f(t*t));complement=f(1.-weight);expected=[f(f(f(a)*complement)+f(f(b)*weight)) for a,b in zip(start,end)];expected[1]=0.
   assert struct.pack('<3f',*actual)==struct.pack('<3f',*expected),(start,end,duration,elapsed,actual,expected)
   assert done==(duration<=0 or now>=deadline)
   cases.append(dict(start=start,end=end,duration=duration,elapsed=elapsed,now_bits=struct.unpack('<I',struct.pack('<f',now))[0],initial_state_hex=initial,output_bits=list(struct.unpack('<3I',struct.pack('<3f',*actual))),finished=done,adapter_calls=calls[first:]))
report=dict(source=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),request_address='0x565e00',update_address='0x5663b0',curve_address='0x565f50',cases=cases,complete=False,limits=['Original request, vector append, curve evaluator, update and cleanup executed in isolated memory. Allocation/free endpoints adapted to an isolated heap.','Camera and service descriptors supplied explicitly. Service flag1 bypasses the separate follow-lock side effect; original Lua point conversion, camera owner and renderer initialization not executed.','Original mode1 smoothstep and strict float32 order matched bit-for-bit. Mode2/general keyframe paths and gameplay integration remain open.'])
Path('E:/mapslol3v3/native_camera_pan_contract.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(dict(cases=len(cases),request_and_update_executed=True,bit_exact=True)))
