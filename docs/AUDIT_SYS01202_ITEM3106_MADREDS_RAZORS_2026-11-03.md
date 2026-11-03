# SYS-01.2-02 — ITEM-3106-SCOPE : Madred's Razors

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Unité limitée au lien entre l’entrée native, le catalogue comparatif 4.20.1 et le consommateur de boutique actuel pour l’ID 3106. ITEM-3106-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin de ce sous-lot

Relier la preuve native déjà reçue à la référence versionnée et aux données/consommateurs locaux; noter le résultat statique du lookup, les limites Map10 et la condition précise permettant de résoudre l’incertitude historique. Ne pas répéter le décodage/hash ni le contrôle de flux shop partagé si aucun nouvel indice n’est apparu.

## Prérequis et périmètre

ITEM-3106-SCOPE est dans D07, dépendances de tâche vides; D07-ITEM-3106 a requires_packages=[] et dépendances vides. Le registre garde implementation_complete=false et acceptance_complete=false. Le sous-lot porte seulement sur source, comparaison catalogue, disponibilité déclarée et consumer boutique. La mécanique passive Maim est séparée dans ITEM-3106-SERVER-PASSIF; stats, shop complet, rendu, runtime, réseau et acceptation sont exclus. Le gate D01-SYS-01-1 reste non accepté; pas d’intégration de code dans ce lot documentaire.

## Sources et données

Reçu natif réutilisé sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json, entrée facts.native_items.3106 :

- DATA/Items/3106.inibin : 550 octets, SHA-256 31ce8f0a80f1d45cc673d05f77c8f7d7f901b808f26735f09933de515ce83e5d, MD5 63df9755792d8e488679dbd04aff647a.
- Membership consignée : membre correspondant DATA/Items/3106.inibin du projet lol_game_client 0.0.1.7, version membre 0.0.1.7, octets et MD5 concordants. La précédence runtime du fichier et le montage historique complet ne sont pas établis.
- Champs natifs du reçu : Price=0, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1042; aucune valeur SellBackModifier décodée dans ce reçu.

Copie locale de Data Dragon officiel 4.20.1 : E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json; source officielle versionnée https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Le reçu global conserve 237 361 octets et SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1; empreinte réutilisée, pas recalculée. L’entrée 3106 relue localement donne Madred's Razors, base 0, total 450, vente 315, achetable, composant 1042, +15% Attack Speed et carte 12 explicitement false. Le catalogue ne porte pas de valeur pour Map10; la restriction de la carte 12 ne décide pas la disponibilité historique de Twisted Treeline.

## Consumer actuel et résultat attendu / observé

Le contrôle propre à l’ID confirme que 3106 est absent de data/4.20/shop_foundation.json (33 définitions) et de data/4.20/map10_shop_admission.json (33 admissions). Le flux Rust commun a été inspecté dans le sous-lot V1067 et réutilisé sans nouvelle recherche : crates/core/src/shop.rs charge ces fichiers; quote_with_counts refuse une définition absente avec item behavior not implemented. Simulation::buy_item effectue la garde de proximité avant le lookup d’objet; si la garde passe, 3106 absent donne le refus générique avant la décision Map10. Une entrée de définition sans admission conduirait ensuite à item map availability not qualified. Aucun de ces chemins n’a été exécuté spécifiquement pour 3106.

Attendu selon le catalogue 4.20.1 si admis et intégré : coût total 450, composant 1042, +15% vitesse d’attaque, revente catalogue 315. Référence native séparée : Price=0, InStore=1, CanBeSold=1 et recette 1042. Résultat du consumer courant constaté statiquement : définition et admission absentes; refus prédit item behavior not implemented. Aucun achat direct n’a été tenté. Le passif Maim (dégâts aux monstres et soin à l’impact dans la description 4.20.1) n’est ni qualifié ni testé ici.

## Écarts, correction existante et reprise

Le lien source → comparaison officielle → consumer local est établi pour cette unité d’audit. Il ne prouve pas que l’objet était achetable sur Map10 dans le client exact PUBLIC 4.20.0.315. InStore=1 n’est pas un champ d’admission Map10. La valeur native Price=0 n’est pas remplacée par le total Data Dragon 450; les deux restent rapportés dans leurs contextes respectifs. L’absence du code local ne prouve pas une absence historique.

La correction fonctionnelle éventuelle est déjà représentée par les tâches ITEM-3106-SCOPE, ITEM-3106-SERVER-STAT-PercentAttackSpeedMod, ITEM-3106-SERVER-PASSIF, ITEM-3106-SERVER, ITEM-3106-SHOP et ITEM-3106-ACCEPT. Les statuts restent inchangés; aucun nouveau ID n’est créé.

Reprendre la décision historique uniquement avec une table marchand/admission Map10 attribuable au build 4.20.0.315, un lecteur natif établi de cette table ou une observation reproductible du client original. Ne pas rehash le même reçu et ne pas relancer le test générique sans nouvel indice.

## Vérifications et décision de clôture

Exécuté le 2026-11-03 : lecture du scope et de son paquet D07; lecture ciblée du reçu 3106 existant; lecture de l’entrée 3106 du catalogue local Data Dragon 4.20.1; contrôle d’appartenance de 3106 aux deux tables locales; réemploi du consumer/ordre de refus documenté en V1067; recherche ciblée de doublon de rapport. Le résultat source → référence → consumer est clos statiquement dans le périmètre ci-dessus.

Non exécuté : hash/re-décodage du natif, hash Data Dragon, test direct, build, exécution du client, achat, effet Maim, réseau, GPU et acceptation humaine. Aucun binaire ou asset n’a été lancé.

Décision : audit statique source/consumer de cette unité terminé; ITEM-3106-SCOPE complet non établi car Map10 4.20.0.315 reste indécidé; fonctionnalité non implémentée/vérifiée ici; acceptation humaine non donnée. SYS-01.2-02 reste partiel.

Aucun code, goal, registre de tâches, plan, application de suivi, base de données, installation ou migration n’a été modifié.
## V1069 — recherche historique ciblée sur Madred's Razors

Question : existe-t-il une indication historique de la disponibilité de l’objet sur Map10 pendant le patch 4.20, au-delà de InStore=1 et du catalogue 4.20.1? Le reçu natif, la source Data Dragon et le consumer local décrits ci-dessus ont été réutilisés; aucun hash ni contrôle shop n’a été répété.

Une recherche ciblée du domaine officiel Riot n’a pas fourni de note officielle exploitable dans cette passe. La page communautaire League of Legends Wiki pour Madred's Razors indique que l’objet était exclusif à Classic Twisted Treeline, que le patch V4.20 l’a retiré de Summoner’s Rift, et que V5.11 l’a retiré de Twisted Treeline. Elle donne également pour V4.20 la recette Dagger + 0 = 450. Cette source secondaire étaye donc une admission positive sur Map10 au niveau du patch 4.20, en cohérence avec le prix total et la carte 12=false du catalogue 4.20.1. Source consultée : https://wiki.leagueoflegends.com/en-us/Madred%27s_Razors.

Limite : l’article est une synthèse communautaire actuelle, pas un artefact Riot natif, une table merchant du build client, ni une observation du binaire PUBLIC 4.20.0.315; la date de déploiement du binaire fourni reste inconnue. Conclusion affinée : disponibilité Map10 en 4.20 fortement étayée par une source communautaire secondaire, mais pas décidée au niveau probatoire exact exigé pour ITEM-3106-SCOPE. Le statut reste a_qualifier et l’effet Maim demeure séparé. Reprise seulement sur note/archive Riot attribuable, table native/reader Map10 exacte ou observation reproductible du client fourni.