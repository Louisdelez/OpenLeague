# Malphite — sources et consommateurs de Granite Shield, V598

Date UTC : 2026-10-26T08:00:55.143013+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, liaison des exigences aux sources natives et aux consommateurs actuels.

## Résultat

Trois fiches du passif enrichies : **39 sources natives, 117 associations, 27 points de code et 54 liens**. Quatre sources de preuves ajoutées. Trois questions propres et quatre dépendances conservées ; statuts et critères inchangés.

Deux scénarios publics observent **six impacts physiques, deux Q d’Annie acceptés, 102 refus Malphite et 602 ticks sans nouveaux dégâts**. Les listes de boucliers de Malphite restent vides, notamment aux offsets **299/300/301 après le dernier impact magique**. Aucun Granite Shield généré. Le moteur possède des fonctions générales de bouclier, mais leur présence ne constitue pas le déclenchement du passif.

Aucun gameplay ni asset modifié. Les manques documentés concernent la production du bouclier, ses règles de remise à zéro et leur qualification ; aucun manque global de modèles ou de textures n’est établi.

## Sources natives

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées ; ordre de montage et serveur historique non déduits de cette appartenance.

| Fichier | Identité source |
|---|---|
| Malphite.inibin | OLS-04a57042-a14d-5eee-83e5-1a91781a1949 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Malphite.ddf | OLS-644c7fcb-cf88-5fb2-8ed2-be3687d39dcc |
| CharScriptMalphite.luaobj | OLS-117643d1-4e8a-5a9e-acf7-630df79dbaa5 |
| CharScriptMalphite.preload | OLS-e35634d2-34f3-55b6-a6ab-9304c931a650 |
| Landslide.inibin | OLS-a4886a5e-9ffa-5684-a920-6b79cc2b67ce |
| Landslide.luaobj | OLS-7d73485d-c2c7-58ff-9017-9cce0b357fca |
| Landslide.preload | OLS-ec53dace-8741-5fed-bd22-84e4b5753510 |
| Malphite Shield Cooldown.inibin | OLS-0d9d1bb9-b225-56b8-bac4-a62acab812dc |
| MalphiteBasicAttack.inibin | OLS-0f7e9c16-57ba-5448-8193-5a3fd6b0a266 |
| MalphiteBasicAttack.luaobj | OLS-f33fd1aa-1491-5bfa-931f-3bb0eff5d315 |
| MalphiteBasicAttack.preload | OLS-cc339984-fb73-5108-9a82-2d0fea0b940f |
| MalphiteBasicAttack2.inibin | OLS-f14588fc-c82d-58e3-b902-920dff613dd4 |
| MalphiteBasicAttack2.luaobj | OLS-c419ec15-f481-5a86-99bc-1784c6df684d |
| MalphiteBasicAttack2.preload | OLS-691670ba-ff14-5f3a-aac4-12db4bfcee3b |
| MalphiteCritAttack.inibin | OLS-07570173-4dc4-59d5-b364-f701bad64fde |
| MalphiteCritAttack.luaobj | OLS-814e3344-a7ed-549e-9ed9-bed14cb840c9 |
| MalphiteCritAttack.preload | OLS-0f0eada5-9032-54d5-8a83-f0e2b345b5d4 |
| MalphiteObduracyEffect.inibin | OLS-e3fbfc8d-daac-54cc-a52e-2062a858478a |
| MalphiteShield.inibin | OLS-3b8e4f47-0673-502a-a28b-2cab715bf23b |
| MalphiteShield.luaobj | OLS-9540dba7-d544-5d7a-958b-2c4529ce92bd |
| MalphiteShieldBeenHit.luaobj | OLS-03202627-ed9d-5f14-a900-e0bdfb3827cb |
| MalphiteShieldBeenHit.preload | OLS-acd499c4-56ba-508f-9e8d-a34b15af7708 |
| MalphiteShieldEffect.luaobj | OLS-f477368e-081e-5800-952f-24f1936e4997 |
| MalphiteShieldEffect.preload | OLS-2d85e5d9-5de2-519f-90cb-4a2335953d18 |
| MalphiteShieldRemoval.luaobj | OLS-694b61e5-18bb-596b-9682-deaf1f8178e3 |
| MalphiteShieldRemoval.preload | OLS-36ce8568-37d2-5054-9b81-699a4c0d868e |
| Obduracy.inibin | OLS-1ad9ccce-db4a-583b-8125-5eb3f77ce950 |
| Obduracy.luaobj | OLS-7b9b62b2-d6f2-5ac3-8814-c5b37e3d4958 |
| Obduracy.preload | OLS-714ff4bd-a5a6-5b2b-8fcf-e548a604b55a |
| ObduracyBuff.inibin | OLS-8af81edb-8260-50f6-bd05-925afe644a58 |
| ObduracyBuff.luaobj | OLS-3ce15492-b18e-5c91-ab24-21ffbd799ed8 |
| ObduracyBuff.preload | OLS-f810786b-b398-5973-960c-aed1c5946b85 |
| SeismicShard.inibin | OLS-a78738dd-11b7-5ea9-a2eb-7ee9a4278a97 |
| SeismicShard.luaobj | OLS-79db3bb4-3510-56ca-a276-4841eced3c13 |
| SeismicShard.preload | OLS-30e13ff3-a8ca-5167-b160-b20ff27d1ee8 |
| UFSlash.inibin | OLS-a400f075-39d9-559b-a763-99aa255381f8 |
| UFSlash.luaobj | OLS-aa62c113-5485-5ac7-b495-081eaec7bb58 |
| UFSlash.preload | OLS-b2941742-ccd9-58f0-97d1-2d80af5c2fc5 |

