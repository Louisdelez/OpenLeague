# SYS-01.2-02 — Sources et consommateurs du réseau de 120 passifs, V666

Date UTC : 2026-10-27T07:51:06.774882+00:00. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct.

## Résultat intégré

V666 :120 fiches réseau de passif reliées à358 sources natives et23 points actuels,soit2046 associations. 17 frontières communes et6 points partiels propres à Annie/Garen/Trundle restent distincts. Diagnostic hérité BUILD/RUN0 :1209 états reçus,1199 exacts bruts,10 écarts JSON conservés ;cycle JSON direct et decode_view f32 exacts. Callbacks/protocole natifs,rendu et acceptation complète restent ouverts. Aucune case,question ou dépendance supprimée.

Les120fiches CH-<champion>-PASSIF-NETWORK restantes et SYS-01.2-02 sont mises à jour dans le registre et les deux bases du plan. Aatrox V664 et Ezreal V665 conservent leurs preuves distinctes. Chaque fiche possède ses instructions complètes, ses sources sélectionnées, les points de code qui lui sont applicables et ses limites. Aucun code de jeu ni asset n’a changé dans cette publication. La préparation V666 précédente demeure un état historique ; son étape de publication est désormais accomplie.

Les358sources natives ne sont pas358fichiers nouvellement récupérés : leurs identités étaient disponibles et leurs associations précises sont maintenant ajoutées. Les17points communs sont des frontières de transport ou de réception. Les6autres points sont des composants locaux partiels pour Annie, Garen et Trundle. Un état générique reçu ne prouve ni absence ni fidélité complète du passif des117autres champions.

## Observations de fonctionnement et limites

Le diagnostic préparatoire conservé a exécuté le véritable core et cinq modules serveur/client actuels dans un programme local distinct :1163entrées inchangées,120champions,360connexions clientes UDP,1209états reçus,13744datagrammes,846requêtes et59395ticks. Les120commandes dupliquées sont refusées, les120reconnexions retrouvent le joueur et un état inchangé, puis les120cycles de mort/réapparition ordinaires passent à480ticks. Les dommages imposés sont des appels explicites à l’API serveur, pas des commandes clientes ni une partie complète.

1199états sont identiques en JSON brut. Dix différences de représentation numérique du récapitulatif restent présentes : Annie, Brand, Nami, Velkoz et Zyra, chacun dans les phases mort et tick précédant la réapparition. Elles se reproduisent dans un simple aller-retour JSON, indépendamment du transport UDP. Le véritable decode_view reconstruit les mêmes valeurs f32 bit à bit et les autres champs sont exacts. Aucune tolérance n’a été ajoutée au jeu. Les deux premiers RUN101 restent enregistrés comme échecs de l’égalité JSON brute, sans être remplacés par le résultat du diagnostic typé.

Trois cas spécifiques seulement : un E d’Annie donne une charge locale ; un dégât sur Garen renseigne son interruption ; une mort proche soigne Trundle selon le ratio communautaire local2%. Ce lot ne qualifie pas les quatre charges et l’étourdissement d’Annie, les paliers complets de régénération de Garen, toutes les cibles/morts de Trundle, ni la fidélité native de ces règles.

Restent ouverts : code serveur historique et callbacks non récupérés, événements et audiences natives, protocole d’origine, résolution effective des alias/providers, tous les déclencheurs et cas limites propres à chaque passif. Le client graphique normal, le HUD, le GPU et l’audio n’ont pas été exécutés dans ce diagnostic. Les prérequis réels des120packages et les360fiches SOURCE/CONTRAT/SIMULATION amont sont conservés. Pas d’inférence d’assets globalement manquants à partir de ces limites.

## Contrôles réellement effectués

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 555704d5abc29217e9439f94cbd25e099e9a8b67e2e2e451faf2fb8f630f7426 |
| RUN | 0 | ed9d1430ae6ab67dd1e700057c242563bc94aa34896abbb8a95ab5800e76d90f |
| prepare | 0 | 26707d7884c4872ec9408373050a8c6d67fb376eff894619cd4800a5dedd1e06 |
| check | 0 | ece52bdae4914fd5bc963f9201c40d5cddd79554285a26bac523348673d03be5 |
| publish | 0 | e86043fd2b0e7ec11fc3d2049b0a9c525743f34da6ed6435721658d20ac7d75d |
| audit | 0 | b47e3ab160d8ab962ca6e6bf5b3bafeace127aa6f616c0496b64aa2a60a61d53 |

