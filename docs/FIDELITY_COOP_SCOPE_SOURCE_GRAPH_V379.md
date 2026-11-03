# SYS-01.2-02 — périmètre des sources CoOp et frontière locale, V379

Cette livraison concerne MODE-COOP-SCOPE et SYS-01.2-02. Les trois autres fiches CoOp SELECT/RULES/RESULT restent du contexte ; leur liste réelle a été vérifiée dans la capture du plan. Aucun nouveau corps CoOp ou consommateur de gameplay n'est proposé.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build2014-11-17 à17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Les composants AIR0.0.1.119 sont des identités de composants, distinctes du build du jeu. Projet F:/OpenLeague, privé F:/OpenLeague-work ; E conservé.

## Sources qualifiées et portée

V376 a trié les23 fiches des autres modes depuis le relevé daté V369 :cinq SCOPE et18 autres rôles exclus. Ses30 contrôles/26 identités/37 ancres ne sont pas un audit exhaustif des implémentations de modes. CoOp a été retenu comme prochain groupe source précis ; Custom/Ranked restent leurs propres recherches.

V377 a qualifié les sources CoOp :44 contrôles/34 identités/50 ancres, huit exports et quatre familles binaires AIR119. Ses sept lectures conditionnelles et limites ne sont pas des exécutions AIR. FINAL25800octets/SHA89a1bf14cbbc9405b12c97102eb35550dd8df8d463200016750de923c2478aa2, propres codes0 ; readinessfalse reste son stade privé original. Le même auteur a produit V372/V375/V376, sans revue indépendante de lui-même.

V378 est une revue distincte de l'auteur V377 :73 contrôles/37 identités/35 ancres ;88 comparaisons/sceau sont une étape séparée. FINAL19095octets/SHA9f11b324a19e6aef447fdb7713b78649f96f9935efeaf0be94f259bc7ca366e6, propres codes0. Le relecteur est aussi auteur V371/V373 : il ne revendique pas une revue indépendante de ces anciens acquis. V103 reste un reçu historique dont l'auteur n'est pas nouvellement établi.

La préparation V379 a passé 99 contrôles source, 66 identités ciblées et 53 ancres uniques, avec deux nominaux, six refus de sélecteur, vingt-cinq formes/contenus refusés et quatre gardes de validation typée. Ces dernières séries sont des contrôles de contrat distincts, avec leur recouvrement ; ce ne sont pas des tests du jeu. Le sceau possède ses contrôles séparés. Le FINAL source V377 et la revue V378 conservent leurs readinessfalse d'origine.

La capture unique post373 a attendu le vrai FINAL374 et le signal de fin des lectures live. Le lookup current/history/origin a travaillé sur les copies privées. Il a retrouvé les autorités et exports existants : quatre archives AIR119 et huit exports E:/OpenLeague ont été physiquement rehashés, séparément de leurs copies F. Les anciens enregistrements sont réutilisés strictement, sans rebinding ni nouveau nœud de copie. Le graphe mutable reste une baseline ; il n'est pas une autorité native.

Le FINAL374 acquis, sa liaison documentaire, les prérequis et le brouillon ROOT sont des preuves d'étape distinctes des sources binaires. Aucun ancien collecteur, exporteur ou runtime historique n'est rejoué par l'assemblée.

## Contrat client CoOp conditionnel

MasterGameController.startCoopVsAIGameFlow1704 assigne _isSolo, gameType=COOP_VS_AI et ranked=false avant initializeForNewGame. Si l'argument vaut false, le corps assigne ensuite JOIN_QUEUE. Ces écritures sont des instructions du client, pas une garantie de conservation du modèle par tout le lifecycle ni une preuve d'entrée réussie en file.

MasterGameViewController.onInviteProvider991 appelle initializeGameMap puis setAvailableQueues avec le gameType courant. Le choix effectif du provider, l'ordre des événements et la joignabilité de ce callback restent inconnus. L'ancien getGameMap first-match/null est du contexte ; aucune carte non nulle n'est déduite de l'étiquette CoOp.

