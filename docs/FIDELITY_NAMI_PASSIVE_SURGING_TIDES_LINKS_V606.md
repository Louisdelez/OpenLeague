# SYS-01.2-02 — Nami : sources et consommateurs de Surging Tides (V606)

Date UTC : 2026-10-26T10:42:11.144890+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

## Résultat et limites

CH-Nami-PASSIF-SOURCE, CH-Nami-PASSIF-SIMULATION-CONTRAT et CH-Nami-PASSIF-SIMULATION sont reliées à 63 sources natives, 189 associations, 21 points du moteur et 42 liens sur les deux fiches de simulation. Les points restent des frontières et du contexte ; aucun consommateur complet du passif n’est démontré.

Le texte natif indique **40 + f1 de vitesse pendant 1,5 seconde**, après contact d’une compétence de Nami avec un champion allié. La formule f1 et les règles détaillées de déclenchement, de rafraîchissement et de cumul restent ouvertes. Le moteur refuse les sorts de Nami ; le déclencheur n’a donc pas pu être exercé.

Deux parties publiques mesurent les vitesses ordinaires et les refus. La collecte complète aboutit, mais **deux des huit critères d’arrivée des trajets mesurés échouent**. Trois essais interrompus précédents sont conservés. Aucun gameplay ni asset modifié ; ni déplacement, ni passif, ni champion déclaré terminé.

## Sources, provenance et inconnues

- Nami.inibin lie NamiPassive et NamiPassive.dds. Le nom Surging Tides est résolu en_GB ligne4413, la description ligne4237. Passive1Desc est une chaîne vide. Passive1Level1..4 sont les chaînes « 0 » ; 5..6 sont absents. Ces champs ne sont pas transformés en progression numérique qualifiée.
- NamiPassive.inibin lie le tooltip ligne2326 : contact avec un champion allié, 40+f1 de vitesse, 1,5 seconde. NamiPassivett.inibin lie le texte du destinataire ligne2327 : vitesse augmentée brièvement. Les champs SpellData sélectionnés (description/tooltip/icône, coût/cooldown, rayon/portée, coefficients, Effect1Level0..5) sont absents pour ces deux fichiers ; absence ne signifie pas zéro.
- Les 24 lignes de Nami.ddf ont lien et coefficient vides, dont quatre NamiPassive. Les entrées SowTheWind et QWER ne résolvent pas f1. Les coefficients Q0,5, W0,5/0,3, E0,2 et R0,6 concernent les sorts, pas la formule du passif.
- NamiPassive.luaobj utilise Janna_Tailwind.dds avec BuffName=NamiPassive, DoesntTriggerSpellCasts=true, PersistsThroughDeath=true et NonDispellable=true. L’icône ne donne pas la mécanique de Janna ; les indicateurs ne qualifient pas une charge ou une durée au respawn.
- NamiPassiveDebuff.luaobj utilise NamiPassive.dds, BuffName=NamiPassivett et Nami_Base_P_buf.troy. Le nom de fichier Debuff ne prouve pas un effet négatif. NamiRunSpeed.luaobj contient seulement PersistsThroughDeath=true, aucune formule de vitesse.
- CharScriptNami natif et communautaire sont vides. Le preload natif relie namipassive, apbonusdamagetotowers, namirunspeed et namijoke ; NamiE.preload relie namipassivedebuff. Le chargement effectif, la particule et le rendu ne sont pas validés par ces dépendances.
- Les alias Minotaur de NamiJoke/NamiRWaveStun et la clé ZyraSeedTrapVision de NamiRVision restent identifiés comme tels, sans politique étrangère adoptée.
- Sept liaisons BuffData sont résolues exactement une fois : ESlowtt, Ett, Passive, Passivett, Qtt, Rtt et RVision. Les six premières sont lignes2324–2329 ; RVision utilise la clé Zyra ligne3010.
- Les 26 Lua sont parcourus entièrement, sans prototype enfant : 12 initialisations littérales et 14 limites NEWTABLE dans les attaques et Q/W/R. Ces limites ne prouvent pas une corruption et ne valent pas exécution du serveur original.
- La sélection contient 23 INIBIN, 26 Lua, 12 preloads, un DDF et un fichier de langue. Aucun NightmareBotNami trouvé dans les emplacements inspectés.
- Sept chemins candidats sont absents : CharScript sous Scripts, les deux ressources Passive dans DATA/Spells global, Passive.preload, PassiveDebuff.inibin, Passivett.luaobj et Passive.ddf dans le dossier de sorts. **Les ressources réelles sont sous Characters/Nami/Spells ; le CharScript est à la racine du personnage.** Aucun manque global d’assets n’est déduit de ces chemins.
- Les 28 références communautaires sont présentes. QWER contiennent du code, sans référence directe NamiPassive/NamiPassivett. W traite une seule cible malgré un commentaire de rebond ; E applique NamiTidecaller ; Q temporise1,5s avant un contrôle ennemi ; R utilise un filtrage angulaire instantané. Ces scripts ne démontrent ni tous les contacts alliés, ni un passif complet, ni un consommateur Rust. Leurs commentaires ne remplacent pas leur code.

