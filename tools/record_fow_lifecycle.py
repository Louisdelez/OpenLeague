from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '100 passed; 0 failed' in (r/'logs/native-secondary-position-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-secondary-position-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_lifecycle_contract.json');assert proof['passed'] and len(proof['eligibility'])==24 and len(proof['lifetime'])==105
secondary=load('data/4.20/fow_secondary_position_contract.json');assert secondary['passed'] and len(secondary['cases'])==48
files=['data/4.20/fow_lifecycle_contract.json','tools/probe_fow_lifecycle.py','data/4.20/fow_secondary_position_contract.json','tools/probe_fow_secondary_position.py','crates/client/src/fow_lifecycle.rs','crates/client/src/fow_position.rs','crates/client/src/main.rs','logs/native-lifecycle-tests.log','logs/native-lifecycle-build.log','logs/native-secondary-position-tests.log','logs/native-secondary-position-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=100,client_build_passed=True,native_eligibility_cases=24,native_lifetime_cases=105,native_secondary_position_cases=48,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Executed complete original eligibility6B0980 in24cases without adapters. Registry handle and raw actor flagsAD/118 control owner-backed eligibility; uncached source is eligible. Generation is not checked in this method.','Executed original lifetime manager6B2110 and its original primary position refresh in105cases. Removal boundary6B1F90 explicitly adapted to erase a single vector entry; original removal queue and destruction not executed.','Rust eligibility and advance match native results: zero duration persists; nonzero duration dispatches removal if elapsed>=duration, otherwise subtracts elapsed; invalid owner position refresh shortens duration before manager tests it.'],
 limits=proof['limits']+secondary['limits']+['Ordinary source lifecycle, raw actor flag/position producers, removal queue/count rollback and live fog integration remain open.','100client tests and build are current;427core tests and10UDPchecks remain prior unchanged-core/server evidence.','All24domains remain unfinished.'],
 next_actions=['Qualify secondary position field producers and complete actor/provider construction; original getter5FFFD0 reads provider+2AA after component offset70.','Qualify original source removal queue and visibility count rollback, team/creation/activation and raw flag producers.','Connect actual Rust source identities and qualified lifecycle to masks, authoritative filtering and GPU rendering; qualify world extent and terrain initialization.'],files_sha256={p:sha(p) for p in files})
receipt['findings'].append('Qualified non-null secondary shared provider and original5FFFD0 getter in48cases, retaining reference counts; secondary X/Z takes priority over actor primary position. Constructor chain61F470 ->641A50 ->641750 ->603660 statically establishes component1094490; full constructors/position producers not executed. Rust refresh now consumes optional secondary position.')
save('docs/native_fow_lifecycle_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_fow_lifecycle_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=100;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=100,current_build_receipt='docs/native_fow_lifecycle_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — position secondaire, éligibilité et durée de vie</h2><p>100 tests client et compilation réussis.48cas de position secondaire et24cas d’éligibilité sans adaptateur ;105cas de durée et position avec frontière de suppression adaptée explicitement. Suppression complète, compteurs, producteurs des champs et rendu ordinaire restent ouverts.</p><a href="native_fow_lifecycle_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_lifecycle.py'),r/'tools/record_fow_lifecycle.py')
print(json.dumps(dict(client_tests=100,eligibility_cases=24,lifetime_cases=105,secondary_position_cases=48,complete=False)))
