from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native kerning prerequisites','exec'))
left=vector+0x6000;right=vector+0x6100;face=vector+0x7000;calls=[]
def hook(uc,a,size,user):
 if a==0xc3b060:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(5)];assert args[:4]==[face,left_index,right_index,0]
  w(args[4],value);w(args[4]+4,29);calls.append({'left':left_index,'right':right_index,'mode':0,'kerning_x_26_6':value,'return_code':0});finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(left+0x24,face);cases=[]
for left_index,right_index,value in itertools.product([0,1,34,8380],[0,1,57,8380],[-129,-65,-1,0,63,64,65,129]):
 calls.clear();w(left+0x2c,left_index);w(right+0x2c,right_index);w(stack,end);w(stack+4,right);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,left)
 u.emu_start(0x8c23f0,end,count=200);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+8
 actual=read_value=u.reg_read(UC_X86_REG_EAX);actual=actual if actual<0x80000000 else actual-0x100000000;assert actual==value>>6
 cases.append({'left':left_index,'right':right_index,'kerning_x_26_6':value,'pixels':actual,'calls':list(calls)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c23f0','kerning_api':'0xc3b060','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'limits':['Original glyph kerning method executes with supplied successful FT_Get_Kerning provider. Mode0 and signed shift6 preserved.','Native actual font pair values, errors, kerning callers and whole text layout remain separately unqualified.']}
(r/'data/4.20/native_glyph_kerning_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited)}))
