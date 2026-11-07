# SYS-01.2-02 — Maokai : sources et consommateurs de Sap Magic (V600)

Date UTC : 2026-10-26T08:36:09.657879+00:00. Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à17:46:45, fuseau et déploiement non établis. Catalogue officiel4.20.1 distinct.

## Résultat

Les trois fiches CH-Maokai-PASSIF-SOURCE, CH-Maokai-PASSIF-SIMULATION-CONTRAT et CH-Maokai-PASSIF-SIMULATION sont enrichies :62sources natives,186associations,29points de code et58liens. Les sources existent, mais les points liés restent des frontières ou du contexte ; aucun producteur complet de Sap Magic n’est démontré.

Dans deux cas publics, cinq Q ennemis Annie acceptés à150unités puis trois attaques Maokai ne déclenchent aucun soin au-delà de la régénération. Maokai est suffisamment blessé pour recevoir le soin théorique de7%PVmax. Les sorts Maokai sont refusés. Ce résultat documente l’écart actuel ; il ne qualifie ni le passif, ni le champion, ni le jeu. Aucun gameplay ou asset modifié.

## Contrat natif et ambiguïtés conservées

- Maokai.inibin pointe vers MaokaiSapMagicPass et Maokai_Passive.dds. La description en_GB ligne4231 indique une charge par sort proche, cinq charges puis soin de7%PVmax au prochain coup de base. Les six champs Passive1Level sont absents, sans remplacement par zéro.
- Les buffs natifs lignes2267/2268/2269 distinguent Hot, Ready/Melee et Pass ; Pass contient @f1@. Le producteur de cette valeur, le rayon exact, les lanceurs/sorts éligibles et l’ordre précis du comptage ne sont pas qualifiés ici.
- Le même fichier maokaisapmagicpass.inibin contient des champs SpellData hérités : tooltip et description Bushwhack, icône Nidalee_Bushwhack.dds, coût60, rayon600, portée900, coefficient0,4. Les clés Bushwhack résolvent un texte de Nidalee. **Ces champs ne sont pas adoptés comme rayon, coût ou formule de Sap Magic.**
- maokaisapmagicmelee.inibin combine un BuffData pertinent avec le tooltip JesterBasicAttack, présent mais vide, et la description MaokaiBasicAttack, non trouvée dans ce fontconfig. Ses coefficients nuls ne prouvent pas un soin nul. Les anciens PassLev1Desc2..4 mentionnent40/60/80% de régénération mana ; ils ne sont pas une progression du soin.
- 26Lua sont intégralement parcourus, sans fonctions enfants :25initialisations littérales et une limite NEWTABLE àpc10 dans MaokaiTrunkLineMissile. CharScriptMaokai et MaokaiSapMagic sont vides. Ce lecteur n’exécute pas le serveur original ; NEWTABLE n’est pas une preuve de corruption.
- 14preloads incluent la chaîne SapMagic→Hot→Melee et les dépendances global_heal, PassiveHitSound et PassiveSwingSound. Les fichiers nommés Sound exposent notamment des métadonnées d’effets main/yeux, pas une lecture audio vérifiée.
- L’icône maokaisapmagicmelee est Maokai_PassiveReady.dds ; les fichiers HitSound/SwingSound/EAggroSound utilisent Maokai_SapMagicReady.dds. Ces identités distinctes sont conservées. Les labels GlacialStorm/Cryophoenix, GemKnight et Bowmaster des capacités voisines ne définissent pas le passif.
- PersistsThroughDeath sur Pass est une métadonnée ; la conservation ou remise à zéro des charges à la mort/respawn n’est pas démontrée.
- Neuf clés BuffData sont résolues exactement une fois. Les26références communautaires restent secondaires ; CharScriptMaokai.cs est vide.
- Six chemins candidats sont absents : CharScript sous Scripts (le vrai fichier est à la racine du personnage), deux fichiers sous DATA/Spells (les vrais sont sous Characters/Maokai/Spells), Maokai.ddf, maokaisapmagic.inibin et maokaisapmagicpass.preload. Aucun manque global de modèles, textures, animations ou sons n’est déduit de ces chemins.

