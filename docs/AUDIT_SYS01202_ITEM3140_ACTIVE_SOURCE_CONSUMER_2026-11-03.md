# SYS-01.2-02 — Quicksilver Sash 3140 : purification et refus courant

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3140-ACTIVE-SOURCE-CONSUMER-01`. Audit statique source → consommateur/refus : **79/79 contrôles ciblés, revue indépendante PASS**. L'actif historique, le ciblage, les règles de purification et le jeu restent ouverts.

## 1. Contrat et périmètre

`ITEM-3140-SERVER-ACTIF`, exigence `OLF-abec7824-42d0-598e-b181-84fb56ca316a`, demande l'actif, le ciblage et la récupération de Quicksilver Sash. État courant : `a_faire`, `required=false` conditionnel, implémentation/acceptation fausses ; prérequis `ITEM-3140-SCOPE` à `a_qualifier`. La phase D07 et le lot `D07-ITEM-3140` n'ajoutent pas de dépendance et ne résolvent pas ce prérequis.

Question : **quelles sources décrivent la purification de 3140, quelles ambiguïtés subsistent dans leurs délais et textes, et où aboutit sa commande d'utilisation dans le code actuel ?** Critères de sortie : identifier les sources et leurs limites, le chemin réel/refus, les recherches infructueuses, l'attendu/observé et l'entrée de reprise. Prix, recette, statistiques ordinaires, admission historique Map10, rendu et autres objets ne sont pas clos. Le préflight n'a trouvé aucun rapport dédié 3140 ; V1176/3142 est réutilisé pour les consommateurs génériques inchangés.

## 2. Sources natives et provenance

Référence : **PUBLIC 4.20.0.315, EUW/en_GB**, `docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`. Racine originale : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/`.

Le manifeste agrégé contrôlé est `F:/OpenLeague/data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest`, 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. Le dossier de déploiement, le manifeste agrégé et les releases de membres ci-dessous ont des rôles distincts.

| Fichier sous DATA | Octets | SHA-256 | Release membre |
|---|---:|---|---|
| `Items/3140.inibin` | 549 | `c3567f751434ddf340bf1d03bf38d24432cd51b3d22205eb5fbc9cfe448ec668` | `0.0.1.7` |
| `Spells/QuicksilverSash.inibin` | 642 | `c9e873260b147012cf6e36546aca0b3b1867c2f7322f1efc4497f8d3729dabef` | `0.0.1.4` |
| `Spells/QuicksilverSash.luaobj` | 222 | `90fd121760f2c6559885a851504cd4551550b931ebb2b1aa636927df46456d86` | `0.0.0.254` |
| `Spells/QuicksilverSash.preload` | 221 | `5a884059cdc28a75cf944f49a33c5f243c7b3ebb648bc4f3b9d13796235e9580` | `0.0.0.254` |
| `Spells/ItemMercurial.inibin` | 681 | `0c129eb9c2adec9f018cf2c06b1aca838a01179d99f08bbdf98d8165d75643c6` | `0.0.1.7` |
| `Spells/ItemMercurial.luaobj` | 386 | `a8d336c7f96d8be9020e91f40dc0cef37ab31a9b7eb4d626d159224433d50c10` | `0.0.0.254` |
| `Spells/ItemDervishBlade.inibin` | 687 | `c94183c4fcc4515ca1f5085c830170292f0d96aa71c3c4112191b625081f43b3` | `0.0.1.7` |
| `Spells/ItemDervishBlade.luaobj` | 384 | `f50c594a3a4c898096a652bc7d26ab4fba34de6bbdf037900753c04238f04dee` | `0.0.0.254` |
| `Particles/summoner_cast.troybin` | 1 128 | `05b69aafa396e90a36b6c4a8fd3d4c4cdee80f21db979210d80688009289afde` | `0.0.0.235` |

Le validateur vérifie taille/SHA, source ID/chemin et taille/MD5 des membres. Chaque chemin demandé possède exactement un membre après comparaison `casefold`. La dernière ressource est enregistrée par le manifeste sous **`DATA/Particles/Summoner_Cast.troybin`**, alors que le chemin physique demandé est `DATA/Particles/summoner_cast.troybin`. Cette comparaison sur l'hôte Windows n'établit ni la politique de casse du VFS historique ni sa priorité de montage. Le contenu graphique n'est pas interprété ou rendu.

`Items/3140.luaobj` et `Items/3140.preload` sont absents du déploiement inspecté **et** des entrées du manifeste agrégé, même après comparaison sans distinction de casse. Ils ne sont pas déclarés corrompus ni nécessaires à reconstruire. Le binding disponible vient de l'INIBIN : `SpellName=QuicksilverSash`, `UseEffect=1`, `Effect1Amount="90"`, source `OLS-9b57c5fa-7497-5082-9df5-90947c771e3a`.

