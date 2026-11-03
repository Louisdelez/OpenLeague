# Kog’Maw — sources et consommateurs du passif, V590

Date UTC : 2026-10-26T05:41:34.647050+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02** : relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches du passif reliées à **18 sources natives**, **54 associations** et **22 points de code**, soit **44 liens** pour les fiches contrat/simulation. Quatre sources de preuves ajoutées. Statuts, critères, trois inconnues propres, quatre dépendances et propriétaires des questions conservés.

**Le déplacement postmortem est refusé et aucune explosion n’est observée dans les deux scénarios exécutés.** Les sources du client décrivent une phase après mort de quatre secondes. Les configurations de la forme `KogMawDead` sont présentes ; leur présence ne constitue pas une transformation implémentée. Aucun code de gameplay ou asset modifié dans ce lot.

## Sources natives et divergences

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiés. L’appartenance ne qualifie pas la priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| KogMaw.inibin | OLS-ff2b413c-763f-5569-8177-14e93cc2ce14 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| KogMaw.ddf | OLS-739e7b25-92ae-5503-a500-bca5ac790916 |
| CharScriptKogmaw.luaobj | OLS-61339088-feec-59c7-a00b-305e88c54bad |
| CharScriptKogmaw.preload | OLS-51492395-eb7a-5344-95a5-dfe2893d222b |
| KogMawIcathianSurprise.inibin | OLS-f8f69e20-e711-5e72-8742-db62f17f969a |
| KogMawIcathianSurprise.luaobj | OLS-33d5d325-8a90-5351-95a9-646fc9cd60ee |
| KogMawIcathianSurprise.preload | OLS-5ecec9f6-29bf-5cb9-9e4b-19c0098340b6 |
| KogMawIcathianSurpriseReady.luaobj | OLS-9afbe197-b10a-5b8e-9291-1078a51572c5 |
| KogMawIcathianSurpriseReady.preload | OLS-f2eb748f-9f22-5a96-8166-5e5eb53f8023 |
| KogMawIcathianSurpriseSound.inibin | OLS-77a8247f-49b5-5958-9cbd-764b638658fe |
| KogMawIcathianSurpriseSound.luaobj | OLS-1d0a6706-3504-5e90-bbe5-3edb4293a086 |
| KogMawIcathianDisplay.inibin | OLS-72f1586b-3518-5da1-b3b9-63f4dfa5e83e |
| KogMawIcathianDisplay.luaobj | OLS-f34e7e06-ae09-5b43-a591-b126e9f52e12 |
| KogMawDead.inibin | OLS-f10b06e7-65fc-55d5-981b-ccd15fb1c110 |
| CharScriptKogMawDead.luaobj | OLS-1c067f1e-cbb2-5a23-8a4c-136840ef130c |
| CharScriptKogMawDead.preload | OLS-3a34d4e2-e419-5223-aee4-2db891cf3443 |
| Base.inibin | OLS-4611fd3a-8c8c-54ef-92f0-53dc97111ef3 |

- `KogMaw.inibin` lie `Passive1LuaName=KogMawIcathianDisplay`, l’icône `KogMaw_IcathianSurprise.dds` et la description du personnage. Les six champs de niveau passif sont absents, sans valeur inventée.
- Description personnage en_GB, ligne **4217** : mouvement plus rapide après mort, explosion après **4 secondes**, **100 + 25 × niveau en dégâts bruts**. Nom du passif ligne 4393.
- Le buff Display, ligne **2186**, annonce quatre secondes et `@f1@` dégâts bruts. Les buffs Surprise et Sound se résolvent lignes 2187/2188. Les trois liaisons de buffs sont résolues.
- **Divergence conservée** : les champs natifs SpellData `Description`, `DynamicExtended`, `DynamicTooltip` de `KogMawIcathianSurprise.inibin` lient des textes lignes **9568/10992/11663** donnant **160 + 30 × niveau en dégâts magiques**. Ce ne sont pas des textes inventés, mais leur rôle effectif et leur éventuelle obsolescence ne sont pas démontrés par l’analyse du serveur historique.
- Le SpellData contient aussi `IsDisabledWhileDead=1`, des champs de rayon/portée/coefficient et de projectile. Ils ne sont pas automatiquement une définition du déclenchement passif, du rayon d’explosion ou de sa formule. `CastRadius=1000`, `CastRange=1600` et `Coefficient=0.7` ne sont pas adoptés comme valeurs du passif.
- `KogMaw.ddf` contient **20 lignes QWER**, sans entrée Icathian : la correspondance dynamique `@f1@` reste à qualifier. L’absence de cette entrée ne signifie pas une formule nulle.
- La forme native **KogMawDead** possède ses propres INIBIN et configuration de skin de base. Son `Passive1LuaName=KogMawIcathianSurprise` et son Q `KogMawCausticSpittle` diffèrent des valeurs du personnage vivant (`KogMawIcathianDisplay` / `KogMawQ`). Ses statistiques de base diffèrent aussi ; elles ne sont pas adoptées comme multiplicateur de vitesse ou règles de transformation.
- **Six Lua** entièrement lus, zéro prototype enfant : cinq initialisations littérales ; une limite **NEWTABLE pc26** dans Surprise. Cette limite du lecteur n’est pas une corruption démontrée. Les deux CharScript natifs ont des initialisations vides. Ready et Display déclarent persistance après mort et non-dissipation, sans prouver leur callback serveur.
- **Quatre preloads** identifiés : dépendances Ready/Display/Surprise, forme `kogmawdead`, `untargetable`, `unlockanimation`, avertissement sonore et effets base/skin08. Déclarer ces dépendances ne prouve ni leur exécution ni une qualification de rendu/audio.
- **Quatre chemins candidats absents** : CharScript sous `Scripts`, Surprise INIBIN global, Ready INIBIN dans les sorts du personnage, DDF de KogMawDead. Les vrais fichiers de personnage et la forme morte sont présents. Aucun alias silencieux, aucune absence universelle de ressources déduite.
- **Dix références communautaires** conservées séparément : CharScript/QWER, statistiques vivant/mort, trois JSON de sorts. Le CharScript communautaire est vide. Ces fichiers ne sont pas une récupération du serveur Riot historique.

