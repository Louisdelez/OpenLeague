from pathlib import Path
import sys,json,struct,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from unicorn import Uc,UC_ARCH_X86,UC_MODE_32
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_EBP,UC_X86_REG_EAX
d=json.loads(Path('E:/mapslol3v3/native_endgame_getter_locations.json').read_text());p=Path(d['source']);pe=pefile.PE(str(p));base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();rows=[]
for name,start,getter,address,expected in [('pan',0x52df66,0x6a7980,0x123ebf8,3.),('nexus_skin',0x52dfe6,0x6a7990,0x123ec08,3.5),('use_nexus_death_animation',0x52dee6,0x6a7970,0x123ebe8,0)]:
 u=Uc(UC_ARCH_X86,UC_MODE_32);u.mem_map(base,(len(image)+4095)//4096*4096);u.mem_write(base,image);u.mem_map(0x3000000,0x10000);u.mem_map(0x3100000,4096);u.mem_write(0x3100000,b'\xc3');u.reg_write(UC_X86_REG_ESP,0x300f000);u.reg_write(UC_X86_REG_EBP,0x300f100)
 # Execute the actual original scalar initializer store. Registration/allocator prefix not run.
 assert bytes(u.mem_read(start,2))==b'\xc7\x05';u.emu_start(start,start+10,count=1)
 actual=struct.unpack('<f' if name!='use_nexus_death_animation' else '<I',bytes(u.mem_read(address,4)))[0];assert actual==expected
 u.mem_write(0x300f000,struct.pack('<I',0x3100000));u.reg_write(UC_X86_REG_ESP,0x300f000)
 # Store the original x87 return through a separate observation stub, with no getter hooks.
 if name!='use_nexus_death_animation':u.mem_write(0x3100000,b'\xd9\x1d'+struct.pack('<I',0x3000100)+b'\x90');u.emu_start(getter,0x3100007,count=16);returned=struct.unpack('<f',bytes(u.mem_read(0x3000100,4)))[0]
 else:u.emu_start(getter,0x3100000,count=16);returned=u.reg_read(UC_X86_REG_EAX)
 assert returned==expected;rows.append(dict(name=name,initializer_tail=hex(start),getter=hex(getter),global_address=hex(address),value=actual,native_instructions_executed=True))
report=dict(source=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),cases=rows,complete=False,limits=['Actual original scalar initializer store and getter executed in isolated memory. Full runtime initialization/registration and configuration override handling not executed.','Values qualify original default configuration; cinematic camera/motion/audio/native Lua VM not executed.'])
Path('E:/mapslol3v3/native_endgame_default_timing.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report))
