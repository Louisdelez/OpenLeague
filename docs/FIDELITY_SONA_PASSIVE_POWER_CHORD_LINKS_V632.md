# Sona — sources du passif et limites du moteur courant, V632

Date de vérification : 2026-10-26T18:44:17.397543+00:00. Projet : `F:/OpenLeague`. Tâche active : **SYS-01.2-02**, relier les exigences aux sources natives et à leur consommateur actuel. Cette livraison enrichit les fiches `CH-Sona-PASSIF-SOURCE`, `CH-Sona-PASSIF-SIMULATION-CONTRAT` et `CH-Sona-PASSIF-SIMULATION`. Elle ne termine pas leur gameplay et ne coche aucune case.

## Résultat intégré

92 fichiers natifs sélectionnés et vérifiés contre les manifestes RADS, 276 associations aux trois exigences, 28 points de code identifiés et 56 liens aux deux fiches de simulation. Les consommateurs génériques sont qualifiés comme limites d’entrée, avec `provides_feature_consumer=false` : ils ne deviennent pas une implémentation de Power Chord. Les anciens liens, trois questions propres, quatre dépendances, critères, statuts et preuves sont conservés.

Les deux bases du plan contiennent les quatre destinataires actualisés, dont SYS-01.2-02. Les 42 603 autres lignes du catalogue, 42 607 états manuels et 23 historiques restent identiques. La synchronisation normale du Store est idempotente. Les registres d’identités, de hiérarchie et d’inconnues restent identiques octet par octet. Aucun code du jeu ni asset n’a été modifié.

Prérequis vérifiés dans le lot D06-CH-Sona : IDENTITE et PASSIF-SOURCE restent `a_qualifier`, PASSIF-SIMULATION-CONTRAT reste `a_faire`, PASSIF-SIMULATION reste `a_implementer_ou_integrer`. La simulation dépend de SOURCE et CONTRAT. L’enrichissement des sources ne clôt pas ces prérequis.

## Référence et provenance

Référence : PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue officiel 4.20.1 distinct. Déploiement lu sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

La découverte part des associations existantes et des noms de fichiers dans les répertoires globaux et propres au champion. Les 92 fichiers sont : 30 INIBIN, 37 Lua, 23 preloads, un DDF et le fontconfig en_GB. Le contenu de chacun est vérifié par taille/SHA-256 et appartenance au projet sélectionné. Aucun fichier NightmareBot retenu. CharScriptSona et Sona.ddf sont à la racine `DATA/Characters/Sona`. Les chemins alternatifs sous Scripts, Localization, Sona.en_gb.ddf et DATA/Spells/SonaPassive.inibin sont absents ; le vrai passif est dans le répertoire du champion. Ces absences ne sont pas un constat général d’assets manquants.

