# Propriétaires du nom et de la clé de cache

Préparation uniquement. Aucun compilateur, test Rust, client ou fichier de production exécuté/modifié par ce lot. Les huit nouveaux tests ci-dessous restent à compiler et exécuter par le root, avec le cache et le gestionnaire réels.

## API

- `Temporary::new(address)` conserve le destructeur standard sans remise à zéro. Les API et tests existants restent valables.
- `Temporary::new_reset(address)` adopte un String24 déjà initialisé et possède son nettoyage `564900`. `retire()` retire le buffer puis écrit capacité15, longueur0, octet0. Chaque étape réussie est conservée. Une erreur d'écriture garde le guard et sa lease, même lorsque `authority()==None`. Aucun nouvel accès au buffer retiré n'est nécessaire lors du retry.
- `Group<const N>` possède un tableau de guards réservé sur la pile. `vacant(index)` vérifie la place **avant** construction ; `Vacant::adopt(owner)` transfère sans opération faillible. `get_mut`, `get`, `remaining_count` et `retire` sont exposés. Le nettoyage essaie tous les slots en ordre inverse ; l'échec de la clé n'empêche pas le nettoyage du nom.
- `finish_group` renvoie `GroupFailure<N> { primary, cleanup:[Option<Error>;N], remaining:Group<N> }`. L'erreur primaire reste distincte des erreurs de nettoyage de chaque slot. Les retries rendent un nouveau tableau d'erreurs, sans effacer les premiers diagnostics.
- `loading::Boundary::initialize_standard_record_owned(..., owners:&mut Group<2>)` contient le nom dans le slot0 et réserve le slot1 à la clé. Son implémentation par défaut appelle l'ancien hook, qui reste présent. Si aucun deuxième guard n'est adopté, `receive` conserve exactement la variante `ReceiveFailure::Owned` existante. Sinon, il utilise `OwnedGroup`.

Les API explicites ne sont pas un remplacement RAII implicite : abandonner un guard ou son erreur sans les conserver est interdit par le contrat `must_use`. Panic/OOM/abort et destructeurs custom non atomiques restent hors qualification.

## Adaptateur Windows

La lease passe de32 à64 octets : nom24, paire8 du préfixe, clé28, padding4. Le slot du ledger, sa capacité, la lease complète et son maintien `Arc<Shared>` existent avant le consumer. Les deux guards sont installés dans la failure typée avant formatage. Le ledger compte aussi un guard qui ne possède plus de heap mais doit terminer les écritures de reset. Aucun recyclage ou retrait du maintien avant la fin de tous les guards et de la lease.

Le hook exécute le vrai préfixe. Un manager nul est refusé explicitement avant le cache : cette précondition hôte ne simule pas un chemin natif réussi. Avec un manager publié, il appelle `audio_loading_resource_cache::initialize_key`, adopte `new_reset`, puis `resolve`. La clé est nettoyée avant le nom. Un miss s'arrête devant `90B520` ; un hit reste emprunté et s'arrête devant la continuation UI. Aucun fournisseur fictif n'est créé.

Le root doit fournir le module cache, son `Boundary` Windows et le cycle de vie du manager. **Aucun patch transport/lib n'est demandé par ce lot ownership.** Le root intègre ses propres modules cache/manager et leurs déclarations séparément.

## Tests préparés

1. Deux erreurs de free simultanées, erreurs primaire/cleanup séparées, retry partiel puis final, aucune relecture du nom déjà retiré.
2. Échec de chacune des trois écritures de reset, en SSO et heap : six cas avec uniquement le stockage du descripteur restant à conserver.
3. Ordre complet clé/free/reset puis nom/free sans reset ; refus d'un slot déjà occupé et retry vide sans aucun effet.
4. Échec de copie avec trois allocations simultanées détenues par deux guards : nouveau buffer de clé, ancien buffer de clé, nom appelant.
5. Vrai consumer standard transmettant deux guards et deux erreurs de nettoyage. Ce test isole une frontière consumer injectée ; il ne prétend pas exécuter le cache natif.
6. Ledger Windows avec deux frees refusés, nom retiré lors du premier retry malgré clé refusée, fermeture en échec, lease non recyclée, deux frees uniques après réparation.
7. Ledger Windows avec reset partiel après libération des deux heaps ; maintien de la lease/Arc puis libération finale, sans second free.
8. Deux noms SSO/heap par le vrai manager Windows, service/index/métadonnées et packet95 jusqu'au miss90B520. Inspection séparée du même hook avant cleanup pour minuscule, skin13 et conservation du nom d'origine. Pas de hit Windows artificiel.

Les13 tests préexistants des trois fichiers de tests sont conservés. Leur seule assertion de modèle changée est le nombre d'octets de lease32→64. Le host de tests owned enregistre désormais les appels free et permet un refus atomique ciblé ; les comparaisons natives existantes ne sont pas retirées.

## Preuves et limites

Le nouvel oracle natif du cache, produit par l'autre agent, contient66 hits et8 abandons séparés de miss sur deux vies ; il établit le nettoyage `564900` et sa trace. Les tests du module cache comparent directement cette preuve à `new_reset`. Cette préparation ne transforme pas les tokens de cache opaques en fournisseurs réels, ni les abandons séparés en équivalence SEH.

La reprise après erreurs hôtes est une adaptation d'ownership. La séquence de succès de `564900` reste free éventuel puis reset capacité/longueur/octet. Les banques CRT et transport restent canoniques, sans pointeur hôte fabriqué. La banque est délibérément conservée lorsque la reprise reste impossible ; ce cas produit une fermeture en échec.
