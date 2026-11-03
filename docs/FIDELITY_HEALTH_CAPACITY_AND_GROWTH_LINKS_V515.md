# SYS-01.2-02 — Vie maximale, initialisation, croissance et arrondis ouverts V515

25 octobre 2026 ; projet F:/OpenLeague. La livraison précise les liens des 244 fiches HP/HPPERLEVEL des 122 champions et de la fiche globale SYS-04.1-01. Elle améliore le référentiel de sources et ses consommateurs, sans terminer la tâche globale ou le jeu.

La référence reste PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; date littérale 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue officiel 4.20.1 et client AIR 0.0.1.119 distincts. Les chemins historiques E restent conservés ; F est le projet de travail choisi par l'utilisateur.

## Résultat intégré

Trois sites existants du code, auparavant sans CID précis à ces lignes, sont désormais identifiés séparément :

- progression.rs:117 — Stats.max_health = base.health + g.health * factor + items.health. CID OLC-2f3a1a16-445a-5780-a880-a7e898b514c1 ; calcul du maximum.
- lib.rs:562 — max_health: def.health pendant join. CID OLC-c819ff27-14a0-5d9c-9de5-38d3dad2b7f5 ; affectation du maximum initial. La ligne voisine initialise la vie courante depuis la même valeur de base.
- progression.rs:143 — p.max_health += growth.health * delta dans award_experience. CID OLC-9a1f96d0-c0bf-520c-a596-729d02343027 ; croissance du maximum stocké. La vie du joueur vivant est ajustée à la ligne 145, celle du joueur mort est conservée.

Les 122 fiches HP reçoivent calcul et initialisation ; les 122 HPPERLEVEL reçoivent calcul et application de croissance. SYS-04.1-01 reçoit ces trois sites en tant que sous-ensemble santé. Total : trois nouveaux CID et 491 liens. Aucun rôle ou lien antérieur supprimé, aucune fonctionnalité de champion ou de serveur historique déclarée complète.

Chaque fiche champion conserve son lien natif générique Data et ajoute un sélecteur exact BaseHP ou HPPerLevel, avec hash de propriété et bits courants : 244 nouvelles liaisons natives. Les pointeurs vers les données de F et leurs anciennes références E sont conservés ; taille/SHA sont comparés sans confondre les fichiers.

## Sources et prérequis

Les 122 INIBIN de champion sont relus dans le deploy 0.0.1.68 avec reference_inibin.py. BaseHP est comparé à champions.json[id]/health ; HPPerLevel à champion_growth_420.json[champion]/health. Chaque propriétaire et pointeur est vérifié. Résultat attendu : égalité après conversion en binary32. Observé : 244 égalités exactes, aucun opérande absent.

Les identités des exports Stats et leur MetaData.ResourcePath sont rapprochés des fichiers natifs. Aucun SHA de JSON n'est attribué à un INIBIN. Les trois sites sont vérifiés dans leurs sources F déjà enregistrées, sans ajout d'alias de source.

Pour le chemin de gain de niveau, les 17 seuils EXP.Level2..Level18 sont relus dans LEVELS/Map10/ExpCurve.inibin : 200 octets, SHA-256 88c26d8999f8e95a6b2bc8e453a5a4186229ea4ef88f3e8e37e8c1dde8a22561. Ils correspondent en f32 aux seuils courants. Level1 est absent des deux sources ; aucune valeur native zéro n'est inventée. Ces seuils ne démontrent pas la formule de croissance des statistiques.

L'inspection conserve les phases D01/D06, les 123 lots concernés, leurs lots requis et les états des tâches préalables. Toutes les entrées numériques et de code utilisées sont disponibles. Le travail est une recherche de liens ; les critères de sortie des lots, phases et champions ne sont pas déclarés satisfaits.

## Exécution fraîche du code courant

Un nouveau probe Rust est compilé et exécuté au code 0. Il utilise la bibliothèque core V476 après comparaison de toutes ses entrées, dépendances et outils ; aucun rebuild du core. Bibliothèque de 278165670 octets, SHA-256 2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c. Le nouveau binaire, les commandes, scripts, logs et observations sont pinés dans CURRENT_HEALTH_CAPACITY_GROWTH.json.

