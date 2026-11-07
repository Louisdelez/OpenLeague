# SYS-01.2-02 — Mercurial Scimitar 3139 : purification, déplacement et refus courant

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3139-ACTIVE-SOURCE-CONSUMER-01`. **Audit documentaire borné clos après 65/65 contrôles statiques et relecture indépendante PASS.** L'actif historique, sa matrice de purification, l'exécution du bonus de déplacement et la tâche fonctionnelle restent ouverts.

## 1. Question, contrat et frontières

La tâche `ITEM-3139-SERVER-ACTIF`, exigence `OLF-d0c532b3-79bc-507f-83bf-6db382a1ca1e`, demande l'actif, le ciblage et la récupération de Mercurial Scimitar. Elle reste `a_faire`, `required=false` conditionnel, avec implémentation/acceptation fausses. Son prérequis `ITEM-3139-SCOPE` est `a_qualifier`. Phase D07 et lot `D07-ITEM-3139` n'ajoutent pas de dépendance et ne résolvent pas celle de la tâche.

Question bornée : **quelles sources propres à 3139 déclarent la purification et le déplacement, comment les distinguer des métadonnées Cleanse/QSS, et où aboutit la commande d'utilisation actuelle ?** Sortie attendue : identités et limites des sources, consommateur réel/refus, attendu/observé, preuves réutilisées et conditions de reprise. Le scope historique Map10, les statistiques ordinaires/prix/recettes, les autres objets et le rendu ne sont pas clos. Aucun rapport dédié 3139 n'a été trouvé dans le préflight ciblé. V1177/3140 est réutilisé pour les ressources partagées, le chemin d'usage et les recherches datées ; son audit ne clôt pas le présent objet.

## 2. Sources natives et identités

Référence du dépôt : **PUBLIC 4.20.0.315, EUW/en_GB**, selon `docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`. Racine originale sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/`.

Le manifeste agrégé relu est `F:/OpenLeague/data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest`, 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. Le dossier de déploiement, le manifeste agrégé et les releases des membres ont des rôles distincts. Le validateur compare directement les sept ressources par taille/SHA, leurs sources enregistrées et le membre unique après comparaison `casefold`, avec taille/MD5.

| Fichier sous DATA | Octets | SHA-256 | Release membre |
|---|---:|---|---|
| `Items/3139.inibin` | 593 | `8345efbd94ffdd7c4bd617e5f2ca3fe8f4e4f1beb1e1e3ff7148950909a4a95c` | `0.0.1.7` |
| `Spells/ItemMercurial.inibin` | 681 | `0c129eb9c2adec9f018cf2c06b1aca838a01179d99f08bbdf98d8165d75643c6` | `0.0.1.7` |
| `Spells/ItemMercurial.luaobj` | 386 | `a8d336c7f96d8be9020e91f40dc0cef37ab31a9b7eb4d626d159224433d50c10` | `0.0.0.254` |
| `Spells/ItemMercurial.preload` | 227 | `113e63440df8f710c3f8f1cb7c60387bee19c8f80a97b9e074745eee1b4921a5` | `0.0.0.254` |
| `Particles/summoner_cast.troybin` | 1 128 | `05b69aafa396e90a36b6c4a8fd3d4c4cdee80f21db979210d80688009289afde` | `0.0.0.235` |
| `Particles/Summoner_Boost.troybin` | 1 195 | `dc5d83b6de4bd2f40ecb7c88abfc35daa02b0ad935a17f5a0b369244534601a6` | `0.0.0.249` |
| `Particles/Item_Mercurial.troybin` | 2 163 | `8acec5a4eff91117f1104341e5e3133de37fa7fbccee490464870e918603c462` | `0.0.0.235` |

Les ID complets figurent dans `result.json`. La source item est `OLS-62fc1b1c-ff11-56e5-8a00-d9b99b2278d2` ; le sort est `OLS-8d372dcc-d90b-5641-8e6c-8155aff8c8c3`. Le manifeste nomme `DATA/Particles/Summoner_Cast.troybin`, tandis que le chemin physique demandé utilise `summoner_cast`. La comparaison sur l'hôte Windows ne prouve ni la politique de casse ni la priorité du VFS historique. Les particules sont identifiées, sans interprétation ou rendu.

`Items/3139.luaobj` et `Items/3139.preload` sont absents du déploiement inspecté et du manifeste agrégé, même après comparaison sans distinction de casse. Aucun fichier n'est déclaré corrompu ou nécessaire à reconstruire depuis cette seule absence.

