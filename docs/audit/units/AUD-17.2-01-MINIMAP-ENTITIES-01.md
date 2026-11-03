# AUD-17.2-01-MINIMAP-ENTITIES-01 — Unités et structures autorisées sur la minimap

Date : 2026-10-30T20:45:17.655113+00:00. Projet F:\OpenLeague. Lot documentaire de SYS-01.2-02.

Résultat : les sources et les consommateurs de SYS-17.2-01 sont reliés, les familles omises et politiques locales identifiées, avec reprises précises. La relecture indépendante décide de la clôture documentaire. La fonctionnalité demeure partielle ; aucune acceptation humaine ni fin du goal n’est revendiquée.

## R1 — Exigence et périmètre

Tâche **SYS-17.2-01 — Afficher les unités et structures autorisées sur la minimap** ; exigence **OLF-565c87e2-ec5a-5e2a-b6bb-61151749bb9c** ; inconnue **OLU-38bd6f3f-57b8-56fa-834c-83a69535cf50**, ouverte. Statut `a_faire`, réalisation/acceptation `false`, conservés. Aucun critère normatif ni texte du goal modifié.

Phase D17, lot D17-SYS-17-2 « Minimap, messages et score », neuf tâches. Prérequis réel : **D13-SYS-13-3** ; ses entrées et statuts sont dans le reçu, sans validation implicite. SYS-13.1-01 et SYS-13.3-06 portent les politiques de vision/publication ; SYS-05.5-05 la reprise du HUD. Le lot HUD précédent est8/8 documentaire, pas un HUD fonctionnel achevé.

Portée : icônes des acteurs/unités/structures et états Map10, sources/layout/projection, filtrage serveur, clé d’entité et cycle de rendu. **Exclus comme exigences voisines** : texture de brouillard SYS-17.2-02, pings03/04, notifications/score et minimap complète. [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.2-01-MINIMAP-ENTITIES-01/audit-unit.json) fixe les critères de sortie et la condition d’arrêt.

## R2 — Sources et ressources vérifiées

Référence : LoL4.20.0.315, PUBLIC/Releases/4.20, EUW/en_GB ; build2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1. Aucun client original ni nouveau binaire n’est exécuté.

Le fichier original `DATA/menu/hud/minimap.ini` est présent : **17707octets**, SHA-256 `197b401bea7eb4d4999a65ca28e11f85a7607b6cbc010e94ab3f85d1521ffde9`. Le profil courant reprend **92 champs exacts**, comparés section/clé/valeur, pour six familles : Champion, Minion, Tower, Inhibitor, HQ, HealthPack. Le nombre de cellules de la bande,28, correspond à General.ImagesOnMinimapIconStrip. Ces92comparaisons concernent les champs sélectionnés du profil courant ; leur définition diffère du recensement83champs de V122 et les deux comptes ne sont pas additionnés.

Les cinq ressources nécessaires au chemin courant sont disponibles et comparées à leurs sources originales ainsi qu’aux entrées du manifeste de distribution :

| Ressource courante | Source originale | Octets courants | Comparaison réellement effectuée |
|---|---|---:|---|
| background.dds | 2DLevelMiniMap.dds | 377408 | Octets identiques |
| icons.dds | MiniMapIcons.dds | 50544 | Octets identiques |
| healthPack.dds | healthPack.dds | 1520 | Octets identiques |
| MapCircle.png | MapCircle.tga | 1983 | Dimensions et pixels RGBA identiques, TGA→PNG |
| MinionMapCircle.png | MinionMapCircle.tga | 208 | Dimensions et pixels RGBA identiques, TGA→PNG |

Les deux comparaisons TGA/PNG sont des lectures et décodages RGBA avec Pillow déjà disponible : **aucune image créée, éditée ou enregistrée**. L’égalité des pixels et les trois copies DDS résolvent la provenance de ces cinq ressources ; cela ne qualifie pas leur affichage GPU ni les rôles omis.

Le SCB courant `assets/maps/tt_level_size.scb` est identique à `LEVELS/Map10/scene/__LevelSize_.SCB`, SHA-256 `16138f6f4d50fe54eaae63e6ec4f3c3a48d632a874dbd74c93306b44048f00b4`. Le rectangle vient de **ShadowIslesMinimapRight.ini**, avec MinimapContent/MinimapFrame/MinimapPillar. Leur chargement/layout provient du lot d’ancrages déjà vérifié : archives originales, sélection normale et deux surcouches conservées. Le contrôleur original d’activation du contenu n’est pas récupéré : le code courant active explicitement le contenu et sa couleur blanche lors du pont local.

