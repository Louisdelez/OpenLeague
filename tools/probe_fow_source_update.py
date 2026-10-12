from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
actor=terrain+0x2000;control=terrain+0x6000;character_data=terrain+0x7000;cases=[]
assert read32(0x1090ea8+0x11c)==0x6494d0 and read32(0x10924dc+4)==0x600ea0
for status,data_radius,overrides,old_radius,modifiers,initial_dirty in itertools.product(['live','expired','missing'],[None,1200.,1350.],[[-1.,0.],[25.,75.]],[100.,1350.],[[-0.5,0.],[0.,0.],[0.5,50.]],[False,True]):
 u.mem_write(actor,bytes(0x3000));write32(actor,0x1090ea8);write32(actor+0x3e0,0x10924dc)
 write32(actor+0x2294,obj);write32(actor+0x2298,0 if status=='missing' else control)
 u.mem_write(control,bytes(16));write32(control+4,0 if status=='expired' else 10);write32(control+8,10)
 write32(actor+0x206c,0 if data_radius is None else character_data)
 if data_radius is not None:u.mem_write(character_data+0x1d8,struct.pack('<f',data_radius))
 for offset,value in [(0x20b8,overrides[0]),(0x20bc,overrides[1]),(0x37c,64.),(0x384,128.),(0x77c,modifiers[0]),(0x778,modifiers[1])]:u.mem_write(actor+offset,struct.pack('<f',value))
 u.mem_write(obj,bytes(0x80));u.mem_write(obj+0xc,struct.pack('<5f',old_radius,9.,8.,1.,0.));u.mem_write(obj+0x45,bytes([initial_dirty]))
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6198f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read32(control+4)==(0 if status=='expired' else 10) and read32(control+8)==10
 cases.append(dict(status=status,data_radius=data_radius,overrides=overrides,fallback_metrics=[64.,128.],percent=modifiers[0],flat=modifiers[1],old_radius=old_radius,initial_dirty=initial_dirty,result_bits=list(struct.unpack('<5I',u.mem_read(obj+0xc,20))),generation_dirty=bool(u.mem_read(obj+0x45,1)[0])))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,entry='0x6198f0',actor_vtable='0x1090ea8',source_getter='0x6494d0',character_data_getter='0x600ea0',native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Original complete source update and native weak-reference acquisition/release execute. Supplied objects/control blocks start with retained reference counts; final deletion paths not exercised.','Character-data source radius, metric overrides/fallbacks and modifier state are supplied fields; original actor constructor/cache loaders and field producers remain open.','Source position/team/creation/eligibility and GPU binding are separate paths not qualified by this update. Actor class name not assigned without constructor provenance.'])
(r/'data/4.20/fow_source_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),first=cases[0],last=cases[-1])))
