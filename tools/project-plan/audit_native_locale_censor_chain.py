"""Read-only conditional locale/config-to-censor source contract.

The provided loose default file remains unlisted in the selected manifests.
"""
import argparse,ast,hashlib,json,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');ROOTS=[R.resolve(),pathlib.Path('E:/mapslol3v3').resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
class EvidenceError(ValueError):pass
def require(v,message):
 if not v:raise EvidenceError(message)
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def integer(x):return type(x) is int and x>=0
def pin(p):
 p=pathlib.Path(p).resolve();require(any(p.is_relative_to(r) for r in ROOTS),'Source outside allowed roots');require(p.is_file(),'Source missing');b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def audit(evidence_root,span_override=None,reference_override=None,inputs_override=None):
 v=pathlib.Path(evidence_root).resolve();require(v.is_relative_to(ROOTS[1]),'Evidence root outside workspace');sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools/pythonlibs')]
 import pefile
 from rads_reference_membership import RadsReferenceMembership
 span=span_override if span_override is not None else load(v/'original-locale-censor-span.json');reference=reference_override if reference_override is not None else load(v/'original-locale-reference-chain.json');inputs=inputs_override if inputs_override is not None else load(v/'locale-origin-inputs-v2.json');sources={}
 def identity(p):
  require(isinstance(p,dict) and set(p)=={'path','bytes','sha256'} and integer(p['bytes']) and isinstance(p['sha256'],str),'Invalid source identity');actual=pin(p['path']);require(all(actual[k]==p[k] for k in ['bytes','sha256']) and str(pathlib.Path(actual['path']).resolve()).casefold()==str(pathlib.Path(p['path']).resolve()).casefold(),'Source identity changed');sources[str(pathlib.Path(p['path']).resolve()).casefold()]=p;return p
 for obj,keys in [(span,['binary','producer','VM','source']),(reference,['binary','producer','helper','inputs','source']),(inputs,['binary','producer','reference','locale_default'])]:
  for key in keys:identity(obj[key])
 require(span['binary']==reference['binary']==inputs['binary'],'Divergent native binary');require(reference['inputs']==pin(v/'locale-origin-inputs-v2.json') and span['source']==pin(v/'censor-locale-callsite-source.json'),'Wrong source/input provenance')
 for obj in [span,reference]:
  tree=ast.parse(pathlib.Path(obj['producer']['path']).read_text('utf-8'));limits=[ast.literal_eval(k.value) for n in ast.walk(tree) if isinstance(n,ast.Call) for k in n.keywords if k.arg=='declared_boundaries'];require(len(limits)==1 and obj['declared_boundaries']==limits[0],'Native boundaries changed')
  require(obj['execution_completed'] is True and obj['historical_OS_process_launched'] is False and type(obj['invalid_access']) is list and obj['invalid_access']==[],'Native run incomplete/faulted')
 require(span['historical_global_string_origin_or_effective_EUW_flag_qualified'] is False and type(span['heap_remaining']) is dict and span['heap_remaining']=={},'Span historical scope or heap promoted')
 require(reference['historical_default_cfg_origin_or_effective_EUW_flag_qualified'] is False and inputs['historical_mounts_CLI_generated_locale_or_EUW_flag_qualified'] is False and inputs['locale_default_is_selected_manifest_member'] is False and inputs['locale_default_origin_qualified'] is False,'Historical locale provenance promoted')
 membership=RadsReferenceMembership(R);member=membership.inspect('DATA/CFG/defaults/Locale.cfg',inputs['locale_default']['path'],inputs['locale_default']);require(member==inputs['locale_default_manifest_membership'] and member['status']=='not_listed_in_two_selected_projects' and not member['matching_members'] and not member['candidates'],'Loose config promoted into selected manifest')
 require(reference['source']==inputs['locale_default'] and pathlib.Path(reference['source']['path']).read_bytes()==b'[General]\r\nLanguageLocaleRegion=en_GB','Wrong actual loose default bytes')
 for p in inputs['membership_inputs']+inputs['source_files']:identity(p)
 pe=pefile.PE(span['binary']['path']);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;require(im[0x1088ab0-base:0x1088ab0-base+6]==b'zh_CN\0' and struct.unpack_from('<I',im,0x10d6c70-base+0x58)[0]==0x92c9e0,'Wrong native literal/virtual target')
 executable=[(base+s.VirtualAddress,base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)) for s in pe.sections if s.Characteristics&0x20000000]
 for obj in [span,reference]:
  pcs=obj['original_PCs'];require(len(pcs)==len(set(pcs)) and all(type(p) is str and hex(int(p,16))==p and any(a<=int(p,16)<b for a,b in executable) for p in pcs),'Invalid original PC set');require({'0x575801','0x57582c','0xc9cf31','0x92c9e0'}<=set(pcs),'Original locale/setter path missing');require(integer(obj['original_instructions']) and obj['original_instructions']>len(pcs),'Wrong instruction count')
 require({'0x82d1a0','0x8b2e70','0x8aec00','0x8b5030','0x8b0630','0x92c9d0'}<=set(reference['original_PCs']) and '0x8b15d0' not in reference['original_PCs'],'Reference initializer/parser path or fallback differs')
 locales=['en_GB','EN_gb','en_US','zh_CN','ZH_cn','zh_cn','zh_TW','ko_KR','ru_RU','fr_FR','zh_CN_suffix','different_language_value_long'];profiles=[(text,storage,old) for text in locales for storage in (['SSO','heap'] if len(text)<16 else ['heap']) for old in [0,1]];require(len(span['cases'])==len(profiles)==46,'Wrong explicit span profiles')
 def call(c,receiver,expected):
  require(c['callsite']=='0x57582c' and c['receiver']==receiver and c['target']=='0x92c9e0' and type(c['argument_low_byte']) is int and c['argument_low_byte']==expected,'Wrong original setter call');require(int(c['argument_word'],16)&255==expected,'Opaque argument low byte differs')
 for c,(text,storage,old) in zip(span['cases'],profiles,strict=True):
  expected=int(text.lower()=='zh_cn');require(c['locale']==text and c['supplied_storage']==storage and type(c['old_byte']) is int and c['old_byte']==old,'Wrong supplied locale/string-storage profile');require(type(c['expected_flag']) is type(c['observed_flag']) is int and c['expected_flag']==c['observed_flag']==expected,'Wrong native conditional flag');require(c['only_primary359_changed'] is True and c['stack_preserved'] is True and c['stopped_before']=='0x57582f','Span touched unrelated storage/stack oroverran scope');call(c['setter_call'],'0x41080000',expected)
 require(len(reference['cases'])==2,'Wrong reference cases')
 for c,old in zip(reference['cases'],[0,1],strict=True):
  require(c['initialization']['enabled'] is True and c['initialization']['original_locale_caller_executed'] is True and c['initialization']['historical_effective_locale_qualified'] is False,'Invalid initializer scope flags')
  require(type(c['old_byte']) is int and c['old_byte']==old and c['initialization']=={'locale':'en_GB','enabled':True,'application_string':'en_GB','declared_user_config':None,'selected_user_config':None,'native_config_directory_mode':None,'original_locale_caller_executed':True,'historical_effective_locale_qualified':False},'Wrong actual initializer selection/context')
  require(all(type(c[k]) is int and c[k]==0 for k in ['expected_flag','observed_flag','secondary_getter_observed']) and c['only_primary359_changed'] is True and c['historical_process_or_mount_context_qualified'] is False,'Reference conditional result or historical scope differs');call(c['setter_call'],'0x40008000',0)
  require(integer(c['instructions']) and len(c['opened'])==len(c['read_streams'])==1,'Wrong reference stream/instruction count');a,b=c['opened'][0],c['read_streams'][0]
  require(str(pathlib.Path(a['physical']).resolve()).casefold()==str(pathlib.Path(reference['source']['path']).resolve()).casefold() and a['sha256']==reference['source']['sha256'] and a['bytes']==37 and a['mode']=='rb' and type(a['backend']) is int and a['backend']==0 and a['logical'].casefold()=='data/cfg/defaults/locale.cfg','Wrong reference opened bytes')
  require(str(pathlib.Path(b['physical']).resolve()).casefold()==str(pathlib.Path(a['physical']).resolve()).casefold() and b['logical']==a['logical'] and type(b['backend']) is int and b['backend']==0 and b['closed'] is True and type(b['position']) is int and b['position']==37,'Wrong actual stream lifetime')
  offset=0
  for read in b['reads']:
   require(all(integer(read[k]) for k in ['offset','item_size','count','bytes']) and read['offset']==offset and read['bytes']==read['item_size']*read['count'],'Wrong original raw read sequence');offset+=read['bytes']
  require(offset==37,'Raw parser did not consume full provided source')
 require(reference['original_instructions']==sum(c['instructions'] for c in reference['cases']),'Wrong reference instruction total')
 executions=[]
 for name,obj in [('original-locale-censor-span',span),('original-locale-reference-chain',reference)]:
  e=load(v/(name+'-execution.json'));require(e['exit_code']==0 and e['cwd']=='E:/OpenLeague' and obj['producer']['path'] in e['command'],'Wrong native execution receipt');identity(e['log']);require('"completed": true' in pathlib.Path(e['log']['path']).read_text('utf-8') and '"faults": 0' in pathlib.Path(e['log']['path']).read_text('utf-8'),'Execution log differs');identity(pin(v/(name+'.json')));identity(pin(v/(name+'-execution.json')));executions.append(pin(v/(name+'-execution.json')))
 for name in ['original_text_config_reference.py','original_config_cache_reference.py','original_config_reader_reference.py','original_directory_reference.py','original_skin_provider_reference.py','native_skin_loader_reference.py','rads_reference_membership.py']:identity(pin(R/'tools/project-plan'/name))
 identity(pin(v/'execute_locale_experiment.py'))
 current=[]
 for path,needle,scope in [
  ('crates/client/src/native_hud_font_configuration.rs','pub fn load(root:&Path)->io::Result<Loaded> {','Currentfontconfiguration reads General/LanguageLocaleRegion fromtheprovidedfontconfiguration copy. Not aneffectcensor initializer orwholelocale/parser proof.'),
  ('crates/core/src/audio_replay_loading_owner.rs','pub fn construct(b: &mut impl Boundary, p: u32, scratch: u32) -> Result<u32, Error> {','Currentloading-wrapper source readsLANGUAGE_GLOBAL2D78D08 andcomparesZH_CN. Not theeffectmanager359setter/currentRustcensorwiring.')]:
  text=(R/path).read_text('utf-8');require(text.count(needle)==1,'Currentlocaleconsumer missing/ambiguous');identity(pin(R/path));current.append({'path':path,'needle':needle,'source':pin(R/path),'scope':scope,'runtime_or_Rust_tests_executed_this_turn':False})
 return {'schema':'openleague_native_locale_censor_chain_audit/v1','passed':True,'counts':{'supplied_locale_storage_span_cases':46,'actual_loose_reference_chain_cases':2,'span_native_instructions':span['original_instructions'],'span_native_PCs':len(span['original_PCs']),'reference_native_instructions':reference['original_instructions'],'reference_native_PCs':len(reference['original_PCs']),'source_identities':len(sources)},'source_identities':list(sources.values()),'native_executions':executions,'current_consumer_evidence':current,'loose_default_manifest_membership':member,'conditional_provided_reference_flag':0,'loose_default_historical_origin_qualified':False,'historical_effective_EUW_flag_or_full_bootstrap_qualified':False,'current_Rust_effect_manager_censor_wiring_qualified':False,'declared_boundaries':span['declared_boundaries']+reference['declared_boundaries']}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');a=p.parse_args()
 try:r=audit(a.evidence_root)
 except (EvidenceError,OSError,ValueError,KeyError,IndexError,TypeError,struct.error) as e:print(json.dumps({'passed':False,'error':str(e)}));return 1
 if a.output:pathlib.Path(a.output).write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'passed':True,'counts':r['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
