# SYS-01.2-02 — sources de périmètre Tutorial et limite d'admission courante, V373

Cette livraison porte uniquement sur MODE-TUTORIAL-SCOPE et SYS-01.2-02. Les quatre fiches SELECT/STEPS/RULES/RESULT restent du contexte. Elle n'ajoute aucun nouveau corps Tutorial et ne transforme pas le lecteur Map10 existant en implémentation Tutorial.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build2014-11-17 à17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Les packages AIR0.0.1.119 sont une identité de composant distincte, pas un numéro de build du jeu. Projet F:/OpenLeague, privé F:/OpenLeague-work ; E conservé.

## Périmètre de la qualification

V369 a recensé les liens des42214 exigences actives :28 fiches modes n'avaient aucun lien source/référence, dont les cinq fiches Tutorial. Les73 fiches plan seul comprennent72 EMPTY et SYS-03.4-07. Les flags absents, false et true sont distincts ; les catégories de métadonnées ne sont pas des taux de complétude ni une preuve d'absence d'implémentation.

V371 a identifié le périmètre AIR à partir des fichiers et copies/exportations déjà conservés. Ses72 contrôles,24 identités et24 ancres sont des vérifications de sources. Ses propres codes sont0 ; son sceau35 est une étape séparée. Son FINAL11229octets/SHA275c0a2c20da2ec33e0cc9404d2fe5ee64a1071e84b420b2fa1eed966057204e reste figé, registration_ready=false. Le même auteur a réalisé V369 ; l'authorship et l'exécution des travaux historiques V103 ne sont pas nouvellement attribués.

Les limites de lancement, provider et montage ne bloquent pas la seule identification de ces sources. Elles restent indispensables à la qualification du tutoriel complet. Le lot de publication a passé ses propres lookup, contrôles de conservation et simulation ; la qualification initiale ne devient pas rétroactivement une publication.

La qualification indépendante V372 a acquis exactement le FINAL371 puis confirmé sa portée source :82 contrôles/20 identités/33 ancres ;116 comparaisons de sceau restent séparées. Les cas sont conditionnés à l'état au branchement après initializeForNewGame. L'auteur historique V103 reste non établi, sans attribution d'exécution fraîche ou de revue tierce inventée.

V375 a précisé getGameMap, les setters et l'origine immédiate de knownMaps :55 contrôles/17 identités/30 ancres, six lectures conditionnelles et deux bornes de modèle ;31 contrôles de sceau sont séparés. ApplicationController cherche la première entrée non nulle de même mapId et retourne null sinon. MasterGameController et GameModel stockent le résultat dans les corps inspectés. knownMaps provient de GeneratedContentLoader.mapData, construit depuis MapGeneratedData.maps dans handleSwfLoaded. Contenu/ordre/disponibilité effective du SWF et effets de lifecycle restent inconnus.

La préparation V373 a réellement passé103 contrôles source et36 contrôles propres de structure/contrat (139 dans le reçu de préflight),47 identités et51 ancres. Ces contrôles ne sont pas des tests Rust ou AIR. Elle possède sa capture unique, son lookup current/history/origin, l'extension V375 depuis le même snapshot, le rehash ciblé, les sélecteurs et la simulation pure. Son FINAL exact est lié au reçu ROOT. Les originaux V371/V375 conservent readinessfalse ; l'assemblée prête est une étape distincte. Le rehash compare les cinq binaires enregistrés à leurs copies F ainsi que les huit exports enregistrés à leurs copies F, y compris les deux anciens chemins E:/OpenLeague. Aucun ancien sourceID n'est réassigné.

Le FINAL indépendant V370 et sa liaison documentaire ont été acquis avant cette mutation. Les refus privés de préparation et versions corrigées sont conservés avec leurs causes ; ils ne sont pas transformés en défauts du jeu ou en anciens audits rejoués.

## Ce que les sources AIR établissent

Les copies binaires ClientLibGame.dat, ClientLibDomain.dat et mod_ser.dat sont confrontées aux identités et appartenances conservées du composant AIR119. Les exports ActionScript sont des produits de décompilation conservés ; ils ne deviennent pas de nouveaux binaires officiels. Les comparaisons fraîches de taille/SHA et les MD5 ciblés sont distingués des anciennes décompilations et de l'analyse RADS non rejouées.

MasterGameController.startTutorialGame1741 appelle l'initialisation, puis choisit sa branche selon gameModel.tutorialType aux lignes1746/1751. Les cas ci-dessous sont conditionnels à l'état lu à ce point ; ils ne prouvent ni la joignabilité depuis l'entrée, ni le reset ou la conservation de tout le modèle par initializeCycle.

| État au branchement | Configuration Enabled | Argument de getGameMap | Type demandé au service |
| --- | --- | --- | --- |
| BASIC | Indifférente à cette branche | PROVING_GROUNDS_ID3 | 0 |
| ADVANCED | true | SUMMONERS_RIFT_ID1 | 1 |
| ADVANCED | false | SUMMONERS_RIFT_ID1 avant repli du modèle | 0 après repli du modèle sur BASIC |

