# Lee Sin — sources et consommateurs de Rafale / Flurry, V592

Date UTC : 2026-10-26T06:20:28.787740+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02** : relier les exigences aux sources natives et à leurs consommateurs actuels.

## Résultat et portée

Trois fiches du passif reliées à **25 fichiers natifs**, avec **75 associations**, **20 points de code et 40 liens**. Le fichier du marqueur Shen fait partie de ces 25 fichiers comme preuve d'une référence contradictoire, pas comme contrat adopté pour Lee Sin. Quatre sources de preuves ajoutées ; trois questions propres, quatre dépendances, statuts et critères conservés.

Les attaques normales fonctionnent dans les trois scénarios. **L'apprentissage et les lancements de sorts restent refusés pour Lee Sin.** Aucun déclenchement de Rafale n'est exercé. Énergie constamment plafonnée : le test ne démontre ni remboursement, ni consommation de charges, ni bonus de vitesse du passif. Aucun code de gameplay ou asset modifié dans ce lot de traçabilité.

## Sources et incohérences conservées

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 à 17:46:45, fuseau et date de déploiement inconnus. Catalogue 4.20.1 distinct. Taille, SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées. Cela ne démontre pas la priorité de montage historique ni le comportement du serveur original.

| Fichier | Identité source |
|---|---|
| LeeSin.inibin | OLS-6ca4ddcd-bdf6-5eed-bfa9-ef64c3bcf8d5 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| LeeSin.ddf | OLS-8e69c762-e0f7-5f10-beb7-6599c4bad88e |
| CharScriptLeeSin.luaobj | OLS-fb319dbc-cee9-5e4c-aa01-43a87f07068f |
| CharScriptLeeSin.preload | OLS-705c34ed-e3bf-5e66-aadd-a8d77b0e34bf |
| BlindMonkFlurry.inibin | OLS-7e09c4a7-20c0-5c59-b562-159db0f503d0 |
| BlindMonkPassive.luaobj | OLS-b6003e81-d590-5f84-a632-1c1697b1c67e |
| blindmonkpassive_cosmetic.luaobj | OLS-47298de7-ef5e-56e6-a28f-b457cf631583 |
| LeeSinBasicAttack.inibin | OLS-0557df4c-efc2-5221-b210-758725772ae7 |
| LeeSinBasicAttack.luaobj | OLS-7f539808-b513-5274-af26-403e1dadf81a |
| BlindMonkQOne.inibin | OLS-c356004e-3d62-53f6-b058-73d3f9bd6513 |
| BlindMonkQOne.luaobj | OLS-684139ab-1eec-58e8-a120-d3d0d81aa98d |
| BlindMonkQTwo.inibin | OLS-557b051b-5bec-5557-9136-7414b1372714 |
| BlindMonkQTwo.luaobj | OLS-c23b1fcb-dff5-5a41-b6cd-7271694ecb75 |
| BlindMonkWOne.inibin | OLS-9cea31af-00c2-5a2a-be86-d72c93f8b09a |
| BlindMonkWOne.luaobj | OLS-d85d121b-9d86-5ba1-bf1d-8e1158a563a5 |
| BlindMonkWTwo.inibin | OLS-248a4a3b-7adf-5a77-ad38-282f17e73ea2 |
| BlindMonkWTwo.luaobj | OLS-d1e8559e-9218-5521-aa72-6b59d8e2f0ac |
| BlindMonkEOne.inibin | OLS-f8e40604-2cc4-5e9b-a820-952afa00837d |
| BlindMonkEOne.luaobj | OLS-2bbe0aa1-00e0-5ecd-8e68-4fc4d073b439 |
| BlindMonkETwo.inibin | OLS-a2ff499f-6a43-50f4-9546-245cb36e2e2c |
| BlindMonkETwo.luaobj | OLS-5a3ce625-c602-5b4a-aad5-eae28a1691d2 |
| BlindMonkRKick.inibin | OLS-26228c18-3c17-5691-897f-e649a493f3de |
| BlindMonkRKick.luaobj | OLS-6d4d9c01-8e0a-5949-ac07-270cf6ee0cf8 |
| Shen Passive Marker.inibin | OLS-4983641a-fb2c-5350-bac7-7b1f32b60a3a |

