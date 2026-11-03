# Audit SYS-01.2-02 — consommateur terrain Rust/Bevy Map10

- Date : 2026-11-03, Europe/Zurich.
- Lot : `V1139`.
- Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-CONSUMER-01`.
- Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.
- Clauses de correction réutilisées : `SYS-02.4-03` et `SYS-02.4-04`.

## 1. Exigence et frontières

Question limitée : identifier le chemin Rust/Bevy qui consomme réellement `terrainHeightScale.png` et `compositeColorMap.png`, résoudre statiquement sa configuration sampler courante et déterminer si les contrôles existants vérifient l'échantillonnage terrain de production.

Le lot est en lecture seule pour le produit. Il ne modifie aucun source, asset, shader, registre, goal, Plan, application de suivi ou base de données. Aucun client graphique, client LoL historique, serveur ou parcours de partie n'est lancé. Les sorties de compilation et les preuves de travail restent sous `E:/mapslol3v3`.

Critère de sortie : consommateur et paramètres déclarés dans le code courant, contrôles réellement exécutés et limites identifiés ; toute lacune runtime, GPU ou historique reçoit une condition de reprise concrète.

## 2. Sources historiques et identités

La référence reste `League of Legends 4.20.0.315`, EUW/en_GB. `F:/OpenLeague/docs/terrain_native_source_validation.json:3-6` identifie `room.nvr` (SHA-256 `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082`) et `League of Legends.exe` (SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`).

Les associations natives réutilisées sont :

| Rôle | Source native | Source actuelle | Identité actuelle |
|---|---|---|---|
| hauteur | `LEVELS/Map10/terrainHeightScale.dds`, SHA-256 `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` | `assets/maps/terrain_native/terrainHeightScale.png`, 2048×2048 RGBA8 | SHA-256 `23e25e91da2dddc7e3a3d5ea1f39d5684d1cc62811e8bde2302637e4d5db6c33` |
| couleur | `LEVELS/Map10/compositeColorMap.dds`, SHA-256 `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` | `assets/maps/terrain_native/compositeColorMap.png`, 1024×1024 RGBA8 | SHA-256 `e237b63585e70d2b25002835a09cee16e62b38f4a3a9a0698153536c3b7e6849` |

La relation DDS→PNG est documentée dans `terrain_native_source_validation.json:66-74`. L'inspection des en-têtes des deux DDS donne `dwMipMapCount=0`, flags `0x00001007`, caps `0x00001002` et une taille exacte de `128 + largeur × hauteur × 4` : les fichiers fournis sont mono-niveau. Cela ne démontre ni l'absence d'une génération de mipmaps à l'exécution historique, ni les états du sampler D3D du draw terrain.

La transformée c233 est reliée à `LEVELS/Map10/Scene/__LevelSize_.SCB`, SHA-256 `16138f6f4d50fe54eaae63e6ec4f3c3a48d632a874dbd74c93306b44048f00b4`, dans `F:/OpenLeague/data/4.20/terrain_transform_contract.json`. Le producteur CPU et les bits chargés dans c233 sont qualifiés dans le périmètre de cette preuve ; le fichier précise qu'aucune soumission D3D ni équivalence framebuffer n'est prouvée.

## 3. Consommateurs réels actuels

Le chemin de production est présent :

1. `F:/OpenLeague/crates/client/src/main.rs:719` enregistre `MaterialPlugin<TerrainMaterial>` ; `main.rs:812` et `821` enregistrent respectivement `terrain_material::setup` et `terrain_material::bind`.
2. `F:/OpenLeague/crates/client/src/terrain_material.rs:152-158` lit `data/4.20/terrain_materials.json` et charge les deux images avec `image(..., false)`.
3. `terrain_material.rs:170-198` partage ces handles entre les matériaux terrain ; `terrain_material.rs:202-224` remplace le `StandardMaterial` d'une entité lorsque son `GltfMaterialName` correspond au catalogue.
4. `terrain_material.rs:44-49` expose les bindings texture/sampler `10/11` pour la hauteur et `12/13` pour la couleur.
5. `F:/OpenLeague/assets/shaders/terrain_fow_vertex.wgsl:149-153,170-172` calcule `native_terrain_uv` depuis `world_position.xz`, l'échelle terrain et la transformée c233.
6. `F:/OpenLeague/assets/shaders/terrain_height_blend.wgsl:50-63,81-83` échantillonne les quatre couches de détail avec `in.uv`, mais `height_map` et `colormap` avec `terrain_uv`.
7. `F:/OpenLeague/crates/client/src/map_fog.rs:101-102` charge aussi la colormap par le même helper non tuilé pour l'extension de brouillard.

