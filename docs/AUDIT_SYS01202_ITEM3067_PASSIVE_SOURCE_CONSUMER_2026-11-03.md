# SYS-01.2-02 — Kindlegem 3067, passif et cumul des délais

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3067-PASSIVE-SOURCE-CONSUMER-01`. **Audit de liaison statique clos après vérification ciblée et relecture indépendante : 49/49 contrôles.** Le passif fidèle à la référence, ses règles de cumul et la tâche fonctionnelle restent ouverts. Aucun code produit, donnée du jeu, registre, Plan ou base n'est modifié par ce lot.

## 1. Question, exigence et critères de sortie

La tâche `ITEM-3067-SERVER-PASSIF`, exigence `OLF-08f12cd6-db5f-5dca-873b-679988948b08`, porte sur le passif et les règles de cumul de Kindlegem. Elle reste `a_faire`, `implementation_complete=false`, `acceptance_complete=false`, `required=false` conditionnel : l'implémentation est requise si l'entrée est historiquement disponible dans le périmètre retenu. Son prérequis `ITEM-3067-SCOPE` est **`partiel_a_terminer`**. Le lot `D07-ITEM-3067` et la phase D07 n'ajoutent pas de dépendance dans `execution_plan_A_Z.json` ; cela ne résout pas la dépendance portée par la tâche.

Question de ce sous-audit : **d'où provient le CDR local positif de 0,1, que déclare le client natif, et quel chemin courant l'agrège puis l'applique aux délais ?** Sortie attendue : source/identité, rôle et signe des valeurs, consommateurs réels, cas zéro/une/deux copies par inspection, preuves existantes et limites. Le scope Map10 historique, les autres propriétés/prix/recettes, le corps serveur Riot et le rendu ne sont pas conclus par ce lot. Aucun rapport propre au passif 3067 n'a été trouvé dans le préflight ciblé ; V454 couvre son texte et l'audit 3101 du 02/11 couvre le mécanisme CDR partagé, avec sa portée conservée.

## 2. Source native et provenance de la donnée locale

Référence : PUBLIC **4.20.0.315**, EUW/en_GB, selon `docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`. Les fichiers originaux sont sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/`.

| Fichier | Taille | SHA-256 | Manifest agrégé lol_game_client 0.0.1.7 |
| --- | ---: | --- | --- |
| `3067.inibin` | 538 | `f4202b6fe7a30fd1a610622fa99a35318c30856792f0db6281d7cf47d6145262` | membre `0.0.0.244`, MD5 `7bec5c162852aefb7a3df9fb7a2036ad` |
| `3067.luaobj` | 56 | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | membre `0.0.0.254`, MD5 `623b11414d3c337a0d501a5c0ee114bb` |
| `3067.preload` | 86 | `d5cd6de256478a1b51f10ac6ed179dd1b5e4491e22add14b56167de39400a2a5` | membre `0.0.0.254`, MD5 `5c38d0eb59e7933a0f49e99428963a5c` |

Le manifeste F relu fait 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. Le validateur compare directement taille et MD5 des trois fichiers aux entrées correspondantes, puis leurs sources enregistrées : `OLS-2d6a4ab7-e8ba-542a-9b20-ca6e68fd01f2`, `OLS-511e2908-6494-5ac8-915a-10123641aa40` et `OLS-8b007151-858d-5ad8-bb9a-51c2ffce5460`. L'appartenance n'établit pas priorité d'overlay ni exécution historique.

Le lecteur INIBIN existant décode `Description=game_item_description_3067`, `FlatHPPoolMod="200"` et **`Effect1Amount=-0.10000000149011612`**, float32 exact octets LE `cd cc cc bd`. Les trois clés candidates `PercentCooldownMod`, `PercentCooldownReductionMod` et `CooldownReduction` ne sont pas trouvées par leurs hashes ciblés. **Le rôle de `Effect1Amount` n'est pas établi par cette recherche.** Son signe n'est ni corrigé, ni déclaré corrompu, ni assimilé à la statistique positive locale.

Le chunk Lua est parsé entièrement par `lua51_reference.Reader` : un seul mot `0x0080001e`, `RETURN A=0/B=1/C=0`, aucune constante, aucun prototype enfant. Ce fichier client précis n'apporte pas de corps serveur de passif. Le preload nomme `BBPreloadSpell`/`kindlegem` ; un préchargement ne prouve pas l'effet.

