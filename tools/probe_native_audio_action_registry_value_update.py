from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;table=vector+0x2000;owners=vector+0x3000;callback=vector+0x1f000;calls=[];visited=set();callback_result=0
regions=[('registry',registry,108),('table',table,24),('owners',owners,72)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==0xaf7600:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'state_notify','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(3)],'at_call':snap()});return
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'state_callback','arguments':[read(sp+4),read(sp+8)],'result':callback_result,'at_call':snap()});finish(callback_result);return
 assert 0xaf6ff0<=a<0xaf7272 or 0xaf6a30<=a<0xaf6a72 or 0xaf7600<=a<0xaf764d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,lookup,instant,skip_notify,callback_kind,value_kind in itertools.product([0,0xa5],['empty','first','last','missing','duplicate'],[0,1,256],[0,1,256],['null','false','true','upper'],['same','different']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 key=0x12345678;old_value=0x11223344;new_value=old_value if value_kind=='same'else 0xaabbccdd;w(registry,table);w(registry+4,0 if lookup=='empty'else 3);w(registry+8,3);w(registry+12,0)
 for i in range(3):
  w(table+i*8,key if(lookup=='first'and i==0)or(lookup=='last'and i==2)or(lookup=='duplicate'and i<2)else key+i+1);w(table+i*8+4,owners+i*24);w(owners+i*24,37+i);w(owners+i*24+4,old_value+i);w(owners+i*24+8,0);w(owners+i*24+12,0);w(owners+i*24+16,0)
 callback_result={'null':0,'false':0,'true':1,'upper':256}[callback_kind];w(0x14a7a0c,0 if callback_kind=='null'else callback);before=snap();calls.clear();w(stack,end)
 for i,arg in enumerate([key,new_value,instant,skip_notify]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6ff0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'lookup':lookup,'key':key,'new_value':new_value,'instant_argument':instant,'skip_notify_argument':skip_notify,'callback_kind':callback_kind,'callback_result':callback_result,'value_kind':value_kind,'before':before,'after':snap(),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF6FF0 first registry key lookup, AF7600 notification body with empty notification list, optional caller state callback low-byte veto, low-byte instant/skip flags, actual AF6A30 duration lookup empty fallback and owner-word4 current-value publication execute. Duplicate keys first owner only, missing keys, equal/different values and upper-only arguments tested. Full physical memory/call snapshots captured.','Notification list and action lists are empty; key table/owners supplied. Custom game callback is an explicit cdecl ABI adapter. Nonempty property/state transition AF5490 allocation/setup/input98, active callbacks/notifications, resource-admission reader AFB320, startup/global publishing, full frame and playback remain open. Rust replay pending.']}
(r/'data/4.20/audio_action_registry_value_update_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual registry current-value publication/notification/callback veto/low-byte cases')
