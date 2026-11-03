"""Select exact reference payloads,keeping this policy distinct from mounted runtime priority."""
import argparse, collections, hashlib, json, pathlib
from rads_reference_membership import RadsReferenceMembership

def identity(path):
    p=pathlib.Path(path); b=p.read_bytes()
    return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest(),'md5':hashlib.md5(b).hexdigest()}

def exact_recoveries(root,verifier):
    meta_path=pathlib.Path(root)/'data/4.20/recovered_client_assets.json'
    meta=json.loads(meta_path.read_bytes()); result={}
    if meta['artifact']!='recovered_native_client_payloads' or meta['game_version']!='4.20':raise ValueError('Recovered metadata scope differs.')
    for entry in meta['files']:
        logical=entry['relative_path']; key=logical.casefold(); p=pathlib.Path(entry['path'])
        if key in result:raise ValueError('Ambiguous recovered resource.')
        row=verifier.inspect(logical,p,entry)
        if row['status']!='matches_selected_project_manifest' or len(row['matching_members'])!=1:
            raise ValueError('Recovered payload does not match one selected project member.')
        backing=identity(entry['source_path'])
        if any(backing[k]!=row['observed'][k] for k in ['bytes','sha256','md5']):raise ValueError('Recovery backing differs.')
        member=row['matching_members'][0]
        if member['project']!='lol_game_client' or member['project_release']!='0.0.1.7' or member['release']!=entry['version']:
            raise ValueError('Recovery project/member release differs.')
        result[key]={'logical_path':logical,'selected':row['observed'],'manifest_member':member,'recovery_record':entry,'backing':backing}
    if len(result)!=11:raise ValueError('Exactly eleven retained recoveries expected.')
    return meta_path,result

def select_reference(row,recovered):
    if row['status']=='exact_selected_payload':
        actual=row['observed']
        if actual['bytes']!=row['bytes'] or actual['md5']!=row['md5']:raise ValueError('False exact loose classification.')
        return {'path':actual['path'],'bytes':actual['bytes'],'sha256':actual['sha256'],'md5':actual['md5'],'origin':'observed_unpacked_exact_member'}
    alternative=recovered.get(row['member_path'].casefold())
    if alternative is None:raise ValueError('No exact recovered reference for '+row['member_path'])
    actual=alternative['selected']
    if actual['bytes']!=row['bytes'] or actual['md5']!=row['md5'] or alternative['manifest_member']['release']!=row['release']:
        raise ValueError('Recovered reference differs from requested member.')
    return {**actual,'origin':'separately_recovered_exact_member'}

def audit(root,audit_path):
    root=pathlib.Path(root); verifier=RadsReferenceMembership(root)
    raw=json.loads(pathlib.Path(audit_path).read_bytes())
    core=next(x for x in verifier.manifests if x['project']=='lol_game_client')
    if raw['manifest']['sha256']!=core['identity']['sha256'] or raw['member_count']!=70286:
        raise ValueError('Whole-member audit identity or count differs.')
    meta_path,recovered=exact_recoveries(root,verifier)
    selected=[]; names=set()
    for row in raw['members']:
        key=row['member_path'].casefold()
        if key in names:raise ValueError('Duplicate audit member.')
        names.add(key)
        expected=[x for x in verifier.by_key[key] if x['project']=='lol_game_client']
        if len(expected)!=1 or any(expected[0][k]!=row[k] for k in ['release','bytes','md5']):raise ValueError('Audit row differs from selected manifest.')
        source=select_reference(row,recovered)
        if pathlib.Path(source['path']).stat().st_size!=source['bytes']:raise ValueError('Selected file size changed since whole-byte audit.')
        selected.append({'member_path':row['member_path'],'member_release':row['release'],'selected_source':source,'runtime_priority_inferred':False})
    if len(selected)!=70286:raise ValueError('Incomplete reference coverage.')
    urf=next(x for x in raw['members'] if x['member_path']=='DATA/Characters/Urf/Urf.inibin')
    refused=[]
    for name,altered in [('missing_recovery',{}),('changed_recovered_MD5',{urf['member_path'].casefold():{**recovered[urf['member_path'].casefold()], 'selected':{**recovered[urf['member_path'].casefold()]['selected'],'md5':'0'*32}}})]:
        try:select_reference(urf,altered)
        except ValueError as e:refused.append({'case':name,'error':str(e)})
        else:raise AssertionError('Expected refusal: '+name)
    return {'schema':'openleague_complete_core_reference_coverage/v1','member_count':len(selected),
        'source_policy':'For reference analysis only: exact observed loose payload,otherwise separately recovered exact selected-manifest member. No runtime mount/precedence or current game adoption inferred.',
        'whole_byte_audit':identity(audit_path),'recovered_catalogue':identity(meta_path),'manifest':core['identity'],
        'selected_sources':selected,'source_origin_counts':dict(collections.Counter(x['selected_source']['origin'] for x in selected)),
        'all_exact_reference_payloads_available':True,'recovered_alternatives':list(recovered.values()),
        'controls':{'all70286_unique_selected_members':True,'all11_retained_recoveries_exact':True,'two_controlled_refusals':len(refused)==2},'refusals':refused,
        'whole_payload_hashes_executed_by_recorded_audit_not_rerun_here':True,'native_gameplay_executed':False,'ordinary_runtime_priority_qualified':False,
        'producer':identity(__file__),'current_originals_or_runtime_assets_changed':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--audit',required=True);p.add_argument('--output',required=True)
    args=p.parse_args();out=pathlib.Path(args.output)
    if out.exists():raise ValueError('Preserve previous receipt.')
    result=audit(args.root,args.audit)
    out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'verified':True,'members':result['member_count'],'origins':result['source_origin_counts'],'controlled_refusals':len(result['refusals']),'runtime_priority_qualified':False}))

if __name__=='__main__':main()
