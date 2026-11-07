# SYS-01.2-02 — Fermeture après chargement des banques, V780

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Date : 30 octobre2026. Les tâches SYS-01.2-02 et SYS-02.2-07 restent partielles.

## Résultat intégré

Le constructeur704B10, le démarrage704E60 avec Audio.ini réel, les six banques et31préfixes audio s'exécutent maintenant dans la même mémoire que la fermeture705080 et le destructeur704C30. Chaque voix est arrêtée avant la fermeture globale ; la fermeture pendant une voix active reste ouverte.

| Contrôle | Attendu et observé |
| --- | --- |
| Sources | Binaire original, six banques, Audio.ini et Locale.cfg relus par leurs empreintes |
| Lecture |31préfixes ;784sorties mixées et713buffers décodés identiques à V779 |
| WAV |730112échantillons PCM16 comparés ; écart maximal1 |
| Instructions |6850blocs natifs, plus le lecteur de configuration, recoupés avec le PE |
| Fin du parcours |3874allocations audio suivies créées et libérées ; zéro restant dans ce suivi |
| Synchronisation | Six attentes du worker des banques sur le mixage ; callback natif et SetEvent observés avant de rendre l'attente |
| Fermeture | Trois workers terminent avec retour0 ;21handles simulés fermés |
| Relance de l'arrêt | Retour1 sans nouvel événement de service |
| Validateurs |11altérations de preuve ou du contrat Rust rejetées |

Le résultat à zéro porte seulement sur les allocations audio suivies. Les mappings d'entrée des banques, les buffers du banc de configuration, la mémoire du processus, les ressources Windows et les réservations physiques des pools n'en font pas partie.

## Commandes natives et consommateurs actuels

REA analyse11fonctions et606instructions, avec26références vérifiées. AF8C80 dispatch la commande5 vers AF90F0 et la commande8 vers AF8F30. La commande8 dépose les notifications de libération dans la file commune puis attend un événement par banque. Le banc exécute le worker natif de mixage jusqu'au callback AEA250 et au signal, consomme l'événement automatique, puis reprend le worker des banques. Deux callbacks de fin de commande s'exécutent sur le worker des banques, six callbacks de banque sur le mixage.

Les six ancres Rust existantes sont relues, dont run_with_common et unload_request. Elles sont conservées avec leurs preuves antérieures. run_with_common traite0/1 et refuse5/8 avec une erreur explicite. Le déchargement individuel existant ne qualifie pas la fermeture globale. Aucun fichier Rust, asset ou binaire produit n'est modifié ; aucun build ou test Rust n'est lancé dans V780.

## Refus avec banques chargées

Trois exécutions distinctes chargent les six banques sans jouer les31préfixes. Le worker de mixage atteint explicitement sa première attente avant le refus.

| Refus | Retour du vidage | Retour705080 | Allocations suivies | Handles simulés fermés |
| --- | --- | --- | --- | --- |
| Premier événement indisponible |2 |1 |1730créées /1730libérées |13 |
| Second événement indisponible |2 |1 |1731créées /1731libérées |14 |
| Allocation60octets de la file refusée |52 |1 |1730créées /1730libérées |14 |

Le propriétaire ne propage pas le refus du vidage. Les branches restantes ont libéré les allocations suivies dans les trois états testés. Ce résultat ne prouve pas tous les refus ni une exécution concurrente Windows.

Un profil nominal sans voix a également vérifié1734créations/libérations et six attentes de mixage, séparément du parcours complet.

## Essais conservés et limites

L'essai initial a été interrompu sans reçu exploitable ; aucun succès n'en est déduit. Une version devenue obsolète du banc a été arrêtée après16préfixes pour exécuter le parcours complet avec gestion de l'attente banque→mixage. L'échec distinct avec banques seules identifie cette attente non gérée. Ces tentatives sont conservées.

Les premières injections de refus rencontraient la première attente d'un worker différé qui n'avait pas encore démarré. Les trois nouveaux profils exécutent explicitement ce démarrage ; les anciens échecs restent des limites du banc, pas des bugs du jeu déclarés. Le premier comparateur de banques rejetait une annotation wait_kind ajoutée au journal. Le comparateur corrigé contrôle puis retire uniquement cette annotation avant comparaison ; les octets et événements natifs restent vérifiés.

Les créations/destructions de pools sont adaptées et les descripteurs natifs ne sont pas remplis. Les pools21,17,29,23 sont fermés explicitement dans le modèle ; le pool19 demandé ne possède toujours pas de destruction explicite observée. Sa durée de vie physique reste ouverte.

Aucun processus de jeu historique ni son matériel n'est lancé. Heap, verrous, TLS, COM, horloge et transports de threads/événements restent fournis. Les voix actives lors de l'arrêt, flux, seek, boucles, autres médias/locales, IO peuplé et ordre réel du bootstrap restent à qualifier.

## Preuves

- Binaire : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
- SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.
- Répertoire : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.
- revision780_media_cooperative_shutdown/OBSERVATIONS.json : parcours complet.
- revision780_banks_cooperative_shutdown/OBSERVATIONS.json : banques sans voix.
- revision780_loaded_*_idle/OBSERVATIONS.json : trois refus.
- revision780_associations/OBSERVATIONS.json : sources, consommateurs, comparaisons et altérations refusées.
- revision780_rea_loaded_shutdown/observations/5513ab38-8459-4ec9-b6df-e81a66c27af2/receipt.json : session REA terminée et fermée.
- revision780_delivery : intégration, conservation des données et relecture indépendante.

Livraison : ce rapport, docs/fidelity_rea_audio_loaded_shutdown_v780.json, registres, deux fiches du plan dans les bases projet/bureau, documents de couverture et de reprise. Les reçus déterminent le résultat effectif des contrôles de publication.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V780 compose la fermeture après31préfixes déjà arrêtés et six banques chargées ; six attentes banque→mixage et trois refus peuplés sont vérifiés. Prochaine étape : qualifier705080 avec une voix encore active, puis les flux/IO peuplés selon les sources. Qualifier aussi la création/destruction native des pools et leurs descripteurs, notamment le pool19 encore non fermé explicitement dans le modèle fourni. Relier les consommateurs Rust ordinaires ; run_with_common refuse encore5/8. Garder ouverts services physiques, concurrence/TLS, logger/CRT, provider/locale et clips complets. Préserver preuves, cases, notes et historiques ; ne pas déclarer le jeu terminé.
