# SYS-01.2-02 — Initialisation du renderer actuel : intégration V705

UTC : 2026-10-28T00:41:20.453451+00:00. Projet : F:/OpenLeague. Référence native : PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. Cette livraison relie V704 aux consommateurs réels du plan et à ses deux bases. Elle qualifie des sources d'initialisation, pas une exécution du renderer.

## Résultat et découpage des rôles

Onze ancrages sont conservés :neuf points de code reçoivent des descripteurs de consommateurs bornés et deux définitions de types restent des références. L'enum RenderCreation et la struct RenderPlugin ne sont pas présentés comme des consommateurs exécutés. La chaîne couvre DefaultPlugins,la macro construisant les plugins par défaut,RenderPlugin,RenderCreation::Automatic,WgpuSettings,create_render et l'appel initialize_renderer.

| Nouveau descripteur | Rôle précis | Fichier et ligne |
|---|---|---|
| OLC-218a7735-35c5-5f0b-b47b-8b8650451bdd | current_renderer_initialization_ordinary_client_default_plugin_group | crates/client/src/main.rs:651 |
| OLC-db965e70-0556-5202-904c-0480f0929bbf | current_renderer_initialization_resolved_default_group_render_plugin | C:\Users\loicd\.cargo\registry\src\index.crates.io-1949cf8c6b5b557f\bevy_internal-0.19.0\src\default_plugins.rs:44 |
| OLC-31fb80d9-b0a4-5954-befa-7ee10fd4daf5 | current_renderer_initialization_render_plugin_initialization_boundary | vendor/bevy_render/src/lib.rs:357 |
| OLC-f73b8217-e00c-58f5-b7ec-0ff06486aa23 | current_renderer_initialization_future_render_resource_creation_boundary | vendor/bevy_render/src/lib.rs:515 |
| OLC-4bcbe03d-6a20-5352-adfe-5e7f8019e5ff | current_renderer_initialization_default_backend_configuration_source | vendor/bevy_render/src/settings.rs:84 |
| OLC-191ba301-a7c2-5217-8f8f-59f11d3271d7 | current_renderer_initialization_plugin_group_constructs_default_plugin_under_feature_guard | C:\Users\loicd\.cargo\registry\src\index.crates.io-1949cf8c6b5b557f\bevy_app-0.19.0\src\plugin_group.rs:165 |
| OLC-80867013-8052-5068-bceb-56ad87bb7193 | current_renderer_initialization_render_creation_default_automatic | vendor/bevy_render/src/settings.rs:311 |
| OLC-0d497b0a-f91f-5c38-90d4-925fcb6f3749 | current_renderer_initialization_automatic_creation_source_refusal_for_none | vendor/bevy_render/src/settings.rs:271 |
| OLC-0a5cde4b-6931-5dd5-92aa-5e322d6ba4b3 | current_renderer_initialization_automatic_renderer_initialization_source_call | vendor/bevy_render/src/settings.rs:277 |

L'ancien descripteur OLC-55e55803-4c64-52ad-bed7-77fab28cc1c6 àmain.rs:651 garde son rôle matériau et ses qualifications. Le nouveau rôle d'initialisation au même endroit est borné séparément. Les huit autres descripteurs déjà vérifiés restent inchangés. Aucun code ou asset du jeu n'est ajouté ou modifié,aucune absence globale de consommateur n'est déduite.

## Versions, dépendances et provenance

La résolution verrouillée/hors ligne confirme Bevy,bevy_internal etbevy_render0.19.0 ;wgpu etwgpu-types29.0.4. Le patch bevy_render pointe sur la copie vendor locale. Le graphe metadata du workspace et les trois sorties CargoTree ciblant le client Windows,avec arêtes normal/build,sont conservés séparément. Ils ne prouvent pas les features exactes d'un binaire existant ou son backend/adaptateur effectif.

Deux contrôles nouveaux comparent src/default_plugins.rs de bevy_internal etsrc/plugin_group.rs de bevy_app aux membres des archives locales.crate. Le SHA-256 de chaque archive est égal au checksum de Cargo.lock ;les octets de chaque membre sont exactement ceux du fichier cache actuellement consommé. Aucune extraction ou substitution n'est faite. Les fichiers.cargo-checksum.json absents sont signalés ;cette comparaison explicite ne devient ni une vérification des crates installées entières,ni une authentification indépendante du registre distant.

