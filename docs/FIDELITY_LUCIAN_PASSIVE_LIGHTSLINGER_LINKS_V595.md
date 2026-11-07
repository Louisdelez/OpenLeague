# Lucian — sources et consommateurs de Lightslinger, V595

Date UTC : 2026-10-26T07:12:31.019915+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, liaison des exigences aux sources natives et aux consommateurs actuels.

## Résultat

Trois fiches du passif enrichies : **35 sources natives, 105 associations, 22 points de code et 44 liens**. Quatre sources de preuves ajoutées. Trois questions propres, quatre dépendances, statuts et critères conservés.

Six impacts ordinaires sont vérifiés, mais **aucun sort de Lucian n'est accepté**. Le passif n'est pas armé : second tir, expiration, critiques passifs, classes de cibles et effets à l'impact ne sont pas qualifiés. Aucun gameplay ou asset modifié.

## Sources natives et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées ; priorité de montage et serveur historique non déduits de cette appartenance.

| Fichier | Identité source |
|---|---|
| Lucian.inibin | OLS-5cf9b03b-6e6d-5516-b7c2-88ba3e575c2b |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Lucian.ddf | OLS-93e04b6c-ebc6-5f7e-a61a-9c1caf330bdf |
| CharScriptLucian.luaobj | OLS-4c0305ab-2f32-5e4a-a674-738b5cbe9d33 |
| CharScriptLucian.preload | OLS-2cc48310-2216-5f62-a194-b2b1facae99f |
| LucianPassive.inibin | OLS-61e25ce3-b4b8-5997-9aa4-fa9f76845c4f |
| LucianPassive.luaobj | OLS-97fa513e-ed82-5d7a-9b54-90f79bd65798 |
| LucianPassiveAttack.inibin | OLS-a4183e60-aaae-5c8e-b1bf-cf478bd01645 |
| LucianPassiveAttack.luaobj | OLS-2a562ed8-08c6-5658-9380-8fa2eff4674d |
| LucianPassiveBuff.inibin | OLS-c6447756-a9ea-597b-bffb-6644b69a2603 |
| LucianPassiveBuff.luaobj | OLS-4c951e54-6030-58f7-ab1e-f791d6b12790 |
| LucianPassiveShot.inibin | OLS-cb58fe20-f838-5bf6-a461-33a0f3b58fdc |
| LucianPassiveShot.luaobj | OLS-d3d4a5af-f004-544c-82ab-7d33b212bf89 |
| LucianPassiveShotDummy.inibin | OLS-09ddf0db-3dca-5afb-8469-58dca18789f5 |
| LucianPassiveShotDummy.luaobj | OLS-13a93123-0356-57f2-bcf8-9b52da52a827 |
| LucianPassiveBuff.preload | OLS-1e110a3b-98f0-5d1f-bad8-107c6167b725 |
| LucianPassiveShot.preload | OLS-015bbddb-90f8-58d3-a882-f0cad2aed0b7 |
| LucianQ.inibin | OLS-2b99061f-a9e8-579a-b234-73d1dd148ce6 |
| LucianQ.luaobj | OLS-24136d32-c59e-5c30-b8da-906a1d5780e8 |
| LucianW.inibin | OLS-013e9761-44c6-555b-8ee8-0f5f49d2f9ee |
| LucianW.luaobj | OLS-edc02e3e-a717-594f-a803-13b070616304 |
| LucianE.inibin | OLS-d8479886-280f-5e76-9bea-8acba82a9dcb |
| LucianE.luaobj | OLS-f3e73386-abdf-583a-a9a6-9a48b68f96e2 |
| LucianR.inibin | OLS-bd9d6e6e-d41f-58a7-ad47-8f3b713409ff |
| LucianR.luaobj | OLS-8f8da41f-f1bf-56dc-8705-4c8631a18677 |
| LucianW.preload | OLS-f710cd4e-f591-536b-8020-a80dacb5b83b |
| LucianE.preload | OLS-67b43c7c-547e-5662-a889-55325f752b3d |
| LucianR.preload | OLS-2b4a6848-a4f1-5cd9-a6b7-33007a13f97d |
| LucianBasicAttack.inibin | OLS-d21526f2-aabd-5c36-8419-fe5767db293e |
| LucianBasicAttack.luaobj | OLS-d7001dc7-dc4f-50aa-b7fb-c1f6a5f3d8b2 |
| LucianBasicAttack2.inibin | OLS-d950dacd-2cdd-5907-a7fc-4d80780cbf4a |
| LucianBasicAttack2.luaobj | OLS-6c6f6bc8-f5f7-557f-858f-559f8b6bfea5 |
| LucianCritAttack.inibin | OLS-32243555-f88f-598a-89a2-f5dd2b1df716 |
| LucianCritAttack.luaobj | OLS-6100a533-95f4-5999-bf1e-14c18fa45962 |
| LucianCritAttack2.inibin | OLS-e3a69fb8-8041-50a6-bd16-723b0ad1dfaf |

