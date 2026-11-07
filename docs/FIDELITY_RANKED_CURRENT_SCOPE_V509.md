# SYS-01.2-02 — Classement Solo et Équipe : sources et portée des consommateurs V509

25 octobre 2026. Projet F:\OpenLeague. Cette livraison documente dix exigences du référentiel : cinq pour RANKED-SOLO et cinq pour RANKED-TEAM (SCOPE, SELECT, RULES, RANK, RESULT). Le Goal reste actif. Les exigences, critères de fin et prérequis restent ouverts ; aucun mode classé ni jeu complet n’est déclaré terminé.

## Résultat et limite principale

Les dix fiches avaient un lien brut vers World. Ce point de code local ne démontre pas les parcours classés historiques. Les liens sont conservés, qualifiés hors portée dans chaque exigence, sans modifier le rôle global ni les autres usages du consommateur. Les 65 occurrences de liens natifs existants restent exactes. Aucun consommateur de fonctionnalité ni lien natif nouveau n’est inventé.

Les vingt questions ouvertes de ces fiches sont précisées : les sources AIR partielles retrouvées ne sont plus masquées par un ancien constat générique d’absence de fichier. Identifiants, propriétaire, aspect, statut ouvert et compteurs restent exacts. Les anciennes questions et conditions de résolution sont datées dans question_history ; les recherches précédentes restent intégralement en préfixe. Aucune inconnue n’est créée ni résolue par cette correction.

Les services locaux queues, teams et leagues sont déclarés not_implemented dans reference_local_services_4_20.json. Leur lecteur de périmètre est une fonction documentaire en lecture seule : il n’appelle aucun RPC et ne constitue pas un backend opérationnel. Les corps actuels du launcher, des sessions, de World, des résultats et du serveur ont été relus. Le résultat local et son gold_remaining ne constituent pas un résultat classé, des LP ou une récompense de compte. La base du plan n’est pas une base de comptes de jeu.

## Entrées et contrat historique

Référence : League of Legends 4.20.0.315 PUBLIC, Releases/4.20, EUW/en_GB ; littéral de build 2014-11-17 17:46:45, fuseau et date de déploiement non établis. Le catalogue 4.20.1 et le composant AIR 0.0.1.119 restent des identités distinctes. AGENTS.md, CURRENT.md, HANDOFF.md, DECISIONS.md, l’objectif joint du Goal et les phases/lots D01-SYS-01-2, D11-MODE-RANKED-SOLO, D11-MODE-RANKED-TEAM ont été consultés. Leur consultation ne vaut pas achèvement des prérequis.

Quatre reçus AIR sont sélectionnés par famille, rôle et propriétaire exacts :

| Contexte | Fichier dans docs | Occurrences d’ancres | Fenêtres |
| --- | --- | ---: | ---: |
| Solo SCOPE V404 | reference_ranked_solo_scope_sources/ranked-solo-scope-source-contract-v404.json | 36 | 0 |
| Team SCOPE V411 | reference_ranked_team_scope_sources/ranked-team-scope-source-contract-v411.json | 63 | 0 |
| Solo quatre rôles V444 | reference_ranked_solo_mode_roles_sources/ranked-solo-mode-roles-source-contract-v444.json | 497 | 191 |
| Team quatre rôles V445 | reference_ranked_team_mode_roles_sources/ranked-team-mode-roles-source-contract-v445.json | 483 | 202 |

Total : 1 079 occurrences d’ancres et 393 fenêtres réidentifiées avec leurs sources. Ce sont des occurrences, pas autant de fichiers ou de comportements indépendants. Les qualifications natives et revues antérieures ne sont pas rejouées. Les tailles et SHA-256 des reçus, exports, autorités et fichiers sélectionnés sont consignés dans le reçu et la collecte.

Le contrat est conservé avec ses distinctions :

