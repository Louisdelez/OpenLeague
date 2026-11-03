"""Read bounded mastery/native resource research without inventing rank authority."""
import argparse,hashlib,json,pathlib,sys
R=pathlib.Path('E:/OpenLeague')
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def need(v,msg):
 if not v:raise ValueError(msg)
def audit(inputs,verify_files=True):
 d=load(inputs) if isinstance(inputs,(str,pathlib.Path)) else inputs
 need(d['schema']=='openleague_mastery_native_resource_research_inputs/v1' and d['passed'] is True,'Wrong schema or failed observation')
 for k in ['original_instruction_execution_this_revision','historical_or_current_game_launched','native_Ranks_reader_qualified','effective_rank_caps_resolved','historical_cap_payload_recovered','global_consumer_absence_proven','current_game_mastery_cap_consumer_qualified','manual_state_mutated']:
  need(d[k] is False,'Unsupported scope claim: '+k)
 need(d['questions_closed']==0 and d['human_acceptance']=='not_given' and d['remaining_question'],'Invented closure/acceptance or lost remaining condition')
 by={str(pathlib.Path(s['path']).resolve()).casefold():s for s in d['source_identities']};need(len(by)==len(d['source_identities']),'Duplicate source')
 roots=[R,pathlib.Path('E:/mapslol3v3'),pathlib.Path('D:/LeagueOfLegendsV2/4.20')]
 for s in by.values():
  p=pathlib.Path(s['path']).resolve();need(any(p.is_relative_to(r.resolve()) for r in roots),'Source outside explicit roots')
  if verify_files:need(pin(p)==s,'Source identity changed: '+str(p))
 for s in [d['producer'],d['reference'],d['previous_delivery'],d['binary'],d['catalogue']]:need(by.get(str(pathlib.Path(s['path']).resolve()).casefold())==s,'Source role rebound')
 need(d['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong historical game PE')
 for key,x in d['research'].items():
  need(load(x['source']['path'])==x['observation'],'Research observation not exact artifact: '+key)
  need(x['observation']['binary']==d['binary'],'Research binary rebound')
 exact=d['research']['exact_rank']['observation'];need(exact['rank_field']['hash_hex']=='0xeab0ddaf' and exact['counts']['raw_candidates']==0,'Exact rank search changed')
 hashes=d['research']['strings']['observation']['hash_controls'];need(len(hashes)==7 and all(not h['raw_byte_matches'] for h in hashes),'Zero negative-search controls changed')
 need(any(x['text']=='Data/Talents' for x in d['research']['strings']['observation']['strings']),'Native directory literal missing')
 windows=d['research']['windows']['observation']['windows'];need({x['start'] for x in windows}=={'0x90b950','0x905090','0x905620','0x607640'} and all(x['full_control_flow_qualified'] is False for x in windows),'Bounded window promoted to full control flow')
 if verify_files:
  sys.path.insert(0,str(R/'tools/pythonlibs'));import pefile
  raw=pathlib.Path(d['binary']['path']).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
  for w in windows:
   off=pe.get_offset_from_rva(int(w['start'],16)-base);need(hashlib.sha256(raw[off:off+w['bytes']]).hexdigest()==w['sha256'],'Native window bytes changed')
 probe=load(d['current_alias_probe']['source']['path']);need(probe==d['current_alias_probe']['observed'],'Current alias observation changed')
 need(probe['passed'] and probe['cases_count']==len(probe['cases'])==13 and all(c['expected']==c['observed'] for c in probe['cases']),'Current alias cases failed/incomplete')
 for k in ['payload_IO_executed','INIBIN_or_Lua_payload_parsed','original_instructions_executed','historical_or_current_game_launched','effective_rank_cap_qualified']:need(probe[k] is False,'Filename lookup promoted to payload/rank authority')
 prefix=pathlib.Path(probe['source']['path']).read_text().split('#[cfg(test)]',1)[0]
 need(hashlib.sha256(prefix.encode()).hexdigest()==probe['exact_prefix']['sha256'] and pathlib.Path(probe['generated_source']['path']).read_text().startswith(prefix),'Compiled provider prefix not exact current source')
 if verify_files:need(pin(probe['compiler']['path'])==probe['compiler'],'Current host compiler changed')
 rows=d['native_mastery_rows'];need([r['id'] for r in rows]==['4312','4313'],'Wrong mastery identity set')
 for r in rows:
  need(r['native_Ranks']==4 and r['catalogue_ranks']==3 and r['effective_historical_Talent_maxRank'] is None and r['comparison_resolution']=='open' and r['historical_payload_recovered'] is False and r['current_game_cap_consumer_qualified'] is False,'Rank observations promoted to effective cap')
 need(len(d['native_membership'])==4 and all(x['status']=='matches_selected_project_manifest' for x in d['native_membership']),'Native mastery membership missing')
 need(len(d['inherited_resource_qualifications'])==3 and all(x['reexecuted'] is False for x in d['inherited_resource_qualifications']),'Inherited resource probes replayed or missing')
 air=d['inherited_AIR_authority'];need(air['reexecuted'] is False and air['qualification']['passed'] and air['qualification']['checks_count']==19,'Inherited AIR authority requalified or changed')
 need(d['checks_count']==len(d['checks'])==25 and all(c['result']=='pass' for c in d['checks']),'Source observation controls incomplete')
 return dict(verified=True,source_hashes_verified=len(by) if verify_files else 0,current_alias_cases=13,bounded_native_windows=4,
  inherited_AIR_checks_not_reexecuted=19,original_rank_caps_resolved=False,native_Ranks_reader_qualified=False,open_comparisons=2,manual_state_mutated=False)
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--output');a=p.parse_args()
 try:r=audit(a.inputs)
 except (ValueError,OSError,KeyError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));raise SystemExit(1)
 if a.output:
  out=pathlib.Path(a.output);need(not out.exists(),'Preserve previous output');out.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
 print(json.dumps(r))
