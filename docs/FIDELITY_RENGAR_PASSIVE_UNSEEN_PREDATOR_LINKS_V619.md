# Rengar — sources et consommateurs de Unseen Predator, V619

Date UTC : 2026-10-26T14:41:51.330770+00:00. SYS-01.2-02,F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. Build littéral2014-11-17 à17:46:45,fuseau et déploiement non établis.

## Résultat et portée

CH-Rengar-PASSIF-SOURCE,CH-Rengar-PASSIF-SIMULATION-CONTRAT et CH-Rengar-PASSIF-SIMULATION reçoivent145 sources natives,435 associations,28 points de code et56 liens supplémentaires pour les deux fiches de simulation. Aucun gameplay modifié ;les trois fiches restent ouvertes.

Depuis un buisson comme depuis le terrain ouvert,Rengar marche vers la cible avant de frapper. Les quatre cas publics comparant vitesse345/370 ne montrent aucun saut dans le chemin testé. La portée native exacte f1 n'est pas liée à son producteur ;400unités est la distance de ce diagnostic,pas une portée native déclarée.

La Férocité est identifiée comme ressource générique et reste à5 pendant ces essais. Aucun sort Rengar accepté :gain,consommation,renforcement et furtivité ne sont pas qualifiés par cette jauge constante.

## Sources natives et limites

145 ressources :37 INIBIN,66 Lua,40 preloads,un DDF,un texte en_GB. Identités et appartenance au manifeste sélectionné vérifiées. Les66 Lua sont entièrement parcourus,sans sous-fonction. Neuf limites NEWTABLE :Rengar9StackBuff,E,EFinal,EFinalMAX,R,RSpeed,RTrack,RTrackSkin,RTrackSkin1. Les57 initialisations littérales ne sont pas l'exécution du serveur historique.

Rengar.inibin :PARType=Ferocity,BaseMP=5,MPPerLevel=0,BaseStaticMPRegen=0. PARStart/PARMax absents ;le remplissage initial courant à5 n'est pas une valeur initiale historique qualifiée. Passive1LuaName=RengarPassive,icône Rengar_Passive.dds,portée ordinaire125,IsMelee=Yes,AD60,0400009155,MS345.

Le texte natif lie le saut à une attaque depuis un buisson ou la furtivité,avec portée f1. La description indique1point de Férocité par capacité utilisée sur un ennemi. À5,les capacités deviennent renforcées et immédiatement disponibles ;l'utilisation d'une capacité renforcée ramène la jauge à0. **Aucun gain sur attaque de base n'est inventé.** Événement exact de gain,cibles,cap,consommation et disponibilité des capacités demandent une qualification serveur.

Passive1Desc décrit des soins de Warwick ;Passive1=1 et niveaux1/6/11/16 sont conservés sans les adopter comme progression du saut ou de la Férocité. CharScriptRengar.luaobj contient seulement BuffTextureName=Wolfman_InnerHunger.dds. RengarManager et RengarFerocityManager sont vides. Le CharScript communautaire est vide.

RengarPassive.inibin existe ;son Lua homonyme est absent au chemin voisin inspecté. RengarNewPassive.luaobj contient BuffName=RengarNewPassive et PersistsThroughDeath=true. RengarPassiveBuff contient son nom et son icône. Les variantes PassiveBuffDash/NewPassiveBuffDash ont les mêmes littéraux DoesntBreakShields=true,BuffName=RengarPassive,IsDeathRecapSource=true,PersistsThroughDeath=true. Cela ne prouve ni leur équivalence effective,ni le choix d'une variante,ni le fonctionnement du saut ou du lifecycle.

Le preload du personnage référence notamment manager,ferocitymanager,passive,passivebuffvisible,rootcheck,trophées et particules. Les dépendances de Férocité comprennent ses warnings et managerincombat. Leur chargement ou application effective n'est pas qualifié par la liste.

25 liens BuffData :18 résolus,7 non résolus (9StackBuff,E,FerocityManagerInCombat,NewPassive,Q,R,TrophyBuff). HatredReady et HatredUnready renvoient au texte **VolibearHatredZilean**. La résolution textuelle est conservée,sans acceptation sémantique pour Rengar. Aucun doublon de basename ni variante NightmareBot sélectionnée.

