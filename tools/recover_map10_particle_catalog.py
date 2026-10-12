from pathlib import Path
import sys,json,hashlib,importlib.util,re,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));from native_troy import decode,key_hash
deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');particles=deploy/'LEVELS/Map10/Particles.dat';sha=lambda b:hashlib.sha256(b).hexdigest()
folder=r/'tools/references/lolpytools'
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
reader=module('map10_reference_ini',folder/'lolpytools_inibin2.py');fixer=module('map10_reference_troy',folder/'lolpytools_troybin_fix.py')
placements=[]
for line_number,line in enumerate(particles.read_text(encoding='utf-8-sig').splitlines(),1):
 values=line.split()
 if len(values)<4:continue
 placements.append({'line':line_number,'reference':values[0],'position':[float(v) for v in values[1:4]],'extra_tokens':values[4:]})
refs={p['reference'] for p in placements};refs.update(x['resolved_path'].split('\\')[-1] for x in json.loads((r/'docs/map_ambient_event_sources.json').read_text(encoding='utf-8-sig'))['references'])
files={}
for p in (deploy/'DATA/Particles').glob('*.troybin'):files.setdefault(p.stem.lower(),[]).append(p)
out=r/'data/4.20/map10_particles';out.mkdir(exist_ok=True);(out/'definitions').mkdir(exist_ok=True)
definitions=[];missing=[];unresolved=[]
for reference in sorted(refs):
 stem=Path(reference).stem;paths=files.get(stem.lower(),[])
 if not paths:missing.append(reference);continue
 hashes={sha(p.read_bytes()) for p in paths};assert len(hashes)==1,('ambiguous native particle',reference,paths)
 source=paths[0];native=decode(source);independent=reader.from_file(str(source));fixer.fix(independent);entries=[];sections={}
 for section,values in independent['Values'].items():
  sections[section]={}
  for name,value in values.items():
   key=key_hash(section,name);assert key in native;field=native[key];raw=field['value'];expected=reader.sanitize_str(raw) if isinstance(raw,str) else raw;normal=lambda v:list(v) if isinstance(v,tuple) else v;assert normal(expected)==normal(value),(source,section,name)
   sections[section][name]=value;entries.append({'section':section,'name':name,'native_hash':key,**field})
 named={e['native_hash'] for e in entries};unknown={str(k):v for k,v in native.items() if k not in named};assert len(named)+len(unknown)==len(native)
 if unknown:unresolved.append({'reference':reference,'hashes':list(unknown)})
 system=sections.get('System',{});groups=[]
 for name,value in system.items():
  match=re.fullmatch(r'GroupPart(\d+)',name)
  if match:
   slot=int(match[1]);group=sections.get(value,{});textures=[{'field':k,'reference':v} for k,v in group.items() if isinstance(v,str) and v.lower().endswith(('.dds','.tga'))];color_fields={k:v for k,v in group.items() if any(s in k.lower() for s in ('rgba','colorscale','coloroffset','colortype'))};groups.append({'slot':slot,'name':value,'declared_type':system.get(f'GroupPart{slot}Type'),'importance':system.get(f'GroupPart{slot}Importance'),'particle_type':group.get('p-type'),'render_mode':group.get('rendermode'),'textures':textures,'color_fields':color_fields})
 groups.sort(key=lambda v:v['slot']);target=out/'definitions'/(source.stem+'.json');document={'native_file':str(source),'source_sha256':sha(source.read_bytes()),'sections':sections,'fields':entries,'unknown_hashes':unknown,'semantics_qualified':False};target.write_text(json.dumps(document,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 previous=next((d for d in definitions if d['native_file']==str(source)),None)
 if previous:previous['aliases'].append(reference)
 else:definitions.append({'reference':reference,'aliases':[reference],'native_file':str(source),'source_sha256':document['source_sha256'],'asset':str(target.relative_to(r)).replace('\\','/'),'asset_sha256':sha(target.read_bytes()),'native_fields':len(native),'independent_named_fields_equal':len(entries),'unknown_field_count':len(unknown),'groups':groups})
catalog={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'particles_source':str(particles),'particles_source_sha256':sha(particles.read_bytes()),'placements':placements,'definitions':definitions,'missing_references':missing,'unknown_fields':unresolved,'renderer_implemented':False,'parser_reference':{'commit':json.loads((folder/'tree.json').read_text(encoding='utf-8-sig'))['sha'],'reader_sha256':sha((folder/'lolpytools_inibin2.py').read_bytes()),'dictionary_sha256':sha((folder/'lolpytools_troybin_fix.py').read_bytes())},'limits':['Original static Particles.dat placements and native definitions recovered; unknown names/fields remain explicit. Native spawning, emitter lifecycle, per-age color/rate/scale functions and rendering remain to implement.','Independent reader agrees on every named encoded field; this does not qualify native execution semantics. No fixed-tint generic plane replaces native groups.']}
(r/'data/4.20/map10_particle_catalog.json').write_text(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve() != (r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'placements':len(placements),'definitions':len(definitions),'groups':sum(len(d['groups']) for d in definitions),'native_fields':sum(d['native_fields'] for d in definitions),'unknown_fields':sum(d['unknown_field_count'] for d in definitions),'missing':missing}))
