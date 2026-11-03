import argparse,datetime,hashlib,json,pathlib,struct,sys
from original_numeric_reference import OriginalNumeric,BINARY_SHA
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'));from reference_inibin import read,hashkey
def load(p):return json.loads(p.read_bytes())
def identity(p):b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
p=argparse.ArgumentParser();p.add_argument('--output',required=True);a=p.parse_args();output=pathlib.Path(a.output)
if output.exists():p.error('Output exists; preserve earlier evidence.')
ref=load(R/'docs/reference_client_4_20.json');binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];converter=OriginalNumeric(binary)
controls=[]
for text,expected in [('7.25',7.25),('-1.25',-1.25),('1e2',100.),('invalid',0.),('6,5',6.),('6.5abc',6.5),('',0.),('  +2.5tail',2.5)]:
 observed=converter.convert(text);assert observed['value']==expected;controls.append({'input':text,'expected':expected,'observed':observed,'passed':True})
for text in ['6.5\0.0000','6.5é','x'*1024]:
 try:converter.convert(text);raise AssertionError('Unsafe input accepted')
 except ValueError as e:controls.append({'input':repr(text[:30]),'expected':'explicit refusal','observed':str(e),'passed':True})
karma=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Karma/Spells/KarmaQ.inibin';values=read(karma);actual=[]
for rank in [2,4]:
 raw=values[hashkey('SpellData','Cooldown'+str(rank))];observed=converter.convert(raw);assert observed['value']==(6.5 if rank==2 else 5.5);actual.append({'field':'Cooldown'+str(rank),**observed})
# Reuse the verified setup/constructor fragment, replacing only its explicit
# numeric-text lookup adapter with actual original numeric instructions.
producer=R/'tools/project-plan/exercise_native_rank_constructor.py';prior=load(R/'docs/reference_native_constructor_sources/rank-constructor-execution.json')
assert hashlib.sha256(producer.read_bytes()).hexdigest()==prior['producer']['sha256']
source=producer.read_text(encoding='utf-8');prefix=source.split('synthetic=[]',1)[0];assert 'argparse.ArgumentParser()' not in prefix
env={'__file__':str(producer),'__name__':'original_rank_setup_for_numeric_qualification'};exec(compile(prefix,str(producer),'exec'),env)
numeric_calls=[]
def numeric(value):
 if isinstance(value,str):
  row=converter.convert(value);numeric_calls.append(row);return row['value']
 if value is None:raise ValueError('Missing numeric source')
 return float(value)
env['numeric']=numeric;rank_result=env['run'](values);assert rank_result['cooldowns'][:5]==[7.,6.5,6.,5.5,5.]
import unicorn,pefile
result={'schema':'openleague_original_numeric_conversion/v1','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'converter':converter.evidence(),
 'native_source':identity(karma),'actual_karma_fields':actual,'actual_rank_constructor':rank_result,'actual_rank_fragment':['0x767a86','0x767c49'],'original_numeric_lookup_calls':numeric_calls,'synthetic_controls':controls,
 'rank_setup_producer':identity(producer),'previous_rank_receipt':identity(R/'docs/reference_native_constructor_sources/rank-constructor-execution.json'),
 'tools':{'python':{**identity(pathlib.Path(sys.executable)),'version':sys.version},'unicorn':{'version':unicorn.__version__,'module':identity(pathlib.Path(unicorn.__file__)),'dlls':[identity(p) for p in pathlib.Path(unicorn.__file__).parent.rglob('*.dll')]},'pefile':{'version':pefile.__version__,'module':identity(pathlib.Path(pefile.__file__))}},
 'producer':{**identity(pathlib.Path(__file__)),'helper':identity(pathlib.Path(__file__).with_name('original_numeric_reference.py'))},'historical_effective_locale_overrides_qualified':False,'gameplay_qualified':False}
binding_start=0x8ae23c;binding_stop=0x8ae267;binding_bytes=converter.image[binding_start-converter.base:binding_stop-converter.base]
result['native_string_getter_binding_static']={'original_binary_sha256':BINARY_SHA,'start':hex(binding_start),'stop':hex(binding_stop),'bytes_hex':binding_bytes.hex(),'sha256':hashlib.sha256(binding_bytes).hexdigest(),
 'observed_dataflow':'Successful string lookup0x8af290 -> actual0xc99987 numeric call at0x8ae255 -> FSTP float32 at0x8ae260.',
 'this_getter_fragment_executed':False,'classification':'Static code binding; converter and original ranked-array stores exercised separately with explicit lookup adapters.'}
output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'actual_karma_fields':actual,'ranked_cooldowns':rank_result['cooldowns'],'synthetic_controls':len(controls),'converter':converter.evidence()},ensure_ascii=False,indent=2))
