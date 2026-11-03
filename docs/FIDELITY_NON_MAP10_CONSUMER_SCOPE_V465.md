# SYS-01.2-02 — 1 896 associations au chargeur Map10 rectifiées

Les fiches de Map1, Map8, Map11 et Map12 citaient `world::enable_map10` comme consommateur actuel. Le corps de cette fonction charge `data/4.20/map10_world.json` ; il ne démontre pas la consommation des CFG natifs des quatre autres cartes. Les associations historiques sont désormais conservées et explicitement qualifiées hors de la portée démontrée de ces exigences.

## Portée traitée

| Famille | Exigences |
|---|---:|
| Fiches de cartes MAP | 84 |
| Configurations d’objets NATIVE | 1 800 |
| Classic 5v5, ARAM et Dominion : disponibilité, sélection, règles, résultat | 12 |
| Total | 1 896 |

SYS-01.2-02 reçoit également le lien vers les preuves : 1 897 fiches enrichies dans le registre et dans chacune des deux bases du plan.

Le lecteur installé depuis V464 expose ces liens dans `out_of_scope_consumers` et les décrit dans les instructions copiables. Les identifiants historiques, les entrées natives, les inconnues et les autres consommateurs restent conservés. Six consommateurs spécialisés, soit douze associations sur les deux fiches de sélection Classic et ARAM, ne sont pas retirés ni requalifiés comme complets. Leurs limites antérieures restent applicables.

## Sources et contrôles

Les quatre fichiers `LEVELS/<carte>/.../ObjectCFG.cfg` proviennent du client fourni 4.20. Leurs tailles, SHA-256 et MD5 enregistrés ont été vérifiés. Leur appartenance aux manifestes est héritée des preuves existantes ; le parseur de manifeste n’est pas réexécuté.

Pour chaque tâche NATIVE, la carte déclarée est confrontée au chemin de sa source, le chemin natif de la fiche au fichier enregistré, puis le sélecteur, le nom d’objet et les champs à la section réelle du CFG. Les 1 800 comparaisons de tâches couvrent 360 sections distinctes. Cette comparaison ne qualifie ni leur instanciation en jeu ni la disponibilité historique du mode.

Le corps du chargeur actuel et son entrée JSON ont été relus et identifiés. Les six consommateurs spécialisés ont été comparés à leurs sources enregistrées et à leurs ancres courantes, sans exécution du jeu.

Contrôles réalisés :

- Six refus du qualificateur : Map10, CFG d’une autre carte, section absente, valeur de champ modifiée, inconnue absente, lien consommateur absent.
- 1 897 sélecteurs nominaux et 1 898 refus de tâche/sélecteur pendant la préparation.
- Comparaison des 42 214 textes de traçabilité : 1 896 textes changés, 40 318 identiques. Les sorties des autres consommateurs restent identiques.
- Six refus via le résolveur et le validateur publics : mauvais sélecteur, prétention de fonctionnalité et consommateur absent.
- Publication puis audit séparé : 1 897 fiches, instructions et textes copiables relus via les lecteurs réels dans chaque base ; 1 896 qualifications de portée vérifiées.
- 42 606 états/notes et 23 entrées d’historique conservés exactement dans chaque base ; 40 709 autres lignes du catalogue inchangées. Intégrité SQLite : ok.
- 40 317 autres exigences actives inchangées. Sources et consommateurs préexistants conservés ; un reçu de preuve ajouté, aucun nouveau consommateur inventé. Registre des inconnues identique en octets.

Le graphe compte maintenant 98 602 sources et 2 412 consommateurs enregistrés. Il conserve 25 321 inconnues ouvertes et 5 517 résolues. Aucune inconnue n’est résolue par ce lot. Aucun statut de tâche, champ required ou critère d’acceptation n’est modifié.

Aucun code de production modifié dans V465, aucune compilation Rust, aucun client AIR, jeu, VM ou contrôle GPU exécuté. Les vérifications portent sur les liens, les données natives citées et leur présentation dans le plan ; elles ne prouvent pas un mode de jeu terminé.

## Livrables

- `docs/reference_world_consumer_scope/non-map10-scope-v465.json` : 1 896 associations, sources, sections comparées, portée du chargeur, prérequis et limites.
- `docs/fidelity_non_map10_consumer_scope_v465.json` : publication et vérifications des bases.
- `docs/fidelity_sources_4_20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/completion_tasks_2026-10-20.json` : registre actualisé.
- Bases `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3` : données des fiches et instructions, sans modification manuelle.
- `docs/coverage.json`, `completion_plan.json`, `resume_checkpoint.json` et documents `docs/ai` : preuves et reprise actualisées, anciennes versions sauvegardées.
- `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision465/` : préparation, sauvegardes, comparaison, audit et inventaire des associations restantes.

## Limites et suite

Les modes et objets concernés restent partiels. Un CFG retrouvé n’est pas une preuve de disponibilité historique, de règles complètes, d’assets rendus ou de partie fonctionnelle. Pour 1 894 fiches du lot, le lien retiré des consommateurs effectifs était le seul associé ; cela signifie que leur implémentation n’est pas démontrée par les liens recensés, pas qu’une absence globale de code a été prouvée.

Il reste 1 748 associations à examiner : SYS 1, WORLD 333, STRUCTURE 108, CAMP 63, MODE 27 et UNIT 1 216. L’inventaire `REMAINING_WORLD_LOADER_LINKS.json` les conserve avec leurs sources et inconnues.

La prochaine analyse porte sur les 304 entités des 1 216 fiches UNIT et sur les producteurs de définitions réellement admis. Le JSON Map10 contient 27 définitions ; le code ajoute `annietibbers` et `annie_r.rs` l’utilise explicitement. L’absence du nom littéral `AnnieTibbers` dans le JSON ne prouve donc pas une absence de prise en charge. Examiner les alias, insertions et appels de production avant de qualifier les liens ; les occurrences dans des tests embarqués ne sont pas des appels de production.

Les lacunes historiques Battle Training restent documentées localement. SYS-01.2-02 et le Goal restent ouverts ; ni le mode ni le jeu ne sont déclarés terminés.
