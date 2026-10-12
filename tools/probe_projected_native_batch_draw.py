from pathlib import Path
import json,datetime,hashlib,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_selector7_batches.py').read_text().split('cases=[]')[0],'native draw prerequisites','exec'))
inventory=json.loads((r/'data/4.20/map10_projected_receiver_inventory.json').read_text());assert inventory['native_sha256']==hashlib.sha256(raw).hexdigest()
vmax=max(m['projection_geometry'][0] for m in inventory['meshes']);imax=max(m['projection_geometry'][3] for m in inventory['meshes'])
vb=arena+0x11000;ib=arena+0x15000
write=lambda a,v:w(a,v)
w(owner+0x28,vb);w(owner+0x2c,vb+4*(vmax+1));w(owner+0x34,ib);w(owner+0x38,ib+4*(imax+1))
for i in range(vmax+1):w(vb+4*i,0x50000000+i*256)
for i in range(imax+1):w(ib+4*i,0x60000000+i*256)
assert read(0x10d9d00+4)==12
cases=[]
for m in inventory['meshes']:
 if not m['material_accepted']:continue
 g=m['projection_geometry'];u.mem_write(context,bytes(0x100));w(context+0x54,5)
 for off in [0x60,0x64,0x68,0x6c]:w(context+off,0xffffffff)
 u.mem_write(rows,struct.pack('<10I',0xffffffff,g[0],g[3],g[1],g[2],g[4],g[5]//3,1,0,0))
 w(stack,end);w(stack+4,rows);w(stack+8,owner);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);draws.clear();calls.clear()
 u.emu_start(0x95afc0,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert len(draws)==1 and draws[0]['args']==[0,0,g[1],g[2],g[4],g[5]//3],(m['index'],draws)
 cases.append(dict(mesh=m['index'],draw_args=draws[0]['args']))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x95afc0',projection_vertex_stride=12,cases=cases,findings=['Actual native batch routine forwards all selected geometry indices/counts unchanged to abstract driver draw. No CPU clipping or per-triangle rectangle filtering in this routine.','Declaration variant1 reads stride12 from original executable table10D9D00.'],limits=['Driver virtual calls, profiling, shader setup prerequisites supplied/adapted; original GPU and active clip-plane state not executed.','Caller shader and graphics clip-state still require qualification before removing reconstructed CPU clipping.'])
(r/'data/4.20/projected_native_batch_draw_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(cases),stride=12,passed=True)))
