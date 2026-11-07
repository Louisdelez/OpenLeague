"""Source/current-consumer links for conversion and distribution;bounded contract checks."""
import pathlib,json,hashlib,sys,collections,re
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision99');sys.path.insert(0,str(R/'tools/project-plan'))
import reference_inibin,rads_reference_membership as membership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return dict(path=str(p),bytes=p.stat().st_size,sha256=h.hexdigest())
TARGETS=[f'SYS-02.5-{i:02}' for i in range(1,8)];BOUNDARIES={TARGETS[2],TARGETS[3]}
LOCAL=['E:/mapslol3v3/StructureExport/Program.cs','tools/project-plan/source_versions.py','tools/project-plan/reference_inibin.py','tools/download_assets.py','tools/references/lolpytools/lolpytools_convert.py','crates/client/src/native_minion_mips.rs']
SPECS={TARGETS[0]:[(0,'if (args.Length == 3 && args[0].Equals("static", StringComparison.OrdinalIgnoreCase))'),(1,'def validate_history(source, root, verify_files=False):')],TARGETS[1]:[(0,'if (args.Length == 3 && args[0] == "inibin")'),(2,'def decode(data):')],TARGETS[2]:[(3,"if not local.exists() or local.stat().st_size != row['bytes'] or digest(local) != row['sha256']:"),(2,'def read(path):')],TARGETS[3]:[(3,"if len(names) != len(set(names)) or set(names) != set(expected):"),(4,'from . import inibin2')],TARGETS[4]:[(5,'native:include_bytes!("../../../assets/forms/native_minion_mips/Blue_Minion_Basic.dds")'),(3,"manifest = json.loads((ROOT / 'assets-manifest.json').read_text(encoding='utf-8'))")],TARGETS[5]:[(3,'def digest(path):'),(3,"raise ValueError('Pack checksum mismatch: ' + row['name'])")],TARGETS[6]:[(0,'StaticMesh staticMesh = StaticMesh.ReadBinary(input);'),(3,'def restore(root, archive, entries, force=False):')]}
FINDINGS={
TARGETS[0]:('Deux modes du convertisseur externe existant sont exercés sur copies F :INIBIN et SCB statique. Arguments,entrées,DLL,configuration runtime et sorties sont identifiés par empreinte. L’historique local versionne une liste explicite de sources ;il ne constitue pas un registre de paramètres pour tous les formats. Le code C# courant et le binaire sont identifiés séparément,sans prétendre à une compilation correspondante.','Versionner les paramètres et dépendances de chaque convertisseur réellement retenu ;qualifier le lien source/binaire et les autres formats. Les deux exemples n’établissent pas une politique exhaustive.'),
TARGETS[1]:('Chaque conversion native INIBIN/SCB est répétée deux fois dans le dossier isolé :sorties byte-exactes entre exécutions. Le lecteur INIBIN local est aussi identifié comme comparateur de source. Une entrée absente,un SCB tronqué,une version INIBIN non prise en charge et une dépendance DLL absente sont refusés.','Qualifier les autres formats et paramètres,ainsi que les variations pertinentes de runtime et d’environnement ;deux cas déterministes ne prouvent pas tout le pipeline.'),
TARGETS[2]:('Le vrai main du restaurateur accepte le pack exact et refuse un cache corrompu ou manquant. La modification d’une source diagnostic hors manifeste ne change pas cette décision :ce cache est celui des packs livrés. Le lecteur INIBIN relit ses octets ;aucune invalidation générale de dérivés d’import n’est démontrée.','Identifier ou construire la clé et les dépendances du véritable cache d’import,puis tester la modification des sources natives et paramètres. Ne pas assimiler la vérification du ZIP livré à cette invalidation.'),
TARGETS[3]:('Le restaurateur exige la population exacte des membres du pack,mais pas un graphe transitif des ressources.1428 occurrences littérales include ont été relevées :708 pointent vers un chemin déclaré dans les packs,720 vers un fichier présent non déclaré. Ce recensement lexical inclut tests/exemples et n’est pas une expansion cfg. La référence lolpytools ne s’importe pas sous sa disposition actuelle ;la copie .NET sans LeagueToolkit.dll échoue.','Qualifier le graphe de dépendances effectivement activé et sa fermeture pour chaque export et build ;classer les720 occurrences avant de conclure à autant de ressources de production manquantes. Séparer la référence Python incomplète du convertisseur .NET testé.'),
TARGETS[4]:('Les22 packs et7511 membres déclarés sont vérifiés.7508 fichiers installés sont exacts ;trois documents de suivi divergent conformément à la politique de préservation. Le DDS Blue_Minion_Basic natif correspond au membre du pack11 et au include_bytes du consommateur Rust actuel. Un ancien pack16 non déclaré reste présent dans le cache et conservé.','Rapprocher l’ensemble des ressources réellement nécessaires du manifeste et des variantes de build ;la conformité des membres déclarés ne prouve pas l’exhaustivité de la distribution ni sa disponibilité distante.'),
TARGETS[5]:('Les22 tailles/SHA de ZIP et tous les7511 membres ont été vérifiés en lecture seule. Les essais du main refusent un pack altéré,un cache absent et un pack local-only absent sans accès réseau.','Qualifier aussi la reconstruction déterministe des packs et les dérivations nouvelles avant adoption ;une vérification du cache actuel ne démontre pas qu’un rebuild futur produit les mêmes archives.'),
TARGETS[6]:('Les entrées et fichiers outil déclarés sont copiés dans F avant les conversions INIBIN/SCB ;aucun asset du jeu n’est remplacé. Deux packs réels sont restaurés vers un dossier vide :dix fichiers exacts,répétition sans réécriture,divergence locale refusée. Runtime .NET partagé explicitement recensé ;aucune herméticité de tous les accès fichiers n’est revendiquée.','Étendre la réimportation aux formats et dépendances requis,puis qualifier le résultat dans le moteur. Restauration d’un pack et conversion d’une source sont deux opérations distinctes ;ni l’une ni l’autre ne prouve seule une installation complète.')}

