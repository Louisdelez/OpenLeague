"""Prepare only a test correction and preserve the failed full-run evidence."""
from pathlib import Path
import datetime, difflib, hashlib, json, re

D = Path(__file__).resolve().parent
S = D.parent.parent
R = Path('E:/OpenLeague')
REL = 'crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
NAME = 'audio_replay_windows_loading_standard_packet_uses_real_resource_manager_and_retires_normalized_key_on_factory_boundary'
EXPECTED = '1a2a311948cc8e40b93f85992df8e4b6c21a0ff10458ad02de770ca5f877b530'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def dump(p, value): p.write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')

assert sha(R / REL) == sha(S / 'production' / REL) == EXPECTED
source = (R / REL).read_bytes()
log = R / 'logs/core-loading-resource-manager-tests.log'
saved_log = D / 'core-tests-before-cache-fix.log'
if saved_log.exists():
    assert saved_log.read_bytes() == log.read_bytes(), 'preserved log must never be overwritten'
else:
    saved_log.write_bytes(log.read_bytes())
text = saved_log.read_text(encoding='utf-8-sig')
assert re.findall(r'test result: FAILED\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out', text) == [('891','1','0','0','480')]
assert 'left: 73' in text and 'right: 72' in text
assert 'audio_replay_windows_loading_retirement_tests.rs:227:9' in text
full_name = 'audio_replay_windows_transport::loading_packets::tests::' + NAME
assert re.findall(r'^test (\S+) \.\.\. FAILED\s*$', text, re.M) == [full_name]

begin = source.index(('fn ' + NAME + '(').encode())
prefix, body = source[:begin], source[begin:]
assert body.count(b'#[test]') == 0, 'bounded replacement expects this final test only'
def replacement(old, new):
    global body
    old = old.replace('\n', '\r\n').encode();new = new.replace('\n', '\r\n').encode()
    assert body.count(old) == 1, old
    body = body.replace(old, new, 1)

replacement(
    '        let packet_bytes=packet(local,42,1,false);let before=r.snapshot().unwrap().engine_allocations;',
    '''        let packet_bytes=packet(local,42,1,false);
        // Keep the first query cold:728410 may grow its persistent metadata
        // String24, independently of the two loading stack temporaries.
        let cached=parent.metadata[0]+0x1b0;
        assert_eq!([b.word(cached+16).unwrap(),b.word(cached+20).unwrap()],[0,15]);
        let before_owned=r.shared.bank.lock().unwrap().owned.clone();''')
replacement(
    '        assert_eq!(r.snapshot().unwrap().engine_allocations,before);\n        assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(),frees+if name.len()>=16{2}else{0});',
    '''        let capacity=b.word(cached+20).unwrap();
        assert_eq!(b.word(cached+16).unwrap(),name.len() as u32);
        let cached_heap=if name.len()>=16 {
            assert_eq!(capacity,(name.len() as u32)|15);
            let raw=b.word(cached).unwrap();assert!(!before_owned.contains(&raw));Some(raw)
        }else{assert_eq!(capacity,15);None};
        let cached_data=cached_heap.unwrap_or(cached);
        assert_eq!(read_bytes(&mut b,cached_data,name.len() as u32),name);
        assert_eq!(metadata::Boundary::read_byte(&mut b,cached_data+name.len() as u32).unwrap(),0);
        let mut expected_owned=before_owned.clone();
        if let Some(raw)=cached_heap {assert!(expected_owned.insert(raw));}
        // Exactly the cache buffer may persist. No missing old owner, unnamed
        // new allocation or leaked name/key is hidden by an aggregate count.
        assert_eq!(r.shared.bank.lock().unwrap().owned,expected_owned);
        assert_eq!(r.snapshot().unwrap().engine_allocations,expected_owned.len());
        assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(),frees+if name.len()>=16{2}else{0});''')
replacement(
    '        assert_eq!(r.snapshot().unwrap().engine_allocations,before);assert_eq!(r.loading_retirement_snapshot()["pending"],0);',
    '''        assert_eq!(r.shared.bank.lock().unwrap().owned,expected_owned);
        assert_eq!(r.snapshot().unwrap().engine_allocations,expected_owned.len());
        assert_eq!(r.loading_retirement_snapshot()["pending"],0);''')
replacement(
    '        recipient.destroy(&mut b);binding.restore(&mut b);r.close_game_manager().unwrap();service.close().unwrap();',
    '''        if let Some(raw)=cached_heap {
            let bank=r.shared.bank.lock().unwrap();
            assert!(bank.owned.contains(&raw));
            assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),0);
        }
        recipient.destroy(&mut b);binding.restore(&mut b);r.close_game_manager().unwrap();
        // Metadata destruction owns this cached buffer; verify retirement
        // without reading the already destroyed metadata descriptor.
        if let Some(raw)=cached_heap {
            let bank=r.shared.bank.lock().unwrap();
            assert!(!bank.owned.contains(&raw));assert!(bank.memory.word(raw).is_err());
            assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),1);
        }
        service.close().unwrap();''')
candidate = prefix + body
names = lambda data: re.findall(rb'#\[test\]\s*fn\s+(\w+)\s*\(', data)
assert names(source) == names(candidate)
output = D / Path(REL).name
output.write_bytes(candidate)
(D / 'test-only.patch').write_text(''.join(difflib.unified_diff(source.decode().splitlines(True), candidate.decode().splitlines(True), fromfile=REL, tofile=REL)), encoding='utf-8')
guards = {}
for name in ['audio_loading_metadata.rs','audio_replay_metadata.rs','audio_loading_owned_string.rs',
             'audio_replay_windows_loading_retirement.rs','audio_replay_windows_loading_packets.rs']:
    path = R / 'crates/core/src' / name
    guards[name] = {'sha256': sha(path), 'bytes': path.stat().st_size}
decision = {
    'scope': 'one test only; preserve the cold first getter and identify the exact legitimate persistent owner',
    'reason': '728410 assigns the persistent String24 metadata+0x1B0 before copying its temporary output. The first long name allocates its cache buffer; teardown frees it in metadata.destroy_base.',
    'source_path': ['audio_loading_metadata::name -> assign(cached,source)',
                    'audio_loading_screen_packet::receive -> finish_group(key then name)',
                    'audio_replay_metadata::destroy_base -> destroy_string(metadata+0x1B0)'],
    'expected_observation_to_qualify': 'SSO case has identical owned set; long case adds only the pointer stored at metadata+0x1B0. Both stack temporaries retire. The cache pointer survives repeated lookup and is freed exactly once at close_game_manager.',
    'real_runtime_changes': False, 'tests_added': [], 'test_names_unchanged': True,
    'rust_compiled': False, 'rust_tests_executed': False,
    'full_original_startup_order_qualified': False,
    'before_sha256': EXPECTED, 'after_sha256': sha(output),
    'unchanged_source_guards': guards,
    'failed_run': {'pipeline_session':76418,'log':saved_log.name,'sha256':sha(saved_log),
                   'passed':891,'failed':1,'filtered':480,'failed_test':full_name,
                   'client_build_executed':False,'qualification_evidence':False},
}
dump(D / 'decision.json', decision)
print(json.dumps({'candidate_sha256':sha(output),'candidate_bytes':output.stat().st_size,
                  'failed_log_sha256':sha(saved_log),'source_guard_count':len(guards),'rust_tests_executed':False}))