## Intégration et conservation

SYS-17.3-01 et SYS-01.2-02 reçoivent 1 lien natif hérité et 54 sources nouvelles. Neuf descripteurs sont ajoutés uniquement au périmètre source du chargement ;les définitions de types sont des reference_inputs. L'évaluation entry_boundary_only reste explicite et ne revendique aucune fonctionnalité native complète.

OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec ancien texte et condition en historique. Elle reste ouverte,avec identifiant,propriétaire,aspects etstatuts conservés. Le graphe compte 99947 sources/5622consommateurs,42215exigencesactives,26189inconnuesouvertes/5517résolues antérieures. Les pins de cette livraison sont vérifiés ;ce compteur n'est pas un rehachage du catalogue complet.

Les deux fiches et bases ont été publiées puis auditées via les vrais Store/copy/summary/trace. Chacune conserve42605autreslignes,42607étatsmanuels et23historiques. Aucun prérequis levé ou case automatiquement cochée. IDS et ordre phases/lots sont byte-identiques.

## Vérifications, refus et résultats

Attendu/observé :sources présentes aux lignes citées,versions et patch résolus,anciens consommateurs byte-identiques,nouveaux rôles limités à leur contrat source et question ouverte. Six falsifications de mapping sont refusées :renderer prétendu exécuté,features binaires prétendues,mapping natif prétendu,type classé consommateur,rôle matériau historique promu etnouvelle frontière promue. Les quatre refus de provenance empêchent un mauvais checksum,membre erroné ou une vérification/exécution plus large que réelle.

Les cinq refus du lecteur V704 et cinq de la revue de chaîne restent des acquis distincts ;la première revue ne les multiplie pas artificiellement. Le candidat V705 refuse cinq mutations,réussit l'inversion documentaire exacte,l'inversion logiqueSQLite et l'idempotence.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V704_CURRENT_RENDERER_SOURCE | 0 | 1 | 78938de96187b7307ebabb5b423a1c4d11c45be1dd14f291c7244f8bf5fdabd6 |
| V704_CURRENT_RENDERER_SOURCE_CHECKED | 0 | 0 | c6029a99538ec5458a6886d119ee16a7ab298135fc34a336eb903cb3a304e8a7 |
| V704_RENDERER_SOURCE_REVIEW | 0 | 0 | b8c46bee4a8f6127ce2ef243e1357a6b211dfb810ff9e1dc4b4cf3deeb039cec |
| V704_RENDERER_CHAIN_REVIEW | 0 | 0 | 6629a3ee5d0fbe23b5036d828c7a49cc43875b043e3d682e3c46ee39fa60a121 |
| V704_CLIENT_FEATURE_TREE | 0 | 0 | 0e07fc8bc1938caa1168f4f89eef7f09ffe29919f36bd9a126c584876b5324d4 |
| V704_RENDERER_CHECKPOINT | 0 | 0 | 1bad6ad8b3fc5d59de6266a91e84dc43afa730554b6d95dd7a605a04dd72e604 |
| V705_CACHE_PROVENANCE | 0 | 0 | 70b7563cd9d48a1bc2a98d7e052232f3cfc9d0a603c74a526044311d4a03c1b8 |
| V705_ASSOCIATIONS | 0 | 0 | 4ec75b6b704bbd2a029d95e437362679bbcce467f010806736f4a87dbf7e3d9a |
| V705_STORAGE | 0 | 0 | d9c3366821cc230b79aa56235a4196db3687bcd0337c200c03c88d17921481f1 |
| V705_PREPARE | 0 | 0 | 6703f694e61d0a7285bd5d54d4ced405efe7db92dcd694772788f9321e7eb42a |
| V705_CHECK | 0 | 1 | 88a53d098d584b2281b661a3e2cbf2d4fb9faf763417ac2e6bb41f456ffee3d2 |
| V705_CHECK_JSON_CHECKED | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V705_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V705_DELIVERY_AUDIT | 0 | 0 | c00283f8e0999e5e6e1afb1014a8d7777ff4212518244f560149e8a3220a5a4f |