Les attentes numériques sont les expressions f32 locales, vérifiées contre les vraies fonctions publiques. Elles ne constituent pas une formule indépendante récupérée du serveur d'origine.

| Chemin | Attendu | Observé |
| --- | --- | --- |
| Capacité calculée | base + croissance × facteur local + bonus santé d'item | 6588 capacités conformes : 122 champions × 18 niveaux × 3 inventaires |
| Bornes du facteur | niveaux injectés 0/19/255 bornés à 1..18 | 1098 capacités conformes |
| Arrivée du joueur | vie et maximum stocké égaux au BaseHP courant | 122 cas conformes |
| API serveur de gain XP | croissance incrémentale du maximum ; vie vivante ajustée, vie morte conservée | 4148 étapes conformes : 122 × 17 niveaux × vivant/mort |
| Gain XP invalide | erreur explicite pour 0, -1, NaN, infini ; joueurs et tick inchangés | 488 refus conformes |
| Propriétaire XP absent | erreur "unknown player" ; joueurs inchangés | 122 refus conformes |
| Gain positif au niveau 18 | niveau et vie inchangés | 244 cas conformes |
| Statistiques d'un joueur absent | panic du contrat courant | un panic capturé et message conservé ; aucun refus propre Result/Option |

Pour le getter, les inventaires sont injectés : vide, 1028 (+150 santé), 1011 (+380). Navigation synthétique 20x20, niveaux assignés directement, aucun achat ou application des effets de boutique à l'état stocké. Ce contexte ne prouve donc pas une incohérence de boutique lorsque le getter inclut un item injecté et que le maximum persistant reste initial.

Les essais XP sont distincts : nouvelles simulations sans inventaire, niveau initial 1 puis vrai award_experience aux seuils natifs comparés. La vie initiale est réglée à la moitié pour le cas vivant et à zéro pour le cas mort. Aucun monde n'est avancé ; l'API est appelée directement, sans qualifier un message réseau ou un client autorisé à attribuer de l'XP.

## Écart local observé : maximum stocké et recalculé

Dans les 4148 comparaisons XP, 1870 diffèrent entre maximum stocké et Stats.max_health recalculé : 935 couples champion/niveau distincts, présents dans les cas vivant et mort. Les 122 champions sont concernés à au moins un niveau. Répartition : 1702 observations à un ULP, 168 à deux ULP. Les deux chemins sont conformes à leurs propres expressions f32 courantes.

Ces résultats ne sont pas normalisés. Ils démontrent des arrondis locaux distincts, sans déterminer la valeur ou la méthode attendue par le serveur Riot. La source native d'un opérande et l'égalité de cet opérande en f32 ne suffisent pas à résoudre cette question.

La question existante OLU-1f10098e-cf58-5e5c-94eb-2747d97c3d8b, propriétaire SYS-04.1-01, reste ouverte. Sa formulation précise les trois sites et le constat local ; sa condition demande toujours les calculs/arrondis/ordres historiques pour toutes les statistiques. Son identifiant, propriétaire, aspect, statut et préfixe de recherches sont conservés. L'ancienne question et l'ancienne condition sont ajoutées à son historique avec le reçu V515.

Cette formulation évite aussi de présenter les anciennes requêtes d'alias BaseHPRegen/BaseMPRegen sans résultat comme des assets manquants : les champs BaseStaticHPRegen/BaseStaticMPRegen ont déjà été identifiés par V512/V513. Ces preuves héritées sont conservées, sans réexécution de leurs anciens probes ou du parseur original. Les quatre écarts de précision de ressource et les 102 défauts Mana natifs non qualifiés restent séparés.

## Contrôles et limites d'affichage du plan

Le candidat est reconstruit depuis les quatre baselines. Les 42214 traces sont comparées : 244 textes changés pour les fiches champion, 41970 exacts. Les 246 contextes sont précontrôlés, dont SYS-01.2-02 et SYS-04.1-01. Les 41968 autres objets tâche/trace, toutes les anciennes sources et tous les anciens consommateurs restent exacts. Toutes les questions hors l'unique précision restent exactes ; aucune inconnue créée ou résolue.

