# OpenLeague

Reconstruction locale du périmètre historique de League of Legends 4.20, avec un moteur en Rust, un serveur autoritaire UDP et un launcher historique en Rust/Tauri.

**En développement — ce dépôt ne constitue pas un jeu terminé.** Les modèles importés et les tests de composants ne prouvent pas que les 122 champions sont intégralement jouables.

## Derniers changements

[Snapshot du 20 octobre 2026 : jeu, plan détaillé et application Windows de suivi](docs/DEVELOPMENT_SNAPSHOT-2026-10-20.md).

## Contenu

- Moteur, simulation, client graphique et serveur local.
- Launcher historique, gestion des sessions et retour après partie.
- Carte 3v3 Forêt torturée restaurée, scènes Blender et ressources de jeu.
- Modèles de 122 champions ; gameplay en cours d'implémentation.
- Données historiques, outils d'import et preuves de vérification.

## Récupération

Installer Git et Python 3.11 ou ultérieur, puis :

```powershell
git clone https://github.com/Louisdelez/OpenLeague.git
cd OpenLeague
python tools/download_assets.py
```

Le dépôt contient le code, la documentation et les petits fichiers nécessaires au développement. Les gros assets, scènes Blender et jeux de données sont distribués dans les [releases](https://github.com/Louisdelez/OpenLeague/releases). Le script vérifie les empreintes SHA-256 et restaure leurs chemins d'origine. Prévoir de l'espace pour les packs, leur extraction et la compilation.

## Compilation sur Windows

Prérequis : Rust 1.90 ou version compatible ultérieure, cible MSVC, Visual Studio Build Tools avec les outils C++, Windows SDK et WebView2 pour Tauri. Les dépendances sont verrouillées dans les fichiers Cargo.lock.

Depuis la racine du dépôt :

```powershell
cargo build --locked --workspace
cargo build --locked --manifest-path launcher/src-tauri/Cargo.toml
cargo run --locked --manifest-path launcher/src-tauri/Cargo.toml
```

Le launcher démarre les exécutables du client et du serveur. Une copie téléchargée doit être vérifiée sur une machine propre : certains outils historiques référencent encore des chemins locaux et des sources externes.

## Vérification

```powershell
cargo test --locked --workspace
cargo test --locked --manifest-path launcher/src-tauri/Cargo.toml
```

Des tests spécifiques nécessitent Windows, un GPU, les ressources LFS ou un client historique de référence externe. Une compilation ou un test isolé ne valide pas une partie complète. Les preuves historiques restent liées à leur version d'exécutable.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Installation et vérifications](docs/BUILDING.md)
- [Versionnement et releases](docs/VERSIONING.md)
- [Workflow Git, PR et contrôles](docs/GIT_WORKFLOW.md)
- [Feuille de route](docs/ROADMAP.md)
- [Licences et ressources](docs/LICENSING.md)
- [Plan détaillé](docs/completion_plan.json)
- [État et preuves](docs/coverage.json)
- [Contribution](CONTRIBUTING.md)

## Licence

Le code original et les assets distribués par OpenLeague sont sous [licence MIT](LICENSE), avec conservation des attributions des titulaires d'origine.
Les dépendances tierces conservent leurs licences et mentions de copyright ; voir [LICENSING.md](docs/LICENSING.md).

OpenLeague est un projet indépendant ; aucune affiliation ou approbation de Riot Games n'est revendiquée.
