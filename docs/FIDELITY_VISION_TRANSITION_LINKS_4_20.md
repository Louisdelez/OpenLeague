# Transitions de vision — liens V107

Les sections de recherche suivantes précèdent l’intégration ;le reçu final distingue sa vérification effective.

# Transitions de vision pendant les sorts — recherche V107

Objectif SYS-01.2-02 ;exigences SYS-13.4-01 à07. Le tour précédent V106 a intégré sept exigences et vérifié les deux bases. Cette étape ajoute une preuve comportementale manquante avant de relier le lot suivant.

## Limite découverte dans les preuves antérieures

Le helper game() des tests inline Annie Q/W construit une grille synthétique sans enable_map10. visible_to rend true lorsque les interactions sont absentes. Leur test nommé dead_target_dissipates_without_mana_refund_and_snapshot_filters_visibility vérifie une cible morte,mais ne crée pas de perte de vision active. Il ne doit pas être utilisé pour qualifier les transitions cachées.

## Quatre contrôles nouveaux

crates/core/tests/vision_transition_observation.rs utilise les API publiques Simulation/Action. La grille est synthétique,Map10 est activée,puis les unités de décor/jeu sont retirées pour isoler deux champions. Le rayon du lanceur est réduit à zéro par son modificateur pour forcer la perte de vision. Ce contrôle n'est ni un déplacement réel hors portée ni un état d'invisibilité de champion.

1. Une cible déjà cachée est refusée sans dépenser mana/cooldown ni produire de projectile.
2. Une cible perdue pendant le cast engagé de Q reste ciblée ;le projectile est émis et endommage la cible,mais n'est pas dans le snapshot du lanceur pendant qu'elle est cachée.
3. Une cible perdue après émission est encore touchée par le Q courant ;le projectile est absent de la projection du lanceur.
4. Le cône W local peut endommager l'ennemi caché sans publier son état dans le snapshot du lanceur.

Les quatre tests ont été réellement exécutés et passent. Le reçu transition-test-receipt.json conserve commande,log,binaire et sources.24 avertissements du core préexistaient dans la compilation ;ils ne sont pas corrigés par ce lot. Aucun code de gameplay n'est modifié.

## Limites et suite

Les résultats décrivent les politiques locales d'Annie seulement. La fidélité native et les autres sorts restent à qualifier. Examiner ensuite dash vers cible cachée,vision des invocations et leur disparition,mort/résurrection et sélection/délai spectateur. Le filtre spectateur client existant décrit des masques ;il ne prouve pas un service réseau à délai de spectateur.

SYS-03.4-07 reste ambigu :le plan ne nomme pas son candidat d'archives ;une clarification a été demandée pendant la poursuite de ce travail indépendant. Aucune spécification AnvilKit n'est promue automatiquement en référence voulue.

Préparer les associations et le lecteur du lot après ces recherches,puis intégrer au registre et aux deux bases. V106 reste la dernière livraison intégrée ;aucune case modifiée et aucune exigence complète déclarée.


# V107 — complément vision, cycle de vie et spectateur

Trois tests exécutés, trois réussites. Commandes, noms, logs, binaires et SHA-256 des sources sont dans lifecycle-spectator-receipt.json.

Le nouveau test crates/core/tests/vision_lifecycle_observation.rs utilise la navigation Map10 réelle et les API publiques. Après retrait des autres unités, la mort réelle du champion par apply_damage retire sa contribution de vision et cache la cible dans snapshot_for. Un délai de réapparition forcé au tick suivant déclenche le consommateur advance_respawns réel : vie, visibilité et publication de la cible sont rétablies. La durée historique de mort n'est pas vérifiée.

Le second test invoque effectivement Tibbers avec R après apprentissage. Le rayon du champion est annulé pour isoler celui du familier. La cible cachée devient visible après l'invocation puis disparaît du snapshot après expiration réelle du familier. L'horloge est avancée directement au délai d'expiration : cela ne simule pas une partie entière.

Le test client existant du filtre spectateur passe sur ses 2304 vecteurs natifs hérités. Cette exécution fraîche concerne le code Rust et le contrat enregistré, pas le binaire historique, le GPU ou un protocole spectateur retardé. Les avertissements existants restent présents :24 core,199 client.

