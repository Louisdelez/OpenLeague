from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc); stamp=now.isoformat(); log='logs/native-troy-build-up-tests.log'
m=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig')); assert m
receipt='docs/native_troy_build_up_progress.json'
next_action='Integrer le parent native_troy_frame au cycle Projected avec build-up-time natif (Annie: 0), flags config 0x40 et stockage suspendu/reacquis. Qualifier le producteur moteur E8 (frequence) avant de fixer la cadence; puis verifier sortie/reentree camera et captures DX12/Vulkan. Poursuivre le plan complet.'
files=['crates/core/src/native_troy_simulation_flags.rs','data/4.20/troy_build_up_time_contract.json','tools/probe_native_troy_build_up_time.py',log]
p=dict(updated_utc=stamp,passed=True,complete=False,native_reads=81,resources=27,core_focused_tests_passed=int(m[1]),annie_build_up_time=0,observed_values=[0,10],findings=['Original caller919C9D reads System/build-up-time via8B1F50, default0, output config1C0.','Replaces existing field rather than preserving it; three prior bit patterns tested.','Native frame resume uses this value as offset; timing cap applies maximum(value,0.5).'],limits=['Parent binding and native engine E8 rate producer still pending.','No new graphical executable or visual validation.','Numeric JSON adapter supports finite numeric values; other typed representations rejected.'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)
(r/receipt).write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('troy-build-up-'+now.strftime('%Y%m%dT%H%M%SZ')); h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,native_troy_build_up_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Horloge de reprise des effets</h2><p>Lecture native de build-up-time qualifiee sur 27 ressources (81 cas), dont Annie. Integration du cycle parent et verification graphique encore ouvertes.</p><a href="native_troy_build_up_progress.json">Preuves</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
