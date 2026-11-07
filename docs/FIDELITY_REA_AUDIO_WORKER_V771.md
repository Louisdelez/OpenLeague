# SYS-01.2-02 — Worker audio natif et seed, V771

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315, EUW/en_GB. Fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Exécuter le parent du contexte commun et le worker identifiés enV770, vérifier leur création/boucle/arrêt et relier les contrats aux consommateurs actuels. Aucun code du jeu ni asset modifié ; aucun nouveau build ou runtime Rust.

AEA640 exécute AF3810, alloue/construit le contexte commun168octets, publie14A7A28, puis appelle B089A0/B20DA0. Les pointeurs common et device sont désormais publiés par leurs instructions originales. Le manager de transitions et plusieurs autres managers restent fournis ; AEA9D0 demeure analysé statiquement.

CreateThread reçoit la fonction B20D10 et common+0x88. L’adaptateur physique diffère son lancement. La fonction originale est ensuite exécutée sur une pile émulée distincte, suspendue à WaitForSingleObject puis reprise. Aucun thread Windows réel ou parallélisme n’est revendiqué.

| Contrôle exécuté | Attendu et observé |
| --- | --- |
| Worker et médias | 31médias ;846passages à l’attente, dont31quotas0,784frames actives et31arrêts |
| Frames traitées | 815 ; compteur final815 ; horloge adaptée1000→18115ms |
| Attente demandée | 10ms, dérivée du périphérique ; distincte de l’avance21ms choisie par le banc |
| Signaux | Les31médias deviennent positifs ;62frames actives positives |
| Décodeur | 713buffers,730112échantillons PCM16 ; écart maximal1unité avec31WAV identifiés |
| Arrêt | B089D0/B20E50 : stop1,SetEvent,join,retour worker0,CloseHandle,global handle0 |
| Limites worker | 12profils de démarrage :4succès1,8refus2 ;13profils de boucle |
| Intégrité | 4837blocs du parcours médias ;66blocs des profils worker comparés au PE |
| Allocations | 3836allocations,2193libérations,1643restantes ; pas de teardown global |
| Falsifications | 16altérations de preuves rejetées |

Une étape qui suspend le worker porte answer=None et une preuve de yield. Elle ne représente pas un retour de B20D10. Le retour natif0 n’est observé qu’après la demande d’arrêt. La fermeture du handle ne libère pas ici l’événement common4402 ni les banques/périphériques/capacités.

## Différences audio et témoin contrôlé

Le premier contrôle a échoué parce qu’il supposait les sorties identiques àV770. La comparaison détaillée montre13durées de préfixe différentes et7médias dont les deux premières frames changent. Sur720frames communes,670sont identiques et50diffèrent. Les708buffers décodés communs restent identiques.

REA et l’exécution montrent que B20D10 appelle C99E9A puis C9BB9B : heure convertie en secondes puis écriture de `_holdrand` dans le TLS CRT fourni. Le banc fixe explicitement l’heure à1700000000secondes Unix. La valeur précédente2531011 est remplacée à l’entrée du worker, après la construction de la première voix. Les consommations natives suivantes du générateur changent les paramètres des voix ; cette heure n’est pas une date historique revendiquée.

Un second profil conserve le parcours direct deV770 et ajoute seulement ces deux appels natifs, avec la même heure et au même point. Les784sorties actives et les713buffers décodés correspondent alors exactement au parcours worker. Cette comparaison explique l’écart du banc ; elle ne garantit pas une sortie identique pour toutes les heures, entrées ou graines aléatoires. Aucun média manquant ou corrompu n’est déduit.

La correction conserve le premier FAILED.json et exige désormais cette comparaison différentielle, en plus du contrôle PCM16 contre lesWAV. Le constat intermédiaire de résultats inchangés était trop large ; les observations ci-dessus le corrigent.

## Refus et limites de boucle

Les profils de démarrage couvrent échec CreateEvent,CreateThread,SetThreadPriority et SetThreadAffinityMask, avec remplissages00/A5. Ils vérifient également priorité-2,stack65536 et affinité0/1 comme entrées explicites. Un refus de priorité/affinité ferme le handle et remet le global à0 ; cela ne prouve pas la terminaison d’un thread concurrent. L’événement du contexte reste conservé.

Les13profils de boucle testent WAIT_OBJECT_0,WAIT_TIMEOUT et autre résultat, COM déjà initialisé ou HRESULT0/1/80010106, ainsi que stop déjà positionné. Les retours0 et258 permettent les passages suivants ; l’autre retour saute le traitement suivant. Le flag stop est testé après le premier traitement et l’attente. COM initialisé localement avec succès est désinitialisé à la sortie ; un HRESULT négatif ne l’est pas. Ces13cas adaptent uniquement le scheduler B06950 pour isoler ces décisions. Le profil31médias exécute son corps réel.

