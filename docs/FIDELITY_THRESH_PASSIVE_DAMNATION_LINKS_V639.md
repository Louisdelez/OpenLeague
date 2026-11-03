# Thresh — Damnation : sources et limites vérifiées, V639

Date UTC : 2026-10-26T21:05:20.819843+00:00. Projet `F:/OpenLeague`. Tâche SYS-01.2-02 : relier les exigences aux sources et consommateurs actuels. Trois fiches Thresh PASSIF-SOURCE, PASSIF-SIMULATION-CONTRAT et PASSIF-SIMULATION enrichies, ainsi que le suivi général. Aucun code de gameplay ou asset modifié.

## Résultat

Le diagnostic du moteur courant conserve **16 d’armure aux niveaux 1 à 18** pour Thresh, conformément à Armor=16 et ArmorPerLevel=0 du fichier natif. La puissance reste à zéro. Ce contrôle sans âme vérifie la croissance nulle ; il ne vérifie ni la création des âmes ni leur collecte ni leurs bonus. Les sorts de Thresh restent refusés dans les chemins contrôlés. Le témoin Annie progresse et apprend normalement dans ce diagnostic.

164 fichiers natifs liés, 492 associations aux trois fiches, 14 points de code et 28 liens aux fiches de simulation. Ces points sont des entrées ou mécanismes génériques, avec `provides_feature_consumer=false`. Trois questions propres et quatre dépendances conservées ; aucune question fermée et aucune case cochée.

## Référence et sources

PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue officiel 4.20.1 distinct. Deploy : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

Sélection : 49 INIBIN, 67 Lua, 46 preloads, un DDF et fontconfig_en_GB.txt. CharScript sous Characters/Thresh/Scripts, sorts globaux et propres au personnage conservés. Pas de fichiers NightmareBot sélectionnés. Identité des octets et appartenance RADS détaillées dans le reçu ; appartenance n’équivaut pas à qualification du chargement historique.

