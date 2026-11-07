# AUD-SYS-01.2-02 — Objet 1055, dégâts d’attaque et vol de vie

Lot d’audit : AUD-SYS-01.2-02-ITEM1055-AD-LIFESTEAL-01


Date : 2026-11-02  
Périmètre : deux exigences liées de l’objet 1055, sans reprendre le bonus de santé déjà audité séparément.

- `ITEM-1055-SERVER-STAT-FlatPhysicalDamageMod` — `OLF-b9425d28-121d-5f01-bf17-3abeaf5ed98e`
- `ITEM-1055-SERVER-STAT-PercentLifeStealMod` — `OLF-f2a8750d-57dd-51ac-ac00-d7166384b469`

## État du lot

- **Audit statique source → donnée → consommateurs : terminé** pour ces deux stats.
- **Implémentation : présente dans les chemins Rust inspectés**, sans conclure à la fidélité complète du jeu.
- **Vérification courante : non exécutée**. Les tests disponibles sont historiques et ne couvrent pas tous les hashes consommateur actuels.
- **Acceptation humaine : non fournie**.

## Prérequis et critère de disponibilité

Le plan indique que D01-SYS-01-2 requiert le paquet D01-SYS-01-1; celui-ci est encore affiché `a_faire`. La référence de client disponible précise néanmoins 4.20.0.315 / PUBLIC / EUW / en_GB, et le fichier natif de l’objet est relié au manifeste 4.20 retenu. Ce rapport réalise un audit documentaire de ces entrées seulement; aucun statut de phase, de goal ou de suivi n’est modifié.

Les deux tâches sont conditionnelles à la disponibilité historique de l’entrée. La présence exacte de `DATA/Items/1055.inibin` dans le membre sélectionné `lol_game_client` 0.0.1.7 satisfait cette condition : elles ne sont pas écartées comme non applicables.

## Sources et données reliées

La source commune est `DATA/Items/1055.inibin`, client déclaré 4.20.0.315, source `OLS-7009b21b-648f-5338-9d1d-5beddef7c7c5`. Le registre consigne 520 octets, SHA-256 `1645d84bd97510e3adc9965a0e6c31a95ddb721b991af0a81af65c9655647f38`, MD5 `6133d350cdde37daaa8d82a7c06bee47`, et une appartenance `matches_selected_project_manifest` au membre `lol_game_client` 0.0.1.7, via `OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d`. Ces preuves d’identité et de membership sont réutilisées depuis l’audit du bonus de santé de cet objet; elles n’ont pas été recalculées dans ce lot.

Le décodage enregistré dans `data/4.20/native_item_audit.json` donne `FlatPhysicalDamageMod = 7` et `PercentLifeStealMod = 0.029999999329447746`. La ligne 1055 courante dans `data/4.20/shop_foundation.json` contient `damage: 7.0` et `life_steal: 0.029999999329447746`, avec `source_sha256` égal au SHA-256 de l’INIBIN. L’empreinte courante de ce JSON reste `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae`.

La trace associe chaque exigence à la source native, à l’entrée officielle `/data/1055`, à la donnée locale `items.id=1055` et au membership, et l’associe au consumer enregistré `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702`. L’inspection ci-dessous identifie aussi les consommateurs de gameplay eux-mêmes; la présence d’un lien dans la trace ne vaut pas acceptation du comportement.

## Consommateurs Rust observés

- `crates/core/src/shop.rs:215-244` désérialise le catalogue intégré; `Bonuses.damage` et `Bonuses.life_steal` sont agrégés depuis les objets de l’inventaire.
- `crates/core/src/progression.rs:64-66, 68-100` passe `items.damage` dans `ad_components` et expose le total par `stats().damage`. Dans le chemin inspecté, l’AD local est `(base + growth + item) * altar`, puis reçoit l’ajustement distinct de Trundle Q. Le +7 direct est donc le résultat attendu dans le cas de test sans modificateur additionnel pertinent.
- `crates/core/src/progression.rs:99` expose `items.life_steal.max(0.)` dans les stats.
- `crates/core/src/lifesteal.rs:4-25` consomme cette stat lors de `basic_attack_hit` : après dégâts physiques, il soigne le champion vivant de `post_mitigation * rate` lorsque la cible n’est pas une structure et que le résultat est fini et positif. Le contrat local de cette route ne démontre pas la politique serveur native, les autres classes d’attaque ni les interactions de jeu complètes.

