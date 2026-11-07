# SYS-01.2-02 — V1141 — chaîne native textures et sampler du terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-SAMPLER-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé avec preuves pour le fragment déclaré**  
Verdict fonctionnel : **fidélité historique non terminée**  
Acceptation humaine : **non demandée**

## 1. Exigence et frontières

La question de ce lot est volontairement étroite : relier `terrainHeightScale.dds` et `compositeColorMap.dds` aux stages du matériau terrain Map10, puis déterminer ce que le chemin natif 4.20 écrit réellement pour `SetTexture` et `SetSamplerState`.

Critère de sortie : soit observer la chaîne et ses valeurs, soit identifier sans ambiguïté les états hérités et la nouvelle entrée nécessaire pour les qualifier. Un reset global, une passe projected, un shader seul ou le renderer Bevy courant ne vaut pas preuve du draw terrain historique.

Exclusions : processus historique complet, provider RADS effectif, vrais objets D3D issus des DDS, draw D3D9 final, pixels GPU, correction du renderer courant, modification des registres/du goal/du Plan/de l'application/de ses bases.

## 2. Sources historiques, identités et limites

### Binaire et ressources

- Exécutable : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Height map : `LEVELS/Map10/terrainHeightScale.dds` ; SHA-256 `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b`.
- Colormap : `LEVELS/Map10/compositeColorMap.dds` ; SHA-256 `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507`.
- Pixel shader `Environment/LIT_PS.ps_2_0` ; SHA-256 `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3`.
- Vertex shader `Environment/LIT_VS.vs_2_0` ; SHA-256 `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5`.
- Include `HeightBlending/HeightBlending.hls` ; SHA-256 `7b9354f7ed5e23b9259bae1883c02d7a8ad91f694ecbac5c0001721aa00812fb`.

Les identités DDS et leur équivalence avec les PNG courants sont réutilisées depuis `docs/terrain_native_source_validation.json` et V1139/V1140. Elles n'ont pas été reconstruites ni recalculées dans ce lot.

### Preuves réutilisées et recherche bornée

- `data/4.20/map_resource_population_contract.json` exécute l'insertion native et recense les deux noms ; il ne qualifie ni le constructeur Map10 complet ni le handle final.
- `data/4.20/environment_render_config_contract.json` établit que Map10 active `HeightBlending/enable` et `ColorMap/enable` ; il s'arrête avant le setup GPU.
- `data/4.20/environment_shader_macros_contract.json` sélectionne `USE_HEIGHT_BLEND` et `MOD2X_COLORMAP` ; il ne soumet pas les samplers.
- `data/4.20/environment_shader_selection_contract.json` identifie `0x95A730`, `0x95A480`, `0x95A640` et `0x983CB0`, mais son ancien reçu exclut la préparation texture.
- Les contrats reset, projected, gamma et particules ont été contrôlés comme témoins négatifs. Ils ne sont pas transférés au terrain : ils portent sur un autre moment ou un autre draw.

La sortie `static_inspection.json` contient aussi un balayage brut des octets `E8`. Ces candidats ne sont pas considérés comme des appels décodés. Seules les fenêtres alignées, désassemblées et corroborées ci-dessous servent de preuve.

## 3. Chaîne native et consommateurs exacts

### Nom de ressource vers champ de contexte — preuve statique originale

| Ressource | Loader original | Instructions déterminantes | Champ produit |
|---|---:|---|---:|
| `terrainHeightScale.dds` | `0x959B10..0x959BBC` | chaîne `.dds` à `0x959B46/0x959B8E`, création `0x98A770`, store `0x959B84` | `context+0x24` |
| `compositeColorMap.dds` | `0x959BC0..0x959C74` | chaîne `.dds` à `0x959BF6/0x959C3E`, création `0x98A770`, store `0x959C34`, publication `0x959C54` | `context+0x28` |
| `fogLightingMap.dds` | `0x959C80..0x959D2C` | chaîne `.dds` à `0x959CB6/0x959CFE`, création `0x98A770`, store `0x959CF4` | `context+0x2C` |

Cette partie relie statiquement les noms natifs aux champs. Les loaders n'ont pas été exécutés avec le provider historique ; elle ne prouve donc pas que les handles synthétiques du probe sont les objets réellement créés depuis ces DDS.

### Champ vers stage et frontière D3D — instructions originales exécutées

