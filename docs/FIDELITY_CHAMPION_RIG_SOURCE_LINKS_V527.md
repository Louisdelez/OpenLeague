# SYS-01.2-02 — Squelettes, influences et lecteurs de skinning, V527

25 octobre 2026 — Projet F:\OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 distinct. Date littérale du build : 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MODELE-RIG** relient maintenant leur configuration Skeleton, le SKL sélectionné dans l’inventaire conservé et les influences SKN aux données du GLB effectivement choisi et aux vrais lecteurs de skinning de la dépendance déclarée par OpenLeague.

**1 343 liens** sont ajoutés : onze pour 121 profils, douze pour Ezreal. Huit consommateurs précis couvrent la conversion d’indices de joints, la lecture des poids, les matrices inverses de bind, l’association des entités de joints, l’initialisation et la mise à jour des matrices de déformation, le shader à quatre poids et son appel depuis le vertex shader. Quatre consommateurs existants sont réutilisés : requête du champion, lecture du chemin GLB, rattachement de scène et override Ezreal. Le dernier ne concerne qu’Ezreal.

Ces huit lecteurs sont les **fichiers réels du cache Cargo** Bevy 0.19.0, pas des copies documentaires présentées comme du code exécuté. Leurs chemins absolus sont enregistrés comme tels. Les archives locales .crate ont le SHA-256 inscrit dans Cargo.lock ; les sept fichiers de source inspectés correspondent aux membres des archives. Quatre fichiers de dépendance utilisés par les nouvelles ancres reçoivent une identité de source ; le fichier loader/mod.rs était déjà enregistré. Les sources de politique et de conversion de coordonnées sont identifiées dans l’inspection sans être promues en preuve de rendu.

Cette vérification établit la correspondance avec la **dépendance verrouillée dans le code courant**. Elle ne démontre pas l’identité d’un exécutable déjà lancé ou une exécution GPU. Aucun fichier de bibliothèque n’est modifié, copié dans le produit ou recompilé dans ce lot.

Une résolution réelle par **cargo metadata --locked --offline --format-version 1 --filter-platform x86_64-pc-windows-msvc** finit aussi au code 0 depuis F:\OpenLeague. Elle confirme que les deux packages sont résolus vers les mêmes répertoires de cache que les fichiers inspectés. Preuve : **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision527_current_cargo_resolution_windows\RESOLUTION.json**. Aucun build ou jeu n’est lancé et les manifestes et le lock restent identiques.

L’essai précédent sans filtre de plateforme échoue au code Cargo 101 : **accesskit_consumer v0.37.0 manque dans le cache hors ligne**. Ce diagnostic et ses journaux sont conservés. La résolution Windows ciblée réussit ; la disponibilité hors ligne de toutes les plateformes n’est pas revendiquée. Aucun téléchargement n’est effectué pour masquer ce manque de cache, qui reste distinct d’un asset LoL absent.

## Sources natives et observations

Les 122 SKL correspondent chacun, par chemin, taille et MD5, à un membre unique des manifestes de projets sélectionnés par la solution EUW fournie. Les basenames Skeleton des configurations sélectionnées correspondent aux entrées d’export. Cela complète les sources config/SKN du lot V526 ; la priorité complète des packages, du cache et des overlays historiques reste non qualifiée. Le lecteur de manifestes conserve son backing E historique ; les copies F des deux manifestes sont vérifiées identiques, sans correction implicite de portabilité.

Le corpus contient **67 SKL modern0 et 55 legacy2**. Les preuves de découverte précédemment exécutées sont conservées et leurs entrées recontrôlées par SHA : **9 254 joints natifs, 9 253 joints GLB**, **1 066 922 influences à poids positif** et **597 877 sommets**. Les positions de bind, les influences et les poses animées restent des catégories distinctes.

Les comparaisons de bind portent sur **9 253 identités comparables**, en utilisant le chemin hiérarchique complet des parents. Leurs matrices locales et inverses de bind restent dans le seuil documentaire de 1e-3 avec le calcul indépendant float64. Le joint manquant reste non comparable. Ce seuil ne qualifie ni la décomposition float32 du client original ni les poses animées.

