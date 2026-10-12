from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_grass_actor_aabb.py').read_text(encoding='utf-8').split('profiles=')[0],'native AABB prerequisites','exec'))
previous=json.loads((r/'data/4.20/grass_actor_aabb_contract.json').read_text(encoding='utf-8'))
assert previous['passed']
cases=[]
fields=[0x48,0x4c,0x354,0x358,0x35c,0x360,0x364,0x368]
for input_index,raw_shape,raw_radius in itertools.product(range(len(previous['cases'])),[0.,25.,float('nan')],[-1.,0.,75.,float('nan')]):
 c=previous['cases'][input_index];u.mem_write(actor,bytes(0x2100));u.mem_write(model,bytes(0xb0))
 u.mem_write(actor+0x60,struct.pack('<3f',*c['position']));f(actor+0x740,c['actor_scale'])
 write32(actor+0x2068,model if c['profile'] else 0);write32(model+0xa4,provider);f(model+4,c['model_scale'])
 write32(provider,table);write32(table+4,bounds_api);samples=c['bounds_calls'];calls.clear()
 f(actor+0x380,raw_shape);f(actor+0x37c,raw_radius);f(actor+0x48,71.);f(actor+0x4c,19.)
 write32(actor+0xcc,0);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6151a0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert list(struct.unpack('<6I',u.mem_read(actor+0x95,24)))==c['aabb_bits']
 assert calls==c['bounds_calls']
 cases.append(dict(input_index=input_index,raw_shape_bits=struct.unpack('<I',struct.pack('<f',raw_shape))[0],raw_radius_bits=struct.unpack('<I',struct.pack('<f',raw_radius))[0],initial_height=71.,initial_radius=19.,state_bits=[read32(actor+off) for off in fields],sentinel=read32(actor+0x36c)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6151a0',spatial_propagation='0x71a5b0',native_addresses=len(visited),state_offsets=[hex(off) for off in fields],cases=cases,runtime_adapters=['Same explicit modelbounds virtual+4 provider as original192AABBcases.'],limits=['Complete6151A0 executes, including original71A5B0 no-node branch, metric fields and sentinel. Actor+CC=null explicitly supplied; registered spatial-tree update remains open.','Original model/provider constructors/getter, position/scales/raw metric producers and actual actor calls remain open.','NaN raw metrics tested in emulated COMISS control flow; no native hardware exception/rounding acceptance or live renderer claimed.'])
(r/'data/4.20/grass_actor_aabb_full_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),complete=False)))