Rengar.ddf :16 lignes,dont deux non vides :Q;f1→@dynamic.attackdamage,1 et R;f1→@text,5. Les14 autres sont vides. Ni la portée f1 du passif ni les producteurs des valeurs renforcées ne sont déduits automatiquement de ces entrées.

Trophées,variantes Bonetooth/Dominion,bonus3/9stacks et variantes de présentation sont recensés comme contexte distinct. Leur présence ne qualifie pas leur usage sur Map10,les récompenses de kills ni la modification de portée.

Cinq candidats absents :CharScript dans Scripts au lieu de la racine,NewPassive.inibin global,FerocityManager.luaobj global,Rengar.en_gb.ddf,RengarUnseenPredator.inibin. L'absence locale supplémentaire de RengarPassive.luaobj est documentée. Aucune absence globale d'assets ou corruption déduite.

| Ressource | Identité du registre |
|---|---|
| Rengar.inibin | OLS-5a6ca215-a553-560c-9ac9-3d44a1d6b5a5 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Rengar.ddf | OLS-7c581f53-bb88-558c-8b7c-fd31b86005c2 |
| CharScriptRengar.luaobj | OLS-f6b48a8a-0f55-578f-b661-683133341360 |
| CharScriptRengar.preload | OLS-4cdd898e-2cc9-5856-aab9-a93d738910c4 |
| Rengar3StackCombatManager.luaobj | OLS-7ba8bbea-0153-50f1-8cab-00e3e8e5a4d2 |
| Rengar3StackCombatManager.preload | OLS-8252a818-8e00-5fa3-9a60-cf1dfc857261 |
| Rengar3StackMobilityDebuff.luaobj | OLS-6d43e4d4-fbe4-550e-b624-4b69287826cc |
| Rengar9StackBuff.inibin | OLS-b98b45dd-88b7-5276-9142-d8e7ab67c769 |
| Rengar9StackBuff.luaobj | OLS-820fbb61-ff26-50e7-8d6c-93f93fa3ad5d |
| Rengar9StackBuff.preload | OLS-c03e202f-e703-5f06-8648-15073dc7ba0d |
| RengarBasicAttack.inibin | OLS-e717fa3d-1cb5-56c3-a2be-24315f70b06c |
| RengarBasicAttack2.inibin | OLS-28218a57-3053-55b3-a2ce-22f20c92f91a |
| RengarBasicAttack3.inibin | OLS-585c161b-fa6c-5f7b-bb50-10dbb12b3aeb |
| RengarBushSpeedBonus.inibin | OLS-992d7a66-c63a-5c22-8001-a2dfe1141d09 |
| RengarBushSpeedBonus.luaobj | OLS-ccb0550e-0996-58c8-92f8-6026f4b6a491 |
| RengarBushSpeedBonus.preload | OLS-1e076106-a75f-51db-9645-174969344553 |
| RengarCritAttack.inibin | OLS-d166b5f9-fde8-52b2-9fb2-1bc53eedbd6b |
| RengarE.inibin | OLS-a02dd8cd-3ae2-5984-a2c4-136f78ac5bfa |
| RengarE.luaobj | OLS-01210c6c-2fe0-5f70-90c5-d2595ef1a07b |
| RengarE.preload | OLS-80790c2b-7b5c-50b5-8bd3-c44045965b0b |
| RengarEFinal.inibin | OLS-dc356c10-c92e-588e-a42c-20e50e59a210 |
| RengarEFinal.luaobj | OLS-8da3b9ca-7ffa-5704-98bb-5df5e1c4af2e |
| RengarEFinal.preload | OLS-01acfb5a-63a7-5447-99f1-be4441576316 |
| RengarEFinalMAX.inibin | OLS-8b6b68a5-7e28-5806-887d-947de331e064 |
| RengarEFinalMAX.luaobj | OLS-0346089a-1de2-5bc5-879d-cffcbd9a8c69 |
| RengarEFinalMAX.preload | OLS-f9913219-a862-5558-85c5-bbb67be25267 |
| RengarERoot.inibin | OLS-22ad5481-986d-54ae-801f-6a764f5d40cc |
| RengarESlow.luaobj | OLS-9c3ee02b-6bbc-5f9f-9e6d-75699581b126 |
| RengarFerocityManager.luaobj | OLS-2035246d-cab4-552f-bb60-a54700b6be79 |
| RengarFerocityManager.preload | OLS-ebeda1bf-d385-5c62-b157-f3d9534b737d |
| RengarFerocityManagerInCombat.inibin | OLS-78f1338c-97c3-569b-b358-eea8ed611ad3 |
| RengarFerocityManagerInCombat.luaobj | OLS-919aa73a-d7ca-5730-9d3a-ab4b12a85a19 |
| RengarLeapDummy.luaobj | OLS-0a0d1e7d-996d-584a-a504-cdc38cfe0a16 |
| RengarManager.luaobj | OLS-469cac05-bc2c-5a44-b24f-8232028284c6 |
| RengarManager.preload | OLS-6824fb71-cd23-5713-a999-3d476b7f7ae7 |
| RengarNewPassive.inibin | OLS-6451d1dd-8dfb-57e8-b7f9-da74506e150c |
| RengarNewPassive.luaobj | OLS-ac026107-0145-5f1f-8855-843b4966f8e3 |
| RengarNewPassive.preload | OLS-df1f0535-5dfd-5568-847c-920a9e442604 |
| RengarNewPassiveBuff.luaobj | OLS-aa84d40c-01b9-5f35-b353-99abfbcedaee |
| RengarNewPassiveBuff.preload | OLS-f98a7d77-0d23-5abd-a4c0-b73b004045bf |
| RengarNewPassiveBuffDash.inibin | OLS-1fc42364-b71f-5297-af18-cffef04d5c99 |
| RengarNewPassiveBuffDash.luaobj | OLS-4249bac7-eae0-5d7d-98e2-e389ff27bf9b |
| RengarNewPassiveBuffDash.preload | OLS-c3b64713-1967-53f6-b699-43726d903eee |
| RengarPassive.inibin | OLS-1e40692f-8039-5905-89d8-f88711e99de0 |
| RengarPassiveBuff.inibin | OLS-778c7fc3-41b5-54a3-8345-2258f9b18c42 |
| RengarPassiveBuff.luaobj | OLS-86d6bc85-7580-573b-aa42-d1572e07e2d8 |
| RengarPassiveBuff.preload | OLS-3716e4ac-263a-518c-a824-be5201177b90 |
| RengarPassiveBuffDash.inibin | OLS-bcb81dd7-a065-56ad-b0a8-25bca71233f1 |
| RengarPassiveBuffDash.luaobj | OLS-fe476dce-3c4d-5290-9987-9bffdb2bc7d9 |
| RengarPassiveBuffDash.preload | OLS-f766d85e-af86-577f-add2-33cef18f6c08 |
| RengarPassiveBuffDashAADummy.inibin | OLS-b537921e-60f5-5b8a-aa3c-878c74370581 |
| RengarPassiveBuffDashAADummy.luaobj | OLS-29b1bb67-0c44-5b0f-81f4-3143db455820 |
| RengarPassiveBuffDashAADummy.preload | OLS-6287329f-c9d8-5873-aef8-64f26efa5df1 |
| RengarPassiveBuffVisible.luaobj | OLS-86ae3822-c7f9-535c-8c6e-43e3ef2242ca |
| RengarPassiveRootCheck.luaobj | OLS-be7cbf88-a7cd-5397-9072-6a5de1b4a24d |
| RengarQ.inibin | OLS-0b4a0881-4885-5c51-ac89-960bb846a59d |
| RengarQ.luaobj | OLS-2c7e12a7-d226-57cc-bf1b-52d6ac158306 |
| RengarQ.preload | OLS-46e0098d-6c92-52a1-afae-3b6e2ef71759 |
| RengarQBase.luaobj | OLS-a27c0f51-1ebd-5d2c-81f0-db3cfb60f3f6 |
| RengarQBase.preload | OLS-06dea1a1-6077-56ac-b05e-903da0719a0b |
| RengarQBaseBuff.luaobj | OLS-72ad40fd-d050-55e4-8809-165f73b5d77b |
| RengarQBuff.inibin | OLS-f48ddae0-6706-54af-a2f4-4ded51aa27f3 |
| RengarQBuff.luaobj | OLS-760e6561-8b59-5d95-b980-d9f5ffcd4293 |
| RengarQBuffBonus.luaobj | OLS-2ee328b5-f344-5071-a084-e2c85a228877 |
| RengarQBuffBonusInternal.luaobj | OLS-092c8278-1882-5f68-b15b-eef02dd46163 |
| RengarQBuffBonusMAX.luaobj | OLS-256de41e-d0bf-51a2-a6d2-6b06c77eca11 |
| RengarQBuffBonusMAXInternal.luaobj | OLS-9e668034-8c18-5605-8fb0-882f8faa55d3 |
| RengarQBuffMAX.inibin | OLS-ef2f831b-0071-503e-a6e8-565f019be6c7 |
| RengarQEmp.inibin | OLS-7c73f259-eb78-59c3-a149-03a9dd58ccfe |
| RengarQEmp.luaobj | OLS-294676fe-c8f3-5a4a-8828-29f71295f3ad |
| RengarQEmp.preload | OLS-caba52cf-2f0f-54ae-bfe7-bfb0dceacc25 |
| RengarR.inibin | OLS-d30aea22-be15-5cbd-809d-e94f6654647e |
| RengarR.luaobj | OLS-015f6a18-c695-552b-8fc7-39777441f89d |
| RengarR.preload | OLS-2d450a4d-cfa1-5b2f-a125-76b15bfa7086 |
| RengarR_Internal.luaobj | OLS-b015f2ef-b9d2-533e-a938-ff479b38b00e |
| RengarR_Internal.preload | OLS-fa1b12c7-af31-5be5-8ab3-6ed10f3ab0ae |
| RengarRAlert.luaobj | OLS-8a151ea0-ae7d-58fc-88ed-bc8209a8f9ec |
| RengarRAlert.preload | OLS-3762984a-8438-5a18-8cae-cee62079557c |
| RengarRAlertSound.luaobj | OLS-d3662f54-0836-5286-8951-d6ded7fc27f7 |
| RengarRAlertSound.preload | OLS-5f4cf2f1-f4fe-5228-9b65-6cd14d46923a |
| RengarRBuff.inibin | OLS-9624c1f8-e7a6-5935-b9cf-b2eacb7989e7 |
| RengarRManager.luaobj | OLS-4711b6c0-69de-5442-add7-8f1d67d5c2ea |
| RengarRManager.preload | OLS-af26afdc-5ad9-5975-b0db-8fad413af92c |
| RengarRSound.luaobj | OLS-ab8620d6-0022-5e12-877a-f9e55eb550d6 |
| RengarRSound.preload | OLS-34497709-8eef-5b0c-a9d7-5e2996a7cc1a |
| RengarRSpeed.inibin | OLS-5495ad7d-7e8c-546f-9be6-401a2bf4304a |
| RengarRSpeed.luaobj | OLS-6ff8612f-e3ca-51fc-b191-32d88d92fdbb |
| RengarRSpeed.preload | OLS-cfbcada7-c73d-5c12-94cb-a6c39556d119 |
| RengarRTrack.luaobj | OLS-dc076afd-6c7d-5371-aed0-93f76d101dc5 |
| RengarRTrack.preload | OLS-81bcc4d9-6fa3-5c59-b1af-654d69be65bd |
| RengarRTrackSkin.luaobj | OLS-5d7acf1f-187f-5a42-b4b3-3bd4f1c65c1e |
| RengarRTrackSkin.preload | OLS-47dda9e4-23ab-5122-a462-4d1bffcee160 |
| RengarRTrackSkin1.luaobj | OLS-24a9e48f-b61c-59d1-a66e-a7dfe4401b30 |
| RengarRTrackSkin1.preload | OLS-ed905293-134e-5bce-a263-2288acf7a4a9 |
| RengarRunSpeed.luaobj | OLS-353d9881-69e6-5f41-8389-cb23a298280c |
| RengarSpeedBonus.luaobj | OLS-7143bd2f-0264-57fb-9da7-598fdd09405a |
| RengarW.inibin | OLS-4a21595e-57a9-540d-bd16-db7287c127fe |
| RengarW.luaobj | OLS-c37c037d-762d-5c30-9b14-54038f43bbc7 |
| RengarW.preload | OLS-295e1b12-bde3-54fb-8613-59d2eed34485 |
| RengarWArmorMR.luaobj | OLS-e7b3fab0-7882-5e32-84ba-c7ff834840b3 |
| RengarWArmorMR.preload | OLS-8452b84e-0364-5e8e-a1dc-853432ffdb0e |
| RengarWBuff.inibin | OLS-c6da2930-67fd-5b91-b980-9086d1144e30 |
| RengarWBuff.luaobj | OLS-ccfc1925-2b8d-5702-8ede-809135db91db |
| RengarWBuff.preload | OLS-00abf3ee-a1c2-5b9e-ae6e-9eed9b1597a1 |
| RengarHatredReady.inibin | OLS-54e49152-10bd-5de5-a6ea-65fd577cbbb0 |
| RengarHatredReady.luaobj | OLS-69f9e086-65c2-5e2a-a9c4-849f9da1de5d |
| RengarHatredUnready.inibin | OLS-56d5cb23-9622-57be-b2cd-84d16f173da7 |
| RengarHatredUnready.luaobj | OLS-d7c9d83d-00a3-50dd-b2bf-00487c40ab79 |
| RengarQAnimation.luaobj | OLS-e5560b3a-fbc2-5004-bbce-aaded72b10d4 |
| RengarRevive.inibin | OLS-8e0a2d65-efdf-5864-8ef0-304d47a20376 |
| RengarRevive.luaobj | OLS-aa4670cf-18cc-581c-ba46-d3ad8103cca9 |
| RengarTrophy.luaobj | OLS-bfde7cae-904d-5fcb-b454-8418225a047e |
| RengarTrophy.preload | OLS-d64fc857-91d8-5310-995d-7e0aef28571d |
| RengarTrophy6Check.luaobj | OLS-4146d491-03de-50db-9557-21a472fa24bf |
| RengarTrophy6Check.preload | OLS-b9f3ba9f-f0c0-5ed2-b2a1-db66ea1bb5ad |
| RengarTrophy9Bonus.inibin | OLS-b17019fc-c2f5-55e9-ab47-3106b14ab4a2 |
| RengarTrophy9Bonus.luaobj | OLS-0673730e-2ec2-5333-9920-9318304e145d |
| RengarTrophy9Bonus.preload | OLS-455086ee-93a1-5d0e-b7fd-f56344fe5632 |
| RengarTrophyAlt.luaobj | OLS-17b2be48-0836-5c6e-8e14-1534146e10c7 |
| RengarTrophyAlt.preload | OLS-bf1d24ea-1e2a-5872-9659-8f2ab9eae95c |
| RengarTrophyBlue.luaobj | OLS-1aa59337-60dc-500b-a54a-40eeaf59b6fc |
| RengarTrophyBlue.preload | OLS-3785d343-496a-5673-8d85-98b87b9b81e2 |
| RengarTrophyBuff.inibin | OLS-5855e2d1-c863-5bf4-9e76-88fd8a362197 |
| RengarTrophyDominion.luaobj | OLS-2686dade-f2b1-5c25-b3a0-8afdb2c8e934 |
| RengarTrophyDominion.preload | OLS-f1ed0f4a-94ad-5b9f-aa28-36834d08e910 |
| RengarTrophyIcon1.inibin | OLS-9a6b851f-974e-5a23-8863-ced9390bcfc7 |
| RengarTrophyIcon1.luaobj | OLS-5c5e3808-9a11-5ad2-9387-ee22e120c10a |
| RengarTrophyIcon2.inibin | OLS-2b0a3b2b-b895-5b07-829c-3270107f52a8 |
| RengarTrophyIcon2.luaobj | OLS-5c103b37-c070-566b-9b09-b071ccd977c5 |
| RengarTrophyIcon3.inibin | OLS-e0e3f0d8-c77a-5d41-9694-53f18054a2b7 |
| RengarTrophyIcon3.luaobj | OLS-440dae1d-9164-58c3-a406-e0daeb9a59b0 |
| RengarTrophyIcon4.inibin | OLS-5a10016b-df12-5161-a4d3-566f56cb7617 |
| RengarTrophyIcon4.luaobj | OLS-b217d5eb-bd32-53fa-9dc8-6c521977217f |
| RengarTrophyIcon5.inibin | OLS-c0bae226-1197-5a63-aabe-90ad7a48db3b |
| RengarTrophyIcon5.luaobj | OLS-8124dfc3-0c1f-5477-a3a9-46c7567f8970 |
| RengarTrophyMant.luaobj | OLS-e3cdb283-bdf0-5b1b-b451-1cb8782945e8 |
| RengarTrophyMant.preload | OLS-88bfb89c-a349-5612-839d-1f0739524b2c |
| RengarTrophyNoItem.luaobj | OLS-ccfdaf4a-ca58-58e7-93ae-e10ee26cea90 |
| RengarTrophyNoItem.preload | OLS-ffb699df-c7f5-51e9-b09c-fd6c38d58389 |
| RengarTrophyRed.luaobj | OLS-f0dbbe7c-4ea9-5d4b-9314-bf9d76b0f34f |
| RengarTrophyRed.preload | OLS-33b7d839-7f55-51ef-babf-bcefb0e36261 |
| RengarTrophyStacks.luaobj | OLS-da437e45-f83e-548a-910c-131db064e68f |
| RengarUpdateTrophyCharges.luaobj | OLS-ebaba75b-096c-5260-b43c-193851bab7e2 |
| RengarWMoveaway.luaobj | OLS-8ea9073f-42f3-5fb7-93e0-2ece03ffc71c |

