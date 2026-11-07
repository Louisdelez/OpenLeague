# SYS-01.2-02 — V1142 — loaders natifs des textures terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-LOADER-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé avec preuves pour la chaîne originale jusqu'aux feuilles readonly déclarées**  
Verdict fonctionnel : **provider historique, décodage natif et upload non terminés**  
Acceptation humaine : **non demandée**

## 1. Exigence et frontières

V1141 avait relié statiquement les noms DDS à `context+0x24/+0x28/+0x2c`, puis exécuté ces champs jusqu'aux frontières D3D avec des handles contrôlés. V1142 traite uniquement le maillon antérieur : exécuter les loaders, la factory, le constructeur et l'initialiseur originaux, avec des feuilles readonly qui lisent intégralement les trois fichiers physiques et vérifient leurs identités.

Le lot ne confond pas :

- instructions originales exécutées ;
- feuilles provider/resource adaptées ;
- sélection des vrais octets ;
- décodage DDS, création d'objet D3D et upload, non exécutés.

Sont exclus : lancement du jeu historique, priorité RADS effective, modification du client original, source produit, asset, registre, goal, Plan, application de suivi ou base de données.

## 2. Sources, identités et preuves antérieures

### Binaire et DDS

- Exécutable : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Fichier sous `LEVELS/Map10` | Taille | En-tête DDS | SHA-256 |
|---|---:|---|---|
| `terrainHeightScale.dds` | 16 777 344 | 2048×2048, RGBA32 non compressé, aucun mip déclaré | `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` |
| `compositeColorMap.dds` | 4 194 432 | 1024×1024, RGBA32 non compressé, aucun mip déclaré | `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` |
| `fogLightingMap.dds` | 4 194 432 | 1024×1024, RGBA32 non compressé, aucun mip déclaré | `ef57969ac3c4a5576563eb0789e429439e58a56ec86e4a37877281a5a995f7fa` |

Les trois en-têtes ont `dwMipMapCount=0`, `RGBBitCount=32` et les masques `R=00FF0000`, `G=0000FF00`, `B=000000FF`, `A=FF000000`. L'initialiseur original reçoit séparément un mip count logique `1`.

### Recherche de réutilisation bornée

Aucune preuve existante n'exécutait la composition terrain complète `0x959B10/0x959BC0/0x959C80 → 0x98A770 → 0x989B10` avec ces trois fichiers.

- `map10_texture_handle_fields.json` exécute `0x958850` sur 174 cas, mais remplace entièrement `0x98A7F0` par des handles synthétiques.
- V689 (`FIDELITY_NATIVE_PORTRAIT_GPU_ROUTE_V689.md`) exécute une chaîne DDS inférieure sur douze portraits et s'arrête avant la méthode virtuelle `+0x60` ; aucun provider ni champ terrain.
- `native_filesystem_text_flow_contract.json` emploie des flux mémoire adaptés ; il ne qualifie pas le montage RADS 4.20.
- `terrain_native_source_validation.json` qualifie chemins, SHA et conversions externes, pas le loader original.
- `native_font_texture_creation_contract.json` intercepte `0x98A770`; `native_texture_filename_contract.json` ne couvre que la normalisation `.tga → .dds`.

V1142 est donc une nouvelle qualification ciblée, pas la répétition d'un reçu antérieur.

## 3. Consommateur original exécuté

### Caller et gates

La route `room.nvr` passe par `0x575FC0 → 0x575C50`. Les seuls appels directs `rel32` retrouvés sont `0x575DB7 → 0x959B10`, `0x575DCE → 0x959BC0` et `0x575DEE → 0x959C80`, après succès de `0x958420`.

- height : byte `0x2D78FBC != 0` ;
- colormap : byte `0x2D78FA4 != 0` ;
- fog : byte `0x14BE79F != 0` et dword non signé `0x1225904 > 0`.

Signature effective commune : `thiscall(TerrainContext* this, uintptr_t unused_arg1, ResourceProvider* provider)`, retour `ret 8`. Le provider est `[ebp+0xC]`; le premier argument n'est pas lu.

### Route par texture

