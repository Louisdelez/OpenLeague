# SYS-01.2-02 — sources des parties Custom/Practice et frontière locale, V384

Livraison de sources pour MODE-CUSTOM-SCOPE et SYS-01.2-02. Les trois voisines SELECT/RULES/RESULT restent distinctes. La capture unique post395 et le lookup sur copies sont terminés code0/session89233/finalf02cbb ; le registrarROOT384 et l'audit de livraison ont réellement terminé0. Aucun corps de gameplay Custom n'est déclaré.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue4.20.1 distinct. AIR0.0.1.119 est une identité de composant, distincte du build du jeu. Projet F:/OpenLeague, privé F:/OpenLeague-work ; E conservé.

## Qualification et provenance

V380 a qualifié dix exports utiles et quatre familles binaires AIR119 : 103 contrôles, 38 identités et 55 ancres ; un cas nominal de lecture source, aucun test exécuté. FINAL23428octets/SHAa842ff8e82146be79abe3664a13a268147f14b1df3ffd58ce83aecf18eac0f46, propres codes outil/sous-processus/collecteur0 ; sceau V2 de63 contrôles séparé. Le premier sceau V1 a réellement retourné1 à cause du traitement privé str/Path de __file__, sans défaut source ni rejeu du collecteur ; ce diagnostic est conservé. Le même auteur a produit V371/V373/V378 ; aucune revue indépendante de lui-même n'est revendiquée. L'auteur V103 reste non établi.

La revue indépendante V381 a qualifié la portée source de V380 :311contrôles/56identités,55ancres primaires et29fenêtres propres, dix classes et quatre familles AIR119. Les archives E ont aussi été rehashées séparément des copiesF. Sa readinessfalse reste datée : ni runtime ni mode complet ne sont acceptés.

La préparation384 a contrôlé159conditions,62identités physiques,55ancres d'exportsAIR dérivés et cinq ancres locales de contexte. Ces cinq dernières sont séparées des ancresAIR. Deux sélecteurs nominaux, six refus de sélecteur,22formes ou fausses associations refusées,15gardes et cinq AST passent ; après sceau, deux gardes nominaux et six refus sont observés séparément. Ces séries se recouvrent ; ce ne sont pas des tests du jeu.

La capture unique post395 a attendu le vrai FINAL396, ses lectures live fermées et le checkpointROOT de sa liaison. Le lookup current/history/origin a travaillé exclusivement sur copies privées. Dix exports enregistrés sur E:/OpenLeague, leurs copiesF et anciens exportsE ont été physiquement vérifiés ; quatre archives originales et leurs copiesF sont conformes aux membres119 MD5/SHA. Aucun ancien record, chemin ou historique n'est réassigné. La revueROOT a vérifié26pins privés, cinq modulesAST,55ancresAIR et cinq locales avant publication, sans exécution du code jeu.

Le brouillon privéROOT V1 reste conservé. Son premier essai de compositionV2 a refusé un marqueurLF contre le CRLF brut avant toute écriture ; seule la nouvelle version utiliseLF. Le diagnostic et sa correction sont privés, distincts de toute anomalie du produit.

Les exports historiques dérivés ne deviennent pas des autorités natives. Le rehash compare chaque identité enregistrée sur son vrai chemin et sa copie F, sans réassigner les anciens sourceID, ni confondre E:/OpenLeague et E:/mapslol3v3. Les manifestes et reçus précédents conservent leurs dates et portées ; aucun nouveau décompilateur ou processus AIR n'est lancé.

## Contrat conditionnel Custom/Practice

Les deux entrées MasterGameController1732/1760 assignent PRACTICE_GAME, remettent la sélection de queue à zéro, appellent initializeForNewGame, demandent PLAY_PRACTICE_GAME_STATE puis JOIN_GAME ou CREATE_GAME. PRACTICE_GAME, la constante CUSTOM_GAME et la clé de provider « custom » sont distinctes. Leur présence ne prouve pas une équivalence de modes ni la conservation du modèle au travers de tout le lifecycle.

CreatePracticeGameController.canCreateGame119 est un prédicat séparé : nom fourni et de longueur suffisante, carte non nulle, compte de joueurs positif dans des bornes fournies par les paramètres et la configuration. createGame124 n'appelle pas ce prédicat dans le corps inspecté. Une application automatique des gardes par l'UI n'est pas déduite.

