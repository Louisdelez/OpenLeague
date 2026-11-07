"""Reproduce original locale caller, raw defaults and seven conditional skins."""
import argparse
import datetime
import hashlib
import json
import pathlib
import shutil
import tempfile

from original_text_config_reference import OriginalTextConfig


def identity(p):
    p=pathlib.Path(p)
    return {'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}


def main():
    a=argparse.ArgumentParser();a.add_argument('--root',default='E:/OpenLeague');a.add_argument('--output',required=True)
    args=a.parse_args();root=pathlib.Path(args.root);out=pathlib.Path(args.output)
    if out.exists():raise ValueError('Preserve previous receipt; choose a new output')
    refpath=root/'docs/reference_client_4_20.json';ref=json.loads(refpath.read_bytes())
    native_root=pathlib.Path(ref['source_root']);binary=native_root/ref['client']['binary'];deploy=binary.parent
    priorpath=root/'docs/reference_native_skin_loader_sources/original-config-cache-execution.json'
    prior=json.loads(priorpath.read_bytes())
    assert prior['passed'] and prior['rows_count']==668
    input_paths=[deploy/'DATA/CFG/defaults/Locale.cfg',deploy/'DATA/CFG/defaults/Game.cfg',
        deploy/'DATA/CFG/Game.cfg',native_root/'Config/Game.cfg']
    sources={str(p.resolve()).casefold():identity(p) for p in input_paths}
    x=OriginalTextConfig(binary,[deploy],native_root);context=x.start()
    initialized=x.initialize_locale()
    assert initialized['locale']==initialized['application_string']=='en_GB' and initialized['enabled']
    assert 0x8b15d0 not in x.case_visited and 0x82d1a0 in x.case_visited and 0x8b2e70 in x.case_visited
    reference_case={'context':context,'initialization':initialized,'opened':list(x.opened),
        'closed_streams':list(x.read_streams),'original_addresses_exercised':len(x.case_visited),
        'exact_loose_Locale_cfg_present':(deploy/'DATA/CFG/Locale.cfg').is_file(),
        'global_Game_cfg_fallback_used':False,'expected_locale':'en_GB','passed':True}
    rows=[]
    for row in prior['rows']:
        if row['champion']!='Renekton':continue
        expected=next(p for p in row['profiles'] if p['locale_resolver_input']=='en_GB')
        scalars={}
        for kind in ['scale','self_illumination']:
            p=expected[kind]
            actual=x.cached_scalar(row['logical_cache_request'],row['section'],p['field'],p['default'])
            assert actual['float32_hex']==p['float32_hex']
            scalars[kind]=actual
        skin_id=x.identity_field(row['section'])
        assert int(skin_id['value'])==row['skin_id']
        source=row['conditional_selected_source'];assert identity(source['path'])==source
        sources[str(pathlib.Path(source['path']).resolve()).casefold()]=source
        rows.append({'champion':row['champion'],'skin_num':row['skin_num'],'skin_id':row['skin_id'],
            'section':row['section'],'logical_cache_request':row['logical_cache_request'],
            'conditional_selected_source':source,'primary_identity':skin_id,'scalars':scalars,
            'same_bits_as_prior_explicit_en_GB_context':True,
            'locale_initialized_from_actual_default_file_by_original_caller':True,
            'effective_historical_package_mounting_qualified':False})
    assert len(rows)==7
    second=x.set_locale('en_US');assert second['after']=='en_GB'
    reference_evidence=x.evidence()
    scratch=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision10')
    copies=[]
    with tempfile.TemporaryDirectory(dir=scratch) as td:
        temp=pathlib.Path(td).resolve();assert temp.is_relative_to(scratch.resolve())
        for logical,source in [('DATA/CFG/defaults/Game.cfg',input_paths[1]),
                               ('DATA/CFG/Game.cfg',input_paths[2]),('Config/Game.cfg',input_paths[3])]:
            p=temp/logical;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,p)
            assert identity(p)['sha256']==identity(source)['sha256']
            copies.append({'temporary_logical':logical,'original':identity(source),
                'temporary_bytes':p.stat().st_size,'temporary_sha256':identity(p)['sha256']})
        y=OriginalTextConfig(binary,[temp],scratch);y.start();fallback=y.initialize_locale()
        assert fallback['locale']=='en_US' and fallback['selected_user_config']
        assert pathlib.Path(fallback['selected_user_config']).resolve()==(temp/'Config/Game.cfg').resolve()
        assert all(v in y.case_visited for v in [0x8b15d0,0x8b3970,0x8b3140])
        fallback_case={'temporary_context':True,'temporary_paths_retained':False,
            'Locale_cfg_and_default_deliberately_not_copied':True,'copies':copies,
            'initialization':fallback,'opened':y.opened,'closed_streams':y.read_streams,
            'evidence':y.evidence(),'expected_locale':'en_US','passed':True,
            'qualification':'Original fallback and native config-directory selection on byte-identical temporary copies; no claim that this missing-locale arrangement was historical.'}
    for p in input_paths:assert identity(p)==sources[str(p.resolve()).casefold()]
    receipt={'schema':'openleague_original_text_config_locale/v1','passed':True,
        'observed_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'reference':identity(refpath),'binary':identity(binary),
        'prior_original_cache_receipt':identity(priorpath),'reference_case':reference_case,
        'one_shot_second_setter':second,'conditional_skin_rows':rows,'conditional_skin_rows_count':len(rows),
        'fallback_case':fallback_case,'source_files':list(sources.values()),
        'original_reference_evidence':reference_evidence,
        'producer':identity(__file__),'helper':identity(pathlib.Path(__file__).with_name('original_text_config_reference.py')),
        'historical_game_process_launched':False,'game_source_or_data_changed':False,
        'historical_effective_backend_mounting_or_locale_qualified':False,
        'limits':['Actual loose-reference defaults/Locale.cfg bytes feed the original caller and setter under the supplied read-only backend. Historical mounted overlays/CLI/generated inputs and host provider bootstrap remain open.',
                  'The fallback arrangement is explicitly a temporary copy of three exact source files, omitting Locale.cfg/default. It qualifies the original branch, not an observed historical startup.',
                  'Seven prior conditional Renekton file/section choices compose with this initialized locale and match prior scalar bits/IDs; all668profiles were not freshly rerun here.',
                  'ASCII raw .ini/.cfg parsing, size/rewind/read/close and constructor mtime64 observation are bounded adapters. Native string bytes/sizes, including the added last-line terminator, are preserved.',
                  'Existing-directory and permission checks observe without creating. File migration/copy/write/delete and directory creation/removal are refused before host dispatch. No current game, renderer, audio or human acceptance proof.']}
    out.write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'passed':True,'locale':initialized['locale'],'conditional_skins':len(rows),
        'fallback_locale':fallback['locale'],'source_files':len(sources),'output':str(out)}),flush=True)


if __name__=='__main__':main()
