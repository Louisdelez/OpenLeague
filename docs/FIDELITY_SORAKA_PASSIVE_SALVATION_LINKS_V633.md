# Soraka — sources de Salvation et écart observé, V633

Date : 2026-10-26T19:09:53.955413+00:00. Projet : `F:/OpenLeague`. Tâche active : SYS-01.2-02, relier chaque exigence à sa source native et à son consommateur actuel. Cette livraison enrichit les trois fiches PASSIF-SOURCE, PASSIF-SIMULATION-CONTRAT et PASSIF-SIMULATION de Soraka, ainsi que le suivi général. Elle ne termine pas le gameplay.

## Résultat

**Le bonus conditionnel de vitesse n’est pas observé dans le moteur courant.** Quatre cas publics comparent un allié sain ou blessé, avec ou sans Bottes, en marchant vers lui puis à l’opposé. L’allié blessé est réellement touché par des projectiles ennemis ; aucun état n’est injecté. Sa vie reste autour de 22%, à moins de 801 unités. La vitesse de Soraka reste 325, ou 350 avec les Bottes, identique aux témoins sains et aux déplacements opposés.

74 fichiers natifs sont reliés aux trois exigences, soit 222 associations. 29 points de code sont identifiés, soit 58 liens aux deux fiches de simulation. Leurs rôles restent des limites d’entrée ou des mécanismes génériques, avec `provides_feature_consumer=false` : ils ne sont pas promus en implémentation de Salvation.

Les anciens liens, trois questions propres et quatre dépendances sont conservés. Les statuts, critères et prérequis restent ouverts. Les deux bases ont quatre destinataires actualisés ; leurs 42 603 autres lignes du catalogue, 42 607 états manuels et 23 historiques sont inchangés. La synchronisation normale du Store reste idempotente. Les registres d’identités, de hiérarchie et d’inconnues sont identiques octet par octet. Aucun code du jeu ni asset n’a été modifié.

## Référence et sources

Référence : PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue officiel 4.20.1 distinct. Déploiement sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

La sélection reprend les liens natifs existants et cherche dans les répertoires globaux et propres à Soraka. Chaque fichier est contrôlé par taille/SHA-256 et appartenance aux manifestes RADS sélectionnés. Les 74 fichiers sont 18 INIBIN, 29 Lua, 25 preloads, le DDF et le fontconfig. Aucun NightmareBot retenu. CharScriptSoraka et Soraka.ddf sont à la racine du champion. Quatre chemins alternatifs sous Scripts, Localization, Soraka.en_gb.ddf et DATA/Spells/SorakaPassive.inibin sont absents ; cela ne signifie pas que les ressources correspondantes sont globalement manquantes.

Le fichier **Consecration Self.inibin**, avec son espace, était déjà connu du registre et est repris dans la sélection. Son tooltip exact fournit le contrat précis de Salvation. L’ancien nom ne doit pas masquer ce texte ni provoquer une réécriture silencieuse des identités.

