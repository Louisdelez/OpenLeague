# Orianna — sources et consommateurs du passif, V613

Date UTC : 2026-10-26T12:48:18.653230+00:00. Tâche SYS-01.2-02, projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis.

## Résultat et périmètre

Trois fiches Orianna sont enrichies : CH-Orianna-PASSIF-SOURCE, CH-Orianna-PASSIF-SIMULATION-CONTRAT et CH-Orianna-PASSIF-SIMULATION. 67 ressources natives sont liées par 201 associations ; 24 points du code courant donnent 48 liens supplémentaires pour les deux fiches de simulation. Les lecteurs de sources ne sont pas promus en implémentation du jeu.

Le passif Clockwork Windup reste non implémenté dans le chemin inspecté. Les essais publics montrent seulement les dégâts physiques ordinaires, sans dégâts magiques supplémentaires ni augmentation sur la même cible. Aucun gameplay ou asset n’est modifié par cette livraison de traçabilité. Les trois questions propres, quatre dépendances, statuts, critères et propriétaires restent conservés.

## Sources natives et inconnues

67 ressources : 21 INIBIN, 26 Lua compilés, 19 preloads et le fichier de texte en_GB. Les 26 Lua ont été parcourus entièrement, sans sous-fonctions ; cinq limites de lecture littérale NEWTABLE sont explicites (Izuna, IzunaDamage, Redact, RedactDamage et Return). Ces limites ne prouvent pas une corruption. Sept clés BuffData sont liées exactement aux textes.

Orianna.inibin et OriannaNoBall.inibin désignent OrianaSpellSword (un seul n), OriannaPassive.dds et le nom Clockwork Windup. Passive1, Passive1Desc et Passive1Level1..6 sont absents des champs sélectionnés. Les deux CharScriptOrianna.luaobj sont vides et identiques (56 octets, SHA256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0). Le CharScript communautaire est également vide.

Le texte SpellSword ligne 2440 décrit des dégâts magiques f2 + f1%AP, puis 20% supplémentaires par attaque ultérieure sur la même cible dans les quatre secondes, jusqu’à deux cumuls ; f3 sert à l’affichage. **Les valeurs f1/f2/f3 et leur progression restent non résolues.** Les valeurs SpellData Effect1=50, Effect2=20 et Coefficient=0 ne sont pas assimilées à ces variables. La portée CastRange=162,100006 n’est pas adoptée comme portée d’attaque. La description mentionne le retour de la Balle lorsqu’elle est trop éloignée, sans fournir ici une distance qualifiée.

Les littéraux du Lua SpellSword indiquent notamment BuffName, BuffTextureName, IsDeathRecapSource, PersistsThroughDeath et NonDispellable. Ils ne fournissent pas le callback des dégâts, le producteur de cumuls, le comportement au respawn ou l’affichage. PowerDagger et PowerDaggerDisplay exposent les mêmes littéraux et des effets vides ; leurs preloads ne prouvent pas le rendu.

Le preload principal nomme orianaspellsword et orianaghostself ; celui de NoBall nomme yomuspellsword, yomughostself et yomushockorb. Les deux citent apbonusdamagetotowers. Aucune conversion implicite de ces noms Yomu n’est effectuée. Les dépendances Yomu ne sont pas recherchées globalement dans ce lot. Les valeurs de régénération de mana diffèrent : statique 1,2/1,568 et croissance 0,16/0,1. La priorité des variantes et leur transformation effective restent à qualifier.

Six candidats sélectionnés sont absents : CharScript à la racine plutôt que Scripts, Orianna.ddf, SpellSword INIBIN dans Characters/Spells plutôt que global, graphie globale OriannaSpellSword plutôt que OrianaSpellSword, OrianaPowerDagger.preload et OrianaSpellSword.ddf. Cela ne prouve pas une absence générale d’assets. Aucun DDF n’a été identifié dans le candidat retenu.

