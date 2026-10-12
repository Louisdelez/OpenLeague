from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
slots=vector+0x19000;sentinel=vector+0x19100;pending=vector+0x1a000;initial=vector+0x1a100;active=vector+0x1a200;visible=vector+0x1a300
observed=[];destructor=read(0x10a4960+8)
def removal_hook(uc,a,size,user):
 if a==0x6c9360:
  assert read(slots)==0 and read(0x2d62910)==initial and read(0x2d6291c)==active
  observed.append('cleanup_after_registry_removal')
 if a==destructor:
  observed.append('destructor');finish(0,4)
u.hook_add(unicorn.UC_HOOK_CODE,removal_hook)
rows=[]
for queued,resource_live in itertools.product([False,True],[False,True]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20)]:u.mem_write(a,bytes(n))
 live=True;w(0x2d628c0,0);u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',1.,2.,3.));run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 w(control+4,30 if resource_live else 0);w(control+8,30);w(troy+0x144,0)
 w(wrapper+8,0x10000);w(wrapper+0xfc,0);u.mem_write(wrapper+0xad,b'\0');w(sentinel,sentinel)
 for a,v in [(0x2d62878,0),(0x2d628c0,slots),(slots,wrapper),(0x2d628c8,1),(0x2d628cc,0xffffffff),(0x2d62924,sentinel),(0x2d62900,pending),(0x2d62904,pending+4*int(queued)),(0x2d62908,pending+64),(0x2d6290c,initial),(0x2d62910,initial+4),(0x2d62914,initial+64),(0x2d62918,active),(0x2d6291c,active+4),(0x2d62920,active+64),(0x2d628e8,visible),(0x2d628ec,visible)]:w(a,v)
 w(pending,wrapper);w(initial,wrapper);w(active,wrapper);observed=[]
 result=run(0x717af0,0,[wrapper])
 assert result==1 and read(0x2d628c8)==0 and read(0x2d628cc)==0
 assert read(0x2d62904)==pending and observed==['cleanup_after_registry_removal','destructor']
 assert read(troy+0x144)==(0x400 if resource_live else 0)
 rows.append(dict(queued=queued,resource_live=resource_live,events=observed.copy(),stop_requests=read(troy+0x144),wrapper_link=read(wrapper+0x11c)))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Whole717AF0 removes queue/init/active memberships and slot before original6C9360 cleanup.','Live resource receives400 stop request, expired resource does not; destructor invoked afterward and count decremented.'],adapters=['Final virtual8 destructor intercepted; wrapper heap/free and spatial teardown excluded.','Empty name index and visibility list; preallocated vectors, supplied registry and resource weak counts.'],limits=['Frame-phase ordering relative to particle simulation remains open.','No general destructor, memory lifetime or graphical acceptance claim.'])
(r/'data/4.20/projectile_deregistration_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS4 native deregistration and particle-stop scenarios')