1504 identités et les quatre pins de baseline sont vérifiés. Six refus d'inspection couvrent opérande absent/NaN/infini et seuil XP absent/NaN/non croissant. Cinquante-quatre gardes de champ/propriétaire/source/consommateur empêchent notamment la confusion entre initialisation et croissance, la substitution de régénération, une normalisation inventée et une fausse parité native. Dix contrôles protègent l'identité, le statut ouvert, l'historique et les recherches de la question. Trois refus du lecteur public couvrent une source absente pour chacun des nouveaux CID.

Premier contrôle au code 1, avant publication : il attendait 245 fragments de trace changés, dont celui de SYS-04.1-01. Le lecteur existant affiche les trois premiers consommateurs ; cette fiche en avait déjà trois et en a désormais six. Son résumé reste donc identique, alors que le graphe complet et le contexte copiable contiennent les nouveaux liens. L'essai et son log sont conservés. Le contrôle corrigé vérifie séparément 244 fragments changés, les six consommateurs via resolve et les trois nouveaux identifiants dans l'instruction complète. Il ne prétend pas que le résumé affiche les six. TRACE_VISIBILITY_DIAGNOSTIC.json conserve les ensembles effectivement observés.

La fiche complète est accessible par le lecteur du plan et par :

```text
python -B tools/project-plan/requirement_trace.py --root F:/OpenLeague --task SYS-04.1-01
```

L'affichage condensé à trois consommateurs est une limite actuelle du lecteur, non corrigée dans cette livraison de liens. La question complète est exposée par resolve/le lecteur complet. Les notes et références permettent de retrouver les preuves ; aucune parité historique n'est déduite du seul affichage.

Une première requête exploratoire, en lecture seule, a échoué en cherchant la clé "native" à la racine du reçu de statistiques. La structure réelle native_source_observation/native a ensuite été inspectée ; aucune donnée autoritaire n'a été modifiée par cette requête.

Un premier essai de publication termine au code 1 avant toute écriture : le publisher attend prerequisites.plan, alors que le relevé fournissait le même pin sous plan_source. Les quatre registres restent identiques à leurs baselines, aucun marqueur de démarrage, reçu public ou preuve publique n’était créé, et aucune base n’avait encore été ouverte. PREWRITE_FAILURE_VERIFIED.json conserve cette vérification. La recette finale distincte ajoute seulement l’alias plan ; les relevés et le probe ne sont pas rejoués. Une préparation et un contrôle finaux sont exécutés à nouveau dans revision515_final. Les scripts/logs initiaux restent immuables.

## Intégration, conservation et fichiers

Publication séquentielle des quatre registres et mise à jour des deux bases, puis audit indépendant reconstruit depuis les baselines. Ces opérations ne forment pas une transaction globale. Aucun ancien fichier de preuve ou journal n'est remplacé.

Registres : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et docs/fidelity_unknowns_4_20.json (une question précisée, toujours ouverte). Reçu : docs/reference_requirement_trace_sources/health-capacity-and-growth-links-v515.json. Preuve : docs/fidelity_health_capacity_and_growth_links_v515.json.

Deux bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Les vrais lecteurs Store.task/copy_text et rt.resolve vérifient 246 fiches par base ; 42360 autres lignes de catalogue, 42606 états/notes et 23 historiques restent exacts ; intégrité SQLite OK. Aucune case manuelle cochée.

Documentation : ce rapport, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md, avec sauvegardes des versions précédentes. Leurs champs antérieurs restent conservés hors date/prochaine action.

Travail sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision515_inspection/OBSERVATIONS.json ; revision515_runtime_checks/CURRENT_HEALTH_CAPACITY_GROWTH.json et OBSERVED_HEALTH_CAPACITY_GROWTH.json ; revision515_final/BASELINE.json, SOURCE_LINK_RECEIPT.json, PREPARATION.json, CANDIDATE_CHECK.json, TRACE_VISIBILITY_DIAGNOSTIC.json et DELIVERY_AUDIT.json ; revision515 conserve les premiers candidats et le refus avant écriture. Les scripts inspection/probe/runtime/delivery/check/check_retry et les wrappers identifient les commandes exactes ; chaque commande Python utilise -X utf8 -E -u -B. Les deux contrôles ont des logs et codes distincts.

Aucun code produit, lecteur du plan, asset ou pack de distribution modifié. Aucun match ordinaire, world tick, serveur Riot, rendu GPU, son ou totalité de modificateurs qualifié. Les 17 sources auxiliaires justifiées V512 restent conservées sans promotion.