| Source | Identité du registre |
|---|---|
| Soraka.inibin | OLS-5b3bffa7-4776-5829-ab74-8399b60fc740 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Soraka.ddf | OLS-1709e430-ebe4-5dda-83be-22f6783e86d4 |
| CharScriptSoraka.luaobj | OLS-8bf13ee7-bfd5-50d5-9df2-0b927b80ace3 |
| CharScriptSoraka.preload | OLS-c2c802a5-3f62-5a18-901c-d22360845d8d |
| Soraka_BasicAttack.inibin | OLS-32a80872-478e-58d1-b298-ca9cbf13b0c4 |
| Soraka_BasicAttack.luaobj | OLS-0c75019a-e4a4-595e-a244-4a9bfd2c4508 |
| Soraka_BasicAttack.preload | OLS-f1af464b-cae6-56d9-a38e-36ebd6dafdbf |
| SorakaBasicAttack.inibin | OLS-efe26571-ac94-5cc9-b835-6832606b841a |
| SorakaBasicAttack.luaobj | OLS-7fca88cb-98e1-502d-8fdc-8cef178b2c11 |
| SorakaBasicAttack.preload | OLS-195b4839-6780-5e66-bfb0-d4c28cce4a4f |
| SorakaBasicAttack2.inibin | OLS-94ba7ca9-70fe-56ab-9ee2-00b067d27216 |
| SorakaBasicAttack2.luaobj | OLS-209f21a2-256a-53f0-ae23-d69fcf646d25 |
| SorakaBasicAttack2.preload | OLS-0ea008a6-e250-5726-96d3-10e2b425388f |
| SorakaConsecrationAura.luaobj | OLS-160f06c4-ec38-5786-a83c-3186967d5e4f |
| SorakaConsecrationAuraNoParticle.luaobj | OLS-f8d3cad8-4a71-59b3-b8ce-a4fb51f58c6e |
| SorakaConsecrationAuraNoParticle.preload | OLS-dfd8285a-feb3-5a18-86ca-3d094854f789 |
| SorakaCritAttack.inibin | OLS-b8bfe9ab-03f7-5bba-a862-b46abcff5e7d |
| SorakaCritAttack.luaobj | OLS-3daa02bf-9a0b-59a8-a983-379040e89f7c |
| SorakaCritAttack.preload | OLS-145fa397-f9b4-5fe7-a0b2-8cf824cc971b |
| SorakaE.inibin | OLS-6720edf3-15f1-554c-b5a5-e475726f6eb0 |
| SorakaE.luaobj | OLS-209a51f8-026b-5bb5-8864-7c3455c23a4e |
| SorakaE.preload | OLS-0c993712-326a-508a-a8e8-1fe787c5651a |
| SorakaEMana.luaobj | OLS-e95339d2-1bdf-591d-98d4-7b8e4b66e2ba |
| SorakaEMana.preload | OLS-228068c6-3a4f-5adb-aedd-6fffd57f323a |
| SorakaEPacify.inibin | OLS-96cf42ee-e0ca-5cbe-963d-0e27aeebbda6 |
| SorakaEPacify.luaobj | OLS-de304a98-026f-5f9a-9c7b-f91457b9c008 |
| SorakaEPacify.preload | OLS-392d72b5-038e-5129-98e1-ed052c28e7a4 |
| SorakaESnare.inibin | OLS-c8ebdc54-23e6-5ed7-a222-f622743981ee |
| SorakaESnare.luaobj | OLS-e52d8366-2361-5e9a-8b54-76ea58520765 |
| SorakaESnare.preload | OLS-0861b924-fd84-50fe-beb8-c4c4ef8e658a |
| SorakaInfuseExplode.luaobj | OLS-0d265548-0edf-5db3-812d-75db92aaea62 |
| SorakaInfuseExplode.preload | OLS-815111ac-982b-56f6-8597-a64231402818 |
| SorakaPassive.inibin | OLS-96ffd944-c045-517e-bb90-e79070f0720d |
| SorakaPassive.luaobj | OLS-c26d762a-5aab-5243-93f7-64c032f5b897 |
| SorakaPassive.preload | OLS-b085da01-a116-5c1c-8c69-15cb2b1ff401 |
| SorakaPassiveFalloff.luaobj | OLS-76d3c6b4-412c-59e6-b339-9a73b4c0d7d9 |
| SorakaPassiveMarker.luaobj | OLS-33b7ab5f-e5cc-567a-a92d-3dab611a1420 |
| SorakaPassiveMarker.preload | OLS-8da77b5b-e670-509d-b76f-27619ae316d9 |
| SorakaPassiveOrient.luaobj | OLS-8e7bcd06-4125-5ebb-abce-9e5e34201b48 |
| SorakaPassiveOrient.preload | OLS-9405f233-8d44-54db-93dd-039d84070bf6 |
| SorakaQ.inibin | OLS-cdf7ee8c-c543-5ca2-8b0a-3ecb9d584099 |
| SorakaQ.luaobj | OLS-c515a78c-5fe5-550c-8ce4-6d3f326f1e86 |
| SorakaQ.preload | OLS-1067e568-b848-5130-b689-de18d00d91d4 |
| SorakaQMissile.inibin | OLS-22e975e7-a2c7-58ec-8a5e-cb9c3aa8a7e4 |
| SorakaQMissile.luaobj | OLS-7a8259be-0f66-514c-a8b9-cabc04f96847 |
| SorakaQMissile.preload | OLS-215686bd-d915-5896-81d0-30e7d975feac |
| SorakaQReturnMissile.inibin | OLS-2fc4b537-9c7d-5086-a785-c9069aba46bf |
| SorakaQReturnMissile.luaobj | OLS-219e98c6-9913-5fd5-b588-b9839e3fa57c |
| SorakaQReturnMissile.preload | OLS-002734b7-b5c4-5aca-91d0-ad07fd50c2e7 |
| SorakaR.inibin | OLS-b8bb3839-e447-5cb3-b213-3dd424972af1 |
| SorakaR.luaobj | OLS-cca2fdc1-42d5-5bd6-8a53-afe251f07163 |
| SorakaR.preload | OLS-fd46d5eb-f1ee-531f-af29-eae0418b5ce9 |
| SorakaRCastTime.inibin | OLS-eaf22c3a-b2ba-5d39-8938-5dbe317ca981 |
| SorakaRCastTime.luaobj | OLS-544d602a-9f67-591b-b854-df824fc5911f |
| SorakaRCastTime.preload | OLS-ea000e24-b129-506e-801a-bb6859139eac |
| SorakaRecall.luaobj | OLS-1d6329ba-186b-57a0-b8a6-8c39520c6d3c |
| SorakaRecall.preload | OLS-03f1b2f7-77c5-5c14-8370-be2d26117087 |
| SorakaStarBuff.luaobj | OLS-17c8f866-1c6e-5a6b-b9c3-02148f139801 |
| SorakaStarBuff.preload | OLS-277e278d-a28a-5189-97bc-f7a54e6bcbae |
| SorakaW.inibin | OLS-84984698-e584-51a8-806d-e7dcc884fdce |
| SorakaW.luaobj | OLS-ca2aaba9-f1f1-50e9-a071-f06998271f66 |
| SorakaW.preload | OLS-70ed3560-10c6-5949-8b1c-62f37630604d |
| SorakaWCastTime.inibin | OLS-00775023-c949-59e9-9d87-31e124ed6a93 |
| SorakaWCastTime.luaobj | OLS-580b2ba7-0216-507a-b302-4a2223941e02 |
| SorakaWCastTime.preload | OLS-1308a0bf-6a61-5cd5-b4e8-4e0b28e822e5 |
| SorakaWParticleMissile.inibin | OLS-efa8ccf4-935d-5150-abb7-178b461b60a2 |
| SorakaWParticleMissile.luaobj | OLS-62a16187-e005-5270-8a86-da42a80fd834 |
| SorakaWParticleMissile.preload | OLS-a54009a0-e1d2-5637-9630-ced2ff7837ac |
| SorakaWSelfBuff.luaobj | OLS-fcea5838-3145-5fb0-91b5-62b55b949dfc |
| SorakaWTargetBuff.luaobj | OLS-ddd90ae9-f419-5a91-a13f-d970f389ff0e |
| SorakaWTargetBuff.preload | OLS-1668f05e-5f84-56e0-a30c-d7f7e3a9362a |
| SorakaRecallOverride.luaobj | OLS-ef11a294-64df-538e-b7f7-daf47bdc85e6 |
| Consecration Self.inibin | OLS-cd23a79e-20d4-5727-98de-efd207f47638 |