Les 63 sources sont comparées au registre et à l’appartenance RADS sélectionnée, avec taille et SHA-256.

| Fichier | Source |
|---|---|
| Nami.inibin | OLS-7586568b-0be1-5a8b-877f-f3da7f8b1206 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nami.ddf | OLS-1b99451f-82a0-5137-a890-f92f25dd88f8 |
| CharScriptNami.luaobj | OLS-72f36df5-3d6b-5f5f-adb9-10dcfacaec4e |
| CharScriptNami.preload | OLS-a8126727-3725-592f-84c2-cc627bd6f45d |
| NamiBasicAttack.inibin | OLS-0ed8ad3f-1c64-517e-ba7e-36deaf486247 |
| NamiBasicAttack.luaobj | OLS-d9335fca-f001-5c42-a1f5-fe8a46a3d2e1 |
| NamiBasicAttack2.inibin | OLS-96985971-1878-53c5-a01a-ae06dd147782 |
| NamiBasicAttack2.luaobj | OLS-cfc835a2-160a-5bdc-aa3e-f8acb9cd33f7 |
| NamiBubbleMARKER.luaobj | OLS-8630d7fc-11bc-5384-bf01-46dbb93b03a6 |
| NamiCritAttack.inibin | OLS-6aeb78c7-3c28-54e4-b2bd-ff0955b109d5 |
| NamiCritAttack.luaobj | OLS-5d06b2f6-9c16-5189-8360-15a33b43ff16 |
| NamiE.inibin | OLS-ed9631e3-305e-5deb-a96e-a1e76b34e727 |
| NamiE.luaobj | OLS-7d87dd64-3720-52c6-b530-8582111051d5 |
| NamiE.preload | OLS-c9b51def-cbb4-50e7-a0e8-085685c868cf |
| NamiESlow.luaobj | OLS-045ead8e-3734-5b23-bcf1-f27808ceed5d |
| NamiESlowtt.inibin | OLS-c173461c-ddff-5696-89c9-2fc9827c0000 |
| NamiEtt.inibin | OLS-6fea9b3a-277e-569a-9644-20a3808d28d1 |
| NamiJoke.luaobj | OLS-68ac8bdc-b801-50c6-89ff-d0219a3f6037 |
| NamiJoke.preload | OLS-c678b8c1-9079-55e9-81ed-93d7518263a9 |
| NamiPassive.inibin | OLS-4fbc5b0f-4cfd-5d32-95f3-ce101ef76cb7 |
| NamiPassive.luaobj | OLS-2dd88cc0-f9d0-5d1a-9c97-cc2354d54186 |
| NamiPassiveDebuff.luaobj | OLS-be0815b5-f1d5-5d3b-860b-559ae8b6ef97 |
| NamiPassivett.inibin | OLS-6fc76548-e848-5b97-9cae-8fe6528f319e |
| NamiQ.inibin | OLS-9d76ee4c-c848-5a7a-9768-4217670c4db7 |
| NamiQ.luaobj | OLS-38e27ea8-1001-5073-808c-f2c66af14a77 |
| NamiQ.preload | OLS-e0503e42-22b2-5a13-ba6d-cf0ee6f4ec6d |
| NamiQDebuff.inibin | OLS-ace37660-26fb-59a2-a02e-6a9287d10275 |
| NamiQDebuff.luaobj | OLS-dcb5ab62-a989-5335-a346-4a308d5441a2 |
| NamiQDebuff.preload | OLS-275d7645-5b7f-579d-bb6b-bbc431946a1c |
| NamiQDummyMissile.inibin | OLS-27126d3d-de76-527f-93fe-6255c31facb2 |
| NamiQDummyMissile.luaobj | OLS-5a961760-72c8-5665-88be-61dc942017b4 |
| NamiQFakeKnockup.luaobj | OLS-b87a2c38-3c00-5792-924d-7397442ce5e1 |
| NamiQMissile.inibin | OLS-7930ecc4-0f21-5833-98f8-58a2929425e6 |
| NamiQMissile.luaobj | OLS-901f491e-c8c3-5e1d-aa9a-c203648a7aa7 |
| NamiQMissile.preload | OLS-3a0c622d-2037-5bf6-a872-ffe5dfb03745 |
| NamiQtt.inibin | OLS-c3771597-26f1-5a64-a994-bd163703b51f |
| NamiR.inibin | OLS-d4159b7f-7853-50a3-85b1-de91939783ee |
| NamiR.luaobj | OLS-378f66b4-6b9e-5d1f-bda6-d1541f4e52d7 |
| NamiR.preload | OLS-2168fc4c-95e2-5b77-a0af-79ddaf582ec0 |
| NamiRMissile.inibin | OLS-a4ee0c03-0ceb-5e53-9f3c-64b7aa1a5f20 |
| NamiRMissile.luaobj | OLS-d8737cee-2d75-5a41-86ec-58bbe343c1c3 |
| NamiRMissile.preload | OLS-77378f36-bded-538b-a049-cb120ed496be |
| NamiRtt.inibin | OLS-0f7f7ee5-ef6f-59e9-808c-b1853c70b8b6 |
| NamiRunSpeed.luaobj | OLS-b6b44b6d-9ea8-58db-bd0e-3ce99368f010 |
| NamiRVision.inibin | OLS-52c76755-4b81-5663-adc0-a6e38398710b |
| NamiRVision.luaobj | OLS-b127eba9-60d8-568f-a783-e48b16bb3b2a |
| NamiRWaveSlow.luaobj | OLS-5003eb6f-8ac3-5622-9ae0-cbe0653c41c2 |
| NamiRWaveStun.luaobj | OLS-aea22ecb-7686-52a8-84b4-27f73bfc3c12 |
| NamiW.inibin | OLS-e368e7c9-8fac-5d51-a1f3-5f9f9670f2a9 |
| NamiW.luaobj | OLS-6b592d99-686e-58fe-8329-b0cf715f1807 |
| NamiWAlly.inibin | OLS-f1a2379e-f5f9-5aaa-9b63-375a39d16f33 |
| NamiWAlly.luaobj | OLS-30ea4cc4-7b6b-5f41-bedb-8da9ec3eae8f |
| NamiWAlly.preload | OLS-fdb945dd-4679-54fe-a70d-80f7f5e23263 |
| NamiWEnemy.inibin | OLS-27cd3909-24e1-55bb-b907-02dfdc05b081 |
| NamiWEnemy.luaobj | OLS-e320f972-4d22-5cb6-b9e7-61fc59482279 |
| NamiWEnemy.preload | OLS-6d8c4fe5-32e4-5d68-ab38-1c6c38b6b0b7 |
| NamiWMissileAlly.inibin | OLS-eaa329d4-509f-5ff3-9ac6-e9709d6841fd |
| NamiWMissileAlly.luaobj | OLS-37e3a0dd-fa29-5a52-9b9e-58dc75c9ccb7 |
| NamiWMissileAlly.preload | OLS-39eef882-9eac-5e91-9c7a-559a191fd58b |
| NamiWMissileEnemy.inibin | OLS-66521ed8-9731-5dfe-a6eb-00b7913b6778 |
| NamiWMissileEnemy.luaobj | OLS-d9120f25-5dd4-5a0e-a3be-1023b9e026a6 |
| NamiWMissileEnemy.preload | OLS-99e34a69-7a94-5040-9dde-49fb7cc1628b |

