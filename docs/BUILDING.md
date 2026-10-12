# Installation, compilation et tests

## Prérequis

Windows, Git et Python 3.11 ou ultérieur, Rust compatible avec le minimum 1.90 du workspace, Visual Studio Build Tools C++, Windows SDK et WebView2 pour le launcher. Blender est utile pour les scènes sources ; il n'est pas nécessaire au lancement du jeu compilé.

## Commandes depuis la racine

```powershell
python tools/download_assets.py
cargo metadata --locked --no-deps
cargo build --locked --workspace
cargo build --locked --manifest-path launcher/src-tauri/Cargo.toml
cargo test --locked --workspace
cargo test --locked --manifest-path launcher/src-tauri/Cargo.toml
cargo run --locked --manifest-path launcher/src-tauri/Cargo.toml
```

Pour un diagnostic séparé, lancer le serveur puis le client dans deux terminaux :

```powershell
cargo run --locked -p openleague-server
cargo run --locked -p openleague-client
```

L'adresse serveur par défaut est 127.0.0.1:5896. Le serveur accepte OPENLEAGUE_SERVER comme variable d'environnement. Garder les services locaux pour les essais initiaux.

## Limites actuelles

Les chemins de certains scripts de restauration et de comparaison sont encore propres à l'environnement d'origine. Le client historique utilisé comme oracle n'est pas garanti dans ce dépôt. Les preuves existantes ne démontrent pas une installation propre autonome. Ne pas qualifier tout le jeu avec la seule réussite de cargo build.

Les caches de compilation, logs temporaires, environnements Python téléchargés, états de session et sauvegardes redondantes sont exclus de Git. Les assets, scènes sources, outils source et rapports de qualification font partie du contenu prévu pour publication.

Les archives de ressources sont versionnées séparément dans les releases. assets-manifest.json fixe le pack et le SHA-256 de chaque fichier. Récupérer les packs avant les compilations et tests qui utilisent des données embarquées.
