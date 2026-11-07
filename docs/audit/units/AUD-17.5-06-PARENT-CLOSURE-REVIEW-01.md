# SYS-17.5-06 — audit des textes et du focus

2026-11-01T15:49:08.681443+00:00 ; goal SYS-01.2-02 actif.

Audit terminé avec constats, sous réserve de relecture distincte et de son reçu réel. La fonctionnalité et la recette visuelle/OS restent ouvertes. Aucun statut du plan changé.

Vérifier lisibilité, focus clavier et absence de débordement des textes
Le résultat « Vérifier lisibilité, focus clavier et absence de débordement des textes » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Clauses examinées

### READABILITY
Observé : Chemins de police et deux renderers distingués ; neuf familles, titres bitmap, absences UI et floating reliés à leurs preuves. Le petit probe ASCII ancien n’est pas une qualification des glyphes du HUD courant.
Limite : Police effectivement chargée, glyphes, contraste, locale et géométrie de chaque frame ne sont pas prouvés. Styles natifs et provider/montage restent partiellement inconnus.
Reprise : Exécuter les notes par vraie cible et identité de build/assets ; reprendre symbol287, provider/font et projection uniquement avec les entrées précises des anciens constats.

### KEYBOARD-FOCUS
Observé : Éditeur Search, priorité et frontières d’événements historiques comparés ; gardes locales fenêtre/identité/shop et contrôles de pause/retour distingués. Textes passifs sans éditeur séparés des contrôles ; chat/options/live scoreboard manquants restent des constats bornés.
Limite : Tab/flèches/navigation et handoff natif non intégralement reproduits ; OS, IME, AltGr, focus visible, dispatch inter-listeners et non-interférence réelle non qualifiés.
Reprise : HUD-SHOP-SEARCH-KEYBOARD-01 et tâches focus existantes, puis vraie exécution à contexte/identité fixés. Un ordre statique Update ne prouve pas l’absence de fuite dans une frame.

### TEXT-OVERFLOW
Observé : Limite d’ajout64scalaires, valeur initiale non normalisée et marqueur de focus séparés des pixels. Rectangles, WordBoundary/Visible par défaut, projection glyph et layout recap identifiés ; notes par rôle évitent de réduire le HUD à Search.
Limite : Aucun débordement réellement observé ici ; aucun fit pixels/ellipsis ou rendu multirésolution/localisé certifié. Garde255octets, bornes d’entrée et dimensions de Node ne valent pas une preuve graphique.
Reprise : HUD-SHOP-SEARCH-LAYOUT-01 plus notes par cible ; mesurer bounds/glyphes à build, assets, locale et dimensions admises, sans inventer une politique native manquante.

