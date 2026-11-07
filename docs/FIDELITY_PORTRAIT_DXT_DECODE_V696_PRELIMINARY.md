# SYS-01.2-02 — Décodage DXT, V696 préliminaire

UTC :2026-10-27T22:13:55.859880+00:00. Projet F:/OpenLeague. Source historique PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Cette preuve est exécutée et revue ;**ses associations au registre canonique et aux deux fiches/bases restent à intégrer**. Le dernier audit canonique publié est V695 :99 711sources/5613consommateurs,42 215exigences actives,26 189inconnues ouvertes.

## Résultat observé et critère

Les sept sorties compressées du bancAPI localV693 sont décodées :4DXT1/BC1 et3DXT5/BC3. Chaque source308×560 et destination512×1024 est traitée par Pillow12.3.0 puis un décodeurPython indépendant. Critère établi avant exécution :différenceRGB≤1niveau entre décodeurs,alpha strictement identique. **Observé :accord strict octet par octet pour les14images et4 877 376pixels par décodeur**,tous canaux compris. La revue vérifie les octets,tailles,SHA-256,associations source et maxima ;elle ne rejoue pas les décodeurs.

Cinq blocs synthétiques attendus exercentBC1quatre couleurs,transparence,précisionRGB565,BC3deuxbranchesalpha et ordre inversé des couleurs. Ils passent. Cinq entrées invalides sont refusées :bloc tronqué,dimensions hors contratmultiple4,format nonpris en charge,magicDDS erroné et fourCC incohérent. Cinq falsifications de preuve sont refusées :empreinte décodée changée,format modifié,qualitécompression prétendument acceptée,alpha historique prétendument qualifié et contrôle synthétique supprimé.

## Écarts de compression conservés

Les sorties décompressées sont également confrontées au modèle périodique de filtrage des sources décompressées. Ces résidus ne sont pas un échec d'accord des décodeurs et **aucun seuil de qualité de compression n'est établi**. Les statistiques décrivent le résultatAPI local ;elles ne suffisent pas à conclure à une corruption ou à une fidélité du rendu.

| Portrait | FormatDWORD | Maxima RGBA,niveauxsur255 | Position du maximum,x,y |
|---|---:|---|---|
| Braum:0 | 894720068 | [51.697845458984375, 32.8203125, 36.934295654296875, 0.0] | 238,243 |
| Braum:1 | 827611204 | [47.8203125, 33.000152587890625, 32.302703857421875, 0.0] | 279,444 |
| Kalista:0 | 827611204 | [40.92364501953125, 28.25714111328125, 32.733978271484375, 0.0] | 376,383 |
| Kalista:1 | 894720068 | [83.0, 33.38433837890625, 56.4437255859375, 0.0] | 187,320 |
| Rengar:0 | 827611204 | [35.1796875, 28.828460693359375, 42.57421875, 0.0] | 335,315 |
| Zac:0 | 894720068 | [45.3046875, 24.15625, 35.73699951171875, 0.0] | 67,831 |
| Zac:1 | 827611204 | [50.4718017578125, 24.997772216796875, 48.284912109375, 0.0] | 407,540 |

Le maximum global atteint83surKalista1. Les maxima sont recomputés par la revue à partir des fichiersRGBA. Moyennes et percentile99RGB sont aussi conservés dans l'observation. Les sources et destinations réelles sont toutes opaques :alpha[255,255]. Les contrôles synthétiques vérifient le décodage d'alphas variables ;ils ne qualifient pas le filtrageAPI d'une vraie source àalpha variable ou le blending historique.

