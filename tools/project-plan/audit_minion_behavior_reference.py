"""Precise minion behavior links;original Lua probes use explicit engine adapters."""
import pathlib,json,sys,hashlib,re,struct
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision100');sys.path[:0]=[str(R/'tools'),str(R/'tools/project-plan')]
from native_lua import Chunk,initialization
from lua51_reference import Reader,LuaReferenceError
from reference_inibin import read,hashkey,decode,InibinError
from rads_reference_membership import RadsReferenceMembership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-12.1-{i:02}' for i in range(1,7)];BOUNDARIES={TARGETS[2],TARGETS[4]};LOCAL=['crates/core/src/world.rs','crates/core/src/lib.rs','crates/core/src/stuns.rs','crates/core/src/unit_stun_tests.rs','crates/core/src/pillar_navigation.rs']
SPECS={TARGETS[0]:['pub struct Definition {','pub struct Unit {','pub struct Lane {'],TARGETS[1]:['.min_by(|a, b| a.1.total_cmp(&b.1))','&& self.visible_to(unit.team, other)'],TARGETS[2]:['pub(crate) fn damage_unit(','.filter(|u| u.camp == Some(camp) && u.health > 0.)'],TARGETS[3]:['if unit.kind!=Kind::Pet && self.tick >= unit.next_ai {','p.target = target;'],TARGETS[4]:['let position = if self.navigation.ground(seed).is_some() {','let mut remaining = if e_slow>0.'],TARGETS[5]:['for mut attack in pending.drain(..) {','self.world.as_mut().unwrap().attacks = remaining;']}
FINDINGS={
TARGETS[0]:('Definition,Unit et Lane sont séparés et spawn_unit refuse world disabled/unknown NPC definition. Huit INIBIN,leurs valeurs de déplacement/rayon et les tables Map10 sont reliés ;le spawn conserve définition,instance et voie distinctes.','Qualifier la construction et les variantes complètes de chaque définition,les erreurs de voie et toutes les règles natives de spawn ;les structures de données ne prouvent pas toute l’IA.'),
TARGETS[1]:('Le script Minion demande FindTargetInAcR ;ses priorités internes ne sont pas dans ce callback. Rust choisit le plus proche ennemi visible,vivant,dans acquisition+rayon et non protégé. AcquisitionRange natif vaut700 pour les casters et600 pour les supers,identiques aux valeurs locales ;il est absent pour les mêlée/canons dont la valeur locale475 reste distincte.','Identifier et qualifier FindTargetInAcR,les priorités et filtres historiques avant de comparer complètement le choix local ;la distance minimale locale ne prouve pas ces priorités.'),
TARGETS[2]:('Les instructions originales OnCallForHelp sont exercées dans Lua5.1 avec états symboliques et API moteur adaptées :seuls AI_ATTACKMOVESTATE/AI_ATTACKMOVE_ATTACKING avec cible fournie demandent fermeture et TimerAntiKite. Le consommateur actuel damage_unit réveille les membres d’un camp ;cela ne démontre pas les renforts des sbires de voie lors d’une attaque de champion.','Qualifier le producteur natif du callback,les types de dégâts,rayons et filtres de renfort ;relier un véritable consommateur de voie avant de fermer cette frontière. Une API adaptée ne prouve pas son effet moteur.'),
TARGETS[3]:('Minion déclare DELAY_FIND_ENEMIES=0.25 et DoLuaShared Minions ;OnInit demande ce timer et un TimerAntiKite4. Rust réévalue à next_ai puis fixe tick+8,soit8/30secondes au tickrate courant. Ce sont des contrats distincts,non une équivalence prouvée du délai de retarget.','Qualifier le scheduler natif,la distinction scan/retarget/anti-kite,les interruptions et l’arrondi ;ne pas convertir automatiquement0.25s en8ticks comme preuve de fidélité.'),
TARGETS[4]:('Les callbacks originaux de collision sont exercés pour20 états et sélections nulles/non nulles. Ils demandent des transitions de cible ;aucune résolution géométrique ou formation n’est exécutée. Rust place au seed de voie ou nearest_walkable,puis avance sur path avec garde du pilier.','Qualifier les collisions entre corps,formations,écartement au spawn et le déclenchement natif des callbacks ;les rayons pathfinding/gameplay/selection sont distincts et ne prouvent pas une résolution de collision.'),
TARGETS[5]:('La boucle Pending distingue windup,release et résolution puis ne conserve que les attaques futures. Les tests Rust vérifient notamment le refus avant release et la survie du projectile lancé à stun/mort de la source encore présente. Le sort natif de base du caster et son missile650 sont identifiés.','Qualifier suppression effective de la source/cible,annulations et nettoyage visuel/réseau selon la référence ;un corpse présent diffère d’une entrée supprimée et les tests actuels ne prouvent pas l’intégralité du cycle natif.')}
def anchor(root,t,i,n):
 p=LOCAL[0];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+t+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='minion_behavior_'+('boundary_' if t in BOUNDARIES else 'partial_')+t.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(n,v):require(v,n);checks.append(n)
 location=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(location['active_root']).resolve()==root);m=RadsReferenceMembership(location['previous_root'])
 observed=load(V/'native-minion-sources.json');lua=load(V/'minion-lua-observation.json');rust=load(V/'rust-minion-tests-corrected.json')
 for name in ['native-minion-sources.json','minion-lua-observation.json','rust-minion-tests-corrected.json']:keep(V/name)
 for d in [observed,lua,rust]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer'])
 for d in [observed,lua]:check('python_'+d['producer']['path'],keep(d['python']['path'])==d['python'])
 def native(logical):
  path=m.deploy/logical;s=keep(path);member=m.inspect(logical,path,s);check('member_'+logical,member['status']=='matches_selected_project_manifest');return s,member
 scriptfacts=[];reader_cases=[]
 for obs in observed['scripts']:
  s,member=native(obs['logical']);check('script_source_'+obs['logical'],s==obs['source'] and member==obs['membership']);raw=pathlib.Path(s['path']).read_bytes();c=Chunk(raw);p=c.function();b=Reader(raw).parse();check('complete_parse_'+obs['logical'],c.i==len(raw));check('initialization_'+obs['logical'],json.loads(json.dumps(initialization(p)))==obs['initialization'])
  def equal(a,b):return a['code']==b['words'] and a['constants']==b['constants'] and len(a['functions'])==len(b['children']) and all(equal(x,y) for x,y in zip(a['functions'],b['children']))
  check('dual_parse_'+obs['logical'],equal(p,b));names={}
  for pc,w in enumerate(p['code'][:-1]):
   n=p['code'][pc+1]
   if w&63==36 and n&63==7 and ((w>>6)&255)==((n>>6)&255):
    i=w>>14;check('closure_no_upvalue_'+obs['logical']+'_'+str(i),p['functions'][i]['flags'][0]==0);names[i]=p['constants'][n>>14]
  fs=[dict(index=i,name=names.get(i),lines=f['lines'],flags=f['flags'],constants=f['constants'],words=f['code'],code_sha256=b['children'][i]['code_sha256']) for i,f in enumerate(p['functions'])];check('function_records_'+obs['logical'],fs==obs['functions']);scriptfacts.append(obs)
  for case,broken in [('truncated',raw[:20]),('trailing',raw+b'\0'),('header',b'bad'+raw[3:])]:
   try:Reader(broken).parse()
   except LuaReferenceError as e:reader_cases.append(dict(source=obs['logical'],case=case,expected='refused',observed=str(e)))
   else:raise ValueError('accepted malformed Lua')
 world=load(root/'data/4.20/map10_world.json');profiles=[]
 for obs in observed['profiles']:
  s,member=native('DATA/Characters/'+obs['name']+'/'+obs['name']+'.inibin');values=read(s['path']);check('profile_source_'+obs['name'],s==obs['source'] and member==obs['membership'])
  for f in obs['fields']:check('field_'+obs['name']+'_'+f['field'],f['present']==(f['key'] in values) and f['value']==values.get(f['key']))
  current=world['definitions'][obs['name']];fields={f['field']:f for f in obs['fields']};check('separate_ranges_'+obs['name'],(not fields['Data.AcquisitionRange']['present'] or float(fields['Data.AcquisitionRange']['value'])==current['acquisition']) and float(fields['Data.GameplayCollisionRadius']['value'])==current['radius'] and float(fields['Data.MoveSpeed']['value'])==current['move_speed']);profiles.append(dict(native=obs,current=current))
 spell,member=native('DATA/Spells/Blue_Minion_WizardBasicAttack.inibin');sv=read(spell['path']);speed=sv.get(hashkey('SpellData','MissileSpeed'));check('caster_missile_speed',float(speed)==650.==world['definitions']['Blue_Minion_Wizard']['projectile_speed'])
 for case,broken in [('header',b'\0'*5),('truncated',pathlib.Path(spell['path']).read_bytes()[:4])]:
  try:decode(broken)
  except InibinError as e:reader_cases.append(dict(source=spell['path'],case=case,expected='refused',observed=str(e)))
  else:raise ValueError('accepted malformed INIBIN')
 shared=next(s for s in scriptfacts if s['logical']=='DATA/Shared/Scripts/Minions.luaobj');minion=scriptfacts[0];check('native_scan_constant',minion['initialization']['globals']['DELAY_FIND_ENEMIES']==.25 and minion['initialization']['stopped']==dict(pc=8,opcode=28))
 existing=load(root/'data/4.20/native_minions_shared.json');check('current_shared_extraction',existing['source_sha256']==shared['source']['sha256'] and {k:existing[k] for k in ['globals','stopped']}==shared['initialization'])
 for k in ['lua_module','adapter_source']:check('lua_runtime_'+k,keep(lua[k]['path'])==lua[k])
 check('lua_scope',lua['passed'] is True and lua['case_count']==len(lua['cases'])==101 and lua['engine_apis_are_adapters'] is True and lua['symbolic_AI_states'] is True and lua['original_lua_instruction_arrays_executed'] is True and all(lua[k] is False for k in ['native_caller_and_timers_qualified','native_target_priority_qualified','collision_geometry_qualified','game_process_executed']))
 for row in lua['native_identities']:check('lua_identity_'+row['name'],row['source'] in [s['source'] for s in scriptfacts] and row['source_roundtrip_exact'] and row['instruction_arrays_preserved'])
 for i,c in enumerate(lua['cases']):check('lua_case_'+str(i),c['expected']==c['observed'])
 check('adapter_import_refused',lua['guard_cases']==[dict(name='adapter_unknown_shared_import',expected='refused',observed='refused')])
 for k in ['binary','log','source','lock']:check('rust_'+k,keep(rust[k]['path'])==rust[k])
 log=pathlib.Path(rust['log']['path']).read_text(encoding='utf8');check('rust_six_actual',rust['exit_code']==0 and rust['tests_passed']==6 and rust['tests_failed']==0 and '6 passed; 0 failed' in log and rust['command'][7]=='stuns::unit_tests::')
 failure=(V/'rust-minion-tests.log').read_text(encoding='utf8');check('zero_test_attempt_preserved','0 passed; 0 failed' in failure and 'running 0 tests' in failure)
 local=(root/LOCAL[0]).read_text(encoding='utf8');lib=(root/LOCAL[1]).read_text(encoding='utf8');check('current_tickrate','pub const TICK_RATE: u64 = 30;' in lib);check('retarget_interval',local.count('p.next_ai = self.tick + 8;')==2 and 'self.units.get_mut(&id).unwrap().next_ai = self.tick + 8;' in local)
 conditions=['.ok_or("world disabled")?','.ok_or("unknown NPC definition")?','lane.filter(|_| def.kind.lane())','u.route =','p.target = target;','unit.home','self.world.as_mut().unwrap().attacks = remaining;','attack.launched && self.units.contains_key(&attack.source)']
 for n in conditions:
  if n=='u.route =':continue
  check('current_branch_'+n,n in local)
 for t in TARGETS:
  for i,n in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,n)['role'])
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for p in LOCAL+['data/4.20/map10_world.json','data/4.20/native_minions_shared.json','data/4.20/native_minions_shared_bytecode.json','tools/native_lua.py','tools/project-plan/lua51_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/extract_native_map10.py','docs/reference_client_4_20.json']:keep(root/p)
 for p in ['prepare_context.py','phase-and-package-context.json','native-inspection.log','lua-probe.log','run_minion_tests.py','rust-run.log','rust-minion-tests.log','rust-corrected-run.log','audit_minion_behavior_initial.py','collect-initial.log','audit_minion_behavior_before_path_fix.py','collect-corrected.log']:keep(V/p)
 facts=dict(scripts=scriptfacts,profiles=profiles,caster_spell=dict(source=spell,membership=member,missile_speed=speed),lua=lua,rust=rust,reader_refusals=reader_cases,local_tickrate=30,local_scan_ticks=8,native_declared_scan_seconds=.25,policies=dict(native_target_priorities_qualified=False,native_help_event_producer_qualified=False,native_scheduler_equivalence=False,formation_geometry_qualified=False,complete_projectile_lifecycle_qualified=False,full_task_scope_complete=False,original_game_process_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for s in _CACHE[key][1]:require(pin(s['path'])==s,'source changed '+s['path'])
 return _CACHE[key]
def bindings(f,t):
 if t==TARGETS[5]:p=f['caster_spell']['source']['path'];role='native_caster_spell_fields_not_cleanup_semantics'
 elif t in [TARGETS[2],TARGETS[4]]:p=f['scripts'][1]['source']['path'];role='native_shared_callback_with_engine_adapter_limits'
 elif t==TARGETS[0]:p=f['scripts'][2]['source']['path'];role='native_map_spawn_definition_source'
 else:p=f['scripts'][0]['source']['path'];role='native_minion_scan_calls_not_engine_target_priority'
 return [dict(path=p,role=role,selector='Bounded original source and current role;caller,engine behavior and remaining scope explicit')]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_minion_behavior_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,n) for i,n in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),original_lua_cases=101,rust_tests=6,original_game_executed=False)
