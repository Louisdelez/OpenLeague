"""Run the isolated adapter checks; never launches the native provider probe."""
from pathlib import Path
import sys,subprocess,json,hashlib,time
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
CASES=[
 ('test_loader_structure.py','loader_structure_tests.json'),
 ('test_isolated_io.py','io_isolation_tests.json'),
 ('test_logs_bridge.py','logs_bridge_tests.json'),
 ('test_crt_heap_ownership.py','crt_heap_ownership_tests.json'),
 ('test_slot_namespaces.py','slot_namespaces_tests.json'),
 ('test_callback_batches.py','callback_batch_tests.json'),
 ('test_process_profile.py','process_profile_tests.json'),
 ('test_environment_profile.py','environment_profile_tests.json'),
 ('test_nls_queries.py','nls_query_tests.json'),
 ('test_sync_os.py','sync_os_tests.json'),
 ('test_heap_size.py','heap_size_tests.json'),
 ('test_thread_queries.py','thread_query_tests.json'),
 ('test_native_slist.py','native_slist_tests.json'),
 ('test_heap_mirrors.py','heap_mirrors_tests.json'),
 ('test_heap_boundary.py','heap_boundary_tests.json'),
 ('test_heap_realloc_x86.py','heap_realloc_x86_tests.json'),
 ('test_native_strlen_tail.py','native_strlen_tail_tests.json'),
]
results=[]
for script,report in CASES:
    start=time.time()
    run=subprocess.run([sys.executable,str(OUT/script)],cwd=OUT,capture_output=True,text=True,timeout=120,
        creationflags=subprocess.CREATE_NO_WINDOW)
    item={'script':script,'report':report,'exit_code':run.returncode,'stdout':run.stdout,'stderr':run.stderr,'seconds':time.time()-start}
    if run.returncode==0:
        data=json.loads((OUT/report).read_text());item['report_sha256']=hashlib.sha256((OUT/report).read_bytes()).hexdigest()
        item['passed']=data.get('passed') is True;item['checks']=data.get('check_count',len(data.get('checks',[])))
    else:item['passed']=False
    results.append(item)
    print(json.dumps({'script':script,'passed':item['passed'],'checks':item.get('checks')}),flush=True)
    if not item['passed']:break
receipt={'passed':len(results)==len(CASES) and all(x['passed'] for x in results),'native_pe_execution':'Original19-byte Windows x86 SList and139-byte RADS strlen bodies only. Heap mirror/ABI suites additionally execute synthetic x86 guard/call snippets. No full game or DLL attachment in this suite.',
 'checks':sum(x.get('checks',0) for x in results),'runs':results,'generator_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
(OUT/'adapter_checks.json').write_text(json.dumps(receipt,indent=2)+'\n')
if not receipt['passed']:raise SystemExit(1)
