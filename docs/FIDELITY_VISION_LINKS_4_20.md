# Vision et brouillard — liens de sources V104

Sept exigences liées à15 rôles actuels. Quatre consommateurs partiels ;trois frontières. Aucune exigence de gameplay clôturée.

## Recherche antérieure conservée

Les sections suivantes décrivent les étapes préparatoires datées. Leurs mentions « non intégré » décrivent ces étapes seulement. La livraison finale et son audit sont identifiés dans la section finale.

# Vision — recherche préparatoire V104

Objectif SYS-01.2-02, exigences SYS-13.1-01 à07. Recherche de sources et de consommateurs uniquement. Le lot précédent V103 a avancé le registre et vérifié les deux bases. Cette étape produit des preuves nouvelles ;elle ne clôture aucune exigence.

## Résultats frais

150 profils du catalogue data/4.20/native_vision_radii.json ont été comparés aux fichiers INIBIN natifs :SHA-256 et valeur du champ0x6c2dcde3 concordent. Le fichier natif GamePermanent.cfg correspond à son empreinte enregistrée ;sa ligne17 déclare PerceptionBubbleRadius = 1350. La sélection locale conserve une valeur positive,sinon le défaut1350. Les sources sont épinglées dans vision-radius-source-review.json. Ce contrôle ne réexécute ni le parseur historique ni le montage des fichiers et ne renouvelle pas leur appartenance aux manifestes RADS.

Neuf tests Rust vision::tests ont été exécutés individuellement avec cargo test --locked --offline -p openleague-core --lib et --exact. Chaque sélection contient un test réussi. Les journaux,commandes et binaires sont épinglés dans vision-rust-tests.json. Les grilles synthétiques et les états contrôlés du simulateur ne constituent pas une partie historique ni une mesure GPU.

## Consommateurs et limites par exigence

| Tâche | Observation actuelle | Preuve restant nécessaire |
|---|---|---|
| SYS-13.1-01 | vision.rs native_base_radius et visible_point_to appliquent les rayons et modificateurs aux sources alliées vivantes. Tests de sélection,modificateurs et partage. | Revalider les dépendances natives de sélection/activation,les cas absents et la fidélité complète. |
| SYS-13.1-02 | Navigation::line_of_sight échantillonne tous les quarts de cellule ;bit2 bloque sauf0x40/0x100. Test de trois grilles. | Relier la grille native et ses flags ;comparer les angles et la traversée à l'algorithme historique. |
| SYS-13.1-03 | Une cible en buisson exige une origine en buisson et une continuité de cellules marquées1. Quatre cas locaux testés. | Qualification historique de la géométrie et des exceptions ;le test actuel prouve la règle reconstruite. |
| SYS-13.1-04 | visible_to traite explicitement alliés,Ignite et vision de position. | Identifier le producteur historique de révélation à l'attaque et le consommateur actuel précis. Pas d'absence globale déduite de cette seule fonction. |
| SYS-13.1-05 | snapshot_for retire les joueurs/unités hors vision ;le serveur appelle cette projection avant state_datagrams. Test de roster public et état caché. | Examiner séparément la mémoire du terrain exploré et ses couches de rendu ;aucun test réseau ou visuel frais ici. |
| SYS-13.1-06 | Les unités passent par le filtre de snapshot_for. | Rechercher les caches de derniers états publics des bâtiments dans tout le parcours ;aucune mémoire qualifiée par les neuf tests. |
| SYS-13.1-07 | fow_champion_sources synchronise les sources alliées,fow_visibility_texture publie le masque et lie les matériaux,fow_gpu possède une extraction/préparation/calcul. | Qualifier les producteurs,révisions,invalidations et pixels effectifs. Une commande GPU préparée n'est pas une preuve de pixels. |

## Détails de portée

visible_to et visible_point_to rendent true lorsque les interactions de carte ne sont pas activées,avant certains autres contrôles. Les tests frais utilisent enable_map10 pour les parcours de partie ;ne pas étendre leur résultat à tous les modes.

L'adaptateur client fow_champion_sources choisit champions,sbires,pets,tourelles/fontaines alliés vivants. Le diagnostic de ce fichier contient encore des textes gpu_bound=false et GPU fog is not bound,alors que fow_visibility_texture et fow_gpu possèdent des liaisons effectives dans le code actuel. Ce texte ne doit pas servir de preuve d'absence du rendu ;le parcours et le diagnostic doivent être rapprochés avant conclusion. Aucun code runtime modifié ici.

Le premier script d'audit utilisait le nom d'encodage invalide utf8-sig. Échec et script initial conservés ;correction utf-8-sig puis réexécution complète réussie. La recherche initiale du fichier vision_tests.rs a échoué ;le vrai module est crates/core/src/vision/tests.rs,lu et testé.

## Suite

Compléter les sources natives et contrats explicites,la qualification du lecteur et les associations précises des sept exigences,puis intégrer le registre et les deux bases avec conservation des cases et anciennes preuves. Ne pas déclarer V104 intégrée au registre à ce stade. Le Goal demeure actif.


# Vision — complément de preuves V104

Le tour précédent a produit un progrès vérifié :150 profils comparés et neuf tests core exécutés,avec état préparatoire documenté. Ce complément poursuit le même objectif SYS-01.2-02 ;il ne remplace pas la portée globale.