Chaque source retenue correspond au registre et au manifeste RADS sélectionné, taille et SHA-256 vérifiés. Les identifiants ci-dessous renvoient aux chemins et valeurs exactes dans la preuve.

| Fichier | Source |
|---|---|
| Maokai.inibin | OLS-128e9118-c35f-5719-8946-d3e09c424b2f |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptMaokai.luaobj | OLS-2811a0bf-b47b-572e-bc2c-287d92eb8a02 |
| CharScriptMaokai.preload | OLS-99e47499-c89d-5096-9f2d-4ab390777439 |
| maokaibasicattack.inibin | OLS-0de4dc7e-0101-50e4-88bc-620dcd5db8c4 |
| maokaibasicattack2.inibin | OLS-608d4e6a-25ff-5328-9451-70c726328b78 |
| maokaicritattack.inibin | OLS-a1f4eddd-db45-524f-93f6-246137182b81 |
| maokaidrain.inibin | OLS-aedde654-1d60-52d0-9b2d-983b42941921 |
| maokaidrain3.inibin | OLS-f857937a-4865-5627-b5a7-7acaa417aad8 |
| maokaidrain3.luaobj | OLS-f39ee5ee-5d59-50e8-b5f8-baf50816b33b |
| maokaidrain3.preload | OLS-ea5ceffe-0a9a-5cc5-a0ff-108acbbf5af1 |
| maokaidrain3counter.luaobj | OLS-48a5b8ad-0996-5cf5-b254-c34e74bd3598 |
| maokaidrain3counter.preload | OLS-bce0538e-fbb6-5f22-8e76-1c00da368e6e |
| maokaidrain3defense.luaobj | OLS-b1d3fbdd-5f7e-5aee-9b69-5afb7ac70577 |
| maokaidrain3tally.luaobj | OLS-bc757cac-4a49-5a05-96d0-1b8222fefc9a |
| maokaidrain3toggle.inibin | OLS-d00dd1c4-012e-5b89-9feb-d1be9a8b622d |
| maokaidrain3toggle.luaobj | OLS-fd509683-e64f-56cd-b2c1-ac5848d768e7 |
| maokaidraindefense.inibin | OLS-fb087a67-09c6-5565-992a-b60f1e9382c1 |
| MaokaiEAggroSound.luaobj | OLS-1e3e001e-cb7b-5e41-9109-e1c613fe2d5b |
| maokaieslow.inibin | OLS-9c5df1b5-2458-5d67-8024-f8545836ad89 |
| maokaieslow.luaobj | OLS-ddf3f5b9-f95c-5cac-8f98-6e9e93c70482 |
| maokaigravediggerresurrection.luaobj | OLS-c3469bef-c6de-577d-90ba-0787ce4950bf |
| MaokaiPassiveHitSound.luaobj | OLS-aa5f4834-d436-5acd-a03c-bcc4a39e2be1 |
| MaokaiPassiveSwingSound.luaobj | OLS-b02f1793-0c3f-59f5-b540-03025b9e0bea |
| MaokaiRChargedLoop.luaobj | OLS-fbfb6dad-3e3e-5801-b560-8c3f99852c04 |
| MaokaiRInitialLoop.luaobj | OLS-f621f1b8-a61d-57a8-883f-4fb28d436665 |
| maokaisapling2.inibin | OLS-c4194919-577c-5f20-a9fa-5e4933d45660 |
| maokaisapling2.luaobj | OLS-ff3784cc-38ab-5377-9bd8-ac9735d735cf |
| maokaisapling2.preload | OLS-a89fd600-a6a0-500e-b6b5-2763238e0890 |
| maokaisapling2boom.inibin | OLS-822a85f9-810b-5867-bf6c-f91dc8fc0223 |
| maokaisapling2boom.luaobj | OLS-4f92eb79-b9be-5fb1-bb6b-b36ad117ce1c |
| maokaisapling2boom.preload | OLS-430d34f0-dd5e-5f72-b9c4-ab1d7cf23e9d |
| maokaisaplingmine.inibin | OLS-869734ab-c358-58f7-9052-80b716da6aa5 |
| maokaisaplingmine.luaobj | OLS-10e35a60-2e4b-542f-9177-bc576ee68183 |
| maokaisaplingmine.preload | OLS-6229df8c-3321-5115-8d34-2ecb2dd7e530 |
| maokaisapmagic.luaobj | OLS-53ce57b8-8b29-513b-bf74-305b1e25d8b2 |
| maokaisapmagic.preload | OLS-58df2289-ce89-5189-87a8-36905972d429 |
| maokaisapmagichot.inibin | OLS-91bf1bda-603c-5e04-a292-8bd25677eb74 |
| maokaisapmagichot.luaobj | OLS-62df2388-4b86-5a2b-a975-2e0d92919b95 |
| maokaisapmagichot.preload | OLS-312d2dc1-12e8-5410-b054-01de93d7e0af |
| maokaisapmagicmelee.inibin | OLS-8011c1aa-fb6e-5e07-8ce3-6282c31dd11a |
| maokaisapmagicmelee.luaobj | OLS-c65afd5e-334e-55ff-9c26-3f382babc4d5 |
| maokaisapmagicmelee.preload | OLS-b7e88070-c997-575b-bf08-2e1e71f4aec6 |
| maokaisapmagicpass.inibin | OLS-21248f0f-17fc-5891-8284-84b83184b8c0 |
| maokaisapmagicpass.luaobj | OLS-0adefedb-ced8-574a-bcb8-2cb6021dbaef |
| MaokaiStun.inibin | OLS-2a09e358-5aab-5ace-8119-a625e28b756e |
| MaokaiTrunkLine.inibin | OLS-6a7432a4-9e11-5448-9d6c-01e122fe4afe |
| MaokaiTrunkLine.luaobj | OLS-ae7b94f1-f9b4-538d-a378-fce58a39de81 |
| MaokaiTrunkLine.preload | OLS-adfa782e-9428-565d-8642-c55ac40835cf |
| MaokaiTrunkLineMissile.inibin | OLS-1f7b5711-d8fe-5d19-b6c2-e4ea7bb0552b |
| MaokaiTrunkLineMissile.luaobj | OLS-549b3b48-2748-507e-9de7-9a343e64b042 |
| MaokaiTrunkLineMissile.preload | OLS-e73fc228-a4a3-5d39-922a-dd2b97f74047 |
| MaokaiTrunkLineStun.luaobj | OLS-253e41dc-fded-5605-893a-f0fb7b57c5f9 |
| MaokaiTrunkSmash.inibin | OLS-8bd13d29-93ce-54b6-82a4-15f7252f900b |
| maokaiunstablegrowth.inibin | OLS-1aba6577-ada5-5fc4-adbe-b7f0cc4e3950 |
| maokaiunstablegrowth.luaobj | OLS-567ed994-7c5b-53f8-bdae-5731fbc5ae6a |
| maokaiunstablegrowth.preload | OLS-4968e65b-faa1-5c67-be37-5833eca3764e |
| maokaiunstablegrowtheffects.luaobj | OLS-73746f2c-f52e-5ecf-ad91-19b1aa0a9159 |
| maokaiunstablegrowtheffects.preload | OLS-689fdc10-7e1d-5f4e-88ac-deb9b9a448a2 |
| maokaiunstablegrowthroot.inibin | OLS-773aa593-5f6b-5215-90dc-4b2233e872e6 |
| maokaiunstablegrowthroot.luaobj | OLS-4fa6f236-e8ff-573a-beee-8573670afdea |
| maokaiunstablegrowthroot.preload | OLS-14599316-5eb5-5a54-9502-f2a02e4f0698 |

