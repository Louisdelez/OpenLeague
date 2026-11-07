# AUD-SYS-01.2-02 — Objet 1055, FlatHPPoolMod

Lot d’audit : AUD-SYS-01.2-02-ITEM1055-HEALTH-LINK-01


Date de contrôle : 2026-11-02  
Requirement : `ITEM-1055-SERVER-STAT-FlatHPPoolMod`  
Requirement ID : `OLF-8a6f3970-6638-5772-ad9e-3339ad3c4c5f`  
Consumer enregistré : `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702`

## Conclusion bornée

L’audit statique source → donnée intégrée → consommateur Rust est clos pour le modificateur de santé plate de l’objet 1055 : la source native enregistrée donne 70, la ligne courante intégrée porte `health: 70`, et le consommateur additionne ce bonus à `max_health`.

La fonctionnalité n’est pas déclarée terminée ni acceptée. Un reçu historique rapporte quatre tests Doran réussis le 14 octobre, mais les fichiers Rust du consommateur ont changé depuis. Aucun test n’a été exécuté pendant ce contrôle; l’exécution courante reste à vérifier.

## Contrat et disponibilité historique

Le registre décrit l’exigence comme conditionnelle : implémentation requise si l’objet était historiquement disponible dans la version retenue. Cette condition est satisfaite pour ce périmètre : le fichier natif 4.20 est enregistré comme membre exact du manifeste sélectionné `lol_game_client` 0.0.1.7. Le registre lie aussi l’entrée au catalogue 4.20.1 et à la ligne locale `items.id=1055`.

La condition ne permet donc pas d’écarter l’exigence comme non applicable.

## Chaîne de preuve observée

| Étape | Résultat |
|---|---|
| Source native | `DATA/Items/1055.inibin`, client déclaré 4.20.0.315, 520 octets, source `OLS-7009b21b-648f-5338-9d1d-5beddef7c7c5`. SHA-256 `1645d84bd97510e3adc9965a0e6c31a95ddb721b991af0a81af65c9655647f38`; MD5 `6133d350cdde37daaa8d82a7c06bee47`. |
| Membership | Le reçu `OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d` marque le chemin comme `matches_selected_project_manifest`, projet `lol_game_client`, release membre 0.0.1.7. La priorité effective des overlays n’est pas qualifiée. |
| Valeur native enregistrée | `data/4.20/native_item_audit.json` associe au SHA natif `FlatHPPoolMod: 70`. |
| Donnée intégrée | `data/4.20/shop_foundation.json`, objet 1055 : `health: 70.0`, `price: 440`; `source_sha256` égale au SHA natif ci-dessus. |
| Chargement et agrégation | `crates/core/src/shop.rs` charge `shop_foundation.json` par `include_str!`, désérialise `health` dans `Bonuses.health`, puis somme ce champ pour les objets de l’inventaire. |
| Application du bonus | `crates/core/src/progression.rs` calcule `max_health = base.health + growth + items.health`. L’achat et la vente appellent `refresh_item_caps`. Le code conserve la réserve de santé absolue et la borne au nouveau maximum; le commentaire indique que la sémantique native de l’ajustement reste à qualifier. |

Le rapprochement numérique est établi dans les artefacts enregistrés. La chaîne complète de production de ces artefacts depuis le décodeur INIBIN n’a pas été rejouée pendant ce lot.

## Cas nominal, refus et reçu historique

Le test source `crates/core/tests/doran_blade.rs` vérifie l’achat de l’objet 1055, `max_health + 70`, la vente et le retour au maximum précédent. Il contient aussi des refus d’achat pour or insuffisant, position hors boutique et inventaire plein, avec assertions d’absence de mutation.

Un reçu conservé sous `E:/mapslol3v3/doran_blade_runtime_qualification/runs/20261014T062246-1d75d2972114406e8eed24feb4ca2be8/` rapporte :

- `doran_integration.log` : 4 tests réussis, 0 échec;
- test d’achat/vente et bonus : réussi;
- test des achats refusés sans changement d’état : réussi;
- binaire d’intégration SHA-256 `90dee78b8198cd356d0639e9325f1cbc6436f03929a5ee9b4814cb49317e6a9a`;
- reçu de qualification SHA-256 `8a3e464a795cf1f79d01c5ea728db4a60ab8b9142b1beecd32ddbef018f283b0`.

La correspondance des entrées montre que ce reçu historique couvre la même donnée intégrée et le même fichier de tests que la copie F courante : leurs SHA-256 sont respectivement `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae` et `bc5074f09e172a3ebf7361c758f891557f05876fa5408f02a7ad8ea4e05d3cf5`. En revanche, ses empreintes de `shop.rs` (`45a0d6807317141e8e2d9a892efcd0d1a466d080436dee15ec070c3f810d5ccb`) et `progression.rs` (`38578beb1b1a7757d765489444f580903cd56dfca8725dc01e14a228ac79331b`) diffèrent des fichiers courants F (`3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0` et `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766`). Le résultat d’octobre est donc conservé comme preuve historique et ne valide pas l’exécution de la révision actuelle.

## Inconnues et reprise

- La recherche du membre natif n’établit pas la priorité effective d’un overlay à l’exécution.
- Aucune source serveur primaire consultée ne qualifie l’ajustement de la santé courante lors d’un achat ou d’une vente; le comportement actuel conserve la réserve absolue.
- Aucun test n’a été exécuté sur les hashes actuels de `shop.rs` et `progression.rs`.
- Aucun comportement de jeu complet ni acceptation humaine n’est établi par ce lot.

Reprendre l’audit d’exécution seulement avec un reçu de test rattaché aux hashes actuels du consommateur. Reprendre l’audit de sémantique de pool si une source serveur primaire 4.20 ou un nouvel oracle de référence devient disponible. Ne pas refaire la recherche d’INIBIN, le calcul des hashes ou l’inventaire du test sans entrée nouvelle.

## Contrôles de ce lot

Lectures ciblées du registre, du source registry, de la ligne native et intégrée, du code consommateur et du test; parsing local des deux JSON d’items; vérification des empreintes enregistrées et courantes; lecture du reçu historique et de son journal de tests. Les chemins et valeurs ci-dessus sont les résultats observés.

Aucun test, build, lancement de jeu, installation ou migration n’a été exécuté pendant ce lot. Aucun code Rust, registre de suivi, goal ou base de données n’a été modifié.
