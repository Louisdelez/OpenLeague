# SYS-01.2-02 — sources de la configuration spawnmist, V352

Cette livraison intègre seulement l’association des captures de configuration aux deux corps actuels Profile::from_documents et HostSource::new, pour SYS-15.1-02 et SYS-01.2-02. Aucun autre lecteur ou groupe d’effet n’est implicitement qualifié.

Référence : PUBLIC 4.20.0.315 / Releases/4.20, EUW / en_GB, build du 2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Dépôt F:/OpenLeague ; travail privé F:/OpenLeague-work ; E conservé.

## Qualifications et étapes distinctes

V348 primaire est conservé avec son FINAL V2 autoritaire, SHA3a2ee29e5953d3e79cb0e6586a74ee7613b7520351bf140352cdb8671ec10226. Source :248 contrôles, puis34 contrôles de lookup séparés ; le premier refus d’ancre et les annotations V1 corrigées restent dans les preuves. Deux booléens par définition donnent quatre occurrences, pas six. Les62 assertions de scellement et43 rechecks du V2 ne sont pas ajoutés au compteur source.

V350 est une qualification fraîche par le même auteur, sans revue tierce indépendante. FINAL28fda7802fd8aba6ac3eb78421bc3b19311367c28f6b3a248a7d0eea17fb4a1c, propres codes outil / sous-processus / collecteur0. Ses184 contrôles comprennent179 du rapport et cinq de finalisation ; les82 assertions de scellement restent séparées. 31 identités uniques sont rehashées au sceau ;29 entrées à trois champs forment la proposition de sources. Quarante ancres et quatre définitions de tests sont source-only. Le refus de mapping partagé PRIMARY2f0, code1, reste conservé ; une observation avec deux usages remplace le faux doublon.

Le FINAL et la projection V350 gardent registration_ready=false. L’auteur a confirmé que ce verrou sépare la qualification source de la future étape de publication : aucun manque indispensable n’est identifié pour la seule association bornée Profile91 / HostSource13. Une nouvelle assemblée de publication doit passer ses propres vérifications ; elle ne change aucun flag historique de factory, device, trigger, provider, getter, FP ou GPU.

Le gate précédent est le FINAL indépendant V347, SHAfa430e408130e0dae2192bf6f3acd58cd8231bd92ae806751f798f262d14c72f, propres codes0,1 149 contrôles et compléments séparés. Son annexe publique et les octets exacts pré-annexe sont conservés ; ce gate n’exige pas l’ancienne empreinte de la preuve publique courante.

Le préflight et la simulation pure V352 ont réellement passé, code 0 : 456 contrôles, dont 403 source et 53 de continuation, avec 34 identités ciblées, 40 ancres et quatre définitions de tests source-only. Les contrôles statiques 59 puis 12 et les deux nominaux / quatre refus de sélecteur / quatre refus supplémentaires du contrôle pur restent des étapes séparées. Le FINAL scellé a pour SHA7e00edc4bd197d4c344e929ff70eb7e8107d000377cc3e18acff27fdb314380a. Le rehash est ciblé et aucune base n'a été ouverte pendant cette préparation.

Le lookup global current/history/origin confirme les deux captures sans nœud exact. Les deux définitions F existent déjà avec leurs identités exactes et restent du contexte : aucun nœud de définition ajouté. Les deux sources des corps et les natifs existants sont réutilisés. Le lecteur privé V1 a refusé sa comparaison trop large de primary_parameters ; la correction limite la comparaison aux clés effectivement sélectionnées, sans transformer cette erreur privée en défaut produit.

La revue root a demandé un garde explicite sur le résultat de validation structurelle avant la mutation. La validation existante levait déjà TraceError en cas d'écart structurel ; ce garde est une clarification défensive. Un import contextlib manquant dans le helper DB V2 a aussi été trouvé et corrigé dans V3 avant tout import ou exécution root. Les versions initiales restent conservées ; les versions finales V3 épinglées par le FINAL sont celles relues et exécutées. La readiness appartient à cette nouvelle assemblée après ses propres contrôles et ne change pas celle V350.

La valeur locale 1 construite lorsque la courbe capturée est null reste une convention du code courant. Le commentaire de source ne qualifie pas un default natif effectif.

## Entrées exactes et nature des preuves

Deux captures courantes : data/4.20/spawn_mist/Order_Spawn_numeric_factory_v5.json et Chaos_Spawn_numeric_factory_v5.json, chacune101 301 octets. SHA Order76eda2fa8f18be3a75621900f906e50f78fc9e6d6353405f144c0bb2d39cc427 ; Chaos8017b4eb314d7ace51ce77f0eb2ee36d4a649d727aef60d1731bc70d6199659b. Ce sont des reference_inputs de captures héritées, pas les octets TROY ni un nouveau résultat d’exécution.

