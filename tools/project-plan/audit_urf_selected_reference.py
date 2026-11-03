"""Resolve the two Urf icon comparisons against manifest-attested native bytes."""
import argparse, hashlib, json, pathlib
from rads_reference_membership import RadsReferenceMembership, verify_recovered_alternatives
from reference_inibin import read, hashkey

LOGICAL='DATA/Characters/Urf/Urf.inibin'

def identity(path):
    p=pathlib.Path(path); b=p.read_bytes()
    return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest(),'md5':hashlib.md5(b).hexdigest()}

def audit(root):
    root=pathlib.Path(root)
    membership=RadsReferenceMembership(root)
    selected=next(x for x in verify_recovered_alternatives(membership) if x['logical_path']==LOGICAL)
    source=pathlib.Path(selected['observed']['path'])
    loose=membership.deploy/LOGICAL
    loose_binding=membership.inspect(LOGICAL,loose)
    if loose_binding['status']!='differs_from_all_selected_manifest_payloads':
        raise ValueError('Expected divergent loose-copy identity changed; re-audit historical comparison.')
    previous=root/'docs/fidelity_community_review_4_20.json'
    previous_review=json.loads(previous.read_bytes())
    prior=[x for x in previous_review['mirror_divergences'] if x['resource']==LOGICAL and x['section']=='Info' and x['key'] in ['IconCircle','IconSquare']]
    if len(prior)!=2 or len({x['key'] for x in prior})!=2:raise ValueError('Two distinct prior icon records required.')
    native=read(source); old_native=read(loose); cases=[]
    for row in prior:
        community_path=pathlib.Path(row['community_path']); current=identity(community_path)
        if current['sha256']!=row['community_sha256'] or identity(loose)['sha256']!=row['native_sha256']:
            raise ValueError('Previous comparison source changed; do not silently refresh source identities.')
        community=json.loads(community_path.read_bytes())
        if community['MetaData']['ResourcePath']!=LOGICAL:raise ValueError('Community logical path differs.')
        key=row['key']; value=community['Values']['Info'][key]
        expected=native[hashkey('Info',key)]; old=old_native[hashkey('Info',key)]
        if not isinstance(expected,str) or old!=row['native'] or value!=row['community']:
            raise ValueError('Historical comparison or exact native field binding differs.')
        cases.append({'section':'Info','key':key,'field_hash':hashkey('Info',key),'community_value':value,
            'selected_native_value':expected,'observed_loose_copy_value':old,'matches_selected_native':value==expected,
            'prior_comparison':row,'classification':'matches_selected_RADS_native_payload' if value==expected else 'selected_native_difference_remains',
            'old_exclusion_superseded_for_this_field_only':value==expected,
            'community_source':current})
    if not all(x['matches_selected_native'] for x in cases):raise ValueError('An icon still differs from selected native payload.')
    images=[]
    for field in cases:
        logical='DATA/Characters/Urf/Info/'+field['selected_native_value']
        metadata=json.loads((root/'data/4.20/recovered_client_assets.json').read_bytes())
        entries=[x for x in metadata['files'] if x['relative_path'].casefold()==logical.casefold()]
        if len(entries)!=1:raise ValueError('Exact icon recovery metadata absent or ambiguous.')
        path=pathlib.Path(entries[0]['path']); binding=membership.inspect(logical,path,entries[0])
        if binding['status']!='matches_selected_project_manifest':raise ValueError('Icon payload not manifest-attested.')
        images.append(binding)
    return {'schema':'openleague_urf_selected_reference_correction/v1','task':'SYS-01.2-05',
        'reference':identity(root/'docs/reference_client_4_20.json'),'prior_review':identity(previous),
        'selected_native_binding':selected,'loose_copy_binding':loose_binding,'cases':cases,'icon_payload_bindings':images,
        'corrected_fields':len(cases),'all_two_fields_match_selected_native':True,
        'old_review_preserved':True,'native_or_community_gameplay_executed':False,'game_code_changed':False,
        'ordinary_runtime_source_priority_or_Urf_presentation_qualified':False,'fully_qualified_community_script':False,
        'scope':'Only Info.IconCircle/IconSquare. The original loose-copy comparison remains a historical fact, but its exclusion decision is superseded for the selected recovered native payload. All other community scripts,gameplay and presentation remain separately qualified.'}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output',required=True)
    args=p.parse_args(); out=pathlib.Path(args.output)
    if out.exists():raise ValueError('Preserve prior receipt; choose a fresh output.')
    result=audit(args.root)
    out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'verified':True,'corrected_fields':result['corrected_fields'],'gameplay_qualified':False,'output':str(out)}))

if __name__=='__main__':main()
