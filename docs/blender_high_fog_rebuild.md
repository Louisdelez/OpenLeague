# Reconstruction des sources Blender

Les deux sources courantes ont été mises à jour et rouverts ; voir blender_high_fog_progress.json. Le post-traitement refuse de superposer une deuxième fois le même groupe.

Pour une reconstruction depuis les ressources, conserver les sources courantes puis exécuter avec Blender 4.5 : tools/create_map_blender_source.py, tools/create_animated_map_blender_source.py, puis tools/update_blender_high_fog.py. Les générateurs de base conservent le groupe bas historique avant son remplacement par le post-traitement. Cette séquence complète reste à rejouer depuis une installation propre ; les deux fichiers actuels et le post-traitement sont vérifiés séparément.

Le rendu tools/render_blender_high_fog.py utilise une caméra de diagnostic et ne sauvegarde aucune modification de scène. Il ne prouve pas la fidélité du client original.
