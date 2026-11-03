# SYS-01.2-02 — ITEM-3113-SCOPE : Aether Wisp

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Unité limitée au lien entre l’entrée native, le catalogue comparatif 4.20.1 et le consumer de boutique actuel pour l’ID 3113. ITEM-3113-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin de ce sous-lot

Relier les faits natifs, la référence versionnée et le lookup du consumer; vérifier nominal/refus statique et rechercher une preuve historique Map10 ciblée. Ne pas transformer une source communautaire d’une autre date en décision pour le build exact.

## Prérequis et périmètre

La tâche est dans D07 avec depends_on=[]; le paquet D07-ITEM-3113 a requires_packages=[] et reste a_faire. Les tâches shop et acceptance restent ouvertes. D01-SYS-01-1 n’étant pas accepté, ce lot reste documentaire et ne modifie pas le code.

Inclus : ID, prix, recette, admission déclarée et consumer boutique. Exclus : rendu, effet du bonus de mouvement, calculs runtime, achat direct, réseau et acceptation humaine.

## Source native et catalogue

Reçu natif/membership réutilisé sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json, facts.native_items.3113 :

- DATA/Items/3113.inibin : 530 octets, SHA-256 02806800cd7bfc1763affcff39bd57e6059461e221638b297e7a4a75006ba1db, MD5 aac4de3e30341dab9d77190322d1cdf5.
- Membership : correspondance du membre DATA/Items/3113.inibin dans lol_game_client projet 0.0.1.7, release du membre 0.0.0.239, taille/MD5 concordants. La priorité/montage runtime effectif n’est pas qualifié.
- Champs natifs : Price=515, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1052; aucun SpellName ou SellBackModifier décodé dans le reçu.

La référence officielle Data Dragon 4.20.1 en_US est https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Le reçu global donne 237 361 octets et SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1; hash réutilisé. L’entrée 3113 a été relue localement : Aether Wisp, base 515, total 950, vente 665, achetable, recette depuis 1052, +30 Ability Power et +5% Movement Speed. Aucun champ maps n’est présent; l’absence de champ ne constitue pas une valeur Map10.

## Consumer actuel et attendu/observé

Les deux tables locales, data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json, comptent 33 entrées chacune et omettent 3113. Le chemin partagé dans crates/core/src/shop.rs a été inspecté et documenté en V1067 : quote_with_counts renvoie item behavior not implemented en cas de définition absente; buy_item, si sa garde de boutique passe, rencontre le même refus avant la garde Map10. Une définition ajoutée sans admission donnerait ensuite item map availability not qualified. Ce flux générique n’a pas été rejoué.

Attendu depuis le catalogue 4.20.1 si intégré/autorisé : total 950, composant 1052, vente catalogue 665. Résultat statique actuel : absence de définition et d’admission; refus prévu item behavior not implemented. Aucun achat direct n’a été exécuté.

## Recherche historique et limite

Question recherchée : existe-t-il une preuve publique datée qu’Aether Wisp était proposé sur Twisted Treeline pendant le patch 4.20? Les recherches ciblées retournent des pages communautaires d’époques différentes. Un article PlayerRealm daté du 7 février 2015 décrit une version Twisted Treeline/Crystal Scar de Luden’s Echo construite à partir d’Aether Wisp et indique que ce composant pouvait être acheté pour réduire le coût restant : https://playerrealm.com/league-of-legends. Cela étaye une présence/utilisation sur TT en février 2015, mais ne décide pas l’état au build 4.20.0.315 de novembre 2014. Des pages communautaires non versionnées se contredisent sur les cartes; elles ne sont pas utilisées pour trancher l’historique. Le reçu natif InStore=1 demeure générique.

Conclusion de recherche : aucune preuve primaire ou datée du patch 4.20 trouvée dans cette passe. Ne pas déclarer l’objet disponible/inaccessible sur Map10 pour le build exact à partir de ces seuls éléments.

## Correction et condition de reprise

Le lien statique natif → catalogue comparatif → consumer actuel est établi. Le consumer ne porte ni définition ni admission 3113. Cette absence locale n’établit pas une absence dans le client original. Le package garde ses tâches existantes; aucun nouvel ID ni changement de registre n’est proposé.

Reprendre seulement sur table de marchand/admission native datée du build, lecteur/callsite attribuable, note officielle de version qui tranche la carte ou observation reproductible du client PUBLIC 4.20.0.315. Ne pas rehash ni répéter le refus shop commun sans nouvel indice.

## Vérifications et décision de clôture

Exécuté le 2026-11-03 : lecture ciblée du scope/paquet D07, reçu natif existant, entrée 3113 locale du catalogue officiel 4.20.1, appartenance aux deux tables shop, recherche historique publique bornée, réemploi du contrôle consumer V1067.

Non exécuté : rehash/re-décodage, test direct, build, lancement du jeu, achat, rendu, effet mouvement, réseau ou acceptation humaine.

Décision : sous-audit statique source → référence → consumer terminé; qualification historique complète de ITEM-3113-SCOPE non établie (Map10 4.20.0.315 inconnu); fonctionnalité/runtime non terminés; acceptation humaine non donnée. SYS-01.2-02 reste partiel.

Aucun code, goal, registre de tâches, plan, application de suivi, base de données, installation ou migration n’a été modifié.