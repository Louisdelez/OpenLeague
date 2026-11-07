# SYS-01.2-02 — Localisation : consommateurs actuels (V157)

## Observations vérifiées

Les 19 fichiers fontconfig installés correspondent octet pour octet aux sources natives désignées par le registre. Chaque fichier contient 12 704 lignes commençant par tr ; ce comptage lexical ne qualifie pas la grammaire, la traduction effective ou sa disponibilité régionale.

Le chargeur Rust native_hud_font_configuration::parse reconnaît les lignes tr mais ne retourne que les maps de polices et les bibliothèques. Cette fonction ne fournit donc pas de dictionnaire de traduction. Les travaux antérieurs sur les polices restent conservés ; ils ne prouvent pas les textes et infobulles localisés.

La configuration Tauri désigne ../web comme frontend. Le HTML du bouton de jeu et le JavaScript du statut de demande y contiennent des textes français littéraux. Les messages de session Rust comportent également des textes français, observés dans le code. Aucune couverture des 19 langues ne découle de cette interface.

## Preuves et portée

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision157\LOCALE_CURRENT_CONSUMER_RESEARCH.json. Dix-neuf comparaisons SHA-256 natives/installées et cinq ancres exactes contrôlées. Aucun test Rust, rendu, écoute ou parcours graphique exécuté. Les traductions fontconfig ne sont pas automatiquement les traductions AIR du launcher ni des banques de voix.

## Suite

Inspecter les autres consommateurs de textes HUD, l’origine des textes AIR, les banques de voix et les contrôles de disposition par langue. Relier chaque tâche CLIENT/HUD/AUDIO/LAYOUT à son rôle précis et conserver les inconnues ; ne pas clôturer une tâche à partir de présence de fichiers ou de sélection de police. Les 76 tâches concernées restent ouvertes et le graphe sémantique est inchangé par cette recherche.

## HUD et audio — consommateurs précisés

Cinq points de consommation vérifiés : catalogue de boutique unique (33 objets), description avec substitution numérique, titres de résultats français, son fixe des autels et schéma média ambiant sans sélecteur de langue. Douze sources natives du manifeste announcer rehashées conformes. Le répertoire VO de cette copie ne contient que en_US ; aucune conclusion globale sur les archives ou la disponibilité historique. Aucun rendu ni écoute exécuté.

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision157\HUD_AUDIO_LOCALE_RESEARCH.json. Les sons fixes des autels ne démontrent pas des annonces parlées localisées. Les textes longs et la disposition dans chaque langue restent à observer.

## Intégration au plan et vérification des copies

76 tâches LOCALE (19 langues, familles CLIENT/HUD/AUDIO/LAYOUT) et SYS-01.2-02 enrichies dans le registre et les deux bases locales. Store.task et Store.copy_text vérifiés pour77fiches par base ;42606états manuels et historique conservés ; intégrité SQLite ok. Les notes distinguent sources fontconfig, textes littéraux, voix en_US observées et règles de disposition, sans qualification visuelle/audio ni clôture de tâche. Le graphe des consommateurs sémantiques reste à compléter.

Reçu : F:\OpenLeague\docs\fidelity_locale_research_task_links_v157.json.
