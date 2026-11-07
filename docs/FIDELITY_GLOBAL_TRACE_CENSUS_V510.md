# SYS-01.2-02 — Inventaire global des sources et consommateurs V510

25 octobre 2026 ; F:\OpenLeague. Goal actif. Cette livraison reprend l’intégralité des 42 214 exigences actives après V509, au-delà du seul sous-inventaire World. Elle identifie les lacunes de couverture et vérifie les fichiers enregistrés ; elle ne termine pas le jeu.

## Résultats constatés

- Le vrai lecteur requirement_trace.validate accepte le graphe actuel ; resolve est exécuté sur chacune des 42 214 exigences avec ses exclusions par exigence.
- Les 2 608 consommateurs enregistrés correspondent à leurs fichiers actuels : SHA-256, taille et aiguille à la ligne enregistrée sont exacts. Ils représentent 509 fichiers distincts. Aucun déplacement de ligne ou changement d’identité n’est relevé dans ce périmètre.
- Les 98 711 sources du registre avant publication existent et ont la taille enregistrée. Un contrôle séparé recalcule effectivement leur SHA-256, pour 22 926 610 684 octets ; ses observations détaillées et les contrôles des archives de versions sont conservés. L’existence et la taille seules ne sont pas présentées comme preuve d’intégrité.
- Les quatre registres d’entrée sont inchangés pendant ces collectes. Le nouveau reçu et les deux observations sont ensuite ajoutés comme trois nouvelles sources, pinées séparément. La cohorte de 98 711 ne prétend donc pas avoir contenu ces preuves avant leur création.

La correspondance d’une source ou d’un consommateur ne prouve pas qu’une fonctionnalité est entièrement implémentée ou fidèle. Les fichiers non enregistrés et les ressources originales encore inconnues restent hors de ce contrôle d’identité. Un fichier de taille et d’empreinte attendues peut lui-même représenter une source partielle, une ressource historiquement vide, un contrat local ou une ancienne preuve bornée.

## Lacunes de couverture et limites à conserver

Les observations structurelles se chevauchent ; ce ne sont ni des tâches achevées ni un pourcentage du jeu :

| Observation sur les exigences | Nombre | Interprétation bornée |
| --- | ---: | --- |
| Au moins une question ouverte | 20 088 | La question et sa condition de résolution restent dans le registre |
| Sans entrée native | 385 | 356 SYS, 24 REF, 5 Battle Training ; pas 385 assets manquants |
| Sans consommateur non exclu | 3 141 | Les anciens liens hors portée restent conservés |
| Sans consommateur non-plan non exclu | 3 214 | Comprend les 3 141 précédentes et 73 fiches où subsiste le plan |
| Non-plan actifs tous explicitement non fonctionnels | 1 916 | Frontières, lecteurs ou références ; pas une fonctionnalité terminée |
| Non-plan actifs tous de type entry_boundary_only | 1 908 | Sous-ensemble des 1 916 précédentes |
| Au moins une exclusion de portée | 3 173 | Une même exigence peut aussi avoir des consommateurs applicables |

Le registre contient 25 827 questions ouvertes et 5 517 résolues avec historique. Une exigence peut avoir plusieurs questions ; ces deux niveaux ne doivent pas être confondus. L’absence de question ne démontre pas non plus une acceptation de comportement.

Les 3 214 fiches sans consommateur non-plan actif comprennent 1 800 NATIVE, 1 204 UNIT, 84 MAP, 38 MODE, 15 WORLD, 72 EMPTY et une SYS. La fiche SYS-03.4-07 porte le candidat d’archives non identifié : la réponse utilisateur « je n’en sais rien » ne le transforme pas en AnvilKit ni en preuve installable. Les 72 EMPTY portent des fichiers historiques vides, dont des logs et marqueurs ; ni leur nom ni leur taille n’autorise à les remplir ou les supprimer. Les preuves natives partielles V59/V61/V160/V161 et leurs inconnues restent conservées.

Dix-huit consommateurs n’ont pas de lien direct current_consumers dans une exigence active : regeneration.rs, des sources de tests Annie et World, et une frontière de routage World. Ce constat ne les rend pas inutiles : ils peuvent appartenir à une preuve composée ou historique. Tous sont conservés ; aucun lien de fonctionnalité n’est inventé pour faire disparaître ce compte.

Les contrats techniques locaux parmi les 356 SYS sans entrée native peuvent n’avoir aucun équivalent natif attendu (identité stable des tâches, politiques de preuve, outillage Rust/Tauri). Les autres cas nécessitent leur examen propre. Les 24 REF restent des références communautaires ; les cinq Battle Training gardent leurs manques natifs spécifiques. Ce classement par famille ne constitue pas une résolution individuelle de ces 385 exigences.