Conclusion structurante : le consommateur Bevy de production n'utilise pas `UVMap.001` pour ces deux textures. Le résultat Blender V1138, qui qualifie l'orientation du nœud `UVMap.001 → Image Texture`, ne peut donc pas être transféré au rendu terrain Bevy.

Fichiers de production relus et identifiés :

- `terrain_material.rs` : SHA-256 `bebddf49191627dc78c52286b69d8086a517e1d6eeac647eca32a190e8b5faa1` ;
- `terrain_fow_vertex.wgsl` : `5b6121980b7545fbf4be0dbead7b6dc1a14d1441f5bf84d1d0594d4efd2dd995` ;
- `terrain_height_blend.wgsl` : `4f73f3f66707982f457a0f4126a6e220ad9329cb7a00f0febc47c331b623e917` ;
- `terrain_materials.json` : `3b3ee9c3b32a1dcc20adacaebe5be3e2a8c4df11758fee50223a8dfdd398fd07`.

## 4. Comportement attendu, observé et contrôles

### Sampler actuel établi statiquement

`terrain_material.rs:107-125` configure les deux images avec `is_srgb=false`, U/V `ClampToEdge` et min/mag `Linear`. Les champs laissés à `default()` sont résolus par Bevy 0.19 dans `bevy_image-0.19.0/src/image.rs:833-875` : mipmap `Nearest`, LOD `0..32`, anisotropie `1`, sans comparaison ni couleur de bord. `image.rs:932-947` transmet ces valeurs sans transformation à wgpu.

Le décodeur conserve les octets RGBA via `into_raw()` et choisit `Rgba8Unorm` lorsque `is_srgb=false` (`image_texture_conversion.rs:58-67,146-156`). `Image::new_uninit` crée une image avec `mip_level_count=1` (`image.rs:1121-1147`). Le chemin vendored envoie `image.data` à la texture (`vendor/bevy_render/src/texture/gpu_image.rs:79-109`) puis délègue directement à wgpu (`render_device.rs:219-229`). Aucun retournement vertical logiciel explicite n'a été observé dans ce chemin. Cette absence de flip explicite ne prouve pas à elle seule l'orientation des pixels GPU ou du framebuffer final.

### Test ciblé réellement exécuté

Commande finale :

```powershell
$env:CARGO_TARGET_DIR='E:\mapslol3v3\cargo_target_sys01202'
cargo test -p openleague-client terrain_material:: --offline --locked --no-fail-fast
```

- Cargo/Rustc : `1.96.1`, hôte `x86_64-pc-windows-msvc`.
- Résultat attendu : compiler la cible binaire de test déjà verrouillée, exécuter seulement les tests nommés `terrain_material::`, sans accès réseau.
- Résultat observé : code 0 ; 4 tests réussis, 0 échec, 0 ignoré, 1539 filtrés ; durée des tests 3,05 s après 4 min 33 s de compilation.
- Cas couverts : bits c233 et bornes dégénérées ; coordonnées monde/texture CPU ; contrats `projected_sampler` et `projected_filter`.
- Journal : `E:/mapslol3v3/audit_map10_bevy_consumer_20261103/cargo_test_bin_retry.log`, SHA-256 `44afc3a62a1a7e1e8293118316dba892da78d0aaa231913e12c393e852956c67`.
- Binaire : `E:/mapslol3v3/cargo_target_sys01202/debug/deps/openleague_client-170289a4dedad9dd.exe`, 352 612 864 octets, SHA-256 `0fe28bdef5168ac7db80e411858386ba81d67a1464fc0aceed4f350f00689192`.
- La compilation a produit 199 avertissements préexistants ; aucune correction automatique n'a été appliquée.

