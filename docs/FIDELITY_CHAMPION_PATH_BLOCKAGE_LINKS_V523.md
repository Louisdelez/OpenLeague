# SYS-01.2-02 — Chemins et blocages des champions, V523

25 octobre 2026 — Projet F:\OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; catalogue officiel 4.20.1 distinct. Date littérale du build : 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat et défaut découvert

**244 sous-tâches sont reliées à leurs composants et frontières précis** : 122 CHEMIN et 122 BLOCAGE. Ce travail ajoute 488 occurrences de champs natifs, 2 440 liens de consommateurs, 16 nouveaux points de code et réutilise deux points déjà qualifiés. Les anciens liens de catalogue sont conservés comme contexte de métadonnées.

La collecte révèle aussi un écart réel du composant local : **46 profils n’atteignent pas le but attendu après 350 ticks lorsqu’un allié immobile occupe leur trajectoire**. Ce résultat reste un échec d’arrivée dans le budget déclaré. Il ne prouve pas un blocage infini et n’est pas une mesure de délai historique Riot.

La destination attendue est [1425,525], avec départ [225,525] et allié Garen immobile à [825,525]. Pour Ahri, la position observée au tick350 est [755.5746459960938,535.6943969726562], avec un chemin encore présent. Le rayon, la vitesse, les positions finales et l’état public sont enregistrés dans les observations. La cause exacte du défaut partagé n’est pas établie par ce lot.

Profils concernés : ahri, amumu, annie, azir, blitzcrank, cassiopeia, draven, elise, fiddlesticks, fizz, graves, heimerdinger, janna, jayce, karma, karthus, kayle, kennen, leblanc, leona, lux, masteryi, morgana, nami, nasus, nautilus, nidalee, pantheon, quinn, rammus, shen, sivir, sona, swain, syndra, teemo, trundle, twistedfate, twitch, varus, vayne, viktor, vladimir, yasuo, zac, zilean.

**92 questions précises restent ouvertes**, une par sous-tâche CHEMIN/BLOCAGE pour chacun de ces 46 profils. Chaque question conserve le résultat attendu, le résultat observé, la reproduction et une condition de résolution qui exige une vérification du comportement. Aucun des 31 344 anciens enregistrements d’inconnues n’est modifié ou fermé.

Le correctif de déplacement reste à réaliser dans ces tâches. La présente tâche SYS identifie les sources, consommateurs et écarts ; elle ne transforme pas le diagnostic en fonctionnalité terminée.

## Sources et consommateurs

Les 122 fichiers natifs de personnage sont relus et hachés. Les valeurs Data.MoveSpeed et Data.PathfindingCollisionRadius sont présentes et correspondent en f32 aux tables principales actuellement chargées. Chaque champ est lié aux deux sous-tâches du champion, d’où 488 occurrences. Ces paramètres ne constituent pas le code historique du calcul de trajet ou des collisions.

Les points de code ajoutés couvrent l’admission de Move, la navigation statique et avec pilier, la répétition des ordres, le réessai d’occupation, le parcours des nœuds de grille et virtuels, la validation du mouvement réservé, le budget de vitesse et la poursuite. Les refus mort/étourdissement/déplacement forcé/cast restent des frontières, distinctes des composants partiels de mouvement. Les lecteurs existants du rayon de pathfinding et de son emploi dans le mouvement sont réutilisés sans changer leurs rôles globaux.

La navigation statique et celle des piliers utilisent un parcours en largeur sur quatre voisins. Le routage allié combine cellules et nœuds virtuels avec un autre parcours de connexité. Le code inspecté ne justifie pas de les appeler A*. La réservation entre alliés, la priorité d’itération, les limites de six joueurs et trois alliés, le réessai à dix ticks, l’exclusion des ennemis et le terrain traité comme un agent ponctuel restent des politiques locales reconstruites.

