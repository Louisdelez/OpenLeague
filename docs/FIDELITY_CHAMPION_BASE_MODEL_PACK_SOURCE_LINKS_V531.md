# SYS-01.2-02 — Packs des modèles de base, V531

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MODELE-PACK** relient maintenant les entrées natives de l’export, les modèles effectivement sélectionnés, les déclarations du manifeste, les membres des ZIP réels et les lecteurs actuels. **4 780 liens natifs** sont ajoutés : 488 entrées config/SKN/SKL/DDS et **4 292 déclarations de fichiers d’animation** de l’inventaire d’export. Toutes ces déclarations ANM correspondent aux manifestes natifs sélectionnés ; cela n’accepte pas leurs poses, événements ou liaisons de canaux.

**1 343 liens de consommateurs** sont ajoutés : 1 342 liens de composants bornés et un lien de contexte de sélection Ezreal qui reste marqué entry_boundary_only/provides_feature_consumer=false. Quatre nouveaux points de code et trois documents de preuve rejoignent le registre. Les identités physiques déjà inscrites restent inchangées. Aucun statut de tâche, critère, case, note utilisateur ou question native n’est changé.

Les ZIP sont ceux de la distribution actuelle du projet. Ils ne sont pas assimilés au format, au patcher ou au comportement de l’installateur RADS d’origine.

## Attendu et observé

| Contrôle | Attendu dans le périmètre | Observé |
| --- | --- | --- |
| Sélection des modèles | Respecter le chemin choisi par le code courant | 122 chemins identifiés, dont ezreal_joint_identity_local.glb |
| Provenance native | Config, maillage, rig, texture et déclarations d’animation identifiés | 488 entrées principales + 4 292 ANM conformes aux manifestes |
| Déclaration et présence | Distinguer fichier déployé, manifeste et membre ZIP | 122 déclarations uniques, tailles et SHA exacts dans les trois cas |
| Dépendances glTF | Inspecter les conteneurs utilisés | Un buffer incorporé par modèle, images incorporées, aucune URI externe |
| Archives réelles | Vérifier leurs identités et leurs tables complètes | Quatre tailles/SHA exacts ; noms, tailles, absence de doublons, collisions de casse, symlinks et chiffrement vérifiés |
| Restauration réelle | Utiliser le vrai restore(), sans remplacement du lecteur | 1 347 fichiers, 3 702 835 780 octets, extraits dans une racine privée puis vérifiés indépendamment |
| Répétition | Conserver octets et dates si le fichier est exact | Répétition réelle sans réécriture, contrôlée sur les 1 347 fichiers |
| Refus/protection | Refuser les cas pertinents et conserver les données privées divergentes | 14 refus ; protection de trois documents de travail ; force explicite testé uniquement sur copies privées |

Archives concernées :

| Archive | Fichiers | Octets décompressés |
| --- | ---: | ---: |
| openleague-assets-01.zip | 1049 | 1256830372 |
| openleague-assets-02-gnar-local-20261015.zip | 80 | 1252255264 |
| openleague-assets-03.zip | 217 | 1175498416 |
| openleague-assets-15-ezreal-joint-identity-local-20261017.zip | 1 | 18251728 |

Deux archives sont déclarées local_only dans le manifeste actuel. Leur cache local est présent et vérifié. Aucune URL distante, disponibilité réseau ou installation sur une autre machine n’est déduite de cette présence locale.

## Consommateurs réels

Le manifeste du projet est lu par tools/download_assets.py. Les fonctions digest, destination et restore sont réutilisées avec leurs identités et qualifications existantes. Les nouveaux liens identifient précisément le contrôle de table des membres à la ligne35 et le contrôle de taille/SHA du cache à la ligne80. La fonction restore effectue le contrôle de destination, de taille/type, de divergence locale, de checksum extrait puis le remplacement atomique **par fichier**.

Le client configure son fournisseur Bevy sur root/assets à main.rs:653. La racine provient de **CARGO_MANIFEST_DIR à la compilation**, puis ../.. à la ligne518. Les requêtes de modèle et assets.load sont reliées aux points réels de main.rs et animation.rs. Ce sont des observations du code courant ; aucun exécutable client n’a été lancé pour confirmer sa racine effective, son chargement, sa relocation ou son rendu.

