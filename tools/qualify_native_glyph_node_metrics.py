from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native glyph node prerequisites','exec'))
owner=vector+0x6000;glyph=vector+0x7000;status=vector+0x8000
def signed(v):return v if v<0x80000000 else v-0x100000000
def hook(uc,a,size,user):
 if a==0x5cc070:
  out=uc.reg_read(UC_X86_REG_ECX);assert out==owner+0x30;w(out,glyph);w(out+4,0);finish(out,4);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for (advance,width,bottom),extra,shadow,outline,character,prefill in itertools.product([(8,7,10),(-3,0,0),(0,12,17),(0x7fffffff,0x7fffffff,-1)],[0,1,4,0xffffffff],[0,1],[0,1],[0,65,0xffff],[0,0xa5]):
 u.mem_write(owner,bytes([prefill])*0x38);w(glyph+4,advance);w(glyph+0xc,width);w(glyph+0x10,bottom);w(status,0xdeadbeef)
 w(stack,end)
 for i,value in enumerate([shadow,outline,extra,character,status,glyph,0]):w(stack+4+i*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8c0be0,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+32 and read(status)==0
 actual=[signed(read(owner+offset)) for offset in [4,8,12]]
 expected=[signed((width+1+2*extra+16*shadow+2*outline)&0xffffffff),signed((bottom+2*extra+16*shadow)&0xffffffff),signed((advance+2*extra)&0xffffffff)];assert actual==expected
 assert bytes(u.mem_read(owner+2,2))==character.to_bytes(2,'little')
 assert read(owner+0x28)==read(owner+0x2c)==0x3f800000
 cases.append({'advance':advance,'width':width,'bottom':bottom,'extra':extra,'shadow':bool(shadow),'outline':bool(outline),'character_utf16':character,'prefill':prefill,'node_width':actual[0],'node_height':actual[1],'node_advance':actual[2],'output_hex':bytes(u.mem_read(owner,0x38)).hex()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c0be0','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'limits':['Original atlas-glyph metadata constructor executes; supplied shared-glyph pointer adapter avoids native reference lifecycle. Native glyph metric fields supplied.','Extra is descriptor field1C. Shadow flag4 adds16 to cell width/height, outline flag2 adds2 to width; advance adds2*extra only. Arithmetic preserves wrapping32bit words.','Rasterization, shadow blur, outline generation, atlas packing, native allocation and GPU drawing remain unqualified.']}
(r/'data/4.20/native_glyph_node_metrics_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited)}))
