# OpenLeague

Reconstruction locale du p�rim�tre historique de League of Legends 4.20, avec un moteur en Rust, un serveur autoritaire UDP et un launcher historique en Rust/Tauri.

**En d�veloppement � ce d�p�t ne constitue pas un jeu termin�.** Les mod�les import�s et les tests de composants ne prouvent pas que les 122 champions sont int�gralement jouables.

## Contenu

- Moteur, simulation, client graphique et serveur local.
- Launcher historique, gestion des sessions et retour apr�s partie.
- Carte 3v3 For�t tortur�e restaur�e, sc�nes Blender et ressources de jeu.
- Mod�les de 122 champions ; gameplay en cours d'impl�mentation.
- Donn�es historiques, outils d'import et preuves de v�rification.

## R�cup�ration

Installer Git et Python 3.11 ou ult�rieur, puis :

```powershell
git clone https://github.com/Louisdelez/OpenLeague.git
cd OpenLeague
python tools/download_assets.py
```

Le d�p�t contient le code, la documentation et les petits fichiers n�cessaires au d�veloppement. Les gros assets, sc�nes Blender et jeux de donn�es sont distribu�s dans les [releases](https://github.com/Louisdelez/OpenLeague/releases). Le script v�rifie les empreintes SHA-256 et restaure leurs chemins d'origine. Pr�voir de l'espace pour les packs, leur extraction et la compilation.

## Compilation sur Windows

Pr�requis : Rust 1.90 ou version compatible ult�rieure, cible MSVC, Visual Studio Build Tools avec les outils C++, Windows SDK et WebView2 pour Tauri. Les d�pendances sont verrouill�es dans les fichiers Cargo.lock.

Depuis la racine du d�p�t :

```powershell
cargo build --locked --workspace
cargo build --locked --manifest-path launcher/src-tauri/Cargo.toml
cargo run --locked --manifest-path launcher/src-tauri/Cargo.toml
```

Le launcher d�marre les ex�cutables du client et du serveur. Une copie t�l�charg�e doit �tre v�rifi�e sur une machine propre : certains outils historiques r�f�rencent encore des chemins locaux et des sources externes.

## V�rification

```powershell
cargo test --locked --workspace
cargo test --locked --manifest-path launcher/src-tauri/Cargo.toml
```

Des tests sp�cifiques n�cessitent Windows, un GPU, les ressources LFS ou un client historique de r�f�rence externe. Une compilation ou un test isol� ne valide pas une partie compl�te. Les preuves historiques restent li�es � leur version d'ex�cutable.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Installation et v�rifications](docs/BUILDING.md)
- [Versionnement et releases](docs/VERSIONING.md)
- [Workflow Git, PR et contr�les](docs/GIT_WORKFLOW.md)
- [Feuille de route](docs/ROADMAP.md)
- [Licences et ressources](docs/LICENSING.md)
- [Plan d�taill�](docs/completion_plan.json)
- [�tat et preuves](docs/coverage.json)
- [Contribution](CONTRIBUTING.md)

## Licence

Le code original et les assets distribu�s par OpenLeague sont sous [licence MIT](LICENSE), avec conservation des attributions des titulaires d'origine.
Les d�pendances tierces conservent leurs licences et mentions de copyright ; voir [LICENSING.md](docs/LICENSING.md).

OpenLeague est un projet ind�pendant ; aucune affiliation ou approbation de Riot Games n'est revendiqu�e.
