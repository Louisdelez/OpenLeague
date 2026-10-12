from pathlib import Path
from datetime import datetime, timezone
import json, hashlib, shutil, re
r=Path('E:/OpenLeague'); now=datetime.now(timezone.utc).isoformat()
receipt='docs/native_simple_particle_update_terrain_progress.json'; log='logs/native-simple-particle-update-terrain-core-tests.log'
def load(p): return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d): (r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p): return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 561 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p=load('data/4.20/simple_scalar_phase_contract.json')
assert p['passed'] and len(p['cases'])==648 and p['adapters']==[] and p['emulator_cpu_case_disagreements']==0
files=['data/4.20/simple_scalar_phase_contract.json','tools/probe_native_simple_scalar_phase.py','crates/core/src/native_simple_scalar_phase.rs','crates/core/src/native_scalar_parameter.rs','crates/core/src/native_probability_curve.rs','crates/core/src/native_random.rs','crates/core/src/lib.rs',log]
integration=load('data/4.20/simple_scalar_integration_contract.json')
assert integration['passed'] and len(integration['cases'])==324 and integration['adapters']==[] and integration['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_scalar_integration_contract.json','tools/probe_native_simple_scalar_integration.py','crates/core/src/native_simple_scalar_integration.rs']
scaled=load('data/4.20/simple_scaled_scalar_contract.json')
assert scaled['passed'] and len(scaled['cases'])==324 and scaled['adapters']==[] and scaled['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_scaled_scalar_contract.json','tools/probe_native_simple_scaled_scalar.py','crates/core/src/native_simple_scaled_scalar.rs']
attribute=load('data/4.20/simple_attribute_policy_contract.json')
assert attribute['passed'] and len(attribute['cases'])==504 and attribute['adapters']==[]
files+=['data/4.20/simple_attribute_policy_contract.json','tools/probe_native_simple_attribute_policy.py','crates/core/src/native_simple_attribute_policy.rs','crates/core/src/native_particle_force_body.rs']
tail=load('data/4.20/simple_particle_tail_contract.json')
assert tail['passed'] and len(tail['cases'])==144 and tail['adapters']==[]
files+=['data/4.20/simple_particle_tail_contract.json','tools/probe_native_simple_particle_tail.py','crates/core/src/native_simple_particle_tail.rs','data/4.20/simple_terrain_follow_contract.json','tools/probe_native_simple_terrain_follow.py','crates/core/src/native_simple_terrain_follow.rs','data/4.20/simple_particle_bounds_contract.json','tools/probe_native_simple_particle_bounds.py']
terrain=load('data/4.20/simple_terrain_follow_contract.json');assert terrain['passed'] and len(terrain['cases'])==720 and terrain['emulator_cpu_case_disagreements']==0
bounds=load('data/4.20/simple_particle_bounds_contract.json');assert bounds['passed'] and len(bounds['cases'])==324 and bounds['adapters']==[] and bounds['emulator_cpu_case_disagreements']==0
files+=['crates/core/src/native_simple_particle_bounds.rs','data/4.20/simple_bounds_policy_contract.json','tools/probe_native_simple_bounds_policy.py','crates/core/src/native_simple_bounds_policy.rs']
policy=load('data/4.20/simple_bounds_policy_contract.json');assert policy['passed'] and len(policy['cases'])==864 and policy['adapters']==[] and policy['emulator_cpu_case_disagreements']==0
attachment=load('data/4.20/simple_attachment_cpu_contract.json');assert attachment['passed'] and len(attachment['cases'])==112 and attachment['adapters']==[] and attachment['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_attachment_cpu_contract.json','tools/probe_native_simple_attachment_cpu.py','crates/core/src/native_simple_attachment.rs','crates/core/src/camera_view.rs','data/4.20/simple_particle_update_contract.json','tools/probe_native_simple_particle_update.py']
update=load('data/4.20/simple_particle_update_contract.json');assert update['passed'] and len(update['cases'])==480 and update['adapters']==[] and update['emulator_cpu_case_disagreements']==0
files+=['crates/core/src/native_simple_particle_update.rs','data/4.20/simple_particle_update_extended_contract.json','tools/probe_native_simple_particle_update_extended.py']
files+=['crates/core/src/'+name+'.rs' for name in ['native_simple_particle_age','native_simple_concrete_forces','native_simple_forces','native_particle_force_graph','native_particle_random_force','native_particle_axis_force','native_simple_movement','native_simple_motion_axis','native_simple_circular_motion']]
extended=load('data/4.20/simple_particle_update_extended_contract.json');assert extended['passed'] and len(extended['cases'])==1152 and extended['adapters']==[]
files+=['data/4.20/simple_particle_update_terrain_contract.json','tools/probe_native_simple_particle_update_terrain.py']
terrain_cycle=load('data/4.20/simple_particle_update_terrain_contract.json');assert terrain_cycle['passed'] and len(terrain_cycle['cases'])==480 and len(terrain_cycle['adapters'])==1 and terrain_cycle['emulator_cpu_case_disagreements']==0
files+=['data/4.20/simple_frame_particles_contract.json','tools/probe_native_simple_frame_particles.py']
frame_particles=load('data/4.20/simple_frame_particles_contract.json');assert frame_particles['passed'] and len(frame_particles['cases'])==384 and frame_particles['adapters']==[] and frame_particles['emulator_cpu_case_disagreements']==0
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Composer9437E0 avec pose et particules réelles et comparer aux384cas natifs de fin de vie ; qualifier émission normale, producteurs de pose et fournisseur réel de hauteur9456E0 ; qualifier les producteurs, intégrer au cycle93F2F0 et au rendu/audio Map10, reconstruire les applications et poursuivre les24domaines.'
proof=dict(updated_utc=now,complete=False,native_sha256=p['native_sha256'],core_tests_passed=561,simple_scalar_phase_cases=648,simple_scalar_phase_ported=True,complete_simple_update_ported=False,ordinary_emitter_consumer_bound=False,ordinary_applications_rebuilt=False,artifacts_sha256={f:sha(f) for f in files},adapters=terrain['adapters'],limits=p['limits']+terrain['limits']+['Malformed resources return explicit errors. Arbitrary nonfinite table/probability values and overflow are unqualified. No complete champion kit or domain.'],findings=['Original945120..94520B executes real RNG8E26A0 and probability91B770 with no endpoint adapters. Rust matches all output words and all55 RNG words and both cursors in648cases.','1485 actual CPU SSE operations and792 actual CPU conversions; zero VM/CPU disagreements.','Definition1C8 enables writes; table1B4/1B8 indexes normalized ages from container20 into output5C. Ordered1>age excludes expired and NaN ages; negative infinity converts to INT_MIN and lower clamp0. Null/constant probability consumes no draws; fast/generic consumes one stored binary32 fraction per active particle.','Selected table lengths1/3/7, null/constant/fast/generic probabilities,0/1/4 particles, three age profiles, three raw RNG states. Remaining integration, producers, rendering/audio and full game qualification incomplete.'],next_action=next_action)
proof.update(simple_scalar_integration_native_cases=324,simple_scalar_integration_ported=True)
proof.update(simple_scaled_scalar_native_cases=324,simple_scaled_scalar_ported=True)
proof['findings'].append('Rust phase9452F1..945466 matches on324 original cases:1254 actual CPU SSE operations and528 conversions, zero VM/CPU differences. One-element table skips output and RNG; other tables evaluate baked/probability scalar then multiply container50 into44. Rust output and all RNG words/cursors match.')
proof['findings'].append('Rust integration94520B..9452F1 matches324 original cases and2472 actual CPU SSE operations: rate*delta+output for ordered active ages. Counts0/1/3/4/5/7/8/9/17 cover four-particle unrolling and remainder; input ages/rates unchanged.')
proof.update(simple_attribute_policy_native_cases=504,simple_attribute_policy_ported=True)
proof.update(simple_particle_tail_native_cases=144,simple_particle_tail_ported=True)
proof['findings'].append('Actual epilogue9455F6..945616 verified on144cases: raw timestamp copied to container4 including signaling NaN and signed zero; containerA4 adds to resource counter24 with unsigned wrap. Supplied caller frame and resource pointers; Rust raw timestamp and wrapping counter match all144cases.')
proof['findings'].append('Whole944540 and actual9442F0/9444B0/9443D0 execute504cases,3456CPU SSE operations.26VM/CPU differences retained and actual hardware used. Mode0 constant multiplier;1 age*multiplier+offset;2 approximate velocity norm*x87 multiplier+offset;3 auxiliary*multiplier+offset; other modes preserve outputs. Rust outputs match all504 CPU cases; input arrays unchanged. Native speed multiplication and offset use actual x87 with saved/restored control word.')
proof.update(simple_terrain_follow_cases=720,simple_terrain_follow_ported=True,simple_terrain_height_provider_qualified=False,simple_particle_bounds_native_cases=324,simple_particle_bounds_ported=True)
proof['findings'].append('Rust9456E0 matches720cases,912CPU SSE operations and ordered X/Z/Y provider arguments. Owner absent, disabled161 or locked160 skips; ordered1>age selects slots; inverse interval uses original double threshold0.001; blend clamps and adjusts Y then previous98. Supplied height endpoint remains explicit and is not native terrain acceptance.')
proof['findings'].append('Next original944C80 bounds body qualified324cases,1764CPU SSE operations, no VM/CPU differences, no endpoints. Radius=container44 scalar*ownerE0; initialize minimaMAX/maxima-MAX; ordered active ages expand bounds. Rust bounds match all324cases including signed extents and empty active sets.')
proof.update(simple_bounds_policy_cases=864,simple_bounds_policy_ported=True)
proof.update(simple_attachment_cpu_cases=112,simple_attachment_core_ported=True)
proof['findings'].append('Actual943300/944600/944760 requalified112 selected profiles with33336 hardware scalar SSE operations, no VM/CPU differences and no adapters. Matrix copy/inverse and bind/local-orient bodies execute; exceptional/packed arithmetic and upstream pose still limited. Core bind and local-orient ports match112 CPU cases each. Full update composition remains incomplete.')
proof['findings'].append('Rust composed9454BF..9455EF matches864 original cases,7416CPU SSE operations: flag and strict(time-last)>threshold1036831949 select actual944C80 refresh; timestamp written before call; otherwise min/max translate by owner center delta. Center always stores owner raw words. No endpoint adapters in this policy proof. Full particle cycle and application consumers incomplete.')
proof.update(simple_particle_update_native_cases=480,complete_simple_update_ported=False)
proof['findings'].append('Whole944E20 executes480cases through return0C with actual selected attachment, linear movement, scalar/probability/attributes, bounds and epilogue.23936CPU scalar SSE and960 conversions, zero VM/CPU differences, no endpoint adapters. Preallocated arrays/poses and null forces, terrain-disabled profiles supplied; Rust composition matches480 whole captures for every output array and call order; broader profiles remain to qualify.')
proof.update(simple_particle_update_composed=True,simple_particle_update_extended_native_cases=1152,simple_particle_update_extended_rust_qualified=True)
proof['findings'].append('Extended whole944E20 executes1152cases with real null/uniform93BDD0 forces, linear/circular motion and three signed-axis policies, constant/fast/generic scalar probabilities sharing55-word RNG.342576CPU SSE operations and10368conversions;414VM/CPU differences retained, hardware reference used. No endpoints; all output arrays, RNG words/cursors and outer call order captured. Rust composition matches all1152 hardware captures in every output array, outer call order,55 RNG words and both cursors.')
proof.update(simple_particle_update_terrain_native_cases=480,simple_particle_update_terrain_rust_qualified=True)
proof['findings'].append('Whole944E20 with terrain enabled measured480cases,26096CPU SSE operations,960conversions, zero VM/CPU differences. Height endpoint explicit; provider X/Z/Y arguments, returned heights and previous98 captured, including early age-prefix skip and locked terrain skip. Rust terrain composition matches480cases including previous heights and provider arguments/order. Real terrain provider remains incomplete.')
proof.update(simple_frame_particles_native_cases=384,simple_frame_particles_rust_qualified=False)
proof['findings'].append('Whole9437E0 executes384 warm-owner end-of-life cases with actual943300 pose and whole944E20 particle body, native final matrix inverse and finish:80672CPU SSE operations,960conversions, zero VM/CPU differences, no endpoint adapters. Owner-end flag10 and strictly expired zero linger suppress emission; animation/helper resources null. All particle and emitter outputs captured. Rust frame composition, normal emission and source producers remain incomplete.')
save(receipt,proof)
history=r/'docs/plan_history'/('simple-particle-update-terrain-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
    shutil.copy2(r/'docs'/name,history/name);d=load('docs/'+name)
    d.update(updated_utc=now,native_simple_particle_update_terrain_progress=receipt)
    if name=='goal_plan_revision.json': d.update(core_tests_passed=561,core_source_tests_passed=561,latest_native_execution_progress=receipt,next_steps=[next_action])
    else:
        d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
        e.update(core_tests_passed=561,latest_native_execution_progress=receipt,simple_scalar_phase_cases=648,simple_scalar_phase_ported=True,simple_scalar_integration_cases=324,simple_scalar_integration_ported=True,simple_scaled_scalar_cases=324,simple_scaled_scalar_ported=True,simple_attribute_policy_cases=504,simple_attribute_policy_ported=True,simple_particle_tail_cases=144,simple_particle_tail_ported=True,simple_terrain_follow_cases=720,simple_terrain_follow_ported=True,simple_terrain_height_provider_qualified=False,simple_particle_bounds_cases=324,simple_particle_bounds_ported=True,simple_bounds_policy_cases=864,simple_bounds_policy_ported=True,simple_attachment_cpu_cases=112,simple_attachment_core_ported=True,simple_particle_update_native_cases=480,simple_particle_update_composed=True,simple_particle_update_extended_native_cases=1152,simple_particle_update_extended_rust_qualified=True,simple_particle_update_terrain_native_cases=480,simple_particle_update_terrain_rust_qualified=True,simple_frame_particles_native_cases=384,simple_frame_particles_rust_qualified=False,complete_simple_update_ported=False,latest_core_test_log=log)
        if name=='resume_checkpoint.json': e['core_tests']=561;d.update(saved_utc=now,next_projected_action=next_action)
        if name=='completion_plan.json':
            d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
            for domain in d['domains']:
                if domain['id'] in ('03','10','15') and receipt not in domain.setdefault('progress_evidence',[]): domain['progress_evidence'].append(receipt)
    save('docs/'+name,d)
for path in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
    text=path.read_text(encoding='utf-8').replace('560 tests moteur','561 tests moteur')
    text=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',text,flags=re.S);path.write_text(text,encoding='utf-8')
d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html';shutil.copy2(path,history/path.name)
text=path.read_text(encoding='utf-8');text=text.replace('</body>','<section id="native-simple-particle-update-terrain"><h2>Cycle complet avec suivi du terrain</h2><p>Le cycle Rust correspond aussi aux 480 cas avec terrain, hauteurs et arguments du fournisseur. Le fournisseur reste contrôlé. 384 cas natifs de mise à jour de l’émetteur avec pose et particules réelles sont mesurés ; composition et émission normale restent à intégrer. 561 tests moteur passent. Cycle complet, ressources et rendu restent à qualifier.</p><a href="native_simple_particle_update_terrain_progress.json">Preuves et limites</a></section></body>');path.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,core_tests=561,cases=480,complete=False)))
