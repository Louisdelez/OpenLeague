"""Bounded native archive and community-source associations;no blanket import approval."""
import collections,hashlib,importlib.util,json,pathlib,struct,sys,zipfile
R=pathlib.Path('F:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
import reference_inibin,lua51_reference,rads_reference_membership as membership
from rads_reference_membership import identity as pin
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(ok,message):
 if not ok:raise ValueError(message)
TARGETS=[f'SYS-02.3-{i:02}' for i in range(1,7)];BOUNDARIES={TARGETS[0],TARGETS[2],TARGETS[5]}
LOCAL=['crates/client/src/native_archive_index.rs','crates/client/src/native_zip_archive.rs','tools/project-plan/rads_reference_membership.py','crates/client/src/animation.rs','tools/download_assets.py','tools/project-plan/audit_community_semantics.py','crates/core/src/spells.rs','tools/project-plan/source_versions.py','tools/project-plan/frontend_builds.py']
SPECS={TARGETS[0]:[(0,' pub fn lookup(&self,requested:Option<&[u8]>,enabled:bool,mut query:impl FnMut(&[u8]))'),(1,'pub fn local_entries(bytes:&[u8])->io::Result<Vec<Record>>')],TARGETS[1]:[(2,'    def inspect(self,logical,path,expected_identity=None):'),(2,'def verify_recovered_alternatives(verifier):')],TARGETS[2]:[(3,'pub fn request('),(4,'def restore(root, archive, entries, force=False):')],TARGETS[3]:[(5,'def garen_case(root,dep,review):'),(6,'p.effects.speed_until = self.tick + seconds(garen_value(0, "Effect5", rank));')],TARGETS[4]:[(5,'def garen_case(root,dep,review):'),(7,'def validate_history(source, root, verify_files=False):')],TARGETS[5]:[(4,'def restore(root, archive, entries, force=False):'),(8,'def manifest_member(manifest,name,path,expected_release):')]}
FINDINGS={
TARGETS[0]:('Le scan borné du deploy natif retrouve cinq ZIP déjà connus et1066 entrées relues avec CRC/SHA ;leurs copies F correspondent.1065 noms distincts,le seul nom répété étant le marqueur vide Textures/ de deux archives. Les consommateurs Rust d’index et de ZIP sont identifiés ;ce scan ne couvre pas toutes les archives locales ni les ressources encore manquantes.','Étendre la recherche aux archives non indexées et aux autres racines pertinentes,avec périmètre explicite et rapprochement des ressources manquantes ;qualifier les montages et collisions au lieu de conclure depuis le seul index.'),
TARGETS[1]:('Le lecteur RADS F compare les deux fichiers loose Urf.inibin et Cheats.cfg à leurs alternatives exactes :les loose divergent,les alternatives correspondent aux manifestes sélectionnés et leurs copies F sont identiques. Les deux origines sont conservées ;l’ordre de sélection runtime reste inconnu.','Conserver version,taille,hash et candidats pour chaque doublon rencontré ;qualifier la sélection effective avant remplacement. Les deux cas exacts ne démontrent pas une politique exhaustive pour tous les doublons.'),
TARGETS[2]:('Deux documents primaires DivineSkins sont épinglés à leurs commits. Ils décrivent fantome,modpkg et ZIP structurés dépendant du patch courant ;aucune compatibilité4.20 n’y est qualifiée. Un SKN natif Garen est identifié et comparé au manifeste. Le client actuel demande des Gltf ;le restaurateur ne vérifie pas la sémantique4.20.','Évaluer un paquet précis et son contenu,versions de formats,rig,animations,textures et droits de réutilisation pertinents ;relier une conversion vérifiée à nos consommateurs. Aucun paquet DivineSkins ni Celestial téléchargé ou exécuté dans ce lot.'),
TARGETS[3]:('La comparaison nommée GarenQ est réexécutée en lecture seule :neuf écarts sur dix durées communautaires,les champs natifs correspondent aux valeurs locales utilisées. Les797 sources de l’inventaire communautaire sont relues par SHA. Six tests de comparaison passent,mais ni code C# ni gameplay natif ne sont exécutés.','Évaluer les autres outils et ressources sur leurs contrats précis,dispatch et versions ;ne pas généraliser les résultats GarenQ aux autres capacités ou aux assemblages non inspectés. Les tooltips natifs contradictoires restent explicitement ouverts.'),
TARGETS[4]:('Les documents DivineSkins ont des commits exacts ;les ressources communautaires conservées ont des SHA relus. Le Git snapshot du Q communautaire est une observation antérieure d’arbre modifié,et son chemin est non suivi :le base HEAD ne devient pas la version exacte du fichier. Les consommateurs de comparaison et d’historique sont reliés.','Conserver pour chaque ressource retenue URL/commit quand établi,état de l’arbre,hash et preuve de correspondance native ;qualifier le parcours complet d’adoption. Un ContentFormatVersion ou un dossier nommé4.20 ne prouve pas le patch.'),
TARGETS[5]:('Le restaurateur actuel refuse sept cas contrôlés dont fichier local divergent,membre/tailles/SHA/politique invalides. Il restaure aussi un diagnostic opaque si son SHA est exact :son contrat porte sur l’intégrité,non sur le format ou la fidélité4.20. Le lecteur RADS qualifie séparément les membres exacts.','Qualifier une garde de correspondance4.20 dans les vrais chemins d’adoption/conversion et de remplacement moderne ;ne pas assimiler checksum réussi,import réussi ou membre natif à la fidélité complète. Aucun remplacement de ressource réelle effectué.')}

def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='community_recovery_'+('boundary_' if tid in BOUNDARIES else 'partial_')+tid.replace('-','_').replace('.','_')+'_'+str(i))
def census(scan):
 base=pathlib.Path(scan['searched_root']);extensions=set(scan['extensions']);return sorted(str(p) for p in base.rglob('*') if p.is_file() and p.suffix.lower() in extensions)
