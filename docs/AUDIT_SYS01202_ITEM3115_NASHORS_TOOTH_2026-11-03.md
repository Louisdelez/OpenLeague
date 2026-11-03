# SYS-01.2-02 — ITEM-3115-SCOPE : Nashor's Tooth

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Unité limitée au lien source native → catalogue 4.20.1 → consumer de boutique pour l’ID 3115. ITEM-3115-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin du sous-lot

Relier la preuve d’identité et les valeurs source au catalogue comparatif et au chemin réel de boutique; établir le refus local statique; traiter séparément toute source cartographique non versionnée. Ne pas convertir un état communautaire actuel en valeur historique 4.20.

## Prérequis et périmètre

La tâche ITEM-3115-SCOPE est en D07, sans dépendance de tâche; D07-ITEM-3115 déclare requires_packages=[] et dépendances vides. Les tâches fonctionnelles serveur/shop/acceptation restent ouvertes. Le gate D01-SYS-01-1 n’étant pas accepté, ce lot reste documentaire.

Inclus : identité, valeurs, prix/recette, présence des tables de shop et limite de disponibilité. Exclus : implémentation de stats, passif on-hit, interprétation du SpellName natif, achat/vente runtime, HUD, réseau et acceptation humaine.

## Sources et valeurs

Reçu natif et membership réutilisés sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json, facts.native_items.3115 :

- DATA/Items/3115.inibin : 551 octets, SHA-256 27ac3578489437cf56ebec439fd73bc97eb8f4065942283fff3eb25ad1b7c53a, MD5 79635a16fdd0e52df386c5663bb2038d.
- Membership : correspondance au membre DATA/Items/3115.inibin de lol_game_client projet 0.0.1.7, version du membre 0.0.0.243, taille/MD5 concordants. La priorité du provider runtime n’est pas qualifiée.
- Champs du reçu : Price=850, InStore=1, CanBeSold=1, UseEffect=0, SpellName=Malady, recette 3101+3108. SellBackModifier n’est pas décodé dans ce reçu. SpellName=Malady n’est pas assimilé au passif Nashor's Tooth.

Référence comparative officielle : Data Dragon 4.20.1 en_US, https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json; reçu global 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1, réutilisé sans recalcul. L’entrée relue localement : base 850, total 2920, vente 2044, composants 3101+3108, +50% Attack Speed, +60 Ability Power, +20% CDR et dégâts on-hit décrits comme 15 + 15% AP. Aucun champ maps ne figure dans cette entrée.

## Consumer actuel et attendu/observé

3115 est absent de data/4.20/shop_foundation.json (33 définitions) et de data/4.20/map10_shop_admission.json (33 admissions). Le chemin Rust commun inspecté en V1067 reste applicable : quote_with_counts refuse l’ID sans définition par item behavior not implemented; buy_item, une fois la garde de boutique satisfaite, atteint le même refus avant le contrôle Map10. Une définition sans admission produirait ensuite item map availability not qualified. Le flux commun n’a pas été réexécuté pour 3115.

Attendu catalogue 4.20.1 si intégré et autorisé : total 2920, recette 3101+3108, revente 2044. Constat natif distinct : prix de base 850, InStore=1, CanBeSold=1. Résultat local statique : absence de définition et admission, refus prédit item behavior not implemented. Aucun achat direct n’a été essayé.

## Recherche historique et limites

Question : les sources publiques consultées décident-elles l’admission de Nashor's Tooth sur Map10 pendant le patch 4.20? Une recherche ciblée a trouvé des pages ChampionCounter et Leaguepedia qui listent une disponibilité multi-cartes/toutes cartes, mais ces fiches ne sont pas datées de 4.20 et leurs états actuels ne constituent pas une preuve du client exact. La page historique ciblée de l’encyclopédie communautaire n’a pas pu être récupérée par l’outil (robots/cache). Aucun contenu n’est supposé à partir de ce refus d’accès.

Conclusion : ces pages corroborent une disponibilité large à une période non qualifiée; elles ne tranchent ni la liste de marchand en 4.20 ni le build PUBLIC 4.20.0.315. InStore=1 reste une valeur générique, pas un drapeau Map10.

## Correction et condition de reprise

Le sous-audit source → catalogue comparatif → consumer actuel est relié. L’absence locale est un manque de fonctionnalité actuel, pas une preuve d’interdiction historique. Les tâches existantes gardent la suite fonctionnelle; aucun nouvel ID n’est proposé et aucun registre ne change.

Reprendre uniquement sur une table native de marchand/admission Map10 attribuable au build, un lecteur/callsite identifié, une note officielle datée qui décide la carte ou une observation reproductible du client fourni. Ne pas refaire les hashes, le contrôle shop commun ou les mêmes recherches non versionnées sans nouvel indice.

## Vérifications et décision de clôture

Exécuté le 2026-11-03 : lecture ciblée de ITEM-3115 et du paquet D07; réutilisation du reçu natif; lecture de l’entrée locale Data Dragon 4.20.1; contrôle d’absence de 3115 dans les deux tables; réemploi du contrôle consumer V1067; recherche web bornée de disponibilité historique.

Non exécuté : rehash/re-décodage, test direct, build, lancement client, achat, passif on-hit, réseau, rendu et acceptation humaine.

Décision : sous-audit statique de la liaison terminé; scope complet ITEM-3115-SCOPE non établi car l’admission Map10 en 4.20.0.315 reste inconnue; feature/runtime non terminés; acceptation humaine non donnée. SYS-01.2-02 reste partiel.

Aucun code, goal, registre de tâches, plan, application de suivi, base de données, installation ou migration n’a été modifié.