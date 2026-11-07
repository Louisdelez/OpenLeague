# SYS-17.5-06 — clavier et focus de la recherche boutique

Unité AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01 ; UTC 2026-11-01T12:45:11.049520+00:00

Audit de ce contrôleur terminé sous réserve du lecteur distinct. Parent SYS-17.5-06 ouvert ; implémentation partielle, aucune recette clavier/GUI ni acceptation humaine. Goal SYS-01.2-02 actif et inchangé.

## 1. Portée et contrat
Vérifier lisibilité, focus clavier et absence de débordement des textes
Recherche boutique seulement ; sources des callbacks et comparison du contrôleur courant. Les phases déclarées ne constituent pas un ordre de dispatch natif exécuté.

## 2. Référence et provenance
FoundryItemShop.gfx, SearchArea/ItemShopRoot et exports déjà identifiés réutilisés. KeyboardNavigation et itemdata/ItemButtonListFactory sont les consumers supplémentaires lus. Le premier chemin supposé de factory était absent (OS error2, chunk fab2fc), puis localisé sous itemdata : le manque de chemin n’est pas une absence de fonctionnalité.
Une recherche de61hits dans trois exports est conservée avec argv/code0 et sortie ; pas61tests ni un catalogue de toutes les commandes. Aucun ancien test ou export relancé.

## 3. Consommateurs, phases et comportements

### CAPTURE-RELEASE
Original source : Text focus or keyboardNav marks search focus. Exclusive host calls and listener registration/unregistration are explicit; close/focusSearch public callbacks exist.
Courant source : Local focused bool plus window/identity/lost guards; commands guard shop.focused.
Écart : No source equivalence between native host capture and local Boolean/OS focus; retain the binding boundary.
Limite : No host binding, OS capture or whole-game suppression verified.

### TAB
Original source : KEY_UP Tab, after guards, sets keyLock, hides search and releases control; root KEY_UP clears keyLock.
Courant source : No explicit Tab transition in this editor match; text control characters are filtered by append.
Écart : Do not replace native Tab behavior with an assumed focus-next rule.
Limite : Listener priority on root does not prove global dispatch ordering between target/root or host.

### ESCAPE-PHASES
Original source : Root KEY_DOWN Escape calls closeShop before the visible/keyLock guard; guarded field KEY_UP Escape calls clearSearch.
Courant source : Shop update clears focused on Escape; editor also clears focused when its modifier/gate path permits. Those branches do not themselves clear query or close shop.
Écart : Keep key-down and key-up paths separate; do not summarize original Escape as only clear or always closed.
Limite : Effective ordering, host close response and physical frames are not executed.

### ENTER-MODES
Original source : Field Enter/NumpadEnter can enter navigation only with visible dropdown and no IME; root Down also enters it. Nav Enter checks modifiers, activeItem and purchase Boolean before clearing/releasing.
Courant source : The local Enter branch releases text focus when reached; it does not select or activate a search result.
Écart : Saisie and navigation are separate native states, not equivalent to the single local focus transition.
Limite : Physical Numpad mapping, event order and successful server purchase are not inferred.

### ARROW-SELECTION
Original source : Populate resets/registers entries; navigation guards empty lists, changes position for four arrows, selects/highlights, scrolls and stores activeItem.
Courant source : Named local editor match and presentation have no corresponding search-navigation transition/state.
Écart : Native result-selection behavior is missing from the compared controller; ordinary pointer selection remains separate and preserved.
Limite : No exhaustive grid-shape/bounds theorem, native render or all-client keyboard inventory.

### EMPTY-OR-REFUSED
Original source : Zero totalItems returns; absent activeItem cannot activate; false purchase Boolean does not enter the clear/release branch. purchaseItem delegates to Player.
Courant source : Existing pointer BuySelected guard and authoritative route remain; no search-keyboard activation is supplied by it.
Écart : A source Boolean is not newly qualified as a network acknowledgement.
Limite : Player backend and server acknowledgement are not re-audited by this UI keyboard lot.

