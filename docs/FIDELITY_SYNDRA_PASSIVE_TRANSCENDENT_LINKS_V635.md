# Syndra — Transcendent, sources et admission des rangs V635

Date : 2026-10-26T19:49:51.324895+00:00. Projet `F:/OpenLeague`. Tâche active SYS-01.2-02 : relier chaque exigence à sa source native et à son consommateur actuel. Livraison sur PASSIF-SOURCE, PASSIF-SIMULATION-CONTRAT et PASSIF-SIMULATION de Syndra, plus suivi général. Aucun code du jeu ou asset modifié.

## Résultat et portée

**Le moteur refuse l’apprentissage des sorts de Syndra aux 18 niveaux contrôlés.** Les quatre rangs restent à zéro. Les effets du passif au rang maximal ne sont donc pas exercés ; le rapport ne prétend pas mesurer leur absence sur un sort maximal jamais lancé. Le témoin Annie prouve que le chemin local peut apprendre 18 rangs et atteindre 5/5/5/3.

116 fichiers natifs, 348 associations, 11 points de code et 22 liens aux deux fiches de simulation. Les consommateurs restent qualifiés comme entrées ou mécanismes génériques avec `provides_feature_consumer=false`. Trois questions propres et quatre dépendances préservées ; aucune acceptation du passif ou du jeu.

## Référence et sélection

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. Deploy sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

La sélection reprend les liens précédents et vérifie les chemins globaux et propres au champion, les octets par taille/SHA-256 et l’appartenance aux manifestes sélectionnés. Elle contient 32 INIBIN, 51 Lua, 31 preloads, Syndra.ddf et fontconfig_en_GB.txt. CharScriptSyndra se trouve sous Scripts ; Syndra.ddf à la racine. Les candidats CharScript à la racine, DDF en_gb et DDF sous Localization sont absents, sans prétention d’absence globale. Aucun NightmareBot retenu.

