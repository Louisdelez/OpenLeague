# SYS-18.1-02 — récupération source des cinq conteneurs

2026-11-01T17:25:50.082457+00:00

Lot de récupération source terminé sous réserve de relecture ; parent d’audit images toujours ouvert. Aucune installation de média dans le launcher,aucune image individuelle exportée ou acceptation de rendu.

Extraire les images du patcher depuis les fichiers fournis
Le résultat « Extraire les images du patcher depuis les fichiers fournis » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Résultat
Cinq conteneurs live récupérés sur F,64340056octets,438membres LOAD ; tailles et MD5 conformes au manifeste natif. Les12LOAD du manifeste sont désormais présents comme sources qualifiées, sans réécrire le contrat ancien à7bundles.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-assets.load — 54448044octets ; MD5 0b9e2bb8b82f9ea32549f666a1c294d8 ; SHA256 f2b24e6fb353f42c303f8e9a3bc5632f25cbbbf856ad3594427a29e53c26ecc1 ; 149membres ; F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01\bundle-assets.load.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-dev.load — 449240octets ; MD5 d5eec71317fa25d43430f0a0cbdd5e5f ; SHA256 e7e3c7ad1d0b40128eedad7f47db2b7d919429be0263866bbec35e37923dfc5e ; 10membres ; F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01\bundle-dev.load.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-hub-news-A.load — 665232octets ; MD5 b4d1b90a862d2e30820444a8608abf6b ; SHA256 fc5b0265d17f736c62df3bd59d1552a63bec0dee05638c9ab94f789f8967ebb2 ; 18membres ; F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01\bundle-hub-news-A.load.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-hub-news-B.load — 1380368octets ; MD5 518ff65771d7d6b9dd5e68bd8b6a94e3 ; SHA256 83ea0b50dc92ca640742aa44a192eed3acf443b7d37b4b2b21f3f6ece30eb271 ; 19membres ; F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01\bundle-hub-news-B.load.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-vendor-lib.load — 7397172octets ; MD5 cfadc55c2ccf445a38d34abe7be68b6e ; SHA256 566d131b48f6f85bb08219c340604d3060fa38ecf1992c5291585140d21d07b8 ; 242membres ; F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01\bundle-vendor-lib.load.

## Provenance et méthode
Footer RBUN distant identique au fichier conservé. XXH64 de la table38861456entrées conforme au footer. Méthode source recover_air_assets et copies C++ relues,non exécutées ; décodeurs déjà présents. Le README évoque WinFsp mais aucune installation/montage n’a été effectué.
4125blocs locaux réutilisés ;2341nouveaux blocs dans25plages contrôlées pour9299661octets,plus130694octets de descripteurs. L’archive entière258607208429octets n’est pas téléchargée. Chaque206/Content-Range et longueur est enregistré ; les refus de200/mauvaiseplage/gzip sont des contrôles locaux de méthode.
L’ancien fichier rads_archive_metadata concerne un autre identifiant d’archive et n’a pas servi à qualifier la taille courante. La page archive était inaccessible au navigateur de recherche ; les requêtes réelles de métadonnées200/footer et données206 ont réussi.

## Contrôles attendus et observés

### TRANSPORT
Attendu : Bounded206ranges, exact response extent, no full-archive body.
Observé : Metadata200,footer206,one130694byte descriptor interval and25content intervals totaling9299661bytes retained. Local guard fixtures reject200,wrongrange andgzip.
Limite : Fixture refusals are local method checks, not events from the archive server.

### SOURCE-IDENTITY
Attendu : Each assembled file matches selected live path and native RLSM size/MD5.
Observé : Five files,64340056bytes,all native MD5/size and LOAD structure checks pass;438member records.
Limite : This proves these source bytes, not their display/public availability or complete image extraction.

### DESCRIPTOR-MASK
Attendu : Use actual Packed getter masks without inventing zero requirements.
Observé : Nonzero high bits preserved opaque; low28size and low4hash-type produce exact file sizes. Initial failed zero-bit assertion and its transport data retained.
Limite : Archive chunk-ID hash algorithms were not reexecuted; selected complete files are checked against native MD5.

