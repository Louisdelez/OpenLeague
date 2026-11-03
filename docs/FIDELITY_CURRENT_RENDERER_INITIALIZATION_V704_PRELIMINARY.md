# SYS-01.2-02 — Initialisation du renderer actuel, V704 préliminaire

UTC : 2026-10-27T23:53:47.306622+00:00. Projet : F:/OpenLeague. Référence native : PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. **Cette étape vérifie des sources et leur résolution Cargo. Les associations au registre et aux deux fiches/bases restent à intégrer.** Dernière publication auditée V703 :99893sources/5613consommateurs,42215exigences actives,26189inconnues ouvertes.

## Sources réellement résolues

Cargo metadata est exécuté avec --locked,--offline et filtre x86_64-pc-windows-msvc. Le binaire Cargo résolu par rustup est identifié et sa version enregistrée ;aucune installation ou compilation n'est lancée. Les sept fichiers d'entrée,dont Cargo.lock,restent byte-identiques avant/après.

Résultat : Bevy,bevy_internal etbevy_render **0.19.0** ;wgpu etwgpu-types **29.0.4**. bevy_render est résolu depuis F:/OpenLeague/vendor/bevy_render,avec source Cargo locale et patch explicitement confirmé dans Cargo.toml. Les fichiers résolus de bevy_internal etbevy_app sont lus dans le cache local.

Le graphe de features de metadata est celui de la résolution du workspace. Il ne prouve pas les features exactes d'un client déjà compilé,ni le backend/adaptateur choisi dans un processus lancé.

Trois commandes Cargo tree distinctes ciblent openleague-client sous Windows,avec les seules arêtes normal/build,profondeur0 et inversion sur bevy_render,bevy_internal puiswgpu. Leurs sorties réelles sont conservées séparément de metadata. Elles rapportent notamment bevy_render=morph,multi_threaded,reflect_auto_register,webgl et la feature bevy_render dans bevy_internal. Les noms de features rapportés pourwgpu ne prouvent ni la disponibilité d'un backend Windows ni le choix d'un adaptateur dans un binaire lancé.

## Chaîne d'initialisation vérifiée dans les sources

Le client configure DefaultPlugins. Le groupe déclare RenderPlugin sous la condition de feature bevy_render. La macro plugin_group construit les plugins via Default ;RenderPlugin dérive Default et RenderCreation utilise Automatic avec des WgpuSettings par défaut.

RenderPlugin::build appelle insert_future_resources,puis RenderCreation::create_render. Dans le chemin Automatic,une valeur backends=None produit un refus explicite ;sinon le source appelle initialize_renderer. WgpuSettings::default lit la configuration de backend de l'environnement,avec ses valeurs par défaut du source. Ce comportement est **lu**,pas exécuté par cette étape.

| Rôle source | Fichier et ligne |
|---|---|
| ordinary_client_default_plugin_group | F:\OpenLeague\crates\client\src\main.rs:651 |
| resolved_default_group_render_plugin | C:\Users\loicd\.cargo\registry\src\index.crates.io-1949cf8c6b5b557f\bevy_internal-0.19.0\src\default_plugins.rs:44 |
| render_plugin_initialization_boundary | F:\OpenLeague\vendor\bevy_render\src\lib.rs:357 |
| future_render_resource_creation_boundary | F:\OpenLeague\vendor\bevy_render\src\lib.rs:515 |
| default_backend_configuration_source | F:\OpenLeague\vendor\bevy_render\src\settings.rs:84 |
| render_creation_variants | F:\OpenLeague\vendor\bevy_render\src\settings.rs:223 |
| plugin_group_constructs_default_plugin_under_feature_guard | C:\Users\loicd\.cargo\registry\src\index.crates.io-1949cf8c6b5b557f\bevy_app-0.19.0\src\plugin_group.rs:165 |
| render_plugin_derive_default | F:\OpenLeague\vendor\bevy_render\src\lib.rs:129 |
| render_creation_default_automatic | F:\OpenLeague\vendor\bevy_render\src\settings.rs:311 |
| automatic_creation_source_refusal_for_none | F:\OpenLeague\vendor\bevy_render\src\settings.rs:271 |
| automatic_renderer_initialization_source_call | F:\OpenLeague\vendor\bevy_render\src\settings.rs:277 |

La source signale que la présence des ressources futures n'est pas nécessairement leur disponibilité immédiate. Aucun état prêt,création effective de texture ou frame n'est déduit de l'existence d'un appel.

## Contrôles et refus

Attendu : résolution locale verrouillée,patch vendor correct,versions cohérentes avec Cargo.lock,ancrages sur les lignes réelles et aucune mutation des sources. Observé :tous ces contrôles passent. Cinq falsifications du lecteur et cinq de la chaîne sont refusées :exécution prétendue,features binaires prétendues,mapping natif prétendu,origine/ligne erronée ou lien Default manquant. La première revue reprend les cinq refus du lecteur ;elle n'est pas comptée comme cinq refus indépendants supplémentaires.

