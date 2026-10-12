from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
cases=[]
for rect in [[0,0,1,1],[6900,7000,7900,8000],[-500,-600,500,600],[100,200,100,200],[1000,900,-1000,-900]]:
    frame=stack+0x7000;owner=heap+0x1e000;source=heap+0x1e100
    u.mem_write(source,struct.pack('<4f',*rect));u.mem_write(frame-0x8c,bytes(24));write32(owner+0x14,0)
    u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,source);u.reg_write(UC_X86_REG_ESI,owner)
    u.emu_start(0x9571b0,0x9571f9,count=100)
    assert u.reg_read(UC_X86_REG_EIP)==0x9571f9
    result=list(struct.unpack('<6f',u.mem_read(frame-0x8c,24)))
    assert result==[rect[0],-100000.,rect[1],rect[2],100000.,rect[3]],result
    cases.append({'rectangle':rect,'bounds':result})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'instruction_range':['0x9571b0','0x9571f9'],'cases':cases,'limits':['Only rectangle-to-volume prefix executes; register/stack/resource prerequisites supplied.','No geometry query, map mode selection, receiver eligibility or GPU submission qualified.','Original code preserves reversed input bounds; caller validity not inferred.']}
(r/'data/4.20/projected_receiver_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof,indent=2))
