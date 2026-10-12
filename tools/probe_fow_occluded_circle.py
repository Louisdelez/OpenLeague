from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8');exec(compile(s.split('\ncases=[]')[0],'native terrain prerequisites','exec'))
counts=heap+0x12000;pixels=heap+0x8000;pointer=heap+0x1fa00;source_flag=False;queries=[];cases=[]
def query_boundary(uc,address,size,user):
 if address==0x8f3390:
  assert uc.reg_read(UC_X86_REG_ECX)==terrain
  top=uc.reg_read(UC_X86_REG_ESP);queries.append(list(struct.unpack('<3f',uc.mem_read(top+4,12))));finish(12,int(source_flag))
u.hook_add(unicorn.UC_HOOK_CODE,query_boundary)
for center in [[128.,128.],[32.,128.]]:
 for radius in [32.,80.]:
  for flag in [0,1,2,512]:
   for source_flag in [False,True]:
    queries.clear();u.mem_write(obj,bytes(0x80));write32(obj,0x10a03d0)
    for offset,value in [(4,center[0]),(8,center[1]),(0xc,radius),(0x14,64.),(0x18,1.),(0x1c,0.)]:u.mem_write(obj+offset,struct.pack('<f',value))
    write32(obj+0x40,bits);write32(obj+0x48,2);u.mem_write(obj+0x45,b'\x01');u.mem_write(obj+0x68,b'\x01');write32(pointer,counts)
    u.mem_write(bits,bytes(8));u.mem_write(counts,bytes(64));u.mem_write(pixels,bytes(64))
    for i in range(64):u.mem_write(cells+56*i+0x32,struct.pack('<H',flag if i%8==4 else 0))
    write32(sp,end);write32(sp+4,8);u.mem_write(sp+8,struct.pack('<f',256.));write32(sp+12,pixels);write32(sp+16,pointer)
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
    u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
    u.emu_start(0x6b14e0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(queries)==1
    words=list(struct.unpack('<2I',u.mem_read(bits,8)));c=bytes(u.mem_read(counts,64));v=bytes(u.mem_read(pixels,64))
    for z in range(8):
     for x in range(8):
      i=z*8+x;chosen=bool(words[i//32]&(1<<(i%32)));assert c[i]==int(chosen);assert v[(7-z)*8+x]==(255 if chosen else 0)
    rect=[read32(obj+o) for o in [0x4c,0x54,0x50,0x58]]
    cases.append({'dimension':8,'extent':256.,'center':center,'radius':radius,'source_metric':64.,'source_flag':source_flag,'flag_column':4,'flag':flag,'rect':rect,'words':words,'selected_cells':sum(c),'source_query':queries[0]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b14e0','cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[{'address':'0x8f3390','purpose':'Supply controlled source flag at terrain query boundary; original fan/clipping/tracing/add-region execute.'}],'limits':['Full occluded source mask pipeline executed on diagnostic8x8grid; actual Map10 terrain and source-flag provider not qualified.','Owner-dependent scale/bias/height, cone composition and normal client lifecycle remain open.']}
(r/'data/4.20/fow_occluded_circle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'sample':cases[:3]}))
