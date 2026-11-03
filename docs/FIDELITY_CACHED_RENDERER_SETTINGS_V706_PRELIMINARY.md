# SYS-01.2-02 — Réglages et cycle désactivé, modules compilés identifiés, V706

UTC : 2026-10-28T00:43:06.054575+00:00. Projet F:/OpenLeague. Référence native PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. **Preuves nouvelles exécutées et revues ;leurs associations au registre et aux deux fiches/bases restent à intégrer.** Dernière intégration auditée V705 :99947sources/5622consommateurs,42215exigences actives,26189inconnues ouvertes.

## Ce qui a été exécuté

Deux pilotes privés sont compilés avec le compilateur identifié et les bibliothèques Bevy/bevy_internal/bevy_render/wgpu du cache sélectionnées par leur chaîne de fingerprints. Les listes de features correspondent aux sorties CargoTree ciblées relevées V704. Les bibliothèques et fingerprints sont rehachés avant/après ;les sources vendor actuelles sont relues, **pas recompilées**. La reproductibilité complète du lien entre ces sources et le cache reste non qualifiée.

Cinq processus enfants appellent réellement WgpuSettings::default. Seule la variable WGPU_BACKEND est pilotée pour ces assertions ;les autres entrées d'environnement sont héritées et ne sont pas qualifiées globalement. Aucun réglage utilisateur persistant n'est changé.

| Cas | Variable de test | Masque observé | Option |
|---|---|---:|---|
| unset | None | 63 | Some |
| vk | vulkan | 2 | Some |
| alias |  Vk , D3D12  | 10 | Some |
| invalid | openleague-invalid-backend-control | 0 | Some |
| empty |  | 0 | Some |

Les constantes du source local wgputypes29.0.4 sont confrontées indépendamment aux résultats. Les cinq assertions passent. **Une valeur vide ou inconnue donne Some(masquevide),pasNone.** Ce résultat ne choisit aucun adaptateur et ne démontre pas la disponibilité d'un backend. Aucun mapping de ces bits vers les catégories natives1225B04=0/1/2 n'est déduit.

## Cycle de vie sans backend

Le premier pilote installe MinimalPlugins,AssetPlugin etRenderPlugin avec backends=None. Les cinq cas de réglage réussissent,mais le cycle désactivé finit avec101 :TexturePlugin::finish attend un ImagePlugin et indexe une liste vide. C'est un prérequis manquant du pilote, pas une texture du jeu déclarée absente. Ce premier binaire,son résultat globalfalse/code2 et le log101 sont conservés.

Un pilote distinct ajoute le vrai ImagePlugin aprèsRenderPlugin,comme l'ordre déclaré dans DefaultPlugins. Il rejoue uniquement le cas désactivé. build,ready,finish etcleanup reviennent avec code0. Le ready du RenderPlugin installé vauttrue alors que RenderApp etRenderDevice sont absents. Avantfinish,RenderAdapter etRenderInstance sont également absents ;aprèscleanup le pilote réaffirme seulement l'absence de RenderApp etRenderDevice.

**Pluginreadytrue ne prouve pas un renderer ou un GPU prêt.** Le source indique que l'absence des ressources futures est compatible avec cette réponse quand le backend n'est pas requis. Le test ne prétend ni un défaut du client normal ni une initialisation graphique normale réussie.

Aucun pilote ne lance de fenêtre,client ou boucle de jeu/réseau et aucun ne demande directement un adaptateur/périphérique graphique. Aucune capture globale des appelsAPI du système n'est revendiquée. Les ressources observées sont celles du World de test.

## Contrôles et identités

La revue compare les JSON aux logs réels,les masques aux constantes sources,les entrées binaires aux hashes et l'architecture PE àx64/8664. Six falsifications sont refusées :masque par défaut modifié,Somevide présenté commeNone,périphérique prétendu présent,clientnormal prétendu lancé,vendor prétendument recompilé etéchec101 supprimé. Six contrôles sont qualifiés au total :cinq réglages initiaux etun cycle corrigé ;le premier résultat globalfalse n'est pas réécrit.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V706_CACHED_SETTINGS | 0 | 2 | daf8bed39605837d21e7c66fb598871dafca4198efc588b70ddfdbd0ee31995d |
| V706_LIFECYCLE_CHECKED | 0 | 0 | 8bb296ec2fceb221a8fc7065ff5f45862b290acdb92f687e2a94bb7eee23264c |
| V706_CACHED_SETTINGS_REVIEW | 0 | 0 | 3fcd11f23be09df7cd6b2f49613688b6be44ff374d3d0c1685996ab13d680591 |

