"""Record this qualification only after core, rebuilt client and 11 CLI checks.

Adapted from loading_standard_integration/record_validation.py. This script
writes production documentation when main is explicitly invoked by the root;
preparing/importing it does not execute tests, clients or a compiler.
"""
from pathlib import Path
import argparse, datetime, hashlib, importlib.util, json, re

R=Path('E:/OpenLeague')
S=Path(__file__).resolve().parent
KEY='loading_resource_manager_validation'
RECEIPT='docs/'+KEY+'.json'
ARCHIVE='docs/loading_resource_manager_sources'
PREFIX='client-loading-resource-manager-'
NATIVE_SHA='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
IMAGE_SHA='d2d0a8517da861a959bbb4f6914573a7897c6f78c1f1d8d7e6e90b50e50a5099'
VERIFIER_SHA='7701fcf6cec4fd862b5579f54f2f0018a2a8208672308abbd43bf0ec8b35966b'
CORRECTION_SHA='9be8760164910052f6c7ff44ca4e46568a01283d18e0ee63c34f89dd8788ce78'
REPAIR_REL='review/index_read_repair/repair_manifest.json'
PROVIDER_PREPARATION_SHA='dde701270da710c68c49890a8eb4669a89b91da4c582fa7670904a5aeff61232'
PROVIDER_IO_SHA='d275c6dc2ab1cfb0416bfff6e6fdecc3bbf2512988b3ae8932507a5c368cb698'
PROVIDER_IO_REVIEW_SHA='882c6e50404806350b5e7a71fa1424da83b8e0ffd349c75134acd00c96cd99b1'
TEST_ORDER_PATH='crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
TEST_ORDER_NAME='audio_replay_windows_loading_standard_packet_uses_real_resource_manager_and_retires_normalized_key_on_factory_boundary'
NEXT_PROVIDER_ACTION=(
 'First implement and test a new isolated scratch I/O environment described by '
 'next_provider_preparation/SCRATCH_ENVIRONMENT.md: one declared virtual deployment, '
 'real read-only source mapping, explicit scratch-only Config writes, path/reparse escape refusal, '
 'actual handle/error behavior, and unchanged source hashes. Preserve the original deployment. '
 'Then restart the native provider at its actual entry in a fresh machine state; '
 'do not inject success into either abandoned probe. Qualify the real CRT/thread formatting state, '
 'provider56, native INI/fallback, publication/recursion/ownership and populated teardown before UI integration. '
)
NEXT_PROVIDER_IO_ACTION=(
 'Continue in a fresh copy of the confined scratch I/O preparation with genuine native CRT '
 'initialization C9A0B9/CABDE8, CA92CB, CB0378 and CAFF53, retaining its process/thread state, '
 'then restart the real provider entry toward INI8B0630. Do not synthesize formatting, INI or provider results. '
 'The36 I/O checks and real scratch Config mkdir do not complete a provider; CABDA8 remains an explicit stop. '
 'Preserve the no-concurrent-filesystem-mutation condition and recorded unexercised write/link cases. '
)
HISTORICAL_CLIENT_RECEIPT='docs/process_clock_validation.json'
HISTORICAL_CLIENT_SHA='312ee0b7dcf978c2530a1d479ee27fdd1734267630bfb7c512868d1e12338c9c'
EXCLUDED=[
 'attack_damage_is_authoritative_and_respects_cooldown','catalog_contains_native_roster',
 'movement_routes_around_blocked_cells','reconnect_fills_the_team_with_a_free_slot',
 'rejects_nonfinite_and_wall_destinations','simulation_limits_lobby_and_forbids_friendly_fire',
]
NEXT_ACTION=NEXT_PROVIDER_IO_ACTION+(
 'Continue the real resource miss90B520: source context producer9063E0/global2D78F20, '
 'directory32 construction90B4A0/90B360/903030/9030C0 and population, provider56 factory9034D0, '
 'existence/path resolution9041E0/903EE0 and original INIBIN [Package]FallbackPackage/8B0630, '
 'parent905000 and cache publication90B270; preserve source publication-before-INI order and qualify '
 'failures/recursion and populated-provider destruction. Then connect the actual resources to '
 '57D775/57D77A loading UI continuation and rendering. Empty manager172, four native hash initializers, '
 'bounded backpointers, normalized cache lookup, and paired temporary retirement are qualified in this receipt. '
 'Opaque native hit tokens are not constructed providers; Windows currently reaches the explicit90B520 miss boundary. '
 'Full normal startup/shutdown callers, screen selection/factories5765F0, service-global publication, actual '
 'transport/event delivery, complete UI/audio/gameplay fidelity and all24 domains114 tasks37 requirements remain. '
 'Qualify the unintegrated GUI shutdown/error-exit proposal separately. No completed screen or complete game is claimed.'
)
LIMITS=[
 'Only the empty manager lifecycle is qualified:14 real allocations, four native static hash initializers and the bounded592E49..592E6A backpointer fragment. The complete normal startup/shutdown callers are not executed by this port.',
 'The66 native cache hits contain opaque fixture tokens. They prove lookup/comparison and borrowed return only, not actual provider construction or populated destruction. The8 native misses stop before90B520 and their temporary cleanup is a separate abandonment, not native SEH equivalence.',
 'The additional2 null-allocation producer cases and264 native hash inputs are narrow contracts. They do not establish a functioning resource factory, context directories, INIBIN fallback or textures.',
 'Windows core tests use the real explicitly initialized manager, metadata providers and packet95 dispatch until the factory90B520 boundary. Diagnostic recipient/service bindings are explicit; normal startup publication and rendered nonempty loading UI remain open.',
 'Paired String24 guards and lease64 preserve separate cleanup failures and reset-only work. Unresolved cleanup retains its shared bank and close fails. Panic/OOM/abort, arbitrary non-atomic custom deallocation and unqualified tutorial/provider rollback are outside this adaptation.',
 'The eleven fresh executable commands exercise existing application/clock/replay behavior on the rebuilt client. They do not render or dispatch the new loading UI; resource/ownership paths are exercised by current core tests.',
 'The14 selected client unit tests in process_clock_validation are historical and were not rerun here. Six unchanged lib.rs tests accidentally listed by whole-file enumeration are filtered out and are not claimed as executed. No visual/audio/network/endurance or human fidelity acceptance is claimed.',
]

def sha(path):
 with path.open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()
