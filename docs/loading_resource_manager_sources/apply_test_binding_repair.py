"""Prepare or install exactly one `mut` test binding; never execute tests."""
import datetime, hashlib, json, re, sys
from pathlib import Path
from apply_metadata_cache_repair import S, R, P, REL, sha, load, inside, replace

D = S / 'review/test_binding_repair'
MANIFEST = S / 'test_binding_repair.json'
OLD = (b'            let bank=r.shared.bank.lock().unwrap();\r\n'
       b'            assert!(!bank.owned.contains(&raw));assert!(bank.memory.word(raw).is_err());')
NEW = OLD.replace(b'let bank=', b'let mut bank=', 1)
PARENTS = ['assembled.json','installed.json','review/index_read_repair/repair_manifest.json',
           'index_repair_installed.json','test_order_repair.json','test_order_repair_installed.json',
           'metadata_cache_repair.json','metadata_cache_repair_installed.json']

def prepare():
    D.mkdir(parents=True, exist_ok=True)
    parent = load(S / 'metadata_cache_repair.json')['files'][REL]
    original = (R / REL).read_bytes()
    assert sha(R / REL) == sha(P / REL) == parent['after_sha256']
    assert original.count(OLD) == 1
    candidate = D / Path(REL).name;candidate.write_bytes(original.replace(OLD, NEW, 1))
    log = R / 'logs/core-loading-resource-manager-cache-exact-test.log'
    saved = D / 'compile-error-before-mut.log'
    if saved.exists(): assert saved.read_bytes() == log.read_bytes()
    else: saved.write_bytes(log.read_bytes())
    text = saved.read_text(encoding='utf-8-sig')
    assert text.count('error[E0596]') == 1 and 'test result:' not in text and 'running 1 test' not in text
    assert 'audio_replay_windows_loading_retirement_tests.rs:284:57' in text
    decision = {'before_hex': OLD.hex(), 'after_hex': NEW.hex(), 'reason': 'Memory::word requires mutable self in the post-close absence assertion.',
                'tests_executed':False,'compiler_failed':True,'pipeline_session':89703,'runtime_changed':False}
    (D / 'decision.json').write_text(json.dumps(decision,indent=2)+'\n',encoding='utf-8')
    proofs = [candidate,saved,D/'decision.json',Path(__file__),S/'apply_metadata_cache_repair.py']
    manifest = {'schema':1,'complete':False,'parents':{name:sha(S/name) for name in PARENTS},
      'files':{REL:{'before_sha256':parent['after_sha256'],'after_sha256':sha(candidate),'bytes':candidate.stat().st_size,'candidate':candidate.relative_to(S).as_posix()}},
      'added_tests':[],'proof_files':{p.relative_to(S).as_posix():{'bytes':p.stat().st_size,'sha256':sha(p)} for p in proofs},
      'compiler_failure':{'log':saved.relative_to(S).as_posix(),'sha256':sha(saved),'error':'E0596','pipeline_session':89703,'tests_executed':False,'qualification_evidence':False},
      'runtime_changed':False,'candidate_compiled':False}
    MANIFEST.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'manifest_sha256':sha(MANIFEST),'candidate_sha256':sha(candidate),'tests_executed':False}))

def install(expected_sha):
    assert re.fullmatch('[0-9a-f]{64}',expected_sha) and sha(MANIFEST)==expected_sha
    m=load(MANIFEST)
    assert m['schema']==1 and m['complete'] is False and m['runtime_changed'] is False
    assert set(m['parents'])==set(PARENTS)
    for name,digest in m['parents'].items():assert sha(inside(S,name))==digest
    assert set(m['files'])=={REL} and m['added_tests']==[]
    row=m['files'][REL];parent=load(S/'metadata_cache_repair.json')['files'][REL]
    assert row['before_sha256']==parent['after_sha256']
    expected={rel:row['after'] for rel,row in load(S/'installed.json')['files'].items()}
    for name in ['review/index_read_repair/repair_manifest.json','test_order_repair.json','metadata_cache_repair.json']:
        expected.update({rel:row['after_sha256'] for rel,row in load(S/name)['files'].items()})
    assert len(expected)==26 and {p.relative_to(P).as_posix() for p in P.rglob('*') if p.is_file()}==set(expected)
    for rel,digest in expected.items():assert sha(inside(R,rel))==sha(inside(P,rel))==digest
    for name,proof in m['proof_files'].items():
        p=inside(S,name);assert p.stat().st_size==proof['bytes'] and sha(p)==proof['sha256']
    candidate=inside(S,row['candidate']);original=(R/REL).read_bytes()
    assert original.count(OLD)==1 and candidate.read_bytes()==original.replace(OLD,NEW,1)
    assert candidate.stat().st_size==row['bytes'] and sha(candidate)==row['after_sha256']
    checkpoint=R/'docs/resume_checkpoint.json';state=load(checkpoint)
    assert state['in_progress']['metadata_cache_repair']['sha256']==m['parents']['metadata_cache_repair.json']
    now=datetime.datetime.now(datetime.timezone.utc)
    backup=R/'docs/plan_history'/('resource-test-binding-repair-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
    state['in_progress']['test_binding_repair']={'manifest':str(MANIFEST),'sha256':expected_sha,'backup':str(backup),'tests_pending':True}
    receipt={'installed_utc':now.isoformat(),'manifest':str(MANIFEST),'manifest_sha256':expected_sha,'backup':str(backup),'files':m['files'],'tests_pending':True}
    payloads={R/REL:candidate.read_bytes(),P/REL:candidate.read_bytes(),
      checkpoint:(json.dumps(state,ensure_ascii=False,indent=2)+'\n').encode(),
      S/'test_binding_repair_installed.json':(json.dumps(receipt,indent=2)+'\n').encode()}
    originals={p:p.read_bytes() if p.exists() else None for p in payloads}
    for p,data in originals.items():
        if data is None:continue
        root,label=(R,'installed') if p.resolve().is_relative_to(R.resolve()) else (P,'staged') if p.resolve().is_relative_to(P.resolve()) else (S,'scratch')
        dest=backup/label/p.relative_to(root);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data);assert dest.read_bytes()==data
    (backup/'repair_manifest.json').write_bytes(MANIFEST.read_bytes());assert sha(backup/'repair_manifest.json')==expected_sha
    published=[]
    try:
        for p,data in payloads.items():
            assert (p.read_bytes() if p.exists() else None)==originals[p];published.append(p);replace(p,data)
    except BaseException as primary:
        errors=[]
        for p in reversed(published):
            try:
                if originals[p] is None:p.unlink(missing_ok=True)
                else:replace(p,originals[p])
            except BaseException as error:errors.append(error)
        if errors:raise BaseExceptionGroup('Test binding repair rollback failed',[primary,*errors])
        raise
    print(json.dumps({'test_binding_repair_installed':True,'tests_pending':True,'backup':str(backup)}))

if __name__=='__main__':
    assert __debug__ and len(sys.argv)==2
    if sys.argv[1]=='--prepare':prepare()
    else:install(sys.argv[1])