Les TROY natifs Order_Spawn.troybin,1 248 octets, SHA1abb1ad92caeed5e2d8370521ebf3e35408149c896392ac57f646f4e2e3b0caf, OLS-61c6bc7f-cd6e-5499-855f-9bbbadd84484 ; Chaos_Spawn.troybin,1 210 octets, SHAc63ba252d64b3ed39e331eea0bc73d2636778d06328f27180b339696d419306e, OLS-39fd87b5-24b4-59d7-9f7c-61eddeee258b, sont les entrées historiques des captures numériques. Leurs 58 champs restent du contexte, sans devenir58 liaisons de getters effectifs nouvelles.

Le PE natif15 973 880 octets, SHA402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, OLS-0d51b5dc-fb9b-51dc-b32f-f9afdb925d39, identifie le producteur historique. Les adresses910EB0 /933000 et le script probe_numeric_sources.py SHA b05f6fbd6f123719732b8a154dc2d014aed96f2fe0fee6361f3a179006cca343 restent des preuves héritées, sans réexécution. Acquisition98A7F0/null et chemins915B00/915F80 différés restent des bornes.

Les définitions courantes map10_particles/definitions/Order_Spawn.json (41 105 octets,SHA63a412b19e9f9d46d8ce09530aa844192a032faffd695a3e9c7aa238be788de2) et Chaos_Spawn.json (40 454 octets,SHAed4523a7e82b68be76489ae9c76aa258d72314ba26774854d7cf5319c585b130) sont aussi lues par Profile. Leur identité et leurs anciens crédits sont préservés ; la portée V350 reste celle des captures numériques. Les copies E de ces captures sont physiquement distinctes et ne deviennent pas deux nœuds JSON courants supplémentaires. V196 resources145/146/407/408 couvre déjà les contenus et includes ; aucun manque d’implémentation n’est déduit de l’absence d’un nœud exact.

## Deux corps actuels, 72 observations et 74 usages

Profile::from_documents, crates/client/src/spawn_mist_sources.rs:91, sourceF OLS-e7e63515-dca4-5c31-91bb-149665c2d7de,12 378 octets,SHA74667ee6d4d983b3fcfb58dc36c7e48788876592f6eb965fc8fe9337ad839988, lit la définition et la capture. Il vérifie passed, la relation source_profile_sha256 / source_sha256, choisit le premier cas effect / mist / provider correspondant, garde des valeurs et construit une Factory à110. Il n’existe pas de symbole Factory::from_documents. Les métadonnées de SHA du PE/probe, chemins et flags complets ne sont pas une vérification d’identité runtime de tous les fichiers.

HostSource::new, crates/client/src/spawn_mist_host.rs:13, sourceF OLS-567e60ea-d2da-5ff0-a794-de66b29404c9,7 389 octets,SHA2d19e83f3038a031439c2fe40d397ccd7fcd8dc55a07be7bd1160cb09a5a3328, lit cinq scalaires PRIMARY2f0/2f4/314/334/33c et deux mots PRIMARY478/45c du même cas pour le contexte d’instance. PRIMARY2f0 est partagé avec la garde de durée Profile130 ; il reste une observation avec deux usages, pas un champ dupliqué.

72 observations ou sélecteurs se répartissent en74 usages de corps, dont14 HostSource pour les deux côtés. Ce ne sont pas72 drivers. F0/22C restent des objets capturés par offsets ; leur rôle n’est pas transformé en producteur d’horloge d’atlas. L’atlas courant lit nested04/08/0C ;474 est la shape scale. Des flags, pointeurs et champs conservés sans usage ordinaire sélectionné gardent cette qualification limitée.

local_configuration:87 est du câblage, pas un troisième lecteur. La route main/plugin/initialize:119 appelle local_configuration:122 avant le contrôle RenderDevice:123 ; Profile:99 et HostSource:104 sont appelés avec provider=false, deux cas sélectionnés et deux provider=true non sélectionnés. Catalog/placement, géométrie, ressources, session/modèle, horloge canonique, images/FoW et publication ultérieure ont leurs propres gardes. La configuration/images/state n’est insérée qu’après succès complet de initialize. Cette lecture de source ne démontre pas une activation ou un rendu observé.

Le code reconstruit un acteur statique local, avec politiques explicites. Les ressources originales fogcircle.sco / TT_Mist_circle.tga manquantes, géométrie/diffuse reconstruits et ordre historique de tous les FX restent distincts. Booléens JSON, entiersuint32 vérifiés, réinterprétation f32, bas octets, casts u8/i32 et préfixe soft sont des règles courantes ; aucune nouvelle preuve de getters, defaults, contexte FP ou fournisseur historique effectif n’est créée.

## Publication et contrôles