## Contrat établi

Le tooltip `game_buff_tooltip_Consecration_Self` décrit **70% de vitesse bonus en allant vers un champion allié sous 40% de vie, dans une portée de 2500 unités**. Le tooltip SorakaPassive indique seulement une vitesse accrue ; la description courte parle d’alliés proches à faible vie. Les seuils ne sont donc pas inventés à partir du comportement actuel.

Soraka.inibin sélectionne SorakaQ/W/E/R. Passive1LuaName reste `Consecration Self`, avec l’icône Soraka_Passive.dds. Passive1Desc contient une description ancienne affectant Starcall, Infuse et Astral Blessing ; les marqueurs Passive1Level1=8 et Passive1Level2=15 sont conservés sans en déduire une progression de Salvation. Les valeurs de base comprennent HP 529,0399780273438, MP 350,79998779296875, AD 50,040000915527344, armure 23,384000778198242, vitesse 325 et portée d’attaque 550.

Les 29 Lua sont lus entièrement et n’ont pas de prototypes de fonctions enfants. Quinze initialisations rencontrent une limite NEWTABLE. CharScriptSoraka, PassiveFalloff, EMana, InfuseExplode, WSelfBuff et WTargetBuff ont des initialisations vides. SorakaConsecrationAura déclare Consecration Self, PersistsThroughDeath et NonDispellable ; NoParticle porte Consecration. Ces métadonnées ne qualifient ni la persistance réelle ni l’immunité à la dissipation.