## Exécution réelle et résultats

Compilation `cargo build --locked --offline`, core réel non compilé comme test ; dépendances et checksums alignés sur Cargo.lock. Simulation Map10 avec commandes publiques Join/Buy/Move/Stop/Learn/Cast/Attack. Aucun état injecté, aucun appel artificiel de healing::heal.

| Cas | PV maximum | Référence7% (pas soin observé) | Q Annie acceptés | Impacts mêlée | Refus Maokai | Ticks de fin |
|---|---:|---:|---:|---:|---:|---:|
| base | 572.20001 | 40.05400 | 5 | 3 | 27 | 180 |
| Ruby_HP_control | 722.20001 | 50.55400 | 5 | 3 | 27 | 180 |

Attendu pour les contrôles ordinaires, observé conforme : cinq Q par cas à150unités, chacun raw80/coût60, dommages magiques et régénération séparés ; résidus inférieurs à0,002. Chaque cas attend432ticks au total les délais Q et38ticks le nettoyage du stun du cinquième Q, avant d’attaquer. Il s’agit du compteur Annie, pas d’une preuve du compteur Maokai.

Avant la première attaque, PV294,53778/572,20001 (base) et444,53778/722,20001 (rubis). Les277,66223PV manquants dépassent les références de soin40,054/50,554. Trois coups de mêlée par cas sont confirmés par le windup source, la cible et le tick de relâchement ; dommages physiques conformes à l’armure, aucun critique. À chaque tick, le gain de PV Maokai correspond seulement à la régénération, résidu inférieur à0,002 ; au premier impact, supplément exactement0 dans les deux cas. Le soin décrit par les textes n’est donc pas observé dans ces scénarios.