Le registrar root puis l'audit de livraison ont réellement terminé avec le code 0, selon ROOT_EXECUTION_RECEIPT.json. L'audit vérifie 403 contrôles source et 34 identités ciblées ; 40 ancres et quatre définitions de tests sont inspectées seulement. Deux sélecteurs nominaux passent ; quatre sélecteurs incorrects et une association sans les deux corps sont refusés.

Le delta exact ajoute 18 sources et deux corps, dont deux nœuds de capture JSON, aucun nœud de définition et un reçu public normalisé avec deux associations. Les 98 498 anciennes sources et 2 401 consommateurs restent exacts ; leurs liens, scopes, flags, assessments et questions sont conservés. Les autres tâches, dont R-VFX, sont identiques. Les quatre sauvegardes brutes permettent la reconstruction intégrale du delta.

Les deux bases physiques distinctes ont été contrôlées en lecture seule avec les vrais Store.task/copy_text/resolve : deux fiches enrichies chacune, 42 606 états manuels et 23 historiques exacts, notes et copies complètes préservées, integrity_check=ok. Aucune coche ou acceptation n'est ajoutée.

La publication est séquentielle, avec un reçu public, trois remplacements JSON optimistes et deux transactions DB distinctes. Elle n'est pas une transaction globale. Toute erreur réelle doit arrêter le travail et préserver l'état observé, sans relance automatique du registrar. La preuve brute après registrar est copiée avant l'audit, avec ses octets exacts.

## Fichiers et suite

Fichiers intégrés : docs/reference_spawn_mist_configuration_sources/spawn-mist-configuration-v352.json, docs/fidelity_spawn_mist_configuration_graph_v352.json, présent rapport, trois registres et les deux bases. Couverture, plan et reprise sont actualisés. Sauvegardes et reçus root : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision352.

Graphe structurel : 98516 sources / 2403 consommateurs ; 25321 questions ouvertes et 5517 résolues. Ces nombres ne signifient pas que tous les fichiers ont été fraîchement rehashés.

Suite : préparer V353 Nexus Idle depuis le FINAL V351 acquis, avec un corps partagé et trois cibles, chaque WORLD limité à son côté et le goal en union. Le FINAL V351 conserve registration_ready=false comme séparation d'étape ; sa topologie GLB courante ne qualifie pas SKL, provider/getter/FP, animation ou GPU. V354 examine un prochain groupe Nexus sans mutation publique.

Les chemins publics intégrés sont docs/reference_spawn_mist_configuration_sources/spawn-mist-configuration-v352.json, docs/fidelity_spawn_mist_configuration_graph_v352.json et docs/FIDELITY_SPAWN_MIST_CONFIGURATION_GRAPH_V352.md. Les codes root et ajouts réellement observés sont détaillés ci-dessus. Aucun nouveau test Rust/build/natif/GPU/générateur revendiqué par cette livraison ; aucune question, coche ou acceptation n’est résolue. SYS-01.2-02 et le jeu restent ouverts. Le candidat d’archive SYS-03.4-07 reste inconnu ; AnvilKit piste seulement.

## Revue de livraison V356

Le FINAL indépendant de livraison V356 est acquis, propres codes outil/sous-processus/collecteur 0 (session 1939, retour ab1df9) : 314 contrôles sans erreur, 33 identités source / 63 observations de fichiers, 40 ancres et quatre définitions de tests source-only. Les 61 assertions de scellement restent séparées. Deux sélecteurs nominaux et six refus (schéma, forme, tâche étrangère, croisement, corps et union incomplets) ont leurs résultats attendus.

Le delta 18/2, les deux tâches enrichies, tous anciens préfixes/liens/scopes/flags/assessments/autres tâches et les octets du registre d'inconnues sont exacts. Les deux bases strictRO et les vrais Store.task/copy_text/resolve conservent chacune 42 606 états, 23 historiques, notes et copies complètes ; integrity_check=ok. Aucun blocage produit n'est relevé.

Cette indépendance porte sur la livraison V352, dont l'auditeur n'est pas auteur. La qualification source V350 a le même auteur ; aucune revue source tierce supplémentaire n'est prétendue. Le wrapper privé V1 a refusé avec le code 1 faute d'argument ROOT, avant SQLite. V1/logs restent conservés ; V2 et ses noms globaux AST/symtable ont été vérifiés. Aucun registrar/audit root, test Rust, natif, GPU ou générateur n'est rejoué.

Reçus : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision356_independent_spawn_mist_configuration_delivery\FINAL_EXECUTION_RECEIPT.json ; F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision356_independent_spawn_mist_configuration_delivery\INDEPENDENT_SPAWN_MIST_CONFIGURATION_DELIVERY_REVIEW.json. Les octets publics exacts avant cette annexe sont préservés dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision352\pre-independent-link-versions. Le lien de revue ne modifie aucun registre ni aucune base, et n'accorde aucune acceptation du jeu.
