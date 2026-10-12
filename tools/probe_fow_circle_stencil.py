from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
obj=heap+0x1f300;bits=heap+0x1a000;counts=heap+0x12000;pixels=heap+0x8000;pointer=heap+0x1fa00;cases=[]
for dim,extent in [(8,256.),(128,10000.)]:
 cell=extent/dim
 for center in [(0.,0.),(extent/2,extent/2),(extent-cell/2,extent-cell/2),(-cell,extent/2)]:
  for radius in [0.,cell,2.5*cell]:
   u.mem_write(obj,bytes(0x80));write32(obj,0x10a03d0)
   for offset,value in [(4,center[0]),(8,center[1]),(0xc,radius),(0x18,1.),(0x1c,0.)]:u.mem_write(obj+offset,struct.pack('<f',value))
   write32(obj+0x40,bits);write32(obj+0x48,(dim*dim+31)//32);u.mem_write(obj+0x45,b'\x01')
   u.mem_write(bits,bytes(((dim*dim+31)//32)*4));u.mem_write(counts,bytes(dim*dim));u.mem_write(pixels,bytes(dim*dim));write32(pointer,counts)
   write32(sp,end);write32(sp+4,dim);u.mem_write(sp+8,struct.pack('<f',extent));write32(sp+12,pixels);write32(sp+16,pointer)
   u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
   u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x6b14e0,end,count=10000000);assert u.reg_read(UC_X86_REG_EIP)==end
   words=list(struct.unpack('<'+'I'*((dim*dim+31)//32),u.mem_read(bits,((dim*dim+31)//32)*4)))
   c=bytes(u.mem_read(counts,dim*dim));v=bytes(u.mem_read(pixels,dim*dim))
   for y in range(dim):
    for x in range(dim):
     i=y*dim+x;selected=bool(words[i//32]&(1<<(i%32)));assert c[i]==int(selected);assert v[(dim-y-1)*dim+x]==(255 if selected else 0)
   rect=[read32(obj+o) for o in [0x4c,0x54,0x50,0x58]]
   cases.append({'dimension':dim,'extent':extent,'center':center,'radius':radius,'scale':1.,'bias':0.,'rect':rect,'words':words,'selected_cells':sum(c),'generation_dirty_after':int(u.mem_read(obj+0x45,1)[0])})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b14e0','circle_vtable':'0x10a03d0','predicate':'0x6aff80','radius':'0x6b0000','cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[],'limits':['Original full non-occluded circle stencil generation and add-region execute with preallocated bit arrays, unowned shape and supplied geometry.','Owner-dependent radius modifiers, occluded visibility branch, cone shapes, live source collection and Map10 extent remain unqualified.']}
(r/'data/4.20/fow_circle_stencil_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'sample':[{k:c[k] for k in ['dimension','center','radius','rect','selected_cells']} for c in cases[:6]]}))
