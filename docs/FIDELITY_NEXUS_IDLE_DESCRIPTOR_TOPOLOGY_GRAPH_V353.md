# SYS-01.2-02 — descripteurs et topologie Idle des Nexus, V353

Cette livraison intègre uniquement le lien entre les descripteurs Idle natifs, les deux JSON et GLB courants et leur lecteur partagé Spec::for_model. Chaque tâche WORLD reste limitée à son propre côté ; SYS-01.2-02 reçoit leur union.

Référence : PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis ; catalogue 4.20.1 distinct. Dépôt F:/OpenLeague, travail privé F:/OpenLeague-work ; E conservé.

## Qualifications conservées

V349 est la recherche primaire, FINAL SHA7bfc2a2657560105f6d37205b9806c81e9c4a7769728c51ec79fc1a1c0b17aec. Les 177 contrôles source, 11 de lookup et 50 de finalisation sont des étapes distinctes. Le refus du premier lecteur de pin est conservé.

V351 est une qualification fraîche par le même auteur, sans revue tierce indépendante. Son FINAL SHA1a1d4e674cc7306b5fcc2feb45b0a92a59d71ec9eff7b8c869ae09b3cfa346b5 présente ses propres codes outil/sous-processus/collecteur 0 : 320 contrôles source, 34 de lookup, 56 de portée V2, et 115 de scellement séparés. Les 53 contrôles V1 réussis sont conservés ; V2 corrige les unités du texte des tâches WORLD, dont les bindings étaient déjà filtrés correctement. Le premier refus source V1 reste documenté. V351 vérifie 27 identités et 27 ancres ; trois définitions de tests sont source-only, sans exécution.

Le FINAL et les projections V351 conservent registration_ready=false. L'explication scellée indique qu'aucune entrée indispensable ne manque au seul lien borné avec la topologie GLB courante explicitement déclarée comme autorité. Ce flag sépare cette qualification de la future publication et de ses propres contrôles. Aucun verrou historique n'est modifié.

Le préflight V353 a réellement passé, code outil/sous-processus 0 : 305 contrôles source et 19 contrôles propres distincts, 32 identités ciblées, 27 ancres et trois définitions de tests source-only. Trois sélecteurs nominaux, six refus de sélecteur et dix refus de contenu/forme passent leurs résultats attendus. Le FINAL de préparation et les compléments finaux conservent les propres retours et leurs compteurs séparés.

Le lookup global current/history/origin porte sur sept entrées. Les quatre sauvegardes brutes V352 établissent la transition exacte 98 498/2 401 vers 98 516/2 403 : les ajouts 18/2 sont ceux réellement publiés et audités. Les vieux records, tâches, assessments, inconnues et limites V351 restent conservés. Les identités de preuve/rapport publics enregistrées dans le checkpoint V352 sont datées ; une annexe indépendante ultérieure ne les transforme pas en sources immuables nouvelles.

La revue root a relevé, dans des brouillons non exécutés, une date de baseline reconstruite variable et un contrôle de forme insuffisamment explicite. La version finale fige une seule baseline privée et compare les mêmes octets avant publication ou via les sauvegardes après publication. Le sélecteur exige trois associations et un corps, puis leurs données exactes. Les scripts antérieurs restent conservés ; aucun échec de produit ou de publication n'est déduit de ces lectures statiques.

NumberOfParticles natif est comparé à la taille locale des 11 descripteurs et à SLOTS=11. Ce lot ne crée pas de lecteur runtime du champ brut. Les 22 textes et deux compteurs, les 44 nœuds et 42 appartenances aux joints restent des unités distinctes, sans total de drivers.

## Sources et limites de provenance

Deux INIBIN natifs de 567 octets :
- OrderNexus.inibin, SHA a07bdc3670f27be0b7136edacf5f8266222b5b817d510012076d9d60820f976a ;
- ChaosNexus.inibin, SHA 1f902f6b18b88c374468e117110b88eb96deb186bc30690f84840deb37bd3a02.

Ils portent 11 chaînes de type 12 et un compteur u8 de type 4 chacun. Ces 22 textes et deux compteurs ne sont pas des paramètres TROY numériques ni des getters flottants exercés. Les ressources TROY mentionnées restent des noms de descripteurs pour ce lot.

