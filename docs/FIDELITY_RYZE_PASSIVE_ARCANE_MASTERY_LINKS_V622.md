# Ryze — sources et consommateurs d’Arcane Mastery, V622

Date UTC : 2026-10-26T15:42:12.595563+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis.

## Résultat et portée

Les fiches CH-Ryze-PASSIF-SOURCE, CH-Ryze-PASSIF-SIMULATION-CONTRAT et CH-Ryze-PASSIF-SIMULATION reçoivent 30 sources natives, 90 associations, 28 points de code et 56 liens pour les deux fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ; statuts et inconnues conservés.

Le texte natif dit que lancer un sort réduit d’une seconde les délais des autres sorts. Aucun sort Ryze n’est actuellement accepté dans les essais. Les contrôles de CDR générique, mana, attaques et Barrier réussissent ; ils ne valident pas Arcane Mastery. Le cas nominal de réduction d’un délai propre actif reste à exécuter après implémentation.

## Sources natives

30 ressources : 14 INIBIN, 8 Lua, 6 preloads, Ryze.ddf et fontconfig_en_GB.txt. Identités, SHA et appartenance au manifeste RADS vérifiées. Aucun doublon de basename ni NightmareBot sélectionné.

Ryze.inibin donne Passive1LuaName=Arcane Mastery, icône Ryze_SpellStrike.dds et BaseMP=342.3999938964844. PARType et Passive1 sont absents. La classification Mana du catalogue courant reste une donnée distincte. Passive1Desc et PassLev1Desc2/3/4 évoquent AP à faible vie, 30/45/60 et niveaux 1/6/16 : cet héritage n’est pas adopté comme progression du passif.

Le BuffData et la description du personnage concordent sur une seconde retirée aux autres sorts lors d’un lancement. Le CDR de Q, 2/4/6/8/10 % selon le rang, est une propriété distincte. Le moment du déclenchement, les slots concernés, invocateurs, recasts, annulations, arrondis, ordre avec le CDR et lifecycle restent à qualifier.

Quatre bindings BuffData résolus. Les fichiers arcane mastery/arcanemastery, Rune Prison/runeprison et Spell Flux/spellflux ont des identités distinctes ; une différence d’espaces ne permet pas de conclure à une équivalence ou une priorité de chargement.

Les huit Lua sont entièrement parcourus sans sous-fonctions ; Overload, spellflux et spellfluxmissile conservent une limite NEWTABLE. Les cinq initialisations littérales restantes ne constituent pas une exécution du serveur historique. CharScriptRyze.luaobj est vide. arcanemastery.luaobj expose nom, icône, PersistsThroughDeath, NonDispellable, DoesntTriggerSpellCasts et autres métadonnées ; aucun callback de lancement n’est ainsi démontré.

Les preloads décrivent notamment arcanemastery, overload, apbonusdamagetotowers, cibles, desperatepower_aoe, manaleach_tar et spellfluxmissile. Leur présence ne prouve ni rendu effectif ni politique serveur.

Ryze.ddf comporte 12 lignes, dont trois liaisons non vides au mana : Q 0.065, W 0.045 et E 0.01. Les champs correspondants donnent 6,5 %, 4,5 % et 1 %. Q Cooldown1=3.5, coefficient AP0.4, ManaCost1=60 ; W Cooldown1 absent ne devient pas zéro ; E Cooldown1=14, réduction MR de premier rang12 ; R Cooldown1=70, coût0. Le texte R définit vol de sort, vitesse et 50 % de dégâts de zone. Le champ ancien Effect1=75 ne justifie pas un bonus AP.

Quatre chemins candidats absents sont consignés : CharScript sous Scripts, arcanemastery dans les Spells globaux, Ryze.en_gb.ddf et RyzePassive.inibin. Les alternatives effectivement sélectionnées sont présentes. Aucune conclusion globale d’assets manquants ou corrompus n’en est tirée.