## Couverture et frontières
Neuf familles de consommateurs réels et cinq compléments sont reliés aux preuves. Douze sites de création sont des factories, pas douze widgets. Les191lignes de recherche ne sont pas un inventaire compilé ni une preuve d’absence de tout texte bitmap/mesh.
- NATIVE-NUMERIC-TEXT : Eighteen source numeric/key definitions, snapshot formatter and custom glyph materials. Same source metrics/projection limits retained; small GPU sample is not ordinary visual acceptance. No own text-editing loop; hotkey/control audits remain separate. 255byte copy guard and glyph geometry are not a pixel-fit proof.
- INVENTORY-COUNT-TEXT : Native HUD counts use prepare/projected glyphs; inventory icon spawn is classified separately. Current count renderer exists; not every count/frame verified by old GPU samples. Drag/selection controls already audited separately; counts are not editable fields. ASCII/copy guards and slot bounds do not establish clipping on real frames.
- EZREAL-PASSIVE-TEXT : One1..5glyph path with icon companion, source binding and layers. Source/size/material path known; no all-champion typography acceptance. Passive display is not a search/text editor. One glyph and source layer checks retain projection/raster limits.
- SESSION-DIAGNOSTIC : PlayerLabel is the F3 diagnostic created at bottom-left, not a world-space nameplate. DejaVu14, max_width95%, status/snapshot/F3 guards sourced; no normal-notice equivalence. Diagnostic visibility is not keyboard text editing; command/rejection policies remain separate. Word layout/defaults and512byte rejection guard do not prove readable arbitrary errors.
- PAUSE-STATUS-CONTROL : Two Bevy Text sites: status and button label; DejaVu16, pass-picking text and blocked button. Local UI wording/layout explicitly marked local, not original tournament renderer. Existing window/shop/identity guards retained; physical focus/navigation not accepted. Status has no fixed width; button184x36 and generic labels are not GUI fit proof.
- SHOP-TEXT : Shared native_text factory plus catalogue-price text spawn; NativeText roles cover search, prices, recipes, descriptions, counts and notices. Gill TTF16 and per-role rectangles; existing source/shop states and search-specific audits retained. Search is the named editor; its native navigation differences and ordinary send outcomes stay open. Search scalar cap is not universal or pixel fit; remaining shop labels use their actual rectangles/default layout.
- DEATH-RECAP-TEXT : Local owner recap creates columns/rows through one text factory, dynamic strings and viewport/row guards. Adaptive font/columns and local style identified; original renderer/native visual proof remains limited. Pickable::IGNORE and FocusPolicy::Pass are explicit; own/death/shop visibility gates retained. Minimum640x480 and bounded rows do not establish fit of every dynamic source name/value.
- TERMINAL-RESULT-TEXT : Frozen authoritative terminal table plus Return label; distinct from a missing live scoreboard. Existing retained victory/defeat visual claims stay dated and scoped; French/locale/native-variant gaps retained. Return/context/lifetime guards already audited, not full OS navigation acceptance. 100%text width and generated multiline rows are not all-window typography verification.
- ENDGAME-CONTINUE-TEXT : CONTINUER label inside a native-image-backed button, size20scaled; winner/session/timing gates. Source image conversion is separate from Text label/native font and locale selection. Continue pointer/window/callback gaps remain existing corrections. Button scale and font scale do not alone prove all labels fit.
- BITMAP-ENDGAME-TITLES : Victory/defeat/title atlas PNGs carry pre-rendered text; native_endgame_ui selects them independently of the CONTINUER Text component. Retain exact DDS→RGBA comparison and locale/variant gaps from result audit; not readable/localized-native proof from a Text token search.
- LIVE-CHAT-HISTORY : Existing bounded absence of playable chat/open/send/history UI retained; no Text factory is manufactured for it. Missing implementation is an audited finding; future consumer must reopen text/focus/layout cases.
- LIVE-SCOREBOARD : Live interactive scoreboard remains distinct from terminal ResultsText and the diagnostic roster text. Do not use terminal result screenshots to accept an absent live board.
- OPTIONS-MENU-BOUNDARY : Existing AS presentation/input/settings contracts are retained; no applied panel UI is inferred from them or from configuration Value::Text. Named alias/resource searches in existing options audit are bounded, not global absence of generic providers.
- WORLD-TEXT-BOUNDARY : No named Text2d/TextSpan/alternate-builder route found by this inventory/cross-check; PlayerLabel is a screen diagnostic. Not a theorem of absence of text baked in sprites/meshes or of original world-nameplate fidelity; preserve cross-domain follow-up if a concrete renderer/asset lead appears.

Monde/floating : couverture et cas physique réutilisés ; sources natives de groupe/enable examinées, événement/style/provider/projection et vue courante non qualifiés. Aucun effacement de ces inconnues.