chooseTutorialType(false) passe par le setter qui vérifie isAdvancedTutorialEnabled ; le repli change tutorialType et isBasicTutorial, sans réassigner gameMap dans le corps inspecté. getGameMap parcourt knownMaps : il retourne la première entrée non nulle dont mapId égale l'argument, sinon null. Les constantes3/1 sont donc des arguments de recherche ; un objet gameMap correspondant dépend d'une entrée présente. Aucune entrée reçue ni correspondance effective n'est supposée. createGame transmet le type0/1 au service, pas la propriété gameMap. Cette lecture ne prouve ni la carte reçue du serveur, ni le résultat de l'appel, ni la réussite historique de création.

BattleTraining.Enabled a un default déclaré false et UseSRU un default déclaré true dans BattleTrainingConfig. Le provider/configuration effectif EUW et les réponses distantes restent inconnus. UseSRU ne remplace pas la constante1 par11 dans le corps inspecté. Aucun défaut local ne devient une configuration historique acceptée.

## Script Map12 et frontière locale

Le payload original LEVELS/Map12/Scripts/TutorialScript.luaobj est identifié :49243octets/SHA22f7319f8dd6cfabc413eefa684da340afff7f36b3e9f7c656cd6d0b72fedfc3, MD5e123fe84dfb61646b0f1082a9f762e1a. Sa présence et ses anciennes observations contrôlées restent du contexte. Elles ne qualifient pas son montage pour les routes AIR Map3/Map1, le provider, les APIs engine ou toute la progression. Aucun de ces anciens essais n'est réexécuté par ce lot.

La route locale inspectée prend champion et summoners dans play/join_local. Le serveur détenu initialise enable_map10, et world.rs185 lit data/4.20/map10_world.json. Ce contrat local est une limite explicite ; le consommateur existant OLC-0ccede58-6326-58df-8834-bdf7c9f3c718 conserve exactement son rôle world_loader et sa portée Map10. Aucun consommateur ordinaire Tutorial applicable n'est qualifié ici. La recherche et cette route ne prouvent pas l'absence globale de tout tutoriel sous un autre nom.

Le package D11-MODE-TUTORIAL garde entity.map=null. Les constantes AIR3/1 et le script12 ne remplacent pas arbitrairement cette classification. Les prérequis et états incomplets, les inconnues de montage/admission et l'acceptation humaine absente restent ouverts.

## Intégration et vérifications

Le registrar ROOT puis l'audit de livraison ont réellement terminé avec le code0. L'audit vérifie 103 contrôles source / 47 identités ciblées,51 ancres de source et aucune définition de test Rust ajoutée. Deux sélecteurs nominaux, six refus de sélecteur et vingt refus de contenu/forme passent ; ces cas vérifient les contrats de liaison et leurs limites, sans exécution AIR.

Le delta complet ajoute un seul reçu normalisé comme nœud de source, aucun consommateur et réutilise le seul ancien play25 (OLC-b5b58c30-faf2-5364-9bc8-e071c5bc36ba) comme frontière entry_boundary_only/false. Les cinq autorités binaires AIR119 et huit références d'exports sont réutilisées avec leur nature distincte. Les nouveaux liens ne prouvent ni payload effectif, ni réponse serveur, ni montage de scène/script, ni admission Tutorial actuelle.

Les98577 anciennes sources et2408 consommateurs restent exacts. Les anciens éléments des listes des deux cibles sont conservés en préfixe ; les autres champs/statuts/flags/assessments/notes restent exacts. Les quatre autres fiches Tutorial, toutes autres tâches et l'intégralité du registre d'inconnues sont inchangées. Les anciennes questions d'absence de source restent des constats datés des recherches précédentes :les nouvelles sources AIR sont maintenant liées, tandis que la configuration effective, la disponibilité des cartes/files et le montage nécessaires au périmètre complet restent ouverts. Le lecteur world185 reste Map10 ; audio129 n'est pas ajouté à SCOPE. entity.map reste null.

Les deux bases physiquement distinctes vérifient les vrais Store.task/copy_text/resolve par connexions SQLite mode=ro/query_only, sans initialiser Store. Deux fiches seulement changent par base ;42606 états manuels et notes,23 historiques et catalogues hors cible restent exacts. Les instructions complètes, copies avec notes éventuelles et chemins absolus structurés JSON-échappés receipt/proof sont comparés. Aucune case ou acceptation n'est ajoutée.

Publication séquentielle sauvegardée : reçu, trois JSON avec gardes optimistes, puis deux transactions BEGIN IMMEDIATE distinctes. Ce n'est pas une transaction globale. Toute erreur arrête le lot sans relance ni rollback automatique. La preuve brute du registrar a été copiée en octets exacts avant l'audit.

## Fichiers et suite

Intégration : reçu Tutorial, preuve V373, ce rapport, trois registres et deux bases du plan ; couverture, plan et reprise actualisés. Sauvegardes, scripts et observations exactes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision373.

Graphe structurel : 98578 sources / 2408 consommateurs ;25321 inconnues ouvertes / 5517 résolues. source_hashes_verified vaut l'entier0 pour le contrôle global ; les identités physiques ciblées sont vérifiées séparément. Aucun pourcentage de jeu terminé n'est déduit.