| Nom embarqué original | Entrée loader | Publication | Effet supplémentaire |
|---|---:|---:|---|
| `terrainHeightScale.dds` | `0x959B10` | `context+0x24` à `0x959B84` | — |
| `compositeColorMap.dds` | `0x959BC0` | `context+0x28` à `0x959C34` | même handle publié dans `0x14BEEAC` |
| `fogLightingMap.dds` | `0x959C80` | `context+0x2C` à `0x959CF4` | — |

Pour chaque cas, les instructions originales :

1. appellent le provider virtuel `+0x28` avec le nom DDS ;
2. exécutent la factory `0x98A770` ;
3. exécutent le constructeur `0x989150` ;
4. publient le handle distinct dans son champ ;
5. entrent dans `0x989B10`, qui appelle le provider `+0x1C`, conserve le nom exact à `handle+0x44`, sépare l'extension par `0x8B5700` et atteint la frontière ressource `0x98A030`.

Deux vtables originales compatibles ont été délimitées : provider local `0x10D6380` (`+0x14=0x90A440`, `+0x1C=0x90A480`, `+0x28=0x90A4A0`) et search provider `0x10D62C8` (`+0x14=0x904A30`, `+0x1C=0x904CD0`, `+0x28=0x904EC0`). Le provider local consulte sa table puis délègue au parent avec le même nom. Cette structure explique la résolution attendue `Levels/Map10/<nom>.dds`, sans qualifier le montage historique effectif.

Métadonnées originales observées sur les trois handles :

- `handle+0x68 = 2` ;
- `handle+0x6C = 1` mip logique ;
- `handle+0x70 = 0xFF000000` ;
- `handle+0x10 = 1` référence ;
- identités distinctes `0x7000`, `0x7001`, `0x7002`.

`0x98A770` alloue `0xA0` octets par `0x9933E0`, appelle `0x989150`, incrémente `texture+0x10` et insère l'objet dans la liste renderer `+0x230`. L'initialiseur `0x989B10` reçoit six arguments, écrit les champs ci-dessus et renvoie un booléen ignoré par les loaders. Le handle est publié avant cette initialisation ; un échec ultérieur ne remet pas statiquement le champ à zéro.

La feuille suivante est précisément connue : `0x98A030` conserve le provider, résout le chemin final dans `texture+0x2C`, puis appelle `0x98A460`. Cette dernière ouvre par provider `+0x14(path,"rb")`, obtient la taille par stream `+0x08`, repositionne par `+0x1C`, lit par `+0x24`, ferme par `+0x00`, puis transmet les octets à `0x989500 → 0x9BB3D0 → 0x9B65E0 → 0x9BB2D0 → 0x9BB220`. V689 qualifie déjà cette chaîne CPU jusqu'avant le backend virtuel `+0x60` à `0x9BB247`, sur un autre périmètre. Le fallback `NullMap_White.dds` ne concerne que les chemins contenant `ao-`, donc aucun des trois noms ici.

## 4. Contrôles exécutés, attendu et observé

### Exécution isolée

Commande :

```powershell
python -B E:\mapslol3v3\audit_map10_native_loader_20261103\probe_native_terrain_loaders.py
```

Résultat : succès, trois cas, `860` adresses d'instructions originales. Toutes les adresses obligatoires ont été observées : les trois entrées, leurs appels factory/stores/initialiseur, `0x98A770`, `0x989150`, `0x989B10` et `0x8B5700`.

| Cas | Lectures readonly | Champ/handle observé | Métadonnées |
|---|---:|---|---|
| height | provider `+0x28`, provider `+0x1C`, frontière `0x98A030` | `+0x24 → 0x40080020` | nom exact, type 2, mip 1, couleur noire, ref 1 |
| colormap | mêmes 3 lectures | `+0x28 → 0x40080140`, global identique | mêmes contrats |
| fog lighting | mêmes 3 lectures | `+0x2C → 0x40080260` | mêmes contrats |

Chaque lecture parcourt le fichier physique complet et vérifie taille et SHA-256. Total : neuf lectures intégrales avec identité attendue.

Script SHA-256 `17f3ffbf90be398b28425b61085c67649e660c8e5721c08eb6c261c8c3186c59`. Reçu `native_terrain_loader_execution.json`, SHA-256 `93bb6a09f0d1953a5ee262dcbfae3a52fc9eace1d7441921fb09bc12aef6d003`.

Relecture indépendante : succès ; verdict, 860 adresses, trois champs, neuf lectures/SHA, métadonnées et global colormap vérifiés.

