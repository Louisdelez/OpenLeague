from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_crt_custom_locale_lifecycle.py').read_text(encoding='utf-8').split("\nfor args in itertools.product")[0]
needle="populate(conversion,count,'all',True,True);w(locale,count);w(record+0x6c,locale)";assert needle in source
source=source.replace(needle,needle+"\n u.mem_write(time_payloads,bytes([0xa5])*89*32)\n for j in range(89):\n  off=j*4\n  if off in[0xac,0xb0]:continue\n  if time_mode=='all'or(time_mode=='alternating'and j%2==0):w(time+off,time_payloads+j*32)")
exec(compile(source,'original-custom-lifecycle-with-time-payloads','exec'))
time_payloads=vector+0x18000;custom.extend([(time_payloads+j*32,32)for j in range(89)]);time_mode='all'
for time_mode,count,lay in itertools.product(['all','alternating'],[1,2],['none','all']):lifetime('heap',count,lay)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+0x3bc),(storage,storage+36*24)]+[(a,a+z)for a,z in custom]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[]
for time_mode,count,lay in itertools.product(['all','alternating'],[1,2],['none','all']):
 v=lifetime('heap',count,lay);v['time_payloads']=time_mode;rows.append(v)
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual complete startup, old locale release, controlled custom install, thread destruction including CA8A15+CC8564 and system cleanup execute. All/alternating distinct time payloads, zero-final vs shared-final locale refcount and TLS/FLS captured. All89 physical payload slots retained; actual original87 ordered payload frees observed at allocator boundary.','Custom structures/allocation identities supplied explicitly, with exact controlled input banks; no original normal locale/time creation producer or actual heap/OS/SEH/concurrency proof. Rust replay pending.']}
(r/'data/4.20/audio_crt_time_locale_lifecycle_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_time_locale_lifecycle.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'full original custom thread lifetimes with distinct temporal payloads;',len(regions),'canonical regions')
