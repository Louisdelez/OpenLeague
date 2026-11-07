# Leona — sources et consommateurs de Sunlight, V593

Date UTC : 2026-10-26T06:37:00.218653+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02** : relier les exigences aux sources natives et à leurs consommateurs actuels.

## Résultat et portée

Trois fiches du passif reliées à **27 fichiers natifs**, **81 associations**, **22 points de code et 44 liens**. Quatre sources de preuves ajoutées ; trois questions propres, quatre dépendances, statuts, critères et données manuelles conservés.

Les attaques ordinaires de Leona et les Q d'Annie alliée fonctionnent dans deux scénarios. **Les commandes de sorts de Leona restent refusées.** La précondition native d'application de la marque n'est donc pas obtenue : ces essais ne qualifient pas sa consommation, son expiration ou ses dégâts. Aucun code de gameplay ni asset modifié dans ce lot de traçabilité.

## Sources natives et limites

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille, SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées ; la priorité de montage historique et le serveur original ne sont pas démontrés par cette appartenance.

| Fichier | Identité source |
|---|---|
| Leona.inibin | OLS-11843fc7-9f87-58fb-abde-198e9eac76b0 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Leona.ddf | OLS-787c4edf-6093-5a44-bf20-c7a02f09de45 |
| CharScriptLeona.luaobj | OLS-71299d7f-6a28-592b-a8c6-8aeebd63df02 |
| CharScriptLeona.preload | OLS-0b80b6f8-abd0-5816-b6f3-9b79eeaf6113 |
| LeonaSunlight.inibin | OLS-8917ce46-b402-5214-9b3d-395d4bd0b90b |
| LeonaSunlight.luaobj | OLS-ff510a8d-0b68-5013-8765-50cf5a316079 |
| LeonaSunlight.preload | OLS-b4e2dced-2483-5975-b2ff-09d192560071 |
| LeonaSunlightPassive.inibin | OLS-0162c9c9-1754-50b1-aa22-40681ad784d2 |
| LeonaSunlightPassive.luaobj | OLS-091265f6-ae65-578b-a342-cc6ccb33d36a |
| LeonaSunlightPassive.preload | OLS-c653f1e8-7e14-5657-8665-015d661c6c10 |
| LeonaShieldOfDaybreak.inibin | OLS-74b01655-e899-552d-91c2-665cd18bc71f |
| LeonaShieldOfDaybreak.luaobj | OLS-43fda1db-ba61-5cf0-8fa7-1c641b1bcbb1 |
| LeonaShieldOfDaybreak.preload | OLS-40e3974f-c607-5215-8261-36cc4804e6fc |
| LeonaShieldOfDaybreakAttack.inibin | OLS-95ec0e8a-a004-5b55-b75e-26b1ff199c8a |
| LeonaShieldOfDaybreakAttack.luaobj | OLS-f8f9f2b4-2b0b-55f9-8f02-9328b81b7ae4 |
| LeonaShieldOfDaybreakAttack.preload | OLS-10644b43-b5ec-50dd-83f2-d1984527140e |
| LeonaSolarBarrier.inibin | OLS-916c5194-edf7-5fc3-ba2b-3ea27e2dcf45 |
| LeonaSolarBarrier.luaobj | OLS-e85aa138-8484-55b7-9280-c675ebe49ba9 |
| LeonaSolarBarrier.preload | OLS-c18feef2-3ea1-5f28-9e0b-e8fafad51a6b |
| LeonaZenithBlade.inibin | OLS-683a099f-5662-51e7-9044-508cffd368f3 |
| LeonaZenithBlade.luaobj | OLS-d28470d4-047a-5125-ac44-b7144dffbe0f |
| LeonaZenithBlade.preload | OLS-028a36d2-b302-528c-ac40-736f24d5a9be |
| LeonaSolarFlare.inibin | OLS-c74eff0c-5a72-5943-b915-88f2835868f1 |
| LeonaSolarFlare.luaobj | OLS-f1365261-60d3-5e6f-a15f-0d19e84d8e79 |
| LeonaSolarFlare.preload | OLS-3ebf8f13-1473-553f-98e8-242eaab8fc98 |
| LeonaSolarBarrierTracker.luaobj | OLS-daa786c3-5635-58a7-9d5c-dc310e885cb3 |

