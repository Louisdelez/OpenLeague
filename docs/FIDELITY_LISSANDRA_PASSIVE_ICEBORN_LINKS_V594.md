# Lissandra — sources et consommateurs d'Iceborn, V594

Date UTC : 2026-10-26T06:55:02.015442+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02** : relier les exigences aux sources natives et à leurs consommateurs actuels.

## Résultat

Trois fiches du passif reliées à **32 fichiers natifs**, **96 associations**, **24 points de code et 48 liens**. Quatre sources de preuves ajoutées. Trois questions propres, quatre dépendances, statuts, critères et données manuelles conservés.

Le moteur exécute les attaques ordinaires de Lissandra, mais **refuse encore l'apprentissage et les lancements de ses sorts**. Aucun sort gratuit ni réduction de recharge par contrôle n'est donc exercé. Les attentes autour de 18 secondes démontrent la persistance des refus, pas un cycle de recharge du passif. Aucun gameplay ou asset modifié dans ce lot de traçabilité.

## Sources natives

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiés ; priorité de montage historique et serveur original non déduits de cette appartenance.

| Fichier | Identité source |
|---|---|
| Lissandra.inibin | OLS-c484b860-cc76-53bd-8162-d47479ad57a1 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Lissandra.ddf | OLS-cc7b5aaf-9346-5762-aa47-06b69d941b46 |
| CharScriptLissandra.luaobj | OLS-990be36f-26bc-5bf6-9eec-4a447fea1302 |
| CharScriptLissandra.preload | OLS-e32e6e4f-4f17-59ef-b57b-4883b80a251a |
| LissandraPassive.inibin | OLS-c9d9577c-fdf7-51c8-b30f-419262e75382 |
| LissandraPassive.luaobj | OLS-f692df58-1427-5846-a674-432a364a5f2d |
| LissandraPassiveBuff.inibin | OLS-d4153faf-e01e-5c2b-bda5-7ff5a9550669 |
| LissandraPassiveBuff.luaobj | OLS-5b337cd5-e6e1-5136-986e-d02de08e51ca |
| LissandraPassiveBuff.preload | OLS-5b108de7-b243-5320-bebd-d62d1d130046 |
| LissandraPassiveReady.inibin | OLS-e2bc3c35-1746-5dbc-bdb9-8a686a2a25bc |
| LissandraPassiveReady.luaobj | OLS-7c020322-166a-5413-917e-fdb7ed5e8fa7 |
| LissandraPassiveReady.preload | OLS-94d32a46-cdeb-55dd-8422-84fb85c09fc2 |
| LissandraQ.inibin | OLS-a9c394e0-dd9b-5bcd-8e7e-a69a826536a2 |
| LissandraQ.luaobj | OLS-01418623-3f6a-500b-8893-32779b672ce2 |
| LissandraW.inibin | OLS-35931694-79e5-51de-ac28-fde9a092c285 |
| LissandraW.luaobj | OLS-1644156d-c39f-5f0a-adb4-3397d67c0c5f |
| LissandraW.preload | OLS-7f0e851d-980e-5740-b7c4-95174469d05d |
| LissandraE.inibin | OLS-1c54bfca-9077-5b28-8dc9-f7c650794782 |
| LissandraE.luaobj | OLS-37c7f217-f8a3-5116-a8fd-0ae6994b9834 |
| LissandraE.preload | OLS-6ceea8af-2cf8-5a82-85ad-bf39ce919ff2 |
| LissandraR.inibin | OLS-60d00854-d66b-5159-915e-11d4da77a2b3 |
| LissandraR.luaobj | OLS-4e28cbed-0557-5d82-94ac-f7acf755c603 |
| LissandraR.preload | OLS-e782715a-45fa-5db4-b2de-866a06debf25 |
| LissandraSlow.inibin | OLS-9471693a-08f5-59a6-a66e-efa40f7accdc |
| LissandraSlow.luaobj | OLS-a5bd5f09-ed1d-5350-b970-064c2f6252e5 |
| LissandraWFrozen.inibin | OLS-96bf4679-fd72-5270-88ae-c16d64591289 |
| LissandraWFrozen.luaobj | OLS-88e5e400-17f2-5ce3-a590-f3fcd59bc8fe |
| LissandraWFrozen.preload | OLS-22f89590-d51d-5805-bf04-3fc3e040157c |
| LissandraRSlow.inibin | OLS-baa1c369-9908-5dc9-a1f9-2749c12abb98 |
| LissandraRSlow.luaobj | OLS-c51a03ca-662d-5396-8bf8-8359df443fb0 |
| LissandraRSlow.preload | OLS-f28ef341-c6fc-5be6-be9d-b751f300f2ea |

