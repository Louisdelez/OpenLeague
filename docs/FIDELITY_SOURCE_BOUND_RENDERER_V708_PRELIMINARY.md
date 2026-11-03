# SYS-01.2-02 — Module renderer compilé depuis les sources actuelles, V708

UTC : 2026-10-28T01:21:00.383539+00:00. Projet F:/OpenLeague. Référence native PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. **Nouvelle preuve exécutée et revue ;associations au registre et aux deux fiches/bases encore à intégrer.** Dernière publication auditée V707 :100006sources/5622consommateurs,42215exigences actives,26189inconnues ouvertes.

## Ce qui change par rapport aux bibliothèques de cache

Le crate vendor bevy_render actuel est compilé depuis son entrée src/lib.rs vers une nouvelle bibliothèque privée. L'inventaire contient88fichiers etreste exactement identique après compilation etrevue. Cela ne signifie pas que chaque fichier conditionnel est exécuté. Les anciens artefacts partagés contrôlés restent byte-identiques.

La compilation utilise explicitement l'édition2024,opt-level0,debuginfo0,debug-assertions actives etune métadonnée de crate distincte. Les quatre features morph,multi_threaded,reflect_auto_register,webgl correspondent au contrat CargoTree ciblé observé. Les variables de package/manifest etla commande complète sont enregistrées. C'est un profil diagnostique déclaré,pas une reproduction du profil de build du client ordinaire.

Les42dépendances directes proviennent du cache identifié par leurs fingerprints etartefacts rlib/DLL. Elles ne sont pas recompilées. Leurs entrées etles pins du cache sélectionné sont contrôlés avant/après ;aucune reconstruction hermétique de leur source ou du graphe transitif complet n'est revendiquée.

## Bibliothèque et pilote effectivement utilisés

Bibliothèque fraîche :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_source_bound_renderer\libbevy_render_source_bound_v708.rlib, 59186412octets,SHA25692e2ab23ffd43859256ba9727d7338804508c02a3a0695cbaf6a51d5f4962acf.

Pilote :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_source_bound_renderer\source_bound_probe.exe, 45702144octets,SHA25626db6c5a327ac7cd13a7c683c652c9f88d5a41a81d6cf3a4f58581897b8097f6,PE x64/8664. Son --extern bevy_render pointe explicitement sur la nouvelle bibliothèque. Il n'emploie pas le crate bevy/bevy_internal du cache,qui aurait ramené l'ancien renderer.

Le pilote compose directement les plugins publics App/TaskPool/FrameCount/Time/ScheduleRunner,Asset,Render etImage. Cette composition déclarée évite l'ancien module de rendu ;elle ne constitue pas le démarrage normal du client ou une exécution de sa chaîne main/DefaultPlugins. Les sources de ces dépendances restent du cache.

## Résultats observés

| Cas | WGPU_BACKEND de test | Masque/option | Code |
|---|---|---:|---:|
| unset | None | 63 | 0 |
| vk | vulkan | 2 | 0 |
| alias |  Vk , D3D12  | 10 | 0 |
| invalid | openleague-invalid-backend-control | 0 | 0 |
| empty |  | 0 | 0 |
| disabled | None | None explicite | 0 |

Les cinq defaults donnent Some63,Some2,Some10,Some0 etSome0. Vide/inconnu n'est pas None. Seule cette variable est pilotée pour les assertions ;les autres entrées d'environnement des defaults restent héritées.

Pour None explicite,build/ready/finish/cleanup réussissent. Le pluginready vauttrue sansRenderApp/RenderDevice. Avantfinish,RenderAdapter etRenderInstance sont aussi absents ;aprèscleanup seules les absencesRenderApp/RenderDevice sont réaffirmées. Cette réponse ne prouve pas un renderer ou un GPU prêt. Le pilote ne demande directement aucun adaptateur/périphérique etne lance ni fenêtre ni boucleclient/frame ;aucun tracé global desAPI n'est prétendu.

Les résultats sont cohérents avec les essais cacheV706,mais la preuve de liaison source→bibliothèque privée est désormais explicite pour **ce module vendor sélectionné**. Elle ne transforme pas rétroactivement les anciennes preuves cache en compilations fraîches.

Une matrice relie les neuf rôles àleur niveau de preuve :trois restent des références source statiques,cinq sont soutenus par le profil de composants contrôlé sans trace indépendante d'instructions,etun appel n'est pas exercé par ce profil. Ce dernier est initialize_renderer avec un backendSome :les casvulkan/alias ne font qu'appeler les réglages ;seul le casNone construit le RenderPlugin. Les deux définitions de types restent des références. La matrice ne prétend donc ni couverture de branches ni exécution de toute la chaîne main/DefaultPlugins.

