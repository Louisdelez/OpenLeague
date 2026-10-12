from pathlib import Path
import json,hashlib,datetime,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
contract=json.loads((r/'data/4.20/simple_emission_contract.json').read_text())
assert len(contract['cases'])==96 and contract['adapters']==[]
assert '49 passed; 0 failed' in (r/'logs/simple-emission-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-emission-build.log').read_text()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source'])
pe=pefile.PE(str(source));img=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
code=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(img[0x941f00-base:0x9420b9-base],0x941f00)]
remaining=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(img[0x9420b9-base:0x943340-base],0x9420b9) if '0xd4' in i.op_str or '0xd8' in i.op_str]
receipt=dict(updated_utc=now,complete=False,client_tests_passed=49,native_cases=96,native_instruction_addresses=contract['original_instruction_addresses'],native_sha256=contract['native_sha256'],native_code=code,remaining_latch_time_references=remaining,current_build_gpu_rerun=False,runtime_annie_projected_emitter_bound=False,files_sha256={n:sha(r/n) for n in ['crates/client/src/simple_emission.rs','crates/client/src/main.rs','data/4.20/simple_emission_contract.json','logs/simple-emission-tests.log','logs/simple-emission-build.log','target/debug/openleague-client.exe']},findings=['Single mode gates on prior-emission latch; initial burst is max(1,trunc(effective rate)), not unconditionally one particle. Annie native authored rate1 gives one.','First ordinary emission also raises zero count to1. Subsequent ordinary count truncates elapsed*rate with original cap1-trunc(rate*(-.33)).','Native delay, emitter lifetime exclusion at exact end, periodic active window and original scalar sampler executed without adapters.'],limits=['Native prefix stops before particle birth; supplied constant-rate curve storage is explicit.','Rust gate/count matches96native cases; normal projected emitter remains unbound pending placement/orientation/birth/latch/owner-end qualification.','Current executable built but not visually rerun; earlier GPU diagnostics retain earlier hashes. No full champion or full game completion.'])
(r/'docs/simple_emission_progress.json').write_text(json.dumps(receipt,indent=2)+'\n')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
 if name=='coverage.json':
  d['current_evidence']['client_tests_passed']=49
  d['current_evidence']['native_simple_emission']={'receipt':'docs/simple_emission_progress.json','native_cases':96,'normal_projected_bound':False}
 elif name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=49
  d.setdefault('next_actions',[]).insert(0,'941F00 emission gate/count prefix executed96cases without adapters; Rust matches. Single burst=max(1,trunc(rate)), latch prevents repeat, age>=eLife stops. Qualify original particle birth, latch/time updates, local orientation and owner-end before binding Annie Projected. See docs/simple_emission_progress.json. Entire24domain goal remains incomplete.')
 else:d['latest_projection_evidence']={'receipt':'docs/simple_emission_progress.json','client_checks':49,'native_emission_cases':96,'native_emitter_bound':False,'full_goal_complete':False}
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path('E:/mapslol3v3/record_simple_emission.py'),r/'tools/record_simple_emission.py')
print(json.dumps({'cases':96,'tests':49,'latch_time_references':remaining}))
