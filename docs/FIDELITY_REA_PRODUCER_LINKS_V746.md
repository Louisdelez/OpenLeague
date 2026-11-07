# SYS-01.2-02 — Producteurs audio natifs et transport Rust, V746

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Le checkpoint V745 constitue un progrès vérifié ; cette suite conserve l’objectif de liaison source/exigence/consommateur. Aucun jeu complet ni fonction audio ordinaire terminé n’est revendiqué.

## REA et sources originales

La nouvelle session REA6.4.0/Ghidra12.1.4 sur le PE original complet termine avec code0 et fermeture confirmée. Source :15973880octets, SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. L’original et sa copie sont inchangés. Les19fonctions/762instructions sont recoupées avec le PE et Capstone.43références sont conservées, dont41appels directs décodés. Les signatures reconstruites restent des hypothèses de décompilation, pas des déclarations C++ originales.

Les16appelants directs de B05ED0 sont résolus.17écritures du sélecteur de paquet proviennent de constantes AX/CX vérifiées ; le scan E8 des sections exécutables retrouve exactement ces16appels. Sélecteurs recensés :1,2,3,7,8,11,12,13,14,16,24,25,30,31,35. Aucune de ces17affectations ne donne20. Cela ne prouve pas une absence globale du producteur20 : appels indirects, autres points d’entrée et autres générations de paquets restent ouverts. Ne pas remplacer cette inconnue par un producteur inventé.

## Contrat natif vérifié

Neuf fonctions entières — AEB0A0,AEB1E0,AEB240,AEB2F0,AEB340,AEB390,AEB700,AEB740,AEBC10 — ainsi que leurs helpers de taille et B05ED0/B06370/B05670 sont exécutés en mémoire Unicorn32 isolée.360cas couvrent dix profils, quatre valeurs d’identifiant, trois remplissages de pile et trois positions de file : espace disponible, fin exacte de page et passage à une autre page préallouée.320adresses d’instruction sont identifiées dans le PE.

Attendu et observé :342paquets exacts sont copiés ;18appels ne produisent aucun paquet. Pour identifiant0, AEB740 retourne0 et AEBC10 retourne2 sans toucher à la file. Les paquets ont12,16,20,28ou36octets selon le producteur. Le mot de pile inutilisé à+4 conserve le remplissage fourni ; il n’est pas canonisé àzéro. Les octets réservés des sélecteurs7 sont également conservés. Les valeurs float, y compris des bits NaN de diagnostic, restent des données brutes de transport ; aucun traitement sonore de ces valeurs n’est qualifié.

La file dispose de trois pages natives de2048octets. Les états, tables et octets des pages sont comparés intégralement. Les fonctions Win32 Enter/LeaveCriticalSection et la feuille CRT memcpy sont adaptées explicitement. Aucun corps de producteur/file n’est remplacé. Allocation, croissance, attente de retry, dispatch des corps, threads réels, périphérique et démarrage historique restent hors de cette preuve.

## Consommateurs actuels

Une sonde privée compile40fichiers Rust actuels inchangés, confirmés par les dépendances rustc. Les342paquets construits nativement alimentent chacune des deux fonctions réelles audio_common_queue::Context::enqueue et enqueue_with_wait :684comparaisons réussies. Retour1, taille publiée, contenu du paquet, état brut, table, pages et ordre Enter/Leave concordent. Deux contrôles de paquets trop courts retournent Truncated en conservant état et données.

Les18cas natifs sans paquet ne sont pas présentés comme des producteurs Rust équivalents : ils sont exclus explicitement du replay de transport. Les services d’allocation, attente et dispatch échoueraient s’ils étaient appelés ; aucun ne l’a été. Les producteurs ordinaires et les corps de commandes ne sont donc pas validés par cette sonde. Les compilations et exécutions finales terminent0 hors ligne, sans incrémental. Aucun code produit/asset modifié.

## Échecs conservés et contrôle

Le premier banc a transmis un bytearray non accepté par Unicorn ; une tentative de préparation utilisait un nom d’encodage erroné. Ces deux diagnostics sont conservés. Le premier reçu natif réutilisait aussi une liste mutable pour offered : les assertions immédiates passaient, mais les lignes enregistrées étaient incohérentes. Deux exécutions Rust ont révélé puis localisé cette erreur de capture. Ce reçu est explicitement invalidé. La correction prend une copie de la liste par cas et réexécute tous les cas natifs, puis la comparaison Rust complète ; seules les captures finales sont qualifiées.

Six falsifications sont rejetées : sélecteur erroné, capture partagée, padding présenté commezéro, appel sans paquet présenté comme enqueued, transport présenté comme producteur ordinaire, conteneur synthétique présenté comme PE original.

## Intégration et suite

Deux rôles précis de transport sont ajoutés aux fiches SYS-01.2-02 et SYS-02.2-07. Les trois registres, coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md sont mis à jour avec ce rapport et son reçu. Deux bases locales du plan sont mises à jour par deltas ciblés ; cases, notes manuelles, historiques, inconnues, prérequis et autres tâches sont conservés. Pas de sauvegarde intégrale supplémentaire.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision746_rea_producers ; revision746_native_producers_final/OBSERVATIONS.json ; revision746_rust_producer_transport_final/OBSERVATIONS.json ; revision746_associations/ENRICHED.json ; revision746_producer_selector_catalog.json ; revision746_delivery. Les reçus VERIFIED.json et INDEPENDENT_READBACK.json distinguent publication et relecture.

Suite : qualifier les routes alternatives vers B06370/B05670 et les appels calculés pertinents sans conclure à une absence globale de20. Le corps20 et l’état étendu Rust, le backend normal, le raccordement ENVS, le parent B17486/transport240-244, Meter, Init STMG/HIRC8/HIRC14, médias, locale et sortie audible restent ouverts. Goal SYS-01.2-02 actif.
