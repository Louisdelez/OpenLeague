from pathlib import Path
import json,datetime,hashlib,shutil,argparse
args=argparse.ArgumentParser();args.add_argument('--pending',type=int);args.add_argument('--log',default='logs/native-hud-layout-provider-tests.log');args.add_argument('--tests',type=int,default=292);args=args.parse_args()
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();pending=args.pending is not None
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
if not pending:assert f'{args.tests} passed; 0 failed' in (r/args.log).read_text(encoding='utf-8')
uniforms=load('data/4.20/native_hud_effect_uniforms_contract.json');assert uniforms['passed'] and uniforms['case_count']==374
ported=(r/'crates/client/src/native_hud_effect_uniforms.rs').exists()
action='Terminer résolution textures/polices/effets/groupes et affichage/interactions HUD. Reconstruire puis vérifier chargement des703éléments et des2réparations sur Vulkan/DX12. Corriger carte/zones bleues ; partie à six clients graphiques et tous les24domaines restent ouverts.'
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=args.tests,current_source_suite_pending=pending,last_qualified_application_tests=279,application_rebuilt_after_changes=False,current_binary_sha256=sha('target/debug/openleague-client.exe'),structural_file_cases=34,structural_loop_rust_compared=True,restoration_provider_integrated_in_source=True,restoration_provider_rust_verified=not pending,restoration_provider_observed_in_application=False,source_layout_files=32,source_layout_elements=703,derived_repaired_files=2,archive_original_unchanged=sha('data/4.20/archives/menu/HUD.zip')=='76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c',effect_uniform_native_cases=374,effect_uniforms_ported=ported,effect_uniforms_rust_compared=ported and not pending,hud_resource_handles_resolved=False,hud_group_binding_complete=False,hud_widgets_drawn=False,artifacts=['data/4.20/native_hud_file_loop_contract.json','data/4.20/native_hud_effect_uniforms_contract.json','crates/client/src/native_hud_file_structure.rs','crates/client/src/native_zip_provider.rs','crates/client/src/main.rs',args.log],next_action=action,limits=['Fixed ShadowIsles normal profile selected explicitly; native upstream profile selection and replacement mode remain open.','Original archives supply data; only two explicit derived overlays selected after byte comparison against native-qualified source and repair inputs. Qualification fixture is a comparator, not the resource supplier.','Structural data loaded; native resource/font/effect lookup, group ownership and widget drawing/interactions remain incomplete.','Application previous279test binary remains distinct from changed source; no current rendering or complete-game claim.'])
if ported:proof['artifacts'].append('crates/client/src/native_hud_effect_uniforms.rs')
proof['hashes']={p:sha(p) for p in proof['artifacts']}
assert proof['archive_original_unchanged']
(r/'docs/native_hud_layout_provider_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-layout-provider-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_layout_provider_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=args.tests,current_source_suite_pending=pending,current_client_application_tests=279,client_test_source_matches_current_build=False,current_source_progress='docs/native_hud_layout_provider_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[dict(session_id=args.pending,command='cargo test -p openleague-client --bin openleague-client -j1',log=args.log,state='verified_live_when_checkpoint_written')] if pending else [])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-layout-provider-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=marker+'<h2>Chargement HUD et réparations</h2><p>32fichiers/703éléments et2réparations intégrés aux sources ; comparaison Rust '+('en cours' if pending else f'validée :{args.tests}tests réussis')+'.374cas de conversion native des paramètres/couleurs effets vérifiés. Application279tests ; ressources/groupes/affichage/interactions restent ouverts.</p><a href="native_hud_layout_provider_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(pending=pending,tests=args.tests,provider_integrated=True,uniforms_ported=ported,complete=False)))
