from pathlib import Path
import sys,json,struct,datetime,hashlib,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
p=r/'data/4.20/particle_projection_contract.json';contract=json.loads(p.read_text(encoding='utf-8'))
assert contract['passed'] and len(contract['cases'])==114
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))['source'])
pe=pefile.PE(str(source));image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
defaults={'p-projection-y-range':{'value':struct.unpack_from('<f',image,0x1138f80-base)[0],'native_constant':'0x1138f80','caller':'0x91da6f','destination_offset':'0x1cc'},'p-projection-fading':{'value':struct.unpack_from('<f',image,0x11390e8-base)[0],'native_constant':'0x11390e8','caller':'0x91da90','destination_offset':'0x1d0'}}
default_contract={'values':defaults,'native_sha256':sha(source),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in decoder.disasm(image[0x91da6a-base:0x91dab1-base],0x91da6a)],'qualification':'Native caller supplies these defaults to8B1F50 reader. Full original missing-field reader path and rendering consequences not executed.'}
(r/'data/4.20/particle_projection_defaults.json').write_text(json.dumps(default_contract,indent=2)+'\n',encoding='utf-8')
contract.pop('type7_defaults_static',None)
p.write_text(json.dumps(contract,indent=2)+'\n',encoding='utf-8')
receipt={'updated_utc':now,'complete':False,'client_tests_passed':42,'native_math_cases':114,'rust_finite_oracle_cases_passed':108,'zero_size_renderer_inputs_explicitly_rejected':6,'native_math_adapters':False,'runtime_projected_consumer':False,'gpu_rerun':False,'type7_defaults':defaults,'files_sha256':{n:sha(r/n) for n in ['data/4.20/particle_projection_contract.json','crates/client/src/projected_surface.rs','logs/annie-native-projection-tests.log','tools/qualify_native_particle_projection.py']},'limits':['Native92E130 math prefix and92DF10 bounds qualified; execution stops before original terrain/FOW state and geometry submission.','SIMPLE_PROJECTED c235/c236 UV formula and recovered92E130 matrix producer retained as distinct contracts; actual native binding route still open.','CPU clipped terrain preserves slopes and winding, with exact UV clipping boundaries for stable f32 intersections. Native clipping/sampler/depth policy unqualified.','Type7 defaults recovered from executable caller, not copied from olderDisintegrate_mis. Full missing-field reader and resulting world-height fade behavior remain open.','Caller p-scale/p-local-orient to matrix inputs, animation/bones, texture precedence, lifecycle, FOW and visible GPU consumer remain unfinished.','Full24domain goal and all122champion complete kits remain unachieved.']}
(r/'docs/annie_native_projection_progress.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
    if name=='coverage.json':
        d['current_evidence']['client_tests_passed']=42
        d['current_evidence']['annie_native_projection_math']={'receipt':'docs/annie_native_projection_progress.json','native_cases':114,'rust_oracle_cases':108,'runtime_complete':False}
    elif name=='resume_checkpoint.json':
        d['saved_utc']=now;d['last_verified']['client_tests']=42
        d.setdefault('next_actions',[]).insert(0,'Native92E130 math prefix/92DF10 bounds verified114cases, Rust matrix/bounds matches108finite cases. Connect actual map triangle extraction and UV projection to particle renderer after qualifying caller p-scale/local-orient and original shader binding. Type7 default y-range5/fading200 recovered statically at91DA6F/91DA90; reader and fade behavior still open. Both glow texture candidates preserved, path precedence unresolved. See docs/annie_native_projection_progress.json; continue full24domain goal.')
    else:d['latest_projection_evidence']={'receipt':'docs/annie_native_projection_progress.json','client_checks':42,'native_cases':114,'runtime_projected_complete':False,'full_goal_complete':False}
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/record_native_particle_projection.py')
print('Recorded114native math cases,108Rust oracle cases,42client tests; runtime particle projection incomplete.')
