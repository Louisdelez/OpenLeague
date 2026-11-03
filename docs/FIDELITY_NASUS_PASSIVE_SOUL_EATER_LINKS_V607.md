# SYS-01.2-02 — Nasus : sources et consommateurs de Soul Eater (V607)

Date UTC : 2026-10-26T11:00:38.326195+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

## Résultat et portée

CH-Nasus-PASSIF-SOURCE, CH-Nasus-PASSIF-SIMULATION-CONTRAT et CH-Nasus-PASSIF-SIMULATION sont reliées à 32 sources natives, 96 associations, 28 points du moteur et 56 liens sur les deux fiches de simulation. Ces points sont qualifiés comme frontières et contexte, sans implémentation complète du passif. SYS-01.2-02 reçoit la synthèse. Aucun gameplay ni asset modifié, aucune tâche déclarée complète.

Les sources natives décrivent un bonus de vol de vie. Le moteur courant ne prend en compte que celui des objets. Les attaques ordinaires ont été exercées : aucun soin de passif au niveau1 dans les cas sans objet et Épée longue ; le Sceptre seul produit environ4,64219PV par coup. Le pourcentage natif f1 et sa progression restent inconnus : ne pas quantifier le déficit historique à partir d’une version moderne ou d’une estimation.

## Sources, conflits et limites

- Nasus.inibin lie NasusPassive, Nasus_Passive.dds et les clés du nom et de la description. Nom Soul Eater en_GB ligne4414 ; description de bonus Life Steal ligne4238. Tooltip SoulEater ligne2691 : `@f1@% bonus Life Steal`.
- Passive1Desc conserve un texte Singed PV supplémentaires selon mana ; PassLev1Desc2 parle de réduction magique10% pour Singed. Ces textes hérités ne sont pas adoptés comme règles Nasus.
- Passive1Level1..6 et les champs SpellData sélectionnés de NasusPassive sont absents. Absence ne signifie pas zéro. NasusPassive.inibin contient la clé de tooltip, sans montant résolu.
- Nasus.ddf possède24lignes. Seuls SiphoningStrikeNew;f1 et NasusQ;f1 relient @stacks avec coefficient3. Les22autres lignes sont vides. Ces valeurs appartiennent au Q et ne résolvent pas le f1 de Soul Eater.
- Six clés de tooltip BuffData sont conservées ; cinq trouvent une correspondance exacte. `game_buff_tooltip_NasusQ` ne correspond à aucune entrée exacte dans le font en_GB lu. Aucun renommage automatique ni correction inventée.
- Douze Lua lus intégralement, aucun prototype enfant : sept initialisations littérales, cinq limites du lecteur sur NEWTABLE (E,Q,QAttack,R,W). Cela ne prouve pas une corruption.
- CharScriptNasus.luaobj a une initialisation vide. NasusPassive.luaobj expose icône, nom et flags PersistsThroughDeath/NonDispellable ; ce ne sont pas un callback de soin ni une qualification du respawn.
- Sept preloads ; CharScript référence notamment nasus_base_p_lifesteal.troy. Les dépendances sont recensées sans acceptation de chargement ou de rendu. NasusTauntRenekton possède une icône Chronokeeper et le nom Slow : aucun comportement étranger n’en est déduit.
- Cinq chemins candidats absents : CharScript sous Scripts, NasusPassive.inibin/.luaobj sous DATA/Spells, NasusPassive.preload/.ddf sous Characters/Nasus/Spells. Les ressources réelles sélectionnées sont présentes dans le dossier du personnage ; aucun manque global de modèles, textures, animations ou sons n’est établi.
- Seize références communautaires distinctes de la source native. CharScript C# vide. Q applique immédiatement des dégâts de sort et accroît AD global sur mort de cible, au lieu d’une qualification d’attaque renforcée et de stacks propres au Q. E annonce une réduction d’armure dans un commentaire, sans application dans le fichier lu. Ces fichiers ne sont ni le serveur original ni des consommateurs Rust exécutés.
- Le tooltip natif R parle de conversion de dégâts en bonus d’attaque ; les bonus défensifs et timers du R communautaire ne constituent pas à eux seuls une preuve de fidélité. Ce lot n’effectue pas une recette QWER complète.

Les32sources sont comparées au registre et à l’appartenance RADS sélectionnée avec taille/SHA-256. Aucun fichier NightmareBotNasus trouvé dans les deux emplacements inspectés ; aucune conclusion sur des emplacements non inspectés.