- `Leona.inibin` lie `Passive1LuaName=LeonaSunlightPassive`, icône `LeonaSunlight.dds`, description `game_character_passiveDescription_Leona`, QWER et attaque Q renforcée. Les six champs de niveau valent **1,4,7,absent,absent,absent** ; ils ne constituent pas une table de dégâts adoptée.
- Description personnage, `fontconfig_en_GB.txt` ligne **4220** : les sorts infligeant des dégâts appliquent **Sunlight pendant 3,5 secondes** ; les dégâts de champions alliés consomment la marque pour des dégâts magiques supplémentaires.
- Buff de cible ligne **2206** : cible marquée par Leona et dégâts magiques supplémentaires des alliés. Buff de passif permanent ligne **2207** : durée de 3,5 secondes et montant **`@f2@` non résolu**. Le montant, sa progression et l'attribution restent à qualifier ; aucune valeur moderne ou communautaire substituée.
- **Neuf Lua** entièrement parcourus, zéro prototype enfant et neuf initialisations littérales qualifiées. CharScript et SolarBarrierTracker ont une initialisation vide : cela ne révèle pas les callbacks serveur.
- `LeonaSunlight.luaobj` déclare le nom et l'icône de la marque. `LeonaSunlightPassive.luaobj` déclare séparément le passif permanent avec `PersistsThroughDeath=true` et `NonDispellable=true`. **La persistance du passif ne prouve pas la persistance de la marque cible.**
- Q activation déclare `DoesntTriggerSpellCasts=false`, alors que Q attaque renforcée déclare `true`. Le preload de cette attaque référence Sunlight. Ces éléments distinguent l'activation, l'impact renforcé et l'attaque ordinaire ; ils ne suffisent pas à prouver l'ordre historique des événements.
- **Huit preloads** sélectionnés : CharScript, Sunlight, passif permanent et les cinq définitions Q/Q renforcé/W/E/R. Les dépendances comprennent SolarBarrierTracker, Sunlight et les particules `leona_sunlight_champion.troy`, `leona_sunlight.troy`, `leonapassive_tar.troy`. Les dépendances sont liées, sans acceptation du rendu ou de leur exécution.
- **Quatre liaisons de buffs** résolues : Sunlight, SunlightPassive, ShieldOfDaybreak et SolarBarrier. Les deux dernières sont du contexte de déclenchement, pas le contrat du passif lui-même.
- **Quatre lignes DDF**, toutes SolarBarrier : bonusarmor ×0,2, bonusspellblock ×0,2 et deux entrées vides. Aucune formule Sunlight `@f2@` n'en est déduite.
- **Treize références communautaires** identifiées et hachées séparément, dont un `CharScriptLeona.cs` vide. Leur présence ne prouve pas la politique serveur originale.
- **Quatre chemins candidats absents** : CharScript à la racine du personnage, Sunlight sous les sorts du personnage, SolarBarrierTracker INIBIN et preload globaux. CharScript existe sous `Scripts`, Sunlight existe globalement et le Lua du tracker existe. Il ne s'agit pas d'un inventaire global d'assets manquants.

## Essais exécutés

