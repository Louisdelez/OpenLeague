from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'vertex color prerequisites','exec'))
out=vector+0x6000
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a));cases=[]
for a,red,green,blue in itertools.product([0,64,128,255],repeat=4):
 packed=(a<<24)|(red<<16)|(green<<8)|blue;w(stack,end);w(stack+4,packed)
 for i in range(4):w(stack+8+i*4,out+i*4)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8e17d0,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=[read(out+i*4) for i in range(4)];assert actual==[a,red,green,blue];cases.append({'packed':packed,'argb':actual})
shaders=[]
for name in ['VS_RENDER_FILL_AND_OUTLINE.vs_2_0_0.bin','VS_RENDER_GLOW.vs_2_0_0.bin']:
 path=r/'data/4.20/shaders/RenderGlyph'/name;data=path.read_bytes();tokens=list(struct.unpack('<'+'I'*(len(data)//4),data));assert tokens[0]==0xfffe0200
 instructions=[];i=1
 while i<len(tokens):
  token=tokens[i];opcode=token&65535
  if opcode==65535:break
  if opcode==65534:i+=1+((token>>16)&32767);continue
  size=(token>>24)&15;assert size;instructions.append(tokens[i:i+1+size]);i+=1+size
 color_moves=[inst for inst in instructions if inst[0]&65535==1 and (inst[1]&0x70000000)==0x50000000]
 assert len(color_moves)==(2 if 'FILL' in name else 1)
 for inst in color_moves:assert ((inst[2]>>16)&255)==0xe4
 shaders.append({'path':str(path),'sha256':hashlib.sha256(data).hexdigest(),'color_moves_tokens':color_moves,'color_swizzle':'xyzw','static_decode_only':True})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8e17d0','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'compiled_vertex_shaders':shaders,'sdk_reference':'C:/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/shared/d3d9types.h','findings':['Original packed-color unpack executes256cases: A,R,G,B bytes.','Archived compiled vertex shaders use identityxyzw color MOV, source token swizzleE4. No HLSL VCOLORSWIZZLE guess needed for these preserved variants.'],'limits':['Compiled vertex shader decode is static, not native hardware vertex execution. Original input declaration producer and alternate variants remain open.','Byte normalization / current viewport gamma and blending must be exercised in port GPU pipeline separately.']}
(r/'data/4.20/native_font_vertex_color_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'native_color_cases':len(cases),'compiled_identity_shader_variants':len(shaders),'passed':True}))
