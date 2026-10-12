from pathlib import Path
import json, datetime, hashlib, shutil
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc); stamp=now.isoformat()
files=['logs/health-camera-client-build.log','target/debug/openleague-client.exe']; results={}
assert 'Finished `dev`' in (r/files[0]).read_text(encoding='utf-8-sig')
for backend in ['dx12','vulkan']:
    capture=f'docs/projected_core_cycle_capture_v28_health_{backend}.json'
    pair=f'docs/projected_pair_control_v28_health_{backend}.json'
    c=json.loads((r/capture).read_text()); p=json.loads((r/pair).read_text())
    assert c['client_sha256']==hashlib.sha256((r/files[1]).read_bytes()).hexdigest()
    assert p['same_frame_attribution_gate_passed'] and p['strict_baseline_equal']
    log=(r/f'logs/projected-core-cycle-v28-health-{backend}-client.log').read_text(encoding='utf-8-sig')
    assert 'Invalid surface' not in log and 'already requested' not in log
    results[backend]={'capture':capture,'pixels':pair,'qualified_identities':c['camera_reentry_qualified_identities'],'baseline':p['baseline'],'visually_inspected_owner':1,'phases':['initial','hidden','returned'],'observation':'Champion bars absent in base view; structure bars attached to base structures; champion bars restored at lane return. No stale bars observed in these six inspected images.'}
    files.extend([capture,pair])
receipt='docs/health_camera_runtime_progress.json'
next_action='Reproduire et corriger le defaut DX12 ResizeBuffers/Invalid surface observe en v26, puis qualifier redimensionnement et restauration. HUD camera corrige: 14 tests et captures v28 DX12/Vulkan. Ne pas confondre ce scenario diagnostique avec acceptation du jeu complet. Poursuivre les 24 domaines du plan.'
d={'updated_utc':stamp,'complete':False,'graphical_build_complete':True,'health_camera_scenario_passed':True,'results':results,'dx12_resize_defect_open':True,'limits':['Six images inspected by agent, not human fidelity approval.','Diagnostic camera jump and seeded match; free camera endurance and resize remain unqualified.','Blue background visible outside eastern map geometry remains to investigate.'],'artifacts_sha256':{f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},'next_action':next_action}
(r/receipt).write_text(json.dumps(d,indent=2)+'\n')
h=r/'docs/plan_history'/('health-camera-runtime-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json','health_camera_progress.json']:
    f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,health_camera_runtime_progress=receipt)
    if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action,active_graphical_build=None)
    if name=='health_camera_progress.json':d.update(active_build_session=None,graphical_validation=True,graphical_validation_scope='v28 camera jump, owner1 initial/hidden/returned in DX12 and Vulkan',next_action=next_action)
    if name=='completion_plan.json':
        assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
        d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
    if name=='goal_plan_revision.json':d['next_steps']=[next_action]
    f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name)
f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Verification HUD camera DX12 et Vulkan</h2><p>Build termine. Six images inspectees: barres coherentes pendant sortie et retour de camera. Attribution GPU et deux nettoyages par backend reussis. Defaut DX12 de redimensionnement encore ouvert.</p><a href="health_camera_runtime_progress.json">Preuves du scenario</a></section></body>'),encoding='utf-8')
print(receipt)