La configuration globale comporte d’autres sections : Champion_Dead, Tower_Destroyed, Inhibitor_Destroyed, Camp, Epic, Fountain/Shop, autels, pings, wards et autres modes. Leur présence ne prouve ni leur applicabilité à Map10 ni une fonctionnalité absente obligatoire. Aucun nouveau lien d’Epic vers Vilemaw, ni de Pet vers une section native inventée, n’est adopté.

## R3 — Producteurs et consommateurs réels

**Autorité/visibilité.** `core/vision.rs:137-167` construit le snapshot du viewer et filtre players/units par `visible_to`. Le roster conserve des identités sans position admise. L’état de relique fixe `relic_visible` depuis la vision et, hors vision, retire disponibilité, deadline et données de prise pertinentes. Le transport session/legacy et le commit client sont ceux du reçu QWER déjà relu ; corpus de1168fichiers inchangé.

Le filtrage courant est une politique locale partielle : alliés, rayon/obstacles/buissons, autels et révélation Ignite sont des chemins réels. Avec `interactions=None`, `visible_to` et `visible_point_to` autorisent avant certains autres contrôles. Ce mode de simulation n’est pas transformé en preuve d’une règle native ; le test minimap hérité utilise `enable_map10()`. Les sources ne qualifient pas toutes les règles historiques de furtivité, vision ou mémoire des structures.

**Marqueurs.** `native_minimap.rs:115-142` ne lit que `snapshot.players`, `snapshot.units` et la relique visible/disponible. Aucun lookup des positions dans roster, aucune extrapolation de `relic_ready_tick` ni cache de positions d’ennemis cachés n’est utilisé pour fabriquer un nouveau marqueur. Une perte de connexion conservant un ancien snapshot est une frontière distincte, décrite plus bas.

Les clés typées distinguent Player(id), Unit(id), Relic et Panel(index). Des mêmes nombres dans deux namespaces ne sont pas un doublon de clé. Les doublons de marqueurs d’un même namespace sont refusés ; la clé est inscrite avant le filtre de santé. Santé non finie/non positive → omission ; point non fini/hors projection → omission. Le chemin standard limite joueurs/unités aux équipes0/1 ; le style Minion neutre255 existe dans le profil sans être sélectionné par cette garde. Relic utilise255 séparément.

| Type courant | Style sélectionné | Condition / frontière |
|---|---|---|
| Melee | Minion | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Caster | Minion | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Siege | Minion | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Super | Minion | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Monster | Non sélectionné | Wildcard ignoré ; sélecteur natif et applicabilité à qualifier |
| Pet | Non sélectionné | Wildcard ignoré ; sélecteur natif et applicabilité à qualifier |
| Boss | Non sélectionné | Wildcard ignoré ; sélecteur natif et applicabilité à qualifier |
| Turret | Tower | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Fountain | Non sélectionné | Wildcard ignoré ; sélecteur natif et applicabilité à qualifier |
| Inhibitor | Inhibitor | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |
| Nexus | HQ | Snapshot autorisé, équipe0/1, santé positive finie, position projetable |

Ainsi **7 types sur11 sont mappés**, pas sept acteurs ni sept types terminés. Les quatre omissions typées sont Monster, Pet, Boss, Fountain. Les autels sont un autre rôle MapState, pas un douzième Kind : leur vecteur n’est pas consommé par la fonction des marqueurs. La relique a un chemin séparé, un seul Key::Relic, conditionné par les deux flags autoritaires.

**États et sélection.** Les acteurs morts sont omis ; Champion_Dead et les variantes détruites des tours/inhibiteurs ne sont pas consommés. Les structures vivantes passent le même filtre serveur de présence ; leur éventuelle mémoire/position connue native n’est pas récupérée. Les choix actuels de couleur/cellule suivent les équipes absolues0/1 du profil Default. Les alternatives de relation, spectateur et daltonisme ne sont pas choisies par ce renderer.

