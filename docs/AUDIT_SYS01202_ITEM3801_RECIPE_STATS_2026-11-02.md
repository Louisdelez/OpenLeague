# SYS-01.2-02 — Crystalline Bracer 3801 : recette et consumers

Lot V833. Portée : source native de la recette et des deux statistiques vers la donnée locale, le consumer Rust et son test existant. La tâche ITEM-3801-SCOPE est requise et reste partiel_a_terminer; ce lot n’en accepte ni l’ensemble ni la sémantique du serveur historique.

## Source et donnée

- Client PUBLIC 4.20.0.315, DATA/Items/3801.inibin, chemin de release déployée 0.0.1.68 : 560 octets, SHA-256 8cdc1dafafc1ca0508e793dbae9f7142303b195e9111a8b7221d5475a276d977. Les octets originaux ont été rehachés dans ce lot.
- Source OLS-fe282525-62eb-5edb-94f0-9a24c47f5350; le manifeste sélectionné la rattache à DATA/Items/3801.inibin dans lol_game_client, project_release 0.0.1.7, release membre 0.0.1.7, 560 octets, MD5 f19b7c784adc1726059cce5469121e16.
- Décodage lecture seule avec tools/project-plan/reference_inibin.py : Price=20, RecipeItem1=1028, RecipeItem2=1006, RecipeItem3/4=0, FlatHPPoolMod=200, PercentBaseHPRegenMod=0.5, InStore=1 et CanBeSold=1.
- La donnée locale shop_foundation.json#/items/13 porte recette [1028,1006], total price=600, health=200, health_regen_percent=0.5 et le SHA natif exact. La valeur native Price=20 est le coût incrémental de la recette après crédit des composants; le test courant observe ce coût. map10_shop_admission.json indique allowed=true.
- Sell price 420 vient de la donnée de catalogue locale/4.20.1, pas d’un décodage de prix de vente serveur dans ce lot. La trace OLF-c32aac6a-24b2-5642-8b73-7e14c788aa56 est requise, associe source et entrée locale, mais indique game_behavior_accepted=false. Son consommateur enregistré OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 est la recherche du catalogue.

## Consumers et résultat

Le consumer shop.rs:79 expose quote; le chemin d’achat débite plan.cost. shop.rs:235,237 additionne health et health_regen_percent. progression.rs:117 consomme le total santé dans max_health; la régénération est calculée dans shop.rs:184-185 à partir du taux de base et du multiplicateur d’objet.

Attendu et observé avec le binaire unitaire existant :

| Cas | Attendu | Observé |
|---|---|---|
| Acheter les composants 1028 et 1006 puis 3801 | créditer les deux composants et ne demander que 20 or supplémentaires | native_two_component_recipe_credits_both_and_does_not_double_stats : plan.cost=20, composants consommés [0,1], assertions réussies |
| Après composition | remplacer les stats des composants par +200 santé et +50 % régénération, sans doubler les bonus | même test : un emplacement d’inventaire, max_health=base+200, régénération 2.352; 1 passé |
| Recette imbriquée générique | préférer l’enfant déjà achevé et ne jamais consommer le même emplacement deux fois | nested_recipe_prefer_finished_child_and_never_consume_same_slot_twice : 1 passé; limite générique, recette synthétique, pas spécifique à 3801 |

Les deux tests ont été exécutés directement, sans Cargo ni recompilation, depuis target/debug/deps/openleague_core-21eb81eb13817108.exe (787 789 824 octets; SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D, 2026-10-21T10:19:25Z). Les empreintes courantes shop.rs 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0, progression.rs EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766, shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE et map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485 correspondent aux reçus V828/V832.

## Limites et reprise

Audit source → recette/donnée → consumers courant clos pour ce parcours. Les tests vérifient le simulateur local, pas le serveur 4.20. La disponibilité historique EUW, la sélection d’overlays, l’affichage boutique, le prix de vente natif, les règles complètes de carte et l’acceptation restent ouverts. Aucun statut, goal, plan, application ni base de suivi n’a changé.

Reprise sur une nouvelle preuve primaire ou un changement du consumer; ne pas redécoder l’INIBIN ni réexécuter ces tests inchangés pour répéter le même parcours. Le statut de ITEM-3801-SCOPE et celui de SYS-01.2-02 restent ouverts.