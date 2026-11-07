# Relecture indépendante V1152 — continuité géométrique Map10

Date : 2026-11-03  
Lot relu : `E:\mapslol3v3\audit_map10_v1152_geometry_continuity_20261103`  
Verdict : **preuves cohérentes et périmètre borné confirmé**.

## Résultat indépendant

La relecture accepte la conclusion limitée suivante : pour le mesh 1093 du `room.nvr` exact, les identités sources selector 2 / stride 44, VB1 et IB1 atteignent les trois adaptateurs de bind du chemin original `0x95AFC0`, puis l’exécution s’arrête à `0x95B112` avant `backend+0x20`.

Elle ne transforme pas les trois wrappers d’enregistrement en objets COM historiques. Les factories originales `0x9596D0` et `0x958420` ne sont pas exécutées dans ce lot. Aucun draw, `Present`, readback de frame/backbuffer ou pixel rendu n’est observé.

La matrice indépendante passe **26/26 contrôles globaux**, **19/19 contrôles pour chacun des deux runs**, puis son validateur passe **8/8 contrôles**.

## Contrôles de source

- PE 4.20 exact : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- `room.nvr` exact : SHA-256 `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082`.
- En-tête relu indépendamment : magic `0x0052564E`, version `0x10009`, comptes `87/107/107/2351/1365`.
- Les **6 602** entrées adresse→octets de chacun des reçus native-bytes sont identiques entre les deux runs et concordent toutes avec le PE d’origine ; zéro mismatch.
- Les instructions originales confirment : selector à `batch+0x1C`, déclaration via `context+0x04+selector×4`, VB via `batch+0x04` et table `+0x28`, IB via `batch+0x08` et table `+0x34`, puis les arguments `+0x0C/+0x10/+0x14/+0x18` avant le call `0x95B112`.

## NVR et triangle 1093

Le parseur indépendant retrouve :

- record 1093 à l’offset `59 952 568`, SHA-256 `3b084a5387c0381d2c8cf063cc8ae0ffb060dbc8dbd15642b99c37dba6f1cfea` ;
- champs `[material=1, VB=1, startVertex=213, vertexCount=3, IB=1, startIndex=252, indexCount=3]` ;
- VB1 : offset `430 312`, `60 324` octets, SHA-256 `92a9cdf6b29773f49c1eca1a6e462fe61df920054998a61377407fa4b4ee8ac6` ;
- IB1 : offset `48 707 442`, `3 456` octets, format `0x65` / 16 bits, SHA-256 `828c3d271f98cecbc4cc32d6245b111731356607daf9bc8c469a6afe7e73e607` ;
- indices sélectionnés `[213, 214, 215]`.

La qualification « non dégénéré » a été contrôlée au lieu d’être déduite des seuls indices. Les positions float3 relues sont :

```text
213 = (12134.635742, -116.338608, 5232.297363)
214 = (12188.582031, -117.496506, 5492.465820)
215 = (12288.470703, -117.496506, 5321.022949)
```

Le carré de la norme du produit vectoriel vaut `1 241 669 941,30749`, soit une aire de triangle approximative `17 618,66866`, strictement non nulle. Le rapport source n’enregistrait pas ces valeurs ; la matrice de cette relecture fournit désormais la preuve explicite qui manquait à l’adjectif.

## Selector 2

Les writes pile originaux `0x9597D1..0x95982E` ont été décodés directement depuis le PE et reconstruisent 48/48 octets du descripteur abstrait :

```text
000000000200000000000c0002000300000018000100040000002000010004010000280004000600ff00000008000000
```

SHA-256 : `a0dae45b432dee6fdc2f4656f13d3f72b692ee4cfbcdc1e9d846389efada3784`.

Les tables natives type/usage et le terminateur D3D9 reconstruisent indépendamment :

```text
000000000200000000000c0002000300000018000100050000002000010005010000280004000a00ff00000011000000
```

SHA-256 : `375b5c8b08666d26c3021e6aad676f5a674e67590bfa363faef2ebc72e543f38`.

La table de stride du PE vaut `[36, 12, 44, 52, 40, 12, 20]`. Le refus selector 0 / stride 36 contre VB1 / stride 44 est donc un refus de preflight du harness correctement qualifié, pas une décision Riot native.

## Runs et borne d’exécution

Le probe final a SHA-256 `165dc538391421a925c72fd32eefcf13a92872ca254bc95ea3a8b93f12e90b6a`. Les deux runs finaux sont postérieurs à sa dernière modification ; la validation est postérieure aux deux runs. Cette chronologie corrige bien l’ancien reçu devenu obsolète pendant la mise au point.

Pour chaque run :

- trois factories portent explicitement `recording_geometry_factory_adapter`, `source_backed=true`, `historical_factory_executed=false`, `historical_COM_wrapper=false` ;
- les mêmes handles atteignent les adaptateurs déclaration, stream source et index ;
- les indices vectoriels VB/IB restent `1` ;
- la trace exacte est `0x95AFC0 → 0x95B035 → 0x95AD40 → 0x95B046 → 0x95A730 → 0x95B063 → 0x95B0A4 → 0x95B0D2 → 0x95B112` ;
- les arguments internes observés à la borne sont `[0, 0, 213, 3, 252, 1]` ;
- `next_instruction_not_executed=true`, `actual_DrawIndexedPrimitive_called=false`, aucun HRESULT de draw.

Le validateur du lot source a également été réexécuté : succès, projection canonique `2410fa49350367ae24f8602ec5091dea92583ab99393cc6fcad3826e0f4629d9`.

## Limites conservées

- wrappers/factories : adaptateurs d’enregistrement uniquement, pas objets GPU historiques ;
- producteurs natifs complets : non exécutés ;
- matériau et textures détail hérités : fixtures hors qualification géométrique ;
- draw, shader pair effectif, `Present`, frame et pixels : non exécutés ;
- l’absence de mutations hors E est cohérente avec les chemins d’écriture des scripts inspectés, mais ce lot n’est pas une journalisation forensique globale du système.

## Livrables rehashables

| Fichier | Octets | SHA-256 |
|---|---:|---|
| `review_geometry_continuity.py` | 20 361 | `97d82ad4ca6c8f9ad8700f43364a74f0f2cab37136e25f805169306f4493e4c5` |
| `validate_geometry_independent_review.py` | 2 648 | `bb62fca680c4a95a82b20498710ea9c22e697477e35b1a2923c2d2dfd8491e09` |
| `geometry_independent_review_matrix.json` | 14 595 | `95b7929370470ce6b74c8c09c08c326c2b4bc6b834aa8c131bc75891efa6be92` |
| `geometry_independent_review_validation.json` | 943 | `f33cc9a4b67cbbb5d68265ca395237dceed5f2a0d449629c49207abb159f7b6e` |

Le rapport est exclu de sa propre table d’empreintes afin d’éviter une référence circulaire.
