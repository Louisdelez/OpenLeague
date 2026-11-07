# SYS-01.2-02 — Configuration graphique effective, V715

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct.

V715 : lecteur original8B1C20 exécuté avec cache, fichiers, parser et lookup natifs. Référence locale en_GB : défaut x3d_platform=0 conservé après lecture du vrai Config/Game.cfg. Quatorze cas synthétiques et leurs hits de cache réussissent ;refus de migration en écriture par la sonde confirmé. Module Rust réel compilé/exécuté sur quinze entrées : texte conservé, mais deux cas localisés diffèrent puisque load_using fournit seulement utilisateur/défaut. Trois consommateurs précis ajoutés, aucun backend wgpu inventé ni GPU exécuté.

## Résultat sur les fichiers fournis

Le caller original de locale lit defaults/Locale.cfg et sélectionne en_GB. Le getter entier8B1C20 construit réellement ses objets de configuration, lit defaults/Game.cfg puis sélectionne le fichier Config/Game.cfg à la racine du client fourni. Le premier fournit0 ; le second ne contient pas la clé et conserve0. Le fichier deploy/DATA/CFG/Game.cfg n'est pas celui retenu comme réglage utilisateur dans ce contexte.

L'exécutable a pour SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Le défaut a pour SHA256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e` et le fichier utilisateur `64d34912ea5411b47d6da0de44da374dd0a9e396fe96dc2b1d87ca76d562110e`. Tous sont relus sans mutation.5753 adresses d'instructions originales sont observées dans ce cas. Chaque table des quinze profils est comparée aux octets du PE.

## Vérifications exécutées

- Une lecture native des fichiers de référence : résultat0, localeen_GB et chemin utilisateur produits par le code original.
- Dix profils synthétiques : remplacements1/2, clé absente, fichier vide ou absent, repli-7, texte non numérique vers0, TrUe vers1, préfixe-4tail vers-4 et dépassement32bits vers2147483647.
- Quatre profils localisés : priorité du fichier utilisateur localisé, repli si sa clé est absente, priorité du défaut localisé puis remplacement par le fichier utilisateur ordinaire.
- Quatorze secondes lectures utilisent le cache sans nouvelle ouverture et conservent le résultat.
- Un déplacement demandé par le code original est refusé avant l'accès hôte ; source conservée et destination toujours absente.
- Le vrai module Rust est compilé avec rustc puis exécuté sur les mêmes quinze entrées : build0, exécution0, code source inchangé.
- Cinq preuves volontairement falsifiées sont rejetées : résultat, identité native, priorité localisée, GPU et modification du sélecteur.

## Écart actuel démontré

| Fichiers synthétiques | Entier original | Texte produit par le module Rust avec les deux fichiers du caller actuel |
|---|---:|---:|
| Utilisateur1, utilisateur localisé2 |2|1|
| Défaut0, défaut localisé2, utilisateur sans clé |2|0|
| Utilisateur1, localisé sans clé |1|1|
| Défaut localisé2, utilisateur1 |1|1|

Le parser Rust conserve bien x3d_platform et les valeurs brutes. `native_user_settings::load_using` lit seulement le défaut et le fichier utilisateur avant `load_text_files` ; il ne découvre pas les fichiers localisés dans ce chemin. Il faut intégrer et qualifier ce chargement pour obtenir la même priorité. La tâche actuelle lie ces sources et consommateurs ; elle n'autorise pas à présenter cette différence comme corrigée.

Le renderer moderne conserve son propre choix `Backends::from_env().unwrap_or(default_backends)`. Il n'existe ici aucune preuve de traduction des numéros natifs vers wgpu. La valeur native2 reste un troisième fournisseur distinct identifié parV714, dont le comportement graphique reste à qualifier.

## Limites

- Le backend de fichiers, cwd, arènes mémoire, stockage/copie SSO, services CRT et I/O en lecture seule sont des adaptations déclarées. Le getter8B1C20, cache8ACEF0, constructeur8AD5B0, parser8AEC00, lookup8AE0E0 et lecteur entier8AF830 exécutent leurs instructions originales, sans résultat de configuration injecté.
- La référence effectivement lue est le contenu local fourni et identifié par SHA ; les valeurs personnelles Config/Game.cfg ne sont pas datées de2014. Le montage historique complet, les archives, autres overlays binaires et overrides CRT restent ouverts.
- Le formatage %d et accessor errno sont adaptés ; les conversions atoi/strtol et la reconnaissance de true restent exécutées par le code original. Les fixtures minimales sont synthétiques, conservées sur F, et ne sont pas des assets historiques.
- Le refus de déplacement est une limite volontaire du banc en lecture seule au siteC9C554 ; il ne décrit pas un refus du jeu historique. Aucun déplacement réel réalisé.
- Rust : seuls load_text_files/parse/value/lookup du module actuel sont exécutés ici. Le caller load_using est inspecté, pas rejoué sur la configuration du projet. Il ne demande que user/default ; les localisations ne sont pas intégrées par ce chemin. La conversion entière et le runtime complet ne sont pas fraîchement exécutés côté Rust.
- Les deux sélecteurs1225B04/1225C58 restent2 après la lecture. La continuation graphique deV714 est une preuve séparée, pas une exécution composée. Aucun device, GPU, écran Standard ou gameplay accepté.
- Premier banc arrêté avant lecture native sur un attribut de suivi non initialisé ; version corrigée distincte, échec conservé. Aucun code de production modifié. États manuels, inconnues et prérequis conservés.

## Livraison et reprise

Trois consommateurs précis et leurs sources sont ajoutés aux liens des deux fiches SYS-01.2-02 et SYS-17.3-01. Leurs rôles sont des limites de composants : pas une validation complète d'écran ou de gameplay. Les prérequis restent dans leur état recensé. Les ajouts sont copiés dans les deux bases du plan avec contrôle d'intégrité et conservation des autres lignes, cases, notes et historiques. Aucune copie intégrale de base supplémentaire.

[Reçu détaillé](fidelity_effective_graphics_config_v715.json). Livraison vérifiable : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision715_delivery/VERIFIED.json.

Suite : qualifier la construction du device natif Direct3D9 et la composition avec le registre de textures/écran Standard ; conserver séparément l'écart de chargement localisé du client actuel et le montage historique encore inconnu.
