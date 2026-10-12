from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
owner=terrain+0x2000;table=terrain+0x1000;motion=terrain+0x8000;control=terrain+0x9000;handle=0x12340002
write32(0x2d628c0,table);write32(0x2d628c4,4)
assert read32(0x1094490)==0x5fffd0
assert bytes(u.mem_read(0x5fffd0,7))==bytes.fromhex('8d813a020000c3')
cases=[]
for mode,position,dirty,present in itertools.product(['valid','generation_mismatch','empty_slot'],[[10.,99.,20.],[10.000005,99.,20.],[10.00002,99.,20.],[125.,-40.,-300.]], [False,True],[False,True]):
 u.mem_write(obj,bytes(0x80));u.mem_write(owner,bytes(0x2000));u.mem_write(table,bytes(16));u.mem_write(motion,bytes(0x338));u.mem_write(control,bytes(16))
 write32(obj,0x10a03d0);write32(owner,0x1090ea8);write32(owner+8,handle);write32(owner+0x18,8 if mode=='generation_mismatch' else 7)
 u.mem_write(owner+0x60,struct.pack('<3f',500.,66.,800.))
 write32(owner+0x18b8,motion if present else 0);write32(owner+0x18bc,control if present else 0)
 write32(control+4,10);write32(control+8,10);write32(motion+0x70,0x1094490);u.mem_write(motion+0x2aa,struct.pack('<3f',*position))
 write32(table+8,0 if mode=='empty_slot' else owner);write32(obj+0x24,handle);write32(obj+0x34,owner);write32(obj+0x30,7)
 u.mem_write(obj+4,struct.pack('<2f',10.,20.));write32(obj+0x20,0x3f800000);u.mem_write(obj+0x45,bytes([dirty]))
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6b1860,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read32(control+4)==10 and read32(control+8)==10
 cases.append(dict(mode=mode,owner_position=[500.,66.,800.],secondary_position=position if present else None,initial_dirty=dirty,result_center_bits=list(struct.unpack('<2I',u.mem_read(obj+4,8))),result_dirty=bool(u.mem_read(obj+0x45,1)[0]),result_cached_owner=bool(read32(obj+0x34)),result_lifetime_bits=read32(obj+0x20)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b1860',secondary_getter='0x5fffd0',secondary_component_vtable='0x1094490',secondary_position_offset='0x2aa',static_constructor_provenance=['61F470 actor initialization calls641A50 at61F513 and assigns shared provider at61F523.','641A50 calls641750; base constructor641750 calls603660 at6417F8 for provider+70.','603660 writes1094490 at60368B; original virtual getter5FFFD0 returns component+23A, hence provider+2AA.'],native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Complete original source position method, non-null shared provider acquisition/drop and native position getter execute. Retained reference counts avoid final destructor paths.','Constructor provenance is static disassembly; complete actor/provider constructors and position field producers are not executed.','Actual source team/creation/activation/removal, counted visibility and GPU integration remain open.'])
(r/'data/4.20/fow_secondary_position_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
