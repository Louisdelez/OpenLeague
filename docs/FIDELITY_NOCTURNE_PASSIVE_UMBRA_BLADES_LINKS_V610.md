# SYS-01.2-02 — Nocturne : sources et consommateurs d’Umbra Blades (V610)

Date UTC : 2026-10-26T11:56:41.559710+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à17:46:45 ; fuseau et date de déploiement non établis. Catalogue4.20.1 distinct.

## Résultat

CH-Nocturne-PASSIF-SOURCE, CH-Nocturne-PASSIF-SIMULATION-CONTRAT et CH-Nocturne-PASSIF-SIMULATION sont reliées à59sources natives,177associations,28points du moteur et56liens sur les deux fiches de simulation. Ce sont des frontières et contextes actuels, sans passif complet démontré. Aucun gameplay ni asset modifié, aucune tâche clôturée.

Les trois cas publics produisent des attaques ordinaires et le seul soin du Sceptre vampirique. Aucun bonus de dégâts120% ou soin natif n’est observé. Une seule cible est testée : zone, soin par cible et réduction du délai restent non qualifiés. Le montant historique du soin n’est pas résolu.

## Sources vérifiées et limites

- Nocturne.inibin lie NocturneUmbraBladesTooltip et Nocturne_UmbraBlades.dds. Textes en_GB : attaque toutes les10secondes infligeant120% de dégâts physiques aux ennemis environnants, soin f1 par cible ; chaque attaque réduit le délai de1seconde. Liens font aux lignes2391,2398,2399,4241 et4417 conservés.
- Passive1=1 et Passive1Level1..4=1/6/11/16 sont des champs relevés, sans les déclarer paliers du soin. Les descriptions héritées Warwick et mana40/60/80% ne sont pas adoptées comme règles Nocturne.
- Le montant f1, ses niveaux/paliers, le rayon exact, les cibles éligibles et l’ordre des opérations temporelles restent ouverts. Les12lignes DDF contiennent R bonusAD×1,2, Q bonusAD×0,75 et10lignes vides, dont4UmbraAttack. Ces f1 ne déterminent pas le soin du passif.
- UmbraAttack CastRadius100 et CastRange125 ne qualifient pas le rayon effectif de la zone. Cooldown1=0 ne remplace pas le délai10s décrit. Des champs absents ne sont pas des zéros.
- Le fichier **Nocturne Passive Cooldown.inibin** existe avec espaces. Le BuffName Lua donne ce même nom. L’absence du candidat compact NocturnePassiveCooldown.inibin ne signifie pas que les données de cooldown manquent. Aucun chargement ou ordre de priorité runtime n’est inventé.
- 16INIBIN,26Lua,15preloads,1DDF et1font forment les59sources. Les26Lua sont parcourus intégralement sans prototype enfant :10initialisations littérales et16limites NEWTABLE. Limite de lecture ne signifie pas corruption. Dix clés BuffData sont résolues exactement.
- CharScriptNocturne.luaobj est sous Characters/Nocturne/Scripts et contient seulement BuffTextureName=Wolfman_InnerHunger.dds. Il n’est pas vide. Le CharScript communautaire est vide. L’icône Wolfman ne prouve pas un comportement Warwick.
- UmbraTooltip expose PersistsThroughDeath ; Umbra expose nom/icône et particules prêtes aux deux paumes. Les preloads relient Umbra, cooldown, marker, attaque, nocturneumbrablades_tar.troy et ifhasbuffcheck. Ces métadonnées ne prouvent ni règle de respawn ni rendu ni callback serveur.
- Cinq candidats absents : CharScript à la racine du personnage plutôt que sous Scripts, Umbra.inibin sous le personnage plutôt que global, cooldown compact, UmbraTooltip.preload et Umbra.ddf. Les sources effectivement trouvées sont conservées. Aucun manque global d’assets n’est établi ; aucun NightmareBotNocturne dans les emplacements sélectionnés.
- Vingt-et-une références communautaires sont séparées du serveur original. Q utilise totalAD×0,75 contre bonusAD×0,75 dans le DDF natif ; cône/range et buff de piste ne sont pas qualifiés comme politique native. W délègue un buff1,5s. E utilise quatre timers0,5s et une peur à2s, avec contrôle de mort mais pas de distance dans le fichier lu. R applique dégâts directs et buff4s, sans dash/vision qualifiés. Aucun de ces scripts n’est exécuté comme consommateur Rust de ce lot.

