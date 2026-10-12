from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
ROOT=Path(__file__).resolve().parent
def evidence(p):
 data=p.read_bytes();return {'path':str(p),'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
proof=json.loads((ROOT/'replay_loading_record_tree_probe.json').read_text());assert proof['passed']
assert proof['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
log=(ROOT/'test_tree.log').read_text(encoding='utf-8-sig');assert 'test result: ok. 3 passed; 0 failed;' in log
seen=set(proof['executed_instruction_addresses'])
branches={name:address for name,address in [('standard_left_rotation_case',0x5db315),('standard_inline_right_rotation',0x5db335),('standard_red_uncle',0x5db386),('standard_right_rotation_case',0x5db3a0),('standard_inline_left_rotation',0x5db3bf),('tutorial_left_rotation_case',0x5db5ec),('tutorial_inline_right_rotation',0x5db60c),('tutorial_red_uncle',0x5db65d),('tutorial_right_rotation_case',0x5db677),('tutorial_inline_left_rotation',0x5db696),('external_left_rotation',0x5c64e0),('external_right_rotation',0x5c6540),('predecessor',0x5ccfe0),('successor',0x5c23e0),('standard_unhinted',0x5db440),('tutorial_unhinted',0x5db710),('standard_duplicate_free',0x5db521),('tutorial_duplicate_free',0x5db7ee)]}
assert set(branches.values())<=seen
snapshots=[s for c in proof['cases'] for s in [c['initial'],c['before_destroy'],c['destroyed']]+[x['snapshot'] for x in c['steps']]]
coverage={'native_instruction_addresses':len(seen),'lifetimes':len(proof['cases']),'record_calls':sum(len(c['steps']) for c in proof['cases']),'ordered_byte_writes':sum(len(s['writes']) for s in snapshots),'branches':[{'name':k,'address':v,'executed':v in seen} for k,v in branches.items()]}
assert (coverage['lifetimes'],coverage['record_calls'],coverage['ordered_byte_writes'])==(48,480,60140)
(ROOT/'coverage_summary.json').write_text(json.dumps(coverage,indent=2)+'\n')
inputs=re.findall(r'#\[path="(E:/[^\"]+)"\]',(ROOT/'loading_record_tree_harness.rs').read_text())
files=['audio_loading_record_tree.rs','audio_loading_record_tree_tests.rs','build_module.py','probe_loading_record_tree.py','replay_loading_record_tree_probe.json','loading_record_tree_sources.json','loading_record_tree_disassembly.txt','native_result.json','native_probe.log','loading_record_tree_harness.rs','loading_record_tree_tests.exe','compile_tree_final.log','test_tree.log','QUALIFICATION.md','coverage_summary.json','record_qualification.py']
receipt={'schema':'openleague-loading-record-tree-native-rust-qualification-v1','recorded_utc':datetime.now(timezone.utc).isoformat(),'native_sha256':proof['native_sha256'],'native_passed':True,'rust_tests_run':True,'rust_test_functions_passed':3,'production_integrated_by_this_agent':False,'cargo_run':False,'coverage':coverage,'runtime_regions':[{'address':0x14c758b,'bytes':1,'role':'tutorial_construction_byte'}],'source_regions':32,'files':[evidence(ROOT/n) for n in files],'diagnostic_history':[evidence(ROOT/'compile_tree.log')],'production_dependencies':[evidence(Path(p)) for p in inputs],'helper_template_source':evidence(Path('E:/OpenLeague/crates/core/src/audio_replay_metadata_state.rs')),'limits':proof['limits']}
(ROOT/'qualification_manifest.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(evidence(ROOT/'qualification_manifest.json')))
