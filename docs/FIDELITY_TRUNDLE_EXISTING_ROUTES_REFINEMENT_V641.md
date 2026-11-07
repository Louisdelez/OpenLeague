# SYS-01.2-02 — Trundle : acquis et inconnues précisés, V641

Date UTC : 2026-10-26T21:46:26.098916+00:00. Référence : PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement non établis ; catalogue 4.20.1 distinct.

V641 Trundle : les chemins partiels V533/V534/V535 et leurs preuves sont conservés. Trois liens explicites au texte natif de King's Tribute sont ajoutés ; trois questions obsolètes sont précisées sans fermeture, avec historique. Le texte lie le soin à @f2@% de la vie maximale de l'ennemi mort ; le producteur natif de f2 reste inconnu. La table locale 2/3/4/5/6 % et le rayon local1000 ne sont pas qualifiés ici comme valeurs natives. Neuf tests Trundle hérités de V534 parmi37 tests : identités et1158 entrées revérifiées, aucun test de jeu relancé. La branche statique d'expiration ou suppression du propriétaire de Tibbers met sa vie à zéro sans appel au récepteur Trundle dans ce bloc ; cette branche n'a pas été exécutée. Aucun nouveau consommateur, aucun changement de gameplay ou d'acceptation.

## Résultat intégré

Les fiches CH-Trundle-PASSIF-SOURCE, CH-Trundle-PASSIF-SIMULATION-CONTRAT et CH-Trundle-PASSIF-SIMULATION conservent tous leurs consommateurs. La fiche SYS-01.2-02 reçoit ce résultat. Trois liaisons vers le fichier natif de textes complètent les liens déjà présents ; deux sources de preuve sont ajoutées. Aucun nouveau consommateur ni aucune question fermée.

Les trois anciennes questions disaient encore que le chemin courant devait être qualifié. V533/V534/V535 l'avaient déjà décrit partiellement. Les anciennes formulations et conditions sont conservées dans question_history, avec date et source ; les propriétaires, identités, aspects, statuts et préfixes de recherche restent identiques. Toutes les autres questions restent strictement identiques.

## Sources et constat natif

Les cinq fichiers ont été relus et leur identité comparée au registre et au manifeste RADS sélectionné.

| Ressource | Octets | SHA-256 |
|---|---:|---|
| Trundle.inibin | 1919 | dc97ef621b8ac4c584fc0c612891ce739b30b5826e14090473ca3686be14f217 |
| CharScriptTrundle.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| TrundleDiseaseOverseer.inibin | 54 | bb6648e5738d8a50e44d1350c02a65ba3533f3e4230560b08791dec9e5f240fc |
| TrundleDiseaseOverseer.luaobj | 382 | e8292d2dc04dd678bc2d61d659e83021324c3c797b2f28621ee9fcdd46f03327 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Les trois clés exactes game_buff_tooltip_TrundleDiseaseOverseer, game_character_passiveDescription_Trundle et game_character_passiveName_Trundle sont relevées avec leur ligne dans OBSERVATIONS.json. Le texte du buff donne @f2@% de la vie maximale de l'ennemi mort à proximité. Cela ne fournit pas le producteur de f2. L'alias INIBIN est TrundleDiseaseOverseer. Le petit INIBIN de buff ne fournit que DynamicTooltip. CharScriptTrundle.luaobj a une initialisation racine vide ; les deux Lua inspectés ont zéro fonction enfant. Les métadonnées de persistance et non-dissipation ne constituent pas le code original du serveur.

## Consommateurs existants conservés

| Fichier et ligne | Rôle enregistré |
|---|---|
| crates/core/src/lib.rs:149 | data_loader |
| tools/project-plan/reference_inibin.py:46 | passive_source_actual_raw_INIBIN_file_reader |
| tools/project-plan/reference_inibin.py:12 | passive_source_actual_raw_INIBIN_decoder |
| tools/project-plan/reference_inibin.py:8 | passive_source_actual_declared_field_hash_helper |
| tools/project-plan/lua51_reference.py:86 | passive_source_actual_serialized_Lua_data_reader |
| tools/project-plan/lua51_reference.py:54 | passive_source_actual_bounded_literal_metadata_reader |
| crates/core/src/trundle_passive.rs:11 | passive_source_current_Trundle_community_level_table |
| crates/core/src/trundle_passive.rs:27 | passive_source_current_Trundle_partial_death_receiver |
| crates/core/src/damage.rs:135 | current_trundle_partial_passive_branch_call_crates_core_src_damage_rs_135 |
| crates/core/src/world.rs:401 | current_trundle_partial_passive_branch_call_crates_core_src_world_rs_401 |
| crates/core/src/lib.rs:598 | partial_passive_simulation_parent_core_command |
| crates/core/src/lib.rs:685 | partial_passive_simulation_parent_core_tick |
| crates/core/src/lib.rs:622 | partial_passive_simulation_parent_target_cast |
| crates/core/src/lib.rs:623 | partial_passive_simulation_parent_point_cast |
| crates/server/src/main.rs:167 | partial_passive_simulation_parent_server_command |
| crates/server/src/main.rs:206 | partial_passive_simulation_parent_server_tick |
| crates/core/src/lib.rs:710 | partial_passive_simulation_parent_trundle_world_step |

