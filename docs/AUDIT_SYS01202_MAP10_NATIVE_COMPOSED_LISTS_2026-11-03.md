# Audit natif composé — paramètres et listes de boutique Map10 (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-NATIVE-COMPOSED-LISTS-01. Les contrôles V1122 (boucle de liste) et V1124 (lecture de Constants.var) avaient été réalisés séparément. Question : dans une même instance d'émulation et sans reset entre lecture des paramètres et boucles, la valeur issue du fichier fourni commande-t-elle effectivement la boucle d'inclusion, tout en laissant la boucle d'exclusion accessible ? Ce lot teste une composition conditionnelle, pas le démarrage ou l'achat historique complet.

## Sources et contexte

PE client PUBLIC 4.20.0.315 SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862; LEVELS/Map10/Constants.var, 19 433 octets, 178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2; LEVELS/Map10/Items.inibin, 657 octets, 2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7. Les trois fichiers sont relus et leurs identités vérifiées. La fixture déclare la racine deploy, locale en_GB, chemin logique de liste LEVELS/Map10/Items.ini et AL=0 pour le résultat de comparaison de mode : ces valeurs ne sont pas observées en partie.

Le registre de paramètres contient seulement les deux objets d'inclusion, avec noms/vtable fournis et champs initialisés à 77. Les deux sentinelles d'arbre sont créées par une fonction native puis installées par la fixture. Les opérations hôte de lecture texte, EOF/fermeture, accès fichier binaire, allocation/copie, CRT/thread et diagnostics, ainsi que le formatter Item%d, sont adaptées et bornées. Les autres paramètres de Constants.var ne sont pas associés à un objet dans ce registre réduit.

## Contrôle exécuté

Python 3.12.14 du venv F: -B sur E:/mapslol3v3/map10_native_composed_audit/probe.py, Unicorn 2.1.4 déjà présent, code 0. Chaque cas utilise une instance Unicorn indépendante; dans un cas donné, aucun reset n'intervient entre lecteur texte, branche d'inclusion et boucles. Le lecteur natif 0x6A27D0 traite le payload, la séquence 0x5B666A–0x5B6695 calcule et stocke le flag, puis 0x5B671B–0x5B6810 exécute les boucles de listes.

- **Octets réels de Constants.var :** le lecteur consomme 19 433 octets en 191 lectures et ferme le flux; les deux paramètres deviennent 0/0. Avec AL=0 fourni, le flag calculé vaut 0. Aucune requête de la boucle ItemInclusionList n'est observée; la boucle UnpurchasableItemList demande Item0…Item98, s'arrête sur la valeur 0 et construit un arbre de 95 IDs distincts.
- **Témoin synthétique :** seule la première valeur du payload texte est changée de 0 à 1 en mémoire. Les paramètres deviennent 1/0, le flag calculé vaut 1 et le getter de ItemInclusionList est atteint une fois; il renvoie 0 pour Item0 dans cette fixture, donc son arbre reste vide. La boucle d'exclusion lit toujours 99 valeurs et construit le même ensemble de 95 IDs. Le fichier original reste inchangé.

Dans les deux cas, Items.inibin est ouvert une fois en rb sur le backend fourni; les arbres sont relus avec contrôles de clés triées, parents, sentinelles et invariants rouge/noir. Les 98 valeurs d'exclusion concordent avec le lecteur de référence et Item98 vaut le défaut 0. Les traces individuelles, accès, valeurs, hashes, branches et états figurent dans resultats.json.

Le résultat confirme conditionnellement le flux entre les deux séquences précédemment isolées. Il ne démontre pas que le fichier Constants.var est celui choisi en partie, que la locale/le mode/le provider ont ces valeurs, que le registre synthétique est complet, qu'une surcharge ultérieure n'intervient pas ou qu'une transaction serveur est autorisée. La garde cliente et sa recherche ont été exercées séparément en V1122; elles ne sont pas rejouées ici.

## Preuves et reprise

E:/mapslol3v3/map10_native_composed_audit/probe.py SHA-256 0bdf88c187af4c933e76f137b8540dadcfb779b9f24009922f25a60caad75d1e; resultats.json db61283137b9c3442d71fb8969692ce7940f7a6ff6cf23632aa1e4b26d4f7369. La sortie identifie les modules exécutés et leurs empreintes; ce n'est pas une reproduction hermétique de l'OS historique. Aucun client réel, serveur, achat, interface ou outil nouvellement installé.

Réutiliser SYS-07.1/07.2 et ITEM-<ID>-SCOPE/SHOP : qualifier d'abord le bootstrap/provider, le suffixe et les paramètres finaux ou obtenir une capture historique attribuable, puis comparer la décision serveur et le parcours client. Audit de cette composition isolée terminé; fonctionnalités, acceptation et goal demeurent ouverts. Aucun registre, application de suivi, base, goal ou code produit modifié.