Le sort lié, source `OLS-5ba5b3d9-d543-5d6a-9218-45ac7939cfa1`, déclare pourtant **`SpellData.Cooldown="60.0000"`**, `CastRange="200.0000"`, `InventoryIcon=Summoner_boost.dds`, `Flags=329748`, `CanCastWhileDisabled=1`, `CannotBeSuppressed=1`, `IsDisabledWhileDead=1`, `TargettingType="0"`. Ces champs sont des métadonnées natives, pas une exécution de l'activation sous chaque contrôle. La portée, le ciblage et les exceptions ne sont pas dérivés de leurs seuls noms.

Le LuaObj du sort est entièrement parsé : 11 instructions d'initialisation, zéro prototype de callback ; seules cinq valeurs littérales sont établies (`NotSingleTargetSpell`, `DoesntBreakShields`, `DoesntTriggerSpellCasts` vrais ; `CastingBreaksStealth`, `IsDamagingSpell` faux). Aucun corps serveur de purification n'est obtenu. Son preload nomme directement `summoner_cast.troy`, `itemmercurial`, `itemdervishblade`. Ces deux ressources liées déclarent chacune un cooldown 90 et des métadonnées de buff pour les icônes **3139** et **3137** ; leur simple préchargement n'établit pas leur sélection, une application de leurs bonus à 3140, ni le comportement de ces autres objets.

## 3. Textes distincts, miroir et recherche communautaire

Le fichier original `DATA/menu/fontconfig_en_GB.txt`, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, donne ligne **6783** « Removes all debuffs (90 second cooldown) » pour l'objet et ligne **7547** son nom. Le cache officiel **4.20.1/en_US** `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, a la même description et `Effect1Amount="90"`. Il reste distinct du client 4.20.0.315 ; l'entrée ne possède pas de clé `maps`.

Autre ambiguïté directe : `QuicksilverSash.inibin` lie ses champs `DisplayName`, `Description`, `DynamicTooltip` aux clés **SummonerBoost**, pas aux clés item3140. Le texte original associé, ligne **9808**, décrit le sort **Cleanse** (nom ligne **10527**) : suppression des disables et debuffs de sorts invocateur, puis réduction des disables entrants de **65 % pendant 3 secondes**. Le tooltip ligne **11889** conserve `@f1@` et `@f2@`. Le texte item « all debuffs/90 » et les chaînes Cleanse ne sont pas fusionnés : aucune immunité de trois secondes, réduction de contrôle, sélection UI ou matrice de purge QSS n'est déduite de ces bindings. De même, **item/texte90 et champ sort60 restent des valeurs à rôle/priorité non qualifiés**.

Un miroir communautaire de données existe : `D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Default/Spells/QuicksilverSash/QuicksilverSash.json`, 2 525 octets, SHA-256 `ea1a033eca07a1de1c1c18d0c7176ffbd6892f2e6f02dd33c2052619eae6621a`, source `OLS-c6161ca7-19b1-5a02-90f8-b6f227077180`, type `community_native_data_mirror`. Il reprend le chemin natif, le cooldown60 et les bindings SummonerBoost. C'est un miroir de métadonnées, pas un script serveur de purification ni une autorité Riot.

Recherche locale reproductible : **799 fichiers `.cs`** sous `D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Scripts`, noms et contenus sans distinction de casse, termes exacts `quicksilversash`, `itemmercurial`, `itemdervishblade`, `summonerboost` : aucun résultat. Une occurrence numérique « 3140 » dans des coordonnées de carte n'est pas traitée comme un script d'objet. La conclusion porte seulement sur cet arbre et ces symboles.

Le parent `/root` a aussi effectué les recherches publiques ciblées consignées dans `external_search_observation.json` : quatre requêtes du connecteur GitHub sur LeagueSandbox/LeagueSandbox-Scripts (QuicksilverSash, SummonerBoost, RemoveAllDebuffs), et deux requêtes web exactes QuicksilverSash/QuicksilverSash.cs. Pour la première requête GitHub, seul le contenu « Action completed » a été inspecté ; son résultat structuré reste inconnu. Les trois suivantes ont un résultat structuré vide confirmé ; les deux recherches web étaient vides. Aucune source exécutable n'a été récupérée. Ce fichier est une **transcription de l'observation du parent**, sans faux identifiants bruts ou URL. Couverture de l'index et des droits d'accès inconnue : aucune absence globale n'est affirmée. Ne pas répéter ces recherches sans dépôt, branche, nom ou artefact nouveau.

## 4. Consommateurs actuels, refus et limites

Le chemin réellement inspecté est `main.rs:1439-1441 item_hotkey` → `Action::UseItem {slot}` → `lib.rs:615 Simulation::command` → `consumables.rs:8-13 use_item`. Les quatre fichiers (`main`, `lib`, `consumables`, `shop`) ont exactement les SHA épinglés par le reçu V1176/3142 ; cette liaison générique est réutilisée, sans test identique relancé.

**3140 est absent du catalogue et du fichier d'admission Map10.** Pour un slot hérité contenant 3140 dans un contexte passant les gardes antérieures, `use_item` retourne `item behavior not implemented` au lookup catalogue avant le contrôle d'actif, la politique de stun et toute mutation du corps inspecté. Un item présent sans `consumable` atteint l'autre refus `item active not implemented`. Fin de partie, propriétaire inconnu, mouvement forcé, mort, slot invalide/vide peuvent arrêter plus tôt. L'absence d'admission n'est pas une décision historique `false`.