Compilation privée `cargo build --locked --offline` contre le vrai core non-test. Locks et checksums alignés ; **1 158 entrées** de code/ressources et chaîne de preuves antérieures préservées. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-leona-passive-sunlight-probe.exe`, **6048768 octets**, SHA-256 `60a89121a40f100f33686b97b3cf4e84dff353a7c2b43a85e76f3120727593a7`.

Deux parties Map10 neuves : Leona propriétaire et Annie alliée **équipe 0**, Ahri cible **équipe 1**. Second cas : Tome 1052 acheté par Leona, 20 AP. Annie apprend Q par commande publique ; aucun état de rang, santé, temps, position ou marque injecté. Déplacements publics vers la zone centrale et positions effectivement atteintes enregistrés.

Chaque scénario comporte trois attaques de Leona, Stop, trois Q d'Annie avec attente des recharges, puis 180 ticks après séquence. Leona ne lance aucun sort accepté.

| Cas | AP Leona | Impacts Leona | Q alliés | Refus | Ticks après séquence | Attente recharge |
|---|---:|---:|---:|---:|---:|---:|
| base | 0.0 | 3 | 3 | 27 | 180 | 208 |
| owner_Tome_20AP | 20.0 | 3 | 3 | 27 | 180 | 208 |

**Contrôles ordinaires attendus et observés :**

- Six impacts physiques de Leona au total, chacun avec son windup visant Ahri et son tick de libération, sans critique. Dégâts conformes à l'AD et à l'armure ; erreur après correction de régénération inférieure à 0,002.
- Six Q alliés au total, chacun avec un missile Annie→Ahri témoin. **80 dégâts magiques bruts**, **60 mana** dépensés et **120 ticks** de recharge. Dégâts après résistance magique et régénération conformes, erreur inférieure à 0,002. Leona +20 AP ne modifie pas ces dégâts ordinaires ; cela ne teste pas un éventuel scaling Sunlight.
- Les trois Q par cas n'arment pas l'étourdissement de Pyromania ; aucun étourdissement observé. Ces chemins Annie sont des contrôles effectivement exécutés, pas un passif Leona substitué.
- **54 refus atomiques** : joueur inconnu, attaque d'un allié, slot invalide, Learn/Cast/CastAt QWER de Leona avant et après les séquences. Snapshots inchangés lors des refus ; rangs/recharges Leona nuls.
- **416 ticks d'attente de recharge** et **360 ticks après séquence** : santé cible conforme à la régénération ordinaire. Participants vivants niveau 1, aucune mort ni fin de partie.

**Contrat Sunlight attendu :** un sort admissible de Leona applique la marque, puis un événement de dégâts allié admissible la consomme et ajoute les dégâts natifs. **Observé : l'application manque**, parce que les commandes de sorts de Leona sont refusées. Les impacts alliés montrent le chemin actuel de dégâts, pas la consommation d'une marque. L'attente supérieure à 3,5 secondes n'est pas un test d'expiration d'une marque jamais appliquée.

Snapshots locaux uniquement ; aucune qualification du transport réseau, du HUD, des animations ou de l'audio. Aucun serveur historique exécuté.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/ally/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD,AP and target resistance |
| crates/core/src/progression.rs:150 | unsupported Leona learning |
| crates/core/src/progression.rs:159 | unsupported Leona rank policy |
| crates/core/src/spells.rs:101 | unsupported Leona cast |
| crates/core/src/annie_w.rs:29 | unsupported Leona ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary owner physical and allied magic damage |
| crates/core/src/attacks.rs:157 | melee release and ordinary cadence |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | target health regeneration correction |
| crates/core/src/shop.rs:261 | public Tome owner AP control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/annie.rs:45 | accepted allied Q,cost and cooldown control |
| crates/core/src/annie.rs:73 | allied magic impact witness,not Sunlight proc |
| crates/core/src/world.rs:226 | current team and target identity |
| crates/core/src/damage.rs:38 | physical and magical defense arithmetic |
| crates/core/src/annie_passive.rs:9 | three allied Q impacts leave Pyromania unarmed |
| crates/core/src/annie_passive.rs:20 | no stun in these allied Q controls |

Les chemins de progression et de sorts expliquent les refus de Leona. Les fonctions d'attaque et de dégâts expliquent les impacts physiques. Le lancement et les projectiles Annie expliquent les impacts magiques alliés, leur coût et recharge. `target_info` fournit les identités et équipes ; les contrôles de mitigation/régénération isolent les dégâts attendus. Ces points sont qualifiés comme **frontières actuelles**, pas comme implémentation de Sunlight.

Huit ressources locales liées : champions, progression, type de ressource, profils d'attaque, critiques, collisions, boutique et règles Q Annie. Les règles locales du Q sont identifiées comme contrôle ; elles ne remplacent pas le contrat natif Leona.

## Travail restant

1. Résoudre `@f2@` et la table de dégâts, les niveaux/statistiques de référence, le propriétaire et les règles d'attribution.
2. Qualifier puis implémenter les événements de dégâts Q renforcé, explosion W, impact E et R qui appliquent la marque.
3. Définir état, propriétaire, cible, application, remplacement/rafraîchissement/cumul et présence de plusieurs Leona.
4. Définir les événements alliés qui consomment la marque : attaques, sorts, familiers, dégâts périodiques, dégâts nuls, événements simultanés et cas de Leona elle-même.
5. Qualifier cibles champions/sbires/monstres/bâtiments, boucliers, immunités, invulnérabilité et ordre avec mitigation/pénétration.
6. Implémenter dégâts supplémentaires et attribution kill/assist, interactions de procs et prévention de récursion.
7. Implémenter les 3,5 secondes et vérifier les bornes d'expiration, la mort/réapparition, la déconnexion et la fin de partie.
8. Exécuter des cas positifs application→consommation et négatifs sans marque, expirée, mauvais propriétaire/équipe ; vérifier les refus sans mutation.
9. Vérifier séparément icône, marque/particules de cible, HUD, animations, audio et transport réseau.

Les inconnues restent ouvertes. Aucun manque global de modèle ou de texture n'est déduit de ce défaut d'implémentation. Les limites Battle Training et le défaut de déplacement V564 restent dans leurs preuves antérieures.

## Livraison, contrôles et conservation

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0.

- 72 associations volontairement fausses et quatre graphes invalides refusés.
- Trois fragments génériques de consignes changés, 42 212 inchangés ; note SYS actualisée séparément.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes identiques ; **42 607 états manuels et 23 historiques préservés**, synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet. Trois questions propres et quatre dépendances conservées.
- Graphe : **99 049 sources, 3 845 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues précédemment**. Revue globale : **3 845 ancres exactes, aucune divergence courante**. Vérification structurelle globale distincte du hachage des sources sélectionnées ; pas de recensement exhaustif des contenus des 99 049 sources.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/leona-passive-sunlight-links-v593.json` ; preuve `docs/fidelity_leona_passive_sunlight_links_v593.json` ; ce rapport ; `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md` ; données/consignes ciblées des deux bases et note de reprise privée. Aucun gameplay/asset modifié ; aucune case cochée.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision593_Leona_discovery`, `revision593_Leona_passive_probe`, `revision593_Leona_inspection_qualified`, `revision593_Leona`, `revision594_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision594_trace_review/REVIEW.json. Leona V593 publié/audité :27sources81associations22points44liens. Deux cas publics0/20AP propriétaire,Annie alliée/Ahri adverse :6impacts Leona6Q alliés54refus360tail416attente recharge. Aucun sort Leona accepté,aucune marque appliquée ou consommée ;expiration et dégâts passifs non qualifiés. Texte3.5s/consommation alliée lié,@f2@ nonrésolu,niveaux1/4/7 non adoptés comme table.9Lua littéraux8preloads4buffs4DDF SolarBarrier13communautaires ;CharScript vide. Passif permanent distinct de marque cible ;drapeaux Q activation/attaque distincts. Quatre chemins candidats absents. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver preuves et défautV564. Prochain passif à inspecter réellement : Lissandra. Goal actif,aucun statut/case/inconnu fermé.
