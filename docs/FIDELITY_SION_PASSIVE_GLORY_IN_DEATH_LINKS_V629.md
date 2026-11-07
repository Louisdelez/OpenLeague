# Sion — Glory in Death : sources et consommateurs V629

Date UTC : 2026-10-26T17:53:09.614341+00:00. Projet : F:/OpenLeague. Exigence SYS-01.2-02.

## Résultat et portée

Trois fiches Sion (SOURCE, SIMULATION-CONTRAT, SIMULATION) et la synthèse SYS-01.2-02 sont enrichies : 150 fichiers natifs, 450 associations, 26 points précis du moteur et 52 liens. Les points du moteur sont des frontières de comportement générique, pas une implémentation du passif. Aucune modification du gameplay. Aucun champion ou jeu déclaré terminé.

Deux cas publics au niveau 1, sans injection directe d’état, montrent la mort normale puis la réapparition après 480 ticks. Aucun intervalle réanimé observé. Les sources natives décrivent pourtant une réanimation permettant le déplacement et l’attaque, avec perte de vie, 100 % vol de vie, bonus physique de 10 % des PV maximum de la cible (maximum 75 contre les monstres) et remplacement des quatre sorts par Death Surge. L’écart est lié aux consommateurs de mort, commandes, attaques, statistiques et réapparition.

Référence : PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue 4.20.1 distinct. Le serveur historique n’a pas été exécuté.

## Sources natives et identités distinctes

La sélection contient 57 INIBIN, 66 Lua compilés, 25 preloads, un DDF et le fichier de traduction. Les appartenances RADS et les empreintes exactes sont conservées dans le reçu. La découverte reprend aussi les sources déjà liées aux exigences : elle ne dépend pas seulement d’un préfixe de nom.

- `Characters/Sion/Sion.inibin` : PV 542,6400146484375, AD 59,720001220703125, mana 275,6000061035156 ; Passive1LuaName=SionPassive, icône Sion_Passive1.dds, QWER=SionQ/W/E/R. PARType et Passive1Level1..6 absents : aucun défaut natif inventé.
- `Characters/Sion/Spells/SionPassive.inibin` : 43 octets, SHA256 c04b93841c6f06b58886a97b503675a88ff44462ea0233be1554ca2e3c998a7b, BuffData.DynamicTooltip=game_buff_tooltip_SionPassive ; texte de réanimation décrit ci-dessus.
- `Characters/Sion/SionPassive.inibin` : 1254 octets, SHA256 b865d50d7b2bb932609646e247520bc67367353e3a4776b2f2c66500dde5e65b ; définition Data 420 PV/50 AD, distincte du fichier Spells homonyme. Les variantes racines SionBerserk et SionMax ont également 420 PV/50 AD. Leur sélection et leur rôle réel restent inconnus ; ces valeurs ne sont pas adoptées comme statistiques de réanimation.
- `Characters/Sion/CharScriptSion.luaobj` est présent à la racine et vide de callbacks. `Characters/Sion/Localization/Sion.ddf` est présent. Les quatre chemins candidats absents sont consignés ; ils ne prouvent pas un manque global d’assets.
- `Spells/Glory_in_Death.inibin`, SionPassiveDelay et SionPassiveZombie résolvent le texte Zombie. Le preload SionPassive référence Delay et Speed : dépendances de chargement, pas scénario exécuté.
- SionPassiveSpeed décrit Death Surge sans coût. SpellData expose Cooldown100, Effect1=100, Effect2=30, Effect3≈0,15, Effect4=0,1. Les producteurs et rôles effectifs de ces nombres ne sont pas qualifiés depuis leurs seuls noms.

Les 37 liens BuffData produisent **19 traductions exactes et 18 non résolues** dans le font sélectionné. Les clés non résolues, notamment SionWPassive sur plusieurs ressources, sont conservées, sans alias automatique. Des métadonnées VarusQ, ForcePulse et ZiggsSnowday sont présentes ; aucune règle de ces champions n’est importée.