### CASE-AND-RESUME
Attendu : Retain exact native A/B names and reuse completed work.
Observé : Initial lowercase-only guard failed after two verified payloads. Exact native whitelist assembled the remaining three from retained intervals,zero new HTTP;earlier completed files untouched.
Limite : Two preparation failures are not game defects or discarded proof.

### REMAINING-SCOPE
Attendu : Separate recovered LOAD sources from extracted images and installed launcher.
Observé : Twelve LOADsources now present at qualified locations;old7-bundle contract,production code/UI and task statuses unchanged.
Limite : Image populations,vector/font distinction,possible images outside LOAD and actual extraction/render still need audit.

## Échecs conservés et reprise
Le premier parseur ajoutait une condition de bits opaques nuls absente du getter C++ ; HTTP206etles130694octets sont restés conservés. Qualification par les masques exacts,aucune requête supplémentaire.
Le premier assembleur rejetait A/B à cause d’un validateur de noms seulement minuscules ;25plages et2payloads déjà réussis conservés. Les3restants ont été assemblés depuis les mêmes données,0requête rejouée. Aucun fichier réussi écrasé.

## Ce qui reste ouvert

### PATCHER-COMPLETE-IMAGE-COVERAGE
Les sources LOAD manquantes sont récupérées ; la population d’images des12conteneurs, les ressources vectorielles/polices et les éventuelles sources d’image hors LOAD ne sont pas encore toutes confrontées à l’objectif.
Reprise : Réutiliser les12sources qualifiées et les115images déjà auditées ; inventorier extensions/signatures et sources hors LOAD réellement listées ou référencées, sans nouvelle récupération identique.

### PATCHER-MATERIALIZATION-AND-RENDER
Aucune nouvelle image individuelle écrite, aucun pixel/frame décodé ou écran launcher installé/qualifié.
Reprise : Notes par membre et tâches18.1.02/06..08 existantes, avec réalisation et recette autorisées séparément.

## Sept rubriques et livraison
- 1 : Récupération des cinq sources,exigence parente d’images préservée.
- 2 : Métadonnées exactes,footer distant et checksum TOC,manifestes natifs et payloads identifiés.
- 3 : Méthode de récupération antérieure relue,nouvelle collecte bornée et vrai lecteur LOAD ; pas intégration produit.
- 4 : 28HTTP de référence,cache réutilisé,MD5 natifs/LOAD vérifiés ; refus locaux et échecs préparatoires distingués.
- 5 : Manque des cinq payloads levé ; population d’images complète et rendu restent ouverts.
- 6 : Pas de tâche générale nouvelle ; corrections de préparation et critères originaux conservés.
- 7 : Ajouts inventoriés/épinglés,lecteur distinct,goal/Plan/app/bases inchangés.

La récupération source est concrète et vérifiée pour cinq conteneurs. L’audit complet des images et leur matérialisation ne se déduisent ni du nombre de membres ni des MD5 : parent conservé ouvert.
Exécutés : lectures binaires,HTTP source bornés,checksum table et MD5/LOAD,contrôles documentaires. Non exécutés : jeu/launcher/AIR/Rust/GUI/GPU ou réseau du jeu,image pixels/frames,export individuel,REA,anciens tests/lecteurs. Les algorithmes d’ID des chunks ne sont pas rejoués ; chaque fichier complet est comparé au MD5 natif.
Nouveaux fichiers de sources : F:\OpenLeague-work\audit-source-recovery\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01 ;70fichiers/empreintes listés dans inputs.json et la preuve. Ajouts d’audit : ce rapport et F:\OpenLeague-work\audit-units\AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01. Aucun goal,critère normatif,produit,Plan/UI,registre ou base modifié.
Prochain lot : AUD-18.1-02-PATCHER-IMAGE-COVERAGE-01 — Confronter les images effectives des12LOAD et les éventuelles sources hors LOAD au périmètre d’extraction, avec distinction raster/vectoriel/police, matériel conservé,consommateur et usage rendu.