- `Malphite.inibin` lie **MalphiteShield**, **Malphite_GraniteShield.dds** et la description ligne **4228** : absorption de **10 % des PV maximum**, rechargement après **dix secondes sans être touché**.
- Buff `MalphiteShield`, ligne **2256** : formulation « ne pas subir de dégâts », durée **`@f2@`**, quantité **`@f1@`** explicitement décrite comme 10 % des PV maximum. Les producteurs des deux variables et la distinction exacte coup reçu/dégâts effectifs restent à qualifier.
- Recharge `Malphite Shield Cooldown`, ligne **2251**, et effet de protection `MalphiteObduracyEffect`, ligne **2255**, sont des sources distinctes. Le quatrième BuffData sélectionné est SeismicShard, ligne **2599**, contexte de vol de vitesse. **Quatre liaisons de buff, toutes résolues.**
- Le même fichier personnage conserve `Passive1=9`, une ancienne description **Jax**, les textes **+40/+60/+80 % de régénération de mana**, et niveaux **3/7/11/15/absent/absent**. Ces valeurs sont conservées sans adoption comme progression ou règles de Granite Shield.
- **13 Lua** parcourus structurellement, entièrement consommés, sans prototype enfant. Quatre initialisations littérales : CharScript vide, Shield, BeenHit et Removal. **Neuf limites NEWTABLE** : Landslide pc10, trois attaques pc0, ShieldEffect pc8, Obduracy pc10, ObduracyBuff pc12, SeismicShard pc4, UFSlash pc6. Limites du lecteur, sans preuve de corruption ou d’exécution serveur.
- Shield déclare icône normale, nom, persistance et non-dissipation. BeenHit déclare **Malphite_GraniteShield_Grey.dds** et le nom **Malphite Shield Cooldown**. Removal porte un effet d’activation vide et des indicateurs de persistance/non-dissipation. Aucun de ces champs ne prouve le comportement à la mort ou au respawn.
- **12 preloads** : le cycle Effect→Removal/BeenHit, BeenHit→Effect et les références de CharScript sont identifiés. Removal référence `Malphite_Base_obduracy_off.troy` et `root`. Les trois attaques référencent **`leona_basicattack_hit.troy`** : dépendance ancienne conservée, sans substitution ni acceptation du rendu.
- **Quatre lignes DDF**, toutes Landslide : `f1 → armor × 0.3`, `f2 → spelldamage × 0.2`, deux liens/coefficients vides. Ce contexte du E n’est pas une formule de bouclier. Q/W/E/R sont SeismicShard, Obduracy, Landslide et UFSlash.
- **17 références communautaires** présentes et hachées séparément. Le CharScript communautaire de Malphite est vide ; il ne fournit pas le cycle de bouclier original.

Six chemins candidats absents : CharScript à la racine du personnage, INIBIN passif dans un sous-répertoire de sorts du personnage, preload Shield et INIBIN BeenHit/Effect/Removal globaux. Les Lua/preloads réellement présents sont identifiés ; l’absence de ces chemins ne démontre pas une ressource globale manquante.

## Exécution du moteur actuel