## Contrôles et preuves
Exécutés ici : identités, fenêtres source exactes, pointeurs de champs, cohérence des reçus hérités, clauses/prérequis, extraction en lecture seule du prochain enregistrement. Contrôles de documents, pas tests du moteur.
- baseline : 203 contrôles producteur / 341 lecteur hérités, codes0 observés dans les reçus. F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-FOCUS-BASELINE-01\text-baseline-proof.json
- layout : 339 contrôles producteur / 522 lecteur hérités, codes0 observés dans les reçus. F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\shop-search-layout-proof.json
- keyboard : 459 contrôles producteur / 654 lecteur hérités, codes0 observés dans les reçus. F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\shop-search-keyboard-proof-v2.json
- GPU : 520 contrôles producteur / 720 lecteur hérités, codes0 observés dans les reçus. F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-GPU-EVIDENCE-01\text-gpu-evidence-proof.json
- census : 1260 contrôles producteur / 1727 lecteur hérités, codes0 observés dans les reçus. F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01\text-consumer-coverage-proof.json

Non exécutés : jeu, compilation/tests Rust, AS, GPU/rendu, clavier OS/IME, réseau, export/désassemblage, REA. L’ancien probe ASCII, son binaire manquant et ses limites restent datés. Les reçus v1 de métadonnées clavier restent conservés à côté de v2.

## Corrections existantes, non appliquées

### HUD-SHOP-SEARCH-LAYOUT-01
objective : Qualifier la présentation bornée du seul texte de recherche boutique.
gap : Rectangle457x30 et defaults WordBoundary/Visible sans contrat explicite de viewport texte ; capacité64sur append ne prouve ni affichage borné ni champ initial valide. Aucun débordement graphique observé.
work : Retrouver le style natif txtSearch/placeholder via les définitions du symbole287 et leurs placements, puis expliciter le contrat du champ courant : police chargée, lignes, découpe/défilement ou autre comportement sourcé, marqueur/caret et fenêtre redimensionnée. Conserver le texte de recherche et l’édition selon le contrat de SYS-07.5-02 ; ne pas masquer un manque de fidélité par une limite arbitraire.
finish : Source des règles de présentation identifiée ; un texte court, le placeholder, un texte long, focus/perte de focus et les dimensions admises sont vérifiés sur le vrai champ. Les contenus issus de l’initialisation sont inclus. Motifs de refus et état complet restent accessibles selon le contrat ; aucune réussite de pixels déduite d’un simple compte de caractères.
resume : Style natif précisément identifié ou décision locale explicitement versionnée avec écart de fidélité ouvert ; cas et dimensions admis, puis travail produit/rendu autorisé séparément.
expected_proof : Ancêtres et composants effectifs, font load/build/assets, texte/caret et bounds mesurés avec captures du véritable champ ; nominal/long/focus/resize et limites explicites.

### HUD-SHOP-SEARCH-KEYBOARD-01
objective : Raccorder les états clavier de saisie et navigation de la recherche boutique.
gap : Le contrôleur courant libère le focus sur Enter/Escape et n’exprime pas la navigation des résultats du contrat source SearchArea/KeyboardNavigation. Les phases natives et l’autorité de capture restent à qualifier.
work : Définir les états et événements à partir des callbacks originaux identifiés : saisie, résultats/navigation, fermeture et reprise. Relier sélection/highlight/scroll et activation aux consumers réels et transactions existantes, en gardant distinct refus local, envoi et confirmation. Résoudre ou laisser explicitement ouverte la liaison native de capture et l’ordre des phases ; ne pas inventer un ordre depuis PRIORITY_INCREASED.
finish : Sur le vrai champ, Tab/Enter/Escape/flèches, liste vide/non vide, activation refusée/admise, modificateurs, IME et perte de focus suivent le contrat identifié. Les états texte et navigation sont distincts ; sélection/scroll et refus d’activation sont observés avec contexte/build/assets nommés, sans assimiler un booléen source à une confirmation serveur. Les autres widgets et le catalogue historique complet restent qualifiés séparément.
resume : Contrat natif/host et phases précisés ou politique locale versionnée avec l’écart de fidélité ouvert ; travail produit/exécution sous autorisation distincte. Réutiliser les sources et tâches présentes.
expected_proof : Matrice événements/états/gardes, vrais consumers, contexte et traces/captures clavier ; absence/présence de résultat et activation refusée/admise, sans faux acquittement ni fuite de commandes de combat.

