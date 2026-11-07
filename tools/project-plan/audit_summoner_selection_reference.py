"""Read-only selection/source trace audit, never a historical service or game test."""
import hashlib,json,pathlib,re,sys
R=pathlib.Path('E:/OpenLeague')
sys.path.insert(0,str(R/'tools/project-plan'))
from frontend_builds import release_manifest,manifest_member
from rads_reference_membership import RadsReferenceMembership
from reference_inibin import read,hashkey
TARGETS=[f'SYS-08.3-{i:02}' for i in range(1,5)]+['SYS-08.4-03']
CLASSES=['CreateSpellSelectionsCommand','SpellSelectCommand','ChampionSelectionControllerNew','SpellSelection','GameMap','GameMode','Spell','InventoryController']
MAPPING={'Barrier':'SummonerBarrier','Heal':'SummonerHeal','Exhaust':'SummonerExhaust','Ignite':'SummonerDot','Smite':'SummonerSmite'}
LOCAL=['launcher/web/index.html','launcher/web/app.js','launcher/src-tauri/src/main.rs','launcher/src-tauri/src/sessions.rs','crates/core/src/summoners.rs','crates/core/src/session_transport.rs','crates/core/src/lib.rs','crates/client/src/main.rs','crates/client/src/session_bootstrap.rs','crates/client/src/session_client.rs','crates/server/src/main.rs','crates/server/src/reconnect.rs','crates/server/src/session_host.rs']
SPECS={
 'SYS-08.3-01':[(LOCAL[0],'<select id="summoner-d">','unfiltered_launcher_spell_options'),(LOCAL[2],'fn play(','launcher_loadout_boundary_without_account_level'),(LOCAL[4],'pub fn join_with_summoners(','server_join_boundary_without_account_level')],
 'SYS-08.3-02':[(LOCAL[2],'fn play(','launcher_supported_pair_guard'),(LOCAL[2],'fn join_local(','joined_launcher_supported_pair_guard'),(LOCAL[4],'if spells[0].is_some() && spells[0] == spells[1] {','server_duplicate_summoner_guard')],
 'SYS-08.3-03':[(LOCAL[0],'<select id="summoner-f">','launcher_spell_map_filter_boundary'),(LOCAL[4],'pub fn join_with_summoners(','server_summoner_map_mode_boundary')],
 'SYS-08.3-04':[(LOCAL[5],'pub const VERSION: u16 = 1;','local_session_protocol_version'),(LOCAL[5],'pub struct JoinRequest {','local_summoner_join_schema'),(LOCAL[4],'pub enum Spell {','local_summoner_enum_names'),(LOCAL[11],"pub fn prepare_join<'a>(",'server_join_version_guard')],
 'SYS-08.4-03':[(LOCAL[1],"await action('play',",'launcher_play_pair_payload'),(LOCAL[1],"await action('join_local',",'launcher_join_pair_payload'),(LOCAL[3],'.env("OPENLEAGUE_CHAMPION",&self.champion).env("OPENLEAGUE_SUMMONERS",&self.summoners)','launch_environment_pair'),(LOCAL[7],'let summoners=serde_json::from_str(&std::env::var("OPENLEAGUE_SUMMONERS")','client_pair_environment_decode'),(LOCAL[8],'Client::new(t::JoinRequest{version:self.version,champion,summoners,','client_pair_join_request'),(LOCAL[12],'let player = match game.join_with_summoners(&request.champion, request.summoners) {','server_session_pair_consumer'),(LOCAL[4],'self.players.get_mut(&id).unwrap().summoners.spells = spells;','simulation_pair_assignment'),(LOCAL[11],'if l.join.champion!=r.champion || l.join.summoners!=r.summoners || l.join.request_nonce!=r.request_nonce {','replayed_join_pair_identity_guard')]
}
FINDINGS={
 'SYS-08.3-01':('AIR filtre active,minLevel et désactivation par mode ; les deux listes locales proposent cinq noms plus Aucun, sans niveau de compte transmis au join.','Récupérer/qualifier le catalogue et les désactivations effectives EUW4.20 ; ajouter et vérifier le niveau du compte et ses gardes, distinct du niveau du champion.'),
 'SYS-08.3-02':('Les deux commandes Tauri refusent un nom hors des cinq variantes ou un doublon non nul ; Simulation refuse le doublon avant création. Les slots vides restent possibles. AIR confirmSpells permute les choix lors du remplacement ; son appel selectSpells ne prouve pas la politique serveur.','Qualifier toutes les paires interdites et le traitement des slots vides dans les modes historiques, puis exercer les refus serveur réels ; aucune règle distante déduite du seul client.'),
 'SYS-08.3-03':('AIR choisit un mode connu ou un repli selon mapId, puis filtre gameModes et les désactivations. Le chemin local de sélection/join inspecté ne reçoit ni mode ni carte ni niveau de compte.','Relier les règles de disponibilité à la configuration effective de partie et les vérifier avant lancement et côté serveur ; les modes Data Dragon ne sont pas un payload de désactivation historique.'),
 'SYS-08.3-04':('Le protocole local porte VERSION=1 et sérialise cinq noms enum ; AIR sélectionne deux spellId et le catalogue4.20.1 possède treize IDs numériques. VERSION=1 ne versionne pas le catalogue historique.','Définir et vérifier le contrat versionné de correspondance des IDs/catalogue, migration et refus ; conserver le protocole local distinct du transport Riot.'),
 'SYS-08.4-03':('Deux valeurs sont suivies depuis les select HTML, les invoke play/join_local, LaunchSpec, la variable JSON, JoinRequest, session_host et Simulation. Le rejeu compare aussi la paire. Cette lecture statique couvre cinq variantes et deux slots optionnels.','Exercer la transmission effective avec serveur/client et tous les IDs retenus, l’ordre D/F, erreurs et reconnexion ; ni réseau ni interface ni fidélité complète exécutés dans ce lot.')
}
def require(value,message):
 if not value:raise ValueError(message)
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def anchor(root,path,needle,role):
 lines=(root/path).read_text(encoding='utf8').splitlines();hits=[i+1 for i,s in enumerate(lines) if needle in s]
 require(len(hits)==1,'ambiguous/missing anchor '+role)
 return dict(path=path,line=hits[0],needle=needle,role='summoner_selection_'+role)
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 routespath=root/'docs/reference_air_routes_4_20.json';routes=load(routespath);keep(routespath)
 manifestpath=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(manifestpath)
 manifest=release_manifest(manifestpath,'lol_air_client','0.0.1.119')
 air=[];texts={}
 for name in CLASSES:
  candidates=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('unique_export_'+name,len(candidates)==1)
  row=candidates[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input'])
  review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input'])
  check('export_identity_'+name,all(review[k]==row[k] for k in ['bytes','sha256']))
  check('binary_identity_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']))
  member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('manifest_'+name,member['bytes']==binary['bytes'])
  texts[name]=pathlib.Path(review['path']).read_text(encoding='utf8')
  air.append(dict(class_name=name,qualified_class=row['analysis']['class'],review=review,binary=binary,member=member,export_evidence='docs/reference_air_routes_4_20.json',fresh_export_executed=False))
 tokens={
 'CreateSpellSelectionsCommand':['knownGameModesForSpells.contains(param1)','case GameMap.CRYSTAL_SCAR_ID:','param1 = GameMode.DOMINION;','case GameMap.PROVING_GROUNDS_ARAM_ID:','case GameMap.HOWLING_ABYSS:','param1 = GameMode.ARAM;','param1 = GameMode.CLASSIC;','return param1.gameModes.contains(param2);','this.inventoryController.getActiveSpells()','_loc5_.minLevel <= this.summonerLevel && !this.inventoryController.isSpellDisabledForMode(_loc5_.spellId,_loc8_)'],
 'InventoryController':['if(_loc2_.active)','this.inventory.gameModeToInactiveSpellIds[param2].contains(param1)'],
 'SpellSelectCommand':['this.gameService.selectSpells(new ArrayCollection([this.spell1.spellId,this.spell2.spellId])','this.championSelectionModel.spellsBusy = true;','this.championSelectionModel.spellsBusy = false;'],
 'ChampionSelectionControllerNew':['public function confirmSpells(param1:Spell, param2:Spell)','if(param1 == param2)','this.commandFactory.getSpellSelectCommand(_loc3_.spell,_loc4_.spell,this.championSelectionViewModel)'],
 'Spell':['public function get minLevel()','public function get spellId()','public function get gameModes()'],
 'GameMap':['TWISTED_TREELINE_ID:int = 10;','CRYSTAL_SCAR_ID:int = 8;','PROVING_GROUNDS_ARAM_ID:int = 7;','HOWLING_ABYSS:int = 12;']}
 for name,ts in tokens.items():
  for i,t in enumerate(ts):check('air_selector_'+name+'_'+str(i),t in texts[name])
 official=pathlib.Path('E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/summoner.json');keep(official)
 dd=load(official);localcat=root/'data/4.20/native_summoners_420.json';keep(localcat)
 check('official_catalogue_version',dd['version']=='4.20.1' and dd['type']=='summoner')
 check('catalogue_semantic_copy',dd==load(localcat));check('thirteen_official_ids',len(dd['data'])==13)
 membership=RadsReferenceMembership(root)
 for p in [membership.catalogue_identity,membership.solution_identity,membership.configuration_identity]:keep(p['path'])
 for p in membership.manifests:keep(p['identity']['path'])
 for p in membership.provenance:keep(p['path'])
 native=[]
 for name,row in sorted(dd['data'].items()):
  logical='DATA/Spells/'+name+'.inibin';source=keep(membership.deploy/logical);member=membership.inspect(logical,source['path'],source)
  check('native_member_'+name,member['status']=='matches_selected_project_manifest')
  vals=read(source['path']);fields={f:vals.get(hashkey('SpellData',f)) for f in ['DisplayName','CooldownTime','CooldownTime1','DynamicTooltip']}
  native.append(dict(name=name,key=row['key'],summonerLevel=row['summonerLevel'],modes=row['modes'],source=source,native_membership=member,native_fields=fields,eligibility_fields_authority='Data Dragon comparison plus AIR DTO reader; effective service payload not recovered'))
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 for p in LOCAL+['docs/reference_client_4_20.json','tools/project-plan/reference_inibin.py','tools/project-plan/frontend_builds.py','tools/project-plan/rads_reference_membership.py']:keep(root/p)
 variants=re.findall(r'^\s+(\w+),\s*$',local[LOCAL[4]].split('pub enum Spell {',1)[1].split('}',1)[0],re.M)
 check('five_local_variants',variants==list(MAPPING))
 options={}
 for slot in ['d','f']:
  body=re.search(r'<select id="summoner-'+slot+'">(.*?)</select>',local[LOCAL[0]],re.S).group(1)
  options[slot]=re.findall(r'<option value="([^"]*)"',body);check('slot_'+slot,options[slot]==['']+variants)
 for verb in ['play','join_local']:
  body=local[LOCAL[2]].split('fn '+verb+'(',1)[1].split('\n}\n',1)[0]
  check('supported_pair_guard_'+verb,all('s != "'+v+'"' in body for v in variants) and '(summoners[0].is_some() && summoners[0] == summoners[1])' in body)
  check('no_account_or_mode_parameter_'+verb,not re.search(r'account|level|game_mode|map_id',body,re.I))
 join=local[LOCAL[4]].split('pub fn join_with_summoners(',1)[1].split('pub fn cast_summoner',1)[0]
 check('duplicate_guard_before_join',join.index('return Err("duplicate summoner spell"')<join.index('self.join(name)?'))
 check('no_account_or_mode_parameter_core',not re.search(r'account|level|game_mode|map_id',join,re.I))
 check('local_protocol_version_one','pub const VERSION: u16 = 1;' in local[LOCAL[5]])
 check('join_protocol_version_guard','if r.version!=wire::VERSION {return Err(Error::UnsupportedVersion);}' in local[LOCAL[11]].split("pub fn prepare_join<'a>(",1)[1].split('pub fn ',1)[0])
 check('strict_join_request','#[serde(deny_unknown_fields)]\npub struct JoinRequest {' in local[LOCAL[5]])
 check('pair_optional_enum','pub summoners: [Option<summoners::Spell>;2]' in local[LOCAL[5]])
 check('client_json_error_not_silent_default','.expect("valid summoner loadout")' in local[LOCAL[7]])
 check('client_missing_environment_null_pair','unwrap_or_else(|_|"[null,null]".into())' in local[LOCAL[7]])
 check('native_name_mapping',all('Spell::'+a+'=>"'+b+'"' in local[LOCAL[4]] for a,b in MAPPING.items()))
 checks.extend('anchor_'+a['role'] for tid in TARGETS for a in [anchor(root,*s) for s in SPECS[tid]])
 facts=dict(air_exports=air,air_tokens=tokens,catalogue_source=str(official),catalogue_version=dd['version'],catalogue_entries=native,local_variants=variants,local_native_mapping=MAPPING,launcher_options=options,local_session_version=1,local_ids_are_historical_numeric_ids=False,account_level_gating_implemented_in_inspected_join=False,mode_gating_implemented_in_inspected_join=False,empty_slots_permitted=True,historical_service_payload_recovered=False,historical_server_pair_policy_qualified=False,historical_AIR_or_game_executed=False,source_checks=checks)
 return facts,list(pins.values())
