# SYS-01.2-02 — Irelia : Ionian Fervor, V577

Date UTC : 2026-10-26T01:59:23.517447+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

CH-Irelia-PASSIF-SOURCE, CH-Irelia-PASSIF-SIMULATION-CONTRAT et CH-Irelia-PASSIF-SIMULATION reçoivent 24 associations vers huit ressources natives et 54 liens vers 27 points actuels. Une règle locale absente du registre est également identifiée et reliée à son lecteur. SYS-01.2-02 référence le lot. Trois inconnues propres, quatre dépendances, critères et statuts conservés. Les prérequis des phases et lots ont été consultés sans être acceptés comme accomplis.

**Le moteur courant n’applique pas la réduction d’Irelia dans les chemins testés.** La réduction de Courage de Garen fonctionne dans le contrôle séparé. Les liens restent des frontières de l’implémentation actuelle : `entry_boundary_only`, `provides_feature_consumer=false`. Aucun gameplay ni asset modifié.

## Sources natives et inconnues

| Ressource | Identifiant |
|---|---|
| Irelia.inibin | OLS-c954ba82-b292-501b-b83b-b94406ad1053 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptIrelia.luaobj | OLS-97cdb18c-d260-5971-94ce-3422ea1dfce5 |
| CharScriptIrelia.preload | OLS-bb6c82da-46e0-54fb-a833-52477a1969a3 |
| IreliaIonianDuelist.inibin | OLS-0f605556-a424-5949-b13f-dc0c056c30ac |
| IreliaIonianDuelist.luaobj | OLS-ddd7b521-7389-5fb6-b6a6-cfae08f7e8dc |
| IreliaIonianDuelist.preload | OLS-a5183631-1bb1-5510-8382-147d564311f0 |
| Irelia.ddf | OLS-8f0a07db-9372-543f-9fa9-1b63d40c5e7b |

Taille/SHA256 vérifiés contre le registre, taille/MD5 contre les manifestes RADS sélectionnés. L’ordre effectif de montage historique n’est pas établi par cette appartenance.

La description en_GB ligne 4202 indique une réduction des contrôles selon les champions ennemis proches : un = 10 %, deux = 25 %, trois = 40 %. Le binding IreliaIonianDuelist, ligne 2022, affiche f1 en pourcentage. Le producteur f1, la portée, les conditions de comptage, les catégories de contrôles, les exceptions, cumuls et arrondis ne sont pas fournis par ces textes.

**La définition du personnage conserve Passive1LuaName=Voracity**, alors que le preload CharScriptIrelia référence IreliaIonianDuelist, comme le buff et son tooltip. Aucune substitution automatique ni règle de Katarina n’est adoptée. Le caractère effectif ou hérité du champ Voracity reste à qualifier. Les icônes personnage et buff correspondent à Irelia_IonianFervor.dds.

Deux chunks Lua entièrement lus, sans prototype enfant, initialisations littérales reconnues : CharScriptIrelia a des globals vides ; le buff donne son nom et son icône. Aucun callback serveur exécuté. Le champ de persistance absent ne vaut pas false.

Les deux preloads sont conservés. Celui du personnage mentionne aussi HitenStyle et une particule idle ; celui du passif référence le buff et trois particules distinctes. Leur existence ne prouve pas leur activation ou leur rendu. Le DDF comporte quatre entrées de Transcendent Blades (R), sans producteur du passif. Passive1Level1..6 sont absents, sans valeurs par défaut inventées.

Sept références communautaires sont conservées séparément. CharScriptIrelia.cs est vide ; le JSON du personnage conserve lui aussi Voracity. Aucune exécution du serveur historique n’en est déduite.

## Commandes publiques réellement exécutées

Quatre cas Irelia utilisent zéro, un, deux ou trois ennemis proches, obtenus par join, Move et Stop. Le cas zéro conserve l’ennemi à environ 13 262 unités. Les autres placent Garen à 150, Annie à environ 250 et Trundle à 350 unités ; Ahri et Ashe servent uniquement à respecter l’alternance des équipes et restent éloignées. Les personnages restent vivants. Aucun changement direct de position, santé, niveau, rang, XP ou effet ; aucun PNJ supprimé.

