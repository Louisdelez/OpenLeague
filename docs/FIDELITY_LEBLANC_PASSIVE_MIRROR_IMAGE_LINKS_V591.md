# LeBlanc — sources et consommateurs de Mirror Image, V591

Date UTC : 2026-10-26T05:59:37.274447+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, liaison des exigences aux sources natives et aux consommateurs actuels.

## Résultat

Trois fiches du passif enrichies : **14 sources natives, 42 associations, 24 points de code et 48 liens de consommateurs**. Quatre sources de preuves ajoutées. Statuts, critères, trois questions propres, quatre dépendances et propriétaires conservés.

Les quatre passages sous 40 % exécutés ne produisent **aucun clone ni invisibilité** : le personnage original reste visible et présent dans la projection adverse. La minute d’attente ne qualifie pas une recharge passive, puisqu’aucun déclenchement n’a lieu. Aucun gameplay ou asset modifié par ce lot de traçabilité.

## Sources natives

PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiés ; priorité de montage historique non déduite de cette appartenance.

| Fichier | Identité source |
|---|---|
| Leblanc.inibin | OLS-0b95b5d0-cc5a-583f-b777-2d8d6623c88c |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptLeblanc.luaobj | OLS-538b7cf0-97f8-56fd-922c-a2d7faa65762 |
| CharScriptLeblanc.preload | OLS-7f99adf8-41a5-5593-aaa8-5ab7fbc6dcc2 |
| LeblancPassive.inibin | OLS-966a1a3e-ccce-57e3-a9a0-ea053ee4d25e |
| LeblancPassive.luaobj | OLS-a1804632-3db8-5f6d-9ea8-0bc2dbb1dc0b |
| LeblancPassive.preload | OLS-0634eb52-0c8a-5bb0-af6c-dc8f63becf30 |
| LeblancPassiveCooldown.inibin | OLS-d2af2d94-1e74-5cc6-b8c0-a193cce773dd |
| LeblancPassiveCooldown.luaobj | OLS-e941bbe3-30dc-515f-8409-784a6b789f7b |
| LeblancMIApplicator.luaobj | OLS-b89fe27e-d146-5c18-b1e4-bb6b0b572128 |
| LeblancMIApplicator.preload | OLS-a5a96fa8-6fda-51ef-8938-b95592921ab8 |
| LeblancMIFull.luaobj | OLS-82ec6831-de16-58cc-8640-61f083072a0f |
| LeblancMIFull.preload | OLS-9ee414a3-e2f6-57bc-a0fa-54309dd8ec11 |
| LeblancMIStealth.luaobj | OLS-1bc795ac-fd60-5a76-a521-afe2db86e6ac |

- `Leblanc.inibin` lie `Passive1LuaName=LeblancPassive`, `LeblancMirrorImage.dds` et la description en_GB ligne **4218**. Six champs de niveau passif absents, sans défaut inventé.
- Description du personnage et buff passif ligne **2198** concordent : **sous 40 % de santé**, **invisible une seconde**, **clone sans dégâts durant au plus huit secondes**, **recharge d’une minute**, contrôle **Alt + clic droit**. Ces textes sont liés à leurs consommateurs natifs déclarés ; ils ne révèlent pas tous les détails de la politique serveur.
- Le buff de recharge ligne **2199** s’intitule **Schism**. Son nom de ressource reste `LeblancPassiveCooldown`. Le texte NightmareBot trouvé dans le même catalogue reste du contexte, sans adoption comme passif ordinaire.
- `LeblancPassive.luaobj` conserve **BuffName=LeblancNoxianCruelty**, persistance après mort et **Nondispellable**. Le cooldown utilise **NonDispellable**, avec une capitale différente, et l’icône `LeblancMirrorImage_Charging.dds`. Aucun renommage ni normalisation silencieuse ; la conséquence éventuelle de cette casse reste à qualifier sur le consommateur historique.
- **Six Lua** entièrement lus, zéro prototype enfant, six initialisations littérales qualifiées. CharScript, MIFull et MIStealth ont des initialisations vides ; MIApplicator déclare la persistance. Cela ne constitue pas des callbacks serveur de création, de furtivité ou de contrôle du clone.
- **Quatre preloads** : chaîne Passive → MIApplicator/cooldown ; Applicator → teinte de furtivité/MIStealth/MIFull/cooldown ; MIFull → particules image/mort et root. Les effets et dépendances déclarés ne prouvent pas leur exécution.
- **Deux liaisons de buffs résolues**, huit références communautaires distinctes. CharScript communautaire vide. QWER, statistiques et JSON communautaires restent des références, sans autorité implicite du serveur Riot.
- **Six chemins candidats absents** : DDF du personnage, CharScript sous `Scripts`, Passive INIBIN global, et INIBIN de MIApplicator/MIFull/MIStealth dans les sorts du personnage. Les Lua et preloads réels sont présents ; cette recherche ne prouve pas une absence universelle d’assets.