| Fichier | Identité du registre |
|---|---|
| Thresh.inibin | OLS-65ef74a5-3946-5508-b6bc-182b58313b06 |
| Thresh.ddf | OLS-55febecf-bd4f-5584-a2df-3aa18d3100b7 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptThresh.luaobj | OLS-8f62bd56-c6c0-585c-ae2a-2f1d6fd2ab4e |
| CharScriptThresh.preload | OLS-8933b6bb-98c4-50d0-a07f-8d6a06fe221e |
| ThreshBasicAttack.inibin | OLS-48d1ca99-5d51-5010-89b4-a7f90b13cd58 |
| ThreshBasicAttack.luaobj | OLS-4e2c621b-6e4c-526c-ab3d-100669d5b144 |
| ThreshBasicAttack.preload | OLS-99a771c8-e8b9-5de8-a00a-fafa8e2f3a43 |
| ThreshBasicAttack1L.inibin | OLS-9b959c9e-5a9a-5335-b918-8ec46ae1fa5f |
| ThreshBasicAttack1L.luaobj | OLS-f46a109d-ba3d-587f-a1ce-206a618dfafc |
| ThreshBasicAttack1L.preload | OLS-325a7144-8fba-53c1-8ec7-969a04f8587e |
| ThreshBasicAttack1M.inibin | OLS-d4a1dbfe-8d97-5044-9334-efb597533b2b |
| ThreshBasicAttack1M.luaobj | OLS-b03b5a69-1ae4-58e1-a959-3acd3be56cd9 |
| ThreshBasicAttack1M.preload | OLS-051b8b77-405d-53ef-8d46-55876294da25 |
| ThreshBasicAttack1S.inibin | OLS-f4054ce0-936b-5af7-b437-68c04b251a8a |
| ThreshBasicAttack1S.luaobj | OLS-0129a8b0-e3dd-57f7-9bcf-f4dd71b916c8 |
| ThreshBasicAttack1S.preload | OLS-653922a2-5201-59bb-b8f8-bcb5fc94a203 |
| ThreshBasicAttack1SFast.inibin | OLS-cdef8afb-8c7f-58b4-9e29-ec1693261033 |
| ThreshBasicAttack1SFast.luaobj | OLS-1d955f3a-fd39-5815-846a-a638c1559dee |
| ThreshBasicAttack2.inibin | OLS-f139d9ad-1303-5cc5-8826-45075568122c |
| ThreshBasicAttack2.luaobj | OLS-5b9f4a2b-73d7-51a1-858f-8d102c415509 |
| ThreshBasicAttack2.preload | OLS-8d97b559-e271-5ef2-89f5-e065fdb6d646 |
| ThreshBasicAttack2L.inibin | OLS-7efbb0b0-94ae-5a5f-b98d-898f05852ace |
| ThreshBasicAttack2L.luaobj | OLS-3389516b-f131-5476-b8ea-4abee9683884 |
| ThreshBasicAttack2L.preload | OLS-174607d6-c51c-5228-8e27-9f46b5402476 |
| ThreshBasicAttack2M.inibin | OLS-6b3dffdd-bfd4-5be0-9288-c2af5ed4c98e |
| ThreshBasicAttack2M.luaobj | OLS-0c17b44d-37ea-51d6-a6fb-8492a72060a6 |
| ThreshBasicAttack2M.preload | OLS-1d88b9c9-2104-538b-8027-bea779c3e6fb |
| ThreshBasicAttack2S.inibin | OLS-92fed2f7-d75a-56a6-9b54-10ca09de5d9e |
| ThreshBasicAttack2S.luaobj | OLS-bcbdc7f9-d872-567e-a04f-69a066d3fe04 |
| ThreshBasicAttack2S.preload | OLS-447fa743-812d-5a98-957d-dfd394a39817 |
| ThreshCommandParticle.luaobj | OLS-3666dbde-47d0-55b6-81bd-201c4be05ecf |
| ThreshCommandParticle.preload | OLS-a5bcd216-d9c8-53f6-b9ba-9f72cc6f69a3 |
| ThreshCritAttack.inibin | OLS-a734ca5b-c323-5651-bb3d-061902dd5d18 |
| ThreshCritAttack.luaobj | OLS-c02b2145-00de-5ece-8419-5fc1d7b5f193 |
| ThreshE.inibin | OLS-363828e2-35fb-5631-b488-e270e9ac72c8 |
| ThreshE.luaobj | OLS-7760be2c-b5e1-5177-81af-828e9120b4a6 |
| ThreshECastbuff.luaobj | OLS-a72ff86d-7d81-56ba-85fd-a9dda8d0fbc8 |
| ThreshECastbuff.preload | OLS-a3128c09-69ae-5d09-8531-9630751a1756 |
| ThreshEMissile1.inibin | OLS-7793610b-fadc-5e45-9559-a49e4d8ae555 |
| ThreshEMissile1.luaobj | OLS-876c6af2-306a-59bd-b452-8bb887e07010 |
| ThreshEMissile1.preload | OLS-f9c1ecde-4f7b-56bb-928e-a9986e14e457 |
| ThreshEStun.inibin | OLS-e85d25f4-2f6e-5d26-9046-487c77d85b5f |
| ThreshEStun.luaobj | OLS-03d47b03-8250-5cdb-a227-67bf2b3d419b |
| ThreshEStun.preload | OLS-f8d9f579-7e72-5d96-a369-e8fd88c7045e |
| ThreshHackedBuff.luaobj | OLS-83c4b6d1-9ba6-5a0d-9149-827eefa516bb |
| ThreshLanternVisualBuff.luaobj | OLS-916820fd-abd4-57ba-bac1-f811c20fef42 |
| ThreshLanternVisualBuff.preload | OLS-910b9c74-9bbc-59b3-b50e-5d0b0dc9bd51 |
| ThreshPassiveSouls.inibin | OLS-18f7328b-2d25-5aa9-959a-51604251a9ca |
| ThreshPassiveSouls.luaobj | OLS-260c18e9-3719-578d-9267-df9798aeb1ba |
| ThreshPassiveSouls.preload | OLS-8a1c4c6f-7b6d-5594-b90d-eaec06c13ec3 |
| ThreshPassiveSoulsDead.luaobj | OLS-2a804d13-3b1d-5af0-9ae9-4dac7660d373 |
| ThreshPassiveSoulsDead.preload | OLS-220cc5e5-1f52-5754-bd19-cfc68ebee2e8 |
| ThreshPassiveSoulsGain.inibin | OLS-4a7bbd58-92a9-5fa4-a929-25edee40ccff |
| ThreshPassiveSoulsGain.luaobj | OLS-268933c0-20ce-5d12-a002-5b271a80ce7c |
| ThreshPassivesoulsGainOver.inibin | OLS-599efdcb-546b-52be-8bff-94e054ffc048 |
| ThreshPassivesoulsGainOver.luaobj | OLS-e4762211-8cd3-5267-8e85-5d5c1b168589 |
| ThreshPassiveSoulsMarker.luaobj | OLS-ddfacc90-5b38-57eb-a888-b91c9fba2957 |
| ThreshPassiveSoulsRoot.luaobj | OLS-7e6edc91-3907-51cc-8986-5b0207299ec1 |
| ThreshPassiveSoulsTar.luaobj | OLS-4b8445d9-dc59-5aa8-bb67-eec8cfa380bf |
| ThreshPassiveSoulsTar.preload | OLS-3e31fd0f-ebe6-574f-badb-68efe82ddf06 |
| ThreshPassiveSoulsVlad.inibin | OLS-600d8f4b-30e6-5f56-83e9-f4f2b3f0ecc4 |
| ThreshPassiveSoulsVlad.luaobj | OLS-19d52d67-d110-535e-a2f0-74b7f16f3017 |
| ThreshPassiveSoulsVlad.preload | OLS-7f76a3ce-6c1c-50e9-8e71-702761334a67 |
| ThreshQ.inibin | OLS-1cadecff-78db-53d6-add9-6625606b1d2d |
| ThreshQ.luaobj | OLS-f0b894dc-68a6-5036-9ccd-224cbf29750b |
| ThreshQ.preload | OLS-26957b9f-9ce2-53a5-ba45-c03274bea91f |
| ThreshQFakeKnockup.luaobj | OLS-5672de07-8e18-5260-9aa1-e913bbc89847 |
| ThreshQInternal.inibin | OLS-3ffb565e-1dc9-5368-ae69-d930fea6ceaf |
| ThreshQInternal.luaobj | OLS-55ea072e-dcef-54cd-8b77-2ffb1450e860 |
| ThreshQLeadOut.luaobj | OLS-41012228-7cb8-50c3-9aa7-06298e3cd420 |
| ThreshQLeap.inibin | OLS-46b9e2f4-5bb7-5ed4-b9d8-f869051fb750 |
| ThreshQLeap.luaobj | OLS-9f7db26c-d219-517f-b58c-d539002b7557 |
| ThreshQLeap.preload | OLS-0a94981e-72aa-5a50-8ebe-3794aec7a701 |
| ThreshQLeapAttack.inibin | OLS-30875ff5-ba2f-5503-bfe7-1a8dc17b110e |
| ThreshQLeapAttack.luaobj | OLS-a4f765dd-54ac-5ef3-9e2a-9889636cf8ea |
| ThreshQMissile.inibin | OLS-d13a69ad-ba7a-593c-8398-052b61148d45 |
| ThreshQMissile.luaobj | OLS-7ce2db58-fc59-5335-a77a-129116db4ac1 |
| ThreshQMissile.preload | OLS-977bdda5-2066-570c-b858-95c85e474ca9 |
| ThreshQMissile2.inibin | OLS-949687be-038d-55f6-b5a6-a9c3bd2e128b |
| ThreshQMissile2.luaobj | OLS-5d3477d1-da4f-5139-9128-4fe705d94911 |
| ThreshQMissile2.preload | OLS-43b91649-401b-51fd-aa1d-5c74dda4cefc |
| ThreshQPassive.inibin | OLS-a1007bc7-c0d4-56c6-b924-d182a3c8bd09 |
| ThreshQPassive.luaobj | OLS-4b7cf8e5-edac-5808-9f8b-0c04583c8046 |
| ThreshQPassive.preload | OLS-55b766ca-ac45-5da0-838c-f69cebb02d3b |
| ThreshQPassive1.inibin | OLS-4feb0dbf-c23a-5abd-8023-8759f92f200d |
| ThreshQPassive1.luaobj | OLS-bdce74d4-27d7-5d5a-987a-13bdb09cdcd0 |
| ThreshQPassive1.preload | OLS-b9ae5a7d-295b-50cd-ac76-3097c58b354f |
| ThreshQPassive2.inibin | OLS-a3341fa2-d0bf-5ab2-8217-945d38e74076 |
| ThreshQPassive2.luaobj | OLS-f1a722ee-8518-5906-a3c9-e89925c9db54 |
| ThreshQPassive3.inibin | OLS-8683dac7-ef6e-5193-8ed3-7d74574ce54e |
| ThreshQPassive3.luaobj | OLS-9c35dd98-5adb-571b-9993-59577e9128bb |
| ThreshQPassive3.preload | OLS-c49f26a2-78c0-5575-83c6-27b109fe4248 |
| ThreshQPassive4.inibin | OLS-b1a43eee-efa1-56bc-a596-c84209bd4fdf |
| ThreshQPassive4.luaobj | OLS-3b7b18b6-d62d-5ecd-8522-cfac9b1b81bd |
| ThreshQPassive4.preload | OLS-d408a497-a5d6-5212-9156-61cd34939fa4 |
| ThreshQPassiveIcon.inibin | OLS-94676ff5-bebe-5ea3-8598-495bfe090f17 |
| ThreshQPassiveIcon.luaobj | OLS-4297e5fa-c2a9-57a6-bb36-5f493a6cea25 |
| ThreshQPullMissile.inibin | OLS-dbcc3179-7bb5-5e8d-9ebe-73cb6f1a6f2a |
| ThreshQPullMissile.luaobj | OLS-5883e349-c257-59d6-8456-89faf0e45edc |
| ThreshQPullMissile.preload | OLS-45b1576c-3427-5aa6-9d05-92326bf9f56c |
| ThreshQSelfRoot.inibin | OLS-69202860-0dcf-5ef4-a17f-9b75ace9c37d |
| ThreshQSelfRoot.luaobj | OLS-96dbd0df-fecc-56f3-9f64-ff5b6bce496f |
| ThreshRBroken.luaobj | OLS-b60bafd2-2855-5216-b8de-15e27a63e956 |
| ThreshRBroken.preload | OLS-986479a8-2b83-5e80-bd51-3b6abb5d56b3 |
| ThreshRCenterMin.inibin | OLS-8f7159ad-b250-55e3-93da-094a65edc38d |
| ThreshRCenterMin.luaobj | OLS-f61e49bf-bb36-5142-8e88-5350ee3a27db |
| ThreshRCenterMin.preload | OLS-3ede3f7e-2304-5132-b926-8b050a43e380 |
| ThreshRDamage.luaobj | OLS-b4d06608-d597-5699-89ae-56cf4294bc81 |
| ThreshResurrection.luaobj | OLS-a24434ac-c134-56fc-81cc-3deef42a5387 |
| ThreshRPenta.inibin | OLS-42ebef0a-90c8-59d3-8cbd-8363fb171b2e |
| ThreshRPenta.luaobj | OLS-dac2348b-8b5a-5c7e-86d5-f3a4411ce828 |
| ThreshRPenta.preload | OLS-264d891d-6730-56a1-be5f-7fbbd3617b5d |
| ThreshRPentaSound.luaobj | OLS-bace89e5-4ed9-5363-b994-3b9584f38137 |
| ThreshRSlow.luaobj | OLS-6ce9da74-7dbd-5e9c-acf0-f3253ab7445c |
| ThreshRSlow.preload | OLS-db66754e-0287-557c-8c37-0ee716746136 |
| ThreshRTrigger.luaobj | OLS-8368089d-c0bb-5d4e-81d1-906209fe0e55 |
| ThreshRTrigger1.inibin | OLS-33fc7185-0d69-5dd2-9165-6c601451d24f |
| ThreshRTrigger1.luaobj | OLS-36c8f7b1-04f9-5e05-95db-f05362ccfb60 |
| ThreshRTrigger1.preload | OLS-5e494c44-98ed-5361-8ec2-14d16a87dc9a |
| ThreshRTrigger2.inibin | OLS-33e39baf-8f6a-5b97-b5f8-9c9775efb30f |
| ThreshRTrigger2.luaobj | OLS-5e015c3a-f299-56bd-928d-d14bb8c84bd7 |
| ThreshRTrigger2.preload | OLS-d4cfc1be-b72c-598b-b0d5-a58a06f80629 |
| ThreshRTrigger3.inibin | OLS-d052e2e0-a4ce-50a5-b7e8-e3a64af00b75 |
| ThreshRTrigger3.luaobj | OLS-0fb30c3e-3056-55bf-b4fb-212508994bbb |
| ThreshRTrigger3.preload | OLS-dd10177e-91fc-58c1-aa8b-1486b056a05f |
| ThreshRTrigger4.inibin | OLS-6e5d073a-416c-58b5-84f7-b404a49dd42a |
| ThreshRTrigger4.luaobj | OLS-e13d5921-ddf4-5a69-beb7-c941315e3070 |
| ThreshRTrigger4.preload | OLS-8194f4df-59fe-5499-aee0-b629dd630b5c |
| ThreshRTrigger5.inibin | OLS-642cef2d-ab56-56e3-a95c-a3c2a2e7dde0 |
| ThreshRTrigger5.luaobj | OLS-ccc8a6c8-9581-5f43-a737-3ba4e7429f5c |
| ThreshRTrigger5.preload | OLS-57532e63-d8cb-5ade-8dc0-8598863c88aa |
| ThreshSelfSlow.luaobj | OLS-bf687e84-bf11-5722-84a9-4cbd1831f291 |
| ThreshSelfSlow.preload | OLS-6cfd10f9-dc4c-5a1e-8501-c8bec62f5e31 |
| ThreshW.inibin | OLS-2681e5bd-6898-5266-81c3-615cf8a411a7 |
| ThreshW.luaobj | OLS-3daba4d5-4554-5d99-b4d7-52f7c3635c20 |
| ThreshW.preload | OLS-19cb53ba-97c2-5cbe-98de-952d0c305690 |
| ThreshWAllyMissile.inibin | OLS-3bff625c-8126-5146-ae37-8ea452a566fa |
| ThreshWLanternIn.inibin | OLS-6c532826-f15a-51da-bbbc-375e6a5b6711 |
| ThreshWLanternIn.luaobj | OLS-c6f533b8-a4ce-548d-9835-10e8a669b9a4 |
| ThreshWLanternIn.preload | OLS-a3e4a790-7c91-5d59-aff9-d625c32809ba |
| ThreshWLanternOut.inibin | OLS-e8ecbc8b-0a3b-5260-babb-3291a11b706c |
| ThreshWLanternOut.luaobj | OLS-041fa93a-92b5-5b62-a2b4-1bd56bd05ec4 |
| ThreshWLanternOut.preload | OLS-5fe09d6b-367c-5901-9f9b-7f714d2139fa |
| ThreshWLanternOutShield.inibin | OLS-f4b47b55-1369-5e19-9142-79b2fa11b5fb |
| ThreshWLanternOutShield.luaobj | OLS-89e20380-30eb-552c-b07a-d4149afdb54f |
| ThreshWLanternOutShield.preload | OLS-adf353d7-7a51-5d62-bb83-72146ca9d45e |
| ThreshWLanternReturn.inibin | OLS-a9ac887d-eadc-5418-9856-eea5e0081c0d |
| ThreshWLanternReturn.luaobj | OLS-fe34c5c3-05e6-5cb3-ad1b-3505c8aa3a1c |
| ThreshWLanternReturn.preload | OLS-f99d7f3e-90e0-5618-bf32-a92206f11cea |
| ThreshWLanternVisibility.inibin | OLS-2db986d4-3d68-53d5-83cf-9d1ec6cfd965 |
| ThreshWLanternVisibility.luaobj | OLS-5e716644-721e-5c3a-8876-c2ad365002bf |
| ThreshWManager.inibin | OLS-7af84b7e-47f5-5c25-ac15-e7b532ea09f9 |
| ThreshWManager.luaobj | OLS-fb04ae7a-0e75-52df-9d24-25d76ed34097 |
| ThreshWManager.preload | OLS-b2f09c4e-590f-56ed-8c83-b7e6f72c56ea |
| ThreshWMarker.luaobj | OLS-d5142a9e-1db7-59e4-b077-c0339ef9d2d1 |
| ThreshWShield.inibin | OLS-e3e51ee9-394e-5cb0-ba3e-48e015938d7f |
| ThreshWShield.luaobj | OLS-c3a1938c-af2a-52a4-a862-2eb146f3590d |
| ThreshWShield.preload | OLS-d8c145c8-f1fc-5f7c-971e-91dd9c6abd52 |
| ThreshWTetherParticle.luaobj | OLS-bc9cb81b-c4d0-54df-b825-fc05b72ceb90 |
| ThreshWTetherParticle.preload | OLS-4a6346fe-64fd-5f70-b7c9-7675b075f38a |
| ThreshWZoneBuff.inibin | OLS-8d394936-a535-5167-b29c-b3e33464eae6 |
| ThreshWZoneBuff.luaobj | OLS-65c78cf4-777b-52e4-a733-10b5d2ab3049 |
| ThreshWZoneBuff.preload | OLS-25af1f6b-f2f5-5b48-8336-85f6a7539c4f |