| Fichier | Identité du registre |
|---|---|
| Sona.inibin | OLS-d7a83c63-a973-5361-ae4a-7ba57c6ff155 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Sona.ddf | OLS-c83055af-41af-5945-8b83-e10d7d5c9484 |
| CharScriptSona.luaobj | OLS-26750998-3bf7-5266-9a93-59637de39fdb |
| CharScriptSona.preload | OLS-4461582a-3ded-5b7e-a41b-cf4093433ff1 |
| SonaAmbientESound.luaobj | OLS-3ace3ec3-8c53-565c-913d-efa4862659cb |
| SonaAmbientManager.luaobj | OLS-4c8d4c23-0f4f-5bc4-8325-f519a9fbc384 |
| SonaAmbientManager.preload | OLS-aa13f120-9181-5c54-818a-aec10e82a4d5 |
| SonaAmbientQSound.luaobj | OLS-45ccbe0d-b167-5da1-aad8-a838d4a65bb0 |
| SonaAmbientWSound.luaobj | OLS-5c4190a0-012d-57ba-bf2d-8857faf1a899 |
| SonaBasicAttack.inibin | OLS-3ba36e65-01f7-5ba4-9492-a4ec4af9fe78 |
| SonaBasicAttack.luaobj | OLS-6d4e14c7-4d86-5ab7-994c-2add807fc51a |
| SonaBasicAttack.preload | OLS-f72b1ca2-5ae4-537f-b2cf-1db28803d087 |
| SonaBasicAttack2.inibin | OLS-8781d5a0-208b-5abe-9182-626d9b88cf43 |
| SonaBasicAttack2.luaobj | OLS-01086b80-fca7-5f8b-8f4f-3b1d1a8dcc47 |
| SonaBasicAttack2.preload | OLS-98e81a07-8f59-5611-bbfb-e861598c656c |
| SonaCritAttack.inibin | OLS-1bb3c0f3-4847-5aa0-82c3-dab27fdc13a2 |
| SonaCritAttack.luaobj | OLS-bcb7aa8c-4bc3-51d0-bfd4-2be78e121fc9 |
| SonaE.inibin | OLS-212f1280-24c5-57ce-9565-f3e34ab036ff |
| SonaE.luaobj | OLS-2f4a7faa-dad5-57db-8f73-6c08b1b03e8b |
| SonaE.preload | OLS-c452cb44-37c4-5391-b2f1-380549c6edb0 |
| SonaEAttack.inibin | OLS-f0e0ffd2-e793-55a9-89ea-e3cdef4e9b07 |
| SonaEAttack.luaobj | OLS-d744a4ae-6126-533f-a238-432dcee28ccc |
| SonaEAttackUpgrade.inibin | OLS-72bcd584-810f-580d-ae26-1b041514f00b |
| SonaEAttackUpgrade.luaobj | OLS-671b814e-d2ea-5612-a59f-c45f5d2f9cec |
| SonaEAttackUpgrade.preload | OLS-4c3122b5-d7fa-5131-b413-6b2066f7f83b |
| SonaEHaste.inibin | OLS-fba489d9-72ca-542a-839f-a8e18b3e99be |
| SonaEHaste.luaobj | OLS-d1adeb31-3aa3-5d90-a71d-223b332e95f3 |
| SonaEHaste.preload | OLS-e4113c50-1f5f-5479-be60-01e789995e45 |
| SonaEPassiveCheck.luaobj | OLS-1caf846b-ff35-5ff5-b425-ed48f1058d21 |
| SonaEPassiveCheck.preload | OLS-fd3eb147-a1d5-5df9-8666-1c3d876b3049 |
| SonaEPCDeathRecapFix.inibin | OLS-056c8790-6545-576d-a3ac-90e11eab146f |
| SonaEPCDeathRecapFix.luaobj | OLS-3d708afb-d88f-57d1-81d8-1d078f70a3be |
| SonaEZone.inibin | OLS-57dec5d4-2be6-5f41-bc6e-97830e5e5c01 |
| SonaEZone.luaobj | OLS-f42825bd-2d2f-5dc3-bbdd-c99afaa0afd8 |
| SonaEZone.preload | OLS-3a933bc4-857f-59a0-b354-90519980a090 |
| SonaPassive.inibin | OLS-9adc4600-a756-526a-85e8-388790b694e4 |
| SonaPassive.luaobj | OLS-d41e4822-6124-5211-bd61-b23e9cc3d2d7 |
| SonaPassiveAttack.luaobj | OLS-06b6416d-fe70-5223-9ae6-a5dcaadbb3ef |
| SonaPassiveCount.inibin | OLS-826e9607-6f1d-57d8-b758-6b958d07ef5f |
| SonaPassiveCount.luaobj | OLS-19e09eae-7442-5eb6-82da-29a74d329a8f |
| SonaPassiveCount.preload | OLS-efa3296d-d5f5-587a-bc18-c2d6f019e2c7 |
| SonaPassiveDebuff.inibin | OLS-01dcc80d-4321-5fd0-b018-951f6a84a36e |
| SonaPassiveDebuff.luaobj | OLS-affad9c0-2c00-56ad-9441-f3a7b8f25ee3 |
| SonaPassiveReady.inibin | OLS-3a054cb1-592c-511d-91b2-83edca056d90 |
| SonaQ.inibin | OLS-5d12163e-1d46-5c37-9864-9f0dd57c06ce |
| SonaQ.luaobj | OLS-ea5e02b1-e1df-5ef2-810e-702b3982bd30 |
| SonaQAttack.inibin | OLS-b88dc099-7654-597a-b5dc-27133a30d831 |
| SonaQAttack.luaobj | OLS-2cfe5800-0032-5b97-b5e6-03b2b4567dc7 |
| SonaQAttackUpgrade.inibin | OLS-a0259703-3095-568e-b2fd-6bb3f3feac73 |
| SonaQAttackUpgrade.luaobj | OLS-adb7e8e6-183c-5421-bd22-90def94e967b |
| SonaQAttackUpgrade.preload | OLS-1d1dbb24-1810-516e-9cfa-7252f3309408 |
| SonaQMissile.inibin | OLS-318bafe9-5f6d-5676-9a7a-988d4e081012 |
| SonaQMissile.luaobj | OLS-93ad998b-f8ef-592a-bc65-1a46a6f5e118 |
| SonaQMissile.preload | OLS-1569bb06-e9d8-5987-8c5b-effd8b726e0f |
| SonaQPassiveCheck.luaobj | OLS-17acb25c-b8a9-586b-b671-dd51b91c5957 |
| SonaQPassiveCheck.preload | OLS-c597aa73-8845-5fb9-a57a-6e441aa25bbf |
| SonaQPCDeathRecapFix.inibin | OLS-60ea6ab6-0a62-51bd-9f66-72e5f76d045e |
| SonaQPCDeathRecapFix.luaobj | OLS-897dfd1f-506f-5f18-a6af-016688c7cba5 |
| SonaQProc.inibin | OLS-fc950f42-d362-5970-9095-f607c9ee671b |
| SonaQProc.luaobj | OLS-884b6665-327e-51d7-8268-74d4c1feff52 |
| SonaQProc.preload | OLS-9d305e99-b663-5c66-a4a6-2fbc07defdfd |
| SonaQProcAttacker.inibin | OLS-a66884fc-c83f-5258-8a75-d4b1a5b08109 |
| SonaQProcAttacker.luaobj | OLS-f0177ae0-8e8f-504f-95a2-ec573e268ee6 |
| SonaQProcAttacker.preload | OLS-e04c4bf1-1425-5f5f-a5d1-5afb480ae9ae |
| SonaQZone.inibin | OLS-5ef6e372-c984-5fb7-bc77-4c3cebc76ce4 |
| SonaQZone.luaobj | OLS-f10b3c68-53cb-5363-98bc-cd3212373999 |
| SonaQZone.preload | OLS-ef323ce2-b02b-5b66-a8cd-13bb8197f17b |
| SonaR.inibin | OLS-03103f4d-3493-54e5-957e-c887a0839a49 |
| SonaR.luaobj | OLS-e8cf13be-5543-50cd-a823-e3d0b96d62fd |
| SonaR.preload | OLS-a1fd6f69-88c3-5126-9b19-094e603cae2d |
| SonaW.inibin | OLS-3d504f12-fe01-5049-9d76-1fbef31a7ed5 |
| SonaW.luaobj | OLS-66dd1378-b49b-5796-bcfd-0a65aa2acca8 |
| SonaW.preload | OLS-af375356-3ab4-5c78-9f82-e1ebcfc82d55 |
| SonaWAttack.inibin | OLS-00221435-079d-546e-860f-56d669c19f18 |
| SonaWAttack.luaobj | OLS-e5b06102-dea1-5250-a80e-6ea85e131fe4 |
| SonaWAttackUpgrade.inibin | OLS-082796fd-0865-5f2e-924e-9e9081a36231 |
| SonaWAttackUpgrade.luaobj | OLS-63384d15-4d9d-59ac-bff6-54cd5535535e |
| SonaWAttackUpgrade.preload | OLS-9599f568-37e5-5cbd-b4c3-f3610f00eb52 |
| SonaWMissile.inibin | OLS-0b2eb7d3-4006-55e7-9c01-ce39332ef906 |
| SonaWMissile.luaobj | OLS-01f561b9-e699-561e-a055-9a0c2b9557e7 |
| SonaWMissile.preload | OLS-0c44e189-6fd2-5082-b82a-5de0b4a756e7 |
| SonaWPassiveCheck.luaobj | OLS-cb26fb1a-8044-5674-8450-537833087306 |
| SonaWPassiveCheck.preload | OLS-32c636b1-a08f-5ab6-8862-48cab75c772b |
| SonaWPCDeathRecapFix.inibin | OLS-5e46787b-00fd-5bd5-bb98-3d80283b63fb |
| SonaWPCDeathRecapFix.luaobj | OLS-06e18823-61a6-5f89-89d2-69aa1c122a5f |
| SonaWShield.inibin | OLS-051f1220-9e0a-5fca-a6cc-d83fa385688b |
| SonaWShield.luaobj | OLS-74b42980-88ed-5103-af05-e6fb0bd91dcb |
| SonaWShield.preload | OLS-945d69f6-1609-593b-ae31-18cc57aedd56 |
| SonaWZone.inibin | OLS-b63c1d08-8daf-57c2-8b9d-534a02e90a20 |
| SonaWZone.luaobj | OLS-07367b66-3e8b-5c72-a3d5-1cfcb154679c |
| SonaWZone.preload | OLS-1acc47d4-6f80-53ae-bcfd-f8ddac11e8b0 |

