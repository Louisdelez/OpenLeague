# SYS-17.5-06 — champ de recherche : layout et sources

Unité AUD-17.5-06-SHOP-SEARCH-LAYOUT-01 ; UTC 2026-11-01T12:30:53.867787+00:00

Audit de ce champ terminé sous réserve de la relecture distincte. SYS-17.5-06 reste ouvert, fonctionnalité et pixels non qualifiés, acceptation humaine non revendiquée. Goal SYS-01.2-02 actif et inchangé.

## 1. Portée et contrat
Vérifier lisibilité, focus clavier et absence de débordement des textes
Champ de recherche boutique uniquement ; source et conditions statiques, pas une recette globale des widgets. Prérequis hérités conservés.

## 2. Historique identifié
FoundryItemShop.gfx SHA256 4aa0368dcd3713d2ccf40439a9482166b597422e8090ae0eff21c4b65063fbee ; export existant code0, ni jeu ni ActionScript exécutés. SearchArea.as SHA256 1ba08efee480269443949da7f710be7ca3a9b38419bde569d52700bed34b5435. SearchAreaDesign déclare txtSearch/txtPlaceholder et symbol287 ; ses propriétés graphiques ne sont pas dans ce script.
SearchArea déclare une limite1000 et rétablit storedSearchText si text.length la dépasse. Ce n’est pas64scalaires Rust ni une autorisation de remplacer les règles historiques. Son focus comprend aussi keyboardNav.enable ; les appels take/release sont distincts.

## 3. Consommateur réellement lié
Le marqueur SearchLabel n’est qu’une déclaration dans le locator nommé. Le texte actif est NativeText::Search, construit dans shop_ui.rs215–216 et mis à jour419–421 via la query NativeText+Text.
Champ parent : [59.5,145,461.5,34] ; texte enfant : [0,0,457,30], unités logiques avant UiTransform. px_node utilise position absolue, taille puis defaults. Racine1170x920, échelle assignée à UiTransform selon la fenêtre ; aucun pixel physique mesuré.
Le helper demande GillSansMTProMedium.ttf à16px logiques. AssetPlugin pointe root/assets, root dérivé de CARGO_MANIFEST_DIR au build. Le fichier F présent concorde avec assets-manifest : ab7b9a5de7baa4be9d9a1a9a7ad073490d80b76ae0864e1993bddcbabbbe380a. Ce constat ne prouve pas le chargement d’un binaire existant, ni son ancien root de compilation.
Text requiert TextLayout. Les sources des deux archives Bevy0.19.0 concordent avec Cargo.lock et les trois membres locaux relus. TextLayout dérive Default, LineBreak par défaut WordBoundary, Node→Overflow→OverflowAxis Visible. Le constructeur du champ ne les remplace pas explicitement. Le catalogue scroll_y est un autre nœud, pas un ancêtre de la recherche. Aucun théorème d’absence de mutation générique/runtime n’est revendiqué.
append ajoute au plus la capacité restante calculée sur64scalaires ; il ne mesure pas le texte et ne tronque pas une chaîne préexistante. OPENLEAGUE_SHOP_QUERY est une source initiale String copiée directement ; aucun environnement modifié ou lu pour sa valeur. Le label ajoute " |" au focus et peut donc dépasser la longueur de la requête.

## 4. Attendu / observé — cas de source

### EMPTY-UNFOCUSED
Condition : Query empty and not focused.
Attendu : Initial/updated placeholder branch names the local French prompt.
Observé en source : Construction uses Rechercher un objet..., update chooses it only for empty&&!focused.
Limite : Source, no measured width or rendered placeholder.

### FOCUSED-TEXT
Condition : Query focused, including an empty query.
Attendu : Current display adds the literal space+pipe focus marker.
Observé en source : Format uses query plus " |"; append capacity is about query only.
Limite : Not a native caret/selection, OS focus or blink acceptance; a64scalar query can produce66display scalars, not a pixel measure.

### LONG-EDIT
Condition : Wide glyphs or long unbroken text admitted by append.
Attendu : Do not infer pixel fit from scalar cap.
Observé en source : No width measurement in append; field leaves WordBoundary/Visible defaults at construction.
Limite : Possible layout risk only; no overflowing frame observed and no global runtime mutation theorem.

### INITIAL-OVERSIZE
Condition : Valid Unicode OPENLEAGUE_SHOP_QUERY value over64scalars or containing a line break.
Attendu : Track this source separately from ordinary editor additions.
Observé en source : Default source copies the String without normalization; display formats it directly.
Limite : Conditional input path, no environment changed or actual value read. Startup validity policy not decided here.

### NATIVE-REJECT
Condition : Original onSearchChange sees text.length>1000.
Attendu : Retain source rejection behavior and its unit boundary.
Observé en source : Restores storedSearchText and returns.
Limite : Decompiled source, not AS runtime, input-unit equivalence or original DefineEditText style qualification.

### FOCUS-AND-RESIZE
Condition : Window/session/focus changes and varying panel scale.
Attendu : Reuse local guard evidence and identify native distinction.
Observé en source : Current transform and editor gates exist; native searchHasFocus also includes keyboardNav.enable.
Limite : No actual GUI, font-load state, keyboard navigation, IME or physical-pixel measurement.