- `Lissandra.inibin` lie `Passive1LuaName=LissandraPassive`, `Lissandra_Passive.dds` et la description en_GB. Mana de base `"304.0"`. Six champs de niveau passif absents, sans valeur de remplacement.
- Description personnage ligne **4222** et buff passif ligne **2216** : prochaine capacité **sans coût de Mana toutes les 18 secondes** ; recharge réduite de **1 seconde** lorsqu'une capacité de Lissandra gêne le déplacement d'un ennemi. Les effets de déplacement provenant **des objets sont explicitement exclus**. L'événement précis, sa multiplicité et les règles d'état restent à qualifier.
- Ready ligne **2217** indique que la prochaine capacité ne coûte aucun Mana. La clé exacte **`game_buff_tooltip_LissandraPassiveBuff` est absente** du catalogue en_GB sélectionné. Le fichier Buff existe ; son texte manquant n'est ni remplacé par celui de Ready, ni transformé en absence du fichier.
- **Neuf liaisons BuffData** observées : huit résolues, une absente. Les textes Q ralentissement, W root, E téléportation, R stun, Slow générique et RSlow sont du contexte de coût/contrôle ; ils ne prouvent pas les callbacks d'Iceborn.
- **Onze Lua** parcourus structurellement, zéro prototype enfant : cinq initialisations littérales qualifiées et six limites **NEWTABLE** (Ready pc6, Q pc6, W pc8, E pc16, R pc8, WFrozen pc14). Une limite du lecteur littéral ne prouve pas une corruption du fichier.
- Passive et PassiveBuff déclarent `PersistsThroughDeath=true`, avec des noms distincts. Cela ne définit pas la politique de recharge, de consommation ou de disponibilité après mort. CharScript a une initialisation vide.
- `LissandraSlow.luaobj` conserve `BuffName=Slow`, l'icône **Chronokeeper_Timestop.dds** et l'effet `GLOBAL_SLOW.TROY`. Ce nom ancien n'est pas remplacé. RSlow déclare notamment `DoesntTriggerSpellCasts=true`, `IsDamagingSpell=true` et `SpellDamageRatio=1.0` ; ces littéraux ne qualifient pas le déclenchement de la réduction passive.
- **Huit preloads** sélectionnés : CharScript, PassiveBuff, Ready, W/E/R, WFrozen et RSlow. Buff référence Ready ; Ready référence `Lissandra_Base_Passive_Ready.troy` et `Lissandra_Base_Passive_Start.troy`. Dépendances liées, sans validation de leur rendu.
- **24 lignes DDF**, pour RRemoval/R/E/Q/T/W, toutes avec `link` et `coeff` vides. Aucune formule ou valeur de recharge n'en est inventée.
- **Seize références communautaires** hachées et identifiées séparément. CharScript communautaire vide ; leur existence ne prouve pas une politique serveur Riot.
- **Cinq chemins candidats absents** : CharScript sous `Scripts`, Passive INIBIN global, Passive preload, Q preload et T INIBIN dans les sorts du personnage. Les fichiers réels restent identifiés à la racine du personnage et dans ses sorts. Absence locale de candidats distincte d'un inventaire complet d'assets manquants.

## Exécution actuelle

