"""Byte-verified native animation event clock; no guessed emitter playback."""
from pathlib import Path
import sys, json, struct, hashlib, datetime
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/pythonlibs'))
import pefile, capstone

def sha(data): return hashlib.sha256(data).hexdigest()
def read(name): return json.loads((ROOT / name).read_text(encoding='utf-8-sig'))
def write(name, value):
    (ROOT / name).write_text(json.dumps(value, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
models = read('docs/map_ambient_source_validation.json')['models']
source = Path(models[0]['sources'][0]['path'])
deploy = next(p for p in source.parents if p.name == 'deploy')
exe = deploy / 'League of Legends.exe'
raw = exe.read_bytes()
pe = pefile.PE(data=raw)
assert pe.FILE_HEADER.Machine == 0x14c
base = pe.OPTIONAL_HEADER.ImageBase
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)

def region(address, size):
    offset = pe.get_offset_from_rva(address - base)
    data = raw[offset:offset + size]
    instructions = list(md.disasm(data, address))
    assert sum(i.size for i in instructions) == len(data), hex(address)
    return {'address': hex(address), 'file_offset': offset, 'bytes_sha256': sha(data),
            'instructions': [{'address': hex(i.address), 'bytes': i.bytes.hex(),
                              'mnemonic': i.mnemonic, 'operands': i.op_str} for i in instructions]}

# Fail closed on instruction differences: source bytes establish the arithmetic,
# caller argument, record start comparison and loop flag rather than a heuristic.
expected = {
    0x889134: '8b512c', 0x88913b: '8b4208', 0x88913e: '2b4204',
    0x88914f: 'd84a0c', 0x88915b: 'd8790c', 0x889169: 'dec9',
    0x889190: 'f30f104610', 0x889195: 'f30f594508',
    0x88919a: 'f30f58460c', 0x88919f: 'f30f11460c',
    0x8891a6: 'e885ffffff', 0x8891af: 'd91c24',
    0x8891b2: 'e8a9110000', 0x8891fd: 'e83e100000',
    0x88a453: '8b430c', 0x88a456: 'f30f10400c',
    0x88a45b: '0f2f4508', 0x88a45f: '0f87e1010000',
    0x88a478: 'c7431001000000', 0x88a47f: 'ff5024',
    0x88a4f9: 'd9ee', 0x88a501: '0f82ad000000',
    0x88a510: 'd94508', 0x88a517: '0f8297000000',
    0x88a285: 'f6400801', 0x88a289: '0f84b4000000',
    0x88a292: 'c7431000000000',
}
for address, value in expected.items():
    offset = pe.get_offset_from_rva(address - base)
    assert raw[offset:offset + len(value)//2].hex() == value, hex(address)
regions = [region(0x889130, 77), region(0x889180, 130),
           region(0x88a453, 47), region(0x88a4f0, 45), region(0x88a280, 38)]
now = datetime.datetime.now(datetime.timezone.utc).isoformat()
proof = {'verified_at': now, 'native_executable': str(exe), 'native_executable_sha256': sha(raw),
         'checked_instructions': len(expected), 'regions': regions,
         'qualified': {
             'clock_units': 'floating animation frames',
             'conversion': '(elapsed_seconds / ((frame_end-frame_start)*time_step)) * (frame_end-frame_start)',
             'simplified_conversion': 'elapsed_seconds / time_step for nonzero frame span',
             'elapsed_update': 'elapsed += playback_speed * delta_seconds',
             'start_record_field_offset': 12,
             'start_condition': 'current_frame >= record_start; event state becomes 1; virtual start callback +0x24',
             'end_condition_observed': 'virtual end accessor < 0 skips end; current_frame < end skips end; additional continuation guards follow',
             'loop_reset_mask': 1,
             'loop_reset_condition': 'only records with (flags_raw & 1) != 0 reset state; continuation guards and emitter lifetime not fully qualified',
         },
         'passed': True, 'complete': False,
         'limits': [
             'Clip-node ownership and complete native blend graph selection remain structurally recovered, not fully qualified.',
             'End accessor, continuation flags and virtual emitter callbacks require further source tracing.',
             'Native frame-range endpoint and ANM-to-BLND duration relationship must be qualified before changing GLTF loop periods.',
             'This proves native timing arithmetic; it does not prove particle/audio runtime playback.',
         ]}
write('docs/map_ambient_native_timing_validation.json', proof)

blends = read('docs/map_ambient_blend_records.json')
for node in blends['clip_nodes']:
    b = Path(node['path']).read_bytes()
    assert sha(b) == node['sha256']
    for clip in node['candidate_clip_nodes']:
        assert clip['time_step_raw'] > 0
for event in blends['records']:
    b = Path(event['source_blnd']).read_bytes(); offset = event['record_offset']
    assert struct.unpack_from('<f', b, offset + 12)[0] == event['start_value_raw']
    assert struct.unpack_from('<f', b, offset + 32)[0] == event['end_value_raw']
    event.update({'time_units_qualified': True, 'time_units': 'animation_frames',
                  'timing_evidence': 'docs/map_ambient_native_timing_validation.json',
                  'candidate_start_seconds': event['start_value_raw'] * event['candidate_owner']['time_step_raw'],
                  'candidate_end_seconds': None if event['end_value_raw'] < 0 else event['end_value_raw'] * event['candidate_owner']['time_step_raw'],
                  'loop_reset_eligible': bool(event['flags_raw'] & 1)})
# Existing definitive second fields remain null: candidate ownership is not yet a
# verified mapping from the native blend graph to the selected runtime clip.
blends['verified_at'] = now
blends['limits'] = proof['limits'] + ['Two Chain4-3 attachments are absent from original native skeleton; no alias invented.']
write('docs/map_ambient_blend_records.json', blends)

# Independently expose the exact source ANM header and GLTF sampler extents.
# All current ambient sources are v4 uncompressed: no version guessing allowed.
animations = []
for model in models:
    glb = (ROOT/'assets'/model['asset']).read_bytes()
    assert sha(glb) == model['sha256']
    length = struct.unpack_from('<I', glb, 12)[0]
    gltf = json.loads(glb[20:20+length]); blob = glb[28+length:]
    for s in model['sources']:
        p = Path(s['path'])
        if p.suffix.lower() != '.anm': continue
        b = p.read_bytes(); assert sha(b) == s['sha256']
        assert b[:8] == b'r3d2anmd' and struct.unpack_from('<I', b, 8)[0] == 4
        tracks, frames, step = struct.unpack_from('<IIf', b, 28)
        assert frames > 0 and step > 0 and tracks > 0
        animation = next(a for a in gltf['animations'] if a['name'].lower() == p.stem.lower())
        final_time = 0.0
        for sampler in animation['samplers']:
            accessor = gltf['accessors'][sampler['input']]; view = gltf['bufferViews'][accessor['bufferView']]
            assert accessor['componentType'] == 5126 and accessor['type'] == 'SCALAR'
            start = view.get('byteOffset',0) + accessor.get('byteOffset',0)
            times = struct.unpack_from('<' + 'f'*accessor['count'], blob, start)
            final_time = max(final_time, max(times))
        animations.append({'native_asset': model['native_asset'], 'source': str(p), 'sha256': sha(b),
                           'native_tracks': tracks, 'anm_header_frames': frames,
                           'anm_header_time_step': step, 'last_source_key_seconds': (frames-1)*step,
                           'gltf_last_key_seconds': final_time,
                           'last_key_difference_seconds': (frames-1)*step-final_time,
                           'native_loop_period_qualified': False})
write('docs/map_ambient_animation_endpoint_validation.json', {
    'verified_at': now, 'animations': animations, 'passed': True, 'complete': False,
    'limits': ['ANM header samples and GLTF keys verified; native BLND frame bounds/loop endpoint still require qualification.',
               'Native BLND loop endpoints remain unqualified; restored final source keys are checked separately in map_ambient_endpoint_validation.json.']})
progress = read('docs/map_ambient_event_progress.json')
progress.update({'updated_utc': now, 'native_time_units_qualified': True,
                 'native_timing_checked_instructions': len(expected), 'runtime_enabled': False})
for name in ['docs/map_ambient_native_timing_validation.json','docs/map_ambient_animation_endpoint_validation.json']:
    if name not in progress['source_receipts']: progress['source_receipts'].append(name)
progress['limits'][0] = 'Native frame conversion/start threshold/loop reset mask byte-verified; clip ownership, full continuation/lifetime and audio/particle runtime remain incomplete.'
write('docs/map_ambient_event_progress.json', progress)
coverage = read('docs/coverage.json'); coverage['updated_utc'] = now
coverage['current_evidence']['map_ambient_event_resources'] = progress
for name in progress['source_receipts']:
    if name not in coverage['evidence']: coverage['evidence'].append(name)
write('docs/coverage.json', coverage)
checkpoint = read('docs/resume_checkpoint.json'); checkpoint['saved_utc'] = now
checkpoint['last_verified']['ambient_native_timing_instructions'] = len(expected)
checkpoint['latest_changes'].append('Original executable byte-proves event clock in animation frames, native start threshold and flags&1 loop reset. ANM header/GLTF endpoint discrepancies retained for qualification; no guessed audio/particle playback enabled.')
checkpoint['restart_next'][0] = 'Continue native EventController emitter/end-accessor/continuation qualification from docs/map_ambient_native_timing_validation.json. Qualify native BLND frame bounds against ANM header and GLTF endpoint before changing loop periods. Resolve original Chain4-3 mismatch, Wwise graph probability/gains/spatial semantics and native particle curves; implement and prove actual playback. Preserve all 24 full-game domains.'
write('docs/resume_checkpoint.json', checkpoint)
plan = read('docs/completion_plan.json'); plan['updated_utc'] = now; plan['current_evidence'] = coverage['current_evidence']
write('docs/completion_plan.json', plan)
print('VERIFIED native clock:', len(expected), 'instruction byte checks;', len(blends['records']), 'event frame units;', len(animations), 'ANM/GLTF endpoint audits')
for a in animations:
    print(a['native_asset'], Path(a['source']).stem, 'ANM keys', a['anm_header_frames'], 'source end', a['last_source_key_seconds'], 'GLTF end', a['gltf_last_key_seconds'])