**Projection et taille.** `native_minimap_geometry.rs` effectue un port statique borné du contrôleur par défaut associé à8008F0/8009F0 : minima X/Z0, pan au centre, zoom1, span du SCB. Aucun code original de projection n’a été exécuté dans ce lot. Les bords projetés sont inclusifs ; le pointeur d’entrée a des bornes droite/bas exclusives, contrat voisin distinct. Les marqueurs utilisent `width × minScale / DPI`, politique locale fixe ; maxScale et réglages natifs ne sont pas intégrés. Le clipping rectangulaire ajuste les UV ; les cellules de la bande sont des indices du profil. Le fond échantillonne explicitement LOD0, politique locale de sampler, sans modification des DDS/mips ni revendication de filtrage original équivalent.

**Cycle de vie.** `sync` conserve les clés présentes, met à jour nœuds/matériaux et retire les clés absentes. L’update exige une session égale et le propriétaire présent ; changement de session, propriétaire/fenêtre absent ou erreur retirent les entités/matériaux. Images manquantes, dimensions/DPI invalides et ressources incohérentes sont refusées. Le matériau absent ou les clés dessinées dupliquées sont des erreurs identifiées.

La garde de cet update **ne consulte pas connection.ready()**. Une session/identité encore égale avec ancien snapshot pendant interruption ne prouve ni effacement ni fraîcheur nouvelle ; la politique conserver/retirer/indiquer l’état périmé reste à qualifier. Aucun défaut de divulgation ni comportement natif souhaité n’est inventé depuis cette seule absence d’appel.

Le champ512 limite **la trace diagnostique**, pas le vecteur de marqueurs ni la liste de rendu. Une trace tronquée ne prouve donc pas un maximum fonctionnel de512acteurs. La trace CPU ne prouve pas une passe FoW ou un rendu GPU.

## R4 — Contrôles, cas et limites d’exécution

**234 contrôles documentaires et d’identité réussis** : sources/données,92champs, cinq ressources, SCB, clauses du code et conservation. L’analyse RGBA est nouvelle et en lecture seule ; aucun traitement de reconstruction d’image n’est fait.

| Cas | Attendu d’après le contrat courant inspecté | Observé / portée |
|---|---|---|
| Acteur vivant autorisé | Un marqueur de sa famille si équipe/position valides | Branches réelles identifiées,7types mappés ; pas de match exécuté. |
| Ennemi retiré du snapshot mais présent au roster | Aucun marqueur reconstruit depuis le roster | Fonction sans lookup roster ; cas CPU hérité identifié. |
| Mort, santé invalide, position invalide/hors cadre | Omission selon les filtres actuels | Branches exactes présentes ; variantes natives non qualifiées. |
| ID dupliqué dans un namespace | Erreur explicite et retrait du groupe minimap sur l’update | Clé typée, détection et gestion de refus reliées ; pas de nouveau test de panne. |
| Relique visible mais indisponible, cachée ou consommée | Pas de marqueur ; aucun respawn déduit du seul temps client | Deux flags requis et absence de lecture du deadline ; cas CPU hérités. |
| Suppression / nouvelle session / propriétaire absent | Retrait des clés/ressources selon les gardes | Code réel et tests CPU hérités ; pas de nouveau scénario réseau/OS. |
| Même session mais connexion non prête | Aucun résultat natif/fraîcheur présumé | Garde actuelle ne teste pas ready ; reprise ciblée MM-READINESS-01. |
| Ressources importées | DDS identiques ; PNG équivalents RGBA aux TGA originaux | Cinq ponts vérifiés, sans GPU ; manifeste de distribution concordant. |
| 512entrées de trace | Limite du diagnostic uniquement | Le rendu consomme le vecteur complet ; aucun faux plafond ajouté. |

Le reçu **du23octobre2026** conserve19tests CPU réussis, code0, journal identifié. Parmi eux, six concernent directement ce lot :

| Cas identifié | Résultat conservé |
|---|---|
| `map10_native_bounds_and_three_real_hud_records_align_at_both_dpis` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |
| `original_icons_decode_and_team_styles_keep_source_colors_and_strip_cells` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |
| `actual_server_vision_removes_enemy_marker_even_when_roster_retains_identity` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |
| `real_update_retains_entities_and_handles_then_retires_missing_actors_and_session` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |
| `relic_marker_follows_real_visibility_consumption_and_authoritative_respawn` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |
| `relic_draw_keeps_its_binding_and_retires_on_snapshot_and_session_changes` | Réussite CPU héritée du23octobre ; source retrouvée, pas de relance |

