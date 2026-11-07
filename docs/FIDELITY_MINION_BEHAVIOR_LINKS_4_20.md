# Sources et consommateurs du comportement des sbires — V100

Objectif SYS-01.2-02 :six exigences SYS-12.1 reliées à13 rôles du code actuel. Quatre parcours partiels,deux frontières explicites pour le producteur de renfort de voie et la géométrie de formation. Aucune clôture de fonctionnalité ou acceptation du jeu n’en découle.

## Référence native et comparaison

Trois fichiers Lua (Minion,Shared/Minions et LevelScript Map10),huit INIBIN de sbires et le sort Blue_Minion_WizardBasicAttack correspondent aux manifestes RADS sélectionnés4.20. Les deux lecteurs Lua locaux concordent sur tous les tableaux d’instructions,constantes et enfants,avec consommation totale des octets. Les fonctions sont identifiées par CLOSURE/SETGLOBAL et leurs plages de lignes ;ces associations ne suffisent pas à qualifier un appelant moteur.

Les structures Rust Definition,Unit et Lane restent séparées. Les valeurs native/current de MoveSpeed et GameplayCollisionRadius concordent pour les huit profils. AcquisitionRange est présent et égal à700 pour les casters,600 pour les supers ;il est absent pour les mêlée et canons,dont l’acquisition locale475 reste à qualifier. PathfindingCollisionRadius,GameplayCollisionRadius et SelectionRadius sont des champs distincts. Le missile du caster vaut650 dans SpellData et dans le contrat local.

Le callback natif de scan demande FindTargetInAcR ;la politique interne de ce helper n’est pas qualifiée. Rust prend actuellement la distance minimale après filtres d’équipe,vie,visibilité,protection et rayon. Le script déclare DELAY_FIND_ENEMIES=0.25 ;le code Rust attend next_ai puis fixe tick+8 à30Hz. Une conversion d’unités ne prouve pas l’équivalence entre scan,retarget et anti-kite.

## Exécution Lua originale bornée

Les deux chunks Minion et Shared/Minions ont été chargés par le module Lua5.1 déjà présent dans tools/pythonlibs. Le seul changement de représentation est le passage des longueurs size_t de chaînes32 vers64bits,avec roundtrip byte-exact et empreintes de tous les tableaux d’instructions identiques. Le producteur réutilise uniquement la fonction adapt inspectée de qualify_original_endgame_lua51.py,extraite via AST ;il n’exécute pas ce script historique complet ni ses écritures E.

L’environnement Lua ne contient que les états symboliques et API fournis explicitement. DoLuaShared accepte seulement Minions et charge les octets identifiés. Les méthodes moteur enregistrent les demandes ;elles ne simulent pas une collision géométrique,un déplacement réel ou le scheduler historique.101 cas couvrent OnInit et les callbacks OnCallForHelp,OnCollisionEnemy,OnCollisionOther sur les20 états déclarés,avec cibles absentes/présentes lorsque pertinentes. Un import partagé inconnu est refusé par l’adaptateur,ce qui est une garde locale du banc et non une règle attribuée au jeu.

OnCallForHelp ne demande SetStateAndCloseToTarget et ResetAndStartTimer TimerAntiKite que pour une cible fournie dans AI_ATTACKMOVESTATE ou AI_ATTACKMOVE_ATTACKING. La nature champion de la cible et l’attaque qui déclenche ce callback ne sont pas prouvées. La branche Rust damage_unit observée réveille les unités d’un camp ;elle n’établit pas un producteur de renfort des sbires de voie.

OnCollisionEnemy/Other conservent leurs gardes d’états. Les demandes de cible et valeurs de retour sont consignées,mais aucune résolution de contact entre corps n’est déduite. Le code courant choisit un seed de voie ou nearest_walkable et suit un path avec garde du pilier ;l’écartement des formations à la sortie de base reste ouvert.

## Tests Rust et refus

La commande `cargo test --locked --offline -p openleague-core --lib stuns::unit_tests:: -- --nocapture` a réellement exécuté six tests,zéro échec. Quatre concernent les unités/sbires :mouvement interrompu puis repris,windup interrompu,projectile lancé ou non lors d’un stun/décès,gardes et nettoyage. Deux portent sur le contrôle des pets. Ils utilisent une navigation synthétique et ne qualifient pas les priorités natives ni un rendu.

Le premier filtre unit_stun_tests:: a sélectionné zéro test ;le wrapper a refusé cette exécution malgré le code Cargo0. Ce journal et son producteur restent conservés,distincts des six tests exécutés après correction du nom du module stuns::unit_tests.

Le traitement Pending conserve les attaques futures et retire celles résolues ou annulées. Le test de projectile lancé conserve encore l’entrée de la source morte ;il ne prouve pas tous les cas de suppression effective d’entité ni le nettoyage visuel/réseau. Les critères restants sont écrits dans la fiche concernée.

