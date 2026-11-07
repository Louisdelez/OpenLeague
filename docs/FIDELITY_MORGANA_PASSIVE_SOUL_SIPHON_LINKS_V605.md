# SYS-01.2-02 — Morgana : sources et consommateurs de Soul Siphon (V605)

Date UTC : 2026-10-26T10:19:21.654401+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

## Résultat

CH-Morgana-PASSIF-SOURCE, CH-Morgana-PASSIF-SIMULATION-CONTRAT et CH-Morgana-PASSIF-SIMULATION sont reliées à28 sources natives,84 associations,28 points du moteur et56 liens sur les deux fiches de simulation. Ces points restent des frontières et du contexte, sans consommateur complet de Soul Siphon démontré.

Les sources décrivent du Spell Vamp : Morgana se soigne avec les dégâts de ses sorts. Le montant dynamique f1, ses paliers et les modificateurs de cibles restent non résolus. Aucun sort Morgana n’est accepté dans le core actuel. Trois simulations publiques vérifient la régénération et le vol de vie d’un objet sur attaques ordinaires, sans qualifier le déclenchement de Soul Siphon. Aucun gameplay ni asset modifié, aucune tâche déclarée complète.

## Sources et écarts

- Morgana.inibin lie Passive1LuaName=Empathize, icône FallenAngel_Empathize.dds, Passive1Name=game_character_passiveName_Morgana. Le nom résolu en_GB ligne4412 est Soul Siphon ; la description ligne4236 concerne le soin personnel sur dégâts de sorts.
- Empathize.inibin contient la clé BuffData game_buff_tooltip_Empathize, résolue exactement une fois ligne1866 : `@f1@% bonus Spell Vamp`. Les champs SpellData sélectionnés (description, tooltip, icône, coût/cooldown, rayon/portée, coefficients, Effect1Level0..5) sont absents. Passive1Level1..6 sont absents. Ces absences ne sont pas des valeurs zéro et ne définissent pas f1 ou ses paliers.
- Passive1Desc garde un texte de régénération des champions alliés proches. PassLev1Desc2..4 gardent +40/+60/+80% de régénération de mana. Ces champs hérités ne remplacent pas le texte localisé et ne deviennent ni aura alliée ni progression de Spell Vamp.
- EmpathizeAura.luaobj initialise BuffTextureName, BuffName=Empathize, PersistsThroughDeath=true et NonDispellable=true. Le nom Aura et la persistance ne définissent ni cibles alliées, ni comportement au respawn.
- CharScriptMorgana.luaobj **n’est pas vide** : il contient les deux indicateurs PersistsThroughDeath et NonDispellable, sans prototype de callback. Le CharScript communautaire C# est vide. La définition communautaire Empathize contient seulement la clé du tooltip.
- Dix Lua sont parcourus intégralement, aucun prototype enfant : trois initialisations littérales et sept limites NEWTABLE (BlackShield, DarkBinding, DarkBindingMissile, MorganaBasicAttack2, MorganaCritAttack, SoulShackles, TormentedSoil). Les constantes conservées donnent du contexte QWER/skins, pas une exécution complète. Une limite du lecteur ne prouve pas une corruption.
- Sept preloads : CharScript charge empathizeaura, apbonusdamagetotowers et crestbigmarker ; EmpathizeAura référence trois particules idle de base/skin05. Les autres relient Q/W/E/R. Ces dépendances ne qualifient pas le chargement ou le rendu.
- Dix INIBIN, dix Lua, sept preloads et un fichier de langue composent les28 sources. Aucun DDF sélectionné. Huit chemins candidats sont absents : Morgana.ddf, CharScript à la racine du personnage, Empathize.inibin/.luaobj sous Characters/Morgana/Spells, Empathize.luaobj/.preload, EmpathizeAura.inibin et Empathize.ddf sous DATA/Spells. Les ressources Empathize, EmpathizeAura et le CharScript sous Scripts existent ; aucun manque global de modèles/textures/animations/sons n’est déduit.
- Dix-huit fichiers NightmareBotMorgana sont identifiés et exclus. Les règles Doom Morgana ne sont pas adoptées.
- Quinze références communautaires sont présentes, dont Q/W/E/R avec callbacks. Leur présence ne prouve ni corps serveur original, ni consommation Rust. Le W communautaire contient16 timers espacés de0,3125s, malgré un commentaire « single pulse », et un rayon275 ; le champ natif CastRadius vaut280. R communautaire utilise600, contre CastRadius625 natif. La convention de distance et les divergences doivent être qualifiées avant adoption. Les commentaires ne remplacent pas le code observé.
- Les coefficients natifs Q0,9AP, W environ0,22/0,33AP, E/R environ0,7AP sont du contexte de sorts, pas le f1 du passif. Le tooltip W décrit5 secondes de dégâts dépendant des PV manquants ; cela ne qualifie pas les timers ou formules communautaires.

