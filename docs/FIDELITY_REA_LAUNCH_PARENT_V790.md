# SYS-01.2-02 — Parent du lancement audio et objets temporaires, V790

Projet : F:/OpenLeague. Fiche détaillée : SYS-02.2-07. Les nouveaux liens qualifient des parcours précis du parent audio et de son nettoyage. Ils ne clôturent ni toute l’exigence audio ni le goal.

## Source native et REA

Le PE x86 original League of Legends.exe est identifié par15973880octets et SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les huit liens natifs ajoutés réutilisent des sources recensées : PE, Audio.ini et six banques. Les octets originaux sont conservés. Une copie exacte isolée est analysée avec REA6.4.0, Ghidra12.1.4 et Java21.0.10 ; fichiers d’analyse sous F. Outil : https://github.com/morluto/rea.

| Fonction | Rôle observé | Instructions |
| --- | --- | ---: |
| 7067B0 | Parent qui choisit la branche liée ou temporaire et signale l’échec | 63 |
| 706850 | Post lié, callback704A40 et seek éventuel | 80 |
| 706910 | Post temporaire, position, callback704A00, marquage après échec | 103 |
| 704A00 | Callback temporaire ; type1 marque retired avant l’appel lié | 26 |
| 704A40 | Callback lié ; type1 appelle slot4 puis slot0(1) | 27 |
| 706600 | Objet puis stockage scratch16octets et insertion dans le propriétaire | 62 |
| 7066A0 | Nettoyage global dans l’ordre d’insertion | 51 |
| 706720 | Nettoyage des entrées retired ; analyse statique seulement ici | 58 |
| 7055D0 | Fabrique d’objet40octets, constructeur707080 et registre du propriétaire | 63 |
| 7056A0 | Retrait de l’objet du registre et destructeur virtuel | 34 |

567instructions recoupées dans les octets originaux avec Capstone ;11références conservées, cibles des CALL/JMP directs vérifiées. Session REA fermée proprement sans erreur d’outil, source et copie identiques avant/après. Les avertissements de décompilation des sauts virtuels dans les callbacks sont conservés ; leur invocation observée ne dépend pas d’un prototype C supposé par Ghidra.

## Trois parcours natifs composés

Les trois parcours exécutent le constructeur704B10, le caller704E60 avec Audio.ini, six banques, le parent7067B0, la publication AEB000, les actions, les voix et décodeurs, puis705080/704C30. Le code original s’exécute dans Unicorn, avec services OS/heap/pools/TLS/verrous/horloge/COM et transport des workers fournis. L’horloge de test epoch0 est déclarée ; ce n’est pas une date historique. Les méthodes de l’objet callback sont des interfaces observables fournies. Aucun processus du jeu original ni périphérique audio réel n’est lancé.

| Profil | Objet de l’événement nominal | Fabrication | Résultat |
| --- | ---: | --- | --- |
| bound | 2000001 | wrapper fourni, enregistrement natif explicite | Post1, deux voix, callback704A40 type1 |
| unbound | 3 | 706600→7055D0→707080 exécutés | Post1, deux voix, callback704A00 type1 |
| unbound avec limites préalables | 4, après objet3 de l’événement absent | même fabrique native, deux scratchs suivis | échec0 conservant objet3, puis Post1 et deux voix |

L’événement nominal est Play_sfx_Env_Map10_Emitter_brazierchain, identifiant1392698701. Les actions1049381235 et415219389 sélectionnent les sons407149979/900501484 et les médias931355143/556739449, depuis les graines natives0 puis3539360597. Deux frames par profil ;16384échantillons PCM comparés par profil, soit49152 au total. Deux WAV distincts, erreur PCM16 maximale1. La comparaison concerne les décodeurs avant mixage ; l’intégrité des captures de buffers est vérifiée sans qualification de toute la sortie physique.

La création temporaire remplit le vrai wrapper40octets, son identifiant et le scratch16octets [objet, propriétaire, lien, retired]. Le registre du moteur traite l’enregistrement sur la publication/frame suivante : la capture immédiatement après Post ne contient pas encore le nouvel objet. À l’inverse, le wrapper bound est fourni et enregistré explicitement. Ne pas fusionner ces deux niveaux de preuve.

Le callback de fin temporaire marque retired avant slot4 ; le troisième profil observe directement la valeur1 dans les méthodes fournies. Le nettoyage global7066A0 dispose l’objet, détruit le lien s’il existe, puis libère le scratch. L’objet échoué sans lien est nettoyé avant le nominal dans le troisième profil. La capacité du vecteur scratch reste allouée jusqu’au destructeur du propriétaire :4octets dans unbound,8octets avec l’échec préalable. Ce stockage est libéré par704C30.

Les5526allocations audio suivies sont libérées sur les trois profils. Chaque profil ferme21handles simulés et termine les trois workers. Le zéro final ne couvre pas les réservations physiques des pools, les mappings de banques ou la mémoire du banc de configuration.