def bindings(f,tid):
 names={'SYS-08.3-01':['CreateSpellSelectionsCommand','InventoryController','Spell'],'SYS-08.3-02':['ChampionSelectionControllerNew','SpellSelectCommand'],'SYS-08.3-03':['CreateSpellSelectionsCommand','InventoryController','GameMap','GameMode'],'SYS-08.3-04':['SpellSelectCommand','Spell'],'SYS-08.4-03':['SpellSelectCommand']}[tid]
 result=[]
 for name in names:
  row=next(x for x in f['air_exports'] if x['class_name']==name)
  result.append(dict(path=row['binary']['path'],role='original_AIR_'+name,selector=row['qualified_class']+'; qualified release119; derived review='+row['review']['path']))
 for row in f['catalogue_entries']:
  result.append(dict(path=row['source']['path'],role='native_summoner_authoring_identity',selector='SpellData; '+row['name']+'; catalogue comparison key='+row['key']+'; no service availability inferred'))
 return result
def audit(q,root='E:/OpenLeague',verify_files=True):
 require(verify_files,'File verification cannot be bypassed')
 root=pathlib.Path(root)
 require(q['schema']=='openleague_summoner_selection_links/v1' and q['passed'] is True,'schema/status')
 for flag in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[flag] is False,'unsupported claim '+flag)
 facts,pins=collect(root)
 require(q['facts']==facts,'facts diverge from original/current sources')
 require(q['source_identities']==pins,'source pin census/identity divergence')
 require(q['checks']==facts['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 unknowns={x['unknown_id']:x for x in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  tid=a['task_id'];require(a['anchors']==[anchor(root,*s) for s in SPECS[tid]],'current role rebound '+tid)
  require(a['native_bindings']==bindings(facts,tid),'native role rebound '+tid)
  require((a['finding'],a['remaining'])==FINDINGS[tid],'scope claim rebound '+tid)
  require(a['entry_boundary_only']==(tid in ['SYS-08.3-01','SYS-08.3-03']) and a['full_task_scope_complete'] is False,'boundary/completion confusion '+tid)
  u=unknowns[a['existing_unknown_id']];require(u['task_id']==tid and u['status']=='open','unknown association not open '+tid)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),native_spells=len(facts['catalogue_entries']),air_exports=len(CLASSES),source_pins=len(pins),historical_or_current_game_executed=False)
