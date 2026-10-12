# Producteur d'horloge natif — lot scratch gelé

État : **oracle natif exécuté et calcul x87 recoupé sur CPU ; Rust non compilé, tests Rust non exécutés, aucune intégration Windows/client**. Le pipeline de compilation du root interdit ici toute compilation Rust. Le port est une proposition à compiler et à comparer aux oracles avant intégration.

## Preuves réalisées

PE original vérifié avant et après l'oracle : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

`native_clock_results.json` contient 253 séquences, 349 appels natifs et 3 387 événements ordonnés :

- 72 appels directs de 993C70 : cache vide/non vide, flags1/255, BOOL0/1/FFFFFFFF, sorties complètes/partielles/absentes, pile contrôlée0/A5.
- 96 séquences de deux appels 993CE0 : flags once0/1/2/FFFFFFFF, cache indépendant, publication une fois et appels répétés. Les vrais CE298A, CE13E2 et995850 exécutent le test, le callback et l'écriture du flag.
- 84 appels couvrant conversion unsigned, soustraction modulo2^64, fréquences0/1/3/10000000/grandes valeurs, limites2^24/2^53/2^63/2^64.
- Un appel dans lequel la frontière QPC modifie origine/fréquence avant le retour : le natif les relit après ce retour.

`clock_x87_hardware.json` recoupe les 277 sorties f32 produites par 993CE0 : **277 identiques, zéro divergence**. Un fragment x64 local exécute les mêmes instructions x87 sur les quatre qwords de conversion ; il ne réimplémente pas les appels Windows ni les verrous. La page exécutable appartient au processus Python et est libérée en fin de test. Aucune injection dans un autre processus, aucun compilateur utilisé.

Les imports QPC/QPF reçoivent des réponses déterministes et des masques d'écriture de bytes. Leur BOOL est observé puis ignoré conformément au PE. Pour QPF qui n'écrit pas tous les octets, le reste provient de la pile native contrôlée de l'oracle : cela n'autorise pas à inventer ces mots dans un adaptateur Windows. Un adaptateur incapable de connaître les huit octets finaux doit retourner une erreur de frontière.

## API proposée

`audio_native_process_clock.rs` expose :

- `initialize(b)` : port993C70, écrit le cache et l'origine dans le stockage canonique fourni.
- `ensure_initialized(b)` : ordre CE298A spécialisé à ce callback, y compris flag et vtable ; la préparation et les opérations de mutex restent explicites.
- `sample_f32_bits(b)` : QPC puis lectures canoniques dans l'ordre source et stockage final f32.
- `divide_to_f32_bits(elapsed, frequency)` : conversion unsigned et division x87 sans intermédiaire f64.

Le `Boundary` requiert lecture/écriture byte/word de la banque canonique et sorties explicites `Query { return_value, words }` de QPC/QPF. Le tampon QPC fourni est toujours `[0,0]`. QPF n'a pas de zéro implicite : la frontière fournit les deux mots finaux connus ou échoue.

`enter_once()` représente CE5247(&14AF61C,CE2961), puis CE290B(&14AF620). `leave_once()` représente CE2934. Ces méthodes retournent une erreur par défaut : aucun faux verrou ni faux succès de production. Le test natif remplace exclusivement ces trois fonctions de synchronisation par des frontières réussies ; **allocation du mutex, concurrence, atexit et durée de vie ne sont pas qualifiées**. Le code original CE298A et les trampolines restent réellement exécutés dans l'oracle.

Les erreurs de lecture, callback inconnu, API indisponible ou publication entraînent toujours la tentative de déverrouillage après acquisition réussie. Une seconde erreur est conservée dans `Error::Cleanup`. Les écritures partielles déjà réalisées restent présentes ; elles ne sont pas arbitrairement annulées. Ces erreurs de frontière sont une adaptation Rust contrôlée, pas une prétention à porter le déroulement d'exception C++ complet.

## Tests Rust préparés, NON EXÉCUTÉS

Quatre tests sont fournis avec `clock_harness.rs` et `audio_native_process_clock_tests.rs` :

1. 253 séquences, 349 appels, tous les octets globaux et les 3 387 événements comparés à l'oracle.
2. 277 sorties comparées au calcul physique x87, y compris fréquence zéro.
3. Échec QPF + déverrouillage, écriture partielle du cache et échec de publication : conservation des deux erreurs et absence de flag de succès.
4. Échec d'acquisition, lecture du flag, callback inconnu et lecture après déverrouillage : vérification de la durée du verrou et absence d'appel indu.

Après autorisation du root uniquement : compiler le harness avec `rustc --test --edition=2021`, les dépendances `serde_json` déjà construites et le répertoire `target/debug/deps` de production en lecture. Le présent reçu ne déclare aucun résultat de ces tests ni aucune validation syntaxique par rustc.

## Calcul et limites x87

Le domaine qualifié est le contrôle x87 **037F** : masques d'exception actifs, précision étendue et arrondi au plus proche. Le port sauvegarde et restaure le mot de contrôle du caller ; il ne sauvegarde/restaure pas le mot de statut, les indicateurs d'exception ni tout l'environnement x87. La fréquence zéro donne les bits infini/indéfini natifs sous ce contrôle, sans transformer cette entrée synthétique en fréquence Windows plausible. Un autre contrôle caller, ou la réactivation d'exceptions non masquées après une opération invalide, exige une qualification distincte. Ne pas qualifier le comportement complet des exceptions à partir de la seule égalité des sorties f32.

Le helper existant `native_game_clock::wall_sample` refuse fréquence0 et inclut deux soustractions de zéro ; il n'a donc pas été substitué au chemin exact de cette proposition. Il faudra choisir une seule primitive arithmétique partagée lors de l'intégration en préservant les contrats existants, plutôt que créer deux producteurs temporels.

## Raccordement unique restant

L'audit statique gelé dans `E:/mapslol3v3/loading_clock_preparation` reste la référence de toutes les dépendances et régions. Les octets des cinq fonctions réellement exécutées et leurs empreintes sont recopiés ici dans `source/`. Aucune région n'est ajoutée à la production dans ce lot.

Le chargement doit recevoir ce temps mural brut. `EffectClock.now`, sensible à pause/échelle et fondé actuellement sur une origine privée, ne convient pas. Le raccordement futur doit publier une seule origine et une seule fréquence dans la banque canonique partagée, puis faire demander des échantillons par les consommateurs chargement et effets. Les couches GameClock/TroyClock restent après ce producteur. Ne pas ajouter `Instant`, réinitialiser l'époque dans un Backend ou conserver deux copies mutables indépendantes des globals.

La banque Windows de sections critiques peut servir au niveau extérieur CE5247 ; le mutex interne reste une dépendance réelle distincte. Aucun adaptateur Windows, changement du producteur client ou raccordement à l'écran n'est réalisé. L'erreur explicite de production demeure la bonne limite actuelle.
