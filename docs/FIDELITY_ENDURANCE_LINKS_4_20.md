# Endurance — traçabilité V154

V154 endurance:seven requirements,seven explicit boundary roles.1151 source pins,1182 checks,32 reader cases including31 refusals.Three CPU decoder transport tests pass. Resource readiness,owned process retirement,mist cleanup,reference cache,decoder events,connection limits and message buffer bounds are scoped controls;no prolonged whole-game or repeated full-cycle qualification.

## SYS-23.5-01

Le collecteur produit des témoins de ressources pour une capture ; il ne mesure pas toutes les ressources pendant une partie prolongée.

Reste à faire : Exécuter une partie prolongée avec compteurs et séries temporelles identifiés, sans réduire la charge de jeu.

## SYS-23.5-02

Le superviseur distingue la sortie du serveur et du client détenus ; ce prédicat ne prouve pas des cycles répétés chargement/partie/retour.

Reste à faire : Répéter les cycles complets avec compteurs avant/après et preuves de fermeture de chaque propriétaire.

## SYS-23.5-03

Le cache suit les références et refuse leur débordement ; ses identités abstraites ne sont pas des compteurs globaux d’allocations RAM/VRAM.

Reste à faire : Mesurer les allocations actives et leur dérive, en distinguant caches attendus, objets vivants et fuites.

## SYS-23.5-04

La sonde de brume conserve des générations Entity et AssetId pour observer leur disparition ; sa portée est un effet précis et non toutes les entités.

Reste à faire : Mesurer entités et effets par famille sur une durée et des cycles définis, avec retour aux niveaux attendus.

## SYS-23.5-05

Le moniteur de décodeurs rapporte création, épuisement et destruction ; trois tests CPU passent sans son audible ni mesure de toutes les voix/GPU.

Reste à faire : Qualifier dérive des voix réelles et ressources GPU, avec compteurs temporels et nettoyage en fin de cycle.

## SYS-23.5-06

Le registre expose leases et endpoints marqués, bornés par Limits ; il ne compte pas tous les handles Windows ni toutes les connexions du processus.

Reste à faire : Suivre handles, sockets et sessions à travers les cycles et vérifier leurs bornes réelles.

## SYS-23.5-07

CAPACITY borne le message du logger, pas la taille cumulée des journaux disque ni tous les caches.

Reste à faire : Inventorier les caches et journaux, vérifier capacité, rotation, rétention et refus à saturation.

Trois tests CPU de notifications de décodeur exécutés. Aucune voix audible, allocation GPU ou dérive globale mesurée. Le cache de références conserve une frontière vers le GPU hôte ; CAPACITY du logger borne un message, pas les journaux cumulés. Les mécanismes ciblés ne qualifient pas le jeu entier en endurance.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.5-01 | Le collecteur produit des témoins de ressources pour une capture ; il ne mesure pas toutes les ressources pendant une partie prolongée. | Exécuter une partie prolongée avec compteurs et séries temporelles identifiés, sans réduire la charge de jeu. |
| SYS-23.5-02 | Le superviseur distingue la sortie du serveur et du client détenus ; ce prédicat ne prouve pas des cycles répétés chargement/partie/retour. | Répéter les cycles complets avec compteurs avant/après et preuves de fermeture de chaque propriétaire. |
| SYS-23.5-03 | Le cache suit les références et refuse leur débordement ; ses identités abstraites ne sont pas des compteurs globaux d’allocations RAM/VRAM. | Mesurer les allocations actives et leur dérive, en distinguant caches attendus, objets vivants et fuites. |
| SYS-23.5-04 | La sonde de brume conserve des générations Entity et AssetId pour observer leur disparition ; sa portée est un effet précis et non toutes les entités. | Mesurer entités et effets par famille sur une durée et des cycles définis, avec retour aux niveaux attendus. |
| SYS-23.5-05 | Le moniteur de décodeurs rapporte création, épuisement et destruction ; trois tests CPU passent sans son audible ni mesure de toutes les voix/GPU. | Qualifier dérive des voix réelles et ressources GPU, avec compteurs temporels et nettoyage en fin de cycle. |
| SYS-23.5-06 | Le registre expose leases et endpoints marqués, bornés par Limits ; il ne compte pas tous les handles Windows ni toutes les connexions du processus. | Suivre handles, sockets et sessions à travers les cycles et vérifier leurs bornes réelles. |
| SYS-23.5-07 | CAPACITY borne le message du logger, pas la taille cumulée des journaux disque ni tous les caches. | Inventorier les caches et journaux, vérifier capacité, rotation, rétention et refus à saturation. |

Reçu : docs/reference_endurance_sources/endurance-links.json. Livraison : docs/fidelity_registry_endurance_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
