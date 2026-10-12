from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
log_calls=0;counter_snapshots=[]
def boundary(uc,a,size,user):
 global log_calls
 if a==0x5fa170:
  log_calls+=1;s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s))
  u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0x8f361e:counter_snapshots.append([u.reg_read(UC_X86_REG_EDI),read32(u.reg_read(UC_X86_REG_EBP)-0x14)])
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
patterns=[[0]*64,[1]*64,[2]*64,[3 if i%3==0 else 1 if i%2 else 2 for i in range(64)],[1 if i%8>=4 else 0 for i in range(64)]]
for pattern,size,position,radius in itertools.product(range(5),[10.,32.,50.],[[0.,0.],[25.,25.],[-50.,-50.],[800.,800.]],[34.999996,35.,500.,501.,float('inf'),float('nan'),-1.]):
 for off,value in [(0x314,size),(0x318,1./size),(0x320,size*.5)]:f(terrain+off,value)
 for i,flag in enumerate(patterns[pattern]):u.mem_write(cells+i*56+50,struct.pack('<H',flag))
 write32(sp,end);u.mem_write(sp+4,struct.pack('<3f',*position,radius));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,terrain)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 before=log_calls;counter_snapshots.clear();u.emu_start(0x8f3390,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(pattern=pattern,cell_size=size,position_bits=list(struct.unpack('<2I',struct.pack('<2f',*position))),radius_bits=struct.unpack('<I',struct.pack('<f',radius))[0],result=bool(u.reg_read(UC_X86_REG_EAX)&255),budget_log_calls=log_calls-before,counters=list(counter_snapshots)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x8f3390',native_addresses=len(visited),patterns=patterns,cases=cases,runtime_adapters=['Diagnostic logging5FA170 boundary returns; original exhausted-budget control flow and count-based result execute.'],limits=['Supplied8x8 flag grids, threecell sizes, finite positions and radius boundary/NaN/infinity. Original terrain predicate executes; original disk loader and actor producer not executed here.','No renderer integration or full-game acceptance.'])
(r/'data/4.20/grass_terrain_budget_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),budget_exhausted=sum(bool(c['budget_log_calls']) for c in cases))))
