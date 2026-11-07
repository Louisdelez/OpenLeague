# AUD-17.5-01-CURRENT-INPUT-CENSUS-01

UTC: 2026-10-31T04:28:01.701849+00:00. Parent SYS-17.5-01, exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et fin du lot
Recenser les acquisitions primitives d’entrée du clientRust et vérifier leurs enregistrements/consommateurs;relier les78IDs HUD courants déjà audités sans les compter de nouveau. Le lot inclut une transition saisie-boutique→commande dans une même frame et une seule fiche de reprise. Fin documentaire:24fichiers candidats tous classés,13routes sources ordinaires identifiées et cas conditionnel précisément borné. Aucun changement produit,aucun succès fonctionnel ou parent/goal complet revendiqué.

## R2 — Sources et preuves réutilisées
Le corpus1168sources et la référence4.20.0.315 EUW/en_GB restent identifiés. Le précédent recensement32fichiers/703ressources natives est conservé avec ses ZIP/PE et restaurations;pas de recherche native répétée. Huit audits d’états existants QWER,invocateurs,objets,drag,minimap/caméra,session,boutique et commandes locales sont relus avec leurs empreintes et rapports. Entrées normatives et prérequis du paquet inchangés.

Nouvelle question:quels fichiers acquièrent réellement les primitives clavier/souris/Interaction,et leur ordre protège-t-il une touche déjà possédée comme texte quand Enter relâche le focus? Recherche bornée reproductible et patrons conservés dans la preuve. Les neuf groupes MessageReader sont des préfixes lexicaux,notamment AssetEvent<> tronqué au premier >;ce n’est pas un parseurRust ni une preuve de typage compilé.

## R3 — Routes et états
| Fichier candidat | Classe | Entrée / consommateur | Périmètre |
|---|---|---|---|
| camera_lock.rs | comment_only | Setting API, no primitive input acquisition | ButtonInput token appears only in comment, typed setting has no backend reader |
| camera_lock_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| camera_lock_ui.rs | ordinary | camera_lock_ui::update / Capture::collect | CAMERA-LOCK via owned pointer gesture, shared state with Y |
| camera_lock_ui_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| endgame_ui_observation.rs | opt_in_programmatic | drive runs no gesture when Host.directory=None | OPENLEAGUE_ENDGAME_UI_OBSERVATION; programmatic Continue/Return, no physical user evidence |
| endgame_ui_observation_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| main.rs | ordinary | commands/item_hotkey,camera,labels | QWER/Learn,D/F,items; world Stop/Move/Attack and camera wheel are adjacent routes; F3 local diagnostic |
| native_endgame_ui.rs | ordinary | native_endgame_ui::update | ENDGAME-CONTINUE: visible armed release |
| native_hud_inventory_drag.rs | ordinary | drag::input via native_hud_inventory::Plugin | INVENTORY-DRAG, reset/cancel owned gesture |
| native_hud_inventory_drag_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| native_hud_learning.rs | ordinary | native_hud_learning::input | four LEARN controls, no new controls per arrow/frame |
| native_minimap_input.rs | ordinary | input::input via native_minimap::Plugin | MINIMAP-CAMERA-PAN/MINIMAP-MOVE |
| native_minimap_input_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| ordinary_camera_input.rs | ordinary | collect→drive via ordinary_camera_input::Plugin | shared CAMERA-LOCK Y; Space/arrows/edge camera navigation adjacent, not extra HUD button IDs |
| ordinary_camera_input_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| ordinary_pause.rs | ordinary | collect→drive via ordinary_pause::Plugin | MATCH-PAUSE key and button share one request state |
| ordinary_pause_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| render_probe.rs | ordinary | render_probe::window_options | LOCAL-WINDOW-MODE F11 always registered; screenshot capture separately opt-in |
| session_departure.rs | ordinary | session_departure::return_button / on_exit | RETURN-LAUNCHER; AppExit hook is lifecycle not another clickable control |
| shop_text_input.rs | ordinary | text_input::Input::update called by shop_ui::update | SHOP-SEARCH editor helper, not separately scheduled input receiver |
| shop_text_input_tests.rs | test_only | cfg(test) source module | Fixtures/injections, no ordinary game input consumer |
| shop_ui.rs | ordinary | shop_ui::update | 53existing shop controls/instances, not one control per keyboard event |
| six_client_match_observation.rs | opt_in_programmatic | Plugin returns before adding observation systems without ENV | programmatic observed gestures, no additional ordinary user controls |
| spell_input.rs | ordinary | spell_input::collect→Shortcuts→main::commands | QWER/Ctrl+QWER collector; legacy pressed_slot helper not actual ordinary dispatch |

