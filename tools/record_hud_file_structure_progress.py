from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();pending='--pending' in sys.argv
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/native_hud_file_loop_contract.json');assert native['passed'] and native['case_count']==34
log='logs/native-hud-file-structure-tests.log';text=(r/log).read_text(encoding='utf-8')
if not pending:assert '292 passed; 0 failed' in text
action='Achever résolution textures/polices/effets/groupes et affichage/interactions HUD ; intégrer et qualifier les réparations dans le runtime, reconstruire et inspecter Vulkan/DX12. Carte/zones bleues, six clients graphiques et ensemble du jeu restent ouverts.'
proof=dict(updated_utc=now,complete=False,native_cases=34,native_addresses=native['native_addresses'],structural_loop_ported=True,structural_loop_rust_compared=not pending,client_source_tests_passed=291 if pending else 292,current_source_suite_pending=pending,last_qualified_application_tests=279,application_rebuilt_after_changes=False,hud_resource_handles_resolved=False,hud_group_binding_complete=False,hud_runtime_integrated=False,hud_widgets_drawn=False,restoration_provider_staged=True,restoration_provider_integrated=False,artifacts=['data/4.20/native_hud_file_loop_contract.json','crates/client/src/native_hud_file_structure.rs',log],next_action=action,limits=['Whole-file structural loop only; native resource/font/effect and group association deliberately bypassed at9A3374.','Creation mode/source32files and2derived repairs qualified; replacement mode/collisions/ownership remain open.','Application remains previous279test build; no new visual/runtime acceptance.'])
proof['hashes']={p:sha(p) for p in proof['artifacts']}
(r/'docs/native_hud_file_structure_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-file-structure-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_file_structure_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=proof['client_source_tests_passed'],current_source_suite_pending=pending,current_client_application_tests=279,client_test_source_matches_current_build=False,current_source_progress='docs/native_hud_file_structure_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[dict(session_id=23587,command='cargo test -p openleague-client --bin openleague-client -j1',log=log,state='verified_live_when_checkpoint_written')] if pending else [])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-file-structure-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=marker+'<h2>Chargeur structurel HUD</h2><p>34fichiers originaux/réparés vérifiés dans la boucle native ; port Rust '+('en comparaison' if pending else 'comparé :292tests réussis')+'. Ressources/polices/effets/groupes et affichage restent ouverts. Application précédente279tests.</p><a href="native_hud_file_structure_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(pending=pending,tests=proof['client_source_tests_passed'],complete=False)))
