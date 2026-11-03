# Audit SYS-01.2-02 — échantillonnage GPU Bevy des textures terrain Map10

- Date : 2026-11-03, Europe/Zurich.
- Lot : `V1140`.
- Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-GPU-SAMPLING-01`.
- Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.
- Clauses de correction réutilisées : `SYS-02.4-03` et `SYS-02.4-04`.

## 1. Exigence et frontières

Question limitée : déterminer, par une exécution GPU isolée, si le décodage Bevy 0.19, l'upload wgpu 29.0.4 et le descriptor sampler courant échantillonnent les deux PNG terrain réels selon l'orientation directe ou inversée de leurs octets décodés.

Le probe est autonome sous `E:/mapslol3v3/audit_map10_bevy_gpu_sampling_20261103`. Aucun source, asset ou shader OpenLeague, registre, goal, Plan, application de suivi ou base de données n'est modifié. Aucun client OpenLeague complet, client LoL historique, serveur ou parcours de partie n'est lancé.

Critère de sortie : décoder les deux PNG avec Bevy, consigner le descriptor obtenu, uploader leurs octets, les échantillonner sur un GPU et relire les valeurs ; comparer numériquement orientation directe/inversée sur des coordonnées c233 et des témoins de bord. Une absence d'adaptateur ou une erreur offline aurait conservé le lot en échec documenté.

## 2. Sources, provenance et identités

Les sources natives et conversions restent celles qualifiées dans `F:/OpenLeague/docs/terrain_native_source_validation.json:66-74` :

| Rôle | DDS natif | PNG actuel exécuté |
|---|---|---|
| hauteur | SHA-256 `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` | `terrainHeightScale.png`, 2048×2048 RGBA8, 1 552 220 octets, SHA-256 `23e25e91da2dddc7e3a3d5ea1f39d5684d1cc62811e8bde2302637e4d5db6c33` |
| couleur | SHA-256 `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` | `compositeColorMap.png`, 1024×1024 RGBA8, 746 681 octets, SHA-256 `e237b63585e70d2b25002835a09cee16e62b38f4a3a9a0698153536c3b7e6849` |

Les deux hashes PNG ont été recalculés avant le verdict. Les 78 coordonnées par texture proviennent sans nouvelle extraction de `E:/mapslol3v3/audit_map10_texture_uv_samples_20261103/resultats.json`, preuve V1137. Ce sont les UV c233 du consommateur courant, distinctes des UV `UVMap.001` étudiées dans Blender.

Versions verrouillées par le `Cargo.lock` isolé : `bevy_asset`, `bevy_image` et `bevy_tasks` 0.19.0 ; `image` 0.25.10 ; `wgpu` 29.0.4 ; `serde_json` 1.0.151. Aucune dépendance n'a été téléchargée pendant l'exécution `--offline --locked`.

## 3. Consommateur réel et probe ciblé

V1139 a identifié le consommateur de production : `terrain_material.rs:152-198` charge et partage les PNG ; `terrain_fow_vertex.wgsl:149-153,170-172` produit `terrain_uv` depuis la position monde et c233 ; `terrain_height_blend.wgsl:55,63,83` échantillonne hauteur et colormap. Le code courant configure non-sRGB, ClampToEdge U/V, Linear min/mag ; Bevy complète avec mip Nearest et LOD 0–32.

La recherche délimitée n'a trouvé aucun contrôle existant réunissant les quatre conditions du lot : deux vrais PNG, sampler GPU courant, `textureSample` et readback. `map_texture_uv_gpu_probe.rs` ne traite que les UV ; `decal_colormap_gpu_probe.rs` utilise une texture synthétique 4×4 ; les tests `terrain_material.rs` restent CPU et `projected_*`.

Le probe nouveau réutilise les API du chemin courant sans intégrer de correction :

1. `bevy_image::Image::from_buffer` décode chaque PNG en `Rgba8Unorm`, non-sRGB ;
2. le descriptor exact est attaché à l'`Image` et vérifié ;
3. `Image.data`, `Image.texture_descriptor` et `Image.data_order` sont fournis à `wgpu::util::DeviceExt::create_texture_with_data`, comme le chemin d'upload courant ;
4. le sampler est créé avec `ImageSamplerDescriptor::as_wgpu()` ;
5. un shader compute exécute `textureSampleLevel(..., 0.0)` ;
6. le buffer RGBA f32 est relu et comparé au bilinéaire CPU clamp direct et inversé.

Ce probe cible les composants réels, mais il ne lance pas l'`AssetServer`, le RenderApp complet ni le fragment raster de la carte.

## 4. Comportement attendu, observé et contrôles

### Exécution finale

```powershell
$env:CARGO_TARGET_DIR='E:\mapslol3v3\cargo_target_sys01202'
$env:OPENLEAGUE_TERRAIN_GPU_RECEIPT='E:\mapslol3v3\audit_map10_bevy_gpu_sampling_20261103\resultats.json'
cargo run --manifest-path 'E:\mapslol3v3\audit_map10_bevy_gpu_sampling_20261103\Cargo.toml' --offline --locked
```

- Code de sortie : `0`.
- Adaptateur : `NVIDIA GeForce RTX 3060` ; backend : Vulkan.
- Les deux exécutions complètes ont réussi. Entre elles, seul `cargo fmt` a corrigé la forme après un premier `cargo fmt --check` code 1 ; aucune logique ni résultat n'a changé. Le contrôle final `cargo fmt --check` donne code 0.
- Descriptor observé dans les deux `Image` : `Rgba8Unorm`, `mip_level_count=1`, ordre `LayerMajor`, ClampToEdge U/V/W, Linear min/mag, Nearest mip, LOD 0–32, anisotropie 1.
- Par texture : 78 UV c233 + 9 témoins = 87 échantillons, 348 canaux. Total : 174 échantillons GPU et 696 canaux relus.

### Résultats numériques

La référence « directe » utilise `x=u×largeur−0,5`, `y=v×hauteur−0,5` sur les lignes décodées ; l'inversée remplace `v` par `1−v`. La tolérance `1/255 + 10⁻⁶` est un seuil de diagnostic, pas une tolérance Riot ni une acceptation visuelle.

| Texture | direct max / moyen | inversé max / moyen | points où direct gagne | centres exacts max |
|---|---:|---:|---:|---:|
| hauteur | `0.0000643730` / `0.00000376883` | `0.989790` / `0.0937658` | 51/87 | `0` |
| colormap | `0.000282243` / `0.0000184233` | `0.647179` / `0.0812332` | 80/87 | `0` |

Les points restants sont des égalités ou zones non discriminantes, pas des victoires de l'orientation inversée. Les deux témoins d'orientation par image donnent une erreur directe nulle :

- hauteur, `u=0.333251953125`, `v=0.250244140625` : GPU/direct rouge `0.8862745`, inversé `0.0156863` ; le témoin miroir échange ces valeurs ;
- colormap, `u=0.33349609375`, `v=0.25048828125` : GPU/direct `[0.0705882, 0.0901961, 0.1137255, 0.6901961]`, distinct de l'inversé `[0.0117647, 0.0235294, 0.0235294, 0.6627451]` ; le témoin miroir confirme l'échange ;
- les témoins ClampToEdge hors `[0,1]` concordent exactement avec le modèle direct.

Résultat observé : pour ce décodeur, cet upload, ce descriptor et ce GPU, l'échantillonnage suit l'orientation **directe des lignes décodées**. Il n'y a pas d'inversion V cachée dans ce chemin isolé. Cela ne signifie pas que les coordonnées Blender et Bevy doivent être identiques : leurs producteurs d'UV sont différents.

## 5. Écarts, limites et inconnues

- Le probe qualifie le comportement courant Bevy/wgpu sur Vulkan RTX 3060, pas tous les backends ni le client complet.
- `textureSampleLevel` force le niveau 0. C'est cohérent avec les `Image` mono-mip observées, mais les dérivées implicites, l'interpolation raster, le mélange des quatre couches, le brouillard et le framebuffer complet ne sont pas exécutés.
- L'orientation directe est définie relativement aux octets RGBA décodés ; elle n'est pas une conclusion sur l'orientation historique D3D ou sur une corruption visuelle de la carte.
- Aucun draw LoL 4.20, état `SetSamplerState`, création/upload D3D ou framebuffer historique n'est observé. Adresse U/V, min/mag/mip, LOD bias et max mip natifs restent inconnus.
- L'ancienne validation 2026-10-03 utilisait `TEXCOORD_1`, un autre binaire et un modèle CPU ; elle n'est pas substituée à cette preuve ni utilisée pour qualifier le chemin c233 courant.

## 6. Corrections et condition de reprise

Aucune correction produit n'est appliquée : les valeurs GPU sont cohérentes avec le descriptor et le modèle direct actuels. Une différence avec Blender ne suffit pas à déclarer un défaut, car Blender V1138 utilisait `UVMap.001` alors que Bevy emploie c233.

Les IDs `SYS-02.4-03` et `SYS-02.4-04` restent ouverts pour la carte complète. Ne rejouer ce probe que si le PNG, le décodeur, le descriptor, le shader, wgpu ou le backend change. Pour lever la lacune historique, la condition de reprise reste une nouvelle preuve liant les DDS au draw Map10 4.20 et observant `SetTexture`, adresse U/V, min/mag/mip, LOD bias, max mip et l'upload ; à défaut, le comportement natif demeure indéterminé.

Un lot distinct pourra vérifier le fragment raster OpenLeague et un framebuffer contrôlé. Il devra identifier version d'asset, caméra, maillage, matériau, shader, backend et pixels ; il ne devra pas réexécuter ce compute sans question supplémentaire.

## 7. Livrable, preuves et statuts séparés

Preuves isolées : `perimetre.md`, `Cargo.toml`, `Cargo.lock`, `src/main.rs`, `cargo_run.log`, `cargo_run_final.log`, `resultats.json` et `hashes.sha256`. Identités principales :

- reçu `resultats.json` : SHA-256 `7c85614ecdba75fef2bcb9ff38ac33fd78d612310c576403a23d3940e1b40174` ;
- source `src/main.rs` : `7616450041d6b7966a48f6e1b89db08bd46b1eec6cc722b538f09b8394cc08ad` ;
- log final : `3daf9a33e90aacd082efd20beea62ba689d0ec233b151cd12168901f9b66a5ed` ;
- binaire isolé : `E:/mapslol3v3/cargo_target_sys01202/debug/openleague-terrain-gpu-audit.exe`, SHA-256 `17b98cd5e0cfcb75f0d35adcd9e70ec360a7c834d4b47768fd84ab1caa814df4`.

| Dimension | Verdict limité |
|---|---|
| Audit de l'unité V1140 | **terminé avec preuves** : décodage, descriptor, upload, échantillonnage et readback actuels qualifiés |
| Implémentation | **présente** dans le client ; aucune correction réalisée |
| Vérification technique | **réussie pour le probe GPU isolé**, **partielle pour la carte** |
| Acceptation humaine | **non demandée et non acquise** |

Les sept rubriques de la charte sont renseignées. Cette clôture ne concerne que `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-GPU-SAMPLING-01`. La fidélité LoL 4.20, le rendu complet de la carte, `SYS-02.4-03`, `SYS-02.4-04` et le goal parent `SYS-01.2-02` restent ouverts. Aucun registre n'est modifié sous la restriction utilisateur ; le rattachement est documentaire uniquement.