Onze refus binaires ont été exercés sur copies d’octets :en-tête/troncature/trailing Lua pour trois scripts,en-tête/troncature INIBIN pour le sort. Le lecteur de liens vérifie59 identités et361 conditions ;sa qualification passe32 cas,dont31 refus de reçus altérés. Ces mutations sont des tests de traçabilité et de portée,distincts des101 exécutions Lua et des six tests Rust.

## Corrections et conservation

La préparation a d’abord supposé AcquisitionRange absent pour les huit profils ;le contrôle du caster a refusé cette généralisation. La relecture a distingué quatre valeurs présentes et quatre absentes. Une seconde tentative a recherché navigation.rs,inexistant :Navigation est dans lib.rs et la garde de pilier dans pillar_navigation.rs. Les deux versions de préparation et journaux d’échec sont conservés ;aucune absence globale de fonctionnalité n’en est déduite.

Le lot modifie le lecteur de traçabilité,les registres,les documents de couverture/reprise et sept fiches de chaque base. Snapshots,états manuels,notes,historique et flags sont contrôlés par l’audit de livraison ;Store.task et Store.copy_text sont exercés sans synchronisation globale du catalogue. Aucun asset/code runtime du jeu modifié,aucun jeu,GPU,AIR ou serveur historique exécuté. Les prérequis du lot de traçabilité sont vérifiés,les prérequis aval et l’acceptation des comportements restent ouverts.

Preuves et producteurs : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision100. Les identités binaires du test Rust,du module Lua,du Python et des sources sont dans le reçu.

## Détail par exigence

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-12.1-01 | Definition,Unit et Lane sont séparés et spawn_unit refuse world disabled/unknown NPC definition. Huit INIBIN,leurs valeurs de déplacement/rayon et les tables Map10 sont reliés ;le spawn conserve définition,instance et voie distinctes. | Qualifier la construction et les variantes complètes de chaque définition,les erreurs de voie et toutes les règles natives de spawn ;les structures de données ne prouvent pas toute l’IA. |
| SYS-12.1-02 | Le script Minion demande FindTargetInAcR ;ses priorités internes ne sont pas dans ce callback. Rust choisit le plus proche ennemi visible,vivant,dans acquisition+rayon et non protégé. AcquisitionRange natif vaut700 pour les casters et600 pour les supers,identiques aux valeurs locales ;il est absent pour les mêlée/canons dont la valeur locale475 reste distincte. | Identifier et qualifier FindTargetInAcR,les priorités et filtres historiques avant de comparer complètement le choix local ;la distance minimale locale ne prouve pas ces priorités. |
| SYS-12.1-03 | Les instructions originales OnCallForHelp sont exercées dans Lua5.1 avec états symboliques et API moteur adaptées :seuls AI_ATTACKMOVESTATE/AI_ATTACKMOVE_ATTACKING avec cible fournie demandent fermeture et TimerAntiKite. Le consommateur actuel damage_unit réveille les membres d’un camp ;cela ne démontre pas les renforts des sbires de voie lors d’une attaque de champion. | Qualifier le producteur natif du callback,les types de dégâts,rayons et filtres de renfort ;relier un véritable consommateur de voie avant de fermer cette frontière. Une API adaptée ne prouve pas son effet moteur. |
| SYS-12.1-04 | Minion déclare DELAY_FIND_ENEMIES=0.25 et DoLuaShared Minions ;OnInit demande ce timer et un TimerAntiKite4. Rust réévalue à next_ai puis fixe tick+8,soit8/30secondes au tickrate courant. Ce sont des contrats distincts,non une équivalence prouvée du délai de retarget. | Qualifier le scheduler natif,la distinction scan/retarget/anti-kite,les interruptions et l’arrondi ;ne pas convertir automatiquement0.25s en8ticks comme preuve de fidélité. |
| SYS-12.1-05 | Les callbacks originaux de collision sont exercés pour20 états et sélections nulles/non nulles. Ils demandent des transitions de cible ;aucune résolution géométrique ou formation n’est exécutée. Rust place au seed de voie ou nearest_walkable,puis avance sur path avec garde du pilier. | Qualifier les collisions entre corps,formations,écartement au spawn et le déclenchement natif des callbacks ;les rayons pathfinding/gameplay/selection sont distincts et ne prouvent pas une résolution de collision. |
| SYS-12.1-06 | La boucle Pending distingue windup,release et résolution puis ne conserve que les attaques futures. Les tests Rust vérifient notamment le refus avant release et la survie du projectile lancé à stun/mort de la source encore présente. Le sort natif de base du caster et son missile650 sont identifiés. | Qualifier suppression effective de la source/cible,annulations et nettoyage visuel/réseau selon la référence ;un corpse présent diffère d’une entrée supprimée et les tests actuels ne prouvent pas l’intégralité du cycle natif. |

Reçu : docs/reference_minion_behavior_sources/minion_behavior-links.json. Livraison : docs/fidelity_registry_minion_behavior_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