Les54refus de commande conservent le snapshot : joueur inconnu, auto-ciblage, slot invalide et apprentissage/lancement Maokai Q/W/E/R ciblé/au sol avant et après. Mana Maokai pleine, rangs et délais nuls ; champions vivants de niveau1, pas de victoire/mort/ralentissement. Le stun Annie est attendu puis nettoyé. Aucun sort Maokai accepté, aucun compteur ou soin Sap Magic qualifié.

Les360ticks de fin sont observés après les attaques ; ils ne prouvent pas une durée ou expiration de charges. Le rayon historique reste à sourcer :150unités est la distance réellement testée, pas une mesure du rayon maximal. Les sorts alliés, propres, hors portée, interrompus, les toggles et autres cibles restent hors de ces deux cas.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-maokai-passive-sap-magic-probe.exe` ; 6053888 octets ; SHA-256 `303b190c553d5adbce29ce7d94a7fd7afa4e0989da52d5606dd93e21f58f9b10`. Les1158entrées du core et des ressources, ainsi que la chaîne des preuves antérieures, sont conservées et revérifiées. BUILD et RUN renvoient0 ; cela valide le diagnostic, pas le gameplay complet.

## Code actuel relié

healing::heal et received_multiplier sont disponibles, mais aucun producteur Maokai n’a été trouvé ou exécuté. basic_attack_hit, attaques, régénération et statistiques fournissent les frontières effectivement utilisées. Les fonctions Annie exécutent les cinq Q et le stun ; elles ne représentent pas un compteur de sorts proches de Maokai. Leurs acquis sont conservés.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary maxHP and target resistance |
| crates/core/src/progression.rs:150 | unsupported Maokai learning |
| crates/core/src/progression.rs:159 | unsupported Maokai rank policy |
| crates/core/src/spells.rs:101 | unsupported Maokai cast |
| crates/core/src/annie_w.rs:29 | unsupported Maokai ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary Maokai melee impacts |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public Ruby150HP control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not passive healing timing |
| crates/core/src/critical.rs:12 | ordinary critical profile;SapMagic critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not passive healing attribution |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted SapMagic attribution |
| crates/core/src/healing.rs:16 | generic healing API,static context;not invoked as SapMagic |
| crates/core/src/healing.rs:9 | current healing modifiers,not passive acceptance |
| crates/core/src/annie.rs:45 | accepted nearby enemy Q casts raw80 cost60 |
| crates/core/src/annie.rs:73 | actual Q damage before Maokai melee |
| crates/core/src/annie_passive.rs:9 | Annie own counter,not Maokai nearbyspell counter |
| crates/core/src/annie_passive.rs:20 | fifth opposing Q stun control |
| crates/core/src/stuns.rs:37 | 38tick cleanup before attacking;not SapMagic behavior |

## Intégration vérifiée

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_sources_4_20.json et fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/maokai-passive-sap-magic-links-v600.json. Preuve : docs/fidelity_maokai_passive_sap_magic_links_v600.json. Les instructions copiables des trois fiches décrivent les sources, contrôles et travail restant ; SYS-01.2-02 reçoit le lien de synthèse.

Les deux bases SQLite du projet et de l’application installée sont mises à jour :4destinataires,42603autres lignes intactes,42607états manuels et23historiques conservés. Synchronisation normale idempotente. Registres des identifiants, phases/lots et inconnues identiques octet par octet ; trois questions propres et quatre dépendances conservées. Aucun statut, critère, propriétaire, case ou note modifié automatiquement.

PREPARE/CHECK/PUBLISH/AUDIT réussissent avec code0. Les contrôles refusent72associations volontairement altérées et4graphes invalides. Trois fragments de traçabilité changent et42212restent identiques. Revue globale :99077sources,4020consommateurs,4020ancres exactes,0divergence. source_hashes_verified=0 désigne la validation structurelle globale ; les payloads sélectionnés et fichiers de consommateurs sont contrôlés séparément, sans prétendre revalider tous les assets du projet.

Documents de couverture/reprise mis à jour : coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md ; champs et preuves antérieurs conservés. Aucun stage/reset/commit/nettoyage.

Détails privés : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision600_Maokai_discovery/OBSERVATIONS.json ; revision600_Maokai_passive_probe/OBSERVATIONS.json ; revision600_Maokai_inspection_qualified/OBSERVATIONS.json ; revision600_Maokai/DELIVERY_AUDIT.json ; revision601_trace_review/REVIEW.json. Les reçus des commandes donnent les codes réellement observés.

## Travail restant

1. Sourcer rayon, distance, catégories de lanceurs/sorts et moment de comptage ; tester intérieur/frontière/extérieur.
2. Implémenter le compteur0..5, état initial, plafonnement, déclenchements refusés/interrompus/multiples, événements simultanés et charges obtenues à l’état prêt.
3. Qualifier consommation au windup/impact, annulation, cible morte, immunité/protection, critique et catégories de cibles.
4. Relier le producteur de soin7%PVmax, @f1@ et l’attribution ; vérifier plafonnement, anti-soin/amplification, soin nul et ordre dégâts/soin.
5. Qualifier niveau, objets, variations temporaires de PVmax, plusieurs Maokai et plusieurs lanceurs.
6. Vérifier mort/respawn, déconnexion, fin de partie, persistance et nettoyage des charges.
7. Vérifier séparément HUD, icônes, modèles/textures, animations, particules, sons, réseau et retour client. Les dépendances préchargées ne constituent pas une acceptation visuelle ou sonore.

Les lacunes Battle Training précédentes et le défaut V564 restent ouverts. Aucun serveur historique, rendu graphique ou transport réseau exécuté dans ce diagnostic.

Suite : Continuer SYS-01.2-02 depuis revision601_trace_review/REVIEW.json. Maokai V600 intégré :62sources186associations29points58liens. 62 sources natives, 26 références communautaires ; 26 Lua dont une limite NEWTABLE sur Q, 14 preloads, 9 buffs résolus. Texte cinq charges de sorts proches et prochain coup soignant7%PVmax. Producteur f1, rayon et sorts éligibles ouverts. CharScript vides, six chemins candidats absents. Champs Nidalee rayon600/portée900/coût60/coefficient0,4, Jester vide, description MaokaiBasicAttack absente et mana40/60/80% conservés sans adoption. Deux cas publics base/rubis150PV :10Q Annie acceptés à150unités,6impacts de mêlée,54refus Maokai,360ticks de fin. Aucun soin au-delà de la régénération ;PV manquants supérieurs à7% au premier coup. Références40,054/50,554PV calculées, pas des soins observés. CinquièmeQ étourdit Maokai ;38ticks de nettoyage par cas avant mêlée. Compteur Annie et fonction de soin générique ne prouvent pas SapMagic. BUILD/RUN/inspection/prepare/check/publish/audit0 ;72+4refus. Conserver preuves et défaut V564. Prochain passif à inspecter réellement : MasterYi. Goal actif, aucun statut/case/inconnue fermé.
