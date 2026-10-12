from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'prepare prerequisites','exec'))
text=vector+0x6000;font=text+0x100;metrics=text+0x200;content=text+0x400;output=vector+0x8000;glyphs=vector+0x10000;calls=[]
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
def signed(v):return v if v<0x80000000 else v-0x100000000
def hook(uc,a,size,user):
 if a==0x8be6b0:
  sp=uc.reg_read(UC_X86_REG_ESP);character=read(sp+4);calls.append(character);finish(0 if character==failed else glyphs+character*0x40,4);return
 assert 0x8bf950<=a<=0x8bfabd or 0x8c3650<=a<0x8c3680 or 0x6b5890<=a<=0x6b5925,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(text+4,font);w(font+4,metrics)
patterns=[[],[65],[65,32,86],[32,32],[65,0,86],[10,65,9],[65]*8,[233,65,86]]
cases=[]
for contents,space,failed,advance,height,scale in itertools.product(patterns,[0,7],[None,86],[13,-3],[0,24],[[1.,1.],[.75,1.5]]):
 calls.clear();w(text+0x5c,output);w(text+0x60,output);w(text+0x64,output+0x1000);w(metrics+0x10,space);u.mem_write(metrics+0x14,struct.pack('<H',32));w(metrics+0xc,height)
 u.mem_write(text+8,b'\0'*24);encoded=struct.pack('<'+'H'*len(contents),*contents) if contents else b''
 if len(contents)<8:u.mem_write(text+8,encoded+b'\0\0');w(text+0x1c,7)
 else:u.mem_write(content,encoded+b'\0\0');w(text+8,content);w(text+0x1c,64)
 w(text+0x18,len(contents));u.mem_write(text+0x3c,struct.pack('<2f',*scale))
 for character in set(contents):w(glyphs+character*0x40+0xc,advance)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,text);u.emu_start(0x8bf950,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+4
 expected_ids=[None if c==32 or c==failed else c for c in contents];expected_calls=[c for c in contents if c!=32];raw_width=sum(space if g is None else advance for g in expected_ids);raw_width=signed(raw_width&0xffffffff)
 actual_ids=[]
 for a in range(output,read(text+0x60),12):ptr,sx,sy=struct.unpack('<3I',u.mem_read(a,12));assert sx==sy==0x3f800000;actual_ids.append(None if ptr==0 else (ptr-glyphs)//0x40)
 actual=[signed(read(text+off)) for off in [0x68,0x6c,0x50,0x54]];expected=[raw_width,height,int(f32(f32(raw_width)*scale[0])),int(f32(f32(height)*scale[1]))]
 assert actual_ids==expected_ids and calls==expected_calls and actual==expected,(contents,actual,expected)
 cases.append({'text_utf16':contents,'space_character':32,'space_advance':space,'failed_character':failed,'glyph_advance':advance,'line_height':height,'scale':scale,'cell_ids':actual_ids,'lookup_calls':list(calls),'dimensions':actual})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8bf950','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'findings':['Full original prepared-cell builder, vector clear/append execute with reserved capacity and supplied cache lookup. Short inline and heap-backed UTF16 storage tested.','Processes stored length, including embedded NUL; special space code unit produces NULL cell without glyph lookup. Failed cache lookup also produces NULL and space advance.','Cells carry scales1,1; unscaled width is wrapping sum of glyph advance or space advance. Height copied from font metric+C. Scaled dimensions use float32multiply then integer truncation.'],'limits':['Native cache lookup adapted to supplied glyph result/miss. Original string setter truncates at firstNUL separately; direct stored-length probe includesNUL.','Reserved vector capacity avoids growth/reallocation/error lifetimes. No high-level wrapping/clipping parser or ordinary HUD widgets proof.','Selected dimensions/scales stay in CVTTSS2SI range; overflow/nonfinite conversion remains unqualified.']}
(r/'data/4.20/native_font_prepare_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