Les 66 Lua sont lus complètement, sans prototype de callback enfant. Le lecteur de littéraux s’arrête sur NEWTABLE pour 21 fichiers, dont SionPassive. Les constantes SionPassiveTooltip, PersistsThroughDeath et ZiggsSnowday ne deviennent pas des valeurs globales évaluées par déduction. Le DDF contient 12 lignes et 5 liaisons non vides : R bonusAD0,4/0,8 ; Q AD0,6/1,8 ; W health0,1. Il ne livre pas de formule de décroissance du passif. Les rôles f1/f2 du W doivent être comparés au texte sélectionné au lieu de les fusionner.

## Références communautaires : présence et limites

63 références locales sont inspectées statiquement : les 59 de la découverte initiale et quatre fichiers complémentaires déjà recensés dans le registre (`Buffs/Sion/Passive.cs`, `PassiveHandler.cs`, `PassiveSpeedBuff.cs`, `Characters/Sion/Passive.cs`). Leurs empreintes et contenus sont dans l’inspection. Aucun moteur C# lancé.

Le CharScript écoute la mort, applique SionPassiveDelay pendant 2 s et utilise un compteur de résurrections pour réinscrire l’écouteur. Le handler rend temporairement non ciblable, appelle `champion.Respawn()` avec un TODO sur la position puis ajoute SionPassive pendant 60 s. Le buff remplace les quatre emplacements par SionPassiveSpeed et restaure QWER à la sortie ; il applique alors 100000 dégâts vrais internes et retire les buffs. Il applique une décroissance sous condition timer>250 avec formule `1+level+tickCount*(0.7*(level*0.7))`. Unités du temps, ordre, réentrance, prévention de boucle et fidélité au serveur 4.20 ne sont pas prouvés. Les particules sont commentées comme non fonctionnelles. Ce buff sélectionné ne définit pas le bonus de 10 % PV max, le vol de vie 100 % ou la cadence rapide.

Death Surge communautaire ajoute un buff 1,5 s donnant +50 % vitesse. Le TODO de décroissance est explicite. Ces valeurs ne sont pas promues en règle native.

Les QWER communautaires mélangent des comportements :

| Sort | Source native sélectionnée | Code communautaire observé et limite |
|---|---|---|
| Q | Charge jusqu’à 2 s, dégâts physiques de zone, knock-up/stun après 1 s | Dégâts magiques ciblés 20×rang+AP, stun ; comportement divergent |
| W | Cumul PV et bouclier 6 s, détonation possible après 2 s, dégâts %PV cible | Callbacks de kills +2/+10 PV ; pas de bouclier/détonation dans ce fichier ; assistance/grands monstres non qualifiés |
| E | Onde, slow et réduction d’armure 2,5 s, repoussement des non-champions | Bouclier ajouté à OnActivate, dégâts 70–210+0,4AP ; ces effets natifs non démontrés |
| R | Charge dirigée 8 s, immunité CC, collision, zone et stun progressifs | Bonus AD50/75/100 et buff30s, commentaire ancien Sion ; pas une preuve de charge |

## Contrôles réels : attendu et observé

Le diagnostic utilise le crate courant, en profil non-test, compilation `cargo build --locked --offline --message-format=json`. Les 1158 entrées de code et ressources, Cargo.lock et les preuves antérieures sont revérifiés avant/après. Commandes de déplacement, achat du Rubis, attaques, morts par coups reçus et réapparitions utilisent l’API publique. Vente et rachat non testés.

| Cas | PV max | Impacts reçus jusqu’à la mort | Attaques ordinaires | Délai de réapparition | Refus dont mort |
|---|---:|---:|---:|---:|---:|
| base | 542.64001 | 15 | 6 | 480 | 72 / 45 |
| Ruby150HP | 692.64001 | 19 | 6 | 480 | 72 / 45 |