Les28 sources sont comparées au registre et à l’appartenance RADS sélectionnée avec taille/SHA-256. Les exclusions et références communautaires gardent leurs identités séparées.

| Fichier | Source |
|---|---|
| Morgana.inibin | OLS-1cb4a668-0445-5185-9217-d7c4935d9294 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptMorgana.luaobj | OLS-a781b676-a4b2-51f0-82f7-e26a83949f76 |
| CharScriptMorgana.preload | OLS-d7575eea-a6f6-5234-9db7-51d7113a7a1f |
| BlackShield.inibin | OLS-9a6d53b9-4cc1-5093-9136-868fad7ad568 |
| BlackShield.luaobj | OLS-0a82b638-42b1-5c10-bf5e-e35f99ea1c52 |
| BlackShield.preload | OLS-d6451f88-91ca-5975-90ff-10256f533ffa |
| DarkBinding.inibin | OLS-35033fe9-9cf4-5837-bf47-6e9614f66d60 |
| DarkBinding.luaobj | OLS-0181674f-3019-5338-815c-fe271f1156c1 |
| DarkBindingMissile.inibin | OLS-a13907fc-cbf7-59e2-ae41-88cca1956cb5 |
| DarkBindingMissile.luaobj | OLS-9e6a9e5f-a239-57fd-9408-e4fa566339c0 |
| DarkBindingMissile.preload | OLS-243b5925-d4f2-5556-a8c4-06664547fcf4 |
| Empathize.inibin | OLS-24a917f4-59ed-5db6-b1ae-659e22f90787 |
| EmpathizeAura.luaobj | OLS-58261c25-a6a9-5b90-bd20-144abbe60139 |
| EmpathizeAura.preload | OLS-f22be836-9a28-5fb7-b48f-51c708711a45 |
| MorganaBasicAttack.inibin | OLS-3e9191e5-f17a-5c5b-b9ec-aaab995fabf0 |
| MorganaBasicAttack2.inibin | OLS-d3040ef9-e12b-5c40-9c4b-6aed5f9be34d |
| MorganaBasicAttack2.luaobj | OLS-dc4df82c-476f-5b2a-b3ae-66435d0213f7 |
| MorganaCritAttack.inibin | OLS-0ab88f70-d9e0-5e6f-a6fc-7b3f8d48d172 |
| MorganaCritAttack.luaobj | OLS-e1d35ef1-6d07-57e6-980f-1502b62c1298 |
| SoulShackles.inibin | OLS-a64348cc-ebd3-53f0-8b75-5eab2659942c |
| SoulShackles.luaobj | OLS-070162c6-6596-553c-8eac-a1cbc5e2f60e |
| SoulShackles.preload | OLS-f28746cf-25af-54af-98d2-46a881626b4e |
| SoulShacklesOwner.luaobj | OLS-9f635d9c-1e08-56b7-9f4d-eed5ec2b45c9 |
| SoulShacklesOwner.preload | OLS-fad08a03-b734-5066-91b0-21bb397cf872 |
| TormentedSoil.inibin | OLS-b8b344cf-6945-5977-bb92-9e96735ffc23 |
| TormentedSoil.luaobj | OLS-45d47f56-fb40-5901-adb4-c4e2acfa4db1 |
| TormentedSoil.preload | OLS-4f51e396-3851-5fc3-b4fc-5e41dbc2262c |

## Prérequis et contrôles exécutés

Phases, lots, dépendances et questions sont enregistrés dans les observations. Trois questions propres et quatre dépendances de tâches restent conservées. L’audit des frontières ne lève pas les prérequis de fidélité.

Compilation Rust `--locked --offline` avec core réel hors configuration de test et identités/checksums des dépendances alignés sur Cargo.lock. Les1158 entrées core/ressources et la chaîne des preuves antérieures sont préservées. Trois parties publiques Morgana/Annie utilisent Join/Buy/Move/Stop/Attack/Learn/Cast ; aucun dégât, soin, état ou niveau n’est injecté directement.

Objets : Tome1052,435or,+20AP ; Sceptre vampirique1053,800or,+10AD et8% vol de vie. Chaque achat est fait dans sa propre partie et dans le budget initial825. PV max547,47998, mana max340,79999. Morgana garde son mana plein, ses rangs et délais nuls. Tous restent vivants, au niveau1, sans victoire, bouclier, ralentissement ou étourdissement.