Inspecteur statique auxiliaire : `inspect_loader_static_detail.py`, SHA-256 `c66443ecd56f2b2bccac63a70c26e131437509ed7ff10fe17d9dead15d47b421`, utilisé pour les callers, signatures, vtables et la frontière I/O. Il n'exécute pas le PE.

Deux assertions du développement du harness ont d'abord échoué puis ont été corrigées : le troisième argument réellement observé à `0x98A030` vaut `0`, pas un pointeur de couleur ; la branche DDS atteint directement cette frontière et n'appelle pas le finalize attendu. Le reçu final reflète le comportement observé, sans masquer ces écarts du modèle initial.

### Adaptateurs séparés des instructions originales

- Provider `+0x28/+0x1C` : feuilles host readonly limitées aux trois noms exacts ; elles lisent tous les octets et vérifient les SHA. Elles ne reproduisent pas l'ordre/priorité RADS.
- `0x98A030` : première feuille texture adaptée ; elle enregistre les arguments originaux, relit et rehache le DDS, puis renvoie le succès. Son corps n'est pas exécuté.
- Allocation/libération CRT, `strrchr` et `strcmp` : adaptateurs déterministes ; la construction de chaînes, le split, la factory, le constructeur, le contrôle loader et les stores restent originaux.
- Sous-système texture préalloué pour la dépendance `+0x94` du constructeur ; aucun bootstrap renderer/provider complet revendiqué.

## 5. Résolu et ouvert

### Résolu par V1142

1. Les trois noms `.dds` embarqués sont passés par les loaders originaux.
2. La factory, le constructeur, l'initialiseur et le split d'extension originaux s'exécutent.
3. Trois handles distincts sont publiés aux champs `+0x24/+0x28/+0x2C` ; le global colormap concorde.
4. Les feuilles readonly sélectionnent et lisent les trois vrais fichiers, avec taille et SHA exacts.
5. Les métadonnées natives type/mip/couleur/référence sont observées.

### Toujours ouvert

1. **Provider historique** : le montage, la priorité et la copie effectivement sélectionnée par RADS dans le processus 4.20 ne sont pas exécutés.
2. **Corps `0x98A030 → 0x98A460`** : la première feuille texture est adaptée ; l'ouverture/stream originaux ne sont pas exécutés avec un provider concret.
3. **Décodage et texture native** : la chaîne CPU inférieure est héritée de V689, pas rejouée pour ces trois DDS ; aucun backend virtuel `+0x60`, objet `handle+0x8C/+0x90` ou upload D3D.
4. **Rendu** : aucun draw, raster GPU, pixel ou acceptation visuelle historique.

La sélection exacte des octets est prouvée aux frontières readonly déclarées ; elle n'est pas présentée comme un décodage ou un upload natif.

## 6. Corrections et conditions de reprise

Les clauses `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucune correction produit n'est appliquée par ce lot d'audit.

Reprendre seulement avec une nouvelle entrée :

1. objets de retour du provider historique ou reproduction vérifiée de son montage/priorité ;
2. exécution `0x98A030 → 0x98A460` avec slots provider `+0x14/+0x1C/+0x28` et stream `+0x08/+0x1C/+0x24/+0x00`, enregistrant chemin, taille et SHA lus ;
3. état de catégorie `texture+0x94`, puis implémentation concrète du backend virtuel `+0x60` à `0x9BB247` ;
4. preuve du décodeur jusqu'aux objets `+0x8C/+0x90`, puis soumission/upload D3D ;
5. capture du draw/pixels si la fidélité visuelle historique est ensuite évaluée.

Répéter un callback « exists », les conversions externes ou V689 sans dépasser sa frontière ne constitue pas une piste nouvelle.

## 7. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_loader_20261103/`.

- `perimetre.md`
- `inspect_loader_static_detail.py`
- `probe_native_terrain_loaders.py`
- `native_terrain_loader_execution.json`

Décision : V1142 est terminé pour sa chaîne déclarée jusqu'aux feuilles readonly. La fonctionnalité historique reste incomplète aux limites provider/décodage/upload/rendu. Le parent `SYS-01.2-02`, les corrections terrain et l'acceptation humaine restent ouverts.

Aucun fichier du client original, source produit, asset, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié.
