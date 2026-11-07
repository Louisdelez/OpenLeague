# V1160 — constantes et matériau FOUR_BLEND avant draw

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-FOURBLEND-MATERIAL-CONSTANTS-PREDRAW-01`  
Verdict de l’audit borné : **PASS**  
Verdict de l’upload historique : **BLOCKED avant toute mutation**

## Résultat

Les CTAB intégrées aux deux bytecodes FOUR_BLEND exacts de V1155/V1156 ont été
extraites, comparées octet pour octet aux `ID3DXConstantTable` retournées, puis
réfléchies et confrontées à un désassemblage D3DX. Les deux runs indépendants
retrouvent les mêmes identités et la même projection
`1727d54026b3d2f0b37060b080b065e65714760878109127cb35f540c0b08317`.

Un adapter d’upload D3D historique n’est pas exécutable honnêtement : les
valeurs complètes du draw, plusieurs handles texture et les render states fixes
ne sont pas composés. Le gate refuse donc avant mutation. Il n’appelle aucun
`IDirect3DDevice9::Set*`, bind, draw, `Present` ou readback ; l’état sentinelle
reste byte-identique. Un jeu synthétique pourtant complet est également refusé
car sa provenance n’est pas `exact_original_map10_draw_state`.

## Identités exactes réutilisées

| Stage | Profil | Bytecode | CTAB |
|---|---|---|---|
| vertex | `vs_2_0` | 992 octets, `c1a169e3aabfe63ac7d90413aee2c440acc1525f8c80cafef4bceb08f0c5be42` | 464 octets, `74ac067514e52ea1c3b264110a52ffed8a3103743f69dd10567536d6892ddc40` |
| pixel | `ps_2_0` | 1 244 octets, `3d184c7984532a8177ce3588a66e7bc0b1fc931d46c3d3f79db3026cd1e5ca58` | 500 octets, `791e0d1c2fd7d7804886e10f0862b95da399808aa4f60389b899f1e3a00d03f0` |

La CTAB embarquée dans le commentaire `CTAB` de chaque bytecode est exactement
égale au buffer CTAB séparé. Tous les objets D3DX CPU sont libérés à refcount
zéro. Il s’agit du `d3dx9_39.dll` x64 courant, pas du processus Riot x86 2014.

## Registres réellement consommés par la paire exacte V1155

### Vertex shader

| Symbole CTAB | Registres | Source ou état de preuve |
|---|---:|---|
| `WORLD_VIEW_PROJECTION_MATRIX` | `c0..c3` | producteur caméra/world/view/projection exact au draw non identifié |
| `SHADOW_PROJECTION_MATRIX` | `c8..c10` | seules les trois colonnes produisant `.xyz` survivent ; valeur Map10 au draw absente |
| `DIRECTIONAL_LIGHT_COLOR` | `c14` | source environnementale non composée |
| `DIRECTIONAL_LIGHT_VECTOR` | `c15` | source environnementale non composée |
| `c_smFade` | `c31` | source shadow-fade non composée |
| `FOG_OF_WAR_PARAMS` | `c230` | `0x6B3849..0x6B3894`; pour l’étendue Map10 15398.671875 : mots `[948449473,3095933121,0,1065353216]`, mais pas transportés dans ce même draw |
| `vCloudsParam` | `c231` | `0x73A850`; producteur connu, valeur dynamique exacte du frame absente |
| `FOG_OF_WAR_ALWAYS_BELOW_Y` | `c250` | `0x6B399F..0x6B3A3E`; valeur originale `[0,-1000,0.01,10]`, non composée au draw |

`WORLD_MATRIX c4`, `TERRAIN_XFORM c233` et `FOW_HEIGHT_FADE c251` sont absents de
la CTAB exacte. Le désassemblage contient aussi des `def c4` littéraux ; ils ne
sont pas des uploads applicatifs et ne sont pas ajoutés à la liste CTAB.

### Pixel shader

| Symbole CTAB | Registre | Source ou état de preuve |
|---|---:|---|
| `AMBIENT_COLOR` | `c0` | valeur environnementale Map10 au draw absente |
| `FOW_EDGE_CONTROL` | `c12` | `0x6B34F0..0x6B361F`; défaut Map10 mots `[1065353216,0,0,0]`, non composé au même draw |

`HEIGHTBLEND_LAYER_SCALE c23`, `HEIGHTBLEND_DATA c25`, `BRUSH_DATA c26` et les
constantes de fog pixel sont absentes de ce bytecode exact.

## Samplers et handles

La CTAB et le désassemblage exacts consomment
`s0,s1,s2,s3,s4,s5,s6,s7,s10`.

| Stage | Rôle | Qualification actuelle |
|---:|---|---|
| `s0..s3` | quatre couches détail | route originale jusqu’à `SetTexture`, mais objets opaques V1141 synthétiques : **fixtures seulement** |
| `s4` | masque de blend FOUR_BLEND | `terrainHeightScale.dds → 0x959B10..0x959BBC → context+0x24 → 0x95A8B6`; route qualifiée, **pas de handle historique réel** |
| `s5` | shadow map | **absent** : aucun owner/handle de shadow target Map10 composé |
| `s6` | visibilité FoW runtime | **absent** : aucun producteur/handle runtime composé |
| `s7` | clouds | **absent comme handle** ; `0x73A850` qualifie séparément un bind contrôlé/fallback |
| `s8` | colormap | route `compositeColorMap.dds → context+0x28` qualifiée, mais **non consommée par ce bytecode** |
| `s9` | fog lighting | route `fogLightingMap.dds → context+0x2C` qualifiée, mais **non consommée par ce bytecode** |
| `s10` | overlay FoW auteur | **absent** : aucun owner/handle Map10 composé |

États connus : `s0..s3 U/V=WRAP`, `s4 U/V=CLAMP` dans la branche code-owned
false ; `s8/s9 U/V=CLAMP`. Une séquence reset+cloud contrôlée donne à `s7`
`U/V=WRAP` et filtres MAG/MIN/MIP linéaires. Restent inconnus au draw : les
filtres/LOD complets de tous les samplers consommés, l’ordre effectif des
overrides et tous les états de `s5/s6/s10`.

## Render states fixes

Le bytecode D3D9 n’encode pas les render states. Le setter matériau original
`0x95AD40` appelle `0x9838D0` avec le descripteur opaque `0x40C`, mais V1141
avait adapté cette frontière. Les couples D3DRS/valeur de `0x40C` et un
snapshot complet au draw ne sont pas qualifiés. Aucun état fixe n’a donc été
inventé ni soumis.

## Écart de permutation découvert

Les producteurs V1158 `0x98C070` et `0x98D960` ont reçu une fixture locale de
trois macros seulement :

1. `COLORPALETTE_DEFAULT=1` ;
2. `DISABLE_EMISSIVE=1` ;
3. `FOUR_BLEND=1`.

Or le chemin Map10 séparément audité active `USE_HEIGHT_BLEND` et
`MOD2X_COLORMAP`. Cela explique exactement pourquoi la paire V1155 n’utilise ni
`c23/c25/c233` ni `s8/s9`. V1158 qualifie ses corps producteurs avec la fixture
fournie, mais ne prouve pas que cette fixture est le vector macro final du draw
Map10.

Deux permutations ont été compilées uniquement comme handoff V1161 ; elles ne
sont **pas** promues historiques :

| Candidate locale ordonnée (+23 globales) | VS requis | PS requis | Samplers PS |
|---|---|---|---|
| trois macros V1155 + `USE_HEIGHT_BLEND=1`, `MOD2X_COLORMAP=1` | `c0..3,c8..10,c31,c230,c231,c233,c250` | `c12,c23,c25` | `s0,1,2,3,4,5,6,8,10` |
| précédente + `FOG_PIXELSHADER_BLEND=1` | précédent + `c236..c237` | `c12,c23,c25` | précédent + `s9` |

Identités candidates reproductibles :

- height+colormap VS : code 816 octets `6cf864b8…7803`, CTAB 396 `b1a37e03…5f89` ;
- height+colormap PS : code 1 488 octets `ce68b270…4400`, CTAB 528 `cf8f558f…7005` ;
- +fog VS : code 1 116 octets `8e741a9c…bf52`, CTAB 444 `8c520a04…85f6` ;
- +fog PS : code 1 684 octets `4f62f923…a849`, CTAB 560 `afe9e3ff…c2f`.

## Handoff REA V1161 ciblé

REA ne doit être repris que sur ces questions discriminantes :

1. `0x9593C0`, `0x9696D0`, `0x77DE90` : relever le vector dynamique ordonné et
   confirmer les append issus de `0x2D78FA4`/`0x2D78FBC`. Arrêt dès que les
   noms/valeurs et leurs producteurs sont identifiés.
2. `0x98C070`, `0x98D960`, `record+0x08/+0x0C`, factories
   `0x9AEBF0/0x9AEA90` : relever le vector combiné réellement transmis. Une
   candidate n’est choisie que si ordre, compte et valeurs correspondent.
3. `0x95A730`, `0x95A480`, `0x95A640`, caller `0x95B112` : joindre le record de
   paire exact au matériau type 3/selector 0 et au draw. La présence du bind
   `s9` seule n’autorise pas `FOG_PIXELSHADER_BLEND`.
4. `0x9C3140` et seulement ses callers qui passent les registres
   `0,8,14,15,31,230,231,250` : retrouver source, mots bruts et ordre des
   constantes manquantes. Arrêt dès que chaque registre CTAB de la permutation
   choisie est sourcé, ou qu’un caller précis reste le seul inconnu.

Aucune recherche REA large, réimport ou installation n’a été lancé dans V1160.

## Exécutions et validation

Commandes finales :

```powershell
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\audit_material_constants.py --run-id final-1 --output E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\material_constants_run1.json
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\audit_material_constants.py --run-id final-2 --output E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\material_constants_run2.json
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\validate_material_constants.py
```

Résultats : deux exits `0`, mêmes registres/CTAB/projection ; validateur
non-mutant `17/17`, exit `0`.

## Limites conservées

- audit statique/CPU current-host terminé ; upload historique non terminé ;
- aucun `Set*`, bind, draw, `Present`, readback ou pixel ;
- pas de vrai handle historique pour `s0..s7/s10` ;
- valeurs WVP/shadow/directional/ambient/shadow-fade non composées au draw ;
- render states fixes et filtres/LOD complets absents ;
- aucune écriture sur `F:`, aucun produit, registre, Goal, Plan, UI ou base ;
- aucune conclusion de complétude Map10, renderer ou jeu.
