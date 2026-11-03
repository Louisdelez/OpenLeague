# SYS-01.2-02 — ITEM-3105-SCOPE : Aegis of the Legion

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Unité limitée au lien entre l’entrée native, le catalogue comparatif 4.20.1 et le consommateur actuel de boutique pour l’ID 3105. ITEM-3105-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin de ce sous-lot

Relier les preuves déjà acquises à l’entrée 3105 et au consommateur réel, établir le résultat statique nominal/refus applicable et séparer ce résultat de l’admission historique Map10. Ne pas décider l’historique sans preuve primaire propre au client PUBLIC 4.20.0.315.

## Prérequis et périmètre

La tâche ITEM-3105-SCOPE appartient à D07 (Objets et boutique), avec depends_on=[]. Le paquet D07-ITEM-3105 ne déclare pas de paquet requis. Le registre indique néanmoins implementation_complete=false et acceptance_complete=false; les tâches serveur/shop/acceptation de l’objet restent ouvertes. Le gate D01-SYS-01-1 demeure non accepté selon l’état de reprise courant : ce lot reste documentaire et n’autorise aucune intégration fonctionnelle.

Inclus : identité et valeurs de l’objet, comparaison versionnée, présence dans les tables de boutique actuelles, contrôle statique du résultat consommateur. Exclus : comportement effectif de l’aura Legion, effets serveur, affichage, achat/exécution runtime, parité réseau et acceptation humaine.

## Sources et valeurs

Preuve native réutilisée sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json (facts.native_items.3105) :

- DATA/Items/3105.inibin, 577 octets, SHA-256 7880115003900947fb3d6e8860d94de400e61291b7f95862bcc7e865c8f86ee6, MD5 64306b930d19781ca3fd2cfe3f90faa2.
- Membership enregistrée : correspondance au membre DATA/Items/3105.inibin de lol_game_client projet 0.0.1.7, version du membre 0.0.1.7, 577 octets et MD5 concordant. La précédence runtime effective et le montage historique complet ne sont pas qualifiés par cette preuve.
- Champs natifs décodés dans le reçu : Price=820, InStore=1, CanBeSold=1, UseEffect=0, recette 1028 + 1033 + 1006; SellBackModifier est absent du reçu.

Référence comparative : Data Dragon officiel 4.20.1, https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Son reçu existant enregistre le fichier comme 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1; empreinte réutilisée, non recalculée dans ce lot. L’entrée 3105 a été relue depuis la copie locale de cette source. Elle nomme Aegis of the Legion, gold.base=820, total=1900, sell=1330, achetable, composants 1028/1033/1006, +200 Health, +20 Magic Resistance, et une aura Legion décrite comme accordant aux alliés proches +20 Magic Resist et +75% Base Health Regen. L’entrée ne contient aucune propriété maps; elle ne décide donc pas l’admission Map10. Les données 4.20.1 ne sont pas assimilées au build client 4.20.0.315.

## Consommateur actuel et résultat attendu / observé

Inspection statique des consommateurs réels :

- data/4.20/shop_foundation.json contient 33 définitions; aucune entrée 3105.
- data/4.20/map10_shop_admission.json contient 33 admissions; aucune entrée 3105.
- crates/core/src/shop.rs:36-70 charge la définition et l’admission. quote_with_counts à la ligne 86 renvoie item behavior not implemented quand la définition manque. Simulation::buy_item vérifie d’abord la proximité de boutique, puis cherche l’objet à la ligne 263; dans le cas nominal où la garde de boutique passe, l’objet absent conduit au même refus avant la règle Map10.
- Si une définition était ajoutée sans admission, le chemin d’achat atteindrait ensuite item map availability not qualified (lignes 266-270). Cette branche n’a pas été exécutée.

Attendu depuis la référence 4.20.1, si l’objet est autorisé et intégré : prix de base 820, composants 1028/1033/1006, prix total 1900 et vente catalogue 1330. Constat natif distinct : InStore=1 et CanBeSold=1, sans preuve Map10. Résultat actuel observé par inspection des données/code : définition et admission absentes; résultat de refus prédit par le flux statique item behavior not implemented. Aucun achat ni appel direct n’a été exécuté.

## Écarts, correction réutilisée et conditions de reprise

La source native établit une entrée d’objet générique dans le client sélectionné; le catalogue 4.20.1 décrit le contenu comparatif; le consommateur OpenLeague actuel ne porte ni définition ni admission 3105. Ces constats ne prouvent pas que l’objet était achetable sur Twisted Treeline/Map10 dans le client exact 4.20.0.315. InStore=1 est un champ natif générique, pas une décision de carte. L’effet d’aura décrit n’est pas qualifié ni implémenté par ce sous-lot.

La correction fonctionnelle éventuelle appartient aux tâches déjà existantes (ITEM-3105-SERVER-STAT-*, ITEM-3105-SERVER, ITEM-3105-SHOP, ITEM-3105-ACCEPT). Aucun nouvel ID n’est proposé et aucun registre n’est modifié. Ces tâches ne sont pas déclarées terminées.

Condition de reprise pour trancher la disponibilité historique : obtenir une table de marchand/admission Map10 attribuable au build 4.20.0.315, un lecteur natif identifié de cette table, ou une observation reproductible du client de référence. Ne pas rehash les mêmes fichiers ni répéter le contrôle de refus générique sans nouvel élément.

## Vérifications, portée et clôture

Exécuté le 2026-11-03 : lecture ciblée des tâches ITEM-3105 et du paquet D07; lecture du reçu natif existant; lecture de l’entrée 3105 de la copie locale Data Dragon 4.20.1; présence/absence de l’ID dans les deux tables shop; inspection des lignes de lookup et de refus dans shop.rs; recherche de rapport antérieur ciblée. Résultat : la chaîne source → référence comparative → consumer actuel est reliée statiquement pour ce sous-lot.

Non exécuté : rehash de l’INIBIN et du catalogue, test unitaire/direct, build, lancement du jeu original ou OpenLeague, observation de boutique, effet d’aura, réseau, GPU, acceptation humaine. Aucun binaire ni ressource n’a été lancé. Les inconnues ci-dessus restent ouvertes.

Décision de clôture : audit statique de ce lien précis terminé; qualification complète de ITEM-3105-SCOPE non terminée (Map10 historique non décidé); implémentation non évaluée par exécution et non terminée; vérification runtime non exécutée; acceptation humaine non donnée. SYS-01.2-02 reste partiel.

Aucun code, goal, registre de tâches, plan, application de suivi, base de données, installation ou migration n’a été modifié.