| Corps ou condition | Lecture source observée | Limite conservée |
| --- | --- | --- |
| setAvailableQueues248, même type et aucun pending | Retour anticipé251 | Aucun refiltrage garanti |
| setAvailableQueues, mise à jour non requise | Appelle getQueues avec l'argument reçu259 | L'argument effectif et le catalogue restent des données fournies |
| getQueues avec COOP_VS_AI | Inclut seulement les objets dont type==QueueType.BOT236 | Ce filtre n'admet pas BOT_3x3 par cette seule condition |
| Réponse getAvailableQueues valide | Callback503 accepte une ArrayCollection et assigne le catalogue509 | La forme de collection ne qualifie pas chaque DTO, sa provenance effective ou la disponibilité EUW |
| Réponse invalide | Pas de nouvelle collection assignée dans ce callback | Pas de validation historique ou de succès serveur |
| Échec du service | Callback518 remet currentGameType à null et le catalogue à une collection vide | Aucun fallback inventé vers un catalogue officiel |

Le helper plus large de QueueType ne modifie pas la comparaison BOT du corps inspecté. Le filtre CoOp ne lit pas ranked, les nombres de participants, supportedMapIds ou les mutators. Les valeurs name et numPlayersPerTeam alimentent des listes de présentation ; elles ne deviennent pas des règles de matchmaking ou d'équipes qualifiées.

Le callback valide remet currentGameType à null508 avant l'appel pending512 à setAvailableQueues(this.currentGameType). Il ne garantit donc pas un appel getQueues(COOP_VS_AI) à cet instant. La branche default de getQueues et les événements/lifecycle restent leurs propres conditions ; aucune liste effectivement affichée ou file historiquement active n'est inférée.

L'interface MatchMakerService et l'appel littéral de MatchMakerServiceImpl identifient le contrat getAvailableQueues. Ils ne prouvent ni l'implémentation injectée, ni le transport/réponse, ni bots, matchmaking, règles, résultats ou partie jouable.

## Consommateurs actuels et conservation

Le lookup current/history/origin a retrouvé les anciennes identités et leurs rôles sans créer de corps. La frontière réemployée est matchmaking_lifecycle_1, OLC-2a7918ec-5a45-52ed-8977-8bed8a53acf0 : launcher/src-tauri/src/main.rs72 déclare la liste invoke_handler avec roster, play, join_local, session_status, resume_session et abandon_session. Ce corps est une frontière d'admission déclarée entry_boundary_only/false ; sa phrase historique sur la commande de file absente n'est pas une preuve d'absence globale d'implémentation. Le CID play25 du Tutorial n'est pas réaffecté au CoOp. Le lecteur world185 reste lié à Map10 ; aucun scénario CoOp n'est ajouté.

Les empreintes de launcher/session/server/world sont cohérentes avec cette route locale Map10 déjà bornée. Aucun ancien rôle, sourceID ou scope n'est réassigné et aucun consommateur de gameplay CoOp n'est inventé.

Les autorités binaires, copies F et exports dérivés conservent leur nature distincte. Chaque registered_identity utilisé par un nouveau lien doit être rehashé sur son chemin réel puis comparé à sa current_F_copy. Les anciens chemins E:/OpenLeague et les exports E:/mapslol3v3 sont des identités distinctes. Le registre mutable et les captures de contexte servent de baseline, pas d'autorité native.

Les anciens champs/statuts/flags/assessments, les trois fiches voisines, les autres tâches, les inconnues et entity.map=null sont conservés. Les sources identifiées ne suffisent pas à confirmer les valeurs effectives du catalogue, les cartes/files disponibles dans la région ou un consommateur de mode courant.

## Intégration et contrôles

Le registrar ROOT et l'audit de livraison ont réellement terminé avec le code 0. L'audit a vérifié 99 contrôles source, 66 identités et 53 ancres. Deux cas nominaux, six refus de sélecteur et vingt-cinq refus de contenu/forme passent ; aucun test Rust ou AIR n'a été exécuté.

Le delta complet est exactement un reçu source ajouté, aucun nouveau CID et le réemploi inchangé de la seule frontière matchmaking_lifecycle_1 (OLC-2a7918ec-5a45-52ed-8977-8bed8a53acf0) pour les deux cibles. Les quatre autorités et les références dérivées restent distinctes. Les 98 578 anciennes sources et 2 408 anciens consommateurs, leurs flags/scopes/assessments, les préfixes d'inputs, les trois voisines et toutes les autres tâches restent exacts.

L'intégralité du registre d'inconnues est inchangée. Ses recherches antérieures sur les sources manquantes restent des observations datées : les quatre archives et huit exports sont maintenant liés, tandis que le catalogue effectif, la région, le provider, les callbacks, cartes/files et montage requis pour le mode complet restent ouverts. entity.map reste null ; world185 reste Map10 et play25 reste son ancien rôle Tutorial.

