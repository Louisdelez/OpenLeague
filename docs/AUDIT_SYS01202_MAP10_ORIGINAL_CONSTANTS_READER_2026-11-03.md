# Audit natif exécuté — lecture des paramètres d'inclusion Map10 (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-ORIGINAL-CONSTANTS-READER-01, suite de V1078/V1080 et complément aux essais de liste V1122. Question : avec le fichier Constants.var identifié et un registre de deux paramètres fourni explicitement, que font le lecteur texte, le lookup et les setters originaux, puis la branche native d'inclusion ? L'expérience s'exécute dans Unicorn et ne démontre pas la sélection effective de cette configuration en partie.

## Source et conditions de fixture

Le fichier original fourni `LEVELS/Map10/Constants.var` a été relu : 19 433 octets, SHA-256 178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2; 191 lignes physiques, 246 octets maximum par ligne. Le PE client PUBLIC 4.20.0.315 relu a pour SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le fichier contient deux affectations à zéro : it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly.

Le harnais existant OriginalConfigReader a été étendu à l'extérieur du projet pour présenter un flux texte borné. La fixture fournit le chemin logique, un registre synthétique contenant seulement les deux objets, leurs noms et la vtable originale 0x1084F24; leurs champs à +0xC commencent à la sentinelle 77. L'ouverture logique en mode rt, lecture par ligne, EOF et fermeture sont adaptées en mémoire; leurs détails et appels sont dans le programme. Les autres paramètres du fichier ne trouvent pas d'objet dans ce registre réduit : ce test ne qualifie pas le traitement complet de tous les paramètres. Allocation/copie, thread/CRT et diagnostics sont également adaptés; la sémantique EOF Windows complète n'est pas revendiquée.

## Contrôles exécutés

Python 3.12.14 du venv F:, Unicorn 2.1.4 déjà présent; programme E:/mapslol3v3/map10_original_constants_audit/probe.py, code 0. Les modules et leurs empreintes sont dans resultats.json. Le lecteur natif 0x6A27D0, le lookup 0x6A2770, le setter 0x574A30 et sscanf 0xC98A11 sont visités dans l'émulateur.

- Avec les octets réels, le lecteur retourne 1, consomme les 19 433 octets en 191 lectures, ferme le flux et les deux champs deviennent 0/0. Le bloc natif 0x5B666A–0x5B6689, exercé séparément avec AL fourni à 0 puis 1, renvoie 0 dans les deux cas.
- Variante synthétique créée uniquement en mémoire : remplacer la première valeur 0 par 1 conduit à 1/0, puis le bloc renvoie 1 pour AL=0 et AL=1.
- Autre variante synthétique : remplacer cette première valeur par `BAD` laisse sa sentinelle 77, tandis que le second champ devient 0. Le lecteur retourne néanmoins 1 et ferme le flux; le bloc testé avec cette sentinelle non nulle renvoie 1. Ce cas démontre qu'un retour global positif de cette fixture ne garantit pas qu'une valeur individuelle ait été acceptée. Il ne décrit pas le contenu du fichier historique.

AL est fourni directement dans les essais de branche; ni la comparaison réelle de mode, ni un montage provider ou une transaction ne sont exécutés ici. Les variantes ne sont pas écrites sur disque et le fichier original n'est pas modifié. Un premier essai exploratoire de l'agent de lecture a échoué avant ouverture par initialisation incomplète des marqueurs; le programme conservé initialise ces marqueurs avant le constructeur et a réussi. Aucun échec n'a été interprété comme un comportement du client.

## Limites et reprise

V1080 avait établi statiquement les affectations et le mécanisme; ce lot démontre le traitement du fichier fourni sur un registre réduit. V1122 a exercé séparément la boucle d'exclusion et sa garde. Les deux résultats ne constituent pas encore une exécution intégrée du démarrage : le choix du provider, du suffixe, la construction du registre réel, les autres paramètres, l'ordre et les surcharges finales restent inconnus. Aucune décision d'achat du serveur n'est prouvée. Réutiliser les tâches SYS-07.1/07.2 et ITEM-<ID>-SCOPE/SHOP; reprendre sur une preuve du contexte effectivement choisi ou un montage natif contrôlé qui ne remplace pas silencieusement les entrées.

## Preuves

E:/mapslol3v3/map10_original_constants_audit/probe.py SHA-256 bd6e450a050c87c992d437b8feaf7b1f9c7fd328dbff2797e2df867f141b019f; resultats.json 4535d5b051a9606ed91a33c060d638301ee340eb30a93000c2fa816d94d2e0ee. Le JSON conserve les trois cas, SHA des payloads, octets consommés, lectures, valeurs, adresses visitées, chemins et empreintes des modules. Ni client historique, serveur ni partie n'ont été lancés; aucune installation. Audit de cette fixture terminé, implémentation produit et acceptation non évaluées. Goal, registres, application de suivi, bases et code produit inchangés.
