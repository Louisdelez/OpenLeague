from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
c=json.loads((r/'data/4.20/simple_birth_contract.json').read_text())
assert c['passed'] and len(c['cases'])==48 and c['adapters']==[]
assert '50 passed; 0 failed' in (r/'logs/simple-birth-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-birth-build.log').read_text()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
proof=dict(updated_utc=now,complete=False,client_tests_passed=50,native_birth_cases=48,native_emission_cases=96,native_instruction_addresses=c['original_instruction_addresses'],native_sha256=c['native_sha256'],runtime_annie_projected_emitter_bound=False,current_build_gpu_rerun=False,files_sha256={n:sha(r/n) for n in ['data/4.20/simple_birth_contract.json','crates/client/src/simple_emission.rs','logs/simple-birth-tests.log','logs/simple-birth-build.log','target/debug/openleague-client.exe']},findings=['Original941F00 runs through return, including943CD0 particle array insertion and native RNG, without adapters.','48cases cover one/two particle bursts, three supplied matrices, translated emitter positions, nonzero local offsets and two particle lifetimes.','Native arrays store actual birth times, lifetimes, positions and velocities; emitter time updates to10.125 and burst latch becomes1. Repeated call produces no additional births or array changes.','Rust birth interpolation and matrix application match all48native array cases.'],limits=c['limits']+['Native matrix producer/local-orient, owner attachment, particle update and owner destruction remain unqualified. Zero-fixture velocity does not qualify moving-particle behavior.','No live Q projection or current executable GPU rerun. Full24domain objective remains incomplete.'])
(r/'docs/simple_birth_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
 if name=='coverage.json':
  d['current_evidence']['client_tests_passed']=50
  d['current_evidence']['native_simple_birth']={'receipt':'docs/simple_birth_progress.json','native_cases':48,'native_adapters':0,'normal_projected_bound':False}
 elif name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=50
  d.setdefault('next_actions',[]).insert(0,'Native941F00 completed through943CD0 particle insertion and return48cases without adapters; supplied valid preallocated arrays, constant curves, matrices and RNG seed. Stored birth/life/position/velocity and latch/time verified; second call no births. Rust birth matrix/interpolation matches. Next qualify943300 matrix producer/local-orient/owner attachment and particle end before normal Annie Projected binding. See docs/simple_birth_progress.json. Entire24domain goal incomplete.')
 else:d['latest_projection_evidence']={'receipt':'docs/simple_birth_progress.json','client_checks':50,'native_birth_cases':48,'native_emitter_bound':False,'full_goal_complete':False}
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['probe_native_simple_birth.py','record_simple_birth.py']:shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Recorded48native particle insertion cases,50client tests and executable hash. Normal projected emitter binding pending.')