Aucun code de gameplay modifié. Les quatre tests précédents et leur reçu restent intacts. V106 reste la dernière intégration au registre. Suite : examiner les consommateurs des déplacements ciblés, préparer les liens SYS-13.4 puis qualifier et intégrer le lot. Goal actif ; aucune case ou acceptation modifiée.


# V107 — associations préparées et lecteur qualifié

Sept exigences SYS-13.4, quatorze rôles précis. Six exigences restent partielles ; le dash ciblé reste une frontière explicitement non implémentée par les consommateurs examinés. Le dispatcher ciblé prend Annie/Trundle/Garen ; Ezreal E exige un point au sol. Le test de disparition de sa cible de projectile porte sur une mort, pas sur une perte de vision : aucune assimilation à un dash ciblé.

Le relevé lexical borné porte sur639 fichiers Rust core et contient3 lignes correspondant aux mots entiers dash/blink. Il n'est pas une preuve d'absence globale ; les dispatchers réels sont les points d'entrée retenus.

vision-transition-associations.json fixe les ancrages, constats, limites et inconnues existantes. audit_vision_transition_reference.py vérifie31 fichiers,73 contrôles et les reçus des7 tests comportementaux exécutés dans cette révision. Sa qualification réussit33 cas :un nominal et32 refus de modifications de portée, source, ancrage ou preuve. Ce sont des contrôles documentaires distincts des sept tests Rust.

Les politiques serveur historiques restent inconnues. Les vecteurs du filtre spectateur sont hérités ; le test Rust a été exécuté, pas le jeu historique. Aucun délai réseau n'est qualifié. Aucun gameplay ni aucune case du plan modifié.

Prochaine action : intégrer les liens au registre via le producteur transactionnel en préservant sources, états manuels et inconnues ; vérifier les deux bases et refaire le contrôle global. Le lecteur préparatoire utilise son propre dossier de travail ; fixer explicitement le chemin V107 avant son installation dans tools/project-plan, puis requalifier sa version installable. V106 reste la dernière livraison intégrée.


## Livraison

Lecteur installable à chemin V107 explicite,requalifié sur33 cas. Les références natives déjà présentes sont préservées ;aucune politique serveur native inventée. Sept exigences partielles ou frontières et le Goal restent ouverts. Résultat de livraison dans docs/fidelity_registry_vision_transition_links_revision_4_20.json.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-13.4-01 | Annie Q refuses a hidden target before commitment without spending; Map10-enabled public test. | Other targeted casts, exact loss ordering and historical server policy remain unqualified. |
| SYS-13.4-02 | Current committed or released Annie Q continues to damage a subsequently hidden target while its projectile is filtered from owner snapshot. | All projectile families and historical policy remain unqualified; radius-zero test is not actual stealth. |
| SYS-13.4-03 | Public targeted dispatcher supports scoped Annie/Trundle/Garen paths; Ezreal E explicitly takes a ground point. No targeted dash behavior is established by these consumers. | Identify and qualify a true targeted dash and its visibility transition; never substitute ground blink or a homing bolt. |
| SYS-13.4-04 | Current Annie W damages a hidden enemy in its cone without publishing that enemy in owner snapshot. | All AoE families and native server selection policy remain unqualified. |
| SYS-13.4-05 | Actual R creates Tibbers,whose vision reveals an enemy when owner vision is zero; expiration removes this contribution. | Other summons, owner death, radius/visibility boundary combinations and native server semantics remain unqualified. |
| SYS-13.4-06 | Actual lethal damage removes champion vision and snapshot presence of the observed enemy; due respawn restores both. | Historical death timer, resurrection spells, other sources and full-match scheduling remain unqualified. |
| SYS-13.4-07 | Current spectator source/mask filter passes inherited 2304 native vectors; actor/context providers are supplied. | Delayed spectator network stream, full team-view pipeline and historical runtime remain unqualified. |

Reçu : docs/reference_vision_transition_sources/vision_transition-links.json. Livraison : docs/fidelity_registry_vision_transition_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
