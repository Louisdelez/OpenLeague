# AUD-SYS-01.2-02 — Objet 1056, FlatMagicDamageMod

Lot d’audit : AUD-SYS-01.2-02-ITEM1056-AP-LINK-01

Date de contrôle : 2026-11-02  
Tâche : ITEM-1056-SERVER-STAT-FlatMagicDamageMod  
Requirement ID : OLF-6efb883b-4e2f-5cd3-94a2-f7b8daf5ffc9  
Consommateur associé dans la trace : OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b

## Résultat borné

Le code courant possède un chemin générique pour ajouter l’ability power d’un objet aux stats du champion. La référence officielle 4.20.1 donne FlatMagicDamageMod=15 pour Doran’s Ring. Cependant, l’objet 1056 est absent de shop_foundation et l’export natif déjà enregistré n’expose pas FlatMagicDamageMod. La valeur +15 est donc confirmée par le catalogue officiel, mais pas par une preuve de décodage de la ressource native brute retenue.

L’audit statique du lien et du consommateur se clôt avec ces deux écarts précis. L’implémentation fonctionnelle n’est pas terminée : l’objet ne peut pas être résolu ni acheté, et aucun test d’exécution n’a été effectué. La tâche demeure a_faire.

## Contrat et applicabilité

L’exigence demande « Objet 1056 — Doran’s Ring : appliquer le modificateur FlatMagicDamageMod ». Le registre la marque required=false avec une condition d’implémentation si l’objet est historiquement disponible dans le périmètre retenu. Le fichier 1056 est membre vérifié du manifeste lol_game_client sélectionné au lot santé précédent; la condition générale d’existence de l’objet est satisfaite. Cela ne confirme pas que le champ FlatMagicDamageMod est encodé sous cette forme dans l’INIBIN 4.20.

La trace associe la source native OLS-04ec5370-8428-5c53-925a-41f5fb787829, le catalogue officiel /data/1056, l’absence actuelle de items.id=1056, et le consommateur OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b. Le registre conserve status=a_faire, implementation_complete=false et acceptance_complete=false; aucune valeur du registre n’a été modifiée.

## Sources et consommateur courant

| Élément | Résultat |
|---|---|
| Référence client | docs/reference_client_4_20.json : version 4.20.0.315, EUW, en_GB. |
| Source native réutilisée | DATA/Items/1056.inibin; source OLS-04ec5370-8428-5c53-925a-41f5fb787829. SHA-256 et membership du manifeste lol_game_client release 0.0.1.68 ont été vérifiés dans le lot AUD-SYS-01.2-02-ITEM1056-HEALTH-LINK-01; aucun nouveau rehash n’a été fait. |
| Export natif enregistré | data/4.20/native_item_audit.json, SHA-256 8490946392b459466ddc396ff681107ca4043406fd2780f41d63bd97c5d25e03. Pour l’objet 1056, la liste publiée de native_values ne contient pas FlatMagicDamageMod. La couverture du décodeur et la présence/absence de la clé dans le binaire brut ne sont pas établies. |
| Référence officielle | OLS-b3343643-2fe6-513b-b286-7c03b86b8409, catalogue Data Dragon 4.20.1 en_US, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. /data/1056 rapporte FlatMagicDamageMod=15. |
| Catalogue courant | data/4.20/shop_foundation.json ne contient pas l’id 1056; l’absence et le SHA-256 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae ont été vérifiés dans le lot santé précédent. |
| Agrégation de l’AP | crates/core/src/shop.rs déclare Bonuses.ability_power et shop::bonuses additionne les bonus ability_power des objets reconnus. SHA-256 courant de shop.rs : 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0. |
| Stat du champion | crates/core/src/progression.rs expose ability_power depuis items.ability_power, avec le multiplicateur d’autel. SHA-256 courant : eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766. |
| Échec de résolution | shop::item recherche seulement dans shop_foundation; quote et buy_item renvoient « item behavior not implemented » quand un id manque. L’effet générique AP n’est donc jamais alimenté par l’objet 1056 courant. |

## Attendu, observé et limites

**Attendu selon le catalogue officiel :** +15 d’ability power, si cette valeur est applicable au client/build retenu.

**Observé dans l’export natif :** aucune clé FlatMagicDamageMod n’est publiée pour 1056 dans l’artefact d’audit existant. Cela ne prouve pas l’absence de la clé dans l’INIBIN brut, car la couverture de l’export n’est pas établie.

**Observé dans le code et les données courantes :** le moteur sait agréger et exposer l’AP d’objets présents, mais aucun objet 1056 n’est catalogué et son chemin d’achat retourne l’erreur générique. Ce résultat vient de l’inspection statique; pas d’achat/refus exécuté pendant ce lot.

La référence officielle est en_US alors que le client retenu est EUW/en_GB. La correspondance exacte du champ natif, la précédence d’overlay et l’application en combat ne sont pas prouvées ici.

## Reprise précise

Reprendre la valeur native seulement avec un décodage identifié du fichier DATA/Items/1056.inibin qui documente les clés et types présents, ou avec une autre source primaire membre du build qui confirme FlatMagicDamageMod. Si +15 est confirmé pour le build retenu, ajouter l’entrée 1056 avec provenance et relier son champ au chemin ability_power existant; puis exécuter un achat nominal, vérifier +15 AP dans les stats attendues et vérifier les refus sans mutation. Si le champ n’est pas natif, expliquer l’écart avec Data Dragon avant de l’exclure. Réutiliser l’identité et le membership vérifiés précédemment tant que la source n’a pas changé.

L’audit est clos comme constat de consommateur générique présent, mais source de valeur native et entrée d’objet manquantes. La fonctionnalité, l’acceptation et SYS-01.2-02 restent ouverts.

## Contrôles réellement exécutés

- lecture ciblée du contrat, de la trace et de l’état de la tâche;
- réutilisation du hash/membership natif 1056 déjà vérifié; aucun rehachage répétitif;
- parsing de la ligne 1056 dans le catalogue 4.20.1 et consultation de l’export natif déjà enregistré;
- inspection de Bonuses.ability_power, de l’agrégation dans shop.rs, et de la sortie ability_power dans progression.rs;
- inspection de l’absence de l’objet dans le catalogue courant selon le rapport précédent.

Aucun test, build, lancement du jeu, installation ou migration n’a été exécuté. Aucun code, registre de suivi, goal, application de suivi ou base de données n’a été modifié.