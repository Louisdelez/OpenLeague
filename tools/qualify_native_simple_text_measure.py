from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native text measure prerequisites','exec'))
owner=vector+0x6000;face=vector+0x7000;node=vector+0x8000;text_pointer=vector+0x9000;out=vector+0xa000;calls=[]
def signed(v):return v if v<0x80000000 else v-0x100000000
def advance(character):return (character%13)+1 if profile=='normal' else (-3 if profile=='negative' else 0x7fffffff)
def hook(uc,a,size,user):
 if a==0x8be6b0:
  sp=uc.reg_read(UC_X86_REG_ESP);character=read(sp+4);assert uc.reg_read(UC_X86_REG_ECX)==owner
  success=character!=failure;value=advance(character);calls.append({'character_utf16':character,'available':success,'node_advance':value if success else None});w(node+0xc,value);finish(node if success else 0,4);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);texts=[None,[],[65],[32,32],[65,86],[65,32,233],[65,0,86],[233,0x4e2d]];cases=[]
for text,space,line_height,profile,failure in itertools.product(texts,[0,3,-2],[0,17,32],['normal','negative','overflow'],[None,65,86,233]):
 calls.clear();w(owner+4,face);w(face+0x10,space);w(face+0xc,line_height);u.mem_write(face+0x14,(32).to_bytes(2,'little'))
 if text is not None:u.mem_write(text_pointer,b''.join(c.to_bytes(2,'little') for c in text)+b'\0\0')
 w(out,0xaaaaaaaa);w(out+4,0xbbbbbbbb);w(stack,end);w(stack+4,0 if text is None else text_pointer);w(stack+8,out);w(stack+12,out+4)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8bf600,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+16
 active=[] if text is None else text[:text.index(0)] if 0 in text else text;total=0;success=True
 for character in active:
  if character==32:total=(total+space)&0xffffffff
  elif character==failure:success=False;break
  else:total=(total+advance(character))&0xffffffff
 expected_width=signed(total) if success and active else 0;expected_height=line_height if success and active else 0
 assert bool(u.reg_read(UC_X86_REG_EAX)&255)==success;assert signed(read(out))==expected_width and signed(read(out+4))==expected_height
 cases.append({'text_utf16':text,'space_advance':space,'line_height':line_height,'metric_profile':profile,'failed_character_utf16':failure,'success':success,'width':signed(read(out)),'height':signed(read(out+4)),'calls':list(calls)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8bf600','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'limits':['Original simple measure method executes; glyph cache lookup and node advances supplied explicitly. Space code32 and font height/space advance supplied.','Null and empty strings succeed with zero dimensions; embedded NUL terminates; glyph failure clears dimensions and stops lookup; accumulated advance wraps32bits.','No kerning in this specific simple measure branch. Rich text, wrapping, alignment, actual glyph node producer, atlas and GPU drawing are separate.']}
(r/'data/4.20/native_simple_text_measure_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited)}))
