# SYS-01.2-02 — Dervish Blade 3137 : couverture du CDR ordinaire

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3137-CDR-COVERAGE-SOURCE-CONSUMER-01`. **45/45 contrôles statiques ciblés, revue indépendante PASS.** Ce lot examine la décomposition et la liaison de la statistique, sans implémenter le CDR ni modifier le plan.

## 1. Question et contrat

Le parent existant `ITEM-3137-SERVER`, exigence `OLF-86cdab72-5849-5b5e-bed7-4f59628cd037`, demande de terminer les statistiques, groupes uniques, passifs, actifs, charges et transformations nécessaires de Dervish Blade. Il reste `a_implementer_ou_integrer`, conditionnel (`required=false`), sans implémentation ni acceptation terminée. Sa portée large **peut couvrir le CDR**. Il serait donc inexact de déclarer cette exigence entièrement absente du plan.

Question précise : **le +10 % de réduction des délais annoncé pour 3137 possède-t-il une source native, une sous-tâche et des liens de consommateurs identifiables ; que produit le chemin courant pour cet objet ?** Le lot distingue la couverture large du parent, sa décomposition explicite, les projections de données et la fonctionnalité. L'actif, le bonus de déplacement, les autres statistiques, l'admission historique et le jeu ne sont pas clos.

Le prérequis `ITEM-3137-SCOPE` reste `a_qualifier`. Le lot d'exécution `D07-ITEM-3137` conserve ses onze tâches ; aucune règle de dépendance ni aucun statut n'est changé. V1179 couvre déjà l'actif. Les audits 3067/V1175 et 3101 du 02/11 sont réutilisés pour les consommateurs CDR partagés et leurs limites, sans nouveau test de ces mécanismes.

## 2. Source native nommée et texte

Référence : **PUBLIC 4.20.0.315, EUW/en_GB**, selon `F:/OpenLeague/docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`.

Le fichier original `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3137.inibin` fait **601 octets**, SHA-256 `f50f7cfe303b43eb78002fc555abcfdfe4410220edbba2757cc2dd88f9b2f0ea`, source `OLS-2e4033cb-588f-58a1-bab7-639eea54201c`. Son membre dans le manifeste agrégé `lol_game_client/0.0.1.7` correspond par taille/MD5, release membre `0.0.1.7`. Le manifeste est épinglé SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`. L'appartenance ne démontre pas le montage effectif ou l'exécution historique.

Le lecteur existant `reference_inibin.py` donne **`Data.PercentCooldownMod=-0.10000000149011612`**, hash de clé **2196017170**, float32 exact LE **`cd cc cc bd`**. Il s'agit d'un **champ natif nommé**, distinct du cas 3067 où seul un autre champ négatif d'effet avait été identifié. Les trois noms ciblés `PercentCooldownReductionMod`, `CooldownReduction`, `FlatCooldownMod` sont absents. Les effets `.5/1/90` concernent séparément les données d'actif déjà auditées ; ils ne deviennent pas une réduction de délai ordinaire.

Le texte original en_GB `DATA/menu/fontconfig_en_GB.txt`, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, ligne 6780, annonce **+10 % Cooldown Reduction dans le bloc `<stats>`**, avant l'actif. Il ne présente pas cette ligne comme une propriété passive UNIQUE. Cette différence empêche d'adopter automatiquement pour 3137 la déduplication par ID reconstruite pour les passifs uniques de 3067/3101. Le champ négatif et la description positive concordent en magnitude ; leur lecteur, leur convention de signe appliquée et les règles serveur de cumul ne sont pas exécutés ni qualifiés ici.

