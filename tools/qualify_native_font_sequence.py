from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'sequence prerequisites','exec'))
owner=vector+0x6000;metrics=owner+0x100;text=owner+0x200;table=owner+0x300;position=owner+0x400;dimensions=owner+0x500;listvec=owner+0x600;glyphvec=owner+0x700;entries=vector+0x8000;output=vector+0xc000;scales=owner+0x800;nodes=vector+0x10000
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
putf=lambda a,x:u.mem_write(a,struct.pack('<f',x))
horizontal=vertical=0;kerning_calls=[]
def hook(uc,a,size,user):
 if a in [vector+0x5000,vector+0x5010,vector+0x5020,vector+0x5030,vector+0x5040,vector+0x5050]:finish({vector+0x5000:position,vector+0x5010:dimensions,vector+0x5020:horizontal,vector+0x5030:vertical,vector+0x5040:glyphvec,vector+0x5050:scales}[a]);return
 if a==vector+0x5070:
  sp=uc.reg_read(UC_X86_REG_ESP);left=uc.reg_read(UC_X86_REG_ECX);right=read(sp+4);assert left in [nodes,nodes+0x100] and right in [nodes,nodes+0x100]
  kerning_calls.append([0 if left==nodes else 1,0 if right==nodes else 1]);finish(kern,4);return
 if a==vector+0x5060 or a==vector+0x5066:return
 assert 0x8be3c0<=a<=0x8be6ab,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(owner+4,metrics);w(text,table)
for offset,address in [(0xc,vector+0x5000),(0x60,vector+0x5010),(0x2c,vector+0x5020),(0x34,vector+0x5030),(0x50,vector+0x5040),(0x3c,vector+0x5050),(0x70,vector+0x5060)]:w(table+offset,address)
# Native owner-scale getter uses x87 return ABI, supplied by a literal FLD/RET stub.
u.mem_write(vector+0x5060,b'\xd9\x05'+struct.pack('<I',scales+8)+b'\xc3')
w(listvec,owner+0x900);w(listvec+4,owner+0x904);w(owner+0x900,text)
for i in range(2):w(nodes+i*0x100,owner+0xa00);w(owner+0xa00+0xc,vector+0x5070)
cases=[]
patterns=[[],[None],[0],[0,1],[0,None,1],[0,1,0],[None,0,1,None,0]]
for pattern,point,horizontal,vertical,scale,kern,space in itertools.product(patterns,[[0.,0.],[11.75,-2.25]],[0,1,2],[0,1,2,3],[[1.,1.],[.75,.5]],[-2,0,3],[0,7]):
 font_scale,owner_scale=scale;putf(position,point[0]);putf(position+4,point[1]);w(dimensions,31);w(dimensions+4,43);w(metrics+4,24);w(metrics+8,-5);w(metrics+0x10,space);putf(scales,font_scale);putf(scales+4,1.);putf(scales+8,owner_scale)
 w(owner+0x5c,output);w(owner+0x60,output);w(owner+0x64,output+0x1000);w(glyphvec,entries);w(glyphvec+4,entries+12*len(pattern));kerning_calls.clear()
 for i,glyph in enumerate(pattern):
  address=entries+i*12;ptr=0 if glyph is None else owner+0xb00+glyph*0x100;w(address,ptr);w(address+4,0);w(address+8,0)
  if glyph is not None:w(ptr+0x30,nodes+glyph*0x100);w(ptr+0xc,[13,17][glyph]);w(nodes+glyph*0x100+8,[-2,3][glyph])
 w(stack,end);w(stack+4,listvec);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8be4c0,end,count=5000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+8
 assert u.reg_read(UC_X86_REG_EAX)==0
 x=point[0] if horizontal==0 else f32(point[0]-(15 if horizontal==1 else 31));y=point[1] if vertical==0 else f32(point[1]+24) if vertical==1 else f32(f32(point[1]+24)-21) if vertical==2 else f32(point[1]+5)
 expected=[];previous=None;expected_calls=[]
 for glyph in pattern:
  if glyph is None:x=f32(x+space);previous=None;continue
  px=f32(x+[-2,3][glyph]);py=f32(y-24)
  if previous is not None:px=f32(px+f32(kern*font_scale));expected_calls.append([previous,glyph])
  expected.append({'glyph_id':glyph,'position_bits':[struct.unpack('<I',struct.pack('<f',v))[0] for v in [px,py]]})
  # Original x87 rounds advance*owner_scale to f32 before extended scale*advance + cursor.
  x=f32(f32([13,17][glyph]*owner_scale)*font_scale+x);previous=glyph
 actual=[]
 for address in range(output,read(owner+0x60),16):
  entry_ptr,font_ptr,px,py=struct.unpack('<4I',u.mem_read(address,16));assert font_ptr==text;glyph=pattern[(entry_ptr-entries)//12];actual.append({'glyph_id':glyph,'position_bits':[px,py]})
 assert actual==expected and kerning_calls==expected_calls,(pattern,point,scale,kern,space,actual,expected,kerning_calls,expected_calls)
 cases.append({'glyph_ids':pattern,'position':point,'horizontal':horizontal,'vertical':vertical,'font_scale':font_scale,'owner_scale':owner_scale,'kerning':kern,'space_advance':space,'draws':actual,'kerning_calls':list(kerning_calls)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8be4c0','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'findings':['Full original sequence and alignment execute with supplied Text/glyph providers and reserved output capacity; every draw position compared bit-for-bit.','NULL glyph entries advance by native font+0x10, unscaled, and reset previous glyph; no draw.','Draw X is cursor plus unscaled glyph-node+8 bearing, plus previous/current kerning multiplied by font X scale when previous exists. Kerning changes draw X, not the cursor advance.','Draw Y is aligned Y minus native font+4. Advance is u32 glyph+0xC times owner scale rounded f32 then font X scale and cursor summed through x87.'],'limits':['Input Text list, glyph vector, metrics, scale and kerning virtual providers supplied. Glyph-vector producer/wrapping/clipping, original allocation/failure/lifetime and ordinary widgets remain open.','Selected patterns, finite origins, horizontal0..2/vertical0..3, integer advances13/17, scales1/.75 and1/.5; negative/overflow advances and extreme float/x87 rounding not qualified.','Native output vector capacity reserved; no growth/reallocation failure evidence. No original framebuffer reference.']}
(r/'data/4.20/native_font_sequence_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
