"""Original birth scheduling and final lifetime; transforms/other fields excluded."""
from pathlib import Path
import struct,json,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000;frame=stack+0x8000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def fv(v):return struct.unpack('<f',struct.pack('<I',v))[0]
def start(addr,stop):
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_EDI,instance);u.emu_start(addr,stop,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop
def reset():
 u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);write32(instance+8,config);write32(frame-0x2c,owner)
def schedule(time,previous,count,index):
 reset();prev=[-2.,1.,5.];current=[4.,-3.,9.]
 for axis in range(3):write32(owner+0x84+axis*4,bits(prev[axis]));write32(owner+0x90+axis*4,bits(current[axis]))
 write32(instance+0x80,bits(previous));write32(frame+8,bits(time));write32(frame+12,count);write32(frame-0x48,0);write32(frame-0x28,0)
 start(0x935324,0x9353d6);u.reg_write(UC_X86_REG_EDX,index);u.reg_write(UC_X86_REG_ECX,owner)
 start(0x935543,0x9355b0)
 position=[hex(read32(frame-off)) for off in (0x110,0x10c,0x108)];fraction=hex(read32(frame-0x10))
 u.reg_write(UC_X86_REG_ESI,config);start(0x9355b5,0x9355e8)
 return {'time':hex(bits(time)),'previous':hex(bits(previous)),'count':count,'index':index,'previous_position':prev,'current_position':current,'fraction':fraction,'position':position,'birth_time':hex(read32(frame-0xb0))}
schedule_cases=[]
for time,previous,count in itertools.product([-2.,0.,.1,1.,10.],[-3.,0.,.05,1.,fv(0xff7fffff)],[1,2,3,7,100]):
 for index in sorted(set([0,count//2,count-1])):schedule_cases.append(schedule(time,previous,count,index))
def life(value,scale,enabled,velocity,coefficients,flags):
 reset();write32(frame-0x34,bits(value));write32(owner+0x80,bits(scale));u.mem_write(config+0xec,bytes([enabled]));write32(config+0x304,flags)
 for axis in range(3):write32(frame-0x7c+axis*4,bits(velocity[axis]));write32(config+0x2f5+axis*4,bits(coefficients[axis]))
 start(0x935d2e,0x935e4b)
 return {'life':hex(bits(value)),'scale':hex(bits(scale)),'enabled':enabled,'velocity':[hex(bits(v)) for v in velocity],'coefficients':[hex(bits(v)) for v in coefficients],'flags':flags,'output':hex(read32(frame-0x34))}
life_cases=[]
for value,scale,enabled,coefficients,flags in itertools.product([-2.,-0.,0.,.1,1.,10.],[-1.,0.,.5,2.],[0,1],[[0.,0.,0.],[.2,-.5,1.]],[0,1,2,4,7]):life_cases.append(life(value,scale,enabled,[-2.,3.,-4.],coefficients,flags))
for raw in (0x7f800000,0xff800000,0x7fc01234,0xffc01234,0x7f7fffff):
 value=fv(raw)
 life_cases.extend([life(value,1.,1,[-2.,3.,-4.],[0.,0.,0.],0),life(1.,value,1,[-2.,3.,-4.],[0.,0.,0.],0),life(1.,1.,0,[value,3.,-4.],[1.,.5,-1.],7)])
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragments':['935324..9353D6','935543..9355B0','9355B5..9355E8','935D2E..935E4B'],'schedule_cases':schedule_cases,'life_cases':life_cases,'original_instruction_addresses':len(visited),'adapters':['Legal native caller locals, owner previous/current positions, timing, already sampled life, scale and configuration supplied. Original sentinel selection, batch fraction, position/time interpolation and lifetime operations execute.'],'limits':['Parent transform8DF790 and fullbirth lifecycle excluded. Life input has already been sampled; probability/RNG order between other birth fields not qualified here.','Raw owner source semantics, field lexical readers and ordinary rendering not qualified.']}
(r/'data/4.20/complex_birth_timing_life_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'schedule_cases':len(schedule_cases),'life_cases':len(life_cases),'passed':True}))
