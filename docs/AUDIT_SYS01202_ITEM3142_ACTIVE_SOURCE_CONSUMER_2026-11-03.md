# SYS-01.2-02 — Youmuu 3142, actif : sources et refus courant

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3142-ACTIVE-SOURCE-CONSUMER-01`. **Audit statique de liaison : 63/63 contrôles ciblés ; revue indépendante PASS.** L'actif historique, son ciblage, sa récupération et l'acceptation du jeu restent ouverts.

## 1. Contrat et frontière

La tâche `ITEM-3142-SERVER-ACTIF`, exigence `OLF-75c0271d-dcad-5541-8e8d-bbcf4a24c04e`, demande d'implémenter l'actif de **Youmuu's Ghostblade**, son ciblage et sa récupération. Elle reste `a_faire`, `required=false` conditionnel, `implementation_complete=false`, `acceptance_complete=false`, dépendante de `ITEM-3142-SCOPE` (`a_qualifier`). Phase D07 et lot `D07-ITEM-3142` n'ajoutent pas de prérequis ; ils ne résolvent pas celui de la tâche.

Question de ce sous-audit : **quelles ressources natives décrivent l'actif, comment traiter leurs valeurs de cooldown divergentes, que demande le script communautaire fourni et que fait le consommateur courant pour cet ID ?** Les autres statistiques/prix/recettes de l'objet, le périmètre historique Map10, les particules/audio complets et le serveur Riot ne sont pas conclus. Le préflight ciblé n'a trouvé aucun rapport dédié 3139/3140/3142 ; seul 3142 est retenu. L'audit 2003 existant est réutilisé pour localiser le trajet de consommation, sans transformer ses tests de potion en tests de Youmuu.

## 2. Sources originales et provenance

Référence enregistrée : **PUBLIC 4.20.0.315, EUW/en_GB**, selon `docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`. Racine originale : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/`.

Le manifeste agrégé F `data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest` fait 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. Le dossier de déploiement `0.0.1.68`, le manifeste agrégé `0.0.1.7` et les releases individuelles ci-dessous ont des rôles distincts. Les dix ressources sont comparées directement au manifeste par taille/MD5 et au registre par ID/chemin/taille/SHA-256. Cela ne qualifie pas les overlays ou le chargement runtime.

| Ressource native | Octets | SHA-256 | Release membre |
|---|---:|---|---|
| `Items/3142.inibin` | 570 | `43af67de84be01a84cfc2370e036365bc615553149cd81c33711bfaa84b5f465` | `0.0.0.254` |
| `Items/3142.luaobj` | 56 | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | `0.0.0.254` |
| `Items/3142.preload` | 94 | `87fb445e1ab060d06d2cfa30b632c4e75544f84bc19ccc5330d17462085d7736` | `0.0.0.254` |
| `Spells/YoumusBlade.inibin` | 1 027 | `368884b1aa5a40a85b1e9e94cbb39250624250f492039a3539a176889cd1641b` | `0.0.0.25` |
| `Spells/YoumusBlade.luaobj` | 155 | `ade7254ed8c76b183d0c4cb1878b594e7c03fe7535f321e6f6004a478a1c284d` | `0.0.0.254` |
| `Spells/YoumusBlade.preload` | 161 | `326f9f2270351c6a1ebc466ab2e4609f824bdd2708373deb0569cc47dfc0c6e1` | `0.0.0.254` |
| `Spells/SpectralFury.inibin` | 44 | `7f82ae029625b14ddd9ce7c1e19922a0a1e3ce4d3bd36c2623ea6adabb7c1fcc` | `0.0.0.120` |
| `Spells/SpectralFury.luaobj` | 608 | `44b46688165383afee1823ffdc28bbffa4ac310568cd86d3a32d9e3eac722d4e` | `0.0.0.195` |
| `Spells/ItemGhostBladePen.luaobj` | 56 | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | `0.0.0.139` |
| `Particles/spectral_fury_cas.troybin` | 1 033 | `0b3454832a3a41da487ba218403e6e203a842048f441a0a84e74f57182ac0916` | `0.0.0.235` |

`3142.inibin` (`OLS-f8be4835-d611-546a-bb00-8b34c7b08203`) déclare `UseEffect=1`, `SpellName=YoumusBlade` et `Description=game_item_description_3142`. Les effets 1 à 5 sont respectivement **45**, chaîne **"20"**, **0.2**, **0.4**, **6**. Le lecteur local les restitue comme données ; leur emploi serveur n'est pas déduit du seul nom. Le chunk `3142.luaobj` contient exactement `RETURN A=0/B=1/C=0`, aucune constante ni prototype : ce fichier ne fournit pas de corps d'actif serveur.