## Prérequis et diagnostic public

Phases, lots, dépendances et questions sont enregistrés dans les observations. Trois questions propres et quatre dépendances de tâches restent ouvertes selon leurs états antérieurs. Cet audit ne lève pas les prérequis de fidélité.

Compilation Rust `--locked --offline` du core réel hors configuration de test, dépendances et checksums alignés sur Cargo.lock. Les 1158 entrées core/ressources et la chaîne des preuves antérieures restent inchangées. Aucun changement direct de position, dégât, soin, XP ou état. Les actions utilisées passent par Join/Buy/Move/Stop/Attack/Learn/Cast publics ; aucune compétence Nami n’est acceptée.

Participants : Nami21 et Ahri23 alliées, Annie22 ennemie. Deux cas : sans objet ; puis Bottes1001 (+25 vitesse,325or) et Tome1052 (+20AP,435or), soit760or dans le budget825. Tous restent vivants au niveau1, sans victoire, mort, ralentissement ou étourdissement. Mana, rangs et délais Nami/Ahri restent pleins/nuls selon leur nature.

| Cas | Vitesse Nami | Vitesse Ahri | AP Nami | Trajets mesurés réussis | Échantillons | À pleine vitesse | Refus |
|---|---:|---:|---:|---:|---:|---:|---:|
| base | 335.0 | 330.0 | 0.0 | 3/4 | 258 | 100 | 51 |
| Boots25_Tome20AP_control | 360.0 | 330.0 | 20.0 | 3/4 | 254 | 98 | 51 |

