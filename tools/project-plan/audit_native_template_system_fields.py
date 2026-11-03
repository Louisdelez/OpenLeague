"""Read-only qualification of native template System getters and sentinel search.

The evidence joins exact candidate bytes, independent static fields and native
getter observations. It deliberately does not qualify the whole template load.
"""
import argparse,ast,collections,hashlib,json,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague')
ALLOWED=[R.resolve(),pathlib.Path('E:/mapslol3v3').resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]

class EvidenceError(ValueError):pass
def require(value,message):
 if not value:raise EvidenceError(message)
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p).resolve();require(any(p.is_relative_to(r) for r in ALLOWED),'Source outside allowed roots')
 require(p.is_file(),'Source missing')
 b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def integer(value,minimum=0):return type(value) is int and value>=minimum
def identity(p):
 require(isinstance(p,dict) and set(p)=={'path','bytes','sha256'},'Invalid source identity')
 require(integer(p['bytes']) and isinstance(p['sha256'],str) and len(p['sha256'])==64,'Invalid identity fields')
 require(pin(p['path'])==p,'Source identity changed')
 return p

def audit(evidence_root,native_override=None,inputs_override=None,sentinel_override=None):
 v=pathlib.Path(evidence_root).resolve();require(v.is_relative_to(ALLOWED[1]),'Evidence root outside workspace')
 sys.path[:0]=[str(R/'tools/pythonlibs'),str(v.parent)]
 import pefile
 from capstone import Cs,CS_ARCH_X86,CS_MODE_32
 from reference_inibin import decode,hashkey
 data=inputs_override if inputs_override is not None else load(v/'template-system-field-inputs.json')
 native=native_override if native_override is not None else load(v/'original-troy-system-fields.json')
 sentinel=sentinel_override if sentinel_override is not None else load(v/'original-template-sentinel-search.json')
 sources={}
 def source(p):
  p=identity(p);sources[str(pathlib.Path(p['path']).resolve()).casefold()]=p
  return p
 for d,keys in [(data,['binary','producer','reader','source_inputs']),(native,['binary','producer','inputs','pilot_producer','pilot_execution','base_consumer']),(sentinel,['binary','producer','VM','source'])]:
  for k in keys:source(d[k])
 for d in [native,sentinel]:
  tree=ast.parse(pathlib.Path(d['producer']['path']).read_text('utf-8'))
  limits=[ast.literal_eval(k.value) for call in ast.walk(tree) if isinstance(call,ast.Call) for k in call.keywords if k.arg=='declared_boundaries']
  require(len(limits)==1 and d['declared_boundaries']==limits[0],'Declared native boundaries differ from frozen producer')
 require(native['binary']==sentinel['binary']==data['binary'],'Divergent native binaries')
 require(native['inputs']==pin(v/'template-system-field-inputs.json') and sentinel['source']==pin(v/'template-system-field-inputs.json'),'Wrong field inputs provenance')
 pe=pefile.PE(data['binary']['path']);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
 def literal(va):
  raw=im[va-base:va-base+256];require(b'\0' in raw,'Native literal not terminated');return raw.split(b'\0',1)[0].decode('ascii')
 expected=[('group-vis','0x8b1f50',250.0),('group-scale-cap','0x8b1f50',None),('SoundOnCreate','0x8b0630',''),('VoiceOverOnCreate','0x8b0630',''),('SoundPersistent','0x8b0630',''),('VoiceOverPersistent','0x8b0630',''),('AudioFlexValueParameterName','0x8b0630',''),('AudioParameterFlexID','0x8b1a80',-1)]+[('GroupPart'+str(i),'0x8b0630','-NONE-') for i in range(1,9)]
 require(data['section']=='System' and literal(0x108ba08)=='System','Wrong native section')
 require(len(data['fields'])==16 and [(s['field'],s['getter'],s['default']) for s in data['fields']]==expected,'Wrong native field/default catalogue')
 require(struct.unpack_from('<f',im,0x1139100-base)[0]==250.0 and literal(0x10d7c3c)=='-NONE-','Native defaults changed')
 callsites=[0x918f8b,0x918fb3,0x918fdd,0x9194dd,0x919536,0x919589,0x9195de,0x919629]+[0x918f2c]*8
 literals=[0x10d7e68,0x10d7e58,0x10d7598,0x10d7624,0x10d7614,0x10d7600,0x10d7f5c,0x10d7f44]
 destinations={'SoundOnCreate':'0x140','VoiceOverOnCreate':'0x158','SoundPersistent':'0x170','VoiceOverPersistent':'0x188','AudioFlexValueParameterName':'0x1a0','AudioParameterFlexID':'0x1b8'}
 for index,spec in enumerate(data['fields']):
  require(spec['key']==hashkey('System',spec['field']),'Wrong native field key')
  require(spec['callsite']==hex(callsites[index]),'Wrong native field callsite')
  if 'literal_address' in spec:require(spec['literal_address']==hex(literals[index]) and literal(int(spec['literal_address'],16))==spec['field'],'Wrong native field literal')
  else:require(spec['literal_format_address']=='0x10d7dac' and spec['group_index']==index-7 and integer(spec['group_index'],1) and literal(int(spec['literal_format_address'],16))%1== 'GroupPart1','Wrong group format')
  if spec['field'] in destinations:require(spec['destination_offset']==destinations[spec['field']],'Wrong native destination offset')
  pc=int(spec['callsite'],16);target=int(spec['getter'],16)
  require(im[pc-base]==0xe8 and pc+5+struct.unpack_from('<i',im,pc-base+1)[0]==target,'Wrong native call target')
 md=Cs(CS_ARCH_X86,CS_MODE_32)
 require(len(data['native_source_blocks'])==2,'Wrong native source blocks')
 for block,(label,a,b) in zip(data['native_source_blocks'],[('template_backend_extended_bounded',0x918e90,0x919730),('sentinel_search_CRT_bounded',0xc98c70,0xc98f30)],strict=True):
  expected_block={'label':label,'start':hex(a),'end_bound':hex(b),'whole_CFG_qualified':False,'instructions':[{'pc':hex(i.address),'bytes':i.bytes.hex(),'instruction':i.mnemonic+' '+i.op_str} for i in md.disasm(im[a-base:b-base],a)]}
  require(block==expected_block,'Static bounded native source differs')
 require(data['sentinel_handling']=={'literal':'-NONE-','callsite':'0x918f5b','callee':'0xc98c70','zero_return_branch':'0x918ff9','nonzero_return_skips_group':'0x918f6b','callee_semantics_requires_native_probe':True},'Wrong sentinel callsite/branch contract')
 require(not data['refused_payloads'] and len(data['rows'])==689,'Incomplete candidate inventory')
 original=load(data['source_inputs']['path'])
 require([r['source'] for r in data['rows']]==original['payload_source_identities'],'Different manifest-exact candidate corpus')
 require(native['execution_completed'] is True and native['historical_OS_process_launched'] is False and native['whole_template_loading_qualified'] is False,'Unqualified native scope/completion claim')
 require(not native['invalid_access'] and len(native['rows'])==689,'Faulted/incomplete native corpus')
 require(integer(native['queries_completed']) and native['queries_completed']==11024,'Wrong native query count')
 require(integer(native['original_instructions'],1) and native['original_instructions']==sum(r['instructions'] for r in native['rows']) and all(integer(r['instructions'],1) for r in native['rows']),'Wrong native instruction counts')
 pcs=native['original_PCs'];require(len(pcs)==len(set(pcs)) and all(type(p) is str for p in pcs),'Invalid native PC set')
 executable=[(base+s.VirtualAddress,base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)) for s in pe.sections if s.Characteristics&0x20000000]
 require(all(hex(int(p,16))==p and any(a<=int(p,16)<b for a,b in executable) for p in pcs),'Native PC outside executable image')
 require({'0x8b0630','0x8b1f50','0x8b1a80','0x8acef0','0x8ad5b0','0x8b4ef0'}<=set(pcs),'Required native cache/parser/getters not observed')
 counts=collections.Counter();queries=0
 for static,observed in zip(data['rows'],native['rows'],strict=True):
  src=source(static['source']);require(observed['source']==src,'Native source identity mismatch')
  p=pathlib.Path(src['path']);expected_logical=p.relative_to(pathlib.Path(data['binary']['path']).parent/'DATA').as_posix()[:-3]
  require(static['logical_relative_to_DATA']==observed['logical_relative_to_DATA']==expected_logical,'Wrong logical source')
  raw=decode(p.read_bytes());require(static['total_decoded_keys']==len(raw),'Wrong static key count')
  require(len(static['field_values'])==len(observed['cases'])==16 and observed['cache_process_context_reset_between_payloads'] is True,'Wrong native per-payload scope')
  for spec,value,case in zip(data['fields'],static['field_values'],observed['cases'],strict=True):
   name=spec['field'];present=spec['key'] in raw;raw_value=raw.get(spec['key']);default=2.0 if name=='group-scale-cap' else spec['default']
   require(type(value['present']) is bool and value=={'field':name,'key':spec['key'],'present':present,'raw_value':raw_value},'Static field differs from exact payload')
   require(case['field']==name and case['getter']==spec['getter'] and case['present'] is present,'Native field binding differs')
   require(type(case['default']) is type(default) and case['default']==default and case['callback_default_is_supplied_fixture'] is (name=='group-scale-cap'),'Supplied default/callback scope differs')
   expected_value=raw_value if present else default
   if spec['getter']=='0x8b1f50':expected_value=struct.pack('<f',float(expected_value)).hex()
   elif spec['getter']=='0x8b1a80':expected_value=int(expected_value)&0xffffffff
   require(type(case['observed']) is type(expected_value) and case['observed']==case['expected']==expected_value,'Native observed value/default differs')
   counts[name+(':present' if present else ':absent')]+=1;queries+=1
  opened=observed['opened'];streams=observed['read_streams']
  require(len(opened)==len(streams)==1,'Wrong native stream count')
  a,b=opened[0],streams[0]
  require(a['physical']==str(p) and a['bytes']==src['bytes'] and a['sha256']==src['sha256'] and a['mode']=='rb' and a['logical']==expected_logical+'bin' and integer(a['backend']) and a['backend']==0,'Wrong original opened payload')
  require(b['physical']==str(p) and b['logical']==a['logical'] and integer(b['backend']) and b['backend']==0 and b['closed'] is True and integer(b['position']) and b['position']==src['bytes'],'Wrong original stream lifetime/length')
  offset=0
  for read in b['reads']:
   require(all(integer(read[k]) for k in ['offset','item_size','count','bytes']) and read['offset']==offset and read['bytes']==read['item_size']*read['count'],'Wrong original read sequence')
   offset+=read['bytes']
  require(offset==src['bytes'],'Original parser did not read entire payload')
 require(data['counts']=={'manifest_exact_payload_candidates':689,'decoded':689,'refused':0,'fields_inspected_per_payload':16,'field_presence':dict(counts)},'Wrong static field counts')
 require(sentinel['execution_completed'] is True and sentinel['historical_OS_process_launched'] is False and sentinel['whole_template_loading_qualified'] is False and not sentinel['invalid_access'] and not sentinel['heap_remaining'],'Wrong sentinel native scope')
 cases=[('-NONE-','-NONE-',0),('prefix-NONE-suffix','-NONE-',6),('smoke','-NONE-',None),('-none-','-NONE-',None),('','-NONE-',None),('smoke','',0),('ab-NONE--NONE-','-NONE-',2)]
 require(len(sentinel['cases'])==7,'Wrong sentinel cases')
 for observed,(left,right,offset) in zip(sentinel['cases'],cases,strict=True):
  require(observed['haystack']==left and observed['needle']==right and observed['expected_offset_or_none']==observed['observed_offset_or_none']==offset,'Wrong sentinel substring observation')
  require(observed['observed_offset_or_none'] is None or integer(observed['observed_offset_or_none']),'Invalid sentinel pointer offset')
  base_pointer=int(observed['haystack_pointer'],16);require(0x41000000<=base_pointer<0x41100000,'Sentinel input pointer outside declared scratch')
  pointer=0 if offset is None else base_pointer+offset
  require(observed['observed_pointer']==observed['expected_pointer']==hex(pointer),'Wrong sentinel return pointer')
 require(integer(sentinel['initial_CRT_feature_flag']) and sentinel['initial_CRT_feature_flag']==struct.unpack_from('<I',im,0x14ae660-base)[0],'Supplied CRT dispatch differs')
 require('0xc98c70' in sentinel['original_PCs'] and integer(sentinel['original_instructions'],1),'Missing original sentinel execution')
 executions=[]
 for name,result in [('original-troy-system-fields',native),('original-template-sentinel-search',sentinel)]:
  execution=load(v/(name+'-execution.json'));require(execution['exit_code']==0 and execution['cwd']=='E:/OpenLeague','Native execution did not exit0')
  source(execution['log']);source(pin(v/(name+'-execution.json')))
  text=pathlib.Path(execution['log']['path']).read_text('utf-8');require('"completed": true' in text and '"faults": 0' in text and result['producer']['path'] in execution['command'],'Native execution receipt/log differs')
  source(pin(v/(name+'.json')));executions.append(pin(v/(name+'-execution.json')))
 for name in ['original_config_cache_reference.py','original_config_reader_reference.py','original_directory_reference.py','original_skin_provider_reference.py','native_skin_loader_reference.py']:source(pin(R/'tools/project-plan'/name))
 source(pin(v/'execute_troy_system_fields.py'));source(pin(v.parent/'reference_inibin.py'))
 current=[]
 for path,needle,fields,scope in [
  ('crates/core/src/native_troy_position_bounds.rs','pub fn from_decoded_system(system:&serde_json::Value)->Result<Self,&\'static str> {',['group-vis'],'Consumes already-decoded numeric System/group-vis with default250. String coercion and upstream decode are outside this Rust entry;no new Rust/runtime test claimed.'),
  ('crates/client/src/native_ambient_parent.rs','pub fn new(document:&serde_json::Value,start:f32,owner:&SimpleOwnerPose,rng:Rng55)->Result<Self,String>{',['group-vis','SoundOnCreate','SoundPersistent'],'Ambient Simple topology and logical audio registration only. This source anchor does not establish champion effects,voiceover/full-field wiring or physical playback.')]:
  p=R/path;text=p.read_text('utf-8');require(text.count(needle)==1,'Current consumer anchor missing/ambiguous')
  for field in fields:require('"'+field+'"' in text,'Current consumer field missing')
  source(pin(p));current.append({'path':path,'needle':needle,'line':next(i+1 for i,line in enumerate(text.splitlines()) if needle in line),'fields':fields,'scope':scope,'source':pin(p),'runtime_or_tests_executed_this_turn':False})
 return {'schema':'openleague_native_template_System_field_audit/v1','passed':True,'counts':{'payloads':689,'fields_per_payload':16,'native_queries':queries,'native_instructions':native['original_instructions'],'native_PCs':len(pcs),'sentinel_cases':7,'sentinel_instructions':sentinel['original_instructions'],'field_presence':dict(counts),'source_identities':len(sources)},'source_identities':list(sources.values()),'native_executions':executions,'current_consumer_evidence':current,'whole_template_loading_or_historical_priority_qualified':False,'historical_OS_process_launched':False,'declared_boundaries':native['declared_boundaries']+sentinel['declared_boundaries']}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output');a=p.parse_args()
 try:r=audit(a.evidence_root)
 except (EvidenceError,OSError,ValueError,KeyError,IndexError,TypeError,struct.error) as e:print(json.dumps({'passed':False,'error':str(e)}));return 1
 if a.output:pathlib.Path(a.output).write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'passed':True,'counts':r['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