Le catalogue officiel **4.20.1/en_US**, cache `E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json`, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`, conserve cette description et le tag `CooldownReduction`, mais son objet `stats` contient seulement `PercentAttackSpeedMod=0.5` et `FlatSpellBlockMod=45.0`. Sa carte `maps={"12":false,"1":false}` n'a pas de clé 10 ; aucune admission n'est inférée. Cette révision reste distincte du client 4.20.0.315.

## 3. Couverture constatée du parent et des projections

Le registre courant contient exactement **onze tâches dont `entity="3137"`** ; elles correspondent aux onze IDs `ITEM-3137-*` lus, sans autre alias dans cette partition. Les onze traces correspondantes ont également été relues. Ce contrôle ne prétend pas exclure un contrat CDR global situé ailleurs.

| Sous-ensemble actuel | IDs et rôle |
|---|---|
| Périmètre | `ITEM-3137-SCOPE` |
| Statistiques explicites | `ITEM-3137-SERVER-STAT-PercentAttackSpeedMod`, `ITEM-3137-SERVER-STAT-FlatSpellBlockMod` |
| Actif | `ITEM-3137-SERVER-ACTIF` |
| Parent serveur | `ITEM-3137-SERVER`, dépendant exactement des deux statistiques ci-dessus et de l'actif |
| Boutique | `SHOP-ICONE`, `SHOP-TEXTE`, `SHOP-PRIX`, `SHOP-RECETTE`, puis `SHOP` sous le même préfixe |
| Acceptation | `ITEM-3137-ACCEPT` |

Il n'existe **aucune sous-tâche CDR explicite dans cette partition**. Le parent conserve pourtant le CDR dans sa description officielle de référence et son titre large couvre les statistiques. Le constat est donc un **manque d'individualisation et de critères propres au CDR sous ce parent**, pas la disparition de l'exigence globale. Le seul consommateur inscrit sur ces traces est `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b`, le refus d'achat de `shop::quote_with_counts`, et non le trajet statistique CDR. Le parent reste `associated_sources_and_current_entrypoints`, `unknown_ids=[]`, `game_behavior_accepted=false` ; une liste d'inconnues vide ne qualifie pas ce comportement.

La projection actuelle `data/4.20/native_item_audit.json` référence les octets exacts de 3137, mais son dictionnaire `native_values` **omet `PercentCooldownMod`**. Les statistiques AS/MR y figurent. Ce résultat et l'omission du champ dans les statistiques structurées du catalogue officiel sont deux omissions de projection constatées, sans conclusion causale sur la génération du plan.

Le consommateur de contrôle réel `tools/verify_native_items.py` a été **lu, jamais exécuté** : sa première boucle vérifie uniquement les clés déjà présentes dans `row['native_values']`; sa seconde liste comporte treize paires de statistiques locales/natives, sans CDR, pour les objets du catalogue courant. Il ne contrôle donc ni l'exhaustivité de tous les champs natifs ni le CDR de 3137. Ses limites documentées sont déjà « source hash and numeric agreement only » : un ancien PASS de cette vérification ne devient pas faux pour sa portée, et il ne vaut pas preuve de couverture exhaustive. Ce script écrit `docs/native_item_validation.json` s'il est exécuté ; il n'a pas été lancé.

La cause historique du découpage reste **UNKNOWN**. Les recherches littérales `SERVER-STAT-` dans `F:/OpenLeague/tools/project-plan`, puis les scripts Python de `F:/OpenLeague/tools` hors target/node_modules, n'ont pas identifié le producteur. Le répertoire historique explicitement cité par le registre, `E:/mapslol3v3/Full_project_audit_2026-10-20`, a été inspecté de façon ciblée : `task_spec.py`/`build_report.py` ne fournissent pas le générateur des IDs atomiques actuel. Ne pas supposer un filtre du générateur à partir de la seule ressemblance des projections ; reprendre cette causalité uniquement avec sa source versionnée retrouvée.

## 4. Consommateurs CDR actuels et résultat pour 3137

`shop.rs:36-46` charge `shop_foundation.json`; `shop.rs:69` résout l'ID. La ligne 3137 est **absente** de ce catalogue. Dans `shop::bonuses` (`shop.rs:215-226`), l'inventaire passe par `filter_map(|id| item(*id))`, puis une somme partant de `Bonuses::default()`. Un ID 3137 hérité est donc **ignoré dans l'agrégation des statistiques** ; il ne produit pas une erreur sur ce trajet. Pour un inventaire ne contenant que cet ID ou des cases vides, la contribution objet CDR est nulle.

Le refus d'achat reste distinct : le lookup de `quote_with_counts` renvoie une erreur pour l'objet absent. Le refus d'utilisation de l'actif est déjà audité dans V1179 et n'est pas requalifié comme refus statistique.

Le chemin générique CDR existe : somme locale → `progression.rs:88` clamp entre zéro et `cooldown::maximum_reduction()` → `cooldown.rs:11-14` calcule `base_seconds*(1-réduction bornée)` → `spells::seconds` effectue `ceil(value*TICK_RATE)`, avec `TICK_RATE:u64=30`. Le callsite Garen dans `spells.rs:157` fournit la statistique au calcul. Les SHA actuels de `shop.rs`, `progression.rs` et `cooldown.rs` correspondent exactement aux empreintes de l'audit 3067 ; la politique locale conserve le plafond 0.4 et décrit explicitement la déduplication et le snapshot au cast comme reconstruits.

Cette déduplication par même ID existe dans le code partagé ; elle n'est **pas promue en politique fidèle de cumul pour le CDR ordinaire de 3137**. Aucune inversion du signe natif n'est introduite dans les données Rust. Les consommateurs recensés `OLC-be153768-fdac-5822-a737-7ffdbcb30611` (agrégation/cap) et `OLC-74c1a701-282b-5e1a-b9c2-34a27e61f7ab` (calcul) sont à réutiliser pour une future liaison de registre autorisée, avec le lookup catalogue conservé.

## 5. Attendu, observé et contrôles exécutés

| Cas | Attendu du sous-audit | Observé et limite |
|---|---|---|
| Source nominale CDR | Identifier un champ ou un texte précis | Champ nommé `PercentCooldownMod`, float32 négatif exact, texte ordinaire +10 % ; application serveur non exécutée |
| Couverture du plan | Distinguer parent large et critères dédiés | Parent large et description CDR conservés ; onze tâches/traces, aucun enfant CDR explicite |
| Projection/vérificateur | Vérifier ce qui est réellement contrôlé | Projection omet le champ ; vérificateur limité à ses clés/paires, sans contrôle d'exhaustivité |
| Inventaire hérité 3137 | Décrire le trajet statistique exact | ID inconnu filtré ; CDR objet nul si aucune autre contribution ; pas d'erreur statistique ni de scénario Rust exécuté |
| Achat | Distinguer omission et refus | Lookup achat absent → erreur explicite par inspection, non exécutée ici |
| Cumul et délais | Garder la politique historique ouverte | Déduplication/cap/calcul locaux présents ; aucun zéro/un/deux 3137 ni bonus historique mesuré |

Commande exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/audit_sys01202_item3137_cdr_coverage_20261103/validate_item3137_cdr.py` → **PASS_STATIC_SCOPE 45/45**. Le validateur lit D/F, désactive le bytecode avant les imports et écrit seulement `result.json` sur E. Les empreintes des sources et consommateurs y figurent. Un premier reçu 42/44 a été conservé dans `result-initial-checks.json` : deux attentes syntaxiques erronées (ordre du derive Default, type du tickrate) ont été corrigées d'après le code réel ; aucun fichier produit n'a été modifié. Le contrôle de partition entity a ensuite été ajouté. Aucun Rust/Cargo, jeu, réseau, rendu, REA, vérificateur natif de masse ou générateur du plan n'est exécuté.

