from pathlib import Path
import json,hashlib,datetime,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
contract=json.loads((r/'data/4.20/simple_emitter_defaults_contract.json').read_text(encoding='utf-8'))
assert contract['passed'] and len(contract['cases'])==3
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))['source'])
pe=pefile.PE(str(source));image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
native_readers=[]
for label,start,end in [('single_particle',0x91e06b,0x91e093),('local_orientation',0x91e5c6,0x91e636),('bind_weight_pair',0x91eb67,0x91ebac),('retained_simple_group_after_loading',0x9191b8,0x919242)]:
    native_readers.append({'label':label,'start':hex(start),'end_exclusive':hex(end),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in decoder.disasm(image[start-base:end-base],start)]})
proof={'updated_utc':now,'complete':False,'client_tests_passed':48,'new_client_checks':2,'original_simple_initializer_cases':3,'native_defaults_initializer_instructions':contract['original_instruction_addresses'],'native_source_sha256':sha(source),'native_reader_code':native_readers,'simple_group_declared':'Annie_Q_mis System GroupPart4Type=Simple','runtime_annie_projected_emitter_bound':False,'current_build_gpu_rerun':False,'files_sha256':{n:sha(r/n) for n in ['data/4.20/simple_emitter_defaults_contract.json','data/4.20/particles/annie/Annie_Q_mis.json','crates/client/src/simple_projected_config.rs','crates/client/src/main.rs','logs/simple-projected-config-tests.log','tools/references/reyengine/VfxParticleSimulator.cs','tools/references/reyengine/VfxPlaybackSim.cs','tools/references/reyengine/manifest.json']},'community_source':{'commit':'66c9837f93ac359b13d5e915c9078310ed2d2c93','url':'https://github.com/TheKillerey/ReyEngine/blob/66c9837f93ac359b13d5e915c9078310ed2d2c93/src/ReyEngine.Rendering/Vfx/VfxParticleSimulator.cs','finding':'IsSingleParticle emits one particle under BurstDone; source explicitly says single-particle first-emission timing is held for game evidence. No native4.20 binding/lifecycle proof obtained.'},'limits':['Original91C0C0 defaults initializer executed on valid empty vector/string storage; allocation/free and stack-cookie adapters only. Full surrounding constructor and reader are not executed.','Defaults single-particle0, bind-weight pair[0,0], scale-bias[1,1], simpleorient0 verified across3prior scalar states. Q authors single-particle1 and local-orient1, which must remain distinct from defaults.','Strict Simple/type7 config loader preserves scalar p-scale500 and authored lifetimes2/1; rejects unsupported complex/vector/missing-orientation input explicitly. Parser does not activate an emitter.','Pair second-component semantics, original single-particle emission/attachment/end policy and local orientation remain unqualified. Zero bind weight alone does not prove a stationary effect.','Prior visible GPU projection remains an explicit diagnostic with its own executable SHA. No new visible Q projection or full champion/game completion claimed.']}
(r/'docs/simple_projected_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8'))
    if name=='coverage.json':
        d['current_evidence']['client_tests_passed']=48
        d['current_evidence']['simple_projected_native_configuration']={'receipt':'docs/simple_projected_progress.json','native_initializer_cases':3,'native_emitter_bound':False}
    elif name=='resume_checkpoint.json':
        d['saved_utc']=now;d['last_verified']['client_tests']=48
        d.setdefault('next_actions',[]).insert(0,'Native Projected group explicitly Simple.91C0C0 default initializer executed3cases: single0,bind[0,0],scaleBias[1,1],simpleorient0. Strict config parser authored Qscale500/life2/eLife1/single1/localOrient1. Native reader/group retention excerpts archived; community simulator burst timing is explicitly unverified. Qualify original single-particle actual spawn/attachment/end policy and local-orient before normal Q binding. Do not infer static or following projection from bind0alone. Full24domain goal remains open. See docs/simple_projected_progress.json.')
    else:d['latest_projection_evidence']={'receipt':'docs/simple_projected_progress.json','client_checks':48,'native_defaults_cases':3,'native_emitter_bound':False,'full_goal_complete':False}
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['record_simple_projected.py','probe_native_simple_defaults.py']:
    shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Recorded3native initializer cases and48client checks; native projected emitter lifecycle remains open.')
