from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
actor=terrain+0x2000;node=terrain+0x5000;spatial=terrain+0x6000;parent=terrain+0x7000
events=[]
def return_call(pop):
 s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4+pop)
def boundary(uc,a,size,user):
 if a==0x95f370:
  assert u.reg_read(UC_X86_REG_ECX)==spatial
  events.append(dict(kind='center',bits=list(struct.unpack('<3I',u.mem_read(spatial,12)))));return_call(0)
 elif a==0x95ff10:
  s=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==parent and read32(s+4)==spatial
  events.append(dict(kind='parent'));return_call(4)
 elif a==0x95f060:
  s=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==node
  events.append(dict(kind='extents',lower_bits=list(struct.unpack('<3I',u.mem_read(read32(s+4),12))),upper_bits=list(struct.unpack('<3I',u.mem_read(read32(s+8),12)))));return_call(8)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
previous=json.loads((r/'data/4.20/grass_actor_aabb_contract.json').read_text(encoding='utf-8'))
boxes=[c['aabb_bits'] for c in previous['cases']]+[[0x80000000,0,0,0,0x80000000,0],[0x7fc12345,0,0,0x3f800000,0x3f800000,0x3f800000]]
cases=[]
for box,cached_mode,present,parent_present in itertools.product(boxes,['zero','exact','offset'],[False,True],[False,True]):
 values=list(struct.unpack('<6f',struct.pack('<6I',*box)))
 roundf=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
 center=[roundf(roundf(values[i]+values[i+3])*.5) for i in range(3)]
 cached=[0.,0.,0.] if cached_mode=='zero' else center if cached_mode=='exact' else [roundf(center[0]+1.),center[1],center[2]]
 u.mem_write(actor,bytes(0x100));u.mem_write(spatial,bytes(0x40));write32(actor+0xcc,node if present else 0);write32(node+8,spatial)
 u.mem_write(actor+0x95,struct.pack('<6I',*box));u.mem_write(spatial,struct.pack('<3f',*cached));write32(spatial+0x28,parent if parent_present else 0)
 initial=list(struct.unpack('<3I',u.mem_read(spatial,12)));events.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x71a5b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(aabb_bits=box,initial_center_bits=initial,node_present=present,parent_present=parent_present,events=list(events),final_center_bits=list(struct.unpack('<3I',u.mem_read(spatial,12)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x71a5b0',native_addresses=len(visited),cases=cases,runtime_adapters=['95F370 center-bound recalculation,95FF10 parent reindex and95F060 local extents boundaries record arguments; downstream spatial structures not mutated in this dispatch probe.'],limits=['Complete71A5B0 dispatcher executes with actual supplied nonnull node/spatial association, including center equality/unordered checks, write-before-call, parent condition and always-extents update.','Downstream index algorithms, actual registration/provider lifecycle and full model-bound producer/camera/live grass rendering remain open. NaN behavior limited to emulated SSE.'])
(r/'data/4.20/grass_spatial_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
