from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
receipt=load('docs/native_hud_layout_build_receipt.json');assert receipt['client_sha256']==sha('target/debug/openleague-client.exe') and receipt['source_tests_passed']==293
captures=[load('docs/hud-layout-loading-'+backend+'-capture.json') for backend in ['vulkan','dx12']]
for c in captures:
 assert c['client_sha256']==receipt['client_sha256'] and c['accepted_elements']==703 and c['repaired_files']==2 and c['visual_inspected']
 assert c['shadow_atlas_native_bytes_equal'] and c['atlas_count']==5 and not c['hud_widgets_drawn']
assert sha('data/4.20/archives/menu/HUD.zip')=='76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c'
receipt.update(hud_layout_loading_runtime_verified=True,backends=['Vulkan','Dx12'],captures=[c['capture'] for c in captures],hud_widgets_drawn=False)
(r/'docs/native_hud_layout_build_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p=r/'docs/native_hud_layout_provider_progress.json';proof=load('docs/native_hud_layout_provider_progress.json');proof.update(updated_utc=now,current_source_suite_pending=False,client_build_pending=False,application_rebuilt_after_changes=True,current_application_source_tests=293,last_qualified_application_tests=293,restoration_provider_observed_in_application=True,backends_verified=['Vulkan','Dx12'],captures=captures)
proof['limits']=[v for v in proof['limits'] if not v.startswith('Application previous279')];proof['limits'].append('Application293test build loads703elements and2derived repairs on Vulkan/Dx12; fixed-camera scene inspected, widget drawing/resource binding and complete game remain open.')
p.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-layout-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_layout_provider_progress=proof)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=293,current_source_suite_pending=False,client_build_pending=False,current_client_application_tests=293,client_test_source_matches_current_build=True,current_source_progress='docs/native_hud_layout_provider_progress.json',native_hud_layout_files=32,native_hud_layout_elements=703,native_hud_repaired_files_selected=2)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[])
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-layout-provider-progress">'
if marker in s:
 start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+s[end:]
section=marker+'<h2>Chargement HUD vérifié dans le client</h2><p>293tests réussis, client reconstruit.32fichiers/703éléments et2réparations chargés sur Vulkan etDirectX12, captures inspectées.374cas de paramètres/couleurs effets natifs comparés. Ressources/polices/effets/groupes et affichage/interactions restent incomplets ; jeu non terminé.</p><a href="native_hud_layout_provider_progress.json">Preuves et limites</a></section>'
p.write_text(s.replace('</body>',section+'</body>'),encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tests=293,application_rebuilt=True,files=32,elements=703,repairs=2,backends=['Vulkan','Dx12'],widgets_drawn=False,complete=False)))
