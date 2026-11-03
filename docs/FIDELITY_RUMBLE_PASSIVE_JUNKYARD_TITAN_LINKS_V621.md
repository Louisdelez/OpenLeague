# Rumble — sources et consommateurs de Junkyard Titan, V621

Date UTC : 2026-10-26T15:18:23.802720+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis.

## Résultat et portée

Les trois fiches CH-Rumble-PASSIF-SOURCE, CH-Rumble-PASSIF-SIMULATION-CONTRAT et CH-Rumble-PASSIF-SIMULATION reçoivent 103 sources natives, 309 associations, 26 points de code et 52 liens supplémentaires pour les deux fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ; statuts ouverts conservés.

Les sources définissent Danger Zone à 50 de chaleur et Overheat à 100, avec bonus magique sur les attaques et blocage des sorts pendant six secondes. Le bonus numérique, le refroidissement et plusieurs transitions restent à qualifier. Le moteur démarre ici à 100, ne refroidit pas pendant l'attente, puis revient à 0 après réapparition. Aucun sort Rumble n'est accepté. Une jauge numérique à 100 ne constitue pas la preuve d'une entrée effective en surchauffe.

## Sources natives et limites

103 ressources : 29 INIBIN, 51 Lua, 22 preloads et le texte en_GB. Taille, SHA et appartenance au manifeste RADS sélectionné vérifiés. Aucun doublon de basename ni variante NightmareBot sélectionné.

Rumble.inibin indique PARType=Heat, BaseMP=100.0, Passive1LuaName=RumbleHeatSystem et icône Rumble_Junkyard Titan1.dds. PARStart/PARMax sont absents : le remplissage initial du moteur actuel n'est pas une valeur historique qualifiée. Attaque mêlée de portée 125, AD 61.0359992981, vitesse 345. Passive1 est absent. Passive1Desc parle d'Alistar contre les tourelles, PassLev1Desc2/3 parlent de +400/+600 PV, niveaux 6/12/18 : ces données héritées ne sont pas adoptées comme règles du passif.

Le texte exact de RumbleHeatSystem précise Danger Zone à 50 pour les capacités de base, surchauffe à 100, bonus magique f1 (+f2) sur attaques et impossibilité de lancer les sorts pendant six secondes. Les producteurs de f1/f2 ne sont pas établis. La description générale dit que chaque sort génère de la chaleur ; les descriptions spécifiques indiquent 20 chaleur pour Q/W/E, un second tir E gratuit sous trois secondes et « No Cost » pour R. La politique exacte de ces exceptions reste à qualifier ; ManaCost=0 ne signifie pas absence de gain de chaleur.

Les champs Q Effect2, W Effect3 et E Effect3 valent 20 aux cinq rangs. Le texte Q décrit trois secondes de cône, moitié des dégâts aux sbires et monstres, et +50 % de dégâts en Danger Zone. W décrit un bouclier de deux secondes, vitesse accrue pendant une seconde, et +50 % de bouclier/vitesse en Danger Zone. E décrit jusqu'à deux tirs, un ralentissement cumulable de trois secondes, un second tir gratuit dans trois secondes et +50 % de dégâts/ralentissement en Danger Zone. Cooldown1=0.5 du fichier E ne résout pas automatiquement son affichage f1, son recast ou sa recharge.

R décrit une ligne de feu placée par cliquer-glisser pendant cinq secondes. Son texte utilise CharAbilityPower2 ; ses champs Coefficient=0.5 et Coefficient2=0.30000000000000004 restent distincts. Cette livraison ne transforme pas la constante communautaire 0.5 en équivalence démontrée du producteur historique secondaire.

16 bindings BuffData : 15 résolus, un non résolu pour RumbleDangerZone. RumbleDangerZoneBuff est une identité distincte avec texte résolu. Six DummySpell/DummySpellDZ de Q/W/E pointent vers OlafRagnarok ; leur résolution textuelle ne vaut pas acceptation sémantique pour Rumble.