## Essais exécutés et échecs conservés

Compilation privée `cargo build --locked --offline` contre le vrai core non-test ; dépendances/checksums alignés au lock racine. **1 158 entrées de code/ressources** et la chaîne antérieure conservées. Binaire qualifié : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-leblanc-passive-mirror-image-qualified.exe`, 6124544 octets, SHA-256 `560aa21ef402b3388f3b6f015e94b0f23099402b0be9556cf15c958cd271a401`.

Deux premières exécutions ont terminé en échec de garde, avec BUILD 0 et RUN non nul. L’hypothèse « santé uniquement régénérée pendant l’attente » échoue dans le cas de base, phase 0, **offset 1778**, au tick **3775**. Le diagnostic conserve les snapshots : trois `Red_Minion_Wizard` ciblent LeBlanc. Le snapshot ne révèle pas lequel des impacts NPC en attente se résout exactement à cet instant ; aucune attribution précise inventée. La zone d’essai était sur la voie basse, traversée par les vagues.

La reprise qualifiée conserve **toutes les durées, quatre franchissements et contrôles**, et déplace les participants par commandes publiques vers la zone centrale, avec `z=7000` demandé et les positions réellement atteintes enregistrées. Elle refuse en plus toute cible NPC visant l’un des participants. Les deux binaires et journaux échoués sont gardés et hachés ; ils ne sont ni écrasés ni comptés comme réussis.

Une erreur de parenthèse dans le générateur local d’inspection a également été corrigée avant création de l’inspection exécutable. La tentative de copie qui suivait n’a trouvé aucun script ; aucune donnée projet n’avait été modifiée par cette tentative. L’inspection ensuite générée et exécutée retourne 0.

Deux parties Map10 neuves : LeBlanc, Annie adverse. Rubis 1028 acheté publiquement dans le second cas, +150 HP. Pas d’injection de santé, position, temps, niveau ou état passif. Attaques normales d’Annie jusqu’à franchissement sous 40 %, puis Stop. Attente **1 810 ticks** avec régénération naturelle au-dessus du seuil, deuxième séquence d’attaques et attente **241 ticks**.

| Cas | Santé max | Impacts témoins | Passages sous 40 % | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|
| base | 516.00 | 11 | 2 | 27 | 2051 |
| ruby | 666.00 | 13 | 2 | 27 | 2051 |

Chaque baisse de santé imputée à Annie possède un projectile Annie→LeBlanc témoin. Les **24 impacts** produisent **quatre franchissements**, avec santé avant ≥40 % et après <40 %. Le cas d’égalité exacte à 40 % n’est pas exercé.

Les **4 102 ticks d’attente** vérifient à chaque tick : santé conforme à la régénération ordinaire, deux joueurs vivants niveau 1, aucune mort/fin de partie, aucun NPC ciblant les participants, aucune unité de définition LeBlanc ni familier possédé par elle, personnage original visible et présent dans la projection adverse. Les contrôles couvrent les offsets **29/30/31**, **239/240/241** et, dans la première attente, **1799/1800/1801/1810**. Ces repères locaux encadrent 1, 8 et 60 secondes à 30 ticks/s ; ils ne qualifient pas l’horloge historique.

**54 refus sans mutation** : joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt QWER avant et après les séquences. La recherche de familiers et d’entités couvre les représentations exposées actuellement ; elle ne prouve pas toutes les représentations possibles d’un clone historique.

Attendu selon les textes liés : invisibilité et clone au franchissement admissible. Observé : aucune invisibilité ni entité correspondante dans ces scénarios ; QWER non pris en charge. Recharge passive non armée, durée/contrôle/dégâts nuls du clone non exerçables. Snapshots locaux uniquement, sans transport réseau, UI ou audio qualifiés.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | ordinary_public_actions |
| crates/core/src/progression.rs:68 | health_caps |
| crates/core/src/progression.rs:150 | unsupported_Leblanc_learning |
| crates/core/src/progression.rs:159 | unsupported_Leblanc_ranks |
| crates/core/src/spells.rs:101 | unsupported_Leblanc_cast |
| crates/core/src/annie_w.rs:29 | unsupported_Leblanc_ground_cast |
| crates/core/src/lib.rs:685 | ordinary_tick_order |
| crates/core/src/lib.rs:744 | observed_players_and_units_not_network_acceptance |
| crates/core/src/damage.rs:53 | nonlethal_health_threshold_boundary |
| crates/core/src/attacks.rs:157 | witnessed_Annie_projectiles |
| crates/core/src/lifesteal.rs:4 | ordinary_attack_damage |
| crates/core/src/regeneration.rs:32 | natural_health_return_above_threshold |
| crates/core/src/shop.rs:261 | Ruby_public_control |
| crates/core/src/shop.rs:215 | Ruby150health_control |
| crates/core/src/vision.rs:79 | current_original_visibility_no_passive_stealth_observed |
| crates/core/src/vision.rs:137 | original_remains_in_enemy_projection |
| crates/core/src/vision.rs:30 | current_vision_radius_context |
| crates/core/src/vision.rs:48 | clear_stationary_visibility_control |
| crates/core/src/annie_r.rs:23 | existing_pet_owner_lookup_not_MirrorImage |
| crates/core/src/annie_r.rs:62 | Tibbers_only_static_context_not_clone_implementation |
| crates/core/src/annie_r.rs:82 | existing_pet_control_lifetime_static_context |
| crates/core/src/movement.rs:53 | ordinary_public_movement |
| crates/core/src/attacks.rs:103 | static_departure_context_not_clone_cleanup |

Le traitement des dégâts et la régénération expliquent les passages de seuil. Les fonctions de vision et de projection expliquent la visibilité observée. Les fonctions de lancement et apprentissage expliquent les refus. Les fonctions **Tibbers** de création, recherche par propriétaire et contrôle de familier sont du **contexte statique existant**, pas une implémentation de Mirror Image ni des appels exécutés du clone. Déconnexion et durée de familier restent non exercées dans ce scénario.

Douze ressources locales de profils/règles sont reliées séparément, notamment vision, monde Map10, Rubis et règles/définition de Tibbers. Elles ne remplacent pas les sources serveur natives.

## Travail restant

1. Préciser l’égalité au seuil, les dégâts létaux, le moment de l’évaluation après mitigation/boucliers et les changements de santé maximale.
2. Qualifier la disponibilité initiale, les coups simultanés, le déclenchement unique et les règles de réarmement/recharge, puis les implémenter.
3. Implémenter la furtivité sur contrat vérifié : durée, interruptions, révélations, ciblage et projection par équipe.
4. Définir et implémenter le clone : identité, propriétaire, position, santé/statistiques, apparence, collision et vision.
5. Définir le contrôle Alt + clic droit et sa traduction autoritaire, l’IA, les ordres et attaques sans dégâts ; distinguer les règles de Tibbers.
6. Qualifier et implémenter expiration, mort du clone, récompenses, mort/réapparition du propriétaire, déconnexion et fin de partie, sans entité résiduelle.
7. Qualifier les métadonnées anciennes et la casse Nondispellable/NonDispellable ; ne pas inventer des callbacks à partir des tables littérales.
8. Vérifier plusieurs niveaux, causes de dégâts, bordures temporelles, révélateurs et autres clones, puis HUD, icônes, animations, VFX, audio et réseau séparément.

Les chemins absents gardent leur portée limitée. Aucun asset 3D manquant n’est déduit de cet écart de gameplay. Le défaut de déplacement V564 et les limites d’autres modes/champions restent ouverts.

## Livraison et conservation

Scénarios qualifiés BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT : codes réels 0. Les deux RUN initiaux non nuls sont conservés séparément.

- 72 associations volontairement invalides et quatre graphes invalides refusés.
- Trois fragments de consignes changés, 42 212 inchangés ; anciens objets et descripteurs conservés.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées.
- Graphe : **99 041 sources, 3 803 consommateurs**, 42 215 exigences, 26 189 inconnues ouvertes, 5 517 précédemment résolues. Revue globale : **3 803 ancres exactes, zéro divergence courante**. Revue structurelle et hachage des sources sélectionnées distincts d’un recensement complet de toutes les sources.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/leblanc-passive-mirror_image-links-v591.json`, `docs/fidelity_leblanc_passive_mirror_image_links_v591.json`, ce rapport, les trois documents couverture/plan/reprise, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, note privée et données/consignes ciblées des deux bases. Aucune case cochée ni acceptation automatique.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision591_Leblanc_discovery`, `revision591_Leblanc_passive_probe`, `revision591_Leblanc_passive_probe_diagnostic`, `revision591_Leblanc_passive_probe_qualified`, `revision591_Leblanc_inspection_verified`, `revision591_Leblanc`, `revision592_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision592_trace_review/REVIEW.json. Leblanc V591 publié/audité :14sources natives42associations24points48liens. Deuxcas publics24impacts4passages sous40%,54refus4102ticks attente;aucun clone/invisibilité,original visible/projeté;recharge nonarmée/nonqualifiée. Texte40%/1s/8s/60s/Alt+clicdroit lié. SixLua littéraux4preloads2buffs8communautaires,CharScriptvide;BuffName NoxianCruelty et casse Nondispellable/NonDispellable conservés;6candidatsabsents. DeuxRUN initiaux échoués pendant attente voie basse avec NPC visantLeBlanc,diagnostic offset1778 tick3775;logs/binaires conservés. Reprise qualifiée zonecentrale mêmesdurées sansNPC réussie. Générateur inspection parenthèse corrigée avantcréation. PREPARE/CHECK/PUBLISH/AUDIT0;72+4refus. Conserver toutespreuves,échecs et déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple LeeSin. Goal actif;aucun statut/case/inconnu fermé.