Les 151 sous-maillages courants emploient des indices de joints U8x4 et des poids F32x4 non normalisés au sens du format d’accessor. Les poids scalaires natifs et GLB conservent les mêmes bits dans la découverte. Le lecteur courant inspecté convertit les indices en format de travail et transmet ce cas F32 ; le shader lit quatre poids et matrices. Ce chemin de code est inspecté, sans nouvelle exécution Bevy ou shader.

Le contrôle complémentaire de ce lot ne trouve aucun indice de joint hors intervalle, y compris dans les voies de poids nul, ni poids négatif. Aucune somme de poids ne diffère de 1 de plus de 1e-3 ; le maximum observé en addition float64 est 1.5493424143642187e-7. Ces mesures ne démontrent pas que les identités de destination sont toutes correctes.

## Anomalie conservée et question précise

**Veigar : 50 joints natifs contre 49 dans le GLB choisi.** Le joint natif 34, au chemin root/pevis/R_thigh/R_calf/R_foot/toe, n’a pas de contrepartie de même identité. **33 influences positives** sont dirigées vers l’autre branche toe malgré des poids scalaires identiques. Aucun modèle n’est réparé ou accepté au titre de ce lot de traçabilité.

La question **OLU-29dbb803-7d62-54e9-a39e-acfedede9e66** est ajoutée et laissée ouverte chez **CH-Veigar-MODELE-RIG**. Elle conserve les identités du SKL et du GLB et demande de qualifier ou restaurer cette identité et les 33 destinations, puis de vérifier hiérarchie, bind et poses. Elle n’est pas attribuée à une autre exigence.

Les questions existantes de SYS-14.2-01 et SYS-14.2-02 restent chez leurs propriétaires, avec leurs textes, recherches et historiques inchangés. Elles sont référencées comme contexte lié, pas réassignées aux champions. Les **31 436 anciennes inconnues** sont conservées exactement comme objets ; une seule question est ajoutée. Aucune inconnue n’est fermée.

Les trois joints homonymes R_PARENTING_HAND_LOC d’Ezreal ont des chemins distincts et restent séparés dans le GLB corrigé effectivement sélectionné. Les résultats du helper ancien qui apparie par nom seul restent conservés séparément. Ses ambiguïtés Ezreal et sa comparaison du toe Veigar entre branches ne deviennent pas des joints manquants supplémentaires ou une mesure qualifiée d’erreur de matrice.

## Contrôles et intégration aux lecteurs du plan

Un premier essai du collecteur est conservé : l’ancre du shader était indiquée ligne 27 au lieu de la ligne observée 26. Le numéro est corrigé dans un nouveau collecteur, sans modifier la source du shader, un registre réel, une base ou un asset durant cet essai. Le collecteur final et ses entrées sont identifiés dans les reçus.

Cinq refus réels utilisent des copies mémoire : SKL tronqué, version legacy non prise en charge, identifiant de joint moderne dupliqué, cycle de joints natifs et cycle/hierarchie invalide du GLB courant. Aucune source n’est altérée.

Le candidat refuse **28 associations falsifiées** sur les cas Aatrox, Ezreal et Veigar : mauvais propriétaire, lecteur retiré, binding natif inventé, fausse exécution client ou acceptation GPU, poids promus en preuve d’identité, appariement par nom promu, fausse couverture complète. Les cas ciblés refusent le mauvais GLB Ezreal, l’effacement des 33 écarts, la disparition de la question Veigar et la réattribution d’une question SYS. **Quatre refus du lecteur public** couvrent source absente, consommateur absent, fausse acceptation et inconnue appartenant à une autre exigence.

La traçabilité de toutes les 42 215 tâches est comparée : **122 fragments changent, 42 093 restent exacts**. Les **42 092 autres objets tâche/trace** sont préservés. Les identités et la hiérarchie restent exactes en octets ; tous les statuts, critères et indicateurs d’acceptation des tâches restent conservés. Seul le statut de traçabilité de la fiche Veigar passe à partiel avec question ouverte. Aucune case n’est cochée.

Les contrôles sur une copie privée puis les deux bases réelles emploient Store.task, copy_text, summary, dépendances et rt.resolve. Par base : **123 destinataires vérifiés**, **42 484 autres lignes catalogue**, **42 607 états/notes** et **23 historiques** exacts. La question Veigar est visible chez son propriétaire et les deux questions SYS sont retrouvées chez les leurs. Intégrité SQLite OK ; synchronisations normales suivantes idempotentes.

