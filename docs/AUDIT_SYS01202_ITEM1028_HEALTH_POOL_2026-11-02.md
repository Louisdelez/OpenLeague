# SYS-01.2-02 — Ruby Crystal 1028 : lien du bonus de vie

Lot V830. Portée limitée : source native FlatHPPoolMod vers donnée locale, consommateur Rust courant et tests. Ce lot ne clôt pas ITEM-1028-SCOPE, qui reste partiel, ni la fidélité du serveur historique.

## Source et donnée

- Client PUBLIC 4.20.0.315, DATA/Items/1028.inibin, release déployée 0.0.1.68, 605 octets, SHA-256 228dc37a101849117fc378dd97a614b5760760036641488f9c03235076f5b082. Le fichier original a été rehaché dans ce lot et correspond à l’identité inscrite.
- Source OLS-7a32193c-65dc-5a1e-b22f-bd25de211842; le registre associe DATA/Items/1028.inibin au manifeste sélectionné lol_game_client (project_release 0.0.1.7, membre release 0.0.0.244, MD5 03450410d40b997c66c8684fd620f457, taille concordante).
- Valeur native décodée déjà consignée dans data/4.20/native_item_audit.json : FlatHPPoolMod=150, Price=400, InStore=true, CanBeSold=true. Elle n’a pas été redécodée dans ce lot.
- data/4.20/shop_foundation.json#/items/5 porte health=150, price=400, sell_price=280 et le SHA natif exact. data/4.20/map10_shop_admission.json indique allowed=true.
- La trace ITEM-1028-SCOPE est requise et associe déjà la source et la donnée courante; game_behavior_accepted=false. Le consommateur enregistré OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 vise la recherche du catalogue.

## Consommateur et résultat

Le chemin Rust observé approfondit ce lien catalogue : shop.rs:215,235 additionne Item.bonuses.health; progression.rs:117 inclut ce montant dans Stats.max_health; après achat/vente, shop.rs:317-320 met à jour la capacité et limite la vie courante au nouveau maximum.

Attendu et observé avec le binaire unitaire existant :

| Cas | Attendu | Observé |
|---|---|---|
| Achat 1028 | +150 vie maximale sans soin instantané | health_pool_preserves_current_and_sale_clamps_without_revival : 1 passé |
| Vente au-dessus du nouveau maximum | capacité restaurée, vie courante limitée, sans réanimation | même test : assertions réussies |
| Niveau, mort, réapparition | bonus maintenu dans la capacité et l’inventaire | health_item_persists_through_level_gain_death_and_respawn : 1 passé |
| Refus applicables du chemin boutique | refus hors boutique, mort ou partie terminée; aucun débit | enemy_shop_dead_unknown_and_ended_guards_prevent_mutation : 1 passé; refus génériques, pas une règle spéciale de 1028 |

Les trois tests ont été exécutés directement, sans Cargo ni recompilation, depuis target/debug/deps/openleague_core-21eb81eb13817108.exe (787 789 824 octets; SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D). Les empreintes actuelles de shop.rs, progression.rs, shop_foundation.json et map10_shop_admission.json correspondent au reçu V828; aucune modification de production n’est intervenue.

## Limites et reprise

Cette preuve qualifie le simulateur local et le lien source-donnée-code. Elle ne prouve pas la règle historique d’ajustement de la vie courante à l’achat/vente : la ressource native établit la statistique, tandis que les comportements de pool testés sont ceux d’OpenLeague. Prix, recettes, restrictions complètes et disponibilité historique ne sont pas clôturés. Aucun statut du plan ni acceptation humaine n’a changé.

Reprise du lien FlatHPPoolMod seulement sur une modification de source/donnée/code ou une nouvelle preuve primaire de sémantique serveur. Le reçu détaillé de l’identité native reste dans docs/fidelity_sources_4_20.json; la donnée décodée est dans data/4.20/native_item_audit.json.