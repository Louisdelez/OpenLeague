# SYS-01.2-02 — Sapphire Crystal 1027 : lien du bonus de mana

Lot V831. Portée limitée : source native FlatMPPoolMod vers donnée locale, consommateur Rust courant et test. Ce lot ne clôt pas ITEM-1027-SCOPE, qui reste partiel, ni la fidélité du serveur historique.

## Source et donnée

- Client PUBLIC 4.20.0.315, DATA/Items/1027.inibin, release déployée 0.0.1.68, 548 octets, SHA-256 0f9a8fe7401cf6873b9e796959d1519b8e1073e70b41127fcc60da426c378852. Le fichier original a été rehaché dans ce lot et correspond à l’identité inscrite.
- Source OLS-b2c39141-e7bc-585f-aff1-804f84914c55; le registre associe DATA/Items/1027.inibin au manifeste sélectionné lol_game_client (project_release 0.0.1.7, membre release 0.0.0.235, MD5 bb446eaca2cb421794290eb13715ec23, taille concordante).
- Valeur native décodée déjà consignée dans data/4.20/native_item_audit.json : FlatMPPoolMod=200, Price=400, InStore=true, CanBeSold=true. Elle n’a pas été redécodée dans ce lot.
- data/4.20/shop_foundation.json#/items/4 porte mana=200, price=400, sell_price=280 et le SHA natif exact. data/4.20/map10_shop_admission.json indique allowed=true.
- La trace ITEM-1027-SCOPE est requise et associe déjà la source et la donnée courante; game_behavior_accepted=false. Le consommateur enregistré OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 vise la recherche du catalogue.

## Consommateur et résultat

shop.rs:215,236 additionne Item.bonuses.mana; progression.rs:110-115 n’ajoute ce bonus au maximum que si lifecycle::uses_mana est vrai.

Attendu et observé avec le binaire unitaire existant :

| Cas | Attendu | Observé |
|---|---|---|
| Ahri achète 1027 | +200 mana maximale | mana_items_do_not_create_energy_or_manaless_resources : 1 passé |
| Akali achète 1027 | aucune création ou hausse d’une ressource énergie | même test : maximum et mana courante inchangés |
| Akali achète Faerie Charm 1004 | aucun revenu mana ajouté à sa ressource énergie | même test : revenu par seconde égal à la base |

Le test a été exécuté directement, sans Cargo ni recompilation, depuis target/debug/deps/openleague_core-21eb81eb13817108.exe (787 789 824 octets; SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D). Les empreintes actuelles de shop.rs, progression.rs, shop_foundation.json et map10_shop_admission.json correspondent au reçu V828; aucune modification de production n’est intervenue.

## Limites et reprise

Ce test qualifie le simulateur local et le traitement du pool selon le type de ressource. Il ne prouve pas la sémantique du serveur historique, la disponibilité EUW, ni l’ensemble des critères version/cartes/restrictions/prix/recettes de ITEM-1027-SCOPE. Aucun statut du plan ni acceptation humaine n’a changé.

Reprise du lien FlatMPPoolMod seulement sur une modification de source/donnée/code ou une nouvelle preuve primaire de sémantique serveur. Le reçu détaillé de l’identité native reste dans docs/fidelity_sources_4_20.json; la donnée décodée est dans data/4.20/native_item_audit.json.