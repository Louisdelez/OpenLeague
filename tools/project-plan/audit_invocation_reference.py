"""Invocation links: exact native inputs, bounded observations and current consumers."""
import pathlib,json,hashlib,sys,re
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision102');sys.path[:0]=[str(R/'tools'),str(R/'tools/project-plan')]
from native_lua import Chunk,initialization
from lua51_reference import Reader,LuaReferenceError
from reference_inibin import read,hashkey
from rads_reference_membership import RadsReferenceMembership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-12.3-{i:02}' for i in range(1,8)];BOUNDARIES={TARGETS[4]}
A='crates/core/src/annie_r.rs';T='crates/core/src/trundle_e.rs';S='tools/project-plan/store.py'
SPECS={TARGETS[0]:[(A,'for (owner,team,height,r) in casts {'),(A,'pub(crate) fn combat_owner(&self,id:u32)->Option<u32> {')],TARGETS[1]:[('crates/server/src/main.rs','game.command(*player, action)'),(A,'if let Some(pet)=self.tibbers(id) {return self.guide_tibbers(id,pet,point);}'),('crates/core/src/annie_w.rs','if p.health<=0. {return Err("champion dead".into());}')],TARGETS[2]:[(A,'u.pet=Some(Pet{owner,rank:r.rank,spawned:self.tick'),(A,'self.units.values().find(|u|u.health>0.&&u.pet.as_ref().is_some_and')],TARGETS[3]:[(A,'if self.tick>=pet.expires||!self.players.contains_key(&pet.owner) {'),(T,'fn trundle_e_live(&self,p:&Pillar)->bool')],TARGETS[4]:[('crates/core/src/spells.rs','return Err("champion spell not implemented".into());'),(A,'u.max_health=value(&format!("health{}",r.rank))')],TARGETS[5]:[(T,'pub struct Pillar {'),(T,'fn eligible(kind:world::Kind)->bool')],TARGETS[6]:[(S,'def task(self,ident):'),(S,'def copy_text(self,kind,ident):')]}
FINDINGS={
TARGETS[0]:('Tibbers reçoit owner et team du lanceur au spawn ;combat_owner attribue le crédit au joueur présent. Les scripts LuluFairyAI et MalzaharVoidling consultent respectivement GetOwner et GetGoldRedirectTarget,avec Die si nul. Les 24 profils natifs et neuf scripts sont identifiés,mais leur montage par invocation reste distinct.','Qualifier les producteurs natifs de propriétaire/équipe et leur stabilité sur chaque type ;GetOwner et GoldRedirectTarget ne deviennent pas des synonymes par leurs usages voisins. Étendre au clonage et aux objets auxiliaires.'),
TARGETS[1]:('Le serveur route Command depuis clients[peer] vers game.command(player,action),sans identifiant de propriétaire fourni par cette branche. cast_tibbers sélectionne le pet du lanceur ;le guide conserve coût/cooldown et refuse une commande morte au point d’entrée. Sept tests Rust incluent propriétaire distinct. Quatre callbacks natifs OnOrder renvoient true même pour un ordre inconnu ;ce retour ne qualifie pas le dispatcher.','Qualifier les sessions réseau réelles,les commandes forgées et le dispatcher natif complet ;les enums restent symboliques. Malzahar HOLD atteint BetPetReturnRadius,API non fournie dans le banc,et reste non qualifié.'),
TARGETS[2]:('Tibbers utilise les règles locales par rang,45 secondes,et redirige un recast vers le pet vivant non expiré. Les tests vérifient trois rangs,un seul spawn et expiration sans prime. Le pilier Trundle expire à6 secondes dans son contrat local. Les callbacks OnInit natifs demandent des timers distincts ;leur scheduling moteur n’est pas exécuté.','Qualifier durée et plafonds pour chaque invocation,les recasts concurrents et toutes les morts/expirations. Les constantes locales et commandes de timer ne prouvent pas les plafonds historiques des tourelles,plantes,ghouls ou clones.'),
TARGETS[3]:('Le test Rust observe Tibbers survivant à la mort du joueur mais supprimé si ce joueur est retiré ;un cast encore en attente est annulé à la mort. Le pilier Trundle survit à la mort sans prolongation mais disparaît au départ/fin. Lulu/Malzahar demandent Die quand le getter fournit nil ;AzirSoldier.Update utilise GoldRedirectTarget et fait de même.','Qualifier ce que les getters natifs renvoient réellement après mort,déconnexion,reconnexion ou remplacement. Un propriétaire nul ne prouve pas une règle de mort du propriétaire ;ne pas généraliser la politique Tibbers.'),
TARGETS[4]:('Le point d’entrée des sorts refuse actuellement les champions hors branches implémentées. Tibbers reconstruit ses statistiques par rang et ne constitue pas un clone. MonkeyKingClone.inibin et les métadonnées de kit de Shaco/Leblanc/Yorick sont des entrées natives recensées,mais ne fournissent pas à eux seuls une règle de copie des statistiques/apparences.','Identifier les producteurs effectifs de clones,les champs copiés/actualisés et les skins sélectionnés,puis leurs consommateurs actuels. Les imports de formes et les Clone Rust de structures de données ne prouvent aucun clonage de champion.'),
TARGETS[5]:('Le pilier Trundle possède owner/team/center/rank/début/fin et agit via les cercles de navigation ;ses filtres excluent structures/boss des cibles de poussée/ralentissement. Les deux tests correspondants sont frais. Les sources Azir,H28GEvolutionTurret,Jarvan et plantes sont distinctes,avec 24 profils candidats identifiés.','Qualifier séparément terrain temporaire,unité ciblable,tourelle,plante,piège et objet visuel ;la géométrie locale Trundle ne qualifie pas les constructions Azir/Heimer ni tous les ciblages.'),
TARGETS[6]:('Le plan contient déjà96 fiches UNIT pour les24 profils inspectés,quatre par profil,consultées par Store.task et Store.copy_text. Les122 kits sont parcourus sur2492 INIBIN hors Skins,avec candidats lexicaux conservés et absence de correspondance non interprétée comme absence d’invocation. Trois fichiers communautaires contiennent des appels de création candidats,dont un auxiliaire Lux.','Prouver l’exhaustivité par les producteurs des kits,les clones sans profil dédié,les pièges et objets auxiliaires ;classifier les faux positifs lexicaux et les formes personnelles. Les24 profils ne forment pas une liste complète et aucune fiche existante n’est supprimée ou cochée.')}
def anchor(root,t,i,spec):
 p,n=spec;hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+t+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='invocation_'+('boundary_' if t in BOUNDARIES else 'partial_')+t.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root);m=RadsReferenceMembership(loc['previous_root'])
 obs=load(V/'native-invocation-sources.json');lua=load(V/'invocation-lua-observation.json');rust=load(V/'rust-invocation-tests.json')
 for name in ['native-invocation-sources.json','invocation-lua-observation.json','rust-invocation-tests.json']:keep(V/name)
 for d in [obs,lua,rust]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer']);check('passed_'+d['producer']['path'],d['passed'] is True)
 for d in [obs,lua]:check('python_'+d['producer']['path'],keep(d['python']['path'])==d['python'])
 def native(s,logical):
  check('source_'+logical,keep(s['path'])==s);member=m.inspect(logical,s['path'],s);check('member_'+logical,member['status']=='matches_selected_project_manifest');return member
 def member_equal(a,b):
  a=dict(a,observed=dict(a['observed'],path=str(pathlib.Path(a['observed']['path']).resolve())));b=dict(b,observed=dict(b['observed'],path=str(pathlib.Path(b['observed']['path']).resolve())));return a==b
 reader_cases=[]
 for s in obs['scripts']:
  check('membership_record_'+s['logical'],native(s['source'],s['logical'])==s['membership']);raw=pathlib.Path(s['source']['path']).read_bytes();c=Chunk(raw);p=c.function();b=Reader(raw).parse();check('complete_parse_'+s['logical'],c.i==len(raw))
  def equal(a,b):return a['code']==b['words'] and a['constants']==b['constants'] and len(a['functions'])==len(b['children']) and all(equal(x,y) for x,y in zip(a['functions'],b['children']))
  check('dual_parse_'+s['logical'],equal(p,b));check('initialization_'+s['logical'],json.loads(json.dumps(initialization(p)))==s['initialization']);check('top_constants_'+s['logical'],p['constants']==s['top_constants']);names={}
  for pc,w in enumerate(p['code'][:-1]):
   n=p['code'][pc+1]
   if w&63==36 and n&63==7 and ((w>>6)&255)==((n>>6)&255) and p['functions'][w>>14]['flags'][0]==0:names[w>>14]=p['constants'][n>>14]
  fs=[dict(index=i,name=names.get(i),lines=f['lines'],flags=f['flags'],constants=f['constants'],words=f['code'],code_sha256=b['children'][i]['code_sha256']) for i,f in enumerate(p['functions'])];check('function_records_'+s['logical'],s['functions']==fs)
  for name,broken in [('truncated',raw[:20]),('trailing',raw+b'\0'),('header',b'bad'+raw[3:])]:
   try:Reader(broken).parse()
   except LuaReferenceError as e:reader_cases.append(dict(source=s['logical'],case=name,expected='refused',observed=str(e)))
   else:raise ValueError('Malformed Lua accepted')
 for row in obs['profiles']:
  logical='DATA/Characters/'+row['name']+'/'+row['name']+'.inibin';check('profile_member_'+row['name'],member_equal(native(row['source'],logical),row['membership']));v=read(row['source']['path'])
  for f in row['fields']:check('field_'+row['name']+'_'+f['field'],f['present']==(f['key'] in v) and f['value']==v.get(f['key']))
  check('strings_'+row['name'],row['string_values']==[dict(key=k,value=x) for k,x in v.items() if isinstance(x,str) and not re.fullmatch(r'[-+\d.eE]+',x)])
 check('profiles_and_scripts',len(obs['profiles'])==24 and len(obs['scripts'])==9)
 roster=load(root/'data/4.20/champions.json');check('roster',keep(root/'data/4.20/champions.json')==obs['roster'] and [c['id'] for c in roster]==[c['champion'] for c in obs['kits']] and len(roster)==122)
 names={r['name'].casefold() for r in obs['profiles']};inventory=[];kit_members=[]
 for kit in obs['kits']:
  d=pathlib.Path(kit['native_directory']);expected_dir=m.deploy/'DATA/Characters'/d.name;check('kit_directory_'+kit['champion'],d==expected_dir and d.name.casefold()==kit['champion']);rows=[];count=0
  for p in sorted(d.rglob('*.inibin')):
   if '/skins/' in p.as_posix().casefold():continue
   count+=1;values=read(p);s=keep(p);inventory.append(s);member=m.inspect(p.relative_to(m.deploy).as_posix(),p,s);check('kit_member_'+str(p),member['status']=='matches_selected_project_manifest');kit_members.append(dict(path=str(p),status=member['status']))
   hits=[dict(key=k,value=v) for k,v in values.items() if isinstance(v,str) and (v.casefold() in names or re.search(r'pet|clone|ghoul|tibbers|voidling|spiderling|plant|soldier|turret|faerie|guardian',v,re.I))]
   if hits:rows.append(dict(source=s,matches=hits))
  check('kit_results_'+kit['champion'],kit['files_scanned']==count and kit['candidates']==rows and kit['complete_summon_census'] is False)
 check('kit_inventory',inventory==obs['kit_files'] and len(inventory)==2492)
 # Existing named tasks are inspected through mutable registry rows, not pinned as immutable source.
 tasks=load(root/'docs/completion_tasks_2026-10-20.json')['tasks'];named=[]
 for t in tasks:
  hay=(t['id']+' '+t.get('title','')+' '+str(t.get('entity',''))).casefold()
  if any(n in hay for n in names):named.append({k:t.get(k) for k in ['id','title','kind','entity','status']})
 check('existing_named_tasks',named==obs['named_plan_tasks']);unit=[t for t in named if t['id'].startswith('UNIT-')];check('four_named_tasks_per_profile',len(unit)==96 and all(sum(t['entity']==r['name'] for t in unit)==4 for r in obs['profiles']))
 for row in obs['community_creation_hits']:
  s=row['source'];check('community_identity_'+s['path'],keep(s['path'])==s);text=pathlib.Path(s['path']).read_text(encoding='utf-8-sig');hits=[dict(line=i+1,text=l.strip()) for i,l in enumerate(text.splitlines()) if re.search(r'\b(CreatePet|CreateClone|CreateMinion|AddMinion)\b',l)];check('community_lexical_'+s['path'],hits==row['matches'] and row['native_authority'] is False)
 check('community_census',len(obs['community_creation_hits'])==3)
 for k in ['lua_module','adapter_source']:check('lua_'+k,keep(lua[k]['path'])==lua[k])
 check('lua_scope',lua['case_count']==len(lua['cases'])==47 and lua['engine_apis_are_adapters'] and lua['symbolic_state_and_order_enums'] and all(lua[k] is False for k in ['script_selection_by_engine_proven','native_dispatch_return_semantics_qualified','native_timer_scheduler_executed','complete_owner_lifecycle_qualified','game_process_executed']))
 for x in lua['native_identities']:check('lua_identity_'+x['name'],x['source'] in [s['source'] for s in obs['scripts']] and x['raw32_roundtrip_exact'] and x['instruction_arrays_preserved'])
 for i,c in enumerate(lua['cases']):check('lua_case_'+str(i),c['expected']==c['observed'])
 check('unprovided_original_api_refusal',len(lua['adapter_refusals'])==1 and 'BetPetReturnRadius' in lua['adapter_refusals'][0]['observed'] and lua['adapter_refusals'][0]['native_api_absence_proven'] is False)
 for s in rust['sources']:check('rust_source_'+s['path'],keep(s['path'])==s)
 for c in rust['cases']:
  for k in ['binary','log']:check('rust_identity_'+c['name']+'_'+k,keep(c[k]['path'])==c[k])
  check('rust_case_'+c['name'],c['exit_code']==0 and c['tests_passed']==1 and c['tests_failed']==0 and '1 passed; 0 failed' in pathlib.Path(c['log']['path']).read_text(encoding='utf8') and '--exact' in c['command'])
 check('seven_actual_rust_tests',rust['case_count']==len(rust['cases'])==7)
 for t in TARGETS:
  for i,n in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,n)['role'])
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for p in sorted({s[0] for specs in SPECS.values() for s in specs}):keep(root/p)
 for p in ['data/4.20/annie_r_rules.json','data/4.20/tibbers_definition.json','data/4.20/native_spells_420.json','tools/native_lua.py','tools/project-plan/lua51_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','docs/reference_client_4_20.json','docs/FIDELITY_PET_ORDER_REFERENCE_4_20.md','docs/fidelity_registry_pet_order_revision_4_20.json']:keep(root/p)
 for p in ['prepare_context.py','phase-and-package-context.json','native-inspection.log','lua-probe.log','rust-run.log']:keep(V/p)
 facts=dict(sources=obs,lua=lua,rust=rust,kit_membership=kit_members,reader_refusals=reader_cases,policies=dict(complete_summon_census=False,complete_cloning_rules_qualified=False,script_selection_qualified=False,native_dispatch_qualified=False,native_getter_death_semantics_qualified=False,timer_scheduler_qualified=False,all_lifetimes_and_caps_qualified=False,full_task_scope_complete=False,original_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for s in _CACHE[key][1]:require(pin(s['path'])==s,'source changed '+s['path'])
 return _CACHE[key]
def bindings(f,t):
 sources=f['sources'];names={s['logical']:s['source'] for s in sources['scripts']};profiles={s['name']:s['source'] for s in sources['profiles']}
 chosen=[names['DATA/Scripts/'+('MalzaharVoidling' if t in TARGETS[:4] else 'H28GEvolutionTurret' if t==TARGETS[5] else 'Pet')+'.luaobj']]
 if t==TARGETS[4]:chosen=[profiles['MonkeyKingClone']]
 elif t==TARGETS[6]:chosen=[s['source'] for s in sources['profiles']]
 return [dict(path=s['path'],role='native_invocation_input_with_producer_and_engine_limits',selector='Exact native profile or Lua; specific observations and exclusions in receipt,not complete invocation fidelity') for s in chosen]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_invocation_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,n) for i,n in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),original_lua_cases=47,rust_tests=7,original_game_executed=False)