Le texte original en_GB, `DATA/menu/fontconfig_en_GB.txt`, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, donne ligne **6727** « UNIQUE Passive: +10% Cooldown Reduction » et ligne **7491** « Kindlegem ». Le cache officiel **4.20.1/en_US** `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, présente la même description. Il reste une référence distincte du client 4.20.0.315 ; cette entrée ne comporte pas de champ `maps` et ne tranche pas son admission Map10 exacte.

La donnée courante `data/4.20/shop_foundation.json#/items/22` porte `cooldown_reduction=0.1`, `health=200`, `group=""`. Son texte provient du **fr_FR** natif (`fontconfig_fr_FR.txt`, SHA `47429564a76830c2cb5a05f7cdad0c62e987532a71789347dccef8322f4d4562`), selon `docs/item_localization_source.json`. La recette source **lue sans exécution** `tools/recover_caster_items.py:14-17` fixe explicitement `cdr=.1` pour `[3108,3114,3067,3101,3024]`, puis exige `+10%` et `UNIQUE` dans la description FR. Elle ne lit pas `Effect1Amount`. `docs/caster_item_sources.json`, daté du 04/10, conserve cette description et `complete=false`. Ce rapprochement explique la provenance déclarée de la donnée locale ; il ne démontre pas une exécution de ce générateur sur le dépôt F actuel. Le script conserve d'anciens chemins E et n'est pas lancé.

Pour le plafond, `LEVELS/Map10/Constants.var:25`, SHA-256 `178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2`, déclare `gcd_PercentCooldownModMinimum=-0.400`. La recette `recover_caster_items.py:21` en tire le plafond positif. Le fichier courant `cooldown_rules.json` donne `maximum_reduction=0.4`, `minimum_seconds=0.0` et dit explicitement que la déduplication par ID et le snapshot au cast sont reconstruits. Le scalaire natif de plafond ne prouve pas les règles serveur complètes de cumul.

## 3. Consommateur courant et lien manquant dans la trace

Le chemin réel inspecté est le suivant : `shop.rs:36-46` charge statiquement `shop_foundation.json` ; le champ aplati `Bonuses.cooldown_reduction` reçoit 0,1 ; `shop.rs:216-226` parcourt les slots, somme le CDR **une fois par ID** avec un `BTreeSet`, tandis que `health` s'additionne à chaque copie ; `progression.rs:88` borne le total entre zéro et le plafond ; `cooldown.rs:11-14` applique `base_seconds * (1 - réduction bornée)` puis `spells::seconds` ; par exemple `spells.rs:157` utilise cette statistique au cast Garen. `spells.rs:90-92` convertit en ticks par `ceil`, avec `TICK_RATE=30` dans `lib.rs:30`.

Le regroupement utilise **l'ID d'objet**, pas `group` ni une identité native de passif unique. Des IDs différents s'ajoutent jusqu'au plafond local. Le fichier local d'admission comporte `3067/allowed=true` ; le prérequis historique SCOPE reste partiel et cette admission locale ne constitue pas sa résolution. Les gardes achat refusent les IDs absents, les entrées déclarées indisponibles et celles dont la carte n'est pas qualifiée.

La trace actuelle garde `associated_sources_and_current_entrypoints`, aucun `unknown_id`, `game_behavior_accepted=false`, et le seul consumer `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702` du catalogue. **L'absence d'inconnue enregistrée ne prouve pas la fidélité.** Le trajet détaillé jusqu'au CDR n'y est pas rattaché. Les consumers déjà recensés `OLC-be153768-fdac-5822-a737-7ffdbcb30611` (cap/stat dans progression) et `OLC-74c1a701-282b-5e1a-b9c2-34a27e61f7ab` (calcul de délai) sont à réutiliser dans un futur lot de registre autorisé. Aucun lien ni statut n'est changé ici.

## 4. Cas nominaux, cumul, refus et portée des vérifications

