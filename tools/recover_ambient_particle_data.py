"""Qualify native ambient particle fields against an independent community reader."""
from pathlib import Path
import importlib.util,json,hashlib,datetime
from native_troy import decode,key_hash
r=Path(__file__).resolve().parents[1];folder=r/'tools/references/lolpytools';tree=json.loads((folder/'tree.json').read_text(encoding='utf-8-sig'))
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
reader=module('ambient_reference_ini',folder/'lolpytools_inibin2.py');fixer=module('ambient_reference_troy',folder/'lolpytools_troybin_fix.py')
references=json.loads((r/'docs/map_ambient_event_sources.json').read_text())['references'];out=r/'data/4.20/particles';out.mkdir(exist_ok=True);proofs=[]
for path in sorted({x['resolved_path'] for x in references}):
 source=Path(path);native=decode(source);reference=reader.from_file(str(source));fixer.fix(reference)
 assert not reference['UNKNOWN_HASHES'],(source,reference['UNKNOWN_HASHES'])
 qualified={};entries=[]
 for section,values in reference['Values'].items():
  qualified[section]={}
  for name,value in values.items():
   key=key_hash(section,name);assert key in native;field=native[key];raw=field['value'];expected=reader.sanitize_str(raw) if isinstance(raw,str) else raw
   def normal(v):return list(v) if isinstance(v,tuple) else v
   assert normal(expected)==normal(value),(source,section,name,expected,value)
   qualified[section][name]=value;entries.append({'section':section,'name':name,'native_hash':key,**field})
 assert len(entries)==len(native)
 result={'native_file':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'sections':qualified,'fields':entries,'unknown_hashes':{},'semantics_qualified':False}
 target=out/(source.stem+'.json');target.write_text(json.dumps(result,indent=2)+'\n')
 proofs.append({'source':str(source),'source_sha256':result['source_sha256'],'output':str(target.relative_to(r)),'output_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'native_fields':len(native),'independent_fields_equal':len(entries),'unresolved_fields':0})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'parser_reference':{'repository':'https://github.com/moonshadow565/lolpytools','commit':tree['sha'],'license_file':str(folder/'LICENSE'),'reader_sha256':hashlib.sha256((folder/'lolpytools_inibin2.py').read_bytes()).hexdigest(),'name_dictionary_sha256':hashlib.sha256((folder/'lolpytools_troybin_fix.py').read_bytes()).hexdigest()},'files':proofs,'native_fields':sum(x['native_fields'] for x in proofs),'passed':True,'complete':False,'limits':['All encoded values and named hashes match an independent reader; historical renderer semantics not proven.','BLND event time units, attachment flags and exact audio/particle runtime remain incomplete.','Color/rate/scale curves and texture references retained; no generic fire substituted.']}
(r/'docs/map_ambient_particle_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native particle field recovery:',proof['native_fields'],'fields in',len(proofs),'files; zero unknown hashes')
