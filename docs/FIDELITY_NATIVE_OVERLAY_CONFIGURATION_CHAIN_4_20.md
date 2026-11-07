# Configuration native des contextes et sélection — référence4.20

Cette livraison V23 intègre des expériences exécutées au tour précédent et relues sur leurs octets exacts. Elle ne relance ni le client historique ni les anciens tests Rust. V22 et toutes les anciennes preuves sont conservées.

Le lecteur du PE4.20 utilise OverlayParenting/Overlay,Name,ContentSrcPath,ContentBuiltPath,ContentLoadablePath,DataPath,RuntimeCommandArg etChildren. Aucun ToolsConfig.xml historique n’a été trouvé dans la copie fournie ou l’index Launcher consulté. Le XML de1064octets est donc un input local reconstruit à partir de ce contrat. Sa provenance et ses octets sont déclarés ; il ne devient pas une ressource historique4.20. La seule nouvelle redirection de lecture concerne ce fichier ; le document,le parser,la construction des contextes et la sélection exécutent leurs corps originaux.

| Cas | Attendu | Observé |
|---|---|---|
| Essai22/budget64 | Refus explicite si le DOM dépasse la borne du harnais | budget:live_blocks à64vivants,Python2 ;71allocations récupérées parcleanuphôte ; aucun accès invalide/import absent/arrêt forcé |
| Helper512 | Production inchangée,borne explicite et refus au-delà | Les20modules actuels restent byte-identiques ; seul MAX_LIVE64→512 change dans le helper ; cinq contrôles passent,513erefusé et513blocs retirés |
| Essai23/argumentvide | Construire trois contextes,choisir la racine,retirer la liste | AuditLeaf→AuditChild→AuditRoot ; Root sélectionnée ;216allocations/libérations avantcleanuphôte |
| Essai24/argumentcorrespondant | Sélectionner l’enfant et consommer son argument | -audit-auditchild construit par5648A0 ;6F24A0/5D2490/5FE670 choisissentAuditChild et vident le vecteur ;217allocations/libérations |
| Propriété | Trois nœuds148,quinze buffers32 ; tousretirés | Sixchamps exacts/nœud,lien suivantvérifié ;906740efface2D78F20/24 ; caslistevide sansheap |
| Cycle des workers/CRT | Retrait normal et aucun secours forcé | DeuxworkersCRT0/joins/nativeclose ; zéroheap/TLS/section avantcleanuphôte ; sémaphores fermés nativement |

L’essai24 observe1753PCsXML et378PCs de champs/sélection,avec contrôle des octets PE à chaque instruction native exécutée. Cinq entrées originales d’allocation/chaînes sont sélectionnées aprèsstartupCRT. Restent les frontières déclarées de copieoctets,FILE en lecture seule,diagnostics,cookie etatexit. L’ordre du cleanup est une composition du harnais,pas une preuve de l’ordre de sortie historique complet. Le DLL/EXE historique est émulé dansUnicorn ; le C observateur actuel et le helperRust possèdent les ressourceshôte actuelles. Aucun codeC/Rust de production ni asset n’est modifié.

La première préparation du nouveau helper avait échoué à l’importPython d’unicorn,exit1 avant compilation. Le chemin tools/pythonlibs explicite corrige l’environnement ; compilation64bits0. Ce diagnostic et l’échec22 restent séparés du succès.

Les fonctions courantes de copie/destruction de chaînes restent de vrais consommateurs de la représentation24octets. Les cinq testsRust/deuxgroupes deV22 sont réutilisés sans les relancer,et leurs anciens corpus32/408/custom restent de simples replays. PackageProvider::prepared consomme une chaîne de couches explicitement préparée ; cette entrée actuelle est reliée précisément. Ni ces feuilles ni ce constructeur ne prouvent l’intégration d’un parseurXML de configuration ou d’un propriétaire racine complet dans le runtimeRust.

Restent ouverts : payload/argumentshistoriques réels,ressourcesI/O non vides,montage d’archive réussi et priorités exactesprovider/base/legacy/overlays,locale-source/génération,OS/NLS/FP etcontentions,customallocator,TLSfallback concretRust etwiring du propriétaire courant ; autresliaisons,divergencesAIR4312/4313 et contradictions communautaires. Une seule inconnue composée est affinée,sans fermeture. Les six tâches du Goal,leurs statuts et les cases/notes/révisions/historique restent conservés.

Preuves : [composition](reference_native_skin_loader_sources/original-overlay-configuration-chain.json),[intégration et audit](fidelity_registry_overlay_configuration_revision_4_20.json).
