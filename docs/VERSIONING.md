# Versionnement

## Deux versions distinctes

- **4.20** : version historique du jeu reproduit ; elle ne change pas avec les releases OpenLeague.
- **0.1.0** : version actuelle déclarée d'OpenLeague dans les manifests ; stade de développement, sans revendication de complétude.

Utiliser Semantic Versioning : MAJOR.MINOR.PATCH. Avant 1.0, documenter toute rupture dans une version mineure. PATCH corrige sans ajouter un périmètre majeur ; MINOR ajoute une fonctionnalité ; MAJOR signale une rupture après 1.0.

## Branches et commits

main est la branche principale. Développer dans feat/..., fix/... ou docs/..., avec revue et contrôles appropriés avant fusion. Commits : feat:, fix:, docs:, test:, build:, chore:. Décrire le comportement réellement livré.

## Releases

Utiliser des tags annotés v0.1.0-alpha.1, v0.1.0-alpha.2, puis beta et rc uniquement lorsque leurs critères sont atteints. Aucun tag de release ni jeu complet n'est créé automatiquement par l'initialisation du dépôt.

Pour chaque release : aligner Cargo.toml, launcher/src-tauri/Cargo.toml et tauri.conf.json ; mettre à jour CHANGELOG.md ; compiler et tester le même commit ; publier limites, SHA-256, preuves et instructions. La version 1.0.0 nécessite la clôture du périmètre dans completion_plan.json et une validation depuis le paquet final.

Les assets lourds et jeux de données sont distribués par packs dans les releases, indépendamment des versions du moteur. Les tags assets-AAAA-MM-JJ identifient ces packs ; ils n'annoncent pas une version finale du jeu. Chaque commit public fixe son manifeste, ses URL et ses empreintes. Ne pas remplacer silencieusement un pack déjà publié : créer un nouveau tag et mettre à jour le manifeste.
