# SYS-01.2-02 — Comparaison mathématique ARGB8, V694 préliminaire

UTC : 2026-10-27T21:50:15.919998+00:00. Projet F:/OpenLeague. Référence native PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Cette preuve est exécutée et revue ; **ses associations au registre canonique et aux deux fiches/bases restent à intégrer**. Le dernier audit canonique publié reste V693 :99 682sources,5613consommateurs,42 215exigences actives,26 189inconnues ouvertes. Aucune case n'est cochée.

## Attendu et observé

Le contrôle lit les cinq sortiesARGB8 de l'essai réel D3DX39 V693,source308×560,destination512×1024,quatre canauxBGRA. Il calcule tous les pixels avec des poids entiers exacts. Le seuil prévu reste1niveau de canal sur255 ; aucune tolérance n'est élargie pendant l'enquête.

Premier essai : modèle bilinéaire avec coordonnées centrées et clamp aux bords. Code nominal attendu0,reçu2 ; les cinq portraits dépassent le seuil,maximum5.67578125. Ce résultat est un refus du modèle de contrôle, sans conclusion de corruption des ressources. Le script,les observations et le reçu d'échec sont conservés.

Le [contratMicrosoft](https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dx-filter) décrit les optionsMIRROR comme un remplacement du bouclage aux bords. Le headerMicrosoft identifié et vérifié enV692 confirme les bits de ces options et la valeur3deLINEAR. Le filtre3capturé ne contient aucune optionMIRROR. On en déduit un modèle linéaire avec indices cycliques ; ce contrat est aussi confronté au résultat réel local, sans présumer l'identité d'un runtime2014.

Second essai distinct : mêmes coordonnées centrées,mêmes poids et même seuil,indices de voisinage modulo308/560. **2 621 440pixels et10 485 760canaux comparés ; différence maximale0.5niveau dans chacun des cinq portraits.** Code attendu/reçu0. Ce sont des valeurs entières arrondies proches d'un modèle mathématique, sans revendication de correspondance bit-à-bit à une image de jeu historique.

| Portrait | Écart maximal,ancien modèleclamp | Écart maximal,modèlewrap |
|---|---:|---:|
| Ahri:0 | 3.4140625 | 0.5 |
| Ahri:1 | 4.1171875 | 0.5 |
| Lulu:0 | 5.67578125 | 0.5 |
| Lulu:1 | 4.7265625 | 0.5 |
| Rengar:1 | 4.14453125 | 0.5 |

Une relecture indépendante en Python scalaire,sansNumPy et avec dénominateurs non réduits,vérifie17 900pixels : tous les bords et une grille intérieure de pas31. Elle retrouve une erreur maximale0.5 et des contre-exemples au modèleclamp sur les bords. Code attendu/reçu0. Les empreintes de NumPy,de son extension native,des scripts,DDS,tampons et sorties sont revérifiées. Aucun asset n'est modifié,aucun nouvel appelD3DX/GPU ou processus de jeu n'est exécuté par ces calculs.

## Sources et limites

Observations du premier modèle :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision694_argb_linear_comparison\OBSERVATIONS.json. Modèle corrigé :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision694_argb_linear_wrap_comparison\OBSERVATIONS.json. Revue indépendante :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision694_wrap_scalar_review\REVIEW.json. Preuve documentaire :docs/fidelity_portrait_argb_model_v694_preliminary.json. Les données proviennent des douze copiesAPI locales identifiées et auditées enV693 ; les références et limites de cette révision sont conservées.

La comparaison qualifie mathématiquement cinq sortiesARGB8 locales. Les sept sorties compresséesDXT1/DXT5 restent à décoder et comparer indépendamment. Les espaces de couleur historiques,sRGB,alpha blending,UV,sampler,mode/backend/catégorieflash,caller normal et nettoyage nominal natif restent ouverts. La correspondance desDLLs avec2014,la frame finale et la résidenceVRAM ne sont pas démontrées. Les consommateurs actuels n'ont pas été modifiés ou exécutés par ce calcul.

Fichiers ajoutés : ce rapport,preuveJSON préliminaire,scripts et observations dans le dossier de travailF. Documents actualisés :coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md. Les anciens champs et fichiers sont sauvegardés et conservés. Le registre canonique,les tâches,les inconnues et les bases ne sont pas modifiés par ce checkpoint. Aucun champion,écran ou jeu complet accepté.

## Suite

Continuer SYS-01.2-02 surF. V693 est publié/audité (12copiesAPI locales,96HRESULT nominaux0,12readbacks/13107200octets,8consommateurs inchangés). V694 a exécuté la comparaison complète des5sortiesARGB8 :2621440pixels/10485760canaux,tous à0.5niveau près du modèle linéaire à bouclage ; revue scalaire indépendante17900pixels incluant tous les bords. Le premier modèleclamp est réfuté (code2,max5.67578125) et conservé ; modèlewrap/code0 et revue/code0,aucune tolérance élargie,aucune texture modifiée. Contratheader/pageMicrosoft identifiés. Cette preuve V694 est documentée mais pas encore reliée au registre canonique ni aux deux fiches/bases : commencer par construire un lecteur d’associations V694,conserver les8descripteurs et historiser la même question ouverte en distinguant5ARGB8qualifiés mathématiquement des7DXT encore non décodés. Utiliser les sorties existantes sans relancerAPI/GPU sans raison. Puis décoder/comparer les7sortiesDXT et relier au transport actuel,UV/couleur/sampler/caller normal ; suivre le retour9B8738/nettoyage natif avec adaptations déclarées. Garder ouverts runtime2014,mode1225C58/callers9B7590,backend/catégorieflash historiques,Kalista288octets et12noms antérieurs. F est le volumeprojet et scratch ; réserve4GiB surF,réutiliser la garde F stricte de revision693_delivery_on_F_checked.py et adapter proprement le préfixe si nouveau scratch. Préserver toutes cases,historiques etpreuves. Goal actif,aucun écran/jeu complet accepté.
