# Raccordement client de l'horloge canonique — stage non compilé

Proposition de code et d'intégration, sans compilation, sans test exécuté et sans changement de production. Les anciennes préparations restent gelées. Le producteur Windows et le mutex ConCRT appartiennent aux lots du root et de l'autre agent ; leurs frontières ne sont jamais remplacées ici par un faux succès.

## Propriété observée

`main.rs` construit une seule `audio_replay_windows_application::Application` dans `attach_native_replay_runtime`, avant le plugin d'effets. Le service configuré depuis Game.cfg est attaché à son Runtime, puis Application est insérée dans Bevy comme ressource NonSend. Aucune nouvelle Application n'est nécessaire.

Application possède Runtime et Bridge et partage le CRT Root par Arc. Runtime possède `Arc<Shared<N>>`, dont `bank: Mutex<Bank>` contient les globals canoniques et `launch: Mutex<bool>` garde la durée de vie. Le CRT possède une autre banque explicite dans `Root.context`, non réentrante sur un même thread. Affecter chaque global horloge/once à son propriétaire exact ; ne pas publier l'origine dans les deux banques. Le Backend actuel verrouille brièvement la banque et la relâche avant les attentes Windows.

EffectClock possède actuellement origin/frequency privés et appelle QPC/QPF directement. Il définit l'origine au premier First. Son `now` est issu de GameClock/TroyClock : pause et scale le modifient. `start` est le précédent instant mural de frame, pas une origine QPC.

## Chaîne unique

Le root fournit `audio_native_process_clock::{RawSample { counter, origin, frequency }, sample_raw}` et `clock::Boundary for Backend<N>`. Le sample exécute l'initialisation canonique puis un seul QPC et lit les mots d'origine/fréquence dans l'ordre natif.

| API proposée | Rôle |
|---|---|
| Runtime::clock_handle | Clone Arc seulement, vérifie launch/closed ; aucune initialisation temporelle. |
| ClockHandle::raw_clock_sample | Prend launch, refuse closed, appelle le Backend de la même banque. |
| Runtime::raw_clock_sample | Même chemin public, sans acquisition imbriquée de launch. |
| ClockHandle::wall_clock_f32_bits | Convertit le même RawSample ; aucun second QPC. |
| Backend::raw_clock_sample | Appelle le port générique ; ne reprend pas launch. |
| Backend::native_clock_f32_bits | Même producteur interne, conversion finale f32. |

Le chargement appellera `self.native_clock_f32_bits()` depuis `Backend::loading_clock_f32_bits` après qualification Windows. Cette entrée est atteinte sous launch depuis receive_game_event. Appeler l'API publique du handle à cet endroit reprendrait le Mutex non réentrant et bloquerait.

ClockHandle possède seulement `Arc<Shared<N>>`, aucun compteur, cache temporel ou Instant. Son Clone manuel ne demande pas N:Clone. Le client conserve ce handle, GameClock/PauseControl et le dernier instant de frame.

## Stage client

`build_client_stage.py` génère `native_effect_clock.rs` depuis le snapshot exact. Les fonctions QPC/QPF et champs origin/frequency privés disparaissent. Chaque calcul demande un RawSample partagé. Les fonctions existantes frame_delta, wall_sample, PauseControl et TroyClock gardent leurs opérations ; aucun quotient mural f32 n'est converti en f64 avant une soustraction qui doit rester x87.

Les opérations PauseControl à deux compteurs demandent deux échantillons distincts et vérifient l'égalité d'origine/fréquence ; une divergence est une erreur explicite. Le nombre de lectures du client est conservé : trois par frame après la première, trois pour pause, deux pour reprise. Cela ne qualifie pas la planification de l'ancien client : First/Bevy reste une adaptation à valider contre58D550/586350.

Au premier First, start reçoit wall_sample(sample.counter,sample.origin,sample.frequency), pas arbitrairement0. Si le chargement a déjà utilisé l'horloge, cette règle conserve l'origine et évite de compter le chargement écoulé comme delta de jeu. game.time/now restent initialement0. reset_session ne recrée ni handle ni producteur.

`client_attach_excerpt.rs` ajoute le handle et EffectClock configuré à la fonction qui possède déjà Application. `Plugin::init_resource` conserve cette ressource. Default reste sans source et échoue si on tente de l'avancer : il ne crée jamais silencieusement un owner supplémentaire.

## Durée de vie et verrous

Application::close appelle Runtime::shutdown, retire Runtime/Bridge puis ferme le CRT Root. Le sample public détient launch jusqu'à la fin de l'acquisition du RawSample ; shutdown prend le même verrou. Un clone peut retenir les allocations par Arc après close, mais doit refuser les lectures et les QPC lorsque closed=true. Aucun Drop de handle n'initialise ou ne réinitialise le temps.

Le root doit raccorder le nettoyage source des deux niveaux de once après le dernier utilisateur et avant le retrait de leurs banques/verrous, en conservant les erreurs. En cas de shutdown partiellement échoué, une reprise sûre ou une erreur du producteur est nécessaire : ready ne justifie jamais l'accès à un mutex déjà détruit.

Ordre proposé : launch de durée de vie → préparation/once → courts accès bank. Ne pas garder le Mutex du bank pendant une attente ConCRT ou un callback qui le reprend. Root.context est lui aussi non réentrant ; aucune closure d'accès CRT ne doit entourer un callback qui y retourne.

## Tests préparés, NON EXÉCUTÉS

Les tests nécessitent la vraie Boundary Windows et le once qualifié, sans substitut de verrou réussi :

- Core : deux handles ont le même Arc ; le Backend chargement et les handles lisent exactement les mêmes adresses d'origine/fréquence ; once=1 ; les clones survivant à close refusent les lectures.
- Client : pause gèle le temps de jeu alors que le compteur mural avance ; scale et reset_session conservent origine/fréquence ; close interdit l'avance.
- Client : un consommateur précédant le premier frame ne provoque aucune nouvelle origine ni delta de chargement.
- Les tests existants du plugin reçoivent un owner explicite via install_test_clock. Le patch annie_ready_test.patch adapte uniquement l'installation de son test Windows.

Après raccordement : observer une seule publication/QPF malgré plusieurs handles ; compléter concurrence, teardown et fautes QPF/ConCRT avec absence de deadlock et conservation des erreurs. Ces preuves ne sont pas apportées par le présent stage.

L'agent de synchronisation identifie le mutex intérieur comme une file ConCRT avec scheduler/TLS et réveils virtuels. Une CRITICAL_SECTION arbitraire ne qualifie pas cette dépendance. **Ne pas basculer le producteur normal client vers ce stage tant que cette frontière échoue**, ce qui arrêterait les effets au premier First. Aucun compiler ou test n'a été lancé ici.
