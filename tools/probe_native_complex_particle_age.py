"""Three original per-particle age producers for movement/surface/color."""
from pathlib import Path
import struct,json,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;stop_address=None
def hook(uc,address,size,user):
 if address==stop_address:uc.emu_stop();return
 previous_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
container=heap+0x1000;pairs=heap+0x3000;frame=stack+0x8000;sp=stack+0x7000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def fv(v):return struct.unpack('<f',struct.pack('<I',v))[0]
def start(address,stop):
 global stop_address
 stop_address=stop
 try:u.emu_start(address,stop,count=10000)
 except Exception:
  print({'start':hex(address),'stop':hex(stop),'eip':hex(u.reg_read(UC_X86_REG_EIP)),'eax':hex(u.reg_read(UC_X86_REG_EAX)),'ecx':hex(u.reg_read(UC_X86_REG_ECX))});raise
 assert u.reg_read(UC_X86_REG_EIP)==stop
def run(time,birth,life):
 u.mem_write(container,b'\0'*0x200);write32(container+4,pairs);write32(pairs,bits(birth));write32(pairs+4,bits(life));output={}
 for kind in ('movement','surface','color'):
  u.mem_write(frame-0x100,b'\0'*0x200);u.mem_write(sp,b'\0'*0x100);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EAX,pairs)
  if kind=='movement':
   u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_XMM0,0);u.reg_write(UC_X86_REG_XMM3,bits(time));start(0x938a5a,0x938aad);normalized=read32(frame-0x20);elapsed=u.reg_read(UC_X86_REG_XMM0)&0xffffffff
  elif kind=='surface':
   u.reg_write(UC_X86_REG_ESI,container);u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_XMM1,0);u.reg_write(UC_X86_REG_XMM3,bits(time));start(0x93949a,0x9394d7);normalized=read32(frame-0xc);u.reg_write(UC_X86_REG_EAX,pairs);u.reg_write(UC_X86_REG_ECX,0);start(0x9394a8,0x9394b0);elapsed=u.reg_read(UC_X86_REG_XMM0)&0xffffffff
  else:
   u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_EDX,0);u.reg_write(UC_X86_REG_XMM3,0);u.reg_write(UC_X86_REG_XMM1,bits(1.));u.reg_write(UC_X86_REG_XMM4,bits(time));start(0x939b94,0x939be9);normalized=read32(sp+8);elapsed=u.reg_read(UC_X86_REG_XMM0)&0xffffffff
  output[kind]={'normalized_bits':hex(normalized),'elapsed_bits':hex(elapsed)}
 return {'time':hex(bits(time)),'birth':hex(bits(birth)),'life':hex(bits(life)),'outputs':output}
maximum=fv(0x7f7fffff);nan=fv(0x7fc01234);inf=float('inf')
cases=[run(time,birth,life) for time,birth,life in itertools.product([-2.,0.,.1,1.,2.,maximum,inf,nan],[-1.,0.,.1,1.,maximum,inf,nan],[-1.,-0.,0.,.1,1.,2.,maximum,inf,-inf,nan])]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragments':['938A5A..938AAD','93949A..9394D7','9394A8..9394B0','939B94..939BE9'],'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Legal SoA container and birth/life pair supplied; original three normalized-age producers and elapsed subtraction execute. No math replacement.'],'limits':['Only age arithmetic and range selection; actual movement, material/color updates, particle expiry/removal and storage ordering remain incomplete.','Whole per-frame scheduling and ordinary graphical integration not qualified.']}
(r/'data/4.20/complex_particle_age_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'consumer_paths':3,'outputs':len(cases)*3,'passed':True}))