## Vérifications et refus

La revue compare l'ensemble des88chemins etles hashes avant/après,vérifie les commandes/librairie liée,les logsJSON,l'archive rlib etl'architecturePE. Six falsifications sont refusées :module présenté comme cache,ancien renderer substitué au lien de la sonde,dépendances prétendument reconstruites,profilordinaire prétendu,clientnormal prétendu etSomevide présenté commeNone.

| Étape | Attendu | Observé | SHA-256 journal |
|---|---:|---:|---|
| V708_SOURCE_BOUND_COMPONENT | 0 | 0 | 442edaaa7b8f6a94a4045fe253cc85629b183b65f5d1e521546f2967d7b8c6c1 |
| V708_SOURCE_BOUND_REVIEW | 0 | 0 | 5d632c540990503f3b3c6172b9c2da6af29b3747366b8ba2649ce14653370052 |
| V708_CONSUMER_SCOPE_MATRIX | 0 | 0 | 1618dd79b10031cfc1fe2eca6d0d966aab4528ff1e419f0892abe51fd887ac8e |

Aucun nouvel échec de compilation oucas de ce lot n'est masqué. Les échecs précédentsV706duImagePluginmanquant etleurs réparations distinctes restent dans leur preuve datée. Aucun code/asset de production n'est modifié par la construction isolée.

## Livraison et limites

Rapport etpreuveJSON ajoutés,couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF actualisés avec sauvegardes etanciens champs conservés. Aucun registre/fichier de tâche canonique oubase du plan changé par ce checkpoint etaucune case cochée. V707 reste publié ;V708 est une preuve supplémentaire datée.

Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_source_bound_renderer\OBSERVATIONS.json. Entrées :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_source_bound_renderer\INPUTS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_source_bound_review\REVIEW.json. Matrice :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision708_consumer_scope_matrix\MATRIX.json. Sources,pins,commandes,cfg/env contrôlés,rlib,binaires etlogs restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Restent ouverts :intégrationV708,reconstruction/provenance complète des dépendances etprofilclientordinaire,configuration/backend/adaptateur effectifs,initialisation d'un renderer normal etframe. Les points main/macroDefaultPlugins/initRenderer avec backendSome ne sont pas déclarés exécutés par ces seuls contrôles. Bootstrap natif0/1/2,mapping verswgpu,créationnormale/inscription978820/signature/ownership,nomportrait/UV/couleur/sampler/transport/cleanup restentouverts. Retour natifPE2/fabrique nulle n'est pas une texture créée ou un manager prêt. Acquis etlimites antérieurs,résidus83nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Aucun écran,champion ou jeu complet accepté.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V707 publié/audité :V706composantscache intégrés,100006sources/5622consommateurs,17descripteurs/ancienmainmatériau et donnéesmanuelles conservés ;questionouverte historisée. V708 exécuté/revu mais associations àfaire :cratevendorbevy_render actuel compilé directement enrlibprivée àpartirdulib.rs/fourcfgfeatures,88fichiersinventoriés exactsavant/après,42dépendancesdirectescache etanciensartefactspinsinchangés. DriverdirectApp/TaskPool/FrameCount/Time/ScheduleRunner/Asset/Image lieexplicitementcetterlib sanscachedbevy_internal. Les6contrôles Some63/2/10/0/0 etNoneLifecycle passent ;pluginreadytrue sansRenderApp/Device,aprèscleanupseulsApp/Device réassertés. Liaison sourceactuelle→moduleprivéqualifiée sousflagsO0/debug0/debugassertions,ni42dépendancesrecompilées,niherméticité/profilclientordinaire/binairejeu. IntégrerV708 commepreuveplusforte pourlemodule,sanspromouvoirlesessaiscacheV706/V707 ni prétendrechaînesourceentièreexécutée (main/macroDefaultPlugins/initrendererSome restentdistincts). Puisqualifier unbackendnormal/headless ouclientnormal avecbinaire/configuration/backend/adaptateur observés,éventuelframe etlifetime ;préserverNoneetSomevide différents. Producteursnatifs9B3D00/9C1430/callers/ordre etcréationnormale/inscription978820/ownership/nomportrait/UV/couleur/sampler/transport/cleanup restentouverts,sansforcerbackend/mapping0/1/2. Garderacquis/résidus83nonacceptés/alphaopaque/DLL2014/Kalista288octets/12noms. Réserve4GiBF/scratchprivé avantprepare ;vérifierreçus/fermeture avantcompression sansperte,aucunesuppression/casepromue. LireJSON unefois pourlescontrôlesdocumentaires. Goalactif,aucunécran/jeuaccepté.
