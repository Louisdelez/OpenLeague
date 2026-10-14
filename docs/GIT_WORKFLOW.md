# Git et GitHub pour OpenLeague

## R�f�rence commune

Ce guide et VERSIONING.md sont la r�f�rence versionn�e pour les humains et les assistants. AGENTS.md les relie au travail quotidien ; le skill `.agents/skills/openleague-git-workflow/SKILL.md` accompagne les op�rations Git. Les commandes ci-dessous sont ex�cut�es depuis la racine du d�p�t avec Python 3.11+.

## Branches, commits et PR

- Garder `main` comme branche d'int�gration. Utiliser une branche courte `feat/...`, `fix/...`, `docs/...`, `chore/...` ou `ci/...` par changement coh�rent.
- Pr�server le chantier actif : v�rifier `git status`, puis utiliser une copie ou un worktree s�par� pour une t�che ind�pendante. Ne pas d�placer le travail non commit� d'un autre chantier.
- Utiliser Conventional Commits : `feat`, `fix`, `docs`, `test`, `build`, `ci`, `chore`, `refactor`, `perf`, `revert`, avec un scope facultatif et `!` pour une rupture. Exemple : `fix(map): correct relic animation`. Le sujet peut �tre fran�ais ou anglais, mais doit d�crire le r�sultat r�el.
- S�lectionner explicitement les fichiers d'un commit. Relire le diff index� ; �viter un ajout global depuis une copie contenant d'autres travaux.
- Ouvrir une PR avec le mod�le du d�p�t : probl�me/r�sultat, p�rim�tre/r�f�rences, v�rifications et limites. Lier l'issue lorsqu'elle existe.
- Corriger les remarques dans la m�me PR. V�rifier le commit courant, les contr�les et les conflits avant une fusion par squash. Le titre de PR devient le message du commit d'int�gration.
- Retirer une branche de t�che apr�s confirmation de sa fusion et conservation de son travail. Ne pas r��crire l'historique public pour appliquer r�troactivement ces conventions.

## Contr�les locaux

Le gestionnaire recommand� est [prek](https://github.com/j178/prek), compatible avec `.pre-commit-config.yaml`. Apr�s installation de prek, activer les hooks sur **sa propre copie de travail** :

```powershell
prek install
prek run --all-files
```

Les hooks v�rifient le contenu index� et le format des messages. Ils ne remplacent pas les contr�les GitHub et ne sont pas activ�s automatiquement dans les autres copies de travail. Sans prek, le m�me contr�le se lance directement :

```powershell
python -B tools/git/check_repo.py --staged
```

La politique contr�le l'alignement des trois versions, les lockfiles, les r�f�rences et empreintes d�clar�es des packs, les JSON modifi�s et les fichiers modifi�s de plus de 5 MiB. Elle refuse l'ajout de caches, cl�s priv�es et contenus destin�s aux packs. Elle ne scanne pas le contenu pour d�tecter tous les secrets et ne t�l�charge pas les packs pour en v�rifier les octets.

## V�rifications de code et fid�lit�

Pour les changements Rust, lancer les commandes de compilation et tests applicables de BUILDING.md. Contr�ler le formatage du code touch� sans reformater massivement le code historique. Pour les changements d'outils, lancer leurs tests pertinents ; pour les rendus/sons/r�seau, ajouter des preuves sur l'ex�cutable concern�.

Le workflow `Repository policy` ex�cute les contr�les de d�p�t et de PR sans t�l�charger les assets ni compiler le jeu. Ces v�rifications n'attestent pas une partie compl�te. La compilation Windows, le GPU, les ressources historiques et les parties � plusieurs clients n�cessitent leurs propres sc�narios.

## Protection GitHub

Configuration cible pour `main` : PR obligatoire, historique lin�aire, refus du force-push et de la suppression, contr�les `Repository hygiene` et `PR policy` requis. �viter d'exiger une approbation d'un second humain lorsque le d�p�t n'en dispose pas. Les r�gles ne sont actives que si elles sont effectivement configur�es dans GitHub ; ce document seul ne les applique pas.

## Ressources et versions

Conserver les packs de release et `assets-manifest.json`. Ne pas migrer les ressources existantes vers Git LFS ni modifier les packs d�j� publi�s pendant un simple entretien Git. Les compilations et �tats priv�s restent ignor�s.

Une livraison du jeu suit VERSIONING.md : versions align�es, changelog, commit identifi�, paquet construit et test�, empreintes et limites. Aucune fusion ordinaire ne d�clenche une publication ou une d�claration de jeu complet. Les automates de release seront ajout�s lorsqu'un sc�nario de livraison reproductible sera qualifi�.
