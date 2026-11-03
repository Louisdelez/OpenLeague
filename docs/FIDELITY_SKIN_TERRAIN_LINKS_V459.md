# SYS-01.2-02 — Justicar Aatrox et terrain de vision, V459

Le skin Justicar Aatrox et le terrain de vision Map10 sont reliés aux sources vérifiées et aux fonctions actuelles. Trois fiches sont enrichies : SKIN-Aatrox-1-PRESENT, SYS-13.1-02 et SYS-01.2-02. Aucun code de jeu ni asset n’est modifié. Aucune case n’est cochée.

## Sources et résultats observés

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build 2014-11-17 à 17:46:45, fuseau et date de déploiement non établis. Cinq fichiers natifs sont comparés au manifeste du projet lol_game_client 0.0.1.7, avec leur release de contenu distincte, taille, MD5 et SHA-256. Les origines enregistrées E: restent conservées ; les copies F: consultées sont comparées aux identités enregistrées.

**Justicar Aatrox.** Skin01.inibin porte explicitement ChampionSkinID=266001 et ChampionSkinName=AatroxSkin01. SimpleSkin, Skeleton et Texture désignent les trois ressources natives vérifiées. Le catalogue officiel 4.20.1 identifie Justicar Aatrox. Le champ Animations nomme AatroxSkin01.blnd ; sa présence dans la configuration ne qualifie pas l’héritage des animations, sons ou VFX. Les quatorze consommateurs déjà liés sont inspectés et conservés. La route ordinaire reçoit le nom du champion, appelle animation::request puis charge les rôles du GLTF. Cela ne démontre pas une sélection ordinaire du skin1. Les expériences natives antérieures ne sont pas réexécutées.

**Terrain de vision.** AIPath.aimesh_ngrid de Map10 : SHA-256 1430e679b91a582f871ce78185bcda3db5eb7daf82beb7aba26264addcf5d9bd, version3.1,306×129. Les hauteurs et flags de chacune des39474cellules correspondent aux octets du fichier compact courant ; les métadonnées correspondent en f32. Les champs region/open du compact ne sont pas qualifiés par cette comparaison.

Le serveur lit les fichiers de grille au démarrage : Navigation::load extrait les flags ; index choisit la cellule ; line_of_sight applique l’échantillonnage local au quart de cellule ; visible_point_to l’appelle pour ses sources ordinaires. Les branches altar/ignite et autres conditions gardent leur propre portée.

Le client compile les fichiers de grille dans Sources::process, puis passe TerrainGrid à regenerate_cached, stencil et compose, qui appelle fow_terrain_ray::trace. Quatre fonctions existantes sont nouvellement enregistrées comme consommateurs précis et dix fonctions de cette chaîne sont inspectées. Le code peut réutiliser un masque en cache ou traiter un budget partiel. L’égalité des fichiers sur disque ne prouve pas les octets embarqués dans un exécutable en cours.

## Intégration et contrôles exécutés

- Préparation, publication et audit : code0. Trois sélecteurs nominaux, six refus de tâche/sélecteur.
- Huit refus supplémentaires : compact tronqué, flag altéré, hauteur altérée, largeur incorrecte, version native incorrecte, mauvais projet de manifeste, mauvaise release de membre et membre absent. Ce sont des contrôles de données et de liaison, pas des tests Rust.
- Un reçu ajouté, quatre consommateurs enregistrés et19liens ajoutés :8à la fiche de vision et11à l’union SYS. Le skin conserve ses14liens existants ; son reçu renouvelé est ajouté sans inventer un manque de consommateur.
- Les vrais Store.task, Store.copy_text, requirement_trace.resolve et générateur de consignes sont relus dans les deux bases. Trois fiches mises à jour ;42603autres lignes exactes dans chaque base. Les42606états/notes et23entrées d’historique sont inchangés.
-42211autres exigences actives inchangées. Anciennes sources, portées et preuves conservées ; registre des inconnues identique en octets. Graphe :42214exigences,98594sources,2412consommateurs,25321questions ouvertes,5517résolues.

## Limites ouvertes

Le comportement complet du skin, le serveur historique de visibilité, les cas limites de parcours, la précédence des fournisseurs natifs, la composition effective de chaque frame et les pixels GPU restent non qualifiés. Aucun jeu, code natif, VM, Rust, build, réseau ou GPU exécuté. Aucun ancien test n’est présenté comme nouvellement passé. Les gardes du script concernent les sources et liens uniquement.

Les recherches initiales ont rencontré deux chemins supposés absents (crates/launcher et crates/core/src/navigation.rs). Les vrais consommateurs sont launcher/ et crates/core/src/lib.rs ; ces erreurs d’orientation ne signifient pas une implémentation absente. Le premier appel resume de cette reprise a retourné un Git indisponible ; une lecture Git explicite ultérieure a confirmé main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca et les changements existants.

## Fichiers et preuves

Registres : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json. Deux bases : runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture, plan et reprise documentaire actualisés sans changer les acceptations.

Reçu : docs/reference_skin_terrain_links/skin-terrain-links-v459.json. Vérification : docs/fidelity_skin_terrain_links_v459.json. Script et sauvegardes exactes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision459_skin_terrain_links.py et revision459/. Les fonctions de publication/audit réutilisent le mécanisme V458 ; elles ne constituent pas une revue indépendante.

SYS-01.2-02 reste ouvert. La prochaine étape est l’audit des380contrats sans input natif direct mais avec références, en distinguant autorité locale, preuve native indirecte et comportement historique encore inconnu. Les cinq fiches Battle Training sans source restent ouvertes.
