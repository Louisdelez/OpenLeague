from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_worker_packet_locale.py').read_text(encoding='utf-8').split('\nconfigs=')[0]
needle="last_error=thread_error;u.mem_write(args[5],(456).to_bytes(4,'little'));emit('CreateThread',args,handle,{'supplied_thread_id':456,'supplied_last_error':thread_error});finish(handle,24);return"
assert needle in source;source=source.replace(needle,"last_error=thread_error;emit('CreateThread',args,handle,{'output_untouched':True,'supplied_last_error':thread_error});finish(handle,24);return")
needle='[0,0,0x40029500,argument,flags,id_output if out else 0]';assert needle in source;source=source.replace(needle,'[0x74000000,0,0x40029500,argument,flags,id_output if out else 0]')
exec(compile(source,'native-thread-error1305','exec'))
configs=[(lay,True,0,1305,out,arg,flags,locale)for lay,out,arg,flags,locale in itertools.product(['none','all'],[False,True],[0,0xffffffff],[0,4],['default','clone_zero','clone_max'])]
for cfg in configs:execute(*cfg)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+956),(incoming,incoming+956),(custom_locale,custom_locale+160),(stack+12,stack+16),(id_output,id_output+4),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[execute(*cfg)for cfg in configs]
def word(row,a):
 for n,base,size in regions:
  if base<=a and a+4<=base+size:return int.from_bytes(bytes.fromhex(row['after'][n])[a-base:a-base+4],'little')
 raise AssertionError(hex(a))
for row in rows:assert word(row,record+12)==1305 and word(row,record+8)==22 and row['freed']==[incoming] and row['id_output']==0xa5a5a5a5 and row['last_error']==1305
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':0xc9c27c,'native_error_mapping':0xc9b75f,'windows_error':1305,'errno':22,'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Entire original nonNULL beginthreadex producer/constructor/free-only/error mapping bodies execute with error1305 and unchanged thread-ID output, matching the actually observed Windows rejection branch. Default/distinct zero/MAX parent locale and TLS/FLS choices retained with complete service/final banks.','Native API failure supplied in emulator; no physical descriptor validation here. Actual x86/x64 Windows error separately qualified. New native48 cases are observations; not an additional full-bank Rust replay beyond existing384 packet comparisons.']}
(r/'data/4.20/audio_crt_worker_packet_error1305_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_thread_error1305.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured48 complete original packet/constructor/free/error1305 mapping cases; native errno22 and untouched outputs confirmed')
