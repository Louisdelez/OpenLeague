# Audit natif exécuté — boucle de liste Map10, arbre et garde cliente (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-ORIGINAL-LIST-LOOP-01, suite des lectures statiques V1119 et des getters isolés V1121. Question : sous une racine et une locale explicitement fournies, la boucle x86 originale remplit-elle la structure à partir des 98 entrées, et la recherche puis la garde native distinguent-elles les IDs présents des candidats absents ? Les séquences sont exercées isolément dans Unicorn; cela ne prouve ni l'initialisation ni la transaction d'une partie historique.

## Sources et contexte

Le PE client PUBLIC 4.20.0.315 relu a pour SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le fichier LEVELS/Map10/Items.inibin relu fait 657 octets, SHA-256 2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7. Le reçu V1116 SHA-256 6400cafbecdbf5d0bdf7ed7fb37a30adb1bf3dcc8938059f1d6b9694ae43e502 fournit les 150 candidats. La correspondance statique avec la garde du client est consignée en V1119; V1121 exerce déjà wrapper/cache/parseur séparément.

Le programme E:/mapslol3v3/map10_original_list_loop_audit/probe.py utilise Python 3.12.14 et Unicorn 2.1.4 déjà présents, avec modules préchargés de F:. La fixture fournit explicitement la racine deploy, la locale en_GB, la chaîne globale `LEVELS/Map10/Items.ini` ainsi que les registres de pile et de cadre. La sentinelle d'arbre est créée par la fonction native 0x6542A0 puis installée par la fixture; le formatter `Item%d` est adapté et borné. Les accès hôte de lecture/fermeture/attributs, l'allocation, la récupération CRT/thread et les diagnostics sont adaptés comme dans V1121. Ces entrées ne démontrent pas le bootstrap ni le provider historique.

## Contrôles exécutés

Commande : Python du venv F: -B sur probe.py, code 0. La séquence native 0x5B679F–0x5B6810 a réellement tourné avec ce contexte : 99 noms Item0…Item98, 98 valeurs positives correspondant au décodage indépendant, puis défaut 0 pour Item98. Le fichier natif a été ouvert une fois en rb. Les adresses de boucle, getter, insertion, wrapper et parseur ont été visitées; la sortie et les accès sont conservés dans resultats.json. L'octet auxiliaire initial lu dans cette fixture vaut 0, sans preuve qu'il ait cette valeur en partie.

L'arbre construit par la séquence native contient 95 IDs distincts. La relecture de sa structure vérifie clés triées et uniques, liens parents, sentinelle, racine noire, enfants de nœuds rouges noirs et hauteur noire égale; hauteur noire observée : 6. L'ID 1062 est présent et 1039 absent; aucun des 150 candidats V1116 ne figure dans cet arbre sous ces entrées.

La recherche native 0x5B6EEC–0x5B6F21 a ensuite été exécutée séparément contre cet arbre, avec un objet de 32 octets fourni par la fixture et son octet +0x0D initialisé à 1 : les 95 IDs présents le mettent à 0; les 150 candidats absents le laissent à 1. La garde cliente 0x81B54A a été exercée séparément avec ces deux valeurs synthétiques : 0 branche vers 0x81B6C7 et atteint l'appel de diagnostic adapté; 1 continue vers 0x81B554. Le logger est adapté, aucun message réellement affiché. Les 245 résultats et deux témoins sont conservés.

Ces essais n'exécutent pas de bout en bout la construction réelle de chaque objet, la sélection historique du provider, les flags d'inclusion, le rendu UI, une transaction ou le serveur. La transition d'octet et la garde sont démontrées seulement pour des états fournis et l'arbre produit dans cette fixture. L'absence de la liste n'établit pas qu'un candidat soit achetable historiquement.

## Preuves et reprise

PE, INIBIN et reçu candidats : empreintes ci-dessus. probe.py SHA-256 6ca98dc36bd75cce5d32983059685514b831c5516f2d2856f6d7c4b4422e5f7f; resultats.json 4bce7ddd3b286d621386b5ed78a71288d02e73a1e1344668257d34544c0e8fad. La sortie enregistre les 99 lectures, 95 IDs triés, 245 recherches, témoins de garde, accès fichiers, adresses visitées et hashes des modules. Aucun client réel n'a été démarré, aucun outil installé et aucun fichier projet modifié par la fixture.

Le consommateur OpenLeague et les tâches SYS-07.1/07.2 et ITEM-SCOPE/SHOP sont documentés séparément en V1120. Réutiliser ce résultat pour qualifier ultérieurement la sélection effective des providers, les flags d'inclusion, la construction/cache des objets et la décision serveur. Rejouer cette séquence seulement en cas de nouvelle entrée ou d'une question ciblée. Audit de ces séquences isolées terminé; le goal, les fonctionnalités et l'acceptation restent ouverts. Aucun registre, application de suivi, base, goal ou code produit modifié.