| Ressource | Identité du registre |
|---|---|
| Orianna.inibin | OLS-d2685aa2-2f5d-50b3-b4a4-6af7fa65b526 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| OriannaNoBall.inibin | OLS-73fe5f87-0bb4-55c5-942d-d20817fba446 |
| CharScriptOrianna.luaobj | OLS-46b1e38e-dc7d-5724-bc4f-9f5aaa9c645e |
| CharScriptOrianna.preload | OLS-7c75fb8c-979f-5f8e-912a-df1a46ff66ca |
| OrianaDetonateCommand.inibin | OLS-f70d2e7c-7bb2-564f-bb9d-3d0f0a5a2f11 |
| OrianaDetonateCommand.luaobj | OLS-43d91fe0-c778-5f2e-a594-7c089da789ca |
| OrianaDetonateCommand.preload | OLS-8fd8e045-8631-5d65-91f7-f6cc071934e2 |
| OrianaDissonanceAlly.inibin | OLS-416d4c18-f277-5be5-b4f9-39e1ed6ff09c |
| OrianaDissonanceCommand.inibin | OLS-e2d3e719-1d87-5bae-bb9c-0aeb54eef82f |
| OrianaDissonanceCommand.luaobj | OLS-c01ddeee-b23e-5220-8e54-fd212ddc8a00 |
| OrianaDissonanceCommand.preload | OLS-1ce5d81a-e973-59c5-a2bb-8d29e1ff2370 |
| OrianaDissonanceEnemy.inibin | OLS-27806b91-9914-5665-9cc2-ec5b2ab3f5f4 |
| OrianaDissonanceWave.inibin | OLS-0c6ed4bb-64d7-585a-bc97-c5a149a0937f |
| OrianaDissonanceWave.luaobj | OLS-7bb41408-e060-5ce5-916b-f1fbc5e5a739 |
| OrianaDissonanceWave.preload | OLS-a88724f1-3449-5665-a205-c8f98a38b12c |
| OrianaGhost.inibin | OLS-0b3047b3-b7b8-5e67-bfbc-3c5e5b64fa29 |
| OrianaGhost.luaobj | OLS-24ed6695-6a24-5ff7-8eae-c77f8d1ecd09 |
| OrianaGhost.preload | OLS-73bb7c92-f6ab-558f-a492-551235a259d4 |
| OrianaGhostMinion.luaobj | OLS-34792331-8267-548a-b8d7-8d9fe264f3ee |
| OrianaGhostMinion.preload | OLS-0baf8c2d-be0e-5d20-82e0-ad90bba88132 |
| OrianaGhostSelf.inibin | OLS-cbd488fc-4363-58d4-bdb2-f290545c745c |
| OrianaGhostSelf.luaobj | OLS-17eaf0f7-d85f-55ef-93d8-676cec3dea3a |
| OrianaGhostSelf.preload | OLS-fc7247fe-3ad8-511c-b390-461c1a7b0f18 |
| OrianaGlobalCooldown.luaobj | OLS-c2726150-5fa7-59ee-9a77-8d70da1f109b |
| OrianaHaste.luaobj | OLS-14cc6214-034d-51f6-abf0-22387c5b47e0 |
| OrianaIzuna.inibin | OLS-4f38d575-e3fb-5c6a-88e5-f5d4a7325688 |
| OrianaIzuna.luaobj | OLS-89f177c3-3ad0-56b5-aeeb-f03c6ed8d776 |
| OrianaIzuna.preload | OLS-386e1f7d-e062-50c0-9070-731322bca9ac |
| OrianaIzunaCommand.inibin | OLS-72a0d3eb-f8be-5bad-aaf4-8d52fddb2670 |
| OrianaIzunaCommand.luaobj | OLS-c4c7c151-78a8-5236-b376-b5e1b6ae8739 |
| OrianaIzunaCommand.preload | OLS-16bc63be-eee2-529a-9ea0-b38468ca0015 |
| OrianaIzunaDamage.luaobj | OLS-fa86a178-025e-50e9-9800-c5b2b149ede7 |
| OrianaIzunaDamage.preload | OLS-5f38d3d4-ce5d-5fb0-b72e-42e186406a22 |
| OrianaPowerDagger.inibin | OLS-1404a258-c82d-58eb-9434-233a453daee1 |
| OrianaPowerDagger.luaobj | OLS-a05d4136-125a-5dac-b558-6d5a76fa02f4 |
| OrianaPowerDaggerDisplay.luaobj | OLS-c10eaca4-6c84-5c22-9102-a01b1e47a5ca |
| OrianaRedact.inibin | OLS-947cc1e3-216e-5d49-9ce9-d595cb674dd5 |
| OrianaRedact.luaobj | OLS-6ee86a5d-5db9-52ab-837a-a0f89832a064 |
| OrianaRedact.preload | OLS-817b6a93-9377-5b5b-9cf2-e7bde52a2134 |
| OrianaRedactCommand.inibin | OLS-5545d27e-7683-5018-a330-44036f4e4b09 |
| OrianaRedactCommand.luaobj | OLS-72652d6c-c7e4-5f39-9b5f-3a1e8d8b7a30 |
| OrianaRedactCommand.preload | OLS-b926474d-1def-5196-b1de-d0d438303acb |
| OrianaRedactDamage.luaobj | OLS-8da7ca53-c099-5c81-a5c2-fbf256ef9e89 |
| OrianaRedactDamage.preload | OLS-87ecb31b-7188-5fa6-80c9-a0e6ab11d32f |
| OrianaRedactShield.inibin | OLS-3d5de60e-ab36-5ec6-931f-3a883b44ea13 |
| OrianaRedactShield.luaobj | OLS-e2e4dfe4-394f-5e3f-b48a-adfc0f1d1251 |
| OrianaRedactShield.preload | OLS-bdb38bf5-ec86-59ce-be1e-47ff841b8531 |
| OrianaRedactTarget.luaobj | OLS-07414047-d301-51e4-939f-ba3d57b0feac |
| OrianaReturn.inibin | OLS-438bd0d0-8784-5926-b7ae-af081360cf6f |
| OrianaReturn.luaobj | OLS-fe910d0f-232d-5e0c-9c0c-6db946e8f840 |
| OrianaReturn.preload | OLS-49a2ebea-c709-5acd-b2f9-c5556c43d49e |
| OrianaSlow.luaobj | OLS-13a0f1df-42d9-5486-bf60-323e2bf636bc |
| OrianaSpellSword.inibin | OLS-fcc4cee4-93b3-5717-a3f0-65bad23c0086 |
| OrianaSpellSword.luaobj | OLS-4173a767-8645-5c74-b1be-a5b54a05cdd3 |
| OrianaSpellSword.preload | OLS-08363fd2-4192-5082-9be1-52c67d856572 |
| OrianaStun.luaobj | OLS-50c81855-cbc4-5eca-890d-19d0543f313d |
| OriannaBallTracker.luaobj | OLS-de11a588-1d69-540a-8aa4-a8ca8c86a403 |
| OriannaBallTracker.preload | OLS-f7a9aece-d960-5b3a-be01-a6718ece0152 |
| OriannaBasicAttack.inibin | OLS-e36f2fc9-3490-57e5-bdd4-f01fb4f38ab4 |
| OriannaBasicAttack2.inibin | OLS-61175ef9-f127-5a06-baad-d5a8d091e262 |
| OriannaBasicAttack3.inibin | OLS-fccfd987-5ed3-5a1c-9d66-da31a1597981 |
| OriannaCritAttack.inibin | OLS-4616b6c7-d554-500a-a630-9f0c6b22b96b |
| OriannaEAllyRangeRingRender.luaobj | OLS-57ce6d22-08ea-502f-ae2c-437f0e8dbc18 |
| OriannaEAllyRangeRingRender.preload | OLS-d76c6691-0204-56a9-a9d8-f98c831e076d |
| CharScriptOrianna.luaobj | OLS-28bc15ae-63fe-5458-82cd-4c848b2a8003 |
| CharScriptOrianna.preload | OLS-108ce17f-d430-585d-be8f-f24e6b39ac0f |