Les deux bases physiquement distinctes ont reçu uniquement les données et instructions des deux tâches. Les vrais Store.task/copy_text/resolve sont vérifiés par connexions SQLite mode=ro/query_only, sans initialiser Store. Les 42 606 états manuels et notes, 23 historiques et catalogues hors cible restent exacts dans chacune. Les instructions complètes et les copies avec notes éventuelles sont comparées ; aucune case ni acceptation n'est ajoutée.

La publication est séquentielle et sauvegardée : reçu, trois JSON avec gardes optimistes, puis deux transactions BEGIN IMMEDIATE distinctes. Elle n'est pas globalement atomique. Le lot s'arrête sur toute erreur sans relance ni rollback automatique. La preuve brute du registrar a été conservée en octets exacts avant l'audit.

## Fichiers et suite

Intégration : reçu CoOp, preuve V379, ce rapport, trois registres et les deux bases du plan ; couverture, plan et reprise actualisés. Scripts, sauvegardes et observations exactes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision379.

Graphe structurel : 98579 sources / 2408 consommateurs ; 25321 inconnues ouvertes / 5517 résolues. source_hashes_verified est l'entier 0 pour ce contrôle global ; les identités physiques ciblées sont vérifiées séparément. Aucun pourcentage de jeu terminé n'en est déduit.

Suite : revue indépendante V383 après le vrai ROOT/checkpoint ; préparation source Custom V384 après V380/V381, sans capture live avant la revue de livraison CoOp terminée. Ranked Solo V382/V385 et Ranked Team V386 restent leurs recherches propres. Disponibilité, règles, réponses et mode jouable restent ouverts.

Les codes ROOT, mutations et contrôles DB réellement observés sont détaillés ci-dessus. Aucun code gameplay, contenu de carte, test AIR/Rust, processus historique, GPU ou générateur n'est exécuté par ce lot de références. Les preuves antérieures et les diagnostics privés sont conservés.

SYS-01.2-02 et le jeu restent ouverts. L'archive SYS-03.4-07 demeure non identifiée par l'utilisateur ; AnvilKit est une piste et OLU-78ef8b13-b7d3-58c4-b632-7ecf25a2f8c0 reste ouvert.

## Relecture indépendante V383

Le relecteur distinct des auteurs V377/V378/V379 confirme la source et la livraison avec ses propres codes outil/sous-processus/collecteur 0 : 479 contrôles, 78 identités ciblées, 53 ancres et aucun test exécuté. Les quatre autorités AIR119 et huit exports restent distincts. Le supplément documentaire ROOT possède séparément 77 contrôles et 27 identités, sans nouvelle lecture du graphe ni des bases. Préparation41 et sceau28 restent des étapes séparées.

Le delta exact depuis les sauvegardes brutes est un reçu source, aucun CID et deux fiches. main72 reste la frontière matchmaking_lifecycle_1 entry_boundary_only/false ; play25 n'est pas ajouté aux nouveaux liens CoOp. Les anciens records/flags/scopes/assessments/inputs en préfixe, les trois voisines CoOp, toutes les autres tâches et les inconnues sont exacts. entity.map reste null et world185 reste Map10.

Deux bases physiquement distinctes sont contrôlées en mode strictement RO/query_only avec authorizer et les vrais Store.task/copy/resolve : 42 606 états manuels et notes, 23 lignes d'historique et les catalogues hors cible sont conservés dans chacune. Le présent lien documentaire ne se connecte à aucune base, n'ajoute aucun nœud et ne modifie aucun des quatre registres. Sept anciennes versions documentaires sont conservées en octets exacts dans revision379/pre-independent-link-versions.

Les deux nominaux, neuf refus de sélecteur, vingt-deux formes propres et quatre gardes typées du relecteur sont distingués des deux nominaux, six refus de sélecteur et vingt-cinq formes du producteur. Ces séries se recouvrent et ne sont pas des tests du jeu. Aucun refus privé propre V383 ; les diagnostics et versions hérités restent datés, sans rejeu.

La source client conserve ses conditions : typeBOT exact, paramètres et catalogue fournis, currentGameType remis à null avant pending, aucune garantie de refiltrage CoOp. Provider, configuration, lifecycle, valeurs EUW, réponses, cartes/files, bots, règles, résultats et partie jouable restent ouverts. Aucun mutateur, build, Rust/AIR, natif, GPU ou générateur n'a été rejoué.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision383_independent_coop_scope_source_delivery/FINAL_EXECUTION_RECEIPT.json. Les empreintes publiques du checkpoint379 sont des observations datées avant cette annexe. Goal actif, aucune case ou acceptation automatique.