Préparation, contrôle, publication et audit finissent au code 0. Les transactions restent séquentielles ; aucune atomicité globale des fichiers et des deux bases n’est revendiquée. Les chemins de consommateurs externes sont ceux du cache courant et nécessiteront une requalification si la dépendance ou son emplacement change.

**Aucun nouveau build Rust, aucune nouvelle exécution du client original, de son lecteur de rig, du jeu courant, du GPU, du réseau ou de l’audio.** Les données de bind et les lecteurs de skinning sont identifiés ; toutes les poses, déformations, animations, formes, skins, limites dynamiques et la fidélité visuelle restent à qualifier. La simple présence d’un GLB ou l’égalité de poids ne clôture aucune fiche.

## Réexamen et investigation suivante

Le réexamen en lecture seule **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision528_trace_review\REVIEW.json** vérifie 42 215 exigences et **2 669 ancres avec leurs octets sur 514 fichiers actuels**, sans divergence. Les 17 auxiliaires intentionnels sont conservés. **9 110 fiches CH** ont encore le chargeur partagé comme seul lien applicable : file de qualification, sans absence d’implémentation démontrée. Le réexamen ne rehache pas l’ensemble des 98 771 sources.

La découverte UV suivante a aussi été exécutée : **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision528_uv_discovery\DISCOVERY.json**. Les UV0 de 597 877 sommets, répartis sur 151 sous-maillages des 122 modèles, correspondent en bits f32 aux sources SKN inspectées. **168 sommets ont des UV hors carré unité** ; ils restent inchangés et ne sont pas déclarés corrompus sur cette seule mesure. Les sélecteurs de coordonnées texture observés indiquent UV0. Les extensions, lecteurs effectifs, transformations de texture, samplers, shaders et pixels restent à qualifier. Ces preuves ne sont pas encore liées aux 122 tâches MODELE-UV.

## Livrables et état

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json, docs/fidelity_unknowns_4_20.json et les deux bases du plan. Couverture, plan de complétion, checkpoint, CURRENT.md et HANDOFF.md reçoivent ce contexte après sauvegarde des versions précédentes.

Ajoutés : docs/reference_requirement_trace_sources/champion-rig-source-links-v527.json ; docs/fidelity_champion_rig_source_links_v527.json ; présent rapport. Six identités de sources sont ajoutées : quatre fichiers de dépendance existants et deux documents de preuves. Aucun code produit, lecteur maintenu, asset, pack ou manifeste n’est modifié.

Graphe final : **42 215 exigences, 98 771 sources, 2 669 consommateurs, 25 920 questions ouvertes et 5 517 résolues** avec historique. Les écarts numériques V512–V525, limites V526, 46 arrivées manquées V523 et leurs 92 questions, V522 Gnar et les états manuels restent conservés. Aucun champion ou jeu complet n’est déclaré terminé.

Travail : revision527_rig_inspection_retry, revision527_rig et revision528_uv_discovery sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20. Les découvertes et essais antérieurs sont conservés. Ne pas republier ce lot.

Poursuivre SYS-01.2-02 depuis F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision528_trace_review/REVIEW.json : 9 110 fiches CH ont encore le chargeur partagé comme seul lien applicable ; file de qualification, sans absence d’implémentation démontrée. Traiter ensuite les 122 CH-*-MODELE-UV à partir de revision528_uv_discovery/DISCOVERY.json déjà exécuté : 597877 sommets /151 sous-maillages, UV0 f32 exacts,168 sommets hors carré unité à préserver sans clamp. Rechercher les vrais convertisseurs TEXCOORD, attributs vertex, sélections de jeux UV, transforms et samplers/shaders réels, y compris extensions de matériaux ; ne pas accepter les textures ou le rendu par la seule égalité des UV. Préserver V527 et sa question Veigar OLU-29dbb803-7d62-54e9-a39e-acfedede9e66 : native34 toe droit absent /33 influences ; conserver les deux questions SYS propriétaires, les différences de portée entre données bind float64, lecteur natif, dépendance déclarée et GPU. Les huit nouveaux consommateurs pointent aux vrais fichiers du cache Cargo, vérifiés contre les archives verrouillées ; cela ne prouve pas le binaire actuellement exécuté. Garder les 17 auxiliaires, écarts numériques,46 arrivées manquées V523 et92 questions, V522 Gnar et tous les états manuels. Publication V527 terminée : ne pas la répéter. Goal entier actif.