def community_module(root):
 saved=sys.path[:];spec=importlib.util.spec_from_file_location('_community_recovery_consumer',root/'tools/project-plan/audit_community_semantics.py');mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod);sys.path[:]=saved;return mod

def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 keep(root/'docs/project_location.json');loc=load(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root)
 d=root/'docs/reference_community_recovery_sources';scan=load(d/'archive-scan.json');keep(d/'archive-scan.json');check('archive_search_scope',scan['all_local_archives_inventory_complete'] is False and scan['all_missing_originals_found'] is False);check('native_archive_census',census(scan)==sorted(x['source']['path'] for x in scan['rows']));names=collections.defaultdict(list)
 for i,row in enumerate(scan['rows']):
  check('archive_identity_'+str(i),keep(row['source']['path'])==row['source']);active=keep(row['active_copy']['path']);check('active_archive_copy_'+str(i),active==row['active_copy'] and all(active[k]==row['source'][k] for k in ['bytes','sha256']))
  with zipfile.ZipFile(row['source']['path']) as z:
   members=[]
   for info in z.infolist():
    b=z.read(info);m=dict(name=info.filename,bytes=len(b),sha256=hashlib.sha256(b).hexdigest(),crc=info.CRC);members.append(m);names[info.filename].append(dict(archive=row['relative'],**m))
  check('exact_archive_members_'+str(i),members==row['members'] and len(members)==row['member_count'])
 collisions={k:v for k,v in names.items() if len(v)>1};check('archive_totals',len(scan['rows'])==5 and sum(x['member_count'] for x in scan['rows'])==1066 and len(names)==1065);check('directory_marker_collision_only',list(collisions)==['Textures/'] and all(x['bytes']==0 for x in collisions['Textures/']))
 test=load(d/'consumer-tests.json');keep(d/'consumer-tests.json');check('consumer_tests_scope',test['passed'] is True and test['community_tests']['tests_run']==6 and test['community_tests']['failures']==test['community_tests']['errors']==0 and test['restore_case_count']==10 and test['restore_expected_refusals']==7)
 for k in ['game_executed','original_code_executed','live_assets_modified','all_modern_replacements_rejected']:check('no_false_'+k,test[k] is False)
 for s in [test['python'],test['producer'],test['community_tests']['log'],*test['consumer_sources']]:check('test_source_'+s['path'],keep(s['path'])==s)
 review=load(root/'docs/fidelity_community_review_4_20.json');keep(root/'docs/fidelity_community_review_4_20.json');check('community_version_scope','ContentFormatVersion != patch' in review['version_policy'])
 for i,s in enumerate(review['script_inventory']):check('community_script_'+str(i),all(keep(s['path'])[k]==s[k] for k in ['bytes','sha256']))
 check('community_script_count',len(review['script_inventory'])==797)
 ref=load(root/'docs/reference_client_4_20.json');keep(root/'docs/reference_client_4_20.json');dep=pathlib.Path(ref['source_root'])/pathlib.Path(ref['client']['binary']).parent
 mod=community_module(root);case=mod.garen_case(root,dep,review);check('current_named_community_case',case==test['community_case']);check('nine_duration_conflicts',len(case['rank_matrix'])==10 and sum(not x['matches_native_base'] for x in case['rank_matrix'])==9 and case['current_values_match_named_native_fields'] is True and case['fully_qualified'] is False)
 for s in [case['community_source'],case['native_source'],case['native_tooltip'],case['alternate_native_tooltip'],case['current_imported_data'],*case['duration_api_bindings'],*case['current_consumers']]:check('case_source_'+s['path'],all(keep(s['path'])[k]==s[k] for k in ['bytes','sha256']))
 gitproof=keep(review['git_observation_receipt']);check('historical_git_receipt_identity',gitproof['sha256']==review['git_observation_receipt_sha256']);check('modified_community_version_not_HEAD',case['community_git_snapshot']['head_blob_identity_not_assumed'] is True and case['community_git_snapshot']['tracked'] is False)
 # The manifests still have historical E backing;use the current F code with that explicit read-only root.
 verifier=membership.RadsReferenceMembership(loc['previous_root']);alts=membership.verify_recovered_alternatives(verifier);pairs=[]
 for a in alts:
  loose=verifier.inspect(a['logical_path'],verifier.deploy/a['logical_path']);active=keep(root/'data/4.20/recovered_client_assets'/a['logical_path']);pairs.append(dict(loose=loose,recovered=a,active_copy=active));check('loose_diverges_'+a['logical_path'],loose['status']=='differs_from_all_selected_manifest_payloads');check('exact_alternative_'+a['logical_path'],a['status']=='matches_selected_project_manifest' and all(active[k]==a['observed'][k] for k in ['bytes','sha256']))
  for s in [loose['observed'],a['observed'],a['recovery_backing'],a['metadata'],*a['recovery_proofs']]:check('alternative_pin_'+s['path'],all(keep(s['path'])[k]==s[k] for k in ['bytes','sha256']))
 check('recorded_alternative_pairs',pairs==test['alternatives'])
 for s in [verifier.catalogue_identity,verifier.solution_identity,verifier.configuration_identity,*[x['identity'] for x in verifier.manifests],*verifier.provenance]:check('membership_pin_'+s['path'],all(keep(s['path'])[k]==s[k] for k in ['bytes','sha256']))
 for rel in ['data/4.20/rads_manifests/catalogue.json']:
  # Catalogue location is defined by the actual membership module,not guessed here.
  pass
 catF=keep(root/membership.CATALOGUE);check('active_manifest_catalogue_copy',all(catF[k]==verifier.catalogue_identity[k] for k in ['bytes','sha256']))
 mesh=keep(dep/'DATA/Characters/Garen/Skins/Base/Garen.skn');raw=pathlib.Path(mesh['path']).read_bytes();header=dict(magic=raw[:4].hex(),major=struct.unpack_from('<H',raw,4)[0],minor=struct.unpack_from('<H',raw,6)[0]);mb=verifier.inspect('DATA/Characters/Garen/Skins/Base/Garen.skn',mesh['path']);check('native_mesh_sample_manifest',mb['status']=='matches_selected_project_manifest');check('native_mesh_magic',header['magic']=='33221100')
 web=load(d/'web-research.json');keep(d/'web-research.json');check('web_not_compatibility',web['compatibility_4_20_qualified'] is False and web['skin_package_downloaded'] is False and web['launcher_installed_or_executed'] is False)
 texts={}
 for s in web['documents']:
  check('web_commit_'+s['repository'],len(s['commit'])==40 and '/'+s['commit']+'/README.md' in s['url']);check('web_source_'+s['repository'],keep(s['source']['path'])==s['source']);texts[s['repository']]=pathlib.Path(s['source']['path']).read_text(encoding='utf8')
 readme=texts['DivineSkins/celestial-releases'];check('documented_mod_formats',all(x in readme for x in ['.fantome','.modpkg','.zip','Compatibility depends on the individual mod and the current League patch.']));check('wiki_creator_scope','Community-written guides' in texts['DivineSkins/divine-wiki'])
 for p in LOCAL+['tools/project-plan/reference_inibin.py','tools/project-plan/lua51_reference.py','assets-manifest.json']:keep(root/p)
 branches={LOCAL[0]:['native duplicate archive-key insertion precedence unqualified','native archive fallback buffer length exceeded'],LOCAL[3]:['model: assets.load(','champions/{name}.glb','model: Handle<Gltf>'],LOCAL[4]:['Archive contents differ from the manifest','Extracted file checksum mismatch','Local file differs; preserve it or use --force','Invalid working-document preservation policy'],LOCAL[7]:['Native/external source is immutable','Source not in explicit mutable local allowlist']}
 for p,needles in branches.items():
  text=(root/p).read_text(encoding='utf8')
  for i,n in enumerate(needles):check('current_branch_'+p+str(i),n in text)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(archives=scan,archive_name_collisions=collisions,community_case=case,community_scripts_verified=797,community_git_receipt=gitproof,tests=test,alternatives=pairs,native_mesh=dict(source=mesh,header=header,membership=mb),web_research=web,policies=dict(all_local_archives_searched=False,missing_originals_all_recovered=False,modern_4_20_compatibility_qualified=False,all_replacements_guarded=False,all_community_semantics_qualified=False,historical_mount_precedence_qualified=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
  scan=_CACHE[key][0]['archives'];require(census(scan)==sorted(x['source']['path'] for x in scan['rows']),'archive census changed')
 return _CACHE[key]
def bindings(f,tid):
 if tid==TARGETS[0]:return [dict(path=x['source']['path'],role='supplied_native_archive_bounded_inventory',selector='ZIP member census;not all local archives or runtime mounting') for x in f['archives']['rows']]
 if tid in [TARGETS[1],TARGETS[5]]:return [dict(path=x['recovered']['observed']['path'],role='exact_native_manifest_alternative_not_runtime_precedence',selector=x['recovered']['logical_path']+';loose divergent retained') for x in f['alternatives']]
 if tid==TARGETS[2]:return [dict(path=f['native_mesh']['source']['path'],role='native_mesh_format_context_not_mod_compatibility',selector='SKN header and exact manifest member;no DivineSkins compatibility inferred')]
 return [dict(path=f['community_case']['native_source']['path'],role='native_ranked_field_comparison_not_community_dispatch',selector='GarenQ SpellData Effect3/5/6 ranks1..5;versioned community comparison')]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_community_recovery_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