L'item INIBIN déclare `SpellName=ItemMercurial`, `UseEffect=1`, `Description=game_item_description_3139` et les effets **0.5**, **1**, **"90"**. Le sort directement lié déclare **`SpellData.Cooldown="90.0000"`**, `CastRange="200.0000"`, `CanCastWhileDisabled=1`, `CannotBeSuppressed=1`, `IsDisabledWhileDead=1`, `TargettingType="0"` et `InventoryIcon=Summoner_boost.dds`. Le cooldown du sort propre à 3139 concorde donc numériquement avec l'item et le texte ; le **60** de QuicksilverSash étudié dans V1177 n'est pas importé ici. Cette concordance ne remplace pas la preuve du lecteur serveur effectif, du ciblage ou de l'activation sous chaque contrôle.

Le LuaObj `ItemMercurial` est entièrement parsé : 17 instructions d'initialisation, aucun prototype enfant. Il déclare cinq drapeaux littéraux plus `BuffTextureName=3139_Mercurial_Scimitar.dds`, `BuffName=ItemMercurial`, `AutoBuffActivateEffect=Item_Mercurial.troy`. Il ne contient pas de callback de purge ou de calcul du déplacement. Le preload nomme `summoner_cast.troy`, `itemmercurial` lui-même et `summoner_boost.troy`. Ces références ne prouvent pas leur dispatch, leur sélection UI, la suppression de debuffs ou un rendu.

## 3. Textes, catalogue distinct et miroir communautaire

Le `fontconfig_en_GB.txt` original a le SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`. La ligne **6782** décrit la suppression de tous les debuffs et **+50 % de bonus Movement Speed pendant une seconde**, recharge **90 secondes** ; la ligne **7546** donne le nom. Aucun qualificatif melee/ranged ne figure dans cette chaîne précise ; cela ne prouve pas l'éligibilité de toutes les classes de porteurs. Les trois effets INIBIN correspondent aux nombres du texte, sans qu'un mapping de leurs lecteurs serveur soit qualifié.

Le tooltip du buff `game_buff_tooltip_ItemMercurial`, ligne **2056**, parle seulement d'une forte augmentation temporaire de déplacement, sans nombres. Dans le même INIBIN, **BuffData.DynamicTooltip** pointe vers cette clé alors que **SpellData.Description/DisplayName/DynamicTooltip** pointent vers **SummonerBoost**. Ces textes Cleanse décrivent notamment une réduction de disables de **65 % pendant trois secondes** et laissent `@f1@/@f2@` dans leur tooltip. Le rôle de ces champs, leur sélection effective et l'implémentation des effets ne sont pas déduits de ces bindings. Aucune propriété 65 %/3 s n'est ajoutée au contrat 3139.

Le cache officiel **4.20.1/en_US** `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, 237 361 octets, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, reprend exactement la description et les effets `0.5/1/90`. **Son entrée 3139 porte `maps["10"]=false`.** Ce résultat est propre au catalogue 4.20.1 ; la disponibilité sur le build client exact et le prérequis SCOPE restent ouverts. Le code courant ne dispose pas d'une entrée d'admission 3139, ce qui reste distinct de la valeur `false` du comparatif officiel.

Le miroir `D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Default/Spells/ItemMercurial/ItemMercurial.json`, 2 620 octets, SHA-256 `a4ca4e69850d62e888ed7b30425213db9f52a4a12c80b62c73a8a276a4dd547e`, source `OLS-ced95e0c-3753-5019-8fac-baf746274924`, est revérifié comme `community_native_data_mirror`. Il reprend le chemin original, le cooldown 90 et les bindings de textes. Ce JSON est une donnée, sans script exécutable de purification ou de bonus de déplacement ; son chemin GameServer ne lui donne pas d'autorité Riot.

La recherche de V1177 dans **799 fichiers C#** de la copie LeagueSandbox-Scripts est réutilisée comme **preuve datée**, notamment pour le terme `itemmercurial` sans résultat. Le reçu V1177 est épinglé SHA-256 `2aa4027509170d343c41955de234194a8c9e9defac9ba869c91520164b62f0bc`. Il n'épingle pas chaque fichier C# ; vérifier son hash ne prouve donc pas que les 799 fichiers sont inchangés aujourd'hui. Le lot ne relance pas cette recherche ni une recherche publique identique et n'affirme aucune absence globale. Reprendre avec un nouveau dépôt, une branche, un symbole ou un artefact précis.

## 4. Consommateur actuel et liaison de trace

Le chemin réel est `main.rs:1439-1441 item_hotkey` → `Action::UseItem {slot}` → `lib.rs:615 Simulation::command` → `consumables.rs:8-13 use_item`. Les quatre sources `main/lib/consumables/shop` ont exactement les SHA du reçu V1177. Ce réemploi ne constitue pas un test produit nouveau.

