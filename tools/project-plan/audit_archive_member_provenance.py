"""Readonly archive-child provenance proof; no historical packaging inference."""
import argparse,collections,hashlib,json,pathlib,sys,zipfile
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from rads_reference_membership import RadsReferenceMembership,identity,logical_key
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):return identity(p)
def need(v,message):
 if not v:raise ValueError(message)
def audit(evidence_root,inputs_override=None):
 v=pathlib.Path(evidence_root);d=load(v/'archive-member-provenance-inputs.json') if inputs_override is None else inputs_override;sources={}
 def keep(row):
  p=pathlib.Path(row['path']).resolve();need(p.is_file(),'Missing evidence: '+str(p));need(any(p.is_relative_to(x.resolve()) for x in [R,pathlib.Path('E:/mapslol3v3'),pathlib.Path('D:/LeagueOfLegendsV2/4.20')]),'Unexpected source root')
  actual=identity(row['path']);need(actual=={k:row[k] for k in ['path','bytes','sha256']},'Changed evidence: '+str(p));sources[str(p)]=actual
 need(d['schema']=='openleague_archive_member_provenance_inputs/v1','Wrong input schema')
 for k in ['original_oracles_reexecuted','current_Rust_decoder_executed','current_Bevy_provider_executed','original_files_changed','container_origin_or_selected_manifest_membership_resolved','all_imports_qualified','arbitrary_recursive_dependencies_qualified']:need(d[k] is False,'Unsupported claim: '+k)
 need(d['human_acceptance']=='not_given','Invented acceptance')
 for k in ['producer','reference','prior_delivery','prior_inputs','catalogue','native_payload_oracle','membership_verifier']:keep(d[k])
 prior=load(d['prior_inputs']['path']);oracle=load(d['native_payload_oracle']['path']);catalogue=load(d['catalogue']['path']);m=RadsReferenceMembership(R)
 need(oracle['passed'] and oracle['case_count']==1066 and oracle['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong inherited native payload oracle')
 selected=d['selected_manifest_sources']
 for k in ['solution','configuration','catalogue']:keep(selected[k])
 for x in selected['manifests']:keep(x['identity'])
 for x in selected['provenance']:keep(x)
 need(selected['solution']==m.solution_identity and selected['configuration']==m.configuration_identity and selected['catalogue']==m.catalogue_identity and selected['manifests']==m.manifests and selected['provenance']==m.provenance,'Selected manifest identity changed')
 expected_rows=[];directories=[]
 for ordinal,(a,c,old) in enumerate(zip(d['archives'],catalogue['archives'],prior['archives'],strict=True)):
  keep(a['native']);keep(a['current']);need(a['ordinal']==ordinal and a['native']==old['native'] and a['current']==old['current'],'Archive origin changed')
  relative=pathlib.Path(c['path']).relative_to('data/4.20/archives');prefix='DATA/'+relative.parent.as_posix()+'/'
  need(prefix==a['manifest_prefix'],'Unqualified manifest reconstruction prefix')
  need(a['container_membership']==prior['manifest_membership']['rows'][ordinal] and a['container_membership']['status']=='not_listed_in_two_selected_projects','Container membership falsely promoted')
  with zipfile.ZipFile(a['native']['path']) as z:
   for index,info in enumerate(z.infolist()):
    data=z.read(info);sha=hashlib.sha256(data).hexdigest();logical=prefix+info.filename.rstrip('/');logical_key(logical)
    hit=[(i,x) for i,x in enumerate(oracle['cases']) if x['archive']==ordinal and x['name']==info.filename];need(len(hit)==1,'Ambiguous inherited oracle member');oi,case=hit[0]
    need((len(data),sha,info.CRC)==(case['uncompressed_size'],case['sha256'],case['crc']),'Archive member disagrees with inherited native output')
    if info.is_dir():directories.append({'archive':ordinal,'entry':index,'name':info.filename,'bytes':len(data),'sha256':sha});continue
    flat=m.deploy/logical;flat_id=identity(flat);need(flat_id['bytes']==len(data) and flat_id['sha256']==sha,'Flat source disagrees with archive child');keep(flat_id)
    expected_rows.append({'archive':ordinal,'entry':index,'archive_member_name':info.filename,'RADS_logical_path':logical,'flat_source':flat_id,'sha256':sha,'md5':hashlib.md5(data).hexdigest(),'bytes':len(data),'CRC32':info.CRC,'compressed_bytes':info.compress_size,'local_header_offset':info.header_offset,'native_payload_oracle_index':oi,'membership':m.inspect(logical,flat,flat_id)})
 need(d['file_members']==expected_rows,'Member path/identity/release/metadata changed');need(d['directory_members']==directories,'Directory population changed')
 counts={'archives':5,'file_members':1059,'directory_members':7,'selected_member_matches':1058,'unlisted_members':1,'decoded_bytes':48570309,'flat_source_SHA_matches':1059,'native_payload_oracle_SHA_matches':1066}
 need(d['counts']==counts and len(expected_rows)==1059 and len(directories)==7 and sum(x['bytes'] for x in expected_rows)==48570309,'Wrong complete bounded population')
 need(collections.Counter(x['membership']['status'] for x in expected_rows)=={'matches_selected_project_manifest':1058,'not_listed_in_two_selected_projects':1},'Member eligibility changed')
 unlisted=[x for x in expected_rows if not x['membership']['matching_members']]
 need(d['unlisted_members']==unlisted and unlisted[0]['RADS_logical_path']=='DATA/menu/HUD/hud1366x768.ini' and unlisted[0]['bytes']==384,'Unlisted file hidden or rebound')
 roles=set()
 for a in d['anchors']:
  keep(a['identity']);p=R/a['path'];lines=p.read_text(encoding='utf-8').splitlines()
  need(str(p)==a['identity']['path'] and 0<a['line']<=len(lines) and lines[a['line']-1]==a['excerpt'] and a['needle'] in a['excerpt'],'Current consumer anchor changed')
  need(a['scope'] and a['role'] not in roles,'Missing/duplicate consumer role');roles.add(a['role'])
 need(len(roles)==7 and [x['task_id'] for x in d['links']]==['SYS-02.1-01','SYS-02.1-02','SYS-02.1-05'],'Wrong task/source scope')
 for link in d['links']:
  need(link['resolve_generic_anchor_question'] is False and link['scope'] and link['remaining_question'] and all(x in roles for x in link['anchor_roles']),'Open provenance boundary removed')
  for source in link['native_samples']:keep(source)
 need(d['links'][2]['native_samples']==[x['flat_source'] for x in expected_rows],'Imported-file source population incomplete')
 return {'schema':'openleague_archive_member_provenance_audit/v1','verified':True,'counts':{'archive_member_provenance_requirements_linked':3,'current_source_anchors':7,**counts,'generic_anchor_questions_resolved':0,'generic_anchor_questions_refined_open':3,'future_inventory_tasks_accepted':0},'source_identities':list(sources.values()),'tool_identities':[identity(sys.executable),identity(zipfile.__file__)],'current_consumer_evidence':d['anchors'],'links':d['links'],'observations':{'archive_member_counts':counts,'unlisted_members':unlisted,'archives':d['archives'],'selected_manifest_sources':selected,'file_members':expected_rows,'directory_members':directories,'current_Rust_decoder_executed':False,'current_Bevy_provider_executed':False,'original_oracles_reexecuted':False},'declared_boundaries':['1058of1059non-directory payloads match exact selected per-member manifests; all1059are SHA-identical to actual supplied flat native files and inherited native payload outputs.','Five containers are unlisted; byte-identical selected contents do not establish historical ZIP packaging/origin.','HUD/hud1366x768.ini384bytes remains unlisted despite ZIP/flat equality; source/version or creation provenance still required.','Manifest prefixes are an explicit comparison mapping,not proof of runtime alias registration.','Python ZIP decoding and the actual readonly membership reader execute; existing Rust decoder/provider/startup sites are source-inspected only. No original experiment replay.','No complete recursive dependency inventory,all-project import provenance,ordinary renderer or future inventory task acceptance.'],'historical_mount_order_qualified':False,'container_origin_or_selected_manifest_membership_resolved':False,'historical_game_process_launched':False,'current_production_Rust_or_C_changed':False,'all_Goal_requirements_completed':False,'human_acceptance':'not_given'}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);args=p.parse_args()
 try:d=audit(args.evidence_root)
 except (ValueError,OSError,KeyError,IndexError) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 pathlib.Path(args.output).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'verified':True,'counts':d['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