Les entrées courantes sont data/4.20/nexus_idle_particles.json, 4 931 octets, SHA a38d222c3da548ba340120708b5bb174907c107b8628e19308d2139c012bbdc4 ; chaosnexus_idle_particles.json, 4 727 octets, SHA 4f005438b622579a12baac3cfff384bcbcdfa282ceb2f14f28a261cb17d05a71 ; assets/structures/native_intact_ordernexus.glb, 1 250 636 octets, SHA 48a91d7f33470e5a00f15ae2ff91abb2c89dc5e17b44517ec292b3030e4b8b31 ; native_intact_chaosnexus.glb, 1 259 840 octets, SHA 8cf760d6143d8bb7967ab59bde1ea0b5ac0672571046086de771f0c501521b8d.

Chaque GLB courant fournit 22 nœuds et 21 appartenances aux joints de skin. Les booléens joint du JSON sont une représentation locale de ces appartenances ; ce ne sont pas des booléens INIBIN natifs. Les noms, parentés et indices de nœuds/joints sont des dépendances courantes vérifiées, pas une preuve de conversion native SKL. Les crédits V196, inventaires et anciennes copies E restent conservés. Un JSON sans nœud exact au registre n'est pas une implémentation manquante.

## Consommateur actuel et refus

Le corps partagé se trouve dans crates/client/src/nexus_idle_particles.rs, signature for_model à 29, lecture JSON à 35 ; source F OLS-4d98646b-ebfe-59c1-a99e-df3875d861f6, 25 653 octets, SHA de08c94ff3d7029c7187186f073298efc26a6d720e063dee21d94f313962775b. Une seule identité de corps est partagée par les deux côtés.

Le match 30–33 choisit le modèle ou refuse un modèle non supporté. Les gardes 37–58 contrôlent schema, modèle, asset, 11 slots, 22 nœuds, 21 joints, noms/ressources/bones, ordre des slots, indices et appartenance aux joints. Le champ key est désérialisé puis cloné ; aucune lecture sémantique n'est qualifiée dans les huit modules ordinaires inspectés. Les métadonnées de SHA, source, flag16 et age_policy ne constituent pas des contrôles runtime d'identité de tous les fichiers.

La route ordinaire main675 → Plugin295 → setup379 → for_model35 est distincte de la présentation postérieure : synchronize390 → produce421 → collect265 / resolve_nodes242 → publish192. Les contrôles de session/phase/horloge, modèles chargés, scène, descendants, parentés et joints peuvent différer ou refuser. Les politiques locales d'âge, de phase, du suffixe de ressource et du flag 0x10 ne sont pas une preuve de cadence, de dispatch ou d'animation natifs. Aucun rendu observé n'est revendiqué.

WORLD-OrderNexus-PRESENT ne reçoit que ses INIBIN/JSON/GLB Order et les unités 11 textes + 1 u8 / 22 nœuds / 21 joints. WORLD-ChaosNexus-PRESENT reçoit seulement Chaos avec les mêmes unités. SYS-01.2-02 reçoit la paire : 22 + 2 / 44 / 42. Le lecteur frontière setup383 conserve ses flags entry_boundary_only et provides_feature_consumer=false ; le lecteur générique world_loader185 conserve son crédit exact. SYS-02.5-04 et SYS-15.1-02 ne sont pas ajoutés à ce lot.

## Publication et contrôles

Le registrar root puis l'audit de livraison ont réellement terminé avec le code 0. Scripts, commandes, sessions, retours et preuve brute exacte : ROOT_EXECUTION_RECEIPT.json. L'audit vérifie 270 contrôles source et 32 identités ciblées. Les trois sélecteurs nominaux passent ; six sélecteurs incorrects et dix contenus/formes invalides sont refusés, dont un INIBIN, un GLB et une preuve du mauvais côté, une union sans Chaos, un mauvais corps et des formes nulles ou supplémentaires.

Le delta exact ajoute 11 sources et un corps partagé, dont deux nœuds JSON. WORLD-OrderNexus-PRESENT reçoit seulement Order, WORLD-ChaosNexus-PRESENT seulement Chaos, et SYS-01.2-02 leur union. Les anciennes 98 516 sources et 2 403 identités de lecteurs restent exactes. Les autres tâches, dont SYS-02.5-04, SYS-15.1-02 et R-VFX, sont inchangées ; les flags du lecteur frontière et du loader générique restent tels quels.

Deux bases physiques distinctes sont vérifiées en lecture seule via les vrais Store.task/copy_text/resolve : trois fiches enrichies, 42 606 états manuels et 23 historiques exacts chacune, notes et textes copiés complets préservés, integrity_check=ok. Les contextes contiennent les chemins absolus canoniques et le sélecteur de leur propre côté. Aucune coche ou acceptation n'est modifiée.

