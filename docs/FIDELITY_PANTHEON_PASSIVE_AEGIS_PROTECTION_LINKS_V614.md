# Pantheon — sources et consommateurs du passif, V614

Date UTC : 2026-10-26T13:03:43.093936+00:00. Tâche SYS-01.2-02, projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis.

## Résultat et périmètre

Les trois fiches CH-Pantheon-PASSIF-SOURCE, CH-Pantheon-PASSIF-SIMULATION-CONTRAT et CH-Pantheon-PASSIF-SIMULATION sont enrichies avec 97 ressources natives et 291 associations. Vingt-quatre points du code courant donnent 48 liens supplémentaires pour les deux fiches de simulation. Les lecteurs de sources ne sont pas assimilés à l’implémentation du jeu.

Le mécanisme de compteur/blocage Aegis Protection reste absent du chemin inspecté et testé. Après quatre puis huit attaques de Pantheon, toutes les attaques entrantes infligent encore les dégâts physiques ordinaires. L’armure d’objet réduit ces dégâts mais ne les bloque pas. Aucun gameplay ou asset n’est modifié dans cette livraison de traçabilité. Trois questions propres, quatre dépendances, statuts, critères et propriétaires restent conservés.

## Sources natives

97 ressources : 33 INIBIN, 37 Lua compilés, 25 preloads, un DDF et le fichier de texte en_GB. Elles correspondent au manifeste sélectionné du client. Les 37 Lua ont été parcourus entièrement, sans sous-fonctions. Huit limites de lecture littérale NEWTABLE sont explicites : BasicAttack, BasicAttack2, CritAttack, E, ESound, Q, RJump et W. Ces limites ne prouvent pas une corruption ; une initialisation littérale ne constitue pas l’exécution du serveur historique.

Pantheon.inibin désigne `Pantheon Aegis` et `Pantheon_AOZ.dds`. La description en_GB ligne4254 indique qu’après quatre attaques ou sorts, Pantheon bloque la prochaine attaque de base ou de tourelle. Le texte Counter ligne2446 mentionne quatre cumuls ; Shield ligne2447 mentionne le blocage des dégâts de la prochaine attaque. W ligne11777 doit rafraîchir immédiatement la protection.

Les champs hérités sont conservés : Passive1Desc parle d’une seconde attaque de Master Yi, PassLev1Desc2..4 indiquent +40/+60/+80% de régénération de mana. Ils ne sont pas adoptés comme règles de Pantheon. Passive1 et Passive1Level1..6 sont absents des champs sélectionnés.

Le CharScript natif est vide ; le CharScript communautaire également. `PantheonPassive.luaobj` et `Pantheon_Aegis.luaobj` exposent les mêmes littéraux de nom, icône, PersistsThroughDeath et NonDispellable. Le compteur et le bouclier exposent leurs noms/icônes. Ces métadonnées ne qualifient pas les callbacks de comptage/blocage, leur priorité, le respawn ou le rendu.

Douze références BuffData sont relevées : six résolues exactement, six non résolues sous leur nom ancien (Pantheon_Aegis_Counter, Pantheon_Aegis, Pantheon_Grand_Skyfall, Pantheon_HeartseekerSound, PantheonAegisShield et PantheonCertainDeath). Aucune substitution implicite de nom avec espace/underscore n’est effectuée. Les textes modernes présents sont distingués de ces liens historiques incomplets.

Cinq noms existent à la fois sous Characters/Pantheon/Spells et DATA/Spells avec des octets différents : BasicAttack INIBIN/Lua, BasicAttack2 INIBIN/Lua et CritAttack INIBIN. Le Lua d’attaque global est vide tandis que celui du personnage contient une table. La priorité historique effective reste inconnue ; les deux identités sont conservées.

Le DDF contient huit lignes : E f1=0,6×bonusattackdamage, Q f1=1,4×bonusattackdamage, six lignes vides. Il ne fournit pas une formule de blocage. Le passif Certain Death de E, décrit comme critique garanti sous15% de PV, est un mécanisme distinct d’Aegis Protection.

Le preload du CharScript mentionne pantheonpassive et pantheonepassive ; le preload du passif mentionne compteur, bouclier et état d’incantation R. Les anciennes dépendances underscore et les particules conservent leurs identités. Leur présence ne constitue pas une acceptation du rendu ni des règles d’événement.

