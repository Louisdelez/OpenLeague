"""Named static community/native comparison, never executing gameplay code."""
import argparse,collections,datetime,hashlib,json,pathlib,re,sys
from lua51_reference import inspect,LuaReferenceError
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from reference_inibin import read,hashkey
def identity(path):
 p=pathlib.Path(path);raw=p.read_bytes();return {'path':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}
def load(p):return json.loads(p.read_bytes())
def scrub_comments_and_strings(text):
 # Candidate class enumeration only; it does not prove C# dispatch semantics.
 return re.sub(r'//[^\n]*|/\*.*?\*/|@"(?:[^"]|"")*"|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',lambda m:'\n'*m[0].count('\n'),text,flags=re.S)
def class_names(text):return re.findall(r'\bclass\s+([A-Za-z_][A-Za-z_0-9]*)\b',scrub_comments_and_strings(text))
def buff_literal(text,name):
 text=re.sub(r'@"(?:[^"]|"")*"|"(?:\\.|[^"\\])*"|//[^\n]*|/\*.*?\*/',lambda m:re.sub(r'[^\n]',' ',m[0]) if m[0].startswith(('//','/*')) else m[0],text,flags=re.S)
 pattern=r'AddBuff\(\s*"'+re.escape(name)+r'"\s*,\s*([0-9]+(?:\.[0-9]+)?)f\s*,\s*1\s*,\s*spell\s*,\s*(ai|owner)\s*,\s*owner\s*\)'
 matches=list(re.finditer(pattern,text))
 if len(matches)!=1:raise ValueError('Expected one exact literal call for '+name)
 m=matches[0];return {'seconds':float(m[1]),'target':m[2],'line':text[:m.start()].count('\n')+1,'text':m[0]}
def anchor(path,needle):
 lines=pathlib.Path(path).read_text(encoding='utf-8').splitlines();hits=[i+1 for i,x in enumerate(lines) if needle in x]
 if len(hits)!=1:raise ValueError('Missing/ambiguous source anchor: '+needle)
 return {**identity(path),'line':hits[0],'needle':needle,'excerpt':lines[hits[0]-1]}
def garen_case(root,dep,review):
 scripts=pathlib.Path(review['community_script_origin']);server=scripts.parent.parent
 q=scripts/'Characters/Garen/Q.cs';record=next(x for x in review['script_inventory'] if x['relative_path']=='Characters/Garen/Q.cs');assert identity(q)['sha256']==record['sha256']
 text=q.read_text(encoding='utf-8');assert class_names(text)==['GarenQ']
 silence=buff_literal(text,'Silence');haste=buff_literal(text,'GarenQHaste')
 native=dep/'DATA/Characters/Garen/Spells/GarenQ.inibin';values=read(native)
 native_values={name:[float(values[hashkey('SpellData',f'Effect{effect}Level{rank}Amount')]) for rank in range(1,6)] for name,effect in [('silence_seconds',3),('haste_seconds',5),('empowered_window_seconds',6)]}
 current=root/'data/4.20/native_spells_420.json';rows=load(current);entry=next(x for x in rows if x['champion'].casefold()=='garen' and x['slot']==0)
 imported={name:[float(entry['values'][f'Effect{effect}Level{rank}Amount']) for rank in range(1,6)] for name,effect in [('silence_seconds',3),('haste_seconds',5),('empowered_window_seconds',6)]};assert imported==native_values
 localization=dep/'DATA/menu/fontconfig_en_GB.txt';tooltip=anchor(localization,'game_spell_tooltip_GarenQ"')
 alternate_tooltip=anchor(localization,'game_spell_tooltip_GarenQBuff"')
 for token in ['Effect3Amount','Effect5Amount','Effect6Amount']:assert token in tooltip['excerpt']
 api=server/'GameServerLib/API/ApiFunctionManager.cs';buff=server/'GameServerLib/GameObjects/Buff.cs';empty=server/'GameServerLib/Scripting/CSharp/BuffScriptEmpty.cs'
 bindings=[anchor(api,'public static Buff AddBuff('),anchor(api,'buff = new Buff(_game, buffName, duration,'),anchor(buff,'Duration = duration;'),anchor(buff,'TimeElapsed += diff / 1000.0f;'),anchor(buff,'CSharpScriptEngine.CreateObjectStatic<IBuffGameScript>("Buffs", Name) ?? new BuffScriptEmpty()'),anchor(empty,'public StatsModifier StatsModifier { get; private set; } = new StatsModifier();')]
 all_classes=[(x['relative_path'],class_names(pathlib.Path(x['path']).read_text(encoding='utf-8'))) for x in review['script_inventory']]
 haste_classes=[p for p,names in all_classes if 'GarenQHaste' in names];assert haste_classes==[]
 matrix=[]
 for rank in range(1,6):
  for prop,call in [('silence_seconds',silence),('haste_seconds',haste)]:
   expected=native_values[prop][rank-1];matrix.append({'rank':rank,'quantity':prop,'native_base_seconds':expected,'community_requested_seconds':call['seconds'],'matches_native_base':call['seconds']==expected,'community_call_line':call['line']})
 assert sum(not x['matches_native_base'] for x in matrix)==9
 return {'id':'GarenQ_literal_duration_contradictions','review_status':'partial_named_semantic_review','fully_qualified':False,
  'community_source':identity(q),'community_git_snapshot':record['git_snapshot'],'native_source':identity(native),'native_tooltip':tooltip,'alternate_native_tooltip':alternate_tooltip,
  'community_calls':{'silence':silence,'haste':haste},'rank_matrix':matrix,'native_ranked_values':native_values,
  'duration_api_bindings':bindings,'missing_named_haste_class_in_797_sources':haste_classes,
  'current_consumers':[anchor(root/'crates/core/src/spells.rs','p.effects.speed_until = self.tick + seconds(garen_value(0, "Effect5", rank));'),
    anchor(root/'crates/core/src/spells.rs','p.effects.empowered_until = self.tick + seconds(garen_value(0, "Effect6", rank));'),
    anchor(root/'crates/core/src/attacks.rs','self.tick + spells::seconds(spells::garen_value(0, "Effect3", rank)),')],
  'current_imported_data':identity(current),'current_values_match_named_native_fields':True,
  'decision':'Exclude fixed1.5silence for ranks2..5 and fixed4haste for all ranks as faithful4.20 base-duration references; keep original ranked native fields/current Rust selection. No gameplay code modified.',
  'remaining_unknowns':['Native game_spell_tooltip_GarenQBuff states2seconds haste/2.5seconds silence while main GarenQ and ranked INIBIN fields vary. Effective template/use must be identified; neither text silently overrides the other.','Full C# dispatch/assembly availability and actual runtime buff behavior not executed. Missing source class is not proof of every possible loaded assembly.','Original server implementation, next-basic-attack timing, damage/tenacity/stacking and other Q interactions remain separate. The literal caller is gated on an enemy target; no equivalent native self-cast/next-attack behavior is inferred.'],
  'native_or_community_gameplay_code_executed':False}