La préparation finale ordonne simultanément les trois déplacements, avec une limite de2400ticks et une tolérance d’arrivée inférieure à1. Chaque cas atteint les trois buts en1037ticks, sans reprise Move. Aucun instantané ne remplace une position pour obtenir cette réussite.

Chaque cas comporte deux attentes de46ticks, soit184ticks au total. Les offsets44/45/46 entourent la conversion locale de1,5seconde à30Hz, mais **aucun buff n’est actif : ces offsets ne sont pas son âge et ne valident pas son expiration**. Les vitesses restent335/360 pour Nami et330 pour Ahri.

Les 102 refus atomiques couvrent, par cas : joueur inconnu, auto-attaque, slot invalide ; avant et après les observations, apprentissage de chaque slot, lancement vers soi, allié, ennemi, sans cible et au sol à la position alliée. Chaque snapshot avant/après refus est identique. Ces refus ne permettent pas de qualifier l’éligibilité native de soi ou d’un allié.

Les huit trajets mesurés enregistrent512 déplacements par tick, dont198 égaux au budget vitesse/30 à la tolérance0,003. Aucun pas ne dépasse ce budget. Les corrections de régénération restent sous0,002. Le critère nominal reste « arrivée à moins de1 unité et au moins10 échantillons à pleine vitesse » : six trajets passent, deux échouent.

### Échecs de déplacement conservés

1. `revision606_Nami_passive_probe` : BUILD0, RUN101, arrêt sur `arrived` durant une installation successive ; le superviseur renvoie1.
2. `_diagnostic` : BUILD0, RUN101, même installation avec journal détaillé. Nami21, but(7534,9819 ;6934,2402), reste vers(1054,8118 ;7275,8491) au tick2400, avec destination toujours active et aucune reprise. Ahri est encore près du départ. La cause exacte n’est pas attribuée à la seule présence de l’alliée.
3. `_concurrent` : BUILD0, RUN101 ; l’installation simultanée dépasse la première difficulté, puis le critère `arrived && full >= 10` d’un trajet mesuré interrompt l’essai. Le journal original est conservé.

Le collecteur `_walk_observations` conserve les mêmes seuils et enregistre chaque résultat au lieu de s’arrêter au premier critère échoué. Il retourne0 pour la collecte complète, **avec nominal_walk_checks_all_passed=false et movement_fidelity_accepted=false**. Aucun échec n’est converti en réussite.

