# SYS-01.2-02 — Décodages DXT reliés aux sources et consommateurs, V697

UTC :2026-10-27T22:35:22.019524+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Cette étape intègre les preuves V696 au registre canonique et aux deux bases du plan ;elle ne termine pas la présentation des portraits ou le jeu.

## Résultat et critères

SeptDDS (4DXT1/BC1,3DXT5/BC3) sont reliés à leur niveau0CPU natif capturé enV692,leurs surfacesAPI locales V693 et leurs décodages V696. Pillow12.3.0 et le décodeurPython indépendant produisent des pixels **strictement identiques sur14images/4 877 376pixels par décodeur**. Le critère fixé avant exécution autorisaitRGB≤1et alphaexact ;l'accord observé est strict sur tous les canaux des données réelles.

Cinq blocs attendus vérifient palettesBC1,transparence,précisionRGB565 et les deux branches d'alphaBC3 ;cinq entrées invalides sont refusées. Les cinq falsifications de preuve sont refusées :empreinte décodée modifiée,qualitécompression prétendument acceptée,alpha réel prétendument variable,caller normal prétendument exécuté et formatDXT changé. Les résultats de la revueV696 restent hérités ;ce lecteur revérifie leurs octets,pins,associations et limites sans rejouer les décodeurs/API/GPU.

## Résidus et limites d'alpha

| Portrait | FormatDWORD | Résidu maximal RGBA,niveaux/255 | Alpha source,min/max |
|---|---:|---|---|
| Braum:0 | 894720068 | [51.697845458984375, 32.8203125, 36.934295654296875, 0.0] | [255, 255] |
| Braum:1 | 827611204 | [47.8203125, 33.000152587890625, 32.302703857421875, 0.0] | [255, 255] |
| Kalista:0 | 827611204 | [40.92364501953125, 28.25714111328125, 32.733978271484375, 0.0] | [255, 255] |
| Kalista:1 | 894720068 | [83.0, 33.38433837890625, 56.4437255859375, 0.0] | [255, 255] |
| Rengar:0 | 827611204 | [35.1796875, 28.828460693359375, 42.57421875, 0.0] | [255, 255] |
| Zac:0 | 894720068 | [45.3046875, 24.15625, 35.73699951171875, 0.0] | [255, 255] |
| Zac:1 | 827611204 | [50.4718017578125, 24.997772216796875, 48.284912109375, 0.0] | [255, 255] |

Le maximum atteint83surKalista1contre le modèle de filtrage non recompressé. Ces mesures n'établissent pas un défaut d'asset ou une qualité acceptable :**aucun seuil d'acceptation de compression n'est inventé**. Les sept sources et destinations réelles ont alpha255partout. Les contrôles synthétiques couvrent le décodage d'alpha variable, pas l'API de filtrage àalpha variable ni le blendinghistorique.