- Solo : entrée et filtre ranked=true/minimum1 ; minimum1 ne prouve ni maximum de groupe, ni admission duo, ni file/carte ou disponibilité EUW.
- Team : chemin d’équipe nommée, restart, demande queueId/teamName sous ranked et teamOnly ; le filtre PREMADE ranked/minimum>1 ne vérifie pas teamOnly. Les lectures tardives de nom/ID et l’initialisation restent distinctes. Un drapeau littéral de service ne prouve pas sa configuration effective.
- SELECT : flags, activité, disponibilité, pools, ownership, spectateur, choix direct, wildcard et override partagé restent conditionnels. Une garde Solo n’est pas transférée à Team.
- RULES : minima relus sous !Solo, fallback nommé et reconversion numérique sont des points distincts. La conversion Number ne qualifie pas la validité ou la plage de l’identifiant ni une politique d’IA. Les minima ne prouvent pas un maximum duo ou une éligibilité d’équipe.
- RANK : DTO, cache, événements et LP fournis sont une source client partielle. Une notification peut précéder un retour false ; un DTO invalide peut ne sauter qu’une mise à jour. Aucun calcul serveur de MMR/LP, promotion, relégation ou persistance n’est déduit.
- RESULT : les lectures Solo2471/2484/2490 et Team/Premade2498, la priorité CAP, les trois prédicats WIN, le premier slot indexé, le OR littéral et les états UI gardent leurs conditions propres. Aucun isSolo=false ni garde Solo n’est ajouté à Team par analogie. Résultats, récompenses, retour et rejeu effectifs restent à qualifier.

Les 31 occurrences natives Solo et 34 Team restent inchangées (par rôle : 4/8/6/8/5 et 6/8/7/8/5). entity.map=null, required, required_if, dépendances et critères de toutes les fiches sont conservés.

## Consommateurs actuels inspectés

Le registre contient dix-sept références/frontières portant des noms ranked, league, ladder, mmr ou matchmaking : trois lecteurs documentaires et quatorze frontières de session/résultat. Les aiguilles de ligne et les identités courantes correspondent aux sources enregistrées : zéro différence sur ces dix-sept fichiers sélectionnés. Aucun de ces noms ne devient une preuve de classement fonctionnel.

Le handler Tauri courant expose roster, play, join_local, session_status, resume_session et abandon_session. Les corps relus couvrent launcher/web/app.js, launcher/src-tauri/src/main.rs et sessions.rs, crates/core/src/world.rs, lib.rs et match_results.rs, crates/server/src/main.rs et result_store.rs. La requête locale existante, l’admission et la sauvegarde de résultat restent des acquis distincts des files, équipes, ligues et règles historiques.

La recherche bornée porte sur 1 203 fichiers Rust/JS/TS/HTML hors target et node_modules. Trois fichiers correspondent aux motifs ; leurs fenêtres sont relues : commentaire de niveau de sort dans six_client_match_observation.rs, rangs de Trundle W/CastRange dans trundle_w.rs, texte alternatif du logo dans index.html. Aucun ne démontre un classement de compte. Ce constat lexical et ces lectures ne prouvent pas une absence globale d’implémentation.

## Vérifications : attendu et observé

| Contrôle | Attendu | Observé |
| --- | --- | --- |
| Sources | Identités et lignes/fenêtres inchangées | 1 613 fichiers pinés vérifiés ; 1 079 ancres et 393 fenêtres |
| Sélection par famille/rôle | Une seule association, bon propriétaire | 10 associations nominales ; 42 refus de source absente/dupliquée, mauvais propriétaire/famille ou rôle inconnu |
| Lecteur de services | Pas d’implémentation ni d’appel serveur déduit | 8 cas documentaires : 3 déclarations non implémentées, 3 demandes originales hors contrat, famille inconnue et doublon refusés |
| Portée publique | Refuser une fausse fonctionnalité, preuve absente, CID étranger ou doublon | 40 refus, quatre par exigence |
| Questions publiques | Refuser propriétaire incorrect, fausse résolution ou condition vide | 60 refus, trois par question |
| Conservation d’historique | Ancienne question/condition/recherche obligatoire | 20 gardes de livraison refusent la suppression ; le lecteur générique accepte cette suppression et ne contrôle donc pas cet historique |
| Instructions de traçabilité | Seulement les dix fiches classées changent | 42 214 textes comparés : 10 changés, 42 204 exacts |
| Contexte de tâche | Association et IDs qualifiés cohérents avant publication | 11 contextes précontrôlés, dont SYS-01.2-02 |
| Préservation | Fiches voisines et données manuelles exactes | 18 fiches Custom/CoOp/Tutorial/Battle Training et leurs questions exactes ; audits des deux bases après publication |