Suite : revue indépendante V374 après acquisition du vrai ROOT/checkpoint ; triage V376 des sources des autres modes à partir des reçus existants. La disponibilité effective du tutoriel, ses files, son montage et son consommateur de scénario restent ouverts.

Les codes ROOT, mutations et contrôles DB réellement observés sont détaillés ci-dessus. Aucun code gameplay, scène, ressource de jeu ou comportement Tutorial n'est modifié par ce lot de liens. Les anciens records, autres tâches, scopes, flags, assessments, notes, cases cochées et historiques sont conservés.

SYS-01.2-02 et le jeu restent ouverts. L'archive SYS-03.4-07 n'a pas été identifiée par l'utilisateur ; AnvilKit demeure une piste et OLU-78ef8b13-b7d3-58c4-b632-7ecf25a2f8c0 reste ouvert.

## Relecture indépendante V374

La revue indépendante des auteurs V371/V372/V375 et de la préparation/publication V373 a réussi avec ses propres codes outil, sous-processus et collecteur 0 : 274 contrôles, 61 identités ciblées, 51 ancres et aucune définition de test exécutée. Les cinq autorités binaires AIR119 restent distinctes des huit références dérivées. Le supplément documentaire ROOT compte séparément 79 contrôles et 17 identités, sans relire le graphe ni les bases.

Le delta vérifié est un reçu source ajouté, aucun nouveau consommateur et deux tâches enrichies. Les cinq autorités et quinze références ajoutées à chacune des deux cibles conservent les anciens préfixes. L'ancien play25 reste entry_boundary_only/false ; les quatre voisines Tutorial, tous les autres enregistrements, indicateurs, périmètres, évaluations, états et inconnues sont conservés. world185 reste Map10, audio129 reste son rôle ; aucun corps de scénario Tutorial n'est déclaré.

Les deux bases physiquement distinctes ont été relues en mode strictement RO/query_only et avec les vrais Store.task/copy/resolve : 42 606 états manuels et notes, 23 lignes d'historique et les catalogues hors cible sont exacts dans chacune. Le présent rattachement ne se connecte à aucune base et ne modifie aucun des quatre registres. Les sept versions documentaires antérieures à cette annexe sont conservées en octets exacts dans revision373/pre-independent-link-versions.

Le premier passage indépendant V1 a réellement retourné 1 avant toute lecture des bases : son garde privé interdisait par erreur l'ajout du premier champ reference_context autorisé sur SCOPE. La correction du garde a ses deux cas nominaux et huit refus séparés ; le journal V1 reste conservé. L'audit V2 a ensuite réellement retourné 0. Les deux nominaux, huit refus de sélecteur et seize formes propres au relecteur ne sont pas additionnés aux deux nominaux, six refus de sélecteur et vingt contenus du producteur : ces séries se recouvrent et ne sont pas des tests du jeu.

Les cas Tutorial restent conditionnels à la branche après initializeForNewGame. Les arguments getGameMap 3/1 ne prouvent ni objet présent, ni montage effectif ; le lookup peut renvoyer null. Le contenu et l'ordre du SWF, les configurations actives, le cycle de vie, la disponibilité EUW, les réponses du service et le consommateur de scénario actuel restent ouverts. Aucun build, test Rust, runtime AIR, processus natif, GPU ou générateur n'a été exécuté par cette revue.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision374_independent_tutorial_scope_source_delivery/FINAL_EXECUTION_RECEIPT.json. Les SHA publics du checkpoint V373 restent des observations datées avant annexe ; le goal reste actif et aucune case n'est cochée automatiquement.

## Rectification de portée en préparation V395

La réduction Advanced désactivé → BASIC/RPC0 omettait le garde public old!==argument. Elle est trop générale pour un contrôleur déjà à false. Voir docs/FIDELITY_TUTORIAL_SETTER_GUARD_REVIEW_PENDING_V395.md et la lecture indépendante V393. Le reçu373 et ses résultats datés sont préservés ; la correction sera additive, sans modifier le jeu ni attribuer une exécution AS. Disponibilité, lifecycle et interventions entre corps restent ouverts.


## Rectification source V395 intégrée — 2026-10-24T04:42:25.056031+00:00

Le correctif public docs/FIDELITY_TUTORIAL_SETTER_GUARD_CORRECTION_V395.md supplée uniquement la réduction non gardée advanced_disabled. Le setter public old!==argument conditionne l’appel privé ; RPC88 relit le getter courant et le payload peut différer. Le reçu373, ses liens et ses résultats datés restent préservés. Vérification : docs/fidelity_tutorial_setter_guard_correction_v395.json ; revue indépendante396 encore à effectuer. Aucun défaut produit exécuté ni acceptation du jeu.


Relecture corrective V396 — 2026-10-24T04:51:48.448335+00:00 : livraison395 vérifiée indépendamment, ancien reçu373 et avis pending inchangés. Voir docs/FIDELITY_TUTORIAL_SETTER_GUARD_CORRECTION_V395.md et sa preuve. Portée source seulement, aucune acceptation du jeu.