Dans les deux cas complets, Ahri part de(8134,9819 ;6934,2402) vers(8434,9814 ;6934,2402), s’arrête à(8398,9814 ;6934,2402), soit36unités avant le but, et perd sa destination. Sur180échantillons :24pas à pleine vitesse, puis156pas nuls. Le retour aboutit. Les quatre trajets Nami et les deux retours Ahri satisfont les critères ; les deux allers Ahri échouent. Aucun nouvel ordre de reprise n’est ajouté pendant ces trajets mesurés.

La collecte documente les vitesses et l’interruption. Elle ne répare pas la navigation. V564 reste ouvert, sans affirmer que ces arrêts ont nécessairement la même cause. Les binaires, sources, journaux et reçus des trois essais antérieurs sont pinés dans la chaîne du collecteur final.

Binaire final : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nami-passive-surging-tides-probe-walk-observations.exe` ; 6086144 octets ; SHA-256 `2c869cb5bbf12223895cb7a11c7f5adfb9f9346383604ed4daf0ccf153cef9e4`. BUILD/RUN de la collecte complète et inspection renvoient0 ; les deux critères de trajet restent échoués. Aucun serveur original, rendu graphique, audio ou transport réseau exécuté.

## Consommateurs actuels

La recherche enregistrée dans les fichiers Rust du core utilise des mots précis (`Nami`, `NamiPassive`, `Surging Tides`) pour éviter de confondre Nami avec « dynamic ». Aucun de ces termes n’est trouvé. Ce constat lexical complète la lecture des routes learn/cast/cast_at et movement_speed ainsi que les refus réellement exécutés ; il ne prouve pas seul une absence dans tout le projet.

stats, shop et movement_speed consomment les vitesses et bonus ordinaires. effective_speed_with_slow/soft_cap traitent des modificateurs existants ; leurs autres seuils et interactions ne sont pas qualifiés par les seuls cas335/360/330. Aucun producteur Surging Tides n’est identifié dans ces chemins. advance_allied_motion, fit_step et note_ally_move sont reliés aux observations et limites de déplacement, sans validation générale de navigation.

Six ressources locales : catalogue, croissance, ressources, collisions, boutique et movement_rules. Leurs règles reconstruites ne remplacent pas la politique native du passif.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | three public participants,ally/enemy identity |
| crates/core/src/lib.rs:598 | public self/ally/enemy/none/ground refusals |
| crates/core/src/progression.rs:68 | ordinary AP/speed inputs |
| crates/core/src/progression.rs:150 | unsupported Nami learning |
| crates/core/src/progression.rs:159 | unsupported Nami ranks |
| crates/core/src/spells.rs:101 | unsupported Nami targeted casts |
| crates/core/src/annie_w.rs:29 | unsupported Nami ground casts |
| crates/core/src/lib.rs:685 | 184idle ticks;offsets notactivebuff age |
| crates/core/src/lib.rs:744 | movement/wait/refusal witnesses,notnetwork acceptance |
| crates/core/src/regeneration.rs:32 | ordinary HP/resource policy |
| crates/core/src/regeneration.rs:10 | per-tick health correction |
| crates/core/src/shop.rs:261 | Boots25speed/Tome20AP actual public purchases |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | ordinary target eligibility boundary |
| crates/core/src/ally_occupancy.rs:635 | sixarrived/twofailed measuredwalks;notnavigationacceptance |
| crates/core/src/ally_occupancy.rs:526 | movement step boundary,V564 open;failure causeunqualified |
| crates/core/src/movement.rs:53 | Nami335/360,Ahri330,notpassiveproducer |
| crates/core/src/movement.rs:37 | stats movement consumer |
| crates/core/src/movement.rs:19 | shared caps context,thresholds not exercised |
| crates/core/src/movement.rs:38 | shared modifiers context,notNami producer |
| crates/core/src/ally_occupancy.rs:582 | public movement order bookkeeping |

## Livraison et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/nami-passive-surging-tides-links-v606.json ; preuve docs/fidelity_nami_passive_surging_tides_links_v606.json. Les instructions copiables contiennent sources, inconnues, essais échoués, critères de trajet encore en échec et travail restant. SYS-01.2-02 reçoit la synthèse.

PREPARE/CHECK/PUBLISH/AUDIT renvoient0 pour la livraison de ces constats. Les 72 associations volontairement altérées et4 graphes invalides sont refusés. Trois fragments de traçabilité changent,42212 restent identiques. Les deux bases SQLite reçoivent quatre lignes ciblées ;42603 autres lignes,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Identifiants, phases/lots et inconnues identiques octet par octet. Aucun statut, critère, propriétaire, note ou case fermé automatiquement.

Revue globale :99101 sources,4177 consommateurs et4177 ancres exactes,aucune divergence. source_hashes_verified=0 désigne le contrôle structurel global ; les sources sélectionnées et consommateurs sont hachés séparément. Aucun nouveau contrôle exhaustif des99101 sources n’est revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés en préservant les preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision606_Nami_discovery/OBSERVATIONS.json ; revision606_Nami_passive_probe_walk_observations/OBSERVATIONS.json ; revision606_Nami_inspection_qualified/OBSERVATIONS.json ; revision606_Nami/DELIVERY_AUDIT.json ; revision607_trace_review/REVIEW.json. Les trois répertoires d’essais échoués restent présents.

## Travail restant

1. Résoudre f1, sa dépendance aux statistiques et la politique de capture/recalcul.
2. Implémenter les sorts producteurs et les contacts admissibles avec soi ou les alliés, sans extrapoler depuis les seuls noms de buffs.
3. Relier le bonus aux statistiques et au déplacement effectif ; qualifier caps, ralentissements et autres bonus.
4. Qualifier chaque contact Q/W/E/R, rebond, soin à PV pleins, traversée, annulation et mort avant impact.
5. Tester application, rafraîchissement, cumul, simultanéité et expiration autour des limites d’un buff effectivement actif.
6. Diagnostiquer les arrêts de navigation enregistrés, conserver les critères échoués et distinguer leur cause de V564 tant qu’elle n’est pas démontrée.
7. Vérifier mort/respawn, dissipation, déconnexion et fin de partie.
8. Qualifier séparément HUD, icônes, particules, animations, sons, rendu et réplication.

Les trois tâches Nami conservent leurs états antérieurs. Les lacunes Battle Training restent ouvertes. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision607_trace_review/REVIEW.json. Nami V606 intégré : 63 sources, 189 associations, 21 points, 42 liens. 63 sources natives, 28 références communautaires, 26 Lua dont 14 limites NEWTABLE, 12 preloads, 7 buffs résolus et 24 lignes DDF vides. Le tooltip donne 40+f1 de vitesse pendant 1,5 seconde sur contact d’une compétence avec un champion allié ; f1 et les règles détaillées restent inconnus. Icônes Janna/Minotaur et clé Zyra conservées sans politique étrangère. CharScript vides ; 7 chemins candidats absents, ressources réelles dans Characters/Nami/Spells. Deux cas publics à trois joueurs, sans objet puis Bottes25/Tome20AP : Nami335/360, Ahri330, 102 refus atomiques et 184 ticks d’attente. Aucun sort Nami accepté ; contact allié non exercé. Huit trajets mesurés : six réussis, deux échoués à 36 unités du but, destination supprimée et 156 ticks immobiles sur 180. 512 échantillons dont 198 à pleine vitesse. Le collecteur aboutit mais les deux critères d’arrivée restent échoués ; aucune acceptation de navigation ou de passif. Trois essais BUILD0/RUN101 conservés : deux installations successives arrêtées près du départ, puis un arrêt sur un critère de trajet mesuré après installation simultanée. Le relevé final conserve ces échecs et le critère d’arrivée inférieur à 1, sans le convertir en réussite. Installation simultanée finale : 1037 ticks par cas, six trajets de préparation, aucune reprise Move. Cause exacte ouverte ; V564 reste ouvert sans attribution automatique. Collecte finale/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ; 72+4 refus d’association/graphe. Conserver toutes les preuves et les critères de mouvement échoués. Prochain passif à inspecter réellement : Nasus. Goal actif.
