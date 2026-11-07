# SYS-01.2-02 — Nidalee : sources et consommateurs de Prowl / Hunt (V609)

Date UTC : 2026-10-26T11:33:18.005286+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

## Résultat

CH-Nidalee-PASSIF-SOURCE, CH-Nidalee-PASSIF-SIMULATION-CONTRAT et CH-Nidalee-PASSIF-SIMULATION sont reliées à72sources natives,216associations,28points du moteur et56liens sur les deux fiches de simulation. Les consommateurs sont qualifiés comme frontières/contextes, sans passif complet démontré. Aucun gameplay ni asset modifié, aucune tâche clôturée.

Les deux tests publics montrent une vitesse constante335/360 dans le buisson, même vers un ennemi visible. Le bonus Prowl manque au chemin exécuté. Hunt et transformation Cougar restent non exercés, tous les sorts Nidalee étant refusés. Des valeurs natives existent ; elles ne suffisent pas à résoudre tous les conflits de texte, de portée et de consommation.

## Sources vérifiées et limites

- Nidalee.inibin lie NidaleePassiveHunt, Nidalee_Passive.dds et la description en_GB. Le Cougar a le même nom/description du passif, mais aucun Passive1LuaName renseigné : ne pas en déduire une absence voulue de passif en forme Cougar.
- Textes en_GB : bonus10% en buisson pendant2s,30% vers champion ennemi visible à5500unités ; JavelinToss et Bushwhack produisent Hunt4s avec vision et avantages Cougar. Les conditions exactes de direction, frontière de portée, visibilité/partage et rafraîchissement restent à qualifier.
- Le BuffData NidaleePassiveHunt cite Takedown, Pounce **et Swipe** renforcés. Description générale et SpellData citent les premiers Takedown et Pounce seulement. Divergence conservée, sans choix arbitraire.
- SpellData CastRange de NidaleePassiveHunt vaut5900 ; le texte dit5500. Aucune équivalence de rayon, portée de détection ou marge n’est inventée.
- Les textes hérités parlent de critique pour les alliés et d’AttackRate10/15/20%. Aucun n’est adopté comme règle Prowl. Passive1Level1..6 sont absents. Les32lignes DDF sont vides, sans interprétation comme zéro.
- 33INIBIN,23Lua,14preloads,1DDF et1font composent les72sources. Tous les Lua sont parcourus intégralement sans prototype enfant ;12initialisations littérales et11limites NEWTABLE. Une limite du lecteur n’est pas une corruption.
- Les deux CharScripts natifs et le CharScript communautaire sont vides. Prowl/BrushPassive/Hunt/Hunted/Hunting/CougarScent exposent des noms, icônes, particules et flags ; ils ne prouvent pas un callback de vitesse, de vision ou de transformation.
- Onze clés BuffData : neuf correspondances exactes ; `game_buff_tooltip_BrushPassive` et `game_buff_tooltip_Bushwhack` restent sans correspondance dans le font lu. Aucun renommage automatique.
- Quatre noms d’attaque Cougar sont présents à deux chemins. Identités conservées séparément, comparaisons de SHA consignées ; la priorité et le chargement runtime ne sont pas qualifiés. Les champs lus ne prouvent pas la transformation effective.
- Cinq chemins candidats absents : CharScript sous Scripts, Hunt.inibin/.luaobj globaux, Hunt.preload/.ddf sous le personnage. Les fichiers sélectionnés existent aux chemins réels ; aucun manque global d’assets n’est établi. Aucun NightmareBotNidalee dans les deux emplacements inspectés.
- Trente-trois références communautaires sont distinctes du serveur original. Q possède un lancement de projectile commenté et aucune application Hunted dans le corps lu. W.cs définit Pounce, pas la trappe humaine, et calcule une zone275sans déplacement démontré. E soigne et délègue le buff d’attaque. R alterne NidaleeCougarForm avec durée999999 ; la conversion complète des capacités/statistiques n’est pas qualifiée ici. Aucun de ces scripts n’est exécuté comme consommateur Rust dans ce lot.

Sources comparées au registre par taille/SHA-256 et à l’appartenance RADS sélectionnée. Leurs chemins distincts sont conservés dans les preuves.

