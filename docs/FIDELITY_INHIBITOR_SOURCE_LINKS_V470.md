# SYS-01.2-02 — Sources et comportements des inhibiteurs, V470

Douze fiches sont enrichies : SOURCE, AI-VULNERABLE, AI-SUPER, AI-RESPAWN, AI et ACCEPT pour TT_OrderInhibitor et TT_ChaosInhibitor. Elles couvrent les références des quatre instances de la carte. Les liens génériques au chargeur sont conservés et complétés par les lecteurs et fonctions de comportement précis ; aucune fidélité complète du jeu n’est déclarée.

## Sources et consommateurs vérifiés

Le parseur a relu le LevelScript.luaobj natif, ses dix fonctions sélectionnées et leur identité par rapport au reçu antérieur. Les constantes, instructions hachées et lignes des prototypes correspondent. L’initialisation statique a aussi été relue et comparée au fichier extrait courant. Ce travail n’exécute pas les callbacks avec un moteur natif.

Les fonctions concernées sont OnLevelInitServer, AllowDamageOnBuildings, DeactivateCorrectStructure, GetDisableMinionSpawnTime, DisableBarracksSpawn, ApplyBarracksDestructionBonuses, ApplyBarracksRespawnReductions, BarrackReactiveEvent, GetMinionSpawnInfo et HandleDestroyedObject. Les corps Rust protected, damage_unit, wave_sequence et advance_world sont conservés dans le reçu, avec les identités des fichiers et 38 ancres existantes vérifiées.

| Sujet | Observation | Limite |
|---|---|---|
| PV | Les deux définitions actuelles utilisent 4000 ; Constants.var de Map10 stocke bar_MaxHP=3000 | Le producteur/override effectif d’origine reste à qualifier ; aucune modification automatique des PV |
| Code communautaire | BarrackVariables initialise MaxHP à 4000, puis GlobalData.Init peut le remplacer par GetInt(bar_MaxHP). Le JSON Map10 fourni vaut 3000 | Le défaut 4000 ne prouve donc pas la valeur effective communautaire ; ordre de packages et exécution non qualifiés. Ce code ne prouve pas le serveur Riot |
| Protection | Le code courant lit depends_all/depends_any et la vie des tours. Les quatre inhibiteurs ont chacun une tour protectrice propre | protected ne lit pas le temps dans son corps ; callbacks natifs d’activation/réactivation et toutes leurs arêtes restent à qualifier |
| Super-sbires | Le code courant produit un super pour la voie dont l’inhibiteur adverse est mort ; deux si les deux inhibiteurs adverses sont morts | Bonus/réductions, compteurs natifs, toutes les frontières de vague et cas spéciaux restent ouverts |
| Moment de décision | Le plan des sbires est figé au slot0 ; dans advance_world, cette étape précède la restauration des inhibiteurs arrivés à échéance | Une réapparition le même tick ne reconstruit pas le plan déjà figé ; cette observation de code n’est pas une preuve de la politique native |
| Réapparition | Après la mort, le moteur local fixe respawn_at = tick + 240 × TICK_RATE ; à l’échéance, il rétablit max_health | Les 240 secondes du script natif concernent la suspension des sbires, pas une preuve suffisante du délai de réapparition du bâtiment |
| Recette | Deux tests existants réussissent sur un binaire précisément identifié | Dégâts forcés et sauts de tick, pas une partie ordinaire ; couverture partielle des côtés et voies |

Le chemin communautaire a été suivi dans Package.GetMapData (constantes numériques), ContentManager.GetMapData (premier package disponible), MapScriptHandler.Init (chargement puis GlobalData.Init avant MapScript.Init), GlobalData.GetFloat/GetInt, puis CreateBuildings. Avec les constantes Map10 fournies effectivement sélectionnées, ce chemin remplacerait le défaut4000 par3000. Cette condition est explicite ; aucune exécution C# ni autorité du backend original n’est déduite de la lecture.

## Instances et protections locales

| Instance | Définition | Équipe locale | Voie | Tour requise |
|---|---|---|---|---|
| Barracks_T2_L1 | TT_ChaosInhibitor | 1 | 0 | Turret_T2_L_01 |
| Barracks_T2_R1 | TT_ChaosInhibitor | 1 | 1 | Turret_T2_R_01 |
| Barracks_T1_L1 | TT_OrderInhibitor | 0 | 0 | Turret_T1_C_06 |
| Barracks_T1_R1 | TT_OrderInhibitor | 0 | 1 | Turret_T1_C_07 |

