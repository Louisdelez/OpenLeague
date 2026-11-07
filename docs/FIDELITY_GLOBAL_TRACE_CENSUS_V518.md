# SYS-01.2-02 — Audit transversal et file des travaux V518

25 octobre 2026 ; F:\OpenLeague ; référence LoL PUBLIC4.20.0.315, EUW/en_GB. Catalogue4.20.1 distinct du client AIR0.0.1.119. Build littéral2014-11-17 17:46:45 ; fuseau et déploiement restent inconnus. Goal actif, tâche et jeu non terminés.

## Résultat vérifié

Les 42 214 exigences sont relues par les vrais requirement_trace.validate et resolve avec leurs exclusions de portée. Les 2 620 consommateurs correspondent aux lignes, tailles et SHA de leurs 509 fichiers actuels : zéro différence. Les 98 736 sources enregistrées avant cette livraison sont présentes et entièrement hachées : 23,083,475,676 octets, zéro différence. Les 7 historiques de source sont vérifiés avec leurs archives et reçus. Les quatre registres restent identiques pendant la collecte.

Ce contrôle porte sur la cohorte enregistrée. Il ne qualifie pas les fichiers originaux encore inconnus, la reconstruction de ressources, le rendu, le son, les services historiques ou un match ordinaire. Le hachage indépendant et source_versions.validate_history(verify_files=True) ne sont pas présentés comme l’exécution de la politique de racines requirement_trace.verify_files.

## Ce qui manque ou reste limité

Les catégories se chevauchent. Elles mesurent les liens et questions du registre, sans pourcentage de complétion du jeu.

| Observation | Fiches | Répartition |
| --- | ---: | --- |
| Sans entrée native associée | 385 | SYS 356, REF 24, MODE 5 |
| Sans consommateur non-plan applicable | 3,214 | EMPTY 72, SYS 1, MAP 84, NATIVE 1800, MODE 38, WORLD 15, UNIT 1204 |
| Non-plan applicables tous limités à une frontière | 1,908 | SYS 346, RUNE 1184, MASTERY 285, WORLD 16, UNIT 1, LOCALE 76 |
| Au moins une question ouverte | 20,088 | SYS 789, EMPTY 132, REF 24, CH 3660, RUNE 1480, MASTERY 342, SUMMONER 96, WORLD 333, STRUCTURE 108, CAMP 63, TT 140, MAP 84, NATIVE 1800, MODE 44, UNIT 1216, SKIN 9653, ROLE 10, LOCALE 114 |

Les 385 absences d’entrée native ne sont pas 385 assets perdus. Les SYS incluent des contrats locaux Rust/Tauri, des règles de preuve et des outils sans équivalent natif nécessaire ; les24REF sont des références communautaires. Les cinq Battle Training conservent leurs entrées de scénario non qualifiées et leurs sources client partielles. Aucune absence n’est résolue par simple classement.

Les 3 214 fiches sans consommateur non-plan applicable nécessitent l’examen de leur vrai consommateur avant d’affirmer une implémentation absente. Les 72EMPTY portent notamment des logs et marqueurs historiquement vides : ils ne sont ni remplis ni supprimés. SYS-03.4-07 reste le candidat d’archives indéterminé ; la réponse utilisateur « je n’en sais rien » ne permet pas de le remplacer par AnvilKit. Les 1 908 frontières seules comprennent notamment les runes, maîtrises et locales ; une entrée validée ne démontre pas leur chaîne fonctionnelle complète.

Les 20 088 fiches avec inconnues possèdent 25 827 questions ouvertes. Les5 517questions déjà résolues gardent leur historique. Parmi les champions,3 660fiches ouvertes se répartissent en30rôles de122champions : dix rôles de passif (source, contrat de simulation, simulation, réseau, animation, VFX, audio, HUD, présentation et acceptation) et cinq rôles de présentation pour chacun des sorts Q/W/E/R. Cette distribution n’invalide pas les implémentations partielles existantes et ne prouve pas les autres rôles complets.

## Comparaison avec V510

Les ensembles de42 214identifiants sont identiques. Les marqueurs structurels sont inchangés ;2 442fiches ont des détails d’association ou de référence différents depuisV510. Douze CID ont été ajoutés, aucun retiré. Les2 440fiches de champs statistiques précis conservent leurs preuves V512–V517, y compris30branches de régénération inapplicables. Cela n’équivaut pas à2 440fonctionnalités de jeu acceptées.

Les17consommateurs sans lien direct actif sont exactement ceux conservés et justifiés enV512 : seize sources de tests Annie/World et un contexte World/Tibbers. Ils ne sont pas supprimés, reliés artificiellement ou présentés comme de nouvelles exécutions. Les anciennes preuves CPU, natives et JS ne sont pas rejouées. Les20écarts f32V517, sixV516, quatreV513, les arrondis de santéV515, les102defaultsMana et les conversions locales de ticks restent bornés par leurs reçus.