## Contrat et divergences

`Thresh.inibin` sélectionne ThreshPassiveSouls. Le tooltip `game_buff_tooltip_ThreshPassiveSouls`, ligne 2770, et la description de personnage, ligne 4289, décrivent des âmes issues des ennemis morts, collectées à proximité, avec des gains permanents d’armure et de puissance. Les champions et grands sbires déposent toujours une âme, les petits sbires parfois. Le tooltip indique explicitement l’absence de croissance d’armure par niveau.

Les textes SoulsGain et SoulsGainOver exposent compte, bonus total, valeur suivante et poursuite des gains après un seuil, sans établir les producteurs ni les valeurs exactes. L’ancien tooltip ThreshPassive, ligne 2769, parle de résistance magique et dégâts de base : il reste distinct du passif sélectionné. Passive1=9, marqueurs 3/7/11/15, ancienne description Jax et mana 40/60/80% sont conservés sans être convertis en règles d’âmes.

Les 67 Lua sont lus intégralement, sans fonctions enfants. Quatorze initialisations rencontrent NEWTABLE et limitent l’interprétation littérale. Les initialisations CharScript, Dead, Marker, Tar et Resurrection sont vides ; Souls/SoulsGain contiennent des métadonnées, pas une exécution de collecte. PersistsThroughDeath ne suffit pas à qualifier la mort/réapparition. Les preloads référencent notamment les marqueurs, expiration et résurrection ; ils ne prouvent pas leurs événements effectifs.