Les dix entrées de sources listées par ce reçu (client, tests, profil, shader et Cargo.lock) sont inchangées. Le reçu ne fige pas tous les inputs transitifs core/serveur ; il ne prouve donc pas à lui seul une qualification actuelle complète. Le helper de cycle de vie utilise des handles d’images fixtures1pixel pour certaines ressources ; le décodage/provenance des vrais assets est vérifié séparément. L’ancien binaire de test reste une métadonnée historique, sans nouveau hachage ni exécution.

**Non exécutés maintenant** : Cargo/tests Rust, client historique, REA, jeu, serveur/réseau réels, GPU, entrées OS ou comparaison graphique original/courant. Les noms « real_update » ou « actual_server_vision » des tests ne sont pas présentés comme une session graphique observée. Aucun des19tests n’a été relancé pour accumuler un nouveau compte.

## R5 — Manques précis et reprise

Quinze sous-corrections **proposed_not_applied** sont décrites dans le reçu avec objectif unique, prérequis, source/limite, fin et preuves attendues. Elles ne créent aucune case dans l’application ni modification du plan normatif.

| ID | Travail unique | Critère de fin du futur correctif | Entrée nécessaire à la reprise |
|---|---|---|---|
| `MM-TURRET-STATE-01` | Tourelle : états et persistance | Retrouver Tower/Tower_Destroyed et leur sélection autorisée ; comparer visible/caché/détruit/supprimé/reset. | Contrôleur natif et source courante typée ; réutiliser SYS-13.3-06. |
| `MM-INHIBITOR-STATE-01` | Inhibiteur : états et persistance | Retrouver Inhibitor/Inhibitor_Destroyed et vérifier transitions de visibilité, destruction et retour. | Sélecteur original et contrat autoritaire de cet inhibiteur ; SYS-13.3-06. |
| `MM-HQ-VISIBILITY-01` | Nexus : visibilité du marqueur | Qualifier HQ et sa persistance/suppression ; aucun HQ_Destroyed inventé, cette section n’est pas présente. | Contrôleur original du Nexus et politique de données autorisées ; SYS-13.3-06. |
| `MM-MONSTER-01` | Monstre de camp | Prouver la sélection Camp propre à Map10, ou sa suppression voulue ; vérifier admissibilité neutre/équipe et transitions. | Nouvel appelant/sélecteur Map10 de ce monstre, sans simple substitution Minion. |
| `MM-PET-01` | Invocation nommée | Qualifier le marqueur ou l’absence justifiée pour une invocation précise, selon son propriétaire/équipe. | Sélecteur original du champion/invocation ; aucune section globale Pet prétendue récupérée. |
| `MM-BOSS-01` | Boss/Vilemaw | Identifier le sélecteur Map10 du boss, puis vérifier visibilité et états ; Epic/Baron ne devient pas automatiquement Vilemaw. | Contrôleur natif Map10 et données autoritaires du boss. |
| `MM-FOUNTAIN-01` | Fontaine/base | Prouver lien ou suppression des candidats Fountain/Shop sur Map10 puis vérifier état/équipe. | Sélecteur natif de la fontaine ; sa présence dans le décor ne suffit pas. |
| `MM-CHAMPION-DEAD-01` | Champion mort | Qualifier Champion_Dead, visibilité, mort/respawn et reset pour un champion nommé. | Contrôleur original de l’état mort et transition autoritaire. |
| `MM-ALTARS-01` | Autels Map10 | Identifier sélection ou suppression AltarInitial/Locked/Unlocked et vérifier les deux autels avec verrouillage/possession. | Contrôleur original Map10 et état courant des autels. |
| `MM-RELIC-SELECTOR-01` | Sélecteur original de la relique | Retrouver le rôle/style/ressource TT_Relic original et vérifier visible, indisponible, consommé, réapparu, sans timer client inventé. | Appelant ou trace originale Map10 ; l’étiquette communautaire du commentaire ne fait pas autorité native. |
| `MM-MARKER-SCALE-01` | Taille/zoom d’une famille | Qualifier règle native et comparer dimensions/clipping à des échelles choisies ; maxScale n’est pas actuellement consommé. | Producteur natif du réglage/zoom et valeur courante typée ; HUD-LAYOUT-SCALAR-01 est un prérequis distinct. |
| `MM-STYLE-MODES-01` | Un sélecteur équipe/mode | Comparer les cellules/couleurs exactes pour une relation ou mode nommé, y compris daltonisme/spectateur lorsqu’applicable. | Producteur original de mode/relation et mode courant explicite. |
| `MM-PROJECTION-01` | Projection d’un mode de contrôleur | Comparer8008F0/8009F0 et leurs vraies entrées avec coins/hors-limites/refus ; pan/zoom/orientation non portés restent explicites. | Producteur original de span/pan/zoom et cas identifié ; HUD-LAYOUT-ASPECT-RANGE-01 concerne le cadre, pas cette transformation monde. |
| `MM-READINESS-01` | Interruption dans la même session | Qualifier ready→unready→récupéré avec ancien snapshot/même session/epoch selon une politique explicite conserver/retirer/signaler. | Politique originale ou politique locale acceptée et scénario courant borné ; SYS-05.5-05 à réutiliser. |
| `MM-GRAPHICAL-01` | Cycle graphique autorisé | Avec build/assets identifiés, qualifier une famille à la fois : visibilité, mouvement, disparition, mort/respawn, session et DPI. | Exécution graphique/serveur courante autorisée et oracle original ; NUM-CURRENT-RENDER-01 reste à qualifier. |

