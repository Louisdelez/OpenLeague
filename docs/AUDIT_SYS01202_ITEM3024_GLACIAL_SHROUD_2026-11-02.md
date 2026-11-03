# SYS-01.2-02 — ITEM-3024-SCOPE : Glacial Shroud, source et consumer

Vérification du 2026-11-02. Lot limité au lien entre la source native enregistrée, la donnée locale et le consumer courant. Aucun code, statut, goal, registre de tâche/trace, Plan, interface ou base de suivi n’est modifié.

## Critère de fin du lot

Établir source → donnée locale → entrée de code utilisée, puis vérifier un cas nominal et une limite applicable. Distinguer cette clôture d’audit d’une fonctionnalité terminée ou acceptée.

## Sources et exigence

- Tâche ITEM-3024-SCOPE, D07 : statut conservé partiel_a_terminer; implementation_complete=false; acceptance_complete=false.
- Exigence de sous-trace OLF-8a0c48d6-44f7-56e5-a10d-2ec7ccedbf71. La trace parent SYS-01.2-02 lie la source native OLS-442d2379-ac1c-58be-9dcf-92e1e1cf8a80, la source catalogue officielle OLS-b3343643-2fe6-513b-b286-7c03b86b8409, l’entrée locale OLS-0423131f-6ac0-52ed-8973-d56afac44144 au pointeur /items/24, et le consumer OLC-b38bc16e-af3e-565e-8e4a-e8549549a702. Sous-trace : associated_sources_and_current_entrypoints; unknown_ids=[].
- Source native : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\3024.inibin. Contrat enregistré : client 4.20.0.315, 560 octets, SHA-256 09a06e48a090fc514a09b4567a3db97fcab085befbd89f6315026b4b59321bb9. Rehash de ce lot : concordant. Membership RADS concordant avec lol_game_client contenu 0.0.1.7, membre de release 0.0.0.242, MD5 60853ee37405b2a0b17487f01e5377d3.
- Le décodage conservé dans data/4.20/native_item_audit.json indique Price=250, RecipeItem1=1027, RecipeItem2=1029, FlatMPPoolMod=250, FlatArmorMod=20 et InventoryIcon=3024_Glacial_Shroud.dds. SHA-256 courant du fichier de décodage : 8490946392B459466DDC396FF681107CA4043406FD2780F41D63BD97C5D25E03. Ces champs décodés ne donnent pas de champ numérique CDR; cela ne prouve pas qu’aucune autre ressource native ne porte cette règle.
- La source officielle enregistrée est Riot Data Dragon item.json version 4.20.1, locale en_US, SHA-256 consigné 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. Elle n’a pas été re-téléchargée ou re-hachée dans ce lot.
- L’entrée courante data/4.20/shop_foundation.json contient prix total 950, recette [1027,1029], +250 mana, +20 armure, +10 % CDR (cooldown_reduction=0.1) et source_sha256 égale à l’INIBIN. Les composants sont tarifés localement 400 et 300; 400+300+250 concorde avec le total local 950. Cette cohérence arithmétique n’est pas une preuve historique du calcul de prix.
- data/4.20/map10_shop_admission.json indique 3024 allowed=true. C’est l’admission du simulateur courant, pas à elle seule une preuve de disponibilité historique sur la carte 10.

## Consumer courant

Le consumer OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 correspond au chemin boutique/catalogue dans crates/core/src/shop.rs : lookup générique item(id), agrégation de bonuses dont cooldown_reduction. crates/core/src/progression.rs transfère le total à Stats et applique cooldown::maximum_reduction(); crates/core/src/cooldown.rs convertit ensuite la réduction en ticks. Empreintes courantes :

- shop.rs : 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0
- progression.rs : EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766
- cooldown.rs : FA6ACAEDB363C33E32E345511740B7E03DF80891E2F8F0E718060F17F7083C61
- shop_foundation.json : 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE
- map10_shop_admission.json : 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485

La liaison statique est identifiable. Le test disponible agrège plusieurs objets et ne démontre pas isolément l’achat ni tous les bonus de 3024.

## Vérification exécutée

Binaire préexistant : target/debug/deps/openleague_core-21eb81eb13817108.exe, 787789824 octets, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Il est plus récent que les sources et données comparées. Aucun build ou Cargo n’a été exécuté.

Commande directe :
target/debug/deps/openleague_core-21eb81eb13817108.exe cooldown::tests::different_unique_components_stack_up_to_native_cap --exact --nocapture

