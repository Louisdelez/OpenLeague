# SYS-01.2-02 — Présentation des tours et fontaines, V475

Quarante fiches PRESENT/MODEL/TEXTURE/ANIM/AUDIO des huit définitions TT_ChaosTurret1–4 et TT_OrderTurret1–4 sont enrichies dans les registres et les deux bases du plan. Les sources natives et chemins actuels sont reliés avec leurs limites. Aucun bâtiment, aucune fiche ni le jeu complet n'est déclaré accepté par ce lot.

## Référence et sélection réellement observée

Référence : League of Legends 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Le catalogue officiel 4.20.1 reste distinct. Le travail concerne F:/OpenLeague.

Le catalogue world_animation_manifest.json sélectionne huit GLB intacts et un GLB DestroyedTower commun aux huit alias détruits, soit neuf fichiers pour seize noms. Le code actuel fusionne ce catalogue, choisit le nom `_destroyed` selon l'état de santé, retire l'ancienne entité et demande le nouveau modèle. Ces routes sont reliées à leurs ancres vérifiées ; le seul chargeur Map10 n'est plus utilisé comme preuve de son.

Les empreintes des GLB correspondent aux reçus d'animation conservés. Le reçu antérieur d'export statique du modèle détruit a une autre empreinte : il précède l'ajout des animations et reste conservé. Cela ne constitue pas une corruption actuelle.

## Textures et données d'animation comparées

Les neuf textures intégrées aux GLB sont décodées en RGBA et comparées aux DDS natifs sélectionnés : dimensions 512 × 512, pixels identiques pour les neuf comparaisons. Les matériaux GLB sont non éclairés (KHR_materials_unlit) et double face. Cette égalité de pixels ne prouve ni les UV et masques, ni le shader, l'éclairage, la colorimétrie ou les effets dans le rendu final.

Un lecteur borné ANM3/ANM4 compare toutes les clés sélectionnées de translation, rotation et échelle, et leurs temps, aux GLB. La disposition ANM3 est explicitement rapprochée du lecteur communautaire LeagueToolkit local ; aucun exécutable Riot ni évaluateur natif complet n'est exécuté. Les flags bruts sont conservés sans leur inventer une sémantique.

| Modèle | ANM | Articulations | Images par piste | Dernière clé GLB, secondes |
| --- | --- | --- | --- | --- |
| Six tours TT_Order/ChaosTurret1–3 | 3 | 3 | 60 | 1,9666668176651 |
| Fontaine TT_ChaosTurret4 | 4 | 3 | 2 | 0,01666666753590107 |
| Fontaine TT_OrderTurret4 | 4 | 3 | 100 | 3,3000001907348633 |
| DestroyedTower partagé | 3 | 2 | 24 | 0,9199999570846558 |

Au total, 4 302 vecteurs d'échantillons sont comparés. Erreur maximale observée : 1,1920928955078125e-7 ; erreur de temps : 0. Tolérances du contrôle : erreur d'échantillon < 1e-4 et erreur de temps < 1e-5 ; les signes équivalents des quaternions sont admis. Les pixels sont comparés exactement, sans cette tolérance.

La différence des durées des fontaines n'est donc pas corrigée arbitrairement : elle correspond aux ANM sélectionnés. Les contrats antérieurs de période et de cycle sont relus comme preuves héritées et leurs identités sont vérifiées ; leurs sondes natives ne sont pas relancées. Le lecteur courant applique vitesse, répétition et maintien du dernier échantillon. Le nom `native_period_seconds` d'un JSON ne vaut pas nouvelle exécution native.

## Maillage détruit : choix local à distinguer de la règle native

DestroyedTower.inibin ne contient pas le champ MeshSkin/SimpleSkin. L'exporteur conservé export_native_map10_destroyed_models.py prévoit dans ce cas de choisir l'unique `.skn` à la racine du dossier du personnage. Cette unicité et l'identité du fichier sélectionné sont revérifiées.

La provenance du fichier est établie, mais cette sélection est un fallback de l'exporteur local. Elle ne démontre pas la règle effective de sélection du maillage par le moteur Riot. Les fiches PRESENT et PRESENT-MODEL conservent explicitement cette inconnue. Les champs Skeleton, Texture et SkinScale sont présents et concordent ; l'échelle locale détruite est 0,87, les tours intactes 1,1 et les fontaines 1,0.

## Animations d'attaque et transitions encore partielles

