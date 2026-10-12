from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
obj=heap+0x1f300;desc=heap+0x1f500;bits=heap+0x1a000;terrain=0x40000000;cells=0x40001000
u.mem_map(terrain,0x10000);write32(0x14c7f1c,terrain);write32(terrain+0x20,cells)
for offset,value in [(7,0.),(0xb,0.),(0xf,0.),(0x314,32.)]:u.mem_write(terrain+offset,struct.pack('<f',value))
write32(terrain+0x30c,8);write32(terrain+0x310,8)
u.mem_write(obj,bytes(0x80));write32(obj,0x10a03d0);write32(obj+0x40,bits)
for offset,value in [(4,128.),(8,128.),(0xc,512.),(0x18,1.),(0x1c,0.)]:u.mem_write(obj+offset,struct.pack('<f',value))
for offset,value in [(0,0.),(4,256.)]:u.mem_write(desc+offset,struct.pack('<f',value))
for offset,value in [(8,8),(0xc,0),(0x10,8),(0x14,0),(0x18,8)]:write32(desc+offset,value)
cases=[]
for delta in [[4.,0.],[0.,4.],[4.,4.],[-1.,-1.]]:
 for flag in [0,1,2,64,66,512]:
  for starts_in_brush in [False,True]:
   u.mem_write(bits,bytes(8));u.mem_write(desc+0x1c,bytes([starts_in_brush]))
   for i in range(64):u.mem_write(cells+56*i+0x32,struct.pack('<H',flag if i%8==4 else 0))
   write32(sp,end);u.mem_write(sp+4,struct.pack('<3f',*delta,0.));u.mem_write(sp+16,struct.pack('<2f',2.,2.));write32(sp+24,desc)
   u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
   u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x6b09e0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
   words=list(struct.unpack('<2I',u.mem_read(bits,8)))
   cases.append({'dimension':8,'extent':256.,'terrain_cell_size':32.,'origin':[2.,2.],'delta':delta,'source_height':0.,'flag_column':4,'flag':flag,'starts_in_brush':starts_in_brush,'words':words})
constants={hex(a):floats(a,1)[0] for a in [0x1138e54,0x1138b7c,0x1138c74]}
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b09e0','cases':cases,'constants':constants,'original_instruction_addresses':len(visited),'runtime_adapters':[],'limits':['Original complete ray traversal and real circle predicate executed with supplied grid/flags/brush prerequisites.','Terrain data is a synthetic flag column, not Map10. Flag meanings, Map10 packed cell loader and source-height/brush providers remain unqualified.','Full radial fan, clipped-ray composition, owner modifiers and normal client integration remain open.']}
(r/'data/4.20/fow_terrain_ray_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'constants':constants,'sample':cases[:8]}))
