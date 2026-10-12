from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague'); now=datetime.datetime.now(datetime.timezone.utc); stamp=now.isoformat(); log='logs/native-troy-engine-rate-tests.log'
m=re.search(r'test result: ok\. (\d+) passed; 0 failed;', (r/log).read_text(encoding='utf-8-sig')); assert m
receipt='docs/native_troy_engine_rate_progress.json'
next_action='Raccorder native_troy_frame au cycle Projected: flags0x40, build-up-time0, frequence native fournie par engine_timing_words(reglage explicite). Le reglage global1225888 est alimente a837591 et lu a929523; nom UI et selection locale restent a relier. Verifier sortie/reentree camera, reprises et rendu DX12/Vulkan; poursuivre le plan complet.'
files=['crates/core/src/native_troy_simulation_flags.rs','data/4.20/troy_engine_rate_contract.json','tools/probe_native_troy_engine_rate.py',log]
p=dict(updated_utc=stamp,passed=True,complete=False,native_cases=24,core_focused_tests_passed=int(m[1]),findings=['Original929523 calls92DA90 with global1225888. Settings0/1 yield15Hz,2 yields20Hz,others30Hz.','All six fields E8..FC captured with three initial fills and eight setting values.','Global writer837591 found statically; UI semantic name remains unqualified.'],limits=['Parent runtime binding not complete.','No new graphical executable or acceptance.'],artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},next_action=next_action)
(r/receipt).write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('troy-engine-rate-'+now.strftime('%Y%m%dT%H%M%SZ')); h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 f=r/'docs'/name;shutil.copy2(f,h/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d.update(updated_utc=stamp,native_troy_engine_rate_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
 if name=='completion_plan.json':
  assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
 if name=='goal_plan_revision.json':d['next_steps']=[next_action]
 f.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,h/f.name);f.write_text(f.read_text(encoding='utf-8').replace('</body>','<section><h2>Frequence native des effets</h2><p>Selecteur natif de frequence porte: 15, 20 ou 30 Hz selon le reglage. 24 cas originaux verifies. Integration du cycle parent encore ouverte.</p><a href="native_troy_engine_rate_progress.json">Preuves</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
