from pathlib import Path
import hashlib,json,datetime
from verify_inputs import verify
OUT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    assert not (OUT/'manifest.json').exists(),'already frozen'
    preserved=verify()
    result=json.loads((OUT/'crt_provider_oracle.json').read_text())
    assert not result['provider_returned'] and not result['completed_path'] and not result['passed'] and result['cleanup_passed']
    assert result['stop']['import']['name']=='LoadLibraryA' and result['stop']['path'].endswith('RADS\\RiotRadsIO.dll')
    assert result['crt_phases'][0]['entry']=='CA92CB' and result['crt_phases'][0]['result']==1
    assert result['crt_phases'][1]['entry']=='CAFF53' and result['crt_phases'][1]['result']==0
    assert result['diagnostic_pipe_events'][0]['last_error']==2 and not result['diagnostic_pipe_events'][0]['succeeded']
    assert result['diagnostic_pipe_events'][0]['data_operations']==0
    assert not result['open_host_handles_after_cleanup'] and not result['diagnostic_pipe_handles_after_cleanup']
    assert not any(result['crt_host_backing_after_cleanup'].values())
    dependency=json.loads((OUT/'rads_dependency.json').read_text())
    assert sha(Path(dependency['dll']))==dependency['dll_sha256']
    assert sha(Path(result['source']))==result['source_sha256']
    for name,value in result['generator_hashes'].items():assert sha(OUT/name)==value,name
    for name,count in [('io_isolation_tests.json',36),('logs_bridge_tests.json',23),('crt_heap_ownership_tests.json',9)]:
        proof=json.loads((OUT/name).read_text());assert proof['passed'] and proof['check_count']==count
        for key,value in proof.get('source_hashes',{}).items():assert sha(OUT/key)==value,key
    files=sorted([p for p in OUT.iterdir() if p.is_file() and p.name!='manifest.json']+list((OUT/'attempts').glob('*.json')))
    manifest={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'kind':'native_crt_provider_stopped_at_real_rads_dependency','integrated':False,'complete':False,'rust_compiled':False,
        'qualification':{'bridge_checks':59,'bridge_heap_fault_checks':9,'native_crt_thread_startup':True,'native_low_io_startup':True,
            'provider_returned':False,'ini_read':False,'dll_loaded':False,'ipc_data_operations':0,'host_cleanup_passed':True,
            'stop':'9529F4 LoadLibraryA mapped original RiotRadsIO.dll','native_lifecycle_complete':False},
        'source_pe':{'path':result['source'],'sha256':result['source_sha256']},
        'dll':{k:v for k,v in json.loads((OUT/'rads_dependency.json').read_text()).items() if k in ('dll','dll_sha256','dll_bytes','machine')},
        'files':{str(p.relative_to(OUT)).replace('\\','/'):{'bytes':p.stat().st_size,'sha256':sha(p)} for p in files},
        'verified_external_inputs':preserved,
        'runtime_directories':'Fresh test/probe directories remain untouched in scratch. They are not provider fixtures or required executable inputs.'}
    (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({'files':len(files),'manifest_sha256':sha(OUT/'manifest.json'),'oracle_bytes':(OUT/'crt_provider_oracle.json').stat().st_size}))
if __name__=='__main__':main()