Le [contratMicrosoft des formats compressés](https://learn.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression) est une autorité de format, pas une captureLoL2014. Le pluginPillowDDS,l'extension native64bits,NumPy et les scripts sont identifiés par version/taille/SHA-256. Leurs chemins installés sont une limite de portabilité locale ;ils ne sont pas des DLLRiot d'origine. Les fichiersRGBA sont des diagnostics. Le conteneurDDS adapté existe uniquement en mémoire ;les DDS natifs et les blocs source/surface restent inchangés.

## Intégration et conservation

SYS-17.3-01 etSYS-01.2-02 reçoivent8liens natifs (EXE+7DDS) et51sources nouvelles. Les huit descripteurs actuels sont fraîchement vérifiés sur leurs sources/lignes et restent inchangés. Aucun nouveau consommateur de fonctionnalité,code ou asset de production n'est ajouté. Dépendances,phases,lots et critères sont conservés.

La questionOLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec ancien texte/condition en historique et recherche ajoutée ;elle resteopen. Identité,propriétaire,aspects,statuts et autres inconnues sont conservés. Le graphe compte99762sources,5613consommateurs,42 215exigences actives,26 189inconnues ouvertes et5517résolues antérieures. Ce compteur ne prouve pas un rehachage du catalogue complet ;les pins de cette livraison sont vérifiés séparément.

Cinq mutations du candidat sont refusées. Inversion documentaire exacte,inversion logiqueSQLite et idempotence sont vérifiées. Les deux bases publiées et auditées conservent42 605autres lignes,42 607états manuels et23historiques. Aucune case cochée automatiquement,aucun prérequis levé,aucune acceptation de jeu enregistrée.

| Étape | Code nominal attendu | Code reçu | SHA-256 journal |
|---|---:|---:|---|
| V696_DXT_DECODE | 0 | 0 | ec2796e170858d5934c64a5c356c498f1c78a70a21ecf1464dc15a154c0b9422 |
| V696_DXT_REVIEW | 0 | 0 | 49bc1508b4754d85683f845228478a6946cd8fbe86d8d2181b5b8459df740aa7 |
| V696_DXT_CHECKPOINT | 0 | 0 | 87ff19920b114c131f6a75b52ad7a5f6dc91a8d28165d45313d6136ab11301ae |
| V697_ASSOCIATIONS | 0 | 0 | 27f8e4d51d75c9863d4ec63e12ea4ff88e371359a53d3afed69174c6085d0a47 |
| V697_STORAGE | 0 | 0 | 24353ada296fc4ad8312604affa33a2221f04825af5b2dedc71c0500817af36b |
| V697_PREPARE | 0 | 0 | a2db4ec6dc992f52630578fbc406ca47a76247cdaa2ceda95fa22bbc24d25b56 |
| V697_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V697_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V697_DELIVERY_AUDIT | 0 | 0 | 07d1778502e8f46262904d00b7d9a5ea942891952160e9a2186394153d4df20e |

14fichiers historiques fermés sont compressés sans perte,avec exclusivité,SHA-256,tailles logiques et sidecars conservés ;réduction de stockage rapportée1329750600octets. Aucune suppression et aucune base active compressée. La réserve4GiB et le scratch restent surF avec garde de chemin stricte.

## Fichiers, provenance et points ouverts

Fichiers canoniques modifiés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,fidelity_unknowns_4_20.json ;reçu docs/reference_requirement_trace_sources/native-portrait-dxt-decode-v697.json ;preuvedocs/fidelity_native_portrait_dxt_decode_v697.json ;deux bases du plan. Ce rapport,couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF sont actualisés avec sauvegardes et conservation des anciens champs. IDS et ordre phases/lots restent byte-identiques. V696préliminaire conserve son état daté ;V697est son intégration ultérieure.

Lecteur source :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision697_dxt_associations\OBSERVATIONS.json. Observation de décodage :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision696_dxt_decode_compare\OBSERVATIONS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision696_dxt_decoder_review\REVIEW.json. Les outils,reçus,journaux,diagnostics et résultats antérieurs sont conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun build complet moteur ou nouveau testRust n'est revendiqué ;les contrôles du consommateur réel du plan sont exécutés.

Restent ouverts :qualité/cause des résiduscompression,comparaison au transport actuel,UV/couleur/sampler,mode/backend/catégorieflash,caller normal/provider/cache/UI et nettoyage nominal natif. Les DLLs2014,frame finale et résidenceVRAM ne sont pas qualifiées. Les cinqARGB8/max0.5V695 et acquisV693/V692/V691/V690/V689,Kalista288octets et12noms ouverts sont conservés. Aucunécran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 surF. V697 a intégré/audité les7DXT V696 :4BC1/3BC3,14images/4877376pixels par décodeur,accord exact ;5blocs/5refus d’entrée/5falsifications. Alpha réel255,compressionqualité non acceptée,résidusmax83. Deux fiches/deux bases,8consommateurs inchangés et question ouverte historisée. Les5ARGB8V695/max0.5et acquis antérieurs sont conservés. V698 a exécuté séparément12parcours natifs après retourcopyS_OK adapté depuisV693,pas de nouvelleAPI/GPU :publicationtexture puis arrêt avant inscription98964D→978820,managerglobal2D79030=0 dans contexte déclaré. Le premier garde698 à9BB764 était trop restrictif sur le succès et le premier lecteur exigeait à tort le stopPC parmi les exécutés ;leurs codes2/1 sont conservés,versionsdistinctes corrigées. Suite :relire/qualifier l’ensemble V698 puis associer cette nouvelle frontière et ses consommateurs précis ;distinguer ce manager d’inscription du provider90AD00 plus amont. Examiner le constructeur/publisher de2D79030 et la fonction978820,le retour/cleanup nominal et lesUV/couleur/sampler sans inventer de backend. Conserver wrappers vivants au stop,ne pas confondre surface0et VRAM entièrement libérée. Comparer ensuite au transport actuel et qualifier résiduscompression,sampler/mode/contexte/normalcaller ;DLL2014,Kalista288octets et12noms restent ouverts. Avantprepare vérifier réserve4GiBF et garder scratchF strict. Goal actif,aucunécran/jeucomplet accepté.
