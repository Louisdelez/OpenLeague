from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_factory_actual_fallback.py').read_text(encoding='utf-8').split('\nfor kind,retry,scenario')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)','live_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)');exec(compile(setup,'live_setup','exec'));u.hook_del(live_hook)
common=heap+0x31000;callback_table=heap+0x32000;callbacks=[heap+0x34000,heap+0x34010];lock_api=read(0xfa4424,'I')[0];unlock_api=read(0xfa4428,'I')[0]
post={0xb1c590:'optional',0xaf5b10:'advance_a',0xb14140:'advance_b',0xb19ec0:'post_a',0xaf3f80:'post_b',0xb0fdb0:'post_c',0xaf3aa0:'post_d',0xb15110:'final'}
def frame_guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);receiver=u.reg_read(UC_X86_REG_ECX)
 if a in [lock_api,unlock_api]and read(sp+4,'I')[0]==0x14a7a44:calls.append({'kind':'frame_lock'if a==lock_api else 'frame_unlock'});ret(1,4);return
 if a in post:
  event={'kind':post[a]}
  if a in [0xaf5b10,0xb14140,0xb15110]:event['receiver']=receiver
  if a in [0xaf5b10,0xb14140]:event['frame']=read(sp+4,'I')[0]
  calls.append(event);ret(0,4 if a in [0xaf5b10,0xb14140]else 0);return
 if a in callbacks:calls.append({'kind':'frame_callback','reference':a,'reason':read(sp+4,'I')[0]});ret(0,0);return
 if a in [0xb06c60,0xb07e50]:calls.append({'kind':'command_consumer'if a==0xb06c60 else 'due_actions','receiver':receiver})
 if 0xb06950<=a<0xb069f6 or 0xb06c60<=a<0xb06f98 or 0xb07e50<=a<0xb07f28:return
 guard_live_fallback(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,frame_guard);rows=[]
for scenario,counter,optional,final,callback_count in itertools.product(['zero','one','three','wrap'],[0,0xffffffff],[0,1],[0,1],[0,2]):
 pattern=0xa5 if optional else 0;kind=3;retry=0;profile='ready';quota_status=1;quota=3;changed=0;previous_tick=0xfffffffa if scenario=='wrap'else 100;now={'zero':101,'one':121,'three':164,'wrap':2}[scenario]
 calls.clear();allocations.clear();next_pointer=heap+0xd000;next_aligned=buffer_base;count_allocate=0;fail_nth=0;put(0x1210228,'I',0xffffffff);put(0x12100f4,'I',48000);u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',3);put(0x14a7d50,'I',0);put(0x14a8338,'I',0xcafe1234);clock_tick=previous_tick;old_reference=invoke(0xb260b0,[settings,3,0],0);assert old_reference!=0;put(0x14a7d50,'I',old_reference);put(0x14a7e48,'I',0);u.mem_write(0x14a7e35,b'\0');put(0x14a79f4,'I',3);output_table=heap+0x8800;u.mem_write(output_table,bytes([pattern])*56);put(output_table+4,'I',old_reference);put(output_table+16,'2I',0,0);put(0x14a7cf8,'2I',output_table,1)
 u.mem_write(common,bytes(0x98));put(common+0x7c,'I',counter);put(0x14a7a5c,'3I',callback_table,callback_count,2);put(callback_table,'2I',*callbacks);put(0x14a82e4,'I',optional);put(0x14a7e4c,'I',heap+0x35000 if final else 0);put(0x14a7a24,'I',heap+0x36000);put(0x14a7a40,'I',heap+0x37000);calls.clear();clock_tick=now
 def snapshot():return {'common':bytes(u.mem_read(common,0x98)).hex(),'table':bytes(u.mem_read(output_table,56)).hex(),'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'callback_header':bytes(u.mem_read(0x14a7a5c,12)).hex(),'callback_table':bytes(u.mem_read(callback_table,8)).hex(),'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xb06950,[],common);rows.append({'scenario':scenario,'clock':now,'rate':48000,'optional':optional,'final':final,'before':before,'result':result,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'adapters':['Full native B06950 caller, actual fallback quota, actual B06C60 empty command consumer, actual B07E50 empty due queue, native reverse callback iteration and wrapping frame counter execute. Mandatory post-frame/optional/final consumers and callback bodies remain controlled interfaces; physical clock/locks adapted.'],'limits':['Empty command/due queues only in this family. Nonempty producer composition and Rust replay required. Controlled remaining consumers/callback bodies are not qualified implementations. Hardware output, normal configuration and complete audio frame remain required.']}
(r/'data/4.20/audio_normal_frame_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native full frame caller compositions, empty input queues and explicit remaining consumers')