REVIEW_QUEUE.json fournit les identifiants, titres, liens et inconnues de chaque catégorie, les30files de rôles champions et les transitions V510/V518. Ces files se chevauchent et gardent l’ordre enregistré ; elles ne constituent ni une estimation d’effort ni une déclaration de manque généralisée.

## Vérifications réellement exécutées

1. v518_global_census.py puis v518_source_hashes.py : validation/résolution des42 214exigences,2 620ancres et identités, existence/taille puis hachage complet des98 736sources, archives de versions et préservation des registres. Les scripts exécutés surE: et leurs copies identiques surF: sont pinés.
2. v518_review_queue.py : comparaison des ensembles/flags avecV510, listes exactes par catégorie et égalité des17auxiliaires avecV512. Zéro tâche, question ou case modifiée par la collecte.
3. Préparation depuis quatre sauvegardes gzip et contrôle du candidat avec le vrai lecteur :42 214textes de traçabilité comparés, tous inchangés ;42 213autres objets tâche/trace exacts. Le contexte complet de SYS-01.2-02 reçoit les preuves et files. Le texte synthétique conserve ses limites d’abrègement existantes.
4. Vingt refus de livraison : cohorte source manquante/doublonnée, SHA/taille/match invalides, faux succès/achèvement, total d’octets incorrect, historique absent/doublonné/invalide, ancre ou identité courante invalide, consommateur ou tâche absent/doublonné. Deux sélecteurs invalides sont aussi refusés par la préparation. Ce sont des gardes du livrable, sans attribution au lecteur public de contrôles qu’il ne fait pas.
5. Préparation, contrôle, publication et audit terminent tous au code0, avec journaux et reçus. Dans chacune des deux bases, les vrais Store.task/copy_text, rt.resolve et instructions vérifient une fiche documentaire ;42 605autres lignes,42 606états/notes et23historiques sont exacts. Intégrité SQLiteOK. Les écritures de registres et bases sont séquentielles, sans atomicité globale revendiquée.

Attendu et observé : recontrôler les identités, exposer les écarts de couverture et intégrer les preuves uniquement à SYS-01.2-02, sans acceptation automatique. Aucun écart d’identité relevé ; aucune inconnue créée, précisée ou résolue. Aucun code produit, lecteur, donnée de jeu ou asset modifié. Aucun build, jeu natif/AIR, serveur/client, LuaVM/NodeVM, GPU ou audio exécuté pendantV518.

## Fichiers livrés

- Reçu : docs/reference_requirement_trace_sources/global-census-v518.json.
- Preuve : docs/fidelity_global_trace_census_v518.json ; présent rapport.
- Quatre nouvelles sources : le reçu et GLOBAL_CENSUS.json, SOURCE_HASH_CHECK.json, REVIEW_QUEUE.json. La cohorte hachée de98 736précède leur ajout ; les quatre nouveaux fichiers sont pinés séparément. Graphe après publication :98 740sources,2 620consommateurs,25 827questions ouvertes et5 517résolues.
- Seuls les références, note, recherche et contexte documentaire de SYS-01.2-02 changent dans fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json. fidelity_sources_4_20.json reçoit les quatrepreuves ; fidelity_unknowns_4_20.json reste exact en octets.
- Couverture, plan de complétion et reprise ajoutent le bilan sans écraser les anciens champs. CURRENT.md et HANDOFF.md sont actualisés après sauvegarde. Aucun critère, dépendance, statut de question, état manuel, note ou historique utilisateur modifié.
- Scripts, observations, sauvegardes, commandes et audit : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision518* ; scripts de collecte réellement lancés : E:\mapslol3v3\v518_*.py. Python -X utf8 -E -u -B ; interpréteur identifié dans le reçu de hachage et l’environnement. Ne pas relancer une publication exclusive sans examiner les marqueurs et preuves.

## Suite concrète

Poursuivre SYS-01.2-02 par CH-*-MOUVEMENT-RAYON et CH-*-ATTAQUE-WINDUP : inspecter les lecteurs effectifs et les liens existants des122champions, distinguer gameplay/pathfinding/selection radius et ticks de windup dérivés ; conserver les defaults/absences natifs et conversions locales, sans importer une sémantique serveur non prouvée. Utiliser REVIEW_QUEUE V518 pour les autres lots. Préserver les2440liens de champs statistiques,20+6+4écarts f32,arrondis santé,102defaultsMana,17auxiliaires,questions/cases/notes/historiques et le Goal entier.
