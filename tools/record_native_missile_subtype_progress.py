from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_subtype_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_subtype_dispatch_contract.json');b=load('data/4.20/missile_direction_recalculation_contract.json');assert a['passed'] and b['passed'] and len(a['cases'])==8 and len(b['cases'])==144
next_action='Qualifier le déplacement complet et la mise à jour de cible du SpellMissileClient d’Annie (7631A0/7631D0), puis raccorder sa pose native10B0D20 au rendu, contrôler scale/alpha/récepteurs terrain et poursuivre les24domaines.'
files=['data/4.20/missile_subtype_dispatch_contract.json','data/4.20/missile_direction_recalculation_contract.json','tools/probe_native_missile_subtype_dispatch.py','tools/probe_native_missile_direction_recalculation.py']
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],dispatch_cases=8,direction_recalculation_cases=144,actual_cpu_rsqrt_operations=278,artifacts_sha256={p:sha(p) for p in files},findings=['Original Annie Disintegrate.inibin confirms CastType=1 and Annie_Q_mis.troy.','Native7617F8 dispatch selects760610 for type1;760610 creates descriptor2D62BC4 registered as SpellMissileClient. Factory7600E0 invokes763010, which sets vtable10B2B5C; virtualE0=75FB00.','VirtualE4=75FD40 tail-jumps virtualE0;144cases via original class vtable match initial direction/time raw words. Rust direction implementation unchanged; prior focused test retained, no new Cargo run claimed.','Generic owner type2D6DA00 registered as obj_BarracksDampener: inhibitor status branch, not missile identity.'],limits=['Direction callback is qualified; full frame movement, target refresh and lifecycle callers remain unqualified.','Factory/class chain is static original-byte evidence; full allocation/creation pipeline not executed here.','No client rebuild, live binding, GPU/audio or full-suite qualification.','24domains114tasks retained; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-subtype-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_subtype_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_subtype_cases=8,native_missile_direction_recalculation_cases=144,native_annie_missile_subtype='SpellMissileClient',native_missile_owner_live_bound=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15'] and receipt not in dom.setdefault('progress_evidence',[]):dom['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():
  s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>CastType1 confirmé dans le INIBIN original ; sélection SpellMissileClient qualifiée sur8branches. Recalcul de direction via sa table virtuelle comparé sur144cas,278RSQRTSS CPU. Déplacement complet, cible mobile et rendu normal restent ouverts.</p><a href="native_missile_subtype_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,dispatch_cases=8,recalculation_cases=144,complete=False)))
