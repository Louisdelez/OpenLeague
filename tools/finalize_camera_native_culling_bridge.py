from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat()
log='logs/camera-native-culling-bridge-tests.log';result=(r/log).read_text(encoding='utf-8-sig');match=re.search(r'test result: ok\. (\d+) passed; 0 failed;',result);assert match
assert 'camera_native::tests::map10_pose_uses_native_geometry_and_points_at_the_supplied_focus ... ok' in result
receipt='docs/camera_native_culling_bridge_progress.json'
next_action='Integrer un registre projectile reutilisant grass_object_registry/grass_spatial_chain ; fournir les bornes group-vis natives et le volume NativeCamera a la requete spatiale puis appliquer les transitions. Ordonner projected_live::update apres camera et verifier ordonnancement natif, rendu et captures, poursuivre les24domaines/114taches.'
files=['crates/client/src/camera_native.rs',log]
proof=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests_passed=int(match[1]),camera_positions=5,aspect_ratios=[0.5,1,16/9],culling_cases=15,retains_native_pose=True,client_effect_registry_integrated=False,full_suites_rerun=False,current_graphical_build=False,limits=['Tests verify target inclusion and behind-camera rejection plus absent pose/invalid aspect errors.','NativeCamera preserves the last successfully computed pose, including configured shake and depth.','Identity inverse fallback supplied; normal nonsingular poses tested.','No new graphical executable, screenshots or complete game acceptance.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('camera-native-culling-bridge-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,camera_native_culling_bridge_progress=receipt)
 changes=dict(camera_native_culling_client_cases=15,camera_native_culling_client_tests=int(match[1]),camera_native_culling_effect_registry_integrated=False)
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
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Volume de visibilite de la camera client</h2><p>Pose native conservee ; inclusion du point vise et exclusion derriere la camera verifiees pour 15 configurations. Registre des effets et captures restent ouverts.</p><a href="camera_native_culling_bridge_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt,int(match[1]))
