# SYS-01.2-02 — Dervish Blade 3137 : purification, bonus conditionnel et refus courant

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3137-ACTIVE-SOURCE-CONSUMER-01`. **Audit de liaison statique clos après 66/66 contrôles ciblés et relecture indépendante PASS.** L'actif historique, sa matrice de purification et l'exécution du bonus restent ouverts.

## 1. Contrat, question et frontière

La tâche `ITEM-3137-SERVER-ACTIF`, exigence `OLF-b94b027b-03e5-5008-b208-c3b81e945be3`, porte sur l'actif, le ciblage et la récupération de Dervish Blade. Elle reste `a_faire`, `required=false` conditionnel, avec implémentation et acceptation fausses. Son prérequis `ITEM-3137-SCOPE` est `a_qualifier`. Phase D07 et lot `D07-ITEM-3137` n'ajoutent pas de dépendance ; cela ne résout pas le prérequis de la tâche.

Question : **quelles sources propres à 3137 déclarent la purification et le bonus de déplacement conditionnel, et où aboutit son utilisation dans le code actuel ?** Critères de sortie : identités/provenance/limites, consommateurs exacts ou refus, attendu/observé, preuves héritées et conditions de reprise. Les statistiques ordinaires, prix, recettes, disponibilité historique Map10 et rendu ne sont pas clos. Le texte mentionne notamment +10 % de réduction des délais hors de cet actif ; sa couverture et son éventuel découpage atomique demandent un préflight distinct, sans conclure ici que l'exigence est absente du plan parent.

Aucun rapport dédié 3137 n'a été trouvé dans le préflight ciblé. Les preuves 3140/V1177 et 3139/V1178 sont réutilisées selon leur portée ; ni leurs mécanismes, ni leurs critères de porteur, ni leurs disponibilités par carte ne sont transférés à 3137.

## 2. Sources natives et provenance

Référence : **PUBLIC 4.20.0.315, EUW/en_GB**, selon `docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`. Les octets originaux sont sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/`.

Le manifeste agrégé contrôlé est `F:/OpenLeague/data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest`, 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. Le dossier de déploiement, le manifeste agrégé et les releases de membres ci-dessous ont des rôles distincts.

| Source sous DATA | Octets | SHA-256 | Release membre |
|---|---:|---|---|
| `Items/3137.inibin` | 601 | `f50f7cfe303b43eb78002fc555abcfdfe4410220edbba2757cc2dd88f9b2f0ea` | `0.0.1.7` |
| `Items/3137.luaobj` | 56 | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | `0.0.0.200` |
| `Spells/ItemDervishBlade.inibin` | 687 | `c94183c4fcc4515ca1f5085c830170292f0d96aa71c3c4112191b625081f43b3` | `0.0.1.7` |
| `Spells/ItemDervishBlade.luaobj` | 384 | `f50c594a3a4c898096a652bc7d26ab4fba34de6bbdf037900753c04238f04dee` | `0.0.0.254` |
| `Spells/ItemDervishBlade.preload` | 162 | `469eccab27b05f4be0e6f2175e0bfd8b17f6c88b073607f801dbd2d4cd6261fb` | `0.0.0.254` |
| `Particles/Summoner_Boost.troybin` | 1 195 | `dc5d83b6de4bd2f40ecb7c88abfc35daa02b0ad935a17f5a0b369244534601a6` | `0.0.0.249` |
| `Particles/Item_Mercurial.troybin` | 2 163 | `8acec5a4eff91117f1104341e5e3133de37fa7fbccee490464870e918603c462` | `0.0.0.235` |

Pour chaque fichier, le validateur compare taille/SHA, source enregistrée et membre unique après comparaison `casefold`, avec taille/MD5. Les chemins logiques retenus sont conservés dans le reçu et concordent ici avec les chemins demandés. Cette comparaison ne prouve ni la politique de casse du VFS historique, ni le montage effectif, ni le rendu des particules.

Les sources principales sont `OLS-2e4033cb-588f-58a1-bab7-639eea54201c` (item), `OLS-56f3742a-c857-5bed-ad71-5a5c7078de57` (LuaObj item), `OLS-5bfed250-88c7-5ce1-b4f6-27d2202c3366` (sort). Les autres IDs sont dans `result.json`.

**Le LuaObj item 3137 existe**, contrairement aux compagnons absents observés pour 3139/3140. Son chunk entier est un seul mot `0x0080001e`, `RETURN A=0/B=1/C=0`, sans constante ni prototype enfant, fin à l'octet 56. Ce fichier précis ne fournit donc pas de corps d'actif serveur. Seul `Items/3137.preload` est absent du déploiement et du manifeste agrégé ; aucune corruption ou reconstruction nécessaire n'est déduite de cette absence.