Conditions contrôlées : sélecteur `context+0x54 = 0`, type matériau `material+0x104 = 3`, height blending activé, branche `FOUR_BLEND` préchauffée.

| Producteur | Chemin original | Stage observé à `D3D SetTexture` |
|---|---|---:|
| `material+0xBAC/+0xBB4/+0xBBC/+0xBC4` | `0x95A640 → 0x983CB0 → 0x9C3050/0x9C30A0 → 0x9C62B0` | `s0..s3` |
| `context+0x24` | bind `0x95A8B6` puis même wrapper original | `s4` |
| `context+0x28` | `0x95A480` puis même wrapper original | `s8` |
| `context+0x2C` | `0x95A480` puis même wrapper original | `s9` |

Le HLSL corrobore la destination : `SAMPLER_4` est `s4`, `COLORMAP` est `s8`, et les deux utilisent `m_TexCoord1.xy` produit avec `TERRAIN_XFORM c233`. Les quatre détails utilisent `s0..s3`. `c23` porte les quatre scales ; `c25` est préparé avec les mots `3f800000,00000000,00000000,3dcccccd`, soit `[1,0,0,0.1]`.

### États sampler effectivement écrits

`0x95A480` demande uniquement, dans ce fragment :

- stage `8`, clé native `0`, valeur `2` ;
- stage `8`, clé native `1`, valeur `2` ;
- les deux mêmes demandes pour le stage `9`.

Les wrappers originaux `0x9C2270 → 0x9C1960 → 0x9C5260` traduisent ces demandes vers `D3DSAMP_ADDRESSU=1`, `D3DSAMP_ADDRESSV=2`, valeur D3D `3 = CLAMP`.

Le caller matériau `0x95AFC0` appelle un setter dédié `0x95AD40` à `0x95B035`, juste avant le bind du même matériau à `0x95B046 → 0x95A730`. Ce lien caller→setter→bind est statique dans ce lot, pas exécuté comme une seule chaîne. Pour le type `3`, la branche contrôlée `0x98AF00=false` met `s0..s3` en `WRAP` et `s4` en `CLAMP`; la branche contrôlée `true` met les stages pairs, dont `s4`, en `WRAP` et les impairs en `BORDER`.

Le producteur code-owned de `0x98AF00` est qualifié séparément : `0x98F3F0` construit le singleton de 12 octets et `0x98F479` initialise son octet `+8` à `0`. Les 23 références absolues au global `0x2D79048`, ses cinq stores et six plages de consommateurs ont été recensés ; les stores non nuls publient le même constructeur, les autres remettent le global à `null`, et aucun consommateur examiné ne réécrit `+8`. Aucun alias hors `.text` ni export du global n'est présent. L'état détenu par le code de cet EXE choisit donc la branche false : `s4 ADDRESSU/V = CLAMP`. Une mutation externe dans un processus historique complet n'est pas observée ni exclue absolument.

La table native `0x10E2B6C` expose huit clés vers les types D3D `1..8`. Elle ne contient pas `D3DSAMP_MAXMIPLEVEL=9`. Un appliqueur générique distinct `0x9BF910` soumet directement les types D3D `1,2,3,5,6,7,8,9,10,11`, dont le type `9` à `0x9BF9C4`, mais aucun lien vers le matériau terrain n'est établi.

## 4. Contrôles exécutés, attendu et observé

### Analyse statique

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_sampler_20261103\inspect_static.py
```

Livrable : `static_inspection.json`, SHA-256 `8179a80308d7de8cd51f88248f7876f8de92737e2af83136b562225078d1644a`. Script SHA-256 `fc91e95d73eaf5b228a9af4d77ccc74b981870368d88b7e8aafbacb6d4a02ce9`.

Attendu : retrouver les stores de champs, le dispatch type 3, les binds s4/s8 et les setters sampler sans attribuer de sens aux candidats bruts non alignés.  
Observé : chaîne ci-dessus retrouvée ; le setter matériau écrit U/V de `s4` suivant deux branches backend, mais ne fixe ni filtres ni LOD. Un setter `0x95CA25..0x95CA6A` met MAG/MIN/MIP à `LINEAR` sur 16 stages seulement après l'appel de draw `0x95C9B0 → 0x95B140` ; cette valeur n'est pas transférée au draw audité.

### Exécution isolée du chemin original

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_sampler_20261103\probe_exact_terrain_path.py
```

Résultat : succès, deux cas, `410` adresses d'instructions originales, `14` soumissions texture, `4` soumissions sampler dans le cas froid et `0` dans le cas déjà clamp.

