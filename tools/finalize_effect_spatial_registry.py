from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat()
log='logs/effect-spatial-registry-tests.log';result=(r/log).read_text(encoding='utf-8-sig');match=re.search(r'test result: ok\. (\d+) passed; 0 failed;',result);assert match
assert 'effect_registry_tracks_motion_camera_exit_reentry_and_disposal ... ok' in result
assert 'effect_registry_preserves_members_through_subdivision_and_removal ... ok' in result
receipt='docs/effect_spatial_registry_progress.json'
next_action='Raccorder effect_spatial_registry::Effects a projected_live, attribuer les identites stables et fournir les bornes group-vis ; appliquer les transitions au lieu de activer chaque creation. Ordonner apres camera, verifier tests et captures DX12/Vulkan, poursuivre les24domaines/114taches.'
files=['crates/client/src/effect_spatial_registry.rs','crates/client/src/main.rs',log]
proof=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests_passed=int(match[1]),registered_effect_stress_count=80,client_effect_registry_implemented=True,projected_live_integrated=False,full_suites_rerun=False,current_graphical_build=False,limits=['Composition reuses qualified existing tree/ownership and core visibility modules. These two integration tests are not a new native execution oracle.','Stable local nonzero identities adapt native descriptor addresses; caller supplies Troy bounds and frame timing.','Tests cover camera entry/exit/reentry, disposal, recycled storage, 80 effect subdivision, removal and invalid identity preflight.','No new graphical executable, screenshots or complete game acceptance.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('effect-spatial-registry-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,effect_spatial_registry_progress=receipt)
 changes=dict(effect_spatial_registry_integration_tests=int(match[1]),effect_spatial_registry_live_bound=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Registre spatial des effets</h2><p>Registre reutilisant les contrats spatiaux existants : entrees, sorties, retour dans le champ, suppression et 80 effets verifies. Raccordement a projected_live et captures restent ouverts.</p><a href="effect_spatial_registry_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt,int(match[1]))