Résultat : 1 test réussi, 0 échec. Les assertions vérifient que l’achat de [3108,3114,3067,3101,3024] atteint le plafond de 0,4 CDR, que ticks(10,0.5)=180 et que ticks(10,-0.2)=300 après bornage à zéro. Le succès confirme ces assertions du simulateur local, pas une mesure du jeu original. C’est une vérification de limite (plafond et réduction négative), pas un refus de l’objet 3024.

## Résultat et reprises précises

Clôturé dans ce lot : identité/version de l’INIBIN enregistrée et re-hachée, membership RADS concordant, entrée locale liée à son hash, consumer de boutique/stats/cooldown local observé, test de limite CDR exécuté.

Restent ouverts pour ITEM-3024-SCOPE et SYS-01.2-02 :

1. La disponibilité historique sur Map10 n’est pas prouvée par le seul fichier d’admission local. Reprendre sur une ligne catalogue/source 4.20 explicite ou autre preuve primaire.
2. La valeur +10 % CDR apparaît dans le catalogue local/versionné, mais pas comme champ numérique dans la ligne d’INIBIN décodée ici. Une ressource native distincte ou règle serveur n’a pas été identifiée/décodée/exécutée.
3. Aucun test isolé n’achète seulement 3024 et n’asserte coût, consommation des composants, +250 mana, +20 armure, +0,1 CDR et refus propres à l’objet. Le test de plafond agrégé ne remplace pas ce test.
4. Aucun serveur original, comparaison visuelle ou acceptation humaine n’a été vérifié.

Condition de reprise : obtenir la preuve primaire versionnée Map10 et, si disponible, celle de la propriété CDR native; pour la fonctionnalité locale, faire vérifier uniquement l’achat isolé exact de 3024. Ne pas refaire le rehash ni le test agrégé si les empreintes restent identiques.

## Addendum V1025 — source Map10 et portée de l’admission de 3024 (2026-11-03)

Ce complément réutilise les analyses croisées V996–V997 du journal de traces ; il ne répète ni le hash/décodage de DATA/Items/3024.inibin, ni le test précompilé du plafond CDR consignés plus haut.

La ressource native Map10 est physiquement sous deploy\LEVELS\Map10\Items.inibin (et non DATA\LEVELS). Sa taille est 657 octets, SHA-256 2E0E874E036429FEE1BDA6C5D1942F8E217EDA7468B6B5BEA5EAC0A4288456F7, MD5 FE5E2701DD444CDAA118C5A922DBA9D5, concordants avec la population de ressources enregistrée. Relecture ciblée avec le décodeur INIBIN local : 98 paires hachage/valeur; après normalisation des entiers stockés comme nombres et comme chaînes décimales, 95 IDs distincts. 3024 et 3025 sont absents; les contrôles 1038 et 1058 sont présents. V996–V997 rapportent que les 85 IDs dont le catalogue indique explicitement maps[10]=false sont tous présents dans la liste Map10, et qu’aucun ID explicitement true ne l’est. Ce rapprochement étaye fortement l’interprétation « liste d’exclusion Map10 », mais le nom de la propriété et le lecteur natif exact restent non établis.

Dans le snapshot distinct Data Dragon 4.20.1, l’entrée 3024 n’a pas de surcharge maps par objet; basic.maps[10]=true. La ligne locale shop_foundation contient 3024 et map10_shop_admission indique allowed=true. Ces trois constats concordent avec une admission probable, mais ni le snapshot 4.20.1, ni le JSON local ne prouvent seuls la décision historique du serveur ou du client 4.20.0.315. Le consommateur Rust courant lit map10_shop_admission; aucun branchement direct de LEVELS/Map10/Items.inibin dans ce consumer n’est établi.

**Attendu / observé et clôture.** Sous l’hypothèse étayée d’une liste d’exclusion, 3024 ne devrait pas être exclu de Map10; il est effectivement absent de la liste native et admis par le contrat local. Ce sous-audit rapproche la source Map10 et le consumer courant, et précise l’état « probablement admis ». La disponibilité historique requise par ITEM-3024-SCOPE reste ouverte, faute de mapping nommé/consumer natif ou de configuration serveur 4.20 primaire. Aucun statut n’est modifié. Reprendre uniquement sur un dictionnaire reliant les clés hachées, un callsite natif identifié ou une configuration/capture serveur datée. Ne pas refaire le census V996–V997, le hash d’ITEM 3024 ou le test CDR tant que leurs empreintes restent inchangées.