## 6. Corrections documentaires proposées et conditions de reprise

Deux fiches **PROPOSÉES UNIQUEMENT, NON ENREGISTRÉES**, réutilisant le parent existant et le prérequis SCOPE :

1. **`ITEM-3137-SERVER-CDR-CONTRAT`** — qualifier le contrat du CDR ordinaire de 3137. Sources : champ natif nommé, texte en_GB et catalogue distinct ; entrée manquante : lecteur/règle serveur ou observation primaire. Définir la transformation du signe et son unité, la valeur appliquée, les doublons du même objet, les autres objets/runes/maîtrises, le plafond et l'application aux délais nouvellement engagés ou déjà actifs. Séparer le CDR des sorts de la recharge 90 de l'actif ; ne pas réduire cette dernière par hypothèse. Critère de fin : les règles nécessaires à l'implémentation ont leur source, leurs attendus/observés et leurs limites qualifiées. Toute inconnue indispensable garde cette fiche de contrat ouverte avec une entrée de reprise ; la clôture de l'audit présent ne la clôt pas. Dépendance proposée : `ITEM-3137-SCOPE`.
2. **`ITEM-3137-SERVER-STAT-PercentCooldownMod`** — intégrer le champ qualifié au trajet ordinaire des statistiques et délais. Dépendances proposées : SCOPE et contrat CDR ci-dessus. Préserver le signe natif dans la provenance ; utiliser uniquement la transformation qualifiée pour la donnée locale. Vérifier zéro/une/deux copies, autre CDR, plafond, achat/vente, inventaire hérité inconnu, délai engagé et refus atomiques ; observer binaire et ressources identifiés. Critère de fin : la contribution individuelle atteint la statistique puis un vrai callsite de sort, les règles de cumul/limites sont vérifiées sur le contrat, sans valider d'autres propriétés de 3137.

Ces propositions ne créent ni tâche, ni dépendance, ni ligne de base, ni nouveau dénominateur dans le suivi. Elles ne comptent pas comme deux audits clôturés. Le parent `ITEM-3137-SERVER` reste le regroupement existant ; une future intervention sur le registre devra conserver ses acquis et rendre le lien aux critères CDR explicite, sous autorisation distincte. Si un contrat global existant répond déjà à un point, le référencer au lieu de dupliquer sa preuve.

Reprise historique : lecteur/callsite du champ `Data.PercentCooldownMod`, source serveur ou observation attribuable tranchant signe et cumul. Reprise de la cause du découpage : script versionné de génération retrouvé. Reprise produit : contrat et scope qualifiés, puis lot d'implémentation autorisé. Les sources et les contrôles inchangés ne justifient pas de nouveaux scans identiques.

## 7. Décision limitée

Les sept rubriques sont renseignées : exigence/frontière ; sources et provenance/limites ; consommateurs et projection ; attendu/observé/contrôles ; écarts ; corrections et critères ; preuves datées/relecture. **Une seule unité d'audit statique de couverture et de liaison est close après revue indépendante PASS.** Implémentation : CDR 3137 absent du catalogue courant ; mécanisme partagé présent. Vérification : 45/45 statiques, aucun scénario 3137 exécuté. Acceptation humaine : non donnée. La règle historique, le parent, SCOPE, les tâches fonctionnelles et `SYS-01.2-02` restent ouverts.

Livrables préparés sur E : ce rapport, `validate_item3137_cdr.py`, `result.json`, reçu initial et publisher protégé. Aucun Goal, Plan, interface, application, base, registre protégé, code produit, asset, installation ou migration n'est modifié par cette préparation. La publication F sera limitée au rapport et aux deux notes de reprise après revue/empreintes.
