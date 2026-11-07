# SYS-01.2-02 — Composants compilés identifiés : intégration V707

UTC : 2026-10-28T01:20:12.183660+00:00. Projet F:/OpenLeague. Référence native PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. V707 relie les essais V706 au registre et aux deux bases. Leur portée reste celle des bibliothèques de cache identifiées ;une compilation distincte des sources V708 est revue séparément.

## Résultats liés

Cinq processus enfants exécutent WgpuSettings::default dans les modules cache identifiés. Seule WGPU_BACKEND est pilotée pour ces assertions. Les autres entrées d'environnement des defaults restent héritées et non qualifiées globalement.

| Cas | Valeur de test | Masque observé | Option |
|---|---|---:|---|
| unset | None | 63 | Some |
| vk | vulkan | 2 | Some |
| alias |  Vk , D3D12  | 10 | Some |
| invalid | openleague-invalid-backend-control | 0 | Some |
| empty |  | 0 | Some |

Les valeurs invalides ou vides produisent Some(masquevide),pasNone. Ces bits ne prouvent ni un adaptateur choisi ni une disponibilité matérielle. Aucune correspondance vers les catégories natives1225B04=0/1/2 n'est déduite.

Le cycle corrigé installe MinimalPlugins,AssetPlugin,RenderPlugin(backendsNone) puis le vraiImagePlugin. build/ready/finish/cleanup réussissent. Le ready du plugin vauttrue sansRenderApp/RenderDevice. Avantfinish,RenderAdapter etRenderInstance sont aussi absents ;aprèscleanup,seules les absencesRenderApp/RenderDevice sont réaffirmées. Le ready du plugin ne signifie pas GPUprêt ou renderer créé.

Le premier pilote avait cinq contrôlessettings réussis puis un échec101 dansTexturePlugin::finish,faute d'ImagePlugin. Son résultat globalfalse/code2,son binaire etsonlog restent conservés. Le pilote distinct corrige seulement ce prérequis du banc ;aucun asset de jeu n'est déclaré manquant ni reconstruit.

## Portée binaire et source

Deux pilotes privés sont compilés et exécutés. La chaîne de fingerprintsBevy→bevy_internal→bevy_render→wgpu etses features sont identifiées ;les listes correspondent aux sortiesCargoTree ciblées. Sourcesvendor etartefacts sont pinés,mais le vendor n'est pas fraîchement recompilé dans V706. Le lien source→cache/reproductibilité complète etle binaire ordinaire du client restent non qualifiés par cette preuve.

Les pilotes n'appellent pas de boucleclient/fenêtre/jeu/réseau etne demandent directement aucun adaptateur/périphérique. Ils ne constituent pas un tracé global desAPI du système. Aucuneframe n'est acceptée. La compilation isoléeV708 constitue une preuve distincte etne change pas rétroactivement la portée de V706/V707.

## Registre, consommateurs et bases

SYS-17.3-01 et SYS-01.2-02 reçoivent 1 lien natif hérité et 59 sources nouvelles. Les17descripteurs de frontières etl'ancienmain651matériau sont revérifiés puis conservés. Aucun nouveau rôle ou code/asset de production n'est ajouté,pas de promotion de fonctionnalité. Les deux références de typesV705 restent des références.

OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec ancien texte etcondition en historique. Identifiant,propriétaire,aspects etstatuts sont conservés ;elle reste ouverte. Graphe :100006sources/5622consommateurs,42215exigencesactives,26189ouvertes/5517résolues antérieures. Le compteur n'est pas un rehachage complet du catalogue ;les pins de cette livraison sont vérifiés séparément.

Les deux bases réellement publiées et auditées conservent chacune42605autreslignes,42607étatsmanuels et23historiques. Store.task/copy/summary/trace consomment les données ;le contexte copiable complet est décodé commeJSON et comparé exactement aux données reference_context. Aucun prérequis levé ou case cochée.

## Contrôles et livraison

Six falsifications sont refusées :vendor prétendu frais,clientnormal/frame prétendus,périmètreaprèscleanup élargi,échec101 supprimé etSomevide présenté commeNone. La revue V706 conserve ses sixrefus ;ce ne sont pas des tests de gameplay. Cinq mutations du candidat sont refusées ;inversion documentaire exacte,inversionSQLite logique etidempotence vérifiées.

