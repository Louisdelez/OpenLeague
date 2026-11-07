# SYS-01.2-02 — Fiche projectile de Gnar, migration V522

25 octobre2026 ;F:\OpenLeague ;PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Date littérale du build2014-11-17 17:46:45,fuseau et déploiement non établis.

## Résultat intégré

La sous-tâche **CH-Gnar-ATTAQUE-PROJECTILE** existe désormais dans le registre canonique,le plan machine,les identités stables,la traçabilité,le plan Markdown et les deux bases locales. Son identifiant de fidélité est **OLF-512e49dc-83dd-56cd-adc7-07d9256b38b9**. Elle démarre **a_faire**,décochée,avec notes vides,révision0,aucune implémentation ni acceptation complète revendiquée. L’agrégat CH-Gnar-ATTAQUE dépend maintenant de cette nouvelle sous-tâche ;sa recette complète ne peut pas ignorer ce travail.

Le plan passe de42214à42215tâches actives,de20399à20400dansD06 et de198à199dans la ficheGnar. Les2770fiches,24parties,151exigences historiques et392tâches archivées sont conservées. Les quatre agrégations historiques04.2,06.1,06.EX1,06.EX2 incluent l’enfant supplémentaire. Les42214anciens identifiants actifs restent exacts ;l’UUID découle du mécanisme stable existant,et aucun numéro ancien n’est réattribué.

## Source de la correction et limites

V521 avait reproduit en mémoire le seul prédicat historique de build_plan.py ligne166 :portée du catalogue>200. Il produisait les56fiches de projectile et omettaitGnar,portée de base150. Le profil courant et les fichiers natifs choisis portent IsMelee=No et MissileSpeed=1500 pour les attaques normales/critiques ;le code courant lance un projectile. Le générateur historique complet n’est pas exécuté ni modifié.

La nouvelle fiche reprend les trois véritables composants courants :attacks.rs:257(lancement),attacks.rs:159(suivi)etlifesteal.rs:4(impact partagé). Elle reprend les entrées natives et références deGnar déjà vérifiées,avec des consignes propres aux tirs normaux/critiques,aux mouvements/annulations,morts/retraits,formes,réseau et rendu. Un catalogue de champion ne remplace pas ces lecteurs. Aucun CID ni code produit n’est ajouté.

Les observations CPUV521 et leurs reçus sont **hérités et relus**,pas réexécutésV522. Les fichiers sources ciblés et leurs SHA ainsi que les ancres courantes sont contrôlés à nouveau. Il n’y a pas de nouveau build du core,de gameplay exécuté,de runtime Riot,de réseau,de renduGPU,d’audio ou de match ordinaire dans cette migration. Le précédent résultatCPU ne démontre pas toutes les transitions Mini/MegaGnar,la croissance de portée,les priorités natives,les callbacks serveur ou la présentation des tirs.

La lacune de **présence dans le plan** est réparée. scope_gap_resolved demeurefalse car la qualification complète reste ouverte. Les contextesV521 avec named_child_not_created=true sont conservés comme preuves datées ;un nouveau contexteV522 les supplée uniquement pour la présence de l’enfant. Ni cette correction ni la présence d’une source ne clôture la sous-tâche,Gnar ou le jeu.

## Contrôles réellement exécutés