def audit(root):
 review=load(root/'docs/fidelity_community_review_4_20.json');ref=load(root/'docs/reference_client_4_20.json');dep=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy'
 index=collections.defaultdict(list)
 for p in dep.rglob('*.luaobj'):index[p.stem.casefold()].append(p)
 bypath={};scripts=[]
 for item in review['script_inventory']:
  path=pathlib.Path(item['path']);ident=identity(path);assert ident['sha256']==item['sha256']
  classes=class_names(path.read_text(encoding='utf-8'));candidates=sorted({p for name in classes for p in index.get(name.casefold(),[])},key=str)
  for p in candidates:
   if str(p) not in bypath:
    try:bypath[str(p)]={'status':'parsed',**inspect(p)}
    except (OSError,ValueError,LuaReferenceError) as e:bypath[str(p)]={'status':'unqualified_chunk',**identity(p),'error':str(e),'code_executed':False}
  scripts.append({'relative_path':item['relative_path'],'sha256':item['sha256'],'declared_class_candidates':classes,'native_basename_candidates':[str(x) for x in candidates],
   'candidate_status':'no_matching_native_chunk' if not candidates else ('single_name_candidate_not_dispatch_proof' if len(candidates)==1 else 'ambiguous_candidates_no_arbitrary_choice'),
   'fully_semantically_qualified':False,'origin_and_git_snapshot_preserved':True})
 counts={'community_scripts':len(scripts),'unique_native_candidates_inspected':len(bypath),'candidate_status':dict(collections.Counter(x['candidate_status'] for x in scripts)),
  'parsed_chunks':sum(x['status']=='parsed' for x in bypath.values()),'unqualified_chunks':sum(x['status']!='parsed' for x in bypath.values()),
  'no_callback_prototypes_in_this_client_chunk':sum(x.get('client_chunk_has_no_callback_prototypes',False) for x in bypath.values()),
  'straight_line_literal_initialization':sum(x.get('literal_initialization',{}).get('qualified_straight_line_literals',False) for x in bypath.values()),
  'scripts_fully_semantically_qualified':0}
 return {'schema':'openleague_community_named_semantic_audit/v1','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'reference':'4.20.0.315 PUBLIC EUW/en_GB',
  'community_review_input':identity(root/'docs/fidelity_community_review_4_20.json'),'format_references':['https://www.lua.org/source/5.1/lopcodes.h.html','https://www.lua.org/source/5.1/lundump.c.html'],
  'native_deploy_root':str(dep),'native_lua_files_enumerated':sum(map(len,index.values())),'scripts':scripts,'native_chunks':list(bypath.values()),'named_cases':[garen_case(root,dep,review)],'counts':counts,
  'limits':['Class/basename association is a research candidate, never proven dispatch. Ambiguity/missing files remain explicit.','No callback prototype in a client chunk does not establish absent original server code elsewhere or faithful community mechanics.','Only complete straight-line literal initialization is decoded. Engine globals remain symbolic; any unsupported branch/call/table/closure discards inferred global values.','Lua5.1.5 sources document the format; exact native Lua patch implementation/version is not inferred.'],
  'native_or_community_gameplay_code_executed':False,'historical_game_process_launched':False,
  'producer':{**identity(pathlib.Path(__file__)),'reader':identity(pathlib.Path(__file__).with_name('lua51_reference.py'))}}
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));p.add_argument('--output',required=True);a=p.parse_args();out=pathlib.Path(a.output)
 if out.exists():p.error('Preserve prior audit output; select a new path.')
 result=audit(pathlib.Path(a.root));out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8');print(json.dumps(result['counts'],indent=2))