- `Lucian.inibin` lie `LucianPassive`, `Lucian_Passive.dds` et la description ligne **4225**. Six champs de niveau passif absents, sans valeur inventée.
- Buff passif ligne **2223** : après un lancement de sort terminé, prochaine attaque dans les **six secondes** en double tir. Second tir : **`@f1@` non résolu** contre champions et structures, dégâts complets contre sbires et monstres, application des effets à l'impact.
- Buff armé ligne **2224** : prochaine attaque en double tir. Le tooltip buff **Q, ligne 2225, répète le texte du passif** ; il n'est pas présenté comme formule de dégâts du Q. La clé **`game_buff_tooltip_LucianE` est absente** du catalogue sélectionné. Cinq liaisons de buffs, quatre résolues ; aucune substitution de la clé absente.
- **Treize Lua** parcourus structurellement, zéro prototype enfant. Quatre initialisations littérales qualifiées ; **neuf limites NEWTABLE** : PassiveAttack8, Shot8, Dummy0, Q4, W8, R10, BasicAttack0, BasicAttack2 0, CritAttack0. Ce sont des limites du lecteur, pas une preuve de corruption.
- Passive déclare **`25.dds`**, persistance et non-dissipation. PassiveBuff déclare **`Lucian_Passive.dds`**, `IsDamagingSpell=false` et `IsDeathRecapSource=true`. E déclare **`Draven_Bloodrage.dds`** et `IsDeathRecapSource=true`. Les noms anciens et les rôles distincts restent conservés ; leur présence ne qualifie pas le rendu ni l'attribution du double tir.
- Shot et ShotDummy portent un **Coefficient voisin de 1,2** en représentation numérique. Ce champ seul ne constitue pas la formule complète du second tir et ne résout pas `@f1@`.
- **Six preloads** : CharScript, PassiveBuff, PassiveShot, W/E/R. Buff référence `lucian_p_buf.troy` et `lucian_p_sound_only.troy`. Shot référence `rageblade` et `itemhurricaneattack` ; dépendances natives identifiées, sans preuve d'exécution ou de multiplicité de leurs effets.
- **84 lignes DDF**, incluant des noms anciens et de test, sans entrée LucianPassive. Aucun ancien nom n'est adopté comme sort jouable, aucune formule passive n'en est déduite.
- **19 références communautaires** identifiées et hachées séparément ; CharScript communautaire vide. Elles ne sont pas assimilées au code serveur original.
- **Sept chemins candidats absents** : CharScript sous `Scripts`, Passive INIBIN global, preloads Passive/PassiveAttack/PassiveShotDummy/Q et CritAttack2 Lua dans les sorts du personnage. Les fichiers réels sont identifiés sous le personnage ; cette liste n'est pas un audit global d'assets manquants.

## Exécution du moteur actuel