Les13sources ordinaires portent plusieurs routes ou helpers,les huit fichiers tests ne sont pas chargés comme contrôles ordinaires. camera_lock.rs mentionne ButtonInput uniquement en commentaire;son API Setting partagée n’acquiert pas le clavier. spell_input::pressed_slot comporte une déclaration et trois lignes d’appel de tests dans spell_input/native_hud_learning;les gardes cfg(test) correspondants sont conservés;la vraie route est collect→Shortcuts→commands. shop_text_input est un helper appelé par shop_ui,non un système enregistré séparément.

Enregistrements vérifiés:plugins spell/caméra/pause/learning,aliases drag et minimap dans leurs parents,collect en PreUpdate après InputSystems,Update chaîné receive→shop_ui::update→commands→camera puis autres vues. Continue/Return et on_exit sont enregistrés séparément. F11 ordinaire reste distinct de capture screenshot opt-in. Y et bouton caméra partagent leur état. Stop/Move/Attack et navigation caméra Space/flèches/bords/molette sont des routes adjacentes de monde/caméra,déjà séparées des IDs de widgets HUD;aucun contrôle nouveau artificiel par touche ou helper.

Les deux observateurs programment Interaction/ButtonInput:la conduite endgame ne fait rien sans directory configuré;le plugin six-client quitte avant ses systèmes sans ENV. Leur présence dans le code ne prouve ni utilisation humaine ni clic physique. Aucun observateur n’est lancé ici. Les événements d’assets et AppExit sont des entrées de cycle de vie,non des boutons supplémentaires.

### Transition conditionnelle à qualifier
Préconditions:joueur local Garen prêt,Q de rang non nul,pas de victoire,captures concurrentes ni priorité item/D/F/S;fenêtre primaire focalisée,session stable et aucun focus perdu. Boutique ouverte et saisie déjà active depuis une frame antérieure;Q frais avec texte q puis Enter reçus dans la même frame,sans modificateur.

1. PreUpdate spell_input::collect mémorise Q(slot0,learnfalse);Enter ne retire pas cet intent.
2. shop_ui::update appelle l’éditeur actif:le texte q est ajouté,puis Enter met focused=false,recopié dans Filters.
3. commands arrive après shop dans la chaîne:son garde voit le focus final false et selected Q reste disponible;sur Garen la branche non ciblée construit Cast{slot0,targetNone} puis atteint send_action.
4. Aucun envoi ni cast réussi observé:la connexion ou le serveur peut encore refuser. Cette trace est déduite du code,non exécutée enRust/GUI.

Nominal Q sans fermeture:focus final true bloque commands. Enter seul:aucun Q frais donc aucune intention Q déduite. Perte de focus:collect réinitialise et abandonne la frame. La frame suivante vide les intents précédents;un nouveau keydown est un autre événement. Le risque source porte sur la libération de capture dans une même frame,non sur un replay inter-frame avéré. Le comportement attendu proposé est une propriété locale d’événement:un Q déjà possédé comme texte ne doit pas devenir combat parce qu’Enter a libéré le champ plus tard. Aucune parité native déduite.

