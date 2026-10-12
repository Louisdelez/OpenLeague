import datetime, hashlib, json, re, shutil
from pathlib import Path

root = Path('E:/OpenLeague')
def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path, value):
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    load(temporary)
    temporary.replace(path)

now = datetime.datetime.now(datetime.timezone.utc)
log = root / 'logs/audio-announcer-registered-formatter-regression.log'
log_text = log.read_text(encoding='utf-8-sig')
match = re.search(r'test result: ok\. (\d+) passed; 0 failed; 0 ignored; 0 measured; (\d+) filtered out', log_text)
assert match and int(match[1]) == 625 and int(match[2]) == 480
small = root / 'logs/announcer-registered-formatter-production-tests.log'
assert '54 passed; 0 failed' in small.read_text(encoding='utf-8-sig')
plan = load(root / 'docs/completion_plan.json')
scope = {'domains': len(plan['domains']), 'tasks': sum(len(d['tasks']) for d in plan['domains']), 'additional_requirements': sum(len(d['additional_requirements']) for d in plan['domains'])}
assert scope == {'domains': 24, 'tasks': 114, 'additional_requirements': 37}
contracts = {}
for name, count in [('audio_announcer_whole_wrapper_contract.json', 4752), ('audio_announcer_long_prefix_contract.json', 16)]:
    path = root / 'data/4.20' / name
    data = load(path)
    assert data['passed'] and len(data['cases']) == count
    contracts[name] = {'cases': count, 'sha256': sha(path)}
references = load(root / 'docs/audio_test_fixture_loading.json')['references']
for reference in references:
    path = root / reference['fixture']
    assert path.stat().st_size == reference['bytes'] and sha(path) == reference['sha256']
sources = ['crates/core/src/audio_announcer_actor_wrapper.rs', 'crates/core/src/audio_announcer_ordered_formatter.rs', 'crates/core/src/audio_announcer_object_lookup.rs', 'tools/announcer_registered_formatter_production_tests.rs']
executable_match = re.search(r'Running unittests .*?\(([^)]+\.exe)\)', log_text)
assert executable_match
test_executable = root / executable_match[1].replace('\\', '/')
receipt = {
    'saved_utc': now.isoformat(), 'passed': True, 'complete': False, 'scope': scope,
    'audio_tests_passed': 625, 'filtered_tests_not_run': 480, 'isolated_production_tests_passed': 54,
    'native_whole_wrapper_cases_ported': 4752, 'native_long_prefix_cases_ported': 16,
    'contracts': contracts, 'historical_fixture_references_verified': len(references),
    'source_hashes': {name: sha(root / name) for name in sources},
    'regression_log_sha256': sha(log), 'isolated_log_sha256': sha(small),
    'test_executable': str(test_executable), 'test_executable_sha256': sha(test_executable),
    'behavior': ['Actor lookup precedes input scan. Only a missing ID produces Unknown; registry errors remain typed errors.', 'Raw bytes, first-NUL termination and unbounded native prefix scan preserved.', 'Initialized registry lookup connects to all 30 plain and 23 localized ordered formatter families with shared caches.'],
    'limits': ['Initialized registry snapshots qualify lookup and composition; live initialization, mutation, locking, callback registration and ownership remain incomplete.', 'Native primitive boundaries in composed fixtures retain their documented adapters and independent contracts.', 'Normal announcement queue, priorities, mixing and actual in-game playback remain incomplete. This milestone does not prove complete audio or complete gameplay.'],
    'next_action': 'Qualify actual outer formatter callback registration and form selection, then live registry661410 initialization/mutation/locking and actor/metadata/cache ownership. Connect normal announcement queue/priorities/admission/mixing and actual in-game playback. Complete physical stream/string/facet/locale ownership, external tied streams, exception masks and throwing/terminating handlers. Preserve all24domains114tasks37requirements.'
}
backup = root / 'docs/plan_history' / ('announcer-registered-formatter-' + now.strftime('%Y%m%dT%H%M%SZ'))
backup.mkdir(parents=True)
for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json', 'completion_plan.html']:
    shutil.copy2(root / 'docs' / name, backup / name)
coverage = load(root / 'docs/coverage.json')
checkpoint = load(root / 'docs/resume_checkpoint.json')
for document in [coverage, checkpoint, plan]:
    document['announcer_registered_formatter_validation'] = receipt
checkpoint['saved_utc'] = now.isoformat()
checkpoint['next_action'] = receipt['next_action']
plan['updated_utc'] = now.isoformat()
plan['next_action'] = receipt['next_action']
plan['complete'] = False
write(root / 'docs/announcer_registered_formatter_validation.json', receipt)
write(root / 'docs/coverage.json', coverage)
write(root / 'docs/resume_checkpoint.json', checkpoint)
write(root / 'docs/completion_plan.json', plan)
page = root / 'docs/completion_plan.html'
markup = page.read_text(encoding='utf-8')
section = '<section id="announcer-registered-formatter-validation"><h2>Annonces : raccordement des identifiants aux messages</h2><p>Registre initialise, wrappers et formatage complet integres : 4752 appels natifs et 16 prefixes longs compares. 54 tests isoles et 625 tests audio passes. Recherche avant lecture, transport des octets et erreurs explicites preserves. Enregistrement dynamique, gestion du registre vivant, file audio et lecture en partie restent a terminer.</p></section>'
assert '</body>' in markup and 'id="announcer-registered-formatter-validation"' not in markup
temporary = page.with_suffix('.html.tmp')
temporary.write_text(markup.replace('</body>', section + '</body>'), encoding='utf-8')
temporary.replace(page)
shutil.copy2(Path(__file__), root / 'tools/record_announcer_registered_formatter.py')
print(json.dumps({'audio_tests': 625, 'isolated_tests': 54, 'scope': scope, 'complete': False}))
