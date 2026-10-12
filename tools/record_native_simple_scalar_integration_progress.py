from pathlib import Path
from datetime import datetime, timezone
import json, hashlib, shutil, re
r=Path('E:/OpenLeague'); now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_scalar_integration_progress.json'; log='logs/native-simple-scalar-integration-core-tests.log'
def load(p): return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d): (r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p): return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 550 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_scalar_phase_contract.json')
assert p['passed'] and len(p['cases'])==648 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
files=['data/4.20/simple_scalar_phase_contract.json','tools/probe_native_simple_scalar_phase.py','crates/core/src/native_simple_scalar_phase.rs','crates/core/src/native_scalar_parameter.rs','crates/core/src/native_probability_curve.rs','crates/core/src/native_random.rs','crates/core/src/lib.rs',log]
integration=load('data/4.20/simple_scalar_integration_contract.json')
assert integration['passed'] and len(integration['cases'])==324 and integration['adapters']==[] and integration['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_scalar_integration_contract.json','tools/probe_native_simple_scalar_integration.py','crates/core/src/native_simple_scalar_integration.rs']
scaled=load('data/4.20/simple_scaled_scalar_contract.json')
assert scaled['passed'] and len(scaled['cases'])==324 and scaled['adapters']==[] and scaled['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_scaled_scalar_contract.json','tools/probe_native_simple_scaled_scalar.py']
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Porter la courbe scalaire multipliée9452F1..945466 déjà qualifiée sur324cas, qualifier les appels944540/944C80/9456E0, puis composer âge, rattachement, forces, mouvement et courbes dans944E20 ; qualifier les producteurs, intégrer au cycle93F2F0 et au rendu/audio Map10, reconstruire les applications et poursuivre les24domaines.'
proof=dict(updated_utc=now,complete=False,native_sha256=p['native_sha256'],core_tests_passed=550,simple_scalar_phase_cases=648,simple_scalar_phase_ported=True,complete_simple_update_ported=False,ordinary_emitter_consumer_bound=False,ordinary_applications_rebuilt=False,artifacts_sha256={f:sha(f) for f in files},adapters=p['adapters'],limits=p['limits']+['Malformed resources return explicit errors. Arbitrary nonfinite table/probability values and overflow are unqualified. No complete champion kit or domain.'],findings=['Original945120..94520B executes real RNG8E26A0 and probability91B770 with no endpoint adapters. Rust matches all output words and all55 RNG words and both cursors in648cases.','1485 actual CPU SSE operations and792 actual CPU conversions; zero VM/CPU disagreements.','Definition1C8 enables writes; table1B4/1B8 indexes normalized ages from container20 into output5C. Ordered1>age excludes expired and NaN ages; negative infinity converts to INT_MIN and lower clamp0. Null/constant probability consumes no draws; fast/generic consumes one stored binary32 fraction per active particle.','Selected table lengths1/3/7, null/constant/fast/generic probabilities,0/1/4 particles, three age profiles, three raw RNG states. Remaining integration, producers, rendering/audio and full game qualification incomplete.'],next_action=next_action)
proof.update(simple_scalar_integration_native_cases=324,simple_scalar_integration_ported=True)
proof.update(simple_scaled_scalar_native_cases=324,simple_scaled_scalar_ported=False)
proof['findings'].append('Next phase9452F1..945466 qualified on324 original cases:1254 actual CPU SSE operations and528 conversions, zero VM/CPU differences. One-element table skips output and RNG; other tables evaluate baked/probability scalar then multiply container50 into44. Rust port remains incomplete.')
proof['findings'].append('Rust integration94520B..9452F1 matches324 original cases and2472 actual CPU SSE operations: rate*delta+output for ordered active ages. Counts0/1/3/4/5/7/8/9/17 cover four-particle unrolling and remainder; input ages/rates unchanged.')
save(receipt,proof)
history=r/'docs/plan_history'/('simple-scalar-integration-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
    shutil.copy2(r/'docs'/name,history/name);d=load('docs/'+name)
    d.update(updated_utc=now,native_simple_scalar_integration_progress=receipt)
    if name=='goal_plan_revision.json': d.update(core_tests_passed=550,core_source_tests_passed=550,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
        e.update(core_tests_passed=550,latest_native_execution_progress=receipt,simple_scalar_phase_cases=648,simple_scalar_phase_ported=True,simple_scalar_integration_cases=324,simple_scalar_integration_ported=True,complete_simple_update_ported=False,latest_core_test_log=log)
        if name=='resume_checkpoint.json': e['core_tests']=550;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ('03','10','15') and receipt not in domain.setdefault('progress_evidence',[]): domain['progress_evidence'].append(receipt)
    save('docs/'+name,d)
for path in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
    text=path.read_text(encoding='utf-8').replace('549 tests moteur','550 tests moteur')
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,history/path.name)
text=path.read_text(encoding='utf-8');text=text.replace('</body>','<section id="native-simple-scalar-integration"><h2>Intégration scalaire des particules</h2><p>324 cas natifs correspondent bit pour bit ; lots de quatre particules et restes vérifiés. 550 tests moteur passent. Cycle complet, ressources et rendu restent à qualifier.</p><a href="native_simple_scalar_integration_progress.json">Preuves et limites</a></section></body>');path.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=550,cases=648,complete=False)))
