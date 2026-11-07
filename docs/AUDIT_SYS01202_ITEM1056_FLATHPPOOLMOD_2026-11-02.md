# AUD-SYS-01.2-02 — Objet 1056, FlatHPPoolMod

Lot d’audit : AUD-SYS-01.2-02-ITEM1056-HEALTH-LINK-01

Date de contrôle : 2026-11-02  
Tâche : ITEM-1056-SERVER-STAT-FlatHPPoolMod  
Requirement ID : OLF-1db7319b-00f2-506b-b6b2-140bbf33ca31  
Consommateur associé dans la trace : OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b

## Résultat borné

L’audit de traçabilité source → catalogue courant → code est clos pour l’exigence de santé plate de l’objet 1056. Le client 4.20 sélectionné contient Doran’s Ring avec FlatHPPoolMod=60 et l’entrée officielle 4.20.1 confirme 60. Le catalogue de jeu courant ne contient pas l’objet 1056. Le consommateur Rust possède une voie générique pour agréger la santé des objets connus, mais la recherche de l’objet 1056 échoue avant que cette voie puisse s’appliquer.

La fonctionnalité n’est pas terminée : le résultat courant prévisible est un refus « item behavior not implemented ». Ce refus n’a pas été exécuté dans un test pendant ce lot. Le statut a_faire est conservé.

## Contrat et condition d’applicabilité

La tâche décrit « Objet 1056 — Doran’s Ring : appliquer le modificateur FlatHPPoolMod ». Le registre la marque required=false, avec la condition : implémentation requise si l’objet est historiquement disponible dans le périmètre 4.20 retenu. La condition est satisfaite : le fichier natif 1056 est identifié comme membre du manifeste lol_game_client retenu. Cela ne rend pas l’implémentation actuelle complète et n’autorise pas à exclure l’exigence.

La trace indique aussi required=false, l’état associated_sources_and_current_entrypoints, le consommateur ci-dessus, et game_behavior_accepted=false. Ces valeurs sont rapportées sans modifier le registre.

## Chaîne observée

| Élément | Résultat |
|---|---|
| Référence client | docs/reference_client_4_20.json : version 4.20.0.315, EUW, en_GB. |
| Source native | DATA/Items/1056.inibin; source OLS-04ec5370-8428-5c53-925a-41f5fb787829; 485 octets; SHA-256 861cf0f8d1d7fb17098cfd76ea28991eb82467ab3361b4322c0124a43174b12c; MD5 f522200f5cd227760bc5df55846b0682. Le fichier D a été rehaché pendant ce lot et correspond au SHA enregistré. |
| Membership | La source OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d la marque matches_selected_project_manifest pour lol_game_client, chemin DATA/Items/1056.inibin, release 0.0.1.68. La priorité effective des overlays demeure non qualifiée. |
| Valeur décodée enregistrée | data/4.20/native_item_audit.json relie au fichier natif FlatHPPoolMod=60, Price=400, InStore=true et CanBeSold=true. |
| Référence officielle | OLS-b3343643-2fe6-513b-b286-7c03b86b8409, catalogue 4.20.1 en_US; SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. La ligne /data/1056 confirme Doran’s Ring, FlatHPPoolMod=60, prix 400. |
| Catalogue courant | data/4.20/shop_foundation.json contient 33 objets et aucun id 1056; SHA-256 courant 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae. La trace locale enregistre aussi selector_exists=false pour items.id=1056. |
| Consommateur d’achat | crates/core/src/shop.rs charge shop_foundation.json; item(id) cherche uniquement dans ce catalogue. quote_with_counts et Simulation::buy_item retournent l’erreur « item behavior not implemented » si l’identifiant manque. SHA-256 courant : 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0. |
| Consommateur de statistique générique | shop::Bonuses contient health; shop::bonuses additionne ce champ pour les objets résolus depuis l’inventaire. progression::stats calcule max_health = santé de base + croissance + bonus des objets. Le lien de l’objet 1056 vers ce chemin manque, car l’ID n’a pas d’entrée de catalogue. SHA-256 courant de progression.rs : eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766. |

## Cas attendu, observation et limites

**Attendu selon les sources :** si l’objet est intégré, acheté et présent dans l’inventaire, son bonus de santé plate contribue à +60 au maximum de santé. Les détails de recalcul de la santé courante à l’achat/vente ne sont pas établis par ce lot.

**Observation statique actuelle :** l’ID 1056 n’est pas résolu par le catalogue; quote/achat atteint la branche de refus de l’objet inconnu. L’agrégateur et le calcul de max_health ne peuvent donc pas recevoir ce bonus depuis cet objet.

**Observation d’exécution :** aucun achat ni refus n’a été exécuté dans un test pendant ce lot. Le refus ci-dessus est déduit directement du code courant, pas présenté comme un résultat runtime.

La preuve officielle est une référence de catalogue en_US, tandis que la référence client choisie est EUW/en_GB. Le champ numérique concorde, mais l’alignement de toutes les métadonnées localisées et la précédence effective du client ne sont pas qualifiés ici.

## Reprise précise

Pour terminer la fonctionnalité 1056, il faudra :
1. intégrer une entrée de catalogue dont les champs et la provenance sont reliés aux ressources 4.20 et à la référence retenue;
2. exécuter sur la révision courante un cas nominal d’achat et vérifier le +60 au maximum de santé;
3. vérifier le refus pertinent (or, boutique ou inventaire selon le contrat) et l’absence de mutation d’état;
4. enregistrer les versions, hashes du code/données, binaire, commande et reçu courant; réutiliser les sources et membership déjà établis au lieu de les rehacher sans changement;
5. garder ouverts les détails que ces contrôles ne prouvent pas : ajustement de la santé courante, précédence overlay, comportement serveur historique et acceptation humaine.

Ce lot ferme uniquement l’audit statique de liaison pour ce champ. Il ne ferme pas la tâche fonctionnelle ITEM-1056, les autres champs de l’objet, ni SYS-01.2-02.

## Contrôles réellement exécutés

- lecture ciblée du registre de tâches, du registre d’identifiants, de la trace de fidélité et du registre de sources;
- rehash SHA-256 du fichier natif 1056 sur D et comparaison avec le reçu d’identité;
- lecture et parsing ciblés de native_item_audit.json, du catalogue shop_foundation.json et de la ligne 1056 du catalogue officiel 4.20.1;
- inspection statique des chemins d’achat dans shop.rs et du calcul de max_health dans progression.rs;
- relevé des hashes courants du consommateur, de progression.rs, de la donnée intégrée et de native_item_audit.json.

Aucun test, build, lancement du jeu, installation ou migration n’a été exécuté. Aucun code, registre de suivi, goal, application de suivi ou base de données n’a été modifié.