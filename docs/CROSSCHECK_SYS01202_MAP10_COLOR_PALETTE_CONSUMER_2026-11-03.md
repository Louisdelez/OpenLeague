# AUD-SYS-01.2-02-MAP10-COLOR-PALETTE-PROVIDER-ORDER-01 — raccord consommateur

Date : 2026-11-03  
Périmètre : lecture seule de la référence 4.20 sur `D:` et d’un ensemble fini de preuves, configurations et consommateurs actuels sur `F:`.  
Verdict : **AUDIT BORNÉ CLOS AVEC ÉCARTS EXPLICITES ; FONCTIONNALITÉ NON TERMINÉE**.

## Résultat utile

La chaîne historique est désormais raccordée documentairement jusqu’au constructeur de macros :

1. l’initialiseur choisit `ColorPalette` ou `ColorPaletteSpectator` selon `0x2D7905C` (`0x97CDA4`) ;
2. il lit l’entier (`0x97CDA9`), accepte seulement `0..2` (`0x97CDB1/0x97CDB4`) et écrit `0x2D79058` à `0x97CDB6`, sinon `0` à `0x97CDD1` ;
3. le setter écrit une valeur valide modifiée à `0x97CCF8`, avant acquisition du provider, persistance et listeners (`0x97CD01`, `0x97CD28`, `0x97CD4E`) ;
4. `0x959DA0` relit `0x2D79058` et sélectionne un unique macro avant l’ajout au vecteur : `0 → COLORPALETTE_DEFAULT`, `1 → COLORPALETTE_SPECTATOR`, `2 → COLORPALETTE_COLORBLIND`. Une valeur autre que `1/2` suit la branche `DEFAULT` ; le lot contrôlé contient donc aussi le cas diagnostic `3 → DEFAULT`, sans en faire une entrée valide de l’initialiseur.

Le raccord actuel OpenLeague n’est pas présent dans les consommateurs nommés inspectés :

- le chargeur `native_user_settings.rs` fusionne `Game.cfg`, mais ne matérialise actuellement que `Performance/EnvironmentQuality` dans `IntegerOptions` ;
- `main.rs` applique cette seule option à la qualité d’environnement ;
- `terrain_height_blend.wgsl` traite le FoW/overlay, mais ne contient aucun binding nommé `ColorPalette`, `ColorPaletteSpectator`, `COLORPALETTE` ou `color_palette` ;
- `fontconfig_en_US.txt` conserve l’étiquette UI `flash_optionsMenu_event_ColorPalette = "Colorblind Mode"`, sans preuve d’un callback, d’un état Rust ou d’un raccord shader.

Cela clôt le contrôle documentaire demandé, pas la fonctionnalité : aucune valeur de palette effective n’est matérialisée par un raccord Rust/WGSL nommé dans ce périmètre fini.

## Sources réutilisées et épinglées

- preuve productrice existante : `AUD-17.5-01-OPTIONS-COLOR-PALETTE-01`, rapport SHA-256 `3fa3ee799741f7a078f6f1a4abb4d5e63b7c211d39d200c4c3d6e52e910a92a4` ;
- reçu existant `color-palette-proof.json`, SHA-256 `8dd3680238278f25f9f73254ad349d51205233a53f287328a448174bc7ce3761`, `181/181` contrôles réussis ;
- `League of Legends.exe` 4.20, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- `native_shader_macro_merge_contract.json`, SHA-256 `e8c78ce146db68b492db92f3be8c7071f0128674d1be09f682f48933fbeecd9e`, `1584` cas, contrat réussi mais explicitement incomplet ;
- `Game.cfg` original et deux copies de référence OpenLeague : mêmes `14789` octets, SHA-256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`.

Les chemins, tailles et empreintes de tous les inputs réellement lus sont dans `crosscheck_run1.json`.

## Defaults, provider et runtime effectif

| Élément | Observé | Ce que cela prouve | Ce que cela ne prouve pas |
|---|---|---|---|
| PE `0x2D79058` | zéro initial, section à remplissage zéro | état initial de l’image | valeur au moment d’une frame |
| PE `0x2D7905C` | zéro initial, section à remplissage zéro | état initial de l’image | contexte Default/Spectator effectif et sa durée de vie |
| `[ColorPalette] ColorPalette` | `0` dans le default | baseline normale archivée | fichier/provider effectivement sélectionné |
| `[ColorPalette] ColorPaletteSpectator` | `1` dans le default | baseline spectateur archivée | session spectateur active |
| utilisateur OpenLeague | `F:\OpenLeague\Config\Game.cfg` et `F:\OpenLeague\DATA\CFG\Game.cfg` absents au contrôle | aucun override à ces deux emplacements | absence de tout autre provider/overlay ou état déjà publié |
| OpenLeague actuel | aucun raccord nommé dans les cinq consommateurs ciblés | écart concret et clôturable | absence mondiale d’une implémentation sémantiquement équivalente non nommée |

La valeur runtime historique reste **UNKNOWN**. La valeur runtime actuelle reste **UNKNOWN / NON MATÉRIALISÉE DANS LE RACCORD NOMMÉ INSPECTÉ**. Les defaults PE/configuration ne doivent pas être présentés comme valeur effective.

## Vérifications

- contrôle indépendant des octets aux onze points `0x97CCF8`, `0x97CD01`, `0x97CD28`, `0x97CD4E`, `0x97CDA4`, `0x97CDA9`, `0x97CDB1`, `0x97CDB4`, `0x97CDB6`, `0x97CDD1`, `0x959DA0` : réussi ;
- contrôle des deux globals PE et de leur zéro initial : réussi ;
- égalité exacte des trois defaults et valeurs `0/1` : réussie ;
- matrice du contrat macros : `396` cas par valeur `0..3`, toutes les soumissions vertex/pixel annoncées, mapping attendu : réussi ;
- contrôle lexical fini des cinq consommateurs actuels : aucun binding code/shader nommé ; l’unique occurrence ciblée est l’étiquette de localisation UI ;
- deux exécutions du validateur : `12/12`, digests identiques `63ffc27fad00f4705e79a83b9218765af80970e7d5bd400477dc4fe0aacec8e1`.

## Limites et inconnues conservées

- valeur, origine et durée effectives de `0x2D7905C` ;
- provider/overlay réellement sélectionné, priorité et persistance effective ;
- valeur de `0x2D79058` immédiatement avant `0x959DA0` ;
- vecteur de macros d’une frame réellement construite et effet pixel final ;
- callback UI actuel, état Rust palette, listener actuel et liaison au matériau/shader ;
- absence de capture jeu/D3D9 et de validation visuelle.

Aucun jeu, D3D9, REA, outil externe ou installation n’a été lancé. Aucun fichier de `F:` ou `D:`, goal, plan, suivi, base, registre ou code produit n’a été modifié.

## Condition de reprise précise

Reprendre seulement avec au moins un chaînon nouveau et qualifié :

1. un bridge actuel qui lit `[ColorPalette] ColorPalette` / `ColorPaletteSpectator` et publie un enum/état de palette ;
2. un bridge renderer/matériau qui transforme cet état en comportement default/spectator/colorblind avant la sélection des shaders d’environnement ;
3. pour lever l’inconnue historique runtime, une trace contrôlée épinglant `0x2D7905C`, le provider/overlay choisi, `0x2D79058` juste avant `0x959DA0` et le vecteur de macros obtenu.

Ne pas relancer une recherche générale de littéraux/adresses sans nouveau caller, receiver, provider ou trace runtime.

