# SYS-01.2-02 — objet 1033 : source et consommateur de résistance magique

Lot V855. Périmètre : relier l’entrée native 1033 à la donnée locale et au calcul de stats actuel. L’achat effectif, la règle serveur historique et l’acceptation restent distincts de cet audit de liaison.

## Contrat et état de la tâche

L’exigence parent est OLF-3a11ace9-485c-55ae-8dff-2533902a5839 (SYS-01.2-02). La sous-exigence ITEM-1033-SCOPE est OLF-906fa39d-191f-5af5-95d9-8cdd834a3129. Dans la trace actuelle, la sous-exigence a l’état associated_sources_and_current_entrypoints, aucun unknown_id, une source native et un consumer. La même source est présente parmi les entrées natives de l’exigence parent.

Le registre des tâches garde ITEM-1033-SCOPE à partiel_a_terminer, implementation_complete=false et acceptance_complete=false. L’audit source/consumer de ce lot est clos; cela ne clôt ni la tâche de périmètre ni SYS-01.2-02.

## Source native et donnée locale

Source enregistrée OLS-46571491-12c3-5054-a026-a167cccd643a : client PUBLIC 4.20.0.315, DATA/Items/1033.inibin, 537 octets, SHA-256 6953986c2f6453cd2b349117216c2f22a60804f8811f0d4b241a2509b8ed78bd. Le fichier original D: a été rehaché pendant ce lot; taille et SHA concordent exactement. Le manifeste sélectionné confirme l’appartenance à lol_game_client, project release 0.0.1.7, membre RADS 0.0.0.237, MD5 bc3e514d7128a6188fd064c9bded9525. Cette appartenance ne prouve pas un comportement du serveur.

L’extraction native existante, dans data/4.20/native_item_audit.json:330-342, donne FlatSpellBlockMod=25, Price=500, InStore=true et CanBeSold=true. La ligne 1033 de data/4.20/shop_foundation.json:194-212 reprend magic_resist=25, price=500, sell_price=350 et le même SHA source. data/4.20/map10_shop_admission.json:41-42 marque l’objet allowed=true. Les JSON existants ont été réutilisés; aucune nouvelle extraction ou conversion n’a été faite.

Registres consultés : docs/fidelity_requirement_trace_4_20.json SHA-256 05E82921FDE916BC1B576DB7F9801B87E8223B866AD1BF1205A8D3E670E60A05; docs/fidelity_sources_4_20.json SHA-256 D8283F8872339087D5E2134F9342B06BC3E67D21514CE4149A1BF42B388FCC38. Ils identifient la même source et son consumer courant.

## Consumer courant et contrôle exécuté

Consumer enregistré OLC-b38bc16e-af3e-565e-8e4a-e8549549a702, rôle catalog_lookup. Dans crates/core/src/shop.rs:69-71, item(id) recherche l’ID dans le catalogue; shop.rs:215-236 additionne les bonus de l’inventaire, dont v.magic_resist à la ligne 234. crates/core/src/progression.rs:105-108 combine items.magic_resist avec les autres termes de résistance magique. Le chemin pertinent est donc source native → entrée catalogue 1033 → lookup d’inventaire → bonus de stats → mitigation.

Attendu : la valeur locale 25 pour l’ID 1033 est disponible au calcul courant et le consumer de dégâts utilise la résistance effective. Observé : le test existant ezreal_e::tests::frozen_ap_cdr_current_magic_defense_shields_and_damage_error_have_one_terminal_application passe 1/1. Il équipe l’ID 1033 sur la cible, lit s.stats(b).magic_resist et vérifie que le dégât Ezreal E correspond à raw * 100 / (100 + MR). Cela exerce le consumer en aval avec l’ID concerné. Ce test n’affirme pas explicitement que MR vaut exactement la résistance de base +25 et ne teste pas un achat de 1033.

Limite/refus observé : shop::tests::enemy_shop_dead_unknown_and_ended_guards_prevent_mutation passe 1/1. Il refuse explicitement l’objet 1057 avec « not implemented » et préserve l’or; les garde-fous boutique, mort et partie terminée ne mutent pas l’état. Ce refus porte sur un autre objet non implémenté; il ne constitue pas un refus de l’objet 1033.

Les deux contrôles ont été exécutés directement avec target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Résultats : 2 tests ciblés réussis, 0 échec. Aucun rebuild ni commande Cargo dans ce lot.

Empreintes courantes : shop.rs 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; progression.rs EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766; ezreal_e_tests.rs A874B2225704B04ECAB923B0D6F66DCCD3F93C33C79D9B8D17A038040470F4C5; shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485. Les quatre premières empreintes code/données applicables concordent avec les reçus antérieurs; l’empreinte du fichier de test est aussi consignée ici.

## Résultat et reprise

Résolu : l’identité de la source 4.20, son membership RADS, la correspondance native FlatSpellBlockMod=25 vers magic_resist=25, l’entrée catalogue et le consumer de stats/mitigation actuels sont reliés et vérifiés. Le résultat attendu du lien est observé avec le test de combat existant; une limite de refus explicite a également été exercée.

Ouvert : aucun test courant ne vérifie un achat de l’objet 1033 ni n’assert la hausse exacte de 25 MR; prix/revente et disponibilité native côté serveur ne sont pas qualifiés; aucune acceptation humaine n’est fournie. Reprendre ces points sur un test d’achat ciblé ou une nouvelle preuve serveur/versionnée, ou si le code, le catalogue, la source ou le manifeste changent. Ne pas répéter le hash, l’extraction native ni la recherche du consumer tant que ces entrées restent inchangées.

Aucun code, statut de tâche, registre de tâches, plan, goal, application de suivi ou base de données de l’application n’a été modifié. SYS-01.2-02 reste partial_with_open_questions.