## Contrat natif établi et limites

Les tooltips de SonaPassive et SonaPassiveCount précisent **trois sorts hors ultime**. La prochaine attaque inflige des dégâts magiques supplémentaires f1 + f2 et un effet dépendant du dernier chant activé. La description courte parle seulement de trois sorts ; l’omission est conservée, sans en déduire que R alimente le compteur. Les noms de variables de texte ne donnent pas leurs producteurs ni leurs formules.

Sona.inibin sélectionne SonaQ/W/E/R, Passive1LuaName=SonaPassive et l’icône Sona_Passive_Charged.dds. Les marqueurs Passive1Level1=8 et Passive1Level2=15 sont présents ; les suivants sont absents. Ils ne suffisent pas à définir une progression de dégâts. Les valeurs de base observées sont HP 482,3599853515625, MP 340,6000061035156, AD 50,040000915527344, armure 20,54400062561035, vitesse 330 et portée 550. PARType et Passive1Desc sont absents ; ils ne sont pas remplacés par des valeurs inventées.

Les correspondances texte/champs suivantes sont établies aux cinq rangs Q/W/E :

| Variante | Correspondance native | Ce qui reste à qualifier |
|---|---|---|
| Staccato, Q | Effect6=50 ; le texte indique +50 % de dégâts Power Chord | Dégâts de base, ordre d’amplification et consommation effective |
| Diminuendo, W | Effect4=20 % de réduction de base ; Effect10=3 secondes ; bonus de texte f1 | Producteur f1, dommages concernés, ordre et interactions |
| Tempo, E | Effect4=40 % de ralentissement de base ; Effect8=2 secondes ; texte CharAbilityPower2 | Calcul effectif AP, application, durée et empilement |