Compilation privée `cargo build --locked --offline` contre le vrai core non-test. Locks et checksums alignés ; **1 158 entrées** de code/ressources et chaîne de preuves antérieures conservées. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-lucian-passive-lightslinger-probe.exe`, **6034944 octets**, SHA-256 `14379fe38a5e149d16823afe2b28a7afd5682c7df2b22e62449e7aad44d1ebc6`.

Deux parties Map10 neuves, Lucian contre Annie : base puis achat public de l'épée longue 1036, **+10 AD**. Déplacements publics vers la zone centrale ; aucune injection de temps, position, rang ou charge passive. Trois attaques à distance puis Stop et **181 ticks** d'attente par cas.

| Cas | AD de base | AD observé | Impacts | Refus | Ticks attente |
|---|---:|---:|---:|---:|---:|
| base | 52.04000 | 52.04000 | 3 | 51 | 181 |
| Sword_AD_control | 52.04000 | 62.04000 | 3 | 51 | 181 |

**Attendu et observé pour les contrôles ordinaires :** six impacts, chacun avec un projectile Lucian→Annie témoin, sans critique. Dégâts correspondant à l'AD et à l'armure après correction de régénération, écart inférieur à 0,002. L'épée porte l'AD de **52,0400009155 à 62,0400009155**, sans démontrer un facteur de second tir.

**102 refus atomiques** : joueur inconnu, attaque sur soi, slot invalide et Learn/Cast/CastAt QWER avant les attaques puis aux offsets **179/180/181 après Stop**. Snapshots inchangés lors des refus. Ces offsets encadrent six secondes à 30 ticks/s ; Stop n'est pas un déclenchement passif démontré. Les rangs et recharges restent nuls.

**362 ticks d'attente** : santé cible conforme à la régénération ordinaire, mana Lucian au plafond, aucun ralentissement/stun, participants vivants niveau 1, aucune mort ni fin de partie.

**Contrat passif attendu :** un sort terminé arme la prochaine attaque en double tir, avec sa fenêtre et ses règles de cible. **Observé : précondition absente**, puisque les sorts restent refusés. Aucun second tir ni expiration d'une charge réelle n'est exercé. Les essais sur Annie ne qualifient pas les règles sbires/monstres/structures. Aucune qualification du serveur historique, réseau, HUD, rendu ou audio.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD and target resistance |
| crates/core/src/progression.rs:150 | unsupported Lucian learning |
| crates/core/src/progression.rs:159 | unsupported Lucian rank policy |
| crates/core/src/spells.rs:101 | unsupported Lucian cast |
| crates/core/src/annie_w.rs:29 | unsupported Lucian ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary ranged launch and impact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public LongSword10AD control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not second-shot spacing |
| crates/core/src/critical.rs:12 | ordinary critical profile;passive critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not Lucian passive recap source |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted double-shot attribution |

Progression et sorts expliquent les refus ; attaque, projectile, dégâts, mitigation et régénération expliquent les impacts ordinaires. Stats et boutique expliquent le +10 AD. Profils critiques et capture/commit du récapitulatif sont du contexte actuel ; ils ne démontrent ni les critiques propres à Lightslinger ni l'attribution de son second tir. Sept ressources locales de profils/statistiques/boutique sont liées séparément.

## Travail restant

1. Qualifier le déclenchement à la fin des Q/W/E/R, les réactivations, refus/interruptions et le remplacement ou rafraîchissement de charge.
2. Résoudre `@f1@`, sa progression, les classes de cibles et le sens exact des dégâts complets sur sbires/monstres.
3. Implémenter premier/second tir, leur délai, coût en charge, annulation, déplacement, Stop et changement/disparition de cible.
4. Qualifier portée, visibilité, collision, esquives, immunités et boucliers pour chaque tir.
5. Qualifier les critiques partagés ou indépendants, mitigation, pénétration, vol de vie et effets à l'impact ; tester Rageblade/Hurricane sur leur contrat propre.
6. Prévenir les récursions de procs ; qualifier l'attribution kill/assist et le récapitulatif du second tir.
7. Tester les six secondes depuis un vrai déclenchement, les événements simultanés, mort/réapparition, déconnexion et fin de partie.
8. Résoudre la clé E manquante et les limites du lecteur sans remplacer les métadonnées anciennes ou adopter les noms de test du DDF.
9. Vérifier séparément HUD, icônes, animation double tir/deux mains, particules, son et transport réseau.

Les inconnues restent ouvertes. Aucun manque global de modèle/texture n'est déduit de ces refus de gameplay. Les limites Battle Training et le défaut de déplacement V564 restent dans leurs preuves antérieures.

## Livraison et conservation

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0. **72 associations fausses et quatre graphes invalides refusés**. Trois fragments génériques de consignes changés, 42 212 inchangés ; note SYS actualisée séparément.

Deux bases : quatre destinataires actualisés, **42 603 autres lignes, 42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente. Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées.

Graphe : **99 057 sources, 3 891 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes, 5 517 résolues précédemment**. **3 891 ancres exactes, aucune divergence courante**. Revue structurelle globale distincte du hachage des sources sélectionnées ; aucun recensement exhaustif des 99 057 contenus.

Fichiers modifiés : registres `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/lucian-passive-lightslinger-links-v595.json` ; preuve `docs/fidelity_lucian_passive_lightslinger_links_v595.json` ; ce rapport ; couverture/plan/reprise, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, consignes ciblées des deux bases et note privée. Aucun gameplay/asset modifié, aucune case cochée.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision595_Lucian_discovery`, `revision595_Lucian_passive_probe`, `revision595_Lucian_inspection_qualified`, `revision595_Lucian`, `revision596_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision596_trace_review/REVIEW.json. Lucian V595 publié/audité :35sources105associations22points44liens. Deux cas publics base/Sword+10AD :6impacts102refus362ticks ;offsets179/180/181 aprèsStop. Aucun sort accepté,charge/secondtir/expiration nonexercés. Texte6sec,doubletir,@f1@ champions/structures,plein dégât sbires/monstres,onhit lié ;@f1@ nonrésolu.13Lua dont9limites NEWTABLE,6preloads,5buffs4résolus Eabsent,84DDF sans formule passive19communautaires. Icônes25.dds/Draven conservées,Qbuff répètepassif,coefficient1.2 nonadopté,preload Rageblade/Hurricane nonqualifié. Sept chemins candidats absents. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver preuves et défautV564. Prochain passif à inspecter réellement : Lulu. Goal actif ;aucun statut/case/inconnu fermé.