## Manifestes et héritage

Les150 ressources INIBIN et GamePermanent.cfg correspondent tous aux manifestes RADS sélectionnés,par chemin,taille et MD5,avec SHA-256 conservé. Les64 contrats fow_*contract.json existants sont recensés ;lorsqu'un native_sha256 est présent,il correspond au binaire natif relu. Leurs indicateurs passed sont des résultats hérités et leurs instructions originales n'ont pas été réexécutées. Le reçu vision-membership-and-contracts.json conserve chaque membre et chaque empreinte.

## Contrôles fraîchement exécutés

Trois tests fow_terrain_ray couvrent le seuil de requête,le budget épuisé,la réutilisation du cache et la traversée sur vecteurs hérités. Neuf tests fow_visibility_texture couvrent notamment cadence,erreurs,reprise,identité d'audience,images absentes,épuisement de compteurs et propriété des images. Deux tests native_fow vérifient les coordonnées et la densité de brouillard. Tous passent :14 tests client,distincts des neuf tests core du point de reprise précédent.

Les commandes cargo sont --locked --offline ;les noms sélectionnés,sorties et empreintes des binaires sont dans vision-client-tests.json. Les tests utilisent le CPU et des objets locaux ;aucun processus de jeu historique,partie complète ou relevé de pixels GPU n'a été exécuté. Une comparaison à un vecteur historique ne constitue pas une réexécution native.

## Associations préparées

vision-association-candidates.json relie les sept exigences à15 ancres exactes. Quatre exigences ont des consommateurs partiels ;trois ne disposent ici que de frontières explicites :révélation à l'attaque,terrain exploré,mémoire des bâtiments. Les recherches lexicales couvrent639 fichiers core,12 serveur et498 client. Les16 occurrences sont dans les connexions serveur,last_seen désignant leur activité. Une absence de hit ne démontre pas l'absence d'une fonction sous un autre nom.

Le serveur utilise Navigation::line_of_sight avec échantillonnage au quart de cellule. Le client utilise fow_terrain_ray::trace issu de la recherche sur6B09E0 et source_flag pour ses masques. Ces algorithmes et leurs rôles ne sont pas interchangeables. Les routes serveur legacy et session utilisent respectivement snapshot_for et snapshot_for_atomic ;les associer ne prouve pas leurs transports réseau de bout en bout.

## À poursuivre avant intégration

Finaliser les bindings natifs/contrats locaux de chaque exigence et le lecteur de vérification ;éprouver les refus de données altérées ou de portée exagérée,puis intégrer le registre et les deux bases. Conserver les questions ouvertes et les cases utilisateur. V103 reste la dernière livraison intégrée ;ce complément V104 est une recherche préparatoire vérifiée. Ne pas rejouer les producteurs immuables déjà reçus.


## Livraison finale

Le lecteur installé vérifie263 fichiers,686 contrôles source et15 ancres. Sa qualification comporte37 cas :un nominal et36 refus. Les151 fichiers natifs correspondent aux manifestes sélectionnés. Les neuf tests core et14 tests client sont des exécutions CPU fraîches conservées ;les64 contrats natifs sont hérités,non réexécutés. Le registre et les deux bases sont mis à jour pour sept exigences plus SYS-01.2-02,avec audit séparé de préservation. Les cases restent manuelles. Voir docs/fidelity_registry_vision_links_revision_4_20.json pour le résultat effectif de livraison.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-13.1-01 | Native catalogue resolves150 profiles;server uses allied living source radii and modifiers. Nine core vision tests passed. | Native activation/provider completeness,all source types and complete historical parity remain unqualified. |
| SYS-13.1-02 | Server uses quarter-cell sampling with wall/transparent flags. Client mask has separate traversal trace based on inherited6B09E0 vectors. | Do not equate the server algorithm and client mask traversal. Qualify historical server visibility,corner cases and actual terrain-provider composition. |
| SYS-13.1-03 | Server requires continuous brush cells for a target in brush. Client source_flag uses the terrain query and a separate circle selection policy. | Qualify shared brush geometry and exceptions,actual source activation and historical server behavior. |
| SYS-13.1-04 | visible_to has ally,Ignite and position-visibility branches;this is an information boundary,not an identified general attack-reveal producer. | Identify the native attack-reveal producer,timing,recipient and current implementation. No global absence claim from a single function. |
| SYS-13.1-05 | Server removes hidden units;native_fow computes visibility density from overlay alpha and visibility red. These are visibility/filter boundaries. | Persistent explored terrain state and temporal rules require separate producers and visual evidence;density arithmetic alone does not prove exploration memory. |
| SYS-13.1-06 | Server filters live unit state and session_host uses snapshot_for_atomic. No remembered building-state cache qualified here. | Identify historical public-state retention and current cache,authorize updates and test hidden destruction/health without leaking current state. |
| SYS-13.1-07 | Client synchronizes source cycles,expands and publishes CPU images,binds material handles and has GPU extraction/prepare/compute code. | Validate transport retirement,recovery,audience and actual GPU pixels in the real render path;CPU publication and prepared commands are not pixel proof. |

Reçu : docs/reference_vision_sources/vision-links.json. Livraison : docs/fidelity_registry_vision_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