Les huit entrées intactes n'exposent que le rôle idle. Dans la branche actuelle des acteurs sans identité d'attaque dédiée, une hausse de next_attack ouvre une fenêtre de 12 ticks et sélectionne le rôle attack. Si ce rôle est absent, le lecteur ignore cette demande. Cette route est enregistrée comme frontière incomplète, pas comme animation d'attaque fonctionnelle ni preuve que le jeu original exige un clip d'attaque spécifique.

Les alias détruits exposent idle/death/attack vers le même clip. La sélection des rôles, le chargement initial d'idle, l'horloge et le maintien du dernier échantillon sont reliés. Il reste à qualifier les transitions, l'interpolation, les boucles, les événements, les effets et la présentation effective en partie ; des clés exportées correctes ne suffisent pas.

## Sons : manque précisément borné

Le chemin actuel d'attaque des tours construit des Pending et les ajoute à la file de combat. L'appel voisin begin_vilemaw_attack ne qualifie pas une présentation de tour : sa garde n'admet que le boss Vilemaw. Cette observation ne prétend pas prouver l'absence de toute autre route du dépôt.

La recherche des noms turret/tower/fountain dans les quatorze fichiers `*audio*.rs` du client ne retourne aucune correspondance. Les chemins map_audio et map_audio_requests relus concernent notamment reliques, autels et émetteurs ambiants. Cette recherche bornée ne démontre pas que les banques ou médias natifs manquent.

Pour les huit fiches audio, il reste à identifier et relier événements, banques/médias et déclencheurs/lecteurs des attaques, impacts, destructions et fontaines, puis vérifier lecture, arrêt, position et mixage. Les huit liens au chargeur Map10 sont conservés mais affichés hors de la portée démontrée. La nouvelle ancre Pending garde provides_feature_consumer=false : aucune lecture sonore n'est inventée.

## Contrôles exécutés et résultats

- Neuf textures exactes et neuf comparaisons complètes des clés sélectionnées ; seize alias, 114 fichiers épinglés et ancres de code relus.
- Neuf refus du collecteur : mauvais asset, indice de clip invalide, GLB invalide/tronqué, pixel altéré, temps hors bornes, ANM3 tronqué, version ANM non supportée, échantillon modifié. Le dernier refuse précisément « Native key sample mismatch ».
- Quarante et un sélecteurs nominaux et quarante-deux invalides ; sept refus publics concernant propriétaire/statut/condition de résolution et preuve/qualification de portée.
- Les 42 214 textes sont comparés : 40 modifiés, 42 174 identiques. Les autres fiches restent identiques, hors ajout des preuves au parent SYS.
- Publication puis relecture indépendante des quatre registres et des deux bases : 41 fiches par base, 42 606 états/notes, 23 historiques et 42 565 autres lignes du catalogue conservés exactement. Intégrité SQLite correcte.

Aucun export, build Rust, jeu natif, GPU ou son audible n'est exécuté pour V475. Les trois tests du cœur de V474 restent des preuves antérieures séparées. Aucun code du jeu ni asset n'est modifié, aucune case n'est cochée.

## Approches corrigées et conservées

La première préparation refusait une différence de casse entre un chemin Windows enregistré et le nom du clip GLB ; le contrôle vérifie maintenant leur correspondance sans casse, puis compare le nom GLB exact. La seconde préparation supposait SimpleSkin présent sur DestroyedTower ; l'inspection a établi son absence et le fallback de l'exporteur. Ces deux échecs ont eu lieu avant création du lot et avant toute modification du registre ou des bases ; leurs diagnostics sont conservés. Le lecteur ANM4 existant a aussi refusé correctement les clips ANM3 durant l'exploration ; le nouveau lecteur traite ces versions explicitement.

## Livrables et suite

Reçu : docs/reference_turret_sources/turret-presentation-v475.json. Preuve : docs/fidelity_turret_presentation_v475.json. Les registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json sont enrichis, ainsi que les deux bases locales et les documents de couverture/reprise.

Scripts et sauvegardes sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision475_delivery.py, revision475_animation_samples.py, revision475_check.py, revision475_finish.py et revision475/. Les preuves antérieures sont conservées.

Poursuivre les fiches STRUCTURE par instance : équipe, position, orientation, protection et cycle. Le sous-inventaire du chargeur contient 394 associations à examiner, 122 partiellement qualifiées et 24 exclusions de portée, dont douze audio. Ce n'est pas le compteur d'achèvement du jeu. Le Goal reste actif.

Ajouts vérifiés : 240 liens natifs, 188 liens consommateurs, quatre ancres, une source et quarante questions ouvertes ; aucune inconnue résolue.
