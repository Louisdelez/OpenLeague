# Port générique de90AD00 — lot cache

Le module `audio_loading_resource_cache.rs` porte `99A310` après son initialisation fraîche, le lowercase en locale C sur toute la longueur, `90D220/901F00` et la valeur empruntée des hits. Le miss est un `Outcome::MissFactory { manager, original_name, skin }` arrêté avant90B520. Aucun fournisseur n'est construit, simulé ou détruit par ce module.

API d'assemblage : `Boundary: owned::Boundary` ajoute `locale_is_default()->Result<bool,Error>`. Appeler `initialize_key(b,address28)` avant d'adopter `owned::Temporary::new_reset(address28)`, puis `resolve(b,manager,original_name,skin,&mut key)`. Le caller conserve le guard en tous cas et nettoie clé puis nom via l'extension Group2 du lot ownership. `resolve` ne consomme pas le guard, n'appelle pas de fabrique et ne libère rien. Le nom original reste intact. Un hit ne signifie pas que la continuation UI est disponible.

La copie utilise `assign_owned_non_alias` existant ; le scratch neuf est une précondition. Les trois lectures éventuelles du pointeur durant99A310 et le read de longueur gardent leur ordre source. Le locale flag est lu une fois par octet, y compris NUL interne/octet haut ; le nom vide ne le lit pas. Non-C localeC985D6 reste une erreur explicite après conservation du propriétaire.

La recherche conserve les relectures source : comparaison byte/word5FA6B0, duplication du comparateur dans la branche de noms différents, longueur key mise en cache, capacité initiale utilisée dans cette branche et capacité relue après chaque test nil, comparateur final901F00 et skin unsigned. Les adresses débordantes et cycles de l'arbre provoquent une erreur hôte explicite ; ce n'est pas une reproduction SEH. Panic/abort, mutations réentrantes arbitraires et callbacks de free à effet partiel restent hors du contrat atomique `release_owned` existant.

## Preuve native complémentaire

`extract_cache.py` lit le PE épinglé402bf2b9… et extrait neuf régions complètes (aucune edge hors fenêtre). `probe_cache_retirement.py` reprend le probe gelé sans toucher ses fichiers, en ajoutant des captures de lecture du lookup et des lectures/écritures/free564900. L'exécution Python/Unicorn a réussi : deux cycles manager, 66 hits avec tokens opaques et huit misses arrêtés avant le corps de90B520. Les 5 634 opérations de lecture lookup et338 opérations de retirement sont conservées dans `native_cache_retirement_oracle.json`.

En supprimant uniquement les nouveaux champs `detail`, le JSON étendu est strictement égal au JSON gelé `E:\OpenLeague\docs\loading_standard_resource_preparation\native_resource_oracle.json`. Aucun résultat de fabrique n'a été ajouté. Le cleanup des misses reste un appel natif séparé après abandon du frame, pas un retour normal simulé.

Le reset observé564900 est : lire capacité ; si heap, lire route globale14BEF40, lire pointeur, free ; écrire capacité15, longueur0, octet0. Les traces et les24 octets finaux sont comparés par les tests Rust, y compris les octets non réinitialisés. Le retrait peut être repris après échec du reset grâce à `Temporary::new_reset` ; le heap déjà libéré ne redevient pas autorité.

## Tests livrés, qualification Rust à effectuer par root

Les sept tests Rust couvrent66 hits et huit misses avec comparaison des lectures lookup, allocations, nom original, arbres inchangés, descripteurs et trace exacte564900 ; locale non-C/vide ; quatre échecs de publication de copie ; chacun des trois resets fallibles en SSO/heap ; deux frees simultanément échoués via Group2 avec erreur primaire conservée ; cycle de l'arbre et cleanup récupérable.

Le lot **n'a lancé aucun compilateur ou client**. La preuve native est passée ; les tests Rust sont préparés et non exécutés ici. Ils exigent le lot ownership (`Temporary::new_reset`, `Group`, `finish_group`) et la fixture ci-dessous. Root doit compiler et rejouer avant toute revendication d'intégration.

Installation prévue par root : modules/tests dans `crates/core/src`, déclaration `pub mod audio_loading_resource_cache;`, et copie de `native_cache_retirement_oracle.json` vers `data/4.20/loading_resource_cache_contract.json`. Le package initial, le manager et le ledger Windows sont fournis par les lots voisins. Aucune écriture production n'a eu lieu dans ce lot.