## Références communautaires

42 références présentes,distinctes de l'autorité historique et du moteur Rust.

- Q communautaire inflige immédiatement30×rang+AD total à une cible. Le texte natif lie Savagery à la prochaine attaque dans3s et distingue des valeurs renforcées,bonus de vitesse d'attaque et d'AD ;le fichier ne qualifie pas ces mécanismes.
- W communautaire soigne10%PVmax et ne modifie pas Stats.Armor dans le fichier. Le natif décrit des défenses,leur amplification par champions/grands monstres touchés et un soin renforcé dépendant des PV manquants. Le commentaire évoquant les dégâts subis ne remplace pas ce contrat4.20.
- E communautaire applique un root1.75s sans branche de Férocité ;le natif distingue ralentissement normal décroissant2.5s et root renforcé avec valeurs dépendant du niveau. Le bonusAD communautaire0.7 n'est pas une acceptation complète de ces variantes.
- R délègue RengarHunt avec durée7+5×rang. La délégation ne qualifie pas délai de furtivité1/3s,révélation,déplacement vers les champions,saut,bonus après rupture de furtivité et génération différée de5Férocité décrits dans le natif.

Les quatre fichiers lus ne gèrent pas Ferocity/CurrentMana. Cela ne prouve pas l'absence de toute logique ailleurs dans le projet communautaire. Aucun script communautaire exécuté ici comme serveur original ou accepté comme consommateur Rust.