Identités des sources contrôlées par taille/SHA-256 et appartenance RADS sélectionnée. Chemins distincts conservés.

| Fichier | Source |
|---|---|
| Nocturne.inibin | OLS-c433de1a-29d2-5967-8228-d7580dc4615c |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nocturne.ddf | OLS-c2f986b1-fd6c-58ad-8d61-4faac8c10d07 |
| CharScriptNocturne.luaobj | OLS-f480849b-61f5-5109-932c-591c2389af8b |
| CharScriptNocturne.preload | OLS-0440d1b8-dc14-5221-99c1-d04593a3b52c |
| Nocturne Passive Cooldown.inibin | OLS-44aaf2aa-d5b5-5f8b-b63d-c0b7fdb65c0f |
| NocturneBasicAttack.inibin | OLS-0b5d0da1-24ef-5f1d-9c1e-1d394e6519da |
| NocturneBasicAttack.luaobj | OLS-6c3838d5-6275-57ef-a8e6-706d03d8b453 |
| NocturneBasicAttack2.inibin | OLS-a59071d5-5126-597a-9aba-ad0f4937f668 |
| NocturneBasicAttack2.luaobj | OLS-e7f5fbb6-11c1-5553-bd94-efaf78ddd804 |
| NocturneCritAttack.inibin | OLS-66ab4c8b-2673-5371-8eb0-d0b26449d713 |
| NocturneCritAttack.luaobj | OLS-53e67561-e7da-5b6e-b107-4fc794dc14f3 |
| NocturneDuskbringer.inibin | OLS-ff13fbf3-3f1e-5c64-8806-1fb618076dd2 |
| NocturneDuskbringer.luaobj | OLS-3cc5fcc9-bd09-5465-b7aa-1c0a414e5726 |
| NocturneDuskbringer.preload | OLS-ca3f0981-f8c7-59eb-826f-d39a97781635 |
| NocturneDuskbringerHaste.luaobj | OLS-4d355206-3053-5821-99fa-cad74b6e1c4f |
| NocturneDuskbringerTrail.inibin | OLS-9d32e2a9-16b7-57e2-8cdc-ab73e20209b6 |
| NocturneDuskbringerTrail.luaobj | OLS-66b09368-5a52-546d-a5f2-d9b3c3a8cd6f |
| NocturneDuskbringerTrail.preload | OLS-8cfe0d6d-661a-5326-82d5-7f70a0d8d37b |
| NocturneParanoia.inibin | OLS-ceeddad1-9e7a-5e79-91a6-9fad41f59bdc |
| NocturneParanoia.luaobj | OLS-dc31ad79-4f67-526e-a388-ab0bacb7a79e |
| NocturneParanoia.preload | OLS-e8f43e89-c894-5faf-a7de-3037322d55b5 |
| NocturneParanoia2.inibin | OLS-7596b3dc-0133-575e-ac92-dfd71a34d294 |
| NocturneParanoia2.luaobj | OLS-4e9dcb0b-016f-5faf-809f-7ec61de17fb5 |
| NocturneParanoia2.preload | OLS-2c3b3bb3-0447-521e-a111-fb9c5a3057ef |
| NocturneParanoiaDash.luaobj | OLS-fb807416-fddf-5676-a14e-11ad2e8bbebd |
| NocturneParanoiaDash.preload | OLS-c2ba2460-74d9-5d95-9c18-d196f51b04dc |
| NocturneParanoiaParticle.luaobj | OLS-0831a67b-7ba6-5bad-947f-5b6a2e8e9dd2 |
| NocturneParanoiaParticle.preload | OLS-4b912687-3b8d-54d6-864b-94052970d0c1 |
| NocturneParanoiaTarget.inibin | OLS-52d70567-062f-5554-a83d-8705016c94ce |
| NocturneParanoiaTarget.luaobj | OLS-82bffa00-146e-5284-9601-d8210d10457e |
| NocturneParanoiaTargetChaos.luaobj | OLS-0253988e-9620-5767-9c43-eab4a8315c29 |
| NocturneParanoiaTargetChaos.preload | OLS-e7874e9e-f04c-55ef-804a-9f00805af9a6 |
| NocturneParanoiaTargetChaosVO.luaobj | OLS-f936fdf4-f8f3-54d0-a0e0-0c0e65cebc4a |
| NocturneParanoiaTargeting.luaobj | OLS-646ce405-14f2-5034-9363-be18a448f993 |
| NocturneParanoiaTargeting.preload | OLS-4199b6ed-b7ee-54be-8372-1e709fbb7540 |
| NocturneParanoiaTargetOrder.luaobj | OLS-417feb6b-89bc-553f-984f-4ff181a7ebbd |
| NocturneParanoiaTargetOrder.preload | OLS-cabf5708-3139-5415-83e6-82d259716514 |
| NocturneParanoiaTargetOrderVO.luaobj | OLS-f6ccff06-9a57-533e-a62f-5d89ab661960 |
| NocturneParanoiaVO.luaobj | OLS-5b0898a0-b240-564b-b503-1a658b30478e |
| NocturnePassiveCooldown.luaobj | OLS-0935f48b-1102-561c-9cfb-e7875cdea6ca |
| NocturnePassiveCooldown.preload | OLS-c97f7f12-8b81-5cd5-85a8-e8de38be8646 |
| NocturnePassiveCooldownMarker.luaobj | OLS-6c161c52-ceed-5acf-9538-8e421f71f433 |
| NocturneShroudofDarkness.inibin | OLS-f68ec749-6e0a-5719-8ab4-ba089c20f253 |
| NocturneShroudofDarkness.luaobj | OLS-85a66e13-8223-5815-b463-43bb92258b52 |
| NocturneShroudofDarkness.preload | OLS-169b12cc-fc70-57ef-88af-27ece1384bf5 |
| NocturneShroudofDarknessBuff.luaobj | OLS-81118159-6cb5-5f70-847b-295df9536a8c |
| NocturneShroudofDarknessShield.inibin | OLS-b41be21c-6fe5-5995-9c8a-53e8b4e42b4f |
| NocturneUmbraBlades.inibin | OLS-d76280b3-e411-51ff-8e7b-3849a4f4454d |
| NocturneUmbraBlades.luaobj | OLS-b175defc-afbb-5989-a371-3ff7ddb0d614 |
| NocturneUmbraBlades.preload | OLS-535a62ac-de9c-5a27-a1e4-1c2ee5d557cd |
| NocturneUmbraBladesAttack.inibin | OLS-835792e9-5bc5-5b57-a29f-b43a89a2f46c |
| NocturneUmbraBladesAttack.luaobj | OLS-2782fcac-8561-5bdb-af6a-a0a71c706d05 |
| NocturneUmbraBladesAttack.preload | OLS-46e7452a-6210-5ff4-a31f-20ab66424e53 |
| NocturneUmbraBladesTooltip.inibin | OLS-5bded18c-d867-5305-bae3-4e13b33f944f |
| NocturneUmbraBladesTooltip.luaobj | OLS-87698c96-835f-5e79-880e-de1342c4e29f |
| NocturneUnspeakableHorror.inibin | OLS-bafa93d1-2187-5b62-b562-c32fd73a9986 |
| NocturneUnspeakableHorror.luaobj | OLS-b152cd58-e8ba-5f3f-aa3d-ea76dfbaba69 |
| NocturneUnspeakableHorror.preload | OLS-9cac2c91-9216-5cd9-8248-8a1bb7b03eb1 |