Ne pas chercher de nouveau les cinq textures inchangées sans piste nouvelle : leur provenance est établie. Une reprise doit apporter un sélecteur/appelant natif, un producteur courant modifié, une règle autorisée ou un scénario graphique précis. Les sections globales absentes du profil courant ne deviennent pas automatiquement autant de fonctionnalités Map10 obligatoires.

## R6 — Réemploi et résultat séparé

Réutilisation explicite : **SYS-13.1-01**, **SYS-13.3-06**, **SYS-05.5-05**, **HUD-LAYOUT-DPI-01**, **HUD-LAYOUT-ASPECT-RANGE-01**, **NUM-CURRENT-RENDER-01**. La projection du monde, la taille des marqueurs et la géométrie du cadre ne sont pas confondues. Le lien TT_Relic→HealthPack demeure **local** ; le commentaire évoquant la communauté n’est pas une récupération du sélecteur original ni une nouvelle validation communautaire.

Résolu dans l’audit : provenance des cinq textures et du SCB ;92champs du profil ; chaîne serveur→snapshot→marqueurs→cycle de vie ; état du roster et de la relique ;11types classés ; omissions et alternatives distinguées ; périmètre des tests hérités ; reprises atomiques.

Ouvert fonctionnellement : sélecteurs/états natifs, familles Monster/Pet/Boss/Fountain, autels, morts/détruits, rôle original de la relique, mémoire de visibilité, modes couleur, échelle/projection non défaut, interruption et preuve graphique courante. Les quatre dimensions **audit**, **implémentation**, **vérification en exécution**, **acceptation humaine** restent indépendantes. L’inconnue native et la tâche fonctionnelle restent ouvertes ; ce lot ne clôt ni le paquet9tâches, ni FoW/pings, ni la minimap ou le jeu complet.

## R7 — Livraison et conservation

[Preuve principale](F:/OpenLeague-work/audit-units/AUD-17.2-01-MINIMAP-ENTITIES-01/minimap-entities-proof.json), 198781 octets, SHA-256 `744dc95d2b6259631e8a542b0b42366661f97492b332d03d949df2582acc94af`. Elle conserve `audit_scope_closed=false` ; le [reçu indépendant final](F:/OpenLeague-work/audit-units/AUD-17.2-01-MINIMAP-ENTITIES-01/delivery-readback.json) fait autorité pour les sept rubriques de ce lot documentaire.

Nouveaux fichiers uniquement : ce rapport, audit-unit.json, verify_minimap.py, minimap-entities-proof.json, verify_delivery.py et delivery-readback.json dans le dossier isolé du lot. Le producteur crée les fichiers exclusivement ; il ne remplace aucune preuve antérieure.

Relecture sans écriture :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.2-01-MINIMAP-ENTITIES-01\verify_delivery.py' --check-only
```

HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, main,76fichiers suivis déjà modifiés conservés. Les19fichiers logiciels gelés, les six documents de contexte et les cinq registres conservent leurs SHA avant/après. Le manifeste et les textures ont été lus, pas modifiés. Aucun goal, critère, application/UI, code produit, registre/statut ou base n’est modifié ; aucune base ouverte. Aucune installation, migration, relance, suppression ou opération Git de mutation.
