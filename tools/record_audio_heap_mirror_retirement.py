from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
def load(f):return json.loads((r/f).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
logname='logs/audio-heap-mirror-retirement-tests.log';b=(r/logname).read_bytes();log=b.decode('utf-16')if b.startswith((b'\xff\xfe',b'\xfe\xff'))else b.decode('utf-8-sig')
assert 'test result: ok. 543 passed; 0 failed;'in log
for name in ['audio_windows_process_heap_post_callback_mirror_retirement_is_atomic_and_bounded','audio_windows_process_heap_reserves_live_and_retired_ranges_even_without_mirrors','audio_windows_process_heap_real_constructor_shared_fls_and_real_locks_release6_restored_original_contexts_and_new_owned_records']:assert name+' ... ok'in log
proofs=['docs/audio_heap_mirror_retirement_validation.json','docs/audio_heap_mirror_context_retirement_validation.json','docs/audio_optional_owned_heap_validation.json']
for f in proofs:
 p=load(f);assert p['passed']
 for name,h in p['files_sha256'].items():assert sha(r/name)==h,(f,name)
for v in load('docs/audio_test_fixture_loading.json')['references']:assert sha(r/v['fixture'])==v['sha256']
next_action='Connect normal constructors and FLS callback ownership for optional buffers, custom locales and dynamic locks. Integrate explicit post-callback mirror retirement into normal client worker lifetimes. Implement original global CRT startup/export dispatch/security-cookie and real FLS startup/getter services without captured first-context restoration. Qualify fresh errno context/callback reentry and handler/retry failures through actual providers. Connect normal audio worker dispatch/progression/physical playback. Preserve full24-domain114-task37-requirement scope; normal client audio and whole game remain unfinished.'
name='audio_heap_mirror_retirement';receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'audio_tests_passed':543,'physical_retirement_cycles_per_architecture':1024,'optional_owned_heap_cases':252,'shared_callback_retirement_cases':12,'test_log':logname,'proofs':proofs,'next_action':next_action,'evidence':['Atomic batch preflight retires only physically freed owned mirrors and corresponding tombstones after original callbacks and forensic readers. Invalid size/reference, overlap or missing tombstones abort without partial deletion.','Live physical and retired logical ranges remain reserved even when external map entries are missing. Adoption rejects overlapping live/retired blocks.','Real x86/x64 process heaps pass1024 three-buffer cycles each with3075 physical allocations/frees each, unchanged unrelated memory and tombstones; full core includes256 cycles and address reservation checks.','Six real FLS/critical-section context shutdown cases in each architecture now retire both mirrors only after completed callbacks and native final-byte comparison.','All126 native optional-buffer cases in each architecture restore individual physical owners, never a merged256-byte block. Original destructor uses real Windows heap/locks; exact final bytes and free identities, wrapped multibyte counts and surviving ownership checked. Full543 audio tests pass.'],'limits':['Retirement is explicit API; normal client audio workers not connected.','Optional states are restored captures and destructor invoked directly; normal buffer constructors and their OS FLS callbacks not qualified.','Canonical map ownership contract forbids replacing owned entries between allocation/free/retirement; same-shape external replacement identity cannot be inferred from public byte records.','Global original startup/dispatch/cookie, custom locale/dynamic allocations, errno reentry/handler failures and complete physical playback remain unfinished.']}
(r/'tools/record_audio_heap_mirror_retirement.py').write_text(Path(__file__).read_text(),encoding='utf-8')
exe=load('docs/audio_windows_process_heap_validation.json')['test_executable'];receipt['test_executable']=exe
files=[logname,exe,'crates/core/src/audio_crt_windows_process_heap.rs','tools/implement_audio_heap_mirror_retirement.py','tools/extend_audio_heap_mirror_retirement.py','tools/record_audio_heap_mirror_retirement.py']+proofs
receipt['files_sha256']={f:sha(r/f)for f in files};(r/f'docs/{name}.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
summary={k:v for k,v in receipt.items()if k not in ['files_sha256','evidence','limits','next_action']};summary['receipt']=f'docs/{name}.json'
for f in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 d=load('docs/'+f);d[name]=summary;d['next_action']=next_action
 if f=='resume_checkpoint.json':d['saved_utc']=receipt['saved_utc']
 for key in ['last_verified','current_evidence']:
  if isinstance(d.get(key),dict):d[key].update({k:receipt[k]for k in ['audio_tests_passed','physical_retirement_cycles_per_architecture','optional_owned_heap_cases','shared_callback_retirement_cases']})
 (r/'docs'/f).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load('docs/completion_plan.json');assert len(p['domains'])==24 and sum(len(d['tasks'])for d in p['domains'])==114 and sum(len(d['additional_requirements'])for d in p['domains'])==37
html=r/'docs/completion_plan.html';s=html.read_text(encoding='utf-8');text='<p>Audio : retrait atomique des copies mÃ©moire aprÃ¨s callbacks vÃ©rifiÃ©, 543 tests audio rÃ©ussis. Buffers secondaires : 252 comparaisons natives avec tas et verrous Windows rÃ©els ; contextes FLS : 12 contrÃ´les du retrait aprÃ¨s callbacks. Constructeurs normaux, locales personnalisÃ©es et intÃ©gration aux workers Ã  poursuivre.</p>\n';assert '</body>'in s
if text not in s:html.write_text(s.replace('</body>',text+'</body>'),encoding='utf-8')
print('PASS543 audio tests; real heap mirror retirement and252 optional owner comparisons; full24/114/37 unchanged')