| Binaire privé | Octets | SHA-256 |
|---|---:|---|
| F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_renderer_settings\settings_probe.exe | 64423424 | a378891a8f90c91e25a9a64bec44b1e1369b37629ebc7625a2271835a591fe91 |
| F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_renderer_lifecycle_checked\settings_probe.exe | 65174016 | 3231699c7ee2866c9a1c6b258cdad3fafe9e087f268a4be158f1894d48f1b9de |

Les commandes de compilation,versionrustc,liens natifs,rlib,fingerprints et sources sont conservés dans les INPUTS/COMPILE/RUSTC_VERSION et preuvesJSON. Leurs identités ne qualifient pas une reconstruction complète de toutes les dépendances ou le binaire ordinaire du client.

## Livraison et limites

Rapport et preuveJSON ajoutés,couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF mis à jour avec sauvegardes et anciens champs conservés. Une décision de reprise distingue pluginready et disponibilité du renderer. Aucun code/asset de production modifié,aucune base ou fiche canonique changée par ce checkpoint et aucune case cochée. V705 garde son état publié ;V706 est une preuve supplémentaire datée.

Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_settings_review\REVIEW.json. Sources et résultats :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_renderer_settings\OBSERVATIONS.json etF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_renderer_lifecycle_checked\OBSERVATIONS.json. Ces preuves restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Restent ouverts :intégration V706,lien source-cache ou compilation fraîche,processus client normal et sa configuration effective,backend/adaptateur,GPU/frame,bootstrap natif,création de secours normale,inscription978820/signature/ownership,nom des portraits,UV/couleur/sampler,transport etcleanup. Le retour natifPE2/fabrique nulle V703 n'est pas une texture créée ou un manager prêt. Acquis et limites antérieurs,résidus83nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms préservés. Aucun écran,champion ou jeu complet accepté.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V705 publié/audité :9consommateurs source et2références de types,99947sources/5622consommateurs,2fiches/2bases et donnéesmanuelles conservés ;questionouverte historisée. V706 exécuté/revu mais associations àfaire :5DefaultWgpuSettings contrôlés dansmodulescacheidentifiés (unsetSome63,vulkanSome2,aliasSome10,invalide/videSome0,ce ne sontpasNone) ;premierlifecycle101 dû auImagePluginmanquant du banc,conservé. Nouveaupilote ajoute le vraiImagePlugin aprèsRenderPlugin commeDefaultPlugins ;backendNoneexplicite,build/ready/finish/cleanup réussissent,pluginreadytrue sansRenderApp/RenderDevice. Avantfinish absenceAdapter/Instance aussi ;aprèscleanup seulsRenderApp/Device réassertés. Deuxdriverscompilés,cachelibs/fingerprints/features etbinaires pinés,matchingCargoTreeciblé ;vendor pasfraîchementrecompilé,lien source-vers-cache/reproductibilité complète nonqualifié. Aucunclientnormal/frame oupériphérique demandéparpilote,aucuntracéAPIglobal. Intégrer ces preuves commecomposantscache bornés,passtartuprendererplein ;préserverancienéchec101/code2 etles5contrôlespassés. Puisqualifier sourcescompilées fraîches oulienbinairecourant,configurationordinaire/backend/adaptateur,producteursnatifs9B3D00/9C1430/callers/ordre sansforcerbackend/mapping0/1/2. NativeV703retourPE2/fabriquenulle resteacquis,pastexturecréée/managerprêt. Suitecréationnormale/inscription978820/ownership/nomportrait/UV/couleur/sampler/transport etcleanup. Pluginreadytrue ne prouvepasReadyGPU. Garderacquis/résidus83nonacceptés/alphaopaque/DLL2014/Kalista288octets/12noms. Avantprepare réserve4GiBF/scratchprivé ;vérifierreçus/fermeture avantcompression sansperte,aucunesuppression/casepromue. LirechaqueJSON unefois pourlescontrôlesdocumentaires. Goalactif,aucunécran/jeuaccepté.
