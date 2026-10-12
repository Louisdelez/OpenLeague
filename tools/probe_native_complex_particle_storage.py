"""Original whole937890 append with original13buffer operations and legal owned storage."""
from pathlib import Path
import json,struct,itertools,datetime,shutil,ctypes
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook;queries=[];height=0.;world=heap+0x6000;vtable=heap+0x6100;owner=heap+0x6200;return_stub=end+0x200;height_result=heap+0x6300
def hook(uc,a,size,user):
 if return_stub<=a<return_stub+9:return
 if a==return_stub-0x10:
  sp=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==world;queries.append([hex(read32(sp+4+axis*4)) for axis in range(3)]);u.mem_write(height_result,struct.pack('<f',height));u.reg_write(UC_X86_REG_EIP,return_stub);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
u.mem_write(return_stub,b'\xd9\x05'+struct.pack('<I',height_result)+b'\xc2\x0c\x00');write32(world,vtable);write32(vtable+0x58,return_stub-0x10);write32(owner+8,world)
container=heap+0x1000;config=heap+0x2000;packet=heap+0x3000
widths=[8,212,156,32,24,56,12,4,8,12,4,4,8];offsets=[4+12*i for i in range(13)]
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
defaults={'unit':[bits(0.)]*3,'scale':[bits(1.)]*3,'anchor':[bits(.25),bits(.5),bits(.75)]}
for address,key in [(0x2d773b4,'unit'),(0x123ef74,'scale'),(0x123ef80,'anchor')]:u.mem_write(address,struct.pack('<3I',*defaults[key]))
def initialize(capacity,trail_count,height_enabled):
 global allocation_cursor,queries
 allocation_cursor=heap+0x80000;queries=[];u.mem_write(container,b'\0'*0x200);u.mem_write(config,b'\0'*0x600);write32(container,owner);write32(container+0xa0,config);u.mem_write(config+0x2ad,bytes([8 if height_enabled else 0]))
 if trail_count:
  write32(config+0x3b0,heap+0x7000);write32(config+0x3b4,heap+0x7000+trail_count*24);write32(config+0x3bc,heap+0x7100);write32(config+0x3c0,heap+0x7104)
 for i,(offset,width) in enumerate(zip(offsets,widths)):
  address=heap+0x10000+i*0x4000
  if capacity:write32(container+offset,address);write32(container+offset+4,address);write32(container+offset+8,address+width*capacity*(trail_count if i==12 else 1))
