# SYS-01.2-02 — Animations de passif : sources et consommateurs, V667

Date UTC : 2026-10-27T08:25:43.953974+00:00. Référence PUBLIC4.20.0.315 EUW/en_GB ;build littéral du2014-11-17 à17:46:45, fuseau et date de déploiement non établis ;catalogue4.20.1 distinct.

## Résultat intégré

V667 :122 fiches d’animation de passif reliées à605 sources natives par735liens et10frontières communes par1220liens. Audit de122modèles/4267clips,121graphes,4450appartenances natives conformes ;29contrôles dont22refus. 35clips nommés passive,34sans rôle courant ;écart Crit Lucian et ambiguïté Renekton conservés. Pas de lecture Bevy/GPU ni de passif complet accepté.

Les122fiches d’animation de passif et SYS-01.2-02 possèdent désormais leurs liens qualifiés et leurs instructions complètes dans le registre et les deux bases du plan. Les cases, notes, historiques, statuts, critères,122dépendances et122questions propres restent conservés. Les605sources étaient déjà recensées ;cette livraison précise735associations. Les dix points du code sont des frontières communes du chargement et de la sélection d’animation, sans acceptation complète du passif.

## Constat exact sur les ressources

Les122GLB effectivement sélectionnés, dont le modèle Ezreal joint_identity, totalisent4267clips. Leurs noms concordent avec le catalogue ;les indices de rôles sont valides. 35clips chez16champions contiennent littéralement « passive ». 34ne sont affectés à aucun rôle du catalogue ;Lucian_Passive_Crit est affecté au rôle crit. Cette recherche par nom ne constitue ni un inventaire exhaustif des animations nécessaires, ni la preuve que tous ces clips doivent être joués.

121graphes natifs de base sont analysés par le lecteur BLNDv1 borné ;les arêtes directes de type1 sont distinguées des autres payloads opaques. Les4450ressources natives identifiées correspondent aux tailles/MD5 des manifestes sélectionnés. L’audit rehache4592fichiers ;il ne rehache pas l’intégralité du registre de sources.

La première passe lit1256INIBIN présents dans les fiches SOURCE, qui contiennent aussi d’autres sorts. Le filtre propre aux sources de passif précédemment qualifiées retient60fichiers :49champs AnimationName absents,11nommés. Les1196autres fichiers sont exclus du comptage spécifique. Ni absence ni valeur nommée ne suffisent à prouver la politique effective de présentation.

## Écarts et limites gardés ouverts

- **Aatrox et Karthus** : des arêtes natives directes référencent des ANM corrélés à des clips importés non affectés à un rôle courant. Le déclencheur et le lecteur de ces états restent à qualifier.
- **Lucian** : le rôle crit courant sélectionne le clip28 Lucian_Passive_Crit. Le graphe natif distingue Crit→lucian_crit1.anm (corrélation au clip7) et Passive_Crit_BASE→lucian_passive_crit.anm. Cet écart de références est documenté ;aucun remappage automatique ni qualification du sélecteur natif.
- **Nautilus** : l’alias natif passive référence nautilus_attack1.anm, déjà corrélé au rôle attack. La réutilisation du clip ne prouve pas le déclencheur de son passif.
- **Zac** : Death_Passive référence le clip de mort ordinaire ;Death_passive2 référence zac_death_unite.anm, corrélé au clip14 sans rôle. Une mort ordinaire ne qualifie pas Cell Division.
- **Renekton** : les configurations de base restent ambiguës ;aucun choix arbitraire de graphe.
- **Tous les champions** : priorité des providers, formes/skins et acteurs secondaires, callbacks natifs, événements, poses converties, durées, interruptions, audiences et présentation normale restent à qualifier selon chaque fiche. Le HUD Ezreal est explicitement exclu des consommateurs d’animation squelettique.

Le premier audit a été refusé avant lecture des modèles :le catalogue historique conserve le chemin E des manifestes, tandis que le lecteur était invoqué sur F. Le journal exit1 reste conservé. La versionhistorical_manifest utilise la provenance historique et vérifie l’identité exacte des copies sur F ;aucune garde du lecteur n’est retirée. Cela ne démontre pas une corruption des ressources.

## Contrôles réellement exécutés

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| SOURCE AUDIT | 0 | 03a63922f842f13e1b48b0b980ff2c2dc021d86deb1b0582bb56adf7f365d870 |
| prepare | 0 | 5dd10107f5130dde97784d86c29372c300ffb751698696c79529a98d53ab021b |
| check | 0 | 4d41dd2411deeb05bd0332dee5a828ffb3991e5832f7a8829f65168d733042c5 |
| publish | 0 | 2f1e4df357c3dffcd19bae285bd2263c1e985a6a15a27e5dd97b54121489e2b4 |
| audit | 0 | 61043d041ec4d06a5f5a2a040cb9dc3b7f58d5893a2e59e48fce319b44911611 |

