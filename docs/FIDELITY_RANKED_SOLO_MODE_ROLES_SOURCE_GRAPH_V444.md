# SYS-01.2-02 — Sources des quatre rôles Solo classé, V444

Les contrats historiques de sélection, de demande de file, de classement et de résultat sont maintenant reliés à leurs quatre fiches du plan et à la synthèse SYS-01.2-02. Les instructions copiables des bases du projet et de l’application bureau restituent ces liens. La livraison ajoute un reçu de qualification ; les 14 autorités AIR et 62 exports dérivés étaient déjà recensés. Aucun nouveau consommateur de jeu n’est qualifié.

Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45. Fuseau et date de déploiement restent inconnus. Le catalogue 4.20.1 et la release AIR 0.0.1.119 sont des identités distinctes. Travail réalisé sur F:/OpenLeague et F:/OpenLeague-work ; les identités historiques E: sont conservées.

## Contrats et sélecteurs

Le reçu est `docs/reference_ranked_solo_mode_roles_sources/ranked-solo-mode-roles-source-contract-v444.json` ; la preuve de livraison est `docs/fidelity_ranked_solo_mode_roles_source_graph_v444.json`.

| Fiche | Sélecteur | Sources et relecture | Portée qualifiée |
| --- | --- | --- | --- |
| MODE-RANKED-SOLO-SELECT | /associations/0 | 430/434 | Conditions de disponibilité, filtres et requête humaine non aléatoire |
| MODE-RANKED-SOLO-RULES | /associations/1 | 436/437 | Construction de la demande de file et traitement conditionnel des callbacks |
| MODE-RANKED-SOLO-RANK | /associations/2 | 433/435, sous-contrat Solo | Requêtes, cache et présentation des données de ligue fournies |
| MODE-RANKED-SOLO-RESULT | /associations/3 | 441/443, sous-contrat Solo | Présentation des résultats fournis, retour et demande de rejeu |
| SYS-01.2-02 | /associations | Union exacte des quatre rôles | Ensemble des liens ci-dessus |

Les contrats Team ne sont pas inclus par simple partage de code. SCOPE404/414 demeure un acquis séparé et inchangé. Chaque chaîne reste conditionnelle aux retours normaux et à l’absence d’intervention pertinente par des callbacks, notifications, réentrance ou changements de cycle de vie.

### Sélection

Les lectures ponctuelles de `gameType` ne prouvent pas un mode durable. La priorité des branches spectateur, tutoriel, pools d’équipe et catalogue partagé reste explicite. Le cas ranked de `showRandom` est une branche de repli ; le wildcard aux lignes 199–203 peut annuler un rejet antérieur.

Le helper vérifie null puis le spectateur avant la phase inactive. La garde `activepick` de la méthode publique est distincte. L’OR de Summon162 lit notamment un champ partagé `tutorialPickOverride` : un indicateur `isTutorial=false` ne prouve pas que ce champ vaut false. Le résultat ACK590 n’est pas testé comme booléen ; les lectures ultérieures de state et bans restent séparées. Provider déjà présent et acquisition ultérieure1474/1477 sont deux routes distinctes.

Skins, wards, bots, composition entière, droits du joueur et réponse serveur restent hors de cette qualification partielle.

### Demande de file

La lecture `isSolo` à418 peut sauter uniquement le bloc de minimum420–432. Elle ne prouve aucune limite duo ou politique d’admission. Sur la branche non-Solo, la deuxième comparaison à424 peut être atteinte même sans appel au fallback422. `Number435` capture seulement l’identifiant ; les autres champs et getters ne constituent pas un instantané atomique.

L’implémentation déclarée transmet `attachToQueue` avec ses paramètres et callbacks. Dans le callback inspecté, `isJoiningMatch=false` précède la première lecture du payload. Une collection d’échecs non null, même vide, conduit au handler puis au retour si ce handler termine normalement. Les politiques serveur de file, pénalité, MMR et admission restent inconnues.

### Classement

Le message peut être bufferisé en l’absence de statistiques ; stockage et dispatch sont distincts. La relance de la requête précède l’effacement des indicateurs dans le corps inspecté. `getMyLeaguePositions` passe par l’implémentation de service déclarée, sans preuve de réponse effectivement reçue.

