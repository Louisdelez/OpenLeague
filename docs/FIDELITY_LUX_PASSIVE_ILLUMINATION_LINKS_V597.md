# Lux — sources et consommateurs d’Illumination, V597

Date UTC : 2026-10-26T07:43:34.235450+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches du passif enrichies : **37 sources natives, 111 associations, 22 points de code et 44 liens**. Quatre preuves ajoutées au registre. Trois questions propres, quatre dépendances, statuts et critères conservés.

Deux scénarios publics du moteur vérifient **six projectiles et impacts physiques ordinaires, 54 refus atomiques et 360 ticks d’attente**. Aucun sort de Lux n’est accepté ; aucune marque n’a été appliquée. La consommation, l’expiration et le déclenchement/rafraîchissement par R ne sont donc pas exercés. Aucun gameplay ni asset modifié.

## Sources natives

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées pour les fichiers ci-dessous ; montage historique et serveur original non déduits de cette appartenance.

| Fichier | Identité source |
|---|---|
| Lux.inibin | OLS-da8db83e-36d0-564c-b35d-556912f7b4c4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptLux.luaobj | OLS-c7c72328-6430-5cd0-b5fe-bd5b537d49c3 |
| CharScriptLux.preload | OLS-2dfdbc72-f481-59b7-b26c-8f67d8f087b7 |
| LuxBasicAttack.inibin | OLS-4728234d-19cc-5e0e-8180-069cbacac746 |
| LuxBasicAttack.luaobj | OLS-b7f9b3d7-137f-5157-965f-26c56798b0bc |
| LuxBasicAttack2.inibin | OLS-21f82108-85ce-56c9-a330-ea8ef3dba259 |
| LuxBasicAttack2.luaobj | OLS-5955c570-079b-52fb-ab2d-93850e527224 |
| LuxCritAttack.inibin | OLS-b4f7d73c-bd49-59f7-913d-769621bb79c9 |
| LuxCritAttack.luaobj | OLS-a709d45e-2403-5f97-a88a-8fa1ab437907 |
| LuxEEnd.inibin | OLS-f5209590-9b74-554c-84af-f6a5da870357 |
| LuxIlluminatingFraulein.inibin | OLS-b7400af4-a6e2-5405-916a-cbbc989f64ed |
| LuxIlluminatingFraulein.luaobj | OLS-c64b5689-482f-5c08-9d97-8dd4d20993aa |
| LuxIlluminationPassive.inibin | OLS-8cbc0350-1fcc-51ec-8c6f-07671770a080 |
| LuxIlluminationPassive.luaobj | OLS-40c8dd4d-1a95-5b58-b0d7-1cc062fda990 |
| LuxIlluminationPassive.preload | OLS-e8afd03d-e813-5015-b7a1-baa17e6115e3 |
| LuxLightBinding.inibin | OLS-7ae58601-aeb4-55bf-a12e-4782bc6d1e4c |
| LuxLightBinding.luaobj | OLS-9e3b34e4-f42a-57cd-b768-a1e7d4fe284c |
| LuxLightBindingDummy.inibin | OLS-be8091f1-6c8b-5080-a8e8-8e278af8ece8 |
| LuxLightBindingDummy.luaobj | OLS-e9ce4b02-572d-50cf-ace8-8ed7d10ccddc |
| LuxLightBindingMis.inibin | OLS-6e2f5a4f-17fd-5044-874c-5f08fca54108 |
| LuxLightBindingMis.luaobj | OLS-e38f9e2b-8918-556b-811a-99daab2ca4ca |
| LuxLightBindingMis.preload | OLS-edc246f7-4e81-53d7-9965-cd577375f07b |
| LuxLightStrikeKugel.inibin | OLS-7ded5c48-4861-5a79-aed1-f2a5b9583746 |
| LuxLightstrikeKugel.luaobj | OLS-2acea56d-cc3f-5ee8-879c-155c55f927ca |
| LuxLightstrikeKugel.preload | OLS-c4d9fd3a-6431-5986-a021-e92065c53129 |
| LuxLightstrikeToggle.inibin | OLS-6f1e84df-4ac1-5b52-9889-7015778660a4 |
| LuxLightstrikeToggle.luaobj | OLS-99fb3c79-023b-53e3-a80a-b97d7ed6e7cf |
| LuxMaliceCannon.inibin | OLS-a82039d6-44ab-5f61-b8e1-6c2434f0929a |
| LuxMaliceCannon.luaobj | OLS-e642d109-07a4-5d70-87d3-52232b2cd92d |
| LuxMaliceCannon.preload | OLS-60a0a860-af80-5279-b2c2-f29b6d767da9 |
| LuxMaliceCannonMis.inibin | OLS-6956c014-b119-554a-ab27-e2b523c64872 |
| LuxMaliceCannonMis.luaobj | OLS-aeddb27d-591d-56fc-8876-f19bbd9eaa13 |
| LuxMaliceCannonMis.preload | OLS-2be100e0-31bf-5e4e-9c68-6380a55d703c |
| LuxPrismaticWave.inibin | OLS-72f79c7d-f7f2-5b94-b773-75add160861f |
| LuxPrismaticWave.luaobj | OLS-a0eb1607-a1fc-553b-8f37-c433275fb109 |
| LuxPrismaticWave.preload | OLS-31fe359a-88d6-59a2-9330-d0f6a50f1630 |