29contrôles des vrais lecteurs, dont22refus :champs absents/vides/nommés, types invalides, chemins hors périmètre, données BLND tronquées/indices invalides, chaîne passive non référencée ignorée, payload type4 maintenu opaque, changement d’indice réellement suivi, GLB tronqué et longueur fausse refusés. Mutations en mémoire ou dans un dossier temporaire ;aucune source altérée.

Le candidat refuse2440associations falsifiées et4graphes invalides. 122fragments de trace changent,42093restent identiques. Dans chaque base :123lignes ciblées vérifiées,42484autres lignes de catalogue,42607états manuels et23historiques conservés. Store.task,copy_text,dépendances,rt.resolve,intégritéSQLite et synchronisation normale idempotente vérifiés. IDs,hiérarchie et registre des inconnues identiques en octets. Aucune question fermée.

La revue globale vérifie5590ancres et empreintes de consommateurs actuels, aucun écart ;graphe99343sources,42215exigences actives,26189questions ouvertes et5517résolues avec historique. Ce lot n’exécute ni le serveur natif, ni Bevy, ni le client graphique ou le GPU ;aucun nouveau binaire du jeu n’est compilé. Les programmes Python et lecteurs réellement exécutés sont identifiés dans les reçus.

## Fichiers et préservation

Modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json ;les123lignes des deux bases ;couverture,plan,reprise et notes courtes. Ajoutés :présent rapport,reçu et vérification V667. Aucun code de jeu, catalogue d’animation ou asset modifié.

Le projet et les preuves restent sur F ;copies SQLite de validation temporaires sur C, archives restaurables sur F avec SHA décompressé vérifié. Pour éviter la saturation de F,420copies d’archivesbaseline privées terminées ont été regroupées en8groupes de liens physiques, conservant chaque chemin et ses octets ;826440644octets logiques libérés. Les identifiants de fichier/horodatages peuvent suivre l’exemplaire canonique ;les anciennes valeurs sont conservées dans CHANGES.jsonl. Ces archives restent immuables, toute édition future doit passer par une nouvelle copie. Bases actives, assets et sources enregistrées exclus de cette opération.

Reçu :F:\OpenLeague\docs\reference_requirement_trace_sources\passive-animation-links-v667.json. Vérification :F:\OpenLeague\docs\fidelity_passive_animation_links_v667.json. Audit source :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision667_passive_animation_audit_historical_manifest\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision667_passive_animation_inspection/OBSERVATIONS.json. Instructions :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision667_passive_animation_inspection/TASK_INSTRUCTIONS.json. Audit de livraison :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision667_passive_animation_delivery/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision668_trace_review\REVIEW.json. Déduplication :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision667_baseline_deduplication/VERIFIED.json.

## Suite

Continuer SYS-01.2-02 : V667 publié/audité pour122PASSIF-PRESENTATION-ANIMATION plusSYS dans les deux bases.735liens vers605sources natives,1220liens vers10frontières communes ;123cibles parbase,42484autres lignes,42607états manuels et23historiques conservés. Revue668 :99343sources/5590consommateurs,5590ancres exactes,aucun problème. L’audit statique vérifie122GLB/4267clips,121graphes et4450appartenances natives ;29contrôles de lecteur dont22refus,aucun Bevy/GPU.35clips contenant passive pour16champions,34nonaffectés à un rôle ;Lucian_Passive_Crit sert au crit courant mais l’alias natif Crit pointe verslucian_crit1.anm (clip7 contre28). Ne pas remapper automatiquement. Nautilus etZac partagent un clip avec attaque/mort ordinaires ;cela ne prouve pas leurs déclencheurs de passif. Renekton reste ambigu. 1256INIBIN de la large SOURCE ont été examinés ;le filtre spécifique garde60sources (49AnimationNameabsents,11nommés),1196autres sorts exclus. Ne pas présenter le total774noms de la passe large comme des animations de passif. Premieraudit1refusé car le backing historique nommeE ;versionhistorical_manifest0vérifieE/Fidentiques sans modifier le lecteur. Poursuivre les122PASSIF-PRESENTATION-VFX dans revision667_passive_animation_delivery/NEXT_PASSIVE_VFX_QUEUE.json :inspecter les champs/graphes/particules réellement disponibles,les sélecteurs et producteurs courants,les textures/attaches/audiences et preuvesGPU déjà acquises ;séparer variantes/skinnatives et ressources génériques. Préserver inconnues,critères et prérequis,aucune caseauto. Frestepeulibre :sauvegardesSQLite temporaires surC,archivesexactes surF. V667a regroupé420archivesbaselineidentiques par liensphysiques,826440644octetslogiques ;touschemins/SHAconservés. Cesarchivesrestentimmuables :copierversunnouveaufichier avanttouteédition. Ne pas supprimer preuves/basesactives. Goalactif.