- Description personnage, `fontconfig_en_GB.txt` ligne **4219** : après utilisation d'une capacité, les **2 prochaines attaques** gagnent **40 % de vitesse d'attaque** et rendent **15 Energy chacune**. Buff Flurry ligne **1724** : vitesse augmentée et restitution de 15 énergie. Le texte indique l'effet général, pas toutes ses règles d'exécution.
- `LeeSin.inibin` : `PARType=Energy`, `BaseMP="200.0"`, `BaseStaticMPRegen="10.0"`, icône `LeeSinPassive.dds`, Q/W/E/R déclarés BlindMonkQOne/WOne/EOne/RKick.
- **Incohérences natives** : `Passive1LuaName="Shen Passive Marker"`. Le fichier exact existe et sa description ligne **2622** est **Ki Strike**, décrivant Shen. `Passive1Desc` décrit Jax ; `PassLev1Desc2..4` indiquent +40/+60/+80 % de régénération Mana ; `Passive1Level1..6` valent **3,7,11,15,absent,absent**. Ces champs sont conservés sans normalisation, sans substitution et sans adoption comme progression de Rafale. Leur rôle réel dans le client/serveur historique reste à qualifier.
- Le preload de personnage déclare `BlindMonkPassive` et sa variante cosmétique. Les métadonnées de ces deux Lua ont les mêmes littéraux : `BuffName=BlindMonkFlurry`, `BuffTextureName=BlindMonkPassive.dds`, particule `blindMonk_passive_buf.troy` attachée aux mains `L_hand` et `R_hand`. Identité des littéraux ne prouve pas identité de comportement serveur. Les deux noms d'icônes restent distincts.
- **11 Lua** entièrement parcourus structurellement, zéro prototype enfant : **4 initialisations littérales qualifiées**, **7 limites NEWTABLE** du lecteur. Positions : BasicAttack 0, QOne 12, QTwo 6, WOne 8, WTwo 12, EOne 18, RKick 18. Ce sont des limites d'analyse des instructions, pas la preuve de fichiers corrompus.
- ETwo déclare notamment `TriggersSpellCasts=true` et `DoesntTriggerSpellCasts=false`, persistance et non-dissipation. Ces métadonnées ne qualifient pas le déclenchement de Rafale à la réactivation du E.
- **1 preload** sélectionné, **16 lignes DDF** QWER sans formule Flurry. Les autres preloads éventuels ne sont pas déclarés absents par cette sélection.
- **14 références communautaires** hachées et identifiées séparément ; `CharScriptLeeSin.cs` est une classe vide. Leur présence ne remplace pas une politique serveur originale prouvée.
- **Six chemins candidats absents** : CharScript sous `Scripts`, Flurry INIBIN global, Flurry Lua et Passive INIBIN/preload/cosmetic INIBIN dans les sorts du personnage. Les fichiers présents sous d'autres noms ou emplacements restent identifiés. Cela ne constitue pas un inventaire exhaustif des assets manquants.

## Vérifications exécutées