Cinq candidats de recherche sont documentés : quatre absents (CharScript à la racine, PantheonAegis.inibin, PantheonAegisCounter.inibin et PantheonPassiveShield.ddf) et **PantheonPassiveShield.inibin présent dans le répertoire personnage**. Ces recherches locales ne prouvent pas une absence globale d’assets. Aucune variante NightmareBot n’entre dans les97 ressources sélectionnées.

| Ressource | Identité du registre |
|---|---|
| Pantheon.inibin | OLS-1e78508b-c2e5-5887-b988-a9b7cb809313 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Pantheon.ddf | OLS-248da488-993f-52e3-9a11-e8aa8c019903 |
| CharScriptPantheon.luaobj | OLS-3b6de7e3-1dcd-5515-9536-7df4eefd5efc |
| CharScriptPantheon.preload | OLS-9eb25ba7-94cf-5195-a3fa-0162300a0560 |
| PantheonBasicAttack.inibin | OLS-3bf54131-c01e-5487-b76e-daaa6dede6fe |
| PantheonBasicAttack.luaobj | OLS-8637ed5c-5742-5e96-99c8-6b7d542720d6 |
| PantheonBasicAttack2.inibin | OLS-2975f844-9ede-51de-8f25-bfa20980404b |
| PantheonBasicAttack2.luaobj | OLS-7f527c60-da6f-5bc8-bca0-3c3ef0c92f06 |
| PantheonCritAttack.inibin | OLS-01d436e8-dcc1-5d3f-a4c0-3391e6d713e9 |
| PantheonCritAttack.luaobj | OLS-6065b0b9-6d44-52cc-946e-1bfe89634c15 |
| PantheonE.inibin | OLS-c1661c5f-48a2-5527-b1c5-bad949901aa4 |
| PantheonE.luaobj | OLS-9b4f87d0-15bc-5783-91a6-b5c848971926 |
| PantheonE.preload | OLS-da085500-99be-5aa4-bf42-d0ef6fe8a09a |
| PantheonEChannel.inibin | OLS-fc30c255-950d-5d26-9763-290c65c17d2f |
| PantheonEChannel.luaobj | OLS-05acd6ed-1f8c-5b64-b7bc-f2a60c3ff345 |
| PantheonEChannel.preload | OLS-7d96e089-02e9-5319-8515-cd7f6f9a8ab6 |
| PantheonEPassive.inibin | OLS-d1fc1e78-df1b-5354-8fed-7f4388b68c7e |
| PantheonEPassive.luaobj | OLS-1e12b9e8-bc45-549f-b50e-0fce669dfa98 |
| PantheonESound.inibin | OLS-7f1cf378-b788-5698-8f1d-ccc7fec7bb73 |
| PantheonESound.luaobj | OLS-db897cec-bdc6-5634-b439-bb4169a5acd0 |
| PantheonPassive.luaobj | OLS-690965ac-79c4-5a01-ab02-2ddcb5100793 |
| PantheonPassive.preload | OLS-4947f3cf-5318-545e-a05e-b7256b318c71 |
| PantheonPassiveCounter.inibin | OLS-43d220d1-664d-5a07-a5bb-192980fb6092 |
| PantheonPassiveCounter.luaobj | OLS-5f928d45-8a61-5dee-900e-d24ede396987 |
| PantheonPassiveShield.inibin | OLS-0f4aeaa0-95bb-50c1-874f-24ce5634dfca |
| PantheonPassiveShield.luaobj | OLS-d5a0abed-eec7-542c-b1c4-2fd6be83e47c |
| PantheonPassiveShield.preload | OLS-26d72a85-4dba-5546-8428-4754f4c4db14 |
| PantheonQ.inibin | OLS-bf09d2f4-1d99-58da-aac0-c17b8a7f52fd |
| PantheonQ.luaobj | OLS-4a2e5563-e6b7-5a5f-b4fc-5c61cc7f82cd |
| PantheonQ.preload | OLS-66304206-749c-5495-baa1-a5f062a62bfa |
| PantheonR.inibin | OLS-e82656b3-f822-577c-8962-74c11671c3d6 |
| PantheonR.luaobj | OLS-45a0637f-118a-5a96-9e5b-91bbfe3d61f2 |
| PantheonRFall.inibin | OLS-4e210424-3dd6-56e7-9598-aa4ec78cd042 |
| PantheonRFall.luaobj | OLS-0fdd867d-ba43-56aa-8e33-a0166486335f |
| PantheonRFall.preload | OLS-bd17f3ab-21b2-5224-a0cc-e2a390acb2e0 |
| PantheonRFallD.luaobj | OLS-31f34d86-7113-58fe-9e95-96daa7d5ede1 |
| PantheonRFallD.preload | OLS-8789335f-c0da-5f0e-b338-cb613ef42a7c |
| PantheonRIsCasting.luaobj | OLS-a3164877-c3b8-5e25-95d9-f40ed9ab84ba |
| PantheonRJump.inibin | OLS-a44c0ae5-88be-585e-941b-42c4b14e86ba |
| PantheonRJump.luaobj | OLS-288e3c5e-73c3-5c45-a55b-41615edc412b |
| PantheonRJump.preload | OLS-d9fdd79d-eed2-55d5-a824-4ef80d227459 |
| PantheonRParticle.luaobj | OLS-32a91474-70df-560e-8399-a3f8a2f005de |
| PantheonRParticle.preload | OLS-f5fd87df-11bd-5a98-8e14-c5e75d1865ca |
| PantheonRParticleRed.luaobj | OLS-01fe280b-2b86-5f19-b7c1-49c2bb910829 |
| PantheonRParticleRed.preload | OLS-7c1bcbfa-61f9-5dfa-bc5e-8091aafc7c1c |
| PantheonW.inibin | OLS-9bcd6440-6a20-5c08-b782-f856b4f42e2e |
| PantheonW.luaobj | OLS-4c9c00a7-d93d-52d7-a21f-8f519140f757 |
| PantheonW.preload | OLS-aa11e60b-c393-5923-a4b5-47e4acae3836 |
| Pantheon Aegis Counter.inibin | OLS-52f0ead0-e04d-55e1-955a-5b2fe64cc4b8 |
| Pantheon Aegis.inibin | OLS-483c7993-c664-5408-bc38-2883f883ab5b |
| Pantheon Grand Skyfall.inibin | OLS-f5c01e52-f7a1-59a5-a744-bdf4d86f068d |
| Pantheon HeartseekerSound.inibin | OLS-ad56300a-c04c-51b9-b6d3-6e067ec89e3a |
| Pantheon_Aegis.luaobj | OLS-f59ce2d8-5508-5f60-a8ed-674854b0e640 |
| Pantheon_Aegis.preload | OLS-f9a29553-405b-5f26-8b84-3f34c9db9a90 |
| Pantheon_Aegis_Counter.luaobj | OLS-bb56a913-a5b5-5f44-bd32-dd327dc9f727 |
| Pantheon_AegisShield.inibin | OLS-4037ffab-c372-5b8e-994b-795cdcb4759f |
| Pantheon_AegisShield.luaobj | OLS-93743a34-c20b-571a-9d79-b2d2932b8f34 |
| Pantheon_AegisShield.preload | OLS-569738f9-d170-54c7-b1de-4026f4f52500 |
| Pantheon_CertainDeath.inibin | OLS-cc131527-8cff-5041-b409-66864f513a62 |
| Pantheon_CertainDeath.luaobj | OLS-5609e105-1092-5231-b40c-1682ef79bea2 |
| Pantheon_GrandSkyfall.inibin | OLS-bcdc6d11-b099-58c5-919b-83a3d49278be |
| Pantheon_GrandSkyfall.luaobj | OLS-511cdd3e-6867-57e7-a5c6-af9754d382c8 |
| Pantheon_GrandSkyfall_Fall.inibin | OLS-b4153ff8-1d96-586d-bec1-32fe45955bc2 |
| Pantheon_GrandSkyfall_Fall.luaobj | OLS-6570f095-6e64-5788-858f-febdef735081 |
| Pantheon_GrandSkyfall_Fall.preload | OLS-8fb48b7a-45da-5165-a645-c512ea778aac |
| Pantheon_GrandSkyfall_FallD.luaobj | OLS-3adab923-40b0-5f7a-b73c-a242aa68d49f |
| Pantheon_GrandSkyfall_FallD.preload | OLS-135261c1-0642-515b-9277-ee6bbf266f2c |
| Pantheon_GrandSkyfall_Jump.inibin | OLS-4e25962e-911c-5795-8057-6492ba8a1b1d |
| Pantheon_GrandSkyfall_Jump.luaobj | OLS-394849de-1056-558f-a8ab-616e7b0a580d |
| Pantheon_GrandSkyfall_Jump.preload | OLS-f7564935-d62e-5583-8946-7cf77524fead |
| Pantheon_GS_Particle.luaobj | OLS-e693eee8-d821-577a-b1c1-94c2afe5f49e |
| Pantheon_GS_Particle.preload | OLS-0ff514c6-57c4-5cbc-af20-77ca3f6dabf2 |
| Pantheon_GS_ParticleRed.luaobj | OLS-97fd95e7-5f4c-5c77-ab2d-a1cac32bc72b |
| Pantheon_GS_ParticleRed.preload | OLS-e9e76e24-649e-5b9f-a08b-18ccdd5794da |
| Pantheon_Heartseeker.inibin | OLS-867fd8a4-3ad2-5765-8490-5767398777ab |
| Pantheon_Heartseeker.luaobj | OLS-b9483763-4277-5ad2-bb30-3cb67561e077 |
| Pantheon_Heartseeker.preload | OLS-27d11e3e-42cc-56f8-80d8-f554fffa5016 |
| Pantheon_HeartseekerChannel.inibin | OLS-a10d730c-79f8-5192-9732-eb26c1bdfbf2 |
| Pantheon_HeartseekerChannel.luaobj | OLS-35ba4f6c-017b-52a5-b054-4fadc677ae0c |
| Pantheon_HeartseekerChannel.preload | OLS-449a82bc-efa6-5ecc-b97a-75f7b0ec43d1 |
| Pantheon_HeartseekerSound.luaobj | OLS-2f17ab18-e151-5088-a9df-7021ff551abb |
| Pantheon_LeapBash.inibin | OLS-e39c86cb-8dad-556c-bbc9-46d31b7a6ec0 |
| Pantheon_LeapBash.luaobj | OLS-15af5ba0-2861-54ef-b619-eada56435455 |
| Pantheon_LeapBash.preload | OLS-f75ac117-e46d-5842-a917-c4c37c9969b1 |
| Pantheon_Throw.inibin | OLS-107c2b0d-1222-5095-b0fb-7e07e2c2fe5e |
| Pantheon_Throw.luaobj | OLS-957c9299-73f9-5eed-966d-6531c150dc3b |
| Pantheon_Throw.preload | OLS-25acd5f6-346b-513e-a54d-640d7878960b |
| PantheonAegisShield.inibin | OLS-e1d2c6c7-7afc-5197-82cd-c1cb078a6a39 |
| PantheonBasicAttack.inibin | OLS-3d1e59f2-3470-54a3-8276-982db3f66ee4 |
| PantheonBasicAttack.luaobj | OLS-fc346a51-4fd3-56bc-b8d1-5623c052604e |
| PantheonBasicAttack.preload | OLS-d5d65561-6d8c-50d7-a210-0a19ae3d04b0 |
| PantheonBasicAttack2.inibin | OLS-89c5af77-2bef-5f39-9270-94585fbed821 |
| PantheonBasicAttack2.luaobj | OLS-a972eca3-c166-5c72-b5f1-89ff43e7033b |
| PantheonBasicAttack2.preload | OLS-1acc60c5-d4ba-51ca-b7f8-f575f20dd05d |
| PantheonCertainDeath.inibin | OLS-8412d5c5-6d42-5eeb-a955-20e624fd181b |
| PantheonCritAttack.inibin | OLS-0e8bd77b-1649-51ad-ba72-7910d234c732 |