Le premier lecteur supposait une écriture bevy_render::RenderPlugin. La macro réelle emploie bevy_render:::RenderPlugin. Il s'est arrêté avec code1 après résolution Cargo,avant toute modification du registre ou du plan. Source,log et métadonnées sont conservés ;un lecteur distinct avec le vrai ancrage refait la résolution et réussit.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V704_CURRENT_RENDERER_SOURCE | 0 | 1 | 78938de96187b7307ebabb5b423a1c4d11c45be1dd14f291c7244f8bf5fdabd6 |
| V704_CURRENT_RENDERER_SOURCE_CHECKED | 0 | 0 | c6029a99538ec5458a6886d119ee16a7ab298135fc34a336eb903cb3a304e8a7 |
| V704_RENDERER_SOURCE_REVIEW | 0 | 0 | b8c46bee4a8f6127ce2ef243e1357a6b211dfb810ff9e1dc4b4cf3deeb039cec |
| V704_RENDERER_CHAIN_REVIEW | 0 | 0 | 6629a3ee5d0fbe23b5036d828c7a49cc43875b043e3d682e3c46ee39fa60a121 |
| V704_CLIENT_FEATURE_TREE | 0 | 0 | 0e07fc8bc1938caa1168f4f89eef7f09ffe29919f36bd9a126c584876b5324d4 |

## Rôles existants et limites

L'ancre main.rs:651 possède déjà le descripteur OLC-55e55803-4c64-52ad-bed7-77fab28cc1c6,qualifié historiquement pour un chemin de matériaux. Il est vérifié et conservé tel quel. Cette étape ne transforme pas son rôle global en équivalence du backend natif. Le hash de registre dans la revue est son observation datée avant V703 ;le descripteur concerné est revérifié après cette publication.

Aucun mapping entre les valeurs natives1225B04=0/1/2 et les backends modernes wgpu n'est qualifié. Les producteurs9B3D00/9C1430 et leurs callers9B6506/9C40A4 restent à exécuter dans un contexte établi. Le retour natif sous PE2 et l'objet de secours nul restent les faits V703 ;ils ne sont pas remplacés par un choix moderne de backend.

Ne sont pas exécutés :compilation,expansion de macro,Default de WgpuSettings,create_render,énumération d'adaptateurs,renderer,GPU ou frame. Restent ouverts :associations V704,rôles précis par exigence,bootstrap natif,création normale/inscription/ownership,nom des portraits,UV/couleur/sampler/transportactuel etcleanup. Les acquis et limites ARGB8/DXT,résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms sont conservés. Aucun écran,champion ou jeu complet accepté.

## Livraison et reprise

Rapport et preuve JSON ajoutés. Couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF sont actualisés avec sauvegardes et anciens champs conservés. Le registre canonique et les deux bases ne sont pas changés par ce checkpoint ;aucune case cochée ou code/asset de production modifié.

Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision704_current_renderer_source_checked\OBSERVATIONS.json. Revues :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision704_renderer_source_review\REVIEW.json etF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision704_renderer_source_chain_review\REVIEW.json. Sorties ciblées du client :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision704_client_feature_tree\OBSERVATIONS.json. Scripts,commandes,métadonnées et identités restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Continuer SYS-01.2-02 sur F:/OpenLeague. V703 publié/audité :V702retourconstructeur/nullfactory avec1225B04=2 PEinchangé intégré,99893sources/5613consommateurs,2fiches/2bases et donnéesmanuelles conservés. V704 sourceactuelle exécutée/revue mais associations àfaire :Cargo metadata locked/offline Windows résoutBevy/bevy_internal/bevy_render0.19.0 etwgpu/types29.0.4,bevy_render=vendorlocal. Onzeancrages ferment la chaîne source mainDefaultPlugins→macro plugin_group_default→RenderPluginDefault→insert_future_resources→RenderCreationAutomatic(WgpuSettings)→create_render→initialize_renderer ;sourceNonebackends refus explicite. Aucunrenderer/defaultsettings/GPU/compilation exécuté ;featuregraph=unionworkspace,pasfeaturesbinaireréel. Cinqrefuslecteur et5refuschaîne ;premieréchec syntaxe macro2/3colon code1 conservé,puis lecteurdistinct0. Ancremain651existante àrôlematériau conservée :nepasréécrire/promouvoir globalement ce rôle pourbackend. Intégrer V704 avec rôles précis/références parscope et questionouverte historisée,puis qualifier producteursnatifs9B3D00/9C1430,callers9B6506/9C40A4 etordrestartup sansforcerbackend ouinventermapping0/1/2verswgpu. Suitecréationnormale/inscription978820/ownership/nomportrait/UV/couleur/sampler/transportactuel etcleanup. Acquis/résidus83 nonacceptés/alphaopaque/DLL2014/Kalista288octets/12noms ouverts conservés. Avant toute prochaine préparation,vérifier la réserve de4GiB surF et le scratch privé ;si nécessaire,rechercher une ancienne copie de test,vérifier ses reçus et sa fermeture,puis la compresser sans perte. Aucune suppression ou case promue. Goal actif,aucun écran/jeu accepté.