def digest(data):return hashlib.sha256(data).hexdigest()
def load(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def encoded(value):
 data=(json.dumps(value,ensure_ascii=False,indent=2)+'\n').encode('utf-8')
 assert json.loads(data)==value
 return data
def within(root,relative):
 path=root/relative
 assert path.resolve().is_relative_to(root.resolve()),relative
 return path

def verify_test_correction(assembled,installed):
 path=S/'required_tests_correction.json';assert sha(path)==CORRECTION_SHA
 correction=load(path)
 assert correction['assembled_sha256']==installed['assembled_sha256']==sha(S/'assembled.json')
 assert correction['installed_sha256']==sha(S/'installed.json')
 original=assembled['required_core_tests']
 assert len(original)==len(set(original))==55
 assert correction['original_required_core_tests']==original
 assert correction['filters']==['audio_','native_clock']
 assert correction['excluded_unchanged_filtered_tests']==EXCLUDED
 assert correction['excluded_tests_executed_or_qualified_here'] is False
 selected=[name for name in original if name not in EXCLUDED]
 assert len(selected)==49 and correction['effective_required_core_tests']==selected
 assert all(any(term in name for term in correction['filters']) for name in selected)
 assert all(not any(term in name for term in correction['filters']) for name in EXCLUDED)
 assert len(assembled['added_tests'])==25 and len(set(assembled['added_tests']))==25
 assert correction['added_tests_still_required']==assembled['added_tests']
 assert set(assembled['added_tests'])<=set(selected)
 assert correction['expected_core_passed']==assembled['expected_core_passed']==890
 assert correction['expected_core_filtered']==assembled['expected_core_filtered']==480
 proof=correction['lib_proof'];baseline=Path(installed['backup'])/'files/crates/core/src/lib.rs'
 staged=S/'production/crates/core/src/lib.rs'
 assert Path(proof['baseline_path']).resolve()==baseline.resolve()
 assert Path(proof['staged_path']).resolve()==staged.resolve()
 assert sha(baseline)==proof['baseline_sha256']==installed['files']['crates/core/src/lib.rs']['before']
 assert sha(staged)==proof['staged_sha256']==installed['files']['crates/core/src/lib.rs']['after']
 suffix=bytes.fromhex(proof['appended_bytes_hex'])
 assert proof['baseline_is_exact_byte_prefix'] is True
 assert staged.read_bytes()==baseline.read_bytes()+suffix
 exports=['pub mod audio_loading_resource_manager;','pub mod audio_loading_resource_cache;']
 assert [s for s in suffix.decode('utf-8').splitlines() if s.strip()]==proof['only_added_nonempty_lines']==exports
 for name in EXCLUDED:
  assert len(re.findall(r'#\[test\]\s*fn\s+'+re.escape(name)+r'\s*\(',baseline.read_text(encoding='utf-8')))==1,name
 return correction

def verify_native(assembled):
 paths={
  'manager':'data/4.20/loading_resource_manager_oracle.json',
  'cache':'data/4.20/loading_resource_cache_contract.json',
  'null':'data/4.20/loading_resource_manager_null_probe.json',
 }
 proofs={}
 for key,relative in paths.items():
  path=R/relative;assert sha(path)==assembled['files'][relative]['after']
  data=load(path);assert data['passed'] is True and data['source_sha256']==NATIVE_SHA
  proofs[key]=data
 manager,cache,null=(proofs[key] for key in ['manager','cache','null'])
 assert len(manager['cases'])==2 and len(manager['hash_cases'])==264
 for case in manager['cases']:
  assert len(case['allocations'])==len(case['frees'])==14 and case['live_after']=={}
  assert case['destructor_keeps_global']==case['manager']
 assert len(cache['cases'])==2 and cache['complete'] is False
 assert sum(len(case['hits']) for case in cache['cases'])==66
 assert sum(len(case['misses']) for case in cache['cases'])==8
 assert all(case['all_owned_allocations_freed'] is True for case in cache['cases'])
 assert len(null['cases'])==2 and null['complete'] is False
 for case in null['cases']:
  assert case['constructor_executed'] is False and case['return_eax']==case['final_global']==0
  assert all(case[key] is True for key in ['stack_restored','frame_restored','fs_chain_restored'])
 return {key:{'path':relative,'sha256':sha(R/relative)} for key,relative in paths.items()}

def verify_repair(assembled,installed,correction,expected_sha):
 """Only a root-pinned, bounded repair may extend the installed24-file set."""
 path=S/REPAIR_REL
 if expected_sha is None:
  assert not path.exists(),'repair_manifest exists: pass its independently reviewed SHA explicitly'
  return None
 assert re.fullmatch(r'[0-9a-fA-F]{64}',expected_sha)
 assert sha(path)==expected_sha.lower()
 repair=load(path);assert repair['schema']==1 and repair['complete'] is False
 assert repair['assembled_sha256']==installed['assembled_sha256']
 assert repair['installed_sha256']==sha(S/'installed.json')
 assert repair['required_tests_correction_sha256']==CORRECTION_SHA
 files=repair['files'];assert 1<=len(files)<=8
 for relative,row in files.items():
  assert relative.startswith(('crates/core/src/','data/4.20/')),relative
  before=installed['files'].get(relative,{}).get('after')
  assert row['before_sha256']==before,relative
  assert re.fullmatch('[0-9a-f]{64}',row['after_sha256'])
  assert before!=row['after_sha256'],'repair must identify an actual change'
  candidate=within(path.parent,row['candidate'])
  assert candidate.stat().st_size==row['bytes'] and sha(candidate)==row['after_sha256'],relative
 added=repair['added_tests'];assert 1<=len(added)<=8 and len(set(added))==len(added)
 assert not set(added)&set(assembled['required_core_tests'])
 assert all(any(term in name for term in correction['filters']) for name in added)
 # Test names must actually exist once in the exact repaired Rust candidates.
 candidate_rust='\n'.join(within(path.parent,row['candidate']).read_text(encoding='utf-8')
                         for relative,row in files.items() if relative.endswith('.rs'))
 for name in added:
  assert len(re.findall(r'#\[test\]\s*fn\s+'+re.escape(name)+r'\s*\(',candidate_rust))==1,name
 for relative,row in repair['proof_files'].items():
  proof=within(path.parent,relative);assert proof.stat().st_size==row['bytes'] and sha(proof)==row['sha256'],relative
 for source,row in repair['source_inputs'].items():
  proof=Path(source);assert proof.resolve().is_relative_to(S.resolve()),source
  assert proof.stat().st_size==row['bytes'] and sha(proof)==row['sha256'],source
 assert repair['native_proofs'],'repair must include its native qualification evidence'
 for relative,entry in repair['native_proofs'].items():
  assert relative in files and relative.startswith('data/4.20/') and relative.endswith('.json')
  data=load(within(path.parent,files[relative]['candidate']))
  checks=entry['json_checks'];assert checks['passed'] is True and checks['source_sha256']==NATIVE_SHA
  for key,expected in checks.items():
   actual=data
   for component in key.split('.'):
    actual=actual[int(component)] if isinstance(actual,list) else actual[component]
   assert type(actual) is type(expected) and actual==expected,(relative,key)
 return repair

def verify_repair_installation(repair,expected_sha):
 """Verify application of the pinned repair, preserving original install evidence."""
 path=S/'index_repair_installed.json'
 if repair is None:
  assert not path.exists(),'repair install receipt without a reviewed manifest'
  return None,{}
 record=load(path)
 assert Path(record['manifest']).resolve()==(S/REPAIR_REL).resolve()
 assert record['manifest_sha256']==expected_sha.lower()
 assert record['files']==repair['files'] and record['tests_pending'] is True
 backup=Path(record['backup'])
 assert backup.resolve().is_relative_to((R/'docs/plan_history').resolve())
 assert backup.name.startswith('resource-index-read-repair-')
 stable={path:sha(path),backup/'repair_manifest.json':expected_sha.lower()}
 assert sha(backup/'repair_manifest.json')==expected_sha.lower()
 for relative,row in repair['files'].items():
  for kind in ['installed','staged']:
   previous=within(backup/kind,relative)
   if row['before_sha256'] is None:assert not previous.exists(),str(previous)
   else:
    assert sha(previous)==row['before_sha256'],str(previous)
    stable[previous]=row['before_sha256']
 return {'receipt':ARCHIVE+'/index_repair_installed.json','receipt_sha256':sha(path),
         'installed_utc':record['installed_utc'],'backup':str(backup),
         'historical_tests_pending_flag_preserved':True},stable

def verify_test_order_repair(assembled,installed,index_repair,expected_sha):
 """One pinned test-only line-order change; no additional test or runtime delta."""
 path=S/'test_order_repair.json'
 if expected_sha is None:
  assert not path.exists(),'test-order manifest exists: pass its reviewed SHA explicitly'
  return None,{}
 assert index_repair is not None and re.fullmatch(r'[0-9a-fA-F]{64}',expected_sha)
 assert sha(path)==expected_sha.lower()
 repair=load(path);assert repair['schema']==1 and repair['complete'] is False
 assert repair['assembled_sha256']==installed['assembled_sha256']==sha(S/'assembled.json')
 assert repair['installed_sha256']==sha(S/'installed.json')
 assert repair['index_repair_manifest_sha256']==sha(S/REPAIR_REL)
 assert repair['index_repair_installed_sha256']==sha(S/'index_repair_installed.json')
 assert repair['added_tests']==[] and set(repair['files'])=={TEST_ORDER_PATH}
 assert TEST_ORDER_PATH not in index_repair['files']
 row=repair['files'][TEST_ORDER_PATH]
 assert row['before_sha256']==installed['files'][TEST_ORDER_PATH]['after']
 candidate=within(S,row['candidate'])
 assert candidate.resolve().is_relative_to((S/'review/test_order_repair').resolve())
 assert candidate.stat().st_size==row['bytes'] and sha(candidate)==row['after_sha256']!=row['before_sha256']
 stable={path:expected_sha.lower(),candidate:row['after_sha256']}
 for relative,proof in repair['proof_files'].items():
  item=within(S,relative);assert item.stat().st_size==proof['bytes'] and sha(item)==proof['sha256'],relative
  stable[item]=proof['sha256']
 decision_path=S/'review/test_order_repair/decision.json'
 assert decision_path.relative_to(S).as_posix() in repair['proof_files']
 decision=load(decision_path)
 assert decision['full_original_startup_order_qualified'] is False and decision['test_names_unchanged'] is True
 before=bytes.fromhex(decision['byte_replacement']['before_hex'])
 after=bytes.fromhex(decision['byte_replacement']['after_hex'])
 assert before==(b'        let manager=r.initialize_loading_resources().unwrap();\r\n'
                 b'        let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();')
 assert after==(b'        let service=r.configure_service(Defaults).unwrap();\r\n'
                b'        let manager=r.initialize_loading_resources().unwrap();r.initialize_game_manager().unwrap();')
 baseline=S/'ownership/audio_replay_windows_loading_retirement_tests.rs'
 assert sha(baseline)==row['before_sha256'];original=baseline.read_bytes()
 assert original.count(before)==1 and original.replace(before,after,1)==candidate.read_bytes()
 stable[baseline]=row['before_sha256']
 test_names=lambda data:re.findall(rb'#\[test\]\s*fn\s+(\w+)\s*\(',data)
 assert test_names(original)==test_names(candidate.read_bytes())
 assert TEST_ORDER_NAME.encode() in test_names(original)
 assert set(decision['source_guards'])=={'audio_replay_windows_service.rs','audio_replay_windows_game_manager.rs'}
 for filename,expected in decision['source_guards'].items():
  guard=R/'crates/core/src'/filename;assert sha(guard)==expected;stable[guard]=expected
 failed=repair['failed_run'];log=within(S,failed['log'])
 assert failed['log'] in repair['proof_files'] and sha(log)==failed['sha256']==repair['proof_files'][failed['log']]['sha256']
 assert failed['passed']==891 and failed['failed']==1 and failed['filtered']==480 and failed['client_build_executed'] is False
 expected_test='audio_replay_windows_transport::loading_packets::tests::'+TEST_ORDER_NAME
 assert failed['failed_test']==expected_test
 text=log.read_text(encoding='utf-8-sig')
 assert re.findall(r'test result: FAILED\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',text)==[('891','1','0','0','480')]
 assert re.findall(r'^test (\S+) \.\.\. FAILED\s*$',text,re.M)==[expected_test]
 assert 'configured service requires a fresh owned runtime lifetime' in text
 return repair,stable

def verify_test_order_installation(repair,expected_sha):
 path=S/'test_order_repair_installed.json'
 if repair is None:
  assert not path.exists(),'test-order install receipt without a reviewed manifest'
  return None,{}
 record=load(path)
 assert Path(record['manifest']).resolve()==(S/'test_order_repair.json').resolve()
 assert record['manifest_sha256']==expected_sha.lower() and record['files']==repair['files']
 assert record['tests_pending'] is True
 backup=Path(record['backup'])
 assert backup.resolve().is_relative_to((R/'docs/plan_history').resolve())
 assert backup.name.startswith('resource-test-order-repair-')
 manifest_backup=backup/'repair_manifest.json';assert sha(manifest_backup)==expected_sha.lower()
 stable={path:sha(path),manifest_backup:expected_sha.lower()}
 for relative,row in repair['files'].items():
  for kind in ['installed','staged']:
   previous=within(backup/kind,relative);assert sha(previous)==row['before_sha256']
   stable[previous]=row['before_sha256']
 return {'receipt':ARCHIVE+'/test_order_repair_installed.json','receipt_sha256':sha(path),
         'installed_utc':record['installed_utc'],'backup':str(backup),
         'historical_tests_pending_flag_preserved':True},stable

def verify_source_set(installed,repair,test_order_repair=None):
 supplement={} if repair is None else repair['files']
 if test_order_repair is not None:
  assert not set(supplement)&set(test_order_repair['files'])
  supplement={**supplement,**test_order_repair['files']}
 expected=set(installed['files'])|set(supplement)
 staged={p.relative_to(S/'production').as_posix() for p in (S/'production').rglob('*') if p.is_file()}
 assert staged==expected,{'undeclared':sorted(staged-expected),'missing':sorted(expected-staged)}
 source_hashes={};repairs=[]
 for relative in sorted(expected):
  path=within(R,relative);stage=within(S/'production',relative)
  initial=installed['files'].get(relative,{}).get('after')
  authorized=supplement[relative]['after_sha256'] if relative in supplement else initial
  actual=sha(path);assert actual==sha(stage)==authorized,relative
  if relative in supplement:
   assert path.stat().st_size==supplement[relative]['bytes']
   repairs.append({'path':relative,'installed_sha256':initial,'qualified_sha256':actual,
                   'added_file':initial is None,'candidate':supplement[relative]['candidate']})
  source_hashes[relative]=actual
 assert len(source_hashes)==24+sum(row['before_sha256'] is None for row in supplement.values())
 return source_hashes,repairs

def interrupted_compile():
 folder=S/'review/interrupted_compile_20261010T205136Z'
 receipt=folder/'receipt.json';record=load(receipt);log=folder/'core-loading-resource-manager-tests.log'
 assert record['tests_executed'] is False and record['is_compiler_error'] is False
 assert record['process_session']==43259 and sha(log)==record['sha256']
 assert 'test result:' not in log.read_text(encoding='utf-8-sig')
 return {'receipt':ARCHIVE+'/'+receipt.relative_to(S).as_posix(),'receipt_sha256':sha(receipt),
         'log':ARCHIVE+'/'+log.relative_to(S).as_posix(),'log_sha256':sha(log),
         'reason':record['reason'],'tests_executed':False,'qualification_evidence':False}

def verify_provider_preparation():
 """Pin the frozen preparation without turning abandoned probes into providers."""
 folder=S/'next_provider_preparation';path=folder/'manifest.json'
 assert sha(path)==PROVIDER_PREPARATION_SHA
 manifest=load(path)
 assert manifest['schema']==1 and manifest['kind']=='native_resource_provider_bounded_preparation'
 for flag in ['integrated','complete','rust_compiled','production_modified','source_deployment_modified']:
  assert manifest[flag] is False,flag
 files=manifest['files'];assert len(files)==14
 actual={p.relative_to(folder).as_posix() for p in folder.rglob('*') if p.is_file()}
 assert actual==set(files)|{'manifest.json'}
 stable={path:PROVIDER_PREPARATION_SHA}
 for relative,row in files.items():
  item=within(folder,relative)
  assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'],relative
  stable[item]=row['sha256']
 for filename,row in manifest['external_dependencies'].items():
  item=Path(filename);assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'],filename
  stable[item]=row['sha256']
 q=manifest['qualification']
 assert q=={'directory_lifetimes_passed':4,'directory_calls_passed':8,
            'default_context_provider_completed':False,'default_context_stop':'CreateDirectoryA before execution',
            'empty_context_provider_completed':False,'empty_context_stop':'uninitialized native CRT execution at BB40E64E',
            'asset_files_inspected':31,'native_ini_read_completed':False,'texture_rendering_completed':False}
 directory=load(folder/'directory_lifecycle_oracle.json')
 assert directory['passed'] is True and directory['complete'] is False and directory['source_sha256']==NATIVE_SHA
 assert len(directory['cases'])==4
 assert {(case['fill'],case['name_hex']) for case in directory['cases']}=={
  (0,'41687269'),(165,'41687269'),(0,'416e6e6965'),(165,'416e6e6965')}
 for case in directory['cases']:
  assert case['context_global']==0 and case['hit_same_pointer_no_allocation'] is True
  assert len(case['allocations'])==len(case['frees'])==17
  assert case['all_owned_allocations_freed'] is True and case['global_clear_is_explicit_caller_action'] is True
  assert [a['bytes'] for a in case['fresh_directory_allocations']]==[32,48,44]
 default=load(folder/'provider_probe_state.json');empty=load(folder/'empty_context_provider_oracle.json')
 for failed in [default,empty]:
  assert failed['passed'] is False and failed['complete'] is False and failed['source_sha256']==NATIVE_SHA
  assert failed['phase']=='provider_miss' and failed['open_find_handles']==0
 assert default['stop']['kind']=='unimplemented_import' and default['stop']['import']['name']=='CreateDirectoryA'
 assert empty['pc']=='0xbb40e64e' and empty['error']=='UcError()' and empty['stop'] is None
 inventory=load(folder/'asset_inventory.json')
 assert inventory['complete'] is False and len(inventory['files'])==31
 assert sum(Path(row['path']).suffix.lower()=='.inibin' for row in inventory['files'])==16
 assert sum(Path(row['path']).suffix.lower()=='.dds' for row in inventory['files'])==15
 for row in inventory['files']+inventory['sources']:
  item=Path(row['path']);assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'],str(item)
  stable[item]=row['sha256']
 pe_path=Path(manifest['source_pe']['path']);pe=pe_path.read_bytes()
 assert manifest['source_pe']['sha256']==digest(pe)==NATIVE_SHA
 stable[pe_path]=NATIVE_SHA
 source=load(folder/'provider_source.json');assert source['source_sha256']==NATIVE_SHA
 regions=source['regions']+source['data'];assert len(regions)==manifest['regions_verified']==22
 u16=lambda offset:int.from_bytes(pe[offset:offset+2],'little')
 u32=lambda offset:int.from_bytes(pe[offset:offset+4],'little')
 coff=u32(0x3c)+4;assert pe[coff-4:coff]==b'PE\0\0'
 optional=coff+20;assert u16(optional)==0x10b
 base=u32(optional+28);sections=optional+u16(coff+16)
 for row in regions:
  raw=bytes.fromhex(row['hex']);assert len(raw)==row['size'] and digest(raw)==row['sha256']
  rva=row['address']-base;found=[]
  for index in range(u16(coff+2)):
   section=sections+40*index;virtual=u32(section+12);size=u32(section+16);offset=u32(section+20)
   if virtual<=rva and rva+len(raw)<=virtual+size:
    found.append(pe[offset+rva-virtual:offset+rva-virtual+len(raw)])
  assert found==[raw],row['role']
 limits=[
  'Preparation only: integrated=false, complete=false; no Rust compilation or production changes in the frozen package.',
  'Four directory lifetimes and eight create/cache-hit calls use an explicitly null search context;17 native allocations/frees per lifetime do not qualify a working full provider.',
  'Both bounded provider attempts failed or stopped: before CreateDirectoryA and at uninitialized CRT execution BB40E64E. Their live-state/error evidence is preserved, not treated as successful provider cleanup.',
  'The31 inventoried source files are16 INIBIN and15 DDS; inventory/community parsing does not establish native INI loading, physical import, texture upload or rendering.',
  'Provider56, native INI/fallback, recursive parent/cache publication, populated-provider destruction and complete loading UI remain unfinished.',
  'The isolated scratch I/O environment is a design only; it has not been implemented or executed by this preparation.',
 ]
 reference={'manifest':ARCHIVE+'/next_provider_preparation/manifest.json','manifest_sha256':PROVIDER_PREPARATION_SHA,
            'readme':ARCHIVE+'/next_provider_preparation/README.md',
            'scratch_environment':ARCHIVE+'/next_provider_preparation/SCRATCH_ENVIRONMENT.md',
            'integrated':False,'complete':False,'rust_compiled':False,
            'directory_lifetimes':4,'directory_calls_with_null_context':8,'assets_inventoried':31,
            'abandoned_provider_attempts_preserved':2,'provider56_completed':False,
            'native_ini_completed':False,'loading_ui_completed':False,
            'historical_next_action_superseded_by':ARCHIVE+'/next_provider_io/manifest.json',
            'limits':limits,'next_action':NEXT_PROVIDER_ACTION}
 return reference,stable

def verify_provider_io_preparation():
 """Preserve the later I/O proof and its explicit unfinished CRT boundary."""
 folder=S/'next_provider_io';path=folder/'manifest.json'
 assert sha(path)==PROVIDER_IO_SHA
 manifest=load(path);assert manifest['schema']==1 and manifest['kind']=='confined_native_provider_io_preparation'
 assert all(manifest[key] is False for key in ['integrated','complete','rust_compiled'])
 assert manifest['source_pe']['sha256']==NATIVE_SHA
 files=manifest['files'];assert len(files)==9
 assert {p.relative_to(folder).as_posix() for p in folder.rglob('*') if p.is_file()}==set(files)|{'manifest.json'}
 stable={path:PROVIDER_IO_SHA}
 for relative,row in files.items():
  item=within(folder,relative);assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'];stable[item]=row['sha256']
 for filename,row in manifest['external_dependencies'].items():
  item=Path(filename);assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'];stable[item]=row['sha256']
 q=manifest['qualification']
 assert q['bridge_checks_passed']==36 and q['native_provider_complete'] is False
 assert q['explicit_stop']=='CABDA8 before uninitialized CRT dispatch' and q['earlier_error_preserved']=='BB40E64E UcError'
 assert q['requires_no_concurrent_filesystem_mutation'] is True
 assert all(q[key] is False for key in ['writable_junction_injection_tested','writable_hardlink_injection_tested','source_or_production_writes'])
 checks=load(folder/'io_isolation_tests.json')
 assert checks['passed'] is True and checks['complete'] is False and checks['error'] is None
 assert len(checks['checks'])==checks['check_count']==36 and checks['open_handles']==0
 source_file=Path(checks['source_file'])
 assert sha(source_file)==checks['source_sha256_before']==checks['source_sha256_after']
 stable[source_file]=checks['source_sha256_after']
 native=load(folder/'native_io_oracle.json');earlier=load(folder/'native_io_uninitialized_crt.json')
 for stopped in [native,earlier]:
  assert stopped['passed'] is False and stopped['complete'] is False and stopped['source_sha256']==NATIVE_SHA
  assert stopped['open_handles_at_stop']==stopped['open_host_handles_after_cleanup']==0
  assert stopped['phase']=='provider_miss' and len(stopped['live_snapshot']['blocks'])==28
  mkdir=[event for event in stopped['io_events'] if event['api']=='CreateDirectoryA']
  assert len(mkdir)==1 and mkdir[0]['result']==1
  assert Path(mkdir[0]['physical_path']).resolve().is_relative_to(Path(stopped['virtual_root']).resolve())
 assert native['pc']=='0xcabda8' and native['stop']['kind']=='uninitialized_crt_dispatch'
 assert native['stop']['required_native_initializers']==['C9A0B9/CABDE8','CA92CB','CB0378','CAFF53']
 assert earlier['pc']=='0xbb40e64e' and earlier['error']=='UcError()' and earlier['stop'] is None
 review_path=S/'next_provider_io_review/review_limits.json';assert sha(review_path)==PROVIDER_IO_REVIEW_SHA
 review=load(review_path)
 assert review['archive_manifest_sha256']==PROVIDER_IO_SHA and review['integrated'] is False and review['complete'] is False
 for relative,expected in review['reviewed_hashes'].items():assert sha(within(folder,relative))==expected
 assert len(review['limits'])==5
 stable[review_path]=PROVIDER_IO_REVIEW_SHA
 pe_path=Path(manifest['source_pe']['path']);pe=pe_path.read_bytes();assert digest(pe)==NATIVE_SHA;stable[pe_path]=NATIVE_SHA
 region_data=load(folder/'source_regions.json');assert region_data['source_sha256']==NATIVE_SHA and len(region_data['regions'])==3
 u16=lambda offset:int.from_bytes(pe[offset:offset+2],'little')
 u32=lambda offset:int.from_bytes(pe[offset:offset+4],'little')
 coff=u32(0x3c)+4;assert pe[coff-4:coff]==b'PE\0\0'
 optional=coff+20;assert u16(optional)==0x10b
 base=u32(optional+28);sections=optional+u16(coff+16)
 for row in region_data['regions']:
  raw=bytes.fromhex(row['hex']);assert len(raw)==row['size'] and digest(raw)==row['sha256']
  assert row['rva']==row['address']-base
  found=[]
  for index in range(u16(coff+2)):
   section=sections+40*index;virtual=u32(section+12);size=u32(section+16);offset=u32(section+20)
   if virtual<=row['rva'] and row['rva']+len(raw)<=virtual+size:
    found.append(pe[offset+row['rva']-virtual:offset+row['rva']-virtual+len(raw)])
  assert found==[raw],row['role']
 reference={'manifest':ARCHIVE+'/next_provider_io/manifest.json','manifest_sha256':PROVIDER_IO_SHA,
            'readme':ARCHIVE+'/next_provider_io/README.md',
            'independent_review':ARCHIVE+'/next_provider_io_review/review_limits.json','review_sha256':PROVIDER_IO_REVIEW_SHA,
            'integrated':False,'complete':False,'rust_compiled':False,'io_checks_passed':36,
            'real_scratch_config_mkdir_result':1,'provider_complete':False,'native_stop':'CABDA8',
            'earlier_failed_boundary_preserved':'BB40E64E UcError','native_ini_complete':False,'loading_ui_complete':False,
            'prior_preparation_preserved':ARCHIVE+'/next_provider_preparation/manifest.json',
            'limitations_from_independent_review':review['limits'],'next_action':NEXT_PROVIDER_IO_ACTION}
 return reference,stable

def prepare_archive(source_hashes,assembled):
 """Snapshot candidates unchanged and every explicitly qualified source file.

 Candidate manifests retain historical noncompiled flags. In particular the
 cache manifest includes a frozen pyc, which is copied as evidence, never run.
 """
 payloads={};rows={}
 for path in sorted(S.rglob('*')):
  relative=path.relative_to(S)
  if not path.is_file() or relative.parts[0]=='production':continue
  assert path.resolve().is_relative_to(S.resolve()),relative
  data=path.read_bytes();name=relative.as_posix()
  payloads[R/ARCHIVE/name]=data;rows[name]={'bytes':len(data),'sha256':digest(data)}
 for relative,expected in source_hashes.items():
  data=(R/relative).read_bytes();assert digest(data)==expected
  assert data==(S/'production'/relative).read_bytes(),relative
  name='qualified/'+relative
  payloads[R/ARCHIVE/name]=data;rows[name]={'bytes':len(data),'sha256':expected,'qualified_production_path':relative}
 assert sum('qualified_production_path' in row for row in rows.values())==len(source_hashes)
 index={'complete':False,'production_partially_integrated':True,'qualification_receipt':RECEIPT,
        'candidate_manifest_flags_preserved':True,'qualified_file_count':len(source_hashes),
        'candidate_manifests':assembled['candidate_manifests'],'files':rows}
 index_data=encoded(index);payloads[R/ARCHIVE/'index.json']=index_data
 return payloads,{'manifest':ARCHIVE+'/index.json','sha256':digest(index_data),'qualified_file_count':len(source_hashes)}

def publish(payloads,preflight):
 """Atomic per-file replacement; caught exceptions restore all prior bytes.

 The passed receipt is the final commit marker. This is not power-loss atomic.
 """
 assert list(payloads)[-1]==R/RECEIPT
 originals={path:path.read_bytes() if path.exists() else None for path in payloads}
 backup=R/'docs/plan_history'/('loading-resource-manager-validation-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
 backup.mkdir(parents=True)
 for path,data in originals.items():
  if data is not None:
   target=backup/path.relative_to(R);target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
   assert target.read_bytes()==data
 staged={};published=[]
 try:
  for path,data in payloads.items():
   path.parent.mkdir(parents=True,exist_ok=True)
   temp=path.with_suffix(path.suffix+'.loading-resource-manager-pending')
   staged[path]=temp;temp.write_bytes(data);assert temp.read_bytes()==data
  preflight()
  for path,temp in staged.items():
   temp.replace(path);published.append(path)
   assert path.read_bytes()==payloads[path],path
 except BaseException as primary:
  rollback_errors=[]
  for path in reversed(published):
   try:
    data=originals[path]
    if data is None:path.unlink(missing_ok=True)
    else:
     temp=path.with_suffix(path.suffix+'.loading-resource-manager-rollback')
     temp.write_bytes(data);temp.replace(path);assert path.read_bytes()==data
   except BaseException as error:rollback_errors.append(error)
  if rollback_errors:raise BaseExceptionGroup('Qualification publication failed; rollback also failed',[primary,*rollback_errors])
  raise
 finally:
  for temp in staged.values():
   try:temp.unlink(missing_ok=True)
   except OSError:pass # Unpublished staging residue is safe to overwrite on retry.

def main(repair_manifest_sha256=None,test_order_repair_sha256=None):
 assert __debug__,'Python -O is forbidden'
 assembled=load(S/'assembled.json');installed=load(S/'installed.json')
 assembled_sha=sha(S/'assembled.json');installed_sha=sha(S/'installed.json')
 assert assembled_sha==installed['assembled_sha256']
 assert installed['files']==assembled['files'] and len(installed['files'])==24
 correction=verify_test_correction(assembled,installed)
 repair=verify_repair(assembled,installed,correction,repair_manifest_sha256)
 repair_installation,repair_stable=verify_repair_installation(repair,repair_manifest_sha256)
 test_order_repair,test_order_stable=verify_test_order_repair(assembled,installed,repair,test_order_repair_sha256)
 test_order_installation,test_order_install_stable=verify_test_order_installation(test_order_repair,test_order_repair_sha256)
 added_tests=[] if repair is None else repair['added_tests']
 expected_passed=890+len(added_tests)
 previous_path=within(R,assembled['previous_qualification'])
 assert sha(previous_path)==assembled['previous_receipt_sha256']
 previous=load(previous_path);assert previous['passed'] is True and previous['complete'] is False
 source_hashes,repairs=verify_source_set(installed,repair,test_order_repair)
 candidate_pins={}
 for relative,expected in assembled['candidate_manifests'].items():
  path=within(S,relative);assert sha(path)==expected;candidate=load(path);candidate_pins[relative]=expected
  for child,row in candidate['files'].items():
   item=within(path.parent,child)
   assert item.stat().st_size==row['bytes'] and sha(item)==row['sha256'],str(item)
 core_path=R/'logs/core-loading-resource-manager-tests.log';core_text=core_path.read_text(encoding='utf-8-sig')
 result=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',core_text)
 assert result==[(str(expected_passed),'0','0','0','480')] and 'test result: FAILED' not in core_text
 required=correction['effective_required_core_tests']+added_tests
 for name in required:assert re.search(r'^test (?:[\w]+::)*'+re.escape(name)+r' \.\.\. ok\s*$',core_text,re.M),name
 for name in EXCLUDED:assert not re.search(r'^test (?:[\w]+::)*'+re.escape(name)+r' \.\.\.',core_text,re.M),name
 runners=re.findall(r'Running unittests .*?\(([^)]+\.exe)\)',core_text);assert len(runners)==1
 core_exe=within(R,runners[0].replace('\\','/'))
 core={'passed':expected_passed,'failed':0,'filtered':480,'log':core_path.relative_to(R).as_posix(),'log_sha256':sha(core_path),
       'executable':core_exe.relative_to(R).as_posix(),'executable_sha256':sha(core_exe),
       'required_tests':required,'original_required_test_count':55,'effective_required_test_count':len(required),
       'required_test_correction':{'path':ARCHIVE+'/required_tests_correction.json','sha256':CORRECTION_SHA},
       'unchanged_filtered_tests_not_executed':EXCLUDED}
 build=R/'logs/client-loading-resource-manager-build.log';build_text=build.read_text(encoding='utf-8-sig')
 assert re.search(r'Finished .* target',build_text) and not re.search(r'^error(?:\[|:)',build_text,re.M)
 verifier=S.parent/'loading_clock_integration/verify_client_commands.py';assert sha(verifier)==VERIFIER_SHA
 spec=importlib.util.spec_from_file_location('client_resource_manager_checks',verifier)
 module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
 module.PREFIX=PREFIX;client=module.verify(root=R)
 assert client['passed'] is True and client['complete'] is False and client['commands']==11
 image_path=S/'independent_image_verification.json';image=load(image_path)
 assert image['passed'] is True and image['errors']==[]
 assert image['region_count']==73 and image['package_bytes']==21110 and image['native_source_sha256']==NATIVE_SHA
 assert image['package_sha256']==assembled['image']==IMAGE_SHA
 assert sha(R/'data/4.20/runtime/replay_runtime_image.bin')==IMAGE_SHA
 native=verify_native(assembled)
 if repair is not None:
  for relative,entry in repair['native_proofs'].items():
   native['repair:'+relative]={'path':relative,'sha256':source_hashes[relative],'verified_json_checks':entry['json_checks']}
 interrupted=interrupted_compile()
 provider_preparation,provider_stable=verify_provider_preparation()
 provider_io,provider_io_stable=verify_provider_io_preparation()
 historic=R/HISTORICAL_CLIENT_RECEIPT;assert sha(historic)==HISTORICAL_CLIENT_SHA
 history=load(historic);assert history['client_tests']['passed']==14 and history['client_tests']['failed']==0
 assert previous['prior_client_unit_test_receipt']==HISTORICAL_CLIENT_RECEIPT
 client_sources={}
 for relative in ['crates/client/src/main.rs','crates/client/src/native_effect_clock.rs']:
  actual=sha(R/relative);assert actual==history['source_hashes'][relative];client_sources[relative]=actual
 now=datetime.datetime.now(datetime.timezone.utc).isoformat()
 summary={'saved_utc':now,'passed':True,'complete':False,'receipt':RECEIPT,'core_tests_passed':expected_passed,
          'client_commands':11,'client_executable_sha256':client['executable_sha256'],
          'empty_resource_manager_connected':True,'normalized_cache_connected':True,'paired_owned_cleanup_connected':True,
          'real_resource_factory_connected':False,'normal_loading_screen_complete':False}
 value={'saved_utc':now,'passed':True,'complete':False,'scope':assembled['scope'],
        'previous_qualification':{'path':assembled['previous_qualification'],'sha256':assembled['previous_receipt_sha256']},
        'assembled_sha256':assembled_sha,'installed_sha256':installed_sha,'core_tests':core,'client':client,
        'source_and_resource_hashes':source_hashes,'client_source_hashes':client_sources,'qualified_repairs':repairs,
        'repair_manifest':None if repair is None else {'path':ARCHIVE+'/'+REPAIR_REL,'sha256':repair_manifest_sha256.lower(),
                    'added_tests':added_tests,'added_files':[p for p,row in repair['files'].items() if row['before_sha256'] is None],
                    'native_validation_limits':repair['limits'],'candidate_historical_execution_flags_preserved':True},
        'repair_installation':repair_installation,
        'test_order_repair':None if test_order_repair is None else {
         'manifest':ARCHIVE+'/test_order_repair.json','sha256':test_order_repair_sha256.lower(),
         'installation':test_order_installation,'only_changed_file':TEST_ORDER_PATH,'added_tests':[],
         'full_original_startup_order_qualified':False,
         'failed_run_diagnostic_only':{**test_order_repair['failed_run'],
          'log':ARCHIVE+'/'+test_order_repair['failed_run']['log'],'qualification_evidence':False}},
        'interrupted_compile_diagnostic_only':interrupted,
        'prepared_loading_resource_provider':provider_preparation,
        'prepared_loading_resource_provider_io':provider_io,
        'client_unit_tests_run_this_lot':False,'prior_client_unit_test_receipt':HISTORICAL_CLIENT_RECEIPT,
        'historical_client_unit_tests':{'passed':14,'current_core_not_requalified':True,'receipt_sha256':HISTORICAL_CLIENT_SHA},
        'build_log':{'path':build.relative_to(R).as_posix(),'sha256':sha(build)},
        'image':{'regions':73,'bytes':21110,'sha256':IMAGE_SHA,'independent_audit':ARCHIVE+'/independent_image_verification.json','independent_audit_sha256':sha(image_path)},
        'native_proofs':native,'native_manager_lifetimes':2,'manager_allocations_per_lifetime':14,
        'native_static_initializers':4,'bounded_backpointer_fragment':'592E49..592E6A',
        'native_hash_cases':264,'native_null_producer_cases':2,'native_cache_hit_tokens':66,'native_miss_boundaries':8,
        'current_core_tests_added':25+len(added_tests),'qualified_source_file_count':len(source_hashes),
        'required_tests_correction':correction,'qualified_candidate_manifests':candidate_pins,
        'candidate_historical_flags_preserved':True,'empty_manager_connected':True,'normalized_cache_connected':True,
        'paired_owned_cleanup_connected':True,'normal_startup_caller_complete':False,'normal_shutdown_caller_complete':False,
        'real_resource_factory_connected':False,'real_provider_cache_constructed':False,'populated_provider_destruction_qualified':False,
        'normal_loading_screen_complete':False,'limits':LIMITS,'next_action':NEXT_ACTION}
 docs={};doc_hashes={}
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  path=R/'docs'/name;doc_hashes[path]=sha(path);d=load(path)
  d[KEY]=summary;d['updated_utc']=now;d['next_action']=NEXT_ACTION
  d['prepared_loading_resource_provider']=provider_preparation
  d['prepared_loading_resource_provider_io']=provider_io
  for field in ['prepared_loading_resource_next','prepared_loading_resource_port_plan']:
   d[field].update(production_partially_integrated=True,integration_receipt=RECEIPT,complete=False,
     status='Historical preparation partially integrated and qualified; actual factory/providers and full startup/UI remain open.',
     remaining_work=NEXT_ACTION)
  d['prepared_next_evidence']['string24_ownership'].update(production_partially_integrated=True,integration_receipt=RECEIPT,
    required_work='Paired loading temporaries and lease retirement are qualified by this receipt. Other cache/provider/tutorial ownership contracts remain separate.')
  if name=='resume_checkpoint.json':
   d.setdefault('communication_preferences',{}).update(
    progress_dashboard_repetition='Do not repeat the tracker link, global percentage or time estimate unless the user asks. Communicate only concrete changes or blockers.',
    source='Explicit latest user request in this conversation; preserve on resume.')
   pending=d.get('in_progress')
   if pending is not None:
    assert pending['assembled_sha256']==assembled_sha and Path(pending['stage']).resolve()==S.resolve()
    if repair is not None:
     applied=pending['index_read_repair']
     assert Path(applied['manifest']).resolve()==(S/REPAIR_REL).resolve()
     assert applied['sha256']==repair_manifest_sha256.lower() and applied['tests_pending'] is True
     assert Path(applied['backup']).resolve()==Path(repair_installation['backup']).resolve()
    if test_order_repair is not None:
     applied=pending['test_order_repair']
     assert Path(applied['manifest']).resolve()==(S/'test_order_repair.json').resolve()
     assert applied['sha256']==test_order_repair_sha256.lower() and applied['tests_pending'] is True
     assert Path(applied['backup']).resolve()==Path(test_order_installation['backup']).resolve()
    d.pop('in_progress')
   d['state']='active';d['saved_utc']=now
   d.setdefault('last_verified',{}).update(loading_resource_manager_receipt=RECEIPT,loading_resource_manager_core_tests=expected_passed)
  if name=='completion_plan.json':
   for domain in d['domains']:
    if domain['id'] not in ['17','21']:continue
    entries=domain.setdefault('progress_evidence',[])
    if RECEIPT not in entries:entries.append(RECEIPT)
    domain['progress_updated_utc']=now
    for task in domain['tasks']:
     if task['id'] in ['17.3','21.3','21.4'] and RECEIPT not in task['evidence']:task['evidence'].append(RECEIPT)
   d['next_execution_steps'][0]=NEXT_ACTION
  docs[path]=d
 html=R/'docs/completion_plan.html';body=html.read_text(encoding='utf-8');doc_hashes[html]=sha(html)
 marker='loading-resource-manager-validation';assert marker not in body and body.count('</body>')==1
 section=f'<section id="{marker}"><h2>Gestionnaire de ressources et clé de chargement</h2><p>Le gestionnaire vide, ses quatre initialiseurs, la recherche du cache et le nettoyage des deux chaînes sont raccordés. {expected_passed} tests moteur ciblés et 11 commandes du client reconstruit passent. Le paquet de chargement atteint la frontière de la fabrique90B520. Les fournisseurs réels, leur destruction après chargement et le rendu complet restent à terminer.</p></section>'
 payloads,evidence=prepare_archive(source_hashes,assembled);value['evidence']=evidence
 payloads.update({path:encoded(d) for path,d in docs.items()})
 payloads[html]=body.replace('</body>',section+'</body>').encode('utf-8')
 payloads[R/RECEIPT]=encoded(value) # Passed receipt must remain the final item.
 stable={S/'assembled.json':assembled_sha,S/'installed.json':installed_sha,
         S/'required_tests_correction.json':CORRECTION_SHA,previous_path:assembled['previous_receipt_sha256'],
         historic:HISTORICAL_CLIENT_SHA,core_path:core['log_sha256'],core_exe:core['executable_sha256'],
         build:value['build_log']['sha256'],verifier:VERIFIER_SHA,image_path:value['image']['independent_audit_sha256'],
         R/'target/debug/openleague-client.exe':client['executable_sha256'],**doc_hashes}
 stable.update({R/relative:expected for relative,expected in source_hashes.items()})
 stable.update({S/'production'/relative:expected for relative,expected in source_hashes.items()})
 stable.update({R/relative:expected for relative,expected in client_sources.items()})
 stable.update({R/relative:expected for relative,expected in client['logs'].items()})
 stable.update(provider_stable)
 stable.update(provider_io_stable)
 stable.update(test_order_stable);stable.update(test_order_install_stable)
 if repair is not None:
  stable[S/REPAIR_REL]=repair_manifest_sha256.lower()
  stable.update({within((S/REPAIR_REL).parent,row['candidate']):row['after_sha256'] for row in repair['files'].values()})
  stable.update({within((S/REPAIR_REL).parent,relative):row['sha256'] for relative,row in repair['proof_files'].items()})
  stable.update({Path(path):row['sha256'] for path,row in repair['source_inputs'].items()})
  stable.update(repair_stable)
 def preflight():
  for path,expected in stable.items():assert sha(path)==expected,str(path)
 preflight();publish(payloads,preflight)
 print(json.dumps(summary))

if __name__=='__main__':
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--repair-manifest-sha256',help='SHA256 of the repair manifest independently reviewed by the root')
 parser.add_argument('--test-order-repair-sha256',help='SHA256 of the separate test-only order repair reviewed by the root')
 args=parser.parse_args();main(args.repair_manifest_sha256,args.test_order_repair_sha256)
