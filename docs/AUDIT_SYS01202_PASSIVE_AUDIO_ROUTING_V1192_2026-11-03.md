# SYS-01.2-02 — Frontière de routage audio des passifs, V1192

3 novembre 2026. Unité AUD-SYS-01.2-02-PASSIVE-AUDIO-ROUTING-BOUNDARY-01 : **un audit statique partagé proposé à la clôture root après relecture indépendante ; disponibilité V670 réutilisée, zéro nouvel audit availability**. Les 122 AUDIO, leurs SOURCE, inconnues, fonctionnalités et acceptations restent ouverts. SYS-01.2-02 demeure OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE.

## 1. Exigence et frontière

Établir le chemin enregistré de l’application normale vers les entrées d’événement et les consommateurs audio, avec corps, appelants et données explicites. Question bornée : un pont passif natif→événement→lecture admise est-il établi dans ce chemin ? Infrastructure générique, sons Q/E/R et rendu de passif ne suffisent pas. Les autres appels dynamiques ou contextes archivés restent hors périmètre.

## 2. Sources, provenance et identité

Le vrai reçu V670, 553891 octets, SHA-256 25aa487d8d5b558b31e1044bc492b17415b23a9aad9a734315ec478bba5ea85a, et ses 122 instructions ont été lus. Référence historique : PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct ; build littéral 2014-11-17 17:46:45 sans fuseau/déploiement établi.

Disponibilité acquise : 244 banques/122 champions, 633 fichiers natifs, 4455 occurrences événementielles, 8243 entrées médias, 124 banques à événements, 75338 champs ID. Aucun natif rehaché/reparsè. Le cache immuable du 3 novembre contient 1350 contrats ; les 122 AUDIO sont tous a_faire, implementation_complete=false et acceptance_complete=false. Dépendances/packages/prérequis comparables concordent. Les anciens acceptance/title/status absents du reçu ne sont pas reconstruits. OLF/OLU/OLC restent historiques datés, non rafraîchis. Les champs réellement présents des sept rubriques ont été relus, sans présumer leur absence.

## 3. Consommateurs réellement examinés

main.rs enregistre quatre chemins Ezreal Q hit/R hit/R OnCast/E Arrival : gardes de contexte et WAV via AudioPlayer<PcmAudio>, sans bus Wwise de passif. Q/R utilisent une enveloppe version 1 ; E utilise policy=local_e_committed_blink_points_v1/events. map_audio.rs porte trois signaux fixes de carte.

AmbientPlayer→map_events→map_audio_requests admet cinq JSON TT ; SoundOnCreate/SoundPersistent deviennent des requêtes logiques, diagnostic backend_available=false. Les entrées ambient_events/selection/manifest sont identifiées, sans preuve de voix admise. Annie ready produit des quads, Ezreal passive_self alimente le HUD ; leurs corps examinés ne postent pas d’audio. StunReady.System sans champ Sound ne prouve pas un silence historique.

L’application Windows normale attache NativeApplication : main.rs:607–640 et 1735–1744 configurent Service, transport et horloge. Service.attach remplace le backend standalone par configure_service→ServiceHandle canonique. Ce backend implémente register/unregister via pending_service ; le refus du standalone ne lui est pas attribué. Le callback canonique ConsumerBoundary::actor_call retourne toutefois «native metadata actor method is not connected» dans audio_replay_windows_receive.rs:40–48.

Runtime.receive_game_event et initialize_game_manager existent ; configure_service seul n’initialise pas le manager requis. Leurs appels ne sont pas identifiés dans le startup normal 607–891 ni le corps Match receive 969–1350 examinés. Les probes CLI sont distinctes. Les APIs core post/seek, sélection, acteurs et PCM existent ; les centaines d’autres helpers ne sont pas déclarées absentes. Game.cfg effectif reste inconnu, loader non appelé.

## 4. Attendu, observé et contrôles

Attendu : chaîne active et limites vérifiables, contrats conservés, disponibilité distincte de lecture. Observé : 11 capacités initiales, 41 entrées initiales, 11 entrées supplémentaires et 16 pins directs canoniques ; fenêtres de corps/appelants et census client borné de 498 fichiers/104 hits, tests inclus. Sources nominales/refus et gardes lues, sans exécution Rust.

274 contrôles documentaires source, 10 assertions code, 4 inputs et 10 canoniques passent. Les 10 contrôles/8 refus du lecteur V670 et le recoupement wwiser sont hérités, distincts, non rejoués ; pas de mélange avec V667 29/22. Aucun build, runtime, écoute, décodage d’asset, REA, recherche native ou gros registre chargé. Entrées et brouillons sont conservés en octets exacts avant révision.

## 5. Écarts et conclusions indéterminées

Aucun pont passif natif→événement→audio admis n’est établi dans le chemin ordinaire examiné. Aucune absence globale du moteur ou du code dynamique n’est démontrée. Le delta V670 «0 consommateur ajouté» demeure une mesure de publication. L’addendum canonique supersède explicitement le refus standalone trop largement attribué dans la revue initiale, conservée intacte.

Tryndamere 17/Viktor 7 IDs répétés restent scoped par banque. Sur 16 médias externes, 12 candidats MISC_Global existent ; Malzahar 35244919/440349231/472550424/1058542249 restent sans candidat dans 594 index SFX/noms WEM, sans preuve d’absence globale. Trois nœuds Ezreal sont candidats MISC_Global ; Zyra 698313483 en Skin01 ne prouve pas un fallback Base. Déclencheurs, sélection, audience, priorités, RTPC, boucles/arrêt, skins/locales et écoute restent à qualifier.

## 6. Corrections réutilisées et reprise

Réutiliser les 122 IDs AUDIO, dépendances PASSIF-NETWORK et six requires_packages, sans doublons. Pour un passif nommé : établir événement natif scoped par banque, conditions/audience/arrêt et médias validés ; relier producteur autoritaire→DTO/adapter→consommateur réel. Les tâches existantes portent l’intégration et leurs critères succès/refus/limites/écoute. COR-SYS-01.2-02-PASSIVE-AUDIO-EVENT-CONSUMER-01 désigne seulement le complément documentaire partagé, sans édition du registre.

Aucun son inventé si le silence d’origine reste inconnu. Reprise sur primaire précise du déclencheur/événement ou changement vérifié du producteur/adapter/consumer ; pas de re-scan banques/wwiser/594 index ou recherche lexicale 122 inchangée.

## 7. Livraison, cohérence et dimensions

Stage E:/mapslol3v3/audit_sys01202_passive_audio_family_20261103 : matrice, revue code, deux addenda, archives, collecteurs/journaux, result et notes. Publisher rapport/CURRENT/HANDOFF réservé au root. typed_pin/verify_pin sont exactement héritées de Brand, cinq contrôles datés non rejoués ; sept hashes protégés hérités, non recalculés en préparation.

Audit : une clôture partagée proposée, conditionnée à la relecture indépendante root ; zéro individuelle/availability nouvelle. Implémentation : incomplète, infrastructure et chemins partiels présents. Vérification : statique/documentaire. Acceptation humaine : non demandée/À VALIDER. Aucun taux global, jeu terminé ou changement Goal/Plan/UI/DB/code/assets/registres.