Les anciens descripteurs de frontière **OLC-8103447b-d1b0-58fc-bf05-4a7fed0c6a4e, OLC-ec231288-b3d0-5692-b72d-ed589e7fa5a1, OLC-592004f8-fd00-5df7-a0dc-59b5f3e28b0e** restent identiques et faux pour la complétude de leur fonction plus large. Les contrôles locaux des ZIP de modèles ne les promeuvent pas en preuve de reconstruction déterministe, fermeture dynamique des ressources ou distribution complète. La sélection Ezreal est conservée comme contexte seulement.

## Exécution réelle et contrôles

Le vrai module F:/OpenLeague/tools/download_assets.py a été chargé sans appeler main ni sa branche HTTP. **restore(root_prive, archive_reelle, entrees_reelles)** a d’abord extrait les quatre archives dans une racine vide sous **F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision531_pack_runtime/restored**. Tous les fichiers ont été vérifiés après écriture. L’exécution initiale a ensuite rencontré une mauvaise attente de contre-test ; ses fichiers, source et journal restent conservés. La reprise a réutilisé cette racine, revérifié chaque fichier et exécuté la répétition sans changement d’octets ou de dates. Les copies n’ont pas été recréées dans une nouvelle racine pour masquer l’échec.

Un modèle réel restauré a été modifié dans cette seule racine privée : le restaurateur a refusé de l’écraser par défaut, a conservé ces octets et n’a laissé aucun temporaire. Un appel force=True explicite a ensuite rétabli la copie privée exacte. Le modèle du projet et ses packs n’ont pas été modifiés.

Les ZIP artificiels servent uniquement aux contrôles de refus/protection : parent/absolu/lecteur, table inattendue ou doublonnée, taille, lien symbolique, checksum, politiques de préservation invalides et erreur tardive de membre. Un test direct de destination vérifie l’antislash. Le créateur ZIP Windows normalise l’antislash du fixture avant restore ; le refus de la table intervient alors avant la destination. L’attente initiale sur le message a été corrigée, le garde réel n’a pas été modifié.

Les trois documents autorisés — coverage.json, completion_plan.json et resume_checkpoint.json — ont été testés sur des fixtures explicitement privées : modifications conservées par défaut avec dates inchangées ; force explicite rétablit uniquement ces fixtures. Les documents réels du projet restent exacts avant/après cette exécution. Ces fixtures ne remplacent aucune source native et ne prouvent pas la disponibilité d’une ressource du jeu.

Le contrôle d’échec tardif démontre aussi une limite : **le premier membre valide reste présent quand le second échoue au checksum**. Les temporaires sont nettoyés, mais il n’existe pas ici de transaction/rollback de l’archive complète. Cette limite reste distincte des preuves de présence et de restauration correctes des quatre archives fournies.

Les commandes de reprise runtime, inspection qualifiée, préparation, contrôle privé, publication et audit renvoient **0**. Vingt-neuf faux constats propres sont refusés : propriétaire, lecteur manquant, équivalence RADS/ZIP inventée, poses acceptées depuis la présence, GPU/jeu/rollback/relocation inventés, source d’animation retirée, hash altéré, modèle Ezreal erroné, frontière promue ou question Veigar supprimée. Quatre refus du lecteur public protègent sources/consommateurs absents, acceptation inventée et inconnue étrangère.

Les deux inspections préliminaires échouées sont également conservées : l’une accédait à un champ facultatif du reçu, l’autre traitait à tort toute référence réutilisée comme composant au lieu de conserver la frontière Ezreal. La version qualifiée sépare ce contexte et contrôle son descripteur inchangé. Aucun de ces codes1 n’est présenté comme succès du produit.

Python, son exécutable, le module zipfile, les scripts, arguments, archives, logs et sorties sont identifiés dans les reçus et EXECUTION_ENVIRONMENT.json. Aucun jeu historique, nouveau client, GPU, Blender, build Rust, compilateur de shader, audio ou réseau exécuté. Les fichiers d’animation ont été identifiés et vérifiés au manifeste, pas joués ou convertis dans ce lot.

## Intégrité des registres et des bases

Les 122 extraits de trace ciblés changent, **42 093 autres extraits sont exacts**. Les 42 092 autres objets tâche/trace sont identiques. IDs, hiérarchie et fichier des inconnues sont **exacts en octets**. Tous les anciens objets sources/consommateurs restent exacts ; les questions rig, textures et matériaux demeurent chez leurs propriétaires, visibles via leur vraie résolution, sans adoption par les tâches PACK ni clôture.