### FOCUS-OUT-AND-LOCK
Original source : Focus-out returns while navigation enabled, otherwise reacquires text focus while focusLock>0 or hides/releases. Mouse callbacks assign/decrement the lock.
Courant source : Lost window/reset and identity/activation guards belong to local editor; no equivalent dropdown lock state is established.
Écart : Native UI lock and real Windows focus are different predicates.
Limite : No input-arbitration schedule, pointer dispatch or OS focus accepted.

### MODIFIERS-IME
Original source : IME controls entering nav on field key-up; Shift/Ctrl/Alt guard root navigation activation. These are distinct guards.
Courant source : Ctrl+V, right-Alt/AltGr and shortcut suppression are local editing policies; Enter/Escape act only after those gates.
Écart : The12inherited text cases are not native IME or modifier equivalence tests.
Limite : No fresh keyboard, paste closure, clipboard, IME or AltGr run.

### CALLBACK-ORDER
Original source : Root KEY_DOWN/UP registrations, field KEY_UP and timer callbacks have named phases; target/root dispatch and external host are not executed.
Courant source : Receive→shop update→commands is chained; focus can change before the command gate reads it.
Écart : A source order is not proof of a concrete same-frame combat leak or universal suppression across bindings.
Limite : No physical event chronology, current binding reachability or GUI/gameplay frame observed.

## 4. Attendu / observé et contrôles
Attendu de l’audit : relier les registrations et transitions aux bons consommateurs, distinguer saisie/nav/activation et les refus. Observé : les sources remplissent les neuf comparaisons ci-dessus ; les cas de liste vide, actif absent, achat Boolean false, lock/visibilité et fenêtre/identité locales sont identifiés. Aucune transition n’a été simulée ou exécutée.
Le Root KEY_DOWN Escape appelle closeShop avant ses gardes ; le field KEY_UP Escape appelle clearSearch après ses gardes. PRIORITY_INCREASED est une propriété de registration, pas une preuve d’ordre global. La navigation indique sélection/highlight/scroll en source ; aucun pixel ou index invalide n’est expérimenté.
purchaseItem s’arrête à la délégation Player.purchaseItem et son Boolean. Ni cette valeur ni le mot SUCCEEDED dans un événement ne démontrent ici une confirmation serveur.
Update receive→shop→commands et la garde shop.focused sont vérifiés ; aucun passage réel de commande de combat ou preuve de suppression globale déduit du même frame.
Contrôles exécutés : empreintes, fenêtres exactes, locator conservé et invariants. Les12cas texte du lot boutique sont hérités et limités ; aucun clavier, IME, AltGr, presse-papiers, Bevy/Rust, AS, jeu, GUI, réseau, REA ou FFDec exécuté.

## 5. Écarts et reprise

### NATIVE-HOST-AND-DISPATCH
Liaison effective take/releaseExclusiveControl/closeShop au client natif, ordre réel target/root/host et phases IME non qualifiés.
Reprise : Nouvelle piste précise de binding/observation native nommée ; conserver les callbacks et phases plutôt que refaire une recherche générale ou simuler leur ordre.

### CURRENT-SEARCH-KEYBOARD-CONTROLLER
États de navigation, sélection/scroll clavier et activation du résultat ne sont pas dans les consumers courants comparés ; réalisation et recette restent ouvertes.
Reprise : HUD-SHOP-SEARCH-KEYBOARD-01 avec états/autorité/cas admis et travail produit séparément autorisé ; réutiliser les deux tâches existantes.

### HUD-READABILITY-AND-GLOBAL-FOCUS
Ce champ ne couvre ni tous les textes/overlays, ni la recette visuelle, l’arbitrage complet et le focus OS réel.
Reprise : Lot suivant sur la pertinence des preuves GPU de texte existantes, puis consumers/cas restant nommés ; ne pas relancer des essais inchangés.