## Références communautaires

25 références présentes sont conservées comme contexte distinct du serveur original. Le Q communautaire traite un cône depuis le propriétaire (dot>0,93, portée1300) et inflige au rang1 65+0,4AP, contre 60+0,5AP et portée825 dans QCommand natif. Ce code n’établit pas un trajet de Balle.

W utilise targetPos et un rayon255 ; E délègue un bouclier de quatre secondes sans qualifier le déplacement de la Balle ni ses dégâts sur le trajet. R utilise targetPos et un rayon410, puis Airborne pendant0,75s ; aucune attraction n’est qualifiée dans ce fichier. Ces scripts ne sont ni exécutés comme serveur original ni intégrés comme consommateur Rust.

## Exécution du moteur courant

Compilation privée du véritable cœur Rust, sans configuration test et avec dépendances alignées sur Cargo.lock, en mode offline/locked. BUILD et RUN ont retourné 0. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-orianna-passive-clockwork-windup-probe.exe` ; 6064128 octets ; SHA256 `518a65c4f3e56a5c1f776bd52a71e0cce264b76ea31bed1aa1a1a2b49e53fdfb`.

Deux parties publiques Orianna/Annie, sans objet puis Tome1052 (+20AP). Aucune injection directe de position, PV, dégâts ou rang. Quatre trajets préparatoires ont réussi sans réémission d’ordres. Tous les champions restent vivants au niveau1 ; aucun contrôle de foule ou bouclier actif, aucun vainqueur. Orianna conserve ses rangs et délais à zéro et son mana plein.

Chaque cas comporte quatre impacts consécutifs sur la même cible, 121 ticks d’attente, puis trois impacts. Total : 14 impacts à distance avec 14 témoins de projectile distincts, 242 ticks d’attente et 54 refus atomiques vérifiés avant/après. Les refus couvrent acteur inconnu, attaque de soi, slot invalide et commandes QWER non supportées. Aucun sort Orianna n’est accepté ; aucune attaque ou Q entrant d’Annie n’intervient.

| Cas | AD | AP | Impacts | Dégât observé par impact | Écart entre séries (ticks) | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base | 40.36800 | 0.0 | 7 | 33.86007690 | 137 | 27 |
| Tome20AP | 40.36800 | 20.0 | 7 | 33.86007690 | 137 | 27 |

Attendu pour une attaque physique générique : 33,86009216. Observé après correction de la régénération : 33,86007690, pour chacun des 14 impacts. Les ticks d’impact sont 1971/2017/2063/2109 puis2246/2292/2338 dans les deux cas : 46 ticks entre impacts d’une série et137 entre les séries. Les dégâts ne changent ni avec +20AP ni avec les attaques répétées. Le bonus magique et l’augmentation décrits par le passif ne sont pas observés.

La traversée d’un délai supérieur à quatre secondes ne qualifie pas l’expiration d’un cumul qui n’a pas été produit. Les essais n’exercent pas l’alternance de cible, plusieurs Orianna, les niveaux supérieurs, la mort/respawn ou la gestion de Balle. Le résultat attendu d’un passif complet reste non satisfait ; les contrôles de ce diagnostic ont réussi.

## Consommateurs réels

La recherche Orianna/Oriana/clockwork dans crates/core/src ne trouve aucune occurrence. Elle est complétée par lecture et exécution des routes d’attaque, d’impact et de dégâts ; elle ne prétend pas démontrer une absence dans tous les projets. Les routes génériques produisent les dégâts physiques ; aucun producteur de cumuls ni ajout magique d’Orianna n’est identifié sur le chemin inspecté. Les points death recap sont du contexte générique, sans qualification du flag natif IsDeathRecapSource.

Sept ressources locales sont liées séparément : catalogue, croissance, ressources, attaques, critiques, collision et boutique. Leur présence ne constitue pas une implémentation du passif.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Orianna spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary AD/AP from Tome,not native passive coefficient |
| crates/core/src/progression.rs:150 | unsupported Orianna learning |
| crates/core/src/progression.rs:159 | unsupported Orianna ranks |
| crates/core/src/spells.rs:101 | unsupported Orianna targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported Orianna ground spell |
| crates/core/src/lib.rs:685 | 242idle ticks and14projectile impacts |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical damage,no onhit magic observed |
| crates/core/src/attacks.rs:157 | repeated ranged projectiles at46tick intervals;137tick gap |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit route,not passive stack producer |
| crates/core/src/regeneration.rs:32 | ordinary HP regeneration separated from damage |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | Tome1052+20AP |
| crates/core/src/shop.rs:215 | ordinary AP input |
| crates/core/src/world.rs:226 | same enemy target,alternate target reset unexercised |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary ranged windup context |
| crates/core/src/critical.rs:12 | ordinary noncritical projectile profile |
| crates/core/src/death_recap.rs:184 | generic recap context,not native IsDeathRecapSource acceptance |
| crates/core/src/death_recap.rs:200 | generic recap context,no passive magic event qualified |
| crates/core/src/ally_occupancy.rs:635 | four preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication et vérification

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/orianna-passive-clockwork-windup-links-v613.json. Preuve : docs/fidelity_orianna_passive_clockwork_windup_links_v613.json. Les instructions copiables des trois fiches et de SYS-01.2-02 reprennent les sources, écarts et limites.

PREPARE/CHECK/PUBLISH/AUDIT : 0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés, 42212 identiques. Deux bases locales contrôlées : quatre destinataires, 42603 autres lignes, 42607 états manuels et23 historiques conservés ; synchronisation normale idempotente. Identifiants, hiérarchie et inconnues restent identiques octet par octet. Aucun statut ou case clôturé automatiquement.

Revue globale : 99129 sources, 4366 consommateurs, 4366 ancres exactes sans divergence. Il s’agit d’une vérification structurelle (source_hashes_verified=0) ; les sources sélectionnées et le code sont hachés séparément. Aucun nouveau contrôle exhaustif de toutes les sources n’est revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage. Les échecs et limites antérieurs, dont V564 et les deux arrivées V606, restent ouverts.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision613_Orianna_discovery/OBSERVATIONS.json, revision613_Orianna_passive_probe/OBSERVATIONS.json, revision613_Orianna_inspection/OBSERVATIONS.json, revision613_Orianna/DELIVERY_AUDIT.json et revision614_trace_review/REVIEW.json. Les scripts, binaires, versions et commandes réellement exécutées y sont identifiés.

## Travail restant

1. Résoudre f1/f2/f3, progression, ordre des dégâts et des cumuls depuis une source qualifiée.
2. Implémenter les dégâts magiques et le producteur de cumuls dans le chemin d’impact réellement consommé.
3. Vérifier les états0/1/2, le plafonnement, le rafraîchissement et les limites exactes de quatre secondes.
4. Vérifier l’alternance de cible, plusieurs Orianna, les résistances, boucliers, immunités et interactions on-hit.
5. Vérifier les annulations/projectiles interrompus, plusieurs niveaux/AP, mort/respawn et nettoyage.
6. Résoudre les divergences NoBall/Yomu et qualifier la Balle, son retour, sa distance et QWER séparément.
7. Qualifier HUD, death recap, particules, animations, audio et réseau séparément du gameplay.

Les trois fiches restent ouvertes. Aucun serveur historique, rendu, audio ou transport réseau n’est qualifié ici. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision614_trace_review/REVIEW.json. V613 Orianna / Clockwork Windup : 67 sources natives, 201 associations, 24 points et 48 liens. Le texte natif décrit des dégâts magiques f2 + f1%AP, puis +20% sur la même cible pendant 4 secondes, jusqu’à 2 cumuls ; f1/f2/f3 restent non résolus. Deux cas publics sans objet/Tome1052+20AP : 14 impacts à distance, 54 refus atomiques, 242 ticks d’attente et quatre trajets réussis. Chaque impact inflige seulement 33,86008 dégâts physiques, sans effet de la puissance ni des attaques répétées ; intervalle de 46 ticks dans les séries et 137 entre elles. Aucun sort Orianna accepté. 26 Lua entièrement parcourus dont 5 limites NEWTABLE, 19 preloads, 7 clés BuffData résolues et 25 références communautaires. CharScripts natifs et communautaire vides. NoBall conserve des noms Yomu dans le preload et des régénérations de mana différentes ; aucune substitution implicite. Six candidats absents ne prouvent pas un manque global d’assets. Q communautaire en cône 65+0,4AP contre 60+0,5AP natif ; W/R utilisent targetPos, R Airborne ne qualifie pas une attraction. La Balle et les piles de passif restent non qualifiées. V564 et les deux échecs V606 restent ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT : 0 ; 72+4 refus de publication. Prochain passif à inspecter réellement : Pantheon. Goal actif.
