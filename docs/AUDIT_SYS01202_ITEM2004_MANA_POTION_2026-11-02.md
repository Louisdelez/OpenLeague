# SYS-01.2-02 — objet 2004 : potion de mana, source et consumer actuel

Lot V857. Critère de fin : vérifier la source item 2004, sa donnée de référence et son consumer d’usage courant; réutiliser les preuves communes intactes de V856 et ajouter un contrôle propre à la mana; noter les liaisons et sémantiques natives encore absentes. Ce lot ne clôt pas ITEM-2004-SCOPE ni l’exigence parent.

## État de trace et référence

Exigence parent OLF-3a11ace9-485c-55ae-8dff-2533902a5839; sous-exigence ITEM-2004-SCOPE, OLF-59361d69-60c3-5421-9253-23a4a8d606c3. Trace sous-exigence : associated_sources_and_current_entrypoints, aucun unknown_id, une source native, trois références et un consumer. Le source ID item est présent dans native_inputs du parent. Le registre des tâches garde ITEM-2004-SCOPE à partiel_a_terminer, implementation_complete=false, acceptance_complete=false.

Le contexte officiel 4.20.1 associé à la tâche indique Mana Potion : 100 mana sur 15 secondes, 35 pièces d’achat, 14 de revente et pile maximale 5 (source OLS-b3343643-2fe6-513b-b286-7c03b86b8409, sélecteur /data/2004). C’est la référence catalogue datée; ce n’est pas une valeur attribuable à l’INIBIN item ni une preuve de sémantique serveur.

## Sources et chaîne des données

Source native item OLS-7280ca15-830f-5756-a845-ac1a23ff6cf1 : DATA/Items/2004.inibin, client PUBLIC 4.20.0.315, 518 octets, SHA-256 aebe87e1d8f93ab561f0b01dd9b0c5cc4313eef63f3a51dfb4129cc5691e78e9. Le fichier original D: a été rehaché et correspond. Le manifeste enregistré confirme lol_game_client, projet 0.0.1.7, membre RADS 0.0.1.7, MD5 d66b76676a32249aac172e9d29b04faf. data/4.20/native_item_audit.json:1077-1096 indique Price=35, InStore=true, CanBeSold=true, SellBackModifier=0.4, MaxStack=5, UseEffect=true, SpellName=FlaskOfCrystalWater et ItemGroup=ManaPotion. Ces champs item ne contiennent pas 100/15.

La référence 4.20.1 et la ligne locale F: data/4.20/shop_foundation.json:813-827 concordent à consumable.kind=Mana, amount=100, duration_seconds=15, max_stack=5, avec le SHA natif item. L’entrée Map10 est allowed=true (map10_shop_admission.json:133-134). Le chemin de la sous-trace relie l’INIBIN item, la référence catalogue, la donnée locale et le membership; le consumer OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 est seulement le lookup générique shop.rs:69.

Piste du sort référencé par l’INIBIN : DATA/Spells/FlaskOfCrystalWater.inibin, OLS-9ab946f5-bcc8-562d-8230-b3124112af51, 859 octets, SHA-256 9849803d7c8af97e872e8a935ac0749f9dac1b496fc6ca397e54b93b08172df1, membre RADS 0.0.0.107. Le payload FlaskOfCrystalWater.luaobj OLS-bea63afb-2bec-5b43-8f67-e5d9927bd41d fait 290 octets, SHA-256 77886cd223136ebb9d476ea743bced4f97354534320273c6b94919c304bec78a; il est enregistré comme exact_selected_core_reference_payload. Les deux fichiers ont été rehachés sur D:. Ni ces sources ni le consumer de consommation ne figurent dans native_inputs/reference_inputs/current_consumers de ITEM-2004-SCOPE; les deux fichiers du sort ne figurent pas non plus dans ces liens du parent. Aucun décodeur/exécuteur de ce sort natif n’a été appliqué.

## Consumer actuel

Le chemin réel F: est crates/core/src/consumables.rs :
- use_item, ligne 8, résout le slot vers l’objet catalogue; ligne 14, Kind::Mana est associé au nom FlaskOfCrystalWater;
- ligne 19, le code refuse les champions sans mana ou au mana maximal; ligne 23, après validation, retire une unité et ajoute la durée à mana_potion_ticks;
- advance_consumables, lignes 25 et 34, applique amount / duration / TICK_RATE par tick et plafonne le mana à max_mana.

La trace item ne référence actuellement que shop.rs:69; consumables.rs n’est pas son consumer lié. Le code courant lit le kind et les valeurs du catalogue F:, pas l’INIBIN ou le luaobj du sort. Le taux local issu du catalogue est 100/(15×30) mana par tick.

## Vérifications exécutées et réutilisées

Nouveau contrôle direct : consumables::tests::ignite_reduces_health_potion_but_not_mana_and_death_clears_effects, 1 réussi, 0 échec. Sur 30 ticks, Ignite réduit le soin de la potion santé à +5 PV, tandis que 2004 ajoute 100/15 mana; la mort efface les deux timers. Le test distingue donc bien l’effet mana du modificateur appliqué au soin.

Preuves réutilisées de V856, sans les relancer : native_potion_totals_restore_over_exactly450_updates (mana +100 au terme de 450 ticks dans le scénario 2003+2004) et guards_full_pools_invalid_items_dead_and_finished_are_atomic (2004 refusé sur Garen sans mana, sans consommation). Le binaire, consumables.rs, shop_foundation.json, map10_shop_admission.json, le registre de tâches et les deux registres de fidélité conservent les mêmes empreintes qu’en V856. Le test V856 est une preuve du simulateur local, pas du serveur historique.

Nouveau test exécuté directement sur target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Résultat : 1 test réussi; aucun Cargo, build ou ajout de test.

Empreintes actuelles : consumables.rs 984EE7042FE5F1A82D15A80689F9022D9A4AFA3E7D6F92E16ADC3E37E340C6C6; native_item_audit.json 8490946392B459466DDC396FF681107CA4043406FD2780F41D63BD97C5D25E03; shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485; completion_tasks_2026-10-20.json 5C30D6F9543CC7F39E7801AB721242204F5745B60E118F793FE618B13BAEF8DA; fidelity_requirement_trace_4_20.json 05E82921FDE916BC1B576DB7F9801B87E8223B866AD1BF1205A8D3E670E60A05; fidelity_sources_4_20.json D8283F8872339087D5E2134F9342B06BC3E67D21514CE4149A1BF42B388FCC38.

## Résultat et écarts ouverts

Résolu pour ce lot : identité et membership de l’INIBIN item, valeur d’activation et nom de sort, référence 4.20.1 de 100/15, donnée F:, admission Map10, chemin d’usage courant et cas de mana indépendante d’Ignite. La relecture des empreintes confirme que les preuves communes de V856 sont encore applicables.

Ouvert : les liens de trace vers FlaskOfCrystalWater.inibin/luaobj et consumables.rs manquent; le comportement natif exact 100/15 du client/serveur 4.20 n’est pas décodé ou exécuté; le garde mana maximal est inspecté dans le code mais n’a pas de test propre à 2004 dans cette vérification; règle serveur, UI, réseau et acceptation humaine ne sont pas qualifiés. Reprendre sur une preuve primaire du sort/serveur et sur autorisation distincte d’actualiser la trace. Ne pas refaire le hash item ou les tests communs si les empreintes restent identiques.

Aucun code, registre de tâches/fidélité, goal Codex, application de suivi ou base de l’application n’a été modifié. Le seul JSON édité pour la reprise est le checkpoint local du projet.
