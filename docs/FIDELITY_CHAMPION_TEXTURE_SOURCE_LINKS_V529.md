# SYS-01.2-02 — Sources et consommateurs des textures de base, V529

25 octobre 2026 — F:\OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; catalogue officiel 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MODELE-TEXTURES** sont reliées au champ Texture de la configuration native sélectionnée, au DDS exact, à son appartenance au manifeste natif, au PNG embarqué dans le GLB effectivement choisi et aux lecteurs actuels. **1 709 liens** ajoutés, sept nouveaux consommateurs, quatre nouvelles identités physiques et deux documents de preuve. Aucun asset, pixel, modèle, shader ou code produit modifié. Les tâches restent a_faire : ce lot qualifie les correspondances demandées par SYS-01.2-02.

Le flux courant est suivi depuis la requête de modèle et son chargement glTF : image embarquée, décodage PNG par Image::from_buffer, rôle couleur sRGB, handle base_color_texture et descripteur Image initial. ActorFog clone le StandardMaterial importé et utilise environment_fow_vertex puis native_environment_fog, lequel appelle le prélèvement PBR de base. La source verrouillée de Bevy 0.19.0 est vérifiée contre Cargo.lock, ses archives et la résolution Windows offline déjà exécutée. Ce contrôle de sources n’est pas une nouvelle compilation ou exécution du jeu.

## Attendu et observé

| Vérification | Attendu dans le périmètre | Observé |
| --- | --- | --- |
| Configuration native sélectionnée | Texture correspond au fichier de l’inventaire | 122/122 basenames égaux, casse ignorée explicitement |
| Appartenance native | Une entrée correspondante dans les projets sélectionnés | 122/122 ; taille/MD5 et identités SHA consignés |
| Dimensions et stockage | DDS/PNG complets, plages bornées | 122/122 ; 151 associations matériau-image ; aucun dépassement |
| Formats DDS | Identifier FourCC ou flags/masques RGB | 112 DXT1, huit DXT5, un DXT3, Quinn BGR24 |
| Mip0 dans Pillow 12.3.0 | Comparer les deux images dans un décodeur déclaré | 120 RGBA exacts ; deux écarts alpha ci-dessous |
| Réexécution du convertisseur local | Comparer sa sortie au PNG courant, sans remplacement | Deux codes 0 ; PNG encodés et RGBA de KhaZix/Thresh reproduits exactement |
| Mips inférieurs | Identifier toute donnée native absente du PNG | 20 chaînes natives présentes, PNG et descripteur initial limités au mip0 |
| Registres et deux bases du plan | Préserver autres tâches/états/historique | Contrôles et audit réussis ; détail ci-dessous |

Les champs DDS de nombre de mips valent zéro dans 98 fichiers, dix dans 18, onze dans deux et un dans quatre. Dans les 98 fichiers au champ zéro, la taille exacte du payload contient **un niveau complet** : zéro n’est pas une absence d’image. Tous les niveaux retenus ont une plage et un hash propres, sans octet final non qualifié. Quinn est un DDS valide BGR24 d’après les flags et masques, sans FourCC : ce fichier n’est pas déclaré manquant ou corrompu.

## Limites restant ouvertes dans les fiches

**20 questions de conservation des mips**, une chez chaque propriétaire : alistar, azir, brand, cassiopeia, drmundo, fiddlesticks, galio, gnar, graves, karma, lucian, missfortune, renekton, rengar, singed, sion, sivir, tristana, warwick, xinzhao. Le code communautaire lit les niveaux DDS puis écrit explicitement Texture.Mips[0] en PNG. Les niveaux inférieurs natifs sont donc absents de cette représentation embarquée. Le chemin PNG verrouillé construit initialement Image avec mip_level_count=1. La politique historique de LOD/filtrage et l’état GPU final courant ne sont pas démontrés. Une éventuelle régénération ne démontre pas la préservation des niveaux natifs.

**Deux questions de décodeur alpha**, sans diagnostic de corruption :

| Champion | Pixels différents | Écart maximal RGBA |
| --- | ---: | --- |
| khazix | 287 | [0, 0, 0, 1] |
| thresh | 3969 | [0, 0, 0, 1] |

Pour ces deux cas, RGB est exact et seule l’alpha diffère d’un niveau entre la lecture DDS de Pillow et le PNG actuel. Le convertisseur communautaire local reproduit exactement le PNG actuel. Cela explique la provenance locale ; cela ne choisit pas le décodeur original de Riot ni une règle de normalisation. Aucun pixel n’a été corrigé sur cette seule comparaison.

Les 22 nouvelles questions sont rattachées exclusivement à leur propre exigence et apparaissent via le vrai lecteur du plan. Aucune ancienne inconnue résolue ou réattribuée. Les anciens objets d’inconnues restent exacts ; le fichier est augmenté de 22 objets.

## Sources et exécutions identifiées

Le reçu détaille les DDS et configs natifs, les PNG embarqués, les niveaux, les sources de conversion et chaque consommateur. Le lecteur d’appartenance utilise son historique E:\OpenLeague ; les deux contreparties de manifestes sur F: sont identiques en octets. Le catalogue historique n’a pas été réécrit pour masquer cette dépendance.

Les **deux seules nouvelles exécutions de conversion** utilisent E:\mapslol3v3\StructureExport\bin\Release\net8.0\StructureExport.exe, **SHA-256 a212248c8d66143ea4a1270a16ba140375afc8d4e9a72ef7bcc17657d20dd198**, avec les SKN, SKL et DDS natifs pinés et des sorties privées sous revision529_texture_export_probe. EXE, DLL, fichiers runtime, arguments, sources entrantes, logs, GLB et sorties PNG sont consignés. Aucune animation demandée pour ces deux essais de texture. Les sources C# de Texture.LoadDds, TextureExtensions.ToImage et Program.cs sont identifiées ; leur équivalence de compilation au binaire historique n’est pas inventée. Aucun original LoL, nouveau client OpenLeague, GPU, audio ou réseau exécuté.