## Attendu, observé et contrôles

| Cas | Attendu pour la référence enregistrée | Observé |
|---|---|---|
| Achat nominal, conditions neutres | +7 au total d’AD et taux de vol de vie +0.03 environ | Les champs natifs et intégrés concordent; le consommateur courant les transmet aux stats AD et vol de vie. Le test source affirme explicitement ces deux valeurs après achat. |
| Vente | Les deux bonus de l’objet disparaissent des stats calculées | Le test source l’affirme après la vente; le code de stats recalcule les bonus à partir de l’inventaire. |
| Achat refusé | Or insuffisant, hors boutique alliée ou inventaire plein : erreur sans modification de l’état | Le test source vérifie ces cas. Le journal historique rapporte le test de refus réussi; le chemin actuel du module boutique n’a pas été exécuté dans ce lot. |
| Attaque ordinaire | Vol de vie sur les dégâts physiques post-atténuation selon le taux courant | Le consommateur statique fait ce calcul sous les gardes ci-dessus. Aucune exécution courante n’a été faite. |
| Sort/structure/attaquant mort | Pas de conclusion native générale | La route locale inspectée traite `basic_attack_hit`, exclut les structures et exige un attaquant vivant. Ces choix ne sont pas présentés comme qualification historique. |

Le test existant `crates/core/tests/doran_blade.rs` contient les assertions nominales, de vente et de refus. Le reçu du 2026-10-14 conserve un journal `doran_integration.log` indiquant 4 réussis, 0 échec; le reçu SHA-256 est `8a3e464a795cf1f79d01c5ea728db4a60ab8b9142b1beecd32ddbef018f283b0`. Ce résultat est historique : le fichier de tests, `shop_foundation.json` et `lifesteal.rs` ont les mêmes SHA-256 dans le reçu et dans F, mais `shop.rs` et `progression.rs` ont changé. Le binaire d’intégration historique ne vérifie donc pas les chemins actuels de calcul et d’achat. Le build historique indique également `complete: false` et `ordinary_gameplay_qualified: false`.

Contrôles exécutés dans ce lot : lecture ciblée des deux entrées de trace; lecture des valeurs INIBIN déjà décodées et de la ligne locale via JSON; inspection des consommateurs Rust; comparaison des empreintes courantes avec le reçu historique. Aucun test, build, lancement, installation ni migration n’a été exécuté.

## Écarts, correction et reprise

La liaison de données est cohérente pour ces deux champs. Aucun défaut de raccord précis n’a été établi dans le périmètre statique, donc aucune correction de code n’est proposée ici. La méthode active limite cette intervention à la documentation d’audit et interdit de modifier les registres ou bases du plan; aucune trace, couverture, tâche ou statut n’a été édité.

Restent ouverts : exécution sur les modules Rust courants; qualification de l’ordre d’AD et de ses modificateurs selon la référence historique; sémantique serveur du vol de vie et de ses cibles/attaques; priorité effective des overlays; acceptation humaine. Reprendre la vérification d’exécution sur un reçu lié aux hashes actuels de `shop.rs` et `progression.rs`, ou l’analyse historique si une source serveur 4.20, un nouveau binaire pertinent ou un conflit de valeur est fourni. Ne pas répéter les recherches ou hashes inchangés.

Ce rapport clôt uniquement l’audit statique des deux liens nommés. Il ne clôt ni les passifs de l’objet 1055, ni les autres objets, ni SYS-01.2-02, ni une fonctionnalité du jeu.
