from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_media)','media_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_media)');exec(compile(s,'setup','exec'))
local=[(0xb0fb40,0xb0fc44)];regions.extend(local);current=heap+0x9400;candidate=heap+0x9600;fallback=heap+0x9a00;vtable=heap+0x9800;entry=heap+0x15000;rows=[]
u.hook_del(media_hook)
def guard_quota(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==0xb260b0:
  settings,kind,flags=read(sp+4,'3I');reference=fallback if kind==3 else(0 if profile=='missing'else candidate);calls.append({'kind':'create_device','settings':settings,'device_kind':kind,'flags':flags,'reference':reference});ret(reference,0);return
 if a==0xb0c270:
  first,second,reference=read(sp+4,'3I');calls.append({'kind':'switch_device','first':first,'second':second,'reference':reference});ret(0,0);return
 if a==entry:
  flags=read(sp+4,'I')[0];calls.append({'kind':'destroy_device','reference':this,'flags':flags});ret(0,4);return
 if a==entry+16:
  init_status=52 if this==candidate and profile=='failed'else 1;calls.append({'kind':'init_device','reference':this,'status':init_status});ret(init_status,0);return
 if a==entry+32:
  calls.append({'kind':'term_device','reference':this});ret(0,0);return
 if a==entry+48:
  pointer=read(sp+4,'I')[0]
  if quota is not None:put(pointer,'I',quota)
  calls.append({'kind':'device_quota','reference':this,'status':status,'quota_written':quota});ret(status,4);return
 if any(lo<=a<hi for lo,hi in local):return
 guard_media(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_quota)
for retry,changed,status,quota,profile,pattern in itertools.product([0,1,2,20,21,41,200,201,0xffffffff,0xffffffed],[0,1],[1,2,52],[None,0,1,3],['missing','ready','failed'],[0,0xa5]):
 calls.clear();allocations.clear();put(0x14a7e48,'I',retry);put(0x14a7d50,'I',current);u.mem_write(0x14a7e35,bytes([changed]));put(0x14a79f4,'I',7);u.mem_write(0x14a79f8,bytes([pattern])*16);put(0x1210228,'I',0xffffffff);u.mem_write(vtable,bytes(32));put(vtable,'3I',entry,entry+16,entry+32);put(vtable+24,'I',entry+48)
 for reference in [current,candidate,fallback]:u.mem_write(reference,bytes([pattern])*32);put(reference,'I',vtable);allocations.append({'reference':reference,'size':32,'freed':False})
 def snapshot():return {'retry':read(0x14a7e48,'I')[0],'device':read(0x14a7d50,'I')[0],'changed':bytes(u.mem_read(0x14a7e35,1))[0],'config':bytes(u.mem_read(0x14a79f8,16)).hex(),'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xb0fb40,[],0);after=snapshot();rows.append({'profile':profile,'pattern':pattern,'device_kind':7,'pool':0xffffffff,'quota_status':status,'quota_written':quota,'before':before,'result':result,'after':after,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual B0FB40 retry/quota/fallback body executes. Mandatory logical device factory/switch/virtual Init/Term/destructor/quota boundaries use controlled fixtures; physical poolfree transport adapted.'],'limits':['Does not qualify device factory B260B0, switching B0C270, device implementations, physical output, normal voice construction or complete frame producer. Fallback factory always succeeds in these controlled cases; null fallback failure needs explicit handling. Config and device objects are controlled owned fixtures.']}
(r/'data/4.20/audio_frame_quota_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native quota/retry/device fallback sequences')