Le contrôle de publication compare les quatre empreintes de registre de départ et toutes les sources pinées. La comparaison candidate et l’audit reconstruisent les documents depuis leurs quatre sauvegardes de départ. Les refus publics et les gardes de livraison sont distingués ; aucune propriété sémantique absente du lecteur générique ne lui est attribuée.

## Livrables et reproduction

Dans F:\OpenLeague, fichiers de registre modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json, docs/fidelity_unknowns_4_20.json. Reçu : docs/reference_ranked_solo_mode_roles_sources/ranked-current-scope-v509.json. Preuve : docs/fidelity_ranked_current_scope_v509.json. Rapport présent, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont mis à jour en conservant leurs états précédents sauvegardés. Seules les données/instructions documentaires de onze fiches par base sont actualisées dans les deux bases du plan ; aucun état, note ou historique manuel n’est remplacé.

Sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20 : revision509_inspection.py, revision509_delivery.py, revision509_check.py, revision509_finish.py et revision509_report.txt décrivent la collecte, préparation, candidat, publication, audit et mise à jour documentaire. revision509 contient les quatre sauvegardes gzip, BASELINE.json, PREPARATION.json, SIMULATED_DELTA.json, SOURCE_LINK_RECEIPT.json, CANDIDATE_CHECK.json, DELIVERY_AUDIT.json et les reçus documentaires/environnement. revision509_inspection/RANKED_SCOPE_OBSERVATIONS.json contient les observations de source, les huit cas documentaires et le corpus recherché. Les commandes de publication à création exclusive sont historiques et ne doivent pas être rejouées sur les mêmes destinations.

Interpréteur : C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe ; options -X utf8 -E -u -B. Les identités des scripts, de l’interpréteur et des entrées sont enregistrées. La sortie terminale de la préparation n’était plus disponible à la reprise ; son reçu PREPARATION passed=true est présent, puis le candidat indépendant reconstruit et vérifie le résultat. Aucun code de sortie de préparation n’est inventé.

## Manques et suite

Restent ouverts : provider/catalogue/file/carte/configuration et disponibilité EUW effectifs ; maximum de groupe/admission duo ; identité, membres, permissions et éligibilité d’équipe ; composition et validation serveur de sélection/règles ; service de file, équipes et ligues ; règles locales versionnées et limites par rapport au MMR Riot non récupéré ; résultat autoritaire lié au classement, application idempotente/persistance, retour/rejeu ordinaires et validation de fidélité appropriée. Les sources client disponibles ne récupèrent pas automatiquement la logique des serveurs d’origine.

Aucun code produit, asset ou case n’est changé. Aucun jeu, AIR, VM Lua, NodeVM, processus serveur/client, build Rust, GPU ou audio n’est exécuté par V509. Les huit cas Python lisent un contrat et ne sont pas des tests de backend. Les preuves CPU V505 et contrôleur JS V508 restent hérités, non rejoués et non attribués au mode classé.

Poursuivre SYS-01.2-02 par un inventaire global des 42 214 exigences, hors du seul sous-inventaire des liens World. Vérifier les compteurs de sources, consommateurs qualifiés/hors portée, questions et dépendances de preuve ; choisir ensuite un écart concret de source/consommateur à résoudre. Une référence qualifiée hors portée demeure une tâche ouverte, pas une fonctionnalité retirée ni terminée. Aucun pourcentage d’achèvement du jeu n’est déduit du nombre de liens corrigés.

Bilan après publication et audit indépendants : deux sources de preuve ajoutées ; aucun CID ou lien natif/consommateur nouveau ; 65 occurrences natives exactes. Dix références hors portée et vingt questions affinées, zéro création/résolution. Graphe : 98711 sources / 2608 consommateurs / 25827 inconnues ouvertes / 5517 résolues avec historique. Deux bases : onze fiches relues chacune, 42595 autres lignes de catalogue exactes ; 42606 états/notes et 23 historiques exacts, intégrité OK. Candidat, publication et audit terminaux0. Préparation : reçu passed=true présent et résultat reconstruit par le candidat ; retour terminal non disponible à la reprise, code non affirmé. Aucun jeu ou backend classé exécuté. Sous-inventaire World seulement :1SYSà reprendre/477partielles/62lignes horsportée encore ouvertes dont27audio ;2liens TTpartiels comptés séparément.