| Cas | AD | AP | Vol de vie | Soin observé par impact hors régénération | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 55.46000 | 0.0 | 0.00000 | 0.00000 | 27 | 180 |
| Tome20AP | 55.46000 | 20.0 | 0.00000 | 0.00000 | 27 | 180 |
| Vampiric10AD8percent_lifesteal_control | 65.46000 | 0.0 | 0.08000 | 4.39255 | 27 | 180 |

Chaque cas reçoit trois attaques physiques Annie, puis un Q Annie accepté (80 bruts,60mana). Une attente de90ticks précède trois attaques ordinaires Morgana ; une seconde attente de90ticks suit. Total :9attaques sortantes,9impacts physiques entrants,3Q et540ticks d’attente. Les six déplacements de préparation aboutissent sans reprise ; cela ne ferme pas V564.

Attendu/observé : chaque impact physique dispose d’un témoin de projectile non critique, source, cible et dégâts bruts. La perte de PV correspond aux dégâts après armure et correction de régénération ; les trois Q correspondent aux dégâts après résistance magique, résidu inférieur à0,002. Le soin attendu sur attaque ordinaire vaut les dégâts après mitigation multipliés par le taux de vol de vie courant. Avec le Sceptre : environ4,392551 attendus et4,392550 observés par impact, trois fois. Sans objet et avec Tome :0 attendu, environ0,000002 d’écart d’arrondi observé, inférieur à la tolérance. Aucun supplément de soin au-delà de la régénération n’est observé durant les ticks sans impact et les attentes.

Morgana est suffisamment blessée pour que ces trois soins ne soient pas plafonnés. **Le contrôle ne qualifie pas le soin à PV pleins, l’anti-soin, les amplificateurs, les surdégâts ou les boucliers.** Le soin du Sceptre vient de basic_attack_hit → heal, pas de Soul Siphon.