Total : 12 attaques sortantes, 34 impacts physiques reçus, deux morts, deux réapparitions, six trajets arrivés, zéro réordre de déplacement, **144 refus atomiques dont 90 après la mort**. Trois attaques avant et trois après réapparition par cas : dégâts 50,092254638671875, cohérents avec attaque ordinaire et mitigation. AD59,72, cadence44ticks et vol de vie0. Rubis augmente les PV maximum de150 ; aucun bonus passif supplémentaire déduit.

Après chaque coup létal, 480 trames sont observées : les 479 premières restent à0PV, position de mort conservée ; au tick480, PV/mana pleins et retour à la fontaine. À trois instants de la période morte, 15 commandes (Move/Attack/Stop et apprendre/lancer/lancer à position pour QWER) sont refusées `champion dead`, avec snapshot inchangé. Ces refus vérifient le contrat générique actuel et montrent l’absence de transition réanimée dans ces cas ; ils ne qualifient pas le passif attendu.

Le code de `command` refuse les actions à health<=0 ; `apply_damage` programme le délai générique ; `advance_respawns` restaure le personnage à la fontaine. Une recherche précise Sion/SionPassive/Glory in Death dans le crate core ne trouve aucune branche dédiée. Cette recherche complète les cas exécutés, elle ne remplace pas leur preuve.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-sion-passive-glory_in_death-probe.exe` ; 6149120 octets ; SHA256 `2e29db3aaa74728ca85e3a5145e4194e6da41b2df30b304f0ff3533453ca6d27`.

Résultats : BUILD0, RUN0, collecteur0 ; première inspection1 à cause d’un décompte attendu18 au lieu des19 traductions exactes ; inspection corrigée0 conservée séparément. Un préflight du générateur avait également refusé un identifiant Python contenant des espaces ; corrigé avant toute publication. Aucune de ces corrections n’a relancé le diagnostic ni modifié les sources de jeu.

## Intégration au plan et conservation

PREPARE, CHECK, SCOPE_CHECK, PUBLISH_SCOPE et AUDIT_SCOPE réellement exécutés :0. 72 mutations d’association et 4 mutations du graphe refusées. Les trois aperçus de trace et les quatre copies de tâches sont vérifiés avec leurs instructions et limites. Le libellé privé hérité `public_move_stop_buy_sell` était trop large : le contrôle de portée conserve cette ancienne sortie, vérifie le source du diagnostic et publie explicitement `public_move_stop_buy=true`, `public_sell_or_rebuy_executed=false`. Le reçu `RUNTIME_SCOPE_CHECK.json` relie la correction aux preuves initiales ; aucune vente/rachat revendiquée par la preuve publique.

Les deux bases (projet et application installée) ont quatre lignes enrichies. Les 42603 autres lignes du catalogue, 42607 états manuels, 23 historiques, phases, lots et groupes sont conservés. Synchronisation normale idempotente. Trois questions propres et quatre dépendances gardées ouvertes. Identités, hiérarchie et registre d’inconnues inchangés à l’octet.

Revue globale : 99193 sources, 4755 consommateurs ; 4755 ancres exactes sans divergence. Le contrôle global est structurel ; la validation des octets de la sélection repose sur les empreintes de découverte, inspection et diagnostic, pas sur une prétendue relecture de tous les assets.

Fichiers produits/modifiés :

- `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`.
- `docs/reference_requirement_trace_sources/sion-passive-glory_in_death-links-v629.json`, `docs/fidelity_sion_passive_glory_in_death_links_v629.json`, présent rapport.
- `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md` et checkpoint privé.
- Bases `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3` ; sauvegardes privées avant modification.
- Scripts et preuves dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision629_Sion*`. Aucune ancienne preuve réécrite, aucun stage/reset/commit.

## Travail restant précis

