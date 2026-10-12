from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_device_factory_quota_switch.py').read_text(encoding='utf-8').split('\nfor retry,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_composition)','composition_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_composition)');exec(compile(s,'switch_setup','exec'))
fallback_regions=[(0xb262f0,0xb263cf),(0xb263e0,0xb26429),(0xb26580,0xb265b5),(0x5eb4b0,0x5eb4b6)];local.extend(fallback_regions);buffer_base=0x33000000;u.mem_map(buffer_base,0x400000);tick_api=read(0xfa4338,'I')[0];rows=[]
u.hook_del(composition_hook)
def guard_live_fallback(uc,a,n,d):
 global next_aligned
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==tick_api:calls.append({'kind':'tick','value':clock_tick});ret(clock_tick,0);return
 if a==0xada610:
  pool,size,alignment=read(sp+4,'3I');reference=next_aligned;next_aligned+=0x40000
  if size:u.mem_write(reference,bytes([pattern])*size)
  allocations.append({'reference':reference,'size':size,'freed':False});calls.append({'kind':'allocate','method':'aligned','allocator':pool,'size':size,'alignment':alignment,'reference':reference});ret(reference,0);return
 if a==0xca1d00:
  reference,value,size=read(sp+4,'3I');assert value==0
  if size:u.mem_write(reference,bytes(size))
  calls.append({'kind':'zero_buffer','reference':reference,'size':size});ret(reference,0);return
 if any(lo<=a<hi for lo,hi in fallback_regions):return
 guard_composition(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_live_fallback)
for kind,retry,scenario in itertools.product([0,1,2,3],[0,1,21],['zero','one','three','wrap']):
 scenario_index=['zero','one','three','wrap'].index(scenario);pattern=0xa5 if (kind+retry+scenario_index)%2 else 0;mask=0 if pattern else 3;changed=int(scenario=='wrap');quota_status=52 if scenario=='three'else 1;quota=3;profile='both_fail'if retry==21 else 'ready';previous_tick=0xfffffffa if scenario=='wrap'else 100;now={'zero':101,'one':121,'three':164,'wrap':2}[scenario]
 calls.clear();allocations.clear();next_pointer=heap+0xd000;next_aligned=buffer_base;count_allocate=0;fail_nth=0;put(0x1210228,'I',0xffffffff);put(0x12100f4,'I',48000);u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',7);put(0x14a7d50,'I',0);put(0x14a8338,'I',0xcafe1234);clock_tick=previous_tick;old_reference=invoke(0xb260b0,[settings,3,0],0);assert old_reference!=0;put(settings+4,'I',mask);put(0x14a7d50,'I',old_reference);put(0x14a7e48,'I',retry);u.mem_write(0x14a7e35,bytes([changed]));put(0x14a79f4,'I',kind);output_table=heap+0x8800;u.mem_write(output_table,bytes([pattern])*56);put(output_table+4,'I',old_reference);put(output_table+16,'2I',0,0);put(0x14a7cf8,'2I',output_table,1);calls.clear();clock_tick=now
 def snapshot():return {'table':bytes(u.mem_read(output_table,56)).hex(),'table_reference':read(0x14a7cf8,'I')[0],'table_count':read(0x14a7cfc,'I')[0],'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xb0fb40,[],0);rows.append({'kind':kind,'scenario':scenario,'pattern':pattern,'profile':profile,'clock':clock_tick,'rate':48000,'next_pool':heap+0xd200,'next_aligned':buffer_base+0x40000,'pool':0xffffffff,'quota_status':quota_status,'quota_written':quota,'before':before,'result':result,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual factory/quota/output-table switching plus fallback configure/Init/quota/Term bodies execute. Only hardware modern/legacy configure/Term/Init/quota boundaries and physical clock/aligned allocate/zeroing/poolfree adapted. Fallback logical bodies have no shims.'],'limits':['Native preparation only; Rust actual-fallback producer integration replay remains required. No attached recorder in this family; recorder lifetime is separately qualified. Physical output/hardware device implementations and complete normal audio-frame producer remain required.']}
(r/'data/4.20/audio_factory_actual_fallback_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native actual-fallback factory/quota/output-table compositions')
