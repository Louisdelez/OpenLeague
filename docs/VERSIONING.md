# Versionnement

## Deux versions distinctes

- **4.20** : version historique du jeu reproduit ; elle ne change pas avec les releases OpenLeague.
- **0.1.0** : version actuelle d�clar�e d'OpenLeague dans les manifests ; stade de d�veloppement, sans revendication de compl�tude.

Utiliser Semantic Versioning : MAJOR.MINOR.PATCH. Avant 1.0, documenter toute rupture dans une version mineure. PATCH corrige sans ajouter un p�rim�tre majeur ; MINOR ajoute une fonctionnalit� ; MAJOR signale une rupture apr�s 1.0.

## Branches et commits

main est la branche principale. D�velopper dans feat/..., fix/... ou docs/..., avec revue et contr�les appropri�s avant fusion. Commits : feat:, fix:, docs:, test:, build:, chore:. D�crire le comportement r�ellement livr�.

Le [workflow Git](GIT_WORKFLOW.md) pr�cise la pr�paration des PR et la fusion par squash. Les types ci:, refactor:, perf: et revert: sont �galement admis. Le contr�le tools/git/check_repo.py v�rifie l'alignement des versions d�clar�es ; il ne qualifie pas une release ni la compl�tude du jeu. Les tags de pr�version peuvent porter alpha/beta/rc, tandis que les manifests gardent leur version d�clar�e selon la convention ci-dessous.

## Releases

Utiliser des tags annot�s v0.1.0-alpha.1, v0.1.0-alpha.2, puis beta et rc uniquement lorsque leurs crit�res sont atteints. Aucun tag de release ni jeu complet n'est cr�� automatiquement par l'initialisation du d�p�t.

Pour chaque release : aligner Cargo.toml, launcher/src-tauri/Cargo.toml et tauri.conf.json ; mettre � jour CHANGELOG.md ; compiler et tester le m�me commit ; publier limites, SHA-256, preuves et instructions. La version 1.0.0 n�cessite la cl�ture du p�rim�tre dans completion_plan.json et une validation depuis le paquet final.

Les assets lourds et jeux de donn�es sont distribu�s par packs dans les releases, ind�pendamment des versions du moteur. Les tags assets-AAAA-MM-JJ identifient ces packs ; ils n'annoncent pas une version finale du jeu. Chaque commit public fixe son manifeste, ses URL et ses empreintes. Ne pas remplacer silencieusement un pack d�j� publi� : cr�er un nouveau tag et mettre � jour le manifeste.
