"""Execute original Complex count finalizer, 934763..93485D."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0]
exec(compile(setup,'native setup','exec'))
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000;scales=heap+0x5000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def signed(v):return v if v<0x80000000 else v-0x100000000
def run(time,elapsed,period,owner_start,last_emission,rate,owner_scale,limit,emitted,flag74,flag334):
 u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);u.mem_write(scales,b'\0'*0x200)
 for address,value in [(instance,scales),(instance+4,owner),(instance+8,config),(instance+0x118,emitted),(config+0x314,limit),(config+0x334,flag334)]:write32(address,value&0xffffffff)
 for address,value in [(instance+0x78,last_emission),(owner+0xa8,owner_start),(config+0x308,period),(scales+0xec,owner_scale)]:write32(address,bits(value))
 u.mem_write(instance+0x74,bytes([flag74]))
 frame=stack+0x8000;sp=stack+0x7000
 for address,value in [(frame+8,time),(frame-0x10,elapsed),(frame-8,rate)]:write32(address,bits(value))
 write32(frame,end);write32(frame+4,end)
 for off in (0,4,8):write32(sp+off,0)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,instance);u.reg_write(UC_X86_REG_EBX,owner)
 u.emu_start(0x934763,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'inputs':{'time':hex(bits(time)),'elapsed':hex(bits(elapsed)),'period':hex(bits(period)),'owner_start':hex(bits(owner_start)),'last_emission':hex(bits(last_emission)),'rate':hex(bits(rate)),'owner_scale':hex(bits(owner_scale)),'limit':limit,'emitted':emitted,'flag74':flag74,'flag334':flag334},'count':signed(u.reg_read(UC_X86_REG_EAX))}
cases=[]
for rate,scale,time,flags in itertools.product([-10.,-1.,0.,.1,1.,3.,10.,100.],[0.,.5,1.,2.],[-1.,0.,.01,.1,.5,1.,2.,5.],[(0,0),(0,1),(1,0),(1,1)]):
 cases.append(run(time,time,2.,0.,0.,rate,scale,10,3,*flags))
for period,elapsed,last,limit,emitted in itertools.product([.1,1.,2.],[-1.,0.,.1,1.,2.,5.],[-1.,0.,.2,2.],[-1,0,1,3,10],[0,2,20]):
 cases.append(run(elapsed+10,elapsed,period,10.,last+10,3.,1.,limit,emitted,1,0))
special=[struct.unpack('<f',struct.pack('<I',v))[0] for v in (0x80000000,0x7f800000,0xff800000,0x7fc01234,0x7f7fffff)]
for field in ('time','elapsed','period','owner_start','last_emission','rate','owner_scale'):
 for value in special:
  arguments=dict(time=2.,elapsed=2.,period=1.,owner_start=0.,last_emission=0.,rate=3.,owner_scale=1.,limit=10,emitted=0,flag74=1,flag334=0);arguments[field]=value;cases.append(run(**arguments))
for emitted in (2147483647,-2147483648,-1):cases.append(run(1.,1.,1.,0.,0.,3.,1.,1,emitted,1,0))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['0x934763','0x93485d'],'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Caller frame, effective sampled rate, owner/type multiplier, timing, limits and flags supplied. Entire downstream original count branch executes; no arithmetic replacement.'],'limits':['Effective rate production, movement-rate branch, owner/type multiplier sources and live emitted counter updates not qualified.','Count function prologue and sampled parameters excluded; full emitter lifecycle and ordinary rendering incomplete.']}
(r/'data/4.20/complex_emission_count_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'positive':sum(c['count']>0 for c in cases),'zero':sum(c['count']==0 for c in cases),'negative':sum(c['count']<0 for c in cases),'passed':True}))
