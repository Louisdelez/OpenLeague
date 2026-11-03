# Coopération contre les bots : sources et consommateurs — V507

25 octobre 2026 — F:\OpenLeague — SYS-01.2-02. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 et composant AIR 0.0.1.119 distincts.

## Résultat

Les quatre fiches MODE-COOP SCOPE/SELECT/RULES/RESULT reconnaissent leurs sources natives partielles et précisent les consommateurs encore non qualifiés. Cinq liens historiques sont conservés dans les listes brutes mais signalés hors portée du gameplay coop : World sur les quatre fiches et invoke_handler sur SCOPE. Les rôles globaux et tous les records de consommateurs restent exacts.

Les huit questions existantes restent ouvertes, avec leurs mêmes identifiants, propriétaires, aspects et statuts. Les formulations datées « aucun fichier exact trouvé » et « admission de None » sont précisées selon les sources actuellement liées et les contrats réels. Anciennes questions/conditions conservées dans question_history, recherches antérieures conservées en préfixe ; aucune création/résolution d’inconnue. Critères, dépendances, required/required_if, entity.map=null, statuts, cases, notes et historiques conservés.

Aucun code, asset ou binaire du jeu n’est modifié. Cette livraison améliore le registre et sa restitution dans les deux bases du plan ; elle n’implémente ni ne valide une partie coop complète.

## Sources examinées et limites

V379 fournit le contrat SCOPE conditionnel ; V412 les trois contrats SELECT/RULES/RESULT. Leurs sources, auteurs, stades et limites restent attribués ; aucune qualification/revue ancienne n’est rejouée. La collecte relit 53 occurrences d’ancres de V379 et 263 de V412, soit 316 occurrences vérifiées, et les 136 fenêtres de V412. Ces occurrences ne sont pas 316 fonctions nouvelles.

| Fiche | Source déjà identifiée | Manque conservé |
|---|---|---|
| SCOPE | Quatre familles binaires AIR119 ; flux CoOp, provider, manager et requête de files | Provider/catalogue/callbacks effectifs, cartes/files et activation EUW datée |
| SELECT | Cinq autorités AIR ; disponibilité, filtres et composition conditionnels | Roster actif, champions/difficultés, pools/flags/ownership et composition serveur réelle |
| RULES | Cinq autorités AIR ; construction de requête et conditions de participants | Sélection AI effective, boucle autonome, priorités, mouvements, sorts/achats, timers et règles serveur |
| RESULT | Quatre autorités AIR ; DTO/providers, prédicats et retour/rejeu conditionnels | Partie contre bots, résultat/retour/rejeu ordinaires, calcul et attribution des récompenses, fidélité |

Les 18 occurrences native_inputs déjà associées restent exactes : 4/5/5/4. Aucun nouveau lien natif n’est ajouté pour assimiler un helper candidat à une politique coop effective.

Les nuances antérieures sont conservées : getQueues compare exactement BOT dans le corps inspecté, ce qui ne généralise pas au helper BOT_3x3 ; isTutorial ne détermine pas seul tutorialPickOverride ; la seconde comparaison de minimum non Solo reste distincte du fallback ; Number(queueId) ne valide pas finitude/plage/difficulté. Les trois prédicats WIN, le premier slot indexé[0], les OR littéraux, la désactivation et les conditions de retour/rejeu restent distincts. Le signal Tutorial ne qualifie pas un résultat Coop. Les champs de récompenses reçus ne fournissent pas leur formule serveur.

## Ressources de bots présentes

La collecte réidentifie 14 fichiers de scripts/helpers/mutateurs, soit 59 prototypes enfants : Bot, TaskBuyItem, TaskCastSpell, TaskDefendStructure, TaskKillHero, TaskKillMinion, TaskKillTower, TaskPushLane, TaskRetreat, TaskWander et quatre mutateurs Bot/IntroBot. Le TutorialScript physique Map12 est exclu de cette sélection de helpers coop candidats.

Les mots d’instruction, constantes et hashes de code des prototypes sont comparés au relevé antérieur. Le Tick sélectionné de TaskCastSpell comporte sept mots et les constantes math/random/0/3 ; son appel encodé ne démontre pas un lancement de sort dans ce corps. Cette observation n’est pas généralisée à toute l’IA de sorts de LoL ni à un binding runtime de math.random.

Le recensement parcourt les 122 dossiers de champions de la référence : 369 fichiers Bot .dat/.inibin, dont 59 .dat, répartis dans 62 dossiers non vides. Tailles/SHA et appartenance aux manifestes sélectionnés sont vérifiés pour ces 369 fichiers et les 14 helpers. Les anciens décodages et cas d’adaptateurs ne sont pas présentés comme fraîchement exécutés.

Ces fichiers sont des ressources candidates. Leur présence ne démontre pas leur sélection/montage pour une file coop donnée, les bots effectivement exposés en EUW, la difficulté active ou la boucle serveur. Les 49 anciens cas Lua/adaptateurs et sept anciens tests Rust de fondation du reçu bot_tutorial restent des preuves historiques bornées, sans rejeu ni addition en nouveaux tests du mode.

## Consommateurs actuels inspectés

World initialise les définitions, acteurs et interactions de Map10. Ce corps ne produit pas les contrats coop de disponibilité, sélection, règles ou résultats. Son CID et sa portée globale sont conservés pour les autres exigences pertinentes.

