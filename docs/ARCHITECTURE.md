# Architecture

| Répertoire | Rôle |
| --- | --- |
| crates/core | Simulation, combat, données et composants reproduits du moteur historique |
| crates/server | Serveur autoritaire UDP, sessions et résultats |
| crates/client | Client graphique Bevy, caméra, HUD, effets et audio |
| crates/font-raster | Rasterisation des polices et pont FreeType |
| launcher/src-tauri | Application Rust/Tauri et supervision des processus |
| launcher/web | Interface du launcher |
| assets | Ressources nécessaires au rendu et au jeu |
| data | Catalogues, règles, contrats et données historiques |
| artwork | Scènes sources de restauration, notamment Blender |
| tools | Imports, analyses et outils de qualification |
| docs | Plan, documentation et preuves techniques |
| vendor, third_party | Dépendances embarquées et licences d'origine |

Le serveur décide de l'état de partie. Le client restitue les données autorisées et envoie des commandes. Le launcher supervise les processus qu'il a lancés et gère les sessions. Les paramètres et ressources historiques doivent être identifiés par version et provenance.

La pile actuelle utilise Rust, Bevy, Tauri et un transport UDP propre. Ne pas présenter des bibliothèques envisagées comme installées ou intégrées. Le projet reste en développement : cette architecture décrit les composants présents, pas leur validation complète.
