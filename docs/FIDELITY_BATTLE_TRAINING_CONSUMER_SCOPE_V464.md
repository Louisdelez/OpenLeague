# SYS-01.2-02 — portée des consommateurs par exigence

Les cinq fiches Battle Training affichaient le chargeur `world::enable_map10` comme consommateur actuel, malgré les réserves documentaires. Le lecteur du plan distingue maintenant ce lien conservé d’une implémentation qualifiée de la fonctionnalité demandée.

## Résultat

Le registre conserve le CID historique, son code, sa portée Map10 et toutes ses associations précédentes. Une qualification propre à chacune des cinq fiches explique pourquoi ce lien ne démontre pas Battle Training. Aucun rôle global du chargeur Map10 n’est changé.

Dans `requirement_trace.resolve`, les liens ainsi qualifiés sont séparés dans `out_of_scope_consumers`, avec leur raison et leur preuve ; ils ne figurent plus dans `consumers` pour les cinq fiches. Leur ancienne association reste consultable dans le registre. Le texte copiable affiche « Référence conservée hors périmètre » et explique qu’aucun consommateur de la fonctionnalité n’est démontré par ce lien.

Cette qualification concerne la portée prouvée du lien actuel. Elle ne prouve pas l’absence de toute autre implémentation dans le dépôt et n’identifie pas la carte historique de Battle Training. Les cinq fiches et leurs dix inconnues restent ouvertes.

## Source et consommateur

Le corps `Simulation::enable_map10`, dans `crates/core/src/world.rs`, charge `data/4.20/map10_world.json`, construit les camps et le monde, instancie les structures et active les interactions. Il ne démontre pas les règles, étapes, restrictions ou résultats du scénario Battle Training.

Le consommateur corrigé est le lecteur du plan `tools/project-plan/requirement_trace.py`, avec le nouveau module `consumer_scope.py`. La qualification est par exigence ; elle ne modifie pas le fonctionnement du jeu. Les preuves AIR partielles V463 restent présentes et distinctes.

## Vérifications réalisées

- Trois tests ciblés réussis : différence entre deux exigences partageant un même consommateur, refus d’une fausse qualification, preuve absente/détachée, doublons et questions fermées.
- Comparaison sur les graphes réels de 42 214 textes de traçabilité : seules les cinq fiches Battle Training changent ; 42 209 textes restent identiques. Ce contrôle porte sur la génération du texte, pas sur le gameplay.
- Les 3 644 autres exigences liées à ce CID continuent de l’exposer comme avant. Leur conservation n’est pas une preuve que tous ces liens sont sémantiquement corrects.
- Six refus via le résolveur et le validateur publics : mauvais sélecteur, prétention de fonctionnalité, consommateur absent.
- Préparation, installation avec archivage, publication et audit séparé réussis. Les lecteurs réels des deux bases relisent les six fiches, leurs instructions et leurs textes copiables ; les cinq exclusions sont également vérifiées dans le résolveur installé.
- Dans chaque base, 42 606 états/notes et 23 lignes d’historique sont conservés exactement ; 42 600 autres lignes du catalogue sont inchangées. Intégrité SQLite : ok.
- L’ancienne version du lecteur F: est archivée et sa transition est enregistrée via `source_versions`. Les anciennes sources E: ne sont pas modifiées. Sept des onze consommateurs du lecteur sont rattachés à sa source F: courante ; les onze ancres sont conservées à leurs lignes et contrôlées contre les octets actuels.
- Le registre des inconnues est identique en octets. Aucun statut de tâche, indicateur de complétude ou champ required n’est changé.

Aucun jeu, compilation Rust, client AIR ou test GPU exécuté. La validation du graphe ne remplace ni la qualification de toutes les sémantiques du jeu, ni l’acceptation humaine.

## Fichiers modifiés et preuves

- Code : `tools/project-plan/requirement_trace.py`, `consumer_scope.py`, `test_consumer_scope.py`.
- Registres : `docs/fidelity_sources_4_20.json`, `fidelity_requirement_trace_4_20.json`, `completion_tasks_2026-10-20.json`.
- Preuves : `docs/reference_battle_training_research/consumer-scope-v464.json`, `consumer-scope-code-transition-v464.json`, `docs/fidelity_battle_training_consumer_scope_v464.json`.
- Bases : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3` ; données des six fiches et instructions uniquement.
- Documents de couverture et reprise ; ancienne version du lecteur sous `docs/fidelity_source_versions/`.
- Préparation, sauvegardes, comparaison complète et audit : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision464/`.

## Limites et suite

Les sources historiques du scénario Battle Training manquent toujours selon V462/V463 ; aucune absence de modèles 3D ou textures n’est déduite. Ces lacunes ne bloquent pas les travaux indépendants.

L’inventaire complet `WORLD_LOADER_LINK_INVENTORY.json` recense 3 649 associations : 333 WORLD, 108 STRUCTURE, 63 CAMP, 84 MAP, 1 800 NATIVE, 44 MODE, 1 216 UNIT et SYS-01.2-02. Cinq sont maintenant qualifiées localement. Les 3 644 autres restent à examiner selon la portée précise de la tâche ; certaines peuvent être valides, partielles ou hors portée. Les nombres ne sont pas des résultats de fidélité.

Parmi elles, les fiches Classic 5v5 (Map11), ARAM (Map12) et Dominion (Map8) fournissent douze cas précis pour commencer. Poursuivre ensuite l’inventaire complet, en conservant les consommateurs spécialisés déjà associés. Ne pas requalifier en bloc sur un nom ou une carte déclarée ; confronter chaque lien aux sources et au corps réellement consommé.

SYS-01.2-02 reste partiel ; le Goal continue. Ni le mode ni le jeu ne sont déclarés terminés.
