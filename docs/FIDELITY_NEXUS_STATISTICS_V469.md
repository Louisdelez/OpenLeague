# SYS-01.2-02 — Sources et statistiques des deux Nexus, V469

Les fiches WORLD-ChaosNexus-SOURCE et WORLD-OrderNexus-SOURCE disposent désormais d’une qualification actualisée de leurs 25 champs chacune. Les 31 ancres de consommateurs existantes ont été relues et leurs fichiers comparés aux identités enregistrées. La portée reste la correspondance entre ressources et code courant ; aucune partie ni fidélité complète des statistiques n’est acceptée.

## Résultats et écarts

| Sujet | Source et observation actuelle | Limite / travail restant |
|---|---|---|
| Identité | Data/UnitTags contient Structure et Structure_Nexus dans les deux INIBIN natifs | Le tag ne définit pas toutes les règles serveur |
| PV | Le JSON courant contient 5500 ; spawn_unit affecte health et max_health après la formule d’amélioration. Nexus n’est pas un sbire de lane, son nombre d’améliorations vaut 0 | Le code communautaire Map10 écrit également 5500 ; ni cette concordance ni l’absence de Data/BaseHP dans le fichier personnage ne prouvent l’autorité du serveur original |
| Rayon de cible | target_info lit directement definition.radius, actuellement 0. Les comparaisons de distance consomment Target.radius | Le code communautaire Map10 transmet 353 à CreateNexus ; le paramètre traverse l’API vers collisionRadius du constructeur Nexus. C’est une divergence à qualifier, pas une preuve que le bon correctif est 353 |
| Échelle visuelle | MeshSkin/SkinScale du fichier natif Skins/Base/Base.inibin vaut 1.0 et correspond au catalogue fusionné qualifié en V468 | L’absence de ce champ dans le fichier personnage principal ne signifie pas qu’il manque partout. Le provider natif effectif et les poses restent séparés |
| Acquisition | Le champ local vaut 475 ; la recherche de candidats correspondante est gardée par lane ou Turret/Fountain, garde que Nexus ne satisfait pas | La simple présence du lecteur générique ne prouve pas que ce champ pilote le Nexus. Aucune conclusion globale de code mort |
| Timers d’attaque | 48 et 15 ticks sont stockés ; la construction d’une attaque exige une cible assignée | Aucun timer natif ni attaque effective du Nexus validé par ces seuls nombres |
| Améliorations | Les coefficients sont stockés et figurent dans des formules ; le multiplicateur des Nexus est nul dans spawn_unit | Cela ne qualifie pas les valeurs/défauts natifs ou leurs overrides |
| Niveau | spawn_unit calcule une moyenne des niveaux joueurs puis la conserve dans _spawn_level sans l’appliquer à cette construction | L’autorité historique et une éventuelle règle de niveau Nexus restent à qualifier |
| Défenses et récompenses | Valeurs locales et points de consommation conservés dans la table détaillée | Les absences bornées aux INIBIN inspectés ne prouvent pas des défauts natifs nuls |

Les anciennes comparaisons V243/V250 sont conservées, y compris leurs classifications héritées. Le reçu V469 fournit des qualifications distinctes et actuelles. Les questions de PV des inhibiteurs restent des questions d’inhibiteurs ; elles ne sont pas attribuées aux Nexus.

## Vérifications réellement exécutées

- Identités SHA-256 des sources et copies de code inspectées ; parseur INIBIN exécuté sur les fichiers personnage et Base des deux Nexus.
- Les observations présence/absence/valeur de 16 champs par personnage sont confrontées à V243. Les deux tables de 25 champs sont comparées au JSON actuel.
- Cinq refus du collecteur : autre identité, mauvaise catégorie, booléen présenté comme nombre, BaseHP natif artificiellement ajouté et tag modifié.
- Trois couples tâche/sélecteur nominaux et quatre couples invalides refusés.
- Lecteur public du plan : 42 214 textes comparés, deux modifiés et 42 212 identiques. Les résultats des autres tâches hors SYS restent identiques.
- Trois refus du validateur public : question affectée à la mauvaise exigence, fausse résolution et condition de résolution absente.
- Programme de publication vérifié avant écriture : quatre registres associés à quatre empreintes de référence.
- Publication puis audit indépendant des registres et des deux bases réelles : trois fiches actualisées par base, SYS inclus ; 42 606 états/notes et 23 lignes d’historique inchangés ; 42 603 autres lignes de catalogue conservées ; intégrité SQLite correcte.

Les scripts exécutés sont revision469_delivery.py prepare/publish/audit, revision469_check.py et revision469_finish.py, avec le Python local identifié dans EXECUTION_ENVIRONMENT.json. Aucun jeu, build Rust, client AIR, runtime C# ou rendu GPU n’est exécuté. Les tests historiques et l’appartenance aux manifestes restent des preuves héritées, non rejouées dans ce lot. Le contrôle d’identité courant ne remplace pas leur portée d’origine.

## Intégration et limites restantes