Le bonus de prochaine attaque de l’aura Q est distinct de Power Chord. Le passif de R améliore les auras : il n’est pas une preuve que R compte parmi les trois sorts. Les formules complètes de f1/f2, les producteurs du compteur, les casts admissibles, le choix du chant quand le passif est prêt et la consommation ne sont pas retrouvés par cette livraison.

Les 37 Lua sont lus entièrement, sans prototypes de fonctions enfants. Le lecteur littéral rencontre 26 limites NEWTABLE, conservées comme telles. CharScriptSona et les scripts Q/W/EPassiveCheck ont des initialisations vides. SonaPassive déclare nom, icône et PersistsThroughDeath ; ce dernier est une métadonnée, pas une qualification du comportement après la mort. SonaPassiveAttack porte BuffName=SonaPassiveReady, alias préservé. Les Q/W/EPCDeathRecapFix déclarent IsDeathRecapSource=true ; cela ne démontre pas les dégâts.

Les 11 références BuffData ont une traduction exacte. Sona.ddf contient 16 lignes, aux anciens noms HymnofValor/AriaofPerseverance/SongofDiscord/Crescendo, toutes sans lien ni coefficient. Ce fichier ne résout pas les variables actuelles du passif. Les preloads des attaques améliorées citent les particules, `sonapassivedebuff`, `slow` et des helpers ; charger un nom ne prouve ni un effet exécuté ni une présentation complète.

## Références communautaires inspectées

35 fichiers sont conservés comme références, sans exécution C# ni promotion en source du serveur historique. CharScriptSona est vide. Dans les scripts sélectionnés :