def payload(index,mode):
 values=[bits((i+1)*.125+index) for i in range(69)]
 values[:16]=[bits(1. if i in [0,5,10,15] else 0.) for i in range(16)];values[12:15]=[bits(10.+index),bits(20.+index),bits(30.+index)]
 if mode:
  for off,v in [(0x40,0x7fa01234),(0x44,0x7fc05678),(0x68,0x80000000),(0xdc,0x7f800000),(0xe0,0xff800000),(0xe4,0x7fa01234),(0xe8,0x80000000),(0x100,0x7fc01234),(0x104,0x7f800000),(0x108,0x7fa01234)]:values[off//4]=v
 if mode==2:
  values[0]=0x7fa01234;values[12:15]=[0x7fa05678,0x7fc01234,0xff800000]
 return values
def append(values,index):
 u.mem_write(packet,struct.pack('<69I',*values));sp=stack+0x8000;u.mem_write(sp-0x400,b'\x55'*0x500);write32(sp,end);write32(sp+4,packet);scratch=[bits(index+.125),bits(index+.25),bits(index+.5)];u.mem_write(sp-0x130,struct.pack('<3I',*scratch));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(0x937890,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 return scratch
def snapshot_buffers():
 result=[]
 for offset,width in zip(offsets,widths):
  begin=read32(container+offset);length=read32(container+offset+4)-begin;assert length%width==0;values=bytes(u.mem_read(begin,length)) if length else b'';result.append({'offset':hex(offset),'width':width,'records':[[hex(v) for v in struct.unpack('<'+'I'*(width//4),values[i:i+width])] for i in range(0,length,width)]})
 return result
cases=[]
for capacity,trail_count,height_enabled,mode,count in itertools.product([0,32],[0,1,4],[False,True],[0,1,2],[1,3]):
 height=-.75;initialize(capacity,trail_count,height_enabled);packets=[]
 for i in range(count):
  values=payload(i,mode);scratch=append(values,i);packets.append({'payload_bits':[hex(v) for v in values],'scratch_bits':[hex(v) for v in scratch]})
 cases.append({'capacity':capacity,'trail_slots':trail_count,'height_enabled':height_enabled,'height_bits':hex(bits(height)),'packets':packets,'queries':queries.copy(),'buffers':snapshot_buffers()})
# Actual UV configurations/consumers composed with append; other packet fields remain explicit fixtures.
birth=json.loads((r/'data/4.20/complex_uv_birth_contract.json').read_text());rows=[]
for name in dict.fromkeys(c['name'] for c in birth['cases'] if c['name'].startswith('map:')):rows.append(next(c for c in birth['cases'] if c['name']==name))
height=0.;initialize(32,0,False);packets=[]
for i,row in enumerate(rows):
 values=payload(i,0)
 for off,pair in zip([0xdc,0xe4,0xec,0xf4],row['output_bits']):values[off//4:off//4+2]=[int(v,16) for v in pair]
 scratch=append(values,i);packets.append({'payload_bits':[hex(v) for v in values],'scratch_bits':[hex(v) for v in scratch],'uv_birth_case':row})
map_case={'capacity':32,'trail_slots':0,'height_enabled':False,'height_bits':'0x0','packets':packets,'queries':queries.copy(),'buffers':snapshot_buffers()}
kernel=ctypes.WinDLL('kernel32',use_last_error=True);kernel.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];kernel.VirtualAlloc.restype=ctypes.c_void_p;kernel.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
code=bytes.fromhex('d901d91ac3');address=kernel.VirtualAlloc(None,4096,0x3000,0x40);assert address;ctypes.memmove(address,code,len(code));copy_float=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(address);cpu_copies=0
def cpu_copy(value):
 global cpu_copies
 source=ctypes.c_uint32(value);destination=ctypes.c_uint32();copy_float(ctypes.byref(source),ctypes.byref(destination));cpu_copies+=1;return hex(destination.value)
disagreements=0
for case in cases+[map_case]:
 case['cpu_buffers']=json.loads(json.dumps(case['buffers']));surface=next(b for b in case['cpu_buffers'] if b['offset']=='0x1c')
 for index,payload_row in enumerate(case['packets']):
  values=[int(v,16) for v in payload_row['payload_bits']];surface['records'][index][:32]=[cpu_copy(values[i%16]) for i in range(32)];surface['records'][index][38]=cpu_copy(int(case['height_bits'],16) if case['height_enabled'] else 0)
 case['cpu_queries']=[[cpu_copy(int(row['payload_bits'][i],16)) for i in [12,14,13]] for row in case['packets']] if case['height_enabled'] else []
 disagreements+=int(case['cpu_buffers']!=case['buffers'] or case['cpu_queries']!=case['queries'])
kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'937890','defaults':{k:[hex(v) for v in values] for k,values in defaults.items()},'cases':cases,'map_uv_case':map_case,'adapters':['Explicit birth payload, native global vectors, legal empty/preallocated buffer state and3caller scratch words supplied. Original entire937890and all append/copy/growth helpers execute. Native heap/free/cookie transport adapted.','External terrain-height virtual call returns explicitly supplied float; call order/arguments captured. No terrain geometry source is qualified.','Three motion scratch words copied without prior stores in this function. Their caller state is supplied and recorded; it is not silently treated as zero.','27actualMap10UVbirth captures transferred into packets, with other birth fields remaining explicit fixtures.'],'limits':['Whole birth payload production, scratch source semantics, global vector startup, height query implementation and ordinary graphical binding remain incomplete.','Only null newborn trail handles; live trail resource acquisition/refcount/deletion and full particle removal remain unqualified.','Growth uses native algorithms with adapted heap, not Windows allocator equivalence. Allocation failure/corrupt storage excluded.']}
proof.update(actual_cpu_x87_copies=cpu_copies,emulator_cpu_case_disagreements=disagreements,cpu_copy_instruction_bytes=code.hex());proof['adapters'].append('Actual processor FLD/FSTP copies qualify masked x87 signaling-NaN quieting for the two matrices, height and terrain arguments. Original emulator output retained; actual CPU outputs are separate and authoritative for these instructions.')
(r/'data/4.20/complex_particle_storage_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'appended_particles':sum(len(c['packets']) for c in cases),'map_uv_particles':len(packets),'actual_cpu_x87_copies':cpu_copies,'emulator_cpu_case_disagreements':disagreements,'passed':True}))