1. Retrouver/qualifier délai, PV initiaux, cadence, progression de perte de vie, durée et vitesse du passif natif ; conserver distinctes variantes Data et BuffData.
2. Implémenter la transition vivant→mort→réanimé→mort, position, ciblage, interruptions, finalisation et absence de récursion ; intégrer correctement compteur de mort, crédit de kill et minuterie de réapparition.
3. Implémenter et tester 100%vol de vie, bonus physique10%PVmax, cap75contre monstres, mitigation, soins, arrondis et interactions avec objets/niveaux ; ne pas généraliser le cap aux sbires.
4. Remplacer/restaurer les quatre sorts avec Death Surge, en qualifiant son coût, recharge, vitesse et décroissance.
5. Séparer cumul de PV du W, sorts QWER remaniés et ancien code communautaire divergent.
6. Qualifier présentation HUD/VFX/sons/animations et réseau indépendamment. Aucun rendu, binaire historique, transport réseau ou partie multijoueur testé ici.
7. Maintenir ouvertes les traductions non résolues et limites du lecteur Lua ; ne pas résoudre une inconnue par une simple association documentaire.

Les limites V564/V606 et les cinq lacunes Battle Training restent locales et documentées ; elles n’empêchent pas cette progression indépendante. Goal actif, tâche globale incomplète.

## Ancres actuelles exactes

| Fichier et ligne | Rôle contrôlé |
|---|---|
| crates/core/src/lib.rs:533 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lib.rs:598 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/progression.rs:68 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/progression.rs:150 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/progression.rs:159 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/spells.rs:101 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/annie_w.rs:29 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lib.rs:685 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lib.rs:744 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/damage.rs:53 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/attacks.rs:157 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lifesteal.rs:4 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/regeneration.rs:32 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/regeneration.rs:10 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/shop.rs:261 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/shop.rs:215 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/world.rs:226 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/damage.rs:38 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/attacks.rs:26 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lifecycle.rs:16 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lifecycle.rs:24 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/ally_occupancy.rs:635 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/ally_occupancy.rs:526 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/spells.rs:5 | current Sion generic death,respawn,attack,resource or explicit dead-command boundary |
| crates/core/src/lifecycle.rs:33 | current generic respawn after480ticks;no Sion reanimation |
| crates/core/src/lifecycle.rs:6 | native baseline table distinct from Sion passive lifecycle |

## Index de sélection native

Chaque entrée porte son chemin complet pour éviter la confusion des noms identiques. Les SHA et appartenances sont dans le reçu associé.