| Source | Identité du registre |
|---|---|
| Syndra.inibin | OLS-ccd1f74e-929e-56f3-a131-c0805d982d4e |
| Syndra.ddf | OLS-1eb7a84f-d6a3-540b-ad11-b9f8b7395eff |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptSyndra.luaobj | OLS-020761f4-52b2-54d6-a153-f28a8f847f68 |
| CharScriptSyndra.preload | OLS-30f305e7-21d4-5033-a720-acfa30e8ba08 |
| SyndraBasicAttack.inibin | OLS-70327656-576d-537c-9c44-5ab9eece3cee |
| SyndraBasicAttack.luaobj | OLS-dea5eec1-70f7-5287-9938-73abf0087f02 |
| SyndraBasicAttack2.inibin | OLS-8888b8ba-ed7f-52e5-b1f5-a26fde5ab5bf |
| SyndraBasicAttack2.luaobj | OLS-4b3793a6-b951-58b7-9c98-f21e48c2c522 |
| SyndraCritAttack.inibin | OLS-8031431a-b685-54e6-a094-3ccde9f6b454 |
| SyndraCritAttack.luaobj | OLS-7e2d973f-82e2-50ec-b5d9-28eb7aa0e1b8 |
| SyndraE.inibin | OLS-e5bf8ffb-7f22-5f16-bc3f-96853628dba5 |
| SyndraE.luaobj | OLS-b190e69b-02b5-5520-b14d-90658f2d19c0 |
| SyndraE.preload | OLS-d269a08a-e861-5baf-a12b-397bfc340efb |
| SyndraE5.inibin | OLS-bb369f86-5f97-51ed-8b5f-e02ba3259643 |
| SyndraE5.luaobj | OLS-820d2652-7bb5-53f2-a674-1af54390c16f |
| SyndraE5.preload | OLS-503e0afd-8531-5a0b-abeb-10ed7be5626e |
| SyndraE5Missile.inibin | OLS-76b465e9-dc95-5661-956a-fb6286935931 |
| SyndraE5Missile.luaobj | OLS-4b730a3a-61d8-513e-9b4a-a50937386c27 |
| SyndraE5Missile.preload | OLS-f64c469b-08e1-5720-8edd-6168e7e9f4ce |
| SyndraE5Sound.inibin | OLS-88da5444-04d9-53d7-bfef-1bc5958a3976 |
| SyndraE5Sound.luaobj | OLS-4306478c-33b8-59a9-94e8-25b8e935c7af |
| SyndraEBump.luaobj | OLS-d6320b5c-9b3b-57e6-9898-1b726743a3ec |
| SyndraEDebuff.inibin | OLS-9139fbdf-da2e-53a4-8917-e2fa59d4e496 |
| SyndraEDebuff.luaobj | OLS-dcb0aa01-7a11-5cda-af9c-b2f50f3fed6d |
| SyndraEImmunity.luaobj | OLS-d403a923-affd-5f3a-92e3-f5ebbde39422 |
| SyndraEImmunityStun.luaobj | OLS-74d9f27e-145b-5901-a9c7-3ae92b5e8007 |
| SyndraEMarker.luaobj | OLS-43d37a08-b1cb-51a7-865a-cde1ecfe759f |
| SyndraEMissile.inibin | OLS-62d6ed87-100b-5c7c-9e16-1c182d561b2b |
| SyndraEMissile.luaobj | OLS-a7b7c4cd-49ec-511c-aa76-5af44cca28c6 |
| SyndraEMissile.preload | OLS-7d70e2e4-532a-5432-a2a7-5e46854c407a |
| SyndraEMissile2.inibin | OLS-a4e81fb9-d98e-5bc9-847b-ef9a212cf54b |
| SyndraEMissile2.luaobj | OLS-b9fd6edc-86fa-531c-8bb4-6a020aa98fec |
| SyndraEMissile2.preload | OLS-87d0bf78-c72d-5527-81eb-9160f8562997 |
| SyndraEMissile3.inibin | OLS-00050b66-aa48-5f92-bebf-39f99a316075 |
| SyndraEMissile3.luaobj | OLS-9576e606-ea7b-58be-86d0-bed3f6584f18 |
| SyndraEMissile3.preload | OLS-44f2fe07-915a-5abb-aaf8-ce1abd25d31f |
| SyndraESound.inibin | OLS-ffa1ab20-c0e3-5c2e-8149-462584f88653 |
| SyndraESound.luaobj | OLS-1768b5c0-7a1d-5157-adf1-2d3a3fc60f1e |
| SyndraPassive.inibin | OLS-9ce257f0-ebaf-59b9-9107-421a10b88f33 |
| SyndraPassive.luaobj | OLS-869b645d-38bc-5cd2-9bf4-15fe8eb1c8ca |
| SyndraPassive.preload | OLS-8771e3c2-5fca-5f62-a62d-0aac22262172 |
| SyndraQ.inibin | OLS-81059831-66e1-5a59-864d-1ecae3fd49f2 |
| SyndraQ.luaobj | OLS-cd343bbe-b252-528a-97cf-4ae29f076e84 |
| SyndraQ.preload | OLS-75d651df-71d9-5776-b289-4b8e14d58caa |
| SyndraQRemoval.luaobj | OLS-2a4ae0dc-58b5-5a0f-842f-d820a589a930 |
| SyndraQRemoval.preload | OLS-8cd0971f-9c4e-548b-a85e-e688b610f932 |
| SyndraQRemoval2.luaobj | OLS-9bc3af9d-5d26-5fcf-803d-f6a595d46c25 |
| SyndraQSpell.inibin | OLS-5f9bce2d-ef11-587a-8a9c-10d5f6c165e9 |
| SyndraQSpell.luaobj | OLS-f1e89c31-7386-509a-a866-533989b3cc15 |
| SyndraQSpell.preload | OLS-97f7e101-2fc5-5c95-90f8-f13029207f4d |
| SyndraR.inibin | OLS-8a1c8ce6-f1d2-5e91-832b-70d2ac03392e |
| SyndraR.luaobj | OLS-ed0d1c20-f3f5-5f2d-a436-f488bc102a94 |
| SyndraR.preload | OLS-53cf6e44-9e51-5036-b764-182df272c9af |
| SyndraRBounce.inibin | OLS-78a774ca-7d58-5a43-b5e5-ab7154584c38 |
| SyndraRBounce.luaobj | OLS-6875aa3a-9faa-56e6-ae17-2f1fbf59d1ff |
| SyndraRBounce.preload | OLS-3c43c613-a105-5ebe-88b5-3ec81186194f |
| SyndraRBounce5.inibin | OLS-f43063ca-ce75-5532-aa90-45abbb9f4a6f |
| SyndraRBounce5.luaobj | OLS-0e51fb69-eb65-5412-978f-55a2c8053c50 |
| SyndraRBounce5.preload | OLS-5679acb5-b45f-59e6-86de-ebe753067ecf |
| SyndraRCastTime.inibin | OLS-eee200cc-b533-5452-9b27-b9d0fba0e2fe |
| SyndraRCastTime.luaobj | OLS-eda40efc-0e91-58c0-b366-c949dc766f98 |
| SyndraRecall.luaobj | OLS-02dd4deb-bebf-5a5f-aebe-cad66dd6a071 |
| SyndraRecall.preload | OLS-7c68e741-064d-507b-8fc7-536a0dbaa715 |
| SyndraRecallOverride.luaobj | OLS-944e9e53-fbfa-58c3-8c08-c5a14ea03585 |
| SyndraRSpell.inibin | OLS-6a7da311-e269-5a06-820a-36a66d8f2a7d |
| SyndraRSpell.luaobj | OLS-d94a2fd7-2f1f-5b4f-864a-f9cdc43bf45a |
| SyndraRSpell.preload | OLS-0d15d0f6-235a-51a5-89f3-e421c470e571 |
| SyndraRSpread1.inibin | OLS-ed912e37-39e1-5cc0-aa11-39faf4c75e9e |
| SyndraRSpread1.luaobj | OLS-06bf9ffa-b419-5d3a-8dff-4d3fc294f01a |
| SyndraRSpread1.preload | OLS-d03293a5-a2c4-5a66-ac95-8b843c33b0a3 |
| SyndraRSpread15.inibin | OLS-6413bf89-81d9-5ed2-b980-9eca3a5bb93f |
| SyndraRSpread15.luaobj | OLS-4fe048f1-bc82-564f-bf04-f920787c3d30 |
| SyndraRSpread15.preload | OLS-01a929f6-947d-5cc1-9ed3-a8568e393fd4 |
| SyndraRSpread2.inibin | OLS-138a6cd9-17db-5808-bb2c-e986c083b512 |
| SyndraRSpread2.luaobj | OLS-3ad83480-3ee1-57c8-a0ca-79a883a3fcda |
| SyndraRSpread2.preload | OLS-4bd9a834-5b2d-5e9e-81e3-ef18157a384b |
| SyndraRSpread25.inibin | OLS-e302cfc8-c9ab-5d04-a0d4-af3393e5a41d |
| SyndraRSpread25.luaobj | OLS-8ed601db-97e6-59ae-8a77-fe20f3f62918 |
| SyndraRSpread25.preload | OLS-73251a2c-2110-505f-b862-cda1064d55f9 |
| SyndraRSpread3.inibin | OLS-8aa77fcb-dc9d-50ba-b4da-0cf9ec0f39c0 |
| SyndraRSpread3.luaobj | OLS-a9a38f90-18ab-5863-9b2f-46aa6ba80f4d |
| SyndraRSpread3.preload | OLS-9e707d62-99d8-53c0-bf10-5735a3c522a9 |
| SyndraRSpread35.inibin | OLS-17032d6f-fb11-52df-9923-619a9b425a29 |
| SyndraRSpread35.luaobj | OLS-7c5d65d8-40ff-53ba-b235-feb3b788a63d |
| SyndraRSpread35.preload | OLS-243eb786-71f8-58b7-8a68-2bccd24344d0 |
| SyndraRTimer.luaobj | OLS-ff6ad915-7859-52b4-8706-a0d703822225 |
| SyndraRTimer.preload | OLS-a46a4cf4-99f9-5e2e-bb28-07b8ceae2005 |
| SyndraRTrigger.inibin | OLS-7c29c08d-6ece-5554-9849-759d003feab7 |
| SyndraRTrigger.luaobj | OLS-8b293e44-db8f-512f-94a8-18192214ae05 |
| SyndraRTrigger.preload | OLS-ca069630-24cd-5429-b990-d9974477e163 |
| SyndraRVisual.luaobj | OLS-88a8b0d6-c972-5d20-9f38-4e2050d7ab47 |
| SyndraRVisual.preload | OLS-b12e4c47-931a-5529-9e5e-aa51c06d3dd7 |
| SyndraRWillFire.luaobj | OLS-e959ec78-daca-55ae-8066-987b6aa68c2a |
| SyndraW.inibin | OLS-c7363f52-4a7c-5701-aa0a-85c5c1cb4744 |
| SyndraW.luaobj | OLS-59a543df-6d72-52c6-9f1d-668897afb7b4 |
| SyndraW.preload | OLS-ff9176c9-d148-518c-916e-3d15420c9893 |
| SyndraWBuff.luaobj | OLS-3cbcb590-515b-5a2d-9f5e-ba599af901d6 |
| SyndraWBuffer.luaobj | OLS-077e1121-0f10-55ae-a9aa-2863c22ce036 |
| SyndraWBuffer.preload | OLS-728b0f15-ea9f-5f6c-b9f4-31bb955091d4 |
| SyndraWCast.inibin | OLS-2e5f2294-58f3-5220-b845-0ab68e6cfdb1 |
| SyndraWCast.luaobj | OLS-f6981b66-afc5-5818-bb68-c843e62b308d |
| SyndraWCast.preload | OLS-a72719c9-ae0f-50aa-b01d-57484ee8cca0 |
| SyndraWCDTimer.inibin | OLS-7af5b4a0-9146-54f0-aa64-25ade2945059 |
| SyndraWCDTimer.luaobj | OLS-7f2459a7-5da1-5e58-80f1-70ef1dc2ed31 |
| SyndraWDebuff.inibin | OLS-da3ee5a1-0f76-5955-bbd6-251d8dca3cbc |
| SyndraWDebuff.luaobj | OLS-fcad10ca-1f48-559b-b00d-5f0505f39e77 |
| SyndraWDebuff.preload | OLS-3b00c3d6-6a08-5859-8baa-3d47b337e5a4 |
| SyndraWFailsafe.luaobj | OLS-7d61c518-2de9-5a2f-b32b-a7241d1b059e |
| SyndraWMana.luaobj | OLS-3d4ca35c-fc25-51cc-a6ee-530ae9fedde0 |
| SyndraWMana.preload | OLS-d80219df-fd84-5f2c-b515-d62ee38c79f5 |
| SyndraWNeutralFix.luaobj | OLS-b8913efe-f129-5f00-ac9c-7128a29310c1 |
| SyndraWSlow.luaobj | OLS-1aaed1ae-abec-5f96-9f54-12a855c55f20 |
| SyndraWSpellSlotSafeguard.luaobj | OLS-2323ceaa-e1b5-56be-963b-b8918e1d3098 |
| SyndraWSpellSlotSafeguard.preload | OLS-cb22385a-e4fd-5d0f-92b5-a30cb8493240 |
| SyndraWTooltip.luaobj | OLS-8d490272-6478-588f-aa81-3c4a159db431 |