La politique d'activation sous stun consultée dans ce chemin ne traite actuellement que les noms des deux potions après résolution du catalogue. `disabled_cast_rules.json` n'a aucune clé QSS/Mercurial/Dervish/Boost ; le champ original `CanCastWhileDisabled=1` n'est donc pas consommé pour cet objet. L'énumération inspectée des sorts invocateur ne fournit pas Cleanse. Le nettoyage des `Effects` et `stuns` à la mort dans `lifecycle.rs` est un autre événement et ne constitue pas l'actif QSS.

Recherche Rust délimitée : fichiers `.rs` de `crates/core/src`, `crates/client/src`, `crates/server/src`, motifs `\b3140\b|QuicksilverSash|ItemMercurial|ItemDervishBlade|SummonerBoost|cleanse|dispel` sans distinction de casse : aucun résultat ; nombre exact/racines dans le reçu. Une route sous un alias non recherché n'est pas exclue.

La trace conserve seulement le native_input item3140 et `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b`, qui est le refus **d'achat** dans `shop::quote_with_counts`, pas le handler d'usage. Les sources de sort et le trajet `use_item` ne lui sont pas liés précisément. `associated_sources_and_current_entrypoints`, `unknown_ids=[]`, `game_behavior_accepted=false` restent inchangés ; une liste d'inconnues vide ne résout pas la purification ou le choix60/90.

## 5. Attendu, observé et vérifications

| Cas | Attendu de l'audit | Observé et portée |
|---|---|---|
| Source nominale | Item → sort et références directes identifiés | Neuf fichiers exacts/source IDs/manifestes ; pas de serveur exécuté |
| Compagnons item absents | Vérifier l'absence sans supposer corruption | Aucun LuaObj/preload item3140 dans deploy ou manifeste agrégé |
| Textes et cooldowns | Garder les rôles distincts | Item/texte90, sort60 ; bindings Cleanse65%/3s séparés ; aucune priorité décidée |
| Slot hérité3140 valide | Décrire le refus réel et ses gardes | Lookup catalogue refuse avant actif/mutation dans `use_item` ; scénario non exécuté |
| Activation sous contrôle | Ne pas promouvoir un champ en matrice testée | Métadonnées disabled/suppression présentes ; handler3140 et purge non qualifiés |
| Communauté | Identifier une source ou borner la recherche | Miroir de données présent ; aucun script retrouvé dans le périmètre nommé ; recherches publiques sans résultat exploitable |

Commande exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3140_active_20261103/validate_item3140_active.py` → **PASS_STATIC_SCOPE79/79**. Elle lit D/F, désactive le bytecode avant imports F et écrit seulement `result.json` sur E. Elle vérifie identités, unicité des membres après comparaison de casse, métadonnées/textes/versions, miroir, recherches locales, trace, gardes et réemploi par SHA. Aucun code Rust, compilation, jeu, rendu, réseau, REA, script communautaire ou acceptation humaine n'est exécuté ici. La transcription des recherches publiques n'est pas une seconde exécution de celles-ci par le validateur.

## 6. Écarts, correction existante et reprise

Réutiliser `ITEM-3140-SERVER-ACTIF` et son prérequis `ITEM-3140-SCOPE`. Entrées requises : autorité de disponibilité historique ; lecteur/callsite original déterminant cooldown/overrides et binding effectif ; corps serveur attribuable ou observation reproductible fixant la matrice de purification, le ciblage et les exceptions. Les bindings vers Cleanse ne prouvent ni que tous les debuffs sont effectivement retirés, ni que ses autres effets sont ceux de QSS.

Après qualification du contrat, un lot d'implémentation autorisé devra relier l'actif au vrai système d'objets et vérifier : activation valide, contrôles/mort/mouvement forcé selon politiques qualifiées, familles de debuffs pertinentes et refus de retrait des états hors contrat, ciblage, cooldown, absence de mutation sur refus, mort/reconnexion et traces réseau/rendu nécessaires. Ces scénarios sont des critères futurs à préciser avec les sources, pas des résultats natifs acquis. Un nouvel artefact serveur, callsite, dépôt/branche communautaire ou changement du consommateur justifie une reprise ciblée ; les mêmes recherches inchangées sont arrêtées.

Sept rubriques présentes : exigence/frontières ; sources/provenance/limites ou recherches infructueuses ; consommateurs/recherche bornée ; attendu/observé/contrôles ; écarts ; correction/critères ; preuves datées/relecture. **Audit de liaison statique clos après revue indépendante PASS ; implémentation3140 non qualifiée ; vérification statique79/79 ; acceptation humaine non donnée.** La tâche, SCOPE, SYS-01.2-02 et le jeu restent ouverts.

Livrables préparés seulement sur E : ce rapport, `validate_item3140_active.py`, `result.json`, `external_search_observation.json` et publisher documentaire protégé. La publication F du rapport et de deux notes est réservée au parent après revue/empreintes. Aucun Goal, Plan, interface, application, base, registre protégé, code produit, asset, installation ou migration n'est modifié par cette préparation.