| Étape | Code nominal attendu | Observé | SHA-256 journal |
|---|---:|---:|---|
| V706_CACHED_SETTINGS | 0 | 2 | daf8bed39605837d21e7c66fb598871dafca4198efc588b70ddfdbd0ee31995d |
| V706_LIFECYCLE_CHECKED | 0 | 0 | 8bb296ec2fceb221a8fc7065ff5f45862b290acdb92f687e2a94bb7eee23264c |
| V706_CACHED_SETTINGS_REVIEW | 0 | 0 | 3fcd11f23be09df7cd6b2f49613688b6be44ff374d3d0c1685996ab13d680591 |
| V706_CACHED_SETTINGS_CHECKPOINT | 0 | 0 | 16822de2d41db4ae74bd41deb44f3b034b441143bf282d2e22eab0e042d8f74e |
| V707_ASSOCIATIONS | 0 | 0 | a7e429459bb21a5f2206b5b4e2c027196e908a4336f96e2aa32198d2f0e294d5 |
| V707_STORAGE | 0 | 0 | 1e1090b25e1edcd47ff65b3c249cc18acf7064420e7baf075c356c87aa43e24f |
| V707_PREPARE | 0 | 0 | bc8aa62408b74bed78fc821f649f7b916cdf27bf48ce1c8d3d7dc7d2c74a7c5f |
| V707_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V707_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V707_DELIVERY_AUDIT | 0 | 0 | 544d6f0c8da4080038c397d8b9401dd1edef29c029910892d16a4b0bd7c7ab68 |

Rapport présent,preuve docs/fidelity_cached_renderer_components_v707.json et reçu docs/reference_requirement_trace_sources/cached-renderer-components-v707.json ajoutés. REG/TR/SRC/UNK etles deux bases actualisés ;IDS etphases/lots byte-identiques. Couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF mis à jour avec sauvegardes etanciens champs conservés. V706 préliminaire garde son état daté,V707 est son intégration ultérieure. 5 preuves fermées/auditées compressées sans perte,taille/SHA/sidecars conservés,aucune suppression oubaseactive touchée ;scratchprivéF etgarde4GiB maintenus.

Lecteur :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision707_cached_component_associations\OBSERVATIONS.json. Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision706_cached_renderer_settings\OBSERVATIONS.json. Binaires,rlib,fingerprints,versionsrustc,commandes etlogs sont identifiés dans les preuves V706 et F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun runtime natif ou Rust n'est rejoué par le lecteur d'associations V707.

Restent ouverts :sourcecourante→binaire normal/rebuild,dépendances etprofilordinaire,configurationeffective/backend/adaptateur/frame,bootstrap natif,créationnormale/inscription978820/signature/ownership,nomportrait/UV/couleur/sampler/transport etcleanup. Le retour natifPE2/fabrique nulle n'est ni texture créée ni manager prêt. Acquis etlimites antérieurs,résidus83nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms préservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V707 a intégré/audité V706 :5settingscache+1lifecyclecorrigé,Some0distinctNone,readyplugintrue sansRenderApp/Device,échec101/global2 duImagePluginmanquantdubanc conservé. 17descripteurs etancienmainmatériau inchangés,zérorôlepromu,2fiches/2bases et donnéesmanuelles conservés ;questionouverte historisée. PortéeV707=cacheidentifié,vendor nonrecompilé danscesessais,pasclientnormal/frame/nativemapping. V708 distinct a maintenant recompilé lecratevendorbevy_render avec88fichiers inventoriés versrlibprivée sousflagsdiagnostiques explicites,enréutilisant42dépendancescacheidentifiées ;6contrôles passent etrevue0,anciensartefactspartagés/ensembleSources inchangés. Cette liaison source-actuelle→rlibprivée estqualifiée pourlemodule,pasrebuildhermétique desdépendances ouprofilclientordinaire. Enregistrer/intégrer V708 sansélargir V707. Puisqualifierconfigurationordinaire/backend/adaptateur etinitialisationréelle,provenance/rebuilddépendances si nécessaire,producteursnatifs9B3D00/9C1430/callers/ordre sansforcerbackend/mapping0/1/2. NativePE2/fabriquenulle resteacquis,pastexturecréée/managerprêt. Suitecréationnormale/inscription978820/ownership/nomportrait/UV/couleur/sampler/transport etcleanup. Garderacquis/résidus83nonacceptés/alphaopaque/DLL2014/Kalista288octets/12noms. Réserve4GiBF/scratchprivé avantprepare ;fermeture/reçus avantcompression sansperte,aucunesuppression/casepromue. LectureuniqueJSON pourconservation. Goalactif,aucunécran/jeuaccepté.