invoke_handler déclare exactement roster, play, join_local, session_status, resume_session et abandon_session. Son rôle était déjà entry_boundary_only/provides_feature_consumer=false. La fiche SCOPE ne le présente plus comme un consommateur du mode coop. Le corps serveur lu initialise explicitement Map10. Les commandes génériques et les résultats locaux existants ne sont pas promus en boucle de décision de champions bots ou en partie coop ordinaire.

Recherche fraîche dans 1203 fichiers Rust/JS/HTML/TS de crates et launcher, avec exclusion explicite de target et node_modules. Zéro fichier de ce corpus ne correspond aux termes coop/co_op/cooperative/bot/bots et aux noms de helpers/RPC ciblés. Une recherche exploratoire plus large avait trouvé l’entité HTML « bot » dans des fichiers générés ; elle est sans rapport avec une IA de bot et n’est pas une preuve de fonctionnalité. Le résultat de la recherche bornée n’est pas une preuve d’absence globale de toute implémentation. Les corps des références enregistrées sont lus séparément pour justifier leur portée précise.

## Contrôles exécutés

| Contrôle | Attendu | Observé |
|---|---|---|
| Sources et sélections | Identités, ancres/fenêtres et ressources conformes aux reçus | 1833 identités ; 316 occurrences AIR, 136 fenêtres ; 14 helpers/369 configurations membres des manifestes sélectionnés |
| Lecteur Lua | Refus du tronqué, en-tête invalide et données finales ajoutées | 42 refus réels, trois par helper ; fichiers natifs inchangés |
| Portée du plan | Liens historiques conservés hors portée, aucun consommateur du gameplay qualifié par eux | Quatre fiches, cinq exclusions ; tous les records de consommateurs exacts |
| Questions | Huit identités/statuts ouverts, anciennes formulations/conditions/recherches récupérables | Conforme ; compteurs et tous les autres enregistrements exacts |
| Refus publics | Fausse feature, preuve détachée, non-membre, doublon ; mauvais propriétaire/statut/condition | 40 refus via le validateur public |
| Historique retiré | La garde de livraison refuse la perte des anciens constats | Huit refus ; le lecteur générique accepte cette métadonnée sans contrôler son historique, ce qui reste explicitement distingué |
| Contexte SYS | qualified_existing_consumer_ids conforme au sélecteur pour toutes les cibles, SYS inclus | Précontrôle réussi avant publication |
| Conservation globale | Seuls quatre textes de traçabilité changent ; critères et voisins protégés exacts | 42214 textes comparés, 42210 exacts ; cinq Tutorial et cinq Battle Training, leurs critères/questions/historiques exacts |

Préparation : cinq sélecteurs nominaux et six refus. Les vrais Store.task/copy_text, requirement_trace.resolve et instructions ordinaires des cinq fiches, SYS inclus, sont relus dans chaque base après publication puis par un audit séparé. La comparaison des 42214 textes de traçabilité ne constitue pas l’exécution des 42214 tâches ou du jeu.

Le contrôle du contexte SYS applique avant publication la vérification qui avait manqué dans V506. Les incidents et la reprise de V506 restent dans leurs artefacts d’origine ; ils ne sont pas rejoués ou requalifiés par V507.

## Preuves, fichiers et reste à faire

Observation COOP_SCOPE_OBSERVATIONS.json : 2215773 octets, SHA256 `90894fe1a2cbbf95c9e26a996bd5ffd4bbd3d186b4476a4dd96a467d7f42481c`. Corpus, lignes, ressources, manifestes, prototypes, refus et identités sont conservés dans ce fichier. Les scripts, commandes et résultats sont sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision507*.

Rapport docs/FIDELITY_COOP_CURRENT_SCOPE_V507.md ; reçu docs/reference_coop_mode_roles_sources/coop-current-scope-v507.json ; preuve docs/fidelity_coop_current_scope_v507.json. Quatre registres et deux bases du plan actualisés ; couverture et reprise mises à jour. Aucun statut manuel n’est accepté automatiquement.

Commandes exécutées avec Python -X utf8 -E -u -B : collecteur inspection, delivery prepare, contrôle candidat, delivery publish puis audit. L’interpréteur, scripts, ressources et journaux pertinents sont identifiés dans les preuves. Aucun jeu, client AIR, VM Lua, processus serveur/client, compilation Rust, GPU ou audio n’est exécuté.

Restent notamment les réponses/catalogues/providers effectifs, les cartes et files régionales, le roster et les difficultés réellement actifs, la boucle autonome des champions bots et ses règles serveur, une partie ordinaire jusqu’au résultat/retour/rejeu et la fidélité humaine. Les sources partielles et consommateurs de fondation permettent de documenter ces manques ; ils ne les résolvent pas. SYS-01.2-02, les modes et le jeu restent ouverts.

Bilan vérifié : deux sources de preuve, aucun CID ou lien natif/consommateur nouveau ; 18 occurrences natives et tous les records de consommateurs exacts. Cinq références hors portée sur quatre fiches ; huit questions affinées avec anciens textes/conditions/recherches conservés, zéro création/résolution. Graphe : 98706 sources / 2608 consommateurs / 25827 ouvertes / 5517 résolues avec historique. Chaque base : cinq fiches relues, 42601 autres lignes de catalogue exactes ; 42606 états/notes et 23 historiques exacts, intégrité OK. Collecte/préparation/candidat/publication/audit : codes terminaux 0 observés. Aucun producteur historique ou test de jeu rejoué. Sous-inventaire :15à reprendre/477partielles/48lignes horsportée encore ouvertes, dont27audio ;deux liens World de tâches TTpartielles comptés séparément.