- Q : dégâts `40 × rang + coefficient AP`, deux ennemis les plus proches à 850. La priorité aux champions et l’aura native ne sont pas démontrées par ce fichier.
- W : soin `15 + 20 × rang + 0,2 AP`, soit 35–115 ; le tooltip natif pointe Effect2=30–110. Le commentaire communautaire 0,25 AP diffère du code 0,2. Le script choisit l’allié au plus faible ratio de vie dans 1000 et soigne aussi Sona ; l’amplification liée aux PV manquants et le bouclier de zone ne sont pas démontrés.
- E : appelle SonaSpeedBoost pour 1,5 seconde sur Sona et les alliés à 1000. La recherche exacte sur tous les `.cs` du périmètre LeagueSandbox-Scripts ne trouve que les deux appels dans E.cs, aucun producteur. Un éventuel montage externe n’est pas qualifié ; aucune valeur de vitesse n’est inventée.
- R : dégâts 150/250/350 plus le coefficient AP, rayon 1000 avec filtre angulaire dot>=0,95 et Stun 1,5 seconde. Ce cône instantané ne démontre pas le projectile rectiligne ni les améliorations d’auras du texte natif.

## Consommateur courant et diagnostic réellement exécuté

La recherche pinée dans `crates/core/src/**/*.rs` ne trouve pas Sona, Power Chord, Staccato ni Diminuendo. Les points d’entrée du moteur sont lus et liés précisément. Les attaques ordinaires utilisent les profils du catalogue, les projectiles et basic_attack_hit. L’apprentissage et les casts propres à Sona sont refusés. Le slow générique n’est pas déclenché par Tempo dans ce diagnostic ; la réduction de dégâts d’Exhaust reste propre à Exhaust et ne vaut pas implémentation de Diminuendo.

| Point actuel | Portée constatée |
|---|---|
| crates/core/src/lib.rs:533 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Sona ordinary ranged attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:159 | actual ordinary projectile traversal;not charged Power Chord variant |
| crates/core/src/slows.rs:74 | generic slow boundary;not invoked for Sona Tempo in this diagnostic |
| crates/core/src/slows.rs:78 | generic slow expiry,not Sona Tempo acceptance |
| crates/core/src/summoner_exhaust.rs:38 | Exhaust-specific reduction branch;must not be counted as Diminuendo |

Le diagnostic privé utilise le vrai crate core de F:/OpenLeague, dans son profil non-test, avec dépendances alignées sur le Cargo.lock courant. 1 158 fichiers d’entrée et les preuves antérieures sont contrôlés avant/après. Il utilise uniquement les commandes publiques de connexion, mouvement, arrêt, achat/vente/rachat, attaques et tentatives de sorts. Aucun état de charge ni dégâts n’est injecté.