### HUD-TEXT-PROBE-RESOURCE-IDENTITY-01
objective : Rendre vérifiable l’identité binaire et ressources du seul probe de texte nommé.
gap : Le probe configure AssetPlugin sur E:/OpenLeague/assets tandis que les données CPU suivent CARGO_MANIFEST_DIR. Les ressources E/F concordent lors de cette inspection mais ne sont pas liées par empreinte aux frames historiques ; le binaire annoncé est remplacé et aucun reçu autonome de sortie n’est fourni.
work : Conserver les anciens logs/JSON et leur portée. Retrouver si disponible le binaire/instantané historique exact ; pour une exécution nouvelle justifiée par une modification ou un cas nouveau, identifier les racines effectives CPU/shader, sources/build, fichiers chargés et leur manifeste avant le rendu, puis enregistrer le retour réel et les résultats bornés. Ne pas relancer automatiquement A-space-V inchangé ni présenter ce probe comme une recette des widgets ordinaires.
finish : Un reçu du probe relie explicitement binaire, build/sources, racines et ressources effectivement utilisées, backend, cas et sortie processus ; absence ou divergence reçoit un refus/limite explicite. Anciennes preuves restent datées, la projection ajoutée et les widgets ordinaires restent qualifiés par leurs propres cas.
resume : Archive historique précise ou source/binaire/ressources changés et cas d’exécution justifié, avec autorisation produit/exécution distincte. Aucun lancement dans cet audit.
expected_proof : Identités des ressources CPU et shader réellement utilisées, hash binaire/build, commande/backend/cas, stdout/stderr et sortie réelle ; bornes des comparaisons conservées.

Les corrections de résultats, mort, options, chat/score et floating sont conservées par leurs pointeurs dans les donneurs ; aucun doublon, aucun critère normatif changé.

## Manques et conditions de reprise

### NATIVE-TEXT-POLICY
Style natif du champ Search, font effectivement résolue et montée, host/dispatch/IME et projection framebuffer ne sont pas tous qualifiés.
Reprise : Reprendre les champs exacts NATIVE-SEARCH-TEXT-STYLE, NATIVE-HOST-AND-DISPATCH et ORIGINAL-FRAMEBUFFER-PROJECTION conservés ci-dessous ; une nouvelle entrée source/runtime identifiée est nécessaire, pas une répétition du même locator.

### CURRENT-SEARCH-BEHAVIOR
Layout texte/politique de débordement et navigation clavier Search restent à corriger et vérifier.
Reprise : Appliquer séparément les corrections exactes HUD-SHOP-SEARCH-LAYOUT-01 et HUD-SHOP-SEARCH-KEYBOARD-01 ; réutiliser SYS-07.5-02/07 et corrections contexte existantes.

### CURRENT-VISUAL-AND-OS-CHECKS
Rendu ordinaire, pixels, glyphes, locale et focus OS/IME de chaque cible non testés ici ; ancien exécutable GPU exact non récupéré.
Reprise : Réutiliser les43notes de cibles ; identifier exécutable, assets réellement chargés, backend, viewport/DPI et locale, puis exécution autorisée. Refaire un probe seulement avec HUD-TEXT-PROBE-RESOURCE-IDENTITY-01, sans réécrire le reçu ancien.