Le premier essai des limites s’est arrêté au trampoline CoUninitialize32001F00 du banc. Une copie distincte ajoute une instruction de retour dans la mémoire de cet adaptateur ; aucun octet du PE n’est modifié. L’échec initial et les15profils déjà parcourus restent conservés.

## REA, identité et consommateurs actuels

REA6.4.0 / SDK2.3.1 / Ghidra12.1.4 / Java21 :12fonctions,469instructions et55références. Session exportée et fermée sans erreur. Fonctions : AEA640,AEA9D0,B089A0,B20DA0,B20D10,B20E50,B089D0,AF8C00,B10040,C99E9A,C9BB9B,B20D00. Les types inférés par le décompilateur restent interprétés avec les instructions et les valeurs observées.

PE original inchangé : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`.
SHA256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

- `audio_normal_frame::Runtime::run` : nouvelle ancre du consommateur de frame ; ses services requis restent à relier au worker ordinaire.
- `audio_windows_engine_thread_name::name_current` : bridgeMSVC/SEH existant, nommé pour le thread courant. AF8C00 reçoit ici un TID enfant explicite ; les contrats ne sont pas interchangeables.
- `audio_crt_windows_engine_worker::spawn` : les deux ancres existantes sont conservées. Ce bridge passe par CRT/root/job/capsule ; B20DA0 utilise CreateThread direct. Aucune équivalence de producteur ou intégration Wwise complète n’est annoncée.
- `audio_fallback_device::quota` : ancre existante réutilisée ; quota21ms et délai d’attente10ms sont distingués.

Cinq ancres au total : une nouvelle et quatre réutilisées, sans promotion de leurs qualifications. Les contrôles Rust antérieurs restent des preuves datées ; aucune exécution Rust nouvelle.

Le premier audit des associations a refusé trois ancres parce que leurs identifiants de source conservaient le chemin historique E:/OpenLeague. Elles concernent deux fichiers présents aujourd’hui sur F:. Le contrôle corrigé vérifie les chemins relatifs et l’identité exacte des octets SHA256 entre les enregistrements historiques et les fichiers actuels. Les identifiants historiques sont conservés et les correspondances sont explicites dans `audit.source_aliases`. Cette vérification ne prétend pas avoir relu les anciens fichiers sur E:. L’échec initial reste disponible.

## Limites restantes

Allocations physiques, verrous, TLS/atomiques, temps,COM,événements,CreateThread,priorité,affinité et nommage debugger restent adaptés. Le nom AK::EventManager passe par une exception consommée par le banc ; aucune livraison réelle SEH n’est qualifiée. Host et worker partagent le TLS CRT fourni. La simulation rend l’ordonnancement explicite mais ne couvre pas les races ni le timing Windows.

Autres managers/paramètres, publication transitions, positions/listeners réels, transport sonore physique, autres médias/locales,streaming,seek,boucles,quotas multiples actifs et teardown global restent ouverts. Le chemin alternatif COM/notifications deV770 arrêté àDF8670 n’est pas résolu par cette révision. Le maximum du parcours présent est76frames, sans borne80 atteinte.

## Fichiers et preuves

Dossier : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.

- `revision771_rea_audio_worker/observations/50749dfa-6e61-4a26-9f66-8b1018bdb3a5/receipt.json` : REA.
- `revision771_worker_explore/OBSERVATIONS.json`, `revision771_worker_checked/OBSERVATIONS.json` : premier média puis31médias.
- `revision771_worker_boundaries/FAILED.json`, `revision771_worker_boundaries_corrected/OBSERVATIONS.json` : échec du trampoline et25profils corrigés.
- `revision771_worker_validation/FAILED.json` : comparaison initiale non valable avec l’ancien seed.
- `revision771_seed_control/OBSERVATIONS.json` : témoin natif avec réinitialisation du seed.
- `revision771_worker_validation_corrected/OBSERVATIONS.json` : relecture complète et différentielle.
- `revision771_worker_associations/FAILED.json` : premier contrôle des identités E/F.
- `revision771_worker_associations_corrected/OBSERVATIONS.json` : sources, consommateurs et 16 falsifications.
- `revision771_delivery/VERIFIED.json`, `INDEPENDENT_READBACK.json`, `FINAL_VERIFIED.json` : publication et relecture.

Livrables intégrés : ce rapport et `docs/fidelity_rea_audio_worker_v771.json`. Les registres sources/exigences/tâches, documents de couverture/reprise et deux bases locales sont enrichis avec deltas ciblés. Cases, notes, historiques, prérequis et inconnues sont conservés. Aucune exigence complète ni le jeu entier n’est déclaré terminé.

## Suite

Qualifier AEA9D0 et les paramètres/managers encore fournis, puis un TLS distinct et les attentes/transports physiques. Relier ces contrats aux producteurs Rust actuels avant de revendiquer un worker ordinaire fidèle.
