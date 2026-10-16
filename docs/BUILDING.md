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


## Pack local des DDS natifs de sbires

Les trois fichiers `assets/forms/native_minion_mips/{Blue_Minion_Basic,Blue_Minion_Wizard,Red_Minion_MechMelee}.dds` doivent être distribués ensemble par un pack déclaré dans `assets-manifest.json`, avant les builds qui utilisent leurs octets embarqués. Le lot local proposé est `openleague-assets-11-native-minion-mips-local-20261016.zip` ; il conserve les dix packs précédents et le cache de release `assets-local-2026-10-15-gnar`.

Un pack `local_only: true` avec `url: null` doit être fourni dans `.asset-cache/<release>/` avec la taille et le SHA-256 exacts du manifeste. Son absence ou une identité différente bloque la restauration ; aucune URL distante de remplacement n'est inventée. Ce mode local ne démontre pas une installation propre depuis Internet.

`python tools/download_assets.py --verify-only` vérifie la taille et le SHA-256 des ZIP en cache et peut créer ce répertoire de cache. Il ne vérifie ni les membres des ZIP ni les fichiers installés. Avant l'adoption d'un pack, vérifier aussi sa liste exacte de fichiers, leurs tailles et leurs SHA-256. La restauration normale conserve les fichiers identiques et refuse les fichiers divergents sans `--force` ; ne pas forcer automatiquement les assets locaux.

Ne pas changer le manifeste pendant une qualification qui en garde le hash. Après un changement de distribution, réconcilier les preuves de source et refaire les contrôles requis ; la disponibilité des packs, la compilation et les preuves GPU restent distinctes.

## Documents de travail et restauration

Les trois fichiers `docs/completion_plan.json`, `docs/coverage.json` et `docs/resume_checkpoint.json` évoluent pendant le développement. Le manifeste conserve leurs anciens contrats d’archives comme graines historiques et les marque `preserve_existing_working_document: true`. La restauration normale conserve leurs copies locales divergentes ; elle continue de contrôler strictement les autres ressources. Cette politique est refusée pour tout autre chemin et doit être un booléen.

Sur un dossier vide, ces entrées sont extraites avec leur taille et SHA-256 historiques vérifiés. Ce sont des graines de reprise historiques, pas une preuve de l’état actuel du projet. `--force` reste une demande explicite de remplacement ; il ne doit pas être ajouté automatiquement. La livraison finale devra fournir aussi les documents courants et leur provenance, séparément de ces graines d’archives.