| Fichier | Source |
|---|---|
| Nasus.inibin | OLS-cce8ca14-9c27-5840-ab21-ff57c6b85f46 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nasus.ddf | OLS-76c0f628-da9d-5a0d-8988-cfa914ceefdb |
| CharScriptNasus.luaobj | OLS-86bebe63-f1b3-508e-996a-3a4c500873d8 |
| CharScriptNasus.preload | OLS-526521c3-f102-5657-9379-f8da62ff2641 |
| NasusBasicAttack.inibin | OLS-f630f477-7171-52b6-9a66-f91e57179f76 |
| NasusBasicAttack2.inibin | OLS-1223b39b-2fc3-5c8d-a3f9-6323da923dbf |
| NasusCritAttack.inibin | OLS-8e7889d3-9e60-57b2-8988-3e6b5dfc6d23 |
| NasusE.inibin | OLS-bd5d76bd-5b3d-5b5a-8003-3291536a09ad |
| NasusE.luaobj | OLS-d76f3fad-0f24-5454-af3d-f6fac0a0f8ad |
| NasusE.preload | OLS-7d32d233-4c01-5ea7-b3be-a6990e186c5e |
| NasusEArmorReduction.luaobj | OLS-2b49d344-6f02-5ed7-be0e-2e9ef390eae8 |
| NasusPassive.inibin | OLS-8c90bb98-70c4-5c98-a78b-d4b8153e6c22 |
| NasusPassive.luaobj | OLS-645e84b5-8b61-563c-b5ba-41baa34edbce |
| NasusQ.inibin | OLS-3ae6c238-b45b-5fcf-85e3-fc42b3aecd66 |
| NasusQ.luaobj | OLS-319670d3-47be-5f52-86ce-1b48527e1cd1 |
| NasusQ.preload | OLS-e749b37b-39ee-5428-bdfc-f5089449dbbf |
| NasusQAttack.inibin | OLS-96aa2f4a-e1fc-5018-b56e-707802245b11 |
| NasusQAttack.luaobj | OLS-8561a716-d37b-5f14-9ecb-6319b9fbe74e |
| NasusQAttack.preload | OLS-e45342a5-2b96-54de-ba57-17364837b6c7 |
| NasusQStacks.inibin | OLS-8a294be8-a381-5bbe-9da6-1eecd8a79dda |
| NasusQStacks.luaobj | OLS-c0809f3b-b821-5273-a3a7-c0206a31f9cb |
| NasusR.inibin | OLS-62f9c29c-50eb-5816-b088-02b8433066e8 |
| NasusR.luaobj | OLS-f07b53b4-f434-53f5-990e-29119f8d0db4 |
| NasusR.preload | OLS-4b44dd8a-bce3-5e3a-ae62-754ef766e2b6 |
| NasusRunCycleManager.luaobj | OLS-9e464021-f107-5d31-b7d9-c79357b06ced |
| NasusSkin5SFX.luaobj | OLS-a2e7e3b9-45c2-534a-b6cf-c8a194b58a65 |
| NasusSkin5SFX.preload | OLS-f526425d-92ca-5d2c-99d8-8d9132cbe731 |
| NasusTauntRenekton.luaobj | OLS-618f340d-8ced-573e-ac55-c82a42e1244a |
| NasusW.inibin | OLS-9e4c9ae4-866c-5164-85de-7a253cb6d453 |
| NasusW.luaobj | OLS-99e43b86-f988-5509-a161-6826e25dda57 |
| NasusW.preload | OLS-65893fa4-9a1e-5ef9-b91a-8a54a4fb6b62 |

## Exécution et résultats attendus/observés

Prérequis de phases/lots et dépendances recensés ; trois questions propres et quatre dépendances conservées. Compilation Rust `--locked --offline`, core réel hors configuration de test, dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et la chaîne antérieure sont conservées.

Trois parties publiques Nasus/Annie via Join/Buy/Move/Stop/Attack/Learn/Cast. Aucun dégât, soin, état ou niveau injecté. Deux déplacements de préparation par cas, tous réussis sans reprise. Tous les personnages restent vivants et niveau1, sans victoire, bouclier ou contrôle de foule. Nasus conserve ses rangs/délais nuls et son mana plein. PVmax561,20001, manamax275,60001.

Objets : Épée longue1036 (+10AD) et Sceptre vampirique1053 (+10AD,8%vol de vie), achetés dans des parties distinctes avec le budget initial. L’égalité d’AD entre ces deux cas isole l’effet du vol de vie.

| Cas | AD | AP | Vol de vie | Soin observé par impact hors régénération | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 59.18000 | 0.0 | 0.00000 | 0.00001 | 27 | 180 |
| LongSword10AD | 69.18000 | 0.0 | 0.00000 | 0.00001 | 27 | 180 |
| Vampiric10AD8percent_lifesteal_control | 69.18000 | 0.0 | 0.08000 | 4.64219 | 27 | 180 |

