from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '190 passed; 0 failed' in (r/'logs/grass-actor-subclasses-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-actor-subclasses-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/grass_actor_subclasses_contract.json');assert proof['passed'] and [len(proof[k]) for k in ['source_cases','id_cases','linked_cases']]==[5,64,1440]
paths=['data/4.20/grass_actor_subclasses_contract.json','crates/client/src/grass_actor_subclasses.rs','crates/client/src/grass_actor_visibility.rs','crates/client/src/main.rs','logs/grass-actor-subclasses-tests.log','logs/grass-actor-subclasses-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=190,client_build_passed=True,native_associated_source_cases=5,native_identifier_gate_cases=64,native_linked_gate_cases=1440,native_addresses=proof['native_addresses'],actor_subclass_gate_consumers_ported=True,live_grass_mask_integrated=False,findings=['Original62DF30 plus weak acquisition5BD6F0/5EC2A0 and drop execute with unchanged retained refcounts: empty/expired/null-pointee/wrong-bit/valid cases. RustWeak adapter matches candidate recovery and leaves strong reference counts unchanged.','Original644E40 identifier gate64cases compares result, identifier calls and service calls; identifier mismatch precedes bit2 and globaloverride shortcuts.','Original62DC80 linked gate1440cases compares result and exact service callorder through original617F10/6B2C30. Rustshares qualified source predicate instead of duplicating selection rules.'],limits=proof['limits']+['RustWeak/Arc candidate container is an ownership adapter; native ABI/object constructors and final native destructors not ported. Returned Rust value is cloned before releasing lease.','No normal-match/GPU capture. All24domains unfinished; complete actor source/global field producers and live render integration remain open.'],next_actions=['Recover actual source/global service and identifier producers, registry eligibility flags and actor AABB writers.','Qualify camera inputs and connect actual actor collector to recovered mask/WALL renderer, inspect normal Map10 match.','Continue complete24domainplan, allchampionkits, sixclientvictory/results and delivery.'],files_sha256={p:sha(p) for p in paths})
save('docs/grass_actor_subclasses_progress.json',receipt)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('187 tests','190 tests').replace('187tests','190tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier producteurs réels des sources/services/identifiants, flags du registre, AABB et caméra ; intégrer le masque des buissons et WALL_OF_GRASS au rendu normal. Critères particuliers644E40/62DC80 portés et comparés à64/1440cas natifs ; récupération associée62DF30 sur5cas. 190tests et compilation réussis. Producteurs et branchement à la partie restant ouverts. Poursuivre tous les domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_actor_subclasses_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=190;d['pending_native_jobs']=[];d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=190,current_test_receipt='docs/grass_actor_subclasses_progress.json',current_build_receipt='docs/grass_actor_subclasses_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),native_grass_actor_subclass_gates_ported=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Critères particuliers et acteur associé</h2><p>64/1440cas natifs,5cas de récupération faible ;190tests et compilation réussis. Producteurs, AABB/caméra et intégration au jeu restent ouverts.</p><a href="grass_actor_subclasses_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_grass_actor_subclasses_progress.py',r/'tools/record_grass_actor_subclasses_progress.py')
print(json.dumps(dict(client_tests=190,id_cases=64,linked_cases=1440,source_cases=5,complete=False)))
