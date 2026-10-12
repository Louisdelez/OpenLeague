"""EffectsQuality initializer and dispatch to native Troy quality global."""
from pathlib import Path
import json,struct,hashlib
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_graphics_options.py').read_text().split('u.hook_add(unicorn.UC_HOOK_CODE,options_hook)')[0]
exec(compile(source,'options setup','exec'))
gpu=vector+0xc000

def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x8b1c20:options_hook(uc,a,size,user);return
 if a==0x835080:
  assert read(sp+4)==19;finish(configured,4);return
 if a==0x987ba0:finish(gpu);return
 if a==0x987f40:finish(0);return
 assert any(lo<=a<hi for lo,hi in [(0x835d96,0x835db6),(0x8373d0,0x8373f5),(0x837518,0x8375a2)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for configured in [-2147483648,-1,0,1,2,3,4,5,2147483647]:
 config_requests.clear();u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x100)
 u.emu_start(0x835d96,0x835db6,count=1000)
 assert config_requests==[dict(section='Performance',key='EffectsQuality',default=3,flags=0)]
 assert read(stack+0x100-8)==19 and read(stack+0x100-4)==configured&0xffffffff
 w(0x2d78aa8,0);w(stack,end);w(stack+4,19);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x8373d0,0x8375a2,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x8375a2
 assert read(0x1225888)==configured&0xffffffff and read(0x1225884)==int(configured>=3)
 rows.append(dict(configured=configured,request=config_requests[0],global_quality=read(0x1225888),high_quality=read(0x1225884),renderer_words=[read(gpu+0x18),read(gpu+0x1c)]))
proof=dict(native_sha256=hashlib.sha256(raw).hexdigest(),passed=True,complete=False,cases=rows,option_id=19,section='Performance',key='EffectsQuality',default=3,adapters=['Config getter and integer-option getter return explicit boundary values.','Renderer provider/refresh adapted; active Troy service absent. Original dispatcher branches and global writes execute.'],limits=['Renderer effects and live service quality callback not qualified.','Text parser separately qualified; INIBIN overlays and live UI changes remain separate.'])
(r/'data/4.20/audio_effects_quality_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'EffectsQuality initializer/dispatcher cases')
