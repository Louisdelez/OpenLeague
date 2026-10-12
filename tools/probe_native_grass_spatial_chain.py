from pathlib import Path
import json,struct,datetime,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
actor=terrain+0x2000;node=terrain+0x5000;spatial=terrain+0x6000;parent=terrain+0x7000;events=[];inputs=set()
collect='--collect' in sys.argv
estimates={} if collect else dict(tuple(map(int,line.split())) for line in Path('E:/mapslol3v3/chain-rsqrt-estimates.txt').read_text(encoding='utf-8-sig').splitlines())
def snapshot(kind):
 return dict(kind=kind,center_bits=list(struct.unpack('<3I',u.mem_read(spatial,12))),local_bits=list(struct.unpack('<6I',u.mem_read(spatial+0x10,24))),radius_bits=read32(spatial+0xc),integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16))))
def boundary(uc,a,size,user):
 if a==0x5fa7dd:
  value=u.reg_read(UC_X86_REG_XMM3)&0xffffffff;inputs.add(value)
  if not collect:
   assert value in estimates,hex(value)
   old=u.reg_read(UC_X86_REG_XMM1);u.reg_write(UC_X86_REG_XMM1,(old&~0xffffffff)|estimates[value])
 elif a==0x95f370:events.append(snapshot('bounds'))
 elif a==0x95f060:events.append(snapshot('extents'))
 elif a==0x95ff10:
  s=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==parent and read32(s+4)==spatial
  events.append(snapshot('parent'));u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+8)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
previous=json.loads((r/'data/4.20/grass_spatial_compound_contract.json').read_text(encoding='utf-8'))
cases=[]
for c in previous['cases']:
 u.mem_write(actor,bytes(0x100));u.mem_write(spatial,bytes(0x40));write32(actor+0xcc,node if c['node_present'] else 0);write32(node+8,spatial)
 u.mem_write(actor+0x95,struct.pack('<6I',*c['aabb_bits']));u.mem_write(spatial,struct.pack('<3I',*c['initial_center_bits']));u.mem_write(spatial+0x10,struct.pack('<6f',*c['local_bounds']));f(spatial+0xc,99.)
 write32(spatial+0x28,parent if c['parent_present'] else 0);u.mem_write(spatial+0x2c,struct.pack('<4i',*c['initial_integer_bounds']));write32(0x14ae660,int(c['integer_sse']));write32(0x2da52e8,0)
 row={k:c[k] for k in ['aabb_bits','initial_center_bits','node_present','parent_present','local_bounds','integer_sse','initial_integer_bounds']}
 row['initial_radius_bits']=struct.unpack('<I',struct.pack('<f',99.))[0]
 for repeat in [False,True]:
  events.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
  u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x71a5b0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  result=dict(events=list(events),final=snapshot('final'))
  if repeat:row['repeat']=result
  else:row.update(result)
 cases.append(row)
if collect:
 Path('E:/mapslol3v3/chain-rsqrt-inputs.txt').write_text('\n'.join(map(str,sorted(inputs)))+'\n',encoding='utf-8')
else:
 proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x71a5b0',native_addresses=len(visited),cases=cases,rsqrt_estimates=[dict(input_bits=k,estimate_bits=v) for k,v in sorted(estimates.items())],runtime_adapters=['95FF10 parent boundary only records state and returns.','RSQRTSS output supplied by actual same-PC x86_64 estimate; remaining native instructions execute.'],limits=['Finite inherited AABB fixtures, supplied node/local/radius state, two integer profiles, default controls. No full game or original hardware x87 execution claimed.','Parent algorithm, actor registration and upstream model providers, camera, live collector/mask/WALL remain open.'])
 (r/'data/4.20/grass_spatial_chain_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(collect=collect,cases=len(cases),sqrt_inputs=len(inputs),native_addresses=len(visited))))
