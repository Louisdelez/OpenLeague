# Kassadin — sources et consommateurs du passif, V585

Date UTC : 2026-10-26T04:25:41.907876+00:00. Projet `F:/OpenLeague`. **SYS-01.2-02** : relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches Kassadin reliées à **13 sources natives**, **39 associations** et **24 points du moteur**, soit **48 liens** de contrat/simulation. Quatre preuves ajoutées. Trois inconnues propres, quatre dépendances, statuts, critères et propriétaires des questions conservés.

**La réduction passive des dégâts magiques n’est pas réalisée dans les essais publics ; un allié bloque encore Kassadin.** Le passage observé à travers un ennemi existe aussi pour Garen : il ne prouve pas Void Stone. Ce lot relie ces écarts vérifiés aux sources et au moteur ; il n’implémente ni n’accepte le passif.

## Sources et ambiguïtés

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance RADS sélectionnée vérifiées ; cette appartenance ne prouve pas la priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| Kassadin.inibin | OLS-2fa2205e-a1fe-5b59-af27-978e18de85b8 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptKassadin.luaobj | OLS-631ac826-7e8c-5561-964e-1a2021ba40db |
| CharScriptKassadin.preload | OLS-07abb08c-3c40-59e4-9ce7-54beeca510a3 |
| VoidStone.inibin | OLS-b2f56aed-9467-5e52-8857-949f84721de5 |
| VoidStone.luaobj | OLS-8ae831b3-0884-562e-a3bd-32fec9f6afb3 |
| VoidStone.preload | OLS-096a66e3-d185-59cb-8311-11c7aee3c890 |
| VoidStoneEmpowered.inibin | OLS-0a24064b-46d1-5b82-8877-1a9e9820dbdc |
| VoidStoneAttackSpeedBoost.luaobj | OLS-1354e9af-35f1-5a39-b5f7-911d550e5acf |
| NullLance.inibin | OLS-36048dcd-ae34-5233-a9a0-cf55bcd28b60 |
| NullLance.luaobj | OLS-8c1a94fc-51b4-5199-a65c-62ee88f52ce6 |
| NullLance.preload | OLS-ed61b602-638a-5f7e-b71f-e7ae129f9f37 |
| KassadinQCancelChannels.luaobj | OLS-1b2aa530-44b8-59ae-bb53-a0301f1ab668 |

- `Kassadin.inibin` lie `Passive1LuaName=VoidStone`, `Passive1Icon=Voidwalker_Netherburn.dds` et la description native en_GB ligne 4212. Le texte annonce **15 % de réduction des dégâts magiques et absence de collision avec les unités**.
- `VoidStone.inibin` lie le même contrat au tooltip de buff, ligne 2909. Trois liaisons directes sont résolues, aucune réécrite par alias.
- `VoidStoneEmpowered.inibin`, ligne 2910, décrit une vitesse d’attaque augmentée de `@f1@%`. `VoidStoneAttackSpeedBoost.luaobj` déclare explicitement `BuffName=VoidStoneEmpowered`. Cette liaison de métadonnées est établie ; elle ne prouve pas que l’effet fait partie de la politique active du passif 4.20.
- `NullLance.inibin`, ligne 2404, décrit un **bouclier absorbant les dégâts magiques**. C’est un contexte du Q, distinct de la réduction multiplicative du passif. Le helper `KassadinQCancelChannels.luaobj` porte également l’identité NullLance sans exécution de sa politique d’annulation.
- Cinq Lua lus entièrement, zéro prototype enfant, cinq initialisations littérales qualifiées. Aucune instruction serveur historique du passif exécutée.
- `VoidStone.luaobj` porte `Kassadin_VoidStone.dds`, persistance après mort et non-dissipation. Le CharScript natif porte `Teemo_EagleEye.dds`, le helper Empowered `Voidwalker_Netherburn.dds`, et NullLance `Averdrian_AstralBeam.dds`. Les noms hérités et leurs rôles restent distincts, sans remplacement automatique.
- Trois preloads : VoidStone déclare le helper de vitesse d’attaque et des effets Q/shield, transparence et R/vanish ; NullLance déclare ses effets de bouclier et son helper de canalisations. Dépendances ne valent pas exécution ni acceptation visuelle.
- Quatre chemins candidats absents : DDF du personnage, VoidStone dans son sous-répertoire Spells, et les chemins globaux `VoidStoneEmpowered.luaobj/.preload`. VoidStone est bien retrouvé dans les sorts globaux ; le helper AttackSpeedBoost est identifié séparément. Ces absences ciblées ne prouvent pas une absence universelle de ressources.
- Champs natifs : résistance magique 30, croissance 0, rayon de navigation 35, rayon gameplay absent. Les champs de niveau passif sont absents, sans zéro ni valeur par défaut inventée.
- Neuf références communautaires séparées ; CharScript vide. Les fichiers communautaires ne sont pas assimilés au serveur historique.

