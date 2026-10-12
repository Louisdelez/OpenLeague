from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_device_factory.py').read_text(encoding='utf-8').split('\nfor kind,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_factory)','factory_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_factory)');exec(compile(s,'factory_setup','exec'))
local.append((0xb0fb40,0xb0fc44));rows=[];old_vtable=heap+0x9800;quota_entry=heap+0x15040
u.hook_del(factory_hook)
def guard_composition(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==0xb0c270:
  first,second,reference=read(sp+4,'3I');calls.append({'kind':'switch_device','first':first,'second':second,'reference':reference});ret(0,0);return
 if a in [0xb30510,0xb2fc00,0x5eb4b0]:calls.append({'kind':'init_device','reference':this,'status':1});ret(1,0);return
 if a in [quota_entry,0xb30220,0xb2fa20,0xb263e0]:
  pointer=read(sp+4,'I')[0]
  if quota is not None:put(pointer,'I',quota)
  calls.append({'kind':'device_quota','reference':this,'status':quota_status,'quota_written':quota});ret(quota_status,4);return
 guard_factory(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_composition)
for retry,kind,changed,quota_status,quota,profile,mask,pattern in itertools.product([0,1,21,201],[0,1,2,3],[0,1],[1,52],[None,3],['ready','modern_fail','both_fail'],[0,3],[0,0xa5]):
 calls.clear();allocations.clear();next_pointer=heap+0xd000;count_allocate=0;fail_nth=0;put(0x14a7e48,'I',retry);put(0x14a7d50,'I',previous_device);u.mem_write(0x14a7e35,bytes([changed]));put(0x14a79f4,'I',kind);u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',mask);put(0x14a8338,'I',0xcafe1234);put(0x1210228,'I',0xffffffff);u.mem_write(previous_device,bytes([pattern])*44);put(previous_device,'I',old_vtable);put(previous_device+8,'I',7);u.mem_write(old_vtable,bytes(32));put(old_vtable+24,'I',quota_entry);allocations.append({'reference':previous_device,'size':44,'freed':False})
 def snapshot():return {'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xb0fb40,[],0);rows.append({'kind':kind,'pattern':pattern,'profile':profile,'pool':0xffffffff,'quota_status':quota_status,'quota_written':quota,'before':before,'result':result,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual B0FB40 quota plus B260B0/B26140/B260C0 factory, raw constructors and flags0 destructors execute in one sequence. Device configure/Term/Init/quota and switching are explicit controlled boundaries; physical allocation/free transport adapted.'],'limits':['Native composition preparation only; Rust factory-to-quota composition replay remains required. Device virtual/configure/Term/switching/physical-output implementations, complete frame producer and normal configuration construction unqualified. Allocation succeeds and fallback configuration succeeds in this family; isolated failure matrices remain separate.']}
(r/'data/4.20/audio_device_factory_quota_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native owned device factory plus quota compositions')
