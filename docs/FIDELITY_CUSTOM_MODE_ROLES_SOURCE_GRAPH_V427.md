# SYS-01.2-02 — trois contrats Partie personnalisée et consommateurs actuels, V427

Livraison analytique intégrée aux quatre tâches, traces et instructions copiables des deux bases locales. Trois contrats distincts SELECT/RULES/RESULT ; dix archives AIR119 et cinquante-neuf exports dérivés ; un reçu source ajouté, aucun CID ni nouveau lien vers un corps de jeu. SCOPE384/387 conserve ses preuves et son état. La revue indépendante429 de livraison reste à effectuer.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 et composant AIR0.0.1.119 distincts. Projet F:/OpenLeague, travail privé F:/OpenLeague-work, E préservé.

## Sources et phases distinctes

SELECT419/424, RULES422/425 et RESULT423/426 : contrats primaires et relectures bornés, avec sources, exports, fenêtres, ancres, diagnostics et auteurs attribués. Le triage ROOT420/421 est un antécédent, pas une qualification supplémentaire. La revue426 distingue sa cohorte source70 de son énumération finale71 incluant le rapport d'API ; les2257 contrôles d'API restent séparés. Les validations de structure, de préparation et de livraison ne deviennent pas des tests du jeu.

Les six qualifications419/424,422/425,423/426 restent figées avec leurs readiness originalesfalse et leurs auteurs. Le préparateur427 est auteur419/425/423,sans nouvelle indépendance de lui-même ;les pairs424ROOT/422Current/426Spell restent distincts. Capture unique après ROOT412/413,liaison et signal explicite ;puis travail exclusivement sur copiesgzip. Trois sélecteurs de rôle et l'union SYS conservent chacun leur contrat, leurs inputs et leurs inconnues.

## SELECT : démarrage, disponibilité et requêtes

Les littéraux PRACTICE_GAME, CUSTOM_GAME et la clé provider custom restent distincts. Master et les DTO fournis orientent TEAM_SELECTION vers le contrôleur et sa vue sous conditions d'état, provider et lifecycle.

Team.startChampionSelection695 compte les seuls PlayerParticipant à707 pour minCustomPlayers708. Il recompte à716 pour le minimum ClientConfig ; le bypass ne s'applique qu'à cette seconde garde. Les alertes de récompenses et d'équipes inégales peuvent différer le démarrage. Leur callback appelle begin directement ; begin761 relit currentGame puis demande startChampionSelection avec ID et optimisticLock, sans réappliquer les minima antérieurs. Les bindings owner et !busy ne sont pas des gardes directes ajoutées à ces méthodes.

Core350 lit deux fois le type fourni. PRACTICE rend les comparaisons Tutorial et ranked fausses à ces points seulement. Pools, spectateur, disponibilité, ownership, location et filtres restent des entrées distinctes ; le wildcard199–203 peut réinitialiser le rejet après eux. Clic197, Core579, garde active pick, disponibilité et tryToAck précèdent d'autres lectures. Summon162 autorise son chemin selon un OR entre non-occupation, shared tutorialPickOverride et duplicatePick fourni. Ne pas déduire le shared override de isTutorial.

Les bots dépendent de l'inventaire botEnabled, du tirage et de la difficulté fournie. computeCanAdd est une capacité séparée des méthodes directes. Le total des participants est la somme des deux équipes, distinct des observateurs. Configuration spectateur et demandes de changement de rôle restent des parcours différents.

Le parcours de skins appelle la commande son, reset timeout et affecte requestedSkin avant certaines gardes. Ces appels source ne prouvent pas un son entendu. Les validations suivantes et la requête dépendent du provider et d'un retour normal. La recherche de wards est finie et n'établit ni parcours qualifié ni absence globale.

## RULES : paramètres, variantes et création

GameTypeConfigManager reçoit des listes et configurations ; les filtres, modes featured et IDs d'override ne prouvent pas les valeurs effectives. Les flags de plateforme, capacités, spectateurs et région sont fournis. La première carte initiale et la liste enabledMaps filtrée restent distinctes.

chooseMap(null) n'affecte pas la carte dans ce corps ; initializeView1383 peut la remettre à zéro par un autre chemin. L'override de capacité n'est pas NaN ; ne pas lui ajouter finitude, positivité ou clamp. Sans lui, les autres branches et Math.min s'appliquent sous leurs prémisses. Le filtrage peut laisser teamSizes vide ; l'affectation players=cap*2 après la garde reste présente. Minimum, capacité et sélection UI ne sont pas confondus.

