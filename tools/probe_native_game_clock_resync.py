from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
wall=vector+0xa000
# Deterministic supplied wall time; original wall-counter provider is separate.
u.mem_write(0x993ce0,b'\xdd\x05'+struct.pack('<I',wall)+b'\xc3')
w(mode+0x10,0x1000000);visited=set()
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a))
upper=struct.unpack('<f',u.mem_read(0x1138c78,4))[0];lower=struct.unpack('<f',u.mem_read(0x1138c70,4))[0]
rows=[]
for scale,start,dt,wall_time,drift in itertools.product([0.,.5,lower-2**-26,lower,1.,upper,upper+2**-26,2.],[0.,16.],[0.,.125],[0.,.0625,16.,16.25,32.],[-.125,0.,.125]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj)
 for off,value in [(0x10,scale)]:u.mem_write(obj+off,struct.pack('<d',value))
 for off,value in [(0x2c,start),(0x34,drift)]:u.mem_write(obj+off,struct.pack('<f',value))
 u.mem_write(wall,struct.pack('<d',wall_time));visited.clear();call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
 rows.append(dict(scale=scale,start=start,delta=dt,wall=wall_time,drift=drift,time_bits=read(obj+0x2c),delta_bits=read(obj+0x30),drift_bits=read(obj+0x34),corrected=0x99c65b in visited,drift_reset=0x99c66f in visited))
assert any(x['corrected'] for x in rows) and any(x['drift_reset'] for x in rows)
out=dict(complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x99c5e0',scale_lower=lower,scale_upper=upper,cases=rows,limits=['Wall-time function replaced in emulator memory by deterministic supplied f64; original performance-counter provider not yet qualified.','Callback absent; finite supplied profiles and default x87 control.'])
(r/'data/4.20/game_clock_resync_contract.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'cases':len(rows),'corrected':sum(x['corrected'] for x in rows),'drift_reset':sum(x['drift_reset'] for x in rows),'scale_band':[lower,upper]}))