L'INIBIN item déclare `SpellName=ItemDervishBlade`, `UseEffect=1`, `Description=game_item_description_3137`, effets **0.5**, **1**, **"90"**. Le sort lié déclare `Cooldown="90.0000"`, `CastRange="200.0000"`, `CanCastWhileDisabled=1`, `CannotBeSuppressed=1`, `IsDisabledWhileDead=1`, `TargettingType="0"`, `InventoryIcon=Summoner_boost.dds`. Le délai concorde numériquement avec l'item et son texte ; cela ne qualifie pas le lecteur serveur, le ciblage ou les exceptions sous chaque contrôle.

Le LuaObj du sort comporte 17 instructions d'initialisation et zéro prototype de callback. Ses valeurs littérales incluent cinq drapeaux, `BuffName=ItemDervishBlade`, `BuffTextureName=3137_Dervish_Blade.dds` et `AutoBuffActivateEffect=Item_Mercurial.troy`. Il ne contient pas de callback de purge, de condition de porteur ou de calcul du bonus. Le preload du sort ne nomme que `summoner_boost.troy` et `itemdervishblade` ; il ne nomme pas `summoner_cast.troy` comme le preload 3139. Les ressources visuelles partagées ne rendent pas les actifs équivalents.

## 3. Textes, catalogue distinct et communauté

Le `fontconfig_en_GB.txt` original a le SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`. Ligne **6780**, il annonce la suppression de tous les debuffs puis, **si le champion est de mêlée**, +50 % de bonus de déplacement pendant une seconde, recharge 90 secondes. Le nom est ligne **7544**. **La condition de mêlée porte sur le bonus de déplacement dans cette chaîne, pas sur la purification.** Ce texte reste une description client, pas une matrice serveur exécutée.

Le tooltip de buff `game_buff_tooltip_ItemDervishBlade`, ligne **2040**, parle d'un déplacement fortement accru pour une courte durée, sans nombres ni condition de porteur. Dans le sort, `BuffData.DynamicTooltip` pointe vers ce texte, tandis que `SpellData.Description/DisplayName/DynamicTooltip` pointent vers **SummonerBoost/Cleanse**, avec les références 65 %/3 s et les variables `@f1@/@f2@` déjà identifiées. Leur rôle et leur sélection UI restent inconnus ; aucun effet de Cleanse n'est ajouté à 3137 depuis ces noms.

Le cache officiel **4.20.1/en_US**, `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, reprend exactement la description et les effets `0.5/1/90`. Son entrée porte **`maps={"12":false,"1":false}` et ne comporte pas de clé `10`**. Cette absence n'est ni `maps[10]=false`, ni une preuve d'admission. La disponibilité sur le build exact et SCOPE restent ouverts ; le `maps[10]=false` de 3139 n'est pas transféré.

Le miroir `D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Default/Spells/ItemDervishBlade/ItemDervishBlade.json`, 2 635 octets, SHA-256 `8438f9907e71d3a55d982b3fb2f7ca9e4189e2825cbb3edb1a763228227a7c5a`, source `OLS-520601c6-169d-5ff9-bde8-b45678839afd`, est revérifié comme `community_native_data_mirror`. Il reprend la ressource native, le cooldown 90 et le tooltip de buff. Ce JSON ne fournit pas de script exécutable de purification ou de bonus ; son chemin GameServer ne lui confère pas d'autorité Riot.

La recherche communautaire de V1177 est réutilisée comme **preuve datée** : 799 fichiers C# et aucun hit nommé `itemdervishblade`. Reçu épinglé `E:/mapslol3v3/audit_sys01202_item3140_active_20261103/result.json`, SHA-256 `2aa4027509170d343c41955de234194a8c9e9defac9ba869c91520164b62f0bc`. Ce reçu n'épingle pas chacun des 799 fichiers ; son hash ne prouve pas leur état actuel. Aucun scan communautaire ou public identique n'est relancé et aucune absence globale n'est affirmée.

## 4. Consommateur réel et trace

Le trajet inspecté est `main.rs:1439-1441 item_hotkey` → `Action::UseItem {slot}` → `lib.rs:615 Simulation::command` → `consumables.rs:8-13 use_item`. Les quatre sources `main/lib/consumables/shop` ont encore exactement les SHA du reçu 3139/V1178, SHA `4010ef0da7b19759cbf0200ff92e177a086f10398ad6cb5cc0c1e9dd4a286e0a`. Ce réemploi de sources ne constitue pas un scénario en jeu.

