"""Original cache/constructor/scalar path for all668 conditional skin bindings."""
import argparse
import collections
import datetime
import hashlib
import json
import pathlib
import sys

sys.path.insert(0,'E:/OpenLeague/tools/project-plan')
from original_config_cache_reference import OriginalConfigCache
from native_skin_reference import integer_identity


def load(p):return json.loads(pathlib.Path(p).read_bytes())
def identity(p):
    p=pathlib.Path(p);raw=p.read_bytes()
    return {'path':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}


def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output',required=True);a=p.parse_args()
    root=pathlib.Path(a.root);out=pathlib.Path(a.output)
    if out.exists():p.error('Preserve previous evidence; choose a new output.')
    ref=load(root/'docs/reference_client_4_20.json');binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];deploy=binary.parent
    prior_path=root/'docs/reference_native_skin_loader_sources/original-skin-resources-execution.json';prior=load(prior_path)
    catalogue_path=pathlib.Path(ref['catalogue']['local_path']);catalogue=load(catalogue_path)
    assert identity(catalogue_path)['sha256']==ref['catalogue']['sha256'] and catalogue['version']=='4.20.1'
    official={(c,int(s['num']),int(s['id'])) for c,d in catalogue['data'].items() for s in d['skins']}
    assert official=={(r['champion'],r['skin_num'],r['skin_id']) for r in prior['rows']}
    x=OriginalConfigCache(binary,[deploy]);rows=[];sources={};counts=collections.Counter();differences=[]
    for index,old in enumerate(prior['rows']):
        physical=pathlib.Path(old['selected_compiled_source']['path'])
        assert identity(physical)==old['selected_compiled_source']
        logical=physical.relative_to(deploy).as_posix()[:-3];section=old['selected_section'];profiles=[]
        try:
            for locale in [None,'en_GB']:
                x.start(locale)
                scale=x.cached_scalar(logical,section,'SkinScale',0.)
                explicit_id=x.identity_field(section)
                assert explicit_id['found'] and integer_identity(explicit_id['value'])==old['skin_id']
                illumination=x.cached_scalar(logical,section,'SelfIllumination',0.)
                missing=x.cached_scalar(logical,section,'OpenLeagueMissingFieldControl',7.25)
                assert missing['value']==7.25 and not any(e['found'] for e in missing['original_scalar_events'])
                hit=x.cached_scalar(logical,section,'SkinScale',0.)
                assert hit['float32_hex']==scale['float32_hex'] and not hit['new_opened_streams'] and hit['pair']['pair']==scale['pair']['pair']
                forced=x.cached_scalar(logical,section,'SkinScale',0.,True)
                assert forced['float32_hex']==scale['float32_hex'] and forced['new_opened_streams'] and forced['pair']['pair']!=scale['pair']['pair']
                assert all(s['closed'] and s['position']==next(o['bytes'] for o in x.opened if o['physical']==s['physical']) for s in x.read_streams)
                if locale is None:
                    for field,result in [('SkinScale',scale),('SelfIllumination',illumination)]:
                        assert result['float32_hex']==old['original_getter_fields'][field]['float32_hex'],(old['champion'],old['skin_num'],field,result)
                profiles.append({'locale_resolver_input':locale,'provider_roots':[str(deploy)],
                    'primary_compiled_identity':explicit_id,'scale':scale,'self_illumination':illumination,
                    'missing_field_control':missing,'cache_hit':hit,'force_reload':forced,
                    'constructor_calls':x.constructed,'closed_streams':x.read_streams,'opened':x.opened,
                    'original_addresses_exercised':len(x.case_visited)})
                counts['declared_contexts']+=1;counts['explicit_primary_id_matches']+=1;counts['cache_hits_without_reopen']+=1;counts['forced_reloads_republished']+=1
                counts['locale_override_pairs']+=int(scale['pair']['override'] is not None)
                for source in x.opened:
                    current=pathlib.Path(source['physical']);sources[str(current)]=identity(current)
            for field in ['scale','self_illumination']:
                if profiles[0][field]['float32_hex']!=profiles[1][field]['float32_hex']:
                    differences.append({'champion':old['champion'],'skin_num':old['skin_num'],'skin_id':old['skin_id'],
                                        'field':field,'initial':profiles[0][field],'explicit_en_GB':profiles[1][field]})
            rows.append({'champion':old['champion'],'skin_num':old['skin_num'],'skin_id':old['skin_id'],
                         'conditional_selected_source':identity(physical),'section':section,'logical_cache_request':logical,
                         'profiles':profiles,'upstream_package_and_effective_runtime_locale_qualified':False})
        except BaseException:
            print(json.dumps({'failed_champion':old['champion'],'skin_num':old['skin_num'],'completed_rows':len(rows),'logical_request':logical}),flush=True)
            raise
        if len(rows)%50==0:print(json.dumps({'processed':len(rows),'counts':dict(counts)}),flush=True)
    assert len(rows)==668 and counts['declared_contexts']==1336
    proof={'schema':'openleague_original_config_cache_experiment/v1','passed':True,
        'observed_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'reference':identity(root/'docs/reference_client_4_20.json'),
        'binary':identity(binary),'catalogue':identity(catalogue_path),'catalogue_version':'4.20.1','prior_conditional_source_selection':identity(prior_path),
        'rows_count':len(rows),'counts':dict(counts),'source_files':list(sources.values()),'rows':rows,
        'locale_context_numeric_differences':differences,'original_cache_evidence':x.evidence(),
        'producer':identity(pathlib.Path(__file__)),'helper':identity(pathlib.Path(__file__).with_name('original_config_cache_reference.py')),
        'historical_game_process_launched':False,'game_source_or_data_changed':False,
        'effective_historical_provider_bootstrap_or_locale_qualified':False,
        'limits':['All668upstream file/section selections are the prior conditional reference, not a newly proved package mount.',
                  'Each source is exercised under two declared contexts: original resolver flag0 and explicit flag1/en_GB. Neither establishes the historical runtime switch/tag/provider list.',
                  'Native singleton/cache/object constructors, compiled parser, locale resolution/file dispatch, scalar/defaults/override lookups, cached hits and forced destruction/reload/publication execute. Bounded file-provider leaves, alloc/SSO/copy, fixed thread/cwd, absent raw-INI stat, logging/atexit/allocator runtime are adapters.',
                  'Fresh isolated contexts restore all writable PE sections. Actual reference files are read only; tests use separately identified temporary payload copies for changed-file controls.',
                  'Existing raw-text INI semantics and host directory mutation are refused. No ordinary current Rust/game consumer, rendering, audio, ownership or availability is qualified.']}
    out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'passed':True,'rows':len(rows),'counts':dict(counts),'sources':len(sources),'locale_numeric_differences':len(differences),'output':str(out)}),flush=True)


if __name__=='__main__':main()
