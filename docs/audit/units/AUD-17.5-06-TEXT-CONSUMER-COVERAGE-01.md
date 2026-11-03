# SYS-17.5-06 — couverture des consommateurs de texte

Unité AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01 ; UTC 2026-11-01T13:48:03.496922+00:00

Audit de cet inventaire terminé sous réserve de la relecture distincte. Parent SYS-17.5-06 ouvert ; aucun renderer ou focus physique accepté. Goal SYS-01.2-02 actif et inchangé.

## 1. Contrat et frontière
Vérifier lisibilité, focus clavier et absence de débordement des textes
Inventaire du client courant, puis couverture des trois clauses par famille ; ni graphe compilé ni nombre d’instances HUD. Corpus figé1168et prérequis conservés.

## 2. Sources et preuves réutilisées
Sources4.20/locales, phases et corrections des audits mort/résultats/pause/boutique/recherche/refus/chat/options conservées. Le lot numérique des18sources et le probeGPU borné sont réutilisés. Aucun ancien test ou lecteur relancé ; aucun code0 autonome absent n’est fabriqué. Les anciennes captures restent des preuves datées aux limites de leurs audits, pas des frames fraîches.
- death : `F:\OpenLeague-work\audit-units\AUD-17.3-04-DEATH-SCREEN-01\death-screen-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.3-04-DEATH-SCREEN-01\delivery-readback.json`.
- results : `F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\match-results-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\delivery-readback.json`.
- pause : `F:\OpenLeague-work\audit-units\AUD-17.5-01-SESSION-CONTROL-STATES-01\session-control-states-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-SESSION-CONTROL-STATES-01\delivery-readback.json`.
- shop : `F:\OpenLeague-work\audit-units\AUD-17.5-01-SHOP-STATES-01\shop-states-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-SHOP-STATES-01\delivery-readback.json`.
- layout : `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\shop-search-layout-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\delivery-readback.json`.
- keyboard : `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\shop-search-keyboard-proof-v2.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\delivery-readback.json`.
- diagnostic : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REJECTION-PRIVACY-01\rejection-privacy-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-05-REJECTION-PRIVACY-01\delivery-readback.json`.
- absence : `F:\OpenLeague-work\audit-units\AUD-17.5-01-CHAT-SCORE-ABSENCE-01\chat-score-absence-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-CHAT-SCORE-ABSENCE-01\delivery-readback.json`.
- options : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MENU-PRESENTATION-01\menu-presentation-proof.json` ; lecteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MENU-PRESENTATION-01\delivery-readback.json`.

## 3. Inventaire qualifié
191lignes dans44fichiers :39test,25matériaux image,61lignes dans des renderers ordinaires (support inclus),12observateurs,9valeurs de configuration,32supports de texte,4adaptateurs de records,9probes. Les61lignes ordinaires comprennent47supports,9sites Bevy Text,3sites glyphes et2sites d’images compagnons.
Neuf familles ordinaires et douze sites source de création ; ce ne sont ni12widgets ni un pourcentage de jeu terminé. Une fabrique dessert plusieurs rôles et instances. Les tests ont des gates cfg(test) vérifiées ; les fichiers de tests externes ont leur gate dans le parent. Le scanner de métadonnées est borné et contrôlé sur guillemets/commentaires/chars, pas un compilateur Rust.
Le contrôle complémentaire des aliases/builders nommés n’a aucun résultat : rgcode1, stderr vide. Cela ne prouve pas absence de tous macros, plugins ou textes pré-dessinés.
- `death_recap_panel.rs:89` — Bevy_Text_spawn ; DEATH-RECAP-TEXT.
- `main.rs:936` — Bevy_Text_spawn ; SESSION-DIAGNOSTIC.
- `match_results_ui.rs:16` — Bevy_Text_spawn ; TERMINAL-RESULT-TEXT.
- `match_results_ui.rs:20` — Bevy_Text_spawn ; TERMINAL-RESULT-TEXT.
- `native_endgame_ui.rs:12` — Bevy_Text_spawn ; ENDGAME-CONTINUE-TEXT.
- `native_ezreal_passive_hud.rs:174` — glyph_material_spawn ; EZREAL-PASSIVE-TEXT.
- `native_hud_inventory.rs:164` — glyph_material_spawn ; INVENTORY-COUNT-TEXT.
- `native_hud_widgets.rs:52` — glyph_material_spawn ; NATIVE-NUMERIC-TEXT.
- `ordinary_pause.rs:176` — Bevy_Text_spawn ; PAUSE-STATUS-CONTROL.
- `ordinary_pause.rs:188` — Bevy_Text_spawn ; PAUSE-STATUS-CONTROL.
- `shop_ui.rs:161` — Bevy_Text_spawn ; SHOP-TEXT.
- `shop_ui.rs:234` — Bevy_Text_spawn ; SHOP-TEXT.

## 4. Familles : lisibilité / focus / débordement

### NATIVE-NUMERIC-TEXT
Eighteen source numeric/key definitions, snapshot formatter and custom glyph materials.
Lisibilité : Same source metrics/projection limits retained; small GPU sample is not ordinary visual acceptance.
Focus clavier : No own text-editing loop; hotkey/control audits remain separate.
Débordement : 255byte copy guard and glyph geometry are not a pixel-fit proof.
Preuves réutilisées : gpu, numeric.

### INVENTORY-COUNT-TEXT
Native HUD counts use prepare/projected glyphs; inventory icon spawn is classified separately.
Lisibilité : Current count renderer exists; not every count/frame verified by old GPU samples.
Focus clavier : Drag/selection controls already audited separately; counts are not editable fields.
Débordement : ASCII/copy guards and slot bounds do not establish clipping on real frames.
Preuves réutilisées : gpu, numeric.

### EZREAL-PASSIVE-TEXT
One1..5glyph path with icon companion, source binding and layers.
Lisibilité : Source/size/material path known; no all-champion typography acceptance.
Focus clavier : Passive display is not a search/text editor.
Débordement : One glyph and source layer checks retain projection/raster limits.
Preuves réutilisées : gpu.

### SESSION-DIAGNOSTIC
PlayerLabel is the F3 diagnostic created at bottom-left, not a world-space nameplate.
Lisibilité : DejaVu14, max_width95%, status/snapshot/F3 guards sourced; no normal-notice equivalence.
Focus clavier : Diagnostic visibility is not keyboard text editing; command/rejection policies remain separate.
Débordement : Word layout/defaults and512byte rejection guard do not prove readable arbitrary errors.
Preuves réutilisées : diagnostic.

### PAUSE-STATUS-CONTROL
Two Bevy Text sites: status and button label; DejaVu16, pass-picking text and blocked button.
Lisibilité : Local UI wording/layout explicitly marked local, not original tournament renderer.
Focus clavier : Existing window/shop/identity guards retained; physical focus/navigation not accepted.
Débordement : Status has no fixed width; button184x36 and generic labels are not GUI fit proof.
Preuves réutilisées : pause.

### SHOP-TEXT
Shared native_text factory plus catalogue-price text spawn; NativeText roles cover search, prices, recipes, descriptions, counts and notices.
Lisibilité : Gill TTF16 and per-role rectangles; existing source/shop states and search-specific audits retained.
Focus clavier : Search is the named editor; its native navigation differences and ordinary send outcomes stay open.
Débordement : Search scalar cap is not universal or pixel fit; remaining shop labels use their actual rectangles/default layout.
Preuves réutilisées : shop, layout, keyboard.

### DEATH-RECAP-TEXT
Local owner recap creates columns/rows through one text factory, dynamic strings and viewport/row guards.
Lisibilité : Adaptive font/columns and local style identified; original renderer/native visual proof remains limited.
Focus clavier : Pickable::IGNORE and FocusPolicy::Pass are explicit; own/death/shop visibility gates retained.
Débordement : Minimum640x480 and bounded rows do not establish fit of every dynamic source name/value.
Preuves réutilisées : death.

### TERMINAL-RESULT-TEXT
Frozen authoritative terminal table plus Return label; distinct from a missing live scoreboard.
Lisibilité : Existing retained victory/defeat visual claims stay dated and scoped; French/locale/native-variant gaps retained.
Focus clavier : Return/context/lifetime guards already audited, not full OS navigation acceptance.
Débordement : 100%text width and generated multiline rows are not all-window typography verification.
Preuves réutilisées : results, pause.

### ENDGAME-CONTINUE-TEXT
CONTINUER label inside a native-image-backed button, size20scaled; winner/session/timing gates.
Lisibilité : Source image conversion is separate from Text label/native font and locale selection.
Focus clavier : Continue pointer/window/callback gaps remain existing corrections.
Débordement : Button scale and font scale do not alone prove all labels fit.
Preuves réutilisées : results, pause.

## 5. Compléments et absences bornées

### BITMAP-ENDGAME-TITLES
Victory/defeat/title atlas PNGs carry pre-rendered text; native_endgame_ui selects them independently of the CONTINUER Text component.
Retain exact DDS→RGBA comparison and locale/variant gaps from result audit; not readable/localized-native proof from a Text token search.

### LIVE-CHAT-HISTORY
Existing bounded absence of playable chat/open/send/history UI retained; no Text factory is manufactured for it.
Missing implementation is an audited finding; future consumer must reopen text/focus/layout cases.

### LIVE-SCOREBOARD
Live interactive scoreboard remains distinct from terminal ResultsText and the diagnostic roster text.
Do not use terminal result screenshots to accept an absent live board.

### OPTIONS-MENU-BOUNDARY
Existing AS presentation/input/settings contracts are retained; no applied panel UI is inferred from them or from configuration Value::Text.
Named alias/resource searches in existing options audit are bounded, not global absence of generic providers.

### WORLD-TEXT-BOUNDARY
No named Text2d/TextSpan/alternate-builder route found by this inventory/cross-check; PlayerLabel is a screen diagnostic.
Not a theorem of absence of text baked in sprites/meshes or of original world-nameplate fidelity; preserve cross-domain follow-up if a concrete renderer/asset lead appears.

## 6. Contrôles, écarts et travail restant
Contrôles effectivement exécutés : identités et correspondance des191lignes, portée cfg/test,12témoins de types image, fenêtres des vrais constructeurs/mises à jour, locators conservés et relecture des preuves. Les trois contrôles synthétiques du scanner concernent uniquement le classement documentaire.
Non exécutés ici : compilation/test Rust, jeu, UI/GUI, rendu/GPU, clavier/IME, presse-papiers, réseau, nouveau REA/export ou migration. Le placement d’un Node, un compte de caractères ou une conversion de PNG ne prouve pas la lisibilité complète.
- HUD-TEXT-CENSUS-METRIC-01 : 191matching lines/44files classify named tokens;9ordinary families and12source spawn sites are not12widgets or a percentage of game completion. Factories create multiple instances.
- HUD-TEXT-CENSUS-NAMESPACES-01 : Value::Text, native record Text and FontMaterial support differ from Bevy Text entities. MaterialNode can hold IconMaterial/FogMaterial; two image companion spawns remain separate from glyph spawns.
- HUD-TEXT-CENSUS-LIVE-TERMINAL-01 : Terminal ResultsText is present, live chat/scoreboard absence remains bounded; PlayerLabel is an on-screen diagnostic, not proof of world nameplates.

### PARENT-THREE-CLAUSE-REVIEW
Ce recensement ne décide pas à lui seul la clôture de SYS-17.5-06 : chaque clause et les limites des familles doivent être confrontées aux sept rubriques.
Reprise : Revue parente à partir des audits acceptés et de cette matrice ; décider explicitement manque fonctionnel/vérification ou véritable clause d’audit encore non examinée.

### VISUAL-AND-PHYSICAL-QUALIFICATION
Fonts chargées, glyphes, focus OS/navigation, textes longs et débordements réels ne deviennent pas acceptés depuis des constructeurs ou anciens tests ciblés.
Reprise : Réutiliser les corrections exactes et preuves datées ; cas rendu/interaction nouveau et nommé seulement après contrat et autorisation adaptée.

### NATIVE-BITMAP-WORLD-BOUNDARIES
Le recensement lexical ne prouve pas absence de texte dans les images/meshes ou toute surface originale. Titres bitmap connus et frontières menu/monde sont conservés séparément.
Reprise : Source/asset/renderer précis si nouvelle piste ; ne pas transformer une absence nommée en absence globale ni répéter une recherche générale sans indice.

Ce lot classe des consommateurs et réutilise leurs corrections exactes ; aucun nouveau défaut de rendu mesuré. La revue parente doit décider les clauses d’audit restantes sans convertir une absence de preuve visuelle en nouveau doublon de tâche.
Aucune définition de correction antérieure n’est modifiée, aucun doublon ajouté. Les inconnues et manques fonctionnels restent ouverts ; le parent ne devient pas clos par ce recensement.

## 7. Relecture et livraison
- 1 : Task/prérequis exacts, inventaire des familles et compléments ; parent pas automatiquement clos.
- 2 : Sources historiques/locales et absences réutilisées par champs ; visualité native/locale reste bornée.
- 3 : 191lignes qualifiées sur44fichiers,12sites source/9familles et5frontières complémentaires ; tests/probes/images séparés.
- 4 : Contrôles source, queries0/absence1 et scanner de métadonnées ; aucun Rust/GUI, ancien test ou programme produit exécuté.
- 5 : Lisibilité/focus/débordement examinés en couverture ; réception de preuve visuelle et graphe compilé non inventés.
- 6 : Corrections existantes exactes conservées ; pas de nouveau défaut de pixels ni doublon proposé depuis ce seul recensement.
- 7 : Preuves immuables identifiées, lecteur distinct et guards source1168/registres/Git ; goal et suivi inchangés.

Livrables ajoutés : ce rapport et `F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01` (entrées, locators, classification/scanner, producteur/preuve, lecteur et reçus). Preuves et fichiers préexistants conservés. Aucun goal, critère normatif, code produit, Plan, application de suivi, registre ou base modifié.
Prochain lot : AUD-17.5-06-PARENT-CLOSURE-REVIEW-01 ; confronter le parent entier aux sept rubriques et décider uniquement la portée documentaire justifiée.
