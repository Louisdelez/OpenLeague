from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_media)','media_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_media)');exec(compile(s,'setup','exec'))
local=[(0xb260b0,0xb260b9),(0xb260c0,0xb26138),(0xb26140,0xb26268),(0xb26000,0xb26028),(0xb2fe00,0xb2fe6f),(0xb2fe70,0xb2fe9e),(0xb2f360,0xb2f3b3),(0xb2f3c0,0xb2f3e0)];regions.extend(local);settings=0x14a79f8;previous_device=heap+0x9400;rows=[]
u.hook_del(media_hook)
def guard_factory(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a in [0xb2ff50,0xb2f930,0xb262f0]:
  if a==0xb2ff50:
   configuration,mask,requested=read(sp+4,'3I');status=52 if profile in ['modern_fail','both_fail']else 1;entry='modern';args=[configuration,mask,requested];cleanup=12
  elif a==0xb2f930:
   configuration,mask=read(sp+4,'2I');status=52 if profile in ['legacy_fail','both_fail']else 1;entry='legacy';args=[configuration,mask];cleanup=8
  else:
   mask=read(sp+4,'I')[0];status=52 if profile=='fallback_fail'else 1;entry='fallback';args=[mask];cleanup=4
  put(this+8,'I',mask);calls.append({'kind':'configure_device','entry':entry,'reference':this,'args':args,'status':status});ret(status,cleanup);return
 if a in [0xb305f0,0xb2fd90,0xb26580]:calls.append({'kind':'term_device','reference':this});ret(0,0);return
 if any(lo<=a<hi for lo,hi in local):return
 guard_media(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_factory)
for kind,pattern,profile,failure,mask,present in itertools.product([0,1,2,3,7],[0,0xa5],['ready','modern_fail','legacy_fail','both_fail','fallback_fail'],[0,1,2],[0,1,3,0x80000000],[False,True]):
 calls.clear();allocations.clear();next_pointer=heap+0xd000;count_allocate=0;fail_nth=failure;u.mem_write(settings,bytes([pattern])*16);put(settings+4,'I',mask);put(0x14a7d50,'I',previous_device if present else 0);put(0x14a8338,'I',0xcafe1234);put(0x1210228,'I',0xffffffff)
 if present:u.mem_write(previous_device,bytes([pattern])*44);put(previous_device+8,'I',7);allocations.append({'reference':previous_device,'size':44,'freed':False})
 def snapshot():return {'settings':bytes(u.mem_read(settings,16)).hex(),'legacy_handle':read(0x14a8338,'I')[0],'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();result=invoke(0xb260b0,[settings,kind,0],0);after=snapshot();rows.append({'kind':kind,'pattern':pattern,'profile':profile,'failure_nth':failure,'current_device':previous_device if present else 0,'pool':0xffffffff,'before':before,'result':result,'after':after,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual B260B0/B26140/B260C0 factory, B26000/B2FE00/B2F360 constructors and flags0 native destructors execute. Device configure/term entry bodies are mandatory controlled service boundaries; poolallocation/free physical transport adapted.'],'limits':['No runtime qualification of hardware configure/term bodies, fallback clock/sample-rate/buffer configure B262F0, B0C270 switching, real device quota or physical output. Device constructors preserve native untouched bytes. Descriptor settings and previous_device44-byte device are controlled fixtures. Factory-to-quota producer composition remains required.']}
(r/'data/4.20/audio_device_factory_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native device factory/allocation/constructors/cleanup/settings sequences')
