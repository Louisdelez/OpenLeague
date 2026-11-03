"""Content identity trace: generated membership is not historical availability."""
import copy,json,pathlib,re,sys
R=pathlib.Path('F:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from rads_reference_membership import identity as pin
from frontend_builds import release_manifest,manifest_member
import reference_client, audit_event_modes_reference as events
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(ok,message):
 if not ok:raise ValueError(message)
TARGETS=[f'SYS-01.3-{i:02}' for i in range(1,7)];BOUNDARIES=set(TARGETS[1:])
LOCAL=['crates/core/src/lib.rs','launcher/src-tauri/src/main.rs','tools/project-plan/reference_client.py','tools/project-plan/local_services_reference.py','tools/project-plan/audit_event_modes_reference.py','tools/project-plan/frontend_builds.py','tools/inventory_reference_content.py','tools/project-plan/native_skin_reference.py']
SPECS={TARGETS[0]:[(0,'pub fn champion_catalog() -> Result<BTreeMap<String, ChampionDefinition>, serde_json::Error> {'),(1,'fn roster() -> Result<serde_json::Value, String> {')],TARGETS[1]:[(2,'def validate(document,source_root=None,verify_native=False):')],TARGETS[2]:[(2,'def validate(document,source_root=None,verify_native=False):'),(3,'def assess(doc,family_id,*,original_service=False,real_money=False,external=False):')],TARGETS[3]:[(4,'def collect(root=R):'),(2,'def reference_label(root,document=None):')],TARGETS[4]:[(5,'def excluded_union_candidate(manifest,name,path,expected):'),(6,"report={'generated_utc':")],TARGETS[5]:[(7,'def choose(bindings):'),(5,'def manifest_member(manifest,name,path,expected_release):')]}
FINDINGS={
TARGETS[0]:('Les122 identifiants numériques et noms de code AIR correspondent au catalogue officiel4.20.1 ;la jointure explicite par nom de code insensible à la casse retrouve les122 identifiants locaux sans doublon,manque ni ajout. champion_catalog et le roster du launcher lisent le catalogue local. Le test Rust existant passe,mais contrôle le nombre/statistiques et non cette jointure exacte.','Conserver la comparaison au changement de catalogue ;qualifier disponibilité historique,skins et kits séparément. Le catalogue local ne contient pas de champ numérique Riot :la jointure est documentée,aucune nouvelle politique globale d’identité imposée.'),
TARGETS[1]:('Le binaire et cinq sources de référence sont revérifiés par reference_client.validate. Le build du17novembre,le timestamp PE,la version du catalogue et la date de sortie sont distincts. ChampionGeneratedData ne contient aucune date de sortie. Les recherches ciblées ne fournissent pas de preuve primaire EUW adoptée.','Retrouver les annonces et activations primaires datées pour les contenus proches de la référence,dont Kalista,sans transformer le build ni une date communautaire US en déploiement EUW ;garder les dates non prouvées inconnues.'),
TARGETS[2]:('MapGeneratedData contient dix cartes candidates. PlatformConfigController filtre les cartes générées par gameMapEnabledDTOList ou prend une liste reçue du service ;GameQueueManager demande getAvailableQueues et vide la liste sur échec. Les lecteurs locaux de région et de services ne reproduisent pas ces payloads historiques.','Qualifier la matrice carte/région/file/date à partir de données serveur ou annonces primaires et relier ses consommateurs ordinaires. Les cartes anciennes,performance et DebugMap5 ne sont pas déclarées disponibles sur leur seule présence.'),
TARGETS[3]:('Le lecteur V94 est relu et ses sources vérifiées :neuf clés générées et neuf clés factory forment dix candidats,mais leur activation dépend de configuration dynamique. Son rôle actuel est la traçabilité ;reference_label conserve la date de build distincte du déploiement.','Retrouver les fenêtres primaires début/fin,régions et files de chaque événement retenu. Aucun calendrier actif ni date événementielle établi ;conserver sr6/ppp distincts et ne pas prendre la présence AIR pour une activation.'),
TARGETS[4]:('Les noms OldTwistedTreeline et DebugMap5 sont des indices textuels natifs,non des décisions de statut. excluded_union_candidate classe l’appartenance exacte à un manifeste ;l’inventaire courant indique explicitement que présence et disponibilité sont distinctes. Aucun de ces consommateurs ne définit la taxonomie complète sorti/interne/obsolète/inconnu.','Définir le contrat des quatre statuts,leur preuve datée et leur consommateur d’affichage/filtrage ;qualifier chaque contenu sans utiliser le nom de fichier ou l’absence au catalogue comme preuve suffisante. Aucune taxonomie globale implémentée dans ce lot.'),
TARGETS[5]:('manifest_member refuse un fichier absent ou divergent du manifeste sélectionné ;choose conserve une liaison de skin non résolue ou ambiguë sans conclure à une indisponibilité. Les sources AIR générées montrent elles-mêmes des candidats distincts des listes actives. Ces gardes sont des frontières locales,non une politique globale d’exclusion.','Relier et tester tous les chemins de décision d’exclusion ;une absence dans un export doit rester une observation limitée avec recherche de variantes/sources et inconnue ouverte. Ne pas assimiler absence de membre RADS,liaison non résolue et contenu historiquement non sorti.')}

def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='content_classification_'+('boundary_' if tid in BOUNDARIES else 'partial_')+tid.replace('-','_').replace('.','_')+'_'+str(i))

