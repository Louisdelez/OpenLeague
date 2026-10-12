# Horloge native : préparation statique bornée

Cette préparation conserve les octets du PE 4.20 dont le SHA256 est `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Aucun code natif n'a été exécuté dans ce lot, aucun Rust compilé, aucune source de production modifiée. Les instantanés décrivent le code observé pendant cet audit, pas une garantie sur les modifications ultérieures.

## Producteur et ordre démontré

`993C70` consulte le byte `2D79080`. S'il est nul, il appelle `QueryPerformanceFrequency` par l'IAT `FA4180`, publie les deux mots dans `2D79158/5C`, puis écrit le byte à 1. Sinon il relit ce cache. Il écrit le mot bas de fréquence à `14BEF50`, initialise à zéro les deux mots temporaires du compteur, écrit le mot haut de fréquence à `14BEF54`, appelle `QueryPerformanceCounter` par `FA4134`, puis publie l'origine à `14BEF48/4C`. Aucun résultat BOOL Windows n'est testé. Le temporaire QPF n'est pas initialisé avant l'appel : une défaillance sans écriture ne permet pas d'inventer une fréquence déterministe.

`993CE0` construit une enveloppe callback sur la pile : vtable `10DE608`, première entrée `995850`, référence au pointeur `993C70`. `CE13E2` distribue via cette entrée. La fonction appelle `CE298A` avec le flag32 `2D75530`. Après le once, elle initialise un compteur local à zéro, appelle QPC, soustrait l'origine en `SUB/SBB` modulo 2^64, convertit séparément les 63 bits bas et le bit haut de chaque entier unsigned en x87, puis divise. Le résultat reste dans ST0. Aucune pause, échelle du jeu, ni création d'origine supplémentaire n'intervient ici.

## Deux niveaux de synchronisation

`CE298A` appelle `CE5247(&14AF61C, CE2961)`, prend le mutex référencé par `14AF620`, teste le flag32 fourni, appelle le callback s'il vaut zéro, écrit le flag à 1 après le retour, puis déverrouille. `14AF61C` est bien un byte ; `14AF620` est un pointeur de 4 octets.

`CE5247` initialise une CRITICAL_SECTION à `14B1844` avec un spin de 4000 et flags 0, via `CABD7A`. Le flag32 `14B1840` utilise XCHG et les états 0/1/2 ; les concurrents attendent via `Sleep(1)`. La fonction enregistre `CE52C1` comme nettoyage, entre dans la section, teste le byte fourni, appelle le callback puis écrit le byte à 1, et quitte la section. La section PE32 occupe 24 octets. Les données opaques de la section hôte x64 ne doivent pas être copiées dedans.

`CE2961` alloue le mutex par `CE28CF(&14AF620, 1)`, puis enregistre `CE2955`. `CE28CF` efface d'abord le pointeur global, appelle `calloc(1,44)` via `CA8673`, initialise les 32 octets internes par `CBE86C`, écrit propriétaire `FFFFFFFF` à +24 et type 1 à +00, puis publie le pointeur. Sur allocation nulle, il retourne 1. `CE2961` suit alors la voie d'échec `CE13ED` ; ce lot n'en porte pas la fermeture CRT.

`CE290B` appelle `CE2702` avec timeout nul. Pour le type 1 effectivement construit, le chemin consulte le thread courant, appelle `CBEE12` seulement si nécessaire, puis incrémente +28. `CE2934` décrémente +28 ; à zéro il remet +24 à FFFFFFFF et appelle `CBEEED`. `CE2955` appelle `CE289E`, qui détruit l'objet interne par `5642D0` et libère par `C98528`. Ces primitives de concurrence interne ne sont pas assimilées à une CRITICAL_SECTION arbitraire : leurs corps externes restent des dépendances non qualifiées.

## Régions et frontières

Les données propres au producteur sont `14BEF48`/16, `2D79080`/1, `2D79158`/8, `2D75530`/4. La route callback utilise seulement les 4 premiers octets à `10DE608`. Le once ajoute `14AF61C`/1, `14AF620`/4, `14B1840`/4, `14B1844`/24. Les régions existantes couvrent déjà le cookie `1222ED0` et la case de dispatch encodée `2DA5310` utilisées par `CABD7A`.

`clock_sources.json` contient, pour chaque région, adresse, taille, octets, SHA256, section, offset fichier et éventuelle portion zéro du chargeur. Les IAT sont vérifiées par la table d'import du PE ; leurs octets initiaux ne sont pas des pointeurs Windows hôte. La liste `external_direct_targets` expose les sorties de ce périmètre borné, notamment allocation/libération, atexit, mutex interne et voie d'échec. Leur présence dans un désassemblage ne vaut pas port ou test d'exécution.

## Réutilisation dans le projet

`native_game_clock::wall_sample(counter, origin, frequency)` conserve la conversion unsigned et la division sur x87 puis stocke f32. C'est un candidat pour le résultat stocké du consommateur, sous son contrat actuel : architecture x86/x64, fréquence non nulle et contrôle x87 037F imposé temporairement. Il ajoute deux soustractions de zéro, et ne reproduit pas tous les flags d'exception x87. Le natif ne fixe pas le contrôle x87 dans 993CE0 ; il faut qualifier le domaine de contrôle retenu et éviter un quotient intermédiaire f64.

`audio_crt_static_lock_startup` porte déjà la sélection du dispatch `CABD7A` dans la boucle de démarrage des verrous, mais n'expose pas une fonction générale autonome pour ce once. `audio_crt_windows_critical_sections::Bank` possède de vrais objets Windows stables et fournit initialize/enter/leave/delete par référence canonique. Il convient au niveau extérieur CE5247, après raccordement et qualification de l'ordre, de la publication et du nettoyage. Les régions opaques hôte restent privées au Bank. `audio_crt_heap::{calloc,free}` et son adaptateur ProcessHeap peuvent servir à l'allocation de 44 octets ; cela ne qualifie pas la dépendance mutex interne. Aucun producteur complet 993C70/993CE0 ni once CE298A/CE5247 n'a été trouvé dans Bridge ou le CRT.

Les preuves antérieures `probe_native_qpc_resync.py` et `native_qpc_resync_progress.json` qualifient une arithmétique composée ; elles contournent CE298A et injectent origine, fréquence et compteur. Elles ne valident donc pas l'initialisation réelle décrite ici. Les reçus historiques sont conservés comme tels ; leurs hashes de source anciens ne certifient pas les sources courantes.

## Une origine commune pour les deux consommateurs

1. Le consommateur de chargement `audio_loading_screen_packet::receive` demande les bits f32 de 993CE0 et les écrit à record+48 sur la branche tutoriel après un nom non vide. La source standard 57D6CB reste une continuation UI séparée, non portée par cette interface. L'adaptateur `audio_replay_windows_loading_metadata::loading_clock_f32_bits` retourne actuellement une erreur explicite.
2. Le client `native_effect_clock` utilise QPC/QPF, mais son `EffectClock` possède une origine privée créée lors du premier `First`, avec QPC avant QPF. Son `now` dérive de GameClock/TroyClock et subit pause et échelle. Ce champ n'est pas le temps mural 993CE0 et ne peut pas alimenter le chargement.

Le prochain port doit posséder une seule origine QPC et une seule fréquence, publiées dans la banque canonique partagée, avec le once et les durées de vie correctes. Les consommateurs de chargement et d'effets doivent demander des échantillons à ce même producteur. La couche GameClock continue d'appliquer pause/échelle uniquement après le temps mural. Ne pas créer d'Instant::now, de seconde origine dans Application/Bridge, ni de zéro de succès pour contourner une absence de branchement. Il faut également éviter que deux chargements indépendants de l'image initiale créent deux époques concurrentes.

Avant raccordement : oracle du premier appel et des appels répétés, cache QPF déjà initialisé, ordre des appels/écritures/atexit, allocations et destruction, appels concurrents et réentrants, échecs des frontières avec libération des verrous sans masquer une seconde erreur, arrondi x87 physique et lecture cohérente des deux mots. Les erreurs OS sans sortie native déterministe doivent rester explicites. La synchronisation d'accès à la banque doit être conçue sans tenir un verrou de map non réentrant pendant un callback qui la réutilise. Les sections Windows doivent conserver leur stockage physique jusqu'à la fin du dernier utilisateur ; les références logiques32 ne sont jamais tronquées depuis des pointeurs hôte64.

La solution sûre de ce lot reste l'erreur explicite existante. Cette archive est une préparation vérifiée par octets ; elle ne fournit pas un compteur opérationnel ni une qualification d'écran de chargement complet.
