from pathlib import Path
import json,struct,datetime,itertools,math
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_spatial_dispatch.py').read_text(encoding='utf-8').split('previous=')[0]
prefix=prefix.replace("events.append(dict(kind='center',bits=list(struct.unpack('<3I',u.mem_read(spatial,12)))));return_call(0)","events.append(dict(kind='center',bits=list(struct.unpack('<3I',u.mem_read(spatial,12)))))")
prefix=prefix.replace("events.append(dict(kind='parent'));return_call(4)","events.append(dict(kind='parent',integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16)))));return_call(4)")
prefix=prefix.replace("upper_bits=list(struct.unpack('<3I',u.mem_read(read32(s+8),12))))", "upper_bits=list(struct.unpack('<3I',u.mem_read(read32(s+8),12))),integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16))))")
exec(compile(prefix,'native spatial prerequisites','exec'))
previous=json.loads((r/'data/4.20/grass_spatial_dispatch_contract.json').read_text(encoding='utf-8'))
unique={}
for c in previous['cases']:
 values=list(struct.unpack('<6f',struct.pack('<6I',*c['aabb_bits'])))
 cached=list(struct.unpack('<3f',struct.pack('<3I',*c['initial_center_bits'])))
 if not all(math.isfinite(v) for v in values+cached):continue
 key=(tuple(c['aabb_bits']),tuple(c['initial_center_bits']),c['node_present'],c['parent_present']);unique[key]=c
local_profiles=[[-5.,-7.,-9.,5.,7.,9.],[-.1,-.2,-.3,.4,.5,.6]]
cases=[]
for c,local,int_sse in itertools.product(unique.values(),local_profiles,[False,True]):
 u.mem_write(actor,bytes(0x100));u.mem_write(spatial,bytes(0x40));write32(actor+0xcc,node if c['node_present'] else 0);write32(node+8,spatial)
 u.mem_write(actor+0x95,struct.pack('<6I',*c['aabb_bits']));u.mem_write(spatial,struct.pack('<3I',*c['initial_center_bits']));u.mem_write(spatial+0x10,struct.pack('<6f',*local));write32(spatial+0x28,parent if c['parent_present'] else 0)
 initial=[101,202,303,404];u.mem_write(spatial+0x2c,struct.pack('<4i',*initial))
 write32(0x14ae660,int(int_sse));write32(0x2da52e8,0);events.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x71a5b0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(aabb_bits=c['aabb_bits'],initial_center_bits=c['initial_center_bits'],node_present=c['node_present'],parent_present=c['parent_present'],local_bounds=local,integer_sse=int_sse,initial_integer_bounds=initial,events=list(events),final_center_bits=list(struct.unpack('<3I',u.mem_read(spatial,12))),final_integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x71a5b0',actual_bound_recalculation='0x95f370',native_addresses=len(visited),cases=cases,runtime_adapters=['Only parent95FF10 and localextents95F060 recordarguments/state andreturn; center95F370 withoriginalCRT executes fully.'],limits=['Finite deduplicated originalAABB/cached-node cases, twoexplicit localbound sets and integerprofiles; ceilprofile0, controls nearest/037F.','Parentreindex/localextents algorithms, registration/fieldproviders, nonfiniteCRT paths and livegrassrender remainopen.'])
(r/'data/4.20/grass_spatial_compound_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),unique_inputs=len(unique))))
