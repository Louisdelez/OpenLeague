from pathlib import Path
import struct,json,datetime,hashlib,math,sys
r=Path('E:/OpenLeague')
sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,unicorn
from unicorn.x86_const import *
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');native=exe.read_bytes();digest=hashlib.sha256(native).hexdigest();pe=pefile.PE(data=native);mapped=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(mapped)+4095)&~4095);u.mem_write(base,mapped)
terrain=0x40000000;u.mem_map(terrain,0x10000);stack=0x20000000;u.mem_map(stack,0x10000);sp=stack+0x8000;end=base+0x100;visited=set()
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a))
def write32(a,v):u.mem_write(a,struct.pack('<I',v))
def read32(a):return struct.unpack('<I',u.mem_read(a,4))[0]
sources=[]
intact=json.loads((r/'docs/intact_structure_animation_inventory.json').read_text(encoding='utf-8'))
for m in intact['records']:
 blends=[f for f in m['files'] if f['kind']=='.blnd'];assert len(blends)==1;sources.append((m['alias'],Path(blends[0]['path'])))
destroyed=json.loads((r/'docs/destroyed_animation_source_audit.json').read_text(encoding='utf-8'))
sources.extend((name,Path(m['blend'])) for name,m in destroyed['models'].items())
runtime=terrain+0x3000;payload=terrain+0x4000;out=terrain+0x5000;capture=0x400200
# Adapter only stores the original x87 return value as a float32.
u.mem_write(capture,b'\xd9\x1d'+struct.pack('<I',out)+b'\xc3')
records=[]
for name,path in sources:
 raw=path.read_bytes();assert raw[:8]==b'r3d2blnd';states=[]
 # Bound native simple clip nodes by the serialized size/kind/name/payload fields.
 for offset in range(0,len(raw)-64,4):
  size,kind,identifier,name_rel,payload_rel=struct.unpack_from('<5I',raw,offset)
  if size not in [72,76] or kind not in [0,2] or name_rel!=20 or payload_rel not in [28,32,36,40]:continue
  end_name=raw.find(b'\0',offset+20);state_name=raw[offset+20:end_name]
  if not state_name or any(c not in b'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_' for c in state_name):continue
  data=offset+payload_rel
  if data+24>len(raw):continue
  atomic_kind,start,finish,step,index,events=struct.unpack_from('<IIIfII',raw,data)
  if atomic_kind!=1 or not math.isfinite(step) or step<=0:continue
  u.mem_write(runtime,bytes(0x80));write32(runtime+0x2c,payload);u.mem_write(payload,raw[data:data+24]);write32(sp,capture);write32(sp+4,end)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,runtime);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x8890c0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
  bits=read32(out);value=struct.unpack('<f',struct.pack('<I',bits))[0];expected=struct.unpack('<f',struct.pack('<f',(finish-start)*step))[0];assert value==expected
  clocks=[]
  for fraction in [0.,.125,.5,.875,1.]:
   elapsed=struct.unpack('<f',struct.pack('<f',value*fraction))[0];u.mem_write(runtime+0xc,struct.pack('<f',elapsed));write32(sp,capture);write32(sp+4,end)
   u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,runtime);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x889130,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
   frame_bits=read32(out);frame=struct.unpack('<f',struct.pack('<I',frame_bits))[0];assert abs(frame-elapsed/step)<1e-4
   clocks.append(dict(elapsed_bits=struct.unpack('<I',struct.pack('<f',elapsed))[0],native_frame_bits=frame_bits))
  states.append(dict(name=state_name.decode(),serialized_record_kind=kind,node_offset=offset,payload_offset=data,frame_start=start,frame_end=finish,time_step=step,animation_index=index,event_reference_raw=events,native_period_bits=bits,native_period_seconds=value,clock_cases=clocks))
 assert len(states)==3,(name,len(states));records.append(dict(model=name,blend=str(path),blend_sha256=hashlib.sha256(raw).hexdigest(),states=states))
 print(json.dumps(dict(model=name,periods={s['name']:s['native_period_seconds'] for s in states})),flush=True)
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x8890c0',clock_entry='0x889130',native_vtable='0x10c8918 +0x34',native_addresses=len(visited-{capture,capture+6}),models=records,limits=['Original full period getter and frame clock executed for48authored simple clip state payloads and240elapsed samples. Runtime object/data pointer supplied directly; loader/constructor/state selector not executed.','x87 return captured asfloat32 by adapter at emulator-only header address400200. Actual original ANM pose interpolation, loop gates and event callbacks remain unqualified.'])
(r/'data/4.20/structure_clip_period_contract.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