def compare_roster(official,local,native):
 require(official.get('version')=='4.20.1','official version');data=official['data'];o=list(data.values())
 require(all(k==v['id'] for k,v in data.items()),'official dictionary identity')
 ids=[str(v['key']) for v in o];names=[v['id'].casefold() for v in o]
 require(all(re.fullmatch(r'[1-9][0-9]*',i) for i in ids) and len(set(ids))==len(ids),'official numeric uniqueness')
 require(len(set(names))==len(names),'official name uniqueness')
 ln=[v['id'].casefold() for v in local];require(len(set(ln))==len(ln),'local identity uniqueness');require(set(ln)==set(names) and len(local)==len(o)==122,'local roster exact')
 require(all(v['index']==v['id'] for v in native),'AIR dictionary identity');ni=[str(v['id']) for v in native];nn=[v['code'].casefold() for v in native]
 require(len(set(ni))==len(ni) and len(set(nn))==len(nn),'AIR identity uniqueness')
 require(len(native)==122 and set(ni)==set(ids),'AIR numeric roster exact');om={str(v['key']):v for v in o};lm={v['id'].casefold():v for v in local}
 require(all(om[str(v['id'])]['id'].casefold()==v['code'].casefold() for v in native),'AIR code numeric relation')
 return [dict(riot_id=v['id'],air_code=v['code'],official_id=om[str(v['id'])]['id'],local_id=lm[v['code'].casefold()]['id']) for v in sorted(native,key=lambda v:v['id'])]