Le sort associé `YoumusBlade.inibin` (`OLS-f2fe573e-41da-51cf-8577-0286ea59f6d8`) stocke pourtant **`SpellData.Cooldown="60.0000"`**, hash exact **1229951523**. Le texte natif en_GB affiche **45 secondes** et l'effet 1 de l'item vaut 45. Ces valeurs ne sont pas fusionnées : un lecteur/override serveur ou une observation historique est nécessaire pour déterminer la valeur effective. Le membre sort est plus ancien que le membre item, ce qui ne suffit pas à établir une priorité ou une valeur périmée. `CastRange="500.0000"`, `InventoryIcon=Nidalee_TakeDown.dds` et `Flags=329732` sont conservés sans en déduire le ciblage, une corruption ou une politique d'activation.

Le LuaObj du sort déclare seulement, dans le lecteur de littéraux utilisé, `DoesntTriggerSpellCasts`, `PersistsThroughDeath` et `Nondispellable` vrais. Ce ne sont pas des preuves de la durée, de la persistance du bonus ou du comportement du serveur. Le preload item nomme `itemghostbladepen` ; le preload sort nomme `spectralfury` et `spectral_fury_cas.troy`. Leurs références directes sont identifiées sans expansion du graphe visuel. `SpectralFury.inibin` lie le tooltip `game_buff_tooltip_SpectralFury` ; son LuaObj nomme le buff `SpectralFury`, la texture `3142_YomuuGhostblade.dds` et des effets d'activation, dont `spectral_fury_activate_speed.troy`. L'identité du fichier particule direct est contrôlée, pas son rendu. Le nom de buff natif et la classe communautaire diffèrent ; leur équivalence n'est pas prouvée.

Le `fontconfig_en_GB.txt` original, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, décrit **+20 % de vitesse de déplacement et +40 % de vitesse d'attaque pendant 6 secondes, recharge 45 secondes**. Son tooltip `SpectralFury` décrit une augmentation de ces vitesses sans donner de valeurs numériques. Le cache officiel 4.20.1/en_US `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, contient la même description item. Le catalogue **4.20.1 reste distinct du client 4.20.0.315** et ne tranche pas le rôle du cooldown 60 du sort.

## 3. Comparaison communautaire bornée

Deux scripts **fournis sous LeagueSandbox-Scripts**, lus sans exécution :

| Chemin relatif à `D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Scripts/` | Octets | SHA-256 |
|---|---:|---|
| `Items/Actives/YoumusBlade.cs` | 806 | `43bd68a757bda590c59d9d3d9d0f4738f3df4bc241a725d32e0a6fe3f036a564` |
| `Buffs/Items/YoumuusGhostblade.cs` | 1 312 | `712993b18d4b1cdc7151e21574ac1d2315ec1b9fa7d88c53177e4b85a3077297` |

`OnSpellPreCast` demande `AddBuff("YoumuusGhostblade",6.0f,1,spell,owner,owner)`. Le buff demande `MoveSpeed.PercentBonus=0.2f`, `AttackSpeed.PercentBonus=0.4f`, puis `AddStatModifier`. Le callback de désactivation retire sa particule ; l'absence de retrait de statistique explicite dans ce callback ne démontre pas une fuite, car le cycle de vie du moteur peut la prendre en charge. Ce moteur n'est pas audité ici. La cible reçue est ignorée au profit de `owner,owner` dans cette requête communautaire ; ce n'est pas une preuve de ciblage du serveur Riot.

Ces scripts concordent textuellement avec les bonus et les six secondes, mais n'établissent pas le dispatch original, la recharge, la règle de cumul, la mort, l'expiration effective ou le nettoyage des modificateurs. Le chemin `GameServer` et son étiquette 4.20 ne leur donnent pas d'autorité Riot. Aucun script communautaire n'est exécuté ou adopté.

## 4. Consommateur actuel et lien de trace

`launcher`/sélection des objets ne sont pas réaudités. Le client en partie produit `Action::UseItem { slot }` à partir de `item_hotkey` (`crates/client/src/main.rs:1439-1441`). `Simulation::command` applique ses gardes d'état et dirige cette action vers `self.use_item` (`crates/core/src/lib.rs:615`). Dans `consumables.rs:8-13`, le corps vérifie d'abord fin de partie, propriétaire, mouvement forcé, vie et slot ; il résout ensuite l'ID dans `shop::catalog()`.

**3142 est absent de `shop_foundation.json` et de `map10_shop_admission.json`.** L'absence d'admission n'est pas la valeur `false` et ne prouve pas l'exclusion historique Map10. Pour un **slot hérité contenant 3142 et un contexte passant toutes les gardes antérieures**, le code atteint `item behavior not implemented` avant le contrôle `consumable` et avant toute mutation. Un objet présent au catalogue mais sans `consumable` reçoit l'autre refus `item active not implemented`. Un slot vide, invalide ou un état mort peut produire son propre refus plus tôt : aucun message unique pour tout contexte n'est revendiqué. L'achat est également refusé par le lookup de `shop::quote_with_counts`.

