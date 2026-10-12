from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-resolved-fls-qualified-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16') if b.startswith((b'\xff\xfe',b'\xfe\xff')) else b.decode('utf-8-sig')
assert 'test result: ok. 555 passed; 0 failed;' in log
for n in ['audio_windows_registered_fls_abi_invokes_full_width_alloc_get_set_free_and_rejects_wrong_null_foreign_encoded_and_permuted_references','audio_windows_root_registered_fls_table_routes_all_four_abi_boundaries_through_fresh_worker_creation_explicit_shutdown_and_drop']:
 assert n+' ... ok' in log,n
proof='docs/audio_resolved_fls_hardware_validation.json';p=load(proof);assert p['passed'] and p['root_cases']==12 and p['typed_abi_cycles']==2 and p['invalid_reference_shapes']==14
for f,h in p['files_sha256'].items():assert sha(r/f)==h,f
refs=load('docs/audio_test_fixture_loading.json')['references'];assert len(refs)==59
for v in refs:assert sha(r/v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json');assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
name='audio_resolved_fls_validation';next_action='Qualify original worker exit C9C356 and conditional C9C459 dependency, then integrate existing CA915B detach port with actual legacy TLS worker retirement (original PE TLS callback array is empty), qualify its fallback and fresh errno context and new-handler failure/reentry services. Qualify whole executable startup around cookie/process-heap bootstrap and native GS/SEH; bind other original optional exports as their consumer ABI is qualified. Connect original optional/custom-locale/time/dynamic-lock producers and root lifecycle/retirement to normal client audio workers, dispatch/progression and physical playback. Preserve all24 domains114 tasks37 requirements; game remains incomplete.'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':555,'registered_fls_root_hardware_cases':12,'registered_fls_typed_abi_cycles':2,'registered_fls_invalid_reference_shapes':14,'root_routed_cleanup_modes':2,'existing_fixture_hashes_preserved':59,'proof':proof,'test_log':logname,'next_action':next_action,
 'evidence':['Native registry validates kernel32 module provenance and all four exact export names/kinds and retains full-width GetProcAddress values before conversion to typed Windows system-ABI functions. Missing/foreign/wrong-kind/permuted references rejected before invocation; unsafe table constructor explicitly requires Windows FLS ownership/callback/LastError semantics.',
 'Production root passes the qualified table into its actual SharedSlot. FLS allocation, inspection, binding, original getter/setter dispatch, explicit close, CRT shutdown and final Drop invoke that table. Diagnostic constructor keeps its explicit linked API path.',
 'Full-core routing spies prove all four boundaries are used during fresh main/worker record creation and explicit or implicit root shutdown; two callbacks, two physical frees/mirror retirements and lock deletion verified. Actual registered API cycle verifies full-width stored-pointer round-trip, clear and free.',
 'Actual x86/x64 executables repeat12 original startup bank configurations with generated cookie and fresh records, plus2 typed ABI cycles/14 rejected reference shapes. All555 audio tests pass; historical59 fixture hashes and full24/114/37 scope preserved.'],
 'limits':['Only the four FLS exports have this typed registered invocation binding. Other resolved exports require consumer-specific ABI integration.',
 'Legacy TLS root, physical OS resource exhaustion, native GS/SEH, whole executable startup and normal client audible playback remain incomplete. Original source pointers and opaque critical-section bytes require explicit normalization; no raw pointer identity claim.']}
exe=load('docs/audio_security_cookie_validation.json')['test_executable'];receipt['test_executable']=exe
tool=r/'tools/record_audio_resolved_fls.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8')
files=[exe,logname,proof,'tools/record_audio_resolved_fls.py','tools/implement_audio_resolved_fls.py','tools/test_audio_resolved_fls.py','tools/guard_audio_resolved_fls_module.py','docs/audio_legacy_tls_lifecycle_discovery.json','tools/discover_audio_legacy_tls_lifecycle.py']
files += [f'crates/core/src/{n}.rs' for n in ['audio_crt_windows_dispatch_resolver','audio_crt_windows_global_services','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']]
receipt['files_sha256']={f:sha(r/f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items() if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update({v:receipt[v]for v in ['audio_tests_passed','registered_fls_root_hardware_cases','registered_fls_typed_abi_cycles','registered_fls_invalid_reference_shapes','root_routed_cleanup_modes']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : les quatre fonctions FLS rÃ©ellement rÃ©solues pilotent maintenant le dÃ©marrage, le stockage des threads et tous les chemins de nettoyage. Pointeurs complets et signatures Windows vÃ©rifiÃ©s en 32 et 64 bits ; routage contrÃ´lÃ© dans le moteur. 555 tests audio rÃ©ussis. CompatibilitÃ© TLS et sortie audio normale du client encore Ã  terminer.</p>\n';assert '</body>' in s
if text not in s:html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS555 audio tests; typed registered FLS root12/ABI2/rejection14; full24/114/37 retained')