Compilation privée `cargo build --locked --offline` contre le vrai core non-test. Locks et checksums vérifiés ; **1 158 entrées** de code/ressources et chaîne de preuves antérieures préservées. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-leesin-passive-flurry-probe.exe`, **6042112 octets**, SHA-256 `e7fbd0c0e55e2124ffe6658ea8af6ad66d1d39801d75f44125478cc7785f72ea`.

Trois parties Map10 neuves, Lee Sin contre Annie. Commandes publiques pour rejoindre, acheter, se déplacer, attaquer et s'arrêter ; aucune injection de santé, énergie, rang, temps ou charges. Positions centrales réellement atteintes enregistrées. Six attaques par cas puis 180 ticks après Stop.

| Cas | Impacts physiques | Refus atomiques | Ticks après Stop | Cadence observée (ticks) | Énergie maximale |
|---|---:|---:|---:|---:|---:|
| base | 6 | 27 | 180 | 46 | 200 |
| Sapphire_energy_control | 6 | 27 | 180 | 46 | 200 |
| Dagger_cadence_control | 6 | 27 | 180 | 40 | 200 |

**Attendu pour les contrôles ordinaires :** dégâts physiques après mitigation, cadence correspondant aux statistiques courantes, refus sans mutation pour commandes non prises en charge, aucune énergie supplémentaire par achat de mana.

**Observé :** 18 impacts, chacun associé au windup Lee Sin visant Annie et à son tick de libération, non critique ; écart de dégâts après correction de régénération inférieur à 0,002. Les cinq intervalles par cas sont respectivement **46/46/40 ticks**. Dagger réduit la cadence ordinaire ; ce n'est pas le bonus de 40 % de Rafale. Sapphire ne change pas le plafond Energy de 200.

**81 refus atomiques** : joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt QWER avant et après les attaques. Snapshots inchangés lors des refus. Rang et recharge restent nuls. **540 ticks après Stop**, uniquement régénération attendue ; participants vivants niveau 1, aucune mort ni fin de partie. Le taux de régénération déclaré est **10 énergie/s**, mais l'énergie reste au plafond : la restauration sous plafond n'est pas mesurée ici.

**Attendu pour Rafale :** après un sort admissible accepté, deux attaques accélérées et remboursement selon le contrat natif. **Observé : précondition absente, car aucun sort accepté.** Ce lot ne fournit pas de cas nominal du passif complet ; il vérifie la frontière actuellement implémentée et ses refus. Aucune acceptation passive, réseau, rendu ou audio.

### Échec d'inspection conservé

Le premier contrôle d'inspection supposait à tort que les six champs de niveau passif étaient absents, par reprise d'un contrôle précédent. Il a terminé avec code 1 avant publication. La relecture brute a trouvé 3/7/11/15 pour les quatre premiers champs, ainsi que les descriptions Jax/Mana. Le script initial est conservé et haché ; l'inspection qualifiée utilise un nouveau nom, vérifie les valeurs exactes et ne les transforme pas en règles adoptées. Les essais Rust étaient déjà réussis et n'ont pas été relancés pour cet échec documentaire.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | resource initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | Energy cap and ordinary cadence; no Flurry term |
| crates/core/src/progression.rs:150 | unsupported LeeSin learning |
| crates/core/src/progression.rs:159 | unsupported LeeSin rank policy |
| crates/core/src/spells.rs:101 | unsupported LeeSin cast |
| crates/core/src/annie_w.rs:29 | unsupported LeeSin ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical damage |
| crates/core/src/attacks.rs:157 | melee release and ordinary cadence |
| crates/core/src/attacks.rs:26 | ordinary attack profile |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | capped ordinary resource regeneration |
| crates/core/src/regeneration.rs:10 | 10 Energy per second declared rate |
| crates/core/src/lifecycle.rs:16 | Sapphire exclusion for Energy |
| crates/core/src/lifecycle.rs:24 | ordinary Energy regeneration eligibility |
| crates/core/src/shop.rs:261 | public Sapphire and Dagger controls |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/shop.rs:314 | ordinary item cap refresh |

Les fonctions de progression et de sorts expliquent les refus ; `stats` calcule actuellement la cadence sans terme Rafale. Les fonctions d'attaque expliquent les impacts ordinaires. `uses_mana`, `restores_resource`, la régénération et les achats expliquent le plafond Energy et les contrôles Sapphire/Dagger. Ces points sont explicitement qualifiés comme **frontières actuelles**, pas comme une implémentation du passif.

Sept ressources locales de champions, progression, type de ressource, attaques, critiques, collisions et boutique sont liées séparément. Leur présence ne prouve pas la politique historique complète.

## Travail restant, sans clôture automatique

1. Résoudre le rôle des champs anciens contradictoires et le chemin effectif de sélection du passif ; conserver le conflit Shen/Jax/Mana tant qu'il n'est pas démontré.
2. Qualifier les sorts et réactivations admissibles : Q1/Q2, W1/W2, E1/E2 et R ; accepter les commandes selon leurs contrats propres avant de prétendre tester un déclenchement Rafale.
3. Définir déclenchement, rafraîchissement, cumul/remplacement, durée, expiration et nombre de charges, puis implémenter ces règles.
4. Qualifier consommation au départ/à l'impact, annulations, esquives, échecs, cibles champions/sbires/monstres/bâtiments et événements simultanés.
5. Implémenter et vérifier les deux attaques accélérées, le retour à la cadence normale, le plafond de vitesse et les interactions avec objets/ralentissements/autres bonus.
6. Vérifier les 15 énergie par attaque sous plafond et près du plafond, l'ordre avec coût/régénération naturelle, l'absence de duplication et les cas refusés.
7. Qualifier mort, réapparition, déconnexion, fin de partie et nettoyage des charges.
8. Vérifier séparément icônes, effets des deux mains, animations, audio, HUD, visibilité et transport réseau.
9. Étendre les cas à plusieurs niveaux et bordures temporelles, avec preuves identifiées et comparaison native ; aucune valeur absente ne doit être inventée.

Le manque démontré ici concerne notamment les commandes de sorts et la logique du passif. Aucun manque global de modèles/textures n'est déduit de ces essais. Les limites Battle Training et le défaut de déplacement V564 restent ouverts dans leurs preuves antérieures.

## Livraison et conservation

BUILD/RUN Rust, inspection qualifiée, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0. Le premier contrôle d'inspection code 1 est conservé séparément.

- 72 associations volontairement fausses et quatre graphes invalides refusés.
- Trois fragments génériques de consignes changés, 42 212 inchangés ; la note SYS est actualisée séparément.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes identiques ; **42 607 états manuels et 23 historiques préservés**, synchronisation normale idempotente.
- Registres d'identité, hiérarchie et inconnues identiques octet pour octet. Trois questions propres et quatre dépendances conservées.
- Graphe : **99 045 sources, 3 823 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes, 5 517 résolues précédemment**. **3 823 ancres exactes**, aucune divergence courante. Vérification structurelle globale distincte du hachage des sources sélectionnées ; aucun recensement exhaustif des 99 045 contenus exécuté.

Fichiers modifiés : registres `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/leesin-passive-flurry-links-v592.json` ; preuve `docs/fidelity_leesin_passive_flurry_links_v592.json` ; ce rapport ; `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md` ; consignes ciblées des deux bases et note de reprise privée. Aucun gameplay/asset modifié, aucune case cochée.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision592_LeeSin_discovery`, `revision592_LeeSin_discovery_expanded`, `revision592_LeeSin_passive_probe`, `revision592_LeeSin_inspection_qualified`, `revision592_LeeSin`, `revision593_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision593_trace_review/REVIEW.json. Lee Sin V592 publié et audité : 25 sources dont marqueur Shen contradictoire,75 associations,20 points/40 liens. Trois cas publics18impacts81refus540ticks ; Energy plafonnée200, cadences46/46/40. Aucun sort accepté, aucun déclenchement ni remboursement passif exercé. Texte2attaques/40%/15Energy lié.11Lua dont7limites NEWTABLE,1preload,16DDF,14communautaires. Champs bruts Shen/Jax/Mana et niveaux3/7/11/15 conservés sans adoption. Première inspection code1 hypothèse de champs absents corrigée dans une nouvelle inspection qualifiée ; ancien script conservé. Toutes étapes qualifiées0,72+4refus. Conserver preuves antérieures et défautV564. Prochain passif à inspecter réellement : Leona. Goal actif ; statuts, cases et inconnues restent ouverts.
