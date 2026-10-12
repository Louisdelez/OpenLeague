from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
owner=terrain+0x2000;table=terrain+0x1000;handle=0x12340002
write32(0x2d628c0,table);write32(0x2d628c4,4)
assert read32(0x1090ea8+0x70)==0x564f20 and read32(0x1090ea8+0x200)==0x600f60
assert read32(0x10a03d0+0x18)==0x5642d0
cases=[]
for mode,position,dirty in itertools.product(['valid','no_owner','empty_slot','handle_mismatch','generation_mismatch','uncached'],[[10.,99.,20.],[10.000005,99.,20.],[10.00002,99.,20.],[125.,-40.,-300.]], [False,True]):
 u.mem_write(obj,bytes(0x80));u.mem_write(owner,bytes(0x2000));u.mem_write(table,bytes(16))
 write32(obj,0x10a03d0);write32(owner,0x1090ea8);write32(owner+8,handle+0x10000 if mode=='handle_mismatch' else handle)
 write32(owner+0x18,8 if mode=='generation_mismatch' else 7)
 u.mem_write(owner+0x60,struct.pack('<3f',*position))
 write32(table+8,0 if mode=='empty_slot' else owner)
 write32(obj+0x24,0 if mode=='no_owner' else handle);write32(obj+0x34,0 if mode=='uncached' else owner);write32(obj+0x30,7)
 u.mem_write(obj+4,struct.pack('<2f',10.,20.));write32(obj+0x20,0x3f800000);u.mem_write(obj+0x45,bytes([dirty]))
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6b1860,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(mode=mode,owner_position=position,initial_center=[10.,20.],initial_dirty=dirty,initial_lifetime_bits=0x3f800000,result_center_bits=list(struct.unpack('<2I',u.mem_read(obj+4,8))),result_dirty=bool(u.mem_read(obj+0x45,1)[0]),result_cached_owner=bool(read32(obj+0x34)),result_lifetime_bits=read32(obj+0x20)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b1860',owner_virtual200='0x600f60',source_vtable='0x10a03d0',position_epsilon_bits=read32(0x11389ac),native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Complete original owner-position update executes with original resolver and null secondary shared-position provider. Non-null secondary position object remains unqualified.','This method does not compare the cached generation; invalid handle/slot clears cached owner and sets lifetime bits34000000. Cached-pointer mismatch assertion is not exercised.','Actor construction, position producer, source creation/team/activation/destruction and full lifetime consumption remain open.'])
(r/'data/4.20/fow_position_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),first=cases[0],last=cases[-1])))