| Entrée ou condition | Résultat attendu et observé dans la source | Limite |
| --- | --- | --- |
| createGame124, filtre de mots positif | Émet GAME_NAME_CONTAINS_OFFENSIVE_WORDS et retourne avant apply/request | Contrôle du corps, aucune exécution AIR |
| createGame124, filtre négatif et config/carte/helpers utilisables | Assigne isBusy, applique le mode/les mutators via les paramètres, appelle gameService.createGame(config,callbacks) | Valeurs et réussite des providers non établies |
| Implémentation GameServiceImpl113 compatible, si sélectionnée | Demande littérale gameService/createPracticeGame avec [config] | Injection, transport et réponse inconnus |
| joinOrCreateGame139 | Appel distinct joinOrCreateGame(config,callbacks) | N'hérite pas des gardes de createGame par hypothèse |
| initializeGameMap211, liste fournie non vide | Assigne le premier élément avec as GameMap | Le cast peut être null ; aucune carte effective garantie |
| Liste absente ou vide | Ce corps ne réassigne pas la carte | Ne pas inventer une assignation null ou un fallback |

PracticeGameParameters.updateMapEnablement149 est distinct de cette sélection initiale. Il peut filtrer les cartes fournies par des IDs d'override, puis par variant.getGameModeForMap et le prédicat dynamique ENABLED_MODES ; sa liste _enabledMaps ne prouve pas la carte initialement assignée. applyGameTypeToConfig224 écrit gameMode depuis le variant et une collection de mutators fournis, sinon une collection vide. Le choix effectif du variant, les configurations actives et les valeurs du catalogue restent ouverts.

JoinGameController107 utilise la mapId du résultat fourni pour getGameMap et demande joinGame(id,password,callbacks). Le lookup first-match/null qualifié antérieurement ne garantit pas un objet non nul. Le contrat GameServiceImpl280 transmet [id,password] à gameService/joinGame ; l'appel de liste101 transmet [] à listAllPracticeGames. Le traitement d'une collection reçue et la conservation de lignes avec map ne prouvent ni liste effectivement disponible, ni admission, ni partie créée. join_local Rust est une route locale distincte de ce contrat AIR.

Toutes ces chaînes sont des lectures de source conditionnelles : elles supposent que les appels atteints retournent normalement, que les données/proxy/helpers sont utilisables et qu'aucune intervention externe, réentrante, de notification ou de lifecycle ne modifie les valeurs pertinentes entre les corps. isBusy, callbacks et setters ne deviennent pas des garanties de conservation de modèle/configuration. L'ordre textuel des demandes ne prouve ni parcours effectif, ni sérialisation, transport, réponse ou état durable.

## Consommateurs et conservation

La recherche current/history/origin sur la copie post395 n'a qualifié aucun ancien corps correspondant aux appels AIR Custom/PRACTICE create/list/join. Les candidats retrouvés restent dans leur portée : world185 Map10 ; la frontière map_availability_boundary_SYS_11_1_06_2 server26 n'implémente pas les paramètres natifs PracticeConfig selon son propre scope ; play25/join_local47 restent leurs corps blind/draft et Map10 ; main72 reste son entrée de file ; le play25 Tutorial garde son rôle. Les candidats sont documentés avec leurs raisons d'exclusion bornées, sans être associés artificiellement au nouveau contrat.

Le delta constaté ajoute uniquement un reçu source et aucun CID. Les listes current_consumers des deux cibles restent strictement égales aux anciennes listes ; les anciennes liaisons contextuelles ne sont pas présentées comme des consommateurs qualifiés des RPC Custom. Le résultat concret est analytique : autorités/exports/contrat liés aux exigences, et vérifiés dans les vrais task/trace/instructions/copies des deux bases lors de cette livraison. Aucune absence globale d'implémentation, aucun nouveau corps jeu ou feature complète n'est déduit.

Les trois voisines, entity.map=null, les anciennes sources/consommateurs/champs/flags/scopes/assessments/statuts et les inconnues sont conservés. Les listes d'inputs des deux cibles restent en préfixe exact. Les cases et notes sont exclusivement manuelles.

## Intégration et contrôles

Le registrarROOT et l'audit de livraison ont réellement terminé avec le code0. L'audit constate 159 contrôles de source, 62 identités, 55 ancres d'exportsAIR et 5 ancres locales de contexte, deux nominaux, six refus de sélecteur et22refus de contenu. Aucun runtimeAIR, modèleAS, buildRust, instructionnative ou GPU n'a été exécuté.

Le delta exact est un reçu source (OLS-db449627-b511-54e2-90a6-7fa9938bbfaf), aucun CID et aucune nouvelle association à un consommateur de jeu. Les groupes qualifiés des deux cibles sont vides ; leurs listes current_consumers antérieures restent strictement égales, avec leurs contextes datés. Les98 580 anciennes sources,2 408 consommateurs, flags/scopes/assessments, préfixes d'inputs, trois voisines et toutes autres tâches sont exacts. Le registre d'inconnues reste inchangé. Aucune carte n'est inventée : entity.map reste null.