| Chemin | Identité de source |
|---|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Sion.inibin | OLS-6c154d89-6f45-5702-b53d-ab004a4c263e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Localization\Sion.ddf | OLS-115ab243-1593-5849-ad8d-ad41a92c8dba |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\CharScriptSion.luaobj | OLS-beadf31b-3d84-5eed-9069-01731a01d70f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\CharScriptSion.preload | OLS-6a193fe2-c046-5860-aead-b31f9c1a0a0e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\Glory_in_Death.inibin | OLS-90415b82-61d0-51d7-aa12-54b11f95f650 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttack.inibin | OLS-1740cd39-a75a-5e1b-a55a-1681efef4dd8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttack2.inibin | OLS-9e2f38f0-7945-57e3-8b59-3ca18911435a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttack3.inibin | OLS-74e0d314-3c97-57db-b1d9-f19483a4ff6c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackPassive.inibin | OLS-f68d4cc1-c357-5343-a381-884e9cac0a79 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackPassive.luaobj | OLS-5831f033-72df-56dd-a0b6-b185630fcc6c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackPassive2.inibin | OLS-74e9048e-df87-5dce-b373-d79bdaca573a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackPassive2.luaobj | OLS-df253b3d-1730-57a3-b7cf-33d64727705c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackTower.inibin | OLS-aa88bd6b-3484-5fea-a6c5-f41ad10c9ab8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackTower.luaobj | OLS-bdaa7d5c-98ad-5755-9978-4eb3b1d3a3c3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackTower2.inibin | OLS-c53e7934-fae7-5737-952b-b2c97ea308fd |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionBasicAttackTower2.luaobj | OLS-d4a48674-7b91-5a55-88f9-34302bfd8f0a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionCritAttack.inibin | OLS-ee51a9a9-7e51-568c-ac5a-2d5d5fb788b2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionE.inibin | OLS-f6b92edd-5f89-510c-a3f7-dfc097bfebd6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionE.luaobj | OLS-bab5b06c-7a39-50ee-8b9f-a0a0d26409f1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionE.preload | OLS-729efcc7-e589-5bfa-98f5-07d379bf50e0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEArmorShred.inibin | OLS-db897181-9e23-56a4-b6af-5fb23ebf503e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEArmorShred.luaobj | OLS-260d38f2-37f7-5c46-a879-57182421726f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEArmorShred.preload | OLS-27394382-f6c7-5dac-9634-7f351f3874e9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMarker.luaobj | OLS-b38c6c44-80b8-5cb2-958a-ff28dcdde5f4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMarker.preload | OLS-6261d77f-d236-5a93-8a43-53d01d0f9a5b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMarker2.luaobj | OLS-d7abb4c4-ceee-5eb2-bb29-388b9a9a6cc8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMarker2.preload | OLS-6c80a2b2-8c44-538b-a3a8-83e3d2046da6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMinion.inibin | OLS-d17550f3-750e-5569-8e3e-3a29923ff1f9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMinion.luaobj | OLS-10592f35-0442-55ba-99bc-237de727f787 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMinion.preload | OLS-80e82293-c6d1-5e9b-b735-661143d9c8a9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMinionCD.luaobj | OLS-94fda582-d286-58d4-947f-b975cac967b9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMissile.inibin | OLS-bacd1899-47f9-5ffc-839c-061a347be034 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMissile.luaobj | OLS-d829b7b1-0044-5692-a3d0-dcbe88ece1fd |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionEMissile.preload | OLS-754e6315-69e6-58ec-b612-9bb2ac7af70f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionESlow.inibin | OLS-1402153b-e7c4-50ff-aba0-9c68614724d6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionESlow.luaobj | OLS-de3f1467-e32d-517a-945a-429be976a2f6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionESlow.preload | OLS-1c14ec95-d6df-518e-8909-b36508766606 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionESoundMinionColide.inibin | OLS-94c048f2-a51d-535c-af25-cb7702e6cb86 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionESoundMinionColide.luaobj | OLS-3ce3dc8b-1c16-5e56-b7c0-10826566efd3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionETrigger.inibin | OLS-7d4a0ea9-c6c3-5759-b438-a2e929025e59 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionETrigger.luaobj | OLS-838b3fb9-2616-5160-bdd6-62b519fe6fdc |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassive.inibin | OLS-d12d2841-f49b-5aca-af53-69d0d417a511 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassive.luaobj | OLS-9e32bee8-39c3-503e-84fa-38cb284ec906 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassive.preload | OLS-78e400cb-7809-5ee7-bf51-a6a0409a316d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveDelay.inibin | OLS-69dbb3db-6c7d-558f-872e-fd3e09cd7b3e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveDelay.luaobj | OLS-77f3701c-91e8-55fa-a998-fc911145e7bd |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveDelay.preload | OLS-b1b944f2-a88e-50f6-be93-66076b7754ab |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveSoundEnd.inibin | OLS-835bd2a2-4ac2-5996-81fc-cd082f29d122 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveSoundEnd.luaobj | OLS-a054af47-d87a-5955-a43f-156b0ed3d170 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveSpeed.inibin | OLS-1cbb62c5-0f3c-529e-b8c3-aa04e26fd861 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveSpeed.luaobj | OLS-b9283693-1dbd-5079-aba0-40a8cc0a9ba8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveSpeed.preload | OLS-3c29773e-83bc-5285-95c5-8fe1f14cd330 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveZombie.inibin | OLS-7c242f72-2799-5b4c-bfdf-b86f19bd858a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveZombie.luaobj | OLS-e0f35648-cc06-5cb7-b226-a019e9d44667 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionPassiveZombie.preload | OLS-308ac124-3208-569f-bc74-7d80a74d0142 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQ.inibin | OLS-b4f6932b-9c85-5d01-92b4-9a9506e40ed7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQ.luaobj | OLS-2fecd3ec-41e3-5258-a8bc-7433a708461d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQ.preload | OLS-eb11f6d1-414d-5c21-a925-849804854569 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQAttackTowerDebug.luaobj | OLS-eb2ff33b-d227-5f6c-800c-ad2af241d3af |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQDamage.inibin | OLS-88163927-09c9-5d1b-88e9-b79ecce73149 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQDamage.luaobj | OLS-1e3f434a-f342-5d69-a0ee-999b83e27b83 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQDamage.preload | OLS-fdb6be37-c753-52c2-b254-51c4bb1b29a9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQHitParticleMissile.inibin | OLS-2a73bcde-6eab-5428-9ee4-fbaa8874c8d8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQHitParticleMissile.luaobj | OLS-d320ec18-c5f4-5fec-bc05-ddcd639ac3b2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQHitParticleMissile2.inibin | OLS-efd76fa7-4884-5557-bf6c-14f8f4a44ebf |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQHitParticleMissile2.luaobj | OLS-90d75db0-a24b-54b8-8fe4-ff5dd8fa4a40 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQIndicatorMissile.inibin | OLS-4276bcd0-189d-58d0-aa13-6c4d7770d808 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQIndicatorMissile.luaobj | OLS-a2d74808-25af-5b85-824e-ff794615af6f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQIndicatorMissile2.inibin | OLS-8adc0dcd-2b20-5fde-bb47-597435e54c79 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQIndicatorMissile2.luaobj | OLS-c9eda093-4565-5609-8e51-4d138cfa8cb7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQKnockUp.inibin | OLS-baff886b-2f1e-5fa1-8878-1386f52ca89c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQKnockUp.luaobj | OLS-27814527-79e9-51de-8f68-fbbb194df8c6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQLock.luaobj | OLS-0002324d-6061-575e-8a51-b6a21f288b7d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQMissile.inibin | OLS-fc3d5fb7-8a6c-5856-b09d-726e7990e722 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQMissile.luaobj | OLS-483bffe6-cdd2-5d3e-b2e9-11bffd949cea |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQMissile.preload | OLS-57506ff0-2d7b-56ba-90f6-be0fdfed8e59 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQMultiHitCD.luaobj | OLS-51efee07-7082-55f6-864f-59fcf92696ec |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQNoAdd.luaobj | OLS-0580e049-7415-59e6-a4d6-7c195a3a2589 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQShapeCut.inibin | OLS-9723d460-6d50-56a4-946a-35b0e89bb1f8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQShapeCut.luaobj | OLS-9bc9b624-db18-5e4b-afd1-9282a7b8d73b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQShapeCutNoAdd.luaobj | OLS-097ea9e4-04a6-55c6-8076-5326466d0369 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSlow.inibin | OLS-32e9f990-0de0-5bcc-a139-29b851fd414a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSlow.luaobj | OLS-b3381226-9352-5cd4-9d2b-21fec3b6e24f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundAfterHalf.inibin | OLS-92bea76d-4d2f-5b9b-b249-de1ffd917ef6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundAfterHalf.luaobj | OLS-bf5d152b-c1cb-5665-90d8-c4cb383322e3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundAfterHalfHit.inibin | OLS-fea74b42-6044-5e93-b662-c3a4c7a69fb6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundAfterHalfHit.luaobj | OLS-aa596409-ee53-5fc4-a36f-deecc6ecc717 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundBeforeHalf.inibin | OLS-c8b53bad-b9f2-5e49-94f7-3f19e44e0b94 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundBeforeHalf.luaobj | OLS-d03a8a20-4840-574b-9709-d3399755fc10 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundBeforeHalfHit.inibin | OLS-1d9ee532-b10f-55e0-b296-c10e4c1b1d89 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQSoundBeforeHalfHit.luaobj | OLS-45d51160-c834-5067-a207-17cf695ccfbb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQStun.inibin | OLS-5acf559e-b2dc-5dfb-90db-d8684a5555fc |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionQStun.luaobj | OLS-845ffb93-8387-561c-a890-e7d3b2633662 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionR.inibin | OLS-e693f9cd-643f-5f8b-a59a-90400f31714d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionR.luaobj | OLS-735c8e27-b713-531d-b659-ef0c7d561329 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionR.preload | OLS-127b9a99-c87f-59ef-8ec9-9a755ad3768a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRDmg.luaobj | OLS-a404db65-d294-58b8-bdf6-8036f67c3dd4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRDmg.preload | OLS-3b81dc4b-99d8-5d93-a515-23abda1cd4ab |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRMarker.luaobj | OLS-f6650b10-cd6d-5b78-8523-0414d17c17d5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRMarker.preload | OLS-6eeaabd1-9c26-5eb2-a673-4f27f8bec88b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRRun.inibin | OLS-d3ad612b-de9a-5105-ae0e-e7777225a8a5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRRun.luaobj | OLS-72103fd4-c107-5eca-bad2-7688885fb82b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRRun.preload | OLS-0f8496f4-7d0b-5d53-befd-b2e742a852d2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSelfBuff.luaobj | OLS-c3cdd942-db3d-5968-bb90-6db7d8f30673 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSlow.inibin | OLS-84a0e04d-170f-5ae6-b54b-2daff5873dca |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSlow.luaobj | OLS-9d8eda45-a317-5249-8a9a-095a293c63a9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSlow.preload | OLS-780dc22a-0d13-53c8-b85d-ba758f193620 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosion.inibin | OLS-7567a866-e618-5947-92ed-890337ce6d4c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosion.luaobj | OLS-794cbb41-83fd-53f9-b27c-69ad9d9f239b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosionHitChampion.inibin | OLS-49b408cc-81f8-53af-88e9-a7c7b8f05f01 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosionHitChampion.luaobj | OLS-e87e4125-7767-5c58-aee5-93cdba53c9e6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosionHitMinion.inibin | OLS-7819f6ed-a4d5-593b-b5b9-b7f0cba13aa9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundExplosionHitMinion.luaobj | OLS-7ec00fd4-3ffa-5679-bdd8-8dc88fd8300b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundFireBall.inibin | OLS-c74000b5-d256-59c3-9d1c-eed84bb2860c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRSoundFireBall.luaobj | OLS-17c48a21-e72b-5f8f-a335-ba77095b4dc4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRTarget.luaobj | OLS-9b30386c-8ac4-5c12-80ab-afe7c3033e1f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionRunCycleManager.luaobj | OLS-0fe9d919-5f35-5203-bd5c-8a8fe735bf76 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionStun.luaobj | OLS-545755d6-427b-5d37-8fc2-b6be63691b3b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOControl.luaobj | OLS-27ce7864-51ea-5c2d-a330-5f7f55241df5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOControl.preload | OLS-184780cd-1cef-5b8e-b579-e8b4df5f2c91 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOMark.luaobj | OLS-dca3403b-611f-5b8b-8051-5a1841a278b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOMark.preload | OLS-088f6788-3a7d-5b79-b6ed-d37f5e8436cf |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOModeChange.inibin | OLS-d23d2e4e-08b9-5883-bf11-300a4e26009d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOModeChange.luaobj | OLS-8e1cf246-d40d-5683-a450-7f82564b9291 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOPass.luaobj | OLS-4e6685b8-c27a-55fa-827e-251e2c24e6a2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOPass.preload | OLS-3c8acfd6-603c-58a6-b6fa-0b48245c119a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOStacks.inibin | OLS-14887557-2881-5a5b-8fe6-bd4e59469aa7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionVOStacks.luaobj | OLS-e266d52f-83e4-5215-bc15-3afe41702746 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionW.inibin | OLS-68176e8d-ca58-5eae-a2f8-d490a0dab241 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionW.luaobj | OLS-86a9a149-fde6-5f36-bf77-7948aff3ac25 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionW.preload | OLS-4e00edf4-90b3-5a26-af77-1c77a258a41c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWDetonate.inibin | OLS-9a207add-c407-5ede-9c7a-386d5ba23528 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWDetonate.luaobj | OLS-01f628ac-8065-567d-ac31-6cee606aa77b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWPassive.inibin | OLS-f95626ac-1c37-5fd0-9d13-1d9a65a16751 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWPassive.luaobj | OLS-e4e26a39-4281-5e72-b952-457338a87d5b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWPassive.preload | OLS-218ea3d9-c85b-5886-b8a2-f502817c4a22 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWShieldStacks.inibin | OLS-b9f57afc-7db1-5c71-9d8f-670abbb0fdeb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWShieldStacks.luaobj | OLS-86497a8c-56a2-54e9-80b3-de2e67741771 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundExplosion.inibin | OLS-65ad049e-3ff9-5444-89d9-3e428855ec08 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundExplosion.luaobj | OLS-fc0ad2bb-3fb7-5035-9bc4-1773dde59606 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundHit.inibin | OLS-8e1a13b6-5cf1-5ab9-8eb4-a08a7802ee35 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundHit.luaobj | OLS-20a59e09-19dd-5e51-b3e1-5c2e292ade4f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundPassive.inibin | OLS-80f9d818-2d64-593e-8c35-20d0bb013678 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundPassive.luaobj | OLS-94650a2e-1658-5f28-9015-5e78ff475077 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundShield.inibin | OLS-7b3985c2-11ca-503d-9161-3a27f3d1c788 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\Spells\SionWSoundShield.luaobj | OLS-fc4e497c-81e4-5752-9b25-ef957ca95919 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\SionPassive.inibin | OLS-fcc7edc7-3f79-50f1-9050-8d08e72f421f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\SionBerserk.inibin | OLS-e630616c-772a-5634-acf1-6f00fe548f51 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Sion\SionMax.inibin | OLS-1f49dccc-3493-54c6-9163-20354b457bc9 |

