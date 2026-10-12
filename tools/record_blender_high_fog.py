from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
receipt=load('docs/blender_high_fog_progress.json');preview=load('docs/blender_high_fog_preview.json')
assert receipt['passed'] and len(receipt['files'])==2
for f in receipt['files']:
 assert f['high_fog_materials']==87 and f['attributed_meshes']==2351 and f['triangles_unchanged']
 assert f['sha256']==hashlib.sha256(Path(f['file']).read_bytes()).hexdigest()
preview.update(visual_inspected=True,observation='Environment and high-fog materials render; cyan/blue background gap remains near Chaos base. Diagnostic camera differs from runtime; no original-frame comparison.')
save('docs/blender_high_fog_preview.json',preview)
receipt.update(preview=preview,render_preview_inspected=True,updated_utc=now)
action='Qualifier le producteur et le profil final des options de brouillard, les exclusions FULLBRIGHT/NOLIGHTING et les passes de rendu natives. Sources Blender statique/animée désormais liées à87matériaux de brouillard haut,2351maillages avec interpolants etCloud2DDSpacké ; aperçu rendu/inspecté mais fidélité Blender complète non qualifiée. Référence originale du fond Chaos, mip automatique de frame, vision et gamma Blender restent ouverts. Puis cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et tous les24domaines.'
receipt['next_action']=action;save('docs/blender_high_fog_progress.json',receipt)
archive=r/'docs/plan_history'/('blender-high-fog-plan-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,blender_high_fog_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[]);d['last_verified'].update(blender_high_fog_materials=87,blender_high_fog_sources=2,blender_high_fog_mesh_attributes=2351)
 else:d['current_evidence'].update(blender_high_fog_materials=87,blender_high_fog_sources=2,blender_high_fog_mesh_attributes=2351)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['update_blender_high_fog.py','render_blender_high_fog.py','record_blender_high_fog.py']:shutil.copy2(stage/name,r/'tools'/name)
for p in ['data/4.20/map_fog_settings.json','tools/recover_native_fog.py']:
 s=(r/p).read_text(encoding='utf-8');s=s.replace('clouds/high layer still pending runtime integration.','clouds/high layer integrated into current runtime; see docs/native_high_fog_progress.json for scope and limits.');(r/p).write_text(s,encoding='utf-8')
p=r/'tools/blender_native_fog.py';s=p.read_text(encoding='utf-8');s=s.replace('native top layer zero for Map10.','high top layer remains separate; it is not identically zero for Map10.');p.write_text(s,encoding='utf-8')
(r/'docs/blender_high_fog_rebuild.md').write_text('''# Reconstruction des sources Blender

Les deux sources courantes ont été mises à jour et rouverts ; voir blender_high_fog_progress.json. Le post-traitement refuse de superposer une deuxième fois le même groupe.

Pour une reconstruction depuis les ressources, conserver les sources courantes puis exécuter avec Blender 4.5 : tools/create_map_blender_source.py, tools/create_animated_map_blender_source.py, puis tools/update_blender_high_fog.py. Les générateurs de base conservent le groupe bas historique avant son remplacement par le post-traitement. Cette séquence complète reste à rejouer depuis une installation propre ; les deux fichiers actuels et le post-traitement sont vérifiés séparément.

Le rendu tools/render_blender_high_fog.py utilise une caméra de diagnostic et ne sauvegarde aucune modification de scène. Il ne prouve pas la fidélité du client original.
''',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Sources Blender mises à jour</h2><p>Deux sources statique/animée enregistrées et rouverts : 87 matériaux et 2 351 maillages avec paramètres de brouillard haut. Cloud2 DDS packé sans modification ; phase animée vérifiée après réouverture. Aperçu rendu et inspecté. Visibilité dynamique, mipmaps Blender, profil final et fidélité du rendu original encore ouverts.</p><a href="blender_high_fog_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(blender_sources=2,materials=87,attributed_meshes=2351,preview_inspected=True,game_binary_changed=False,complete=False)))
