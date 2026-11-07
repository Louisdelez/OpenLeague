# Audit SYS-01.2-02 — consommateur local de disponibilité des cartes, 2026-11-02

**Lot :** AUD-SYS-01.2-02-MAP-AVAILABILITY-CONSUMER-01  
**Exigence liée :** SYS-01.3-03 — qualifier la disponibilité des cartes par région et file de jeu (OLF-8206dc5c-7957-50e2-8a24-c9627166e84d)  
**Portée de ce lot :** relier les candidats de carte AIR déjà audités au démarrage et à l’admission de partie du moteur local; déterminer si ce chemin consomme une région ou une file.  
**Hors portée :** matrice historique EUW/région/file/date, activation du service original, exécution AIR ou client original, implémentation d’un sélecteur et acceptation du jeu.  
**Décision :** lot d’audit statique clos. SYS-01.3-03 et SYS-01.2-02 restent ouverts.

## Contrat et preuves réutilisées

La tâche SYS-01.3-03 demande de qualifier la disponibilité par région et file. Le rapport de classification V95 et ses revalidations V192/V254 restent les preuves source de ce lot; leurs recherches de service, contrôles et limites ne sont pas rejoués.

docs/reference_content_classification_sources/MapGeneratedData.as est l’export JPEXS déjà lié à AirGeneratedContent.swf du client AIR 0.0.1.119 dans docs/FIDELITY_CONTENT_CLASSIFICATION_LINKS_4_20.md. Il énumère dix objets générés. La ligne 35 décrit l’ID 10 comme TwistedTreeline, « The Twisted Treeline », totalPlayers=6. Cet export identifie une entrée et son nombre de joueurs; il ne donne pas une activation EUW, une file active ni une date de disponibilité.

Les sources AIR déjà auditées situent le filtrage dans PlatformConfigController (gameMapEnabledDTOList ou liste du service) et la demande de files dans GameQueueManager.getAvailableQueues. Le payload historique de ces services reste non récupéré dans les preuves V95/V192/V254. Elles ne permettent donc pas d’établir la matrice région × carte × file × date.

## Consommateur réel courant

Le code du serveur local fixe la carte au démarrage : crates/server/src/main.rs:16-27 charge assets/maps/tt_navigation_grid.json et tt_navigation_grid.cells.bin, puis appelle Simulation::enable_map10() et enable_map10_cast_ground().

Le chemin de connexion local ne choisit pas de carte, région ou file :

- crates/core/src/lib.rs:303-315 définit ClientPacket::Join avec champion et summoners.
- crates/client/src/session_connection.rs:168-170 émet cette requête Join.
- crates/core/src/lib.rs:533-545 admet le champion, fixe ses équipes et lit data/4.20/champion_spawns_map10.json.
- crates/core/src/lib.rs:535-538 refuse une septième admission avec « 3v3 lobby full ».

Une recherche bornée dans crates/core/src/lib.rs, crates/server/src/main.rs, crates/server/src/session_host.rs et crates/client/src/session_connection.rs pour les sélecteurs region, queue_id, available_maps, available_queues, map_selection, map_id et mapId n’a trouvé aucun hit. Ce constat porte sur le chemin d’admission inspecté; il ne prétend pas qu’aucun autre composant du dépôt ne puisse décrire une carte.

**Conclusion côté consommateur :** le consommateur de jeu actuellement établi sélectionne Map10 de façon fixe au démarrage et admet jusqu’à six joueurs; il ne consomme pas de disponibilité par région ou file. Les consommateurs AIR décrits plus haut sont des frontières de service du client historique, pas une preuve que le moteur Rust possède leur payload ou leur politique.

## Attendu, observé et limites de vérification

