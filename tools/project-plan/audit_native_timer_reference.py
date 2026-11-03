"""Readonly verifier of original timer observations, byte identities and declared boundaries."""
import argparse,copy,hashlib,itertools,json,math,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3');sys.path.insert(0,str(R/'tools/pythonlibs'))
import pefile,capstone
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
 if not ok:raise ValueError(why)
def f32(n):return struct.unpack('<f',struct.pack('<f',n))[0]
def sha(data):return hashlib.sha256(data).hexdigest()
def audit(evidence_root,inputs_override=None,rounding_override=None,prefix_override=None,body_override=None,clock_override=None,expiry_override=None,trace_override=None):
 v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
 inputs=load(v/'native-timer-inputs.json') if inputs_override is None else inputs_override
 need(inputs['schema']=='openleague_native_timer_inputs/v1','Wrong input schema')
 need(all(inputs[k] is False for k in ['historical_clock_or_event_producer_qualified','Lua_reference_ownership_or_actual_scheduler_callback_qualified','current_Rust_gameplay_executed']),'Unsupported whole/native/historical behavior claim')
 identities={};tool_ids={};cache={}
 def keep(x,tool=False):
  p=pathlib.Path(x['path']).resolve(strict=True);allowed=[R.resolve(),S.resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
  need(any(p.is_relative_to(a) for a in allowed) or tool and p==pathlib.Path(sys.executable).resolve(),'Source outside allowed roots')
  key=str(p).casefold()
  if key not in cache:cache[key]=pin(p)
  need(all(cache[key][k]==x[k] for k in ['bytes','sha256']),'Changed source identity');(tool_ids if tool else identities)[key]=x;return p
 for key in ['producer','reference','normalized_scope','trace_scope','binding_code','clock_reference_candidates','prior_delivery','prior_camp_comparison','prior_camp_reference','runtime_backend_inspection']:keep(inputs[key])
 for x in inputs['tools']:keep(x)
 reference=load(inputs['reference']['path']);need(reference['client']['version']=='4.20.0.315' and reference['client']['channel']=='PUBLIC' and reference['client']['branch']=='Releases/4.20' and reference['reference']['region']=='EUW' and reference['reference']['locale']=='en_GB','Wrong historical client')
 prior=load(inputs['prior_delivery']['path']);need(prior['delivery_audit']['passed'] and not prior['delivery_audit_pending'] and not prior['integration_pending'],'Unqualified prior delivery')
 overrides=[rounding_override,prefix_override,body_override,clock_override,expiry_override];kinds=['rounding','prefix','body','clock','expiry'];probes={}
 for kind,override in zip(kinds,overrides,strict=True):keep(inputs['probes'][kind]);probes[kind]=load(inputs['probes'][kind]['path']) if override is None else override
 r,p,b,c,e=[probes[k] for k in kinds]
 schemas=['openleague_original_timer_rounding_candidate/v1','openleague_original_neutral_timer_prefix/v1','openleague_original_neutral_timer_body/v1','openleague_original_clock_write_prefixes/v1','openleague_original_timer_expiry_prefix/v1']
 for kind,schema in zip(kinds,schemas,strict=True):
  record=probes[kind];need(record['schema']==schema,'Wrong original probe schema');source=keep(record['source']);keep(record['producer'])
  need(record['source']==r['source'],'Mixed original PE sources');runtime=record['runtime'];keep(runtime['python'],True);keep(runtime['unicorn_python_module']);keep(runtime['pefile_module'])
  need(runtime==r['runtime'] and runtime['unicorn_version']=='2.1.4' and len(runtime['backend_dll_candidates'])==1,'Wrong emulation runtime')
  for dll in runtime['backend_dll_candidates']:keep(dll)
 raw=source.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;need(base==0x400000 and sha(raw)==next(x['sha256'] for x in reference['sources'] if x['path']==reference['client']['binary']),'Wrong reference PE')
 backend=load(inputs['runtime_backend_inspection']['path']);need(backend['matches_probe_candidate_identity'] is True and len(backend['loaded_libraries'])==1 and backend['loaded_libraries'][0]['source']==r['runtime']['backend_dll_candidates'][0],'Runtime inspection mismatch')
 normalized=load(inputs['normalized_scope']['path']);keep(normalized['expiry_clarification']);clarification=load(normalized['expiry_clarification']['path']);need(clarification['previous_probe']==inputs['probes']['body'] and clarification['clarifying_probe']==inputs['probes']['expiry'] and clarification['whole_update_qualified'] is False,'Wrong field clarification lineage')
 need(normalized['raw_body_probe']==inputs['probes']['body'] and normalized['field_roles']=={'offset0':'elapsed accumulator in the tested expiry prefix','offset4':'duration threshold in the tested expiry prefix'} and normalized['raw_provisional_labels_preserved'] is True and normalized['native_Lua_ownership_or_whole_scheduler_qualified'] is False,'Unsupported field-role scope')
 need(r['entry_VA']==0xca5f30 and r['dispatch_global_VA']==0x2da52e8 and r['supplied_FPU_CW']==0x37f and r['supplied_MXCSR']==0x1f80 and r['cases_count']==len(r['cases'])==28,'Wrong rounding entry/state/count')
 need(r['local_adapter']=={'VA':0x32000000,'bytes':(b'\xdd\x1d'+struct.pack('<I',0x32000100)).hex(),'purpose':'Only stores original x87 result; adapter instructions separate from original PE.'},'Wrong local FSTP adapter')
 values=[-100.25,-1.5,-1.0,-0.25,-0.0,0.0,0.25,1.0,1.5,15.5,85.125,95.125,515.75,1000000.001]
 for case,(dispatch,value) in zip(r['cases'],itertools.product([0,1],values),strict=True):
  expected=float(math.ceil(value));signed=math.copysign(0.0,value) if expected==0 else expected
  need(case['supplied_dispatch_global']==dispatch and case['input_bits_le']==struct.pack('<d',value).hex() and case['input_double']==value,'Wrong rounding input profile')
  need(case['expected_finite_ceil_value']==expected and case['observed_double']==expected and case['observed_bits_le']==struct.pack('<d',signed).hex() and case['canary_preserved'] is True and case['invalid_accesses']==[] and case['stack_after']==0x31008004,'Changed finite rounding result/ABI/signed zero')
 need(all(r[k] is False for k in ['native_game_OS_process_launched','whole_timer_or_scheduler_executed','native_initial_clock_anchor_qualified','current_Rust_or_CSharp_gameplay_executed','integrated_into_registry']),'Rounding promoted into full timer acceptance')
 need(p['rounding_probe']==inputs['probes']['rounding'] and p['entry_VA']==0x6a6eaa and p['stop_before_VA']==0x6a6ef6 and p['cases_count']==len(p['cases'])==72 and p['all_expected_results_match'] is True,'Wrong arithmetic prefix scope')
 start=pe.get_offset_from_rva(p['entry_VA']-base);end=pe.get_offset_from_rva(p['stop_before_VA']-base);need(p['prefix_bytes']==end-start and p['prefix_sha256']==sha(raw[start:end]),'Changed original arithmetic prefix bytes')
 for case,(dispatch,epoch,current,delay) in zip(p['cases'],itertools.product([0,1],[-1.,0.,85.],[0.,85.125,100.,100.25],[15.,95.,515.]),strict=True):
  elapsed=0.0 if epoch<0 else f32(f32(current)-f32(epoch));expected=f32(math.ceil(elapsed)+f32(delay)-elapsed)
  need([case[k] for k in ['supplied_dispatch_global','supplied_epoch_float','supplied_clock_float','supplied_delay_float']]==[dispatch,epoch,current,delay] and case['supplied_clock_pointer_is_null'] is (epoch<0),'Wrong supplied prefix profile')
  need(case['expected_elapsed_float']==case['observed_elapsed_float']==elapsed and case['expected_first_pushed_float']==case['observed_first_pushed_float']==expected and case['observed_second_pushed_float']==0 and case['clock_object_read'] is (epoch>=0),'Changed prefix arithmetic/guard')
  need(case['invalid_accesses']==[] and case['stack_delta']==-8 and case['canary_preserved'] is True,'Changed prefix ABI/faults')
 need(all(p[k] is False for k in ['native_OS_game_process_launched','whole_timer_or_scheduler_executed','historical_epoch_or_initial_clock_anchor_qualified','current_Rust_or_CSharp_gameplay_executed','integrated_into_registry']),'Prefix promoted into historical clock/scheduler acceptance')
 need(b['prefix_probe']==inputs['probes']['prefix'] and b['entries']=={'timer':0x6a6e80,'pool_registration':0x6a6dc0,'actual_nil_predicate':0x48d260},'Wrong complete-body entries')
 layout={'base':0x2d5e1e8,'slots':64,'stride':0x48,'interval_offset':0,'countdown_offset':4,'repeat_offset':8,'active_offset':9,'callback_offset':0x28,'callback_size':32,'nil_type_offset_in_callback':0x10}
 need(b['pool_layout']==layout and b['cases_count']==len(b['cases'])==144 and b['all_expected_pool_results_match'] is True and b['original_nil_predicate_executed'] is True,'Wrong pool/layout/count')
 need(b['hooked_Lua_reference_boundaries']=={'copy_constructor':0x48d050,'assignment':0x48d100,'destructor':0x48d1d0} and b['supplied_ignored_string_pointer']==0xdeadbeef and b['supplied_extra_float_argument']==123.0,'Wrong declared opaque boundary/extra args')
 blob=bytearray(range(0x40,0x60));struct.pack_into('<I',blob,0x10,6);struct.pack_into('<I',blob,0x18,0x70707070);blob=bytes(blob);need(b['supplied_callback_bytes']==blob.hex(),'Wrong provided callback marker')
 for case,(dispatch,epoch,current,delay,repeat,slot) in zip(b['cases'],itertools.product([0,1],[-1.,85.],[100.,100.25],[50.,90.,300.],[False,True],[0,2,None]),strict=True):
  elapsed=0.0 if epoch<0 else f32(f32(current)-f32(epoch));duration=f32(math.ceil(elapsed)+delay-elapsed)
  need([case[k] for k in ['supplied_dispatch_global','supplied_epoch_float','supplied_clock_float','supplied_delay_float','supplied_first_nil_slot']]==[dispatch,epoch,current,delay,slot] and case['supplied_repeat_bool'] is repeat and case['supplied_callback_type_tag']==6,'Wrong full timer profile')
  before=bytearray(b'\xa7'*(64*0x48))
  for i in range(64):struct.pack_into('<I',before,i*0x48+0x28+0x10,0 if i==slot else 6)
  after=bytearray(before)
  if slot is not None:struct.pack_into('<ffBB',after,slot*0x48,0.0,duration,int(repeat),1);after[slot*0x48+0x28:slot*0x48+0x48]=blob
  need(case['before_pool_sha256']==sha(before) and case['after_pool_sha256']==case['expected_pool_sha256']==sha(after) and case['whole_pool_matches_expected'] is True,'Changed complete pool bytes/effect')
  need(case['expected_elapsed_float']==elapsed and case['expected_countdown_float']==duration and case['observed_slot_countdown_float']==(duration if slot is not None else None) and case['observed_registered_slot']==slot and case['predicate_slots']==list(range(64 if slot is None else slot+1)),'Changed actual nil scan/registered slot/float')
  calls=case['boundary_calls'];need([x['api'] for x in calls]==['opaque_Lua_reference_copy_constructor']+([] if slot is None else ['opaque_Lua_reference_assignment'])+['opaque_Lua_reference_destructor']*2,'Changed declared Lua-reference operation sequence')
  need(calls[0]['source']==0x31008004 and calls[0]['destination']==0x31007fc0 and calls[0]['bytes']==blob.hex() and calls[-2]['object']==0x31007fc0 and calls[-1]['object']==0x31008004,'Wrong provided callback copies/lifetimes')
  if slot is not None:need(calls[1]=={'api':'opaque_Lua_reference_assignment','source':0x31007fc0,'destination':0x2d5e1e8+slot*0x48+0x28,'bytes':blob.hex()},'Wrong slot assignment boundary')
  need(case['invalid_accesses']==[] and case['stack_delta']==4 and case['SEH_chain_restored'] is True and case['canary_preserved'] is True,'Full target ABI/SEH/fault violation')
 need(all(b[k] is False for k in ['actual_Lua_reference_ownership_qualified','scheduler_tick_or_callback_invocation_executed','historical_epoch_or_initial_clock_anchor_qualified','native_OS_game_process_launched','current_Rust_or_CSharp_gameplay_executed','integrated_into_registry']),'Opaque body promoted into actual ownership/scheduler acceptance')
 need(c['cases_count']==len(c['cases'])==13 and c['boundaries']=={'negative_epoch_guard':[0x593750,0x59376e],'field_payload_write':[0x5884cc,0x5884db]},'Wrong clock-write bounds/count')
 specs=[('negative_epoch_guard',0x593750,0x59376e,epoch,current) for epoch in [-1.,0.,85.] for current in [0.,85.,100.25]]+[('field_payload_write',0x5884cc,0x5884db,-1.,value) for value in [-1.,0.,85.,100.25]]
 for case,(role,entry,stop,epoch,value) in zip(c['cases'],specs,strict=True):
  expected=value if role=='field_payload_write' or epoch<0 else epoch
  need([case[k] for k in ['role','entry_VA','stop_before_VA','supplied_epoch_float','supplied_clock_or_payload_float']]==[role,entry,stop,epoch,value] and case['expected_epoch_float']==case['observed_epoch_float']==expected and case['invalid_accesses']==[],'Changed clock guard/payload write profile')
  need(case['supplied_clock_pointer_null'] is (epoch>=0) and case['field_payload_displacement']==(5 if role=='field_payload_write' else None),'Wrong bounded clock data source')
  if role=='negative_epoch_guard':need((0x593761 in case['executed_PCs']) is (epoch<0),'Wrong conditional current-clock read')
 need(all(c[k] is False for k in ['historical_epoch_value_or_message_identity_qualified','whole_clock_lifecycle_or_protocol_executed','native_OS_game_process_launched','integrated_into_registry']),'Bounded clock write promoted into historical protocol acceptance')
 need(e['timer_body_probe']==inputs['probes']['body'] and e['cases_count']==len(e['cases'])==64 and e['entry_VA']==0x593bf0 and e['stop_before_callback_preparation_VA']==0x593c8e and e['stop_before_other_timer_family_VA']==0x593d66,'Wrong expiry prefix scope')
 for case,(elapsed,delta,repeat,active) in zip(e['cases'],itertools.product([0.,9.75,10.,25.],[0.,.25,1.,25.],[False,True],[False,True]),strict=True):
  need(case['supplied_elapsed']==elapsed and case['supplied_duration']==10 and case['supplied_delta']==delta and case['supplied_repeat_bool'] is repeat and case['supplied_active_bool'] is active,'Wrong expiry profile')
  expired=active and f32(elapsed+delta)>=10;next_elapsed=f32(elapsed+delta) if active else elapsed
  if expired:next_elapsed=f32(next_elapsed-10)
  before=bytearray(b'\xa7'*(64*0x48))
  for i in range(64):before[i*0x48+9]=0
  struct.pack_into('<ffBB',before,0,elapsed,10.0,int(repeat),int(active));after=bytearray(before);struct.pack_into('<f',after,0,next_elapsed)
  if expired and not repeat:after[9]=0
  need(case['expected_expired'] is expired and case['observed_stop_before_VA']==(0x593c8e if expired else 0x593d66) and case['expected_elapsed_after_accounting']==case['observed_elapsed_after_accounting']==next_elapsed and case['observed_active_byte']==after[9],'Changed expiry/elapsed/duration/active behavior')
  need(case['before_pool_sha256']==sha(before) and case['after_pool_sha256']==case['expected_pool_sha256']==sha(after) and case['whole_pool_matches_expected'] is True and case['invalid_accesses']==[] and case['canary_preserved'] is True,'Changed expiry pool bytes/faults')
 need(all(e[k] is False for k in ['Lua_callback_preparation_or_execution_executed','whole_scheduler_update_executed','historical_clock_or_delta_source_qualified','native_OS_game_process_launched','integrated_into_registry']),'Expiry prefix promoted into whole update/callback acceptance')
 need(e['field_roles_observed']=={'offset0':'Elapsed accumulator: delta added when active, duration subtracted once before the first expiry callback boundary.','offset4':'Duration threshold used by the original comparison, not a remaining-countdown value.'},'Wrong clarified elapsed/duration field roles')
 trace=load(inputs['trace_scope']['path']) if trace_override is None else trace_override;need(trace['source']==r['source'] and trace['inherited_raw_receipts_changed'] is False,'Wrong trace/source scope');keep(trace['producer']);keep(trace['decoder'])
 by_pc={x['VA']:x for x in trace['original_PC_instructions']};need(len(by_pc)==len(trace['original_PC_instructions'])==283 and len(trace['profiles'])==321,'Wrong instruction/profile accounting')
 md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
 for address,row in by_pc.items():
  off=pe.get_offset_from_rva(address-base);ins=next(md.disasm(raw[off:off+15],address,count=1));need(row=={'VA':address,'file_offset':off,'bytes':bytes(ins.bytes).hex(),'mnemonic':ins.mnemonic,'operands':ins.op_str},'Changed original instruction identity')
 index=0;original_instruction_count=0
 for kind in kinds:
  for i,case in enumerate(probes[kind]['cases']):
   pcs=case['executed_PCs'];excluded={0x32000000} if kind=='rounding' else {0x48d050,0x48d100,0x48d1d0} if kind=='body' else {case['observed_stop_before_VA']} if kind=='expiry' else set()
   count=case.get('executed_instruction_count',len(pcs));removed=1 if kind in ['rounding','expiry'] else len(case['boundary_calls']) if kind=='body' else 0;row=trace['profiles'][index];index+=1
   need(row['probe']==kind and row['case_index']==i and row['recorded_code_hook_visits']==count and row['excluded_visits']==removed and row['original_instruction_count']==count-removed and row['excluded_PC_values']==sorted(set(pcs)&excluded),'Adapters/stopping hooks counted as original execution')
   need(all(pc in by_pc for pc in pcs if pc not in excluded) and count>=len(pcs) and count>removed,'Unsupported original code-trace addresses/count');original_instruction_count+=count-removed
 for key in ['prefix_probe','rounding_probe','timer_body_probe']:
  for record in probes.values():
   if key in record:keep(record[key])
 need(len(inputs['current_source_anchors'])==5 and len(inputs['community_source_anchors'])==6,'Missing actual source consumers')
 for a in inputs['current_source_anchors']+inputs['community_source_anchors']:
  lines=keep(a['source']).read_text('utf-8-sig').splitlines();need(lines[a['line']-1]==a['excerpt'] and a['needle'] in a['excerpt'] and sum(a['needle'] in line for line in lines)==1,'Changed actual current/community consumer')
 prior_comparison=load(inputs['prior_camp_comparison']['path']);keep(prior_comparison['probe']);native_camp_source=load(prior_comparison['probe']['path'])['source'];keep(native_camp_source);keep(prior_comparison['community_source'])
 return {'schema':'openleague_native_timer_reference_audit/v1','verified':True,'counts':{'inherited_numerical_and_arithmetic_profiles':100,'fresh_complete_timer_profiles':144,'fresh_clock_write_profiles':13,'fresh_expiry_profiles':64,'total_original_code_profiles':321,'timer_pool_slots':64,'original_PC_identities':283,'original_instruction_count_excluding_boundaries':original_instruction_count,'current_Rust_source_anchors':5,'community_source_anchors':6,'fully_qualified_community_scripts':0},
  'source_identities':list(identities.values()),'tool_identities':list(tool_ids.values()),'comparison':{'relative_timer_arithmetic':'ceil(elapsed)+delay-elapsed on supplied finite profiles','field0':'elapsed accumulator','field4':'duration threshold','historical_epoch_85_qualified':False},'current_consumer_evidence':inputs['current_source_anchors'],
  'candidate_scripts':[{'relative_path':'Maps/Map10/NeutralMinionSpawn.cs','source':prior_comparison['community_source'],'native_candidates':[native_camp_source['path']],'dispatch_qualified':False}],
  'inherited_native_experiments':[inputs['probes']['rounding'],inputs['probes']['prefix']],'fresh_native_experiments':[inputs['probes'][k] for k in ['body','clock','expiry']],'fresh_CSharp_component_experiments':[],
  'declared_boundaries':['Provided globals, pool, tags, stack/SEH/FPU states are explicit test inputs, not historical startup evidence.','Full timer/pool bodies use three declared opaque Lua-reference boundaries; actual Lua ownership and callback/event execution remain open.','Clock writes and expiry accounting stop before enclosing protocol/UI/virtual/callback continuation.','Offset0 is elapsed and offset4 duration in the observed expiry prefix; prior raw provisional labels and receipts remain unchanged.','Original instruction counts exclude local FSTP adapter, bypassed helper entry visits and pre-instruction stop visits.','Actual epoch/global initialization history, dispatcher/message identity, complete update/catch-up behavior and current Rust gameplay equivalence remain open.'],
  'native_engine_API_or_original_argument_producer_qualified':False,'current_Rust_or_CSharp_gameplay_qualified':False,'historical_game_process_launched':False}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');a=p.parse_args()
 try:result=audit(a.evidence_root)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 if a.output:pathlib.Path(a.output).write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'verified':True,'counts':result['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