### MISSING-OR-BOUNDED-SURFACES
Chat/live score/options et monde/floating ont des absences courantes bornées et des gaps de réalisation/politique ; atlas de titres n’est pas un Text widget.
Reprise : Réutiliser les tâches/corrections et conditions exactes des donneurs absence/options/résultats/floating ; élargir la recherche uniquement avec une piste de renderer/atlas/source nouvelle. Les limites des queries191lignes restent conservées.
- Ancienne frontière `NATIVE-SEARCH-TEXT-STYLE` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\shop-search-layout-proof.json/remaining_gaps/0.
- Ancienne frontière `CURRENT-SEARCH-PIXELS` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\shop-search-layout-proof.json/remaining_gaps/1.
- Ancienne frontière `SEARCH-KEYBOARD-PARENT` : Comparaison SearchArea/Root/KeyboardNavigation et éditeur réel ajoutée ; les manques du contrôleur courant demeurent dans HUD-SHOP-SEARCH-KEYBOARD-01. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01\shop-search-layout-proof.json/remaining_gaps/2.
- Ancienne frontière `NATIVE-HOST-AND-DISPATCH` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\shop-search-keyboard-proof-v2.json/remaining_gaps/0.
- Ancienne frontière `CURRENT-SEARCH-KEYBOARD-CONTROLLER` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\shop-search-keyboard-proof-v2.json/remaining_gaps/1.
- Ancienne frontière `HUD-READABILITY-AND-GLOBAL-FOCUS` : Neuf familles courantes, compléments et frontières focus identifiés ; aucune recette OS/IME ou visuelle revendiquée. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01\shop-search-keyboard-proof-v2.json/remaining_gaps/2.
- Ancienne frontière `HISTORICAL-RUN-IDENTITY` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-GPU-EVIDENCE-01\text-gpu-evidence-proof.json/remaining_gaps/0.
- Ancienne frontière `ORDINARY-TEXT-VISUAL-CASES` : Familles et sites réels recensés ; notes de vérification par cible ci-dessous. La réalisation de ces essais reste ouverte. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-GPU-EVIDENCE-01\text-gpu-evidence-proof.json/remaining_gaps/1.
- Ancienne frontière `ORIGINAL-FRAMEBUFFER-PROJECTION` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-GPU-EVIDENCE-01\text-gpu-evidence-proof.json/remaining_gaps/2.
- Ancienne frontière `PARENT-THREE-CLAUSE-REVIEW` : Les trois clauses sont confrontées ici à chacune des familles, aux compléments et aux sept rubriques ; décision documentaire seulement. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01\text-consumer-coverage-proof.json/remaining_gaps/0.
- Ancienne frontière `VISUAL-AND-PHYSICAL-QUALIFICATION` : Constat conservé avec son entrée et sa condition de reprise exactes. Il porte sur une politique historique non qualifiée, une implémentation ou une vérification manquante, pas sur une clause cachée par la clôture. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01\text-consumer-coverage-proof.json/remaining_gaps/1.
- Ancienne frontière `NATIVE-BITMAP-WORLD-BOUNDARIES` : Titres bitmap reliés à l’audit résultats ; groupe floating relié aux preuves natives et absences bornées existantes. Aucun théorème d’absence globale de texte dans les sprites/meshes. Définition et reprise originales dans F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-CONSUMER-COVERAGE-01\text-consumer-coverage-proof.json/remaining_gaps/2.

## Notes de vérification par cible
43notes proposées dans SYS-17.5-06 existante, sans ajout de tâche, changement de critère ou case cochée. Une note n’est pas un essai passé. Conditions communes : Contrat/référence et dimensions admises, vraie identité build/assets/locale, puis travail/exécution autorisé séparément. Une propriété de layout ne prouve pas le rendu.

