from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
log='logs/native-hud-viewport-tests.log'
assert '299 passed; 0 failed' in (r/log).read_text(encoding='utf-8')
assert load('data/4.20/native_hud_viewport_transfer_contract.json')['passed']
action='Reconstruire le client299tests puis vérifier le log de viewport/41groupes et captures Vulkan/DX12 ; terminer producteurs réglages/cycle caches, ressources/polices/effets, widgets/interactions ; corriger carte/zones bleues, six clients graphiques et24domaines.'
artifacts=['crates/client/src/native_hud_viewport.rs','crates/client/src/main.rs','data/4.20/native_hud_viewport_transfer_contract.json','data/4.20/native_hud_owner_prefix_contract.json',log]
proof=dict(updated_utc=now,complete=False,client_source_tests_passed=299,last_qualified_application_tests=296,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=False,viewport_transfer_native_cases=12,constructor_prefix_native_cases=2,runtime_dimension_supplier='Bevy primary Window physical dimensions',initial_scalar_bits=0x3f800000,runtime_bounds_refresh_integrated=True,runtime_bounds_refresh_window_test_passed=True,runtime_application_observed=False,source_group_bounds_native_cases=1152,groups=48,bound_elements=697,unbound_elements=6,initial_refreshed_groups=41,hud_widgets_drawn=False,full_native_resize_lifecycle_complete=False,settings_overrides_complete=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=['Original owner prefix initializes scalar1.0, not viewport; original transfer branch tested on12supplied Game dimension cases.','OpenLeague supplies physical Bevy Window dimensions; upstream original Game producer and logical/physical mapping not qualified.','Rust app Window test verifies1280x800 then1920x1080 source group limits against native fixtures and clean cache reuse.','OpenLeague explicitly invalidates nonempty group bounds on dimension change; this does not prove original full resize/GPU/font/cache lifecycle.','Source suite passed; previous application296test build, no new visual/runtime acceptance. Widgets/complete game not achieved.'])
(r/'docs/native_hud_viewport_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-viewport-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_viewport_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=299,current_source_suite_pending=False,current_client_application_tests=296,client_test_source_matches_current_build=False,current_source_progress='docs/native_hud_viewport_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-viewport-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=marker+'<h2>Viewport HUD</h2><p>299tests source réussis. Fenêtre réelle raccordée ; changement1280×800 vers1920×1080 comparé aux limites natives. Application précédente296tests : reconstruction et contrôle visuel à faire. Cycle natif complet/réglages, ressources et widgets ouverts.</p><a href="native_hud_viewport_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tests=299,complete=False,application_tests=296,runtime_source_integrated=True)))
