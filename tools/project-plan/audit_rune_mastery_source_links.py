"""File-backed source fiches, explicitly separate from loadout/gameplay application."""
import argparse,collections,hashlib,json,pathlib,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from reference_inibin import read,hashkey
from fidelity_compare import close
from rads_reference_membership import RadsReferenceMembership,identity
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):return identity(p)
def need(v,message):
 if not v:raise ValueError(message)
def source_tasks(registry):
 return [t for t in registry['tasks'] if t['kind']=='source' and t['domain']=='08' and t['id'].startswith(('RUNE-','MASTERY-')) and t['id'].endswith('-SCOPE')]
def read_task(root,task_id,context=None):
 """Read known source fields; never infer historical availability or apply effects."""
 root=pathlib.Path(root)
 if context is None:
  registry=load(root/'docs/completion_tasks_2026-10-20.json');comparison=load(root/'docs/fidelity_catalogue_comparison_4_20.json');verifier=RadsReferenceMembership(root);catalogues={}
  for name in ['rune.json','mastery.json']:
   hits=[(path,meta) for path,meta in comparison['catalogues'].items() if pathlib.Path(path).name==name];need(len(hits)==1,'Exact catalogue missing/ambiguous');path,meta=hits[0];need(pin(path)['sha256']==meta['sha256'] and meta['version']=='4.20.1','Catalogue identity/version changed');catalogues[name]=load(path)
  context={'tasks':{t['id']:t for t in registry['tasks']},'comparison':comparison,'verifier':verifier,'catalogues':catalogues}
 tasks=context['tasks'];need(task_id in tasks,'Unknown task');t=tasks[task_id]
 need(t['kind']=='source' and t['domain']=='08' and task_id.startswith(('RUNE-','MASTERY-')) and task_id.endswith('-SCOPE'),'Only source-fiche tasks supported; gameplay/loadout task refused')
 family='rune' if task_id.startswith('RUNE-') else 'mastery';ident=str(t['entity']);official=context['catalogues'][family+'.json'];need(official.get('version')=='4.20.1' and ident in official['data'],'Catalogue subject absent');entry=official['data'][ident]
 need(t['reference_context']['official_entry']==entry,'Task official entry diverges from exact catalogue')
 verifier=context['verifier'];source=verifier.deploy/('DATA/Items/'+ident+'.inibin' if family=='rune' else 'DATA/Talents/'+ident+'.inibin');source_id=pin(source);values=read(source)
 rows=[(i,x) for i,x in enumerate(context['comparison']['rows']) if x['family']==('rune_stats' if family=='rune' else 'mastery_rank_count') and x['subject']==ident];need(bool(rows),'Existing comparison rows absent');fields=[]
 for index,row in rows:
  need(pathlib.Path(row['native_path']).resolve()==source.resolve(),'Comparison rebound to another native source');key=row['native_key'];section,name=key.split('*',1) if '*' in key else ('Data',key);h=hashkey(section,name);need(h in values,'Native field absent; no zero/default invented');native=values[h]
  catalogue=entry['stats'][row['field']] if family=='rune' else entry['ranks']
  need(close(native,row['native']) and close(catalogue,row['catalogue']),'Recorded comparison/source field changed')
  fields.append({'comparison_row':index,'section':section,'name':name,'hash':h,'native_value':native,'catalogue_value':catalogue,'scalar_values_close':close(native,catalogue),'prior_resolution':row['resolution'],'mechanical_adoption_qualified':False})
 membership=verifier.inspect(source.relative_to(verifier.deploy).as_posix(),source,source_id)
 need(membership['status']=='matches_selected_project_manifest','Native source not selected release member')
 return {'task_id':task_id,'family':family,'subject':ident,'native_reference':{'version':verifier.reference['client']['version'],'region':verifier.reference['reference']['region'],'locale':verifier.reference['reference']['locale'],'reference_build_date':verifier.reference['client']['build_date'],'build_timezone':None,'regional_deployment_date':None},'source':source_id,'native_membership':membership,'catalogue_version':'4.20.1','catalogue_locale':'en_US','catalogue_metadata':{k:entry[k] for k in ['name','description','rune','masteryTree','prereq','ranks'] if k in entry},'fields':fields,'source_fields_verified':True,'historical_purchase_or_page_eligibility_proven':False,'account_loadout_or_effect_application_proven':False,'whole_source_scope_accepted':False,'remaining_scope':'Dated EUW availability/purchase/page restrictions and account/loadout/effect application are separate. Native fields/catalogue presence never establish them. SpellData.Ranks is not promoted to an effective service Talent.maxRank.'}