NONE est toujours proposé pour les spectateurs dans la source inspectée ; les autres options dépendent des littéraux et configurations. La factory invalide son cache lors du signal ; une vue peut conserver une ancienne référence de paramètres. Les mutateurs, mode puis invariant sont essayés selon l'ordre source. ConfigurationModel.setValue(value,false) stocke et peut dispatcher changedSignal(false) : false est un payload, pas une suppression de notification.

canCreate119, create124 et les chemins UI sont distincts. Enter1586 teste ENTER et canCreate avant de dispatcher CLICK ; le handler1327 vérifie practiceGamesEnabled, index/config et ID>=0 puis appelle create, sans réappliquer tous les autres contrôles. Les conditions de réception UI, focus et framework ne sont pas déduites. La désactivation187 remet les paramètres indiqués à zéro sous prémisses de lifecycle.

## RESULT : issue, retour et rejeu

Le contrôleur consomme les DTO fournis. Les setters peuvent notifier ; le switch relit le type après copies et cleanup. CAP a priorité. Dans la branche Practice/Custom, le booléen de rejeu choisit Join ou Create. Ne pas lui appliquer la garde Coop2471. allowedtoPlayAgain2418 est distinct.

Conserver les trois prédicats WIN : présence pour le drapeau local du contrôleur, valeur1 pour le libellé avec leaver/invalid, présence pour le slot indexé[0] de la première collection non vide utilisée pour teamOne. Ce slot n'est pas le premier participant non nul. Les OR littéraux des filtres restent exacts. Les chemins review/mock1292 et overrideBack4305 sont exclus du résultat frais.

cleanupCycle est vide ; la remise à false688 appartient à deactivate. Affichage, visibilité, résultats, rewards et home sont lus à leurs points propres ; le booléen de conjonction du retour peut court-circuiter, et le flag home est lu après cleanup. Le résultat serveur, le bridge natif vers AIR, le transport et l'exécution UI ne sont pas établis par ces lectures.

## Consommateurs et conservation

Trois associations individuelles SELECT /0, RULES /1, RESULT /2 ; SYS utilise exactement leur union sous /associations. Le lookup current/history/origin a parcouru les98584 sources sans filtrer sur leur rôle ;69 groupes exacts(10 archives/59 exports),124 records d'alias et252 fichiers physiques vérifiés. Soixante candidats consommateurs et43 sites ont été inspectés. Aucun corps Custom supplémentaire n'est qualifié par ce lot ;les anciennes listes et portées restent strictement égales. Cette conclusion ne prouve pas une absence globale. Un corps générique, Map10 ou un ancien rôle de registre ne devient pas un consommateur Partie personnalisée par son nom.

Conserver inputs en préfixe, records E/F distincts, origine, historique, current_consumers, flags/scopes/assessments, required/required_if, statuts, notes et cases. Six questions datées391 restent ouvertes ; trois entity.map=null restent distincts de SYS.entity=null. Les fiches, traces, instructions et copies des deux bases présentent les contrats bornés, sans acceptation automatique.

Toutes les chaînes exigent retour normal et absence d'intervention externe, réentrante, de notification ou de lifecycle pertinente. Injection, catalogue, file, config effective, disponibilité EUW, validation serveur et gameplay complet restent ouverts.

## Intégration et contrôles

RegistrarROOT et audit séparé réellement terminés avec code0,chacun une seule fois. Vérification954 contrôles source/248 identités/306 ancres AIR et203 fenêtres ;4 nominaux,20 refus de sélecteur et28 refus de contenu. Les1927 contrôles de lookup,32 privés AST/métadonnées/RAM,69 de sceau,1 nominal/11 refus après sceau et69 contrôles du compagnon sont séparés ;aucun n'est un test du jeu.

Deux bases physiquement distinctes relues avec les vrais Store.task/copy_text et requirement_trace.resolve via URI mode=ro/query_only et authorizer, sans Store.__init__ ni substitution de modules. Quatre fiches/instructions/copies exactes chacune.42606 états et notes,23 historiques et42602 autres lignes catalogue conservés par base ;integrity_check ok.42214 exigences actives et42210 hors cible restent des populations distinctes.

Anciens records/versions/origines/listes/flags/scopes/assessments et champs des tâches conservés. SCOPE384/387 et toutes les autres tâches inchangés. Six questions ouvertes,aucune résolution ni case cochée. Trois entity.map=null distincts deSYS.entity=null.

