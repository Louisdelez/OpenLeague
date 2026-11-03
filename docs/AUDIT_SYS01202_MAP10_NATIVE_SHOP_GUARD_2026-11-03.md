# Audit natif — liste Map10 et garde de boutique cliente (2026-11-03)

## Périmètre et résultat

Unité AUD-SYS-01.2-02-MAP10-NATIVE-UNPURCHASABLE-CONSUMER-01. Suite des preuves V1075–V1085 et correction V1117 : rechercher un consommateur natif en aval de UnpurchasableItemList, puis confronter les 150 candidats à la ressource Map10 déjà identifiée. Le résultat ci-dessous est une liaison **statique du client** et un croisement de données, pas une observation d'une partie, une preuve du provider effectif ou une autorisation du serveur.

## Sources et vérifications effectuées

Le PE 32 bits PUBLIC 4.20.0.315 `League of Legends.exe` du deploy sélectionné a été relu : 15 973 880 octets, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. La ressource LEVELS/Map10/Items.inibin fait 657 octets, SHA-256 2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7. Le programme E:/mapslol3v3/map10_native_shop_guard_audit/probe.py vérifie l'en-tête PE32, ImageBase 0x400000, les sections et le mapping VA→octets, puis 28 instructions sélectionnées avec Capstone 5.0.6 déjà présent. Les octets précis, adresses, mnémoniques et opérandes sont conservés dans resultats.json. Les chaînes Item%d, ItemInclusionList, UnpurchasableItemList et le message de la boutique sont vérifiées dans le PE.

Le lecteur reference_inibin.py existant décode les 98 clés UnpurchasableItemList/Item0…Item97 : ensemble de hashes exact, 98 valeurs non nulles et 95 IDs distincts. Ces vérifications reproduisent V1075 pour permettre le nouveau croisement, sans qualifier le chargement effectif. Dans le reçu V1116, les 150 candidats ne figurent pas parmi les 95 valeurs de cette ressource; les 83 IDs explicitement `maps[10]=false` dans Data Dragon 4.20.1 y figurent tous. Témoins : 1062 figure dans la liste; 1039 n'y figure pas. Ce croisement ne confirme pas les 150 objets comme disponibles : autre liste, flags, provider, restrictions et serveur restent pertinents.

## Chaîne native constatée statiquement

- À 0x5B679F–0x5B680E, une boucle construit ItemN, appelle le getter 0x8B1A80 avec la section UnpurchasableItemList et arrête sur retour zéro. Une valeur non nulle est transmise à 0x5CC5B0 avec le contexte 0x14CD2B0. Le callee inspecté compare la clé à un nœud et appelle la routine d'insertion : cela relie statiquement la boucle à cette structure, sous réserve du retour du getter et de l'état du provider.
- Dans 0x5B6D80, l'identifiant à [argument+0x8C] est utilisé pour chercher dans la même structure; après correspondance, 0x5B6F1D écrit zéro à [objet+0x0D]. Le constructeur 0x5B9860 initialise précédemment le mot [objet+0x0C] à 0x0100, ce qui initialise l'octet +0x0D à 1 sur ce PE little-endian. Le chemin et le cache demeurent conditionnels.
- La routine 0x5B6FA0 peut construire/retrouver l'objet. Au point 0x81B506, son résultat non nul est placé dans EDI; après d'autres gardes, 0x81B54A teste [EDI+0x0D] et saute si nul vers le chemin qui référence le message `Item %d not marked as Purchasable`. Ce message et les instructions étayent une garde de la boutique cliente; ils ne démontrent pas à eux seuls une transaction serveur refusée.

Les preuves V1075/V1078 montrent séparément que ItemInclusionList et UnpurchasableItemList peuvent coexister. V1080/V1081/V1085 documentent des valeurs de configuration et un suffixe conditionnels. La sélection finale du fichier, les surcharges, les valeurs effectives des flags, l'état du cache et la politique serveur ne sont pas établis par ce contrôle. Aucun code du client n'a été exécuté.

## Consommateur OpenLeague et reprise

Le code courant crates/core/src/shop.rs:261 et data/4.20/map10_shop_admission.json ont été reliés en V1114–V1116 : le catalogue local et sa garde Map10 sont des mécanismes distincts de ce PE. Ils n'ont pas été modifiés ni exécutés dans ce lot. Réutiliser SYS-07.1/07.2, ITEM-<ID>-SCOPE et SHOP, ainsi que le rapport ITEM-3116 existant : qualifier le provider et les flags effectifs, puis comparer la projection cliente et la décision serveur sur des objets présents et absents de la liste. Une capture historique attribuable ou l'exécution contrôlée du chemin complet sur des entrées identifiées permettrait d'aller au-delà de la lecture statique. Ne pas répéter les recherches REA précédemment expirées sans nouvelle piste.

## Preuves

Exécution réellement effectuée : Python 3.12.14 du venv F: avec -B sur E:/mapslol3v3/map10_native_shop_guard_audit/probe.py, code 0; désassemblage et décodage en lecture seule, aucun lancement du PE ou partie. probe.py SHA-256 33f372dc267ff99c59d19631a916a1ade1bc435c9223bdd514f0034726a54443; resultats.json 815cfbbd62e69b9c36d32dd8b26610f519fc713d832a7a68d94b70d717bd6717. Reçu candidats V1116 SHA-256 6400cafbecdbf5d0bdf7ed7fb37a30adb1bf3dcc8938059f1d6b9694ae43e502; lecteur INIBIN 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5. La sortie liste les 98 valeurs et les instructions; ce n'est pas une preuve d'exécution ni une recette hermétique.

Audit de cette chaîne statique et de ce croisement clos; implémentation OpenLeague non évaluée, vérification runtime/historique et acceptation non réalisées. SYS-01.2-02 et les tâches fonctionnelles restent ouverts. Aucun goal, registre, application de suivi, base ou code produit modifié.
