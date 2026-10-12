from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
owner=terrain+0x2000;table=terrain+0x1000;outputs=heap+0x1fa00;handle=0x12340002
write32(0x2d628c0,table);write32(0x2d628c4,4)
cases=[]
vtables=[0x1090ea8,0x10913d8,0x109192c,0x1091e14,0x1092608,0x1092ce8,0x10931b4,0x1093d80]
for vt in vtables:
 assert read32(vt+0x70)==0x564f20 and read32(vt+0x120)==0x617f80
 for percent in [-1.,-0.5,0.,0.25,1.]:
  for flat in [-100.,0.,80.]:
   for mode in ['valid','no_owner','empty_slot','handle_mismatch','generation_mismatch','out_of_range']:
    u.mem_write(obj,bytes(0x80));u.mem_write(owner,bytes(0x800));u.mem_write(table,bytes(16));write32(owner,vt)
    write32(owner+8,handle if mode!='handle_mismatch' else handle+0x10000);write32(owner+0x18,7 if mode!='generation_mismatch' else 8)
    u.mem_write(owner+0x778,struct.pack('<2f',flat,percent))
    write32(table+8,owner if mode!='empty_slot' else 0)
    write32(obj+0x24,0 if mode=='no_owner' else handle+3 if mode=='out_of_range' else handle)
    write32(obj+0x34,owner);write32(obj+0x30,7);u.mem_write(obj+0x18,struct.pack('<2f',0.75,23.))
    u.mem_write(outputs,bytes(8));write32(sp,end);write32(sp+4,outputs);write32(sp+8,outputs+4)
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
    u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
    u.emu_start(0x6b17e0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
    result=list(struct.unpack('<2f',u.mem_read(outputs,8)))
    cases.append(dict(vtable=hex(vt),percent=percent,flat=flat,mode=mode,default_scale=0.75,default_bias=23.,result=result,result_bits=list(struct.unpack('<2I',u.mem_read(outputs,8)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b17e0',owner_resolver='0x717d10',virtual70='0x564f20',virtual120='0x617f80',native_vtables=[hex(v) for v in vtables],original_instruction_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Original complete owner resolver, source generation check, virtual self-getter and actor modifier writer execute without adapters.','Registry, owners and state fields supplied explicitly; actual owner construction, field producers/buffs, identity mapping to Rust actors and live source lifecycle remain open.','Cached-pointer mismatch assertion path and invalid sentinel handle0xffffffff are not exercised. Native class names not assigned without constructor provenance.','Scale/bias qualification does not prove complete native fog integration or ordinary rendering.'])
(r/'data/4.20/fow_owner_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),first=cases[0],last=cases[-1])))
