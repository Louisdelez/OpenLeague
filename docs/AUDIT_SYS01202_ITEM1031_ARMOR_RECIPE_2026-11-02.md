# SYS-01.2-02 — objet 1031 : recette et armure

Date : 2026-11-02

## Portée et critère de clôture

Cette unité ferme l’audit du lien local source 4.20 → donnée de boutique → consommateurs d’achat et de statistiques pour l’objet 1031. Elle ne clôt ni ITEM-1031-SCOPE, ni l’intégration serveur/historique, ni SYS-01.2-02. L’implémentation et l’acceptation restent distinctes.

## Source native et donnée locale

La preuve existante de data/4.20/native_item_audit.json et de docs/fidelity_sources_4_20.json est réutilisée sans nouveau décodage ni rehash :

- Client de référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Fichier : DATA/Items/1031.inibin; source OLS-27c16d5f-5b7b-5cf6-a566-82e082cfb7f3, 528 octets, SHA-256 a238de31167478dc5f77ca152402cf3216dcedf5d8fb66751aa266691c36264c, identité de source vérifiée.
- Membership : correspond à DATA/Items/1031.inibin du manifeste sélectionné lol_game_client, projet/release 0.0.1.7; taille et MD5 concordent. La priorité runtime effective n’est pas qualifiée.
- Valeurs natives décodées et déjà enregistrées : Price=450, RecipeItem1=1029, FlatArmorMod=40, InStore=true, CanBeSold=true.
- data/4.20/shop_foundation.json : recette [1029], coût total local 750, armure +40, sell_price=525, même SHA-256. data/4.20/map10_shop_admission.json indique allowed=true.
- Le coût natif 450 est incrémental après le composant 1029; 750 total et 525 à la vente sont des valeurs du catalogue 4.20.1/local. La source native consultée ne prouve pas à elle seule le prix de vente du serveur historique.

## Consommateur actuel et vérifications

Le chemin courant est shop::quote → shop::buy_item (crédit des composants, coût restant et débit) → shop::bonuses (armure) → progression::stats (statistique du champion). L’admission Map10 est locale.

Les deux cas suivants ont été exécutés directement dans le binaire précompilé existant, sans Cargo ni recompilation :

| Cas | Attendu | Observé |
|---|---|---|
| Nominal : acheter 1029 puis 1031 | ne débiter que 450 supplémentaires, remplacer les composants par 1031, appliquer +40 armure | shop::tests::recipe_consumes_once_and_replaces_stats : 1 passé; solde 75, un 1031 en inventaire, armure de Garen +40 |
| Refus : tenter 1031 avec or insuffisant et composant 1029 | refuser sans changer or ni inventaire | shop::tests::unaffordable_recipe_preserves_components_and_gold : 1 passé; erreur d’or insuffisant, inventaire et or inchangés |

Binaire : target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, horodatage 2026-10-21 10:19:25 UTC, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Les fonctions et tests correspondants existent dans les sources courantes (crates/core/src/shop.rs, progression.rs). La provenance de compilation du binaire par rapport aux empreintes actuelles n’est toutefois pas démontrée; ces résultats attestent ce binaire précis, pas un build frais du code actuel.

Ancres courantes : shop.rs:79 (quote), 215/233 (agrégation armure), 261 (achat), 377/387 (tests); progression.rs:68/101 (stats et armure). Empreintes observées pendant le lot : shop.rs SHA-256 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; progression.rs SHA-256 EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766. Ces empreintes décrivent les sources présentes, sans établir qu’elles ont produit le binaire exécuté.
## Résultat, limites et reprise

Lien source → donnée → consumer local clos statiquement pour cette unité; les deux tests précompilés sont un contrôle complémentaire et ne prouvent pas une compilation du code courant. La fonctionnalité du jeu n’est pas déclarée terminée. ITEM-1031-SCOPE reste partiel_a_terminer, acceptance_complete=false; aucun statut n’a été changé.

Restent ouverts : disponibilité historique effective sur EUW, ordre/priorité des ressources au runtime, prix de vente historique, autres cartes, serveur réel et acceptation. La reprise de ces points exige une preuve primaire du client/serveur effectif ou un binaire de test lié aux empreintes courantes; ne pas redécoder la source déjà vérifiée sans nouvel indice.

Aucun code, registre de tâches, goal, Plan, application de suivi ou base de données modifié. Aucun logiciel installé ni migration exécutée.