Le premier lecteur V704 s'arrête avec code1 car il cherchait une écriture double-colon dans une macro àtriple-colon. Source,log et métadonnées sont conservés ;un lecteur distinct utilise l'ancrage réel et réussit. Le checkpoint V704 a relu inutilement ses grands JSON par champ :il a terminé avec code0,mais le prochain checkpoint utilise une seule lecture avant comparaison. Cette lenteur ne change pas les résultats source ou les états manuels.

5 preuves historiques fermées et auditées sont compressées sans perte,avec taille/SHA etsidecars conservés. Aucune suppression ou base active touchée ;scratch privéF et garde4GiB maintenus.

Le premier check V705 s'est arrêté avec code1 avant publication :il cherchait le JSON compact du contexte dans le texte dont le JSON est indenté. Le contexte complet était déjà présent. Un vérificateur distinct décode le blocJSON et impose l'égalité exacte avec toutes les données reference_context et la sectionV705. Il préserve le premier candidatSQLite dans son état après échec et emploie une nouvelle copie candidate. Le reçu d'adoption piné conserve préparation,delta,snapshots,anciencode/log et candidat échoué ;aucun changement du consommateur produit n'a été nécessaire.

## Fichiers et limites

Rapport présent,preuve docs/fidelity_current_renderer_initialization_v705.json et reçu docs/reference_requirement_trace_sources/current-renderer-initialization-v705.json ajoutés. REG/TR/SRC/UNK actualisés,ainsi que les deux bases,couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF. Les sauvegardes et anciens champs sont conservés. V704 préliminaire garde son état daté ;V705 est son intégration ultérieure.

Lecteur :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision705_renderer_initialization_associations\OBSERVATIONS.json. Observation source :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision704_current_renderer_source_checked\OBSERVATIONS.json. Tous les scripts,reçus,journaux,archives et identités Cargo restent identifiés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun nouvel appel Rust/Defaultsettings/create_render,compilation,renderer,API/GPU,natif original ou frame n'est exécuté par cette association.

Le contexte natif V703 reste un retour constructeur avec1225B04=2PEinchangé,fabrique nulle,slot4C0 et8blocs328dont40nonclassé ;il ne prouve pas une texture créée ou un manager prêt. Restent ouverts :backend effectif et ordre de bootstrap natif,exécution normale actuelle,features du binaire,mapping0/1/2,création normale,inscription978820/signature/ownership,nom des portraits,UV/couleur/sampler,transport etcleanup. Les distinctions1225B04/1225C58/provider90AD00 etCString/FNV/hashfichier8E50F0 sont conservées. Anciensacquis/limitesARGB8/DXT,résidus83nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms préservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V705 a intégré/audité V704 :9nouveauxconsommateurs source du bootstrap graphique actuel et2références de types,Bevy0.19.0/wgpu29.0.4,patchvendorlocal,metadataoffline et3CargoTreeclientWindows. Deuxmembres cache externes exacts auxarchives locales/Cargo.lock ;pascrates installéesentières. Ancienmain651matériau et8descripteurs antérieurs inchangés,questionouverte historisée,2fiches/2bases et donnéesmanuelles conservés. Aucunrenderer/Defaultsettings/GPU/compilation exécuté,featuresbinaireréel etmappingnative0/1/2inconnus. Suite :qualifier leconsommateurRust réel deconfiguration/default/refusbackendsNone avecbinaire etfeatures identifiés,si entréesdisponibles ;conserver source/résolution/exécution séparées. Examiner également producteursnatifs9B3D00/9C1430 etcallers9B6506/9C40A4/ordrebootstrap sansforcerbackend ouinventermapping. NativeV703retourPE2/fabriquenulle resteacquis,pastexturecréée/managerprêt. Puiscréationnormale/inscription978820/signature/ownership,nomportrait/UV/couleur/sampler/transportactuel etcleanup. Acquis/résidus83nonacceptés/alphaopaque/DLL2014/Kalista288octets/12noms conservés. Réserve4GiBF/scratchprivé avantprepare ;vérifier fermeture/reçus avantcompression sansperte,aucunesuppression/casepromue. Pour prochains checkpoints lire chaqueJSON unefois puis comparer lesancienschamps,éviter la relecture par champ deV704. Goalactif,aucunécran/jeuaccepté.