Ces correspondances sont celles du JSON actuel et de sa consommation. Les noms ou positions ne valident pas automatiquement la sémantique native des protections. Les 50 champs des deux définitions et les observations de champs INIBIN ont été comparés aux preuves antérieures ; les anciens liens SOURCE sont préservés.

## Tests réellement exécutés

Le binaire de tests est F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision239/bin/openleague_core_v235.exe, SHA-256 cbe1c8e0e74f3a9a99e911462d2cbe84b4745a3dfceb476f96b976c2449b1ee0. Son identité est revérifiée avant et après les tests ; tous les fichiers d’entrée recensés dans le reçu V245 sont restés identiques. Ce n’est pas une nouvelle compilation de tout le checkout.

Commandes : chaque nom ci-dessous est passé au binaire avec --exact --nocapture --test-threads=1.

1. world::tests::structure_dependencies_prevent_early_nexus_damage_and_end_match_after_chain : code0, un test réussi. Refus de dégâts précoces/protection, refus d’attaque alliée, chaîne bleue sélectionnée détruite par dégâts injectés, victoire rouge et gel après victoire.
2. world::tests::inhibitor_respawn_restores_protection_and_super_minions_are_wave_scoped : code0, un test réussi. Chaîne rouge gauche détruite par dégâts injectés, un super bleu à la vague contrôlée, saut au tick de réapparition, santé maximale et protection de la tour du Nexus restaurées.

Les journaux bruts et le reçu CURRENT_INHIBITOR_TESTS.json sont dans revision470_runtime_checks. Ces tests ne couvrent pas les quatre instances, la frontière juste avant réapparition observée sur une simulation ordinaire, les deux inhibiteurs détruits simultanément, les protections temporelles natives, ni la présentation/audio. Le nom d’un test ne remplace pas ses assertions.

## Vérification du plan et intégration

- 18 liens natifs et 61 liens vers les consommateurs existants ajoutés, SYS inclus ; six sources enregistrées, dont le reçu, quatre fichiers du chargeur communautaire et le reçu des tests.
- Dix questions propres aux tâches de comportement ajoutées ; les deux questions de PV existantes restent exactement conservées. Aucune inconnue résolue.
- Six refus du collecteur : mauvaise entité, voie absente, mauvaise équipe, dépendance incorrecte, chunk natif tronqué, BaseHP inventé dans l’observation.
- Treize sélecteurs nominaux et quatorze sélecteurs invalides refusés.
- Lecteur réel : 42 214 textes de traçabilité comparés, douze changés et 42 202 identiques. Les sorties des autres tâches hors SYS restent identiques.
- Trois refus du validateur : mauvais propriétaire d’inconnue, résolution artificielle, condition de résolution absente.
- Publication vérifiée pour les quatre registres ; audit indépendant réussi des deux bases réelles. Treize fiches par base sont mises à jour, SYS inclus ; 42 606 états/notes et 23 historiques préservés, 42 593 autres lignes de catalogue identiques, intégrité SQLite correcte.

Le graphe compte 98 613 sources, 2 417 consommateurs, 25 351 inconnues ouvertes et 5 517 résolues. Les anciens enregistrements restent conservés. Aucun statut, critère, case utilisateur, code de gameplay ou asset n’est modifié.

La publication elle-même exécute les lecteurs Python et les contrôles SQLite, sans test de jeu supplémentaire ; les deux tests de cœur ont été exécutés séparément avant la collecte. Aucun client graphique, rendu GPU, moteur Lua natif ou runtime C# n’est lancé. L’appartenance aux manifestes et les expériences antérieures autres que ces deux tests restent des preuves héritées.

## Livrables et suite

Les quatre registres de traçabilité, les deux bases du plan et les documents de couverture/reprise sont actualisés. Reçu : docs/reference_inhibitor_sources/inhibitor-links-v470.json. Preuve : docs/fidelity_inhibitor_links_v470.json. Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision470/ ; scripts revision470_delivery.py prepare/publish/audit, revision470_check.py, revision470_tests.py et revision470_finish.py.

Suite : traiter les dix fiches de présentation des inhibiteurs (PRESENT, MODEL, TEXTURE, ANIM, AUDIO), en recherchant les véritables assets sélectionnés et leurs consommateurs. Puis poursuivre les structures/camps restants. L’inventaire particulier du chargeur Map10 contient encore500 associations à examiner et38 partiellement qualifiées ; ce n’est pas le nombre total de tâches restantes du jeu. SYS-01.2-02 et le Goal restent actifs.
