# Audit natif exécuté — lecture de la liste Map10 via le cache original (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-ORIGINAL-CACHE-ITEMS-01, suite de V1119. Question : sous une racine de fichiers déclarée et des adaptateurs explicites, le wrapper original consommé par la boucle de boutique peut-il lire les 98 entrées de UnpurchasableItemList depuis Items.inibin ? Les fragments originaux sont exécutés dans Unicorn; ce n'est pas un lancement du client historique ni une preuve de son contexte réel.

## Source native et liaison statique

Le binaire client PUBLIC 4.20.0.315 sélectionné est `League of Legends.exe`, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. LEVELS/Map10/Items.inibin fourni fait 657 octets, SHA-256 2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7. Identités relues avant les essais.

Les octets PE vérifiés en lecture seule à 0x5B66AA–0x5B6704 montrent une chaîne `Items.ini` remise à une méthode virtuelle de provider, puis un résultat copié dans une chaîne globale. En 0x5B67BD–0x5B67DB, cette chaîne globale est passée au getter 0x8B1A80 avec la section UnpurchasableItemList. V1119 documente la boucle en aval et la garde cliente. Cette lecture relie statiquement un nom logique et le getter, mais ne démontre pas ce que le provider historique a effectivement renvoyé.

## Contrôles natifs isolés exécutés

Python 3.12.14 du venv F:, Unicorn 2.1.4 déjà présent; imports pefile, unicorn et modules de référence préchargés depuis F: et leurs chemins/empreintes enregistrés. Aucun outil installé. Trois programmes ont été réellement exécutés avec -B : probe.py (parseur et helper), cache_probe.py (cache sans locale fournie) et cache_en_gb_probe.py (cache avec locale en_GB explicitement fournie), tous code 0. Les deux contextes de cache utilisent une racine backend déclarée `[deploy]`; cette racine et la locale sont des entrées de fixture, pas des observations historiques.

Dans le contexte en_GB, le cache original 0x8ACEF0, le constructeur 0x8AD5B0, le parseur 0x8B0380, le wrapper 0x8B1A80 et le helper 0x8AF830 ont été visités dans l'émulateur. Les accès adaptés constatent l'absence de Items_en_GB.ini et Items_en_GB.inibin dans cette racine, puis la présence de Items.inibin. Un seul flux rb ouvre le fichier natif identifié; ses 657 octets sont consommés et le flux fermé. Les 98 requêtes Item0…Item97 renvoient les mêmes 98 valeurs positives que reference_inibin.py, soit 95 IDs distincts. Item98 absent renvoie le défaut demandé : 0 ou 77 selon le test. Les 150 candidats V1116 ne figurent pas parmi les valeurs renvoyées dans ce contexte.

Le contrôle de type distingue 86 valeurs décodées en entier et 12 en chaîne par le lecteur de référence. Exemple important : Item20 est stocké sous forme de texte `3180`; le getter entier typé ne le trouve pas, tandis que le helper et le wrapper numériques originaux renvoient 3180. Il serait donc erroné de déduire un arrêt de boucle sur cette seule absence du getter typé. Le helper a également renvoyé 3180 malgré un défaut 77, puis 77 pour Item98 absent. Une entrée de chemin `../Items.ini` est refusée par le harnais : c'est une garde de fixture, pas un comportement original revendiqué.

Le contrôle séparé du parseur avec fichier fourni directement a lui aussi lu/fermé les 657 octets et retrouvé les 98 valeurs via 0x8AF830; le wrapper lui-même n'était pas exécuté dans ce premier contrôle. Les essais cache utilisent réellement le wrapper original, mais pas la boucle d'achat complète de V1119.

## Adaptateurs, limites et suite

Les fonctions machine citées s'exécutent dans une image isolée, avec racines de lecture déclarées. Les feuilles hôte d'ouverture, lecture, fermeture et attributs de fichiers, l'allocation/copie, l'identité de thread, l'acquisition des données CRT et les diagnostics sont adaptées par le harnais; les accès fichiers sont bornés en lecture seule et la suppression de répertoire est refusée. Le bootstrap historique des providers, leur ordre, d'autres archives/overlays, le suffixe réellement demandé, les flags effectifs, les éventuelles écritures ultérieures, la boucle de boutique, le serveur et une transaction en partie ne sont pas qualifiés. en_GB est une entrée déclarée cohérente avec la référence, pas la preuve d'une sélection historique effective.

Le consommateur OpenLeague local `shop.rs` et l'admission Map10 ont été testés séparément en V1120. Réutiliser SYS-07.1/07.2 et les fiches ITEM-SCOPE/SHOP : qualifier le provider et la configuration effectifs, puis comparer les décisions cliente et serveur sur des IDs présents et absents de la liste. Ne pas traiter l'absence des 150 candidats de cette liste comme une admission finale.

## Preuves

PE et INIBIN : empreintes ci-dessus. E:/mapslol3v3/map10_original_parser_audit : probe.py SHA-256 b19d7ce542aac2768cccb2b35eeb7bb77ff60b148ae2b55a9efc77c0fb82d471; resultats.json f4e3d48fe507b0c9ca5c98e2b6b33df63cecd1175bbae93d17e6639ede57b1fe; cache_probe.py a13b6265c3ee0b116b0467432868011267d5c0ff528aefa26abd7ed1d26a3e85; cache_resultats.json 183257a90f3576d4d9fa4571a86cba9e7fde921784eac0419e12f5e07cfe8ed5; cache_en_gb_probe.py 4b0774ffd711aad1f679c3f00b46cef5ab63023f28d0aeda34d8d1803d8ced39; cache_en_gb_resultats.json cea40313cb48000a2c37c47a6a2ff692e3d7e6efdaeea5f0692356252bb510ff. Les résultats conservent les ouvertures, accès, lectures, adresses visitées, valeurs et SHA des modules/adaptateurs; ils ne constituent pas une reproduction hermétique de l'OS historique.

Audit de ce chemin isolé terminé; admission historique, implémentation globale et acceptation demeurent ouvertes. Aucun goal, registre, application de suivi, base ou code produit modifié.
