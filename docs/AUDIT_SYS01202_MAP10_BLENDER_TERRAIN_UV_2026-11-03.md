# Audit SYS-01.2-02 — UV spatiaux du terrain Map10 Blender/runtime (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-BLENDER-TERRAIN-UV-01 ; tâche SYS-02.4-03, parent SYS-01.2-02. Question : pour deux morceaux du matériau NVRMaterial_TT_Jungle1, comment les UV spatiaux stockés dans la scène Blender se comparent-ils au calcul de coordonnées du terrain dans le client courant, et que montrent les arêtes internes ? Critères : même géométrie et repères vérifiés, données numériques par boucle, c233 identifié, arêtes et limites. Les autres morceaux, coutures inter-objets, shaders GPU et pixels sont exclus.

## Sources et consommateurs

V98 `FIDELITY_REPAIR_WORKFLOW_LINKS_4_20.md` avait rouvert les deux scènes et constaté des UV finis et le libellé `xz/15360`, sans comparer numériquement coordonnées ou coutures. La scène `F:/OpenLeague/artwork/maps/TwistedTreeline_OpenLeague.blend` a SHA-256 33ca3eb569c99d13a7751a14addb703627075b6b1a4b84359b490d96bc88ad9b ; GLB `F:/OpenLeague/assets/maps/twisted_treeline.glb` SHA-256 909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a. Ces empreintes correspondent au reçu V98, ont été lues par la fixture et recontrôlées ensuite. L'empreinte juste avant cette exécution n'a pas été recalculée séparément.

La référence de bornes est `LEVELS/Map10/Scene/__LevelSize_.SCB`, SHA-256 16138f6f4d50fe54eaae63e6ec4f3c3a48d632a874dbd74c93306b44048f00b4 selon le contrat natif antérieur `data/4.20/terrain_transform_contract.json`, issu du PE client 4.20.0.315. Ce reçu qualifie une transformée isolée, pas le rendu historique. Ses valeurs c233 uploadées pour le cas Map10 sont `[6.494066474260762e-05, 6.494066474260762e-05, -0, -0]` en f32. Le SCB et le PE ne sont pas exécutés à nouveau dans ce lot.

Dans le matériau Blender, le nœud de libellé `Spatial UV: reconstructed xz/15360` choisit `UVMap.001` pour height_map et colormap (`tools/blender_native_terrain.py`). Côté client, `map_coordinates.rs` met la racine à 1/20, `terrain_fow_vertex.wgsl` multiplie les coordonnées monde XZ par 20 et applique c233 ; `terrain_height_blend.wgsl` utilise le résultat pour height_map et colormap. Le calcul est ici reproduit sur CPU en f32, non exécuté par le GPU.

## Méthode et résultats observés

Les objets `MapGeo_Instance_1093` et `MapGeo_Instance_1027` utilisent le matériau étudié : 3 et 75 boucles. Le script ouvre le JSON et le BIN du GLB en lecture seule et compare, pour chaque boucle, POSITION et TEXCOORD_1 à la position et à `UVMap.001` de Blender. Les nœuds GLB sélectionnés n'ont ni parent ni transformation explicite ; les matrices monde Blender sont identités. Sur ces boucles, la relation vérifiée est Blender `(x,y,z)=(gltf.x,-gltf.z,gltf.y)` et UV Blender `(u,1-v)` ; les erreurs de correspondance sont au plus 1e-5 pour la position et 1e-6 pour l'UV. Les fonctions de l'importeur Blender 4.5 décrivent également ces transformations. Ce constat ne prouve pas la correspondance des autres objets.

Après remise de V dans la convention glTF, l'écart maximal absolu entre UV stocké et calcul c233 simulé vaut :

| Objet | Boucles | Max U | Max V |
|---|---:|---:|---:|
| MapGeo_Instance_1093 | 3 | 0,002009213 | 0,000898063 |
| MapGeo_Instance_1027 | 75 | 0,001802266 | 0,001296759 |

Exemple de la première boucle 1093 : UV glTF `(0,790015340 ; 0,340644360)` ; c233 calculé `(0,788031399 ; 0,339788854)` ; différence `(0,001983941 ; 0,000855505)`. Ces écarts concernent des coordonnées, sans conclusion sur leur impact visuel ou sur la fidélité d'une des deux solutions.

Le contrôle des arêtes utilise uniquement les indices de sommets Blender partagés à l'intérieur de chaque objet, avec tolérance UV de 1e-6 : 1093 n'a aucune arête interne vérifiable ; 1027 en a cinq et aucune rupture UV détectée, plus 65 arêtes de bord. Ce n'est pas un contrôle des frontières entre objets, des sommets superposés non soudés ou des coutures visibles.

## Exécution et preuves

Commande réellement exécutée : `blender.exe --background --factory-startup --disable-autoexec --python-exit-code 1 F:\OpenLeague\artwork\maps\TwistedTreeline_OpenLeague.blend --python E:\mapslol3v3\audit_map10_blender_uv_20261103\probe.py`, avec sortie dans `blender.log` ; Blender 4.5.0, code 0, pas de sauvegarde ni export. Binaire `E:/mapslol3v3/tools/blender/blender-4.5.0-windows-x64/blender.exe` SHA-256 a6511d5d7d430d119dbd9f0df85496073e926c5a81ccfa731a381ad2fe612fd0. `probe.py` SHA-256 3873143099392cf90b7b34ae1c48b3ccb74bf24e46a275a5023db9824698b8f0 ; `resultats.json` SHA-256 111fbd54e6552a6f7cf0a533fcb6e94707cbf05acd9d71640ac6a791680b5094 ; `blender.log` SHA-256 afc0515b178d8be217bca68b8a9c5df1113db7933a2a7442a7bfa5899b2a2f74. Les huit empreintes d'entrée du résultat ont été relues. Les 78 lignes de valeurs sont conservées dans le JSON.

## Liaison à la scène client

`crates/client/src/main.rs:909–915` charge la scène GLB 0 sous `map_root_transform` ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620. Le contrôle `python -B E:\mapslol3v3\audit_map10_blender_uv_20261103\scene0_check.py` finit au code 0 et confirme que les deux nœuds nommés sont des racines de la scène GLB 0. Script SHA-256 f2959cf114ac28abf8176918ddf71e183fd43657877beace9e6d5762d5994227 ; résultat `scene0_check.json` SHA-256 68696a7345bf94f3f1d2b56ff0520a740766263e11431e0e75edfb281286738f. Cette liaison est statique ; Bevy et WGSL restent non exécutés ici.
## Écarts et reprise

L'écart numérique existe pour le périmètre mesuré. Reprendre SYS-02.4-03 : comparer les autres morceaux et les frontières géométriques inter-objets, puis qualifier transformations, échantillonnage et rendu côte à côte avec versions, textures et caméra identifiées. Déterminer la référence et le traitement voulu avant toute réparation ; ne pas interpréter l'écart comme une corruption certaine ni modifier l'asset sur cette seule mesure. Les autres scènes, matériaux, interpolation, filtrage et effet visuel demeurent ouverts.

Audit de ce sous-périmètre terminé ; correction, fidélité globale de la carte, exécution GPU et acceptation humaine restent ouvertes. Aucun goal, registre, code produit, application de suivi, base ou scène modifié.
