"""Qualify current installed files, actual core tests and the rebuilt client."""
from pathlib import Path
import datetime,hashlib,importlib.util,json,re,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):
 p.parent.mkdir(parents=True,exist_ok=True);temp=p.with_suffix(p.suffix+'.tmp')
 temp.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');assert load(temp)==v;temp.replace(p)
def archive_sources():
 dest=R/'docs/loading_standard_sources';rows={}
 for path in sorted(S.rglob('*')):
  if not path.is_file() or any(part in ['production','__pycache__'] for part in path.relative_to(S).parts):continue
  rel=path.relative_to(S);target=dest/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path,target)
  assert sha(path)==sha(target);rows[rel.as_posix()]={'bytes':target.stat().st_size,'sha256':sha(target)}
 save(dest/'index.json',{'complete':False,'partially_integrated':True,'files':rows})
 return {'manifest':'docs/loading_standard_sources/index.json','sha256':sha(dest/'index.json')}

def archive_resource_preparation():
 source=S.parent/'loading_standard_resource_next';manifest=source/'preparation_manifest.json'
 expected='883e26f470dceaaa4c21d1d0469035eeb9d080b25fa8a9a8689b3e54e7710cbc'
 assert sha(manifest)==expected
 data=load(manifest);assert data['status']=='preparation_only_not_integrated' and not data['complete']
 assert not any(data[k] for k in ['real_provider_cache_constructed','real_provider_cache_destroyed','normal_nonempty_ui_usable','production_modified','compiler_or_client_executed'])
 files={**data['files'],'preparation_manifest.json':{'bytes':manifest.stat().st_size,'sha256':expected}}
 assert len(files)==17
 for rel,row in files.items():
  path=source/rel;assert path.resolve().is_relative_to(source.resolve()),rel
  assert path.stat().st_size==row['bytes'] and sha(path)==row['sha256'],rel
 destination=R/'docs/loading_standard_resource_preparation'
 for rel,row in files.items():
  target=destination/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source/rel,target)
  assert sha(target)==row['sha256'],rel
 return {'manifest':'docs/loading_standard_resource_preparation/preparation_manifest.json','sha256':expected,
         'status':'preparation_only_not_integrated','complete':False,'source_regions_byte_verified':57,
         'native_manager_lifetimes':2,'cache_hits_with_opaque_fixture_tokens':66,
         'misses_stopped_before_factory_body':8,'table_publication_selection_cases':8,
         'real_provider_cache_constructed':False,'real_provider_cache_destroyed':False,
         'normal_nonempty_ui_usable':False,'next_action':data['next_action']}
