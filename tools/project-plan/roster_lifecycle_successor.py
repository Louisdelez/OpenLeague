"""Explicit evidence-only successor for one analytical roster unknown lifecycle.

Does not call or patch legacy.audit, does not substitute open status, and writes
nothing. The actual unknown document is evaluated separately from source facts.
"""
import datetime
import json
import pathlib
import re
import sys

ROOT=pathlib.Path(r'F:\OpenLeague')
sys.path.insert(0,str(ROOT/'tools/project-plan'))
import audit_content_classification_reference as legacy

PROOF=pathlib.Path(r'F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision251_identity_comparison_unknown_review\IDENTITY_COMPARISON_UNKNOWN_REVIEW.json')
PROOF_BYTES=63214
PROOF_SHA='510982f6676a012fe228a0dcb148cb3bd29da82a0bf38e394621baf5807c817d'
COMPARISON_PATH='tools/project-plan/audit_content_classification_reference.py'
COMPARISON_SHA='045420d74d08796d2e0a9a925762a3124de4f9a553db6f9a04684ff7f3c5f20a'
COMPARISON_SOURCE_ID='OLS-4bf47231-db1d-5640-a2bf-cd673f14dd3a'
TARGET='SYS-01.3-01'
IDENTITIES={
 'SYS-01.3-01':('OLU-62a2cad5-8fe3-54e4-afb7-a84ca99183e6','OLF-f09e69fc-50e8-5e95-b6c2-eeda4203f1f8'),
 'SYS-01.3-02':('OLU-a9b1c2f1-bf04-5bfc-b4d9-98eac6555eff','OLF-b41ca1ed-9152-58e5-8d52-85fe3b522ce2'),
 'SYS-01.3-03':('OLU-90a7cde0-6c8c-5f90-b769-130661412d6e','OLF-8206dc5c-7957-50e2-8a24-c9627166e84d'),
 'SYS-01.3-04':('OLU-b8d5c132-0ac1-5138-abb5-ec75c6f81b8a','OLF-fe729378-dd70-51cc-a604-2187f23f8792'),
 'SYS-01.3-05':('OLU-ba5151eb-6169-58a1-8193-542cb2146608','OLF-8959154c-d2ad-551d-92c1-e24fda6542b9'),
 'SYS-01.3-06':('OLU-27c9c84a-e2c9-5739-bbeb-8923c8770c36','OLF-3672b112-e71c-57f9-bdf3-9790b631b70f'),
}
SCOPE='analytical_roster_identity_comparison_only'

def require(ok, message):
    if not ok:
        raise ValueError(message)

def identity(path):
    return legacy.pin(path)

def proof_document():
    p=identity(PROOF)
    require(p['bytes']==PROOF_BYTES and p['sha256']==PROOF_SHA,'Qualification proof identity changed')
    d=legacy.load(PROOF)
    uid,rid=IDENTITIES[TARGET]
    require(d['passed_within_scope'] is True,'Qualification proof not passed')
    require(d['proposal']['decision']=='resolve','Qualification proof does not propose resolution')
    require((d['proposal']['unknown_id'],d['proposal']['task_id'],d['proposal']['requirement_id'])==(uid,TARGET,rid),'Qualification proof identity mismatch')
    require(d['fresh_direct_comparison']['joined_count']==122 and d['fresh_direct_comparison']['refusals']==12,'Qualification comparison proof incomplete')
    require(all(d[k] is False for k in ('human_acceptance','gameplay_accepted','full_scope','goal_complete')),'Qualification scope promoted')
    return d