## Diagnostic réellement exécuté

Compilation privée `cargo build --locked --offline`, contre le vrai `crates/core/src/lib.rs`, non-test. Paquets et checksums alignés au lock racine. **1 158 entrées de code/ressources** et les preuves antérieures, dont Khazix V589 et les échecs conservés, vérifiés inchangés.

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-kogmaw-passive-icathian-surprise-probe.exe` — 6043136 octets — SHA-256 `3b8eb3abde50f1190def29204d6bc8d734ade0ec1412d9f267c2941d06c5b73f`.

Deux parties Map10 neuves : Kog’Maw victime, Annie attaquante. Achat public du Rubis 1028 dans le second cas : coût 400, +150 HP. Déplacements publics séquentiels dans le corridor bas, avec **100 unités** entre les positions atteintes. Annie attaque jusqu’à la mort puis reçoit Stop. Observation jusqu’à réapparition naturelle puis déplacement de Kog’Maw. Aucune injection de santé, position, mana, niveau, délai ou horloge.

| Cas | HP max | Impacts témoins | Refus publics | Dont mort | Ticks après mort | Délai ordinaire |
|---|---:|---:|---:|---:|---:|---:|
| base | 546.16 | 14 | 82 | 55 | 480 | 480 |
| ruby | 696.16 | 18 | 82 | 55 | 480 | 480 |

Les **32 baisses de santé** ont chacune un projectile Annie→Kog’Maw témoin. Chaque scénario produit une seule mort, une première élimination à 400 et une victime niveau 1. Le délai de réapparition ordinaire est **480 ticks, soit 16 secondes**, distinct des quatre secondes du passif.

Avant mort : refus joueur inconnu, attaque sur soi, slot invalide et Learn/Cast/CastAt QWER. Après mort, offsets **0, 1, 119, 120, 121**, les quatre Cast, quatre CastAt et Move/Attack/Stop sont refusés par `champion dead` : **55 refus morts par cas**, 110 au total. Chaque refus conserve exactement le snapshot. Les frontières 119/120/121 encadrent quatre secondes à 30 ticks/s sans prétendre qualifier l’horloge historique.

Jusqu’au tick 479, santé nulle, position et mana inchangés, identité `kogmaw` et même échéance de réapparition. L’ennemi reste à sa position, à 100 unités du corps, et à pleine santé : **aucun dégât d’explosion observé pendant les 960 ticks cumulés**. Cette distance d’essai n’établit pas le rayon natif. Au tick 480 : santé/mana restaurés, retour à la base ; le déplacement fonctionne à nouveau. Douze refus Learn/Cast/CastAt après réapparition complètent les **164 refus sans mutation**.

Attendu selon les textes liés : phase mobile après mort puis explosion à quatre secondes. Observé : refus de mouvement et absence de perte de santé de l’ennemi dans ces scénarios ; mort/réapparition génériques uniquement. Le test constate cet écart, il ne valide pas Icathian Surprise. Snapshots locaux, sans transport réseau, affichage ou audio qualifiés.

## Consommateurs reliés

| Source et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | blanket_dead_command_guard |
| crates/core/src/progression.rs:68 | ordinary_caps_not_dead_passive_state |
| crates/core/src/progression.rs:150 | alive_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_KogMaw_ranks |
| crates/core/src/spells.rs:101 | dead_guard_then_unsupported_alive_KogMaw |
| crates/core/src/annie_w.rs:29 | dead_guard_then_unsupported_ground_cast |
| crates/core/src/lib.rs:685 | tick_order_lifecycle_and_terminal_boundary |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | lethal_cleanup_and_immediate_respawn_deadline |
| crates/core/src/champion_kills.rs:26 | ordinary_kill_credit |
| crates/core/src/champion_kills.rs:32 | single_ordinary_kill_reward |
| crates/core/src/attacks.rs:157 | witnessed_Annie_projectiles |
| crates/core/src/lifesteal.rs:4 | ordinary_attack_damage |
| crates/core/src/lifecycle.rs:33 | actual_baseline_respawn_and_resource_restore |
| crates/core/src/lifecycle.rs:6 | level1sixteen_seconds_distinct_from_four_seconds_passive |
| crates/core/src/lifecycle.rs:24 | resource_policy_static_context |
| crates/core/src/regeneration.rs:32 | dead_regeneration_suppressed |
| crates/core/src/shop.rs:261 | Ruby_public_control |
| crates/core/src/shop.rs:215 | Ruby150health_control |
| crates/core/src/attacks.rs:103 | static_only_no_KogMaw_passive_cleanup |
| crates/core/src/movement.rs:53 | ordinary_speed_not_dead_form_acceleration |

Le garde mort de `command`, les branches de lancement/apprentissage, le nettoyage létal, le crédit de mort et la réapparition expliquent le comportement constaté. Les projectiles sont les témoins des impacts ; shop/statistiques fournissent le contrôle Rubis. La fonction de vitesse est liée comme frontière actuelle, sans accélération postmortem qualifiée. Déconnexion et règles de ressource non exercées séparément restent du contexte statique.

Dix ressources locales de profils/règles sont liées distinctement des ressources natives, dont les règles de mort et les positions de réapparition Map10. Elles ne deviennent pas du code serveur historique.

## Travail restant précis

1. Qualifier les rôles des textes contradictoires et la formule effective par niveau ; relier `@f1@` à son producteur, sans remplacer dégâts bruts par magiques arbitrairement.
2. Définir la transition létale vers l’état temporaire, le crédit de mort et le départ du délai de réapparition ; distinguer l’acteur d’origine et une éventuelle forme contrôlée.
3. Définir la vitesse/accélération, le contrôle de déplacement, les collisions et restrictions d’actions pendant ces quatre secondes.
4. Qualifier ciblabilité, invulnérabilité, buffs persistants, actions/projectiles déjà engagés et ordonnancement des événements simultanés.
5. Qualifier l’origine du chronomètre, l’instant d’explosion, le rayon réel et les bordures, types de cibles, dégâts, attribution, boucliers et interactions.
6. Implémenter les consommateurs manquants conformément au contrat qualifié ; vérifier plusieurs niveaux, morts par différentes causes, cibles multiples et frontières temporelles/spatiales.
7. Qualifier les interactions de résurrection, dont Yorick, puis réapparition, déconnexion, fin de partie et nettoyage sans explosion double ou retardée.
8. Qualifier séparément HUD/compte à rebours, icône, forme, animations, VFX base/skins, audio et réplication réseau.
9. Étendre le lecteur Lua pour le flux NEWTABLE si nécessaire ; préserver les données brutes et les chemins absents précisément recensés.

Aucun serveur historique exécuté. Aucune ressource 3D manquante déduite du défaut de gameplay. BattleTraining, les autres champions et le défaut de déplacement V564 restent des limites distinctes ouvertes.

## Intégration et vérifications

BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels 0, journaux et identités conservés.

- **72 associations invalides et quatre graphes invalides refusés** ; trois fragments de consignes changés et 42 212 inchangés.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées.
- Graphe : **99 037 sources, 3 779 consommateurs**, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 précédemment résolues. Revue globale : **3 779 ancres exactes, zéro divergence courante**. Le contrôle structurel et celui des sources sélectionnées ne prétendent pas re-hacher tout le catalogue.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/kogmaw-passive-icathian_surprise-links-v590.json`, `docs/fidelity_kogmaw_passive_icathian_surprise_links_v590.json`, ce rapport, `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, note/reçu privé et données/consignes ciblées des deux bases. Aucune case cochée, aucune acceptation automatique.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision590_KogMaw_discovery`, `revision590_KogMaw_passive_probe`, `revision590_KogMaw_inspection_verified`, `revision590_KogMaw`, puis `revision591_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision591_trace_review/REVIEW.json. KogMaw V590 publié/audité :18sources natives,54associations,22points/44liens. Deuxcas publics32impacts Annie,2morts,164refus dont110dead offsets0/1/119/120/121;960ticks,deuxréapparitions480ticks. Move postmortem refusé,ennemi100unités pleinevie,aucune explosion observée. Texte personnage4secondes100+25niveau bruts contre anciens textesSpellData160+30niveau magiques;divergence ouverte. KogMawDead etsa base présents,stats/Qdistincts nonadoptés. SixLua5littéraux1NEWTABLEpc26,4preloads3buffs,DDF20sansIcathian,10communautaires,CharScriptvide,4candidatsabsents. BUILD/RUN/inspection/prepare/check/publish/audit0;72+4refus. Conserver les preuves et échecs antérieurs,déplacementV564. Poursuivre le passif suivant après inspection réelle,par exemple Leblanc. Goal actif;aucun statut/case/inconnu fermé.