| Fichier | Source |
|---|---|
| Nidalee.inibin | OLS-9bb2247a-9241-56b4-9cac-8a7dae3edbb6 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nidalee.ddf | OLS-9a4aadac-0b7b-5665-9fbc-450fc2d37570 |
| CharScriptNidalee.luaobj | OLS-5647ab2b-31f5-5612-b289-47f5999e6f33 |
| CharScriptNidalee.preload | OLS-58b57fb7-c2a5-5759-92c8-a4b6a0c6de86 |
| AspectOfTheCougar.inibin | OLS-e75da41e-9614-57d6-ac8b-38960a6bbf94 |
| AspectOfTheCougar.luaobj | OLS-1eac216a-d948-5bc4-b72f-039930917213 |
| AspectOfTheCougar.preload | OLS-02ed97ae-4476-50ad-82e4-94555c27028e |
| AspectOfTheHuntress.luaobj | OLS-134c60f8-3868-5874-a47d-56a8f7607f37 |
| BrushPassive.inibin | OLS-9a568f5e-04f6-5518-b4ba-33e6d65cb9b4 |
| BrushPassive.luaobj | OLS-99771a2c-7f34-5012-b998-e6928e77e6d4 |
| BrushPassive.preload | OLS-4d10849b-f4f4-5fcb-af4a-d6a45862e6d8 |
| Bushwhack.inibin | OLS-4eb16ee8-fdd8-57bc-a583-2baed35793c1 |
| Bushwhack.luaobj | OLS-4c505b4d-0f8d-5e2d-bdea-cfb72f4028b1 |
| Bushwhack.preload | OLS-e91665fe-8830-57ad-8a28-d77f84981b95 |
| BushwhackDamage.inibin | OLS-ddc33617-2e0f-563f-8f8e-2d14b10d0f03 |
| BushwhackDamage.luaobj | OLS-474bcfee-0eab-5d21-a4b6-de870ed108af |
| BushwhackDamage.preload | OLS-04cca627-a491-5e96-b6d8-e975c3dcc70c |
| JavelinToss.inibin | OLS-2740338a-e701-5f10-8d9f-2e7859a018d1 |
| JavelinToss.luaobj | OLS-8525ef83-3298-5a9a-96ec-097fad246007 |
| JavelinToss.preload | OLS-d22d6073-9746-5740-80df-6d49e25b9c3b |
| Nidalee_CougarBasicAttack.inibin | OLS-18e6386d-2e9e-574a-9267-452b6bef50d1 |
| Nidalee_CougarBasicAttack2.inibin | OLS-38fb7e22-a614-5c4e-ace7-6871d6cf6d67 |
| Nidalee_CougarCritAttack.inibin | OLS-5bd9d5cc-0ee6-50fc-9ba7-c7cedddfe891 |
| Nidalee_CougarTakedownAttack.inibin | OLS-db14f67c-b941-573e-8fb2-1adaa80dca9e |
| NidaleeBasicAttack.inibin | OLS-72897a4a-71af-54f4-be2a-c42cc3bfbef1 |
| NidaleeBasicAttack2.inibin | OLS-67df2a31-a013-5e39-bbec-f8d89db4a798 |
| NidaleeCougarScent.inibin | OLS-2dcd5f4e-a0ef-5723-93d2-b347a3d165fd |
| NidaleeCougarScent.luaobj | OLS-1244362e-cd15-5688-bf9b-a13945fd7d01 |
| NidaleeCritAttack.inibin | OLS-6b394472-bf44-5adf-bd4f-940e5dd63bdf |
| NidaleePassiveHunt.inibin | OLS-3665d2ff-f944-5ed3-b43e-9ce7cf1548bd |
| NidaleePassiveHunt.luaobj | OLS-fb3d793c-a861-5841-8bae-c8210285abd1 |
| NidaleePassiveHunted.inibin | OLS-3c608daa-6258-5ae7-b7e2-c86602f6fd74 |
| NidaleePassiveHunted.luaobj | OLS-3b9b53f5-dad0-5246-b758-c846bc0e2504 |
| NidaleePassiveHunted.preload | OLS-d1d44ac9-92d2-52df-aaea-1438b393d06b |
| NidaleePassiveHunting.inibin | OLS-dccab197-8b0a-539a-96f0-e5a0ec7aace3 |
| NidaleePassiveHunting.luaobj | OLS-0918405f-675c-5fdc-a3a5-de7f5c00432a |
| NidaleePassiveHunting.preload | OLS-83aaaab6-f7f3-53bf-9529-287bc9ee1f83 |
| NidaleeTakedownAttack.inibin | OLS-8d530d1c-6837-5003-af43-cbc2e0d4e679 |
| NidaleeTakedownAttack.luaobj | OLS-f1bb7370-ebdc-5b5c-9865-05540745f9bc |
| NidaleeTakedownAttack.preload | OLS-b02480d1-7db2-5a3e-a6a9-f45376917561 |
| Pounce.inibin | OLS-a61e3154-abd7-53d7-9285-8840daca0bff |
| Pounce.luaobj | OLS-6e33d748-3e8d-57dd-a22d-ded3d577cc41 |
| Pounce.preload | OLS-3130787d-75b4-5b44-b958-91cee8879c6d |
| PounceBlocker.inibin | OLS-8c5f9f84-0f68-56de-badd-89fd41cf95da |
| PounceBlocker.luaobj | OLS-73019f6c-bf9c-5e56-8928-17a00cfc32a2 |
| PounceEnabler.inibin | OLS-498564b9-b311-54ab-b827-10b572970651 |
| PounceEnabler.luaobj | OLS-bcef5017-f254-5c37-85ef-f9cbe7e3961f |
| PounceMS.inibin | OLS-92965d6d-eb73-56dd-b8c8-9c5a4d3a8442 |
| PounceMS.luaobj | OLS-38bc3bb8-a93a-59ed-b8d5-28a5b1b8b27c |
| PrimalSurge.inibin | OLS-baeb535c-cb6a-5a72-8b5f-96d662da5948 |
| PrimalSurge.luaobj | OLS-2ad88f27-d965-5f28-b26e-be566ee650fd |
| PrimalSurge.preload | OLS-094556e9-0906-5048-b393-434888642159 |
| Prowl.inibin | OLS-eb5cc411-0af6-551a-b4ef-ec885e8c5f00 |
| Prowl.luaobj | OLS-e6123247-ea19-5fa6-9955-bf6fd95ca5ad |
| Prowl.preload | OLS-c80bcd3b-9660-5436-b1fe-e7dd402c2296 |
| Swipe.inibin | OLS-726ab918-81e7-5310-b2a6-c25adb743087 |
| Swipe.luaobj | OLS-0427b039-88c0-51f2-b06a-3c5b14f03b66 |
| Swipe.preload | OLS-095fdfac-3a98-5866-a873-56207c9f61ac |
| SwipeBlocker.inibin | OLS-aab6eec8-3e72-5005-9e24-8c1fc2f1eaf4 |
| SwipeBlocker.luaobj | OLS-5a6257b9-eeff-5a3f-8d56-77f1a52ddd1f |
| Takedown.inibin | OLS-4a90f5db-a995-5ae1-b88b-ca8c94f691a0 |
| Takedown.luaobj | OLS-345e5452-b08a-5d5d-b07f-adfde847b833 |
| TakedownBlocker.inibin | OLS-45fa7a5f-dc40-52eb-9670-92e1abe2074b |
| TakedownBlocker.luaobj | OLS-b775cf52-7e08-5d18-9798-182d3038e4aa |
| CharScriptNidalee_Cougar.luaobj | OLS-c73e1475-4b41-5fe3-a1ea-99402f9667aa |
| CharScriptNidalee_Cougar.preload | OLS-2ac78119-9fe5-5618-b497-ac507f97f362 |
| Nidalee_Cougar.inibin | OLS-e76cfb1f-c091-5ad1-85db-4912ad733987 |
| Nidalee_CougarBasicAttack.inibin | OLS-6400617f-5782-5436-b625-a9d1c9ea3580 |
| Nidalee_CougarBasicAttack2.inibin | OLS-71039218-b484-5e3f-82c6-f67bed4144c4 |
| Nidalee_CougarCritAttack.inibin | OLS-4b8d578a-30c6-597d-9a35-8e3077a67180 |
| Nidalee_CougarTakedownAttack.inibin | OLS-dc67bb96-e57d-50e5-8ddd-9e6c51c3abae |

