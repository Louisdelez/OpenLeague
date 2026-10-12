from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
qpc=vector+0xb000;w(0xfa4134,qpc);counter=0;stats=0

def observe(uc,address,size,user):
 global stats
 if address==0xce298a:finish(0)
 elif address==qpc:
  sp=u.reg_read(UC_X86_REG_ESP);u.mem_write(read(sp+4),struct.pack('<Q',counter));finish(1,4)
 elif address==0x8c7b80:stats+=1;finish(0)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
w(0x2d79078,0);u.mem_write(0x2d78e00,b'\0');w(0x2d78dc0,0);w(0x2d791a8,obj)
u.mem_write(0x14bef48,struct.pack('<Q',0));u.mem_write(0x14bef50,struct.pack('<Q',10000000))
rows=[]
for counter,previous,scale in itertools.product([0,1000,2500,10000,1000000],[0.,.125],[0.,.5,1.,2.]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);u.mem_write(obj+0x38,b'\1');u.mem_write(obj+0x10,struct.pack('<d',scale));u.mem_write(0x2d78dfc,struct.pack('<f',previous));stats=0
 call(0x586350,0)
 delta=struct.unpack('<f',u.mem_read(0x123eeb8,4))[0];minimum=struct.unpack('<f',struct.pack('<I',0x3983126f))[0]
 expected=max(struct.unpack('<f',struct.pack('<f',counter/10000000-previous))[0],minimum)
 assert delta==expected,(counter,previous,delta,expected)
 assert struct.unpack('<f',u.mem_read(obj+0x30,4))[0]==struct.unpack('<f',struct.pack('<f',delta*scale))[0]
 rows.append(dict(counter=counter,previous=previous,scale=scale,source_delta=delta,time_bits=read(obj+0x2c),delta_bits=read(obj+0x30),stats_calls=stats))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),dispatcher='0x586350',embedded_update='0x99c5e0',cases=rows,limits=['Normal frame branch only; frame limiter disabled.','QPC OS output supplied, lazy initialization bypassed; statistics routine8C7B80 stubbed, post-frame manager null.','Primary validity flag supplied true; source previous wall timestamp supplied.','No live client integration claimed.'])
(r/'data/4.20/game_clock_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows))))
