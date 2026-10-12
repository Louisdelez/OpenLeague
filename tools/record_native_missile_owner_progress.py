from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_effect_owner_progress.json';log='logs/native-missile-effect-owner-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
o=load('data/4.20/missile_effect_owner_orientation_contract.json');b=load('data/4.20/missile_effect_owner_binding_contract.json');assert o['passed'] and b['passed']
next_action='Qualifier la création complète de l’effet missile763410/763950 et le producteur de direction, raccorder le fournisseur10B0D20 à AnnieProjected, puis contrôler scale/alpha/récepteurs terrain et poursuivre les24domaines.'
files=['crates/core/src/native_missile_effect_owner.rs','crates/core/src/lib.rs','data/4.20/missile_effect_owner_orientation_contract.json','data/4.20/missile_effect_owner_binding_contract.json','tools/probe_native_missile_effect_orientation.py','tools/probe_native_missile_owner_binding.py',log]
proof=dict(updated_utc=now,complete=False,native_sha256=o['native_sha256'],native_orientation_cases=24,native_binding_cases=8,actual_cpu_rsqrt_operations=37,focused_core_tests_passed=1,filtered_core_tests=592,full_core_suite_rerun=False,ordinary_projected_binding=False,client_rebuilt=False,artifacts_sha256={p:sha(p) for p in files},findings=['MissileEffect loader768499 stores string at SpellData+5E0; MissileEffectPlayer+5F8 and Enemy+610 selected by763536..7635B2 depending local viewer/context. Selection path remains static evidence.','Creator763950 constructs provider vtable10B0D20 at763BDC with owner from projectile wrapper+4; distinct from spell caster provider10B0E1C.','Provider10B0D20 shares position/direction/status methods with10B0E1C but orientation slotC is719D20, building a basis from direction+6C instead of object matrix+18C0.','24 original orientation cases include alive/expired, cardinal/diagonal/zero/small/near-vertical directions. 37 RSQRTSS operations supplied by physical CPU; Rust bitwise outputs match.','Native6C9BD0 stores shared owner at wrapper+148/+14C, obtains live effect from weak handle+11C/+120 and forwards owner to effect virtual68. Eight executions verify live/expired/absent/new/old owner combinations; virtual body is adapted.'],limits=o['limits']+b['limits']+['No live client changes, GPU/audio rerun or champion/domain completion.','Historical590 full core suite retained; only one focused test run now,592 filtered.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-owner-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_effect_owner_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_owner_orientation_cases=24,native_missile_owner_binding_cases=8,native_missile_owner_focused_tests=1,native_missile_owner_live_bound=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15'] and receipt not in dom.setdefault('progress_evidence',[]):dom['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Pose native du projectile</h2><p>Fournisseur10B0D20 distinct du lanceur identifié. Orientation portée en Rust et comparée bit à bit sur24cas ;37opérations RSQRTSS sur CPU réel. Transmission native du propriétaire contrôlée sur8cas avec consommateur adapté. Un test ciblé passe,592filtrés. Création complète, producteurs et rendu normal restent ouverts.</p><a href="native_missile_effect_owner_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,complete=False,focused_tests=1)))