## Contrat natif

Le tooltip `game_buff_tooltip_SyndraPassive` (ligne 2740) et la description du personnage (ligne 4285) concordent : les sorts gagnent des effets au rang maximal.

| Sort | Effet supplémentaire natif |
|---|---|
| Q — Dark Sphere | 15% de dégâts supplémentaires contre les champions |
| W — Force of Will | Durée du ralentissement augmentée de 33% |
| E — Scatter the Weak | Largeur du sort augmentée de 50% |
| R — Unleashed Power | Portée augmentée de 75 |

Ces valeurs sont établies par les textes natifs. Les producteurs, transitions de rang, géométrie précise, ordre des opérations et arrondis restent à qualifier. Le DDF associe W;f2 à `@text`, coefficient `1.5` : ce texte ne prouve pas le calcul de durée au rang maximal. Ne pas transformer implicitement 33% en un autre ratio ou une durée arrondie sans producteur vérifié.

Syndra.inibin sélectionne SyndraQ/W/E/R et SyndraPassive. Passive1 et les quatre premiers Passive1Level sont des chaînes `0`, les deux derniers marqueurs absents ; Passive1Desc est vide et PassLev1Desc2 contient `5 Astral Spirts`. Ces valeurs anciennes restent conservées sans devenir des seuils de rang. Les chaînes natives mana `334.0`, croissance `50`, vitesse `330` et portée d’attaque `550` restent distinctes de leurs conversions locales.

