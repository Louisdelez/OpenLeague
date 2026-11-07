# Audit de priorisation — objets absents du catalogue courant et données Map10 (2026-11-03)

## Périmètre et résultat

Unité AUD-SYS-01.2-02-ITEM-MAP10-PRIORITY-01, suite de V1114. Question : parmi les 247 IDs natifs associés aux fiches ITEM mais absents de shop_foundation.json, quelles données locales permettent de prioriser les investigations Map10 ? Cette classification n'est ni une décision d'admission ni un audit complet par objet.

L'entrée 247 IDs et leurs identités provient de E:/mapslol3v3/item_source_link_audit/catalog_resultats.json et resultats.json, issus de V1114. La référence comparative déjà conservée data/4.20/native_ddragon_items_420.json est Data Dragon 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1, distincte du client exact PUBLIC 4.20.0.315. Les 247 ont une entrée dans ce catalogue.

## Classification exécutée

Le programme E:/mapslol3v3/item_map10_priority_audit/probe.py a lu les 247 entrées, sans résoudre implicitement les valeurs manquantes :

- 83 portent explicitement `maps[10]=false` dans leur fiche 4.20.1; 61 portent aussi `gold.purchasable=true` et 22 `false`, donnée générale non limitée à Map10.
- 164 n'ont pas de valeur 10 explicite : 121 n'ont pas d'objet maps et 43 ont un objet maps sans clé 10. Le catalogue porte `basic.maps[10]=true`, mais le présent contrôle ne qualifie ni la résolution effective de ce défaut, ni la politique historique du build exact; ces 164 ne sont pas déclarés admis.
- Sur ces 164, 150 portent `gold.purchasable=true` en 4.20.1. Pour eux, les 150 INIBIN 4.20.0.315 ont été relus, leurs tailles/SHA comparés aux identités V1114 et Data/InStore décodé avec reference_inibin.py : 150/150 valent 1. Les 14 restants ont `purchasable=false`; leurs champs natifs InStore n'ont pas été décodés dans ce lot.

Ces 150 sont des **candidats de recherche**, pas des objets déclarés achetables en 3v3. Les champs généraux purchasable/InStore et l'absence d'un override explicite ne prouvent ni l'admission historique de Map10, ni l'existence de la mécanique, ni la fidélité des prix/effets. La liste individuelle, les chemins via source_id et les hashes sont conservés dans resultats.json. Exemples de candidats : 1039, 1043, 1054, 1056 et 2041; les audits existants par objet restent prioritaires et ne sont pas annulés.

crosscheck.py a contrôlé le catalogue complet 4.20.1 : 85 fiches ont explicitement maps[10]=false; les 83 absentes du catalogue courant et les deux présentes 1038/1058 forment exactement ces 85. Cette comparaison, code 0, n'a pas relu le fichier natif Map10.

## Preuves antérieures et inconnue de règle

V996–V997 ont décodé LEVELS/Map10/Items.inibin : 95 IDs, dont les 85 exclusions explicites 4.20.1. Correction V1117 : V1075 a identifié ses 98 clés comme UnpurchasableItemList/Item0…Item97 et distingué ItemInclusionList : ces listes peuvent coexister, leur seule présence ne démontre aucune contradiction. V1078/V1080 ont lié statiquement la branche d'inclusion aux deux flags, initialisés à zéro et présents à zéro dans un Constants.var Map10; le suffixe, le provider, les surcharges et leurs valeurs effectives en partie restent inconnus. L'absence d'un ID de UnpurchasableItemList n'établit donc pas l'admission finale. Réutiliser les preuves V1075–V1085 et reprendre sur le contexte effectif ou une capture Map10 attribuable, sans répéter les scans inchangés.

Le consumer courant crates/core/src/shop.rs et la garde d'admission sont décrits dans V1114 : les 247 IDs absents du catalogue sont refusés sur le chemin d'achat après succès de shop_guard, avant la politique Map10. Cette prédiction vient du code, sans achat ni partie exécutée ici.

## Contrôles et fichiers

Commandes réellement exécutées : Python 3.12.14 du venv F:, option -B, sur probe.py et crosscheck.py; codes 0. Le lecteur reference_inibin.py SHA-256 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5 est utilisé uniquement sur les 150 candidats. Ni client, serveur historique, runtime, réseau ou achat exécuté; pas d'installation ni de recherche web.

E:/mapslol3v3/item_map10_priority_audit : probe.py SHA-256 20402032995efb9a110d40b7b0c91205ac4d21a09f0706caa7e6988ad3e2261b; resultats.json 6400cafbecdbf5d0bdf7ed7fb37a30adb1bf3dcc8938059f1d6b9694ae43e502; crosscheck.py b036ec669f20f4a4597ea353b53c686d6accb66101e54523cac50667afbe8b2d; crosscheck.json 2220afae880ffd5b281985477988ee8110c60eaed9e66377ad22ca9362a6d242. L'entrée V1114 resultats.json a pour SHA 4ba7b89c666257d17a4f4cbb06d90c757946a3d3fdd8919cfc1fada31289a90d; sa comparaison de catalogue 1538b353bc3e154127b8732e4779cd25b65976916772fd34451fb189f540e922.

## Reprise

Classification des 247 fiches de référence terminée pour ce snapshot, pas l'audit d'admission historique. Réutiliser les fiches ITEM-<ID>-SCOPE, SHOP et SERVER existantes : prioriser les 150 candidats en tenant compte des audits déjà réalisés, rechercher la politique historique de Map10, puis seulement qualifier effets, achats et tests applicables. Les 83 exclusions explicites de 4.20.1 et 14 non achetables globalement nécessitent elles aussi leur contexte de version/mode; ne pas les supprimer. Aucune modification de goal, registre, application de suivi, base ou code produit; SYS-01.2-02 reste ouvert.


## Rectification V1117 — liste Map10 et inclusion (2026-11-03)

La version initiale de V1116 sous-estimait les preuves V1075–V1085 : le nom des 98 clés et la séparation des deux listes sont établis par les contrôles documentés, et leur coexistence ne constitue pas une contradiction. Le paragraphe concerné ci-dessus a été corrigé. La version initiale est conservée dans E:/mapslol3v3/item_map10_priority_audit/report.txt. Cette rectification ne qualifie ni le provider, ni les valeurs effectives des flags, ni l'admission d'un objet en partie. Aucun registre ou application modifié.