## Cas limites et refus

Deux appels au parent avec nom vide, avec et sans objet lié, retournent0, mettent la sortie à0 et n’émettent aucune opération ni allocation. L’événement OpenLeague_missing_event utilise réellement706910 et la fabrique native ; AEA950 échoue, le parent retourne0 mais laisse la sortie pointer sur l’objet3, marque le scratch retired=1 et émet le diagnostic. Le sink5FA170 est fourni et son texte capturé ; l’initialisation du logger et ses effets externes ne sont pas qualifiés. Le scratch et l’objet restent suivis jusqu’au shutdown réel.

Six altérations de preuve sont refusées : récepteur du parent substitué, trace de fabrique effacée, cookie callback substitué, retired effacé après événement absent, ordre natif de libération inversé et empreinte PCM changée. Ce sont des contrôles des preuves, distincts des trois limites natives et des refus Rust.

## Consommateurs Rust

Nouveau test crates/core/tests/audio_parent_contract_observation.rs. Le code de production reste inchangé. La comparaison exécute les vrais dispatchers, le sélecteur, Pool::allocate, deliver_callback, clear et les callbacks. Le test fournit les identités objet/stockage issues des captures et le retour playing-ID du backend ; il ne fournit pas de backend de lecture physique. L’exécution synchrone de la sélection dans ce test ne qualifie pas l’ordonnancement natif complet.

Commande : cargo test --locked --offline -p openleague-core --test audio_parent_contract_observation -- --nocapture.

Code0,2tests réussis,0échec,3observations. Les trois profils retrouvent objet, deux sélections, méthodes callback et ordre de nettoyage. Les deux noms vides et l’événement absent sont comparés dans le troisième profil. Trois refus locaux supplémentaires (non-ASCII, NUL interne, âge NaN) conservent la sortie et n’appellent pas le backend ; ils ne sont pas attribués au binaire natif. Les24avertissements Rust existants restent dans stderr. Reçu : compilateur, binaire de test, commande, sources et empreintes avant/après.

Quatre ancres précises sont ajoutées : audio_unbound_post::dispatch et Pool::{allocate,deliver_callback,clear}. Le parent, les callbacks, le sélecteur et Dispatcher déjà recensés sont réutilisés, avec leur ancien texte de qualification conservé. Les nouvelles preuves décrivent ce qui a réellement été exécuté dans V790. Le diagnostic AmbientRequests du client indique encore backend_available=false ; ce constat de source reste statique, sans lancement du client.

## Publication et preuves

Deux fiches (parent SYS-01.2-02 et SYS-02.2-07), trois registres et les deux bases du plan sont enrichis par deltas ciblés réversibles. Cases, notes, historiques, autres fiches, prérequis et registre des inconnues sont conservés. Aucun statut d’implémentation/acceptation n’est promu. Pas de nouvelle copie intégrale des bases.

Sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision790_launch_bound/OBSERVATIONS.json, revision790_launch_unbound/OBSERVATIONS.json et revision790_launch_unbound_limits/OBSERVATIONS.json : exécutions natives, PCM et arrêt.
- revision790_rea_launch_parent/observations/cb2b3821-4859-454b-a24d-f2c9b0bef2f8/receipt.json : session REA et réponses conservées.
- revision790_native_validation.json : contrôles des trois traces et du PE.
- revision790_current_parent/RECEIPT.json, stdout.txt et stderr.txt : tests Rust.
- revision790_associations/OBSERVATIONS.json : sources, liens, refus de preuves et limites.
- revision790_delivery/ : deltas, publication et relecture indépendante.

Livrable relié au registre : docs/fidelity_rea_launch_parent_v790.json. Les documents de couverture/reprise, CURRENT, HANDOFF, DECISIONS et REA_WORKFLOW portent les nouvelles preuves.

## Limites et prochaine action

Le type4 des callbacks et le nettoyage retired706720 sont statiques dans ce lot. Aucun nouvel OOM, streaming/IO réel, pool19 physique, émetteur ordinaire, backend audio Rust complet, concurrence ou jeu complet n’est qualifié. Les anciens jeux de cas restent hérités, pas comptés comme fraîchement exécutés.

Continuer SYS-01.2-02 sur F avec REA. V790 compose le parent7067B0 et sa fabrique temporaire jusqu’au shutdown ; qualifier maintenant le nettoyage différé706720 après une vraie fin d’événement, puis les producteurs de callback4 et les limites OOM pertinentes. Garder séparés les services physiques, le pool19, le streaming/IO, le backend Rust et les émetteurs ordinaires du jeu. Poursuivre aussi les associations partielles du recensement V784. Les cinq exigences Battle Training restent ouvertes sans nouvelle entrée historique ; ne pas répéter leurs recherches inchangées. Préserver sources, preuves, cases, notes, historiques et inconnues.