## Exécution, attendu et observé

Prérequis de phases/lots, trois questions propres et quatre dépendances conservés. Compilation Rust `--locked --offline`, core réel hors configuration de test et dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et la chaîne de preuves antérieures restent inchangées.

Deux parties publiques Nidalee/Annie, sans objet puis Bottes1001(+25vitesse). Aucun déplacement, buff, dégât, niveau ou visibilité injecté. Les personnages restent vivants niveau1 sans victoire ni contrôle de foule ; Nidalee conserve mana plein, rangs/délais nuls.

Préparation : Nidalee à7084,9819/6884,2402 ; Annie à7484,9819/6884,2402. Quatre trajets mesurés par cas entre le point Nidalee et6684,9819/6884,2402, traversant de vrais drapeaux HAS_GRASS. Le consommateur Navigation::load considère hauteur finie et NOT_PASSABLE ; l’octet exporté nommé open ne détermine pas la praticabilité dans ce code. Les drapeaux et positions sont enregistrés avant/après chaque pas.

| Cas | Vitesse | Pas mesurés | Échantillons buisson | Vers ennemi visible dans le buisson | Refus | Attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 335.0 | 144 | 82 | 40 | 27 | 122 |
| Boots_speed_control | 360.0 | 136 | 76 | 36 | 27 | 122 |