## Reprise

Continuer SYS-01.2-02 depuis revision630_trace_review/REVIEW.json. V629 Sion / Glory in Death :150 fichiers natifs,450 associations,26 points actuels et52 liens. Deux SionPassive.inibin de chemins distincts conservés ;définitions racines420PV/50AD non adoptées comme état réanimé. Texte natif :réanimation,PV décroissants,100%vol de vie,10%PVmax cible physiques,cap75monstres,remplacement QWER par Death Surge. 66Lua dont21 limites NEWTABLE,25preloads,37BuffData dont19résolus/18sans traduction exacte ;DDF12lignes5liaisonsQWR. 63références communautaires :ébauche de réanimation délai2s/Respawn/buff60s et vitesse50%1,5s sans décroissance ;formules et moteur C# non qualifiés,anciens comportements Q/E/R divergents. Deux cas publics base/Rubis :12attaques,34impacts reçus,deux morts et réapparitions normales après480ticks,144 refus dont90 pendant la mort,six trajets. Aucune phase réanimée,vol de vie0,cadence44ticks ;aucun sort Sion accepté. BUILD/RUN0 ;inspection initiale1 pour décompte de traductions puis correction19/18 vérifiée. Sources,états,cases,inconnues et preuves antérieures conservés ;aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Sivir. Goal actif.