Les 51 Lua sont entièrement parcourus, sans sous-fonction. Vingt-trois limites NEWTABLE restent explicites dans la preuve ; elles concernent notamment attaques, Q/W/E/R, Overheat et variantes de missiles/dummy. Les 28 initialisations littérales restantes ne sont pas une exécution du serveur historique.

CharScriptRumble.luaobj est vide. HeatSystem expose nom, icône et PersistsThroughDeath. HeatPunchTT expose PersistsThroughDeath et NonDispellable ; son nom ne prouve ni sa sélection effective sur Map10 ni une règle spéciale de carte. Overheat comporte les constantes LOC_Silence.troy, VFX et RumbleSkin03, mais sa limite NEWTABLE est conservée. Des effets de silence référencés ne prouvent pas un état autoritaire de silence. Les champs génériques à zéro d'OverheatAttack.inibin ne fixent pas le bonus magique à zéro.

Le preload du personnage cite HeatSystem, HeatPunchTT, apbonusdamagetotowers et globalruncyclemanager. HeatSystem précharge Overheat et DangerZoneBuff ; Overheat précharge sound, heatdelay et heatingup ; HeatDelay précharge heatingup/heatingup2. Ces dépendances ne prouvent ni le refroidissement, ni le lifecycle, ni un rendu/son effectif.

Aucun fichier DDF portant Rumble dans son nom n'a été trouvé sous le DATA local inspecté. Les chemins Rumble.ddf et Rumble.en_gb.ddf sont absents, ainsi que trois autres candidats : CharScript dans Scripts, HeatSystem.luaobj dans DATA/Spells et RumbleJunkyardTitan.inibin. Les fichiers réels HeatSystem et CharScript sous Characters/Rumble sont présents. Cette recherche locale ne prouve pas une absence globale de ressources ou une corruption du client.