## Suite

Le recensement actuel retrouve 1464 autres fiches de statistiques d'identité, réparties sur 12 champs, toutes encore reliées seulement au CID data_loader. Examiner d'abord les 488 fiches ARMOR/ARMORPERLEVEL/SPELLBLOCK/SPELLBLOCKPERLEVEL et leurs calculs réels, avec distinction des bonus, effets et réductions ; poursuivre ensuite les huit autres champs. Le nombre de fiches est un constat structurel, pas un pourcentage de jeu réalisé. Conserver l'écart local de maximum, les questions historiques et la limite du résumé à trois consommateurs.

Le Goal et SYS-01.2-02 restent actifs. Aucune acceptation complète d'un champion, d'une phase ou du jeu n'est accordée.

Bilan après relecture : inspection, compilation/exécution du probe, préparation finale, contrôle final, publication finale et audit au code 0. Premier contrôle et première publication au code 1 conservés ; le refus de publication survient avant toute écriture, quatre baselines exactes vérifiées. Graphe : 98730 sources, 2614 consommateurs, 25827 questions ouvertes, 5517 résolues avec historique. Les 17 consommateurs sans lien actif restent les auxiliaires justifiés V512.

## Supplément 2026-11-02 — Annie BaseHP : source, donnée et consommateurs actuels

**Unité auditée :** CH-Annie-IDENTITE-HP / OLF-7969b3b0-f0f4-5fcf-ac40-110e651bd748. Portée limitée au lien de la vie de base; HPPerLevel, la croissance, les modificateurs et le comportement de partie ne sont pas inclus.

**Source native réutilisée et revalidée :** DATA/Characters/Annie/Annie.inibin du client 4.20.0.315, 1 637 octets, SHA-256 29f1cb388e5692d0fd572ec32888a2a3d56c7aec1876e7cfc9a4bc76bca61f36. Le fichier actuellement présent au chemin de référence D conserve cette empreinte. Le reçu de membership V515 l’associe au membre lol_game_client release 0.0.1.7 par taille, MD5 et chemin. Le champ décodé est Data.BaseHP, hash 742042233, binary32 511.67999267578125, bits 0x43ffd70a.

**Lien local actuel :** data/4.20/champions.json#/6/health contient Annie (id=annie) et 511.68. Sa conversion binary32 observée donne 511.67999267578125, bits 0x43ffd70a, identiques à la source. Le fichier actuel (32 052 octets, SHA-256 7cc80048c9460419041134232345d9b4da6d8f4e6795f7236720bef39e99de88) correspond au reçu V515.

**Consommateurs courants vérifiés :**
- OLC-93924678-ea15-5516-8f55-08616c5450cc : crates/core/src/lib.rs:149, lecteur du catalogue; l’include JSON est à la ligne 151.
- OLC-c819ff27-14a0-5d9c-9de5-38d3dad2b7f5 : crates/core/src/lib.rs:562, initialise max_health depuis def.health au join.
- OLC-2f3a1a16-445a-5780-a880-a7e898b514c1 : crates/core/src/progression.rs:117, recalcule Stats.max_health depuis base.health, la croissance et les objets.

Les empreintes actuelles de lib.rs (cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d) et de progression.rs (eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766) sont identiques aux pins V515. Les lignes enregistrées sont donc encore celles de cette révision.

**Attendu / observé :** la valeur native BaseHP et la donnée locale de base doivent avoir le même binary32; égalité exacte observée (0x43ffd70a). Cas nominal de liaison réussi. Aucun refus de chargement de donnée invalide n’a été exécuté dans ce lot. Aucun test Cargo, client LoL, match ordinaire ou serveur historique n’a été exécuté aujourd’hui; les contrôles V515 sont antérieurs et ne sont pas présentés comme fraîchement lancés.

**Décision limitée :** audit statique source native → donnée F → consommateur fermé pour Annie BaseHP seulement. Le code actuel et la donnée sont liés; cela ne prouve pas l’application des PV dans une partie fidèle. Arrondis de croissance, ordre des modificateurs, état persistant, spawn historique, acceptation humaine et tâche générale SYS-01.2-02 restent ouverts. La fiche de plan n’a pas été modifiée ni marquée terminée.