Le reçu public, les trois remplacements JSON et les deux transactions DB sont séquentiels, pas globalement atomiques. Une erreur réelle doit interrompre le travail et préserver son état observé, sans relance automatique ni rollback. Les sauvegardes brutes et la preuve après registrar sont conservées sur leurs octets exacts. Les états partiels des prérequis WORLD-AI et l'acceptation humaine manquante de la référence restent ouverts.

## Fichiers et suite

Fichiers intégrés : docs/reference_nexus_idle_sources/nexus-idle-descriptor-topology-v353.json, docs/fidelity_nexus_idle_descriptor_topology_graph_v353.json, présent rapport, trois registres et les deux bases. Couverture, plan et reprise sont actualisés. Sauvegardes et reçus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision353.

Le graphe structurel contient 98527 sources / 2404 consommateurs, 25321 inconnues ouvertes et 5517 résolues. Le rehash est ciblé ; le compteur global ne prouve pas un rehash de tous les fichiers.

Suite : préparer le lot V357 des liens Startup Gem/GemInside depuis le FINAL V355 acquis et Startup GemSparkle depuis le FINAL V359 acquis. Les qualifications restent séparées. Main77 et Sparkle126 ont leurs propres gardes et limites ; ils ne deviennent pas un lecteur unique ou un effet intégral. L'audit V356 de livraison spawnmist est acquis et relié, distinct de sa qualification source V350 par le même auteur.

Les chemins publics intégrés sont docs/reference_nexus_idle_sources/nexus-idle-descriptor-topology-v353.json, docs/fidelity_nexus_idle_descriptor_topology_graph_v353.json et docs/FIDELITY_NEXUS_IDLE_DESCRIPTOR_TOPOLOGY_GRAPH_V353.md. Les gates, codes root, ajouts de graphe et preuves DB réellement acquis sont détaillés ci-dessus.

Aucune exécution Rust, build, binaire natif, GPU ou ancien générateur n'est revendiquée. Les inconnues sur SKL, appartenance RADS fraîche, provider/getter/FP, animation et présentation complète restent ouvertes. Les prérequis techniques et humains non terminés restent tels quels. Aucun champion, WORLD, exigence globale ou jeu complet n'est déclaré terminé. L'archive SYS-03.4-07 reste inconnue ; AnvilKit reste une piste.

## Relecture indépendante V361

La relecture indépendante de la livraison V353 a passé avec ses propres codes outil/sous-processus/collecteur 0 : 382 contrôles, 43 identités ciblées, 27 ancres et trois définitions de tests source-only. Trois nominaux, six refus de sélecteur et dix refus de contenu ou de forme passent. Le supplément root vérifie séparément 44 contrôles et 25 identités ; ces compteurs ne sont pas ajoutés à ceux de l'audit principal.

Les quatre sauvegardes brutes reconstruisent exactement le delta 11 sources / un Spec35, 98516/2403 vers 98527/2404. Les anciens enregistrements, liens, scopes, flags présents ou absents, assessments, inconnues et autres tâches restent exacts. Chaque WORLD garde son seul côté ; le goal porte leur union. Dans les deux bases physiquement distinctes relues en mode=ro/query_only avec les vrais Store/task/copy/resolve, seules les trois fiches prévues changent ; 42606 états manuels et notes et 23 historiques restent exacts.

Le garde privé V1 avait deviné le mauvais chemin world_loader et a refusé avec le code 1 avant toute lecture DB. V2 utilise les enregistrements canoniques exacts par CID/path/line/flags ; aucun produit corrigé ou promu. V1, sa sortie et sa correction restent conservés. Les fonctions pures extraites sont attribuées ; aucun mutateur root n'a été importé ou rejoué. Le nombre de bases auditées est deux ; le nombre total d'ouvertures SQLite n'a pas été instrumenté.

Cette revue confirme les liens et la topologie GLB courante seulement. NumberOfParticles reste une provenance comparée à la longueur et à SLOTS11, sans lecteur runtime de la clé native. SKL, animation, getter/FP/provider/device/GPU et présentation complète restent ouverts. Aucun test Rust, build, natif ou générateur exécuté.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision361_independent_nexus_idle_delivery/FINAL_EXECUTION_RECEIPT.json. Les octets exacts de la preuve et du rapport avant annexe, ainsi que couverture/plan/reprise/contexte, sont conservés dans revision353/pre-independent-link-versions avec reçu de préservation. Les SHA publics du checkpoint V353 demeurent des observations datées.