**3137 est absent du catalogue courant et du fichier d'admission Map10.** Pour un slot hérité contenant 3137 et un contexte passant les gardes antérieures, le lookup catalogue retourne `item behavior not implemented` avant le contrôle `consumable`, la politique de stun et la première mutation du corps inspecté. Un item présent sans consommable atteint le refus distinct `item active not implemented`. Fin de partie, propriétaire inconnu, mouvement forcé, mort et slot invalide/vide peuvent arrêter plus tôt. L'achat est aussi refusé au lookup de `shop::quote_with_counts`. L'absence d'entrée locale ne décide pas l'admission historique.

Une recherche nouvelle porte uniquement sur l'ID exact `\b3137\b` dans les fichiers Rust de core/client/server ; aucun hit, bornes et compte dans le reçu. Les anciennes recherches de noms ItemDervishBlade/cleanse ne sont pas répétées. Une route indirecte sous un alias différent n'est pas exclue.

La trace conserve seulement le native_input item et le consumer d'achat `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b`, sans liaison précise du handler d'usage et des dépendances du sort. Son état `associated_sources_and_current_entrypoints`, `unknown_ids=[]` et `game_behavior_accepted=false` sont conservés. La liste d'inconnues vide ne prouve ni la condition de mêlée, ni le bonus appliqué, ni la purification. Les compléments de liens restent documentés, non appliqués au registre gelé.

## 5. Attendu, observé et contrôles

| Cas | Attendu de l'audit statique | Observé et limite |
|---|---|---|
| Source de l'actif | Binding et chiffres propres à 3137 | Item → ItemDervishBlade ; 90 et 0.5/1 concordent avec le texte ; pas de serveur exécuté |
| Porteur mêlée/distancé | Conserver exactement la condition de texte | Bonus de déplacement conditionnel mêlée ; aucune restriction de purge inférée ; aucun test de porteur |
| Fichiers compagnons | Vérifier présence/absence propre à l'objet | LuaObj item présent et à retour vide ; preload item absent, sans corruption inférée |
| Carte | Ne pas inventer une valeur absente | Catalogue 4.20.1 sans clé10 ; SCOPE/build exact ouverts ; admission locale absente |
| Slot hérité autrement valide | Identifier le refus précis | Catalogue absent → refus avant actif/mutation ; scénario non exécuté |
| Communauté | Distinguer données et comportement | Miroir actuel vérifié ; recherche de script datée réutilisée, corpus actuel non déclaré identique |

Commande exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3137_active_20261103/validate_item3137_active.py` → **PASS_STATIC_SCOPE 66/66**. Le validateur lit D/F, désactive le bytecode avant imports et écrit seulement le reçu E. Il vérifie identités, source IDs, membres, chunk item, valeurs/textes précis, tâche, miroir, consommateurs et ordre des refus. Une première adaptation du contrôle preload a échoué parce qu'elle conservait deux noms du lot 3139 ; elle a été corrigée d'après le preload 3137 relu. Aucun artefact source n'a été modifié. Aucun Rust/Cargo, jeu, réseau, GPU, rendu, REA ou script communautaire n'est exécuté ; aucun test ancien n'est relancé ou promu en scénario 3137.

## 6. Écarts, correction et clôture limitée

Réutiliser `ITEM-3137-SERVER-ACTIF` et `ITEM-3137-SCOPE`. Entrées nécessaires : autorité d'admission historique, lecteur serveur des effets et du délai, corps de purification ou observation primaire reproductible. Qualifier le ciblage, les familles de debuffs, l'usage sous contrôles et la condition de mêlée propre au bonus, son calcul, sa durée, son expiration et son cumul. Le tooltip, les drapeaux client et le miroir JSON ne fournissent pas cette preuve.

Après qualification, un lot d'implémentation autorisé devra observer les cas mêlée/distancé, la purge conforme au contrat, les effets conservés/refusés, le bonus pendant/après sa durée, le cooldown, la mort/reconnexion et les refus sans mutation. Les sources et le handler précis seront à relier au registre dans un lot autorisé. Ces critères sont futurs et ne déclarent aucun comportement historique acquis. Une nouvelle source/callsite, observation ou dérive de consommateur justifie une reprise ; les scans inchangés sont arrêtés.

Les sept rubriques sont renseignées : exigence/frontières ; sources/limites et recherche héritée ; consommateurs ; attendu/observé/contrôles ; écarts ; correction/reprise ; preuves datées/relecture. **Audit de liaison statique terminé après revue indépendante PASS ; implémentation 3137 non qualifiée ; vérification statique 66/66 ; acceptation humaine non donnée.** La tâche, SCOPE, SYS-01.2-02 et le jeu restent ouverts.

Livrables préparés seulement sur E : rapport, `validate_item3137_active.py`, `result.json` et publisher documentaire protégé. Seuls le rapport et deux notes pourront être publiés par le parent après revue/empreintes. Aucun Goal, Plan, interface, application, base, registre protégé, code produit, asset, installation ou migration n'est modifié par la préparation.