def audit(evidence_root,inputs_override=None):
 v=pathlib.Path(evidence_root);d=load(v/'rune-mastery-source-link-inputs.json') if inputs_override is None else inputs_override;sources={}
 def keep(row):
  p=pathlib.Path(row['path']).resolve();need(p.is_file() and any(p.is_relative_to(x.resolve()) for x in [R,pathlib.Path('E:/mapslol3v3'),pathlib.Path('D:/LeagueOfLegendsV2/4.20')]),'Missing/unqualified evidence path');actual=pin(row['path']);need(all(actual[k]==row[k] for k in ['bytes','sha256']),'Changed evidence: '+str(p));sources[str(p).casefold()]=row
 need(d['schema']=='openleague_rune_mastery_source_link_inputs/v1','Wrong input schema')
 for k in ['gameplay_or_loadout_implemented','historical_availability_qualified','effective_service_mastery_caps_qualified','future_source_tasks_accepted','original_game_executed']:need(d[k] is False,'Unsupported source-to-gameplay claim: '+k)
 need(d['human_acceptance']=='not_given','Invented human acceptance')
 for k in ['producer','reference','prior_delivery','comparison','reader_source']:keep(d[k])
 for row in d['catalogues']:keep(row)
 registry=load(R/'docs/completion_tasks_2026-10-20.json');tasks={t['id']:t for t in registry['tasks']};comparison=load(d['comparison']['path']);verifier=RadsReferenceMembership(R);catalogues={pathlib.Path(x['path']).name:load(x['path']) for x in d['catalogues']};context={'tasks':tasks,'comparison':comparison,'verifier':verifier,'catalogues':catalogues}
 expected_tasks=[t['id'] for t in source_tasks(registry)];need(d['task_ids']==expected_tasks and len(expected_tasks)==353,'Wrong exact source task population')
 observed=[read_task(R,tid,context) for tid in expected_tasks];need(d['fiches']==observed,'Source fiche/native/catalogue/decision observation changed')
 for fiche in observed:keep(fiche['source'])
 selected=d['selected_manifest_sources']
 for k in ['solution','configuration','catalogue']:keep(selected[k])
 for x in selected['manifests']:keep(x['identity'])
 for x in selected['provenance']:keep(x)
 need(selected['manifests']==verifier.manifests and selected['solution']==verifier.solution_identity and selected['configuration']==verifier.configuration_identity and selected['provenance']==verifier.provenance,'Selected manifest scope changed')
 contract=d['reader_contract'];need(contract['role']=='actual_rune_mastery_source_fiche_reader' and contract['installed_path']=='tools/project-plan/audit_rune_mastery_source_links.py' and contract['source']==d['reader_source'],'Reader contract rebound')
 text=pathlib.Path(contract['source']['path']).read_text(encoding='utf-8').splitlines();need(text[contract['line']-1]==contract['excerpt'] and 'def read_task(root,task_id,context=None):' in contract['excerpt'],'Source reader contract line changed')
 roles={contract['role']}
 for a in d['anchors']:
  keep(a['identity']);p=R/a['path'];lines=p.read_text(encoding='utf-8').splitlines();need(0<a['line']<=len(lines) and a['excerpt']==lines[a['line']-1] and a['needle'] in a['excerpt'] and p.resolve()==pathlib.Path(a['identity']['path']).resolve(),'Current helper anchor changed');need(a['role'] not in roles and a['scope'],'Duplicate/unscoped consumer role');roles.add(a['role'])
 need(len(roles)==4 and len(d['links'])==353 and [x['task_id'] for x in d['links']]==expected_tasks,'Missing source/reader links')
 by_task={f['task_id']:f for f in observed}
 for link in d['links']:
  fiche=by_task[link['task_id']];need(link['native_samples']==[fiche['source']] and link['native_selectors']==[x['section']+'*'+x['name'] for x in fiche['fields']],'Native field association incomplete')
  need(link['anchor_roles']==[contract['role'],*list(a['role'] for a in d['anchors'])] and link['resolve_generic_anchor_question'] is False and link['scope'] and link['remaining_question'],'Runtime/availability unknown silently closed')
 counts={'source_requirements_linked':353,'rune_source_fiches':296,'mastery_source_fiches':57,'native_source_files':353,'native_field_observations':359,'rune_stat_observations':302,'mastery_rank_observations':57,'native_selected_member_matches':353,'new_current_source_reader_anchors':4,'source_fiches_accepted':0,'runtime_unknowns_resolved':0}
 need(d['counts']==counts and sum(len(x['fields']) for x in observed)==359 and collections.Counter(x['family'] for x in observed)=={'rune':296,'mastery':57},'Source count or subject family changed')
 open_rows=[i for i,x in enumerate(comparison['rows']) if x['resolution']['status']=='open'];need(open_rows==comparison['open_question_rows']==[18397,18398] and [comparison['rows'][i]['subject'] for i in open_rows]==['4312','4313'],'Mastery contradictions changed/closed without authority')
 return {'schema':'openleague_rune_mastery_source_link_audit/v1','verified':True,'counts':counts,'source_identities':list(sources.values()),'tool_identities':[pin(sys.executable)],'current_consumer_evidence':d['anchors'],'reader_contract':contract,'links':d['links'],'observations':{'fiches':observed,'open_catalogue_rows':open_rows,'gameplay_or_loadout_implemented':False,'historical_availability_qualified':False,'effective_service_mastery_caps_qualified':False},'declared_boundaries':['Source tasks now have an actual field-backed reader; simulation/acceptance tasks are refused by this interface.','296rune/57mastery native files and359fields agree with the existing native/catalogue comparison and exact selected project members.','Catalogue tier/type/name text and raw native values are retained separately; existence and numeric equality do not prove purchase eligibility,page restrictions or effects.','The two mastery4312/4313 authority questions remain open; four native ranks never become service caps by inference.','All353source scopes remain unaccepted and their existing runtime questions remain open. Current source-reader coverage is distinct from original/gameplay fidelity.'],'historical_game_process_launched':False,'current_production_Rust_or_C_changed':False,'all_Goal_requirements_completed':False,'human_acceptance':'not_given'}
def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));p.add_argument('--task');p.add_argument('--evidence-root');p.add_argument('--output');a=p.parse_args()
 try:d=read_task(a.root,a.task) if a.task else audit(a.evidence_root)
 except (ValueError,OSError,KeyError,IndexError) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 if a.output:pathlib.Path(a.output).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps(d if a.task else {'verified':True,'counts':d['counts']},ensure_ascii=False,indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
