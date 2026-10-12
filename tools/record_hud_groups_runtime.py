from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
receipt=load('docs/native_hud_groups_build_receipt.json');assert receipt['client_sha256']==sha('target/debug/openleague-client.exe') and receipt['source_tests_passed']==296
captures=[load('docs/hud-groups-loading-'+backend+'-capture.json') for backend in ['vulkan','dx12']]
for c in captures:
 assert c['client_sha256']==receipt['client_sha256'] and c['scene_groups']==48 and c['bound_elements']==697 and c['unbound_elements']==6 and c['visual_inspected']
 assert c['accepted_elements']==703 and c['repaired_files']==2 and c['shadow_atlas_native_bytes_equal'] and not c['hud_widgets_drawn']
 assert c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
assert sha('data/4.20/archives/menu/HUD.zip')=='76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c'
receipt.update(hud_group_loading_runtime_verified=True,backends=['Vulkan','Dx12'],captures=[c['capture'] for c in captures],hud_widgets_drawn=False)
(r/'docs/native_hud_groups_build_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p=r/'docs/native_hud_groups_progress.json';proof=load('docs/native_hud_groups_progress.json');proof.update(updated_utc=now,current_source_suite_pending=False,client_build_pending=False,application_rebuilt_after_changes=True,current_application_source_tests=296,last_qualified_application_tests=296,group_source_loading_observed_in_application=True,backends_verified=['Vulkan','Dx12'],captures=captures,group_bounds_native_cases=1152,group_bounds_rust_ported=False)
proof['limits']=[v for v in proof['limits'] if not v.startswith('697membership assignments')];proof['limits'].append('Application296test build loads48sourcegroups and697members with6undeclared-group overlays on Vulkan/Dx12; fixed-camera scenes inspected, no widget drawing or complete-game claim.')
proof['artifacts'].append('data/4.20/native_hud_group_bounds_contract.json');proof['hashes']['data/4.20/native_hud_group_bounds_contract.json']=sha('data/4.20/native_hud_group_bounds_contract.json')
proof['limits'].append('1152native bounds union/cache cases qualified with supplied owner dimensions/scalars and source elements; not yet ported toRust or integrated with group render caches.')
p.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-groups-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_groups_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=296,current_source_suite_pending=False,client_build_pending=False,current_client_application_tests=296,client_test_source_matches_current_build=True,current_source_progress='docs/native_hud_groups_progress.json',native_hud_scene_groups=48,native_hud_bound_elements=697,native_hud_unbound_elements=6,native_hud_group_bounds_cases=1152)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[])
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-groups-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=marker+'<h2>Groupes HUD vérifiés dans le client</h2><p>296tests réussis, client reconstruit.48groupesScenes.ini et697rattachements observés sur Vulkan/DirectX12 ;6surcouches référencentHUDCenterAbilitys absent des définitions. Captures inspectées.1152cas natifs de limites de groupes préparés pour portRust. Caches/horloge/options/disposition, ressources et affichage/interactions restent incomplets.</p><a href="native_hud_groups_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(tests=296,groups=48,bound=697,unbound=6,backends=['Vulkan','Dx12'],bounds_native_cases=1152,widgets_drawn=False,complete=False)))
