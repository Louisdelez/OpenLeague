# SYS-01.2-02 — Arrêt global pendant une voix active, V781

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. SYS-01.2-02 et SYS-02.2-07 restent partiels.

## Résultats distincts

Le premier essai rejoue31cycles de voix dont les lignes complètes et784résumés de sortie sont identiques à V779. Il lance ensuite une voix51118002 sans arrêt explicite, puis appelle705080. Cinq banques sont libérées ; la dernière attend un signal absent après la borne de quatre cycles du banc. À cette frontière :1806allocations avant arrêt,21créations et1421libérations pendant l'arrêt,406encore vivantes. Voix, parent et décodeur restent alloués. Ce résultat ne constitue ni un arrêt réussi ni un défaut du jeu établi.

Un second essai ciblé utilise une borne220cycles calculée avec la durée du média188071/44100secondes, la période21ms et une marge16cycles. Il atteint le nettoyage, mais l'observateur passif échoue car il suppose encore la présence du média retiré ; son gestionnaire d'erreur répète cette lecture et ne produit pas de reçu natif structuré. Le code, les fichiers partiels et l'observation du retour1 sont conservés. Aucun succès n'en est déduit.

Le troisième essai conserve la borne et corrige uniquement cette observation : un média absent devient une valeur absente dans le relevé. Il ne fournit ni arrêt de voix ni signal artificiel de fin. Il initialise704E60 avec Audio.ini, charge six banques, lance une voix par les fabriques natives et l'enregistre directement dans le pipeline parent. Cette voix est toujours active à l'entrée de705080. Ce profil ciblé ne rejoue pas les31cycles du premier essai.

| Contrôle du troisième essai | Résultat vérifié |
| --- | --- |
| État avant arrêt | Voix, parent et décodeur alloués ; registre actif1 ; signal de sortie non nul |
| Préfixe actif |45frames de sortie, identiques au préfixe correspondant de V779 |
| Décodage conservé |184appels,188071échantillons comparés au WAV ; erreur maximale1 PCM16 |
| Synchronisation | Six attentes banque→mix ; plus longue attente202cycles ; signal réellement observé avant retour |
| Instructions |6773blocs natifs, plus configuration, recoupés avec le PE |
| Allocations suivies |2211créées,2211libérées,zéro restant après704C30 |
| Fermeture | Trois workers avec retour0 ;21handles simulés fermés |
| Deuxième arrêt | Retour1 sans nouvel événement de service |
| Validateurs |11altérations rejetées |

La libération du parent, de la voix, du décodeur et de l'objet audio est vérifiée dans les événements de705080. La comparaison des échantillons du troisième essai porte sur les données réellement capturées. Les713buffers du parcours historique complet restent une preuve héritée : le premier reçu d'échec ne contient pas leurs nouvelles captures. Les deux variantes de scripts et de publication préparées pour une fermeture immédiate réussie n'ont pas été exécutées comme audit/publication ; elles ne constituent pas des preuves positives.

## REA, sources et consommateurs

REA/Ghidra a analysé AF90F0, AF8F30, B089D0, ADBBE0, AEB790, B17E00, AF3AA0 et B0DFC0 :8fonctions,723instructions,11références. L'identité des octets, l'export et la fermeture de session sont contrôlés. AF8F30 place la notification de libération de banque puis attend son événement. AF90F0 parcourt les références qualifiées par un compteur ; l'état capturé de la source de cette voix porte un compteur+0x14 nul. Le contrat complet du caller événement/action et de ce compteur reste à qualifier.

Huit ancres Rust sont inspectées. Sept étaient déjà liées ; la nouvelle ancre statique Runtime::drain dans audio_path_voice_control_drain.rs correspond au consommateur AF3AA0 (application, retrait, cleanup, destruction et libération avec relecture après callbacks). Son fichier et sa ligne sont identifiés ; aucun test Rust nouveau n'est revendiqué. run_with_common accepte0/1 et refuse5/8. Le déchargement individuel et le drainage existants ne prouvent pas une fermeture globale intégrée au jeu Rust.

## Limites et refus

Une seule voix résidente, créée par fabriques natives et enregistrée directement dans le pipeline, est observée. Le caller d'événement du jeu, voix simultanées, streaming, seek, boucles, autres médias/locales et refus pendant une voix active restent ouverts. Les trois profils de refus V780 sont revalidés à partir des reçus, sans nouvelle exécution et sans voix active.

Heap, pools, verrous, TLS, horloge, COM et transports de threads/événements sont fournis au banc isolé. Le zéro d'allocations exclut mappings d'entrée, mémoire de configuration/processus, réservations physiques et ressources Windows. Pool19 et les descripteurs physiques restent ouverts. Aucun jeu historique, périphérique audio réel, code Rust, asset, build ou test Rust n'est lancé ou modifié par cette révision.

## Preuves et livraison

- PE original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
- SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.
- Racine : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.
- revision781_active_voice_shutdown/FAILED.json : premier essai borné.
- revision781_wait_observer_failure.json : second essai, observateur défaillant.
- revision781_active_voice_wait_observed/OBSERVATIONS.json : troisième essai.
- revision781_wait_associations/OBSERVATIONS.json : audit et falsifications.
- revision781_rea_active_shutdown/observations/359335ee-c258-45ad-9069-c07ae3344e18/receipt.json : session REA.
- revision781_delivery : publication, deltas réversibles et relecture.

Livrables : ce rapport, docs/fidelity_rea_audio_active_shutdown_v781.json, registres des tâches/sources/liens, deux fiches dans les deux bases, couverture et reprise. Les reçus déterminent l'achèvement de publication. Cases, notes, historiques, autres tâches et preuves antérieures conservés.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V781 observe l'arrêt avec une voix résidente construite par les fabriques natives et enregistrée directement dans le pipeline ; ne pas généraliser à un événement du jeu. Prochaine étape : qualifier le caller événement/action vers la voix, les préconditions d'arrêt et les refus avec voix active, puis les sources streaming/IO peuplées. Qualifier aussi les descripteurs et allocateurs physiques, notamment pool19. Relier les consommateurs Rust ordinaires ;5/8 restent refusés. Garder ouverts concurrence/TLS, logger/CRT, provider/locale, autres médias et les autres exigences du goal. Préserver sources, preuves, cases, notes et historiques.