def anchor(root,t,i,s):
 path,needle=LOCAL[s[0]],s[1];hits=[j+1 for j,l in enumerate((root/path).read_text(encoding='utf8').splitlines()) if needle in l];require(len(hits)==1,'unique anchor '+t+' '+needle)
 return dict(path=path,line=hits[0],needle=needle,role='conversion_distribution_'+('boundary_' if t in BOUNDARIES else 'partial_')+t.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[];observed_files={}
 def watch(p):
  p=pathlib.Path(p).resolve();st=p.stat();observed_files[str(p)]=(st.st_size,st.st_mtime_ns)
 def keep(p):
  x=pin(p);pins[x['path'].casefold()]=x;watch(p);return x
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root)
 packs=load(V/'pack-observation.json');conv=load(V/'conversion-observation.json');restore=load(V/'restore-observation.json')
 for f in ['pack-observation.json','conversion-observation.json','restore-observation.json']:keep(V/f)
 for d in [packs,conv,restore]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer']);check('python_'+d['producer']['path'],keep(d['python']['path'])==d['python']);check('passed_'+d['producer']['path'],d['passed'] is True)
 manifest=load(root/'assets-manifest.json');check('manifest_identity',keep(root/'assets-manifest.json')==packs['manifest']==restore['manifest']);cache=root/'.asset-cache'/manifest['release'];em={x['path']:x for x in manifest['files']};check('manifest_unique',len(em)==len(manifest['files'])==7511 and len(manifest['packs'])==22);check('pack_counts',packs['declared_packs']==packs['pack_identity_matches']==22 and packs['declared_files']==7511)
 for p,row in zip(manifest['packs'],packs['packs'],strict=True):
  check('pack_hash_'+p['name'],keep(cache/p['name'])==row['source'] and all(row['source'][k]==p[k] for k in ['bytes','sha256']));expected={x['path']:x for x in manifest['files'] if x['pack']==p['name']};check('pack_population_'+p['name'],row['name']==p['name'] and row['member_count']==len(expected)==len(row['members']) and {x['path'] for x in row['members']}==set(expected))
  for x in row['members']:check('member_'+x['path'],all(x[k]==expected[x['path']][k] for k in ['bytes','sha256']))
 current_counts=collections.Counter();mutable={'docs/completion_plan.json','docs/coverage.json','docs/resume_checkpoint.json'}
 for x in packs['installed']:
  row=em[x['path']];p=root/x['path'];check('installed_expected_'+x['path'],x['expected']=={k:row[k] for k in ['bytes','sha256']} and x['pack']==row['pack'])
  if x['path'] in mutable:
   check('preserved_policy_'+x['path'],row.get('preserve_existing_working_document') is True and x['status']=='preserved_working_document' and p.is_file());current_counts['preserved_working_document']+=1
  else:
   observed=pin(p);watch(p);check('installed_bytes_'+x['path'],x['status']=='exact' and observed==x['observed'] and all(observed[k]==row[k] for k in ['bytes','sha256']));current_counts['exact']+=1
 check('installed_census',len(packs['installed'])==7511 and len({x['path'] for x in packs['installed']})==7511 and dict(current_counts)==packs['installed_counts']=={'exact':7508,'preserved_working_document':3})
 extras=[str(p) for p in sorted(cache.glob('*.zip')) if p.name not in {x['name'] for x in manifest['packs']}];check('undeclared_cache_retained',extras==packs['undeclared_cached_files'] and len(extras)==1)
 for k in ['all_runtime_resources_declared','transitive_dependencies_qualified','all_assets_installed_exactly','originals_modified','download_or_restore_performed']:check('pack_scope_'+k,packs[k] is False)
 literal=re.compile(r'\binclude_(str|bytes)!\s*\(\s*"([^"\n]+)"\s*\)');includes=[];rust_files=[]
 for base in [root/'crates',root/'launcher/src-tauri/src']:
  for p in sorted(base.rglob('*.rs')):
   rust_files.append(str(p));text=p.read_text(encoding='utf8');hits=list(literal.finditer(text))
   if hits:keep(p)
   for h in hits:
    target=(p.parent/h.group(2)).resolve();rel=target.relative_to(root).as_posix() if target.is_relative_to(root) else None;includes.append(dict(consumer=p.relative_to(root).as_posix(),line=text[:h.start()].count('\n')+1,macro=h.group(1),literal=h.group(2),resolved=str(target),project_relative=rel,exists=target.is_file(),declared_pack=em.get(rel,{}).get('pack'),status='lexical_candidate_not_cfg_or_transitive_proof'))
 check('literal_candidates_exact',includes==packs['lexical_include_candidates']);check('candidate_scope',len(includes)==1428 and sum(bool(x['declared_pack']) for x in includes)==708 and all(x['exists'] for x in includes))
 for k in ['dotnet','runtimes','runtime_config','deps']:check('converter_'+k,keep(conv[k]['path'])==conv[k])
 for x in conv['copied_tool_files']+conv['inputs']:
  for k in ['original','copy']:check('copied_'+x[k]['path'],keep(x[k]['path'])==x[k])
  check('copy_identity_'+x['copy']['path'],all(x['copy'][k]==x['original'][k] for k in ['bytes','sha256']))
 for x in conv['diagnostic_inputs']+conv['converter_source_context']:check('converter_context_'+x['path'],keep(x['path'])==x)
 check('conversion_scope',len(conv['runs'])==2 and conv['case_count']==len(conv['cases'])==8 and conv['all_formats_deterministic'] is False and conv['hermetic_filesystem_access_proven'] is False and conv['live_assets_modified'] is False and conv['native_originals_unchanged'] is True)
 for run in conv['runs']:
  check('repeat_'+run['format'],run['byte_identical'] and run['outputs'][0]['sha256']==run['outputs'][1]['sha256'])
  for x in run['outputs']:check('conversion_output_'+x['path'],keep(x['path'])==x)
 for c in conv['cases']:
  check('converter_log_'+c['name'],keep(c['log']['path'])==c['log']);check('converter_return_'+c['name'],c['exit_code']==0 if c['expected']=='accept' else c['exit_code']!=0)
 check('eight_converter_cases',[x['name'] for x in conv['cases']]==['inibin-1','inibin-2','static-1','static-2','missing-input','truncated-static','unsupported-inibin','missing-toolkit'])
 native_ini=pathlib.Path(conv['inputs'][0]['original']['path']);values=reference_inibin.read(native_ini);check('current_source_reader_repeat',len(values)>0 and values==reference_inibin.read(native_ini))
 for x in restore['source_packs']:check('restore_pack_'+x['path'],keep(x['path'])==x)
 for x in restore['restored']:check('restored_'+x['output']['path'],keep(x['output']['path'])==x['output'] and all(x['output'][k]==em[x['manifest']['path']][k] for k in ['bytes','sha256']))
 check('restore_case_scope',len(restore['restored'])==10 and restore['case_count']==7 and restore['expected_refusals']==4 and restore['network_access_performed'] is False and restore['live_assets_modified'] is False)
 for x in [restore['consumer'],restore['log'],restore['vendored_conversion_reference']['source']]:check('restore_provenance_'+x['path'],keep(x['path'])==x)
 check('vendored_import_failure',restore['vendored_conversion_reference']['outcome']['import_succeeded'] is False and all(not x['exists'] for x in restore['vendored_conversion_reference']['imports']))
 for x in restore['vendored_conversion_reference']['imports']:check('vendored_path_'+x['module'],pathlib.Path(x['expected_file']).exists()==x['exists'])
 for k in ['all_formats_reimported','native_import_cache_invalidation_proven','transitive_graph_complete']:check('restore_scope_'+k,restore[k] is False)
 verifier=membership.RadsReferenceMembership(loc['previous_root']);blue=verifier.deploy/'DATA/Characters/Blue_Minion_Basic/Blue_Minion_Basic.dds';local=root/'assets/forms/native_minion_mips/Blue_Minion_Basic.dds';nativepaths=[native_ini,pathlib.Path(conv['inputs'][1]['original']['path']),blue];members=[]
 check('native_blue_matches_pack11',all(keep(blue)[k]==keep(local)[k] for k in ['bytes','sha256']) and em[local.relative_to(root).as_posix()]['pack'].startswith('openleague-assets-11-'))
 for p in nativepaths:
  identity=keep(p);m=verifier.inspect(p.relative_to(verifier.deploy).as_posix(),p,identity);check('native_member_'+str(p),m['status']=='matches_selected_project_manifest');members.append(m)
 for x in [verifier.catalogue_identity,verifier.solution_identity,verifier.configuration_identity,*[m['identity'] for m in verifier.manifests],*verifier.provenance]:check('manifest_pin_'+x['path'],all(keep(x['path'])[k]==x[k] for k in ['bytes','sha256']))
 for p in LOCAL+['docs/reference_client_4_20.json','tools/project-plan/rads_reference_membership.py']:keep(root/p)
 for p in ['prepare_context.py','phase-and-package-context.json','packs.log','conversion.log','restore.log']:keep(V/p)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(packs=packs,conversion=conv,restore=restore,current_installed_counts=dict(current_counts),native_membership=members,native_examples=dict(inibin=str(native_ini),scb=str(nativepaths[1]),dds=str(blue)),reference_ini_fields=len(values),policies=dict(all_formats_versioned=False,all_imports_deterministic=False,native_import_cache_invalidation=False,transitive_dependencies_complete=False,all_required_assets_distributed=False,all_packs_rebuilt=False,hermetic_reimport_proven=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values()),observed_files,sorted(rust_files)
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  f,p,stats,rust_files=_CACHE[key]
  # Hashes verified once per process;subsequent receipt mutations retain the same source snapshot.
  # Any mtime/size change forces refusal rather than adopting bytes or silently refreshing evidence.
  for path,expected in stats.items():
   s=pathlib.Path(path).stat();require((s.st_size,s.st_mtime_ns)==expected,'source snapshot changed '+path)
  now=sorted(str(p) for base in [pathlib.Path(root)/'crates',pathlib.Path(root)/'launcher/src-tauri/src'] for p in base.rglob('*.rs'));require(now==rust_files,'Rust census changed')
 return _CACHE[key][:2]
def bindings(f,t):
 key='dds' if t in [TARGETS[4],TARGETS[5]] else 'scb' if t in [TARGETS[0],TARGETS[3],TARGETS[6]] else 'inibin'
 return [dict(path=f['native_examples'][key],role='native_'+key+'_declared_conversion_or_pack_example',selector='Bounded exact native example;does not establish all formats,dependencies or distribution coverage')]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_conversion_distribution_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),full_source_hash_pass_per_process=True,cached_receipt_checks='mtime/size snapshot and Rust file census;changed source refused',native_or_game_executed=False)
