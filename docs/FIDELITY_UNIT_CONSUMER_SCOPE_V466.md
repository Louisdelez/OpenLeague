# SYS-01.2-02 — Liens des 304 entités UNIT

Les 1 216 fiches UNIT ont été examinées pour qualifier leur association au chargeur Map10. Les liens génériques ne suffisent pas à démontrer le comportement de chaque unité. Trois entités possèdent des chemins plus précis dans le code actuel : Tibbers, la relique et le pilier de Trundle.

## Résultat intégré

| Ensemble | Résultat |
|---|---|
| AnnieTibbers, quatre fiches | Définition ajoutée dynamiquement, création par le R d’Annie, ordres et aura, catalogue d’animations monde fusionné, demande du modèle depuis le snapshot. |
| TT_Relic, quatre fiches | Initialisation des interactions par Map10, disponibilité et ramassage dans l’état d’interaction, placement et chargement du modèle côté client. |
| TrundleWall, quatre fiches | État de pilier distinct des NPC, création/expiration, chargement et animation du modèle. Le chargeur Map10 générique est écarté comme preuve de cette fonctionnalité. |
| 301 autres entités, 1 204 fiches | L’association au chargeur générique est conservée dans l’historique mais écartée des consommateurs effectifs : ce lien ne démontre pas leur admission. Cela ne prouve pas une absence globale d’implémentation. |

Au total : 1 208 associations qualifiées hors portée, douze fiches reliées à des chemins partiels précis, deux nouveaux points de code enregistrés et 34 liens ajoutés, dont sept sur la fiche SYS. Les références natives, leurs inconnues et les preuves précédentes sont conservées. Les 1 217 fiches concernées, SYS inclus, sont publiées dans les deux bases du plan.

Le JSON monde contient 27 définitions. `world::enable_map10` ajoute aussi `annietibbers` à l’exécution. Le constat antérieur d’absence du nom littéral `AnnieTibbers` dans le JSON reste conservé avec cette correction de portée : il ne prouve pas l’absence de Tibbers dans le jeu local.

## Sources effectivement vérifiées

Les identités de 305 sources natives citées par ces fiches ont été vérifiées par taille et SHA-256. Ce lot ne décode pas à nouveau leurs champs binaires et ne rejoue pas les anciens contrôles de manifestes. Leurs appartenances à la référence fournie restent celles des preuves antérieures.

Les fonctions et leurs appels ont été relus dans les fichiers actuels de F:/OpenLeague : world.rs, annie_r.rs, lib.rs, interactions.rs, trundle_e.rs, animation.rs, main.rs, map_relic_world.rs et trundle_e_visual.rs. Les sources enregistrées des consommateurs spécialisés ont été comparées aux fichiers actuels et à leurs ancres.

Les trois GLB existent et leurs en-têtes, longueurs et métadonnées JSON sont cohérents. Tibbers contient sept animations dont les noms correspondent au catalogue monde et les indices de rôles sont valides. La relique contient le clip `OdinHealthRelic_Idle` à l’indice utilisé par le code ; le pilier contient `IceBlock_Idle1` à l’indice utilisé. Ce contrôle n’est ni un rendu GPU, ni une comparaison visuelle des textures, ni une validation de lecture des animations.

## Vérifications réellement exécutées

- Préparation sans mutation du plan, puis publication et audit indépendant.
- 1 217 sélecteurs nominaux et 1 218 refus de couples tâche/sélecteur incorrects.
- Quatre refus du qualificateur : identité absente, correspondance statique exacte, alias de casse, ensemble dynamique non qualifié.
- Comparaison des 42 214 textes de traçabilité : 1 216 changés et 40 998 identiques.
- Six refus du résolveur/validateur publics pour des preuves de portée invalides.
- 1 217 fiches, instructions et textes copiables vérifiés via les lecteurs réels dans chaque base ; les 1 216 sorties UNIT sont comparées à leurs consommateurs attendus.
- Intégrité SQLite correcte ; 42 606 états/notes et 23 entrées d’historique exactement conservés dans chaque base. Les 41 389 autres lignes de catalogue restent identiques.
- 40 997 autres exigences actives inchangées, anciens enregistrements de sources et consommateurs préservés, registre des inconnues inchangé en octets.

Une première comparaison a échoué car le vérificateur dédoublonnait la liste historique de SYS. Le vérificateur a été corrigé pour conserver intégralement cette liste. La première préparation non publiée est archivée dans `revision466_preparation_attempt1`; la nouvelle préparation et la comparaison ont réussi avant publication. Aucun doublon historique n’a été supprimé.

Le graphe compte 98 603 sources, 2 414 consommateurs, 25 321 inconnues ouvertes et 5 517 résolues. Aucune inconnue n’est résolue par ce lot. Aucun statut, aucune case ni aucun critère d’acceptation ne sont modifiés. Aucun code de production du jeu n’est modifié. Aucune compilation Rust, exécution du jeu ou du client AIR, ni rendu GPU n’est réalisé pour ce lot. Les lecteurs Python du plan sont exécutés par les contrôles décrits ci-dessus.

## Livrables

- `docs/reference_unit_consumer_scope/unit-scope-v466.json` : associations, identités, chemins actuels, métadonnées des modèles, prérequis et limites.
- `docs/fidelity_unit_consumer_scope_v466.json` : publication et contrôles des bases.
- `docs/fidelity_sources_4_20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/completion_tasks_2026-10-20.json` : liens intégrés.
- `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3` : fiches et instructions actualisées.
- `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md` et `docs/ai/HANDOFF.md` : reprise actualisée avec sauvegarde des versions précédentes.
- `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision466/` : préparation, comparaison, audit, sauvegardes et inventaire de la suite.

## Manques et limites

Pour les 301 autres entités, un consommateur précis reste à identifier et qualifier au-delà du lien générique écarté. Pour les trois entités mieux reliées, la fidélité des paramètres, des comportements, des textures, des animations, des effets et de la session reste à démontrer selon leurs critères. Les champs reconstruits et limites déjà documentés restent applicables. Les contrôles de ce lot ne valident pas leur gameplay.

Les prérequis D01/D12 sont recensés, sans déclarer leurs phases terminées. Les lacunes historiques de Battle Training restent locales et ouvertes. Les assets présents, les règles côté serveur inconnues et la disponibilité historique d’un mode sont des questions distinctes.

Parmi les associations au chargeur Map10, huit sont désormais qualifiées comme chemins partiels de Tibbers/relique. Il reste 532 associations à examiner : SYS 1, WORLD 333, STRUCTURE 108, CAMP 63 et MODE 27. Cet inventaire n’est pas le compte de tout le travail restant sur le jeu.

Suite : relier les exigences WORLD aux fonctions qui exécutent réellement leur comportement, en commençant par la protection et la destruction des Nexus, puis les structures et camps. La présence d’une définition JSON ne suffit pas à valider un comportement. SYS-01.2-02 et le Goal restent ouverts.