Le reçu distingue partial_component_ids, boundary_only_ids et retained_metadata_context_ids. Il ne change pas le lecteur générique pour promouvoir un catalogue en consommateur de fonctionnalité. Les limites natives antérieures, notamment les formes et priorités de ressources non établies, restent conservées.

## Vérifications réellement exécutées

- Inspection des prérequis phase/fiche, champs natifs, valeurs courantes, SHA et ancres. Le premier collecteur refuse une ancre dont le numéro de ligne était erroné ; le collecteur corrigé réussit. Les essais sont conservés et aucun registre n’est publié à cette étape.
- Le premier probe ne compile pas : il demandait attack_range à Stats, qui ne l’expose pas. La reprise lit cette portée dans la définition courante identifiée, sans modifier le core. Son exécution stricte s’arrête sur l’arrivée manquée d’Ahri. Une collecte suivante atteint une autre assertion de détour sur un profil resté bloqué. Ces échecs et leurs binaires/journaux restent conservés.
- La collecte finale compile et s’exécute au code0. Elle enregistre chaque arrivée attendue non observée comme un échec, au lieu de s’arrêter au premier. Les assertions des routes effectivement terminées, des refus et des limites de déplacement sont maintenues. **collection_completed=true et all_declared_goals_reached=false restent deux résultats distincts**, vérifiés dans le reçu, les fiches, les bases et la publication.
- 122 trajets individuels sur une grille synthétique avec mur et ouverture atteignent leur but ; 122 répétitions de Move gardent l’état public exact. 610 demandes vers NaN, infini, hors-grille ou cellule bloquée sont refusées sans modifier les joueurs ni le tick.
- 122 Stop laissent la position fixe pendant dix ticks ; 122 étourdissements maintiennent l’ordre, bloquent cinq ticks puis permettent la reprise à l’expiration du sixième. 122 refus de mort et 122 refus de marqueur forcé sont vérifiés sans mutation. Le marqueur forcé est une entrée injectée ; sa trajectoire n’est pas qualifiée par ce test.
- 122 poursuites atteignent leur premier windup à portée selon le calcul courant ; 122 morts injectées de la cible annulent la poursuite. Le rayon corporel65 de la cible Garen est un repli local, distinct de son rayon de pathfinding35.
- 366 contextes de corps immobiles comparent allié vivant, ennemi et allié mort. Les deux contrôles exclus traversent le corps ; parmi les 122 cas d’allié vivant, 76 arrivent et 46 n’arrivent pas dans le budget350. 122 cas d’alliés opposés sont observés pendant100ticks : les deux acteurs bougent et leurs positions de fin de tick restent séparées. Leur arrivée finale n’est pas affirmée.
- 93 778 vérifications du déplacement du centre par tick respectent le budget courant. Les séparations observées portent sur les positions de fin de tick ; le probe ne reconstitue pas indépendamment tout le volume balayé de la trajectoire.
- Deux casts publics Trundle E de rang1 provoquent l’annulation d’un ancien Move devenu obstrué, puis un nouvel ordre prend un détour. Le rayon150 et la géométrie de pilier restent locaux. Trois refus supplémentaires couvrent une destination séparée par un mur complet, un joueur inconnu et une partie terminée.

Les cas utilisent une grille plate synthétique40×40 et la session0, avec positions, équipes, morts et marqueurs explicitement injectés. Les composants CPU et leurs appels publics sont exécutés, sans partie ordinaire, runtime original, réseau, GPU ou audio. Les gates de casts et windups sont identifiées statiquement ; tous leurs contextes et toutes les formes ne sont pas exécutés ici. Aucun champion ni jeu complet n’est accepté.

## Intégration et conservation

Un premier candidat échoue sur le vrai générateur de consignes : le champ scope requis par consumer_instruction_line manquait. L’échec est conservé ; six fichiers d’entrée sont vérifiés exacts, le publisher n’a pas démarré et les livrables publics sont absents. Le candidat final corrige ce contrat et les étapes préparation, contrôle, publication et audit terminent au code0.

