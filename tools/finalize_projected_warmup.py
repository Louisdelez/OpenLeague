from pathlib import Path
import json,datetime,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(n):return json.loads((r/'docs'/n).read_text(encoding='utf-8-sig'))
def save(n,d):(r/'docs'/n).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
receipts=['projected_pipeline_warmup_measurement_progress.json','projected_pipeline_warmup_dx12_measurement_progress.json']
for n in receipts:
    m=load(n)
    assert len(m['projection_instances'])==2
    assert all(x['nonready_frames']==0 and x['warmup_seconds']==0 and x['all_fow_ready'] for x in m['projection_instances'])
    m['artifacts_sha256']['crates/client/src/projected_warmup.rs']=hashlib.sha256((r/'crates/client/src/projected_warmup.rs').read_bytes()).hexdigest();save(n,m)
receipt='projected_warmup_progress.json'
d=dict(updated_utc=now,complete=False,first_cast_pipeline_delay_fix_verified=True,backends=['vulkan','dx12'],casts=4,pipeline_nonready_frames=0,first_frame_fow_bindings_verified=True,client_sha256=load(receipts[0])['client_sha256'],measurements=['docs/'+n for n in receipts],runtime_captures=['docs/projected_core_cycle_capture_v7.json','docs/projected_core_cycle_capture_v8_dx12.json'],limits=['Two casts per backend; startup specializer uses production camera/material/vertex layout keys. No compile delay observed during any measured projection.', 'Pipeline ready does not prove fragment output. First DX12 capture lacks clearly attributable glow; exact frame-aligned pixels, receiver selection, owner factors, native fidelity and full kit/game remain unfinished.'])
save(receipt,d)
p=load('projected_warmup_pending.json');p.pop('session_id',None);p.update(updated_utc=now,status='build_and_four_cast_two_backend_measurement_passed',progress='docs/'+receipt);save('projected_warmup_pending.json',p)
next_action='Isoler les fragments de la projection normale sur une image GPU synchronisée, notamment au premier lancement DirectX 12 ; qualifier les fournisseurs natifs et poursuivre le rendu/audio et tous les 24 domaines.'
for n in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
    p=load(n);p.update(updated_utc=now,projected_warmup_progress='docs/'+receipt)
    if n=='resume_checkpoint.json':p.pop('pending_projected_warmup',None);p.update(saved_utc=now,next_projected_action=next_action)
    elif n=='completion_plan.json':p['next_execution_steps'][0]=next_action
    elif n=='goal_plan_revision.json':p['next_steps']=[next_action]
    save(n,p)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
p=load('completion_plan.json');p['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('completion_plan.json',p)
p=load('goal_plan_revision.json');p['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('goal_plan_revision.json',p)
p=r/'docs/completion_plan.html';p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Pipeline de projection préparé — Vulkan et DirectX 12</h2><p>Quatre lancements vérifiés sur le même exécutable : pipeline prêt et brouillard lié dès la première image mesurée, sans attente de compilation pendant les effets. L’attribution exacte des pixels reste ouverte, notamment sur la première capture DirectX 12. Aucun domaine ou kit entièrement clôturé.</p><p><a href="projected_warmup_progress.json">Preuves et limites</a></p></section></body>'),encoding='utf-8')
for n in ['analyze_projected_warmup_probe.py','analyze_projected_warmup_dx12_probe.py','install_projected_warmup.py','finalize_projected_warmup.py']:
    shutil.copy2(Path('E:/mapslol3v3')/n,r/'tools'/n)
print('Four casts/two backends verified; pipeline delay fixed; pixel attribution remains open')
