from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-worker-exit-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 556 passed; 0 failed;'in log
n='audio_crt_worker_exit_preparation_matches124_original_full_com_lookup_cache_missing_export_tls_fls_fresh_null_context_detach_and_exit_code_cases';assert n+' ... ok'in log
proof='docs/audio_crt_worker_exit_component_validation.json';p=load(proof);assert p['passed'] and p['cases']==248 and p['native_cases']==124
for f,h in p['files_sha256'].items():assert sha(r/f)==h,f
native=load('data/4.20/audio_crt_worker_exit_preparation.json');assert native['case_count']==124 and all(v['terminal']for v in native['cases'])
refs=load('docs/audio_test_fixture_loading.json')['references'];assert len(refs)==59
for v in refs:assert sha(r/v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json');assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
name='audio_crt_worker_exit_validation';next_action='Integrate original worker exit preparation and explicit CA915B detach with owned actual TLS/FLS worker services. Qualify LoadLibraryExW/registered RoUninitialize pointer codec and lifetime services, original CABDA8 package detection/C9C384 RoInitialize strict-zero flag producer and OS thread terminal boundary; never fake an automatic legacy TLS callback. Finish legacy root fallback, fresh errno/new-handler/reentry services, full executable startup/GS/SEH and other optional export consumer ABIs. Connect locale/time/optional-buffer/dynamic-lock producers and normal audio client worker dispatch/progression/physical playback. Keep full24 domains114 tasks37 requirements; whole game remains incomplete.'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':556,'original_worker_exit_cases':124,'worker_exit_component_x86_x64_cases':248,'existing_fixture_hashes_preserved':59,'proof':proof,'test_log':logname,'next_action':next_action,
 'evidence':['Entire original C9C356 worker exit executed in x86 emulator, including CA91A9 context getter, conditional C9C459 COM release, CA915B explicit detach/CA9026 destructor and imported ExitThread terminal boundary.124 configurations cover TLS/FLS, existing/fresh/failed context, COM flags0/1/MAX, cache flags0/1/MAX, module/export absence and exit codes0/97/MAX.',
 'Rust worker-exit preparation reproduces original lazy combase.dll LoadLibraryExW flags0x800, RoUninitialize lookup, encoded pointer/cache publication and decode/invoke. Missing module/export returns without cache publication. COM release precedes explicit detach; NULL getter result bypasses both and preserves exit code.',
 'Full-core native comparison checks all service-entry and final banks, allocator/free identities, slot state, LastError, tombstones and explicit terminal code. Unchanged preparation port independently repeats all124 cases in each real x86/x64 executable,248 component comparisons.',
 'All556 audio tests pass; historical59 fixture hashes and full24/114/37 scope preserved.'],
 'limits':['COM/TLS/FLS syscall and allocator outcomes supplied during these component comparisons. Actual RoUninitialize, LoadLibrary ownership and physical ExitThread not invoked or qualified here.',
 'PreparedExit is an explicit result to be consumed by a qualified worker terminal boundary; preparing it does not terminate an OS thread. No normal audio worker integration claim.',
 'Fresh lookup uses one controlled source record allocation; runtime ownership, legacy TLS root/worker cleanup, errno/reentry/handlers, full executable startup and audible physical playback remain incomplete.']}
exe=load('docs/audio_resolved_fls_validation.json')['test_executable'];receipt['test_executable']=exe
tool=r/'tools/record_audio_crt_worker_exit.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8')
files=[exe,logname,proof,'crates/core/src/lib.rs','crates/core/src/audio_crt_worker_exit.rs','data/4.20/audio_crt_worker_exit_preparation.json','tools/probe_native_audio_crt_worker_exit.py','tools/implement_audio_crt_worker_exit.py','tools/record_audio_crt_worker_exit.py','docs/audio_crt_worker_com_initialization_discovery.json','tools/discover_audio_crt_worker_com_startup.py']
receipt['files_sha256']={f:sha(r/f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update({v:receipt[v]for v in ['audio_tests_passed','original_worker_exit_cases','worker_exit_component_x86_x64_cases']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : prÃ©paration de sortie du worker et nettoyage COM originaux portÃ©s ; 124 exÃ©cutions natives comparÃ©es et 248 comparaisons en 32/64 bits. 556 tests audio rÃ©ussis. Les contrÃ´les portent sur la prÃ©paration et une frontiÃ¨re de terminaison explicite ; intÃ©gration aux vrais workers TLS/COM et sortie sonore du client encore Ã  terminer.</p>\n';assert '</body>'in s
if text not in s:html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS556 audio tests; original worker exit124/component248; full24/114/37 retained; physical termination unqualified')

