from pathlib import Path
import json, hashlib

root = Path(r'E:\OpenLeague')
field = 'normal_client_shutdown_validation'
archive = root / 'docs/normal_client_shutdown_validation'
receipt_path = root / 'docs/normal_client_shutdown_validation.json'

def read(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

receipt = read(receipt_path)
assert receipt['passed'] and not receipt['complete']
for name, row in receipt['archived_files'].items():
    path = (archive / name).resolve()
    assert path.is_relative_to(archive.resolve())
    assert path.stat().st_size == row['bytes'] and sha(path) == row['sha256'], name
for name, expected in receipt['published_document_sha256'].items():
    assert sha(root / name) == expected, name
backup = Path(receipt['backup'])
assert backup.resolve().is_relative_to((root/'docs/plan_history').resolve())
for name, expected in receipt['original_document_sha256'].items():
    assert sha(backup/Path(name).name) == expected, name
summaries = []
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    before, after = read(backup/name), read(root/'docs'/name)
    summaries.append(after[field])
    assert not after['complete']
    for k in ['loading_rads_native_preparation','loading_provider_crt_preparation',
              'native_champion_loading_assets_import','loading_resource_manager_validation']:
        assert before[k] == after[k], k
    if name == 'resume_checkpoint.json':
        assert after['state'] == 'active'
        assert before['communication_preferences'] == after['communication_preferences']
    if name == 'completion_plan.json':
        assert before['domains'] == after['domains']
        assert len(after['domains']) == 24 and sum(len(d['tasks']) for d in after['domains']) == 114
        assert before['next_execution_steps'][1:] == after['next_execution_steps'][1:]
        assert after['next_execution_steps'][0] == after['next_action']
assert summaries[0] == summaries[1] == summaries[2]
assert sha(root/'target/debug/openleague-client.exe') == receipt['client_executable_sha256']
assert (root/'docs/completion_plan.html').read_text(encoding='utf-8').count('id="normal-client-shutdown-validation"') == 1
print(json.dumps({'verified':True,'receipt_sha256':sha(receipt_path),
    'archived_files':len(receipt['archived_files']),'plan_and_prior_evidence_preserved':True,
    'communication_preference_preserved':True,'goal_checkpoint_active':True}))