| Ressource sélectionnée | Identité du registre |
|---|---|
| Rumble.inibin | OLS-09bcb620-9b25-5225-80f9-2d92d65e7960 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptRumble.luaobj | OLS-bf293b9c-5096-5d01-9f50-397e1cde4b91 |
| CharScriptRumble.preload | OLS-7c0a5ef6-243d-5c73-bfbe-b54ff6ab1b75 |
| RumbleBasicAttack.inibin | OLS-5d57ffe0-30de-5cf0-a748-26de361fcedc |
| RumbleBasicAttack.luaobj | OLS-0eec4d9f-9b2b-5edb-930e-3f8bb7023557 |
| RumbleBasicAttack2.inibin | OLS-6464f251-e1fd-5171-9615-6bb255f62cad |
| RumbleBasicAttack2.luaobj | OLS-9b560ef9-9ed4-5f31-b4ff-b6fd60550c25 |
| RumbleBasicAttack3.luaobj | OLS-58d3fad6-f827-5ab4-9596-98aa3bdff746 |
| RumbleCarpetBomb.inibin | OLS-1a46182d-0cc5-5bbc-a7f7-db3b50529f09 |
| RumbleCarpetBomb.luaobj | OLS-ccb39872-ed0e-5dcc-bebc-9be2741dd429 |
| RumbleCarpetBomb.preload | OLS-95f2506d-823d-51e0-b035-689d6eb085b0 |
| RumbleCarpetBombBurnDest.luaobj | OLS-f79843dc-520a-5445-afd6-dbc08a7168b9 |
| RumbleCarpetBombBurnDest.preload | OLS-078c1ed4-0f17-5047-9297-b2f5f05d3c41 |
| RumbleCarpetBombBurnOrder.luaobj | OLS-a3e57e90-772f-5f8d-8f0f-2bd91825f31b |
| RumbleCarpetBombBurnOrder.preload | OLS-397b1d54-f612-5195-a41b-1fd75500a9cd |
| RumbleCarpetBombCounter.luaobj | OLS-f3a4c9cb-9051-5083-9ab0-0dd35025d001 |
| RumbleCarpetBombDummy.inibin | OLS-92ef02f7-e1b2-5d9a-9ba6-fb36ebfb713f |
| RumbleCarpetBombDummy.luaobj | OLS-796be397-1a5e-542c-8654-5d3c92dc0beb |
| RumbleCarpetBombEffect.luaobj | OLS-97be0c36-6d04-59dd-9696-a9a9df8e38cc |
| RumbleCarpetBombEffect.preload | OLS-d58750fa-7fa6-55b8-8063-7f333c4a73e6 |
| RumbleCarpetBombMissile.inibin | OLS-8056720d-6f34-519f-b632-31a7ace7772f |
| RumbleCarpetBombMissile.luaobj | OLS-50b4a46f-b4d7-5305-88b1-406f2e3858bd |
| RumbleCarpetBombMissile.preload | OLS-89a91c4e-79bc-5b42-8b47-7c77cab2baed |
| RumbleCarpetBombSlow.inibin | OLS-8242bd56-2221-58c4-84da-7cc25f9d6a4b |
| RumbleCarpetBombSlow.luaobj | OLS-a552bb1f-039c-5428-9d2e-82d5668607ce |
| RumbleCarpetBombSound1.luaobj | OLS-e83cd0c9-6964-518f-ae78-3c956852fc34 |
| RumbleCarpetBombSound1.preload | OLS-9408861c-510c-593c-abb4-4f10fc82d4df |
| RumbleCarpetBombSound2.luaobj | OLS-08940248-7f48-5d55-b0e1-ddbea63d7ec6 |
| RumbleCarpetBombSound2.preload | OLS-c22d262f-130c-5f84-89f8-4aa2364d3887 |
| RumbleCritAttack.inibin | OLS-0ce81945-c6f3-56f6-838e-d8b8d9271ae7 |
| RumbleCritAttack.luaobj | OLS-9ecac79f-d7f9-5d43-8da3-a3aada62f49e |
| RumbleDangerZoneBuff.inibin | OLS-2b55bcb4-1e1b-5764-b2ae-5ad928a03cca |
| RumbleDangerZoneBuff.luaobj | OLS-b4a1a853-ad50-55e0-8b5f-5a699f97fd57 |
| RumbleFlameThrower.inibin | OLS-651f6822-c98e-58a7-bca0-0b70e61680af |
| RumbleFlameThrower.luaobj | OLS-4bb09186-a339-5634-811a-24049262aff6 |
| RumbleFlameThrower.preload | OLS-de479af6-3add-571c-bcf5-e32b0ccf35e4 |
| RumbleFlameThrowerBuff.luaobj | OLS-88e49e09-d817-5bdc-9ddb-4b7ee0b0e9ea |
| RumbleFlameThrowerBurn.luaobj | OLS-ece9a84a-7c29-53bb-9f0c-1f017c932033 |
| RumbleFlameThrowerBurn.preload | OLS-ab0eeb0f-c0d0-59c9-8b4e-c2dc1449a3bb |
| RumbleFlameThrowerDummySpell.inibin | OLS-00c033ac-2946-507f-94c3-2e3eded395db |
| RumbleFlameThrowerDummySpell.luaobj | OLS-02167a13-ce60-5781-baec-42394bd8a517 |
| RumbleFlameThrowerDummySpellDZ.inibin | OLS-e87c44f0-0657-5529-8cff-a08c9444caad |
| RumbleFlameThrowerDummySpellDZ.luaobj | OLS-85bc623d-8963-51df-bf43-4928c086e40b |
| RumbleFlameThrowerEffect.luaobj | OLS-1450c459-8b87-5424-9867-65ce0ce11ae2 |
| RumbleFlameThrowerEffect.preload | OLS-803ee2de-41b7-55d8-916a-bfe15be3aa85 |
| RumbleFlameThrowerSpray.inibin | OLS-2478b5d3-2ea8-593d-99d4-b11877e3bbed |
| RumbleFlameThrowerSpray.luaobj | OLS-dd95f10f-4fc9-539b-a9a7-cdcb048b97f3 |
| RumbleFlameThrowerSpray.preload | OLS-7dce4521-9853-5a36-9710-29d29ff541e6 |
| RumbleFlameThrowerSpraySuper.inibin | OLS-44cd2f68-7863-5ec3-a051-2ac99075143d |
| RumbleFlameThrowerSpraySuper.luaobj | OLS-078486d6-e5e7-5252-b7f4-76b52fd53f1c |
| RumbleFlameThrowerSpraySuper.preload | OLS-ce820a65-60dd-565a-859e-11514699f741 |
| RumbleGrenade.inibin | OLS-57786f48-030b-5e9b-a2a8-51f193802b51 |
| RumbleGrenade.luaobj | OLS-8896d585-2724-57ec-9f80-a8a44c89a1a3 |
| RumbleGrenade.preload | OLS-1a0ef605-22d6-52b8-8c1b-4c592ed6726b |
| RumbleGrenadeCD.luaobj | OLS-8c736936-0e76-5b1e-a1e7-c8af3a597f87 |
| RumbleGrenadeCounter.luaobj | OLS-6e59d8b3-1cbc-5c52-9356-49b3eea4e5cb |
| RumbleGrenadeDebuff.luaobj | OLS-4f823c43-1311-52b0-a963-2c20e94da0ca |
| RumbleGrenadeDummySpell.inibin | OLS-35f5f140-4582-5d17-88cf-c3bcd8286f3c |
| RumbleGrenadeDummySpell.luaobj | OLS-0a040848-5511-53fc-b4b0-63f8f5fdcc2f |
| RumbleGrenadeDummySpellDZ.inibin | OLS-1061890b-789e-5a80-8672-2fac4603a613 |
| RumbleGrenadeDummySpellDZ.luaobj | OLS-667d749e-ef96-54df-9381-323a1a9fa106 |
| RumbleGrenadeDZ.luaobj | OLS-bf4c96de-d6d7-53b3-b6d7-a95eb575c067 |
| RumbleGrenadeMissile.inibin | OLS-7b2fe9eb-66d0-5498-8544-bb1333d3bad6 |
| RumbleGrenadeMissile.luaobj | OLS-39811ddb-7452-5a16-ae9e-60ab2c818980 |
| RumbleGrenadeMissile.preload | OLS-c9012852-5f6c-5e32-bb4f-48e6c4964941 |
| RumbleGrenadeMissileMechBase.inibin | OLS-30db93d9-4bef-512d-94e6-d273f4aca57d |
| RumbleGrenadeMissileMechBase.luaobj | OLS-ebdbfc82-a98b-51eb-8b4e-68fb39e491e2 |
| RumbleGrenadeMissileMechBase.preload | OLS-248ad051-1508-5664-88a9-6c13f768664c |
| RumbleGrenadeMissileMechDZ.inibin | OLS-e529e500-f7cc-56c6-9aba-f1c79c35e34f |
| RumbleGrenadeMissileMechDZ.luaobj | OLS-06a48505-87e7-5bf7-8f39-9da3fb3375c8 |
| RumbleGrenadeMissileMechDZ.preload | OLS-b1ea7ef1-aa79-506a-a3b7-3b9d7aa7b8fe |
| RumbleGrenadeSlow.inibin | OLS-a4997c8b-13b8-556a-a820-0894e5241eb1 |
| RumbleGrenadeSlow.luaobj | OLS-01059d77-7b87-576d-902e-994a8eaf47a4 |
| RumbleGrenadeZapEffect.luaobj | OLS-44827d96-2506-5e75-9d03-f7f13619c2b1 |
| RumbleGrenadeZapEffect.preload | OLS-b435cc1b-89e5-588e-9712-74919c4b95ba |
| RumbleHeatDelay.luaobj | OLS-4b530a94-9a5e-572c-8bfb-a27f84b21e0d |
| RumbleHeatDelay.preload | OLS-2bd47f84-39db-5e90-bd9f-f459779a6782 |
| RumbleHeatingUp.luaobj | OLS-1d3ecb88-0248-509a-abe3-a3bc13e57b92 |
| RumbleHeatingUp2.luaobj | OLS-d13551b7-30de-5f68-a335-276b0bb22794 |
| RumbleHeatPunchTT.luaobj | OLS-066a5371-9040-5bc6-978e-8a0e7fad4897 |
| RumbleHeatSystem.inibin | OLS-1bae89b6-8795-5efb-9844-89cfdd487184 |
| RumbleHeatSystem.luaobj | OLS-5c0f3be0-75f4-5058-ad67-4efbf2d9ce8c |
| RumbleHeatSystem.preload | OLS-65122e24-80fa-5e3b-8964-cf769268cfc7 |
| RumbleOverheat.inibin | OLS-0bd2e180-e07a-5c4d-b448-5f24b2b90ae8 |
| RumbleOverheat.luaobj | OLS-5fa0602b-35af-5387-976f-4389935bdf00 |
| RumbleOverheat.preload | OLS-0102230c-907d-5f80-ae5b-a49423e4763b |
| RumbleOverheatAttack.inibin | OLS-1cd0b8e4-46a7-53c3-8fca-97bd4cb54595 |
| RumbleOverheatAttack.luaobj | OLS-c58275f0-3923-5d31-b620-85cd9dbce4e2 |
| RumbleOverheatSound.luaobj | OLS-e8e64247-6050-52e7-b470-db5638259363 |
| RumbleShield.inibin | OLS-89d6f45f-ace2-5178-9b33-10f41b0c32d7 |
| RumbleShield.luaobj | OLS-dab95d54-27be-5ea8-b145-a7576bb25cc9 |
| RumbleShield.preload | OLS-faad9409-5c72-5539-bff5-a4b130bbe7d6 |
| RumbleShieldBuff.inibin | OLS-6c220f78-3882-56aa-8229-59faa4e1d2d0 |
| RumbleShieldBuff.luaobj | OLS-d7bc4f6b-7edc-5153-ba62-4ce0738edfa8 |
| RumbleShieldDummySpell.inibin | OLS-4f78a9a8-f2a2-5873-b5d9-915e7a433e49 |
| RumbleShieldDummySpell.luaobj | OLS-78eedac3-e375-5998-a3f7-bea24cf20bcc |
| RumbleShieldDummySpellDZ.inibin | OLS-a804873a-63aa-57f1-8376-cdd71756b3f1 |
| RumbleShieldDummySpellDZ.luaobj | OLS-6ebf230e-3850-5589-a8b3-c5262e6b2024 |
| RumbleCarpetBombBuffDest.luaobj | OLS-f315dc24-b96d-5bcd-846f-44f309492e12 |
| RumbleCarpetBombBuffOrder.luaobj | OLS-e5f7d8b9-35da-507b-ac63-d35ba3777751 |
| RumbleDangerZone.inibin | OLS-42edcb11-17df-5ad5-b625-2b0309ea08b5 |
| RumbleDangerZone.luaobj | OLS-016029b4-544b-596f-b344-ec90ac3e5a5a |