56 refus propres aux associations empêchent notamment la promotion du catalogue, les faux résultats natifs, les faux objectifs atteints et les fausses acceptations. Trois refus du lecteur public contrôlent un consommateur absent, une source étrangère et une acceptation de comportement inventée. Les fragments de trace de toutes les 42 215 tâches sont comparés ; seuls les destinataires du lot changent. Les 41 970 autres objets tâche/trace sont exacts. Les identités et la hiérarchie du plan restent exactes en octets ; la migration Gnar V522 est conservée.

L’adaptateur SQLite met à jour uniquement les données et consignes des245 destinataires, puis les métadonnées du catalogue. La version de catalogue est calculée par le préfixe de lecture du vrai Store.sync_catalog et comparée aux imports normaux précédents. Sur une copie privée puis dans les deux bases réelles, Store.task, copy_text, summary et rt.resolve vérifient les résultats. Les deux synchronisations normales suivantes sont idempotentes.

Chaque base conserve exactement 42 607 états et notes, 23 historiques et 42 362 autres lignes catalogue, ainsi que phases, fiches et groupes. Les comparaisons couvrent les tables complètes par flux SHA-256 et les lignes ciblées champ par champ. Les identifiants, titres, ordres, statuts de suivi et critères ne sont pas réattribués. L’intégrité SQLite estOK. Les transactions et écritures sont séquentielles ; aucune atomicité globale n’est revendiquée.

Le texte condensé reste limité aux trois premiers consommateurs. Le graphe complet et le reçu vérifient les11 composants ajoutés par fiche CHEMIN et9 par fiche BLOCAGE ; le texte condensé ne montre donc pas toute la qualification. La fenêtre Tauri, sa graine et son exécutable ne sont pas reconstruits ou exercés dans ce lot.

Graphe final : 42 215 exigences actives, 98 759 sources, 2 649 consommateurs, **25 919 questions ouvertes** et5 517 résolues avec historique. Les anciennes questions restent exactes ; les92 ajouts ne sont pas des défauts d’assets inventés. Aucun code produit, asset, lecteur ou pack n’est modifié.

## Fichiers et preuves

Modifiés : docs/fidelity_sources_4_20.json ; docs/fidelity_requirement_trace_4_20.json ; docs/completion_tasks_2026-10-20.json ; docs/fidelity_unknowns_4_20.json et les deux bases locales. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md reçoivent le contexte courant après sauvegarde de leurs versions précédentes.

Ajoutés : docs/reference_requirement_trace_sources/champion-path-blockage-links-v523.json ; docs/fidelity_champion_path_blockage_links_v523.json ; présent rapport. Les preuves détaillées et les commandes figurent sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20 : revision523_inspection_retry, revision523_runtime_checks_final et revision523_final. Les premiers essais restent dans leurs dossiers respectifs.

Les reçus identifient le coreV476 réutilisé, ses entrées, dépendances, toolchain et SHA, ainsi que les nouveaux probes. La compilation fraîche concerne le probe ; aucun nouveau build du core n’est prétendu. Les journaux revision523_FINAL_COMMAND_*.json donnent les commandes et leurs codes de retour. Ne pas republier ce lot déjà intégré.

## Suite

Poursuivre SYS-01.2-02 avec les122agrégatsCH-*-MOUVEMENT, en reprenant les sources et consommateurs précis RAYON(V519),CHEMIN/BLOCAGE(V523). Inspecter leurs critères et les consommateurs réels du cycle complet, relier les composants et limites sans accepter leurs92questions de sous-tâches ni transformer les46arrivées non observées à350ticks en succès. Le correctif du module allié partagé doit être réalisé et vérifié dans les tâches de mouvement concernées ;cette tâcheSYS reste un travail de traçabilité. Conserver les compteurs vérifiés,42215tâches,25919questions ouvertes et5517résolues,les17auxiliaires,V522Gnar,les identités et toutes cases/notes/historiques. Ne pas republier V523. Réexaminer ensuite le recensement global des lecteurs encore génériques et des sources manquantes ;Goal entier actif.
