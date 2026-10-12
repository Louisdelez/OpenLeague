from pathlib import Path
import json,hashlib,datetime
OUT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    assert not (OUT/'manifest.json').exists(),'already frozen'
    prior=Path('E:/mapslol3v3/loading_provider_crt_integration')
    assert sha(prior/'manifest.json')=='c3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486'
    for name,v in json.loads((prior/'manifest.json').read_text())['files'].items():assert sha(prior/name)==v['sha256'],name
    oracle=json.loads((OUT/'rads_provider_oracle.json').read_text())
    assert oracle['stop']['import']['name']=='GetCommandLineA' and oracle['rads_module']['state']=='attaching'
    assert not oracle['passed'] and not oracle['complete'] and not oracle['provider_returned'] and oracle['cleanup_passed']
    assert not oracle['unstarted_callbacks_at_end'] and not oracle['interrupted_callbacks']
    assert not any(oracle['crt_host_backing_after_cleanup'].values())
    assert 0x9529fa not in oracle['executed_instruction_addresses']
    assert sum(0x10000000<=a<0x101ac000 for a in oracle['executed_instruction_addresses'])==612
    assert sha(Path(oracle['rads_module']['source']))==oracle['rads_module']['sha256']
    for name,value in oracle['generator_hashes'].items():assert sha(OUT/name)==value,name
    counts={'loader_structure_tests.json':21,'io_isolation_tests.json':36,'logs_bridge_tests.json':23,
            'crt_heap_ownership_tests.json':9,'slot_namespaces_tests.json':12,'callback_batch_tests.json':8}
    for name,count in counts.items():
        j=json.loads((OUT/name).read_text());assert j['passed'] and j['check_count']==count,name
        for file,value in j.get('source_hashes',{}).items():assert sha(OUT/file)==value,file
    old=json.loads((OUT/'attempts/001.json').read_text());assert old['stop']['import']['name']=='GetCommandLineA' and not old['cleanup_passed']
    files=sorted([p for p in OUT.iterdir() if p.is_file() and p.name!='manifest.json']+list((OUT/'attempts').glob('*.json')))
    data={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'kind':'partial_original_x86_RADS_attach',
      'integrated':False,'complete':False,'rust_compiled':False,'provider_complete':False,'dll_attached':False,
      'native_stop':'GetCommandLineA at100F2AE9 before supplying command line','native_dll_addresses_at_stop':612,
      'native_addresses_at_stop':len(oracle['executed_instruction_addresses']),'host_cleanup_passed':True,
      'tests':counts,'source_dll':oracle['rads_module']['source'],'source_dll_sha256':oracle['rads_module']['sha256'],
      'source_exe':oracle['source'],'source_exe_sha256':oracle['source_sha256'],
      'prior_manifest_sha256':sha(prior/'manifest.json'),
      'files':{str(p.relative_to(OUT)).replace('\\','/'):{'bytes':p.stat().st_size,'sha256':sha(p)} for p in files}}
    (OUT/'manifest.json').write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps({'files':len(files),'manifest_sha256':sha(OUT/'manifest.json'),'oracle_bytes':(OUT/'rads_provider_oracle.json').stat().st_size}))
if __name__=='__main__':main()
