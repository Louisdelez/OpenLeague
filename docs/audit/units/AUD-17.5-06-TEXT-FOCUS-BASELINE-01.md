# SYS-17.5-06 — base de preuves texte et focus

Unité AUD-17.5-06-TEXT-FOCUS-BASELINE-01 ; UTC 2026-11-01T12:18:05.237113+00:00.

Ce sous-lot vérifie la pertinence des preuves acquises. Le parent SYS-17.5-06 reste ouvert sur ses trois clauses ; aucune recette visuelle ou acceptation humaine. Goal SYS-01.2-02 actif et inchangé.

## Contrat et dimensions
Vérifier lisibilité, focus clavier et absence de débordement des textes

Audit du sous-lot : terminé sous réserve de la relecture distincte. Audit parent : en cours. Implémentation : partielle/non qualifiée pour cette recette. Vérification : sources seulement ici ; essais anciens hérités. Acceptation humaine : non demandée dans ce sous-lot, non revendiquée.

## Référence historique et chronologie
V795 qualifie des lectures/alias sur racines de diagnostic ; ses anciennes pistes callback/lookup ont ensuite reçu des preuves fragmentaires distinctes. Ne pas reprendre comme état actuel « callback jamais analysé ». Callback : contrôles synthétiques de fragments, pas lookup réel. Provider : lookup/comparateur original sur tables contrôlées, pas méthode entière ni montage historique. Aucun ne prouve les pixels.

- font_V795 : `F:\OpenLeague\docs\fidelity_rea_locale_text_v795.json` ; c2f7946f3d5717d6b9d1d0f4279716036cea9226fce5c14fe917ef9875859f74
  - REA is static only; no original localization parser,lookup or game process executed.
  - Current modules are compiled with selected cached serde_json;this is not a full client or Bevy font/glyph test.
  - Explicit isolated locale roots with exact source copies;locale selection in ordinary launcher/client is not qualified by these38 profiles.
  - Lexical keys and localized sample lines do not prove native value parsing,escaping,precedence,plural/number formatting or visible text.
  - CLIENT,AUDIO,LAYOUT locale tasks remain outside this lot;19HUD and3SYS requirements stay partial;all unknowns/manual states preserved.
  - HandleLocalizeText callback7879A0, token parser795D10, string storage, escaping and lookup are not yet analyzed or executed;registration alone does not establish resolved text.
  - Vingt-trois fiches enrichies ; états manuels, prérequis et registre des inconnues conservés.

- callback : `F:\OpenLeague-work\audit-units\AUD-22.1-07-CALLBACK-01\fragment-proof.json` ; 78dc9371cb19516ee87d242a0a4d42fd7a3c07897fa06addfccf3652feeddcb6
  - Inputs, backend result and output bytes are declared synthetic controls, not recovered translator results
  - Only null-input prefix and result-selector suffix executed, not CRT/provider/bootstrap/lookup
  - The backend decision for a real missing key remains unqualified
  - Translator absence assertion is distinct from a missing text key
  - No historical process, current Rust callback, network or graphical verification

- provider : `F:\OpenLeague-work\audit-units\AUD-22.1-07-PROVIDER-01\lookup-proof.json` ; e56f20e4e4fc20b10617ab17990b92c799342590266fea2debeb6bbadfdd14bc
  - Controlled tables contain six unmodified native source records per locale, not a reconstructed full parser result
  - Table allocation/layout and SFString byte blocks are explicitly owned controls
  - Original lookup/hash/comparator execute without callbacks or synthetic search answers
  - Reading selected value bytes is not native copy/encoding/render execution
  - Direct SFString byte-key case behavior does not qualify upstream normalization
  - Profile translator identified; effective historical mounting remains open

## Consommateurs et couverture

### READABILITY
Sélection/alias de police et lookup natif borné ont des preuves identifiées ; diagnostic F3 et textes boutique ont des consommateurs. Aucun de ces résultats n’est un rendu lisible de tous les widgets.
Non prouvé : Police effectivement liée aux widgets, disponibilité des glyphes, métriques, lisibilité/contraste à plusieurs résolutions et locales.
Reprise : Partir des vrais constructeurs Text/font et dimensions de la recherche boutique ; relier les polices réellement utilisées, puis définir les cas de rendu sans les inventer.