17 BuffData, 16 traductions résolues ; WZoneBuff reste non résolu. Les références MaokaiTrunkSmash et AhriSeduce ne sont pas promues en règles de Thresh. Attention au nom physique `ThreshPassivesoulsGainOver.inibin`. Le DDF contient 72 lignes : son unique lien non vide est KhazixW;f1, bonusattackdamage 0,6. Il ne fournit aucune formule d’âme.

## Communauté : références partielles

54 fichiers inspectés, sans exécution C#. CharScript est vide. Q ajoute directement 1 AP à chaque impact et applique Root pendant 1,75 seconde : ce code ne démontre ni décès, ni âme, ni ramassage, ni gain d’armure. W appelle ThreshLantern pendant quatre secondes pour le propriétaire et l’allié vivant le plus proche à portée 950 ; la recherche ciblée dans le sous-arbre ne retrouve que ces deux appels, pas le producteur. Un producteur extérieur reste inconnu.

E fournit un cône, des dégâts et un Slow d’une seconde, sans déplacement forcé démontré. R utilise une zone de 450 et un Slow de deux secondes ; les cinq murs et leurs franchissements ne sont pas démontrés. Ces écarts restent visibles dans les instructions du plan. Ces références ne remplacent pas les règles natives manquantes.

## Diagnostic du consommateur réel