def validate_lifecycle(unknown_document, root=ROOT):
    root=pathlib.Path(root)
    rows=unknown_document.get('unknowns')
    require(isinstance(rows,list),'Unknown collection required')
    ids=[u.get('unknown_id') for u in rows]
    require(len(ids)==len(set(ids)),'Duplicate unknown identity')
    index={u['unknown_id']:u for u in rows}
    proof=proof_document()
    target=None
    for task,(uid,rid) in IDENTITIES.items():
        require(uid in index,'Unknown missing '+task)
        u=index[uid]
        require(u.get('task_id')==task,'Unknown task mismatch '+task)
        require(u.get('requirement_id')==rid,'Unknown requirement mismatch '+task)
        if task!=TARGET:
            require(u.get('status')=='open','Other content unknown must remain open '+task)
        else:
            target=u
    require(target['question']==proof['unknown']['question'] and target['resolution_condition']==proof['unknown']['resolution_condition'],'Target question or condition changed')
    status=target.get('status')
    require(status in ('open','resolved'),'Unsupported target lifecycle status')
    uid,rid=IDENTITIES[TARGET]
    if status=='resolved':
        e=target.get('resolution_evidence')
        require(isinstance(e,dict) and bool(e),'Resolved unknown requires resolution evidence')
        require(e.get('schema')=='openleague_roster_comparison_resolution/v1','Resolution evidence schema required')
        require(e.get('unknown_id')==uid,'Resolution evidence unknown mismatch')
        require(e.get('task_id')==TARGET,'Resolution evidence task mismatch')
        require(e.get('requirement_id')==rid,'Resolution evidence requirement mismatch')
        require(e.get('source_contract')==str(PROOF),'Resolution evidence path mismatch')
        require(e.get('source_contract_sha256')==PROOF_SHA,'Resolution evidence SHA mismatch')
        require(e.get('source_contract_bytes')==PROOF_BYTES,'Resolution evidence byte count mismatch')
        require(e.get('scope')==SCOPE,'Resolution evidence scope mismatch')
        c=e.get('consumer')
        require(isinstance(c,dict),'Resolution comparison consumer required')
        require(c.get('pathrel')==COMPARISON_PATH and c.get('function')=='compare_roster' and c.get('line')==25 and c.get('needle')=='def compare_roster(official,local,native):','Resolution comparison consumer anchor mismatch')
        require(c.get('source_id')==COMPARISON_SOURCE_ID,'Resolution comparison consumer source mismatch')
        actual=identity(root/COMPARISON_PATH)
        require(c.get('sourcepin')==actual and actual['sha256']==COMPARISON_SHA,'Resolution comparison consumer identity mismatch')
        history=target.get('resolution_history')
        prior=proof['unknown'].get('resolution_history',[])
        require(isinstance(history,list) and len(history)==len(prior)+1 and history[:-1]==prior,'Resolved unknown requires append-only resolution history')
        last=history[-1]
        require(last.get('from')=='open' and last.get('to')=='resolved','Resolution history transition mismatch')
        require(last.get('unknown_id')==uid,'Resolution history unknown mismatch')
        require(last.get('task_id')==TARGET,'Resolution history task mismatch')
        require(last.get('requirement_id')==rid,'Resolution history requirement mismatch')
        require(last.get('source_contract_sha256')==PROOF_SHA,'Resolution history evidence mismatch')
        require(isinstance(last.get('reason'),str) and bool(last['reason'].strip()),'Resolution history reason required')
        try:
            stamp=datetime.datetime.fromisoformat(last['utc'])
            valid=stamp.tzinfo is not None and stamp.utcoffset()==datetime.timedelta(0)
        except (ValueError,TypeError,KeyError):
            valid=False
        require(valid,'Resolution history UTC required')
    return {
        'target_unknown_id':uid,'task_id':TARGET,'requirement_id':rid,
        'target_status_observed':status,'target_resolved_qualified':status=='resolved',
        'other_five_content_unknowns_observed_open':True,
        'source_qualification':identity(PROOF),'scope':SCOPE,
    }

def revalidate(document, unknown_document, root=ROOT):
    root=pathlib.Path(root)
    actual=identity(root/COMPARISON_PATH)
    require(actual['sha256']==COMPARISON_SHA,'Pinned comparison module changed')
    require(document.get('schema')=='openleague_content_classification_links/v1' and document.get('passed') is True,'Classification schema/status')
    for k in ('full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified'):
        require(document.get(k) is False,'Unsupported classification scope '+k)
    # Only the existing source/data collector is reused. legacy.audit is not called.
    facts,pins=legacy.collect(root)
    require(document['facts']==facts,'Classification facts changed')
    require(document['source_identities']==pins,'Classification source identities changed')
    require(document['checks']==facts['source_checks'] and document['checks_count']==len(facts['source_checks']),'Classification source check census')
    require([a['task_id'] for a in document['associations']]==list(IDENTITIES),'Classification task census')
    for association in document['associations']:
        task=association['task_id']
        require(association['anchors']==[legacy.anchor(root,task,i,s) for i,s in enumerate(legacy.SPECS[task])],'Classification anchors '+task)
        require(association['native_bindings']==legacy.bindings(facts,task),'Classification native roles '+task)
        require((association['finding'],association['remaining'])==legacy.FINDINGS[task],'Classification claim '+task)
        require(association['entry_boundary_only']==(task in legacy.BOUNDARIES) and association['full_task_scope_complete'] is False,'Classification association scope '+task)
        require(association['existing_unknown_id']==IDENTITIES[task][0],'Classification unknown binding '+task)
    # Fresh execution of the real analytical consumer on actual pinned inputs.
    f=facts['roster']
    official=legacy.load(f['official_source']['path'])
    local=legacy.load(f['local_source']['path'])
    txt=pathlib.Path(f['native_source']['path']).read_text(encoding='utf-8')
    native=[dict(index=int(i),id=int(j),code=name) for i,j,name in re.findall(r'champions\[(\d+)\] = createChampion\((\d+),"([^"]+)"',txt)]
    require(native==f['native_rows'],'Current AIR export rows changed')
    joined=legacy.compare_roster(official,local,native)
    require(joined==f['joined'] and len(joined)==122,'Current analytical comparison changed')
    lifecycle=validate_lifecycle(unknown_document,root)
    return {
        'schema':'openleague_roster_lifecycle_successor_revalidation/v1',
        'verified':True,'source_checks':len(facts['source_checks']),'source_pins':len(pins),
        'joined_rows':len(joined),'analytical_comparison_executed':True,
        'lifecycle':lifecycle,
        'legacy_audit_called':False,'legacy_modules_patched':False,
        'unknown_status_substituted':False,
        'fresh_execution':{'Python_source_comparison':True,'Rust':False,'AIR':False,'native_client':False,'game':False},
        'inherited_Rust_test_receipt_verified':True,
        'registry_database_product_mutated':False,
        'gameplay_accepted':False,'full_scope':False,'goal_complete':False,
    }

if __name__=='__main__':
    import argparse
    ap=argparse.ArgumentParser()
    ap.add_argument('--root',default=str(ROOT))
    ap.add_argument('--receipt',default=str(ROOT/'docs/reference_content_classification_sources/content_classification-links.json'))
    ap.add_argument('--unknowns',default=str(ROOT/'docs/fidelity_unknowns_4_20.json'))
    args=ap.parse_args()
    print(json.dumps(revalidate(legacy.load(args.receipt),legacy.load(args.unknowns),args.root),ensure_ascii=False))