Par base : **123 destinataires**, **42 484 autres lignes catalogue exactes**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie, résolution, dépendances, résumé, intégrité et synchronisation normale idempotente vérifiés. Les deux premiers contrôles de packs apparaissent dans les trois liens du texte condensé ; le reçu et la résolution complète exposent le reste, notamment les 4 292 déclarations ANM.

Réexamen global frais : **42 215 exigences**, **98 793 sources**, **2 710 CID**, **526 fichiers de consommateurs**, zéro divergence d’ancre ou d’octets. Les 17 auxiliaires voulus sont conservés. Questions inchangées : **26 064 ouvertes**, **5 517 résolues**. Les **8 622 fiches CH** au seul chargeur partagé restent une file de qualification ; ces catégories ne prouvent ni une absence d’implémentation ni un pourcentage de jeu terminé. Aucun nouveau hash physique global des 98 793 sources revendiqué.

## Limites de ce résultat

Les modèles restaurés sont les **GLB actuels**, avec leurs données embarquées exactes. Cela ne résout pas le rig Veigar, les mips, les écarts alpha, les ressources/variantes de matériaux non qualifiées, les clips/poses/événements ni les autres limites de fidélité. La présence et la restauration d’un GLB ne prouvent pas qu’il reproduit toutes les propriétés du modèle natif. Les ressources globales, autres packs, métadonnées de jeu et dépendances d’un exécutable complet restent séparées. Aucune installation complète ou sur machine vierge n’est acceptée.

## Fichiers et preuves

- Registres modifiés : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json. Inconnues, identités et hiérarchie conservées en octets.
- Reçu : docs/reference_requirement_trace_sources/champion-base-model-pack-source-links-v531.json ; vérification : docs/fidelity_champion_base_model_pack_source_links_v531.json.
- Inspection : revision531_pack_inspection_qualified/OBSERVATIONS.json ; restauration/contrôles : revision531_pack_runtime_resume/EXECUTION.json ; fichiers réels dans revision531_pack_runtime/restored.
- Sauvegardes, candidats, contrôles, audit : revision531_pack ; commandes revision531_pack_COMMAND_*.json/.log ; scripts et échecs précédents conservés.
- Réexamen : revision532_trace_review/REVIEW.json. Couverture/reprise : docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md, champs antérieurs conservés.
- Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Aucune donnée manuelle modifiée.

## Suite du Goal

La découverte des fiches MODELE parentes est exécutée : **122 parents**, **854 dépendances**, les sept sous-tâches attendues présentes partout, aucun enfant absent. Tous les parents restent partiel_a_requalifier ; 145 questions demeurent chez leurs enfants. L’union des composants positifs des enfants ne constitue pas à elle seule un consommateur de validation complète du parent. Aucun lien parent n’est publié par cette découverte. Voir revision532_model_parent_discovery/DISCOVERY.json.

Poursuivre SYS-01.2-02 depuis revision532_trace_review/REVIEW.json : 8 622 fiches CH ont encore le chargeur partagé seul, file de qualification sans absence d’implémentation démontrée. Examiner les 122 CH-*-MODELE parents depuis revision532_model_parent_discovery/DISCOVERY.json : 854 dépendances, les sept slots MESH/RIG/UV/TEXTURES/MATERIAUX/PORTRAITS/PACK présents partout, aucun enfant absent, statuts partiel_a_requalifier et 145 questions chez les enfants. La découverte recense 60 composants positifs distincts par union ; cette union ne prouve pas un validateur complet ni une acceptation du parent. Inspecter les véritables consommateurs de chaque critère de validation/import/rendu/pack avant de publier des liens ; préserver les sept dépendances et toutes les frontières. Ne pas déclarer le modèle/champion accepté depuis la restauration. V531 : 122 modèles exacts dans quatre archives et la copie privée, 1 347 fichiers restaurés/vérifiés, 4 292 déclarations ANM conformes aux manifestes ; fichiers privés sous revision531_pack_runtime/restored, ne pas refaire les copies. Les 14 refus et protections des trois documents sont acquis ; échec initial de fixture antislash et deux contrôles de métadonnées conservés/corrigés. Conserver Ezreal en contexte non promu, racine client de compilation distincte d’un exécutable observé, ZIP du projet distincts de RADS, absence de rollback global. Préserver les 22 questions textures, 122 matériaux, Veigar joint 34/33 influences, 168 UV hors unité, 46 arrivées V523/92 questions et 17 auxiliaires. V531 publié et audité : ne pas republier. Goal entier actif.
