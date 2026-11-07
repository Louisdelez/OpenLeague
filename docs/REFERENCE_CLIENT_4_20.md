# Référence du client OpenLeague 4.20

La référence choisie est le **client PUBLIC 4.20.0.315, branche Releases/4.20,
région EUW, locale configurée en_GB**, fourni dans le dossier historique.
Sa **date de référence est la date de build native du 17 novembre 2014**,
avec l’heure littérale **17:46:45**, de fuseau non établi.

Cette date est celle inscrite dans l’exécutable. Ce document ne la présente
pas comme une date de déploiement du patch sur EUW. La date de déploiement
régional reste inconnue sur les sources primaires consultées. L’horodatage
de liaison PE, **2014-11-18T01:55:38+00:00**, est conservé comme un fait distinct.
Aucune conversion de fuseau n’est déduite de la différence.

Le contrat exploitable est [reference_client_4_20.json](reference_client_4_20.json).
Les consignes copiées par le plan utilisent ce contrat ; le catalogue SQLite
est invalidé quand le contrat ou son lecteur change.
Le catalogue officiel Data Dragon **4.20.1**, en_US, sert à comparer les données.
Son numéro n’est ni une version de binaire ni une preuve de région.

## Sources natives

Racine : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20.
Ces sources ont été lues et hachées, sans lancer ou modifier le client.

| Fichier | Fait retenu | SHA-256 |
| --- | --- | --- |
| RADS/system/system.cfg | Region=EUW | a99ea26414fbd7deebace37c9e2c109f818a8c394f92607cfa082bd49f35c16a |
| RADS/system/locale.cfg | locale=en_gb, canonisé en_GB | 82ecb50f4bf707a35a13a6b6987df89fa6044bedac6fc8aca179890a7890d6ae |
| RADS/system/launcher.cfg | airConfigProject=lol_air_client_config_euw | f3417678c2e9a39bb40c937d5b8d63265092376756514652e5a22eb6c5195379 |
| RADS/solutions/lol_game_client_sln/releases/0.0.1.68/configurationmanifest | en_gb / lol_game_client_en_gb | f601219e81fe20e4c805c5faaa7af664c0c6adcdd43d591c7a4f22ebbd7601f3 |
| RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe | Nov 17 2014 / 17:46:45 / 4.20.0.315 / PUBLIC / Releases/4.20 | 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 |

## Vérifier à nouveau

Depuis E:/OpenLeague :

    python -B tools/project-plan/reference_client.py --root E:/OpenLeague

Le contrôle refuse une source absente ou différente, une région/locale
incohérente, un autre build et les affirmations de fuseau ou de déploiement
non établies. Aucun client d’origine n’est exécuté par ce contrôle.
Les tests de refus et le test du consommateur de consignes sont conservés
dans tools/project-plan/test_reference.py. La recette d’intégration SQLite
et les résultats sont liés depuis reference_client_4_20_acceptance.json.

## Limites de cette tâche

Les fichiers multilingues et les journaux ajoutés après 2014 ne définissent
pas la région ou la date du build. La disponibilité historique de chaque
contenu, les versions du patcher/AIR, la complétude des services et la recette
du jeu relèvent des autres tâches ouvertes du plan.

Les anciennes URL officielles des notes 4.20 et une tentative d’archive
n’étaient pas accessibles pendant cette vérification ; elles ne servent
donc pas à affirmer une date de déploiement. Les faits retenus ci-dessus
proviennent des cinq fichiers natifs identifiés.


## Complément SYS-01.1-02

Les builds du patcher et d’AIR sont désormais identifiés séparément dans [REFERENCE_FRONTEND_BUILDS_4_20.md](REFERENCE_FRONTEND_BUILDS_4_20.md), sans changer l’identité datée du client de partie ci-dessus.


## SYS-01.1-03 — client de partie et configurations serveur

Identité native **4.20.0.315 PUBLIC**, solution **0.0.1.68**. Configurations LeagueSandbox (5119), registre HTTP local et réglages Rust OpenLeague (127.0.0.1:5896) identifiés séparément. Écarts Map1/Map11 et net8 absent conservés ouverts. Voir [REFERENCE_GAME_SERVER_4_20.md](REFERENCE_GAME_SERVER_4_20.md). La case reste manuelle ; aucune qualification du jeu complet n’est déduite.
