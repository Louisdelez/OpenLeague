from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
defaults=load('data/4.20/search_context_defaults_contract.json');folders=load('data/4.20/global_resource_folders_contract.json');assert defaults['passed'] and folders['passed']
discovery=load('docs/native_projection_discovery.json');assert hashlib.sha256(Path(discovery['source']).read_bytes()).hexdigest()==defaults['native_sha256']
receipt={'updated_utc':now,'complete':False,'native_default_constructor_addresses':defaults['native_addresses'],'native_folder_orchestration_addresses':folders['native_addresses'],'default_context':defaults['default_context'],'directory_requests':folders['folders'],'limits':defaults['limits']+folders['limits'],'catalog_job':{'session_id':22217,'process_id':9724,'log':'logs/global-resource-catalog-probe.log','script':'tools/probe_global_resource_catalog.py','state_at_check':'running','live_process_checked_utc':now},'next_actions':['Poll existing live native catalog session22217, inspect its exit and resulting global_resource_catalog_contract.json; do not restart solely for an observation timeout.','If native catalog completes, install tools/install_global_resource_catalog_test.py and run all client tests/build; record using tools/record_global_resource_discovery.py after updating its verified test count/log assertions.','Qualify Shared recursive iteration and Levels/Characters directory enumeration; complete configuration/upscale/normal fog pipeline and remaining full-game plan.'],'files_sha256':{p:sha(p) for p in ['data/4.20/search_context_defaults_contract.json','data/4.20/global_resource_folders_contract.json','target/debug/openleague-client.exe']}}
save('docs/native_global_context_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_global_context_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['next_projected_action']=' '.join(receipt['next_actions']);d['pending_native_jobs']=[receipt['catalog_job']]
 else:d['current_evidence']['native_global_context_receipt']='docs/native_global_context_progress.json'
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
for name in ['probe_search_context_defaults.py','probe_global_resource_folders.py','probe_global_resource_catalog.py','record_global_resource_discovery.py','record_global_context_checkpoint.py','install_global_resource_catalog_test.py','inspect_search_context_creation.py','inspect_global_resource_enumeration.py','inspect_recursive_resource_enumeration.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print(json.dumps({'constructor_addresses':defaults['native_addresses'],'orchestration_addresses':folders['native_addresses'],'directory_requests':len(folders['folders']),'catalog_session':22217,'complete':False}))
