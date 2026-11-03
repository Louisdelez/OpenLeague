# Appartenance des références aux releases natives 4.20

La solution native0.0.1.68 et sa configuration en_gb sélectionnent lol_game_client0.0.1.7 et lol_game_client_en_gb0.0.0.235. Les deux manifestes déjà récupérés sont vérifiés avec leurs SHA et reçus. Ces releases de projet et celles de chaque contenu restent distinctes du build PUBLIC4.20.0.315 et du catalogue4.20.1.

Sur7257sources natives déjà enregistrées :7248correspondent par chemin/taille/MD5,2divergent et7ne sont pas listées dans ces deux projets. Les26fichiers vides qui correspondent sont bien enregistrés avec une taille nulle dans le manifeste ; cela ne prouve pas leurs consommateurs obligatoires.

Urf.inibin : copie loose515octets/MD5db15c1934bf303d71ffe3f02e4782ff5 ; membre attendu610/63eb93a8d415b4a7eea65e7f40665f6f. Cheats.cfg : copie150octets/0c22edb003b4452850141660324bcfb6 ; membre attendu148/a5f4d81fcd498a88ba4782d60bfebdd9. Leurs deux contenus conformes existent dans data/4.20/recovered_client_assets ; ils sont revérifiés avec le backing/récupération et maintenant reliés sans écraser les copies loose. Les paramètres GoldAmount99950→250,TargetStunDuration5→1,AutoCooldownDelay0.05→0.75 diffèrent réellement. Aucun serveur ou gameplay n’est modifié par cette recherche.

Les sept non-listés sont Localization_Errors.txt, trois netlogs2018,defaults/Locale.cfg,DATA/cfg/Game.cfg et input.ini. Ils peuvent être générés ou appartenir à une autre provenance ; aucune corruption ni absence générale déduite. Le defaultLocale37octets utilisé par V10 reste prouvé comme entrée de cette copie ; son producteur historique et son admission effective restent ouverts.

Le graphe conserve chaque source/ID, expose son appartenance et lie le reçu aux exigences concernées. Le lecteur de trace contrôle la projection contre les lignes du reçu lors de la vérification complète ; la consigne copiée affiche aussi projet/release de contenu/statut et limites. Trois nouvelles questions précises sur provenance/priorité complètent les recherches existantes ; aucun ancien statut clos ou supprimé.

Dix-huit tests dédiés vérifient les vraies sources, les divergences, les alternatives, les fichiers vides, chemins interdits, identités altérées et projections falsifiées. Le lecteur est Python et ne revendique pas le parsing natif RADS. Provenance communautaire des archives explicitement conservée, authenticité indépendante CDN non établie. Bootstrap/provider/ordre des archives,12scales,maîtrises4312/4313 et sémantiques communautaires restent à qualifier.

Reproduction : `python -B tools/project-plan/rads_reference_membership.py --root E:/OpenLeague --output CHEMIN_NEUF.json`. [Reçu](reference_native_skin_loader_sources/native-release-membership.json). Aucun programme historique lancé, aucun code/donnée du jeu modifié et aucune acceptation humaine.


## Audit borne -- consommateur courant URF/Cheats (2026-11-02)

### Critere de cloture
Pour chacune des deux ressources divergentes, identifier un consommateur Rust/Tauri actuel ou borner explicitement l'absence de lien direct dans le code et le catalogue d'assets. Cette cloture concerne uniquement l'audit du consommateur courant; elle ne clot pas l'origine historique ni l'execution du jeu.

### Preuves reutilisees
Les identites d'octets et alternatives sont reprises du present rapport: `data/characters/urf/urf.inibin` loose (515 octets, MD5 `db15c1934bf303d71ffe3f02e4782ff5`) contre membre selectionne (610 octets, MD5 `63eb93a8d415b4a7eea65e7f40665f6f`); `data/cfg/defaults/cheats.cfg` loose (150 octets, MD5 `0c22edb003b4452850141660324bcfb6`) contre membre (148 octets, MD5 `a5f4d81fcd498a88ba4782d60bfebdd9`). Aucun octet n'a ete rehache pendant ce lot.

### Controles et resultats
- Attendu: un chemin source ou appelant actuel relie a chaque ressource, ou une absence directement recherchee et delimitee.
- Observe pour URF: les recherches exactes de `urf.inibin` et `data/characters/urf` dans les sources Rust/Tauri sous `crates` et `launcher` retournent zero correspondance. Le manifeste `assets-manifest.json` contient 7 511 entrees et zero chemin URF correspondant.
- Observe pour Cheats: les recherches exactes de `cheats.cfg` et `data/cfg/defaults/cheats` dans le meme perimetre retournent zero correspondance; le manifeste a zero entree correspondante.
- `assets-manifest.json` n'est lu que dans `crates/client/src/animation.rs:1731` et `crates/client/src/ezreal_joint_identity_binding_tests.rs:48`; aucune de ces references ne fournit un lien vers URF ou Cheats. Le decodeur INIBIN explicite local releve dans `crates/client/src/map10_native_config.rs:5-6` lit `Levels/Map10/terrain.inibin`, pas une ressource de champion.
- Le rapport `docs/FIDELITY_LOCALE_FONT_LINKS_4_20.md` couvre deja le consommateur statique de la copie `data/4.20/font_configuration/locale.cfg`; cette preuve est reutilisee sans refaire ses recherches. La selection historique de `DATA/CFG/defaults/Locale.cfg` reste distincte et inconnue.

### Conclusion et limites
Le sous-audit des liens de consommateur actuel pour URF et Cheats est clos avec un resultat negatif borne: aucun appelant direct ni ligne de manifeste n'a ete identifie dans le perimetre indique. Cela ne prouve pas l'absence d'un chargement indirect generique. Aucune fonction d'import INIBIN pour URF/Cheats, aucun appelant de ces chemins, aucun test, build, lancement client ou rendu n'a ete ajoute ou execute.

Les inconnues `OLU-6c4ea73e-b19b-5768-b6b0-6f596a6a3a20` et `OLU-f76e6025-f166-5cef-88b4-24340ec8d4b9` restent ouvertes: il manque une preuve d'origine de deploiement et de selection effective du provider/overlay avec les empreintes selectionnees. Reprendre seulement sur un manifeste/staging autoritatif ou une trace du demarrage/provider original qui etablit cette selection. Aucun statut de tache, registre, goal, application de suivi ou base n'a ete modifie. SYS-01.2-02 et le jeu restent incomplets.