## Exécution, attendu et observé

Prérequis de phases/lots consultés, trois questions propres et quatre dépendances conservées. Compilation Rust --locked --offline, core réel hors configuration de test, dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et les preuves antérieures restent inchangées.

Trois parties publiques Nocturne/Annie : sans objet, Épée longue1036(+10AD), Sceptre vampirique1053(+10AD et8%vol de vie). Aucun déplacement, dégât, soin, niveau ou buff injecté. Les personnages restent vivants niveau1, sans contrôle de foule, bouclier ou victoire ; rangs/délais Nocturne nuls et mana plein.

Chaque cas : deux trajets de préparation ; trois impacts physiques et un QAnnie ; attente301ticks ; trois attaques Nocturne ; attente301ticks ; trois autres attaques Nocturne. Total18attaques mêlée,9impacts physiques entrants,3Q,1806ticks d’attente et6trajets sans reprise. Les témoins windup.release identifient source/cible des attaques.

| Cas | AD | AP | Vol de vie | Soin observé par première attaque | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 59.20800 | 0.0 | 0.00000 | -0.00001 | 27 | 602 |
| LongSword10AD | 69.20800 | 0.0 | 0.00000 | -0.00001 | 27 | 602 |
| Vampiric10AD8percent_lifesteal_control | 69.20800 | 0.0 | 0.08000 | 4.64403 | 27 | 602 |

