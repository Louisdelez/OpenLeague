# SYS-01.2-02 — objet 1037 : dégâts d’attaque et achat Map10

Date : 2026-11-02

## Portée de cette unité

Cette unité relie le champ FlatPhysicalDamageMod de la source native 1037 à la donnée de boutique, au consumer de dégâts d’attaque et à l’admission d’achat Map10. Elle ne clôt pas l’ensemble de ITEM-1037-SCOPE, la fidélité serveur historique, ni SYS-01.2-02.

## Source native et catalogue

Les preuves existantes sont réutilisées; aucun INIBIN n’a été décodé ou rehaché :

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source : DATA/Items/1037.inibin, OLS-3c0238b4-a342-5b4e-a81f-7c18e7ecf36a, 536 octets, SHA-256 03a7ebdb20caeef142d62896fe8fac8eb07276d1058adbb14f172698cddadd5d; identité vérifiée.
- Membership : DATA/Items/1037.inibin concorde avec le manifeste sélectionné lol_game_client, projet 0.0.1.7, release membre 0.0.0.237; taille et MD5 concordent. La priorité effective au runtime demeure inconnue.
- Valeurs natives déjà enregistrées : Price=875, FlatPhysicalDamageMod=25, InStore=true, CanBeSold=true.
- shop_foundation.json a le même SHA source, damage=25, prix=875, aucun composant; map10_shop_admission.json marque allowed=true.
- L’entrée officielle Data Dragon 4.20.1 de référence concorde sur Pickaxe, +25 dégâts et prix 875. La donnée locale est libellée « Pioche »; aucune validation UI/localisation n’est faite ici. Le sell_price local 613 n’est pas un prix de vente encodé dans les champs natifs consignés.

## Consumer et preuves réutilisées

Dans le code courant, shop::bonuses additionne Item.damage, puis progression::stats transmet items.damage au calcul des dégâts d’attaque. L’achat passe par le devis, les gardes de boutique et la politique Map10.

Le reçu V832 du test précompilé all_31_admitted_items_still_buy_through_the_normal_map10_command_path inclut l’ensemble des 31 IDs admis; puisque 1037 a allowed=true dans les données présentes, le test couvre son achat normal, son entrée en inventaire et le débit du prix local. Le test ne mesure pas Stats.damage après achat et ne prouve donc pas le +25 au runtime.

Contrôle de réutilisation effectué dans ce lot : les SHA-256 de shop.rs, progression.rs, map10_shop_admission.rs, shop_foundation.json et map10_shop_admission.json sont identiques aux empreintes du reçu V832. Le binaire reste celui documenté en V832 : map10_shop_admission-a6a46c157264e4a3.exe, 6 056 960 octets, horodatage 2026-10-21T10:16:13Z, SHA-256 7791975EFF9F583C94791B54664393DD05447AEEF7C504D705B623B74BD4A80A. Aucun test n’a été exécuté dans ce lot; le lien de compilation exact entre ce binaire précompilé et les sources observées n’est pas établi.

Ancres courantes : crates/core/src/shop.rs:79, 215, 223, 261; crates/core/src/progression.rs:61, 68, 90; crates/core/tests/map10_shop_admission.rs:69. Empreintes des sources confirmées en lecture seule : shop.rs 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; progression.rs EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766; test Map10 3BB3FB2959F3F085335CF1D92DF51CE883B0C15720FA1D71B36DBED5D37FE4D; shop_foundation.json 504AD86B20157B91B4EECB8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485.

## Résultat, limites et reprise

Le lien documentaire natif → donnée locale → consumer de dégâts et achat Map10 est établi; le test historique réutilisé confirme seulement l’admission/achat dans son binaire. Le comportement statistique +25 n’a pas de mesure runtime démontrée dans ce lot. ITEM-1037-SCOPE reste partiel_a_terminer et acceptance_complete=false.

Restent à établir : preuve d’acceptation du stat +25 avec un exécutable lié aux sources courantes, disponibilité historique par carte/file en 4.20.0.315, prix de vente historique, priorité effective au runtime et acceptation humaine. Reprendre ces points sur une preuve primaire ou un changement de consumer; ne pas redécoder le fichier natif ni rejouer le test d’admission identique sans nouvel indice.

Aucun code, registre, goal, Plan, application de suivi ou base de données modifié. Aucun test, build, installation ou migration exécuté dans ce lot.