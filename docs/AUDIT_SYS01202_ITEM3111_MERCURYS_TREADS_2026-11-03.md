# SYS-01.2-02 — ITEM-3111-SCOPE : Mercury's Treads

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Unité limitée au lien entre l’entrée native, le catalogue comparatif 4.20.1 et le consumer de boutique actuel pour l’ID 3111. ITEM-3111-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin de ce sous-lot

Établir le lien source → référence versionnée → consumer actuel et documenter le refus prévu ainsi que les limites exactes de la preuve historique Map10. Réutiliser les preuves communes du consumer et ne pas inférer l’admission d’une valeur InStore ou d’un résultat web non daté.

## Prérequis et périmètre

La tâche est dans D07, avec dépendances déclarées vides; le paquet D07-ITEM-3111 indique aussi requires_packages=[] et reste a_faire. Les tâches d’implémentation/acceptation liées au serveur et au shop restent ouvertes. D01-SYS-01-1 n’est pas accepté; ce lot demeure documentaire.

Inclus : identité, prix, recette, drapeaux natifs génériques, données comparatives 4.20.1, présence dans les tables shop et résultat du lookup. Exclus : effet Tenacity en jeu, stats runtime, achat/vente exécuté, affichage, réseau et acceptation humaine.

## Sources et valeurs

Preuve native réutilisée sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json, facts.native_items.3111 :

- DATA/Items/3111.inibin, 576 octets, SHA-256 00a0b69d7a4d28ec0648b99927f01525fd1d0b95b54af7d95d4fec92ec211c0b, MD5 6ca75cd941f7951c1860cfe438f26abb.
- Membership consignée : correspondance du membre DATA/Items/3111.inibin dans lol_game_client projet 0.0.1.7, release membre 0.0.1.7, taille et MD5 concordants. La précédence runtime n’est pas qualifiée.
- Champs enregistrés : Price=375, InStore=1, CanBeSold=1, UseEffect=0, recette 1001+1033. SellBackModifier n’est pas décodé dans ce reçu.

Référence : Data Dragon officiel 4.20.1 en_US, https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Le reçu de source global donne 237 361 octets et SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1; hash réutilisé, non recalculé. L’entrée 3111 a été relue localement : base 375, total 1200, vente 840, achetable, composants 1001+1033, +25 Magic Resist, +45 Movement Speed et description Tenacity à 35%. L’objet ne porte pas de clé maps dans cette entrée. La donnée 4.20.1 ne tranche pas Map10 du build 4.20.0.315.

## Consumer actuel et résultat attendu / observé

Les contrôles spécifiques à l’ID montrent que 3111 est absent de data/4.20/shop_foundation.json (33 définitions) et de data/4.20/map10_shop_admission.json (33 admissions). Le chemin partagé, vérifié en V1067 dans crates/core/src/shop.rs, charge ces tables; quote_with_counts refuse un ID sans définition par item behavior not implemented. Simulation::buy_item passe d’abord la garde de proximité; si elle réussit, le lookup absent produit le même refus avant la règle Map10. Une définition sans admission conduirait ensuite à item map availability not qualified. Le chemin commun n’a pas été rejoué.

Attendu de la référence 4.20.1 si intégré et autorisé : coût total 1200, recette 1001+1033, vente catalogue 840. Les faits natifs séparés sont Price=375, InStore=1 et CanBeSold=1. Résultat du consumer courant établi statiquement : entrée/admission absentes et refus prévu item behavior not implemented; aucun achat direct n’a été lancé.

## Recherche historique limitée

Question : une source publique versionnée décide-t-elle l’admission de Mercury's Treads sur Map10 en 4.20? La recherche web ciblée du 2026-11-03 a renvoyé une page ChampionCounter non datée qui liste actuellement plusieurs cartes pour l’objet; elle ne spécifie ni le patch 4.20 ni le build 4.20.0.315 et n’est pas retenue comme preuve historique. La page historique ciblée de l’encyclopédie communautaire n’a pas pu être récupérée par l’outil (robots/cache); aucun contenu manquant n’est extrapolé. Cette recherche ne change donc pas la conclusion à partir des reçus.

## Écarts et condition de reprise

InStore=1 et CanBeSold=1 sont des champs génériques de l’objet; aucun ne prouve une vente ou admission Map10. La source native, la description 4.20.1 et l’absence du consumer sont reliées, mais l’état historique Map10 reste inconnu. L’absence d’intégration actuelle ne prouve pas une interdiction dans LoL 4.20.

Reprendre uniquement sur une table native marchand/admission Map10 identifiée dans le client exact, un lecteur/callsite natif de cette table, une note officielle datée attribuable ou une observation reproductible du build PUBLIC 4.20.0.315. Ne pas refaire le hash, le contrôle shop partagé ou la recherche web non datée sans nouvel indice.

## Vérifications et décision de clôture

Exécuté le 2026-11-03 : lecture ciblée du scope et paquet D07; réemploi du reçu natif et du hash Data Dragon; lecture de l’entrée locale 3111; vérification de présence/absence de 3111 dans les deux tables locales; réemploi du contrôle statique shop V1067; recherche web historique bornée et évaluation de sa portée.

Non exécuté : rehash/re-décodage, test direct, build, lancement du client, achat, effet Tenacity, réseau, rendu et acceptation humaine.

Décision : sous-audit statique source → référence → consumer terminé; qualification complète de ITEM-3111-SCOPE non établie faute de décision Map10 historique; fonctionnalité non évaluée/terminée; acceptation humaine non donnée. SYS-01.2-02 reste partiel.

Aucun code, goal, registre de tâches, plan, application de suivi, base de données, installation ou migration n’a été modifié.