| Contrôle | Attendu à cette portée | Observé |
|---|---|---|
| Entrée AIR Map10 | ID, libellé et taille d’équipe relevés sans inférer une activation | ID 10, TwistedTreeline, six joueurs dans l’export existant |
| Consommateur du moteur | Le chemin qui choisit la carte et admet les joueurs est identifié | Le serveur charge le terrain TT et active Map10; Join ne transporte que champion et invocateurs |
| Refus local pertinent | Une équipe complète ne reçoit pas une septième admission | La garde de Simulation::join retourne « 3v3 lobby full » dès six joueurs |
| Disponibilité région/file | Une règle ou un payload historique utilisable est lié au sélecteur courant | Aucun sélecteur correspondant dans le chemin borné; payload du service original non récupéré |

Les résultats ci-dessus sont une lecture statique des sources. **Aucun test, build, client, serveur, AIR, réseau ou rendu n’a été lancé pour ce lot.** Le nominal d’admission et le refus à six joueurs ne sont donc pas déclarés reproduits à l’exécution. Les tests de roster cités dans le rapport V95 ne couvrent pas ce comportement et ne sont pas réutilisés comme preuve d’exécution de partie.

## Critères de clôture de ce lot

1. **Exigence et frontières : satisfait.** Uniquement le lien entre les données de carte existantes et le chemin local d’admission.
2. **Source et provenance : satisfait par réutilisation qualifiée.** Export AIR et rapports V95/V192/V254 réutilisés; dix entrées ne sont pas interprétées comme dix cartes activées.
3. **Consommateur réel ou absence : satisfait pour la portée.** Démarrage Map10, paquet Join et admission à six joueurs identifiés; absence des champs de région/file établie par la recherche bornée.
4. **Attendu/observé et contrôles : satisfait statiquement.** Code de sélection et de refus relevé; aucune exécution nouvelle n’est revendiquée.
5. **Écarts et inconnues : satisfait.** Payload régional/file, dates et disponibilité originale restent inconnus.
6. **Correction requise : satisfaite documentairement.** Réutiliser SYS-01.3-03; aucune nouvelle tâche, entrée de registre ou modification produit créée.
7. **Livrable et relecture : satisfait.** Rapport daté, empreintes des consommateurs courants, limites et condition de reprise consignées.

## Empreintes et contrôles réellement exécutés

SHA-256 relevés le 2026-11-02 :

- crates/core/src/lib.rs — CB2AF93A240737ED3F1D3EE31CF4FF916E730F402E7D0B128E7F29E5A3ED004D
- crates/server/src/main.rs — BEFC3F71AC9959061E18C5C63D8912887D7BE2485EF05A27253B1AC6AEF97512
- crates/server/src/session_host.rs — AE65F3A022F1D235751DBA408BA1A8856398F9E47943DDD3302B4F1428BC0BA7
- crates/client/src/session_connection.rs — FDD81B790BCA52DD4E20CA5D34E81D78136F3958AB7028F5CA193D078FB9ACD1
- docs/reference_content_classification_sources/MapGeneratedData.as — 0F2F7CF33A7D40433C34575C9F6FBFBB23693A0C9D1287C6563064E4CA413A44

Contrôles : lecture des sources nommées; Get-FileHash -Algorithm SHA256 sur les cinq fichiers ci-dessus; recherche rg -n -i --glob '*.rs' des sept sélecteurs dans les quatre fichiers du chemin d’admission. Recherche sans résultat. Aucun test/build exécuté.

## Condition de reprise et état

Reprendre la matrice de disponibilité seulement avec un payload EUW 4.20 pertinent pour gameMapEnabledDTOList et getAvailableQueues, ou une source primaire datée qui les remplace, et le callsite de sélection correspondant. Ne pas relancer l’export AIR ni les revalidations V95/V192/V254 sans nouvel artefact ou changement de hash.

- **Audit de ce lien consommateur :** terminé, périmètre borné.
- **Audit complet SYS-01.3-03 :** ouvert; activation par région/file/date non déterminée.
- **Implémentation de cette sélection dans le moteur :** absente de la portée examinée.
- **Vérification d’exécution :** non exécutée pour ce lot.
- **Acceptation humaine :** non demandée.
- **Goal SYS-01.2-02 :** reste partiel; aucun statut modifié.
- **Goal, Plan, UI, bases/registre de tâches, application, code produit :** inchangés.
- **Installation ou migration :** aucune.