| Cas | Attendu par lecture du code courant | Observé dans ce lot |
| --- | --- | --- |
| Zéro Kindlegem, sans autre CDR | bonus objet CDR=0 ; délai de base 10 s → 300 ticks | Déduction statique de la somme vide, de la formule et du taux30 ; aucun scénario Rust exécuté |
| Une copie3067, sans autre CDR | CDR=0,1 ; bonus HP=200 ; 10 s → 270 ticks | Ligne de donnée + branche du premier ID + formule ; contribution individuelle non mesurée en runtime |
| Deux copies3067 | CDR reste0,1 ; bonus HP=400 ; délai inchangé par rapport à une copie | Déduction de `insert(i.id)` et de l'addition HP ; pas de test direct à deux3067 |
| 3067 et autres IDs à CDR | somme des IDs distincts puis plafond0,4 ; 10 s → 180 ticks au cap | Code actuel et ancien test partagé incluant3067 ; contribution isolée masquée par le cap |
| ID absent/inadmissible, valeur invalide | erreurs explicites achat ; assertion finitude/base>=0 dans ticks | Gardes inspectées, refus non exécutés dans ce lot |

Preuves réutilisées : `docs/AUDIT_SYS01202_ITEM3101_PASSIF_2026-11-02.md` rapporte deux tests d'un exécutable existant du 21/10 (`openleague_core-21eb81eb13817108.exe`, SHA `46d3732181601e8bfdc1923857d66192fd2a18fba13fe7aa3bd2f80876f74e6d`) : le cap avec `[3108,3114,3067,3101,3024]`, et le doublon de **3108**. Les deux étaient réussis ; ils ne constituent pas un test direct de Kindlegem ni une exécution de la source actuelle. Les SHA courants de `shop.rs`, `progression.rs`, `cooldown.rs`, du catalogue et des règles sont identiques à ceux épinglés par cet audit du 02/11 ; cela ne prouve pas que le binaire ancien a été compilé depuis ces octets. Aucun test ancien n'est relancé ici.

Contrôle exécuté : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3067_passive_20261103/validate_item3067_passive.py` → **`PASS_STATIC_SCOPE 49/49`**. Il lit D/F, écrit seulement le reçu E, vérifie identités/membership, textes/versions, champs exacts, provenance source de la donnée, callsites et portée des preuves héritées. La génération de bytecode Python est désactivée. Un défaut initial de sérialisation `Path` du validateur a été corrigé ; une attente initiale erronée `a_qualifier` a été remplacée par l'état observé `partiel_a_terminer`. Ni l'un ni l'autre n'a modifié de source ou de statut. Aucun Rust/Cargo, client original, jeu, réseau, GPU ou rendu n'a été exécuté.

## 5. Écarts, correction existante et reprise

Réutiliser `ITEM-3067-SERVER-PASSIF` et son prérequis `ITEM-3067-SCOPE`. Restent à établir : la disponibilité historique exacte, le lecteur natif et le rôle de `Effect1Amount`, le corps serveur du passif, le regroupement unique entre IDs, l'interaction avec d'autres CDR et les délais déjà actifs. Reprendre la recherche native seulement avec mapping de champ, callsite, artefact serveur attribuable ou observation primaire nouvelle. Le tooltip et le chunk vide ne suffisent pas à reconstruire ces règles.

Pour l'implémentation et la vérification futures, qualifier d'abord le contrat, puis mesurer directement zéro/une/deux copies3067, autre ID de même groupe éventuel, cap, achat/vente, cooldown déjà engagé et refus. Identifier binaire/ressources et distinguer moteur local, serveur historique, réseau et rendu. Compléter le lien de trace vers les consumers précis uniquement dans un lot de registre autorisé. Aucun nouveau script serveur, statut, tâche ou migration n'est créé ici.

## 6. Décision limitée et livrables

Les sept rubriques sont renseignées : exigence/frontières ; sources/provenance/limites ; consommateurs ; attendu/observé ; contrôles réellement exécutés et hérités ; écarts/reprise ; correction existante et preuves datées. **Audit terminé pour cette liaison statique**, après revue indépendante. Implémentation : donnée/agrégation/calcul locaux existants, fidélité du cumul historique non qualifiée. Vérification : 49/49 statiques, cas directs3067 non exécutés. Acceptation humaine : non fournie. La tâche fonctionnelle, son prérequis, `SYS-01.2-02` et le jeu restent ouverts.

Livrables E : ce rapport, `validate_item3067_passive.py`, `result.json` et publisher documentaire protégé, non exécuté par l'auteur du lot. Les SHA des sources et consommateurs inspectés figurent dans `result.json`. La publication F n'est prévue qu'après relecture indépendante et contrôle d'empreintes, en ajoutant le rapport et deux notes de reprise. Aucun Goal, Plan, application de suivi, base, registre protégé, code produit ou asset n'est modifié par la préparation.
