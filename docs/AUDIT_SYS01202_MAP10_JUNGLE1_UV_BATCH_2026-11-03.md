# Audit SYS-01.2-02 — UV et frontières du terrain Jungle1 Map10 (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-JUNGLE1-UV-BATCH-01 ; parent SYS-01.2-02, tâche SYS-02.4-03. Suite de V1134 : comparer pour tous les morceaux du matériau `NVRMaterial_TT_Jungle1` leurs UV spatiaux Blender et le calcul c233 du client, vérifier les liens réels du nœud et examiner les frontières géométriquement identiques. Les autres matériaux, la proximité approchée, les jonctions partielles, le GPU et les pixels sont exclus.

## Sources et consommateurs

V1134 `AUDIT_SYS01202_MAP10_BLENDER_TERRAIN_UV_2026-11-03.md` a qualifié deux objets, la conversion de repère, la source native c233 et le chemin client, sans comparaison inter-objets. Les entrées de ce lot restent la scène `F:/OpenLeague/artwork/maps/TwistedTreeline_OpenLeague.blend` SHA-256 33ca3eb569c99d13a7751a14addb703627075b6b1a4b84359b490d96bc88ad9b, le GLB `F:/OpenLeague/assets/maps/twisted_treeline.glb` SHA-256 909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a et `data/4.20/terrain_transform_contract.json` SHA-256 41b5063e3c804dd8c7144e04eedfc000b59966f287d8be817a21ea66604b241b. Les empreintes relues correspondent aux preuves antérieures. La provenance du contrat de bornes `__LevelSize_.SCB` et du PE client 4.20.0.315 est documentée par V1134 ; les instructions natives ne sont pas rejouées ici.

Dans la scène ouverte, le nœud UVMap.001 est **effectivement relié** aux entrées Vector des textures `terrainHeightScale.png` et `compositeColorMap.png`. Le code client, `main.rs`, `map_coordinates.rs`, `terrain_material.rs`, `terrain_fow_vertex.wgsl` et `terrain_height_blend.wgsl`, charge la scène 0 et applique le calcul c233 pour les textures de hauteur et de couleur. Le calcul est reproduit sur CPU en f32 ; aucun shader GPU ni échantillonnage de texture n'est exécuté.

## Comparaison des morceaux et résultats

Inventaire : **34 nœuds GLB et 34 objets Blender** utilisant ce matériau, noms identiques, 1 728 indices/boucles. Tous sont des racines non transformées de la scène GLB 0 ; matrices Blender identité. Aucun objet n'est exclu ni en exception. Les positions et UV de chaque boucle sont comparés au GLB selon la conversion Blender/glTF établie V1134 ; erreur maximale observée : zéro pour les positions et environ 2,98e-8 pour les UV.

Après conversion de V vers la convention glTF, les **1 728 boucles sur 1 728** présentent une différence supérieure à 1e-6 sur au moins un axe par rapport au calcul c233 CPU. Les écarts signés sont compris entre 0,000520468 et 0,002009213 en U, et entre 0,000829667 et 0,001530528 en V. Cela étend la mesure des deux morceaux V1134 à ce seul matériau ; ces nombres ne démontrent ni corruption ni différence de pixels.

## Arêtes vérifiées et limites

Les arêtes internes sont d'abord établies par indices de sommets Blender : 151 arêtes internes, aucune discontinuité UV supérieure à 1e-6. Parmi 1 426 occurrences de bords locaux, un regroupement des **deux extrémités 3D exactement égales** donne 99 groupes à deux objets distincts, 451 à deux occurrences dans le même objet et 326 groupes à occurrence unique ; aucun groupe de plus de deux. Les UV des deux extrémités concordent dans les 99 groupes inter-objets et les 451 groupes d'un même objet, au seuil 1e-6. Un rapprochement exact indique une coïncidence géométrique, pas une soudure ou une couture visuelle.

Le contrôle ne traite pas les frontières vers d'autres matériaux, les positions proches mais non identiques, T-jonctions et recouvrements partiels ; les 326 occurrences uniques ne sont pas prouvées être des trous. Les textures, filtrages, orientation d'échantillonnage, interpolation, rendu et fidélité native ne sont pas comparés.

## Exécution et preuves

Blender 4.5.0 déjà installé, `--background --factory-startup --disable-autoexec --python-exit-code 1`, scène F: et script E:, deux exécutions code 0 ; aucune sauvegarde ou export. La première version du script et son résultat sont conservés séparément ; la seconde distingue notamment les occurrences d'un même objet. Binaire Blender SHA-256 a6511d5d7d430d119dbd9f0df85496073e926c5a81ccfa731a381ad2fe612fd0, identité réutilisée de V1134.

Preuves dans `E:/mapslol3v3/audit_map10_jungle1_uv_batch_20261103` : `probe.py` SHA-256 c8309994866ba9a7d56e2537483ff27826a115d31af460a799065bdfe36c290f ; `resultats.json` SHA-256 9aee435596aca5b9b4571522b32310fe2348c4ded9b2cf1d0e93145ce3fb38a0 ; `blender.log` SHA-256 33b2fb23b7774d43ab1baf37312341742fcea7a099e2a8d7ebc78ae4472a837c. Neuf empreintes d'entrée ont été recontrôlées. Les dénominateurs, noms, résultats par objet et groupes de multiplicité sont conservés dans le JSON.

## Écart et reprise

L'écart de coordonnées est établi pour les 34 objets Jungle1 ; son effet visuel et la référence correcte à adopter restent indéterminés. Réutiliser SYS-02.4-03 : qualifier les frontières inter-matériaux et les géométries non exactement coïncidentes, puis comparer les échantillonnages et rendus sous caméra, textures, versions et paramètres identifiés. Ne pas modifier automatiquement les UV ni généraliser aux autres matériaux sur ce seul résultat.

Audit de ce sous-périmètre terminé ; réparation, rendu, fidélité globale et acceptation humaine restent ouverts. Aucun asset, code produit, goal, registre, application de suivi ou base modifié.
