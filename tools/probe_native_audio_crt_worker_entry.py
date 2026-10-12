from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_audio_crt_thread_system_startup.py').read_text().split('\nfor lay,fail in itertools.product')[0]
needle='u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))'
assert needle in source
source=source.replace(needle,'u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory);baseline=bytes(u.mem_read(base,len(image)))')
exec(compile(source,'worker-entry-setup','exec'));original_hook=hook
incoming=vector+0x14000;phase=False;terminal=None
exit_ref=vector+0x29200;w(0xfa42d8,exit_ref);api_addresses[exit_ref]='ExitThread';baseline=bytes(u.mem_read(base,len(image)))
def entry_hook(uc,a,z,user):
 global terminal
 if phase and a==0xc9c439:terminal='com_stage';u.emu_stop();return
 if phase and a==exit_ref:
  emit('ExitThread',[read(u.reg_read(UC_X86_REG_ESP)+4)],0);terminal='exit';u.emu_stop();return
 original_hook(uc,a,z,user)
u.hook_add(unicorn.UC_HOOK_CODE,entry_hook)
def execute(lay,state,function,argument,handle):
 global phase,terminal,tls_value,failure
 phase=False;terminal=None;run(0,0x11223344,lay,'none')
 u.mem_write(incoming,bytes(956));w(incoming+0x5c,0x106b708)
 for off,value in [(0x54,function),(0x58,argument),(4,handle)]:w(incoming+off,value)
 if state!='existing':tls_value=0
 failure='set'if state=='publication_failure'else'none'
 before=snapshot();calls.clear();freed.clear();allocations.clear();phase=True
 w(stack,end);w(stack+4,incoming);u.reg_write(UC_X86_REG_ESP,stack)
 u.emu_start(0xc9c3dc,end,count=30000);assert terminal
 if state=='existing':assert freed==[incoming] and tls_value==record
 elif state=='empty':assert freed==[] and tls_value==incoming and read(incoming)==123
 else:assert freed==[] and tls_value==0 and calls[-1]['kind']=='ExitThread'
 return {'layout':lay,'state':state,'function':function,'argument':argument,'handle':handle,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'allocations':list(allocations),'tls_value':tls_value,'last_error':last_error,'terminal':terminal}
configs=list(itertools.product(['none','all'],['existing','empty','publication_failure'],[0,0x40029500,0xffffffff],[0,0x40029600,0xffffffff],[0,97,0xffffffff]))
for cfg in configs:execute(*cfg)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+956),(incoming,incoming+956),(storage,storage+36*24)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[execute(*cfg)for cfg in configs]
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':0xc9c3dc,'stop_before_com':0xc9c439,'incoming_reference':incoming,'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Original C9C3DC executes slot lookup, fresh packet publication and thread identity, or three-field transfer and complete original incoming packet destructor. Publication failure executes GetLastError and terminal imported ExitThread boundary.','Stops before already separate COM producer C9C439. Supplied Windows/heap outcomes, no actual OS worker, callback body, SEH or whole game qualification. Incoming packet has no optional owned allocations or locale references.']}
(r/'data/4.20/audio_crt_worker_entry_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_worker_entry.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Captured',len(rows),'original entry cases;',len(regions),'banks')
