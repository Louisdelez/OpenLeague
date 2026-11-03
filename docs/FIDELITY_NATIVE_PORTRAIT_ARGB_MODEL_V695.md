# SYS-01.2-02 — Cinq portraits ARGB8 : associations canoniques V695

UTC :2026-10-27T22:09:47.981720+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Cette étape relie les preuves mathématiques V694 aux sources natives et consommateurs actuels. Elle ne termine pas l'écran de chargement,un champion ou le jeu.

## Résultat, attendu et observé

Les cinqDDSARGB8 sont reliés à leur tamponCPU natif V692,leur copieAPI locale réelle V693 et la comparaison numérique V694. **2 621 440pixels/10 485 760canaux comparés ; écart maximal0.5niveau par canal au modèle bilinéaire à bouclage.** Le seuil explicite est1niveau sur255 ; aucune tolérance n'est élargie. La revue scalaire indépendante contrôle17 900pixels,comprenant tous les bords et une grille intérieure. Les cinq sources et sorties sont revérifiées par taille/SHA-256 et niveau0CPU exact. Aucun API/GPU ou calcul complet antérieur n'est rejoué par ce lecteur d'associations.

| Portrait | Pixels comparés | Max,calcul complet | Max,revue scalaire | SHA-256 sortieAPI héritée |
|---|---:|---:|---:|---|
| Ahri:0 | 524288 | 0.5 | 0.499908447265625 | 91b87b252bbcaf3b89f7bf30ea17f42e8652f1869a297451f4ca385ef4c0af88 |
| Ahri:1 | 524288 | 0.5 | 0.499908447265625 | 07690eb534a36ed83139d9640f7f7c8cbc4ca055d517ab817e308f42b0586e39 |
| Lulu:0 | 524288 | 0.5 | 0.499603271484375 | 1d72881c94fa474c221d803f1b3abe464c4db166ef1145d374635f1ca2a4664e |
| Lulu:1 | 524288 | 0.5 | 0.5 | 85d19baac2b1fc4196f563013c28e91c8fb5c4636605e66f74164a1579bfffb2 |
| Rengar:1 | 524288 | 0.5 | 0.5 | 902df55b8304c10a45bba4f209d8123d5ebddd90b4e440c23f1d76d568766617 |

La comparaison exhaustive et la revue échantillonnée n'atteignent pas nécessairement le même maximum. Le premier lecteur V695 exigeait à tort0.5exact dans chaque échantillon et s'arrête/code1 avant toute publication. Un fichier distinct vérifie correctement0≤erreur≤0.5 ; les valeurs exactes ci-dessus sont conservées. Ce changement corrige une assertion d'intégration, pas le seuil numérique du modèle complet.

Le modèleclamp initial V694 reste réfuté/code2,max5.67578125. Le modèlewrap et la revue scalaire réussissent/code0. Les preuves sont conservées sans modification des DDS. Le [contratMicrosoft de filtre](https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dx-filter) et le header Microsoft identifié distinguent bouclage et optionsMIRROR ;le filtre3observé n'a pas ces options. Cette interprétation est confrontée au résultatAPI local, sans qualifier un processus2014.

## Liens réels et couverture

Deux fiches sont modifiées :SYS-17.3-01 et SYS-01.2-02. Elles reçoivent6liens natifs (EXE et5DDS) et29sources nouvelles. Les huit descripteurs actuels sont revérifiés sur leur source/ligne et restent inchangés. Aucun nouveau consommateur de fonctionnalité ou code/asset de production n'est ajouté. Les prérequis,phases,lots,identités et critères restent conservés.

La questionOLU-ac85c18c-d131-517e-83a7-d0987d643c48 reçoit son ancien texte et sa condition dans question_history,puis précise les cinq résultatsARGB8 et les septDXT encore ouverts. Son statut resteopen ;propriétaire,identité,aspects et autres inconnues sont préservés. Le graphe compte99711sources,5613consommateurs,42 215exigences actives,26 189inconnues ouvertes et5517résolues antérieures. Le compteur de graphe n'est pas un rehachage du catalogue complet ;les pins de cette livraison sont vérifiés séparément.

## Refus et vérifications

Cinq falsifications de preuve sont refusées :coordonnéesclamp substituées,critère de tolérance élargi,prétendue comparaisonDXT,empreinte de sortie altérée et prétendue exécution du caller normal. Cinq mutations du candidat de registre sont refusées. Inversion documentaire byte-exacte,inversion logiqueSQLite et idempotence de synchronisation sont vérifiées. Les deux bases effectivement publiées et auditées conservent42 605autres lignes,42 607états manuels et23historiques. Aucune case n'est cochée automatiquement.