La comparaison mip0 Pillow et la résolution Cargo Windows sont des preuves héritées dont les entrées sont revérifiées, pas des exécutions répétées. Aucun téléchargement ou modèle génératif requis pour ce travail de correspondance.

## Vérifications et préservation

Inspection, préparation, contrôle privé, publication et audit : **codes 0**. Six refus de l’analyseur borné : en-tête DDS tronqué, nombre de mips hors dimensions, FourCC inconnu, payload tronqué, dépassement de chunk PNG et CRC invalide. Ce sont les refus de l’outil d’audit, pas une affirmation de refus global par Bevy.

**29 refus propres** protègent propriétaire, lecteurs, données de mips, delta alpha, question propriétaire, format Quinn, override Ezreal et limites de portée/exécution. Quatre refus du lecteur public protègent les références absentes, l’acceptation inventée et l’inconnue étrangère. Les 122 fragments de trace changent ; **42 093 autres fragments sont exacts**. Les 42 092 autres objets tâche et trace sont identiques. IDs et hiérarchie sont exacts en octets ; les anciens enregistrements sources/consommateurs, y compris la correction ActorFog V528 et son historique, restent exacts.

Par base : **123 lignes destinataires**, **42 484 autres lignes catalogue exactes**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie, résolution, dépendances, résumé, questions propriétaires et intégrité OK ; synchronisation normale idempotente. Le questionnement Veigar RIG reste inchangé. Aucun statut, critère, case ou note utilisateur modifié.

Réexamen global frais : **42 215 exigences**, **98 783 sources**, **2 690 consommateurs**, **522 fichiers de consommateurs**, zéro divergence d’ancre ou d’octets. Les 17 auxiliaires voulus restent présents. Questions : **25 942 ouvertes**, **5 517 résolues**. Pour **8 866 fiches CH**, le chargeur partagé demeure le seul lien précis à qualifier. Ces files se recoupent et ne sont ni un pourcentage de jeu terminé ni une preuve d’absence d’assets. Aucun nouveau hash physique global des 98 783 sources n’est revendiqué.

## Livrables

- Registres : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, fidelity_unknowns_4_20.json et completion_tasks_2026-10-20.json.
- Reçu : docs/reference_requirement_trace_sources/champion-texture-source-links-v529.json.
- Vérification intégrée : docs/fidelity_champion_texture_source_links_v529.json.
- Inspection : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision529_texture_inspection/OBSERVATIONS.json.
- Préparation, sauvegardes des registres/bases, candidats et contrôles : revision529_texture ; commandes revision529_texture_COMMAND_*.json/.log.
- Reconversions locales : revision529_texture_export_probe/PROVENANCE.json ; réexamen : revision530_trace_review/REVIEW.json.
- Couverture et reprise : docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md ; les champs antérieurs sont conservés.

## Ce qui n’est pas établi

La priorité complète des caches et overlays historiques, les autres skins/formes, les paramètres de matériau, les textures supplémentaires éventuelles, les règles originales de sRGB/alpha/prémultiplication, la conservation GPU des mipmaps et la comparaison visuelle en match restent à qualifier. Les limites antérieures sur rig, animations, gameplay et serveur restent ouvertes. Ni ce lot ni la présence d’un PNG ne termine un champion ou le jeu.

## Suite du Goal

La découverte suivante des matériaux a été exécutée en lecture seule : 122 champions, 151 matériaux ; getters SelfIllumination natifs hérités et configurations sélectionnées pinés, paramètres glTF et choix du convertisseur recensés. Un premier essai a refusé à tort de distinguer la projection Python d’un scalaire quantifié du getter natif. Le script et le log échoués restent conservés. La reprise sépare les types et bits : LeeSin garde son écart d’un ULP, Velkoz et Zac leurs chaînes littérales. Les paramètres actuels unlit/double-sided/alpha ne démontrent pas une politique Riot. La recherche littérale SelfIllumination ne peut exclure un lecteur indirect. Aucun lien MODELE-MATERIAUX n’est publié par cette découverte. Résultat : revision530_material_discovery_retry/DISCOVERY.json.

Poursuivre SYS-01.2-02 depuis revision530_trace_review/REVIEW.json : 8 866 fiches CH ont encore le chargeur partagé seul, file de qualification sans absence d’implémentation démontrée. Examiner les122 CH-*-MODELE-MATERIAUX depuis revision530_material_discovery_retry/DISCOVERY.json :151matériaux, getters natifs SelfIllumination hérités et paramètres glTF/convertisseur inventoriés ; leur correspondance native n’est pas acceptée et aucun lien matériaux n’est publié. Vérifier vrais consommateurs, paramètres/variantes StandardMaterial vers FogMaterial, alpha/unlit/lumière/ombres et shaders normaux ; ne pas prendre les paramètres glTF/Bevy pour la politique Riot. Une recherche littérale négative ne prouve pas l’absence de lecteur indirect. Conserver les22 questions texture V529 :20 chaînes mip natives absentes du PNG/descriptor initial et2 écarts alpha Pillow/convertisseur ; ne pas réparer les assets dans cette tâche de correspondance. Préserver ActorFog V528 et historique de requalification du vertex standard, Veigar joint34/33influences,168UV hors unité,46 arrivées V523/92questions et17auxiliaires. V529 publié et audité : ne pas republier. Goal entier actif.