Attendu pour le chemin générique actuel : dégâts AD après armure, régénération et vol de vie d’objet seulement. Observé : résidus inférieurs à0,002. Aucun coefficient120% sur les18attaques. Base et Épée : soin supplémentaire nul à l’arrondi près. Sceptre : soin attendu4,6440525PV, observé4,6440301PV sur chacun des six coups ; assez de PV manquants pour éviter le plafonnement. Le contrôle Épée/Sceptre conserve le même AD et isole le soin de l’objet.

Les attentes301ticks dépassent10s, mais ne constituent pas une mesure d’âge ou d’expiration du buff natif absent. La réduction1s par attaque et les éventuelles règles de reset restent non qualifiées. Une cible ennemie seulement : aucun succès multicible revendiqué.

QAnnie accepté trois fois : brut80/coût60, dégâts après résistance et correction de régénération. Les81refus atomiques couvrent joueur inconnu, auto-ciblage, slot invalide, apprentissage/lancement ciblé/au sol QWER avant et après. Snapshots identiques après refus. Aucun sort Nocturne accepté.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nocturne-passive-umbra-blades-probe.exe`, 6153216octets, SHA-256 `79b786696cc39936152b9554f119ec1859dd263266add7b0ed475e48a639839e`. BUILD/RUN et inspection qualifiée :0. Aucun serveur historique, rendu, audio ou transport réseau exécuté. Les trajets de ce lot ne ferment ni V564 ni les deux échecs d’arrivée V606.

## Consommateurs actuels

Recherche Nocturne/Umbra dans crates/core/src sans occurrence, complétée par lecture et exécution des routes d’attaque, statistiques, dégâts, régénération, soin et refus. La recherche lexicale seule ne prouve pas une absence globale.

progression::stats calcule AD ordinaire et vol de vie des objets ; basic_attack_hit applique le vol de vie aux dégâts après mitigation via heal. Aucun producteur Umbra avec zone, soin natif et cooldown n’a été identifié sur ces routes. Huit ressources locales sont liées séparément : catalogue, croissance, ressource, attaque, critique, collision, boutique et QAnnie.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Nocturne spawn |
| crates/core/src/lib.rs:598 | public action andatomic refusal |
| crates/core/src/progression.rs:68 | ordinary AD and item lifesteal inputs,notUmbra |
| crates/core/src/progression.rs:150 | unsupported Nocturne learning |
| crates/core/src/progression.rs:159 | unsupported Nocturne ranks |
| crates/core/src/spells.rs:101 | unsupported Nocturne spell action |
| crates/core/src/annie_w.rs:29 | unsupported Nocturne ground cast |
| crates/core/src/lib.rs:685 | tick order and1806idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,notnetwork acceptance |
| crates/core/src/damage.rs:53 | ordinary physical/magic damage and lifesteal basis |
| crates/core/src/attacks.rs:157 | Nocturne melee and Annie ranged attacks |
| crates/core/src/lifesteal.rs:4 | item8percent ordinary lifesteal,notUmbraheal |
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

## Intégration et conservation

Registres : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/nocturne-passive-umbra-blades-links-v610.json ; preuve docs/fidelity_nocturne_passive_umbra_blades_links_v610.json. Instructions copiables enrichies dans les trois fiches et la synthèse SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72associations altérées et4graphes invalides refusés. Trois fragments de traçabilité changés,42212identiques. Deux bases locales : quatre destinataires,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation normale idempotente. Identifiants, hiérarchie et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99117sources,4292consommateurs,4292ancres exactes sans divergence. Cette revue est structurelle (source_hashes_verified=0) ; les sources sélectionnées et le code sont hachés séparément, sans recontrôle exhaustif de toutes les sources revendiqué.

Un libellé d’ancre du premier relevé mentionnait540ticks, hérités du modèle précédent. Corrigé en1806dans une nouvelle inspection avant publication. Premier relevé et première préparation non publiée conservés ; ils ne constituent pas une panne du moteur. Un précontrôle du générateur de finalisation a refusé la mention540dans l’explication même de cette correction ; filtre rectifié avant toute finalisation. Les faits runtime et binaires n’ont pas été changés.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md actualisés avec preuves antérieures conservées. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision610_Nocturne_discovery/OBSERVATIONS.json ; revision610_Nocturne_passive_probe/OBSERVATIONS.json ; revision610_Nocturne_inspection_qualified/OBSERVATIONS.json ; revision610_Nocturne_qualified/DELIVERY_AUDIT.json ; revision611_trace_review/REVIEW.json. Les scripts et reçus de commande permettent de reproduire chaque contrôle.

## Travail restant

1. Résoudre le montant/progression du soin f1, les cibles éligibles, le rayon et les ordres de cooldown.
2. Implémenter le producteur du passif dans le chemin d’attaque effectif, avec marqueur prêt/cooldown et sélection multicible.
3. Qualifier les120% de dégâts, le soin par cible et les interactions avec critique, vol de vie, boucliers et immunités.
4. Tester avant/à/après10s, réduction1s sur attaques successives, interruption, mort/respawn et nettoyage.
5. Couvrir champions/sbires/monstres/structures, dégâts nuls/surdégâts, PV pleins/plafonnement, anti-soin et modificateurs.
6. Qualifier séparément QWER, HUD, icônes, rendu, particules, animations, audio et réseau.

Les trois fiches Nocturne restent ouvertes. Les limites Battle Training et navigation sont conservées. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision611_trace_review/REVIEW.json. V610 Nocturne / Umbra Blades : 59 sources natives,177 associations,28 points et56 liens. Textes natifs : toutes les10s, attaque à120% dégâts physiques aux ennemis environnants, soin f1 par cible ; chaque attaque réduit le délai de1s. Montant/progression du soin, rayon exact et ordre du délai restent inconnus. Trois cas publics base/Épée1036/Sceptre1053 :18attaques mêlée,9impacts physiques entrants,3Q Annie,1806ticks et81refus atomiques. Deux attentes301ticks par cas ; aucun bonus120% ni soin natif observé. Seul le Sceptre soigne4,64403PV par attaque, conformément à ses8% de vol de vie. Une seule cible : zone et réduction du délai non qualifiées. 26Lua dont16limites NEWTABLE,15preloads,12DDF,10clés BuffData résolues ;21références communautaires. CharScript natif expose seulement une icône Wolfman ; communautaire vide. Le fichier natif de cooldown possède des espaces dans son nom et est présent. Cinq chemins candidats absents ne prouvent pas un manque global d’assets. Valeurs héritées Warwick et paliers Passive1Level non adoptés comme soin. Q communautaire utilise AD total contre bonus AD dans DDF natif ; autres QWER non qualifiés comme serveur original. Libellé hérité540ticks corrigé en1806avant publication ; premier relevé conservé. Six trajets sans reprise ; V564 et deux échecs V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection qualifiée/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus de publication. Prochain passif à inspecter réellement : Nunu. Goal actif.
