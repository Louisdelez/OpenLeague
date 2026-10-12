from pathlib import Path
import json,datetime,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(n):return json.loads((r/'docs'/n).read_text(encoding='utf-8-sig'))
def save(n,d):(r/'docs'/n).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
names=['projected_pair_control_'+v+'.json' for v in ['v11_pair_dx12','v12_pair_dx12_no_gamma','v13_pair_dx12_no_msaa']]
controls=[load(n) for n in names]
assert not controls[0]['strict_baseline_equal'] and not controls[1]['strict_baseline_equal'] and controls[2]['strict_baseline_equal']
assert controls[2]['same_frame_attribution_gate_passed']
receipt='projected_pair_stage_controls_progress.json'
d=dict(updated_utc=now,complete=False,controls=['docs/'+n for n in names],six_casts_executed=True,renderer_stage_narrowed='DX12 paired-view discrepancies persist without gamma and disappear with MSAA disabled in diagnostic cameras.',unmodified_dx12_pixel_attribution_qualified=False,dx12_no_msaa_diagnostic_pixel_attribution_qualified=True,original_fidelity_qualified=False,client_sha256=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),limits=['Controls identify a dependency on the multisampled path; exact DX12 raster/resolve/order cause remains unqualified.', 'Ordinary game camera MSAA remains unchanged. Single-sample diagnostic equality is not acceptance of the unmodified multisampled output.', 'Original LoL antialiasing target/postprocess configuration, complete native projection fidelity, kits and all24domains remain unfinished.'])
save(receipt,d)
p=load('projected_pair_baseline_pending.json');p.pop('session_id',None);p.update(updated_utc=now,status='build_and_three_control_captures_passed_msaa_dependency_observed',progress='docs/'+receipt);save('projected_pair_baseline_pending.json',p)
next_action='Qualifier le réglage anticrénelage natif LoL4.20 et examiner la voie de résolution MSAA DirectX 12 ; conserver les preuves mono-échantillon séparées, puis poursuivre le rendu/audio et les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
    p=load(name);p.update(updated_utc=now,projected_pair_stage_controls_progress='docs/'+receipt)
    if name=='resume_checkpoint.json':p.pop('pending_pair_stage_controls',None);p.update(saved_utc=now,next_projected_action=next_action)
    elif name=='completion_plan.json':p['next_execution_steps'][0]=next_action
    elif name=='goal_plan_revision.json':p['next_steps']=[next_action]
    if name!='goal_plan_revision.json':
        target=p['last_verified'] if name=='resume_checkpoint.json' else p['current_evidence'];target.update(current_client_sha256=d['client_sha256'],annie_projection_dx12_no_msaa_diagnostic_pixel_attribution_qualified=True,annie_projection_reconstructed_dx12_pixel_attribution_qualified=False)
    save(name,p)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
p=load('completion_plan.json');p['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('completion_plan.json',p)
p=load('goal_plan_revision.json');p['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('goal_plan_revision.json',p)
p=r/'docs/completion_plan.html';p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>DirectX 12 — contrôles de rendu</h2><p>Six lancements sur le même exécutable. Référence : 33 images avec écarts. Sans gamma : écarts persistants sur 32 images. Sans MSAA dans les vues de diagnostic : 33 références identiques, contribution de deux projections isolée. La dépendance à la voie MSAA est identifiée ; la cause de résolution précise et le réglage natif LoL4.20 restent à qualifier. Le MSAA de la caméra de jeu est conservé.</p><p><a href="projected_pair_stage_controls_progress.json">Contrôles, empreintes et limites</a></p></section></body>'),encoding='utf-8')
for n in ['analyze_pair_stage_control.py','refine_projected_pair_baseline.py','finalize_pair_stage_controls.py']:
    shutil.copy2(Path('E:/mapslol3v3')/n,r/'tools'/n)
print('Six casts/three controls recorded; MSAA path narrowed; full Goal remains active/incomplete')
