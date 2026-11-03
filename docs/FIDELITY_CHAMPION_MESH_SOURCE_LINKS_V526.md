# SYS-01.2-02 — Sources des maillages de base et dimensions, V526

25 octobre 2026 — Projet F:\OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 distinct. Build daté littéralement du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat intégré

Les **122 tâches CH-*-MODELE-MESH** relient maintenant leurs configurations et maillages natifs aux fichiers effectivement sélectionnés par le client courant, puis aux consommateurs de catalogue, requête GLB, échelle, scène et transformation de racine. L’ancien chargeur partagé de définitions reste conservé comme contexte ; il ne devient pas une preuve de géométrie ou de rendu.

**855 liens** sont ajoutés : sept pour 121 champions, huit pour Ezreal. Cinq points précis sont ajoutés : animation.rs:361 pour le catalogue compilé, :427 pour le retour d’échelle, :441 pour la première scène du GLB chargé, :492 pour son rattachement ; main.rs:1228 pour le facteur uniforme appliqué à la racine. Trois consommateurs existants sont réutilisés : requête du champion reçu, lecture du chemin GLB, sélection particulière Ezreal. Les deux premiers concernent tous les champions, le troisième seulement Ezreal.

Le choix courant d’Ezreal est **champions/ezreal_joint_identity_local.glb**. Le catalogue historique model_catalog.json n’est pas utilisé comme substitut à l’entrée réellement compilée animation_manifest.json. Aucun catalogue, GLB ou asset n’est réexporté dans ce lot.

## Comparaison réellement exécutée

Le collecteur relit les sources SKN de l’inventaire d’export conservé et les GLB actuellement sélectionnés. Il traite 96 SKN 2.1 et 26 SKN 4.1 ; les autres versions sont refusées par ce lecteur borné. Les partitions de sous-maillages, sommets, indices et accès aux buffers sont contrôlés. Les positions finies sont comparées en valeurs et en bits f32 ; les indices conservent leur ordre. Les noms de matériaux sont comparés, sans qualifier leurs textures ou leur shader.

Sur les 122 modèles : **597 877 sommets** et **2 562 636 indices** comparés. Aucune divergence des positions, de leurs bits, des indices ou des noms de matériaux n’est observée. La scène sélectionnée est la première du GLB ; son unique nœud de maillage et ses ancêtres statiques ont une transformation identité dans le corpus inspecté. Les bornes brutes proviennent des positions décodées. Elles ne représentent pas les volumes animés après skinning.

Les noms SimpleSkin des configurations sélectionnées correspondent aux basenames des entrées d’export comparées. Les 244 entrées natives (122 configurations et 122 maillages) sont vérifiées par chemin, taille et MD5 dans les deux manifestes de projets choisis par la solution 4.20 EUW. Cela ne démontre pas toute la priorité de montage du cache, des packages et des overlays historiques.

Les valeurs retournées par les getters natifs de SkinScale viennent du reçu antérieur original-skin-resources-execution.json, dont l’identité est contrôlée. Ce getter n’est pas réexécuté ici. Les 122 valeurs actuelles, après le cast f32 réellement présent dans le code, ont les mêmes bits que ces valeurs natives héritées. Les 12 corrections de précision qualifiées auparavant restent conservées ; le décodage Python normalisé brut n’est pas promu à leur place. Le facteur de racine courant est projeté avec les opérations f32 de 0.05 × scale. Les bornes mises à l’échelle sont une projection documentaire, pas une mesure dans une partie ou un framebuffer.

Les identités de GLB du reçu V109 utilisé ici correspondent toutes aux fichiers actuels. Ce constat concerne ce reçu précis ; il ne réécrit pas les autres observations historiques, notamment les anciens hashes Gnar conservés ailleurs.

Le contrôle de dépendances GLB vérifie les références de buffers/images et leurs plages d’octets. Il ne lance aucun codec ni GPU. Les sources du convertisseur StructureExport et de LeagueToolkit sont identifiées comme code communautaire ; elles ne deviennent pas des règles du client original.

## Essais, limites et refus

