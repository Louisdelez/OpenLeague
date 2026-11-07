# SYS-01.2-02 — Améliorations temporelles des sbires, V486

Huit fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-AI-UPGRADE sont reliées aux sources natives, aux champs consommés par Rust et aux observations de64 scénarios actuels. Chacune conserve une question ouverte. Aucun code de gameplay, asset, critère, prérequis ou état manuel modifié.

Référence : LoL4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague.

## Sources et règles distinctes

Les huit INIBIN de personnages sont redécodés pour BaseHP, BaseDamage, Armor, SpellBlock, ExpGivenOnDeath et GoldGivenOnDeath. La présence, la valeur brute et la comparaison numérique avec la configuration courante sont conservées. Un champ absent reste absent.

LEVELS/Map10/Scripts/LevelScript.luaobj est reparsé intégralement. Sept fonctions sont comparées aux preuves précédentes par constantes, opcodes et SHA des instructions : OnLevelInitServer, GetInitSpawnInfo, GetMinionSpawnInfo, UpgradeMinionTimer, IncreaseCannonMinionSpawnRate, ResetToDefaultWaveCounts, ClearCurrentWaveCounts. Aucun de ces callbacks n'est exécuté dans ce lot.

La récupération des tables suit seulement l'initialisation bornée autorisée par native_lua.py, jusqu'à l'appel non interprété au pc277/opcode28. Le résultat concorde avec le reçu hérité. UPGRADE_MINION_TIMER vaut90 ; les tables Melee/Caster/Cannon/SuperDefaultMinionInfo donnent les coefficients et overrides. Dix champs de table par définition concordent avec map10_world.json. Les appartenances RADS restent héritées ; les identités physiques sont revalidées, sans nouvel audit de manifeste.

| Type, identique pour Bleu/Rouge | HP ajoutés | Dégâts ajoutés | Armure ajoutée | Résistance magique ajoutée | Or ajouté | Bonus d'or maximal | XP de carte |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Mêlée |10|0,5|1|0,625|0,2|12|64|
| Mage |7,5|1|0,625|1|0,2|8|32|
| Canon |13,5|1,5|1,5|1,5|0,5|30|100|
| Super |100|5|0|0|0,5|30|100|

Ces valeurs sont des coefficients de table. Leur application historique exige aussi le timer, le choix de table et les helpers. UpgradeMinionTimer contient notamment HPBonus/HPUpgrade, DamageBonus/DamageUpgrade, GoldBonus/GoldUpgrade/plafond, Armor, MagicResistance, ExpBonus/ExpUpgrade et LocalGoldBonus/GoldShareUpgrade. ExpUpgrade et GoldShareUpgrade valent0 dans les quatre tables récupérées. Leur présence n'est ni ignorée ni transformée en mécanisme local supplémentaire.

Exemples d'overrides distincts : les fichiers de personnages donnent XP77/51/94/500 et or20/10/35/150 pour mêlée/mage/canon/super. Map10 donne XP64/32/100/100 et or18,8/13,8/39,5/39,5, consommés actuellement. L'armure des fichiers canon15 et super30 devient0 dans ces tables ; SpellBlock du super vaut−30 dans son INIBIN, contre résistance magique0 dans Map10. Pour les autres types SpellBlock est absent dans les fichiers vérifiés. Ces écarts sont documentés ; ils ne sont pas déclarés corruption ou automatiquement corrigés.

## Exécution actuelle

Un nouveau programme Rust a été compilé et exécuté avec coreV476 après revalidation des entrées, outils, bibliothèque et dépendances. Aucun nouveau cargo build. Binaire, commandes, codes de sortie0, journaux et observations : revision486_runtime_checks/CURRENT_MINION_UPGRADE.json. Le schéma de ce reçu porte bien V486.

64 cas : huit définitions × huit scénarios. Les unités sont créées par le planificateur actuel ; le scénario prépare les créneaux antérieurs puis avance explicitement le tick au moment à mesurer. Les supers utilisent des inhibiteurs ennemis dont la santé est fixée à0. Les sauts temporels ne représentent pas une partie jouée continûment et ne qualifient pas le calendrier ordinaire des vagues.

À la naissance, le code courant calcule floor(tick/(30×90)). Santé maximale et initiale, dégâts et défenses utilisent leur base et ce nombre d'améliorations. L'or ajoute min(coefficient×nombre,plafond). Le champ d'expérience copie la constante de définition.