Contrôles réellement exécutés ici : identités, fenêtres exactes, correspondance des archives à Cargo.lock et de leurs membres, asset/manifeste, locator nommé et invariants de source. Reçus du sous-lot précédent réutilisés, pas relancés. Les vérifications documentaires ne sont pas des tests du moteur.
Non exécutés : jeu, AS, compilation/test Rust, rendu, métriques/glyphes, font LoadState, presse-papiers, réseau, panne, REA, FFDec ou export nouveau.

## 5. Écarts et reprises

### NATIVE-SEARCH-TEXT-STYLE
Définition effective des TextField et placements du symbole287 : style, linebreak, clipping, scroll/caret, montage et rasterisation natifs non qualifiés par les scripts exportés.
Reprise : Nouvelle piste précise dans les définitions/ressources natives déjà disponibles ; pas de nouvel export général ni de recherche répétée sans indice. Réutiliser SearchAreaDesign, GFX et les sources font déjà identifiés.

### CURRENT-SEARCH-PIXELS
Aucun frame, LoadState de police, glyphes, taille calculée, clipping effectif ou mesure après UiTransform vérifié dans ce lot.
Reprise : HUD-SHOP-SEARCH-LAYOUT-01 avec contrat admis et vrai build/assets ; exécution produit séparément autorisée.

### SEARCH-KEYBOARD-PARENT
Navigation clavier native, Tab/Enter/Escape et capture/release ne sont pas entièrement confrontés ici ; autres textes/overlays et recette HUD entière restent ouverts.
Reprise : Lot suivant sur SearchArea/KeyboardNavigation et les gardes effectives, réutilisant les sources présentes ; aucune clôture de SYS-17.5-06 depuis ce seul champ.

## 6. Travail produit restant, non appliqué
HUD-SHOP-SEARCH-LAYOUT-01 — Qualifier la présentation bornée du seul texte de recherche boutique.
Rectangle457x30 et defaults WordBoundary/Visible sans contrat explicite de viewport texte ; capacité64sur append ne prouve ni affichage borné ni champ initial valide. Aucun débordement graphique observé.
Travail : Retrouver le style natif txtSearch/placeholder via les définitions du symbole287 et leurs placements, puis expliciter le contrat du champ courant : police chargée, lignes, découpe/défilement ou autre comportement sourcé, marqueur/caret et fenêtre redimensionnée. Conserver le texte de recherche et l’édition selon le contrat de SYS-07.5-02 ; ne pas masquer un manque de fidélité par une limite arbitraire.
Critère : Source des règles de présentation identifiée ; un texte court, le placeholder, un texte long, focus/perte de focus et les dimensions admises sont vérifiés sur le vrai champ. Les contenus issus de l’initialisation sont inclus. Motifs de refus et état complet restent accessibles selon le contrat ; aucune réussite de pixels déduite d’un simple compte de caractères.
Reprise : Style natif précisément identifié ou décision locale explicitement versionnée avec écart de fidélité ouvert ; cas et dimensions admis, puis travail produit/rendu autorisé séparément.
Preuve attendue : Ancêtres et composants effectifs, font load/build/assets, texte/caret et bounds mesurés avec captures du véritable champ ; nominal/long/focus/resize et limites explicites.

SYS-07.5-02 réutilisé sans changer son objectif ni son critère original : Rechercher un objet par nom localisé.
- Réutiliser SearchArea length>1000→storedSearchText ; ne pas convertir implicitement ces unités en64scalaires Rust.
- Inclure OPENLEAGUE_SHOP_QUERY parmi les producteurs : append ne tronque pas une valeur initiale arbitraire et le label ajoute un marqueur propre.
- Décider le contrat d’édition fidèle/local nommé pour ces entrées, distinct du layout et de la recherche par nom localisé ; aucun changement de tâche ou de critère dans cette intervention.

Aucun doublon de tâche de recherche ou de correction de contexte pointeur. Les dépendances mentionnent l’origine/liaison au parent, pas un ordre exécutable déjà accepté.

## 7. Relecture et décision
- 1 : Champ de recherche seulement, task/prérequis exacts, parent ouvert.
- 2 : Original GFX/export/AS identifiés ; style TextField et rendu restent inconnus avec reprise précise.
- 3 : Vrai NativeText::Search relié à factory et update, SearchLabel distingué, root/assets et TTF présents identifiés.
- 4 : Contrôles sources/archives/manifest et six cas conditionnels ; aucun jeu/GUI/réseau exécuté.
- 5 : Bornes logiques, defaults, source initiale et unités natives distingués ; pixels et navigation globale non qualifiés.
- 6 : Un layout atomique proposé, SYS-07.5-02 et ses critères exacts réutilisés ; aucune correction appliquée.
- 7 : Preuve/rapport datés, lecteur distinct, source1168/Git/registres et acquis conservés.

Ce champ et ses frontières source sont audités ; les clauses restantes de SYS-17.5-06 et la vérification du rendu restent ouvertes.
La limite graphique est un risque source et une politique manquante, pas un débordement observé. Une nouvelle preuve de frame ou de style natif pourra rouvrir ce périmètre précisément.
Livrables ajoutés : ce rapport et le dossier `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-LAYOUT-01` (spécification, entrées, producteur, preuve, lecteur et reçus). Tous les fichiers préexistants et preuves restent conservés. Aucun goal, critère normatif, code produit, Plan, application de suivi, registre ou base modifié.
Prochain lot : AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01 — Recherche boutique uniquement : focus text-field ou navigation, Tab/Enter/Escape, owner et capture/release ; comparer SearchArea/KeyboardNavigation au vrai éditeur et aux gardes courantes.
