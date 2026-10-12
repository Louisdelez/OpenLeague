from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
out=heap+0x1a000;count=heap+0x1b000;bounds=heap+0x1b100;vertices=heap+0x1c000;indices=heap+0x1d000
u.mem_write(bounds,struct.pack('<6f',0,-100000,0,10,100000,10));u.mem_write(indices,struct.pack('<3H',0,1,2))
cases=[]
triangles=[[[1,0,1],[2,0,1],[1,0,2]],[[-1,0,1],[-2,0,1],[-1,0,2]],[[11,0,1],[12,0,1],[11,0,2]],[[1,0,-1],[2,0,-1],[1,0,-2]],[[1,0,11],[2,0,11],[1,0,12]],[[-10,0,5],[20,0,5],[5,0,20]],[[0,0,1],[0,0,2],[-1,0,1]],[[1,200000,1],[2,200000,1],[1,200000,2]]]
for tri in triangles:
 raw=struct.pack('<9f',*(v for point in tri for v in point));u.mem_write(vertices,raw);u.mem_write(out,b'\xcd'*72);write32(count,0)
 args=[out,0,count,bounds,0,vertices,indices,1]
 write32(sp,end)
 for i,v in enumerate(args):write32(sp+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x95f9c0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 accepted=read32(count);expected=not(any(all(p[axis]<lo for p in tri) or all(p[axis]>hi for p in tri) for axis,lo,hi in [(0,0,10),(2,0,10)]))
 assert accepted==int(expected)
 if accepted:assert bytes(u.mem_read(out,36))==raw
 cases.append({'triangle':tri,'accepted':bool(accepted),'vertices_preserved':bool(accepted)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x95f9c0','bounds':[0,-100000,0,10,100000,10],'cases':cases,'findings':['Rejects only triangles wholly outside one X/Z rectangle side, strict comparisons.','Boundary-touching and crossing triangles retained unchanged, no clipping.','Y is copied but not used for acceptance in this leaf.'],'limits':['Supplied vertices/indices/output/count and query bounds; grid traversal, map-mode selection and full GPU not executed.','Capacity sentinel and multiple-triangle accumulation not covered.']}
(r/'data/4.20/projected_receiver_triangles_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(proof,indent=2))
