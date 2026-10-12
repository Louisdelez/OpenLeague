from pathlib import Path
import json,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_owner_properties.py').read_text(encoding='utf-8').split('\nrows=[]')[0],'owner setup','exec'))
root=vector+0x16000;root_table=vector+0x16400;team=vector+0x16800;root_callback=end+0x110;root_value=False
w(root,root_table);w(root_table+0xb0,root_callback);w(0x2d787b8,root)
def visibility_hook(uc,a,size,user):
 if a==root_callback:finish(int(root_value))
u.hook_add(unicorn.UC_HOOK_CODE,visibility_hook)
rows=[]
for excluded,root_value,team_id,mask,owner_state in itertools.product([False,True],[False,True],[None,100,200,300],[0,1,2,3],['absent','expired','live']):
 for a,n in [(wrapper,0x200),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 w(wrapper,0x10a4960);w(wrapper+0xb0,0x212|(0x20 if excluded else 0));w(wrapper+0x15c,mask)
 w(0x2d77f48,0 if team_id is None else team)
 if team_id is not None:w(team+0x18,team_id)
 w(body,0x10b2b5c);w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(handle,body);w(owner_control+4,30 if owner_state=='live' else 0);w(owner_control+8,30)
 if owner_state!='absent':w(wrapper+0x148,provider)
 result=bool(run(0x6ca0a0,wrapper,[])&255)
 expected=not excluded and (not root_value or team_id is None or bool(mask&(1 if team_id==100 else 2)))
 assert result==expected,(excluded,root_value,team_id,mask,owner_state,result)
 rows.append(dict(excluded_type_20=excluded,root_filter_enabled=root_value,team_id=team_id,team_mask=mask,owner_state=owner_state,visible=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['6CA0A0','718DD0','718E30','586220'],findings=['Wrapper type bit20 returns false immediately.','Otherwise concrete primary projectile provider90 returns true; absent/expired primary also reaches the global filter.','Global virtualB0 false or missing team object returns true; enabled filter selects mask bit1 for team100, bit2 for all other observed team values.'],adapters=['Global root virtualB0 returns supplied boolean; team global object/id and wrapper mask supplied. Their producers remain unqualified.','Original wrapper virtual90, primary provider weak acquisition and concrete body90 execute; secondary provider absent.'],limits=['Other actor provider implementations and the secondary-only rejection branch remain open.','This is the native visibility consumer, not native FOW rasterization, source construction, scheduling or graphical acceptance.'])
(r/'data/4.20/projectile_team_visibility_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=proof['native_instruction_addresses'])))