Total :8trajets aboutis,280pas dont272à pleine vitesse,158échantillons buisson dont76vers ennemi visible à moins de5500et82en éloignement. Chaque pas respecte la vitesse ordinaire335ou360divisée par30, tolérance0,003. La vitesse observée ne reçoit aucun bonus Prowl. Les caps/ordres de cumul historiques ne sont pas déclarés qualifiés par cette comparaison.

Quatre trajets de préparation réussis. Avant et après le contrôle de dégâts, deux attentes61ticks par cas donnent244ticks au total. Les offsets59/60/61 sont des observations de cette attente, pas l’âge d’un buff Prowl ou Hunt actif ; aucune expiration de buff absent n’est revendiquée.

Deux QAnnie acceptés, brut80/coût60, dégâts après résistance magique corrigés de régénération, résidus inférieurs à0,002. Les autres ticks correspondent à la régénération seule. Ces impacts ne déclenchent pas Hunt de Nidalee.

Les54refus atomiques couvrent joueur inconnu, auto-ciblage, slot invalide et apprentissage/lancement ciblé/au sol QWER avant/après. Snapshots identiques après refus. Aucun JavelinToss, Bushwhack ou changement de forme accepté : Hunt4s, révélation et sorts Cougar renforcés sont non exercés.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nidalee-passive-prowl-probe.exe`, 6060544octets, SHA-256 `b0bf5b692d6ed620bc817b7a86cbb3e0d44b9e9feec15d1957ba8d67a21d5800`. BUILD/RUN/inspection :0. Aucun serveur historique, rendu, audio ou transport réseau exécuté. Les trajets réussis de ce lot ne ferment pas V564 ni les deux échecs d’arrivée V606.

## Consommateurs réels

Recherche enregistrée dans crates/core/src sans occurrence Nidalee/Prowl/Hunted, complétée par lecture et exécution des routes de mouvement, vision et sorts. Ce constat lexical ne constitue pas seul une preuve d’absence globale.

movement_speed fournit vitesse de base/objets ; effective_speed gère des bonus génériques sans Prowl. flags et line_of_sight lisent le buisson ; visible_to et visible_point_to établissent la visibilité effectivement observée. La présence d’une vision générique ne qualifie pas la révélation Hunt. snapshot_for reste un consommateur de filtrage, sans acceptation réseau. Onze ressources locales, dont règles de mouvement/vision et rayons natifs, sont liées séparément des règles historiques du passif.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | human Nidalee spawn |
| crates/core/src/lib.rs:598 | public actions and refusals |
| crates/core/src/progression.rs:68 | ordinary stats without Prowl |
| crates/core/src/progression.rs:150 | unsupported Nidalee learning |
| crates/core/src/progression.rs:159 | unsupported Nidalee ranks |
| crates/core/src/spells.rs:101 | unsupported hunt and form casts |
| crates/core/src/annie_w.rs:29 | unsupported Nidalee ground casts |
| crates/core/src/lib.rs:685 | tick order |
| crates/core/src/lib.rs:744 | runtime witnesses |
| crates/core/src/regeneration.rs:32 | ordinary regeneration |
| crates/core/src/regeneration.rs:10 | health correction |
| crates/core/src/shop.rs:261 | Boots25speed |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | enemy position state |
| crates/core/src/damage.rs:53 | incoming AnnieQ control,notHunt |
| crates/core/src/damage.rs:38 | magic damage control |
| crates/core/src/annie.rs:45 | two incoming Q80raw60mana |
| crates/core/src/annie.rs:73 | two actual Q hits |
| crates/core/src/ally_occupancy.rs:635 | actual grass entry/exit motion |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,old issues remain |
| crates/core/src/movement.rs:53 | current335/360 without Prowl |
| crates/core/src/movement.rs:37 | generic bonuses,notProwl |
| crates/core/src/movement.rs:19 | generic speed limits;native order open |
| crates/core/src/vision.rs:45 | actual HAS_GRASS flags |
| crates/core/src/vision.rs:48 | ordinary brush LOS,notHunt reveal |
| crates/core/src/vision.rs:79 | actual enemy visibility,notHunt |
| crates/core/src/vision.rs:95 | shared team visibility context |
| crates/core/src/vision.rs:137 | filtered snapshots,network notexecuted |

## Intégration et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/nidalee-passive-prowl-links-v609.json ; preuve docs/fidelity_nidalee_passive_prowl_links_v609.json. Instructions copiables enrichies dans les trois fiches et synthèse SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT :0 ;72associations altérées et4graphes invalides refusés. Trois fragments modifiés,42212identiques. Deux bases locales : quatre destinataires,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation normale idempotente. Identifiants, phases/lots et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99113sources,4264consommateurs,4264ancres exactes sans divergence. Vérification globale structurelle (`source_hashes_verified=0`) ; sources sélectionnées/code hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md actualisés avec preuves antérieures conservées. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision609_Nidalee_discovery/OBSERVATIONS.json ; revision609_Nidalee_passive_probe/OBSERVATIONS.json ; revision609_Nidalee_inspection/OBSERVATIONS.json ; revision609_Nidalee/DELIVERY_AUDIT.json ; revision610_trace_review/REVIEW.json.

## Travail restant

1. Qualifier direction, visibilité, frontière5500, portée interne5900, rafraîchissement et ordre des multiplicateurs.
2. Ajouter Prowl au vrai consommateur, puis tester entrée/sortie du buisson et persistance2s.
3. Implémenter les vrais déclencheurs JavelinToss/Bushwhack et Hunt4s, avec vision alliée et marqueurs par source/cible.
4. Résoudre Swipe dans les textes contradictoires, les capacités renforcées et les conversions humaine/Cougar.
5. Résoudre les clés de texte non liées et la priorité des ressources Cougar dupliquées.
6. Tester plusieurs cibles/Nidalee, immunités, mort, respawn, invisibilité, déconnexion et nettoyage.
7. Qualifier séparément rendu, HUD, particules, animations, audio et réseau.

Les trois fiches Nidalee restent ouvertes. Les limites Battle Training et navigation restent conservées. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision610_trace_review/REVIEW.json. V609 Nidalee / Prowl :72 sources natives humaines/Cougar,216 associations,28 points et56 liens. Textes :10% en buisson2s,30% vers champion visible à5500, Hunt4s. Conflits conservés : Swipe renforcé dans un tooltip seulement ; CastRange5900 contre texte5500. Deux cas publics base/Bottes :8trajets mesurés,280échantillons dont272 pleine vitesse,158en buisson et76vers ennemi visible, vitesse335/360 sans bonus Prowl. 244ticks d’attente,2Q Annie et54 refus atomiques ; aucun sort Nidalee ni transformation accepté, Hunt non exercé. 23Lua dont11limites NEWTABLE,14preloads,32DDF vides,11clés BuffData dont9résolues ; BrushPassive et Bushwhack restent non liées. 33références communautaires ; Q projectile commenté, W classe Pounce et R simple toggle de buff non qualifiés comme serveur original. Deux CharScripts natifs vides ; quatre noms de ressources Cougar présents à plusieurs chemins sans priorité runtime établie. Cinq chemins candidats absents sans manque global d’assets établi. Quatre trajets de préparation réussis ; V564 et échecs V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus de publication. Prochain passif à inspecter réellement : Nocturne. Goal actif.
