from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,re,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));from PIL import Image
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();now=datetime.now(timezone.utc).isoformat()
c=load('data/4.20/map10_particle_catalog.json');t=load('data/4.20/map10_particle_textures.json');m=load('data/4.20/map10_particle_meshes.json');o=load('docs/map10_spawn_orphan_sections.json')
selector=load('data/4.20/map_particle_type_selection_contract.json');assert selector['passed'] and len(selector['cases'])==18 and selector['adapters']==[]
assert len(c['placements'])==244 and len(c['definitions'])==26 and sum(len(d['groups']) for d in c['definitions'])==52 and not c['missing_references']
assert sum(d['native_fields'] for d in c['definitions'])==1638 and sum(d['unknown_field_count'] for d in c['definitions'])==4 and o['fields_recovered']==142
assert t['references']==29 and len(t['entries'])==28 and [v['reference'] for v in t['missing']]==['TT_Mist_circle.tga'] and not t['ambiguous'] and not t['decode_failures']
assert m['references']==5 and len(m['entries'])==4 and [v['reference'] for v in m['missing']]==['fogcircle.sco'] and not m['ambiguous'] and not m['decode_failures']
artifacts=['data/4.20/map10_particle_catalog.json','data/4.20/map10_particle_textures.json','data/4.20/map10_particle_meshes.json','docs/map10_spawn_orphan_sections.json']
artifacts+=['data/4.20/map_particle_type_selection_contract.json','docs/native_map_particle_group_discovery.json','tools/probe_native_map_particle_type_selection.py','tools/discover_native_map_particle_groups.py']
for d in c['definitions']:
 assert sha(d['asset'])==d['asset_sha256'];doc=load(d['asset']);assert len(doc['fields'])+len(doc['unknown_hashes'])==d['native_fields'];assert hashlib.sha256(Path(d['native_file']).read_bytes()).hexdigest()==d['source_sha256'];artifacts.append(d['asset'])
for e in t['entries']:
 assert (r/'assets'/e['dds_asset']).read_bytes()==Path(e['source']).read_bytes();png=r/'assets'/e['png_asset'];assert hashlib.sha256(png.read_bytes()).hexdigest()==e['png_sha256'];a=Image.open(png).convert('RGBA');b=Image.open(e['source']).convert('RGBA');assert a.size==b.size and a.tobytes()==b.tobytes();artifacts.extend(['assets/'+e['dds_asset'],'assets/'+e['png_asset']])
for e in m['entries']:
 asset='assets/'+e['mesh_asset'];assert sha(asset)==e['mesh_asset_sha256'];assert (r/'assets'/e['original_asset']).read_bytes()==Path(e['source']).read_bytes();doc=load(asset);assert len(doc['vertices_native_xyz'])==e['vertex_count'] and len(doc['faces'])==e['triangle_count'];artifacts.extend([asset,'assets/'+e['original_asset']])
pipeline=['recover_map10_particle_catalog.py','qualify_map10_spawn_orphan_sections.py','recover_map10_particle_textures.py','recover_map10_particle_meshes.py','recover_map10_particle_scb.py'];artifacts.extend(['tools/'+v for v in pipeline]);artifacts.extend(str(p.relative_to(r)).replace('\\','/') for p in (r/'tools/references/league-toolkit-static').iterdir() if p.is_file())
next_action='Qualifier le chargement natif des groupes Map10 et des maillages SCB, les courbes couleur/alpha/échelle et leur rendu ; récupérer TT_Mist_circle et fogcircle ou tracer leur reconstruction. Remplacer les huit sprites ambiants reconstruits ; achever HUD/carte et partie à six clients, puis les 24 domaines.'
receipt='docs/map10_particle_catalog_progress.json';proof={'updated_utc':now,'complete':False,'product_rendering_changed':False,'binaries_changed':False,'rust_tests_rerun':False,'static_placements':244,'native_definitions':26,'declared_groups':52,'native_encoded_fields':1638,'named_encoded_fields':1634,'orphan_fields_recovered':142,'orphan_sections':6,'unknown_fields':4,'texture_references':29,'native_textures_recovered':28,'missing_textures':['TT_Mist_circle.tga'],'mesh_references':5,'mesh_geometry_recovered':4,'missing_meshes':['fogcircle.sco'],'native_mesh_vertices':sum(e['vertex_count'] for e in m['entries']),'native_mesh_triangles':sum(e['triangle_count'] for e in m['entries']),'pipeline_executed_from_project':pipeline,'artifacts_sha256':{p:sha(p) for p in artifacts},'community_reference':{'repository':'https://github.com/LeagueToolkit/league-toolkit','revision':'3f49b76488b6ff0623b7ea24aaad61c700552f0b','files':'tools/references/league-toolkit-static','license':'LICENSE-APACHE'},'limits':['Native asset recovery and encoding checks do not prove original emitter defaults, curve execution, pose or raster fidelity. The Rust renderer has not changed in this step.','Six authored sections in Chaos_Spawn/Order_Spawn are absent from their active GroupPart lists. They remain separate, not enabled or counted as additional declared groups.','Saucer8 SCB geometry has exact binary re-encoding including RGB face colors. Original .sco reference to .scb native loader resolution remains unqualified.','TT_Mist_circle and fogcircle absent from examined client paths; exact web searches found no downloadable source. Four unnamed encoded fields remain explicit.','Eight fixed-tint reconstructed sprites remain in the ordinary map asset; full map, champion kits, six-client match and all24domains remain incomplete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof['native_type_selector_cases']=18;proof['native_type_selector_instruction_addresses']=selector['original_instruction_addresses'];proof['native_type_default_reader_qualified']=False;proof['limits'].append('18 original type-selector cases executed: only exact case-sensitive Simple selects Simple; other supplied strings select Complex. Original caller supplies Complex as default argument, but absent-field reader execution remains unqualified.');(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('map10-native-particles-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,map10_particle_catalog_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_asset_progress=receipt,map10_particle_definitions=26,map10_particle_declared_groups=52,map10_particle_unknown_fields=4,map10_particle_original_textures=28,map10_particle_original_meshes=4)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('02','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="map10-native-particle-recovery"><h2>Ressources natives des particules Map10</h2><p>244 placements, 26 définitions, 52 groupes déclarés ; 1 634 champs identifiés sur 1 638. 28 textures et quatre maillages originaux récupérés. 142 champs appartenant à six sections non déclarées récupérés sans activer ces sections. TT_Mist_circle et fogcircle restent manquants. Courbes, poses et rendu animé à intégrer et qualifier ; aucun domaine clôturé.</p><a href="map10_particle_catalog_progress.json">Preuves et limites</a></section>'
if 'id="map10-native-particle-recovery"' in s:s=re.sub(r'<section id="map10-native-particle-recovery">.*?</section>',section,s,flags=re.S)
else:s=s.replace('</body>',section+'</body>')
p.write_text(s,encoding='utf-8');p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_asset_progress=receipt,next_steps=[next_action]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for root in (r/'docs',Path('E:/mapslol3v3')):
 p=root/'GOAL-OPENLEAGUE-NOUVEAU.txt'
 if p.exists():s=p.read_text(encoding='utf-8');s=s.replace('146 champs inconnus','4 champs inconnus');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'artifacts_verified':len(set(artifacts)),'unknown_fields':4,'native_meshes':4,'native_textures':28,'domains_closed':0,'rust_rendering_changed':False}))