def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root)
 # Reverify the previously delivered event sources; this does not reexecute AIR or JPEXS.
 ef,ep=events.collect(root)
 for s in ep:pins[s['path'].casefold()]=s
 checks.extend('event_'+c for c in ef['source_checks']);keep(root/'tools/project-plan/audit_event_modes_reference.py');keep(root/'docs/reference_event_modes_sources/event_modes-links.json')
 d=root/'docs/reference_content_classification_sources';dec=load(d/'generated-decompilation.json');keep(d/'generated-decompilation.json');swf=keep(dec['input']['path']);check('decompile_input',swf==dec['input']);check('decompile_exit_and_scope',dec['exit_code']==0 and dec['native_AIR_executed'] is False and len(dec['outputs'])==2)
 exports={}
 for name in ['ChampionGeneratedData','MapGeneratedData']:
  p=keep(d/(name+'.as'));rows=[s for s in dec['outputs'] if pathlib.Path(s['path']).name==name+'.as'];check('new_export_'+name,len(rows)==1 and all(p[k]==rows[0][k] for k in ['bytes','sha256']));exports[name]=p
 for s in [dec['java'],*dec['tool_jars']]:check('decompiler_tool_'+s['path'],keep(s['path'])==s)
 mp=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';m=release_manifest(mp,'lol_air_client','0.0.1.119');member=manifest_member(m,'assets/swfs/AirGeneratedContent.swf',swf['path'],'0.0.1.119');check('native_generated_manifest',member['bytes']==63377)
 refpath=root/'docs/reference_client_4_20.json';keep(refpath);ref=load(refpath);reference_client.validate(ref,verify_native=True);check('native_reference_validated',True)
 refs=[keep(pathlib.Path(ref['source_root'])/s['path']) for s in ref['sources']]
 off=keep(ref['catalogue']['local_path']);check('official_catalogue_hash',off['sha256']==ref['catalogue']['sha256']);local=keep(root/'data/4.20/champions.json');official=load(off['path']);lc=load(local['path'])
 txt=pathlib.Path(exports['ChampionGeneratedData']['path']).read_text(encoding='utf8');native=[dict(index=int(i),id=int(j),code=n) for i,j,n in re.findall(r'champions\[(\d+)\] = createChampion\((\d+),"([^\"]+)"',txt)]
 joined=compare_roster(official,lc,native);check('three_rosters_122_exact',len(joined)==122);check('local_numeric_RiotID_absent',all('key' not in c and 'riot_id' not in c for c in lc))
 mt=pathlib.Path(exports['MapGeneratedData']['path']).read_text(encoding='utf8');maps=[]
 pattern=r'maps\[(\d+)\] = createMap\((\d+),"([^\"]+)","((?:\\.|[^"\\])*)","",(\d+)\);'
 for index,i,code,display,players in re.findall(pattern,mt):
  check('map_dictionary_'+i,index==i);maps.append(dict(map_id=int(i),code=code,display_literal=display,total_players=int(players),historical_availability='unknown'))
 check('ten_generated_maps',len(maps)==10 and [v['map_id'] for v in maps]==[1,2,4,7,8,10,11,12,13,90]);check('old_debug_names_retained',maps[2]['code']=='OldTwistedTreeline' and maps[-1]['code']=='DebugMap5');check('winter_autumn_distinct',maps[1]['code']=='SummonersRiftWinter' and '(Autumn)' in maps[1]['display_literal'])
 routes=load(root/'docs/reference_air_routes_4_20.json');air=[]
 conditions={'PlatformConfigController':['param1.gameMapEnabledDTOList','ServiceProxy.instance.gameMapService.getGameMapList','param1[0] is GameMap','_loc3_.mapId == _loc5_.gameMapId','AppConfig.instance.availableMaps = _loc2_;','param1.enabledQueueIdsList'], 'GameQueueManager':['ServiceProxy.instance.matchMakerService.getAvailableQueues','this.platformConfig.allGameQueues = param1.result as ArrayCollection;','this.platformConfig.allGameQueues = new ArrayCollection();']}
 for name,needles in conditions.items():
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('one_export_'+name,len(rows)==1);row=rows[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input']);review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input']);check('export_hash_'+name,all(review[k]==row[k] for k in ['bytes','sha256']));check('library_hash_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']));mb=manifest_member(m,row['input'],binary['path'],raw['manifest_entry']['release']);text=pathlib.Path(review['path']).read_text(encoding='utf8');branches=[]
  for i,n in enumerate(needles):
   lines=[j+1 for j,l in enumerate(text.splitlines()) if n in l];check('AIR_branch_'+name+str(i),bool(lines));branches.append(dict(needle=n,lines=lines))
  air.append(dict(class_name=name,review=review,binary=binary,manifest_member=mb,branches=branches,export_reexecuted=False))
 test=load(d/'rust-catalogue-test.json');keep(d/'rust-catalogue-test.json')
 for k in ['binary','log','source','lock']:check('rust_test_'+k,keep(test[k]['path'])==test[k])
 check('rust_test_exit_scope',test['exit_code']==0 and test['tests_passed']==1 and test['tests_failed']==0 and test['game_executed'] is False)
 log=pathlib.Path(test['log']['path']).read_text(encoding='utf8');check('rust_log_pass', 'test tests::catalog_contains_native_roster ... ok' in log and '1 passed; 0 failed' in log)
 for p in LOCAL+['tools/project-plan/rads_reference_membership.py']:keep(root/p)
 branches={LOCAL[0]:['include_str!("../../../data/4.20/champions.json")','rows.into_iter().map(|r| (r.id.clone(), r)).collect()'],LOCAL[5]:["observed='absent_from_release_manifest'","observed='different_content_from_release_manifest'"],LOCAL[6]:['Filesystem presence does not establish released skins, playable modes or object availability in patch 4.20.'],LOCAL[7]:["'unresolved_native_skin_binding'","'ambiguous_native_skin_bindings'","'runtime_skin_selection_qualified':False"]}
 for p,ns in branches.items():
  text=(root/p).read_text(encoding='utf8')
  for i,n in enumerate(ns):check('current_branch_'+p+str(i),n in text)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 web=load(d/'web-search-notes.json');keep(d/'web-search-notes.json');check('no_primary_date_adopted',web['primary_regional_release_date_adopted'] is False)
 facts=dict(roster=dict(official_source=off,local_source=local,native_source=exports['ChampionGeneratedData'],native_rows=native,joined=joined,local_numeric_RiotID_field_present=False,join_scope='Explicit comparison only; casefold names; no global ID policy or availability inferred.'),generated=dict(source=swf,exports=exports,manifest_member=member,decompilation=dec,maps=maps),reference=dict(document=ref,sources=refs,native_validated=True,binary_executed=False),air=air,event_candidates=ef['candidates'],event_policies=ef['policies'],rust_test=test,web_research=web,policies=dict(release_dates_qualified=False,map_region_queue_matrix_qualified=False,event_calendars_qualified=False,global_taxonomy_implemented=False,global_exclusion_policy_implemented=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[key]
def bindings(f,tid):
 out=[dict(path=f['generated']['source']['path'],role='native_generated_content_identity_not_release_activation',selector=('ChampionGeneratedData.fillChampionData;122 IDs' if tid==TARGETS[0] else 'MapGeneratedData.fillMapData;10 candidates,not10 active maps'))]
 if tid in [TARGETS[1],TARGETS[2],TARGETS[3]]:out.append(dict(path=str(pathlib.Path(f['reference']['document']['source_root'])/f['reference']['document']['client']['binary']),role='native_build_date_not_content_release_date',selector='PUBLIC4.20.0.315;Nov17 2014 17:46:45;timezone/deployment unknown'))
 if tid==TARGETS[2]:
  out.extend(dict(path=x['binary']['path'],role='native_map_queue_service_boundary',selector=x['class_name']+';export='+x['review']['path']+';payload not recovered') for x in f['air'])
 if tid==TARGETS[3]:out[0]['selector']='FeaturedGameGeneratedData and factory/dynamic configuration,qualified by V94 reader;no dated activation'
 return out
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_content_classification_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False,rust_test_executed=True)