Les81 refus atomiques couvrent joueur inconnu, auto-ciblage, slot invalide et apprentissages/lancements ciblés/au sol QWER avant et après les contrôles. Chaque snapshot reste identique après refus. Aucun sort Morgana accepté : les dégâts de compétence admissibles et le Spell Vamp n’ont pas été exercés. Les seules attaques ordinaires ne prouvent pas un échec du passif sur un déclencheur adéquat.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-morgana-passive-soul-siphon-probe.exe` ; 6094848 octets ; SHA-256 `203e6f9527c900647a58ad17edc97e23013e8f420aa4e12eaf1ce3f243e3e32e`. BUILD/RUN et inspection renvoient0. Aucun serveur original, rendu graphique, audio ou transport réseau exécuté.

## Consommateurs

La recherche enregistrée dans tous les fichiers Rust de crates/core/src ne trouve aucun des termes Morgana, Empathize, Soul Siphon ou Spell Vamp et leurs variantes inspectées. Ce constat lexical est associé à la lecture du routage learn/cast/cast_at, des dégâts, du vol de vie et des soins, ainsi qu’aux refus d’exécution ; il ne constitue pas seul une preuve d’absence globale dans le projet.

stats et shop fournissent AP/AD/vol de vie ordinaires ; basic_attack_hit applique le vol de vie sur dégâts physiques après mitigation ; heal applique les règles génériques de réception du soin. Le multiplicateur Ignite/Trundle est du contexte non exercé dans ce lot. apply_damage ne démontre pas un producteur Soul Siphon. Les récapitulatifs et snapshots restent du contexte sans acceptation de présentation ou réseau.

Huit ressources locales : catalogue, croissance, ressources, contrats d’attaque/critique, collisions, boutique et Q Annie. Leur présence ne remplace pas une politique historique du passif.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Morgana spawn |
| crates/core/src/lib.rs:598 | public action andatomic refusal |
| crates/core/src/progression.rs:68 | ordinary AP/AD/lifesteal inputs,notspellvamp |
| crates/core/src/progression.rs:150 | unsupported Morgana learning |
| crates/core/src/progression.rs:159 | unsupported Morgana ranks |
| crates/core/src/spells.rs:101 | unsupported Morgana ability trigger |
| crates/core/src/annie_w.rs:29 | unsupported Morgana ground cast |
| crates/core/src/lib.rs:685 | tick order and540idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,notnetwork acceptance |
| crates/core/src/damage.rs:53 | ordinary physical/magic damage,notspellvamp producer |
| crates/core/src/attacks.rs:157 | Morgana andAnnie ordinary ranged attacks |
| crates/core/src/lifesteal.rs:4 | item8percent ordinary lifesteal,not Soul Siphon |
| crates/core/src/regeneration.rs:32 | ordinary HP regen separated fromhealing |
| crates/core/src/regeneration.rs:10 | per-tick health correction |
| crates/core/src/shop.rs:261 | Tome20AP andVampiricScepter10AD8percent |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | ordinary target state |
| crates/core/src/damage.rs:38 | postmitigation damage andlifesteal basis |
| crates/core/src/attacks.rs:26 | ordinary ranged timing |
| crates/core/src/critical.rs:12 | noncritical projectile witnesses |
| crates/core/src/death_recap.rs:184 | context,notrendered recap |
| crates/core/src/death_recap.rs:200 | damage recap context |
| crates/core/src/healing.rs:16 | ordinary item healing;notpassive producer |
| crates/core/src/healing.rs:9 | generic received healing context;Ignite/Trundle modifiers unexercised |
| crates/core/src/annie.rs:45 | three accepted Q80raw60mana |
| crates/core/src/annie.rs:73 | three incoming Q hits |
| crates/core/src/ally_occupancy.rs:635 | six actual public travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | movement boundary,V564 remains open |

## Livraison et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/morgana-passive-soul-siphon-links-v605.json ; preuve docs/fidelity_morgana_passive_soul_siphon_links_v605.json. Les instructions copiables précisent sources, conflits, preuves d’exécution, limites et travail restant. SYS-01.2-02 reçoit la synthèse.

PREPARE/CHECK/PUBLISH/AUDIT renvoient0. Les72 associations volontairement altérées et4 graphes invalides sont refusés. Trois fragments de traçabilité changent,42212 restent identiques. Les deux bases SQLite, projet et application installée, reçoivent quatre lignes ciblées ;42603 autres lignes,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Identifiants, phases/lots et inconnues identiques octet par octet. Aucun statut, critère, propriétaire, note ou case fermé automatiquement.

Revue globale :99097 sources,4156 consommateurs et4156 ancres exactes,aucune divergence. source_hashes_verified=0 représente la vérification structurelle globale ; les sources sélectionnées et consommateurs sont hachés séparément. Aucun nouveau contrôle exhaustif des99097 sources n’est revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés en préservant les preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision605_Morgana_discovery/OBSERVATIONS.json ; revision605_Morgana_passive_probe/OBSERVATIONS.json ; revision605_Morgana_inspection_qualified/OBSERVATIONS.json ; revision605_Morgana/DELIVERY_AUDIT.json ; revision606_trace_review/REVIEW.json. Tous les contrôles de ce lot renvoient0 ; les échecs historiques restent préservés dans la chaîne.

## Travail restant

1. Résoudre f1, ses paliers et sa combinaison avec les autres sources de Spell Vamp.
2. Implémenter les sorts réellement déclencheurs puis le lien entre dégâts admissibles et soin Soul Siphon.
3. Qualifier Q, W périodique dépendant des PV manquants, les deux impacts R et les écarts des scripts communautaires.
4. Définir catégories de cibles, réduction éventuelle de zone/périodique, dégâts après mitigation, absorption et surdégâts sur preuve.
5. Tester soin à PV pleins/manquants, dégâts nuls, mort du lanceur/cible, simultanéité, anti-soin et amplification.
6. Vérifier objets, niveaux, respawn, déconnexion et fin de partie.
7. Qualifier séparément icône, HUD, particules, animations, sons, rendu et réplication.
8. Conserver les limites Battle Training et navigationV564 sans les confondre avec le passif.

Les trois tâches Morgana conservent leurs états antérieurs. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision606_trace_review/REVIEW.json. Morgana V605 intégré :28sources84associations28points56liens. 28sources natives,15références communautaires,10Lua dont7limites NEWTABLE,7preloads,1buff résolu ;18NightmareBot exclus et8chemins candidats absents dont DDF. Soul Siphon décrit f1% Spell Vamp personnel sur dégâts de sorts ;f1,niveaux,modificateurs de cibles restent inconnus. Ancien texte de régénération alliée et textes mana40/60/80% conservés sans adoption. CharScript natif contient deux flags sans callback,communautaire vide ;QWER communautaires codés mais non exécutés ni acceptés comme serveur original. W16timers malgré commentaire single pulse ;rayons W275/native280,R600/native625 à qualifier. Trois cas publics base/Tome20AP/Sceptre10AD8%vol de vie :9attaques sortantes9physiques entrantes3Q Annie,540ticks et81refus atomiques. AD55,46/55,46/65,46 ;seul le Sceptre rend4,39255PV par attaque après mitigation,distinct de Soul Siphon. Aucun sort Morgana accepté,donc déclencheur de dégâts de compétence non exercé. Six trajets sans reprise,aucune injection directe ;V564 reste ouvert. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus d’association/graphe. Conserver preuves,statuts,inconnues et distinguer vol de vie ordinaire de Spell Vamp. Prochain passif à inspecter réellement : Nami. Goal actif.