Deux échecs initiaux sont conservés avec leurs sources et journaux. Le premier révèle que le lecteur de manifestes exige les chemins E historiques inscrits dans le catalogue récupéré. Les deux manifestes existent sur E et leurs copies sur F ont les mêmes tailles et SHA-256. Le lecteur historique valide est donc employé avec cette équivalence explicite ; les manifestes ne sont pas réécrits et le défaut de portabilité du lecteur sur F reste ouvert. Le deuxième essai exigeait un enregistrement direct de la copie F du reçu de getters : seule son identité E était enregistrée. Le collecteur final vérifie la copie F contre cette contrepartie E et conserve les deux chemins, sans inventer une identité de source ou une nouvelle exécution native.

Six cas de format sont réellement refusés sur des copies mémoire : SKN tronqué, mauvais en-tête, table de matériaux débordante, accessor GLB débordant, buffer tronqué et scène 0 vide. Aucune source n’est altérée pour ces contrôles.

Le candidat refuse également 92 associations falsifiées : mauvais propriétaire, lecteur retiré, source ou champ inventé, promotion du catalogue, fausse exécution native ou client, acceptation GPU, dimensions animées ou couverture de tous les skins inventées, priorité historique prétendue et fausse acceptation complète. Les cas ciblés empêchent notamment de remplacer le fichier effectivement choisi pour Ezreal, d’altérer la preuve de position, le hash natif ou l’échelle observée. Trois refus du lecteur public couvrent un consommateur absent, une source absente et une acceptation comportementale inventée.

Les fragments de traçabilité de toutes les 42 215 tâches sont comparés : 122 changent, 42 093 restent exacts. Les 42 092 autres objets tâche/trace sont préservés. Identités, hiérarchie et registre d’inconnues restent identiques en octets. Tous les critères, statuts a_faire, dépendances et indicateurs d’acceptation des 122 tâches sont conservés ; aucune case n’est cochée.

La copie privée puis les deux bases réelles sont vérifiées avec Store.task, copy_text, summary, dépendances et rt.resolve. Par base : 123 destinataires vérifiés, 42 484 autres lignes catalogue, 42 607 états/notes et 23 historiques exacts. Intégrité SQLite OK ; synchronisation normale suivante idempotente. Préparation, contrôle, publication et audit finissent au code 0. Les transactions sont séquentielles ; aucune atomicité globale fichiers/deux bases n’est revendiquée.

**Aucun nouveau build Rust, aucune exécution Bevy, client original, GPU, réseau ou audio.** Une égalité de positions et d’échelles n’accepte ni les squelettes, bind matrices et influences, ni les UV, matériaux, textures, animations, formes, skins, clips, visibilité et tailles pendant une partie ordinaire. Ces limites sont séparées des mesures passées et des tâches correspondantes. Le rig Veigar et les autres anomalies antérieures ne sont pas clos par ce résultat de maillage.

## Investigation poursuivie sur les squelettes

La découverte **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision527_rig_discovery_identity\DISCOVERY.json** a également été exécutée, sans écrire dans les registres ou bases. Elle compare les chemins hiérarchiques complets de 9 254 joints natifs à 9 253 joints dans les GLB sélectionnés, puis les destinations d’influences positives. Elle confirme un écart sur Veigar : 50 joints natifs contre 49, le joint natif 34 « toe » sous R_foot est absent et 33 influences concernent cette identité manquante. Aucune correction du modèle n’est effectuée dans ce lot de traçabilité.

Les 9253 identités comparables ont leurs matrices locales et inverses de bind dans le seuil documentaire de 1e-3, avec un calcul indépendant en float64. Le joint absent reste non comparable. Cette projection ne qualifie ni le contexte float32 du client original ni les déformations animées ou le rendu.

La première découverte conserve aussi les résultats de l’ancien helper qui apparie les joints par nom seul. Ce helper est insuffisant pour les trois noms répétés R_PARENTING_HAND_LOC d’Ezreal et compare un « toe » de Veigar entre branches différentes. La seconde découverte utilise le chemin complet des parents ; les résultats du helper ancien restent séparés et ne sont pas présentés comme trois joints absents ou une nouvelle panne de matrices. Les deux commandes finissent au code 0. Ces preuves de rig ne sont pas encore liées aux 122 tâches MODELE-RIG ; c’est la prochaine intégration à réaliser.