## R4 — Attendu, observé et contrôles
Première tentative conservée:le contrôle attendait deux références du helper legacy dans un seul fichier;la recherche exacte en trouve quatre dans deux fichiers. Trois lignes d’appel sont dans des tests gardés cfg(test),la quatrième est la déclaration. La version2 corrige cette hypothèse et préserve script/reçu en échec;aucun résultat ni rapport de la version1 n’avait été produit. Un second échec de sérialisation JSON a laissé un fragment invalide,conservé avec son reçu. La version3 compare les mêmes identités par listes triées et encode avant création exclusive;le fragment invalide ne devient pas une preuve de réussite.

Exécuté ici:Python de lecture,empreintes,recherche exhaustive des patrons déclarés dans les fichiers client présents,classification et fragments exacts/ordre d’enregistrement.19tests CPU hérités (12éditeur,7shortcuts ordonnés) retrouvés passants dans le journal terminal code0,sources actuelles égales au manifeste conservé. Le test des lecteurs indépendants vérifie qu’un autre curseur lit encore quatre événements après l’éditeur:events.clear de ce lecteur ne signifie pas suppression globale.

La fixture existante installe seulement son drive éditeur;elle ne contient pas shop_ui::update suivi du vrai main::commands. Ces19réussites ne qualifient donc pas Q→Enter à travers les deux consommateurs. Aucun nouveau testRust,natif,jeu,GUI,réseau,clavier physique ou lecture du presse-papiers;zéro test intégré capture-release exécuté. Le binaire de test historique est nommé/haché dans la preuve,sans requalification de son état actuel.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Account for every bounded primitive-input source hit | 24files classified13ordinary,8tests,2opt-in observers,1comment-only; nine lexical MessageReader prefix groups recorded. | Textual API census,not compiled call graph or Bevy backend/runtime proof; alias/reflection/external-library callbacks not enumerated. |
| C2 | Link actual schedule/callers | Ordinary plugin/update registrations and module aliases pinned; collector/helper/intent receiver distinct;78IDs mapped to eight prior state audits. | Not24controls or13features; shared Y/camera button and hotkey/button family counted once. |
| C3 | Do not count synthetic programmatic clicks as human controls | Endgame observer no-op without directory; six-client plugin returns without ENV; tests and camera_lock comment excluded. | No observer/installer/app executed, no physical UI evidence claimed. |
| C4 | Check cross-consumer capture ownership | Named source-derived Q→Enter condition reaches intent-construction/send boundary after final shop.focused becomes false. | No runtime or actual successful cast observed; source path conditional on explicit preconditions and proposed local policy. |
| C5 | Reuse existing tests with their true scope | 19retained text/ordered shortcut tests pass, including independent reader assertions; fixture only installs editor drive. | Not an integrated shop update→main commands/capture release test; no fresh Rust test or native parity claimed. |
| C6 | Preserve open scopes and precise resume work | One new capture-release correction, existing focus and pointer tasks reused; native Flash/profile/current unknowns still explicit. | No registry/goal/criteria/product/Plan/DB mutation; all-HUD parent remains open. |

## R5 — Manques et conditions de reprise
Ce recensement de code est borné aux APIs/patrons déclarés;il ne représente pas un callgraph compilé,les backends de la bibliothèqueBevy,des callbacks externes/reflection/alias non nommés ou tous les contrôles natifs. Les menus/movies Flash,profils et callbacks dynamiques restent à réconcilier avant clôture du parent. Native/input/runtime et physique restent distincts.

Pour la transition boutique:aucune nouvelle recherche ni source externe nécessaire pour la reprise locale. Il faut une autorisation produit,une politique explicite de propriété de capture,puis un cas intégré des vrais systèmes avec mêmes événements et état. La preuve doit s’arrêter au niveau réellement observé:construction d’intent,soumission,refus/ack et effet de jeu sont des étapes distinctes. Source native supplémentaire nécessaire seulement pour revendiquer la fidélité historique de cette politique.

