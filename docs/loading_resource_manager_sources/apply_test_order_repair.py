"""Install the exact test-only order correction with a separate receipt."""
from pathlib import Path
import datetime, json, sys
from apply_index_repair import S,R,P,sha,load,replace

assert __debug__ and len(sys.argv)==2
path=S/'test_order_repair.json'
assert sha(path)==sys.argv[1]=='b17f1699ebb35154690809891d34090f828706223b30787f4dfafb8ba3c74c86'
repair=load(path)
installed=load(S/'installed.json')
index=load(S/'review/index_read_repair/repair_manifest.json')
assert repair['assembled_sha256']==sha(S/'assembled.json')==installed['assembled_sha256']
assert repair['installed_sha256']==sha(S/'installed.json')
assert repair['index_repair_manifest_sha256']==sha(S/'review/index_read_repair/repair_manifest.json')
assert repair['index_repair_installed_sha256']==sha(S/'index_repair_installed.json')
expected={rel:row['after'] for rel,row in installed['files'].items()}
expected.update({rel:row['after_sha256'] for rel,row in index['files'].items()})
for relative,digest in expected.items():
    assert sha(R/relative)==sha(P/relative)==digest,relative
relative='crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
assert set(repair['files'])=={relative} and repair['added_tests']==[]
row=repair['files'][relative]
candidate=S/row['candidate']
assert candidate.resolve().is_relative_to(S.resolve())
assert row['before_sha256']==expected[relative]
assert sha(candidate)==row['after_sha256'] and candidate.stat().st_size==row['bytes']
decision=load(S/'review/test_order_repair/decision.json')
old=bytes.fromhex(decision['byte_replacement']['before_hex'])
new=bytes.fromhex(decision['byte_replacement']['after_hex'])
assert (R/relative).read_bytes().count(old)==1
assert candidate.read_bytes()==(R/relative).read_bytes().replace(old,new)
for filename,digest in decision['source_guards'].items():
    assert sha(R/'crates/core/src'/filename)==digest
for filename,proof in repair['proof_files'].items():
    p=S/filename
    assert p.resolve().is_relative_to(S.resolve())
    assert p.stat().st_size==proof['bytes'] and sha(p)==proof['sha256']
now=datetime.datetime.now(datetime.timezone.utc)
backup=R/'docs/plan_history'/('resource-test-order-repair-'+now.strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True)
checkpoint=R/'docs/resume_checkpoint.json'
state=load(checkpoint)
assert state['in_progress']['assembled_sha256']==repair['assembled_sha256']
state['in_progress']['test_order_repair']={'manifest':str(path),'sha256':sys.argv[1],'backup':str(backup),'tests_pending':True}
payloads={R/relative:candidate.read_bytes(),P/relative:candidate.read_bytes(),checkpoint:(json.dumps(state,ensure_ascii=False,indent=2)+'\n').encode('utf-8')}
originals={p:p.read_bytes() for p in payloads}
for p,data in originals.items():
    root,label=(R,'installed') if p.resolve().is_relative_to(R.resolve()) else (P,'staged')
    dest=backup/label/p.relative_to(root)
    dest.parent.mkdir(parents=True,exist_ok=True)
    dest.write_bytes(data)
    assert dest.read_bytes()==data
(backup/'repair_manifest.json').write_bytes(path.read_bytes())
published=[]
try:
    for p,data in payloads.items():
        assert p.read_bytes()==originals[p]
        published.append(p)
        replace(p,data)
except BaseException as primary:
    errors=[]
    for p in reversed(published):
        try:replace(p,originals[p])
        except BaseException as error:errors.append(error)
    if errors:raise BaseExceptionGroup('Test order repair failed; rollback needs recovery',[primary,*errors])
    raise
receipt={'installed_utc':now.isoformat(),'manifest':str(path),'manifest_sha256':sys.argv[1],'backup':str(backup),'files':repair['files'],'tests_pending':True}
replace(S/'test_order_repair_installed.json',(json.dumps(receipt,indent=2)+'\n').encode('utf-8'))
print(json.dumps({'test_order_repair_installed':True,'backup':str(backup),'tests_pending':True}))