## Références communautaires

34 références présentes et identifiées séparément de l'autorité native et du Rust. CharScriptRumble.cs est vide. Les quatre fichiers Q/W/E/R lus ne contiennent pas HeatSystem, CurrentMana, DangerZone ou Overheat ; cela ne prouve pas l'absence de toute logique ailleurs dans le projet communautaire.

- Q : six ticks de 0.5 s, dégâts totaux 15+60×rang+AP, cône de 600. Aucune réduction spécifique de moitié pour sbires/monstres ou amplification Danger Zone qualifiée dans ce fichier.
- W : délègue RumbleScrapShield pour quatre secondes et une particule. Le texte natif distingue bouclier deux secondes et vitesse une seconde. Les valeurs du commentaire ne qualifient pas les effets réellement produits par la délégation.
- E : cône étroit de 850, première unité rencontrée, dégâts et Slow de deux secondes. La version native décrit trois secondes, cumul et deuxième tir gratuit ; le commentaire communautaire « within 4s » ne remplace pas ce texte et ne prouve pas un recast implémenté.
- R : cinq pulses espacés d'une seconde, quatre centres échantillonnés le long de 1700 unités, quart des dégâts par zone de rayon 250 et Slow de 0.5 s. Cela ne qualifie pas une ligne continue de feu, son placement natif, les recouvrements, les ticks et le ralentissement complet.

