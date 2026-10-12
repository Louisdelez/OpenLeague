from pathlib import Path
import json,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text(encoding='utf-8').split('\nrows=[]')[0],'team setup','exec'))
clock_root=vector+0x17000;clock_table=vector+0x17400;clock_ready=end+0x120;clock_get=end+0x130;clock_value=vector+0x17800
w(clock_root,clock_table);w(clock_table+0x20,clock_ready);w(clock_table+8,clock_get);w(clock_value,0x40e00000);u.mem_write(clock_get,b'\xd9\x05'+struct.pack('<I',clock_value)+b'\xc3');w(0x2d791a8,clock_root)
def activate_hook(uc,a,size,user):
 if a==clock_ready:finish(1)
u.hook_add(unicorn.UC_HOOK_CODE,activate_hook)
rows=[]
for root_value,team_id,mask,present in itertools.product([False,True],[None,100,200],[0,1,2,3],[False,True]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 live=True;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 w(0x2d77f48,0 if team_id is None else team)
 if team_id is not None:w(team+0x18,team_id)
 w(wrapper+0x15c,mask);assert read(wrapper+0x12c)==1
 w(body,0x10b2b5c);u.mem_write(body+0x60,struct.pack('<3f',100.,200.,300.));u.mem_write(body+0x6c,struct.pack('<3f',0.,0.,1.));w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(handle,body);w(owner_control+4,30);w(owner_control+8,30);w(provider_control+4,30);w(provider_control+8,30)
 if present:run(0x6c9bd0,wrapper,[provider,provider_control])
 run(0x6c97b0,wrapper,[0]);dormant=properties();assert dormant['visibility']==1
 run(0x6c9b60,wrapper,[]);active=properties();enabled=u.mem_read(wrapper+0x158,1)[0];assert enabled==1
 visible=not root_value or team_id is None or bool(mask&(1 if team_id==100 else 2));assert active['visibility']==int(not visible)
 run(0x6c9bc0,wrapper,[]);disabled_before_update=properties();assert u.mem_read(wrapper+0x158,1)[0]==0 and disabled_before_update==active
 run(0x6c97b0,wrapper,[0]);disabled=properties();assert disabled['visibility']==1
 rows.append(dict(root_filter_enabled=root_value,team_id=team_id,team_mask=mask,provider_present=present,mode_12c=1,dormant=dormant,active=active,disabled_before_update=disabled_before_update,disabled=disabled))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['7172B0','6C8E30','6C9B60','6C9BC0','6C97B0','6CA0A0'],findings=['Original load6C8E30 sets wrapper12C=1. Original activation6C9B60 sets158=1 then immediately calls wrapper5C=6C97B0 with root time.','Activation removes suppression only when native team callback permits visibility.','Original deactivation6C9BC0 clears158 without immediate Troy setter; next accepted wrapper update writes suppression1.'],adapters=['Inherited zero-initialized wrapper allocation with original table; constructor itself omitted.','Clock root20 supplies ready=true and root8 supplies7.0; root time source unqualified.','Native team callback and concrete projectile provider execute; global filter/team/mask supplied.'],limits=['Native activation/deactivation callers and frame ordering remain unqualified.','No original team/FOW producers or current graphical integration claimed.'])
(r/'data/4.20/projectile_visibility_activation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=proof['native_instruction_addresses'])))