Les 51 Lua sont entièrement lus, sans fonctions enfants. Seize initialisations rencontrent NEWTABLE. CharScript est vide ; SyndraPassive déclare nom, icône et PersistsThroughDeath, sans callback de rang exécuté. Les preloads citent les dialogues Q5/W5/E5/R3 et le sort SyndraE5. Les identités distinctes E/E5 sont conservées ; leur présence ne démontre pas une sélection effective ou un cône élargi. Deux BuffData ont une traduction exacte. Le DDF comporte 16 lignes, dont seul W;f2 a un lien non vide.

Métadonnées étrangères : RCastTime porte Time Bomb ; RTimer et RVisual, BurningAgony ; RWillFire et WMana, SkarnerImpaleBuff. Elles ne deviennent pas des politiques de Zilean, Mundo ou Skarner pour Syndra. La recherche textuelle « Transcendent » ramène aussi IreliaTranscendentBlades : cet élément est explicitement hors contrat Syndra.

## Références communautaires

37 fichiers inspectés sans exécuter le C#. CharScript vide. Les QWER communautaires ne sont pas promus en règles natives ou en consommateurs Rust.

- Q : dégâts immédiats 70–230 plus coefficient AP dans un rayon de 200 ; sphère uniquement représentée par une particule selon le code et son commentaire. Aucun objet manipulable, durée de vie de sphère ou bonus champion au rang 5 démontré.
- W : dégâts 80–240 plus coefficient AP après 0,5 seconde, rayon 250 et Slow de 1,5 seconde. Le commentaire de rayon 150 est distinct du code. La saisie de sphère/sbire, le second lancer et la durée améliorée au rang 5 ne sont pas démontrés.
- E : dégâts 70–250 +0,4 AP, portée 700, produit scalaire minimal 0,8 ; stun 1,25 seconde pour chaque cible touchée. Le commentaire 1,5 seconde ne remplace pas cette valeur. Le texte natif demande une poussée et des sphères projetées qui étourdissent sur leur trajet ; ces producteurs ne sont pas démontrés dans le fichier choisi. Pas de largeur distincte au rang 5 démontrée.
- R : 6 + rang sphères, soit 7/8/9, dégâts par sphère 90/135/180 +0,2 AP, timers espacés de 0,15 seconde. La cible acceptée est un ObjAIBase ennemi. Le natif décrit une cible champion et trois sphères orbitales plus les sphères précédemment créées. Le comptage effectif, les trajectoires et la portée améliorée ne sont pas démontrés.

