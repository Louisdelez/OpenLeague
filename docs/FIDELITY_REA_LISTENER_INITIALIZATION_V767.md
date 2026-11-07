# SYS-01.2-02 — Initialisation des listeners et signal natif, V767

Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB. Deux fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Leur périmètre global reste partiel.

## Ce qui change

Le banc précédent conservait les huit slots de listeners à zéro. Le descripteur spatial produisait une distance NaN (0xFFC00000), puis un facteur source nul. Cette révision appelle le véritable initialiseur B19E30 avant la création de sortie et des voix, sans écrire artificiellement des gains positifs.

B19E30 et B1A0B0 produisent les frames, bases, échelles de distance1, gains de canaux1 et drapeaux dirty des huit listeners. L’appel n’alloue rien. Il est ajouté explicitement par le banc : cela ne prouve pas encore l’ordre du bootstrap historique complet. Les sources, banques, positions nulles déclarées et identifiants de test restent les mêmes. Il s’agit d’une correction du contexte de test, pas d’un défaut démontré dans le jeu Rust.

Les 62 descripteurs observés ont maintenant une distance0 et un facteur source0x3F7FC105, environ0.999039. B16540 produit un gain wrapper positif. Les 62 décisions de traitement sont admises, contre4 dans le profil précédent.

## Signal mesuré

Les 31 médias sont testés sur deux frames actives puis une frame d’arrêt. Les 93 passages suivent B0C1A0 → B277F0 → B26430 → B27AD0 et portent1024frames. Les buffers float32 ont8192octets.

18 frames actives de9 médias contiennent des échantillons non nuls ;44 frames de22 médias restent nulles. Les31 frames d’arrêt sont nulles. Le pic absolu mesuré est0.0030345532577484846. Les36 dumps positifs bus/device sont conservés par SHA256 et relus ;tous les échantillons sont finis. Ces résultats ne prouvent ni une sortie audio physique ni une écoute acceptée. Deux frames ne suffisent pas à conclure que les22 autres médias sont absents ou incorrects :préfixe décodé,latence et durée doivent être examinés.

Les voix,objets et références sont retirés comme auparavant.2520 allocations et889 libérations laissent1631 allocations de banques,sorties et capacités,soit8 de plus que le banc silencieux. Aucun teardown global n’est annoncé.4565 blocs exécutés concordent avec le PE original.

## REA et consommateurs actuels

REA6.4.0/Ghidra12.1.4 analyse12 fonctions : B199D0,AEC6E0,AED6C0,AED7A0,AEDC00,AEC1D0,B052B0,AEB0E0,705E30,B1AB00,B1AF20 et AEF410.1264 instructions et19 références sont revérifiées contre le PE SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Session exportée et fermée sans erreur. B19E30/B1A0B0 sont désassemblés et exécutés directement dans le même PE ;ils ne sont pas présentés comme deux décompilations REA supplémentaires.

Les modules Rust audio_listener_backend et audio_distance restent inchangés. Table::native concorde exactement sur les champs frame/basis/scale/dirty des huit slots. nearest concorde sur62distances sous positions nulles et listener par défaut. Les gains de canaux,le routing,le descripteur spatial complet,les cônes,le mixer et le transport audio courant ne sont pas qualifiés par cette comparaison.

Table::from_slots refuse le contexte vierge de scale0. Les setters refusent scale0 et index8 sans changer la table. Quatre refus locaux sont vérifiés ;ils ne constituent pas une équivalence avec la politique native de panne. Le test existant d’initialisation/notification couvre256masques et passe. Deux consommateurs précis sont ajoutés ;nearest est réutilisé.

## Contrôles et limites

Huit falsifications sont rejetées :échelle initiale effacée,signal supprimé des statistiques,dump et frame divergents,propriétaire de média changé,initialiseur substitué,code natif altéré,slot Rust divergent et promotion fictive d’un mixer Rust exécuté.

Le code x86 s’exécute dans Unicorn avec allocateur,verrous,TLS,atomiques et clock1000 adaptés. Banques réelles et constructeurs natifs sont utilisés ;capacité de file,managers,positions,IDs et autres entrées restent déclarés. Aucun client historique normal,worker concurrent,appareil physique ni mixer courant complet n’est lancé. Streaming,seek,boucles,autres médias/locales,provider et ordonnancement restent ouverts. Aucun code produit ni asset modifié ;états manuels et preuves antérieures conservés.

## Preuves et suite

Preuve : docs/fidelity_rea_listener_initialization_v767.json. Banc : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision767_listener_initialized_probe/OBSERVATIONS.json. Comparaison Rust : revision767_rust_listener/OBSERVATIONS.json. Audit : revision767_listener_associations/OBSERVATIONS.json. Publication : revision767_delivery/VERIFIED.json ;relecture indépendante : INDEPENDENT_READBACK.json.

Qualifier le bootstrap réel du listener et les données du jeu,puis inspecter les préfixes des22médias encore nuls aux étapes décodeur,resampler et mixer. Ne pas transformer un silence initial en absence d’asset ni ces échantillons positifs en validation du jeu complet.
