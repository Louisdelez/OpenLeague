from pathlib import Path
import subprocess,hashlib,json,datetime,copy
r=Path('E:/OpenLeague');local=Path('E:/mapslol3v3')
out=subprocess.check_output([str(local/'rtpc_input_x87_hardware_probe.exe')],text=True)
pairs={int(a,16):int(b,16)for a,b in (line.split(',')for line in out.strip().splitlines())}
assert pairs[0x7f812345]==0x7fc12345 and pairs[0xff812345]==0xffc12345
for bits in [0,0x80000000,0x3f000000,0x7f800000,0xff800000,0x7fc12345,0xffc12345]:assert pairs[bits]==bits
for name in ['rtpc_input_x87_hardware_probe.rs','rtpc_input_x87_hardware_probe.exe']:(r/'tools'/name).write_bytes((local/name).read_bytes())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
proof={'passed':True,'complete':False,'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'operation':'B110A0 input FLD m32fp followed by FSTP m32fp before ADECF0; PC64nearest037f; actual CPU execution on this Windows PC','case_count':len(pairs),'cases':[{'input_bits':a,'output_bits':b}for a,b in pairs.items()],'source':'tools/rtpc_input_x87_hardware_probe.rs','source_sha256':sha(r/'tools/rtpc_input_x87_hardware_probe.rs'),'executable':'tools/rtpc_input_x87_hardware_probe.exe','executable_sha256':sha(r/'tools/rtpc_input_x87_hardware_probe.exe'),'stdout':out,'limits':['Critical FLD/FSTP operations replayed on actual x86_64 CPU, same legacy x87 binary32 load/store operations as original32-bit routine; entire original32-bit game not invoked by this CPU probe.','Unicorn original126-case oracle does not quiet signaling NaNs at this load/store boundary. Preserve original fixture unchanged; corrected boundary arguments explicitly derive from measured CPU mapping, never from the production Rust result. No complete game/audio output claim.']}
(r/'docs/audio_rtpc_input_x87_hardware_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
path=r/'data/4.20/audio_dynamic_input_owner_selector_overrides_preparation.json';p=json.loads(path.read_text(encoding='utf-8'));p['unadjusted_emulator_fixture_sha256']=sha(path);p['hardware_input_conversion_proof']='docs/audio_rtpc_input_x87_hardware_discovery.json';p['hardware_input_conversion_proof_sha256']=sha(r/p['hardware_input_conversion_proof']);count=0
for row in p['cases']:
 row['unadjusted_emulator_calls']=copy.deepcopy(row['calls'])
 for c in row['calls']:
  if c['kind']=='curve'and c['input_bits']in pairs and pairs[c['input_bits']]!=c['input_bits']:c['input_bits']=pairs[c['input_bits']];count+=1
p['hardware_adjusted_curve_arguments']=count;p['limits'].insert(0,'Original emulated126 cases preserved in separate unadjusted fixture. Curve argument signaling-NaN conversion corrected only at measured x87 input FLD/FSTP boundary, using actual CPU nine-case proof. Other calls, all canonical physical banks and selected results unchanged. This is an original-code composition with explicitly documented hardware instruction qualification; not a pure Unicorn byte-for-byte claim for signaling NaNs.')
assert count>0;(r/'data/4.20/audio_dynamic_input_owner_selector_overrides_fp_qualified_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
src=r/'crates/core/src/audio_dynamic_input_owner_selector.rs';s=src.read_text(encoding='utf-8').replace('audio_dynamic_input_owner_selector_matches126_original_owner_global_default_override_collision_sorted_duplicate_keys_signaling_nan_input_x87_publication_and_complete_physical_cases','audio_dynamic_input_owner_selector_matches126_original_owner_global_default_collision_duplicate_keys_signaling_nan_hardware_qualified_x87_arguments_and_complete_physical_cases').replace('data/4.20/audio_dynamic_input_owner_selector_overrides_preparation.json','data/4.20/audio_dynamic_input_owner_selector_overrides_fp_qualified_preparation.json');src.write_text(s,encoding='utf-8')
print('Actual CPU confirms x87 signaling-NaN quieting; preserved unadjusted native fixture;',count,'explicit argument corrections in separate qualified fixture')
