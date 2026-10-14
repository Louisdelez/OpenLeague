# Git et GitHub pour OpenLeague

## Référence commune

Ce guide et VERSIONING.md sont la référence versionnée pour les humains et les assistants. AGENTS.md les relie au travail quotidien ; le skill `.agents/skills/openleague-git-workflow/SKILL.md` accompagne les opérations Git. Les commandes ci-dessous sont exécutées depuis la racine du dépôt avec Python 3.11+.

## Branches, commits et PR

- Garder `main` comme branche d'intégration. Utiliser une branche courte `feat/...`, `fix/...`, `docs/...`, `chore/...` ou `ci/...` par changement cohérent.
- Préserver le chantier actif : vérifier `git status`, puis utiliser une copie ou un worktree séparé pour une tâche indépendante. Ne pas déplacer le travail non commité d'un autre chantier.
- Utiliser Conventional Commits : `feat`, `fix`, `docs`, `test`, `build`, `ci`, `chore`, `refactor`, `perf`, `revert`, avec un scope facultatif et `!` pour une rupture. Exemple : `fix(map): correct relic animation`. Le sujet peut être français ou anglais, mais doit décrire le résultat réel.
- Sélectionner explicitement les fichiers d'un commit. Relire le diff indexé ; éviter un ajout global depuis une copie contenant d'autres travaux.
- Ouvrir une PR avec le modèle du dépôt : problème/résultat, périmètre/références, vérifications et limites. Lier l'issue lorsqu'elle existe.
- Corriger les remarques dans la même PR. Vérifier le commit courant, les contrôles et les conflits avant une fusion par squash. Le titre de PR devient le message du commit d'intégration.
- Retirer une branche de tâche après confirmation de sa fusion et conservation de son travail. Ne pas réécrire l'historique public pour appliquer rétroactivement ces conventions.

## Contrôles locaux

Le gestionnaire recommandé est [prek](https://github.com/j178/prek), compatible avec `.pre-commit-config.yaml`. Après installation de prek, activer les hooks sur **sa propre copie de travail** :

```powershell
prek install
prek run --all-files
```

Les hooks vérifient le contenu indexé et le format des messages. Ils ne remplacent pas les contrôles GitHub et ne sont pas activés automatiquement dans les autres copies de travail. Sans prek, le même contrôle se lance directement :

```powershell
python -B tools/git/check_repo.py --staged
```

La politique contrôle l'alignement des trois versions, les lockfiles, les références et empreintes déclarées des packs, les JSON modifiés, l'encodage UTF-8 des textes modifiés et les fichiers modifiés de plus de 5 MiB. Elle refuse l'ajout de caches, clés privées et contenus destinés aux packs. Elle ne scanne pas le contenu pour détecter tous les secrets et ne télécharge pas les packs pour en vérifier les octets.

## Vérifications de code et fidélité

Pour les changements Rust, lancer les commandes de compilation et tests applicables de BUILDING.md. Contrôler le formatage du code touché sans reformater massivement le code historique. Pour les changements d'outils, lancer leurs tests pertinents ; pour les rendus/sons/réseau, ajouter des preuves sur l'exécutable concerné.

Le workflow `Repository policy` exécute les contrôles de dépôt et de PR sans télécharger les assets ni compiler le jeu. Ces vérifications n'attestent pas une partie complète. La compilation Windows, le GPU, les ressources historiques et les parties à plusieurs clients nécessitent leurs propres scénarios.

## Protection GitHub

Configuration cible pour `main` : PR obligatoire, historique linéaire, refus du force-push et de la suppression, contrôles `Repository hygiene` et `PR policy` requis. Éviter d'exiger une approbation d'un second humain lorsque le dépôt n'en dispose pas. Les règles ne sont actives que si elles sont effectivement configurées dans GitHub ; ce document seul ne les applique pas.

## Ressources et versions

Conserver les packs de release et `assets-manifest.json`. Ne pas migrer les ressources existantes vers Git LFS ni modifier les packs déjà publiés pendant un simple entretien Git. Les compilations et états privés restent ignorés.

Une livraison du jeu suit VERSIONING.md : versions alignées, changelog, commit identifié, paquet construit et testé, empreintes et limites. Aucune fusion ordinaire ne déclenche une publication ou une déclaration de jeu complet. Les automates de release seront ajoutés lorsqu'un scénario de livraison reproductible sera qualifié.
