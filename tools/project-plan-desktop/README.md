# OpenLeague Plan — application Windows

Application locale Rust/Tauri 2. Interface du plan embarquée, backend Rust, SQLite
avec transactions, contrôle des révisions et sauvegarde cohérente. Aucun serveur
Python, Node ou service Internet nécessaire pour utiliser l’application.

## Installation sur ce PC

Le raccourci « OpenLeague Plan » sur le Bureau lance l’exécutable installé dans
%LOCALAPPDATA%\Programs\OpenLeague Plan\. L’icône du livre avec une coche a été
créée avec ImageGen et incorporée à l’exécutable Windows.

%LOCALAPPDATA%\OpenLeague Plan\connection.json indique la base utilisée.
Sur ce PC, elle reste E:\OpenLeague\runtime\project-plan\plan.sqlite3 : le site
local et l’application partagent les mêmes coches, notes et historique.
La base d’origine n’est ni remplacée ni réinitialisée.

Sans configuration existante, l’application crée sa propre base dans
%LOCALAPPDATA%\OpenLeague Plan\ depuis le catalogue complet embarqué compressé.
Cette graine correspond à la sauvegarde cohérente du 20 octobre 2026.
Les écritures suivantes sont conservées hors de l’exécutable.
Une base explicitement configurée mais absente provoque une erreur visible.

## Utilisation

Les 24 parties, fiches, consignes, recherche, cases, notes, Retour et progression
globale fonctionnent dans la fenêtre native. Options permet d’exporter le suivi,
d’importer le JSON compatible avec le site, de sauvegarder SQLite et de télécharger
l’audit. La copie utilise le presse-papiers Windows. Les téléchargements ouvrent
une boîte « Enregistrer » native. Fermer la fenêtre quitte l’application.

WebView2, déjà présent sur ce PC, reste une dépendance système de Tauri Windows.
Une copie sur un autre PC nécessite Windows et WebView2. Les chemins des sources
historiques dans les consignes restent des références du projet d’origine.
Cette application conserve le plan ; elle ne valide pas automatiquement le jeu.

## Compilation

Depuis src-tauri :

    cargo test --locked
    cargo build --locked --release --bin openleague-plan
    cargo run --locked --bin verify_plan -- CHEMIN_BASE_SQLITE

Le workspace Cargo est indépendant du moteur et du launcher du jeu.
Cargo.lock fixe les dépendances. La famille de crates Tauri est explicitement
fixée à des versions compatibles avec Tauri 2.11.5.
La base embarquée se trouve dans src-tauri/resources/plan.sqlite3.gz ;
l’audit et le site sont embarqués également. Pour une prochaine livraison,
produire une sauvegarde SQLite cohérente et rafraîchir les ressources avant build.
Ne jamais remplacer une base utilisateur par une nouvelle graine lors d’une mise à jour.

## Sources et icône

- https://v2.tauri.app/reference/config/
- https://docs.rs/rusqlite/0.40.1/rusqlite/backup/
- Icône : outil intégré ImageGen, demande logo-brand, livre/checklist formant
  un O et une coche, graphite/ivoire/or discret, sans texte, fond transparent.
- Original de l’image : icon-imagegen-original.png, conservé sans retouche.
- Les PNG/ICO dérivés ne font qu’adapter la taille et le format pour Windows.

Les preuves de compilation, tests et vérification de la fenêtre native sont
conservées dans E:\mapslol3v3\Plan_Tauri_2026-10-20.

## Catalogue dans Git

Le catalogue JSON complet est conservé sans perte dans `docs/completion_tasks_2026-10-20.json.gz`. Depuis la racine du dépôt, exécuter `python tools/project-plan/restore_catalog.py` avant les outils Python ou leurs tests. La commande vérifie les empreintes et ne remplace pas un fichier divergent. La graine SQLite embarquée du programme Windows reste indépendante.
