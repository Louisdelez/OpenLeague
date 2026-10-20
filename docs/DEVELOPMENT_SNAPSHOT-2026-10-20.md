# Avancement publié — 20 octobre 2026

Ce commit sauvegarde le code et les documents présents dans la copie de développement,
sur la branche de synchronisation existante. Le jeu reste en développement ; aucun
domaine ni kit champion complet n'est déclaré terminé.

## Jeu et launcher

Le snapshot conserve les avancées de la Forêt torturée, Garen, Annie, Trundle et
Ezreal, les animations, le rendu du brouillard, les effets, l'audio, la boutique,
les sessions et les diagnostics bornés du launcher. Le dernier lot installé ajoute
ArrivalHeads à l'arrivée du E, le flash d'impact accepté du Q et Pause/Reprendre.
Le code Bevy Render modifié reste distribué avec ses licences.

La suite du 18 octobre comporte **3565 réussites** : 1923 moteur, 1541 client,
50 serveur, 40 launcher et 11 Bevy. Deux fixtures ignorées sont comptées séparément.
Les trois exécutables ont été compilés. Ces résultats sont historiques et ne sont
pas présentés comme une nouvelle exécution pour ce commit. La qualification visuelle,
audio, native et d'une partie complète reste ouverte. Les empreintes du runtime et
du reçu sont dans [le relevé JSON](development_snapshot_2026-10-20.json).

## Plan et application de suivi

Le plan du 20 octobre contient **24 parties, 2770 fiches et 42214 sous-tâches**.
Le [plan lisible](OpenLeague_PLAN_DE_TRAVAIL_A_Z.md), ses fiches, son audit et les
sources des interfaces web et Windows sont inclus. Les coches restent un suivi
manuel et ne constituent pas une preuve d'achèvement du jeu.

Le catalogue JSON dépasse 100 Mio et est donc publié sous sa forme gzip exacte.
Depuis la racine du dépôt, utiliser Python 3.11+ :

```powershell
python tools/project-plan/restore_catalog.py
python tools/project-plan/start_plan.py
```

La restauration vérifie les deux SHA-256, borne la taille décompressée et refuse
de remplacer un catalogue divergent. La base SQLite utilisateur n'est pas publiée.
La graine embarquée de l'application est conservée avec une identité revue ; aucune
note non vide n'a été trouvée dans ses états ou son historique.

Les preuves antérieures de l'application Windows annoncent 10 tests Rust et un build
release réussis, ainsi qu'une observation native et un export. Elles ne prouvent pas
une installation sur un autre PC. Voir [son mode d'emploi](../tools/project-plan-desktop/README.md).

## Ressources et limites de publication

Le manifeste garde 22 packs et 7511 entrées ; 13 packs restent uniquement locaux.
Aucune nouvelle release d'assets n'est créée par ce commit. Les gros corpus reconstruits,
binaires, caches, bases utilisateur et journaux privés restent hors Git. Une installation
autonome du jeu depuis un clone neuf reste à qualifier.

Cinq fichiers nécessaires dépassent la limite de dépôt par défaut de 5 Mio : deux
archives de comparaison, deux documents du plan et la graine SQLite de l'application.
[Leur liste](../tools/git/large-file-exceptions.json) fixe chaque chemin, taille et
SHA-256. Le contrôle refuse les autres gros fichiers, les modifications d'identité
et les chemins privés ; aucune exception de répertoire n'est ajoutée.

## Vérifications de cette publication

- 18 tests de la politique Git réussis ; contrôle du contenu indexé réussi.
- 14 tests du plan Python réussis : 12 dans la passe initiale, puis les deux tests
  HTTP rejoués avec accès réseau local après le refus des sockets dans le bac à sable.
- Catalogue gzip restauré et empreinte du JSON complet vérifiée ; fichier divergent
  non remplacé par l'outil de restauration.
- Les 1165 fichiers Rust sélectionnés correspondent exactement aux empreintes du
  runtime historiquement validé. Aucun test du jeu n'est réexécuté ici.
- Recherche ciblée de motifs de clés privées et de jetons dans les fichiers indexés :
  aucun résultat. Ce contrôle ciblé n'est pas un audit exhaustif de secrets.
- La copie de développement, son index Git et la base de suivi utilisateur restent
  inchangés par ce travail de publication.
