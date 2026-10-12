from pathlib import Path
import json,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_owner_properties.py').read_text(encoding='utf-8').split('\nrows=[]')[0],'owner setup','exec'))
custom_table=vector+0x16000;visibility_callback=end+0x100;callback_value=False
u.mem_write(custom_table,bytes(u.mem_read(0x10a4960,0x100)));w(custom_table+0x90,visibility_callback)
def visibility_hook(uc,a,size,user):
 if a==visibility_callback:finish(int(callback_value))
u.hook_add(unicorn.UC_HOOK_CODE,visibility_hook)
rows=[]
for enabled,mode,callback_value,present,owner_live in itertools.product([False,True],repeat=5):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 live=True;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,custom_table);w(wrapper+0xb0,0x212);w(0x2d628c0,0);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 u.mem_write(wrapper+0x158,bytes([enabled]));w(wrapper+0x12c,int(mode))
 w(body,0x10b2b5c);u.mem_write(body+0x60,struct.pack('<3f',100.,200.,300.));u.mem_write(body+0x6c,struct.pack('<3f',0.,0.,1.));w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(handle,body);w(owner_control+4,30 if owner_live else 0);w(owner_control+8,30);w(provider_control+4,30);w(provider_control+8,30)
 if present:run(0x6c9bd0,wrapper,[provider,provider_control])
 before=properties();result=run(0x6c97b0,wrapper,[0]);after=properties()
 expected=int(not(enabled and callback_value and mode))
 assert after['visibility']==expected,(enabled,mode,callback_value,present,owner_live,after)
 rows.append(dict(enabled_158=enabled,mode_12c=int(mode),wrapper_callback=callback_value,provider_present=present,owner_live=owner_live,before=before,after=after,continues=bool(result&255),expected_suppression=expected))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['6C97B0','718ED0','586220','928560'],findings=['Source byte84 is suppression, not an affirmative visible flag: transfer maps it to instance1DC bit8, and93F2F0 rejects that bit.','Wrapper158 false, virtual90 false, or wrapper12C zero forces suppression1.','Concrete projectile provider body98 returns true; provider acquisition/loss does not force an additional suppression in these profiles.'],adapters=['Inherited factory allocation/resource/bounds adapters; wrapper constructor and visibility field producers remain unqualified.','Wrapper virtual90 explicitly supplied boolean; its global spectator/team/visibility consumers remain unqualified.','Original concrete projectile provider callback and Troy setter execute; secondary provider absent, optional body absent, lists empty.'],limits=['No production visibility integration claimed: virtual90 and fields158/12C need native construction and world/team providers.','No full frame, rendered visibility or complete champion acceptance.'])
(r/'data/4.20/projectile_wrapper_visibility_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),suppressed=sum(c['after']['visibility']!=0 for c in rows),native_addresses=proof['native_instruction_addresses'])))