## Diagnostic courant

Véritable cœur Rust compilé hors configuration test,offline/locked,dépendances alignées sur Cargo.lock. BUILD0,RUN0,collecte0,inspection0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-rengar-passive-unseen-predator-probe.exe` ;6057472 octets ;SHA256 `cb828f2396f4682b30f83b233835dc6a0ce6539a5ffbdff19812bf9682849aac`.

Quatre parties publiques :buisson/terrain ouvert,sans/avec Bottes1001(+25MS). Deux champions niveau1 vivants,une cible visible à400unités,aucun contrôle/bouclier/vainqueur. Pas d'injection directe de position,PV,ressource,rang ou dégâts. Huit trajets préparatoires réussis sans réémission.

Les drapeaux de navigation effectivement lus sont1 pour le départ dans le buisson,0 pour le départ ouvert. Positions de départ :buisson x6906,317871/z6884,240234 ;ouvert x7084,9819/z6884,240234 ;ennemi400unités plus loin sur le même axe. La visibilité est vérifiée à chaque tick mesuré.

| Cas | Flags départ | Vitesse | Pas complets avant impact | Distance parcourue avant impact | Ticks ordre→premier impact | Refus |
|---|---:|---:|---:|---:|---:|---:|
| brush_base | 1 | 345.0 | 20 | 230.00000 | 29 | 27 |
| open_base | 0 | 345.0 | 20 | 230.00000 | 29 | 27 |
| brush_boots | 1 | 370.0 | 18 | 221.99414 | 27 | 27 |
| open_boots | 0 | 370.0 | 18 | 221.99414 | 27 | 27 |

À345MS :20pas de11.5unités,230unités parcourues,29ticks jusqu'au premier impact. À370MS :18pas d'environ12.333unités,221.99414unités parcourues,27ticks. Les résultats sont identiques entre départ buisson et ouvert à vitesse égale. Chaque déplacement reste dans le budget ordinaire vitesse/30,avec tolérance0.003 pour l'arrondi. Les routes d'attaque et de mouvement inspectées ne contiennent pas de branche Rengar identifiée.

Total :12impacts mêlée ordinaires,50.36068726dégâts observés chacun,108refus,244ticks d'attente. Les témoins de windup/release et les résidus de dégâts corrigés de régénération sont vérifiés. Aucun dégât entrant ou sort Annie utilisé.

Les refus couvrent acteur inconnu,attaque de soi,slot invalide et apprentissage/lancements QWER non supportés,avec snapshots inchangés. La ressource reste à5,maximum courant5,rangs/délais à zéro,restauration générique nulle.

**Limites :** le départ dans un buisson et la visibilité sont exercés,mais pas le binding natif de portée f1,les limites exactes de portée,la furtivité,la fenêtre après sortie du buisson,les trophées,les capacités renforcées,mort/respawn ou transport réseau. Une marche observée ne qualifie pas la trajectoire historique du saut.

## Consommateurs réels

Recherche Rengar/Ferocity/UnseenPredator sans occurrence dans crates/core/src. L'inspection des routes réelles de commande,attaque,mouvement,vision et ressource complète cette recherche. Classification Ferocity,non-restauration générique,vision et déplacement ordinaires sont conservés comme comportements présents ;ils ne constituent pas le passif complet.

Sept ressources locales liées :catalogue,croissance,ressources,attaques,critiques,collision,boutique. Les1158 entrées du diagnostic sont identifiées et hachées. Les flags de navigation sont lus dans vision.rs,à partir des cellules chargées ;aucun drapeau inventé pour provoquer le cas de buisson.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current resource5 at join,native initial value unresolved |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary stats and maximumFerocity5 |
| crates/core/src/progression.rs:150 | unsupported Rengar learning |
| crates/core/src/progression.rs:159 | unsupported Rengar ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported ground spell |
| crates/core/src/lib.rs:685 | four cases12melee244idle;ordinary approach |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | generic damage,not passive stat conversion |
| crates/core/src/attacks.rs:157 | ordinary walking then three melee impacts per case |
| crates/core/src/lifesteal.rs:4 | ordinary physical hits,not leap or Ferocity generation |
| crates/core/src/regeneration.rs:32 | generic nonrestoration,not Ferocity policy |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | public Boots1001 purchase |
| crates/core/src/shop.rs:215 | ordinary movement speed bonus |
| crates/core/src/world.rs:226 | one enemy champion;other target types unexercised |
| crates/core/src/damage.rs:38 | generic physical damage control |
| crates/core/src/attacks.rs:26 | melee hit witness |
| crates/core/src/lifecycle.rs:16 | generic nonmana resource classification |
| crates/core/src/lifecycle.rs:24 | Ferocity excluded by generic Mana/Energy predicate |
| crates/core/src/lifecycle.rs:33 | generic nonmana reset path read,not exercised |
| crates/core/src/ally_occupancy.rs:635 | eight preparation travels and ordinary attack approach |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564/V606 remain open |
| crates/core/src/vision.rs:45 | actual map flags:brush1/open0 |
| crates/core/src/vision.rs:48 | ordinary brush visibility context |
| crates/core/src/vision.rs:79 | visible enemy in all measured approach frames |
| crates/core/src/movement.rs:53 | 345/370 speed control;all steps within budget |

## Publication et conservation

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_sources_4_20.json,docs/fidelity_requirement_trace_4_20.json. Reçu :docs/reference_requirement_trace_sources/rengar-passive-unseen-predator-links-v619.json. Preuve :docs/fidelity_rengar_passive_unseen_predator_links_v619.json. Instructions copiables des trois fiches et de SYS-01.2-02 mises à jour.

PREPARE/CHECK/PUBLISH/AUDIT0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases :quatre destinataires,42603 autres lignes,42607 états manuels et23 historiques conservés,synchronisation idempotente. Identifiants,hiérarchie,inconnues inchangés octet par octet. Trois questions propres et quatre dépendances conservées ;aucune tâche clôturée.

Revue globale99153sources/4514consommateurs,4514ancres exactes sans divergence. Revue structurelle globale(source_hashes_verified=0),distincte des hashes sélectionnés ;pas de recontrôle exhaustif de toutes les sources revendiqué.

Un garde du générateur d'inspection a arrêté sa première version avant écriture sur la sous-chaîne « reign » dans « foreign ». La variante contrôle le nom complet de l'ancien passif,conserve les deux générateurs et produit l'inspecteur qui passe0. Une recherche dans un répertoire nav supposé inexistant a été corrigée vers les fonctions réellement trouvées dans vision.rs. Aucun de ces incidents n'a modifié les sources natives ou le jeu.

coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md actualisés avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage. Battle Training,V564/V606 et les inconnues précédentes restent ouverts.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision619_Rengar_discovery/OBSERVATIONS.json,revision619_Rengar_passive_probe/OBSERVATIONS.json,revision619_Rengar_inspection/OBSERVATIONS.json,revision619_Rengar/DELIVERY_AUDIT.json et revision620_trace_review/REVIEW.json.

## Travail restant

1. Qualifier les variantes réellement sélectionnées,la portée f1 et les conditions du saut.
2. Qualifier sortie de buisson,furtivité,vision,cible,terrain,root,annulation et trajectoire.
3. Implémenter le saut au chemin d'attaque réellement consommé,puis vérifier impact et on-hit.
4. Qualifier l'état initial et les événements de gain/consommation de Férocité,seuil5 et disponibilité immédiate.
5. Implémenter versions normales/renforcées QWE et liens avec R.
6. Qualifier trophées,récompenses,bonus de mobilité/portée et variantes Map10 séparément.
7. Tester plusieurs Rengar,changements de cible,mort/départ,répétitions et limites de portée.
8. Qualifier HUD,icône,trajectoire/hauteur,animations,audio et réseau séparément.

Pas de serveur historique,rendu,audio ou transport réseau qualifié ici. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision620_trace_review/REVIEW.json. V619 Rengar / Unseen Predator :145 sources natives,435 associations,28 points et56 liens. Texte natif :saut depuis buisson/furtivité,1 Férocité par capacité sur ennemi,seuil5,renforcement disponible immédiatement puis remise0. Quatre cas publics buisson/terrain ouvert,sans/avec Bottes1001 :12attaques mêlée,108 refus,244ticks et huit trajets. Cible visible à400 ;avant le premier impact20pas ordinaires à345vitesse ou18à370,soit230/221,994unités parcourues ;aucun saut observé. Jauge courante5 ;génération/dépense de Férocité,furtivité et portée native f1 non qualifiées. Aucun sort Rengar accepté. BUILD/RUN/inspection0. 66Lua dont9limites NEWTABLE,40preloads,25BuffData dont18résolus7nonrésolus. HatredReady/Unready renvoient à VolibearHatredZilean ;résolution non acceptation sémantique. DDF16lignes dont Qf1 @dynamic.attackdamage1 et Rf1 @text5,aucune portée passive résolue. CharScript natif icône Wolfman uniquement,Managers vides ;texte Warwick et niveaux1/6/11/16 non adoptés. Passive/NewPassive et trophées/Dominion restent distincts. 42références communautaires :Q immédiat,W soin fixe10%PVmax sans défenses dans le fichier,E root inconditionnel,R délégation ;aucune branche Férocité dans les quatre fichiers lus. Cinq candidats absents et Lua RengarPassive absent localement ne prouvent pas un manque global d’assets. Acquis génériques de ressource/vision/mouvement conservés ;V564/V606 ouverts. Aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Riven. Goal actif.