## Contrôles réellement exécutés

1. revision510_global_census.py : validation structurelle et résolution des 42 214 exigences, lecture des 509 fichiers actuels, comparaison de 2 608 ancres/identités, existence/taille de 98 711 sources, préservation des quatre registres.
2. revision510_source_hashes.py : lecture complète et SHA-256 des 98 711 fichiers enregistrés, contrôle des archives et reçus des sources versionnées avec source_versions.validate_history(verify_files=True), conservation du registre source. Ce programme distinct ne prétend pas avoir exécuté requirement_trace avec sa politique de racines verify_files.
3. revision510_delivery.py prepare et revision510_check.py : candidat construit depuis quatre sauvegardes gzip, ensembles exacts des IDs de sources/tâches/consommateurs contrôlés ; dix refus de cohorte incomplète, doublon, mauvaise identité, faux succès/achèvement ou historique invalide. Deux sélecteurs invalides refusés. Tous les anciens enregistrements restent exacts.
4. Les 42 214 textes de traçabilité sont comparés : aucun ne change, car le lecteur synthétique conserve ses premières sources/consommateurs ; le contexte documentaire complet de SYS-01.2-02 reçoit le reçu global. Les 42 213 autres tâches et fiches de traçabilité restent identiques. Toutes les questions et tous les consommateurs restent identiques.
5. Publication et audit indépendant : actual Store.task/copy_text, rt.resolve et instructions sur SYS-01.2-02 dans chacune des deux bases. Une ligne de catalogue actualisée par base, 42 605 autres lignes exactes, 42 606 états/notes et 23 historiques exacts, intégrité SQLite OK. Les écritures de registres et bases sont séquentielles ; elles ne sont pas décrites comme une transaction globale atomique.

Attendu : vérifier les identités sans promouvoir la couverture en acceptation et sans modifier les suivis manuels. Les observations, refus et audits fournissent le résultat exact ; tout écart éventuel reste un écart, sans réparation automatique de hash ou réattribution de source.

Aucun build, binaire de jeu, AIR, serveur/client local, VM Lua, NodeVM, GPU ou audio n’est exécuté. Aucun code produit ou asset de distribution n’est modifié. Les anciens cas CPU, JS et natifs ne sont pas rejoués ni présentés comme des preuves de classement actuel.

## Fichiers et intégration

Sources de preuve : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision510_global_census\GLOBAL_CENSUS.json, SUMMARY.json et SOURCE_HASH_CHECK.json. Les scripts revision510_global_census.py, revision510_source_hashes.py, revision510_delivery.py, revision510_check.py et revision510_finish.py sont dans le même dossier de travail parent. L’interpréteur Python et les scripts sont identifiés par taille/SHA dans les reçus. Options Python : -X utf8 -E -u -B. Les publications à création exclusive ne doivent pas être rejouées à l’aveugle.

Dans F:\OpenLeague : reçu docs/reference_requirement_trace_sources/global-census-v510.json, preuve docs/fidelity_global_trace_census_v510.json, présent rapport. Trois sources ajoutées à fidelity_sources_4_20.json ; références, recherches et note ajoutées uniquement à SYS-01.2-02 dans fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json. fidelity_unknowns_4_20.json reste identique. Deux bases : seule la donnée/instruction documentaire de SYS-01.2-02 change. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md reçoivent le bilan, avec leurs versions précédentes sauvegardées. Aucun critère, dépendance, statut de question ou état manuel n’est modifié.

## Suite concrète

Utiliser cet inventaire global comme index de sélection, pas comme déclaration de fin. Examiner les exigences sans entrée native avec leurs contrats locaux et consommateurs réels, en commençant par SYS-01.2-01 et les neuf politiques SYS-01.4 : distinguer absence attendue d’équivalent natif et lacune réelle, puis lier les sources locales précises sans fermer les questions d’acceptation restantes. Conserver les cas communautaires, le candidat d’archives indéterminé et les limites Battle Training ouverts. Les preuves et gardes V509 sur les modes classés restent exactes ; les services locaux files/équipes/ligues et la logique serveur historique restent à traiter dans leurs tâches.

Bilan final vérifié : collecte, hachage complet, préparation, candidat, publication et audit terminaux0. 98711sources / 22926610684octets, zéro écart d’identité ; 7sources avec historique validé. Trois nouvelles preuves pinées séparément ; graphe après publication 98714sources/2608consommateurs/25827questions ouvertes/5517résolues avec historique. Deux bases :1fiche documentaire chacune,42605autres lignes exactes,42606états/notes et23historiques conservés,intégritéOK. Zéro tâche de jeu acceptée,aucune inconnue créée/affinée/résolue.