| Ressource | Identité du registre |
|---|---|
| Ryze.inibin | OLS-b709a185-bad9-54a8-9422-1c2af10d5281 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Ryze.ddf | OLS-b666d7c3-1b38-54a3-8cc5-d49a9dc6bf57 |
| CharScriptRyze.luaobj | OLS-25f89ca8-b92c-5c47-bc8a-a9d63fb7ec66 |
| CharScriptRyze.preload | OLS-a05b11ec-5f82-5bfa-a2bf-cdc3173a278b |
| arcane mastery.inibin | OLS-9d6190e4-7dbc-58df-a1aa-c9a179efc833 |
| arcanemastery.inibin | OLS-57433c76-13fc-5843-bafa-c03ac8a574dc |
| arcanemastery.luaobj | OLS-6306d648-eeea-54af-b857-8f8f42584fe0 |
| desperatepower.inibin | OLS-9e3c293a-23f8-5de7-ba42-76108c0e3798 |
| desperatepower.luaobj | OLS-69e35a3b-3d99-5144-bea1-64dfacb8f138 |
| desperatepower.preload | OLS-af4bdfea-517f-5387-b4e3-8ae25ff3f04a |
| Overload.inibin | OLS-9addad8d-9010-5f33-8a15-6cc1b99305ea |
| Overload.luaobj | OLS-edabf685-af2d-5d39-9e8a-eb04a9359a3d |
| Overload.preload | OLS-06546a7c-92c0-5173-9053-d685ed8f9284 |
| Rune Prison.inibin | OLS-22c30dc7-3139-5e61-9936-1efb97d439e0 |
| runeprison.inibin | OLS-0285626b-9bf3-5eac-aea2-3db366afe6bd |
| runeprison.luaobj | OLS-94d5df95-3f5e-5862-a14b-64956f709d9c |
| runeprison.preload | OLS-bfc1d0a7-9ba6-59fa-82d2-76ce50d43793 |
| ryzebasicattack.inibin | OLS-e3e0091a-52d4-5620-9fc9-853c26953f71 |
| ryzebasicattack2.inibin | OLS-86d7bfc7-f1a1-57cb-a954-185b978d9769 |
| ryzecritattack.inibin | OLS-e2db08f9-eecf-5d84-bbe1-e3e3e9557ece |
| ryzedesperatepowerattack.inibin | OLS-290324c9-c682-5bfa-a040-7f9a9cf2c26c |
| ryzedesperatepowerattack.luaobj | OLS-08bab4b9-c265-55ba-afc2-15c234400fb9 |
| Spell Flux.inibin | OLS-45306863-8768-54a9-a110-9703ce714caf |
| spellflux.inibin | OLS-489684d1-0a49-5084-a5fa-d4faa2220c59 |
| spellflux.luaobj | OLS-f86e8085-02ef-5685-8f60-f8878ac61884 |
| spellflux.preload | OLS-f6cb64b8-2f25-573b-a1ae-5aadc332a023 |
| spellfluxmissile.inibin | OLS-8da29562-d794-5276-bb94-c6cc290375f9 |
| spellfluxmissile.luaobj | OLS-65ded463-ea93-5721-b1fe-ef90d6aa54ac |
| spellfluxmissile.preload | OLS-6069668f-b9c6-530f-95e3-9bf6214ba5b1 |

## Références communautaires et divergences

19 références présentes et identifiées séparément. CharScriptRyze.cs est vide. Aucun marqueur Arcane Mastery/setcooldown/reducecooldown dans les quatre fichiers Q/W/E/R inspectés ; cette recherche ne prouve pas une absence globale ailleurs.

- Q ajoute 2 % du mana maximal contre 6,5 % dans la source native sélectionnée.
- W applique 40+20×rang+0,6AP et un root 0,5+0,25×rang, sans le terme de mana 4,5 %. Le commentaire contradictoire sur les dégâts de base n’est pas préféré au code.
- E utilise cinq itérations, exclut les cibles déjà touchées et sélectionne l’équipe adverse ; aucun rebond sur Ryze, terme 1 % mana ou réduction effective MR n’est présent dans ce fichier. Le commentaire ne prouve pas l’effet.
- R ajoute 75AP×rang avec une durée de cinq secondes, au lieu des effets natifs de vol de sort, vitesse et zone.

Aucun script communautaire exécuté comme serveur historique ni accepté comme consommateur Rust dans cette livraison.

## Diagnostic actuel : attendu et observé

