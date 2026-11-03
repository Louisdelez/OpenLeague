"""Exact rune/mastery source and page boundaries; no invented service payload."""
import collections,json,pathlib,re,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from audit_summoner_selection_reference import pin,load,require
from frontend_builds import release_manifest,manifest_member
from rads_reference_membership import RadsReferenceMembership
from reference_inibin import read,hashkey
TARGETS=[f'SYS-08.1-{i:02}' for i in range(1,6)]+[f'SYS-08.2-{i:02}' for i in range(1,9)]+[f'SYS-08.4-{i:02}' for i in [1,2,4,5,6]]
CLASSES=['RuneType','RuneSlot','RuneBookUtils','RuneBookController','SpellBookDTO','SpellBookPageDTO','AbstractBookPage','MasteriesController','MasteriesUtils','MasteryBook','MasteryPage','SelectRunePageCommand','MasteriesManager','Talent','TalentRow','RunesTransportationController','RuneSlotView']
LOCAL=['launcher/web/index.html','launcher/web/app.js','launcher/src-tauri/src/main.rs','launcher/src-tauri/src/sessions.rs','crates/core/src/lib.rs','crates/core/src/session_transport.rs','crates/core/src/progression.rs','crates/core/src/summoners.rs','crates/server/src/session_host.rs','crates/server/src/reconnect.rs']
SPECS={
 'SYS-08.1-01':[(0,'<div class="selection-fields">'),(2,'fn roster()')],
 'SYS-08.1-02':[(2,'fn play('),(5,'pub struct JoinRequest {')],
 'SYS-08.1-03':[(5,'pub struct JoinRequest {'),(4,'pub fn join(&mut self, name: &str)')],
 'SYS-08.1-04':[(5,'pub struct JoinRequest {'),(7,'pub fn join_with_summoners(')],
 'SYS-08.1-05':[(5,'pub struct JoinRequest {'),(8,'let player = match game.join_with_summoners(&request.champion, request.summoners) {')],
 'SYS-08.2-01':[(0,'<div class="selection-fields">'),(2,'.invoke_handler(tauri::generate_handler!')],
 'SYS-08.2-02':[(1,'async function action(command,payload){'),(2,'.invoke_handler(tauri::generate_handler!')],
 'SYS-08.2-03':[(0,'<div class="selection-fields">'),(2,'.invoke_handler(tauri::generate_handler!')],
 'SYS-08.2-04':[(1,'async function action(command,payload){'),(2,'.invoke_handler(tauri::generate_handler!')],
 'SYS-08.2-05':[(2,'.invoke_handler(tauri::generate_handler!'),(3,'struct LaunchSpec {')],
 'SYS-08.2-06':[(2,'.invoke_handler(tauri::generate_handler!'),(3,'struct LaunchSpec {')],
 'SYS-08.2-07':[(4,'pub fn join(&mut self, name: &str)'),(6,'pub fn stats(&self, id: u32) -> Stats {')],
 'SYS-08.2-08':[(4,'pub fn join(&mut self, name: &str)'),(6,'pub fn stats(&self, id: u32) -> Stats {')],
 'SYS-08.4-01':[(1,"await action('play',"),(5,'pub struct JoinRequest {')],
 'SYS-08.4-02':[(1,"await action('join_local',"),(5,'pub struct JoinRequest {')],
 'SYS-08.4-04':[(6,'pub fn stats(&self, id: u32) -> Stats {'),(4,'pub fn join(&mut self, name: &str)')],
 'SYS-08.4-05':[(3,'struct LaunchSpec {'),(1,'async function refreshSession(){')],
 'SYS-08.4-06':[(3,'pub fn resume(&self)->Result<String,String>{'),(5,'pub struct ResumeRequest {'),(8,'t::ClientMessage::Resume(request) => {')]
}
FINDINGS={
 'SYS-08.1-01':('RuneType expose quatre IDs de couleur modifiables ; le catalogue compare296 runes de tiers1/2/3. Le launcher actuel ne propose que champion et sorts invocateur.','Qualifier la disponibilité EUW et les configurations de slots effectives ; ne pas assimiler les296 définitions à296 runes achetables.', ['RuneType','RuneBookController']),
 'SYS-08.1-02':('RuneBookUtils compare type et minLevel du slot ; le placement automatique parcourt spellBookConfig reçu de la session. Le join local ne porte pas de compte ni page.','Récupérer/qualifier la table de slots et niveaux,les restrictions de tiers et leur application serveur ; le placement explicite ne suffit pas à prouver tous les gardes.', ['RuneSlot','RuneBookUtils','RunesTransportationController','RuneSlotView']),
 'SYS-08.1-03':('Le budget local AIR vient de summonerTalentsAndPoints.talentPoints ; augmentation contrôlée contre totalPointsToSpend. La branche de vue avec DTO fourni utilise30, sans prouver un plafond universel par arbre. Aucun budget/page dans le join local.','Qualifier les plafonds par compte/arbre et le payload historique ; conserver le budget global distinct des rangs et des seuils de rangée.', ['MasteriesController','MasteryBook','MasteriesUtils']),
 'SYS-08.1-04':('AIR consomme pointsToActivate,prereqTalentGameCode et maxRank du catalogue reçu ; buildFakeMasteryTree ne fait pas autorité. Les caps4312/4313 restent inconnus malgré Ranks4 natif/catalogue3.','Qualifier le talentTree effectif et les règles serveur de prérequis/seuils ; ne pas substituer la table factice ou Ranks au DTO.', ['MasteriesController','MasteriesUtils','Talent','TalentRow']),
 'SYS-08.1-05':('JoinRequest strict contient champion et sorts,aucune page ; session_host appelle join_with_summoners. Le refus de champs inconnus ne valide pas une page ou un rang.','Implémenter/qualifier le contrat de pages et leur validation serveur autoritaire après qualification des règles ; conserver le refus de protocole distinct du refus sémantique.', ['MasteriesController','RuneBookUtils']),
 'SYS-08.2-01':('AIR ajoute une page reçue du service et conserve pageId,name,current ; le launcher local n’expose aucun CRUD de page dans ses commandes inspectées.','Définir création et nom local selon les contraintes historiques qualifiées,persistance et identité ; ne pas utiliser la base des tâches comme inventaire de compte.', ['RuneBookController','SpellBookDTO','AbstractBookPage']),
 'SYS-08.2-02':('Le DTO de rune contient les slots ; saveSpellBook délègue au service. Le chemin Tauri actuel ne reçoit pas ces entrées.','Ajouter édition,sauvegarde atomique et erreurs de pages après qualification type/niveau/quantité ; vérifier relecture réelle.', ['RuneBookController','SpellBookPageDTO','RunesTransportationController']),
 'SYS-08.2-03':('MasteryBook.createPage crée un DTO et un nom par token ; maxMasteryPagesAllowed est remplacé depuis la session. Aucune commande de page locale inspectée.','Qualifier limites et noms,puis créer/persister des pages locales ; ne pas fixer10 depuis le seul initialiseur statique.', ['MasteryBook','MasteriesController','MasteryPage']),
 'SYS-08.2-04':('MasteryPage copie les entrées DTO dans un buffer volatile et les recopie à la sauvegarde ; MasteriesController appelle saveMasteryBook. Aucun éditeur de rangs local inspecté.','Implémenter édition/relecture des rangs et refus sémantiques ; les entrées copiées ne prouvent pas une application d’effets.', ['MasteryPage','MasteriesController']),
 'SYS-08.2-05':('Les copies ObjectUtil de MasteryPage isolent les buffers d’édition ; elles ne démontrent pas une commande utilisateur de duplication d’une page. LaunchSpec ne stocke pas de pages.','Qualifier la duplication demandée,allouer une identité indépendante et vérifier l’absence de partage mutable ; aucune duplication native complète déduite de la copie du buffer.', ['MasteryPage','SpellBookPageDTO']),
 'SYS-08.2-06':('MasteryBook refuse la suppression de la dernière page et réajuste l’index ; validateCurrentPage rétablit une sélection. SpellBookDTO.removePage retire seulement le membre dans ce corps.','Implémenter suppression/persistance en conservant une sélection valide et qualifier séparément runes/maîtrises ; ne pas attribuer au DTO rune la garde mastery.', ['MasteryBook','MasteriesController','SpellBookDTO']),
 'SYS-08.2-07':('Les302 champs de runes sont relus comme données ; Simulation.join initialise depuis la définition du champion et stats calcule base/croissance/objets/effets sans entrée de page dans ce chemin.','Qualifier l’application et l’ordre des bonus de runes puis les vérifier au premier tick ; le résumé AIR et le lecteur de sources ne réalisent pas les effets serveur.', ['SpellBookPageDTO']),
 'SYS-08.2-08':('Les57 Ranks et leur catalogue sont relus ; le join et stats inspectés n’ont pas de page de maîtrises. Les deux divergences de caps restent ouvertes.','Qualifier et appliquer chaque effet/condition/ordre des maîtrises ; aucune formule serveur inférée des descriptions ou du nombre de rangs.', ['MasteriesController','MasteryPage']),
 'SYS-08.4-01':('SelectRunePageCommand appelle selectDefaultSpellBookPage et met à jour current/defaultPage sur succès. Le payload local play et JoinRequest ne portent pas de page.','Transmettre et valider l’identité/contenu/version de page rune retenue ; la sélection de service AIR ne prouve pas le paquet de lancement natif.', ['SelectRunePageCommand','SpellBookDTO']),
 'SYS-08.4-02':('MasteriesManager appelle setSelectedPageByID puis MasteriesController sauvegarde le livre ; le payload local join_local et JoinRequest ne portent pas de page.','Qualifier/transmettre la page de maîtrises et l’autorité de son contenu ; aucun protocole Riot déduit de ce provider client.', ['MasteriesManager','MasteriesController']),
 'SYS-08.4-04':('SpellBookPageDTO.getCombinedStats somme les effets par displayName pour l’affichage. Les statistiques du jeu local n’ont pas d’entrée de page.','Comparer affichage et calcul serveur au premier tick pour toutes les familles,arrondis et conditions ; ne pas adopter l’agrégation localisée du résumé comme formule serveur.', ['SpellBookPageDTO','MasteryPage']),
 'SYS-08.4-05':('AIR conserve la sélection dans les livres/providers ; le superviseur local ne conserve que champion/sorts/capacités de session. Aucun état de page dans LaunchSpec inspecté.','Implémenter et vérifier conservation des pages après retour,redémarrage et erreurs ; le maintien des seuls sorts ne couvre pas la configuration complète.', ['SelectRunePageCommand','MasteriesManager','MasteryBook']),
 'SYS-08.4-06':('La reprise locale rattache le contexte de joueur existant ; ResumeRequest contient version,contexte,clé et nonce,sans pages. La présence d’un mécanisme de reprise ne prouve pas leur restauration.','Ajouter pages et version de configuration à l’état autoritaire,puis vérifier reconnexion et refus d’une modification concurrente ; payload/reprise historique non qualifiés.', ['SelectRunePageCommand','MasteriesManager'])
}
def anchor(root,tid,index,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[i+1 for i,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='page_loadout_'+tid.lower().replace('-','_').replace('.','_')+'_'+str(index)+'_entry_boundary')
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 routepath=root/'docs/reference_air_routes_4_20.json';routes=load(routepath);keep(routepath)
 mp=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(mp);manifest=release_manifest(mp,'lol_air_client','0.0.1.119');air=[];texts={}
 for name in CLASSES:
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('class_'+name,len(rows)==1);row=rows[0]
  raw=next(x for x in routes['original_sources'] if x['path']==row['input']);review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input'])
  check('export_'+name,all(row[k]==review[k] and raw[k]==binary[k] for k in ['bytes','sha256']))
  member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('manifest_'+name,member['bytes']==binary['bytes'])
  texts[name]=pathlib.Path(review['path']).read_text(encoding='utf8');air.append(dict(class_name=name,qualified_class=row['analysis']['class'],review=review,binary=binary,member=member,export_evidence='docs/reference_air_routes_4_20.json',fresh_export_executed=False))
 tokens={
 'RuneType':['_26815048RED_RUNE:int = 1;','_1666914341YELLOW_RUNE:int = 3;','_470763519BLUE_RUNE:int = 5;','_1123368038BLACK_RUNE:int = 7;'],
 'RuneBookUtils':['return param2.runeType.equals(param1.runeType) && param2.minLevel <= param3;'],
 'RuneBookController':['new ArrayCollection(this.session.summonerCatalog.spellBookConfig.source)','this.serviceProxy.spellBookService.saveSpellBook(param1,param2,param3,param4);','var _loc2_:SpellBookPageDTO = param1.result as SpellBookPageDTO;','this.runeBook.addPage(_loc2_);','switch(param1.rune.tier)','return param1.currentAvailableQuantity > 0;'],
 'RuneSlot':['public function get minLevel()','public function set minLevel(param1:int)'],
 'RunesTransportationController':['_loc5_ >= param1.quantity','_loc4_.runeType.runeTypeId == param1.runeType.runeTypeId && _loc4_.minLevel <= this.runeBookController.summonerLevel','this.runesViewController.getCurrentRuneBookPage().setRuneBySlotNumber(param2,param1);'],
 'RuneSlotView':['this._runeSlot.minLevel > this.runesViewController.getSummonerLevel()'],
 'AbstractBookPage':['public var pageId:Number;','public var current:Boolean;','public function set name(param1:String)'],
 'SpellBookDTO':['public function addPage(param1:SpellBookPageDTO)','this.bookPages.removeItemAt(_loc2_);','_loc2_.current = false;','param1.current = true;'],
 'SpellBookPageDTO':['public function getCombinedStats()','_loc10_ = _loc8_.displayName;','_loc2_[_loc10_].push(_loc9_);','_loc13_ = sumItemEffects(_loc2_[_loc5_]);'],
 'MasteriesController':['this._masteryBook.totalPointsToSpend = this.session.summonerTalentsAndPoints.talentPoints;','this._masteryBook.totalPointsToSpend = 30;','MasteryBook.maxMasteryPagesAllowed = this.session.maxNumberOfAllowedMasteryPages;','MasteriesUtils.registerTree(this.session.summonerCatalog.talentTree);','MasteriesUtils.getMasteryRowByMasteryID(param1).pointsToActivate > _loc2_','this._masteryBook.currentPage.getSpentPoints() >= this._masteryBook.totalPointsToSpend','_loc3_.prereqTalentGameCode != 0','_loc5_.rank < MasteriesUtils.getMasteryByID(_loc3_.prereqTalentGameCode).maxRank','_loc4_.rank < MasteriesUtils.getMasteryByID(param1).maxRank','this.serviceProxy.masteryBookService.saveMasteryBook(','public function setSelectedPageByID(param1:int)','public function deleteCurrentPage()'],
 'MasteriesUtils':['public static function registerTree(','public static function getSpentPointsInGroup(','public static function buildFakeMasteryTree('],
 'MasteryBook':['if(this._voPages.length == 1)','this.currentPageIndex = this._voPages.length - 1;','if(this._voPages.length >= maxMasteryPagesAllowed)','_loc1_.name = AbstractBook.PAGE_NAME_TOKEN + _loc1_.pageId;','public function currentPageNameIsUnique()'],
 'MasteryPage':['this._volatileEntries = ObjectUtil.copy(this._pageDTO.talentEntries) as ArrayCollection;','this._pageDTO.talentEntries = ObjectUtil.copy(this._volatileEntries) as ArrayCollection;','this._pageDTO.name = this._name;'],
 'SelectRunePageCommand':['this.spellBookService.selectDefaultSpellBookPage(this.newPage,','this.runeBook.defaultPage = this.newPage;','this.newPage.current = true;'],
 'MasteriesManager':['this.masteriesProvider.setSelectedPageByID(param1.pageID);','this.championSelectionModel.selectedMasteryPage = param1;'],
 'Talent':['public function get maxRank()','public function get prereqTalentGameCode()'],
 'TalentRow':['public function get pointsToActivate()']}
 for name,ts in tokens.items():
  for i,t in enumerate(ts):check('token_'+name+'_'+str(i),t in texts[name])
 # Inspect only the actual rank-increase/catalogue methods, excluding the fake tree.
 increase=texts['MasteriesController'].split('public function increaseTalentRank(',1)[1].split('public function closeMasteries',1)[0]
 check('rank_rules_no_fake_or_native_Ranks',not any(s in increase for s in ['buildFakeMasteryTree','SpellData','"Ranks"']))
 # Re-read all353 native fields already attributed by V50; preserve contradictions.
 fichepath=root/'docs/reference_rune_mastery_sources/source-fiches.json';keep(fichepath);old=load(fichepath)['observations']['fiches']
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 cats={}
 for name in ['rune','mastery']:
  p=pathlib.Path('E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference')/(name+'.json');keep(p);cats[name]=load(p);check('catalogue_'+name,cats[name]['version']=='4.20.1')
 rows=[]
 for f in old:
  ident=f['subject'];family=f['family'];s=keep(f['source']['path']);check('source_'+family+ident,all(s[k]==f['source'][k] for k in ['bytes','sha256']))
  mem=m.inspect(f['native_membership']['logical_path'],s['path'],s);check('membership_'+family+ident,mem['status']=='matches_selected_project_manifest')
  vals=read(s['path']);fields=[];entry=cats[family]['data'][ident]
  for field in f['fields']:
   v=vals[hashkey(field['section'],field['name'])];cat=entry['stats'][field['name']] if family=='rune' else entry['ranks']
   check('field_'+family+ident+'_'+field['name'],v==field['native_value'] and cat==field['catalogue_value'])
   fields.append(dict(section=field['section'],name=field['name'],native=v,catalogue=cat,prior_resolution=field['prior_resolution']))
  rows.append(dict(task_id=f['task_id'],family=family,id=ident,source=s,native_membership=mem,fields=fields,catalogue_metadata={k:entry[k] for k in ['name','description','rune','ranks','prereq'] if k in entry}))
 check('353subjects_359fields',len(rows)==353 and sum(len(r['fields']) for r in rows)==359)
 for fam,n in [('rune',296),('mastery',57)]:check('complete_'+fam,{r['id'] for r in rows if r['family']==fam}==set(cats[fam]['data']) and len(cats[fam]['data'])==n)
 caps=[dict(id=r['id'],native=r['fields'][0]['native'],catalogue=r['fields'][0]['catalogue'],effective_service_cap=None) for r in rows if r['family']=='mastery' and r['id'] in ['4312','4313']]
 check('caps_remain_open',len(caps)==2 and all(c['native']==4 and c['catalogue']==3 for c in caps))
 tiers=dict(collections.Counter(r['catalogue_metadata']['rune']['tier'] for r in rows if r['family']=='rune'));types=dict(collections.Counter(r['catalogue_metadata']['rune']['type'] for r in rows if r['family']=='rune'))
 check('tiers',tiers=={'1':94,'2':97,'3':105});check('types',types=={'red':62,'yellow':68,'blue':66,'black':100})
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 for p in LOCAL+['docs/reference_client_4_20.json','tools/project-plan/audit_summoner_selection_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/frontend_builds.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_rune_mastery_source_links.py']:keep(root/p)
 jr=local[LOCAL[5]].split('pub struct JoinRequest {',1)[1].split('}',1)[0];rr=local[LOCAL[5]].split('pub struct ResumeRequest {',1)[1].split('}',1)[0]
 spec=local[LOCAL[3]].split('struct LaunchSpec {',1)[1].split('}',1)[0]
 join=local[LOCAL[4]].split('pub fn join(&mut self, name: &str)',1)[1].split('pub fn command(',1)[0]
 stats=local[LOCAL[6]].split('pub fn stats(&self, id: u32) -> Stats {',1)[1].split('pub fn award_experience',1)[0]
 for name,body in [('JoinRequest',jr),('ResumeRequest',rr),('LaunchSpec',spec),('Simulation.join',join),('Simulation.stats',stats)]:check('bounded_no_page_field_'+name,not re.search(r'\brunes?\b|master(?:y|ies)|rune_page|mastery_page',body,re.I))
 check('strict_join','#[serde(deny_unknown_fields)]\npub struct JoinRequest {' in local[LOCAL[5]])
 check('join_base_health_mana','health: def.health,' in join and 'mana: def.mana,' in join)
 check('stats_items_growth','let items = shop::bonuses(p);' in stats and 'growth_total(p.level)' in stats)
 handlers=re.search(r'generate_handler!\[([^\]]+)\]',local[LOCAL[2]])[1];check('actual_six_commands',[s.strip() for s in handlers.split(',')]==['roster','play','join_local','session_status','resume_session','abandon_session'])
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):a=anchor(root,tid,i,s);checks.append('anchor_'+a['role'])
 facts=dict(air_exports=air,native_fiches=rows,catalogue_tier_counts=tiers,catalogue_type_counts=types,mastery_tree_comparison=cats['mastery']['tree'],unresolved_caps=caps,current_contracts=dict(JoinRequest=jr,ResumeRequest=rr,LaunchSpec=spec,handlers=handlers),bounded_scopes=['JoinRequest','ResumeRequest','LaunchSpec','Simulation.join','Simulation.stats','launcher invoke handlers'],global_implementation_absence_proven=False,source_checks=checks,historical_service_payload_recovered=False,summary_is_server_formula=False,buffer_copy_is_page_duplication=False,mastery_budget_30_is_universal_cap=False,all_pages_implemented=False,native_or_game_executed=False)
 return facts,list(pins.values())
def bindings(f,tid):
 result=[]
 for name in FINDINGS[tid][2]:
  row=next(x for x in f['air_exports'] if x['class_name']==name)
  result.append(dict(path=row['binary']['path'],role='original_page_loadout_'+name,selector=row['qualified_class']+'; release119; derived review='+row['review']['path']))
 if tid in ['SYS-08.1-04','SYS-08.2-08']:
  for row in f['native_fiches']:
   if row['family']=='mastery' and row['id'] in ['4312','4313']:result.append(dict(path=row['source']['path'],role='native_rank_cap_conflict_unresolved',selector='SpellData.Ranks=4; catalogue=3; effective Talent.maxRank unknown'))
 return result
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass')
 require(q['schema']=='openleague_page_loadout_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed')
 require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census')
 require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t)
  require(a['native_bindings']==bindings(f,t),'native binding rebound '+t)
  require((a['finding'],a['remaining'])==FINDINGS[t][:2],'claim rebound '+t)
  require(a['entry_boundary_only'] is True and a['full_task_scope_complete'] is False,'boundary promoted '+t)
  u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),native_fiches=len(f['native_fiches']),air_exports=len(CLASSES),source_pins=len(p),native_or_game_executed=False)