### KEYBOARD-FOCUS
Gardes boutique sur fenêtre/identité/perte de focus, flux d’événements et activation ; ordre shop avant commands hérité. Les prédicats natifs text-field/logicalE9/input98/movie4 restent distincts.
Non prouvé : Navigation clavier complète, focus visible, capture OS/IME/AltGr réels, tous overlays et absence chat ; l’absence de chat ne valide pas ses états.
Reprise : Réutiliser SYS-17.4-08 et les cas texte boutique ; qualifier le vrai owner clavier et les consommateurs sélectionnés avant tout essai GUI.

### TEXT-OVERFLOW
append ajoute au plus la capacité restante calculée sur64scalaires Unicode et filtre les caractères de contrôle ; il ne tronque pas une chaîne préexistante arbitraire. Le parseur de polices laisse tr au domaine séparé. Ces gardes ne mesurent aucune largeur en pixels.
Non prouvé : Wrapping, clipping, ellipsis, hauteur, tailles de fenêtre, glyphes proportionnels/combinaisons et textes longs localisés dans les vrais widgets.
Reprise : Prochain cas limité : construction et mise à jour du champ de recherche boutique, métriques et contraintes de layout. Conserver le maximum64comme borne d’entrée, pas comme preuve visuelle.

## Attendu / observé et contrôles
Correspondances sources et preuves : conservées. Attendu local append : capacité restante en scalaires Unicode et filtrage des contrôles ; observé en source. Une chaîne fournie arbitrairement au-delà de64ne serait pas tronquée par append. Aucun calcul de largeur en pixels établi. Attendu du lecteur de polices : profil fourni ; observé : quatre maps/une bibliothèque et tr laissé au domaine séparé. Ceci ne valide ni les traductions ni les glyphes/rendu.
Focus : gardes fenêtre/session/perte/open, première frame et Enter/Escape relues dans le vrai éditeur. Les tests de12cas cités dans le lot boutique sont hérités, pas relancés ; ils ne prouvent ni IME natif ni navigation clavier globale. Les consommateurs/faits natifs chat,logicalE9,input98,movie4 restent distincts.
Aucun jeu, Rust, GUI, réseau, presse-papiers réel, REA ou émulation originale exécuté dans ce lot. Aucun reçu autonome code0 inventé pour les anciens lots focus/boutique. La relecture focus v2 est retenue ; la première preuve demeure conservée.

## Écarts et suite
Les limites sont déjà établies et leurs tâches/corrections existent ; aucun nouveau défaut de layout mesuré dans ce lot de pertinence. La prochaine inspection doit identifier le vrai consommateur avant de proposer un travail produit.

Trois clauses ouvertes : police/glyphes et lisibilité rendue ; focus/navigation et consumers absents ; contraintes/mesures de débordement. Les clauses ne sont pas closes par ce simple inventaire. Sources UI et cas réels seront nommés avant toute nouvelle recette.

Prochain lot minimal : AUD-17.5-06-SHOP-SEARCH-LAYOUT-01. Champ de recherche boutique uniquement : retrouver les vrais constructeurs/mises à jour Text, la police réellement liée, les dimensions et wrapping/clipping/mesures ; comparer ce contrat à append64.

## Sept rubriques et livraison
- 1 : SYS-17.5-06 exact, three clauses, baseline-only scope.
- 2 : V795, callback and provider separately retained; no original mounting/render inferred.
- 3 : Shop text/font parser and inherited focus/shop consumers verified unchanged.
- 4 : Actual documentary/source controls; old native/Rust tests not rerun; no GUI, clipboard or network.
- 5 : All three parent clauses still incomplete; 64scalar and alias/lookup limits explicit.
- 6 : Existing work retained, no measured new product defect; justified no duplicate correction.
- 7 : Dated immutable proof and report, distinct reader, unchanged corpus and registers.

Livrables : ce rapport, entrées/spécification, preuve, producteur/lecteur et reçus dans `F:\OpenLeague-work\audit-units\AUD-17.5-06-TEXT-FOCUS-BASELINE-01`. Tous les fichiers préexistants sont conservés ; aucun goal, critère normatif, code produit, application de suivi, registre ou base modifié.