Binaire exécuté : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-sona-passive-power_chord-probe.exe` ; 6073856 octets ; SHA-256 `52226d50c084ae42c184995e8873ab9a972938f073a90d43aab9829e6b41dac2`. Les chemins de sources, Cargo.toml/Cargo.lock, compilateur, commandes exactes et journaux sont dans le reçu du diagnostic.

| Cas niveau 1 | AP | Impacts ordinaires | Premier dégât observé | Ticks au repos | Refus atomiques |
|---|---:|---:|---:|---:|---:|
| base | 0.0 | 6 | 41.972839 | 181 | 27 |
| Tome20AP | 20.0 | 6 | 41.972839 | 181 | 27 |

Attendu pour le chemin générique : six projectiles uniques et impacts ordinaires par cas, dégâts physiques calculés depuis le projectile et l’armure, régénération prise en compte ; le Tome ne modifie pas l’AD. Observé : 12 impacts, dégâts 41,972808837890625 à 41,97283935546875, résidu absolu inférieur à 0,002. AD inchangée 50,040000915527344 ; AP 0/20 ; mana à son maximum 340,6000061035156. Les deux cas restent niveau 1, vivants, sans stun/slow ni sort propre accepté.

Quatre trajets aboutissent sans réordre. Le cas Tome contient achat, vente puis rachat effectifs. Chaque cas exerce avant/après les refus Learn/Cast/CastAt sur les quatre emplacements, plus joueur inconnu, auto-attaque sur soi et emplacement invalide : 54 refus, instantanés inchangés. Les 362 ticks au repos ne sont pas un test d’expiration du passif. La garde de ressources ne démontre pas les dépenses d’un sort qui n’a jamais été accepté.

Erreurs réellement observées : `champion skill progression not implemented`, `champion spell not implemented`, `champion ground spell not implemented`, `unknown player`, `invalid enemy target` et `invalid skill slot`. Les refus de sorts signalent ici une limite d’implémentation, sans démontrer un manque de textures ou de modèles.

**Aucun des trois casts nécessaires n’est accepté. Le compteur et le passif prêt ne sont donc pas exercés.** Les résultats n’établissent ni que Power Chord fonctionne, ni qu’un proc correctement chargé échoue. Ils qualifient les commandes disponibles et la limite du moteur à l’entrée des sorts.

## Publication et contrôles

Découverte, BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH et AUDIT : codes retour 0. Les contrôles de publication refusent 72 associations altérées et quatre graphes invalides. Les trois courts aperçus de traçabilité changent uniquement pour les trois fiches Sona ; les quatre textes complets et objets du plan sont actualisés. Les liens de dépendance et propriétaires des questions restent consultables par les vrais lecteurs Store et rt.resolve.

La relecture globale vérifie 99 205 sources référencées et 4 837 points de consommation, dont les ancres sont exactes sans divergence. Il s’agit d’une revue de graphe et de points de code : le champ global `source_hashes_verified=0` ne revendique pas un re-hachage de toutes les sources. Le contrôle de contenu porte sur la sélection et les entrées pinées décrites ci-dessus. Les 26 189 questions ouvertes et 5 517 questions résolues avec historique sont conservées.

Fichiers publics enrichis : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/sona-passive-power_chord-links-v632.json ; preuve docs/fidelity_sona_passive_power_chord_links_v632.json ; présent rapport ; docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json et docs/ai/CURRENT.md/HANDOFF.md. Les bases sont runtime/project-plan/plan.sqlite3 et la base de l’application installée sous AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Sauvegardes et scripts exacts : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision632_Sona`.

## Inconnues et travail restant

Retrouver les producteurs des dégâts/AP/progression, qualifier le compteur 0/1/2/3 et l’exclusion de R, le dernier chant quand prêt, les casts refusés/annulés, l’attaque lancée/annulée/bloquée et la consommation. Puis qualifier séparément chaque variante, dégâts/contrôles/durées, cibles, propriétaires multiples, niveaux, ordre simultané, boucliers/invulnérabilité, mort/réapparition/reconnexion, HUD/VFX/sons/animations et transport réseau. Les ressources importées et les mécanismes génériques ne remplacent pas ces preuves. Les limites antérieures V564/V606 restent ouvertes.

La tâche active SYS-01.2-02 et le goal restent incomplets. Les statuts et critères d’origine sont conservés.

Continuer SYS-01.2-02 depuis revision633_trace_review/REVIEW.json. V632 Sona / Power Chord : 92 fichiers natifs, 276 associations, 28 points et 56 liens. Trois sorts hors ultime chargent la prochaine attaque ; dégâts magiques f1+f2 et variante du dernier chant. Q Staccato : +50% de dégâts du passif ; W Diminuendo : réduction de base20%,3s ; E Tempo : ralentissement de base40%,2s. Les producteurs de dégâts,progression,AP etcompteur restent ouverts. 37Lua dont26 limites NEWTABLE,23preloads,11BuffData traduits ;DDF16lignes vides etanciens noms. Passive1Level8/15 ne suffit pas à établir les dégâts ;metadata persistante non assimilée au cycle de mort. 35références communautaires :CharScript vide,Q sans priorité champions ni aura démontrée,W35–115 contre soin natif30–110 etsans amplification PV manquants/bouclier démontrés,E appelle SonaSpeedBoost sans producteur retrouvé dans les scripts sélectionnés,R cône etpas de bonus aux auras démontré. Deux cas publics base/Tome20AP :12attaques à distance ordinaires avec projectiles,54 refus,362ticks au repos,quatre trajets etachat/vente/rachat. Aucun sort Sona accepté :compteur,attaque chargée,Staccato/Diminuendo/Tempo non exercés. BUILD/RUN/inspection0 ;états,cases,inconnues etpreuves antérieures conservés,aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Soraka. Goal actif.
