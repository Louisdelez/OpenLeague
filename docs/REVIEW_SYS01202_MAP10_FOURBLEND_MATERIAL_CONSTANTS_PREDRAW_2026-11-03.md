# Revue indépendante V1160 — constantes et matériau FOUR_BLEND

Date : 2026-11-03  
Périmètre relu : `AUD-SYS-01.2-02-MAP10-FOURBLEND-MATERIAL-CONSTANTS-PREDRAW-01`  
Verdict de la revue : **PASS — 20/20, aucune anomalie**  
Verdict fonctionnel conservé : **BLOCKED_PRE_DRAW_UPLOAD**

## Conclusion

Le lot source est cohérent, reproductible et correctement borné. Les deux runs
retenus et un troisième run déclenché par cette revue produisent la même
projection déterministe :
`1727d54026b3d2f0b37060b080b065e65714760878109127cb35f540c0b08317`.

Cette réussite qualifie l'audit CPU/current-host des CTAB, bytecodes et entrées
manquantes. Elle ne qualifie pas l'upload historique, le draw Map10, les pixels,
le renderer, la carte ou le jeu. Les deux permutations V1161 restent des
**candidates compilées sur l'hôte courant**, pas des permutations historiques.

## Contrôles réellement exécutés

| Contrôle | Attendu | Observé |
|---|---|---|
| Manifeste source | 7 artefacts, tailles et SHA-256 exacts | 7/7 conformes |
| Syntaxe | trois scripts Python analysables sans exécution | AST 3/3 valide |
| Runs retenus | `final-1` et `final-2`, 19 checks chacun | 19/19 + 19/19 |
| Déterminisme | égalité hors ID/date et projection commune | égalité exacte ; hash commun confirmé |
| Entrées épinglées | toutes présentes et inchangées | 14/14 identités actuelles |
| Validateur d'origine | non mutant, 17/17 | exit 0, 17/17, arbre source inchangé |
| Rerun indépendant | compilation/réflexion D3DX reproductible | exit 0, 19/19, projection identique |
| CTAB exacte | CTAB embarquée = CTAB retournée | vrai pour VS et PS, trois runs |
| Nettoyage D3DX | buffers/refcounts à zéro | code=0, CTAB=0, aucun proxy vivant |
| Gate historique | refus avant mutation | deux gates `BLOCKED_BEFORE_MUTATION` |
| Frontières interdites | aucun Set/bind/draw/Present/readback | compteurs et listes d'appels à zéro |
| Sources protégées | aucune modification | lot source et cinq registres F: inchangés |

## Identités confirmées

Paire V1155 exacte :

- VS : code 992 octets,
  `c1a169e3aabfe63ac7d90413aee2c440acc1525f8c80cafef4bceb08f0c5be42` ;
  CTAB 464 octets,
  `74ac067514e52ea1c3b264110a52ffed8a3103743f69dd10567536d6892ddc40` ;
- PS : code 1 244 octets,
  `3d184c7984532a8177ce3588a66e7bc0b1fc931d46c3d3f79db3026cd1e5ca58` ;
  CTAB 500 octets,
  `791e0d1c2fd7d7804886e10f0862b95da399808aa4f60389b899f1e3a00d03f0`.

Registres exacts confirmés : VS
`c0..c3,c8..c10,c14,c15,c31,c230,c231,c250`, PS `c0,c12`, samplers
`s0,s1,s2,s3,s4,s5,s6,s7,s10`.

Candidates V1161 confirmées comme reproductibles, mais non historiques :

- height+colormap : VS code/CTAB `6cf864b8…7803` / `b1a37e03…5f89`,
  PS `ce68b270…4400` / `cf8f558f…7005` ;
- height+colormap+fog : VS `8e741a9c…bf52` / `8c520a04…85f6`,
  PS `4f62f923…a849` / `afe9e3ff…c2f`.

La revue confirme aussi que les quatre questions REA contiennent chacune des
cibles, une décision permise et une condition d'arrêt. La présence de `s9`
seule ne suffit pas à promouvoir `FOG_PIXELSHADER_BLEND`.

## Refus et limites conservés

- Le jeu de valeurs synthétique complet est refusé car sa provenance n'est pas
  `exact_original_map10_draw_state`.
- Le rerun emploie `d3dx9_39.dll` x64 de l'hôte courant, pas le processus Riot
  x86 de 2014.
- Aucun device D3D9 n'est créé ou muté par ce lot ; aucun shader n'est bindé ;
  aucun `Draw*`, `Present`, readback ou contrôle de pixel n'est exécuté.
- La revue confirme les hashes avant/après des cinq registres protégés ; elle
  n'est pas une instrumentation système globale de toutes les écritures.
- Les handles historiques, valeurs complètes au draw, render states fixes et
  filtres/LOD complets restent ouverts comme indiqué par le rapport source.

## Commande de revue

```powershell
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_review_20261103\independent_review_v1160_material_constants.py --output E:\mapslol3v3\audit_map10_v1160_material_constants_review_20261103\review_receipt.json
```

Cette commande a aussi exécuté, sans modifier le lot source :

```powershell
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\validate_material_constants.py
python -B E:\mapslol3v3\audit_map10_v1160_material_constants_20261103\audit_material_constants.py --run-id independent-review --output E:\mapslol3v3\audit_map10_v1160_material_constants_review_20261103\review_rerun.json
```

## Preuves

- `review_receipt.json` : 20/20, aucune anomalie ;
- `review_rerun.json` : 98 654 octets, SHA-256
  `465b98b6f0de3188cba824022a75ba9df4688cede5e9153569157b9dd6a03481` ;
- lot source avant/après : identique ;
- registres protégés avant/après : les cinq SHA-256 attendus sont inchangés.

