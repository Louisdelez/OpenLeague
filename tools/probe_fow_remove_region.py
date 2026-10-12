from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
region=heap+0x1f900;pointer=heap+0x1fa00;counts=heap+0x12000;pixels=heap+0x8000;bits=heap+0x1a000
write32(region,bits);write32(pointer,counts);cases=[]
for dim,rect in [(8,[0,0,8,8]),(8,[1,2,5,6]),(128,[20,31,24,35])]:
 for initial in [0,1,2,255]:
  for pattern in [0,1,2]:
   mask=[0]*((dim*dim+31)//32)
   for index in range(dim*dim):
    if pattern==1 or (pattern==2 and index%2==0):mask[index//32]|=1<<(index%32)
   u.mem_write(bits,struct.pack('<'+'I'*len(mask),*mask));u.mem_write(counts,bytes([initial])*dim*dim);u.mem_write(pixels,bytes([90])*dim*dim)
   x0,z0,x1,z1=rect
   for offset,value in [(0xc,x0),(0x10,x1),(0x14,z0),(0x18,z1)]:write32(region+offset,value)
   write32(sp,end);write32(sp+4,dim);write32(sp+8,pixels);write32(sp+12,pointer);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,region)
   u.emu_start(0x6b2e60,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
   c=bytes(u.mem_read(counts,dim*dim));v=bytes(u.mem_read(pixels,dim*dim));changes=[]
   for z in range(dim):
    for x in range(dim):
     at=z*dim+x;out=(dim-z-1)*dim+x;inside=x0<=x<x1 and z0<=z<z1;selected=pattern==1 or (pattern==2 and at%2==0)
     expected=max(0,initial-1) if inside and selected else initial
     assert c[at]==expected
     expected_pixel=(255 if expected else 0) if inside else 90
     assert v[out]==expected_pixel
     if inside:changes.append({'index':at,'texture_index':out,'count':c[at],'visibility':v[out]})
   cases.append({'dimension':dim,'rect':rect,'initial_count':initial,'pattern':pattern,'changes':changes,'outside_preserved':True})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b2e60','cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[],'findings':['Only selected stencil bits decrement raw counts, saturating at0. Overlapping sources remain visible while counts are nonzero.','Every cell in the rectangle updates the visibility byte0/255, including unselected bits. Texture row is dimension-1-nativeZ. Cells outside rectangle are preserved.'],'limits':['Region stencil generation, source addition, native GPU upload, smoothing/fade and Map10 providers remain to qualify.']}
(r/'data/4.20/fow_remove_region_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