La recherche exacte `3142|YoumusBlade|YoumuusGhostblade|SpectralFury` dans les fichiers `.rs` de `crates/core/src`, `crates/client/src`, `crates/server/src` ne trouve aucun chemin nommé ; le reçu en donne le nombre de fichiers et les racines. Elle ne prouve pas l'absence de toute logique indirecte sous un alias différent. Le trajet générique d'actif disponible est celui des consommables Health/Mana, pas une interprétation des LuaObj originaux.

La trace `ITEM-3142-SERVER-ACTIF` conserve un seul native_input, le fichier item, et un seul consumer `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b` : le lookup/refus **d'achat** dans `shop.rs`. Le trajet précis de `use_item` et les dépendances du sort ne lui sont pas liés. Son état `associated_sources_and_current_entrypoints`, `unknown_ids=[]` et `game_behavior_accepted=false` sont conservés ; aucune résolution sémantique n'est déduite de la liste d'inconnues vide.

## 5. Attendu, observé et contrôles exécutés

| Cas | Attendu pour l'audit statique | Observé et limite |
|---|---|---|
| Source nominale de l'actif | Item, sort, texte et références directes identifiés | 10 ressources exactes/membership, binding `YoumusBlade`, texte +20/+40/6/45 ; pas d'exécution native |
| Recharge | Conserver les valeurs différentes | Item/tooltip/catalogue : 45 ; champ de sort : 60 ; rôle/override effectif inconnu |
| Slot hérité 3142 autrement valide | Refus courant sans actif ni mutation | Code absent-catalogue → `item behavior not implemented`, avant consumable/stun/get_mut ; scénario non exécuté |
| Objet présent non consommable ou gardes antérieures | Ne pas confondre les refus | Refus `item active not implemented` distinct ; états/slots invalides peuvent arrêter plus tôt |
| Communauté | Identifier les requêtes et leurs limites | Requête selfbuff 6 s et .2/.4 ; aucune adoption ni preuve serveur Riot |

Commande exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3142_active_20261103/validate_item3142_active.py` → **`PASS_STATIC_SCOPE 63/63`**. Le validateur lit D/F, écrit seulement `result.json` sur E et désactive le bytecode avant les imports F. Les SHA des sources et consommateurs sont dans le reçu. Il contrôle la provenance, les valeurs exactes, les contrats, les branches et leur ordre dans les corps inspectés. **Aucun test Rust, compilation Cargo, partie, launcher, réseau, rendu, REA ou script communautaire n'a été exécuté.**

`docs/AUDIT_SYS01202_ITEM2003_HEALTH_POTION_2026-11-02.md` est réutilisé pour les noms du trajet de consommation. Ses tests anciens de potion ne prouvent ni l'actif 3142 ni le refus actuel de son slot hérité. Aucun binaire ancien n'est relancé ; aucun résultat runtime 3142 n'est revendiqué.

## 6. Correction existante, reprise et clôture

Réutiliser `ITEM-3142-SERVER-ACTIF` et `ITEM-3142-SCOPE`. Avant implémentation fidèle : qualifier la disponibilité historique Map10, le lecteur de la recharge item/sort et ses overrides, le dispatch de l'actif, le ciblage, le cumul des bonus, la mort et le nettoyage. Entrée de reprise : callsite original attribuable, source serveur primaire, mapping de champ ou observation historique reproductible. Les mêmes chaînes, scripts et métadonnées ne justifient pas un nouveau scan inchangé.

Un futur lot autorisé devra relier le contrat retenu au vrai système d'actifs, puis vérifier activation, cible, ressource/cooldown, bonus pendant/après six secondes selon source qualifiée, cumul, mort/reconnexion, refus atomiques et effets visibles. La traçabilité pourra alors ajouter les consommateurs précis et les dépendances déjà enregistrées, dans un lot de registre autorisé. Aucune règle 45/60 n'est choisie arbitrairement et aucun nouvel ID de correction n'est nécessaire.

Les sept rubriques du contrat d'audit sont couvertes : exigence/frontières, sources/identités/limites, consommateurs réels/recherche bornée, attendu/observé, contrôles exécutés/non exécutés, écarts/reprise, correction et preuve datée. **Clôture limitée : audit statique source→consommateur/refus terminé après relecture indépendante ; fonctionnalité 3142 non qualifiée.** Vérification : 63/63 statiques, aucun scénario produit 3142 exécuté. Acceptation humaine : non donnée. La tâche, son prérequis, `SYS-01.2-02` et le jeu restent ouverts.

Livrables préparés dans `E:/mapslol3v3/audit_sys01202_item3142_active_20261103` : rapport, validateur, reçu et publisher documentaire protégé. La publication F est réservée au parent après revue et empreintes. Aucun Goal, Plan, interface, application, base, registre protégé, code produit, asset, installation ou migration n'est modifié par cette préparation.