- `Lux.inibin` lie `LuxIlluminationPassive`, `LuxIlluminatingFraulein.dds` et la description passive ligne **4227**. Les six champs de niveau passif sont absents. Q/W/E/R désignent respectivement LightBinding, PrismaticWave, LightStrikeKugel et MaliceCannon.
- Buff passif ligne **2241** : les sorts infligeant des dégâts appliquent **six secondes** d’Illumination ; les attaques de Lux déclenchent des dégâts magiques et consomment la marque. **`@f1@` et `@f2@` restent non résolus.** La description du personnage mentionne une dépendance au niveau de Lux.
- Buff cible `LuxIlluminatingFraulein`, ligne **2240** : prochaine attaque normale de Lux sur cette cible. Ce fichier est distinct du passif du porteur. Les deux autres liaisons BuffData sont `LuxEEnd` ligne **2239** (détonation du E) et `LuxLightBindingMis` ligne **2242** (immobilisation). **Quatre liaisons de buff, toutes résolues.**
- R : description ligne **9606**, tooltip ligne **11700**. Les deux textes indiquent qu’il déclenche puis rafraîchit Illumination. Les événements et leur ordre ne sont pas reconstitués à partir des textes seuls.
- **14 Lua** parcourus structurellement, entièrement consommés, sans prototype enfant. Deux initialisations littérales : CharScript vide et métadonnées du passif. **Douze limites NEWTABLE** : attaques normale/normale2/critique au pc0, marque au pc8, Q au pc14, QDummy au pc0, QMis au pc10, E au pc6, réactivation E au pc2, R et RMis au pc6, W au pc2. Limites du lecteur, sans preuve de corruption ni d’exécution du serveur.
- Le passif déclare `DoesntBreakShields=false`, `DoesntTriggerSpellCasts=true`, son icône, son nom, `PersistsThroughDeath=true` et `NonDispellable=true`. **La persistance du porteur ne définit pas la durée de la marque sur la cible.** Ces booléens ne qualifient pas à eux seuls les interactions de bouclier/proc.
- **Sept preloads** : CharScript, passif, QMis, E, R, RMis et W. QMis/E/RMis référencent la marque `luxilluminatingfraulein` ; passif et RMis référencent `luxpassive_tar.troy`. Les dépendances de présentation et helpers R restent du contexte, sans acceptation de rendu ni de gameplay.
- Les deux INIBIN du passif et de la marque portent `Coefficient=0` et `Coefficient2=0`. **Cela ne prouve pas des dégâts nuls**, puisque le texte dépend de deux variables et du niveau. Leurs valeurs communes de portée/rayon/vitesse et coût/recharge nuls restent des champs de ces ressources, sans adoption comme politique complète du passif.
- R principal : coefficient **0,75**, recharge rang 1 **80**, coût **100**, portée **25000**, rayon **250**. RMis : coefficient voisin de **0,7**, recharge **60**, coût **0**, portée **3500**, rayon voisin de **299,3**. Vitesse **3000** dans les deux ressources. Les valeurs restent séparées ; aucune série n’est choisie arbitrairement comme règle finale de R ou du passif.
- Les quatre clés **SpellData Description/DynamicTooltip** des deux fichiers `LuxIlluminationPassive.inibin` et `LuxIlluminatingFraulein.inibin` n’ont pas de texte correspondant dans le catalogue sélectionné. Leurs textes **BuffData**, eux, sont présents. Aucune clé absente n’est remplacée silencieusement.
- **20 références communautaires** présentes et hachées séparément. Le CharScript communautaire de Lux est vide ; il n’établit pas l’application ou la consommation originales de la marque.
- **26 fichiers NightmareBotLux repérés et exclus du contrat standard**. Ils sont une variante de scénario, pas une substitution autorisée au passif normal. Leur recensement ne constitue pas une qualification de leurs contenus.

