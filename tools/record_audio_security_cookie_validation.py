from pathlib import Path
import json, hashlib, datetime
r = Path('E:/OpenLeague')
def load(f): return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-security-cookie-root-tests.log'
b=(r/logname).read_bytes()
log=b.decode('utf-16') if b.startswith((b'\xff\xfe',b'\xfe\xff')) else b.decode('utf-8-sig')
assert 'test result: ok. 553 passed; 0 failed;' in log
names=[
 'audio_security_cookie_matches896_original_complete_entropy_order_raw_qpc_bool_stack_inputs_default_collision_promotion_and_retention_cases',
 'audio_windows_root_startup_real_cookie_entropy_precedes_dispatch_and_matches6_native_startup_banks_after_cookie_input_transition',
 'audio_windows_root_startup_cookie_guard_rejects_foreign_slot_and_missing_output_storage_without_entropy_calls']
for n in names: assert n+' ... ok' in log, n
proofs=['docs/audio_security_cookie_component_validation.json','docs/audio_cookie_root_startup_hardware_validation.json']
for f in proofs:
 p=load(f); assert p['passed']
 for name,h in p['files_sha256'].items(): assert sha(r/name)==h,(f,name)
assert load(proofs[1])['cases']==12
order=load('docs/audio_cookie_entry_order_discovery.json')
assert order['passed'] and order['pe_entry_reference']==0xca0f20
assert order['cookie_call'] < order['heap_bootstrap_call'] < order['crt_root_call']
refs=load('docs/audio_test_fixture_loading.json')['references']
assert len(refs)==59
for v in refs: assert sha(r/v['fixture'])==v['sha256'],v['fixture']
plan=load('docs/completion_plan.json')
assert len(plan['domains'])==24
assert sum(len(d['tasks']) for d in plan['domains'])==114
assert sum(len(d['additional_requirements']) for d in plan['domains'])==37
name='audio_security_cookie_validation'
next_action='Bind qualified registered Windows exports with full-width ABI dispatch and qualify legacy TLS fallback, fresh errno context and new-handler failure/reentry services. Qualify full executable startup order around original cookie/process-heap bootstrap and native GS/SEH. Connect original optional/custom-locale/time/dynamic-lock producers and qualified root lifecycle/retirement to normal audio client workers, dispatch/progression and physical playback. Preserve all24 domains114 tasks37 additional requirements; whole game remains incomplete.'
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':553,'original_cookie_controlled_cases':896,'cookie_component_x86_x64_cases':1792,'actual_entropy_root_x86_x64_cases':12,'existing_fixture_hashes_preserved':59,'proofs':proofs,'test_log':logname,'next_action':next_action,
 'evidence':['Original x86 cookie producer executed on896 controlled entropy/stack/cookie cases. Rust compares exact cookie/complement bytes and API event order, including raw counter failure BOOL, prior output words, default collision, high16 promotion and valid-cookie retention.',
 'Unchanged production cookie implementation repeats896 cases in each actual x86 and x64 executable. Four actual Windows entropy APIs run before fresh root startup in12 architecture/configuration cases; native startup banks compared after explicit cookie input and relocation normalization.',
 'Production root rejects existing foreign FLS slot and missing cookie output storage before entropy; actual root cookie transition tested on6 configurations in full core suite. All553 audio tests pass; historical59 fixture hashes and full24/114/37 scope preserved.'],
 'limits':['Controlled counter boundary results do not prove actual OS entropy quality or resource exhaustion. Source32 local reference and prior counter words are explicit inputs, never truncated or dereferenced host pointers.',
 'Native GS/SEH and complete executable startup ordering around process-heap bootstrap remain unqualified. Legacy TLS fallback, named-export ABI binding, fresh errno/new-handler failures and normal client audio output remain incomplete.']}
(r/'tools/record_audio_security_cookie_validation.py').write_text(Path(__file__).read_text(),encoding='utf-8')
exe=load('docs/audio_production_root_startup.json')['test_executable']
receipt['test_executable']=exe
files=[exe,logname,'crates/core/src/lib.rs','crates/core/src/audio_security_cookie.rs','crates/core/src/audio_crt_windows_root_startup.rs','data/4.20/audio_security_cookie_preparation.json','tools/probe_native_audio_security_cookie.py','tools/implement_audio_security_cookie.py','tools/test_audio_cookie_root_integration.py','tools/record_audio_security_cookie_validation.py','docs/audio_cookie_entry_order_discovery.json','tools/discover_audio_cookie_entry_order.py']+proofs
receipt['files_sha256']={f:sha(r/f) for f in files}
(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items() if k not in ['files_sha256','evidence','limits','next_action']}
summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f); d[name]=summary; d['next_action']=next_action
 if f=='resume_checkpoint.json': d['saved_utc']=receipt['saved_utc']
 for key in ['last_verified','current_evidence']:
  if isinstance(d.get(key),dict):
   d[key].update({k:receipt[k] for k in ['audio_tests_passed','original_cookie_controlled_cases','cookie_component_x86_x64_cases','actual_entropy_root_x86_x64_cases']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
html=r/'docs/completion_plan.html'; s=html.read_text(encoding='utf-8')
text='<p>Audio : producteur original du cookie de sÃ©curitÃ© portÃ© en Rust et intÃ©grÃ© avant le contexte CRT ; 896 cas natifs comparÃ©s, 1792 comparaisons exÃ©cutÃ©es en 32 et 64 bits, 12 dÃ©marrages avec les API Windows rÃ©elles. 553 tests audio rÃ©ussis. CompatibilitÃ© TLS, services restants et sortie audio normale du client encore Ã  terminer.</p>\n'
assert '</body>' in s
if text not in s: html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS553 audio tests; cookie native896/component1792/actual entropy root12; full24/114/37 retained')