Sauvegardes brutes avant trois remplacementsJSON et deux transactionsDB optimistes séparées ;pas d'atomicité globale revendiquée,aucun rejeu ou rollback automatique. Preuve brute du registrar conservée avant audit. Six versions documentaires préservées avant cette publication. Refus privé V1 réel1/3b9497 conservé :deux orthographesF:/ etF:\ de l'identité426. V2 a comparé norme physique,taille/SHA etsamefile ;aucun rebindingE→F ni relabeling du code1. Les compteurs426source70/final71/API2257 restent distincts.

Graphe98585 sources/2408 consommateurs,25321 questions ouvertes/5517 résolues. source_hashes_verified entier0 désigne le contrôle structurel ;rehashs physiques ciblés séparés. Aucun jeu original,AIR,VM,Rust ouGPU exécuté.

## Fichiers et suite

Livrables :docs/reference_custom_mode_roles_sources/custom-mode-roles-source-contract-v427.json ;docs/fidelity_custom_mode_roles_source_graph_v427.json ;ce rapport ;trois registres et quatre fiches de chaque base locale. Scripts,sorties et sauvegardes :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision427. Couverture,plan et reprise suivent les preuves.

Revue indépendante429 après le vrai checkpoint et signalROOT ;puis liaison429 avant capture428Tutorial. Ensuite444Solo/446,445Team/447 et450TutorialRULES-partiel/451 restent sous leurs gates. Attribution434 corrigée dans444V3 avec annexe446,structures et sources antérieures conservées.

Recherche452/453 séparée :deux ressources Appen_US/fr_FR déclarées AIR119 manquent aux emplacements bornés ;six tentatives CDN ont échoué enDNS avant HTTP,aucun octet ni fichier récupéré. Cela ne qualifie ni leur absence globale,ni la locale effective,ni l'identitéBattleTraining↔Advanced. Ces inputs et questions restent ouverts.

Cette livraison qualifie les liens source de trois contrats client et les consommateurs du plan. Providers,catalogues,états,validation serveur,EUW et modes jouables restent ouverts. Aucun processus de jeu natif,AIR,VM,Rust ouGPU exécuté. Goal et jeu ouverts ;archiveSYS-03.4-07 non identifiée.


## Revue indépendante V429

La revue V4 a réussi : code 0, session 81850, dernier retour 723fb7. Elle comporte 2 333 contrôles propres, 271 identités physiques, 306 ancres AIR dans 203 fenêtres et 23 refus attendus. Le sceau (48 contrôles, code 0/81f2c8) et le compagnon (19 contrôles, code 0/9d11bc) restent séparés. Ces contrôles de sources et de restitution ne sont pas des tests du jeu.

Le delta vérifié est exactement un reçu source, aucun CID et aucun lien gameplay nouveau. Les trois fiches Custom et la fiche SYS restituent les sélecteurs précis dans les deux bases réelles, ouvertes en lecture seule avec les vrais task/copy/resolve et instructions ordinaires. Chaque base conserve ses 42 606 états et notes, 23 lignes d’historique et 42 602 lignes de catalogue hors cible. Les 42 214 exigences actives restent distinctes du catalogue incluant les lignes retirées. SCOPE384/387, anciennes listes, champs et autres tâches sont préservés.

Deux échecs propres au lecteur indépendant sont conservés : V2 comparait trop strictement les littéraux F:/ et F:\\ du même fichier426 (code 1/acab1c) ; V3 masquait un helper par une variable locale baseline (code 1/640a57). V4 corrige ces gardes sans modifier les sources ou la livraison427. Ils ne sont pas des défauts du produit. Les compteurs426 restent séparés : 493 contrôles source, 70 identités source et une pièce API additionnelle dans l’énumération finale de 71 ; 2 257 contrôles API distincts.

Le relecteur Fresh est distinct des auteurs des six qualifications sources, du préparateur427 et de ROOT. Ses anciens travaux sont attribués et ne deviennent pas une nouvelle auto-indépendance. Aucun producteur, jeu natif, AIR, VM, Rust ou GPU rejoué. Lectures et connexions closes avant FINAL.

Pièces privées : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision429_independent_custom_mode_roles_source_delivery. Sept versions documentaires brutes sont sauvegardées avant cette liaison. Les quatre registres et les bases ne sont pas modifiés par la liaison. Les inconnues de providers, états effectifs et serveur restent ouvertes. Le checkpoint de liaison et le signal ROOT précèdent la capture428 ; le résultat Custom ne termine ni le mode, ni le jeu, ni SYS-01.2-02.