Cinq chemins candidats absents : `Lux.ddf` dans le personnage, CharScript à sa racine, INIBIN passif dans un sous-répertoire de sorts du personnage, preload de la marque globale et Lua de LuxEEnd. Les chemins effectivement présents sont documentés. Ce constat borné n’établit pas un manque global de carte, modèles, textures ou animations.

## Exécution actuelle

Compilation privée `cargo build --locked --offline`, vrai core non-test, paquets et checksums alignés sur le lock racine. **1 158 entrées** de code/ressources et chaîne de preuves précédentes vérifiées sans changement.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-lux-passive-illumination-probe.exe` ; **6039552 octets**, SHA-256 `94d0ce38507fc777d5f8526c05dc2620cbecab3c2ee96363e33c5859235a908f`.

Deux parties Map10 neuves, Lux contre Annie. Cas de base puis achat public de l’ouvrage 1052, **+20 puissance**. Déplacements publics vers la zone centrale, trois attaques puis Stop et 180 ticks d’attente par cas. Aucune injection de position, temps, rang, sort ou marque.

| Cas | AD | Puissance | Impacts physiques | Projectiles Lux | Refus | Attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 53.54400 | 0.0 | 3 | 3 | 27 | 180 |
| Tome_AP_control | 53.54400 | 20.0 | 3 | 3 | 27 | 180 |

**Contrôle nominal ordinaire attendu et observé :** six impacts avec témoins de projectile Lux→Annie, aucun critique, dégâts physiques conformes à AD/armure après correction de régénération ; écart inférieur à 0,002. AD **53,5439987183** dans les deux cas. L’achat ajoute 20 puissance sans démontrer la formule passive. Trois identités de projectile du propriétaire sont relevées par cas ; aucun dégât supplémentaire entre les impacts ou durant l’attente.

**Contrat passif attendu :** application par sort infligeant des dégâts, consommation par attaque, durée de six secondes, déclenchement et rafraîchissement par R. **Observé : précondition absente**, tous les sorts de Lux étant refusés. Des attaques sans marque ne qualifient ni la consommation ni la formule d’Illumination. Les 180 ticks après Stop ne constituent pas une mesure d’expiration d’une marque réelle.

**54 refus atomiques :** joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt QWER avant les attaques puis après l’attente. Chaque refus conserve le snapshot. Le dispatch de progression et celui des sorts confirment l’absence de prise en charge de Lux dans ces voies courantes.

Mana au plafond **334**, rangs/recharges nuls, joueurs vivants niveau 1, sans stun/ralentissement, décès ou fin de partie. Aucun gameplay historique, transport réseau, rendu, HUD, animation ou audio accepté par ces essais.

## Consommateurs

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD,AP and target resistance |
| crates/core/src/progression.rs:150 | unsupported Lux learning |
| crates/core/src/progression.rs:159 | unsupported Lux rank policy |
| crates/core/src/spells.rs:101 | unsupported Lux cast |
| crates/core/src/annie_w.rs:29 | unsupported Lux ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary ranged launch and impact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public Tome20AP control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not mark consumption timing |
| crates/core/src/critical.rs:12 | ordinary critical profile;Illumination critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not Illumination passive recap source |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted Illumination attribution |

Les points d’attaque, impact physique, mitigation et régénération expliquent les observations ordinaires. Statistiques/boutique expliquent +20 puissance ; progression/sorts expliquent les refus. Critiques et récapitulatif restent des frontières de contexte, sans qualification du passif. **Aucun de ces 22 points n’est présenté comme un consommateur complet d’Illumination.**

Sept ressources locales sont liées : catalogue champions, croissance, ressources, attaques, critiques, collision et boutique. Elles restent distinctes des règles natives recherchées.

## Travail restant

1. Qualifier les événements Q/E/R appliquant la marque et les cibles admissibles ; distinguer sorts sans dégât, boucliers et immunités.
2. Résoudre `@f1@`/`@f2@`, niveau de Lux, puissance et dégâts par cible ; ne pas adopter les coefficients nuls comme politique de dégâts.
3. Implémenter l’état de marque par cible/propriétaire, renouvellement, remplacement, simultanéité et durée depuis une application réelle.
4. Qualifier consommation à l’attaque ou à l’impact, attaques annulées, projectiles déjà lancés, Stop, cible morte/disparue, portée et visibilité.
5. Qualifier le R avec et sans marque préalable : ordre des dégâts, consommation, nouvelle application et rafraîchissement ; conserver les ressources principale/missile distinctes.
6. Qualifier dégâts magiques, résistance/pénétration, boucliers, invulnérabilité, procs, critiques et objets, sans récursion.
7. Vérifier plusieurs cibles, collisions et réactivation/explosion E ; les preloads de marque ne suffisent pas à prouver leur déclenchement.
8. Qualifier attribution kill/assist/récapitulatif et nettoyage au décès, respawn, déconnexion et fin de partie.
9. Résoudre les clés de texte absentes et les douze limites du lecteur, sans substitution NightmareBot ni invention d’une source DDF.
10. Vérifier séparément marque visuelle, HUD/icône, animation, effet d’impact, son et réseau.

Les inconnues restent ouvertes. Le défaut de déplacement V564 et les lacunes Battle Training restent suivis dans leurs preuves antérieures.

## Livraison et conservation

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0. **72 associations invalides et quatre graphes invalides refusés**. Trois fragments génériques de consignes changés, 42 212 inchangés ; notice SYS actualisée séparément.

Dans chacune des deux bases : quatre destinataires actualisés, **42 603 autres lignes, 42 607 états manuels et 23 historiques conservés** ; synchronisation normale idempotente. Identités, hiérarchie et inconnues byte-exactes ; trois questions propres et quatre dépendances conservées. Aucun statut ou case coché automatiquement.

Graphe : **99 065 sources, 3 935 consommateurs, 42 215 exigences actives, 26 189 inconnues ouvertes et 5 517 résolues antérieurement**. **3 935 ancres exactes, aucune divergence courante**. Contrôle structurel global distinct du hachage des sources sélectionnées ; pas de nouveau recensement exhaustif des contenus de toutes les sources.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/lux-passive-illumination-links-v597.json` ; preuve `docs/fidelity_lux_passive_illumination_links_v597.json` ; ce rapport ; couverture/plan/reprise, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, consignes ciblées des deux bases et note privée. Aucun gameplay ou asset modifié.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision597_Lux_discovery`, `revision597_Lux_passive_probe`, `revision597_Lux_inspection_qualified`, `revision597_Lux` et `revision598_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision598_trace_review/REVIEW.json. Lux V597 intégré et audité :37sources111associations22points44liens. Deux cas publics base/Tome20AP :6impacts physiques de6projectiles,54refus,360ticks. Aucun sort accepté ni marque appliquée ;consommation,expiration6sec et R déclenchement/rafraîchissement non exercés. Texte natif6sec,@f1@/@f2@ et R lié ;formules non résolues.14Lua dont12limites NEWTABLE,7preloads,4buffs résolus20références communautaires ;CharScript vides. Quatre clés SpellData du passif absentes,cinq chemins candidats absents dont Lux.ddf. Coefficients passifs0 ne valent pas dégâts0 ;R principal0.75/recharge80 et missile0.7/recharge60 distincts.26NightmareBot exclus. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver preuves et défaut V564. Prochain passif à inspecter réellement : Malphite. Goal actif ;aucun statut/case/inconnue fermé.