Chaque cas reçoit trois attaques Annie puis un Q brut80/coût60. Attente90ticks, trois attaques Nasus, attente90ticks. Total9impacts mêlée,9physiques entrants,3Q et540ticks d’attente. Les attaques Nasus ont un témoin windup avec cible et tick de libération ; celles d’Annie un projectile non critique. Pertes de PV comparées aux dégâts après mitigation et correction de régénération, résidus inférieurs à0,002.

Attendu pour le mécanisme courant : dégâts après mitigation × taux de vol de vie des objets. Observé avec Sceptre :4,642190PV, attendu4,642174, trois fois. Sans objet et avec Épée :0attendu, écart d’arrondi d’environ0,000009PV. Les ticks sans impact et les540ticks d’attente correspondent à la régénération seule. Nasus est assez blessé pour éviter le plafonnement ; PV pleins, anti-soin, amplification, surdégâts et boucliers restent non qualifiés ici.

Les81refus atomiques couvrent joueur inconnu, auto-ciblage, slot invalide et apprentissage/lancement ciblé/au sol des quatre sorts avant/après. Snapshots identiques après refus. Aucun sort Nasus accepté. Les attaques ordinaires et le vol de vie courant sont exercés, mais Q renforcée et combinaisons de sorts restent non qualifiés.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nasus-passive-soul-eater-probe.exe` ; 6117888octets ; SHA-256 `ea72220339e31457412145cd44d824d7a247a64a74fca2b02cf9deb088ac01b3`. BUILD/RUN :0. Aucun serveur original, rendu, audio ou transport réseau exécuté.

## Corrections d’outillage et échecs conservés

La première collecte V607 a renvoyé0 mais omettait les liens de tooltip : remplacement de nom ayant altéré DynamicTooltip en DynasuscTooltip. Script et relevé initiaux conservés ; un nouveau script/relevé `_discovery_qualified` corrige le champ. Aucune première collecte n’est présentée comme exhaustive.

La première inspection a réellement renvoyé1 sur l’hypothèse que toutes les clés de tooltip étaient résolues. La nouvelle inspection `_inspection_bindings` exige précisément cinq correspondances et la clé NasusQ non résolue. Elle vérifie le constat de la limite ; elle ne valide pas le tooltip manquant. Première inspection conservée. La vérification finale de ce constat renvoie0.

Les échecs antérieurs restent dans la chaîne : notamment trois essais Nami RUN101 et deux critères d’arrivée V606 échoués. Six trajets Nasus réussis ne ferment ni V564 ni ces deux écarts de navigation.

## Consommateurs actuels

Recherche enregistrée dans les fichiers Rust de crates/core/src : aucune occurrence des termes Nasus/Soul Eater et variantes sélectionnées. Ce constat lexical est complété par lecture des routes, statistiques et soins ainsi que l’exécution réelle ; il ne prouve pas une absence globale dans tout le projet.

`progression.rs` : life_steal est exclusivement `items.life_steal.max(0.)`. `lifesteal.rs` : basic_attack_hit utilise post_mitigation×rate puis heal sur les cibles non structure, lanceur vivant. Les modificateurs génériques de soins restent du contexte. Aucun bonus Nasus n’est ajouté à ce consommateur. Huit ressources locales (catalogue, croissance, ressources, attaques/critiques, collisions, boutique, QAnnie) sont reliées séparément de la source native.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Nasus spawn |
| crates/core/src/lib.rs:598 | public action andatomic refusal |
| crates/core/src/progression.rs:68 | ordinary AD and item-only lifesteal inputs |
| crates/core/src/progression.rs:150 | unsupported Nasus learning |
| crates/core/src/progression.rs:159 | unsupported Nasus ranks |
| crates/core/src/spells.rs:101 | unsupported Nasus spell action |
| crates/core/src/annie_w.rs:29 | unsupported Nasus ground cast |
| crates/core/src/lib.rs:685 | tick order and540idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,notnetwork acceptance |
| crates/core/src/damage.rs:53 | ordinary physical/magic damage and lifesteal basis |
| crates/core/src/attacks.rs:157 | Nasus melee and Annie ranged attacks |
| crates/core/src/lifesteal.rs:4 | item8percent ordinary lifesteal,not a native Soul Eater bonus |
| crates/core/src/regeneration.rs:32 | ordinary HP regen separated fromhealing |
| crates/core/src/regeneration.rs:10 | per-tick health correction |
| crates/core/src/shop.rs:261 | LongSword10AD andVampiricScepter10AD8percent |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | ordinary target state |
| crates/core/src/damage.rs:38 | postmitigation damage andlifesteal basis |
| crates/core/src/attacks.rs:26 | ordinary attack timing |
| crates/core/src/critical.rs:12 | ordinary critical attack profile context |
| crates/core/src/death_recap.rs:184 | context,notrendered recap |
| crates/core/src/death_recap.rs:200 | damage recap context |
| crates/core/src/healing.rs:16 | ordinary item healing;notpassive producer |
| crates/core/src/healing.rs:9 | generic received healing context;Ignite/Trundle modifiers unexercised |
| crates/core/src/annie.rs:45 | three accepted Q80raw60mana |
| crates/core/src/annie.rs:73 | three incoming Q hits |
| crates/core/src/ally_occupancy.rs:635 | six actual public travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | movement boundary,V564 remains open |

## Publication et conservation

Modifications : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json ; reçu docs/reference_requirement_trace_sources/nasus-passive-soul-eater-links-v607.json ; preuve docs/fidelity_nasus_passive_soul_eater_links_v607.json. Instructions copiables enrichies dans le plan et les deux bases SQLite (projet et application installée).

PREPARE/CHECK/PUBLISH/AUDIT :0 ;72associations invalides et4graphes invalides refusés. Trois fragments de traçabilité modifiés,42212identiques. Quatre lignes ciblées par base,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation ordinaire idempotente. Identifiants, phases/lots et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99105sources,4205consommateurs et4205ancres exactes, aucune divergence. La revue globale est structurelle (`source_hashes_verified=0`) ; hachages des sources sélectionnées et du code vérifiés séparément, sans revendiquer le recontrôle exhaustif de toutes les sources.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md mis à jour avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision607_Nasus_discovery_qualified/OBSERVATIONS.json ; revision607_Nasus_passive_probe/OBSERVATIONS.json ; revision607_Nasus_inspection_bindings/OBSERVATIONS.json ; revision607_Nasus/DELIVERY_AUDIT.json ; revision608_trace_review/REVIEW.json.

## Travail restant

1. Résoudre le pourcentage f1, niveaux et paliers de Soul Eater sur une preuve4.20.
2. Définir sa combinaison avec objets, runes et maîtrises puis ajouter le bonus au vrai consommateur des statistiques.
3. Qualifier dégâts admissibles, cibles champion/sbire/monstre/structure, Q renforcée et critiques.
4. Vérifier soins à PVpleins/manquants, dégâts nuls, boucliers, surdégâts, mort et simultanéité.
5. Vérifier anti-soin, amplification, objets/vente, progression, respawn et fin de partie.
6. Résoudre la clé de texte Q non liée et comparer les simplifications communautaires sans adoption automatique.
7. Qualifier séparément QWER, présentation, particules, animation, audio, HUD et réseau.
8. Conserver les cinq limites Battle Training et les écarts de navigation ouverts.

Les trois tâches Nasus restent ouvertes dans leurs états antérieurs. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision608_trace_review/REVIEW.json. V607 Nasus / Soul Eater : 32 sources natives, 96 associations, 28 points et 56 liens. Le tooltip donne f1% bonus Life Steal ; f1, niveaux et combinaison restent inconnus. Anciennes descriptions Singed PV/mana et réduction magique10% conservées sans adoption. Trois cas publics sans objet/Épée longue10AD/Sceptre10AD8%vol de vie : 9 attaques mêlée, 9 impacts physiques entrants, 3 Q Annie, 540 ticks et 81 refus atomiques. AD59,18/69,18/69,18 ; vol de vie0/0/8%. Seul le Sceptre rend environ4,64219PV par attaque. Les stats courantes additionnent seulement le vol de vie des objets : bonus natif non implémenté. Attaques ordinaires exercées, aucun sort Nasus accepté. 12Lua dont5limites NEWTABLE,7preloads,24lignes DDF dont2Q @stacks coeff3 sans résolution du passif ;16références communautaires. CharScript natif et communautaire vides. Q communautaire inflige des dégâts de sort immédiats et augmente AD global ; E annonce une réduction d’armure dans un commentaire sans application dans le corps lu. Aucun n’est adopté comme serveur original. Six clés de tooltip dont cinq résolues ; game_buff_tooltip_NasusQ non trouvé dans en_GB. Première inspection refusée sur cette clé, limite ensuite enregistrée sans résolution artificielle. Cinq chemins candidats absents, sans conclure à des assets absents. Six trajets sans reprise ; V564 et deux échecs de trajet V606 restent ouverts. Première collecte avec champ DynamicTooltip mal orthographié conservée puis corrigée dans un nouveau relevé. Aucun gameplay modifié. BUILD/RUN et inspection finale/PREPARE/CHECK/PUBLISH/AUDIT0 ; première inspection1 conservée. 72+4refus de publication. Prochain passif à inspecter réellement : Nautilus. Goal actif.