## Exécution actuelle

Compilation privée `cargo build --locked --offline` du vrai `crates/core/src/lib.rs` non-test, dépendances/checksums alignés sur le lock racine. **1 158 entrées de code/ressources** et les preuves antérieures vérifiées, notamment Karthus V584, Karma V583 et les preuves/échecs de stockage V582.

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-kassadin-passive-void-stone-probe.exe` — 6093824 octets — SHA-256 `56706f2ff59760215179c816a06feec36419c55770f6c7023341f85060f26806`.

### Dégâts publics et contrôle de résistance

Quatre simulations Map10 neuves : Kassadin ou Ahri, sans ou avec achat public de la Cape de néant 1033, coût 500, +25 résistance magique. Annie apprend Q publiquement, lance deux Q puis inflige deux attaques ordinaires. Les acteurs se déplacent par commandes publiques jusqu’au centre. Aucun état, niveau, délai, position, santé ou événement direct de dégâts injecté.

| Cas | Résistance magique | Impacts magiques | Impacts physiques | Refus | Ticks après attaques |
|---|---:|---:|---:|---:|---:|
| kassadin_cloakfalse | 30 | 2 | 2 | 17 | 90 |
| kassadin_cloaktrue | 55 | 2 | 2 | 17 | 90 |
| ahri_cloakfalse | 30 | 2 | 2 | 5 | 90 |
| ahri_cloaktrue | 55 | 2 | 2 | 5 | 90 |

Les huit impacts magiques ont chacun un projectile Annie Q source/cible témoin, dégâts bruts 80. La régénération appliquée après le sort est prise en compte. Les observations corrigées correspondent à **80 × 100 / (100 + MR)** : environ **61,5385 à 30 MR** et **51,6129 à 55 MR**, pour Kassadin comme pour Ahri. Résidu maximal inférieur à 0,002.

La comparaison avec un facteur passif de 0,85 donne environ **52,3077** et **43,8710**. L’écart observé est donc environ **9,2308** et **7,7419** par Q. Ces valeurs de comparaison illustrent le contrat de 15 % ; elles ne qualifient pas l’ordre historique de toutes les réductions.

Les huit impacts physiques ont des projectiles ordinaires témoins non critiques et correspondent au calcul AD/armure, avec correction de la régénération appliquée avant les attaques. Les 360 ticks après les attaques ne montrent que la régénération prévue. Aucun mort, niveau gagné ou bouclier actif observé.

**44 refus sans mutation** : joueur inconnu, attaque sur soi, slot invalide ; Learn/Cast/CastAt des quatre sorts pour Kassadin ; relance d’Annie Q pendant son délai. La stabilité des refus ne qualifie pas les sorts Kassadin. Aucun lancement du bouclier NullLance ni dégât vrai exercé.

### Collision : comparaison au comportement générique

Quatre simulations distinctes, Kassadin/Garen face à une Annie alliée ou ennemie. L’alliée est placée par les joins ordinaires à la base ; l’ennemie et l’acteur se déplacent publiquement vers le centre. Le trajet vise le centre de l’alliée ou un point au-delà de l’ennemie. Aucun déplacement forcé de l’état.

| Cas | Distance minimale observée | Somme des rayons de navigation | Destination atteinte |
|---|---:|---:|---|
| kassadin_ally_occupied_path | 65.0000 | 65 | False |
| garen_ally_occupied_path | 65.0000 | 65 | False |
| kassadin_enemy_occupied_path | 0.6738 | 65 | True |
| garen_enemy_occupied_path | 3.0044 | 65 | True |

Kassadin et Garen restent à **65 unités** de l’alliée, destination non atteinte. Les deux atteignent la destination située au-delà de l’ennemie, en entrant dans la somme des rayons de navigation. Cela prouve le contraste du moteur actuel entre ces cas alliés/ennemis ; ce n’est ni une qualification historique générale de collision, ni une acceptation du passif Kassadin.

Le rayon de navigation n’est pas automatiquement le rayon du corps gameplay. Aucun essai de sbire, monstre, pet, mur, déplacement forcé ou embouteillage multicorps ajouté dans ce lot.

## Consommateurs reliés

| Source et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_dispatch_and_refusals |
| crates/core/src/progression.rs:68 | ordinary_MR_not_passive_multiplier |
| crates/core/src/progression.rs:150 | Kassadin_learning_refusal_AnnieQ_accepted |
| crates/core/src/spells.rs:101 | Kassadin_cast_refusal |
| crates/core/src/annie_w.rs:29 | unsupported_Kassadin_ground_cast |
| crates/core/src/lib.rs:685 | magic_regen_movement_basic_hit_order |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | ordinary_magic_pipeline_no_VoidStone |
| crates/core/src/damage.rs:38 | typed_resistance_and_reduction_formula |
| crates/core/src/penetration.rs:9 | source_penetration_before_resistance |
| crates/core/src/annie.rs:45 | public_AnnieQ_commit |
| crates/core/src/annie.rs:73 | magical_projectile_hit_witness |
| crates/core/src/lifesteal.rs:4 | ordinary_physical_control |
| crates/core/src/attacks.rs:157 | physical_projectile_witness |
| crates/core/src/regeneration.rs:32 | regen_order_correction |
| crates/core/src/shop.rs:261 | public_Cloak_control |
| crates/core/src/shop.rs:215 | Cloak25MR_not15percent_passive |
| crates/core/src/movement.rs:53 | ordinary_motion |
| crates/core/src/ally_occupancy.rs:635 | allied_body_block_no_Kassadin_exception |
| crates/core/src/collision.rs:17 | pathfinding_radius_not_native_gameplay_radius |
| crates/core/src/ally_occupancy.rs:281 | ally_routing_does_not_prove_enemy_collision_policy |
| crates/core/src/lifecycle.rs:33 | static_lifecycle_not_exercised |
| crates/core/src/attacks.rs:103 | static_departure_not_exercised |

Le pipeline actuel applique pénétration, résistance et ses réductions déjà supportées sans branche VoidStone identifiée. Les entrées publiques d’Annie Q et des attaques fournissent les témoins distincts de dégâts magiques/physiques. Le shop et les statistiques expliquent les +25 MR, pas un multiplicateur de 15 %. Les routes et la résolution des mouvements alliés expliquent le blocage. Les fonctions de réapparition et départ sont du contexte statique non exercé ici.

Neuf ressources locales liées séparément : profils de champions, croissance, ressources, attaques, critiques, collision, shop, règles Q Annie et mouvement. Les sélecteurs de champions comprennent Kassadin, Annie, Ahri et Garen. Ces données locales ne deviennent pas des règles originales de serveur par la seule association.

## Travail restant

1. Réduction passive des dégâts magiques et preuves d’ordre avec pénétration, résistance, boucliers, autres réductions et arrondis ; cas zéro, limites, dégâts simultanés, sources absentes et types vrais/physiques.
2. Politique d’absence de collision avec les unités : alliées/ennemies, champions/sbires/monstres/pets, poursuite et déplacements répétés, stationnement et passages étroits. Garder terrain et obstacles distincts des corps d’unités.
3. Distinguer le bouclier NullLance et qualifier ses interactions avec le passif après son implémentation ; les refus actuels ne prouvent pas un bouclier fonctionnel.
4. Qualifier le contexte Empowered et ses paramètres/activation, ou conserver explicitement son rôle historique non adopté. Aucun `@f1@` converti en nombre inventé.
5. Préserver la provenance et les rôles des icônes, résoudre les chemins candidats manquants selon leur portée réelle ; métadonnées et preloads ne remplacent pas les callbacks serveur.
6. Cycle mort/réapparition, déconnexion/fin de partie, HUD, animations, VFX, audio et transport réseau à contrôler après intégration.

Aucun serveur historique, rendu GPU ou transport réseau exécuté par ce diagnostic. Aucun asset 3D manquant n’est déduit des écarts de gameplay. Les limites BattleTraining et le défaut de déplacement V564 restent séparés et ouverts.

## Livraison et conservation

BUILD, RUN et inspection : retours réels 0. PREPARE initial : 0 ; CHECK initial : 1 car la consigne SYS disait seulement « bouclier Q » et omettait le nom NullLance exigé par le contrôle. Les trois consignes Kassadin étaient conformes. Aucun état vivant n’avait alors été publié. Le résumé a été précisé dans un nouveau lot qualifié ; scripts, logs et reçus initiaux restent conservés et pinés. PREPARE, CHECK, PUBLISH et AUDIT du lot qualifié : retours réels 0. La relecture du script généré a corrigé un compteur de catalogue avant sa première exécution ; aucun reçu ni état publié antérieur n’a été remplacé.

- 72 associations volontairement invalides et quatre graphes invalides refusés.
- Trois fragments de consignes modifiés, 42 212 inchangés.
- Deux bases locales : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés** ; synchronisation normale idempotente.
- Identités, hiérarchie et inconnues identiques octet pour octet. Trois questions propres et quatre dépendances conservées avec leurs propriétaires.
- Graphe : **99 017 sources, 3 656 consommateurs**, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues précédemment. Revue globale : **3 656 ancres exactes, zéro divergence courante**. Contrôle structurel distinct du hachage des sources sélectionnées.

Fichiers actualisés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/kassadin-passive-void_stone-links-v585.json`, `docs/fidelity_kassadin_passive_void_stone_links_v585.json`, ce rapport, `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md`, `HANDOFF.md` et reçu privé de reprise. Les deux bases reçoivent les données/consignes ; aucun statut accepté ni case cochée automatiquement. Aucun gameplay/asset modifié.

Preuves : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision585_Kassadin_discovery`, `revision585_Kassadin_passive_probe`, `revision585_Kassadin_inspection_verified`, `revision585_Kassadin` (candidat initial non publié), `revision585_Kassadin_qualified`, et revue `revision586_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision586_trace_review/REVIEW.json. Kassadin V585 publié/audité :13sources natives,39associations,24points/48liens. Quatre cas Kassadin/Ahri sans/avecCape1033,8impacts magiques8physiques,44refus360ticks;dégâts magiques ordinaires61.5385/51.6129 à30/55MR,sans15%passif. Quatre cas Kassadin/Garen :alliés bloquent65,enemis traversés par les deux,donc passage générique nonqualifiant. Cinq Lua littéraux,3buffs liés,3preloads,9communautaires;DDF et3autres chemins candidats absents. Empowered attaque@f1@ et bouclierNullLance séparés,icônes héritées nonremplacées. Conserver les limites et preuves antérieures,KarthusV584,KarmaV583,stockageV582,déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple Katarina. Goal actif;aucun statut/case/inconnu fermé.
