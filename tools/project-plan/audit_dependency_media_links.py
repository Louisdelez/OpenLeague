"""Readonly exact source/current-consumer audit for dependency and media references."""
import argparse,collections,hashlib,json,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3')
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
 if not ok:raise ValueError(why)
def audit(evidence_root,inputs_override=None,probe_override=None,projections_override=None):
 v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
 inputs=load(v/'dependency-media-link-inputs.json') if inputs_override is None else inputs_override
 need(inputs['schema']=='openleague_dependency_media_link_inputs/v1','Wrong link schema')
 need(all(inputs[k] is False for k in ['all_future_dependency_tasks_qualified','original_provider_dependency_resolution_qualified','current_Bevy_or_audio_device_executed']) and inputs['human_acceptance']=='not_given','Unsupported complete/provider/device claim')
 identities={};tools={}
 def keep(x,tool=False):
  p=pathlib.Path(x['path']).resolve(strict=True);need(tool or any(p.is_relative_to(a.resolve()) for a in [R,S,pathlib.Path('D:/LeagueOfLegendsV2/4.20')]),'Source outside explicit roots')
  actual=pin(p);need(all(actual[k]==x[k] for k in ['bytes','sha256']),'Changed source identity');(tools if tool else identities)[str(p).casefold()]=x;return p
 for k in ['producer','reference','prior_delivery','component_probe','source_projections','existing_decoder_identity']:keep(inputs[k])
 for x in inputs['current_documents']:keep(x)
 previous=load(inputs['prior_delivery']['path']);need(previous['delivery_audit']['passed'] and not previous['delivery_audit_pending'] and not previous['integration_pending'],'Previous delivery not qualified')
 reference=load(inputs['reference']['path']);need(reference['client']['version']=='4.20.0.315' and reference['reference']['region']=='EUW' and reference['reference']['locale']=='en_GB','Wrong original reference')
 oracle_sha=next(s['sha256'] for s in reference['sources'] if s['path']==reference['client']['binary'])
 probe=load(inputs['component_probe']['path']) if probe_override is None else probe_override
 need(probe['schema']=='openleague_dependency_media_consumer_probes/v1','Wrong probe schema')
 for k in ['current_production_code_changed','outputs_installed_in_project','historical_game_process_launched','original_oracles_reexecuted','Bevy_or_audio_device_executed']:need(probe[k] is False,'Unsupported probe scope')
 for k in ['producer','publication_recovery_producer','executed_binary','projections']:keep(probe[k])
 keep(probe['compiler'],True)
 for x in probe['source_identities']:keep(x)
 for k in ['compiler_version','build','execution']:need(probe[k]['exit_code']==0,'Component command failed');keep(probe[k]['log'])
 recovery=probe['publication_recovery'];need(recovery['initial_wrapper_exit_code']==1 and recovery['completed_build_and_component_exit_codes']==[0,0] and recovery['raw_log_unchanged'] and not recovery['completed_commands_replayed'],'Publication failure or replay hidden')
 raw=pathlib.Path(probe['execution']['log']['path']).read_text(encoding='utf-8').strip();actual=json.loads(json.loads('"'+raw+'"'))
 expected={'INIBIN_entries':53,'typed_integer_queries':58,'INIBIN_truncation_refusals':366,'INIBIN_other_refusals':2,'bank_header_oracle_profiles':63,'actual_bank_headers':6,'PCM_clips':31,'PCM_truncation_refusals':31,'PCM_other_refusals':4,'bank_stream_dependency_methods':'exact projected current source','historical_game_process_launched':False,'Bevy_or_audio_device_executed':False}
 need(actual==probe['observed']==expected,'Wrong bounded component observations')
 projections=load(inputs['source_projections']['path']) if projections_override is None else projections_override
 need(projections['schema']=='openleague_exact_rust_source_projections/v1' and len(projections['projections'])==8,'Wrong projection scope');keep(projections['producer'])
 host=next(x for x in probe['source_identities'] if pathlib.Path(x['path']).name=='dependency_media_host.rs');host_text=pathlib.Path(host['path']).read_text(encoding='utf-8')
 for p in projections['projections']:
  source=keep(p['source']);text=source.read_text(encoding='utf-8');a,b=p['normalised_character_span'];need(hashlib.sha256(text.encode()).hexdigest()==p['normalised_source_sha256'] and text[a:b]==p['snippet'] and hashlib.sha256(p['snippet'].encode()).hexdigest()==p['snippet_sha256'] and p['snippet'] in host_text,'Projection differs from actual source')
 for name in ['native_map10_inibin_loader_contract.json','native_map10_typed_integer_contract.json','audio_bank_header_contract.json']:
  d=load(R/'data/4.20'/name);need(d['passed'] and d['native_sha256']==oracle_sha,'Inherited oracle identity mismatch')
 sys.path.insert(0,str(R/'tools/project-plan'));import reference_inibin
 keep(pin(R/'tools/project-plan/reference_inibin.py'))
 troy=load(R/'data/4.20/relic_runes/TT_Heal_Rune.json');values=reference_inibin.read(troy['source']['path']);need(len(probe['Troy_raw_fields'])==4,'Wrong Troy field count')
 need([x['key'] for x in probe['Troy_raw_fields']]==['p-mesh','p-meshtex','p-type','p-scale'],'Wrong Troy field roles')
 for row in probe['Troy_raw_fields']:
  h=reference_inibin.hashkey('Heal_Plus',row['key']);need(row['section']=='Heal_Plus' and int(h)==row['hash'] and values[h]==row['original_raw_value']==row['current_document_value']==troy['sections']['Heal_Plus'][row['key']],'Wrong actual Troy field/dependency')
 need(probe['Troy_raw_fields'][1]['original_raw_value']=='color-hold.tga','Logical Troy request silently converted')
 manifest=load(R/'data/4.20/ambient_audio_manifest.json');need(inputs['existing_decoder_matches_manifest'] and inputs['existing_decoder_identity']['sha256']==manifest['decoder_sha256'],'Existing conversion provenance mismatch')
 bank_cache={}
 for row in manifest['banks']:
  p=keep(pin(row['path']));data=p.read_bytes();need(hashlib.sha256(data).hexdigest()==row['sha256'],'Original bank changed');chunks={};cursor=0
  while cursor<len(data):
   need(cursor+8<=len(data),'Truncated bank envelope');tag,size=struct.unpack_from('<4sI',data,cursor);start=cursor+8;end=start+size;need(end<=len(data) and tag not in chunks,'Ambiguous/out-of-range bank chunk');chunks[tag]=(start,data[start:end]);cursor=end
  need(cursor==len(data),'Bank stream not fully consumed');bank_cache[str(p)]=chunks
 need(len(probe['media_embedded_matches'])==len(manifest['media'])==31,'Missing media associations')
 for observed,row in zip(probe['media_embedded_matches'],manifest['media'],strict=True):
  bank=keep(observed['bank']);chunks=bank_cache[str(bank)];matches=[x for x in struct.iter_unpack('<III',chunks[b'DIDX'][1]) if x[0]==row['source_id']];need(len(matches)==1,'Missing/ambiguous DIDX source');mid,offset,size=matches[0]
  need(observed['source_id']==mid and observed['DIDX_offset']==row['embedded_offset']==offset and observed['absolute_DATA_offset']==chunks[b'DATA'][0]+offset and observed['bytes']==row['embedded_bytes']==size,'Wrong embedded-media coordinates')
  wem=keep(observed['WEM']);wav=keep(observed['WAV']);need(wem.read_bytes()==chunks[b'DATA'][1][offset:offset+size] and pin(wem)['sha256']==row['wem_sha256'] and pin(wav)['sha256']==row['wav_sha256'],'Media not linked to original payload')
  need(observed['frames']==row['frames'] and observed['sample_rate']==row['sample_rate'] and observed['channels']==row['channels'],'Wrong PCM metadata association')
 need(len(inputs['anchors'])==11 and len({a['role'] for a in inputs['anchors']})==11,'Wrong current consumer population');roles={a['role']:a for a in inputs['anchors']}
 for a in inputs['anchors']:
  p=keep(a['source']);need(p==(R/a['path']).resolve(),'Wrong project consumer');lines=p.read_text(encoding='utf-8').splitlines();need(a['needle'] in lines[a['line']-1] and a['excerpt']==lines[a['line']-1],'Changed actual consumer anchor')
 need([x['task_id'] for x in inputs['links']]==['SYS-02.2-06','SYS-02.2-07'] and [x['task_id'] for x in inputs['links'] if x['resolve_generic_anchor_question']]==['SYS-02.2-07'],'Wrong association resolution scope')
 for link in inputs['links']:
  need(link['native_samples'] and link['scope'] and link['anchor_roles'] and all(r in roles for r in link['anchor_roles']),'Incomplete source-consumer link')
  for x in link['native_samples']:keep(x)
 membership_path=v/'dependency-media-native-membership.json';keep(pin(membership_path));membership=load(membership_path)
 need(membership['schema']=='openleague_dependency_media_native_membership/v1' and membership['input']==pin(v/'dependency-media-link-inputs.json') and not membership['effective_runtime_precedence_qualified'] and not membership['native_process_launched'],'Wrong membership scope')
 for k in ['producer','verifier','native_solution','native_configuration','catalogue']:keep(membership[k])
 for row in membership['manifests']:keep(row['identity'])
 for row in membership['provenance']:keep(row)
 from rads_reference_membership import RadsReferenceMembership
 verifier=RadsReferenceMembership(R);samples={str(pathlib.Path(x['path']).resolve()).casefold():x for link in inputs['links'] for x in link['native_samples']};rows=[verifier.inspect(pathlib.Path(x['path']).relative_to(verifier.deploy).as_posix(),x['path'],x) for x in samples.values()]
 need(rows==membership['rows'] and len(rows)==10 and all(r['status']=='matches_selected_project_manifest' for r in rows),'Wrong exact native membership')
 return {'schema':'openleague_dependency_media_link_audit/v1','verified':True,'counts':{'dependency_media_requirements_linked':2,'current_source_anchors':11,'exact_manifest_native_samples':10,'INIBIN_entries':53,'typed_integer_queries':58,'INIBIN_refusals':368,'bank_header_oracle_profiles':63,'actual_bank_headers':6,'native_embedded_WEM_matches':31,'current_PCM_clips':31,'PCM_refusals':35,'Troy_raw_fields':4,'generic_anchor_questions_resolved':1,'generic_anchor_questions_refined_open':1,'future_dependency_tasks_accepted':0},'source_identities':list(identities.values()),'tool_identities':list(tools.values()),'current_consumer_evidence':inputs['anchors'],'links':inputs['links'],'observations':{'component':{'observed':probe['observed'],'execution':probe['execution'],'publication_recovery':recovery},'Troy_raw_fields':probe['Troy_raw_fields'],'media_source_ids':[r['source_id'] for r in probe['media_embedded_matches']]},'declared_boundaries':['Actual current pure readers execute; historical oracles are inherited and not rerun.','Typed getter and Stream dependencies use eight exact normalized source projections. The minimal Error transport adapter does not qualify the full manager/ABI.','Map10 decoder covers only its five present INIBIN types; Troy dependencies are identified by exact raw fields and current document, without qualifying complete provider/alias resolution.','31WEMs match original DIDX/DATA and31existing WAVs decode correctly, but WEM-to-WAV conversion, native mixer/loops, current Bevy device and listening are not requalified.','Future validator tasks remain a_faire and are not accepted by these source/current-consumer links.'],'original_provider_dependency_resolution_qualified':False,'historical_game_process_launched':False,'current_production_Rust_or_C_changed':False,'all_Goal_requirements_completed':False,'human_acceptance':'not_given'}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args()
 try:d=audit(a.evidence_root)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 pathlib.Path(a.output).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'verified':True,'counts':d['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