| Scénario par définition | Attendu et observé |
| --- | --- |
| Première naissance trouvée dans le calendrier local | Sept champs statistiques concordent avec la configuration et l'indice calculé |
| Tick5399, avant la deuxième amélioration | Une amélioration |
| Tick5400, seuil exact | Deux améliorations |
| Tick5401, juste après | Deux améliorations |
| Un tick avant le plafond d'or | Bonus inférieur au plafond |
| Au seuil du plafond | Bonus égal au plafond |
| Une période après le plafond | Même or ; autres statistiques suivent leurs coefficients |
| Unité existante franchissant deux seuils | Après blessure contrôlée de100, santé, maximum, dégâts, défenses, or et XP restent identiques |

Les plafonds locaux sont atteints après40 périodes pour les mages et60 pour les autres profils. La récompense maximale enregistrée est21,8 pour les mages,30,8 pour les mêlées,69,5 pour les canons/supers, sous réserve de représentation float32 conservée dans les observations. Ces champs ne prouvent pas le versement effectif, l'arrondi final ou le partage d'or/XP.

Dans le dernier scénario, l'acteur est créé au tick5399, sa santé est diminuée directement de100, son AI et ses attaques sont figées, chemins/cible effacés et les autres unités retirées. Le temps passe ensuite à5400 puis à une période au-delà du plafond d'or. Les champs restent exactement inchangés. Cela démontre le comportement actuel dans cette isolation ; cela ne prouve ni une politique native de mise à jour en direct, ni une guérison implicite, ni toutes les interactions de combat.

## Registre, refus et conservation

Huit nouvelles ancres dans world.rs : horloge de naissance, arrondi inférieur, santé, dégâts, armure, résistance magique, plafond d'or et expérience constante. Les anciennes associations restent en place. Une inconnue par tâche précise l'ancrage et la précision du timer natif, le cumul des tables, la propagation vers les unités déjà présentes, les bonus d'inhibiteur et les récompenses.

Cinq refus de format vérifiés : trois Lua altérés (en-tête, troncature, octet final ajouté), deux INIBIN invalides. Neuf sélecteurs nominaux et dix invalides ; trois refus du lecteur public pour propriétaire d'inconnue incorrect, fausse résolution ou condition vide.

42 214 instructions comparées :8 modifiées et42 206 identiques. Critères, prérequis, inconnues antérieures et autres sorties préservés. Publication puis audit indépendant des quatre registres et des deux bases. Neuf fiches/base, y compris SYS-01.2-02 ;42 606 états/notes,23 historiques et42 597 autres lignes du catalogue conservés exactement. Intégrité SQLite et chemins réels Store.task/copy_text vérifiés. Aucune case cochée, aucune inconnue résolue. Aucun échec du programme de test ou des collecteurs de ce lot.

## Limites et livraison

Restent ouverts : ancrage historique des90secondes, ordre des callbacks, précision et arrondis natifs, sélection/montage effectif, bonus d'inhibiteur, propagation vers les unités vivantes et versement/partage des récompenses. Les tables et fichiers sont disponibles ; leurs sémantiques complètes ne sont pas déduites d'une égalité numérique. Aucun serveur/client Riot, rendu ou audio exécuté.

Nouveaux fichiers : docs/reference_minion_behavior_sources/minion-upgrade-v486.json, docs/fidelity_minion_upgrade_v486.json et ce rapport. Scripts, observations, sauvegardes et preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision486*.

Modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json ; bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu ni asset modifié.

Sous-inventaire du chargeur :183 associations encore génériques (WORLD155, MODE27, SYS1),333 partielles et24 exclusions dont12 audio. Ce sous-inventaire ne mesure pas l'achèvement global du jeu. Suite : consolider les huit fiches SOURCE des sbires déjà partiellement reliées enV250, puis les huit agrégats AI encore génériques. Les sources existantes, leurs nombreuses ancres et leurs limites doivent être conservées ; ne pas présumer une implémentation absente. Goal actif.

Ajouts : 16 liens natifs, 72 liens consommateurs, 8 nouveaux consommateurs, 2 sources et 8 questions ouvertes. 1235 fichiers directement épinglés. Graphe : 98648 sources, 2511 consommateurs, 25668 ouvertes, 5517 résolues avec historique.