Le programme privé lie le cœur Rust courant hors tests. Il fournit explicitement l’expérience par API serveur : **ce n’est pas une progression naturelle en partie**. Aucune écriture directe des rangs ou de l’état champion, aucun tick de simulation, aucun décès, aucune âme injectée. Dix-huit appels XP par cas, dont un au plafond, soit 36 au total.

| Champion | Niveaux | Learn acceptés | Learn refusés | Cast refusés | Refus aux limites | XP invalides | Rangs finaux |
|---|---|---|---|---|---|---|---|
| thresh | 18 | 0 | 72 | 144 | 4 | 5 | [0, 0, 0, 0] |
| annie | 18 | 18 | 54 | 0 | 4 | 5 | [5, 5, 5, 3] |

Attendu : Thresh conserve 16 d’armure sans âme ; le témoin Annie gagne de l’armure. Observé : Thresh=16 aux 18 niveaux, AP=0 ; Annie passe de 19,219999 à 87,220001, AP=0. Les 144 prédictions de rang concordent avec les commandes publiques. Total : 278 refus de commandes et 10 refus XP invalides (zéro, négatif, NaN, infini, propriétaire inconnu), sans mutation des snapshots. Annie apprend 18 rangs et atteint 5/5/5/3 ; Thresh reste à 0/0/0/0.

