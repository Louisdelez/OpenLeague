# Audit SYS-01.2-02 — échantillonnage réel Blender des textures terrain Map10 (V1138)

## Unité et décision limitée

- Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-BLENDER-SAMPLING-01`.
- Parent : `SYS-01.2-02`; consommateurs de reprise : `SYS-02.4-03` et `SYS-02.4-04`.
- Question : le nœud Blender `ShaderNodeTexImage` utilisant les UV `UVMap.001` et les deux textures natives suit-il l’orientation V directe ou inversée observée dans la carte exportée ?
- Décision : l’audit de cette question Blender est terminé. L’implémentation de la carte, la vérification Bevy/GPU et l’acceptation humaine ne sont pas terminées.

Le lot ne modifie aucun fichier OpenLeague, scène source, asset, shader Rust, registre, goal, application de suivi ou base de données. Les scripts et rendus sont isolés sous `E:/mapslol3v3/audit_map10_blender_sampling_20261103`.

## Sources, identité et consommateurs

Entrées natives et preuves réutilisées :

- scène Blender `F:/OpenLeague/artwork/maps/TwistedTreeline_OpenLeague.blend`, SHA-256 `33ca3eb569c99d13a7751a14addb703627075b6b1a4b84359b490d96bc88ad9b` (identité V1134) ;
- géométrie `F:/OpenLeague/assets/maps/twisted_treeline.glb`, SHA-256 `909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a` (identité V1134) ;
- `F:/OpenLeague/assets/maps/terrain_native/terrainHeightScale.png`, 2048×2048 RGBA8, SHA-256 `23e25e91da2dddc7e3a3d5ea1f39d5684d1cc62811e8bde2302637e4d5db6c33` ;
- `F:/OpenLeague/assets/maps/terrain_native/compositeColorMap.png`, 1024×1024 RGBA8, SHA-256 `e237b63585e70d2b25002835a09cee16e62b38f4a3a9a0698153536c3b7e6849` ;
- V1134 `E:/mapslol3v3/audit_map10_blender_uv_20261103/resultats.json`, SHA-256 `111fbd54e6552a6f7cf0a533fcb6e94707cbf05acd9d71640ac6a791680b5094`, fournissant les 78 paires de boucles ;
- V1136 et V1137 relus pour les matériaux, leurs paramètres déclaratifs et la comparaison CPU précédente.

Le consommateur Blender réel est la scène et le chemin de préparation `F:/OpenLeague/tools/blender_native_terrain.py`, avec les nœuds de terrain décrits par V1136. Les consommateurs Rust inspectés mais non exécutés dans ce lot sont `F:/OpenLeague/crates/client/src/terrain_material.rs`, `F:/OpenLeague/assets/shaders/terrain_height_blend.wgsl` et `F:/OpenLeague/assets/shaders/terrain_fow_vertex.wgsl`.

## Méthode exécutée

1. Une scène Blender 4.5 en mémoire uniquement a été créée avec 78 quads temporaires (13×6). Chaque quad porte un UV constant issu de `blender_uv` V1134 dans la couche nommée `UVMap.001`.
2. Le graphe réel de test est `ShaderNodeUVMap` → `ShaderNodeTexImage` → `ShaderNodeEmission` → sortie. Les images sont chargées depuis les PNG natifs, réglées `Non-Color`, interpolation `Linear`, extension `EXTEND`.
3. Blender a été lancé avec `--background --factory-startup --disable-autoexec --python-exit-code 1`; moteur `BLENDER_EEVEE_NEXT`, vue `Standard`, sortie PNG. Le cadre caméra couvre exactement les 13×6 cellules.
4. Deux résolutions indépendantes ont été rendues : 8×8 puis 16×16 pixels par cellule. La valeur au centre de chaque cellule est relue par Python 3.12/Pillow, la sortie PNG sRGB est reconvertie en linéaire, puis comparée à deux modèles CPU bilinéaires niveau 0 : `y=v*h-0,5` (V direct) et `y=(1-v)*h-0,5` (V inversé).

Un témoin 2×2 synthétique confirme séparément que le nœud lit bien `UVMap.001`. Une grille d’identifiants a révélé puis corrigé le défaut de banc où `ortho_scale=rows` ne couvrait pas la grille large ; les résultats définitifs utilisent le cadre horizontal `ortho_scale=cols` et plusieurs pixels par cellule. Les premiers rendus EXR/chemin de texture erroné sont conservés comme anomalies de banc, pas comme preuves.

## Attendu et observé

Une orientation est retenue uniquement comme meilleure correspondance numérique du rendu Blender isolé ; le seuil `0,01` est un seuil de diagnostic de ce lot, pas une tolérance historique ou d’acceptation.

| Texture | Résolution | V direct : écart max / moyen | V inversé : écart max / moyen | cellules inversées ≤ 0,01 |
|---|---:|---:|---:|---:|
| hauteur | 8 px/cellule | 0,911970 / 0,107034 | 0,009732 / 0,001249 | 78/78 |
| couleur | 8 px/cellule | 0,165872 / 0,081466 | 0,004479 / 0,001199 | 78/78 |
| hauteur | 16 px/cellule | 0,911970 / 0,107153 | 0,009906 / 0,001282 | 78/78 |
| couleur | 16 px/cellule | 0,165872 / 0,081469 | 0,004399 / 0,001119 | 78/78 |

Le cas nominal est donc observé : deux images natives chargées, 78/78 cellules mesurées dans chaque rendu, et l’hypothèse V inversé est nettement plus proche dans les deux séries. Le V direct n’est pas retenu comme orientation Blender pour ce périmètre.

## Contrôles réellement exécutés

- Blender 4.5 : deux rendus finaux, code 0 ; sorties `height_s8.png`, `color_s8.png`, `height_s16.png`, `color_s16.png`.
- Python 3.12 du dépôt et Pillow : comparaison des 156 points par série, code 0.
- Témoin synthétique UV et grille d’identifiants : exécutés ; ils ne sont pas des preuves du jeu.
- Aucun client LoL historique, serveur, Bevy/GPU, capture d’écran de la carte, mipmap explicite ou parcours de partie n’a été exécuté.

Preuves détaillées : `E:/mapslol3v3/audit_map10_blender_sampling_20261103/perimetre.md`, `probe.py`, `compare.py`, `resultats_scale8.json`, `resultats_scale16.json`, `blender.log`, `blender_s16.log`, `compare.log`, `compare_s16.log`. Le résultat de référence final est `resultats_scale16.json` (SHA-256 `57ef1de5afba08368ee90529afaf112e46a474eff52904a2a3427bef0c14260a`) ; la série 8 px est `resultats_scale8.json` (SHA-256 `9c6335c70e7d816dc1540bc2dae6d403e2ab16b930a35e979436789c608ff8b4`).

## Limites, inconnues et reprise

- Les écarts résiduels (jusqu’à environ 0,01) ne permettent pas de qualifier le point de texel exact, le LOD/mipmap ou toutes les conversions de couleur ; les modèles CPU restent des comparateurs, pas une définition du renderer historique.
- La mesure porte sur 78 boucles de deux objets Jungle1 et sur le nœud Blender isolé. Elle ne généralise pas à toutes les mailles, aux mélanges de quatre couches, au brouillard, aux ombres, au GLB complet, à Bevy ou au GPU.
- La présence et la configuration déclarée des consommateurs Rust sont établies par lecture ; leur upload GPU et leurs pixels ne le sont pas.
- Aucune réparation UV ou texture n’est autorisée par ce lot. La reprise exige un rendu Bevy contrôlé (même emplacement, même version d’asset, capture ou lecture GPU) puis une qualification séparée du LOD et du mélange avant toute correction.

## Relecture des sept critères

1. Exigence et frontières : documentées ci-dessus et dans `perimetre.md`.
2. Sources/provenance : PNGs, scène, GLB et résultat V1134 identifiés et hashés ; client historique non exécuté.
3. Consommateurs : nœud Blender réellement rendu ; consommateurs Rust inspectés, non exécutés.
4. Attendu/observé : deux orientations, deux résolutions, 78 cellules par texture, résultats chiffrés.
5. Écarts/limites : résidu de sampler, LOD, GPU et portée explicitement ouverts.
6. Correction : aucune modification ; reprise SYS-02.4-03/04 proposée avec critères distincts.
7. Livrable/preuves : scripts, logs, résultats JSON et rendus isolés datés du 2026-11-03.

Conclusion limitée : audit de l’orientation V du sampler Blender sur ce jeu de boucles terminé ; fonctionnalité de terrain, fidélité de la carte et goal SYS-01.2-02 restent ouverts.
