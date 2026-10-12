from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
qpc_stub=vector+0xb000;w(0xfa4134,qpc_stub);w(mode+0x10,0x1000000);counter=0;calls=0

def observe(uc,address,size,user):
 global calls
 if address==0xce298a:finish(0);return
 if address==qpc_stub:
  sp=u.reg_read(UC_X86_REG_ESP);u.mem_write(read(sp+4),struct.pack('<Q',counter));calls+=1;finish(1,4)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
rows=[]
for elapsed,frequency,origin,start,drift in itertools.product([0,1,10000001,2**53+1,2**63+17,2**64-1],[3,10000000,2**53+1],[0,123456],[0.,16.,1024.],[-.125,.125]):
 counter=(origin+elapsed)&((1<<64)-1)
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj)
 u.mem_write(obj+0x2c,struct.pack('<f',start));u.mem_write(obj+0x34,struct.pack('<f',drift));u.mem_write(0x14bef48,struct.pack('<Q',origin));u.mem_write(0x14bef50,struct.pack('<Q',frequency));calls=0
 call(0x99c5e0,obj+0x20,struct.pack('<d',.125));assert calls==1
 rows.append(dict(counter=counter,origin=origin,frequency=frequency,start=start,delta=.125,scale=1.,drift=drift,time_bits=read(obj+0x2c),delta_bits=read(obj+0x30),drift_bits=read(obj+0x34)))
out=dict(complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,limits=['Original993CE0 conversion and99C5E0 resync executed together; QPC OS call supplied by deterministic u64 output and lazy initialization skipped with globals set.','Includes synthetic unsigned conversion/wrap boundaries, not claims about real hardware frequencies.','Unicorn x87 arithmetic requires physical CPU cross-check before rounding-sensitive qualification.'])
(r/'data/4.20/qpc_resync_contract.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'native_composed_cases':len(rows),'qpc_calls_per_case':1}))