**3139 est absent du catalogue actuel et du fichier d'admission Map10.** Un slot hérité contenant 3139, dans un contexte passant les gardes antérieures, atteint `item behavior not implemented` au lookup catalogue avant la vérification `consumable`, la politique de stun et la première mutation du corps inspecté. Un objet présent sans `consumable` atteint l'autre refus `item active not implemented`. Fin de partie, propriétaire inconnu, mouvement forcé, mort et slot invalide/vide peuvent arrêter plus tôt. Aucun message identique pour tous les contextes n'est affirmé. L'achat est également refusé au lookup de `shop::quote_with_counts`.

Une recherche nouvelle porte seulement sur l'ID exact `\b3139\b` dans les fichiers Rust des trois racines core/client/server ; aucun résultat, avec bornes et nombre de fichiers dans le reçu. Les recherches symboliques ItemMercurial/cleanse du lot précédent ne sont pas relancées. Une logique indirecte sous un autre alias n'est pas exclue par le nouveau contrôle d'ID.

La trace garde le seul native_input item3139 et le consumer `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b`, refus **d'achat**, sans liaison précise du handler d'usage ou des dépendances du sort. `associated_sources_and_current_entrypoints`, `unknown_ids=[]` et `game_behavior_accepted=false` sont conservés. Une liste d'inconnues vide n'établit pas la purification, le bonus ou le cooldown effectif. Le registre est gelé sous la restriction actuelle ; le rapport matérialise les liaisons et les ajouts de trace nécessaires sans les appliquer.

## 5. Cas attendus, observés et contrôles

| Cas | Attendu de l'audit statique | Observé et limite |
|---|---|---|
| Source propre à 3139 | Item → ItemMercurial, chiffres et textes identifiés | Item/sort/texte concordent sur 90 ; effets 0.5/1 et texte +50 %/1 s ; pas d'exécution serveur |
| Purification et déplacement | Distinguer texte, buff et corps effectif | Métadonnées présentes ; matrice de purge et exécution du bonus non qualifiées |
| Références Cleanse/QSS | Ne pas importer les autres règles depuis un alias | Textes Cleanse 65 %/3 s séparés ; le cooldown 60 de QSS n'est pas le champ du sort ItemMercurial |
| Carte et contexte | Distinguer versions et absence locale | Catalogue 4.20.1 maps10=false ; build exact/SCOPE ouverts ; entrée locale absente |
| Slot hérité 3139 autrement valide | Identifier le refus avant actif/mutation | Code catalogue absent → refus ; scénario non exécuté |
| Communauté | Réutiliser les preuves selon leur portée | Miroir actuel vérifié ; recherche C# datée réutilisée, corpus actuel non déclaré inchangé |

Commande exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3139_active_20261103/validate_item3139_active.py` → **PASS_STATIC_SCOPE 65/65**. Le validateur lit D/F, désactive le bytecode avant imports et écrit seulement le reçu E. Il vérifie identités, membres, valeurs et textes précis, contrat de tâche, miroir, consommateurs et refus ordonnés. Aucun Rust/Cargo, jeu original ou local, réseau, GPU, rendu, REA ou code communautaire n'est exécuté. Aucun test ancien n'est relancé ni promu en scénario 3139.

## 6. Écarts, correction et reprise

Réutiliser `ITEM-3139-SERVER-ACTIF` et `ITEM-3139-SCOPE`. Entrées nécessaires : autorité de disponibilité historique, lecteur/callsite serveur des effets et du cooldown, corps de purification ou observation primaire reproductible. Qualifier ensuite les familles de debuffs, le ciblage, l'usage sous contrôles, les conditions du bonus de déplacement et son calcul/expiration/cumul, sans substituer les bindings de Cleanse à cette preuve.

Un futur lot d'implémentation autorisé devra relier le contrat au vrai système d'objets, puis observer activation valide, effets supprimés et conservés, bonus pendant/après la durée qualifiée, portée éventuelle des classes de porteurs, cooldown, cumul, mort/reconnexion et refus sans mutation. Les sources et le handler précis seront à relier au registre dans un lot autorisé. Ces critères restent futurs et ne déclarent aucun résultat historique acquis. Une nouvelle source/callsite, observation ou dérive du consommateur justifie une reprise ; les scans inchangés sont arrêtés.

Les sept rubriques sont renseignées : exigence/frontières, sources/limites et recherches héritées, consommateur réel, attendu/observé et contrôles, écarts, correction et conditions de reprise, livrables datés/relecture. **Audit statique clos après revue indépendante PASS ; implémentation 3139 non qualifiée ; vérification 65/65 statiques ; acceptation humaine non donnée.** La tâche, SCOPE, SYS-01.2-02 et le jeu restent ouverts.

Livrables préparés sur E : rapport, `validate_item3139_active.py`, `result.json` et publisher documentaire protégé. Seuls le rapport et deux notes pourront être publiés par le parent après revue et vérification des empreintes. Aucun Goal, Plan, interface, application, base, registre protégé, code produit, asset, installation ou migration n'est modifié par la préparation.