La recherche de code utilise un motif borné pour Thresh et Damnation afin de ne pas compter les occurrences de `threshold`. Aucun producteur spécifique retrouvé dans ce périmètre. Les points dégâts, mort et récompense sont inspectés statiquement mais **ne sont pas exercés par ce diagnostic à zéro tick**.

| Point de code | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/lib.rs:598 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:68 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:150 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:159 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/spells.rs:101 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/annie_w.rs:29 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/lib.rs:744 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:131 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:50 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/progression.rs:46 | current rank/XP or spell-refusal path;Thresh admission absent;Annie local positive control |
| crates/core/src/damage.rs:53 | generic death or damage boundary,static inspection only;not exercised here and not soul producer |
| crates/core/src/champion_kills.rs:32 | generic death or damage boundary,static inspection only;not exercised here and not soul producer |
| crates/core/src/world.rs:355 | generic death or damage boundary,static inspection only;not exercised here and not soul producer |

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-thresh-passive-damnation-probe.exe` ; 5489152 octets ; SHA-256 `2aa6a68fef42a6ad8254a9af20edfbac218bbee75a36c7524e4aad3cf50d4e75`. Compilation `cargo build --locked --offline --message-format=json` et exécution : codes 0. Les 1 158 entrées cœur/ressources, manifestes, identités et sommes de contrôle Cargo ainsi que les preuves antérieures sont conservés.

## Preuves et contrôles de publication

Répertoire privé : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.

- Découverte : `revision639_Thresh_discovery/OBSERVATIONS.json`, SHA-256 `04cb3524503bead8ac6db682e732e3ddea8681d66856f9a51ce54127ef816e22`.
- Runtime : `revision639_Thresh_passive_probe/OBSERVATIONS.json`, SHA-256 `e12ec9107df4ce8020f79ff6c8818946543f3488e39bda991cce00a1e8260f08` ; commandes, logs, source et binaire identifiés dans ce reçu.
- Inspection : `revision639_Thresh_inspection/OBSERVATIONS.json`, SHA-256 `e2b1369af4ce7809ad81de209044fd142b48bd4910b9ceba9ce1f4e4afaa6516`.
- Association : `docs/reference_requirement_trace_sources/thresh-passive-damnation-links-v639.json`.
- Vérification : `docs/fidelity_thresh_passive_damnation_links_v639.json`.
- Relecture : `revision640_trace_review/REVIEW.json`.

PREPARE, CHECK, PUBLISH, AUDIT : codes 0. Soixante-douze mutations invalides d’association et quatre mutations invalides du graphe sont refusées. Les copies de tâches sont vérifiées via les vrais lecteurs Store et requirement_trace. Deux bases SQLite synchronisées de façon idempotente : quatre destinataires, 42 603 autres lignes inchangées, 42 607 états manuels et 23 historiques conservés. Trois textes courts de traçabilité changent ; les instructions complètes des quatre destinataires incluent les résultats et limites.

Graphe : 99 233 sources et 5 005 consommateurs ; 26 189 inconnues ouvertes et 5 517 résolues conservées. Les 5 005 ancres de code sont exactes sans divergence. La validation globale est structurelle (`source_hashes_verified=0`) ; les vérifications d’octets ciblées sont distinctes et documentées dans les preuves. Aucun test du serveur Riot historique, du rendu, des sons ou du réseau.

Fichiers modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json ; nouveaux reçu, preuve et présent rapport ; ajouts documentaires à coverage.json, completion_plan.json et resume_checkpoint.json ; CURRENT.md et HANDOFF.md. Les registres d’identités, phases/lots et inconnues restent identiques octet par octet. Les deux bases et le dossier privé contiennent les copies/protocoles associés. Aucun stage, commit ou changement du code de jeu.

## Travail restant explicite

1. Retrouver les catégories exactes admissibles, notamment monstres, les rayons de décès et ramassage, la durée et la visibilité des âmes.
2. Établir les taux et l’algorithme aléatoire, les valeurs successives, arrondis, seuils/plafonds et producteurs de f1/f2/f3.
3. Relier le producteur de décès à la création, à la collecte unique et aux bonus permanents ; qualifier collecte par proximité et lanterne ainsi que les interactions E/W.
4. Contrôler plusieurs Thresh, morts simultanées, répétitions, expiration, hors rayon, mort/réapparition, déconnexion et reprise déterministe.
5. Implémenter et qualifier les sorts dans les tâches dédiées ; les refus actuels ne prouvent pas leurs effets ni le passif.
6. Qualifier séparément HUD, sons, VFX, animations, rendu et réseau. Conserver les limites historiques V564/V606.

Cette livraison termine l’association ciblée, pas Damnation, Thresh ou le jeu. Les inconnues et critères restent ouverts. Les preuves privées sont une dépendance locale, pas un paquet portable autonome.

## Reprise

Continuer SYS-01.2-02 depuis revision640_trace_review/REVIEW.json. V639 Thresh / Damnation :164 fichiers natifs,492 associations,14 points de code et28 liens. Sources :âmes déposées par ennemis morts,collecte à proximité,gains permanents armure/AP,pas de croissance d’armure par niveau. Champions et grands sbires toujours,petits sbires parfois ;valeurs et taux restent ouverts. Armor16/ArmorPerLevel0 vérifiés. Anciennes descriptions Jax/mana et marqueurs3/7/11/15,tooltip MR/dégâts de base et DDF Khazix conservés séparément.67Lua sans fonctions enfants,dont14 limites NEWTABLE,46preloads,17BuffData dont16résolus ;DDF72lignes,unique lien KhazixW bonusAD0,6.54références communautaires,CharScript vide,Q +1AP à l’impact divergent des âmes,W producteur ThreshLantern non retrouvé dans le sous-arbre,E/R simplifiés. Diagnostic avec XP fournie par API serveur :niveaux1à18,Thresh armure16/AP0 constant,72 apprentissages et144 casts refusés ;Annie témoin18 apprentissages et croissance d’armure observée.278 refus de commandes et10 refus XP,0tick simulé. Aucun décès,drop,ramassage ou gain d’âme exercé. BUILD/RUN/inspection0 ;gameplay,états,cases,inconnues et preuves conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Tristana. Goal actif.
