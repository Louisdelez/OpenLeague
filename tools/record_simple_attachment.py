from pathlib import Path
import json,hashlib,datetime,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
c=json.loads((r/'data/4.20/simple_attachment_contract.json').read_text())
assert c['passed'] and len(c['cases'])==112 and c['adapters']==[]
assert '51 passed; 0 failed' in (r/'logs/simple-attachment-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-attachment-build.log').read_text()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source'])
p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
code=[]
for label,start,stop in [('emitter_local_reader',0x91e51e,0x91e58e),('locked_follow_reader',0x91eb67,0x91ebd5),('emitter_matrix_producer',0x943300,0x9433ea),('bind_consumer',0x944600,0x944755),('local_orientation_consumer',0x944760,0x9448b9)]:
 code.append(dict(label=label,instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(img[start-base:stop-base],start)]))
proof=dict(updated_utc=now,complete=False,client_tests_passed=51,native_attachment_cases=112,native_instruction_addresses=c['original_instruction_addresses'],native_sha256=c['native_sha256'],native_code=code,native_reader_keys={hex(a):img[a-base:].split(b'\0',1)[0].decode() for a in [0x10d7474,0x10d83e0,0x10d7a64]},runtime_annie_projected_emitter_bound=False,current_build_gpu_rerun=False,files_sha256={n:sha(r/n) for n in ['data/4.20/simple_attachment_contract.json','data/4.20/simple_update_order_discovery.json','data/4.20/simple_emitter_defaults_contract.json','crates/client/src/simple_attachment.rs','crates/client/src/simple_projected_config.rs','crates/client/src/main.rs','logs/simple-attachment-tests.log','logs/simple-attachment-build.log','target/debug/openleague-client.exe']},findings=['Original943300 captures first emitter matrix and inverse once, updates current matrix/position on subsequent calls. Default e-local-orient1 verified in91C0C0 across3seeded flags.','Original944600 applies bind pair or p-lockedtoemitter; original944760 independently applies current*initialInverse to active particles when p-local-orient1. Bind0does not disable local-orient following.','112cases cover two emitter modes, two particle orientation modes,7bind pairs,2system matrices,locked0/1 and8normalized age boundaries. Rust consumers match native results.','Native91C0C0 defaults locked0/followTerrain0 verified; strict config reads these fields and rejects unqualified terrain-follow mode.','Static call discovery:9438B5 matrix producer precedes9438D5 emission;944EDF bind precedes944EE6 local-orient. Surrounding control flow/age producer not yet executed.'],limits=c['limits']+['Original native owner/bone pose producer and complete particle update/end policy remain open; prepared consumers are not normal Annie Projected activation.','No current executable visual rerun, no full champion or full24domain completion.'])
(r/'docs/simple_attachment_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 path=r/'docs'/name;d=json.loads(path.read_text(encoding='utf-8'))
 if name=='coverage.json':
  d['current_evidence']['client_tests_passed']=51
  d['current_evidence']['native_simple_attachment']={'receipt':'docs/simple_attachment_progress.json','native_cases':112,'normal_projected_bound':False}
 elif name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=51
  d.setdefault('next_actions',[]).insert(0,'Native943300 emitter matrix/capture/inverse,944600 bind/locked,944760 local-orient executed112cases without adapters. Rust matches. Qlocal1 follows pose evenbind0. Verified initializer e-local1/locked0/followTerrain0. Static9438B5 before9438D5 emission;944EDF bind before944EE6local. Next qualify surrounding update normalized-age producer near944EA7 and owner-end policy/upstream bone pose before normal Projected. See docs/simple_attachment_progress.json. Full24domains open.')
 else:d['latest_projection_evidence']={'receipt':'docs/simple_attachment_progress.json','client_checks':51,'native_attachment_cases':112,'native_emitter_bound':False,'full_goal_complete':False}
 path.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['record_simple_attachment.py','discover_simple_update_order.py','discover_simple_orientation.py']:shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Recorded112native attachment cases,51client tests, native reader keys, static update calls and build SHA.')
