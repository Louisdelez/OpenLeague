# Audit SYS-01.2-02 — échantillons CPU des textures terrain Map10 (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-TERRAIN-UV-SAMPLING-01 ; parent SYS-01.2-02, tâches SYS-02.4-03 et SYS-02.4-04. Question : sous un modèle explicite de lecture bilinéaire de niveau 0, les deux jeux de coordonnées mesurés V1134 produisent-ils les mêmes valeurs brutes dans les PNG de hauteur et de couleur ? Périmètre : 78 paires de boucles de deux objets Jungle1, pas 78 points uniques ni toute la carte. Ni rasterisation, shader, sortie finale ou rendu historique ne sont testés.

## Sources et consommateurs

V1134 `AUDIT_SYS01202_MAP10_BLENDER_TERRAIN_UV_2026-11-03.md` identifie la source native `__LevelSize_.SCB`, le contrat c233 et les 78 paires de coordonnées GLB/Blender et c233 CPU ; son `resultats.json` SHA-256 111fbd54e6552a6f7cf0a533fcb6e94707cbf05acd9d71640ac6a791680b5094 est relu et utilisé sans refaire la géométrie. V1136 a vérifié l'identité des PNG embarqués et externes et les paramètres déclaratifs des deux matériaux. Les textures utilisées sont `terrainHeightScale.png` SHA-256 23e25e91da2dddc7e3a3d5ea1f39d5684d1cc62811e8bde2302637e4d5db6c33 et `compositeColorMap.png` SHA-256 e237b63585e70d2b25002835a09cee16e62b38f4a3a9a0698153536c3b7e6849 ; leurs dimensions sont 2048² et 1024², RGBA8. Le contrat c233 provient d'une exécution native isolée antérieure, pas d'une partie historique exécutée ici.

Les consommateurs à comparer sont le nœud d'image Blender UVMap.001 et le shader client `terrain_height_blend.wgsl` alimenté par `terrain_fow_vertex.wgsl` ; V1136 documente Non-Color/STRAIGHT/Linear/EXTEND côté Blender et is_srgb=false/Linear/ClampToEdge côté client par lecture. Le modèle ci-dessous ne s'exécute dans aucun de ces moteurs.

## Orientation et modèle

Un contrôle séparé charge directement les PNG dans Blender 4.5 et compare huit positions `image.pixels` à Pillow 12.3.0 : les huit correspondent à la ligne Pillow inversée `(x,h-1-y)` ; six diffèrent de la même ligne sans inversion. Ces témoins sont limités à huit pixels ; ils ne prouvent ni origine d'échantillonnage des shaders ni upload GPU. Un autre témoin utilisé par le modèle compare deux positions asymétriques pour chaque image et concorde à 1e-6.

Le modèle CPU suppose explicitement pour **les deux jeux d'UV** que V augmente vers les lignes Pillow descendantes. Il utilise `x=u*largeur-0,5`, `y=v*hauteur-0,5`, un mélange bilinéaire des quatre voisins avec clamp de chaque accès au bord, RGBA brut divisé par 255, sans conversion sRGB, arithmétique double Python et niveau 0. Cette convention commune est une hypothèse de comparaison ; elle n'établit pas l'orientation effective du rendu Bevy ou Blender. Sept témoins synthétiques de centres, milieu et bords réussissent ; NaN et Inf sont refusés dans deux témoins supplémentaires. Ce sont des tests du modèle, non des refus observés du GPU.

## Résultats sous ce modèle

| Texture | Paires comparées | Écart > 1e-6 sur au moins un canal | Écart > 1/255 sur au moins un canal | Écart absolu maximal par canal RGBA |
|---|---:|---:|---:|---|
| Hauteur | 78 | 44 | 27 | 0,08590 ; 0,18210 ; 0,17401 ; 0 |
| Couleur | 78 | 78 | 73 | 0,04758 ; 0,05706 ; 0,06787 ; 0,03283 |

Ces différences sont des **valeurs de texture simulées aux coordonnées de boucles**, sur une échelle de 0 à 1. Elles suggèrent que l'écart UV peut modifier les valeurs lues dans ce modèle ; elles ne démontrent pas une différence de pixels à l'écran. Les moyennes et les 156 comparaisons individuelles sont conservées dans le résultat.

## Contrôles et preuves

Depuis `E:/mapslol3v3/audit_map10_texture_uv_samples_20261103` : Blender 4.5 déjà installé, `--background --factory-startup --disable-autoexec --python-exit-code 1`, pour les témoins d'images ; Python 3.12.14 du venv F: avec `-B` pour Pillow et le calcul, codes 0. Aucun fichier de projet sauvegardé ou exporté. `sample.py` SHA-256 a14412750eef7abf4b37293cc7021648f9a7cac07ce17fc803b6169cc0939c33 ; `resultats.json` 86d2763e2e779dbb89777aecc78869b3c537b00193b3042f3eab1b3499a2aeac ; `sample.log` ec73743f2c28b66f1aa16c5fe91ca7a4bf9020e19101a50b3936a2056f9be870. Sept empreintes référencées par le résultat ont été relues et correspondent.

Le témoin indépendant à huit pixels est dans `orientation/comparison.json` SHA-256 f2bc12b322a0f71054143e1b744ce226d2cb0d0e1b7d6b0f6304bbb2f489dc6c ; scripts `orientation/blender_probe.py` SHA-256 5a8a5042b4967adf52605b43f4d631777d534657d9108e543c392e4cda4722a0 et `orientation/compare.py` f3b274f4d4014b26ec4d8b4b1cb291c6e36eec1e74aa1ad5805d1490091b4b8b. La scène correspond après contrôle à l'empreinte V1134/V1136 ; aucun hash frais juste avant n'a été relevé séparément.

## Limites et reprise

L'orientation du pipeline effectif, l'échantillonnage Blender, l'upload GPU Bevy, la sélection de mipmaps, les poids de mélange des quatre couches, l'alpha, la conversion finale, l'interpolation par pixel et le rendu visuel ne sont pas vérifiés. Les 78 boucles proviennent de deux objets seulement ; aucun résultat généralisé à tous les pixels ou au jeu. Réutiliser SYS-02.4-03/04 : qualifier d'abord orientation et LOD des deux chemins réels, puis rendre ou capturer un même emplacement avec caméra, textures et version identifiées, et comparer. Ne pas corriger les UV automatiquement ou qualifier une corruption historique depuis cette simulation.

Audit de ce modèle et de ses témoins terminé ; rendu, réparation et acceptation humaine restent ouverts. Aucun goal, registre, application de suivi, base, code produit ou asset modifié.