## Réexamen global et livrables

Le réexamen en lecture seule **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision527_trace_review\REVIEW.json** vérifie le graphe de 42 215 exigences, les 2 661 ancres et les octets des 509 fichiers courants, sans divergence. Les 17 auxiliaires intentionnels sont conservés. La file CH dont le seul lien applicable est le chargeur partagé passe de 9 354 à **9 232**. Cette file repère des liens à préciser ; elle n’est pas un comptage de fonctionnalités absentes ni une mesure de complétion du jeu.

Le réexamen ne rehache pas tous les 98 765 fichiers sources. Le contrôle des sources du présent lot et le précédent recensement global restent des preuves de portée distincte. Le texte condensé conserve son plafond de trois consommateurs ; le graphe complet et le reçu exposent les sept ou huit ajouts par fiche.

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et les deux bases locales du plan. Couverture, plan de complétion, checkpoint, CURRENT.md et HANDOFF.md reçoivent ce contexte après sauvegarde.

Ajoutés : docs/reference_requirement_trace_sources/champion-mesh-source-links-v526.json ; docs/fidelity_champion_mesh_source_links_v526.json ; présent rapport. Deux sources documentaires et cinq consommateurs sont ajoutés. Aucun code produit, lecteur maintenu, asset, pack ou manifeste n’est modifié.

Graphe final : 42 215 exigences, 98 765 sources, 2 661 consommateurs, 25 919 questions ouvertes et 5 517 résolues avec historique. Les inconnues, 46 arrivées manquées V523 et leurs 92 questions, limites Gnar V522 et écarts V512–V525 sont préservés. Aucun modèle animé, champion ou jeu complet n’est déclaré accepté.

Travail privé : revision526_mesh_inspection_final et revision526_mesh sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20. Les deux essais d’inspection antérieurs restent conservés. Les commandes et environnements sont identifiés dans les reçus de ce répertoire. Ne pas republier ce lot.

La découverte suivante est déjà exécutée : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision527_rig_discovery_identity/DISCOVERY.json. Utiliser sa comparaison par chemins hiérarchiques : 9 254 joints natifs, 9 253 joints GLB ; Veigar manque du joint droit natif34 et 33 influences sont concernées. Les matrices comparées par identité sont dans le seuil documentaire1e-3 ; le joint absent reste non comparable. L’ancien helper par nom seul est conservé séparément : ses ambiguïtés Ezreal et sa comparaison Veigar entre branches ne doivent pas être promues en erreurs de matrices ou en assets manquants. Cette découverte n’est pas encore liée aux122fiches RIG ; qualifier le contrat et les consommateurs réels puis intégrer les preuves, sans réparer le produit hors du périmètre SYS. Poursuivre SYS-01.2-02 à partir de F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision527_trace_review/REVIEW.json. Les 9 232 fiches CH avec le chargeur partagé comme seul consommateur applicable forment une file de qualification, sans absence d’implémentation démontrée. Traiter ensuite les 122 CH-*-MODELE-RIG : réexaminer les SKL et GLB effectivement sélectionnés, les identités et parents de joints, influences et matrices de bind ; réutiliser les preuves V109 et la correction Ezreal joint_identity sans écraser les divergences Veigar ni qualifier les poses animées par la seule égalité des positions. Garder les 122 contrats MESH V526 distincts du rig, UV, textures, matériaux, packs et formes/skins. Le lecteur de manifestes possède encore des chemins E historiques ; copies F vérifiées identiques, aucune portabilité autonome revendiquée. Préserver V512–V525, les écarts numériques, les 46 arrivées manquées V523 et leurs 92 questions, V522 Gnar, les 17 auxiliaires et les cases/notes/historiques. Publication V526 terminée : ne pas la répéter. Goal entier actif.