Marker et Orient déclarent seulement un attachement `root`, pas un calcul d’angle ou de sélection d’allié. Le preload Passive cite falloff ; les preloads d’indicateurs citent des particules, dont la graphie native `soraka_base_passive_indicatior.troy`. Ces références ne prouvent pas la présentation en jeu. Recall contient des métadonnées SyndraPassive, RecallOverride DravenPassive et StarBuff un effet Jayce : elles sont conservées, sans importer les règles de ces champions.

Les cinq BuffData ont des traductions exactes. Le DDF comporte 16 lignes anciennes, dont une seule avec un lien : InfuseWrapper;f1 → mana × 0,05. Ce lien ne constitue pas une formule de Salvation.

Restent à qualifier : le producteur effectif, le test de direction, l’angle, les égalités aux seuils, la sélection entre plusieurs alliés, les états/visibilités admissibles, les instants d’activation et de retrait, ainsi que l’ordre avec les autres bonus, ralentissements et plafonnements. Le diagnostic ne prétend pas qu’une vitesse finale est simplement égale à la vitesse de base multipliée par 1,7.

## Références communautaires

22 fichiers sont inspectés comme références non exécutées. CharScriptSoraka est vide. Les scripts Q/W/E/R ne sont pas promus en règles natives ni en consommateurs Rust actuels.

- Q : dégâts 70–230 plus coefficient AP dans un rayon de 300 ; appelle SorakaQHaste pour 1,5 seconde après un hit de champion. Le centre à 150% de dégâts, son ralentissement et le soin associé au W natif ne sont pas démontrés. La recherche exacte dans tous les `.cs` de LeagueSandbox-Scripts ne retrouve que l’appel SorakaQHaste dans Q.cs, pas sa définition. Un éventuel montage externe reste inconnu.
- W : soin 120–240 plus coefficient AP. Le coût de 10% des PV max n’est prélevé que si PV > coût + 1, puis la branche de soin peut s’exécuter. Ce paiement conditionnel ne démontre pas le refus natif sous 5% de vie ni le passif de soin après Starcall.
- E : ciblage ennemi avec dégâts/silence ou allié avec restauration de mana, distinct du texte 4.20 Equinox : zone 1,5 seconde, silence à l’intérieur puis immobilisation et dégâts à la disparition.
- R : soin global ; ni suppression préalable des instances de Grievous Wounds ni bonus de 50% sous 40% de vie ne sont démontrés dans ce fichier.

## Code actuel et diagnostic