Le test de type du DTO conditionne une mise à jour mais ne supprime pas toutes les opérations ultérieures. `LEAGUE_POINTS_UPDATE` et `NOT_YET_SEEDED` peuvent provoquer un dispatch avant un retour false. Les champs LP, progression et placement décrivent les données fournies ; ils ne révèlent pas de formule MMR/LP, de propriété d’équipe ou de service local de classement implémenté.

### Résultat

Trois prédicats WIN distincts, l’accès au premier élément de collection et les OR2904/2918 restent séparés. Les champs de récompense et de prévisualisation ne prouvent pas leur calcul ou leur attribution serveur. Le resetfalse688 appartient à `deactivate` ; `cleanupCycle608–610` est vide.

Le cas nommé `RANKED_GAME_SOLO` à2447 appelle la route de rejeu Solo avec un paramètre relu, la garde2471 et les lectures `isSolo` à2484 puis2490. La route Team2498 est exclue. Le flag UI stocké `allowedToPlayAgain` est distinct de la méthode `Master.allowedtoPlayAgain()`. L’annexe des getters441 conserve ses 16 contrôles propres, séparés de ses 421 contrôles de source et des 1 226 contrôles de la relecture443.

## Consommateurs actuels et provenance

Le lookup a examiné la capture de 98 586 sources sans filtrer les anciennes versions ou origines : 76 groupes de contenu, 146 records d’alias et 378 fichiers physiques. Les identités enregistrées sur E: et leurs copies F: restent distinctes. Aucun record n’est redirigé vers un autre chemin.

Les corps actuels ont été examinés avant décision. World185 lié à Map10, les points d’entrée du launcher, les sessions et les corps de résultats conservent leur portée existante. Aucun corps local Solo supplémentaire n’est qualifié par cette livraison ; aucune absence globale d’implémentation n’est déduite de cette recherche bornée. Les listes `current_consumers` restent strictement égales aux listes antérieures. Le consommateur effectivement vérifié ici est le plan : fiche, trace, instructions et copie avec notes.

Le préparateur444 a également produit la relecture435 : aucune nouvelle indépendance n’est revendiquée sur cette pièce. Les auteurs restent attribués séparément : Combat430/436/441, Spell434/443, FreshCustom433/437 et Current435. Les huit reçus de source conservent leur `registration_ready=false` historique ; la préparation444 porte sa propre décision de publication analytique.

La normalisation conserve les formats des fenêtres héritées. Le hash434 porte sur ses lignes numérotées ;433/435 et441/443 utilisent leur format LF déclaré. Les hashes LF calculés par444 sont distincts. L’annexe des getters ne reçoit pas de hash hérité inventé. Les refus privés antérieurs restent conservés.

## Vérifications réellement exécutées

Le registrar a terminé avec code0, session59766, dernier retour025f00. Une copie exacte de sa preuve brute a été conservée avant l’audit. L’audit séparé a terminé avec code0, session85522, dernier retour5e050c. Aucun rejeu de ces commandes n’a été effectué.

| Vérification | Attendu | Observé |
| --- | --- | --- |
| Sources ciblées et ancres | Identités et fenêtres inchangées | 1 093 contrôles, 275 identités, 497 ancres, 191 fenêtres ; aucune erreur |
| Sélecteurs nominaux | Quatre rôles et union exacte | 5 cas acceptés |
| Mauvais rôle, cible ou union | Refus explicite | 28 sélecteurs refusés |
| Contrat altéré ou portée promue | Refus explicite | 23 contenus refusés |
| Fiches, instructions, copie et résolution | Cinq fiches exactes dans chaque base | 5/5 dans chacune des 2 bases |
| Autres lignes du catalogue DB | Inchangées | 42 601 lignes exactes par base |
| États et notes | Conservation intégrale | 42 606 états et notes exacts par base |
| Historique | Conservation intégrale | 23 lignes exactes par base |
| Intégrité SQLite | ok | ok pour les 2 bases |