Un premier générateur local s'arrête sur une transformation de boucle trop large,avant la création du programme candidat ;le lancement dépendant constate ensuite ce fichier absent/code2. Le générateur distinct est vérifié par AST avant copie/exécution ;la préparation corrigée réussit. Le reçu de fichier absent et les sources précédentes restent conservés. Aucune donnée canonique ou base active n'est modifiée par ces arrêts.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V694_ARGB_LINEAR_COMPARISON | 0 | 2 | 12300f0c45c9e9344d0988a01ba9841ae8f765a0cca697d889ca5bd0cd79ded8 |
| V694_ARGB_WRAP_COMPARISON | 0 | 0 | 54c4e80959aac22e34ea4d70ccc6f86c5439ae8d91146d6f0d40199bd777b47c |
| V694_WRAP_SCALAR_REVIEW | 0 | 0 | 4e6807612c50d3656a3b853cd47ea606838f01ea0000472841534b406eb3abbe |
| V695_ASSOCIATIONS | 0 | 1 | c29d2c71fcafb0232d1dc59ce23edcb9b30a169f73de690a3bf371382f6bbe6b |
| V695_ASSOCIATIONS_CHECKED | 0 | 0 | 1c60a4fffef6179ace5f457e72aa6b5d2431a91073ab1b24682cced9b07b25f1 |
| V695_STORAGE | 0 | 0 | b14a6cd368867a4e7a73bf5cbea98443f570c906f6aaf46359f5d153de89e6e0 |
| V695_PREPARE | 0 | 2 | 3dc19e7de10a68d305c25a993ce0936a7a345a02194fdc083fd13a5836d8ad1c |
| V695_PREPARE_CHECKED | 0 | 0 | 7e9f1739263aea9a55b4a3150ceeccd75e3b0adf0cc1a5bdfd78353a9125427c |
| V695_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V695_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V695_DELIVERY_AUDIT | 0 | 0 | d26c31090c522a0b871763ecefab9e75dca90fc5866dc1ef29c86a9cdcf8c1b2 |

Trois sauvegardesSQLite fermées de V693 sont compressées sans perte :859021312octets de stockage rapporté récupérés. Accès exclusif,WAL vide ou absent,SHA-256,tailles logiques et sidecars sont contrôlés. Aucun fichier supprimé et aucune base active compressée. Le nouveau scratch reste surF avec garde stricte du chemin et réserve4GiB.

## Fichiers et limites

Registres modifiés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,fidelity_unknowns_4_20.json. Reçu :docs/reference_requirement_trace_sources/native-portrait-argb-model-v695.json. Preuve :docs/fidelity_native_portrait_argb_model_v695.json. Deux bases du plan actualisées. Rapport présent,couverture,completion_plan,resume_checkpoint,CURRENT/HANDOFF actualisés avec sauvegardes et conservation des champs antérieurs. IDS et ordre des phases/lots restent byte-identiques. La preuve V694 préliminaire est conservée avec son état daté ;cette livraison est son intégration canonique ultérieure.

Observations de liens :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision695_argb_model_checked\OBSERVATIONS.json. Comparaison complète :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision694_argb_linear_wrap_comparison\OBSERVATIONS.json. Revue scalaire :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision694_wrap_scalar_review\REVIEW.json. Les scripts,reçus,journaux et sorties restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Les sept sortiesDXT restent à décoder et comparer. Le résultatARGB8 concerne un modèle mathématique des sorties locales, pas le rendu du consommateur actuel ou une capture historique. Restent ouverts :espace de couleur/sRGB/alpha blending,UV/sampler,mode/backend/catégorieflash,caller normal/provider/cache/UI et nettoyage nominal natif. Les DLLs2014,frame rasterisée et résidenceVRAM ne sont pas qualifiées. Les acquis V693/V692/V691/V690/V689 restent hérités avec leurs limites ;Kalista288octets et12noms de ressources restent ouverts. Aucun build complet ou acceptation de jeu n'est revendiqué.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V695 a intégré/audité les preuvesV694 :5ARGB8,2621440pixels/10485760canaux,modèle périodique linéaire max0.5 ; revue scalaire17900pixels. Premier modèleclamp code2 conservé,même seuil1 ; lecteur initial trop strict sur maximumscalaire=0.5/code1 corrigé en borne<=0.5 dans fichier distinct ; premier générateur local arrêté avant création et reçu de programme absent/code2 conservés. Deux fiches/deux bases auditées,8consommateurs inchangés,questionOLU-ac85c18c-d131-517e-83a7-d0987d643c48 historisée et ouverte,aucune case promue. Les mentionspréliminairesV694 restent datées ;V695 est le successeur canonique. Suite :décoder indépendamment les7sortiesDXT1/DXT5 existantes (4BC1/3BC3) avec outils/sources/arrondis identifiés,comparer pixels et alpha au filtrage attendu sans inventer un seuil d’acceptation de compression. Pillow12.3.0 et son pluginDDS/binaire installés ont été inspectés ;contratMicrosoft block-compression lu,aucun décodageDXT exécuté à ce checkpoint. Ne pas relancerAPI/GPU sans raison. Comparer ensuite au transport actuel et suivreUV/couleur/sampler,retour9B8738/nettoyage nominal avec adaptations déclarées. Mode1225C58/callers9B7590,backend/catégorieflash historiques,identitéDLL2014,caller normal/provider/cache/UI restent ouverts ;Kalista288octets et12noms antérieurs conservés. Scratch privé surF avec garde stricte et réserve4GiB au volumeF ;sources/proofs immuables,cases/historiques préservés. Goal actif,aucun écran ou jeu complet accepté.
