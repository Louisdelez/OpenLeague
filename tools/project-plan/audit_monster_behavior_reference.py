"""Monster reference links:source requests and current partial engine behavior remain distinct."""
import pathlib,json,hashlib,sys,struct
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision101');sys.path[:0]=[str(R/'tools'),str(R/'tools/project-plan')]
from native_lua import Chunk,initialization
from lua51_reference import Reader,LuaReferenceError
from reference_inibin import read,hashkey,decode,InibinError
from rads_reference_membership import RadsReferenceMembership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-12.2-{i:02}' for i in range(1,8)];BOUNDARIES={TARGETS[0],TARGETS[4]};LOCAL=['crates/core/src/world.rs','crates/core/src/world_tests.rs','crates/core/src/lib.rs','crates/core/src/damage.rs','crates/core/src/progression.rs']
SPECS={TARGETS[0]:['if unit.kind.lane() || matches!(unit.kind, Kind::Turret | Kind::Fountain) {','let mut target = unit.target.filter(|id| {'],TARGETS[1]:['if self.combat_owner(source).is_some() {','.filter(|u| u.camp == Some(camp) && u.health > 0.)'],TARGETS[2]:['if unit.position.distance(home) > 800. || target.is_none() {','let path = self.dynamic_path(unit.position, home);'],TARGETS[3]:['p.health = p.max_health;','let home = unit.home;'],TARGETS[4]:['let mut target = unit.target.filter(|id| {','u.next_ai = 0;'],TARGETS[5]:['if camp.spawn_at.is_none()','camp.spawn_at = Some(self.tick + spells::seconds(camp.config.respawn_seconds));'],TARGETS[6]:['let credited=self.combat_owner(source);','killer.gold += gold + altar_bonus;']}
FINDINGS={
TARGETS[0]:('Leashed.FindNewTarget est exercé avec rayon850,inclusif,origine de leash et gardes de roam/état. AcquisitionRange natif300 pour deux golems et1200 pour Vilemaw correspond aux profils locaux ;475 des wolves/wraiths reste une valeur locale non trouvée dans ces quatre champs. Le bloc Rust de recherche par proximité vise voies/tourelles/fontaines ;les monstres y conservent une cible existante.','Qualifier la sélection effective de Leashed ou autre script,FindTargetNearPosition et les producteurs actuels de cible de monstre ;ne pas assimiler le rayon850 du script au champ AcquisitionRange ni déclarer une absence globale sur ce seul bloc.'),
TARGETS[1]:('damage_unit réveille les membres vivants du même camp lorsque combat_owner existe,en fixant target=source et next_ai=0. Le test Rust existant observe cette aggro partagée. LeashedCallForHelp possède un corps natif distinct de OnTakeDamage ;ses mots et constantes sont reliés,mais son appelant moteur reste inconnu.','Qualifier le dispatch natif des renforts,les équipes,types de dégâts,propriétaires et distances ;un réveil local de tout le camp ne prouve pas ces règles historiques.'),
TARGETS[2]:('Leashed déclare850/750/750/1150 et un seuil de compteur10. La source TimerRetreat est conservée. Rust demande le retour quand distance(home)>800 ou cible absente,avec une exception pour une attaque Vilemaw engagée.','Qualifier le déclenchement natif complet,les compteurs et rayons selon le script effectivement monté ;le seuil local800 ne devient pas850 sans comparaison et acceptation.'),
TARGETS[3]:('Le composant natif OutOfCombatRegen demande par défaut HP+0.125*MaxHP seulement si HP>0 et état non halted ;il ne plafonne pas lui-même la valeur passée à SetHP. Des taux fournis0/.25 sont conservés. Rust remet immédiatement health=max_health dans la branche home.','Qualifier le scheduler,Start/Stop,le plafonnement de SetHP et la sélection effective du composant ;la demande Lua de soin est distincte du soin moteur réalisé et du reset instantané local.'),
TARGETS[4]:('FindNewTarget ne cherche pas de cible en AI_RETREAT,INACTIVE ou RUN_IN_FEAR ;d’autres callbacks natifs OnTakeDamage/LeashedCallForHelp restent des voies distinctes à qualifier. Rust peut attribuer une cible par dommage au camp puis la conserver dans advance_npc_ai,mais la branche home peut la vider.','Qualifier l’interruption du reset via les véritables événements natifs et leur équivalent Rust,puis tester reprise,distance,état et soin ;le refus du helper FindNewTarget ne prouve pas un refus global de reprise.'),
TARGETS[5]:('Rust arme spawn_at une seule fois quand tous les membres sont morts ou absents,avec respawn_seconds ;un test actuel vérifie les morts partielles et la frontière du respawn. La preuve V42 de NeutralMinionDeath est relue par identité et tableaux d’instructions :une répétition de dernière mort demande à nouveau un timer dans son hôte observateur.','Qualifier l’unicité du producteur natif de mort,les timers moteur et l’ancrage initial ;les27 cas V42 sont hérités,non réexécutés ici. Garder distinct le garde local et la requête du callback original.'),
TARGETS[6]:('GoldGivenOnDeath/ExpGivenOnDeath des sept profils correspondent aux valeurs locales. damage_unit refuse une cible déjà morte,crédite combat_owner et réserve l’XP de monstre/boss au propriétaire ;le test Rust observe crédit exclusif et or. Les bonus autel et récompenses globales sont séparés.','Qualifier les doublons et tous les producteurs de dégâts,les crédits de pets et modificateurs natifs ;les champs de base exacts et le test courant ne prouvent pas l’économie complète ni son acceptation.')}
def anchor(root,t,i,n):
 p=LOCAL[0];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+t+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='monster_behavior_'+('boundary_' if t in BOUNDARIES else 'partial_')+t.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root);m=RadsReferenceMembership(loc['previous_root']);obs=load(V/'native-monster-sources.json');lua=load(V/'monster-lua-observation.json');rust=load(V/'rust-monster-tests.json')
 for name in ['native-monster-sources.json','monster-lua-observation.json','rust-monster-tests.json']:keep(V/name)
 for d in [obs,lua,rust]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer']);check('passed_'+d['producer']['path'],d['passed'] is True)
 for d in [obs,lua]:check('python_'+d['producer']['path'],keep(d['python']['path'])==d['python'])
 def native(s,logical):
  check('source_'+logical,keep(s['path'])==s);member=m.inspect(logical,s['path'],s);check('member_'+logical,member['status']=='matches_selected_project_manifest');return member
 parsed={};reader_cases=[]
 for s in obs['scripts']:
  check('membership_record_'+s['logical'],native(s['source'],s['logical'])==s['membership']);raw=pathlib.Path(s['source']['path']).read_bytes();c=Chunk(raw);p=c.function();b=Reader(raw).parse();check('complete_parse_'+s['logical'],c.i==len(raw))
  def equal(a,b):return a['code']==b['words'] and a['constants']==b['constants'] and len(a['functions'])==len(b['children']) and all(equal(x,y) for x,y in zip(a['functions'],b['children']))
  check('dual_parse_'+s['logical'],equal(p,b));check('initialization_'+s['logical'],json.loads(json.dumps(initialization(p)))==s['initialization']);check('top_constants_'+s['logical'],p['constants']==s['top_constants']);names={}
  for pc,w in enumerate(p['code'][:-1]):
   n=p['code'][pc+1]
   if w&63==36 and n&63==7 and ((w>>6)&255)==((n>>6)&255) and p['functions'][w>>14]['flags'][0]==0:names[w>>14]=p['constants'][n>>14]
  fs=[dict(index=i,name=names.get(i),lines=f['lines'],flags=f['flags'],constants=f['constants'],words=f['code'],code_sha256=b['children'][i]['code_sha256']) for i,f in enumerate(p['functions'])];check('function_records_'+s['logical'],s['functions']==fs);parsed[s['logical']]=b
  for name,broken in [('truncated',raw[:20]),('trailing',raw+b'\0'),('header',b'bad'+raw[3:])]:
   try:Reader(broken).parse()
   except LuaReferenceError as e:reader_cases.append(dict(source=s['logical'],case=name,expected='refused',observed=str(e)))
   else:raise ValueError('Malformed Lua accepted')
 world=load(root/'data/4.20/map10_world.json');check('world_identity',keep(root/'data/4.20/map10_world.json')==obs['current_world']);profiles=[]
 for row in obs['profiles']:
  logical='DATA/Characters/'+row['name']+'/'+row['name']+'.inibin';check('profile_member_'+row['name'],native(row['source'],logical)==row['membership']);v=read(row['source']['path']);check('current_profile_'+row['name'],world['definitions'][row['name']]==row['current_definition'])
  for f in row['fields']:check('field_'+row['name']+'_'+f['field'],f['present']==(f['key'] in v) and f['value']==v.get(f['key']))
  for field,current in [('GoldGivenOnDeath','gold'),('ExpGivenOnDeath','experience')]:check('reward_'+row['name']+'_'+field,float(v[hashkey('Data',field)])==row['current_definition'][current])
  value=v.get(hashkey('Data','AcquisitionRange'));check('range_present_'+row['name'],value is None or float(value)==row['current_definition']['acquisition']);profiles.append(dict(name=row['name'],native_acquisition=value,current_acquisition=row['current_definition']['acquisition']))
 check('seven_profiles',len(profiles)==7 and sum(x['native_acquisition'] is not None for x in profiles)==3)
 for k in ['lua_module','adapter_source']:check('lua_'+k,keep(lua[k]['path'])==lua[k])
 check('lua_scope',lua['case_count']==len(lua['cases'])==78 and lua['engine_apis_are_adapters'] and lua['component_dispatch_and_loading_are_adapters'] and all(lua[k] is False for k in ['script_selection_by_engine_proven','native_timer_scheduler_executed','actual_healing_or_movement_engine_executed','game_process_executed']))
 for x in lua['native_identities']:check('lua_identity_'+x['name'],x['source'] in [s['source'] for s in obs['scripts']] and x['raw32_roundtrip_exact'] and x['instruction_arrays_preserved'])
 for i,c in enumerate(lua['cases']):check('lua_case_'+str(i),c['expected']==c['observed'])
 check('adapter_refusals',len(lua['adapter_refusals'])==2 and all(x['expected']==x['observed']=='refused' for x in lua['adapter_refusals']))
 failure=(V/'lua-probe.log').read_text(encoding='utf8');check('initial_false_heal_expectation_preserved',"'AI_ATTACK', None, 0, []" in failure and 'AssertionError' in failure)
 for k in ['source','consumer','lock']:check('rust_'+k,keep(rust[k]['path'])==rust[k])
 for c in rust['cases']:
  for k in ['binary','log']:check('rust_identity_'+c['name']+'_'+k,keep(c[k]['path'])==c[k])
  check('rust_case_'+c['name'],c['exit_code']==0 and c['tests_passed']==1 and c['tests_failed']==0 and '1 passed; 0 failed' in pathlib.Path(c['log']['path']).read_text(encoding='utf8') and '--exact' in c['command'])
 check('two_actual_rust_tests',rust['case_count']==len(rust['cases'])==2)
 oldpath=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision42/original-map10-neutral-callbacks-lua51.json');old=load(oldpath);keep(oldpath);source=next(s for s in obs['scripts'] if s['logical']=='LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj');check('inherited_native_identity',old['source']==source['source']);b=parsed[source['logical']]
 def words(p):return [p['code_sha256']]+[h for f in p['children'] for h in words(f)]
 check('inherited_instruction_arrays',old['instruction_array_sha256']==words(b) and old['raw32_roundtrip_exact'] and old['instruction_arrays_preserved']);deaths=old['death_cases'];ordered=[c for c in deaths if c['profile']=='ordered_member_death'];dupes=[c for c in deaths if c['profile']=='duplicate_last_member_death'];unknown=[c for c in deaths if c['profile']=='unknown_member_name'];check('inherited_death_census',len(deaths)==27 and len(ordered)==18 and len(dupes)==8 and len(unknown)==1);check('inherited_timer_requests',sum(len(c['calls']) for c in ordered)==8 and sum(len(c['calls']) for c in dupes)==8 and unknown[0]['calls']==[] and unknown[0]['all_camps_unchanged']);check('inherited_scope',old['native_engine_API_implementation_executed'] is False and old['actual_game_event_producer_or_duplicate_dispatch_qualified'] is False)
 for k in ['producer','format_adapter']:check('inherited_'+k,keep(old[k]['path'])==old[k])
 local=(root/LOCAL[0]).read_text(encoding='utf8');conditions=['if unit.health <= 0. {','if self.winner.is_some() {return;}','credited','Kind::Monster || kind == Kind::Boss','p.target = None;','p.next_ai = self.tick + 8;','stationary_vilemaw','camp.members.clear();']
 for n in conditions:check('current_branch_'+n,n in local)
 check('source_leash_radii',all(obs['scripts'][0]['initialization']['globals'][k]==v for k,v in {'LEASH_RADIUS':850,'LEASH_PROTECTION_RADIUS':750,'INNER_RELEASH_RADIUS':750,'RELEASH_RADIUS':1150,'LEASH_COUNTER_THRESHOLD':10}.items()))
 for t in TARGETS:
  for i,n in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,n)['role'])
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for p in LOCAL+['tools/native_lua.py','tools/project-plan/lua51_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','docs/reference_client_4_20.json','docs/FIDELITY_CAMP_REFERENCE_4_20.md','docs/fidelity_registry_camp_revision_4_20.json']:keep(root/p)
 for p in ['prepare_context.py','phase-and-package-context.json','native-inspection.log','probe_monster_lua.py','lua-probe.log','lua-probe-corrected.log','rust-run.log']:keep(V/p)
 facts=dict(sources=obs,lua=lua,rust=rust,profile_acquisition=profiles,reader_refusals=reader_cases,inherited_camp=dict(receipt=str(oldpath),source=old['source'],original_instruction_hashes_verified=True,death_cases=deaths,observations_reexecuted=False,recorded_runtime=old['runtime'],recorded_python_equals_current=old['runtime']['python']==pin(sys.executable),native_event_dispatch_qualified=False),policies=dict(script_selection_qualified=False,native_target_helper_qualified=False,complete_leash_and_patience_qualified=False,SetHP_engine_clamp_qualified=False,timer_scheduler_qualified=False,all_rewards_qualified=False,full_task_scope_complete=False,original_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for s in _CACHE[key][1]:require(pin(s['path'])==s,'source changed '+s['path'])
 return _CACHE[key]
def bindings(f,t):
 index=4 if t==TARGETS[3] else 5 if t==TARGETS[5] else 0
 s=f['sources']['profiles'][0]['source'] if t==TARGETS[6] else f['sources']['scripts'][index]['source']
 return [dict(path=s['path'],role='native_monster_source_with_selection_and_engine_limits',selector='Exact source;callback,metadata or inherited evidence role stated;not proof of complete engine behavior')]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_monster_behavior_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,n) for i,n in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),original_lua_cases=78,rust_tests=2,original_game_executed=False)