Le récepteur local travaille après une transition de vie positive vers zéro par dégâts, avec filtrage des victimes et bénéficiaires et appel au soin commun. Le rayon local est1000 ; la table locale est2/3/4/5/6 % selon les niveaux. La provenance communautaire déjà documentée reste distincte de la référence native non résolue. Les appels damage/world, commande et tick étaient déjà liés : aucune association équivalente n'est créée.

La lecture statique du bloc d'expiration ou disparition du propriétaire dans advance_pet_orders (annie_r.rs) montre une mise à zéro de la vie suivie de nettoyage et continue, sans appel à apply_damage ou au récepteur Trundle dans ce bloc. Ce constat porte sur le bloc inspecté ; il ne démontre ni son exécution ni la règle historique attendue pour une expiration de familier.

## Inconnues toujours ouvertes

### CH-Trundle-PASSIF-SOURCE

Identifiant conservé : `OLU-22bb1b10-f4b6-528b-8819-db6202193ee8`. Statut : ouvert.

Les sources client et le chemin local partiel de King's Tribute sont déjà reliés par V533/V534/V535. Restent à qualifier le producteur natif de f2 et sa table exacte, les catégories de victimes et les règles historiques de proximité, de cycle de vie et de présentation ; la table locale 2/3/4/5/6 % demeure communautaire.

Condition : Établir la formule native f2 avec source 4.20 datée, arbitrer les variantes communautaires sans les promouvoir en règle native et qualifier les exceptions encore ouvertes. Conserver les liens et tests locaux déjà acquis ainsi que l’absence de corps serveur original récupéré.

### CH-Trundle-PASSIF-SIMULATION-CONTRAT

Identifiant conservé : `OLU-f7704088-2964-56e6-b3cb-3906982487d3`. Statut : ouvert.

Les cinq branches locales de Trundle et les deux appels de mort par dégâts sont décrits et liés en V534. Restent à qualifier leur équivalence native, l’ordre historique des soins et récompenses/XP, les expirations ou suppressions hors dégâts, illusions et distinctions no-render, et les branches non couvertes par les tests hérités.

Condition : Confronter chaque règle locale restante aux sources natives ou à un contrat explicitement reconstruit ; distinguer dégâts mortels, expiration de familier et suppression du propriétaire. Garder la table communautaire et les neuf tests de politique Trundle V534 dans leur portée, sans prétendre à une instrumentation exhaustive.

### CH-Trundle-PASSIF-SIMULATION

Identifiant conservé : `OLU-8fd2539d-244b-5ca5-b567-43ed8d8a3e0a`. Statut : ouvert.

Le récepteur local de Trundle et ses chemins damage/world/commande/tick sont déjà reliés en V535 ; neuf tests Trundle de V534 sont conservés. L’exécution ordinaire complète client/serveur et les cas hors morts par dégâts restent non qualifiés. La branche statique d’expiration ou disparition du propriétaire de Tibbers met sa vie à zéro sans appeler ici le récepteur Trundle ; ce constat n’est pas une exécution de cette branche.

Condition : Qualifier les parcours et interactions encore hors preuve, notamment expiration/suppression des familiers, correspondance aux règles natives et partie ordinaire client/serveur ; vérifier succès/refus/limites avec un binaire identifié. Ne pas refaire les associations V534/V535 équivalentes ni confondre tests de fixtures, lecture statique et acceptation du jeu.

## Vérifications fraîches et preuves héritées