Aucun de ces scripts n'est exécuté comme serveur historique ou accepté comme consommateur Rust dans cette livraison.

## Diagnostic du moteur actuel

Véritable cœur Rust compilé hors configuration test, offline/locked, dépendances alignées avec Cargo.lock. BUILD=0, RUN=0, collecte=0, inspection=0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-rumble-passive-junkyard-titan-probe.exe` ; 6112256 octets ; SHA256 `24fd16ef49603853a6f8500b00b8c75dff0e303f055ed8f2bef4968f55332b60`.

Trois parties publiques Map10, Rumble niveau 1 contre Annie : base, Tome 1052 (+20 AP) et Saphir 1027 (+200 mana). Neuf trajets réussis sans réémission. Aucun téléport ni injection de PV, dégâts, rang, ressource ou état de surchauffe. Aucun sort Annie ou Rumble accepté dans le diagnostic.

Chaque cas : trois attaques à jauge initiale 100 ; 301 ticks d'attente ; 16 attaques physiques entrantes jusqu'à la mort ; réapparition après 480 ticks à jauge 0 ; trajet de retour public ; trois attaques à jauge 0 ; 301 ticks d'attente. Total : 18 impacts mêlée sortants, 48 entrants, trois morts/réapparitions, 1806 ticks d'attente et 81 refus atomiques.

| Cas | AP | Jauge initiale → respawn | Impacts sortants | Dégâts observés | Impacts entrants | Ticks de respawn |
|---|---:|---|---:|---:|---:|---:|
| base | 0.0 | 100 → 0 | 6 | 51.19611 | 16 | 480 |
| Tome20AP | 20.0 | 100 → 0 | 6 | 51.19611 | 16 | 480 |
| Sapphire200Mana | 0.0 | 100 → 0 | 6 | 51.19611 | 16 | 480 |

AD 61.0359992981 et dégâts physiques observés 51.19610596 dans les trois cas. Le Tome produit bien 20 AP, sans bonus magique observé sur ces attaques ordinaires. Le Saphir ne change pas le maximum de 100. Aucun refroidissement observé pendant les attentes, ni gain de chaleur sur les attaques ; ce dernier constat n'est pas présenté comme un écart, puisque le texte lie le gain aux sorts. La génération par sorts n'est pas exercée.

Rangs et cooldowns Rumble restent à zéro ; silence_until vaut zéro. Les refus couvrent acteur inconnu, attaque de soi, slot invalide, apprentissage et lancements ciblés/au sol QWER. Tous préservent le snapshot. « Non implémenté » n'est pas un refus qualifié de surchauffe. Le nombre 100 à l'apparition ne démontre pas une transition 99→100 ni un callback Overheat.

Les témoins de windup/release, projectiles entrants et dégâts corrigés de régénération sont vérifiés, y compris le plafonnement des dégâts létaux aux PV disponibles. Rumble reste niveau 1. Le lifecycle courant reset à 0 est conservé comme comportement générique observé ; il ne qualifie pas à lui seul les règles natives de mort/réapparition.

| Point | Attendu dans le contrôle | Observé | Limite |
|---|---|---|---|
| Sources | Identité et manifeste exacts | 103 ressources vérifiées | Sélection locale |
| Seuils textuels | Binding exact en_GB | 50/100, blocage 6 s | Pas de transition native exécutée |
| Refus de sorts | Erreur explicite sans mutation | 81 refus | Ne prouve pas le silence Overheat |
| Attaques courantes | Dégâts physiques ordinaires | 18 impacts identiques | Aucun bonus magique qualifié |
| Puissance | Tome augmente AP | 20 AP, dégâts ordinaires inchangés | Pas de ratio passif mesuré |
| Mana supplémentaire | Filtrage pour Heat | Maximum 100 avec Saphir | Pas de HeatSystem complet |
| Attente | Observation de la jauge | 100 puis 0 constants | Temporisation native de refroidissement inconnue |
| Mort/réapparition | Cycle public du moteur courant | 3 cycles, 480 ticks, reset 0 | Pas d'acceptation historique du lifecycle |

Non exercés : montée de chaleur, seuils 49/50/99/100, refroidissement après vrais sorts, transformation Danger Zone, blocage effectif Overheat, sortie de surchauffe, deuxième E pendant surchauffe, Q déjà actif, bonus magique, critiques, lifesteal renforcé, cibles autres que champion, niveaux supérieurs et plusieurs Rumble. Aucun rendu, audio ou transport réseau qualifié.

## Consommateurs réels

Recherche exacte Rumble/Junkyard Titan/Overheat sans occurrence dans crates/core/src, complétée par la lecture des chemins de commande, apprentissage, lancement, effets, attaque, dégâts, statistiques, régénération et réapparition. Les états et fonctions génériques sont conservés ; l'absence de branche spécifique ne signifie pas absence de tout fonctionnement du champion.

Sept entrées locales liées : catalogue, croissance, ressource, attaques, critiques, collision et boutique. Les 1158 entrées du diagnostic sont identifiées et hachées. Heat est distinct de Mana/Energy : exclusion de la restauration générique et du bonus de mana d'objet, reset générique à zéro au respawn.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current resource100;native initial Heat unresolved |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary AD61.036,AP0/20,maxHeat100 |
| crates/core/src/progression.rs:150 | unsupported Rumble learning |
| crates/core/src/progression.rs:159 | unsupported Rumble ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spells,not overheat silence proof |
| crates/core/src/annie_w.rs:29 | unsupported ground spells |
| crates/core/src/lib.rs:685 | 18 ordinary attacks,1806idle,three lifecycle cases |
| crates/core/src/lib.rs:744 | resource/state witnesses,not transport acceptance |
| crates/core/src/damage.rs:53 | ordinary damage and48incoming hits |
| crates/core/src/attacks.rs:157 | ordinary melee at100 and0;no magic bonus observed |
| crates/core/src/lifesteal.rs:4 | physical hit,not native Overheat proc |
| crates/core/src/regeneration.rs:32 | Heat excluded;no passive cooling |
| crates/core/src/regeneration.rs:10 | resource rate0 and health correction |
| crates/core/src/shop.rs:261 | public Tome/Sapphire purchases |
| crates/core/src/lifecycle.rs:33 | three public deaths/respawns,Heat reset0 |
| crates/core/src/shop.rs:215 | AP20 and mana200 item literals |
| crates/core/src/world.rs:226 | one enemy champion;other targets unexercised |
| crates/core/src/damage.rs:38 | ordinary physical mitigation controls |
| crates/core/src/attacks.rs:26 | melee release witnesses |
| crates/core/src/lifecycle.rs:16 | Heat excludes Sapphire max-mana bonus |
| crates/core/src/lifecycle.rs:24 | generic Heat nonrestoration |
| crates/core/src/ally_occupancy.rs:635 | nine public travels without reorder |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564/V606 remain open |
| crates/core/src/spells.rs:5 | effect states inspected,no Rumble overheat state |
| crates/core/src/progression.rs:40 | ordinary AD,not extra magic damage |

## Publication et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/rumble-passive-junkyard-titan-links-v621.json. Preuve : docs/fidelity_rumble_passive_junkyard_titan_links_v621.json. Instructions copiables actualisées pour les trois fiches et SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT=0. Soixante-douze associations altérées et quatre graphes invalides sont refusés. Trois fragments de traçabilité modifiés, 42212 inchangés. Chaque base conserve les 42603 autres lignes, 42607 états manuels et 23 historiques ; quatre destinataires actualisés, synchronisation idempotente vérifiée. Identifiants, hiérarchie et inconnues identiques octet par octet. Trois questions propres et quatre dépendances conservées ; aucune tâche clôturée.

Revue globale : 99161 sources, 4566 consommateurs, 4566 ancres exactes sans divergence. Revue structurelle (source_hashes_verified=0), distincte du hachage des ressources sélectionnées ; aucun recontrôle exhaustif de toutes les sources revendiqué.

Le premier générateur d'inspection a échoué à l'analyse Python sur une parenthèse supplémentaire avant création ou exécution de l'inspecteur. La copie prepare_revision621_rumble_inspection_syntax.py corrige la syntaxe ; les deux sont conservées. Inspection effective et diagnostic Rust réussis avec code 0.

coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md actualisés avec sauvegardes et conservation des preuves antérieures. Aucun stage/reset/commit ou nettoyage. Battle Training, V564/V606 et les autres inconnues restent ouverts.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision621_Rumble_discovery/OBSERVATIONS.json, revision621_Rumble_passive_probe/OBSERVATIONS.json, revision621_Rumble_inspection/OBSERVATIONS.json, revision621_Rumble/DELIVERY_AUDIT.json et revision622_trace_review/REVIEW.json.

## Travail restant

1. Qualifier la valeur initiale de chaleur, les événements de gain et les exceptions E/R.
2. Qualifier délai et taux de refroidissement, reset du délai et interaction avec les sorts actifs.
3. Qualifier Danger Zone aux limites exactes et les versions Q/W/E effectivement choisies.
4. Qualifier Overheat : entrée, durée, blocage, sortie et éventuelles exceptions du deuxième E.
5. Identifier f1/f2 du bonus magique, progression, AP, arrondis et ordre des effets.
6. Implémenter l'état autoritaire Heat/Danger Zone/Overheat dans les vrais chemins de commandes et de temps.
7. Brancher gains et variantes sur les sorts effectivement implémentés ; conserver les refus atomiques.
8. Brancher le bonus magique au véritable impact d'attaque et qualifier critique, lifesteal, boucliers et on-hit.
9. Tester 49/50/99/100, casts annulés/refusés, recasts, attaques interrompues, simultanéité et plusieurs Rumble.
10. Qualifier HeatPunchTT et la sélection effective Map10, sans déduire la politique du nom de fichier.
11. Vérifier mort/réapparition, départ/reconnexion, niveaux et catégories de cibles.
12. Vérifier séparément HUD, jauge, animations, VFX, sons et transport réseau ; lier les preuves aux fiches concernées.

## Reprise du goal

Continuer SYS-01.2-02 depuis revision622_trace_review/REVIEW.json. V621 Rumble / Junkyard Titan : 103 sources natives, 309 associations, 26 points et 52 liens. Texte natif : Danger Zone à 50, surchauffe à 100, bonus magique sur attaques et blocage des sorts 6 s ; bonus f1/f2, refroidissement et état initial non résolus. Q/W/E indiquent 20 chaleur ; E mentionne un second tir gratuit dans 3 s et R No Cost, à distinguer de la description générale chaque sort. Trois cas publics niveau 1 base/Tome1052+20AP/Saphir1027+200mana : 18 attaques ordinaires, 48 impacts entrants, 3 morts/3 réapparitions, 1806 ticks et 81 refus. Jauge initiale100 inchangée, retour0 après 480ticks, maximum100 même avec Saphir ; dégâts physiques51,1961 identiques avec AP20, aucun bonus magique observé. Aucun sort Rumble accepté, aucune transition de chaleur qualifiée ;100 numérique ne prouve pas un état de surchauffe. BUILD/RUN/inspection0. 51Lua dont23limites NEWTABLE,22preloads,16BuffData dont15résolus et DangerZone non résolu. Six bindings dummy pointent OlafRagnarok ;texte Alistar,HP400/600 et niveaux6/12/18 hérités non adoptés. CharScripts natif/communautaire vides. HeatSystem et HeatPunchTT exposent des métadonnées de persistance,non une politique Map10 ou lifecycle. Aucun DDF Rumble trouvé dans DATA ;cinq candidats absents sans conclusion globale de ressources manquantes. 34références communautaires :Q six ticks sans moitié sbires/monstres ou chaleur qualifiée ;W délégation4s contre bouclier natif2s/MS1s ;E slow2s contre3s sans second tir qualifié ;R quatre zones échantillonnées et dégâts fractionnés,non ligne native qualifiée. Aucun HeatSystem/CurrentMana/DangerZone/Overheat dans les quatre fichiers lus. Acquis génériques Heat,non-restauration,reset au respawn et V564/V606 conservés. Aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Ryze. Goal actif.