**400 unités est un seuil de regroupement du diagnostic, pas la portée native du passif.** Le fait que les ennemis soient dans ce groupe ne prouve pas les conditions historiques exactes d’activation.

Dans chacun des trois cas avec ennemis proches, Garen apprend et lance publiquement Q, puis attaque Irelia. Le windup précédent, sa cible, son tick de libération, l’état renforcé et la perte de santé identifient l’impact. La durée brute du silence est lue par le consommateur actuel du contrat Garen : 45 ticks. Observé : 45 ticks dans les trois cas, avec disparition du prédicat de silence à l’échéance exacte, soit 135 ticks de suivi public. Ce lot ne requalifie pas tous les dégâts de Garen Q ni leur présentation.

## Événements serveur de diagnostic distincts

Les appels `grant_stun` et `grant_slow` sont des événements serveur explicites ; **ils ne sont pas présentés comme des sorts lancés par un joueur**. Pour chaque cas Irelia, un étourdissement et un ralentissement de 25 % sont appliqués ensemble pour des durées brutes de 1, 30 puis 90 ticks. Le ralentissement et l’étourdissement ont chacun leur état et leur échéance vérifiés.

Deux autres simulations utilisent Garen, sans ennemi proche : état de base puis activation publique de Courage, appris par Learn et lancé par Cast. Les événements serveur y utilisent 90 ticks.

| Cas | Ennemis du groupe diagnostic | Silence Q public, ticks | Durées serveur brutes → observées | Refus publics | Refus serveur |
|---|---:|---:|---|---:|---:|
| irelia_enemies0_couragefalse | 0 | — | 1 → 1, 30 → 30, 90 → 90 | 18 | 9 |
| irelia_enemies1_couragefalse | 1 | 45 | 1 → 1, 30 → 30, 90 → 90 | 18 | 9 |
| irelia_enemies2_couragefalse | 2 | 45 | 1 → 1, 30 → 30, 90 → 90 | 18 | 9 |
| irelia_enemies3_couragefalse | 3 | 45 | 1 → 1, 30 → 30, 90 → 90 | 18 | 9 |
| garen_enemies0_couragefalse | 0 | — | 90 → 90 | 1 | 9 |
| garen_enemies0_couragetrue | 0 | — | 90 → 63 | 1 | 9 |

Attendu pour les voies génériques inspectées : Irelia conserve les durées brutes ; Garen sans Courage conserve 90 ; Courage applique le calcul local de 70 % et produit 63. Observé : ces résultats exacts. Au total, 14 paires de contrôles, soit 28 événements, suivies pendant 637 ticks. Les états restent actifs jusqu’au tick précédent leur échéance et sont expirés à celle-ci. Les positions restent constantes pendant ces périodes sans ordre de déplacement accepté.

Les 74 refus publics comprennent 60 refus Irelia — joueur inconnu, attaque de soi, slot invalide, Learn/Cast/CastAt pour quatre capacités — et 14 ordres de déplacement refusés pendant un étourdissement. Les 54 refus serveur couvrent source/cible inconnue, tag vide, durée nulle, ralentissement non fini ou supérieur à un. Tous les snapshots comparés restent inchangés après refus.

Ce contrôle confirme le fonctionnement du consommateur courant de Courage, **sans adopter son multiplicateur ou son arrondi comme règle d’Irelia**. Il ne qualifie ni suppressions, projections, charmes, peur, plusieurs sources, objets de ténacité, changements de niveau, visibilité, mort/réapparition, réseau, HUD, VFX, audio ou animations.

## Consommateurs et source locale manquante corrigée

Les points liés couvrent commandes, rangs, sorts, attaque renforcée, application du silence, calcul de durée, admission/application/expiration des étourdissements et ralentissements, snapshots et cycle de vie statique. `control_duration` applique uniquement Courage dans le code inspecté ; il ne compte pas les ennemis pour Irelia.

La première inspection s’est arrêtée sur un KeyError : `data/4.20/disabled_cast_rules.json` existait mais n’avait aucune entrée dans le registre. Le script initial est conservé. L’inspection qualifiée ajoute une entrée locale avec chemin, taille et SHA256, ainsi que le lecteur exact `stuns::allows_disabled`, qui charge ce fichier par `include_str!`. Le candidat vérifie l’identité de la source et ce chemin de chargement.