La tentative initiale avec `--lib` a été refusée avec le résultat attendu pour ce paquet (`no library targets found`) ; son journal est `cargo_test.log`, SHA-256 `8503abc1e41ea4b66c9b81359b4de35b1f475653ef6d73c5635250539170b60e`. Une première compilation binaire interrompue avant le résultat final est conservée dans `cargo_test_bin.log` mais n'est pas comptée comme preuve. Seul le retry terminé est recevable.

### Ce que ces tests ne prouvent pas

Les deux tests `projected_*` appellent le helper commun, mais leurs autorités natives concernent des images projetées/particules. Ils ne qualifient pas les états D3D du terrain Map10. Aucun contrôle exécuté ici ne charge les deux PNG réels dans un `AssetServer`, n'observe le `GpuImage`, ne réalise un `textureSample`, ne lit des pixels rendus ou ne compare un framebuffer Bevy au client 4.20.

## 5. Écarts, limites et inconnues

- Implémentation actuelle : chemin de chargement, bindings, UV c233 et shaders présents ; fidélité historique non démontrée.
- Mipmaps actuels : descriptor LOD `0..32`, mais les PNG décodés ont un seul niveau ; seul le niveau 0 existe dans ce chemin observé.
- Native 4.20 : adresse U/V, min/mag/mip, LOD bias, max mip, éventuelle génération runtime de mips, convention d'upload et orientation finale du draw terrain restent inconnus.
- `terrain_native_progress.json:30` conserve déjà la limite explicite : gamma, sampler et mipmap natifs non qualifiés.
- La preuve c233 qualifie le calcul et les bits CPU, pas le draw terrain historique final.
- Les preuves Blender, `projected_*` et les valeurs globales de reset ne sont pas transférées au sampler terrain.
- Aucun constat visuel de corruption ou d'équivalence n'est produit par ce lot.

## 6. Corrections et condition de reprise

Aucune correction produit n'est réalisée ou justifiée par ce lot : le chemin courant existe et l'état historique manquant ne permet pas de choisir honnêtement un changement d'UV, de texture ou de sampler. Les IDs existants `SYS-02.4-03` (géométrie/UV) et `SYS-02.4-04` (matériaux/rendu) restent les consommateurs des actions futures ; aucun doublon n'est ajouté au Plan sous la restriction actuelle.

Ne reprendre cette question qu'avec une piste nouvelle répondant à l'une des conditions suivantes :

1. associer les DDS Map10 au draw historique exact et observer, pour leurs stages, `SetTexture` et `SetSamplerState` couvrant U/V, min/mag/mip, LOD bias et max mip, ainsi que la création/upload de la ressource ; ou
2. exécuter un contrôle GPU Bevy isolé chargeant les deux PNG réels, capturant descriptors/samplers, échantillonnant des coordonnées discriminantes et relisant les pixels.

Le second contrôle peut qualifier le comportement actuel. Seule une capture ou une exécution native reliée au draw Map10 peut établir la fidélité historique. Ne pas rejouer V1137/V1138 sans nouvelle question : leurs preuves sont déjà réutilisées et leur périmètre diffère.

## 7. Livrable, cohérence et statuts séparés

Preuves datées : `E:/mapslol3v3/audit_map10_bevy_consumer_20261103/perimetre.md`, les trois journaux Cargo, `metadata.json` et le présent rapport. Les sources natives, actuelles et Bevy sont nommées avec leurs versions, chemins, lignes et identités utiles. La cohérence a été relue contre V1136, V1138, `terrain_native_source_validation.json`, `terrain_transform_contract.json` et les consommateurs de production.

| Dimension | Verdict limité |
|---|---|
| Audit de l'unité V1139 | **terminé avec preuves** : consommateur, configuration sampler courante résolue statiquement, contrôles et lacune native sont identifiés |
| Implémentation | **présente**, sans conclusion de fidélité LoL 4.20 |
| Vérification technique | **partielle** : quatre tests CPU réussis ; aucun test PNG/GPU/pixel |
| Acceptation humaine | **non demandée et non acquise** |

Les sept rubriques de la charte sont renseignées. La clôture concerne seulement `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-CONSUMER-01`. Les fonctionnalités terrain, `SYS-02.4-03`, `SYS-02.4-04` et le goal parent `SYS-01.2-02` restent ouverts. Aucun registre n'est modifié en raison de la restriction utilisateur ; le rattachement est consigné par les identifiants ci-dessus et dans les documents de reprise uniquement.
