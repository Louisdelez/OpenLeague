# SYS-01.2-02 — Blasting Wand 1026 : lien de puissance magique

Lot V832. Portée limitée : source native FlatMagicDamageMod → donnée locale → consumers Rust et admission Map10. ITEM-1026-SCOPE reste partiel; ce lot ne valide pas le bonus AP au runtime.

## Source et donnée

- Référence PUBLIC 4.20.0.315, fichier DATA/Items/1026.inibin, release déployée 0.0.1.68 : 564 octets, SHA-256 d05d7e5257977da1c641d848c51e819651221b5c21c38daca5985037ba36bde2. Le fichier original a été rehaché dans ce lot.
- Source OLS-6b884efb-f313-5720-8023-497e92cb7925. Le registre confirme le membre DATA/Items/1026.inibin du manifeste sélectionné lol_game_client (project_release 0.0.1.7, release membre 0.0.0.237, 564 octets, MD5 bf6922a39c9d72323713decf4fa268d4).
- Le lecteur local en lecture seule tools/project-plan/reference_inibin.py a décodé FlatMagicDamageMod=40, Price=860, InStore=1 et CanBeSold=1. Sa provenance est décrite dans le module; aucune installation ni modification du décodeur.
- data/4.20/shop_foundation.json#/items/17 porte ability_power=40, price=860 et le SHA natif exact. data/4.20/map10_shop_admission.json indique allowed=true.
- La tâche ITEM-1026-SCOPE est requise; la trace OLF-4f5ab96b-a244-542f-a506-a1775e534507 associe la source, l’entrée locale et le consommateur OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 (recherche du catalogue). game_behavior_accepted=false.

## Consumer courant

- crates/core/src/shop.rs:224 ajoute Item.bonuses.ability_power dans l’agrégat d’inventaire.
- crates/core/src/progression.rs:87 inclut items.ability_power dans Stats.ability_power et applique le multiplicateur de l’autel d’équipe.

Attendu : l’achat Map10 place 1026 dans l’inventaire au prix local, et le chemin de statistiques courant transmet son AP. Observé : 1026 a allowed=true; le test existant all_31_admitted_items_still_buy_through_the_normal_map10_command_path a été exécuté directement et passe 1/1, couvrant chaque objet admis dont 1026 pour l’admission, l’inventaire et le débit du prix. Il ne mesure pas Stats.ability_power après l’achat de 1026.

## Limites et contrôles

Les refus both_excluded_items_are_rejected_atomically_with_sufficient_gold_and_empty_or_full_inventory et missing_map_admission_is_unknown_and_never_invented_as_allowed passent également (1/1 chacun). Ils vérifient les exclusions 1038/1058 et la valeur inconnue; ils ne sont pas des refus propres à 1026, qui est admis.

Binaire existant : target/debug/deps/map10_shop_admission-a6a46c157264e4a3.exe, 6 056 960 octets, 2026-10-21T10:16:13Z, SHA-256 7791975EFF9F583C94791B54664393DD05447AEEF7C504D705B623B74BD4A80A. Pas de Cargo ni de recompilation. Les empreintes courantes sont enregistrées ici : shop.rs 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; progression.rs EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766; map10_shop_admission.rs 3BB3FB2959F3F085335CF1D92DF51CE883B0C15720FA1D71B36DBED5D37FE4D7; shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485. Ces fichiers sont antérieurs au binaire; aucun lien d’empreinte de compilation embarqué ne prouve que ce binaire a été produit à partir de ces empreintes exactes.

L’audit statique source → valeur locale → consumer est clos pour ce champ. L’assertion runtime +40 AP reste à faire; les tâches complètes de version, cartes, restrictions, prix et recettes, la fidélité serveur et l’acceptation humaine restent ouvertes. Aucun statut, registre, goal, plan, application ni base de suivi n’a changé.