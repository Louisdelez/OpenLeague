# Revue indépendante — V1162 entrées runtime des macros Map10

Date : 2026-11-03  
Lot source : `E:\mapslol3v3\audit_map10_v1162_macro_runtime_inputs_20261103`  
Répertoire de revue : `E:\mapslol3v3\audit_map10_v1162_macro_runtime_inputs_review_20261103`

## Verdict

**PASS — paquet de preuve cohérent et audit de classification clos dans son périmètre borné.**

Contrôles indépendants : **803/803**.  
Validateur source relancé sans sortie : **31/31**, code retour `0`.  
Le lot source est inchangé avant/après la relance du validateur.

Ce verdict qualifie l'intégrité et les conclusions bornées du lot, pas une fonctionnalité runtime : aucun client/jeu, aucune frame D3D/GPU, aucun réseau, aucune session REA et aucune écriture sur F: n'ont été effectués pendant cette revue.

## 1. Intégrité des six artefacts autoritatifs

Les six tailles et SHA-256 ont été comparés à des valeurs attendues indépendantes, puis au manifeste. Résultat : **6/6 conformes**.

| Artefact | Octets | SHA-256 |
|---|---:|---|
| `probe_macro_runtime_inputs.py` | 26273 | `8c145edd5b1fa2d7f5c9dcfa03738499e4b7dc2b93a1e8d72b702296ab456ca3` |
| `macro_runtime_inputs_run1.json` | 114806 | `d4370dab6d0f2b54f4f48b1575e87d097f1ccbf31ea7e9e830b2aa7f3168eac6` |
| `macro_runtime_inputs_run2.json` | 114806 | `3fa98f81bc91bfdde42e5bc356945c9dfa319ab23db34d4d7e283e1d6507162c` |
| `validate_macro_runtime_inputs.py` | 6371 | `528936f104d171d9b4193f927e2c98653df8e47170a2db2eadc0b67f06c98cc8` |
| `macro_runtime_inputs_validation.json` | 7725 | `0f40fa6287130aafe822e3d66070bb583f65a059c3d1e9231cb4cd47803d137a` |
| `AUDIT_V1162_MAP10_MACRO_RUNTIME_INPUTS.md` | 8780 | `fe09388b5b25553d245403c34a95207be4e00d6b7e2c64c71313c846bb521473` |

Les fichiers `exploratory.json`, `exploratory2.json` et `exploratory3.json` existent, mais le manifeste les place explicitement dans `development_only_not_authoritative` et ils sont absents de la liste des six artefacts autoritatifs. Leurs `run_id` et verdicts d'inventaire ont aussi été contrôlés.

Limite documentaire : le caractère non autoritatif est porté par le manifeste, pas par un champ autoportant dans chacun des trois JSON exploratoires ; détachés du manifeste, ils sont donc ambigus.

## 2. Deux runs et digest stable

Les runs `run1` et `run2` ont la même preuve stable et le digest canonique recalculé `2edd222c5873a4b18cb0ff3c67c2ec77e4c788101a059855a7067498d2bc60d4`. Leurs fichiers complets ont des SHA-256 différents, comme attendu, car leur `run_id` diffère.

Le validateur livré a été analysé syntaxiquement, puis exécuté **sans `--output`**. Sa sortie JSON est identique au reçu stocké, ses 31 contrôles passent, et les empreintes de tous les fichiers du lot source sont identiques avant et après : relance non mutante démontrée.

Observation de métadonnée non bloquante : dans `macro_runtime_inputs_validation.json`, le bloc nommé `validator` épingle `probe_macro_runtime_inputs.py` (le producteur), pas `validate_macro_runtime_inputs.py`. Le manifeste épingle néanmoins correctement le vrai validateur, et la présente revue l'a exécuté directement.

## 3. Neuf classifications et preuve PE/config

Le PE original a été relu par un mappeur PE32 indépendant, sans importer le producteur V1162. L'identité du binaire, les 9 valeurs initiales, les occurrences littérales `.text`, tous les octets des références directes, les 14 sites d'écriture/lecture-écriture attendus et les 12 fenêtres de producteur ont été comparés aux reçus.

| Rôle | Catégorie | Valeur Map10 épinglée | Stores directs |
|---|---|---:|---|
| `shadow_setting` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x837434` |
| `environment_quality` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x83771f`, `0x960a55` |
| `animate_fow_override` | `STATIC_CODE_OWNED` | 0 | aucun |
| `animate_fow_feature_object` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x531d8e` |
| `cloud_feature_object` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x531dfe` |
| `global_options` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x95912c`, `0x960a67` |
| `color_palette_selector` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x97ccf8`, `0x97cdb6`, `0x97cdd1` |
| `fog_feature_byte` | `MAP10_CONFIG_DETERMINABLE` | true | `0x986fe5`, `0x987374`, `0x987391` |
| `fog_mode` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue | `0x987616` |

Résultat : **1 `STATIC_CODE_OWNED`, 1 `MAP10_CONFIG_DETERMINABLE`, 7 `RUNTIME_OR_FRAME_NOT_PINNED`**.

- `animate_fow_override` reste épinglé à `0` dans le périmètre statique direct : trois lectures littérales, aucun store direct. Les écritures externes ou indirectes calculées ne sont pas exclues.
- `fog_feature_byte` est déterminable à `true` par le contrat Map10 déclaré : source `terrain.inibin` épinglée, `Fog/Enable=1`, initialiseur/consommateur/setter documentés. Ce n'est pas une capture d'un processus historique vivant.
- Les sept autres valeurs restent `null` dans les reçus et possèdent chacune une condition de reprise.

## 4. Defaults PE/Game.cfg versus runtime effectif

Le `Game.cfg` original a été relu directement : `EnvironmentQuality=3`, `ShadowsEnabled=1`, `ShadowQuality=1`, `ColorPalette=0`, `ColorPaletteSpectator=1`. Ces baselines et les initiales PE ne sont jamais converties en état runtime effectif pour les sept inconnues. Les catégories, valeurs `null`, limites et conditions de reprise conservent explicitement cette séparation.

## 5. Refus du vecteur incomplet

Les deux runs, le validateur et le manifeste convergent vers `NOT_BUILT_REQUIRED_INPUTS_UNKNOWN`. Le vecteur historique complet n'a pas été construit et aucune complétude renderer/carte/jeu n'est revendiquée.

## 6. Limites et reprises

- Les dix sources amont situées sur F: ont seulement été reconnues par leurs pins déjà inscrits dans les deux runs ; elles n'ont volontairement pas été relues, conformément à la frontière « aucun F ». La revue requalifie les preuves locales E:/D:, pas l'historique de création de ces contrats.
- Les sept entrées inconnues exigent encore les providers/overlays, l'ordre d'initialisation ou les objets runtime listés dans leurs `resume_condition`.
- Aucune observation en processus ne permet de certifier les états effectifs au moment des builders `0x9593C0` et `0x987830`.
- Les compteurs `no game/no REA/no F` du lot sont des limites déclarées et cohérentes ; la présente revue a elle-même respecté ces limites.
- Le remapping death-screen reste explicitement hors périmètre de V1162.

## 7. Livrables de revue

- `review_receipt.json` — contrôles détaillés et sortie du validateur relancé ;
- `REVIEW_V1162_MAP10_MACRO_RUNTIME_INPUTS.md` — présent rapport ;
- `commands.txt` — commandes et frontières d'exécution ;
- `review_manifest.json` — empreintes des livrables de revue ;
- `review_v1162_macro_runtime_inputs.py` — validateur indépendant local.
