from pathlib import Path
import json,datetime,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(n):return json.loads((r/'docs'/n).read_text(encoding='utf-8-sig'))
def save(n,d):(r/'docs'/n).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
vk=load('projected_pixel_pair_progress.json');dx=load('projected_pixel_pair_dx12_progress.json')
assert vk['same_frame_pixel_attribution_passed'] and not dx['same_frame_pixel_attribution_passed']
assert vk['baseline_frames']==59 and dx['baseline_frames']==32
raw=load('../logs/projected-core-cycle-v10-pair-dx12-pixels.json');active=[x for x in raw['rows'] if x['draws']];first=min(x['time'] for x in active)
baseline=[x for x in raw['rows'] if not x['draws'] and first-2<=x['time']<first]
dx['baseline_range']=dict(changed_pixels_min=min(x['changed_pixels'] for x in baseline),changed_pixels_max=max(x['changed_pixels'] for x in baseline),max_rgb_difference=max(x['max_rgb_difference'] for x in baseline))
save('projected_pixel_pair_dx12_progress.json',dx)
for name in ['projected_pixel_pair_progress.json','projected_pixel_pair_dx12_progress.json']:
    d=load(name)
    for instance in d['projection_instances']:
        for file in instance['saved_rgba']:
            p=Path(file)
            for candidate in [p]+[p.with_suffix('.'+s+'.png') for s in ['on','off','difference']]:
                d['artifacts_sha256'][str(candidate.relative_to(r))]=hashlib.sha256(candidate.read_bytes()).hexdigest()
    save(name,d)
p=load('projected_pixel_pair_pending.json');p.pop('session_id',None);p.update(updated_utc=now,status='build_and_four_cast_capture_passed_vk_attribution_passed_dx_baseline_failed',vulkan_progress='docs/projected_pixel_pair_progress.json',dx12_progress='docs/projected_pixel_pair_dx12_progress.json');save('projected_pixel_pair_pending.json',p)
next_action='Capturer les écarts de référence entre les deux vues DirectX 12 et en trouver la cause sans relâcher le critère ; poursuivre la fidélité native des projections et tous les 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
    d=load(name);d.update(updated_utc=now,projected_pixel_pair_progress='docs/projected_pixel_pair_progress.json',projected_pixel_pair_dx12_progress='docs/projected_pixel_pair_dx12_progress.json')
    if name=='resume_checkpoint.json':d.pop('pending_projected_pixel_pair',None);d.update(saved_utc=now,next_projected_action=next_action)
    elif name=='completion_plan.json':d['next_execution_steps'][0]=next_action
    elif name=='goal_plan_revision.json':d['next_steps']=[next_action]
    if name!='goal_plan_revision.json':
        target=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
        target.update(annie_projection_reconstructed_vulkan_pixel_attribution_qualified=True,annie_projection_reconstructed_dx12_pixel_attribution_qualified=False,annie_projection_original_pixel_fidelity_qualified=False)
    save(name,d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    s=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,s,flags=re.S),encoding='utf-8')
d=load('completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('completion_plan.json',d)
d=load('goal_plan_revision.json');d['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest();save('goal_plan_revision.json',d)
p=r/'docs/completion_plan.html';p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Pixels de projection — comparaison GPU synchronisée</h2><p>Vulkan : 59 images de référence identiques, contribution de projection isolée sur deux lancements, pics de 68 506 et 68 009 pixels modifiés. DirectX 12 : les 32 images de référence présentent déjà 31 à 161 pixels différents ; attribution stricte non validée. Écarts conservés à analyser, aucune tolérance ajoutée pour faire passer le contrôle. Fidélité au rendu original et tous les domaines restent ouverts.</p><p><a href="projected_pixel_pair_progress.json">Vulkan</a> · <a href="projected_pixel_pair_dx12_progress.json">DirectX 12</a></p></section></body>'),encoding='utf-8')
for n in ['analyze_projected_pixel_pair.py','analyze_projected_pixel_pair_dx12.py','export_projected_pair_figures.py','export_projected_pair_dx12_figures.py','finalize_projected_pixel_pair.py']:
    shutil.copy2(Path('E:/mapslol3v3')/n,r/'tools'/n)
print('Vulkan attribution passed; DX12 baseline failure preserved; no domain complete or pending job')