BUILD/RUN se rapportent au diagnostic préparatoire vérifié et conservé ; ils ne sont pas présentés comme une nouvelle exécution pendant la publication. PREPARE/CHECK/PUBLISH/AUDIT sont les contrôles exécutés pour cette intégration. Le candidat refuse2645associations falsifiées et4graphes invalides, notamment une promotion du transport commun en passif complet, la suppression d’une différence JSON, une fausse identité de binaire ou une question étrangère.

Dans chacune des deux bases :121lignes ciblées vérifiées,42486autres lignes de catalogue identiques,42607états manuels et23historiques identiques. Store.task, copy_text, dépendances, rt.resolve, intégrité SQLite et synchronisation normale idempotente contrôlés. Les120fragments de trace ciblés changent ;42095autres restent identiques. Les instructions complètes sont vérifiées dans le format réellement produit par make_instruction : une valeur JSON avec les retours à la ligne échappés. L’adaptateur ne supprime aucune assertion et ne modifie pas le sérialiseur du plan.

IDs, hiérarchie et registre des inconnues restent identiques en octets ;120questions propres,123paires de questions parentes et120dépendances de tâches sont conservées. La revue globale indépendante vérifie5580ancres et empreintes de consommateurs actuels, aucun écart. Graphe :99339sources,42215exigences actives,26189questions ouvertes et5517résolues avec historique. Ce contrôle ne rehache pas l’intégralité des sources historiques et ne mesure pas le pourcentage du jeu terminé.

## Sauvegardes et fichiers

Projet et preuves persistantes sur F. Copies SQLite de validation créées dans un répertoire temporaire unique sur C pour ne pas saturer F ;chaque copie est compressée sur F, puis son SHA décompressé est comparé avant suppression de la seule copie temporaire. La copie candidate est restaurée exactement et comparée au relevé initial avant mise à jour. Les documents JSON candidat/baseline sont lus directement depuis leurs archives. Script de restauration explicite :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision666_network_restore_snapshots.py.

Modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json ;121lignes de chacune des bases projet et application installée ;couverture,plan,reprise et notes courtes. Ajoutés :présent rapport,reçu et vérification V666. Anciens documents conservés sous forme gzip vérifiée.

Binaire du diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-passive-network-matrix-probe-typed.exe, 7862784octets, SHA-256 f44e562a66cd965a66caa177685c41f03e65423904aa19fa3f0654199345f156.

Reçu :F:\OpenLeague\docs\reference_requirement_trace_sources\passive-network-matrix-links-v666.json. Vérification :F:\OpenLeague\docs\fidelity_passive_network_matrix_links_v666.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision666_passive_network_inspection/OBSERVATIONS.json. Runtime :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_probe_typed\OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_delivery/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision667_trace_review\REVIEW.json. Instructions par champion :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision666_passive_network_preparation/TASK_INSTRUCTIONS.json.

## Travail suivant

Continuer SYS-01.2-02 : V666 est publié et audité pour120PASSIF-NETWORK plusSYS dans les deux bases ;358sources natives,23points (17frontières communes et6points spécifiques),2046liens,120questions propres et123paires parentes conservées. Revue revision667_trace_review/REVIEW.json :5580ancres/empreintes exactes,aucun problème,graphe99339sources/5580consommateurs,26189questions ouvertes. Les122réseaux de passif ont des liens au-delà du chargeur partagé,mais aucun passif complet n’est accepté par cela. Poursuivre les122fiches PASSIF-PRESENTATION-ANIMATION listées dans revision666_passive_network_delivery/NEXT_PRESENTATION_ANIMATION_QUEUE.json :inspecter leurs vraies ressources et consommateurs de rendu/animation,les preuves déjà acquises et les callbacks. Distinguer réutilisation d’animation commune,animation spécifique,ressource native disponible et déclencheur réellement consommé. Ne pas déduire une absence depuis le seul chargeur,ni ajouter une animation inventée pour remplir une case. Les cas réseau V666 gardent dix écarts JSON bruts (Annie,Brand,Nami,Velkoz,Zyra) et deux RUN101 historiques ;decode_view f32 et cycle JSON direct exacts. Seulement trois cas de producteur spécifiques exercés,protocole/callbacks natifs et rendu non qualifiés. F reste peu libre :copies SQLite temporaires sur C,archives exactes sur F,baseline/candidat JSON compressés directement. Ne pas effacer bases actives ou preuves enregistrées. Goal actif,aucune case ou inconnue automatiquement fermée.
