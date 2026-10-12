from pathlib import Path
import hashlib
import json

HERE=Path(__file__).resolve().parent
ROOT=Path('E:/OpenLeague')
OLD=HERE.parent/'process_clock_client_probe/main_probe.rs.txt'

def record(path):
    path=Path(path)
    raw=path.read_bytes()
    return {'path':str(path),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}

old=record(OLD)
assert old['sha256']=='3369c5bc4000a179374ec2cec1ae9e5430ef1d69335d97aff8991f99f54d1a75'
old_text=OLD.read_text(encoding='utf-8')
start='#[cfg(windows)]\nfn native_process_clock_probe(root: &std::path::Path) {'
baseline=old_text[old_text.index(start):].strip()
main=(ROOT/'crates/client/src/main.rs').read_text(encoding='utf-8')
assert baseline==main[main.index(start):].strip(), 'Production function drifted from frozen probe'
log_path=ROOT/'logs/client-process-clock-clock.json'
log=json.loads(log_path.read_text(encoding='utf-8-sig'))
assert log['passed'] is False and log['complete'] is False
assert log['exercise_error'] is None and log['exercise']['frame_updates']==7
assert log['exercise']['paused_frames']==4 and log['closed']['process_clock']['qpc_calls']==33
assert log['closed']['process_clock']['qpf_calls']==1 and log['closed']['application']['closed'] is True
assert log['cleanup_errors']==['runtime cleanup: runtime retained allocations, workers, handles or critical sections']
assert log['retired_runtime'] is None
new=(HERE/'main_probe.rs.txt').read_text(encoding='utf-8')
assert new.index('drop(app);')<new.index('drop(source);')<new.index('let shared_drop =')
assert '.raw_clock_sample(' not in new[new.index('drop(app);'):]
assert '.wall_clock_f32_bits(' not in new[new.index('drop(app);'):]
assert 'state.critical_sections == 1' in new
assert 'report_owners == 3' in new and 'report_owners != 1' in new
assert int('2d6ed58',16)==47639896
manifest={
    'kind':'process_clock_probe_shared_scope_retirement_fix',
    'complete':False,'production_integrated':False,'rust_compiled':False,
    'rust_tests_run':False,'client_executed_for_fix':False,
    'old_failed_log_used_as_diagnostic_only':True,
    'failed_log_did_not_report_intermediate_section_count':True,
    'expected_retained_sections_from_source':1,
    'expected_report_owners_before_shared_drop':3,
    'expected_report_owners_after_shared_drop':1,
    'direct_os_deletion_count_observed':False,
    'old_probe_unchanged':old,
    'diagnostic_log':record(log_path),
    'sources':[record(ROOT/name) for name in [
        'crates/client/src/main.rs','crates/client/src/native_effect_clock.rs',
        'crates/client/src/native_replay_service.rs',
        'crates/core/src/audio_replay_transport_startup.rs',
        'crates/core/src/audio_replay_windows_transport.rs',
        'crates/core/src/audio_replay_windows_clock.rs',
        'crates/core/src/audio_replay_windows_service.rs',
        'crates/core/src/audio_replay_windows_application.rs',
        'crates/core/src/audio_crt_windows_critical_sections.rs',
    ]],
    'artifacts':[record(HERE/name) for name in ['main_probe.rs.txt','README.md','record_preparation.py']],
}
destination=HERE/'manifest.json'
destination.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':record(destination),'probe':record(HERE/'main_probe.rs.txt'),
                  'rust_compiled':False,'client_executed_for_fix':False}))