## R6 — Correction précise et rattachement
Réutiliser SELF-FOCUS-CONFLICT-01 pour les propriétaires/focus/captures et HUD-SHOP-POINTER-CONTEXT-01 pour le contexte souris/fenêtre;ce dernier ne qualifie pas la libération clavier dans la même frame. Trois tâches existantes sont relues avec leurs critères:SYS-07.5-02,SYS-17.4-08,SYS-22.3-03. Le chat reste un chantier distinct,non une fonctionnalité créée par ce lot.

### HUD-CAPTURE-RELEASE-FRAME-01
Qualifier la barrière de capture boutique lors d’une libération de focus dans la même frame qu’une touche de sort.

Travail:
- Définir explicitement la politique locale de propriété d’événement pendant la saisie; nommer la durée de capture et ne pas déduire une fidélité native depuis cet exemple.
- Réutiliser Shortcuts et éditeur existants; suivre Q(text q)→Enter de la saisie déjà active jusqu’au vrai commands/send_action sans lancer le presse-papiers.
- Qualifier capture puis relâchement/focus/window/session et comparaison avec Q sans Enter,Enter seul,frame suivante fraîche; corriger uniquement sous autorisation produit.

Fin:
- Une fixture intégrée du vrai collecteur+shop update+commands démontre l’absence d’intention de combat pour le Q possédé comme texte selon la politique choisie; aucune transmission n’est appelée succès sans reçu.
- Le Q nouveau après libération fonctionne dans le contexte autorisé; les nominal/refus du champ,événements indépendants,modificateurs et pertes focus/session restent conservés.
- Sources,binaire,événements,attendu/observé identifiés; acceptation physique et parité native restent distinctes.

Reprise: Sources et consommateurs présents,aucune nouvelle recherche requise. Autorisation produit et politique locale de capture explicite,puis preuve intégrée de ce seul parcours; natif callback nécessaire seulement pour revendiquer la parité historique.

Proposition non appliquée,critères normatifs et statuts inchangés.78IDs existants reliés une fois aux huit audits d’états;aucun nouvel ID de contrôle produit,aucun pourcentage ni dénominateur complet. Reste: Bounded ordinary current input-source census is closed only by independent reader; finish native Flash/menu/dynamic control inventory and reconcile every remaining family before parent SYS-17.5-01 closes. Source-derived shop capture-release witness needs authorized integrated current execution and explicit policy; missing functionality/physical acceptance are not solved by this document. Native callbacks/profile selection and all remaining resolution/focus/readability parent clauses retain their own tasks and scope; no global denominator/percentage.

## R7 — Livraison et conservation
Nouveaux fichiers uniquement:audit-unit.json;producteurs versions1/2 et reçus attempt-1-failure.json/attempt-2-failure.json conservés;current-input-census-proof.json conservé comme fragment invalide;verify_current_input_census_v3.py et current-input-census-proof-v3.json;lecteurs versions1/2 préparés non exécutés,verify_delivery_v3.py,delivery-readback-v3.json et ce rapport-v3. Producteur audit_scope_closed=false;relecture séparée des sept rubriques pour clore uniquement le recensement borné et la documentation du risque source. parent_documentary_scope_closed=false,fonctionnalité/goal non terminés et acceptation humaine non revendiquée.

Cinq registres normatifs,25fichiers protégés,1168sources et état suiviGit conservés. Aucun goal/critère/code produit/Plan/UI/base modifié,aucune base ouverte,installation,migration,retrait ni relance. Les preuves antérieures restent conservées.

Preuve: F:\OpenLeague-work\audit-units\AUD-17.5-01-CURRENT-INPUT-CENSUS-01\current-input-census-proof-v3.json. Relecture: F:\OpenLeague-work\audit-units\AUD-17.5-01-CURRENT-INPUT-CENSUS-01\delivery-readback-v3.json.
