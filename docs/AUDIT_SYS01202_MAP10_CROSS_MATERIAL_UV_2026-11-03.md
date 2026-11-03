# Audit SYS-01.2-02 — UV Lanes1, frontières et images du terrain Map10 (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-CROSS-MATERIAL-UV-01, parent SYS-01.2-02, tâche SYS-02.4-03. Suite de V1134/V1135 : comparer les UV spatiaux Lanes1 au calcul client c233 ; vérifier les frontières exactement coïncidentes entre Lanes1 et Jungle1 ; identifier les images et paramètres de leurs nœuds. Les positions seulement proches, jonctions partielles, autres matériaux, échantillonnage GPU, pixels et serveur/client historique sont exclus.

## Sources et consommateurs

V1134 documente la référence native `__LevelSize_.SCB` et le PE 4.20.0.315 utilisés pour le contrat c233 ; V1135 a examiné 34 objets Jungle1 sans autres matériaux. Scène Blender `F:/OpenLeague/artwork/maps/TwistedTreeline_OpenLeague.blend` SHA-256 33ca3eb569c99d13a7751a14addb703627075b6b1a4b84359b490d96bc88ad9b ; GLB `F:/OpenLeague/assets/maps/twisted_treeline.glb` SHA-256 909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a ; `terrain_transform_contract.json` SHA-256 41b5063e3c804dd8c7144e04eedfc000b59966f287d8be817a21ea66604b241b. Ces identités sont relues. Le calcul natif isolé antérieur n'est pas rejoué ici.

`main.rs` charge la scène GLB 0 sous la racine au 1/20 ; `terrain_fow_vertex.wgsl` remonte les coordonnées XZ et applique c233, puis `terrain_height_blend.wgsl` les utilise pour height_map et colormap. Le contrôle reproduit cette arithmétique sur CPU en f32. Blender utilise réellement UVMap.001 pour les deux images de chacun des matériaux ; correspondances géométriques et conversion Blender/glTF sont vérifiées sur les boucles, pas supposées à partir du libellé de nœud.

## Coordonnées et frontières : attendu et observé

L'inventaire trouve **48 objets Lanes1 / 1 761 boucles** et 34 objets Jungle1 / 1 728 boucles ; noms Blender/GLB concordants, 82 objets qualifiés, aucune exception. Les 34 lignes Jungle1 reproduisent exactement les résultats par objet de V1135. Les 1 761 boucles Lanes1 présentent un écart absolu supérieur à 1e-6 sur au moins un axe entre leur UV converti et le c233 simulé. Les écarts signés vont de 0,000442266 à 0,002079308 en U et de 0,000661105 à 0,001699865 en V. Les résultats complets par objet et les vérifications d'import figurent dans le JSON.

Pour les arêtes à incidence locale de bord, les deux extrémités 3D exactement égales sont rapprochées avec leur orientation UV. **25 groupes** contiennent un bord Jungle1 et un bord Lanes1, deux occurrences chacun ; aucun groupe multiple et aucune différence UV supérieure à 1e-6 aux extrémités. C'est une coïncidence géométrique mesurée, pas une preuve de soudure ni d'absence de couture visible. Les arêtes proches, subdivisées, partiellement superposées ou contiguës à d'autres matériaux restent ouvertes.

## Images et paramètres observés

Un second contrôle en lecture seule examine quatre nœuds réels (deux images × deux matériaux). Les PNG embarqués dans la scène sont byte-identiques aux fichiers externes du client : `terrainHeightScale.png` 2048², SHA-256 23e25e91da2dddc7e3a3d5ea1f39d5684d1cc62811e8bde2302637e4d5db6c33 ; `compositeColorMap.png` 1024², SHA-256 e237b63585e70d2b25002835a09cee16e62b38f4a3a9a0698153536c3b7e6849. Blender déclare Non-Color, alpha STRAIGHT, interpolation Linear et extension EXTEND ; lecture statique du client : is_srgb=false, ClampToEdge, filtres min/mag Linear. Ces paramètres sont analogues à un niveau déclaratif, sans preuve d'équivalence des bords, de l'orientation des pixels, de l'alpha ou du LOD réellement échantillonné.

## Exécution et preuves

Blender 4.5.0 déjà installé, `--background --factory-startup --disable-autoexec --python-exit-code 1`, scène F: et scripts dans `E:/mapslol3v3/audit_map10_cross_material_uv_20261103` : contrôle des géométries et contrôle séparé des images, codes 0, aucune sauvegarde ni export. Binaire SHA-256 a6511d5d7d430d119dbd9f0df85496073e926c5a81ccfa731a381ad2fe612fd0. Une première préparation de script a refusé un remplacement textuel avant écriture ; elle a été corrigée avant l'exécution Blender.

- Géométrie : `probe.py` SHA-256 fb7c9a7d3de34a99564a430e13a2d593e1aa519622c3cd9888b3ece33ee8b263 ; `resultats.json` bda954bf69b36e9b89064d5f7d1722f45aa5d5e595bd47f38f0a60d4db3e74bb ; `blender.log` 0adf4eadcf5fe768e11fd8c19ae848f48401ed943847138ac9ff3ecced99299c. `python -B verify.py`, code 0 ; `verification.json` SHA-256 5ce09a8f440c71d6488cd19c514f74f364e3d8686c16bc9350f6a162f85f0388, neuf empreintes de source et les 34 lignes précédentes vérifiées.
- Images : `sampling_probe/probe.py` SHA-256 9eb8e0acd4fa0d1aa91000b51ecf0ac2515c07d5e4ff36b2af93d5e8e93449cf ; `sampling_probe/result.json` 49be4f5e61e26913041e43bf88a62cc4bba266fd8fc78f3a67e541826af6c091 ; `sampling_probe/blender.log` 66d0300c7ff0ae61fbf14b5a66946e43ebbac09c238442126e17a0cea5c66bbb. Dix sources et les quatre liens/images ont été relus.

## Écarts et reprise

Les écarts de coordonnées sont documentés pour les deux matériaux de terrain ; les frontières exactement coïncidentes mesurées ne présentent pas d'écart UV. Il reste à qualifier frontières approchées/partielles et voisinage d'autres matériaux, orientation et échantillonnage effectifs, puis rendu comparatif sous versions, caméra, textures et paramètres identifiés. Réutiliser SYS-02.4-03 pour la correspondance UV et SYS-02.4-04 pour les matériaux : aucune réparation automatique ne découle d'une divergence numérique seule. La fidélité historique et l'impact visuel restent inconnus.

Audit de ce sous-périmètre terminé ; correction, rendu et acceptation humaine restent ouverts. Aucun code produit, asset, goal, registre, application de suivi ou base modifié.