Les lectures de contrôle utilisent URI `mode=ro`, `query_only` et un authorizer. Les méthodes ordinaires `Store.task`, `copy_text`, `requirement_trace.resolve` et de génération des instructions sont utilisées ; les notes existantes sont incluses dans la copie. Les bases projet et bureau sont physiquement distinctes.

Les 53 contrôles de préparation AST/métadonnées/simulation, 22 contrôles de scellement, 7 contrôles positifs et 20 refus de garde finale restent séparés. Les 61 pins privés de la revue ROOT et ses six analyses AST ne sont pas des tests du jeu. Aucun jeu original, AIR, instruction native, VM, compilation Rust ou GPU n’a été exécuté pour cette livraison.

Le graphe contient maintenant 98 587 sources et 2 408 consommateurs. Les 25 321 questions ouvertes et 5 517 questions résolues restent inchangées. `source_hashes_verified=0` désigne la validation structurelle des métadonnées ; les rehashs physiques ciblés sont documentés séparément.

## Conservation et fichiers modifiés

Les sauvegardes précèdent les trois remplacements JSON puis les deux transactions DB optimistes. Ces opérations sont séquentielles, sans atomicité globale revendiquée. La livraison s’arrête sur erreur et ne rejoue pas automatiquement une mutation.

Les anciens records, origines, versions, inputs, flags, scopes, évaluations et statuts sont conservés. Les 42 209 autres exigences actives sont exactes. Les huit questions des quatre rôles restent ouvertes ; leurs quatre `entity.map=null` sont distincts de `SYS.entity=null`. Aucune acceptation ni case n’est modifiée automatiquement.

Fichiers de données concernés : `docs/fidelity_sources_4_20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/completion_tasks_2026-10-20.json` et cinq fiches dans chaque `plan.sqlite3`. Le registre des inconnues reste identique octet pour octet. Reçu, preuve, ce rapport et documents de couverture/reprise accompagnent la livraison.

Scripts, copies brutes, sauvegardes et observations réelles : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision444`. Préparation : dossier `revision444_ranked_solo_mode_roles_source_link_preparation`. Les refus de contrôle automatique et l’autorisation humaine de reprise sont conservés dans les pièces privées, sans transformer les refus avant processus en codes0.

## Travail restant

La revue de livraison446 est reliée. La préparation445 attend le checkpoint de liaison ROOT. Viennent ensuite les contrats Team445/447, les appels input-lock450/451 et la liaison du consommateur textuel ITEM1001 déjà identifié. Le bilan daté `docs/SOURCE_ASSOCIATION_REMAINING_2026-10-24.md` conserve le reste du travail de traçabilité.

Les providers effectifs, DTO reçus, disponibilité des files EUW, admission duo, propriété, MMR/LP, montage et comportement serveur restent ouverts. L’archive SYS-03.4-07 demeure inconnue ; AnvilKit est une piste. Cette livraison ne termine ni l’objectif global SYS-01.2-02 ni le jeu.


## Revue indépendante V446

La revue indépendante V446 est reliée : 4 936 contrôles, dont une frontière source de 4 556 contrôles, 288 identités ciblées, 497 ancres et 191 fenêtres. Les 14 autorités AIR sont séparées des 62 exports dérivés. Collecteur code0, session86625, retour2a9750 ; supplément24/code0/ffbce8, sceau32/code0/740a9a et compagnon35/code0/ede94b restent séparés. Ces contrôles ne sont pas des tests du jeu.

Les cinq fiches sont vérifiées par les méthodes ordinaires dans deux bases distinctes en lecture seule. Par base : 42 606 états et notes, 23 historiques et 42 601 autres lignes de catalogue conservés. Le delta est un reçu source, aucun CID et aucun nouveau lien vers un corps de jeu ; 42 209 autres exigences actives et les anciens records sont exacts. Les huit questions restent ouvertes. Les auteurs434/443 sont crédités sans présenter leur travail réutilisé comme une nouvelle revue indépendante des sources.

Sept versions documentaires sont sauvegardées brutes avant cette liaison. Aucun registre ou base n’est modifié par cette étape. Pièces : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision446_independent_ranked_solo_mode_roles_source_delivery.
