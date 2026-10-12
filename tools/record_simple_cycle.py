from pathlib import Path
import json,datetime,hashlib,shutil,sys,html
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
c=json.loads((r/'data/4.20/simple_cycle_contract.json').read_text())
assert c['passed'] and c['runtime_adapters']==[] and len(c['frames'])==9
assert c['birth_calls']==[[10.,2.]] and c['frames'][-1]['emitter_finished']==1
assert '52 passed; 0 failed' in (r/'logs/simple-cycle-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-cycle-build.log').read_text()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
code=[]
for label,start,stop in [('age_and_count_producer',0x944e20,0x944ef9),('end_frame_pose_and_finished',0x943ada,0x943b56),('container_update_epilogue',0x9455ef,0x945617)]:
 code.append(dict(label=label,instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(img[start-base:stop-base],start)]))
proof=dict(updated_utc=now,complete=False,client_tests_passed=52,native_frames=9,native_runtime_instruction_addresses=c['original_instruction_addresses'],native_sha256=c['native_sha256'],native_code=code,runtime_annie_projected_emitter_bound=False,current_build_gpu_rerun=False,files_sha256={n:sha(r/n) for n in ['data/4.20/simple_cycle_contract.json','crates/client/src/simple_cycle.rs','crates/client/src/main.rs','logs/simple-cycle-tests.log','logs/simple-cycle-build.log','target/debug/openleague-client.exe']},findings=['Full original9437E0 frame update executed9frames: one birth, actual moving/rotating emitter following, normalized age0..1.0625, active count1then0and finished flag1at exact particle lifetime2.','First zero-delta frame does not compute active count; native threshold abs(delta)>f32bits953267991.','End-frame943ADA copies current emitter matrix and inverse into saved previous-frame pose. This is refreshed every frame, not a fixed birth inverse.','Rust constant-life zero-velocity single-particle sequence matches all native frames. Native particle slots remain allocated after expiration; inactive and emitter-finished states are separate from physical array freeing.'],limits=c['limits']+['Rust supports positive finite lifetime cap only; original owner-end zero-cap behavior remains to qualify.','Current native fixture supplies the system pose directly. Original bone/missile producer and early owner disappearance remain unqualified.','No current GPU rerun or live normal Q Projected activation; full24domain objective remains incomplete.'])
(r/'docs/simple_cycle_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
old_domain_state=next(x for x in json.loads((r/'docs/completion_plan.json').read_text(encoding='utf-8'))['domains'] if x['id']=='15')['current_state']
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 path=r/'docs'/name;d=json.loads(path.read_text(encoding='utf-8'))
 if name=='coverage.json':
  d['current_evidence']['client_tests_passed']=52;d['current_evidence']['current_build_receipt']='docs/simple_cycle_progress.json'
  d['current_evidence']['native_simple_cycle']={'receipt':'docs/simple_cycle_progress.json','native_frames':9,'runtime_adapters':0,'normal_projected_bound':False}
 elif name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=52
  for executable in d.get('executables',[]):
   file=r/executable['path']
   if file.is_file():executable['sha256']=sha(file);executable['bytes']=file.stat().st_size
  d.setdefault('next_actions',[]).insert(0,'Native9437E0 full frame cycle executed9frames/2159instruction addresses without runtime adapters; initializer heap adapters only. One birth at10, pLife2, follows moving/yaw pose, expires at12; slots stay allocated. Native943ADA refreshes previous pose/inverse everyframe: not fixed birth inverse. Rust constant-life zero-velocity sequence matches. Next qualify owner-end flag0x10, p-linger life-cap0and pose/bone producer, then normal Projected binding/GPU validation. See docs/simple_cycle_progress.json. Full24domain goal remains open.')
 else:
  d['updated_utc']=now;d['current_evidence']['client_tests_passed']=52;d['current_evidence']['current_build_receipt']='docs/simple_cycle_progress.json'
  d['progress_summary']['client_tests_last_recorded']=52
  d['latest_projection_evidence']={'receipt':'docs/simple_cycle_progress.json','client_checks':52,'native_frames':9,'native_emitter_bound':False,'full_goal_complete':False}
  domain=next(x for x in d['domains'] if x['id']=='15')
  domain['progress_evidence']=list(dict.fromkeys(domain['progress_evidence']+['docs/simple_cycle_progress.json']))
  domain['current_state']+=' Cycle natif complet vérifié sur 9 frames, expiration à 2 secondes et matrice précédente rafraîchie chaque frame ; disparition anticipée du propriétaire encore à qualifier.'
  task=next(t for t in domain['tasks'] if t['id']=='15.1');task['evidence']=list(dict.fromkeys(task['evidence']+['docs/simple_cycle_progress.json']))
 path.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
page=r/'docs/completion_plan.html';s=page.read_text(encoding='utf-8').replace('51 tests client enregistrés','52 tests client enregistrés').replace(html.escape(old_domain_state),html.escape(domain['current_state']))
page.write_text(s,encoding='utf-8')
receipt_path=r/'docs/plan_update_receipt.json';receipt=json.loads(receipt_path.read_text(encoding='utf-8'))
receipt['files_sha256']={n:sha(r/'docs'/n) for n in ['completion_plan.json','completion_plan.html','goal_objective.txt']}
receipt['latest_evidence_update_utc']=now;receipt_path.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
for name in ['probe_native_simple_cycle.py','record_simple_cycle.py']:shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Recorded9complete native frame updates and52client tests; previous-frame inverse semantics corrected; early owner-end pending.')