def main():
 assembled=load(S/'assembled.json');installed=load(S/'installed.json')
 assert sha(S/'assembled.json')==installed['assembled_sha256']
 assert len(assembled['required_core_tests'])==len(set(assembled['required_core_tests']))==22
 assert sha(R/assembled['previous_qualification'])==assembled['previous_receipt_sha256']
 previous=load(R/assembled['previous_qualification'])
 source_hashes={};repairs=[]
 for rel,row in installed['files'].items():
  actual=sha(R/rel);assert actual==sha(S/'production'/rel),rel
  source_hashes[rel]=actual
  if actual!=row['after']:repairs.append({'path':rel,'installed_sha256':row['after'],'qualified_sha256':actual})
 core_path=R/'logs/core-loading-standard-tests.log';text=core_path.read_text(encoding='utf-8-sig')
 results=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out',text)
 assert len(results)==1 and all(int(n)==0 for n in results[0][1:4]) and 'test result: FAILED' not in text
 passed=int(results[0][0]);assert passed==865 and int(results[0][4])==480
 for name in assembled['required_core_tests']:assert re.search(re.escape(name)+r'\s+\.\.\. ok',text),name
 runners=re.findall(r'Running unittests .*?\(([^)]+\.exe)\)',text);assert len(runners)==1
 core_exe=R/runners[0].replace('\\','/')
 core={'passed':passed,'failed':0,'filtered':int(results[0][4]),'log':core_path.relative_to(R).as_posix(),'log_sha256':sha(core_path),
       'executable':core_exe.relative_to(R).as_posix(),'executable_sha256':sha(core_exe),'required_tests':assembled['required_core_tests']}
 build=R/'logs/client-loading-standard-build.log';build_text=build.read_text(encoding='utf-8-sig')
 assert re.search(r'Finished .* target',build_text) and not re.search(r'^error(?:\[|:)',build_text,re.M)
 verifier=S.parent/'loading_clock_integration/verify_client_commands.py'
 assert sha(verifier)=='7701fcf6cec4fd862b5579f54f2f0018a2a8208672308abbd43bf0ec8b35966b'
 spec=importlib.util.spec_from_file_location('client_checks',verifier);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
 module.PREFIX='client-loading-standard-';client=module.verify(root=R)
 image=load(S/'independent_image_verification.json');assert image['passed'] and not image['errors']
 assert image['region_count']==62 and image['package_bytes']==20872
 assert sha(R/'data/4.20/runtime/replay_runtime_image.bin')==image['package_sha256']=='a23f6215d9a876ee38115a3350b7330c9af795da09645dcc8c3e541f715c9c97'
 # This lot changes core paths only; do not relabel prior client unit tests as
 # rerun against this core. The rebuilt binary's commands are fresh evidence.
 for rel in ['crates/client/src/main.rs','crates/client/src/native_effect_clock.rs']:
  assert sha(R/rel)==previous['source_hashes'][rel],rel
 now=datetime.datetime.now(datetime.timezone.utc).isoformat();key='loading_standard_validation';receipt='docs/'+key+'.json'
 next_action=('Continue the normal loading screen through its real resource manager using docs/loading_standard_resource_preparation/preparation_manifest.json: port90B7C0/90A4C0 publication at2D78F1C together with four static hash initializers531A50/531A90/531AD0/531B10, postpublication backpointers592E49..592E6A and nine container sentinels; then90AD00 normalized-name/skin cache and real miss provider/configuration lifecycle,57D775 UI continuation and actual rendering. Prepared cache-hit fixture tokens do not establish real providers or populated destruction. Standard nonempty57D6FE..57D775 now preserves the original service, applies override String24, calls the real skin provider and reaches explicit991E60/90AD00 boundaries. Temporary String24 ownership and its scratch survive failed cleanup and retire on retry. Normal5765F0 screen selection/factories, service-global publication, locale setup, actual transport/event delivery, UI/audio/gameplay fidelity and all24 domains114 tasks37 requirements remain required. Qualify normal GUI cleanup failures reaching the exit status separately; that proposal remains unintegrated. No completed screen or complete game is claimed.')
 limits=[
  'Standard prefix stops before diagnostic991E60 or resource90AD00. No resource provider, texture, UI view, normal recipient factory or rendered loading screen is completed by this lot.',
  'The128 native prefix cases are reused archived executions. Native successful selection and deliberately separate abandoned-boundary cleanup are compared; these are not new native executions or native SEH equivalence.',
  'Owned String24 adapts returned host failures for exclusive nonalias temporaries after successful name construction. Earlier provider rollback, metadata cache assignment, tutorial cleanup, arbitrary custom deallocators and panic/OOM unwind are unchanged and not universally qualified here.',
  'Deferred cleanup deliberately keeps the shared bank alive. A still-unresolved owner makes close fail; a successful retry releases its keepalive. This is explicit retention on failure, not successful shutdown.',
  'Windows tests use real metadata/index/name/skin providers with explicitly bound diagnostic recipients/service globals. Normal process publication remains required.',
  'The eleven final executable commands verify existing application/clock/replay behavior on the new build. The new standard prefix and injected cleanup failures are exercised by core Windows tests; these CLI commands do not render or dispatch its UI.',
  'Prior14 selected client unit tests are historical evidence from process_clock_validation; they were not rerun in this lot. No visual, audio, network, endurance or human fidelity acceptance is claimed.'
 ]
 resource_manifest=S.parent/'loading_standard_resource_next/preparation_manifest.json'
 assert sha(resource_manifest)=='883e26f470dceaaa4c21d1d0469035eeb9d080b25fa8a9a8689b3e54e7710cbc'
 resource_preparation=None
 value={'saved_utc':now,'passed':True,'complete':False,'scope':'Standard nonempty loading-name/skin selection and owned temporary lifetime',
        'core_tests':core,'client':client,'client_unit_tests_run_this_lot':False,'prior_client_unit_test_receipt':assembled['previous_qualification'],
        'source_and_resource_hashes':source_hashes,'qualified_repairs':repairs,
        'build_log':{'path':build.relative_to(R).as_posix(),'sha256':sha(build)},
        'image':{'regions':62,'bytes':20872,'sha256':image['package_sha256'],'independent_audit':'docs/loading_standard_sources/independent_image_verification.json'},
        'native_prefix_cases_reused':128,'native_owned_string_cases_reused':128,'consumer_service_global_mutations':6,
        'consumer_partial_publication_fault_cases':16,'windows_prefix_cases':4,'windows_new_test_functions':3,
        'prefix_connected':True,'typed_owned_failure_connected':True,'scratch_retirement_connected':True,
        'normal_screen_factory_connected':False,'normal_service_global_publication_connected':False,'resource90AD00_connected':False,
        'normal_loading_screen_complete':False,'limits':limits,'next_action':next_action}
 summary={'saved_utc':now,'passed':True,'complete':False,'receipt':receipt,'core_tests_passed':passed,
          'client_commands':client['commands'],'client_executable_sha256':client['executable_sha256'],
          'standard_name_skin_prefix_connected':True,'owned_cleanup_retry_connected':True,'normal_loading_screen_complete':False}
 docs={}
 for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
  d=load(R/'docs'/name);d[key]=summary;d['updated_utc']=now;d['next_action']=next_action
  d['prepared_standard_prefix_candidate'].update(production_partially_integrated=True,integration_receipt=receipt,complete=False,ready_for_integration=False,
        status='Historical unsafe candidate superseded by qualified typed ownership integration; provider/UI remains incomplete.')
  d['prepared_next_evidence']['string24_ownership'].update(production_partially_integrated=True,integration_receipt=receipt,
        ready_for_integration=False,status='Historical preparation superseded by current integrated caller/lease and qualified core tests.',
        required_work='The typed caller/lease path is integrated and qualified in this receipt. Continue resource manager and UI integration; other String24 cache/provider/tutorial failure contracts remain separate.')
  if name=='resume_checkpoint.json':
   d['state']='active';d['saved_utc']=now;d.pop('in_progress',None)
   d.setdefault('last_verified',{}).update(loading_standard_receipt=receipt,loading_standard_core_tests=passed)
  if name=='completion_plan.json':
   for domain in d['domains']:
    if domain['id'] not in ['17','21']:continue
    entries=domain.setdefault('progress_evidence',[])
    if receipt not in entries:entries.append(receipt)
    domain['progress_updated_utc']=now
    for task in domain['tasks']:
     if task['id'] in ['17.3','21.3','21.4'] and receipt not in task['evidence']:task['evidence'].append(receipt)
   d['next_execution_steps'][0]=next_action
  docs[name]=d
 html=R/'docs/completion_plan.html';body=html.read_text(encoding='utf-8');marker='loading-standard-validation';assert marker not in body
 section=f'<section id="{marker}"><h2>Noms et skins pendant le chargement</h2><p>Le préfixe standard applique le nom de remplacement, conserve le service initial et sélectionne le skin depuis les données natives. Les temporaires et leur stockage sont conservés en cas de nettoyage différé, puis libérés lors de la reprise. {passed} tests moteur ciblés et {client["commands"]} commandes du client reconstruit passent. Le gestionnaire de ressources et la suite du rendu restent à intégrer ; l’écran de chargement complet reste à terminer.</p></section>'
 assert body.count('</body>')==1
 new_html=body.replace('</body>',section+'</body>')
 for rel,digest in source_hashes.items():assert sha(R/rel)==digest,rel
 evidence=archive_sources();resource_preparation=archive_resource_preparation()
 value.update(evidence=evidence,next_resource_preparation=resource_preparation)
 for d in docs.values():d['prepared_loading_resource_next']=resource_preparation
 def encoded(d):
  result=(json.dumps(d,ensure_ascii=False,indent=2)+'\n').encode('utf-8');assert json.loads(result)==d;return result
 # Stage every document first. Publish the passed receipt last; on any caught
 # error restore all prior bytes so the marker cannot prevent a clean retry.
 payloads={R/'docs'/name:encoded(d) for name,d in docs.items()}
 payloads[html]=new_html.encode('utf-8');payloads[R/receipt]=encoded(value)
 originals={path:path.read_bytes() if path.exists() else None for path in payloads}
 backup=R/'docs/plan_history'/('loading-standard-validation-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
 for path,data in originals.items():
  if data is not None:(backup/path.name).write_bytes(data)
 staged={}
 for path,data in payloads.items():
  temp=path.with_suffix(path.suffix+'.loading-standard-pending');temp.write_bytes(data)
  assert temp.read_bytes()==data;staged[path]=temp
 try:
  for rel,digest in source_hashes.items():assert sha(R/rel)==digest,rel
  for path,temp in staged.items():temp.replace(path)
  for path,data in payloads.items():assert path.read_bytes()==data,path
 except BaseException:
  for path,data in originals.items():
   if data is None:path.unlink(missing_ok=True)
   else:
    temp=path.with_suffix(path.suffix+'.loading-standard-rollback');temp.write_bytes(data);temp.replace(path)
  raise
 finally:
  for temp in staged.values():temp.unlink(missing_ok=True)
 print(json.dumps(summary))
if __name__=='__main__':main()