La recherche pinée dans `crates/core/src/**/*.rs` ne trouve pas Soraka, Salvation ou Consecration. La lecture de movement.rs montre les bonus Garen, Heal, relique et Trundle et les ralentissements, sans producteur dépendant de la santé ou de la direction d’un allié pour Soraka. Les règles locales de plafonnement signalent elles-mêmes que l’ordre historique n’est pas qualifié. Les entrées de mouvement, de combat, de régénération et de refus de sorts sont reliées précisément.

| Point de code | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Soraka movement,wounded ally,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:159 | actual enemy projectiles create wounded allied Garen;not Soraka spell |
| crates/core/src/movement.rs:53 | actual movement speed has no Salvation branch |
| crates/core/src/movement.rs:38 | current bonuses/slows calculation;no ally health or direction producer |
| crates/core/src/movement.rs:19 | local softcap order is not historical Salvation qualification |
| crates/core/src/garen_passive.rs:27 | ally Garen recovery context,not Soraka passive |

Le diagnostic privé appelle le vrai crate core de F:/OpenLeague, profil non-test et dépendances alignées sur le Cargo.lock du projet. Les 1 158 fichiers d’entrée et preuves antérieures sont contrôlés avant/après. Il utilise les commandes publiques : Soraka et Garen sont alliés, Annie est ennemie ; mouvements concurrents vers trois positions, achat de Bottes, attaques d’Annie, arrêts, marche vers Garen puis à l’opposé. Les dégâts, positions et vies ne sont pas injectés.

Binaire exécuté : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-soraka-passive-salvation-owned-probe.exe` ; 6095872 octets ; SHA-256 `62390fa18045f8ec1caacc151ac04ae02d754c334accf40f5cd0168c1c470919`. Reçu : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision633_Soraka_passive_probe_owned/OBSERVATIONS.json`. Il conserve commandes, journaux, sources, manifeste et lock, artifact du crate et identité de l’exécutable.

| Cas | Vitesse | Distance vers l’allié, 30 ticks | Distance opposée, 30 ticks | Vie alliée min–max | Impacts ennemis | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base_healthy_ally | 325 | 324.990234 | 324.990234 | 100.00–100.00% | 0 | 28 |
| base_wounded_ally | 325 | 324.990234 | 324.990234 | 21.92–22.42% | 13 | 28 |
| Boots25Speed_healthy_ally | 350 | 349.995117 | 349.995117 | 100.00–100.00% | 0 | 28 |
| Boots25Speed_wounded_ally | 350 | 349.995117 | 349.995117 | 21.92–22.42% | 13 | 28 |

Dans les deux cas blessés, 13 impacts chacun abaissent Garen à environ 21,92% de vie. Durant les déplacements il reste entre 21,92 et 22,42%, contre 100% pour les témoins sains. Les distances à l’allié vont de 475,01 à 800 unités sans Bottes et de 450,56 à 800,56 avec Bottes. Chaque pas mesuré a un cosinus de direction supérieur à 0,99 vers l’allié et inférieur à -0,99 à l’opposé. Les joueurs restent niveau 1, vivants, sans stun ni slow dans ces scénarios.

Résultat attendu d’après le texte : une vitesse accrue dans le cas allant vers l’allié blessé. Résultat observé : même vitesse que vers l’allié sain et à l’opposé, 325/350 ; distances sur 30 ticks de 324,990234375/349,9951171875 unités. Ce constat établit un écart dans ces scénarios et le rattache au chemin actuel de calcul. Il ne valide pas toutes les bornes ni la formule historique de plafonnement.

Le diagnostic vérifie 12 arrivées sans réordre, huit ordres de marche mesurés, 240 ticks et 26 impacts avec projectile témoin et résidu de dégâts inférieur à 0,002. Deux achats de Bottes sont exécutés, aucune vente ni aucun rachat. Les 112 refus gardent les instantanés identiques : joueur inconnu, attaque sur soi, attaque alliée, emplacement invalide, puis Learn/Cast/CastAt des quatre slots avant/après. Les sorts de Soraka restent refusés. Les règles de régénération de Garen sont conservées comme contexte du témoin blessé, sans être attribuées à Soraka.