L'inspection V641 a réellement relu les cinq ressources natives, les17 identités et ancres de consommateurs, les preuves V533/V534/V535 et les1158 entrées du test V534. Son reçu est F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision641_Trundle_inspection/OBSERVATIONS.json. Les1175 identités épinglées dans ce reçu sont contrôlées à nouveau par la livraison.

La preuve de test héritée est F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision534_passive_runtime\EXECUTION.json. Elle rapporte37 tests réussis, dont9 Trundle, zéro échec et zéro ignoré ; ces tests de fixtures n'ont PAS été réexécutés en V641. Binaire hérité : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision534_passive_runtime\cargo-target\debug\deps\openleague_core-21eb81eb13817108.exe ; 787789824 octets ; SHA-256 8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97. Commande héritée : cargo test --locked --offline -p openleague-core --lib passive --message-format=json -- --nocapture. Le journal et le dep-info hérités ont également été vérifiés par identité.

Le contrôle nominal vérifie le graphe, les identités de tâches, la préservation des objets et l'accès via Store.task/copy_text/summary, les dépendances et rt.resolve. Le copier-coller complet expose les questions précisées et limites dans les quatre fiches. Les42215 résumés courts de traçabilité restent identiques : ils ne contiennent pas le texte intégral des questions et ne présentent que les trois premiers groupes natifs. Cette stabilité ne signifie pas que le copier-coller complet est inchangé.

54 mutations invalides sont refusées par la garde V641 : promotion en réussite, suppression de preuve native ou dépendance, historique ou préfixe de recherche perdu, propriétaire changé, fermeture injustifiée, condition inventée et anciens tests présentés comme relancés. Quatre graphes invalides sont refusés par le véritable rt.validate. La garde d'historique est spécifique à cette livraison ; le lecteur générique ne vérifie pas question_history.

| Étape réellement exécutée | Code retour | SHA-256 du journal |
|---|---:|---|
| prepare | 0 | 511a7bec6efe7f5e14e4b1b6ef01f5a4bd2f37587bac865105977ca54d9145ca |
| check | 0 | ed9153414847158e965328e302847e4fec54af7f146376ac9efbfe2e3b2ef0e1 |
| publish | 0 | e755951d328ff6541ea6daaae129f1d1f419eab578981142331074b504c360e7 |
| audit | 0 | aed47aa3ca9277f7ffbfc626105b5942ecd7ba566a78a8cb76a93d107ca31ef3 |

Après publication, les deux bases conservent42603 autres lignes,42607 états manuels et23 historiques ; les quatre lignes ciblées sont relues par le véritable consommateur et la synchronisation est idempotente. Le contrôle global indépendant confirme5023 ancres et identités courantes sans divergence, pour99239 sources enregistrées. Il ne rehash pas toutes les sources historiques et ne mesure pas l'achèvement du jeu.

## Fichiers et limites de livraison

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json et docs/fidelity_unknowns_4_20.json ; les deux bases du plan (projet et application installée). Nouveaux reçus : docs/reference_requirement_trace_sources/trundle-existing-routes-refinement-v641.json et docs/fidelity_trundle_existing_routes_refinement_v641.json. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Sauvegardes et scripts privés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision641_Trundle.

Les identités de tâches et la hiérarchie restent identiques octet par octet. Aucun fichier de gameplay ou asset changé ; aucun nouveau test de jeu, rendu, audio, serveur historique ou réseau exécuté. Aucune acceptation utilisateur ajoutée et aucune case cochée. La formule native, les expirations, illusions, ordre historique et scénarios ordinaires restent à qualifier. La publication vérifiée n'est pas présentée comme globalement atomique.

## Suite

Continuer SYS-01.2-02 depuis revision642_trace_review/REVIEW.json. V641 Trundle : trois questions précisées avec historique et trois liens de textes natifs ajoutés ;17 consommateurs et V533/V534/V535 conservés. Aucune formule native ou expiration qualifiée, aucune exécution de jeu nouvelle. Reprendre la préparation Twitch dans revision642_Twitch_preflight/PREFLIGHT.json :68 chemins natifs candidats,5 scripts communautaires,texte natif six secondes/six cumuls ;E communautaire utilise trois cumuls malgré son commentaire six. Préparation seulement :identités non encore comparées au registre et aucune exécution du jeu. Inspecter ensuite les fiches passives Twitch et leurs consommateurs réels, en vérifiant d’abord les acquis existants ; Tryndamere dispose déjà de V537, ne pas dupliquer ses associations. Sources originales, communauté et moteur actuel doivent rester distincts. Goal actif.