1. Instructions du dépôt et reprise lues. Inspection des registres,UUID,dépendances,crosswalks,lecteursPython/Rust et schémasSQLite. La première inspection en lecture seule échoue avec «unable to open database file» dans l’environnement restreintWAL ;la reprise autorisée en lecture seule réussit. Les sorties et scripts sont conservés. Aucun fichier du projet n’était alors modifié.
2. Sauvegardes gzip des huit fichiers de référence et sauvegardes cohérentesSQLite des deux bases avant migration. Préparation exclusive de candidats,sans écriture des registres actifs.
3. Validation des42215identités actives et des42758identités totales,du graphe complet et de ses compteurs. Tous les sommets du graphe de dépendances sont vérifiés sans cycle ;les compteurs phase/fiche/registre concordent.42212autres objets tâche et42212autres lignes de traçabilité restent exacts ;seulsGnar-ATTAQUE etSYS-01.2-02 reçoivent le contexte documentaire,l’enfant est ajouté. Les inconnues restent exactes en octets.
4. Sur deux copies privées de bases,le vrai **Store.sync_catalog** est exécuté avec les lectures de fichiers candidats explicitement substituées. Ce test vérifie le vrai importeur,sans présenter l’overlay comme une publication normale. Store.task,copy_text,list_packages etsummary vérifient ensuite la nouvelle fiche,son texte complet,la recherche exacte,la dépendance du parent et les totaux. Les sources statiques du backendRust sont inspectées ;la fenêtre nativeTauri n’est pas exercée dans ce lot.
5. Cinq refus contrôlent une identité modifiée,un consommateur absent,une source native étrangère,une fausse acceptation et la suppression de la dépendance du parent. Ces gardes propres à la migration ne sont pas présentées comme cinq tests du gameplay.
6. Après réussite du candidat,publication séquentielle des fichiers puis exécution normale de Store.sync_catalog dans les deux bases réelles. Aucun mécanisme globalement atomique n’est revendiqué ;les marqueurs et sauvegardes permettent de localiser une interruption. Aucun échec de publication n’a été observé.
7. Audit indépendant des fichiers publiés et des deux bases. Chaque base contient42607lignes catalogue dont42215actives ;42606anciens états/notes et23historiques sont conservés exactement. La nouvelle ligne est décochée,notes vides,révision0. Les42604autres lignes catalogue sont comparées champ par champ avec le seul décalage d’ordre attendu après l’insertion. L’intégritéSQLite estOK. Une nouvelle synchronisation normale ne modifie ni catalogue,ni métadonnées,ni états,ni historique.

Préparation,contrôle,publication et audit finissent tous au code0. Aucune case utilisateur n’est cochée et aucune acceptation humaine n’est attribuée. La graine embarquée de nouvelle installation,l’exécutableTauri et les estimations embarquées ne sont pas reconstruits ;l’intégration vérifiée porte sur les deux bases existantes du poste. Les reçus historiques à42214 restent datés et inchangés.

## Fichiers et preuves

Modifiés :docs/completion_tasks_2026-10-20.json ;docs/fidelity_requirement_ids_4_20.json ;docs/execution_plan_A_Z.json ;docs/fidelity_requirement_trace_4_20.json ;docs/fidelity_sources_4_20.json ;docs/OpenLeague_PLAN_DE_TRAVAIL_A_Z.md ;docs/OpenLeague_PLAN_DETAILS/D06.md. fidelity_unknowns_4_20.json est sauvegardé et vérifié mais reste exact. Couverture,plan de complétion,reprise et notescourantes reçoivent ce nouveau contexte,avec sauvegarde des anciennes valeurs.

Ajoutés :docs/reference_requirement_trace_sources/Gnar-projectile-plan-migration-v522.json ;docs/fidelity_Gnar_projectile_plan_migration_v522.json ;présent rapport. Une source de reçu est ajoutée,aucun consommateur de code. Graphe :98756sources,2633consommateurs,25827questions ouvertes,5517résoluesavec historique. Aucune question créée,fermée ou réassignée.

Travail conservé sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision522 :INPUT_PINS.json,baseline,candidate,databases-before,candidate-databases,PREPARED.json,CANDIDATE_CHECK.json,PUBLICATION_STARTED.json,PUBLISHED_*.json,PUBLISHED.json,DELIVERY_AUDIT.json. Scriptsrevision522_delivery.py,revision522_runner.py,revision522_finish_final.py,journauxrevision522_COMMAND_*. Les anciens essais etV521 restent conservés. Ne pas republier cette migration déjà intégrée.

## Suite

Poursuivre SYS-01.2-02 avec les122CH-*-MOUVEMENT-CHEMIN et122CH-*-MOUVEMENT-BLOCAGE. Inspecter d’abord les vraies entrées Move/Attack,le calcul et le suivi des routes réellement utilisés,les flags/rayons/profils natifs et les filtres de collision/occupation/immobilisation ;relier chaque lecteur exact sans confondre une métadonnée avec une fonctionnalité complète. Reprendre les anciennes preuves et défauts connus,ne pas recréer de moteur ni inventer la politique historique. Préserver la migrationV522 :42215tâches actives,identités anciennes exactes,nouvelleCH-Gnar-ATTAQUE-PROJECTILE àfaire,dépendance agrégat,formes/rendu/priorité ouverts. Les anciennes recettes à42214restent des reçus datés ;adapter uniquement les contrôles futurs à la population actuelle. Conserver tous critères,cases/notes/historiques,17auxiliaires et25827questions ouvertes. Goal entier actif.
