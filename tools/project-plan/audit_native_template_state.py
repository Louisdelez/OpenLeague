"""Read-only reference consumer of original template lifetime/state evidence."""
import argparse,hashlib,json,pathlib,struct
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def require(ok,message):
 if not ok:raise ValueError(message)
STRINGS=[0xf0,0x108,0x120,0x140,0x158,0x170,0x188,0x1a0]
CLEAR={0x140,0x158,0x170,0x188}
def audit(evidence_root,empty_override=None,state_override=None):
 v=pathlib.Path(evidence_root).resolve();empty=load(v/'template-empty-lifecycle.json') if empty_override is None else empty_override;state=load(v/'template-state-controls.json') if state_override is None else state_override
 execution=[load(v/(n+'-execution.json')) for n in ['template-empty-lifecycle','template-state-controls']]
 require(empty['schema']=='openleague_original_template_empty_lifecycle/v1' and state['schema']=='openleague_original_template_state_controls/v1','Wrong template evidence schema')
 for data,receipt,flag in zip([empty,state],execution,['template_resource_loading_or_nonempty_retirement_qualified','resource_loading_nonempty_group_retirement_or_nonnull_notifications_qualified'],strict=True):
  require(data['execution_completed'] is True and type(receipt['exit_code']) is int and receipt['exit_code']==0,'Native experiment incomplete')
  require(data['invalid_access']==[] and data['heap_remaining']=={},'Native fault or guest allocation leak')
  require(data['historical_OS_process_launched'] is False and data[flag] is False,'Overbroad template/resource/runtime claim')
 require(empty['binary']==state['binary'] and empty['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong original game binary')
 require(len(empty['declared_boundaries'])==4 and len(state['boundaries'])==3,'Missing lifetime boundaries')
 require(len(empty['cases'])==2 and [c['allocation_fill_byte'] for c in empty['cases']]==[0,0xa5] and all(type(c['allocation_fill_byte']) is int for c in empty['cases']),'Wrong zero/poison profiles')
 snapshots=[];object_pointers=set()
 defaults={0:0x10d6b90,4:0x41094000,8:0,0x138:0,0x1b8:0xffffffff,0x1bc:0,0x1c0:0,0x1c4:0,0x1c8:0,0x1cc:0,0x1d0:0xbf800000}
 for c in empty['cases']:
  pointer=int(c['constructed_pointer'],16);require(0x44000000<=pointer<0x45000000 and pointer not in object_pointers,'Invalid/duplicate native object pointer');object_pointers.add(pointer)
  b=bytes.fromhex(c['snapshot_after_constructor_hex']);require(len(b)==0x1d8 and bytes.fromhex(c['snapshot_after_second_reset_hex'])==b and c['second_empty_reset_identical'] is True,'Wrong constructed/reset snapshot')
  require(all(struct.unpack_from('<I',b,k)[0]==value for k,value in defaults.items()),'Native constructor initialized-word mismatch')
  require(b[0x1d4]==0 and struct.unpack_from('<I',b,0x13c)[0]==(0 if c['allocation_fill_byte']==0 else 0xa5a5a5a5),'False assumption about whole-object/default initialization')
  require(c['original_string_defaults']==[{'offset':hex(off),'value':'','length':0,'capacity':15} for off in STRINGS],'Wrong empty string metadata')
  require(all(type(s['length']) is int and type(s['capacity']) is int for s in c['original_string_defaults']),'Noninteger native string size/capacity')
  require(all(b[off]==0 and struct.unpack_from('<II',b,off+16)==(0,15) for off in STRINGS),'Raw SSO bytes differ from reported defaults')
  require(c['original_deleting_dtor']=='0x918620' and type(c['remaining_guest_allocations']) is int and c['remaining_guest_allocations']==0 and c['callback_is_supplied_empty_secondary_interface'] is True,'Wrong destructor or receiver scope')
  snapshots.append(b)
 diff=[i for i,(a,b) in enumerate(zip(*snapshots,strict=True)) if a!=b];spans=[]
 for p in diff:
  if spans and spans[-1][1]==p:spans[-1][1]+=1
  else:spans.append([p,p+1])
 comparison=load(v/'template-constructor-fill-comparison.json')
 require(len(diff)==151 and all(snapshots[0][i]==0 and snapshots[1][i]==0xa5 for i in diff),'Unexpected input-fill dependence')
 require(comparison['bytes_compared']==472 and comparison['bytes_dependent_on_initial_fill']==151 and comparison['different_spans']==[[hex(a),hex(b)] for a,b in spans] and comparison['not_all_object_bytes_initialized'] is True and comparison['padding_or_inactive_array_semantics_not_inferred'] is True and comparison['resource_loading_qualified'] is False,'Fill-dependence report mismatch/overclaim')
 require(len(state['cases'])==6 and [c['profile'] for c in state['cases'][:2]]==['all_long_strings','mixed_SSO_and_heap_strings'],'Wrong populated-string control profiles')
 for c in state['cases'][:2]:
  require(c['particle_group_collections_were_empty'] is True and type(c['live_allocations_before_reset']) is int and c['live_allocations_before_reset']>1 and type(c['live_allocations_after_reset']) is int and c['live_allocations_after_reset']==c['live_allocations_before_reset'] and type(c['live_allocations_after_deleting_dtor']) is int and c['live_allocations_after_deleting_dtor']==0,'Reset/dtor allocation scope mismatch')
  require(len(c['assigned'])==len(c['after_reset'])==8,'Incomplete string control')
  for index,(off,a,b) in enumerate(zip(STRINGS,c['assigned'],c['after_reset'],strict=True)):
   assigned=('field'+str(index)) if c['profile'].startswith('mixed') and index%2==0 else 'OpenLeague_ControlledReference_NotHistorical_'+str(index)+'_long_string'
   require(a['text']==assigned,'Controlled input string does not match its declared profile')
   expected='' if off in CLEAR else a['text'];require(a['offset']==b['offset']==hex(off) and b['expected']==b['observed']==expected,'Wrong reset clear/retain string behavior')
   require(type(a['capacity_before_reset']) is int and a['capacity_before_reset']>=len(a['text']) and b['capacity_after_reset']==a['capacity_before_reset'] and b['data_pointer_after_reset']==a['data_pointer_before_reset'],'Reset capacity/pointer retention mismatch')
 require([(c['entry'],c['name']) for c in state['cases'][2:]]==[(hex(entry),name) for entry in [0x92dd90,0x92ddb0] for name in ['', 'DATA/Particles/ControlledReference.troy']],'Wrong optional-callback cases')
 require(all(type(c['optional_callback_pointer']) is int and c['optional_callback_pointer']==0 and c['receiver_unchanged'] is True and c['native_return_stack_verified'] is True for c in state['cases'][2:]),'Nonnull/unverified notification wrongly qualified')
 pcsets=[{int(p,16) for p in data['original_PCs']} for data in [empty,state]]
 require(all({0x918490,0x9187a0,0x918660,0x918620}<=p for p in pcsets) and {0x92dd90,0x92ddb0}<=pcsets[1] and not any(0x918b30 in p or 0x918e90 in p for p in pcsets),'Incorrect native lifecycle/loading PC scope')
 for data,receipt in zip([empty,state],execution,strict=True):
  last=json.loads(pathlib.Path(receipt['log']['path']).read_text('utf-8').strip().splitlines()[-1]);require(last['completed'] is True and last['error'] is None and last['cases']==len(data['cases']) and last['instructions']==data['original_instructions'] and last['PCs']==len(data['original_PCs']) and last['faults']==last['heap_remaining']==0,'Terminal log does not corroborate observations')
 pins=[empty['binary'],empty['producer'],empty['VM'],empty['source'],state['producer'],* [e['log'] for e in execution]]
 for name in ['template-empty-lifecycle.json','template-empty-lifecycle-execution.json','template-state-controls.json','template-state-controls-execution.json','template-constructor-fill-comparison.json','loader-backend-source.json']:pins.append(pin(v/name))
 for p in [v.parent/'revision30/probe_original_graph_owner.py',v.parent/'revision29/probe_original_graph_predicate.py',v.parent/'revision29/graph_predicate_model.py',pathlib.Path('E:/mapslol3v3/champion_critical_blnd_graph_static_source_audit/bounded_blnd_type1_reader.py')]:pins.append(pin(p))
 roots=[pathlib.Path(p).resolve() for p in ['E:/OpenLeague','E:/mapslol3v3','D:/LeagueOfLegendsV2/4.20']];unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins}
 for identity in unique.values():require(any(pathlib.Path(identity['path']).resolve().is_relative_to(root) for root in roots),'Reference outside declared roots');require(pin(identity['path'])==identity,'Changed lifecycle reference')
 return {'schema':'openleague_template_state_reference_audit/v1','counts':{'zero_and_poison_cases':2,'populated_string_cases':2,'null_notification_cases':4,'input_fill_dependent_bytes':151,'native_instruction_hooks':sum(d['original_instructions'] for d in [empty,state]),'distinct_original_PCs':len(pcsets[0]|pcsets[1]),'fresh_source_files':len(unique)},'initialized_words':{hex(k):hex(v) for k,v in defaults.items()},'empty_SSO_string_offsets':[hex(p) for p in STRINGS],'reset_clear_offsets':[hex(p) for p in sorted(CLEAR)],'reset_retain_offsets':[hex(p) for p in STRINGS if p not in CLEAR],'input_fill_dependent_spans':[[hex(a),hex(b)] for a,b in spans],'source_identities':list(unique.values()),'original_game_binary':empty['binary'],'declared_boundaries':empty['declared_boundaries']+state['boundaries'],'native_executions':[pin(v/(n+'-execution.json')) for n in ['template-empty-lifecycle','template-state-controls']],'full_constructor_bytes_initialized':False,'resource_loading_nonempty_groups_or_nonnull_callbacks_qualified':False,'all_Goal_objectives_completed':False}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args();out=pathlib.Path(a.output)
 if out.exists():raise ValueError('Preserve previous output')
 result=audit(a.evidence_root);out.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']))
if __name__=='__main__':main()