### TXT-CHECK-HUD-955a99641a30104e
HUD/Elements/CenterHUD_HealthBar.ini::HPStat
Attendu : Nominal/limite/refus de la règle source ceil(current) / ceil(maximum), ASCII spaces around slash ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-495804d53d5798e4
HUD/Elements/CenterHUD_PARBar.ini::MPStat
Attendu : Nominal/limite/refus de la règle source floor(current) / floor(maximum), only native resource type Mana ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-1eda9257a159be31
HUD/Elements/CenterHUD_AbilitiesSpell0.ini::SpellCooldown0
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-e3362f6b8009ba52
HUD/Elements/CenterHUD_AbilitiesSpell0.ini::SpellHotKey0
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-ed210d6ffca1177f
HUD/Elements/CenterHUD_AbilitiesSpell1.ini::SpellCooldown1
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-ee459b0a4efc8b6e
HUD/Elements/CenterHUD_AbilitiesSpell1.ini::SpellHotKey1
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-e90982db87a0d51a
HUD/Elements/CenterHUD_AbilitiesSpell2.ini::SpellCooldown2
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-2610bf26aadbe061
HUD/Elements/CenterHUD_AbilitiesSpell2.ini::SpellHotKey2
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-f2360bb84c6c0471
HUD/Elements/CenterHUD_AbilitiesSpell3.ini::SpellCooldown3
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-fd0945485824f4b2
HUD/Elements/CenterHUD_AbilitiesSpell3.ini::SpellHotKey3
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-2e6f399e46258a9f
HUD/Elements/CenterHUD_AbilitiesSpellSummoner0.ini::SummonerSpellCooldown0
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-91f2233252ace500
HUD/Elements/CenterHUD_AbilitiesSpellSummoner0.ini::SummonerSpellHotKey0
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-f4ec1688bd39bde0
HUD/Elements/CenterHUD_AbilitiesSpellSummoner1.ini::SummonerSpellCooldown1
Attendu : Nominal/limite/refus de la règle source format(max(ready_at-tick,0)/TICK_RATE,NumericCooldownFormat) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-b9d67dc0aa9a45e7
HUD/Elements/CenterHUD_AbilitiesSpellSummoner1.ini::SummonerSpellHotKey1
Attendu : Nominal/limite/refus de la règle source short ASCII label from recovered default input binding ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-8a03e123a0fbd692
HUD/Elements/ShadowIslesChampionLeft.ini::GoldStat
Attendu : Nominal/limite/refus de la règle source finite nonnegative <=u32::MAX; floor then unsigned decimal ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-b194ef5344755925
HUD/Elements/ShadowIslesChampionLeft.ini::LevelStat
Attendu : Nominal/limite/refus de la règle source player.level.to_string() ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-64cd6a559b724b96
HUD/Elements/ShadowIslesChampionLeft.ini::RespawnTimer
Attendu : Nominal/limite/refus de la règle source integer ceil(max(respawn_at-tick,0)/TICK_RATE) ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-HUD-1c82d1efc3d2711f
HUD/Elements/ShadowIslesTitanBar.ini::GameTime
Attendu : Nominal/limite/refus de la règle source snapshot.tick / TICK_RATE, then minutes:seconds with two second digits ; texte/glyphes et bounds observés dans le vrai HUD. Font résolue distinguée de la propriété brute, fidélité native non déduite du seul INI.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-0
HUD inventory slot 0
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-1
HUD inventory slot 1
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-2
HUD inventory slot 2
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-3
HUD inventory slot 3
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-4
HUD inventory slot 4
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-INVENTORY-5
HUD inventory slot 5
Attendu : Valeur/visibilité conformes aux cas admis du slot, petit/grand compteur légal, changement/contexte ancien ; bounds/glyphes vérifiés, sans qualifier un septième slot historique non établi.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-EZREAL-PASSIVE
native_ezreal_passive_hud stack
Attendu : Compteur1..5, absence/expiration et contexte invalide selon source ; géométrie/glyphes/association icône vérifiés sans généraliser à tous les champions.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-DIAGNOSTIC
PlayerLabel F3
Attendu : F3 off/on, statut/refus déjà public et qualifié, vide/long/multiligne admis, contexte changé ; bounds effectifs et retrait observés. Ce n’est pas une notification normale native.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-PAUSEHUD
PauseHud
Attendu : Libellés existants attente/disponible/demande/refus/timeout selon leur contrat, contexte/focus/overlay et dimensions admises ; texte/bouton restent distincts.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-PAUSEBUTTONLABEL
PauseButtonLabel
Attendu : Libellés existants attente/disponible/demande/refus/timeout selon leur contrat, contexte/focus/overlay et dimensions admises ; texte/bouton restent distincts.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-SEARCH
NativeText::Search
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-GOLD
NativeText::Gold
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-DETAIL
NativeText::Detail
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-SELECTEDNAME
NativeText::SelectedName
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-SELECTEDPRICE
NativeText::SelectedPrice
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-RECIPE
NativeText::Recipe
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-SELLPRICE
NativeText::SellPrice
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-COUNT
NativeText::Count
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-PRICE
NativeText::Price
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-NOTICE
NativeText::Notice
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-SHOP-STATICLABELS
literal shop labels
Attendu : Vrai rôle/rectangle, contenu court et long légal/localisé, visibilité/contexte et glyphes mesurés ; politique native manquante conservée. Search réutilise ses corrections layout/clavier, pas de doublon.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-RECAP-COLUMNS
LocalOwnerDeathRecap
Attendu : Titre/résumé, chaque colonne, sources/dégâts/bouclier/létalité et pied de tableau sur rangées admises ; fenêtres minimale/nominale/redimensionnée admises, retrait/owner/shop ; pas de texte natif inventé.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-RESULTSTEXT
ResultsText
Attendu : Victoire/défaite/final ancien et contenu figé selon corrections existantes ; source langue/variante, multiline/bounds et garde retour séparés du live scoreboard.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-RETURNLABEL
ReturnLabel
Attendu : Victoire/défaite/final ancien et contenu figé selon corrections existantes ; source langue/variante, multiline/bounds et garde retour séparés du live scoreboard.
Observé : non exécuté ; état proposé, non appliqué.

