from pathlib import Path
import json,hashlib,datetime,shutil,ast,struct
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_motion_consumer_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
log='logs/annie-native-flight-consumer-tests.log'
assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
seq=load('data/4.20/missile_motion_sequences_contract.json');assert len(seq['sequences'])==48
frames=sum(len(x['frames']) for x in seq['sequences']);assert frames==384
t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct}
exec(compile(ast.Module(body=[x for x in t.body if isinstance(x,ast.FunctionDef) and x.name in ['ini','hashkey']],type_ignores=[]),'parse','exec'),ns)
native=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Annie/Spells/Disintegrate.inibin')
data=ns['ini'](native);fields={k:data[ns['hashkey']('SpellData',k)] for k in ['MissileGravity','MissileSpeed','MissileAccel','MissileMinSpeed','MissileMaxSpeed','MissileTargetHeightAugment','MissileFixedTravelTime','MissileBoneName']}
assert not fields['MissileGravity'] and not fields['MissileAccel'] and not fields['MissileFixedTravelTime']
assert fields['MissileBoneName']=='neck'
for key in ['MissileSpeed','MissileMinSpeed','MissileMaxSpeed']:assert float(fields[key])==1400
assert float(fields['MissileTargetHeightAugment'])==100
next_action='Construire et capturer le client avec déplacement natif d’Annie ; raccorder la direction et la pose propriétaire au rendu, qualifier collisions, cible absente et arrêt, puis poursuivre les24domaines.'
files=['crates/client/src/annie_q_vfx.rs','crates/core/src/native_missile_motion.rs','crates/core/src/native_missile_position_sync.rs','data/4.20/missile_motion_sequences_contract.json',log]
proof=dict(updated_utc=now,complete=False,focused_client_tests_passed=1,native_sequences=48,native_frames=384,full_client_suite_rerun=False,graphical_client_rebuilt=False,current_runtime_capture=False,source_fields=fields,original_inibin_path=str(native),original_inibin_sha256=hashlib.sha256(native.read_bytes()).hexdigest(),artifacts_sha256={p:sha(p) for p in files},findings=['Ordinary Annie visual flight consumer now advances native units using75F130 profile, then native7631C0/7648C0 position sync; reconstructed vertical interpolation removed.','Client consumer matches all384original moving-target frames in raw f32 words for position,direction and stored target.','Original Disintegrate INIBIN confirms zero gravity/acceleration/fixedtime,speed1400,min=max,targetheight100,neck.'],limits=['Test binary compiled; ordinary graphical executable not rebuilt or captured by this receipt.','Actual bone global transform, native launch offset/caller order, local frame clock, missing target lifecycle and server disappearance remain to qualify.','Target absence still skips ordinary update; fallback is verified in helper but not routed from the live consumer.','Identity projection orientation remains; particle rendering/factors/collisions and server lifecycle remain incomplete.','Zero completed domains; all24domains114tasks retained.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-native-motion-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_motion_consumer_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,annie_native_motion_consumer_frames=384,annie_native_motion_consumer_focused_tests=1)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Déplacement natif du projectile d’Annie</h2><p>Consommateur client raccordé au déplacement natif :384étapes comparées. Un test ciblé passe ; exécutable graphique et captures à reconstruire. Orientation, collisions et arrêt restent ouverts.</p><a href="annie_native_motion_consumer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
