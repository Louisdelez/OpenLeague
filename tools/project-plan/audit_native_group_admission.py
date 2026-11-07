"""Read-only source/observation consumer for native group admission.

Original resources, constructed branch fixtures and supplied manager flags are
kept distinct. Neither a historical EUW flag nor full template loading is proved.
"""
import argparse,ast,collections,hashlib,json,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');ROOTS=[R.resolve(),pathlib.Path('E:/mapslol3v3').resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
class EvidenceError(ValueError):pass
def require(v,message):
 if not v:raise EvidenceError(message)
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def integer(x,minimum=0):return type(x) is int and x>=minimum
def pin(p):
 p=pathlib.Path(p).resolve();require(any(p.is_relative_to(r) for r in ROOTS),'Source outside allowed roots');require(p.is_file(),'Source missing');b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}

def audit(evidence_root,native_override=None,inputs_override=None,fixtures_override=None,flag_override=None):
 v=pathlib.Path(evidence_root).resolve();require(v.is_relative_to(ROOTS[1]),'Evidence root outside workspace');sys.path[:0]=[str(R/'tools/pythonlibs'),str(v.parent)]
 import pefile
 from reference_inibin import decode,hashkey
 inputs=inputs_override if inputs_override is not None else load(v/'group-admission-inputs.json')
 fixtures=fixtures_override if fixtures_override is not None else load(v/'admission-contract-fixtures.json')
 native=native_override if native_override is not None else load(v/'original-group-admission.json')
 access=flag_override if flag_override is not None else load(v/'original-censor-flag-access.json')
 source=load(v/'template-group-admission-source.json');sources={}
 def identity(p):
  require(isinstance(p,dict) and set(p)=={'path','bytes','sha256'} and integer(p['bytes']) and isinstance(p['sha256'],str),'Invalid identity')
  require(pin(p['path'])==p,'Source identity changed');sources[str(pathlib.Path(p['path']).resolve()).casefold()]=p;return p
 for obj,keys in [(inputs,['producer','reader','source_inputs','native_source']),(fixtures,['producer','reader']),(native,['producer','pilot_consumer','Troy_leaf','binary','inputs','fixtures']),(access,['producer','VM','binary','source']),(source,['binary','producer'])]:
  for key in keys:identity(obj[key])
 require(native['binary']==access['binary']==source['binary'],'Divergent original binary')
 require(native['inputs']==pin(v/'group-admission-inputs.json') and native['fixtures']==pin(v/'admission-contract-fixtures.json') and inputs['native_source']==access['source']==pin(v/'template-group-admission-source.json'),'Wrong input/source provenance')
 for obj in [native,access]:
  tree=ast.parse(pathlib.Path(obj['producer']['path']).read_text('utf-8'));limits=[ast.literal_eval(k.value) for n in ast.walk(tree) if isinstance(n,ast.Call) for k in n.keywords if k.arg=='declared_boundaries'];require(len(limits)==1 and obj['declared_boundaries']==limits[0],'Native boundary declarations changed')
 require(native['execution_completed'] is True and native['historical_OS_process_launched'] is False and native['full_template_loading_or_historical_censor_context_qualified'] is False and type(native['invalid_access']) is list and native['invalid_access']==[],'Native run incomplete/faulted or scope promoted')
 require(access['execution_completed'] is True and access['historical_OS_process_launched'] is False and access['historical_manager_initialization_or_EUW_flag_qualified'] is False and type(access['invalid_access']) is list and access['invalid_access']==[] and type(access['heap_remaining']) is dict and access['heap_remaining']=={},'Flag run incomplete/faulted or historical state promoted')
 pe=pefile.PE(native['binary']['path']);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
 require(im[0x92c9d0-base:0x92c9d7-base].hex()=='8a8155030000c3','Getter is not the original secondary355 byte read')
 require(im[0x918e5d-base:0x918e60-base]==im[0x918e8c-base:0x918e8f-base]==b'\xc2\x08\x00','Admission callee-pop8 ABI changed')
 require(struct.unpack_from('<I',im,0x10d6e74-base+0x68)[0]==0x92c9d0,'Wrong secondary callback slot68')
 for address,text in [(0x10d7db8,b'e-disabled\0'),(0x10d7d6c,b'e-censor-policy\0')]:require(im[address-base:address-base+len(text)]==text,'Wrong native admission literal')
 executable=[(base+s.VirtualAddress,base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)) for s in pe.sections if s.Characteristics&0x20000000]
 for obj in [native,access]:
  pcs=obj['original_PCs'];require(len(pcs)==len(set(pcs)) and all(isinstance(p,str) and hex(int(p,16))==p and any(a<=int(p,16)<b for a,b in executable) for p in pcs),'Invalid native PC set')
 require({'0x918d50','0x92c9d0','0x8b0630','0x8b1a80','0x8afc30','0x8acef0','0x8ad5b0','0x918e71','0x918e5d','0x918e8c'}<=set(native['original_PCs']),'Required original admission/cache/getter/branch PCs missing')
 require(not {'0x918b30','0x918e90'}&set(native['original_PCs']),'Whole template load outside declared scope')
 require(inputs['historical_manager_flag_or_namespace_priority_inferred'] is False and not inputs['refused_payloads'] and len(inputs['rows'])==len(native['rows'])==689,'Wrong real corpus scope')
 previous=load(inputs['source_inputs']['path']);require([r['source'] for r in inputs['rows']]==[r['source'] for r in previous['rows']],'Different original candidate corpus')
 counts=collections.Counter();policies=collections.Counter();disabled_values=collections.Counter();callbacks=diagnostics=0
 def check_stream(row,identity_value,logical,backend):
  require(len(row['opened'])==len(row['read_streams'])==1 and row['isolated_cache_reset'] is True and integer(row['instructions'],1),'Wrong stream/cache scope')
  a,b=row['opened'][0],row['read_streams'][0];p=pathlib.Path(identity_value['path'])
  require(a['physical']==str(p) and a['logical']==logical+'bin' and a['mode']=='rb' and integer(a['backend']) and a['backend']==backend and a['bytes']==identity_value['bytes'] and a['sha256']==identity_value['sha256'],'Wrong opened source')
  require(b['physical']==str(p) and b['logical']==logical+'bin' and integer(b['backend']) and b['backend']==backend and b['closed'] is True and integer(b['position']) and b['position']==identity_value['bytes'],'Wrong read/close lifetime')
  offset=0
  for r in b['reads']:
   require(all(integer(r[k]) for k in ['offset','item_size','count','bytes']) and r['offset']==offset and r['bytes']==r['item_size']*r['count'],'Wrong original stream read sequence');offset+=r['bytes']
  require(offset==identity_value['bytes'],'Original parser did not consume whole payload')
 def decision(case,section,disabled,policy,flag):
  nonlocal callbacks,diagnostics
  expected=int(not disabled and (policy==0 or policy==1 and flag==0 or policy==2 and flag!=0))
  require(case['section']==section and type(case['supplied_flag']) is int and case['supplied_flag']==flag and type(case['disabled_effective']) is int and case['disabled_effective']==disabled and type(case['censor_policy_effective']) is int and case['censor_policy_effective']==policy,'Wrong explicit admission input')
  require(type(case['observed']) is int and type(case['expected']) is int and case['observed']==case['expected']==expected,'Wrong original admission decision')
  require(len(case['callback_calls'])==int(not disabled),'Wrong disabled-to-callback gate')
  for c in case['callback_calls']:require(type(c['flag_at_receiver_plus355']) is int and c=={'receiver':'0x40009000','flag_at_receiver_plus355':flag},'Wrong secondary receiver/flag')
  expected_diagnostic=int(not disabled and policy not in [0,1,2]);require(case['invalid_policy_diagnostics']==[{'callsite':'0x918e71','phase':'group_admission'}]*expected_diagnostic,'Wrong invalid-policy diagnostic branch')
  callbacks+=len(case['callback_calls']);diagnostics+=expected_diagnostic;return expected
 for static,observed in zip(inputs['rows'],native['rows'],strict=True):
  src=identity(static['source']);require(observed['source']==src,'Wrong real native source');p=pathlib.Path(src['path']);raw=decode(p.read_bytes());logical=p.relative_to(pathlib.Path(native['binary']['path']).parent/'DATA').as_posix()[:-3]
  require(static['logical_relative_to_DATA']==observed['logical']==logical and static['total_decoded_keys']==len(raw),'Wrong real logical/key count');check_stream(observed,src,logical,0)
  slots=[];groups=[];seen=set()
  for slot in range(1,len(raw)+10):
   key=hashkey('System','GroupPart'+str(slot));require(key not in seen,'Group hash collision');seen.add(key);value=raw.get(key,'-NONE-');require(isinstance(value,str) and value.isascii() and value and '\0' not in value and not any(c.isspace() for c in value) and len(value)<=240,'Unqualified group token')
   skip='-NONE-' in value;slots.append({'slot':slot,'key':key,'present':key in raw,'name':value,'sentinel_substring_present':skip})
   if skip:
    if slot>=9:break
    continue
   fields=[]
   for name in ['e-disabled','e-censor-policy']:
    k=hashkey(value,name);effective=raw.get(k,0);require(type(effective) is int and (name!='e-disabled' or effective in [0,1]),'Unsupported authored admission field');fields.append({'field':name,'key':k,'present':k in raw,'raw_value':raw.get(k),'effective_value':effective})
   groups.append({'slot':slot,'section':value,'fields':fields});counts['groups']+=1;disabled_values[str(fields[0]['effective_value'])]+=1;policies[str(fields[1]['effective_value'])]+=1
  else:raise EvidenceError('No original-profile slot termination')
  require(all(type(s['slot']) is int and type(s['present']) is bool and type(s['sentinel_substring_present']) is bool for s in static['group_slots']),'Invalid static group-slot types')
  require(all(type(g['slot']) is int and all(type(f['present']) is bool and type(f['effective_value']) is int and (f['raw_value'] is None or type(f['raw_value']) is int) for f in g['fields']) for g in static['groups']),'Invalid static admission-field types')
  require(static['group_slots']==slots and static['groups']==groups,'Static group fields differ from exact payload')
  require(len(observed['slots'])==len(slots) and all(type(o['slot']) is int and o=={'slot':s['slot'],'expected':s['name'],'observed':s['name']} for s,o in zip(slots,observed['slots'],strict=True)),'Wrong native group slot outputs')
  require(len(observed['cases'])==2*len(groups),'Wrong real admission case count')
  for index,group in enumerate(groups):
   for flag in [0,1]:
    c=observed['cases'][index*2+flag];require(type(c['slot']) is int and c['slot']==group['slot'],'Wrong original group slot');counts['real_admitted' if decision(c,group['section'],group['fields'][0]['effective_value'],group['fields'][1]['effective_value'],flag) else 'real_rejected']+=1
  counts['real_group_slots']+=len(slots)
 require(inputs['counts']=={'payloads':689,'refused':0,'groups':1575,'group_slots_including_terminators':6396,'disabled_values':dict(disabled_values),'censor_policy_values':dict(policies)},'Wrong real inventory counts')
 require(fixtures['fixtures']==len(fixtures['rows'])==len(native['fixture_rows'])==21 and fixtures['historical_payloads_replaced'] is False and fixtures['historical_state_inferred'] is False,'Local fixtures promoted into original resources')
 pairs=[(d,p) for d in [None,0,1] for p in [None,0,1,2,3,-1,255]]
 for static,observed,(disabled,policy) in zip(fixtures['rows'],native['fixture_rows'],pairs,strict=True):
  src=identity(static['source']);require(observed['source']==src and static['historical_payload'] is observed['historical_payload'] is False,'Wrong local fixture provenance')
  require(static['origin']=='locally_constructed_INIBIN_v2_branch_fixture_not_historical_resource' and static['section']=='FixtureGroup' and type(static['disabled_authored']) is type(disabled) and static['disabled_authored']==disabled and type(static['censor_policy_authored']) is type(policy) and static['censor_policy_authored']==policy,'Wrong fixture field profile')
  raw=decode(pathlib.Path(src['path']).read_bytes());require(raw=={hashkey('FixtureGroup',k):value for k,value in [('e-disabled',disabled),('e-censor-policy',policy)] if value is not None},'Fixture bytes differ from explicit contract')
  logical=pathlib.Path(src['path']).relative_to(v/'fixtures').as_posix()[:-3];require(static['logical']==observed['logical']==logical,'Wrong fixture logical path');check_stream(observed,src,logical,1);require(len(observed['cases'])==2,'Wrong fixture cases')
  for flag,c in enumerate(observed['cases']):counts['fixture_admitted' if decision(c,'FixtureGroup',disabled or 0,policy or 0,flag) else 'fixture_rejected']+=1
 require(integer(native['real_group_slots']) and native['real_group_slots']==counts['real_group_slots']==6396 and integer(native['real_admission_cases']) and native['real_admission_cases']==3150 and integer(native['local_fixture_cases']) and native['local_fixture_cases']==42,'Wrong native aggregate counts')
 require(integer(native['original_callback_calls']) and native['original_callback_calls']==callbacks and integer(native['invalid_policy_diagnostic_calls']) and native['invalid_policy_diagnostic_calls']==diagnostics,'Wrong callback/diagnostic counts')
 require(integer(native['original_instructions'],1) and native['original_instructions']==sum(r['instructions'] for r in native['rows']+native['fixture_rows']),'Wrong native instruction count')
 require(len(access['cases'])==16 and integer(access['original_instructions'],1) and {'0x92c9e0','0x92c9d0'}<=set(access['original_PCs']),'Wrong flag-access coverage')
 for c,(old,value) in zip(access['cases'],[(a,b) for a in [0,1,7,255] for b in [0,1,7,255]],strict=True):
  require(type(c['old_byte']) is int and c['old_byte']==old and type(c['supplied_new_byte']) is int and c['supplied_new_byte']==value,'Wrong flag-access input profile')
  require(c['primary']=='0x41080000' and c['secondary']=='0x41080004' and int(c['secondary'],16)==int(c['primary'],16)+4 and c['only_primary359_changed'] is True and c['getter_preserved_storage'] is True,'Wrong flag-access receiver/storage scope')
  require(all(type(c[k]) is int for k in ['expected_changed','observed_changed','expected_getter','observed_getter']) and c['expected_changed']==c['observed_changed']==int(old!=value) and c['expected_getter']==c['observed_getter']==value,'Wrong original byte setter/getter behavior')
 executions=[]
 for name,obj in [('original-group-admission',native),('original-censor-flag-access',access)]:
  e=load(v/(name+'-execution.json'));require(e['exit_code']==0 and e['cwd']=='E:/OpenLeague' and obj['producer']['path'] in e['command'],'Wrong native execution receipt');identity(e['log']);text=pathlib.Path(e['log']['path']).read_text('utf-8');require('"completed": true' in text and '"faults": 0' in text,'Native execution log differs');identity(pin(v/(name+'.json')));identity(pin(v/(name+'-execution.json')));executions.append(pin(v/(name+'-execution.json')))
 for rel in ['tools/project-plan/original_config_cache_reference.py','tools/project-plan/original_config_reader_reference.py','tools/project-plan/original_directory_reference.py','tools/project-plan/original_skin_provider_reference.py','tools/project-plan/native_skin_loader_reference.py']:identity(pin(R/rel))
 identity(pin(v/'execute_group_admission.py'));identity(pin(v.parent/'reference_inibin.py'))
 current=[]
 for e in source['existing_class_reference_evidence']:identity(e['source'])
 path='crates/client/src/native_particle_class.rs';needle='pub fn from_system(system: &Value, slot: usize) -> Result<Self, String> {';text=(R/path).read_text('utf-8');require(text.count(needle)==1,'Existing Rust class consumer missing/ambiguous')
 current.append({'path':path,'needle':needle,'source':pin(R/path),'scope':'Existing Simple/Complex class selector only. It consumes GroupPartNType;this anchor does not establish admission/censor wiring or runtime acceptance.','runtime_or_Rust_tests_executed_this_turn':False})
 return {'schema':'openleague_native_group_admission_audit/v1','passed':True,'counts':{'real_payloads':689,'real_groups':1575,'real_group_slot_queries':6396,'real_admission_cases':3150,'real_admitted':counts['real_admitted'],'real_rejected':counts['real_rejected'],'local_fixture_payloads':21,'local_fixture_cases':42,'local_fixture_admitted':counts['fixture_admitted'],'local_fixture_rejected':counts['fixture_rejected'],'flag_access_cases':16,'native_callback_calls':callbacks,'invalid_policy_diagnostic_calls':diagnostics,'native_instructions':native['original_instructions'],'native_PCs':len(native['original_PCs']),'flag_access_instructions':access['original_instructions'],'flag_access_PCs':len(access['original_PCs']),'source_identities':len(sources)},'source_identities':list(sources.values()),'native_executions':executions,'current_consumer_evidence':current,'historical_EUW_flag_or_full_template_loading_qualified':False,'current_Rust_admission_wiring_or_game_acceptance_qualified':False,'declared_boundaries':native['declared_boundaries']+access['declared_boundaries']}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');a=p.parse_args()
 try:r=audit(a.evidence_root)
 except (EvidenceError,OSError,ValueError,KeyError,IndexError,TypeError,struct.error) as e:print(json.dumps({'passed':False,'error':str(e)}));return 1
 if a.output:pathlib.Path(a.output).write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'passed':True,'counts':r['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
