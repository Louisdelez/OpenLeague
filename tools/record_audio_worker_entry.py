from pathlib import Path
import json,hashlib,datetime,re
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(f):return hashlib.sha256((r/f).read_bytes()).hexdigest()
logname='logs/audio-worker-entry-tests.log';raw=(r/logname).read_bytes();log=raw.decode('utf-16')if raw.startswith((b'\xff\xfe',b'\xfe\xff'))else raw.decode('utf-8-sig')
match=re.search(r'test result: ok\. (\d+) passed; 0 failed;',log);assert match and int(match[1])>=562
assert 'audio_crt_worker_entry_matches162_original_tls_fls_packet_adoption_three_field_transfer_destructor_publication_failure_and_terminal_banks ... ok'in log
proof='docs/audio_worker_entry_component_validation.json';p=load(proof);assert p['passed']and p['cases']==324
for f,h in p['files_sha256'].items():assert sha(f)==h,f
body=load('data/4.20/audio_crt_worker_body_preparation.json');assert body['passed']and body['case_count']==54
refs=load('docs/audio_test_fixture_loading.json')['references'];assert len(refs)==59
for v in refs:assert sha(v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json');assert len(plan['domains'])==24 and sum(len(d['tasks'])for d in plan['domains'])==114 and sum(len(d['additional_requirements'])for d in plan['domains'])==37
next_action='Port original C9C315 normal worker body using54 native captures: required context, stdcall callback argument/return and complete exit. Integrate original C9C3DC packet adoption/transfer plus existing package/COM producer in real root/FLS workers, qualify incoming packet locale/optional ownership and actual callback/ExitThread. Qualify original exception filter/SEH/fatal context and S_FALSE terminal COM ownership; complete actual legacy TLS fallback, errno/new-handler/reentry and full executable startup. Connect normal client audio dispatch/progression and physical playback. Preserve24 domains114 tasks37 requirements; whole game incomplete.'
name='audio_worker_entry_validation';exe=load('docs/audio_worker_com_startup_validation.json')['test_executable']
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':int(match[1]),'original_worker_entry_cases':162,'worker_entry_component_x86_x64_cases':324,'original_normal_worker_body_captures':54,'existing_fixture_hashes_preserved':59,'test_executable':exe,'test_log':logname,'next_action':next_action,'evidence':['Original C9C3DC captured in162 cases: TLS/FLS existing-context three-field transfer, complete incoming packet destructor, fresh adoption with real source thread identity write, publication failure LastError to terminal ExitThread boundary. Every service and final bank retained.','Unchanged Rust entry source compared against all162 native cases on x86 and x64 (324 comparisons). Prepared exit preserves source incoming-packet leak on publication failure. Regression covers all banks, service order, dead records, slot and last error.','Additional54 complete original C9C315 normal body executions capture actual native SEH prolog, required-context lookup, supplied stdcall callback argument, raw u32 result forwarded through complete original exit. FS registration captured at callback and terminal boundary. This body has not yet been ported or integrated.'],'limits':['Entry OS/allocator outcomes supplied; no physical original entry integration or user-facing audio milestone claimed. Incoming packet fixtures omit optional allocations and locale ownership.','Body callbacks supplied, COM flag0; no exception injection, filter, fatal-context path or OS SEH proof.','Full game remains incomplete across unchanged24 domains114 tasks37 requirements.']}
tool='tools/record_audio_worker_entry.py';(r/tool).write_text(Path(__file__).read_text())
files=[exe,logname,proof,'crates/core/src/lib.rs','crates/core/src/audio_crt_worker_entry.rs','data/4.20/audio_crt_worker_entry_preparation.json','data/4.20/audio_crt_worker_body_preparation.json','tools/probe_native_audio_crt_worker_entry.py','tools/probe_native_audio_crt_worker_body.py','tools/implement_audio_crt_worker_entry.py','tools/probe_audio_worker_entry.py',tool]
receipt['files_sha256']={f:sha(f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for k in ['last_verified','current_evidence']:
  if isinstance(d.get(k),dict):d[k].update({v:receipt[v]for v in ['audio_tests_passed','original_worker_entry_cases','worker_entry_component_x86_x64_cases','original_normal_worker_body_captures']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : entrée native du worker portée en Rust ; 162 captures et 324 comparaisons 32/64 bits. Corps normal capturé dans 54 cas, encore à porter. '+str(receipt['audio_tests_passed'])+' tests audio réussis. Intégration du worker complet et chemins d’exception à terminer.</p>\n';assert '</body>'in s;html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('Recorded worker entry qualification; audio tests',receipt['audio_tests_passed'],'scope24/114/37 preserved')