## Références communautaires et divergences

35 références présentes sont conservées séparément du serveur original. Le Q communautaire produit au rang1 100+1,3ADtotal et double les dégâts sous15%PV. Le tooltip natif utilise Effect2=65 et le DDF f1=1,4bonusAD. Les champs natifs anciens Effect1=100/Coefficient=1,3 restent aussi conservés : leur coexistence ne valide pas automatiquement la formule communautaire ni la priorité runtime.

W communautaire inflige dégâts et stun1s ; le fichier ne qualifie ni saut ni recharge du passif. E utilise 13+0,5AP par frappe au rang1 avec trois timers0/0,25/0,5s ; le DDF natif lie0,6bonusAD et le texte double les dégâts contre les champions, distinction absente du fichier communautaire lu.

R communautaire programme après3,5s des dégâts **physiques**200+AP au rang1, moitié au bord, sans déplacement qualifié du lanceur. Les champs et le texte natifs indiquent **magie**400+AP,33% au bord et ralentissement35% pendant1s. Ces scripts n’ont pas été exécutés comme serveur historique ou intégrés au consommateur Rust.

## Exécution du moteur actuel

Compilation privée du véritable cœur Rust, sans configuration test, dépendances alignées sur Cargo.lock, mode offline/locked. BUILD et RUN ont retourné0. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-pantheon-passive-aegis-protection-probe.exe` ; 6114816 octets ; SHA256 `3182eb5debf3f6467330df3c70e3c415c0b7844bee0824ec4469f0ce80050b7d`.

Deux parties publiques Pantheon/Annie : sans objet puis Armure d’étoffe1029 (+15armure). Aucune injection directe de position, PV, dégâts ou rang. Quatre trajets préparatoires réussis, sans réémission d’ordres. Les deux champions restent vivants au niveau1, sans contrôle de foule ou bouclier actif, sans vainqueur. Les rangs et délais de Pantheon restent à zéro, son mana plein.

Chaque cas observe trois impacts entrants au départ, quatre attaques mêlée sortantes puis trois impacts entrants, quatre nouvelles attaques sortantes, un Q Annie puis trois impacts entrants. Total : 16 attaques mêlée sortantes,18 impacts physiques entrants avec témoins de projectile, deux Q Annie (raw80/coût60) et54 refus atomiques. Les refus couvrent acteur inconnu, attaque de soi, slot invalide et commandes QWER non supportées ; les snapshots avant/après restent égaux.

| Cas | Armure | Attaques sortantes | Impacts entrants | Dégât entrant après4 attaques | Impacts bloqués | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base | 27.65200 | 8 | 9 | 39.49017334 | 0 | 27 |
| Cloth15Armor | 42.65200 | 8 | 9 | 35.33773804 | 0 | 27 |

Attendu d’une mitigation physique ordinaire :39,49017715 sans objet,35,33774185 avec armure. Observé après correction de régénération :39,49017334, ou environ35,33774. Les mêmes valeurs restent présentes après0/4/8 attaques de Pantheon ; aucun impact n’est bloqué. Le résultat attendu d’Aegis après quatre attaques n’est donc pas satisfait. Les contrôles de ce diagnostic passent sans qualifier la fonctionnalité.

Le Q magique reçu est un contrôle de dégâts génériques. Il ne prouve pas qu’un bouclier Aegis aurait été conservé : aucun bouclier Aegis n’a été produit. Aucun sort Pantheon, saut ou rafraîchissement W n’est accepté/exercé. Aucun tir de tourelle, attaque de sbire/monstre, annulation, mort/respawn ou transition simultanée n’est testé ici.

## Consommateurs réels

La recherche Pantheon/Aegis dans crates/core/src ne trouve aucune occurrence. Elle est complétée par la lecture et l’exécution des chemins d’attaque/impact/dégâts. Les sources actuelles appliquent mitigation puis absorption de boucliers génériques à montant ; aucun producteur de compteur Pantheon ou blocage de la prochaine attaque n’est identifié sur ce chemin. La recherche lexicale n’est pas une preuve d’absence dans tous les projets.

Sept ressources locales sont liées explicitement : catalogue, croissance, ressources, attaques, critiques, collision et boutique. Les entrées AnnieQ restent identifiées dans la chaîne des1158 fichiers d’entrée du diagnostic. Une mécanique générique de bouclier à montant n’est pas assimilée à Aegis.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Pantheon spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary armor including Cloth,not Aegis block |
| crates/core/src/progression.rs:150 | unsupported Pantheon learning |
| crates/core/src/progression.rs:159 | unsupported Pantheon ranks |
| crates/core/src/spells.rs:101 | unsupported Pantheon targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported Pantheon ground spell |
| crates/core/src/lib.rs:685 | ordinary attacks and incoming Q |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical/magical damage,no Aegis block observed |
| crates/core/src/attacks.rs:157 | two series of four melee attacks,not passive counter |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit route,not Aegis producer |
| crates/core/src/regeneration.rs:32 | ordinary regeneration separated from damage |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | Cloth1029+15armor |
| crates/core/src/shop.rs:215 | ordinary armor input |
| crates/core/src/world.rs:226 | one champion enemy;turret/minion/monster unexercised |
| crates/core/src/damage.rs:38 | ordinary resistance mitigation,not block |
| crates/core/src/attacks.rs:26 | melee windup context |
| crates/core/src/critical.rs:12 | ordinary critical context,not CertainDeath |
| crates/core/src/shields.rs:12 | generic amount shield,not one-attack passive protection |
| crates/core/src/shields.rs:47 | generic absorb path,not native Aegis |
| crates/core/src/ally_occupancy.rs:635 | four preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication, fichiers modifiés et contrôles

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/pantheon-passive-aegis-protection-links-v614.json. Preuve : docs/fidelity_pantheon_passive_aegis_protection_links_v614.json. Instructions copiables enrichies pour les trois fiches Pantheon et SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases locales contrôlées : quatre destinataires,42603 autres lignes,42607 états manuels et23 historiques conservés ; synchronisation normale idempotente. Identifiants, hiérarchie et inconnues inchangés octet par octet. Aucun statut, propriétaire, critère ou case clôturé automatiquement.

Revue globale :99133 sources,4390 consommateurs,4390 ancres exactes sans divergence. Contrôle structurel global (source_hashes_verified=0) ; les sources sélectionnées et le code sont hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés en conservant les preuves antérieures. Aucun stage/reset/commit/nettoyage. Les limites de Battle Training, V564 et les deux arrivées V606 restent ouvertes.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision614_Pantheon_discovery/OBSERVATIONS.json, revision614_Pantheon_passive_probe/OBSERVATIONS.json, revision614_Pantheon_inspection/OBSERVATIONS.json, revision614_Pantheon/DELIVERY_AUDIT.json et revision615_trace_review/REVIEW.json. Scripts, binaires, versions et commandes exécutées y sont identifiés.

## Travail restant

1. Qualifier les événements exacts d’incrément du compteur : lancement/impact, sorts admissibles, attaques annulées.
2. Résoudre la priorité des ressources historiques et les six liens de texte non résolus sans inventer d’alias.
3. Implémenter le compteur, l’état protégé et la consommation au véritable point d’impact.
4. Tester états0/1/2/3/4, rechargement pendant protection, W et attaques simultanées.
5. Tester tourelles, sbires, monstres, multiattaques, projectiles déjà en vol et interactions on-hit.
6. Vérifier boucliers, immunités, changement de cible, mort/respawn et nettoyage.
7. Qualifier séparément QWER, indicateur de charges, HUD, particules, animations, audio et réseau.

Les trois fiches restent ouvertes. Aucun serveur historique, rendu, audio ou transport réseau n’est qualifié ici. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision615_trace_review/REVIEW.json. V614 Pantheon / Aegis Protection : 97 sources natives, 291 associations, 24 points et 48 liens. Textes natifs : quatre attaques ou sorts préparent le blocage de la prochaine attaque normale ou de tourelle ; W rafraîchit la protection. Deux cas publics base/Armure1029+15 : 16 attaques mêlée sortantes, 18 impacts physiques entrants après 0/4/8 attaques, deux Q Annie et 54 refus atomiques. Aucun impact bloqué : 39,49017 dégâts sans objet ou 35,33774 avec armure, conformément à la mitigation générique. Aucun sort Pantheon accepté. 37 Lua dont huit limites NEWTABLE, 25 preloads, huit lignes DDF ; 12 liens BuffData dont six résolus et six historiques non résolus. 35 références communautaires séparées. CharScripts natif et communautaire vides. Cinq noms de fichiers existent sous deux chemins avec octets différents, priorité inconnue. Des champs hérités parlent de Master Yi et de mana ; ils ne définissent pas Aegis. Quatre candidats absents et un candidat présent ne prouvent pas un manque global d’assets. Q communautaire 100+1,3ADtotal contre texte/DDF natifs 65+1,4bonusAD ; W sans saut ou recharge qualifiés ; E utilise AP au lieu du lien bonusAD ; R physique200/demi-bord contre magie400/tiers-bord natifs. Quatre trajets réussis ; V564/V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT : 0 ; 72+4 refus de publication. Prochain passif à inspecter réellement : Poppy. Goal actif.