Les deux bases physiquement distinctes ont reçu uniquement les données et instructions des deux fiches. Les vrais Store.task/copy_text/resolve sont relus par SQLite URI mode=ro/query_only, sans initialiser Store. Instructions, copie et notes éventuelles, anciens consommateurs,42 606états manuels et notes,23historiques et catalogues hors cible sont vérifiés dans chacune. Aucune case ou acceptation n'est modifiée.

Les sauvegardes brutes précèdent le reçu et les trois remplacementsJSON optimistes, puis deux transactionsBEGIN IMMEDIATE distinctes. Cette séquence n'est pas globalement atomique. Aucun rejeu ni rollback automatique n'a été fait. La preuve brute du registrar est conservée en octets exacts avant l'annexe d'audit. La revue indépendante387 doit maintenant vérifier la livraison après son vrai checkpointROOT.

## Fichiers et suite

Livrables : docs/reference_custom_scope_sources/custom-scope-source-contract-v384.json, docs/fidelity_custom_scope_source_graph_v384.json, ce rapport, trois registres et les deux bases du plan. Couverture, plan, reprise et notes courantes sont mis à jour. Scripts, sauvegardes et observations réelles : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision384.

Graphe structurel :98581sources/2408consommateurs ;25321inconnues ouvertes/5517résolues. Le contrôle global source_hashes_verified est l'entier0 ; les rehash physiques ciblés sont séparés. Ces compteurs ne mesurent pas un pourcentage de jeu terminé.

Suite : revue indépendante387 après ROOT384 réel et checkpoint ; puis404 RankedSolo après ses sources382/385 et nouveau signalde capture. Team386/390, SELECT392/397, RESULT394/399, OnTutorialInit400/402, CoOpSELECT403/405 et résultatsCoOp406 restent des étapes distinctes. RULES408 est un triage,409 qualifie sa demande client ciblée ; aucune autorité de règles serveur n'en est déduite. CorrectionTutorial395 et revue396 sont déjà reliées et conservées.

Les codesROOT, mutations et contrôlesDB réellement observés sont détaillés ci-dessus. La source ne qualifie pas les cartes/files EUW actives, les providers, le catalogue, les règles serveur, les résultats, le montage ou le gameplay Custom. Aucun test Rust, build, runtime AIR, processus natif, GPU ou générateur n'est exécuté par ce lot.

SYS-01.2-02 et le jeu restent ouverts. L'archive SYS-03.4-07 demeure non identifiée ; AnvilKit est une piste et OLU-78ef8b13-b7d3-58c4-b632-7ecf25a2f8c0 reste ouvert.

## Relecture indépendante V387 — 2026-10-24T05:41:45.302949+00:00

Le relecteur distinct des auteurs380/381, de la préparation384 et du ROOT a réellement terminé avec le code0 :536contrôles,87identités physiques,quatre autorités AIR119,dix références dérivées,55ancres AIR et cinq ancres locales de contexte séparées. La préparation345/65 et le sceau44 restent des phases séparées ; aucun de ces compteurs ne constitue un test du jeu.

Le delta est un reçu,aucun CID,aucun nouveau lien vers un corps de jeu. Les anciens current_consumers sont strictement identiques. Les candidats current/history/origin sont exclus selon leur portée documentée, sans absence globale déduite. MODE-CUSTOM-SCOPE.entity.map est null ; SYS-01.2-02.entity est null,ce sont deux formes distinctes. Les trois voisines,anciens records,flags,scopes,assessments,inputs et inconnues restent exacts.

Deux bases distinctes relues en RO/query_only avec le vrai Store.task/copy/resolve :42 606états et notes,23historiques et42 604autres lignes de catalogue exacts chacune. Les deux connexions sont fermées. Suite propre2nominaux/6refus de sélecteur/6formes ; suite producteur2/6/22 attribuée séparément sans rejeu.

Le refus privéV2 porte sur un comptage AST interne,le refusV4 sur deux attentes de forme de preuve et d'entity,avant toute ouverture DB. Ils restent conservés avec la correctionV5 ; CreateProcess206 est un diagnostic de préparation, sans code de processusPython inventé. Aucun défaut source ou produit n'en est déduit.

Le raccordement ici conserve les quatre registres et n'ouvre aucune base. Les sept anciennes versions publiques sont sauvegardées en octets exacts. Le contrat reste conditionnel au retour normal et à l'absence d'intervention pertinente : provider,cartes,overrides,transport,réponses serveur,montage et EUW effectifs non qualifiés. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision387_independent_custom_scope_source_delivery\FINAL_EXECUTION_RECEIPT.json. Le goal reste actif ; prochaine étapeSolo404 avec capturepost384 autorisée après le vrai checkpoint de cette liaison.