## Consommateurs actuels

La recherche pinée de Syndra/Transcendent dans `crates/core/src/**/*.rs` ne trouve aucun producteur nommé. `next_rank` n’admet que les champions explicitement pris en charge et refuse Syndra avant les vérifications ordinaires de points/rangs. `learn` et la commande publique partagent cette prédiction. `cast` et `cast_at` refusent les sorts de Syndra comme non implémentés.

| Point de code | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/lib.rs:598 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:68 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:150 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:159 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/spells.rs:101 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/annie_w.rs:29 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/lib.rs:744 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:131 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:50 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |
| crates/core/src/progression.rs:46 | current rank/XP or spell-refusal path;Syndra admission absent;Annie local positive control |

Ressources locales liées : champions.json, champion_growth_420.json, champion_resources.json et experience_curve_map10.json. Les définitions de Syndra, Annie et Garen sont sélectionnées ; Garen sert uniquement de cible des commandes refusées. La courbe XP est une entrée du diagnostic, pas une preuve de progression naturelle.

## Diagnostic réellement exécuté

Vrai crate core de F:/OpenLeague, profil non-test et dépendances alignées sur Cargo.lock. 1158 entrées et les preuves précédentes contrôlées avant/après. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-syndra-passive-transcendent-probe.exe`, 5478912 octets, SHA-256 `6d6c7d24b82e4139c4502c352a3169fbd2e24f7e5ce68eca9e7b59dcb6ad2067`. Reçu complet : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision635_Syndra_passive_probe/OBSERVATIONS.json`.

**L’expérience est fournie par l’API serveur `award_experience`.** Il n’existe pas de commande réseau XP dans le contrat local inspecté. Ce diagnostic contrôlé ne constitue ni une partie naturelle, ni un test de transport réseau. Aucun rang ou champ de champion n’est modifié directement. Aucun tick de simulation n’avance, aucun combat, déplacement ou achat n’est exécuté.

Deux simulations : Syndra et Annie. Pour chaque niveau 1 à 18, la prédiction next_rank est comparée à Action::Learn sur chacun des quatre slots. Syndra reçoit aussi Cast et CastAt pour chaque slot. Les deltas XP viennent de la courbe Map10 ; 17 attributions atteignent les niveaux 2 à 18, puis une attribution de 1000 au plafond vérifie que le niveau reste 18. Total : 36 attributions diagnostiques.

