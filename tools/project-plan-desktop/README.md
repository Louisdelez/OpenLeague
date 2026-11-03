# OpenLeague Plan 1.3.1 — application autonome

Le raccourci du Bureau ouvre directement l’application Rust/Tauri. Le plan complet,
la recherche, les consignes, les coches, les notes, l’historique et les sauvegardes
sont gérés dans l’application, sans serveur Python/Node ni navigateur à lancer.

Le dossier `data/` à côté de `OpenLeague Plan.exe` contient la base persistante
`plan.sqlite3`, sa configuration et le diagnostic `startup.json`. Sur ce PC :
`C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/`.
Conserver ce dossier lors d’une mise à jour ; le démarrage ne remplace jamais une
base existante par la graine embarquée. Une base corrompue est conservée et refusée.

Migration du 22 octobre 2026 : 42 214 tâches, 2 770 fiches, 24 parties, huit coches,
42 606 états/notes/révisions et 23 événements d’historique repris à l’identique.
La base du projet E:/OpenLeague demeure conservée comme source de cette migration.
L’application utilise désormais son stockage autonome ; une évolution future du
catalogue projet se transmet par une migration explicite, sans effacer le suivi.

Les anciennes bases, l’ancien binaire et le raccourci sont sauvegardés. Preuves :
`E:/mapslol3v3/Plan_progress_desktop_fix_20261022/`.

## Documentation historique des versions précédentes

Les indications ci-dessous sur une base partagée dans E:/OpenLeague décrivent le
fonctionnement antérieur à 1.3.1. Le stockage courant est le dossier data/ ci-dessus.

---

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


## Estimations et recommandations — version 1.3.0

Chaque sous-tâche conserve trois badges : temps agent IA, difficulté pour l’IA,
modèle et effort recommandés. Une carte de survol personnalisée, également
accessible au clavier, explique ces trois informations. Échap la ferme. Les badges ne déclenchent aucune action au clic. Aucun modèle, état ou note n’est changé automatiquement.

Les durées sont des scénarios d’agent IA avec outils, prérequis disponibles. La
cadence reste une hypothèse explicite avec quelques repères locaux ; ce n’est
pas un benchmark d’inférence ni une conversion d’heures humaines. Le badge de durée contient uniquement la fourchette de temps. Le survol précise
quand il s’agit d’une première passe de recherche dont la durée totale reste ouverte.
Recherche, limites et sources : docs/PLAN_AI_ESTIMATION_RESEARCH_2026-10-22.md.

Actualiser les profils intégrés aux deux interfaces sans modifier SQLite :

    python -B tools/project-plan/task_estimates.py --root E:/OpenLeague --output runtime/project-plan-estimates/task-estimates.json --refresh-ui
    python -B tools/project-plan/test_task_estimates.py

Les sources méthodologiques et la calibration explicite sont dans
tools/project-plan/task_estimate_research.json. Recompiler l’application Tauri
après une actualisation de ses ressources web. Préserver la base utilisateur.

Difficulté : cinq icônes d’étoile, avec remplissage à la demi-étoile. Les quatre
classes existantes sont représentées par 1, 2,5, 3,5 et 5 étoiles ; ce changement
visuel ne réévalue pas les tâches. Le score est annoncé aux lecteurs d’écran.