Quatre liens natifs sont ajoutés aux fiches SOURCE. Deux sources documentaires supplémentaires sont enregistrées : le reçu V469 et le code communautaire Nexus jusque-là non enregistré. L’API de création était déjà enregistrée ; elle est réutilisée. Aucun point de consommation historique n’est supprimé ou transformé en une nouvelle implémentation. Deux questions propres aux fiches SOURCE sont ajoutées et laissées ouvertes. Aucune inconnue n’est résolue, aucun statut ni critère ni case n’est changé.

Le graphe compte maintenant 98 607 sources, 2 417 consommateurs, 25 341 inconnues ouvertes et 5 517 résolues. Ces comptes décrivent le registre, pas un pourcentage de jeu terminé.

Le livrable est intégré dans les quatre registres, les textes copiables des bases existantes et les documents de couverture/reprise. Reçu : docs/reference_nexus_sources/nexus-statistics-v469.json. Preuve : docs/fidelity_nexus_statistics_v469.json. Preuves et sauvegardes détaillées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision469/.

Les valeurs locales ne sont pas modifiées sur la seule foi du code communautaire. Retrouver l’autorité native effective des PV, rayons, défenses, récompenses, niveaux, timers et éventuels overrides reste nécessaire pour qualifier la fidélité. Les limites visuelles/audio V468 restent également ouvertes. SYS-01.2-02 et le Goal restent actifs.

## Table actuelle : ChaosNexus

| Champ | Valeur actuelle | Classification V243 conservée |
|---|---|---|
| id | ChaosNexus | local_identity_metadata_equal |
| kind | Nexus | local_enum_with_native_UnitTags_context |
| asset | structures/chaos_nexus.glb | local_asset_reference_model_not_qualified |
| scale | 1.0 | local_fallback_absent_native_character_field |
| health | 5500 | community_context_equal_lineage_unknown |
| damage | 0.0 | local_fallback_absent_native_character_field |
| armor | 0.0 | local_fallback_absent_native_character_field |
| magic_resist | 0.0 | local_fallback_absent_native_character_field |
| move_speed | 0.0 | local_fallback_absent_native_character_field |
| attack_range | 0.0 | local_fallback_absent_native_character_field |
| attack_cooldown | 48 | local_tick_defaults_compatible |
| attack_windup | 15 | local_tick_defaults_compatible |
| acquisition | 475.0 | local_fallback_absent_native_character_field |
| radius | 0.0 | local_fallback_absent_native_character_field |
| experience | 0.0 | local_fallback_absent_native_character_field |
| gold | 0.0 | local_fallback_absent_native_character_field |
| global_experience | 0.0 | local_fallback_absent_native_character_field |
| global_gold | 0.0 | local_fallback_absent_native_character_field |
| hp_upgrade | 0.0 | local_nonlane_upgrade_zero |
| damage_upgrade | 0.0 | local_nonlane_upgrade_zero |
| armor_upgrade | 0.0 | local_nonlane_upgrade_zero |
| mr_upgrade | 0.0 | local_nonlane_upgrade_zero |
| gold_upgrade | 0.0 | local_nonlane_upgrade_zero |
| gold_max_bonus | 0.0 | local_nonlane_upgrade_zero |
| projectile_speed | 0.0 | local_zero_projectile_default |

Les compléments V469 (échelle, PV, rayon, acquisition et timers) précisent la portée de ces classifications historiques ; voir le tableau de résultats et le reçu détaillé.

## Table actuelle : OrderNexus

| Champ | Valeur actuelle | Classification V243 conservée |
|---|---|---|
| id | OrderNexus | local_identity_metadata_equal |
| kind | Nexus | local_enum_with_native_UnitTags_context |
| asset | structures/order_nexus.glb | local_asset_reference_model_not_qualified |
| scale | 1.0 | local_fallback_absent_native_character_field |
| health | 5500 | community_context_equal_lineage_unknown |
| damage | 0.0 | local_fallback_absent_native_character_field |
| armor | 0.0 | local_fallback_absent_native_character_field |
| magic_resist | 0.0 | local_fallback_absent_native_character_field |
| move_speed | 0.0 | local_fallback_absent_native_character_field |
| attack_range | 0.0 | local_fallback_absent_native_character_field |
| attack_cooldown | 48 | local_tick_defaults_compatible |
| attack_windup | 15 | local_tick_defaults_compatible |
| acquisition | 475.0 | local_fallback_absent_native_character_field |
| radius | 0.0 | local_fallback_absent_native_character_field |
| experience | 0.0 | local_fallback_absent_native_character_field |
| gold | 0.0 | local_fallback_absent_native_character_field |
| global_experience | 0.0 | local_fallback_absent_native_character_field |
| global_gold | 0.0 | local_fallback_absent_native_character_field |
| hp_upgrade | 0.0 | local_nonlane_upgrade_zero |
| damage_upgrade | 0.0 | local_nonlane_upgrade_zero |
| armor_upgrade | 0.0 | local_nonlane_upgrade_zero |
| mr_upgrade | 0.0 | local_nonlane_upgrade_zero |
| gold_upgrade | 0.0 | local_nonlane_upgrade_zero |
| gold_max_bonus | 0.0 | local_nonlane_upgrade_zero |
| projectile_speed | 0.0 | local_zero_projectile_default |

Les compléments V469 (échelle, PV, rayon, acquisition et timers) précisent la portée de ces classifications historiques ; voir le tableau de résultats et le reçu détaillé.