## Échec conservé et contrôles

Le premier BUILD du diagnostic privé a retourné 101 : E0382, lecture de `s.snapshot()` après déplacement de `s` dans le tuple de retour de setup. Aucun RUN de cette première version. La version qualifiée `revision633_soraka_probe_owned.py` capture l’instantané avant le déplacement, utilise un nouveau projet et un nouveau nom de binaire, et conserve les sources et journaux échoués. Ses BUILD/RUN retournent 0 ; aucun code du jeu n’a été corrigé pour faire passer le test.

Découverte, inspection, PREPARE, CHECK, PUBLISH et AUDIT : codes 0. Les validations refusent 72 associations altérées et quatre graphes invalides. Les trois courts aperçus de traçabilité et les quatre fiches/consignes complètes attendues sont actualisés. Les vrais lecteurs Store, copie des instructions, dépendances et rt.resolve relisent les données publiées.

La revue globale porte le graphe à 99 209 sources et 4 866 points de consommation, avec ancres exactes et aucune divergence courante. Elle est structurelle : `source_hashes_verified=0` ne signifie pas un re-hachage global des 99 209 sources. Le contenu est contrôlé sur la sélection et les entrées pinées décrites plus haut. Les 26 189 questions ouvertes et 5 517 résolues avec historique sont préservées.

## Fichiers et suite

Registres enrichis : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/soraka-passive-salvation-links-v633.json. Preuve : docs/fidelity_soraka_passive_salvation_links_v633.json. Le présent rapport, coverage.json, completion_plan.json, resume_checkpoint.json et CURRENT/HANDOFF portent la reprise. Les bases sont runtime/project-plan/plan.sqlite3 et la base installée AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Scripts exacts, sauvegardes et reçus privés sont sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision633_Soraka`.

Restent à faire : producteur Salvation ; limites 39,99/40/40,01% et autour de 2500 ; angles, virages et plusieurs alliés ; visibilité, morts, départs et reconnexions ; activation/retrait ; autres effets de vitesse, plafonnements et simultanéité. Qualifier séparément la simulation, le HUD, les VFX, sons, animations et le réseau. Les limites antérieures V564/V606 restent ouvertes. Les exigences et le goal ne sont pas terminés.

Continuer SYS-01.2-02 depuis revision634_trace_review/REVIEW.json. V633 Soraka / Salvation : 74 fichiers natifs, 222 associations, 29 points de code et 58 liens. Le tooltip exact de Consecration Self.inibin décrit 70% de vitesse bonus vers un champion allié sous 40% de vie, à une portée de 2500 unités. Les anciens noms et descriptions restent distincts. 29 Lua, dont 15 limites NEWTABLE ; 25 preloads ; 5 BuffData traduits ; 16 lignes DDF avec InfuseWrapper lié à mana × 0,05. Les métadonnées Syndra, Draven et Jayce ne sont pas adoptées comme règles. 22 références communautaires partielles ou divergentes, dont SorakaQHaste sans producteur retrouvé. Quatre cas publics niveau 1, allié sain/blessé et base/Bottes : 26 impacts Annie sur Garen, 112 refus atomiques, 12 arrivées, 8 déplacements mesurés et 240 ticks. Vers un allié à environ 22% de vie entre 450 et 801 unités, aucun bonus Salvation observé : vitesse 325 ou 350, identique aux témoins sains et opposés. Deux achats de Bottes ; aucune vente, aucun rachat ni état injecté. Sorts Soraka refusés. Premier BUILD 101 privé conservé ; diagnostic corrigé BUILD/RUN et inspection 0. Statuts, cases, inconnues et preuves conservés ; gameplay inchangé. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Swain. Goal actif.