Compilation privée `cargo build --locked --offline` contre le vrai core non-test. Dépendances et checksums alignés au lock racine ; **1 158 entrées** de code/ressources et chaîne de preuves antérieures conservées. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-lissandra-passive-iceborn-probe.exe`, **6034432 octets**, SHA-256 `87969cf38558b5209af8283e55e6a9ad363c5b447f5f1630e9ad3ff6d1593205`.

Deux parties Map10 neuves, Lissandra contre Annie. Cas de base puis achat public du Codex 3108 : **30 AP et 10 % de CDR** observés. Déplacements par commandes publiques vers la zone centrale. Aucune injection de temps, position, rang, mana ou état passif.

Trois attaques à distance par cas, Stop, puis **541 ticks** d'attente. Les commandes Learn/Cast/CastAt QWER sont essayées avant les attaques, puis aux offsets **539, 540 et 541** après Stop. À 30 ticks/s, ces offsets encadrent 18 secondes d'attente locale ; **Stop n'est pas un départ prouvé de recharge passive**.

| Cas | AP | CDR | Mana max | Impacts | Refus | Ticks attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 0.0 | 0.0000 | 304.0 | 3 | 51 | 541 |
| Codex_CDR_control | 30.0 | 0.1000 | 304.0 | 3 | 51 | 541 |

**Attendu pour les contrôles ordinaires :** impacts physiques correspondant aux projectiles et à la résistance de la cible, refus sans mutation, statistiques d'objet réelles et régénération ordinaire pendant l'attente.

**Observé :** six impacts, chacun avec un projectile Lissandra→Annie témoin, non critique. Dégâts après armure et correction de régénération conformes à moins de 0,002. **102 refus atomiques**, incluant joueur inconnu, attaque sur soi, slot invalide et les quatre séquences de douze commandes de sorts par cas. Aucun rang ni recharge QWER de Lissandra n'est acquis.

Pendant **1 082 ticks d'attente**, la santé de la cible suit la régénération attendue. Mana Lissandra constamment plafonné à **304**, aucun ralentissement ni stun, participants vivants niveau 1, aucune mort ni fin de partie. La consommation de mana et sa gratuité ne peuvent pas être distinguées sur un sort refusé.

**Attendu pour Iceborn :** une capacité admissible acceptée peut consommer un état prêt et coûter zéro mana ; des contrôles admissibles peuvent réduire sa recharge selon le contrat. **Observé : préconditions non obtenues**. Aucun sort accepté, aucun coût dépensé, aucune recharge passive armée ni contrôle de capacité appliqué. Le Codex prouve seulement les statistiques d'objet actuelles ; il ne qualifie pas une réduction de recharge passive.

Snapshots locaux uniquement. Aucun serveur historique, transport réseau, HUD, rendu ou audio qualifié par ces essais.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AP,CDR,mana and defense values |
| crates/core/src/progression.rs:150 | unsupported Lissandra learning |
| crates/core/src/progression.rs:159 | unsupported Lissandra rank policy |
| crates/core/src/spells.rs:101 | unsupported Lissandra cast |
| crates/core/src/annie_w.rs:29 | unsupported Lissandra ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary ranged launch and impact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public Codex30AP10percent CDR control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/cooldown.rs:11 | existing spell CDR arithmetic static context,not Iceborn recharge |
| crates/core/src/cooldown.rs:10 | ordinary CDR cap |
| crates/core/src/slows.rs:41 | existing slow admission static context,not Lissandra event producer |
| crates/core/src/slows.rs:62 | existing slow application static context,not Iceborn reduction |
| crates/core/src/stuns.rs:15 | existing stun entry static context,not Iceborn reduction |
| crates/core/src/movement.rs:53 | ordinary movement and slow consumption context |

Les fonctions de progression et de sorts expliquent les refus. Attaques, dégâts, mitigation et régénération expliquent les résultats ordinaires. Les fonctions de stats/boutique expliquent le Codex. Les entrées slow/stun et le calcul générique de CDR sont **du contexte statique existant**, pas des callbacks Iceborn exécutés. Une fonction générique capable de ralentir une cible ne prouve pas que Lissandra produit l'événement ni que sa recharge passive en tient compte.

Huit ressources locales liées : champions, progression, type de ressource, attaques, critiques, collisions, boutique et règles génériques de recharge. Aucun remplacement du contrat passif par ces ressources.

## Travail restant

1. Définir l'état initial, les états prêt/recharge, le début du délai de 18 secondes et la transition vers la disponibilité.
2. Qualifier la consommation de la gratuité pour chaque capacité et réactivation, les refus, annulations et interruptions ; préserver coût/état sur refus.
3. Vérifier le coût gratuit avec mana insuffisant pour le coût ordinaire, sous plafond et au plafond, et l'ordre avec régénération ou remboursement.
4. Relier les événements de contrôle admissibles : ralentissement, root, stun, propriétaire, équipe, cibles, immunités et boucliers.
5. Qualifier multiplicité par capacité/impact/cible, rafraîchissement d'un contrôle existant, événements simultanés, limite basse et passage prêt.
6. Implémenter et vérifier la réduction de 1 seconde ; vérifier l'exclusion des contrôles issus d'objets sans confondre source du contrôle et CDR d'objet.
7. Qualifier séparément l'interaction éventuelle de la CDR ordinaire avec ce passif ; les contrôles présents ne la déterminent pas.
8. Qualifier mort/réapparition, déconnexion et fin de partie. Les littéraux de persistance ne suffisent pas.
9. Résoudre le texte PassiveBuff manquant, les six limites du lecteur littéral et les rôles exacts de Passive/Buff/Ready sans normalisation silencieuse.
10. Vérifier séparément HUD, icône, Ready/Start, animations, VFX, audio, visibilité et transport réseau.

Les inconnues restent ouvertes. Le manque d'implémentation des sorts ne démontre pas un manque global de modèles/textures. Les limites Battle Training et le défaut de déplacement V564 restent dans leurs preuves précédentes.

## Livraison et conservation

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0.

- 72 associations volontairement fausses et quatre graphes invalides refusés.
- Trois fragments génériques de consignes changés, 42 212 inchangés ; note SYS actualisée séparément.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes identiques ; **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente.
- Registres d'identité, hiérarchie et inconnues identiques octet pour octet. Trois questions propres et quatre dépendances conservées.
- Graphe : **99 053 sources, 3 869 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues précédemment**. Revue globale : **3 869 ancres exactes, aucune divergence courante**. Vérification structurelle globale distincte du hachage des sources sélectionnées ; pas de recensement exhaustif des 99 053 contenus.

Fichiers modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/lissandra-passive-iceborn-links-v594.json` ; preuve `docs/fidelity_lissandra_passive_iceborn_links_v594.json` ; ce rapport ; `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md` ; données/consignes ciblées des deux bases et note de reprise privée. Aucun gameplay/asset modifié, aucune case cochée.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision594_Lissandra_discovery`, `revision594_Lissandra_passive_probe`, `revision594_Lissandra_inspection_qualified`, `revision594_Lissandra`, `revision595_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision595_trace_review/REVIEW.json. Lissandra V594 publié/audité :32sources96associations24points48liens. Deux cas publics base/Codex30AP10%CDR :6impacts102refus1082ticks attente ;offsets539/540/541 aprèsStop,Mana304plafonné. Aucun sort accepté,gratuité/recharge passive/réduction par contrôle nonexercées. Texte18sec/1sec/effets objets exclus lié.11Lua dont6limites NEWTABLE,8preloads,9buffs dontPassiveBuff absent,24DDF vides16communautaires ;CharScriptvide. Slow Chronokeeper et trois états passifs conservés. Cinq chemins candidats absents. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver preuves et défautV564. Prochain passif à inspecter réellement : Lucian. Goal actif ;aucun statut/case/inconnu fermé.