## 6. Correction atomique proposée, non appliquée
HUD-SHOP-SEARCH-KEYBOARD-01 — Raccorder les états clavier de saisie et navigation de la recherche boutique.
Le contrôleur courant libère le focus sur Enter/Escape et n’exprime pas la navigation des résultats du contrat source SearchArea/KeyboardNavigation. Les phases natives et l’autorité de capture restent à qualifier.
Travail : Définir les états et événements à partir des callbacks originaux identifiés : saisie, résultats/navigation, fermeture et reprise. Relier sélection/highlight/scroll et activation aux consumers réels et transactions existantes, en gardant distinct refus local, envoi et confirmation. Résoudre ou laisser explicitement ouverte la liaison native de capture et l’ordre des phases ; ne pas inventer un ordre depuis PRIORITY_INCREASED.
Critère : Sur le vrai champ, Tab/Enter/Escape/flèches, liste vide/non vide, activation refusée/admise, modificateurs, IME et perte de focus suivent le contrat identifié. Les états texte et navigation sont distincts ; sélection/scroll et refus d’activation sont observés avec contexte/build/assets nommés, sans assimiler un booléen source à une confirmation serveur. Les autres widgets et le catalogue historique complet restent qualifiés séparément.
Reprise : Contrat natif/host et phases précisés ou politique locale versionnée avec l’écart de fidélité ouvert ; travail produit/exécution sous autorisation distincte. Réutiliser les sources et tâches présentes.
Preuves attendues : Matrice événements/états/gardes, vrais consumers, contexte et traces/captures clavier ; absence/présence de résultat et activation refusée/admise, sans faux acquittement ni fuite de commandes de combat.

SYS-07.5-02 et SYS-07.5-07 sont réutilisées avec leurs critères exacts. HUD-SHOP-SEARCH-LAYOUT-01 et HUD-SHOP-POINTER-CONTEXT-01 conservent leurs définitions. Les liens au parent indiquent l’origine, sans ordre exécutable inventé.
- Réutiliser SYS-07.5-02 pour la recherche et la population des résultats ; le layout déjà proposé demeure distinct du contrôleur clavier.
- Réutiliser SYS-07.5-07 pour l’activation et son refus autoritaire ; ne pas traiter Player.purchaseItem Boolean comme une preuve serveur.
- Conserver HUD-SHOP-POINTER-CONTEXT-01 pour le contexte pointeur ; ne pas le renommer ou modifier ses critères depuis ce lot clavier.

## 7. Relecture et limites de clôture
- 1 : Recherche boutique seulement et task/prérequis inchangés.
- 2 : Exports d’origine, enregistrement, états et backend boundary identifiés ; host/ordre/IME ouverts.
- 3 : Éditeur courant, focus booléen, garde commands et ordre Update vérifiés sur sources.
- 4 : 61hits de source, fenêtres et neuf comparaisons conditionnelles ; aucun AS/Rust/GUI ou entrée physique exécuté.
- 5 : Captures native/local/OS, phases Escape, modifiers et booléen achat non confondus.
- 6 : Un contrôleur clavier atomique proposé ; recherche/transactions/layout/pointeur existants conservés avec critères exacts.
- 7 : Livrables datés, relecture distincte et guards Git/source1168/registres ; aucun statut normatif modifié.

Correction documentaire v2 : le drapeau new_current_source_query devient true ; les lignes1366/1381 du locator fab2fc sont conservées. Première preuve/rapport/reçu (producteur code0) préservés ; matrice, fenêtres et correction produit inchangées. Ce défaut de métadonnée n’est pas un défaut du jeu.

Le périmètre de source de la recherche clavier peut être clos ; host/dispatch, implémentation, autres widgets et vérification de rendu restent ouverts. Aucun goal, critère normatif, code produit, Plan, application de suivi, registre ou base modifié. Livrables nouveaux : ce rapport et `F:\OpenLeague-work\audit-units\AUD-17.5-06-SHOP-SEARCH-KEYBOARD-01` (entrées/spécification, locator, producteur/preuve, lecteur/reçus). Preuves et fichiers antérieurs conservés.
Prochain lot : AUD-17.5-06-TEXT-GPU-EVIDENCE-01 ; preuves de texte GPU existantes, sans relancer les essais inchangés.