Le [contratMicrosoft des formats compressés](https://learn.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression) identifieDXT1/BC1 etDXT5/BC3,avec interpolation des couleurs et de l'alpha. Il décrit une compression avec perte. Cette source de format ne constitue pas une référence de renduLoL2014 ou une règle d'acceptation de qualité.

## Provenance, binaires et vérifications réellement exécutées

Les sources sont les DDS4.20identifiés dans V693. Leurs octets niveau0 àoffset128 restent égaux aux tamponsCPU natifs capturés enV692 ;les blocs des surfaces locales V693 sont inchangés. Les deux décodeurs consomment ces mêmes blocs. Un conteneurDDS est construit en mémoire avec le header natif adapté uniquement aux dimensions,taille linéaire,niveaumip1 et capsTEXTURE ;aucun fichierDDS natif n'est modifié. Les fichiersRGBA sont des diagnostics, pas des assets de production.

Le pluginPillowDDS,son extension native64bits,NumPy,son extension et les scripts sont identifiés par version/taille/SHA-256. Le décodeur indépendant développeRGB565 et les tables d'indices avec entiers ;le contrat de précision est explicite. Aucune installation,téléchargement de logiciel,exécutionAPI/GPU ou lancement du jeu n'est requis par ces calculs. Les preuvesAPI V693 et natives V692 sont héritées.

Commandes réelles :V696_DXT_DECODE etV696_DXT_REVIEW,code attendu/reçu0. Scripts :revision696_dxt_decode_controlled.py etrevision696_dxt_decoder_review.py. Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision696_dxt_decode_compare\OBSERVATIONS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision696_dxt_decoder_review\REVIEW.json. Les reçus et journaux sont dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision669_V696_*. Les empreintes,commandes et limites détaillées sont dansdocs/fidelity_portrait_dxt_decode_v696_preliminary.json.

## État de livraison et limites

Ce rapport,la preuveJSON préliminaire,les scripts et diagnostics sont ajoutés. coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT/HANDOFF sont actualisés avec sauvegarde et conservation des champs. Le registre canonique,les tâches,les inconnues et les bases ne sont pas modifiés par ce checkpoint. Aucune case cochée et aucun nouveau consommateur de fonctionnalité déclaré.

L'accord des décodeurs ne qualifie pas l'arrondi du décodeurD3DXhistorique,l'encodage de compression attendu,le transport actuel,les UV,couleur/sampler,le contextebackend/catégorieflash/mode,le caller normal ou le nettoyage nominal natif. Les DLLs2014,la frame finale et la résidenceVRAM restent non qualifiées. Les acquisV695/V694/V693 et antérieurs,Kalista288octets et12noms ouverts sont conservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 surF. V695 a publié/audité les5ARGB8modèlewrap(max0.5),deuxfiches/deuxbases,99711sources/5613consommateurs,données manuelles inchangées. V696 a maintenant décodé les7sortiesDXT existantes :4DXT1/BC1,3DXT5/BC3. Pillow12.3.0 et décodeurPythonindépendant donnent des pixels strictement identiques sur les14images source/destination,4877376pixels par décodeur ;5blocs attendus,5entrées invalides refusées,5falsifications refusées,revue desoctets/maxima réussie. Tous les vrais alphas sont255 ;seuls les contrôles synthétiques couvrent alpha variable,aucune qualificationalphaAPI/blendinghistorique. Résidus vsfiltrageidéal mesurés,jusqu’à83niveaux(Kalista1),sansseuil ou acceptationdequalitécompression. Cette preuve V696 est documentée mais pas encore reliée au registre canonique/deuxfiches/bases :construire le lecteur d’associations en gardant8descripteurs et historisant la même question ouverte,puis publier/auditer. Conserver diagnosticsRGBA,source/headerPillow/binaire,modèle et reçus ;aucunDDS/assetmodifié,aucunAPI/GPU rejoué. Ensuite qualifier la cause/portée des résidus et comparer au transport actuel ;suivreUV/couleur/sampler et retour9B8738/nettoyage natif,mode1225C58/callers9B7590,backend/catégorieflash et caller normal/provider/cache/UI. IdentitéDLL2014,Kalista288octets,12noms antérieurs et historiques restent ouverts. Avantnouveauprepare vérifier réserve4GiBF ;compresser seulement sauvegardes/proofs fermés si nécessaire,sans suppression. Réutiliser garde F stricte avecpréfixe approprié,aucunhelperC implicite. Goal actif,aucunécran/jeucomplet accepté.