| Champion | Niveaux | Learn acceptés | Learn refusés | Cast/CastAt refusés | Autres refus de commandes | Refus XP | Rangs finaux |
|---|---:|---:|---:|---:|---:|---:|---|
| syndra | 18 | 0 | 72 | 144 | 4 | 5 | [0, 0, 0, 0] |
| annie | 18 | 18 | 54 | 0 | 4 | 5 | [5, 5, 5, 3] |

Attendu du chemin actuel inspecté : refus Syndra et progression possible pour Annie. Observé : 72 Learn Syndra refusés avec `champion skill progression not implemented`, 144 Cast/CastAt refusés avec les erreurs d’implémentation correspondantes ; rangs 0/0/0/0. Annie accepte 18 Learn et finit 5/5/5/3 ; sa séquence locale atteint Q5 au niveau 9. Ce témoin ne qualifie pas les règles historiques d’apprentissage de Syndra.

Total : 278 refus de commandes, dont huit contrôles de slots invalides/joueur inconnu, et dix refus XP (zéro, négatif, NaN, infini, joueur inconnu dans les deux simulations). Les refus conservent les instantanés. Les 144 prédictions de rang concordent avec les commandes. La fin de niveau 18 et le plafond sont vérifiés. Les effets maximaux de Syndra, leurs dégâts, durées, géométries et interactions restent **non exercés**.

## Contrôles de livraison

Découverte, BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH, AUDIT : codes 0. Gardes de publication : 72 associations altérées et quatre graphes invalides refusés. Trois aperçus courts et quatre fiches complètes actualisés ; vrais lecteurs Store, copie des consignes, dépendances et rt.resolve utilisés.

Deux bases relues et synchronisation normale idempotente. Les 42 603 autres lignes catalogue, 42 607 états manuels et 23 historiques restent inchangés. Identités, hiérarchie et inconnues identiques octet par octet. Revue globale : 99 217 sources et 4908 points de consommation, ancres exactes sans divergence. Cette revue est structurelle ; elle n’effectue pas un re-hachage global (`source_hashes_verified=0`). Les contrôles de contenu concernent la sélection et les entrées pinées. Les 26 189 questions ouvertes et 5517 résolues avec historique sont conservées.

## Fichiers et travail restant

Registres enrichis : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/syndra-passive-transcendent-links-v635.json. Preuve : docs/fidelity_syndra_passive_transcendent_links_v635.json. Reprise : coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md/HANDOFF.md. Bases : runtime/project-plan/plan.sqlite3 et AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Sauvegardes et scripts exacts sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision635_Syndra`.

À réaliser : apprentissage et sorts Syndra effectifs ; sphères de gameplay, saisie/lancer, durée de vie, collisions, poussée/étourdissement et comptage du R ; transitions Q/W/E 4→5 et R 2→3 ; quatre améliorations du passif, types de cibles, calculs, arrondis et frontières géométriques. Puis casts en mouvement, simultanéité, mort/reconnexion, progression naturelle et réseau. HUD, effets, sons et animations nécessitent des preuves séparées. V564/V606 restent ouverts. Aucun statut complet, aucune acceptation du champion ou du jeu.

Continuer SYS-01.2-02 depuis revision636_trace_review/REVIEW.json. V635 Syndra / Transcendent : 116 fichiers natifs, 348 associations, 11 points de code et 22 liens. Le texte natif donne les effets au rang maximal : Q +15% de dégâts aux champions, W +33% de durée de ralentissement, E +50% de largeur, R +75 de portée. Cinquante et un Lua sans fonctions enfants, dont seize limites NEWTABLE ; trente et un preloads ; deux BuffData traduits ; DDF de seize lignes dont W;f2=@text1.5. Les métadonnées anciennes et étrangères restent distinctes. Trente-sept références communautaires partielles : sphère Q visuelle, W sans saisie réelle, E avec stun inconditionnel, R à7/8/9 sphères fixes. Diagnostic avec expérience fournie par API serveur, pas progression naturelle : niveaux1à18, 72 apprentissages et144 casts Syndra refusés ; rangs0/0/0/0. Témoin Annie :18 apprentissages acceptés et rangs5/5/5/3. Total278 refus de commandes et10 refus XP, instantanés conservés. Aucun tick de simulation ni effet Syndra au rang maximal exercé. BUILD/RUN et inspection0. États, cases, inconnues et preuves conservés ; gameplay inchangé. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Talon. Goal actif.
