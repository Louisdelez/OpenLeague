from pathlib import Path
import sys,json,hashlib,datetime,shutil,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
d=json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))
native=Path(d['source']);raw=native.read_bytes();p=pefile.PE(data=raw);image=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
dis=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
code=[]
for label,start,end in [('type7_projected_branch',0x931306,0x931408),('projection_preparation',0x92e130,0x92e3ec),('projected_shader_selection_and_bounds',0x93187e,0x9319b4),('projection_bounds_helper',0x92df10,0x92e130)]:
    b=image[start-base:end-base]
    code.append({'label':label,'start':hex(start),'end_exclusive':hex(end),'bytes_sha256':hashlib.sha256(b).hexdigest(),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in dis.disasm(b,start)]})
proof=json.loads((r/'docs/annie_projection_sources.json').read_text(encoding='utf-8'))
proof['native_discovery']={'source':str(native),'sha256':sha(native),'code':code,'float_constants':[{'address':hex(a),'value':struct.unpack_from('<f',image,a-base)[0],'raw_bits':struct.unpack_from('<I',image,a-base)[0]} for a in [0x1138a68,0x1138df8,0x1138c74,0x1138ba4]],'behavior_emulated':False,'interpretation':'Type7 branch calls92E130. That function builds matrices using negative supplied XZ, an angle multiplied by radians-per-degree, inverse supplied scale*2, and +0.5 translation. Caller fields and complete geometry/FOW/sampler behavior are not qualified by static discovery.'}
proof['updated_utc']=now
proof['client_tests_passed']=40
proof['new_client_checks']=3
proof['test_log']='logs/annie-projection-tests.log'
proof['files_sha256']={name:sha(r/name) for name in ['crates/client/src/projected_surface.rs','crates/client/src/main.rs','logs/annie-projection-tests.log','docs/native_projection_discovery.json']}
proof['external_research']=[{'url':'https://gist.github.com/miyu/e69c6102e9edb5a1025e','kind':'Community texture read/create log, created2015-12-08','result':'No Annie_Fire_Glow or Annie_Q_mis reference found; does not resolve4.20 path precedence.'}]
(r/'docs/annie_projection_sources.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    target=r/'docs'/name;doc=json.loads(target.read_text(encoding='utf-8'))
    if name=='coverage.json':
        doc['current_evidence']['client_tests_passed']=40
        doc['current_evidence']['annie_projection_preparation']={'receipt':'docs/annie_projection_sources.json','native_shader_math_ported':True,'actual_runtime_consumer':False,'glow_candidate_assets_preserved':2,'native_path_precedence_qualified':False,'native_projection_code_discovered':True,'native_projection_behavior_qualified':False}
    elif name=='resume_checkpoint.json':
        doc['saved_utc']=now;doc['last_verified']['client_tests']=40
        doc.setdefault('next_actions',[]).insert(0,'Qualify original92E130 projection matrices/bounds and type7 caller931306 fields; archived static disassembly in docs/annie_projection_sources.json. Then bind actual restored terrain triangles, native FOW and texture sampler. projected_surface.rs ports UV and preserves clipped slopes but is not a live emitter. Preserve both glow candidates until native resolver precedence is established. Full24domain scope remains open.')
    else:
        doc['latest_projection_evidence']={'receipt':'docs/annie_projection_sources.json','client_checks':40,'runtime_projected_complete':False,'full_goal_complete':False}
    target.write_text(json.dumps(doc,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['probe_native_projection.py','record_annie_projection.py']:
    shutil.copyfile(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Recorded native source/code discovery,40client checks; full game and projected consumer remain incomplete.')