Cette table autorise ou refuse certains sorts sous contrôle. Elle n’établit aucune immunité native d’Irelia. Son lecteur est inspecté statiquement dans ce lot ; aucune couverture d’exécution de toutes ses branches n’est revendiquée. Les snapshots de simulation ne sont pas une preuve de transport réseau.

## Identités, contrôles et conservation

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-irelia-passive-ionian-fervor-probe.exe`. Taille : 6078976 octets. SHA256 : `6a9ecfb00b4aa08c80f555455825186194abd839a9711ba5c7bd878dfb08bd11`.

BUILD/RUN code 0, openleague_core courant non-test. Verrou privé aligné sur les identités/checksums du verrou racine. Les 1 158 entrées core/ressources et la chaîne antérieure restent identiques, dont Heimerdinger V576 et ses trois essais échoués. Aucun client ou serveur historique exécuté.

Discovery, inspection qualifiée et chaîne de livraison qualifiée prepare/check/publish/audit : code 0. L’inspection initiale échouée reste distinguée. La première préparation s’est également arrêtée avant publication : sa comparaison utilisait un élément au lieu de la tranche complète des consommateurs ajoutés. Le script, le candidat, le reçu et le journal PREPARE de code 1 sont conservés. La comparaison complète corrigée est exécutée dans revision577_Irelia_qualified ; les journaux portent QUALIFIED_COMMAND. Aucun échec ancien n’est réécrit comme succès.

Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments enrichis, 42 212 autres inchangés. Lecteurs réels Store.task/copy_text/summary/dépendances et résolution de trace vérifiés dans les deux bases SQLite. Chacune conserve 42 603 autres lignes, 42 607 états manuels et 23 historiques ; quatre destinataires enrichis, intégrité et synchronisation idempotente vérifiées. Identifiants, hiérarchie et registre des inconnues identiques en octets.

Revue fraîche : 42 215 exigences, 98 985 sources, 3 480 consommateurs ; 3 480 ancres exactes, aucune divergence courante. Les 26 189 inconnues ouvertes et 5 517 résolues sont inchangées. Quatre nouvelles sources de preuve et une source locale identifiée expliquent l’augmentation de cinq sources. La revue structurelle ne re-hashe pas toutes les sources et ne mesure pas un pourcentage du jeu terminé.

## Travail restant

- Qualifier le producteur f1, la portée et les conditions exactes du comptage ennemi.
- Résoudre l’usage effectif du champ Voracity sans substitution arbitraire.
- Établir les contrôles éligibles/exclus, cumuls, arrondis et durées minimales.
- Intégrer le calcul d’Irelia aux consommateurs pertinents, puis vérifier de vrais déclencheurs de sorts pour chaque contrôle.
- Vérifier entrées/sorties de portée, visibilité, morts, clones, plusieurs sources, objets, niveaux et fin de partie.
- Qualifier séparément réseau, HUD, animations, particules, VFX et audio.
- Conserver les défauts de déplacement antérieurs, dont V564 ; aucun n’est corrigé par ces essais réussis.

## Fichiers et reprise

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/irelia-passive-ionian_fervor-links-v577.json. Preuve : docs/fidelity_irelia_passive_ionian_fervor_links_v577.json. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts/journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision577. Aucune case, aucun statut ni inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision578_trace_review/REVIEW.json. IreliaV577 publiée/auditée :3fiches,8natives,1règle locale ajoutée,24associations,27points/54liens limités. Quatre cas Irelia0à3ennemis et deux contrôles Garen :3silences Q publics45ticks;14paires serveur stun/slow avec Irelia1/30/90inchangés,Courage90à63;74refus publics54serveur637ticks. Portée native inconnue,400diagnostic seulement;Voracity conservé distinct du preload. Préserver chaîne V576,inspection initiale manquant disabled_cast_rules et PREPARE initial échoué pour comparaison de tranche;livraison qualifiée séparée revision577_Irelia_qualified. Aucun statut/case/inconnu fermé. Poursuivre un autre passif après inspection réelle,par exemple Janna. Défaut déplacementV564 ouvert;goal actif.