Cœur Rust compilé hors configuration test, offline/locked ; identités des dépendances alignées avec Cargo.lock et 1158 entrées source contrôlées. BUILD=0, RUN=0, collecte=0, inspection=0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-ryze-passive-arcane-mastery-probe.exe`, 6081536 octets, SHA256 `4da60cda94df94c05fb0278b13c934670a738862ee16095e267de0d917c01737`.

Trois profils publics niveau1 contre Annie : base, Codex3108 acheté via Tome1052, Saphir1027. Aucune position, ressource, vie, rang ou échéance injectée. Six trajets Move/Stop sans réémission. Dix-huit impacts physiques ordinaires, 726 ticks d’attente, 84 refus atomiques avec snapshots inchangés : acteur inconnu, autoattaque de soi, slot invalide, Barrier en délai et apprentissage/lancement QWER avant et après les attaques.

| Profil | AP | Mana maximal | ticks pour entrée diagnostique 10s | Attaques | Dégâts physiques observés | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base | 0.0 | 342.4000 | 300 | 6 | 46.16675 | 28 |
| Codex30AP10CDR | 30.0 | 342.4000 | 270 | 6 | 46.16675 | 28 |
| Sapphire200Mana | 0.0 | 542.4000 | 300 | 6 | 46.16675 | 28 |

Attendu pour le mécanisme générique : CDR d’objet 10 % ramène une durée d’entrée de 10s de300 à270ticks ; observé conforme. Cette entrée n’est pas un délai natif Ryze. La différence arithmétique d’une seconde ne constitue pas le déclenchement du passif.

Barrier est accepté une fois dans chaque profil, bouclier115 pendant2s et délai6300ticks. Après61ticks le bouclier est expiré. L’échéance de disponibilité demeure inchangée au fil du test, même avec le CDR d’objet ; le temps restant diminue par écoulement normal des ticks. Cela ne qualifie aucune inclusion ou exclusion des invocateurs dans Arcane Mastery : aucun sort Ryze n’a déclenché ce passif.

AD55.0400009155, dégâts physiques46.166748046875 dans les trois profils. AP30 n’affecte pas ces attaques. Mana maximal342.39999 ou542.40002 avec Saphir ; le mana final est au maximum après trajets/attente/régénération. Ce constat ne prouve pas un remplissage instantané lors de l’achat.

Tous rangs et délais QWER restent0 ; tous sorts Ryze sont refusés. Aucun délai propre actif n’a été réduit. La recherche exacte Ryze/Arcane Mastery dans crates/core/src ne trouve aucun chemin dédié ; les frontières génériques sont liées sans les promouvoir en implémentation du passif.

## Consommateurs liés

Neuf ressources locales sont conservées : catalogues champions/croissance/ressources, attaques/critiques/collisions, boutique, délais et Barrier. Les lecteurs de sources ne deviennent pas des consommateurs de simulation.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | ordinary join resources |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary AD55.04,AP0/30,CDR0/0.1,mana342.4/542.4 |
| crates/core/src/progression.rs:150 | unsupported Ryze learning |
| crates/core/src/progression.rs:159 | unsupported Ryze ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spells |
| crates/core/src/annie_w.rs:29 | unsupported ground spells |
| crates/core/src/lib.rs:685 | elapsed time,18ranged,726idle;not passive reduction |
| crates/core/src/lib.rs:744 | state/timer witnesses,not transport acceptance |
| crates/core/src/damage.rs:53 | ordinary damage,not mana scaling |
| crates/core/src/attacks.rs:157 | 18 ranged ordinary hits |
| crates/core/src/lifesteal.rs:4 | ordinary physical damage |
| crates/core/src/regeneration.rs:32 | generic mana/health restoration |
| crates/core/src/regeneration.rs:10 | damage correction and mana regeneration |
| crates/core/src/shop.rs:261 | public Tome/Codex recipe and Sapphire purchases |
| crates/core/src/shop.rs:215 | item AP,mana and percent CDR |
| crates/core/src/world.rs:226 | one enemy champion;other target kinds unexercised |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | attack timing context |
| crates/core/src/lifecycle.rs:16 | current Mana classification distinct from absent native PARType |
| crates/core/src/lifecycle.rs:24 | generic mana restoration |
| crates/core/src/ally_occupancy.rs:635 | six public travels without reorder |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564/V606 remain open |
| crates/core/src/spells.rs:5 | current states inspected,no Ryze cast-reduction state |
| crates/core/src/summoners.rs:32 | public Barrier loadout,not native availability acceptance |
| crates/core/src/cooldown.rs:11 | percent CDR duration helper,10s diagnostic input only |
| crates/core/src/cooldown.rs:10 | generic cap distinct from fixed1s decrement |
| crates/core/src/summoners.rs:47 | accepted Barrier6300ticks,ready_at unchanged under refused Ryze casts |

## Intégration et contrôles

PREPARE, CHECK, PUBLISH et AUDIT exécutés avec code0. Les tests négatifs refusent72 associations invalides et4 graphes invalides. Ils rejettent notamment fausse acceptation, source manquante, binaire altéré, question étrangère et dépendance retirée.

Graphe99165 sources /4594 consommateurs ; revue globale de4594 ancres exactes sans divergence. Le contrôle structurel global ne re-hache pas toutes les sources : les sources sélectionnées et entrées code sont vérifiées séparément par identité.

Deux bases SQLite : quatre destinataires actualisés, 42603 autres lignes conservées, 42607 états manuels et23 historiques identiques, synchronisation Store idempotente. Trois fragments de traçabilité changés,42212 inchangés. Trois questions propres et quatre dépendances conservées. Registres des identités, hiérarchie et inconnues inchangés octet pour octet.

Fichiers livrés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, reçu reference_requirement_trace_sources/ryze-passive-arcane-mastery-links-v622.json, preuve fidelity_ryze_passive_arcane_mastery_links_v622.json et ce rapport. Couverture, plan de complétion, reprise et notes CURRENT/HANDOFF actualisés avec sauvegardes antérieures. Bases projet et application mises à jour sans cocher de tâche. Scripts, sources Rust du diagnostic, journaux et observations conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 sous les noms revision622_ryze et revision622_Ryze.

La recherche exploratoire d’un fichier summoner_flash.rs était une mauvaise hypothèse de chemin ; le code réel utilisé est summoners.rs et le diagnostic porte sur Barrier. Aucune fonction Flash déduite ou testée. Aucun échec BUILD/RUN/inspection dans cette livraison. Les échecs historiques, notamment V564/V606, restent conservés et ouverts.

## Manques explicitement laissés ouverts

Implémenter puis qualifier le lancement des sorts Ryze et le callback réduisant les autres délais ; résoudre exclusions, annulations, recasts, ordre avec le CDR, limites zéro, progression, effets des sorts et lifecycle. Les métadonnées de persistance ne constituent pas une politique mort/respawn. Le serveur historique, rendu, sons, HUD, animations et réseau n’ont pas été exécutés ou qualifiés ici. Les divergences communautaires et variantes de ressources restent distinctes. Ni Ryze, ni le jeu, ni SYS-01.2-02 ne sont déclarés terminés.

Suite : Continuer SYS-01.2-02 depuis revision623_trace_review/REVIEW.json. V622 Ryze / Arcane Mastery : 30 sources natives, 90 associations, 28 points et 56 liens. Texte 4.20 : lancer un sort réduit de 1 seconde les délais des autres sorts ; le CDR de Q,2/4/6/8/10%,est distinct. DDF12 lignes dont3 mana :Q6,5%,W4,5%,E1%. PARType absent,classe Mana actuelle séparée ;textes hérités AP30/45/60 à basse vie et niveaux1/6/16 non adoptés. 8Lua dont3limites NEWTABLE,6preloads,4BuffData résolus ;CharScripts vides. Noms avec et sans espaces distincts,aucune équivalence automatique. 19références communautaires :Q2%mana contre6,5%,W sans4,5%,E sans1%,réduction MR ou rebond sur Ryze,R75AP par rang contre vol de sort/vitesse/AoE natifs. Trois essais publics niveau1 base/Codex30AP10%CDR/Saphir200mana :18attaques physiques46,16675,84 refus atomiques,726ticks et six trajets. Barrier accepté trois fois,6300ticks,échéance inchangée ;QWER rangs/délais0 et aucun sort Ryze accepté. Contrôle générique sur une entrée diagnostique10s :300/270/300ticks ;sa différence1s ne prouve pas le passif. Aucun délai propre actif réduit,aucune règle native sur les invocateurs déduite. BUILD/RUN/inspection0 ;acquis génériques et V564/V606 conservés. Aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Sejuani. Goal actif.
