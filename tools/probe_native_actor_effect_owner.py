"""Execute native actor effect-owner vtable10B0E1C scalar/vector methods."""
from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
provider=vector+0x6000;handle=vector+0x7000;control=vector+0x7100;actor=vector+0x8000;output=vector+0xa000
logs=0

def owner_hook(uc,a,size,user):
 global logs
 if a==0x5fa170:
  logs+=1;finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,owner_hook)
cases=[]
for live,kind,flag,primary,oldid,newid,death in itertools.product([False,True],['other','missile','unit'],[False,True],[0,1],[7],[7,8],[0,1]):
 w(provider+4,handle);w(provider+8,control);w(provider+0xc,oldid);w(handle,actor);w(control+4,2 if live else 0);w(control+8,2)
 w(actor+0x1c,0x400 if flag else 0);w(actor+4,0x2d6da00 if kind=='missile' else 0x12345);w(actor+0x114,newid);w(actor+0x118,primary);w(actor+0x50c,death)
 position=[123.5,-24.,9876.25];direction=[-.25,0.,.75]
 for off,values in [(0x60,position),(0x6c,direction)]:u.mem_write(actor+off,struct.pack('<3f',*values))
 result={};before_logs=logs
 for key,entry,arg in [('eligible',0x718dd0,False),('position',0x719760,True),('direction',0x7197f0,True),('primary',0x719200,False),('secondary',0x7192c0,False)]:
  u.mem_write(output,b'\xa5'*12);w(stack,end);w(stack+4,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,provider);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(entry,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
  value=u.reg_read(UC_X86_REG_EAX)&255
  result[key]=dict(ok=bool(value),words=list(struct.unpack('<3I',u.mem_read(output,12)))) if arg else value
  assert read(control+4)==(2 if live else 0),'strong refcount not restored'
 expected_primary=primary if flag else int(death==0 and kind=='missile')
 assert result['eligible']==int(live)
 assert result['position']['ok']==live and result['direction']['ok']==live
 assert result['primary']==(expected_primary if live else 0),result
 assert result['secondary']==int(live and flag and newid!=oldid),result
 cases.append(dict(live=live,kind=kind,flag=flag,primary=primary,previous_id=oldid,current_id=newid,death=death,position=position,direction=direction,result=result,diagnostic_calls=logs-before_logs))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),vtable='0x10b0e1c',entries={'eligible':'0x718dd0','position':'0x719760','direction':'0x7197f0','primary':'0x719200','secondary':'0x7192c0'},native_instruction_addresses=len(visited),cases=cases,adapters=['Explicit weak/shared owner fields; original5BD6F0/5EC2A0/5CCF80 execute including atomic reference acquisition/release.','Only diagnostic logger5FA170 stubbed for missing owner; no pose/status return stubbed.'],limits=['Orientation719890 and normalization718F70 not yet qualified.','Live wrapper and missile effect-group producer binding to Annie projection not established.','Finite ordinary vector inputs; exceptional x87 conversion not qualified.'])
(r/'data/4.20/actor_effect_owner_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))
