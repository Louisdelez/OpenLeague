from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
refresh_source=(r/'tools/probe_fow_restricted_filter_generated.py').read_text(encoding='utf-8')
prefix=refresh_source.split('\ncases=[]')[0]
prefix=prefix.replace("captures.append(dict(counts=", "captures.append(dict(refresh_before=read32(0x2d7c074),cached_restricted=bool(u.mem_read(0x2d7c070,1)[0]),init_bits=read32(0x2d7c06c),counts=")
exec(compile(prefix,'native view refresh prerequisites','exec'))
def configuration_adapter(uc,a,size,user):
 if a==0x8b1910:adapters.append('view_config_enabled');finish(eax=1)
u.hook_add(unicorn.UC_HOOK_CODE,configuration_adapter)
setup=refresh_source.split(' u.mem_write(0x71000000,bytes(0x10000))')[1].split(' allocation_cursor=')[0]
setup='u.mem_write(0x71000000,bytes(0x10000))'+setup
setup='\n'.join(line[1:] if line.startswith(' ') else line for line in setup.splitlines())
presence='actor';actor_tag=100;flag_ad=True;flag_118=False;flag_24=True;flag_2c=False;descriptor_matches=True
cases=[]
for initial_bits,initial_cached,initial_remaining,sequence in itertools.product([0,1,2,3,4,7],[False,True],[-1,0,1,20],['off','on','pulse']):
 exec(compile(setup,'supplied actor registries','exec'))
 allocation_cursor=heap+0x19000;sources=[];captures.clear();generated.clear();adapters.clear();ticks=5001
 for pointer,size in [(manager,64),(entries,32),(output,24),(view,256),(player,4096),(context,256),(camera_root,16),(camera,512)]:u.mem_write(pointer,bytes(size))
 for address,value in [(manager+4,entries),(manager+8,entries),(manager+0xc,entries+32),(0x2d77f48,player),(0x2d787b8,context),(0x2d798ac,manager),(0x2d78d24,camera_root),(0x2d7c06c,initial_bits),(0x2d7c074,initial_remaining & 0xffffffff),(player+0x18,100),(player+0x17c,0x71007800),(0x71007834,66),(context,0x71007000),(camera_root,camera),(view+0x10,8),(view+0x14,counts),(view+0x18,pixels),(view+0x3c,pending_storage),(view+0x40,pending_storage),(view+0x44,pending_storage+64),(0x14bef50,1000),(0x14bef54,0),(0x14bef48,0),(0x14bef4c,0)]:write32(address,value)
 u.mem_write(0x2d7c070,bytes([initial_cached]));u.mem_write(0x2d7c078,bytes([1]));f(view+0xc,15398.671875)
 for i,center in enumerate([[0.,0.],[1000.,0.],[10000.,10000.]]):
  invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output+8*i,0,55+i,66,100,200.,0,128.,64.,0.,*center))
  obj=read32(output+8*i);sources.append((obj,read32(output+8*i+4)));bp=bits+i*0x100;write32(obj+0x40,bp);u.mem_write(bp,struct.pack('<2I',0x55555555,0x55555555))
  for off,val in [(0xc,1),(0x10,5),(0x14,2),(0x18,6)]:write32(obj+0x40+off,val)
 frames=[]
 for step in range(25):
  restricted=sequence=='on' or sequence=='pulse' and step in [1,2]
  write32(player+0x5e8,0x800 if restricted else 0);captures.clear();generated.clear();adapters.clear();u.mem_write(counts,bytes(64));u.mem_write(pixels,bytes(64))
  for obj,_ in sources:
   u.mem_write(obj+0x44,bytes([0]));u.mem_write(obj+0x45,bytes([0]));invoke(0x6b2d80,obj+0x40,struct.pack('<7I',8,pixels,view+0x14,1,5,2,6))
  invoke(0x6b3fa0,view,struct.pack('<f',3.));assert len(captures)==1
  frames.append(dict(step=step,restricted=restricted,before_processing=captures[0],refresh_after=read32(0x2d7c074),generated=list(generated),adapters=sorted(set(adapters))))
 cases.append(dict(initial_bits=initial_bits,initial_cached=initial_cached,initial_remaining=initial_remaining,sequence=sequence,frames=frames))
selection_cases=[]
for initial in [-2147483648,-3,-2,-1,0,1,2,2147483647]:
 write32(0x1223ebc,initial & 0xffffffff);write32(0x2d7c074,17);values=[]
 for _ in range(8):
  invoke(0x6b2c80,0);assert read32(0x2d7c074)==17
  values.append(struct.unpack('<i',u.mem_read(0x1223ebc,4))[0]);assert u.reg_read(UC_X86_REG_EAX)==read32(0x1223ebc)
 selection_cases.append(dict(initial=initial,values=values,refresh_unchanged=17))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5,0x6b4175,0x6b418f,0x6b41de,0x6b420a,0x6b439b,0x993d0f,0x993d24,0x6b14e0,0x8b1910}),cases=cases,selection_cases=selection_cases,limits=['Original6B3FA0 cache initialization bits1/2/4, player bit11 comparison, counter reset20, clean/applied source enqueue gates and positive-only decrement execute. Original6B2C80 selector cycle executes64steps without touching refresh counter.','Actor registries, descriptors and matching identifiers supplied. Spectator false, QPC/clock, allocator and configuration reader(enabled=true) boundaries adapted.','Each tick supplies/reapplies the same clean stencil via original6B2D80; generation boundary records requests only. This isolates state transitions; no continuous actual terrain/GPU generation.','One view called per tick here. Shared global counter advances per view call; complete multi-view initialization/lifetime and live gameplay binding remain open.'])
(r/'data/4.20/fow_view_refresh_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(sequences=len(cases),updates=sum(len(c['frames']) for c in cases),native_addresses=proof['native_addresses'])))