Compilation privée `cargo build --locked --offline`, vrai core non-test, paquets/checksums alignés au lock racine. **1 158 entrées** de code/ressources et chaîne de preuves précédentes vérifiées sans changement.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-malphite-passive-granite-shield-probe.exe` ; **6056960 octets**, SHA-256 `30c15bba6e5e23530c89688d5e21e1e0476e0f4137a95b47436fae94c2e6e236`.

Deux parties Map10 neuves : Malphite reçoit les attaques d’Annie. Base puis achat public du rubis 1028, **+150 PV maximum**. Déplacements publics vers la zone centrale, apprentissage public du Q d’Annie. Trois attaques d’Annie, Stop, un Q accepté, puis **301 ticks sans nouveaux dégâts**. Aucune injection de temps, position, rang, dégâts ou bouclier ; `grant_shield` n’est pas appelé artificiellement dans ces scénarios.

| Cas | PV maximum | Référence théorique 10 % | Impacts physiques | Impacts magiques | Refus Malphite | Attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 574.20001 | 57.42000 | 3 | 1 | 51 | 301 |
| Ruby_HP_control | 724.20001 | 72.42001 | 3 | 1 | 51 | 301 |

**Contrôle nominal attendu et observé :** six impacts avec témoins de projectiles Annie→Malphite, sans critique ; dégâts physiques conformes à AD/armure après correction de régénération, écart inférieur à 0,002. Chaque Q est accepté avec état de lancement enregistré, **80 dégâts bruts et 60 mana consommés** ; les deux pertes de vie correspondent aux dégâts magiques après résistance et régénération, écart inférieur à 0,002.

**Contrat passif attendu :** bouclier de 10 % des PV maximum et reconstruction après la période native sans coup/dégât. **Observé :** listes de boucliers vides pendant les contrôles et après dix secondes sans nouveaux dégâts, aux offsets **299/300/301** à 30 ticks/s depuis le dernier impact Q. Les valeurs **57,42000198** et **72,42000580** sont des calculs de référence à partir des PV maximum actuels ; elles ne sont pas présentées comme des boucliers observés.

**102 refus atomiques** : joueur inconnu, attaque sur soi, slot invalide et Learn/Cast/CastAt QWER de Malphite avant les dégâts puis aux trois offsets. Chaque refus conserve le snapshot. Les rangs/recharges de Malphite restent nuls et son mana au plafond **282,200012207**. Les deux Q acceptés appartiennent à Annie ; aucun sort de Malphite n’est accepté.

Les joueurs restent vivants au niveau 1, sans stun/ralentissement, décès ou fin de partie. Pendant les 602 ticks d’attente, les variations de vie correspondent uniquement à la régénération. Ce contrôle ne qualifie pas la remise à zéro sur dégâts nuls, dégâts absorbés, immunité, DoT, événements simultanés ou changements de PV maximum en présence d’un bouclier actif.

Aucun serveur historique, réseau, rendu, HUD, animation, VFX ou audio accepté par ces essais.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary maximumhealth andincoming damage resistance |
| crates/core/src/progression.rs:150 | unsupported Malphite learning |
| crates/core/src/progression.rs:159 | unsupported Malphite rank policy |
| crates/core/src/spells.rs:101 | unsupported Malphite cast |
| crates/core/src/annie_w.rs:29 | unsupported Malphite ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | incoming physical/magical damage andgeneric shield absorption |
| crates/core/src/attacks.rs:157 | Annie ordinary ranged attack launch andimpact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | Malphite regeneration correction |
| crates/core/src/shop.rs:261 | public Ruby150HP control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary incoming attack windup profile |
| crates/core/src/critical.rs:12 | ordinary critical profile;GraniteShield critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not shield-specific recap source |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted GraniteShield attribution |
| crates/core/src/shields.rs:12 | generic authoritative shield API,static context;not invoked as Malphite passive |
| crates/core/src/shields.rs:41 | generic expiry/cleanup;no Malphite producer qualified |
| crates/core/src/shields.rs:47 | generic absorption boundary;empty shields in ordinary cases |
| crates/core/src/annie.rs:45 | accepted opposing Annie Q raw80 cost60 |
| crates/core/src/annie.rs:73 | opposing magic missile impact before no-damage wait |

`apply_damage` appelle la mitigation puis `absorb_shields` ; les scénarios traversent cette frontière avec des listes vides. `advance_shields` assure la maintenance générique. `grant_shield` existe comme API d’événement serveur et est relié en **contexte statique**, sans appel artificiel ni producteur Malphite démontré. Une capacité générique ne vaut pas implémentation du passif.

Le lancement et l’avancement du Q d’Annie sont exercés pour les dégâts magiques entrants. Attaques, statistiques, boutique et régénération expliquent les autres observations. Les 27 points restent explicitement des frontières actuelles ; aucun n’est présenté comme consommateur complet de Granite Shield.

Huit ressources locales liées : catalogue champions, croissance, ressources, attaques, critiques, collision, boutique et règles Q d’Annie. Elles ne remplacent pas les règles du bouclier natif.

## Travail restant

1. Relier un véritable producteur Malphite au système de bouclier ; définir état initial, début de partie et respawn.
2. Résoudre `@f1@`/`@f2@`, montant selon les PV maximum et moment du calcul ; vérifier achats/ventes, niveaux et variations temporaires.
3. Qualifier la distinction coup reçu/dégât effectif, les sources qui remettent le délai à zéro, immunités, dégâts nuls et dégâts déjà absorbés.
4. Vérifier délai de dix secondes depuis un événement réel, coups répétés, remise à zéro juste avant échéance et événements simultanés.
5. Qualifier mitigation, absorption partielle/totale, rupture et débordement pour dégâts physiques, magiques et bruts.
6. Qualifier priorité/empilement avec d’autres boucliers et interaction W/armure ; ne pas assimiler le DDF Landslide au passif.
7. Définir cycle Shield/Effect/BeenHit/Removal, persistance et nettoyage au décès, déconnexion et fin de partie.
8. Vérifier attribution des dégâts, événements de combat et récapitulatif, sans substituer une API artificielle au passif.
9. Étendre le lecteur pour les neuf blocs NEWTABLE si nécessaire et conserver les métadonnées anciennes sans adoption arbitraire.
10. Vérifier séparément icône normale/grise, compteur de recharge, HUD de bouclier, rupture/reconstruction, animation, particules, son et réseau.

Trois questions propres et quatre dépendances conservées. Défaut de déplacement V564 et lacunes Battle Training toujours suivis dans leurs preuves antérieures.

## Livraison et conservation

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0. **72 associations invalides et quatre graphes invalides refusés**. Trois fragments génériques de consignes changés, 42 212 inchangés ; notice SYS actualisée séparément.

Dans chacune des deux bases : quatre destinataires actualisés, **42 603 autres lignes, 42 607 états manuels et 23 historiques conservés** ; synchronisation normale idempotente. Identités, hiérarchie et inconnues byte-exactes. Aucun statut, critère ou case coché automatiquement.

Graphe : **99 069 sources, 3 962 consommateurs, 42 215 exigences actives, 26 189 inconnues ouvertes et 5 517 résolues antérieurement**. **3 962 ancres exactes, aucune divergence courante**. Revue structurelle globale distincte du hachage des contenus sélectionnés ; pas de nouveau recensement exhaustif de toutes les sources.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/malphite-passive-granite-shield-links-v598.json` ; preuve `docs/fidelity_malphite_passive_granite_shield_links_v598.json` ; ce rapport ; couverture/plan/reprise, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, consignes ciblées des deux bases et note privée. Aucun gameplay ou asset modifié.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision598_Malphite_discovery`, `revision598_Malphite_passive_probe`, `revision598_Malphite_inspection_qualified`, `revision598_Malphite` et `revision599_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision599_trace_review/REVIEW.json. Malphite V598 intégré et audité :39sources117associations27points54liens. Deux cas publics base/Ruby150PV :6impacts physiques2QAnnie acceptés80raw60mana,102refus Malphite,602ticks sans nouveaux dégâts. Boucliers vides299/300/301aprèsdernierQ ;aucun GraniteShield généré. Texte10%PVmax/10sec sanscoup ettooltip sansdégât@f1@/@f2@ lié ;producteurs etresetexact ouverts.13Lua dont9limites NEWTABLE,12preloads,4buffs résolus,4DDFLandslide17communautaires ;CharScript vides. Jax,mana40/60/80%,niveaux3/7/11/15 etparticuleLeona conservés sansadoption. Six chemins candidats absents. Fonctions génériques grant/advance/absorb liées mais pas producteurMalphite démontré. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver preuves et défautV564. Prochain passif à inspecter réellement : Malzahar. Goal actif ;aucun statut/case/inconnue fermé.