Adresses requises toutes observées : `0x95A730`, `0x95A640`, `0x95A8B6`, `0x95A480`, `0x983CB0`, `0x9C3050`, `0x9C30A0`, `0x9C62B0`, `0x9C2270`, `0x9C1960`, `0x9C5260`.

| Cas | Attendu | Observé |
|---|---|---|
| cache sampler froid | textures distinctes `s0,1,2,3,4,8,9` ; clamp U/V s8/s9 | ordre exact observé ; 7 appels texture ; 4 appels sampler type `1/2`, valeur `3` |
| cache s8/s9 déjà à la valeur native clamp `2` | mêmes textures ; aucun doublon sampler | 7 appels texture ; 0 appel sampler ; cache final `2` |
| deux vecteurs sentinelles différents aux clés `4/5/6/7` | aucune mutation si le fragment hérite les états | valeurs byte-identiques avant/après sur s4/s8/s9 |

Probe SHA-256 `60849bae90bd6bc4f63cd2c06bdf22fa4d305e02e64c3d7db7829c0176562127`. Reçu `native_terrain_exact_path_execution.json`, SHA-256 `85fd491aef6fc66e1ceccede8e28a417635649f44674e905a04f33090f0366f6`.

Relecture indépendante du reçu : succès ; verdicts, 410 adresses, stages/identités texture, 4+0 appels sampler, table `1..8` et invariance des sentinelles vérifiés.

### Exécution isolée du setter matériau antérieur

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_sampler_20261103\probe_native_terrain_sampler_setter.py
```

Résultat : succès, deux branches contrôlées de l'original `0x98AF00`, `234` adresses d'instructions originales. Le getter original lit `global 0x2D79048 → byte +8`; le constructeur paresseux n'est pas exécuté car un objet explicite est fourni.

| Branche contrôlée | Appels D3D observés | Résultat s4 | Clés `4/5/6/7` |
|---|---:|---|---|
| `0x98AF00=false` | 10 | U/V `CLAMP` (`type 1/2`, valeur `3`) | préservées sur s0..s7 |
| `0x98AF00=true` | 20 | U/V `WRAP` (`type 1/2`, valeur `1`) | préservées sur s0..s7 |

Dans la branche true, les stages pairs `0/2/4/6` sont `WRAP`; les impairs `1/3/5/7` sont `BORDER` avec couleur de bord `0`. Le choix historique n'est pas déduit de ces deux cas contrôlés.

Probe SHA-256 `92b62acf0f2111707d036cb6f3f0862f26734bbaf840d8a34915e4899c804783`. Reçu `native_terrain_sampler_setter_execution.json`, SHA-256 `f2dcfc154d98a390cb4f4036a3ab40269b637b5fc1d177b14a13812e0a18c924`.

Relecture indépendante : succès ; verdict partiel, 234 adresses, 10/20 appels, s4 clamp/wrap, invariance des clés `4..7` et absence de choix historique dans ce reçu seul vérifiés. Le scan code-owned de la section suivante qualifie séparément la branche false. Une première expression PowerShell a signalé à tort `preservation` car `.Properties.Count` n'était pas forcé en tableau ; l'inspection montrait bien huit propriétés par cas, puis le contrôle corrigé avec `@(...)` a réussi. Il s'agit d'un défaut du vérificateur, pas du reçu.

### Qualification du flag backend détenu par l'EXE

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_sampler_20261103\inspect_backend_flag.py
```

Résultat : succès ; 23 références absolues, 5 stores du global, 6 plages de consommateurs sans writer `+8`, aucun alias hors `.text`, constructeur à `0`, branche code-owned false, donc `s4 U/V = CLAMP`.

Script SHA-256 `c53959ccf178f231fe2e79494e6a792c6f30e5daa36b90935d2a1b26a1547ef8`. Reçu `backend_flag_code_owned_state.json`, SHA-256 `fae9cdc8c38fec60ef1f2a4394e2d0403d3192dac609241b9b9315ca19ce7378`.

Relecture indépendante : succès ; comptes, six plages, absence d'alias, flag constructeur `0`, branche false, s4 clamp et absence de capture live vérifiés.

### Adaptateurs explicitement séparés