### TXT-CHECK-CONTINUE
NativeImage button_label
Attendu : Label/cadre à l’échelle admise, victoire/défaite/ancien contexte/fermeture selon corrections existantes ; pas de fusion entre atlas de titre et Text du bouton.
Observé : non exécuté ; état proposé, non appliqué.

## Revue de clôture
- 1 : Contrat SYS-17.5-06 et trois clauses exactes ; prérequis non déclarés terminés.
- 2 : Référence historique, styles/providers inconnus et source floating/bitmap conservés avec reprises.
- 3 : Familles courantes et absences bornées examinées ; inventaire nommé ne prouve pas un graphe Rust compilé.
- 4 : Contrôles documentaires actuels et reçus hérités distincts ; aucun nouveau test produit/GPU/OS.
- 5 : Douze anciennes ouvertures classées ; les inconnues de réalisation/vérification demeurent explicites.
- 6 : Trois corrections exactes réutilisées ;43notes de vérification rattachées à la tâche existante, pas de nouveaux critères.
- 7 : Livrables immuables, sources/pointeurs, producteur et lecteur distinct ; aucun changement de goal, Plan, registre ou base.

La clôture porte sur la confrontation documentaire des clauses aux consommateurs et frontières réellement examinés. Les inconnues historiques et vérifications produit sont des constats explicites avec actions/reprises ; elles ne sont pas supprimées, et aucun volume de fichiers ou de contrôles ne sert de pourcentage de complétude.
Les anciennes décisions de parent ouvert restent inchangées dans chaque sous-lot. La décision présente examine les clauses ; elle n’additionne pas les voyants verts.

Fichiers ajoutés uniquement : ce rapport et F:\OpenLeague-work\audit-units\AUD-17.5-06-PARENT-CLOSURE-REVIEW-01 (entrées, snapshot, scripts, preuve et reçus). Goal, critères, code produit, application de suivi, registres et bases conservés.
Prochain lot : AUD-17.5-01-PARENT-COVERAGE-REVIEW-01 — Comparer les clauses du parent actif/désactivé/refusé à la couverture existante des contrôles HUD ; isoler le premier vrai manque d’audit, sans répéter les recherches closes.

Premier producteur documentaire code1 conservé : ancien lecteur floating utilise producer_proof au lieu de main_proof. Adaptation explicite en v2 ; aucun échec produit déduit.