- Handles/objets texture opaques distincts et méthodes AddRef/Release/interface brute synthétiques ; le manager et les wrappers texture originaux vont jusqu'à la frontière `D3D SetTexture`.
- Renderer, cache, contexte et matériau préalloués ; ils sélectionnent la route retrouvée, sans prétendre reproduire le bootstrap historique.
- Endpoints D3D enregistrent les arguments puis renvoient `S_OK` ; aucun vrai device/GPU.
- Endpoints de bind shader, de constante et de cookie sont contrôlés ; le dispatch, les caches et les traductions visés restent originaux.
- Pour le probe du setter, `0x9838D0` est un adaptateur explicite de raster state qui observe `0x40C`; le setter sampler, `0x98AF00`, les caches et la traduction D3D restent originaux.

## 5. Écarts et inconnues restant ouverts

### Résolu par V1141

1. Route matériau exacte : type `3`, selector `0`, `FOUR_BLEND`, height blending actif.
2. Registres shader : height `s4`, colormap `s8`, fog `s9`.
3. Binds originaux jusqu'à `D3D SetTexture` : `context+0x24 → s4`, `context+0x28 → s8`.
4. Pour `s8` : `ADDRESSU/V = CLAMP` est explicitement demandé par le bind et observé à la frontière D3D ; le cache évite les doublons.
5. Pour `s4` : le setter immédiatement antérieur est identifié et exécuté dans ses deux branches ; le producteur code-owned du getter est qualifié à false, donc l'état détenu par l'EXE soumet `CLAMP`.
6. Preuve négative : ni le setter matériau ni le bind n'écrivent les clés filtre/mip/LOD ; deux états initiaux différents sont conservés par le bind.

### Toujours ouvert

1. **DDS vers handles réels** : les noms vers champs sont prouvés statiquement, pas par l'exécution du provider/loader historique complet.
2. **Stage 4 live historique** : la valeur code-owned est `CLAMP`, mais aucun processus historique complet n'a été capturé ; une mutation externe, injection ou patch mémoire non retrouvé reste hors preuve.
3. **Stages 4 et 8** : valeurs historiques de `MAG`, `MIN`, `MIP` et `LODBIAS` non déterminées ; le bind les conserve et le setter linéaire retrouvé intervient après le draw.
4. **MAXMIPLEVEL** : type D3D `9` absent de l'entrée à huit clés ; l'appliqueur générique qui sait l'écrire n'est pas relié au terrain.
5. **Draw/pixels** : aucun draw D3D9 historique ni raster GPU d'origine n'est observé.

Ces inconnues ne sont pas remplacées par les valeurs du reset global, d'une passe projected ou du renderer Bevy.

## 6. Corrections et conditions de reprise

Les clauses de correction existantes `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucune correction produit n'est appliquée dans ce lot d'audit.

Reprendre seulement avec au moins une nouvelle entrée :

1. exécution du loader/provider qui démontre que les objets stockés à `context+0x24/+0x28` proviennent des deux DDS précis ;
2. seulement si une qualification live absolue est requise, capture du processus historique au passage `0x95B035 → 0x95AD40` pour confirmer l'absence de mutation externe du flag code-owned `0` ;
3. nouveau caller/setter natif qui écrit les clés `4/5/6/7` des stages `4/8` avant le draw qualifiant ;
4. lien entre le descripteur `[edi+0x34]` de `0x9BF910` et la même soumission terrain, ou trace complète du device pour `MAXMIPLEVEL` type `9` ;
5. capture ordonnée d'un draw Map10 original correspondant au filtre matériau/shader/stages, avec état du device avant/après et, pour la fidélité visuelle, pixels GPU.

Répéter les recherches dans les contrats reset/projected/gamma/particules ou le test générique de traduction sampler ne constitue pas une piste nouvelle.

## 7. Livrables, cohérence et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_sampler_20261103/`.

- `perimetre.md`
- `inspect_static.py`
- `static_inspection.json`
- `probe_exact_terrain_path.py`
- `native_terrain_exact_path_execution.json`
- `probe_native_terrain_sampler_setter.py`
- `native_terrain_sampler_setter_execution.json`
- `inspect_backend_flag.py`
- `backend_flag_code_owned_state.json`

Décision : l'audit V1141 est terminé pour son fragment déclaré, car sources, consommateur, comportement, contrôles, adaptateurs, écarts et conditions de reprise sont explicites. La fonctionnalité historique n'est pas déclarée terminée. Le parent `SYS-01.2-02`, les corrections terrain et l'acceptation humaine restent ouverts.

Aucun asset, source de production, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié par ce lot.
