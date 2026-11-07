# SYS-01.2-02 — REA, commande audio et consommateurs actuels, V744

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Cette livraison relie une chaîne native supplémentaire aux consommateurs Rust réellement vérifiés. Le goal reste ouvert.

## Résultat de REA

REA6.4.0/Ghidra12.1.4 analyse un conteneur synthétique de9216octets. Celui-ci contient exactement les71octets de AF63B0,94octets de B09F80 et la constante255.0 de4octets, aux adresses originales. En-têtes et remplissages sont synthétiques. SHA256 du conteneur : f4578532586e12a62ddbfcf6b16fb59e967bbec4056ccb203493a9a50ba40a71. PE source :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Deux fonctions/55instructions sont décompilées ; corps, adresses et octets sont comparés avec le PE original et Capstone. REA identifie l’appel B09FD4→AF63B0 et son appelant B09F80. L’autre référence entrante,4000A8→B09F80, vient de l’en-tête synthétique : ce n’est pas un appelant historique. L’absence d’autres fonctions dans ce conteneur ne prouve aucune absence dans le client complet. Bundle et réponses conservés, close_binary/client/transport fermés, aucune erreur REA dans cette session. Aucun binaire original ou conteneur lancé comme jeu.

L’import complet V742 expiré après600s et le complément V743 restent conservés et référencés. Ils ne sont pas présentés comme de nouvelles exécutions. Le pseudocode est une reconstruction ; les instructions et observations restent la référence pour les conversions.

## Contrat original vérifié

B09F80 recherche object_id dans193seaux, à registry+20+(id%193)*4. Les nœuds contiennent next,key,object_pointer. Objet absent : retour2. Objet trouvé : appel AF63B0, qui refuse listener>=8 (comparaison non signée), sinon tronque input*255.0 puis écrit l’octet bas dans owner+38+listener et owner+40+listener et retourne1. Un pointeur d’objet nul et une chaîne cyclique ne sont pas qualifiés.

La file B06C60 sélectionne l’opcode20 à la table B07DC8 : branche B07618, appel B07634→B09F80. Message24octets : taille u16+0, opcode u16+2, mot opaque+4, object_id+8, listener+C, obstruction+10, occlusion+14. Le mot opaque reste une donnée fournie, sans interprétation inventée.

960cas natifs :480appels B09F80 directs et480passages dans B06C60 entier, quatre dispositions (tête, collision puis cible, seau vide, chaîne sans cible), six identifiants, quatre indices d’auditeur et cinq couples de flottants finis.183adresses d’instruction recoupées avec le PE. Attendu/observé : seules les deux positions prévues changent quand objet et indice sont valides ; sinon l’objet128octets est conservé. La file ignore le retour2 du corps, consomme le message et le marqueur de frame suivant : retour1, processed2, offset32, frame1. Le succès de la file ne prouve donc pas une modification de l’objet.

Exécution isolée Unicorn32 avec registre, ring et objet fournis. EnterCriticalSection/LeaveCriticalSection/SetEvent sont trois adaptateurs déclarés, dont ordre et arguments sont contrôlés. Aucun thread historique ou comportement de concurrence n’est qualifié. Les valeurs exceptionnelles V742 sont héritées ; elles ne sont pas rejouées dans cette matrice.

## Consommateurs Rust actuels et écart restant

Une sonde privée compile40fichiers source réels inchangés, vérifiés dans le fichier de dépendances rustc. Elle exécute Context::consume_with_dispatch et audio_main_sfx_mixed_transport::dispatch_global. Compilation hors ligne, sans incrémental, artefacts et temporaires sur F. Le premier essai de compilation omettait un module référencé après une section de tests ; l’échec101 est conservé. L’ajout de ce module réel à la sonde donne une compilation0 puis une exécution0. Aucun code produit changé.

480cas de transport utilisent un callback diagnostique qui mémorise le message et retourne Ok : mêmes paquets, ordre des services, processed2, offset32 et frame1 que la file native. Ce callback ne réalise pas le corps20. Les mêmes480paquets passent ensuite au vrai répartiteur main-SFX sélectionné : erreur explicite « other common-audio command requires its native body », processed0, offset0, frame0, file non consommée et états sentinelles du manager, des valeurs, Meter, graphe et cibles conservés. Ce répartiteur qualifie le profil RTPC/opcode2 ; son refus ne démontre pas l’absence de toute autre route dans le produit.

Cinq contrôles supplémentaires : marqueur seul accepté, opcode inconnu40 éliminé selon la file existante, trois paquets tronqués/mal dimensionnés refusés sans consommation. Le traitement ENVS, le corps20 Rust, le chargement et la sortie audible restent ouverts. Les preuves antérieures de calcul de gain/LPF ne sont pas promues en intégration complète.

## Intégration et vérifications

Cinq falsifications sont rejetées : confusion retour file/corps, octet objet corrompu, mauvais sélecteur, message refusé marqué consommé, conteneur synthétique présenté comme image complète. Deux rôles précis ajoutés pour la file actuelle et le refus du répartiteur ; une source de preuve ajoutée. SYS-01.2-02 et SYS-02.2-07 enrichies ; toutes les associations précédentes, inconnues et données manuelles sont conservées.

Documents modifiés : ce rapport, docs/fidelity_rea_queue_links_v744.json, docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Les deux bases du plan reçoivent uniquement les données/instructions des deux fiches et les métadonnées de catalogue, par deltas ciblés ; aucune sauvegarde intégrale supplémentaire. Pas de modification des cases, notes manuelles, historiques ou critères de fin.

Preuves privées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision744_owner_queue_native, revision744_rea_call_chain, revision744_rust_queue_boundary, revision744_queue_associations et revision744_delivery. Les scripts source, binaires de sonde, versions, entrées, empreintes et journaux figurent dans les reçus. La publication et sa relecture indépendante doivent chacune réussir ; voir VERIFIED.json et INDEPENDENT_READBACK.json.

Suite : production/enqueue amont de la commande20 et autres routes du code courant, parent B17486, transport240/244, raccordement ENVS, Meter, Init STMG/HIRC8/HIRC14, médias, locale, sortie audible. Aucun jeu, moteur audio ou goal complet accepté par ce lot.


## Relecture finale

Le contrôle indépendant réussit : octets et références REA, 960 cas natifs et 960 cas Rust recoupés. Les deux bases passent quick_check ; les 42605 autres tâches, 42607 états manuels, 23 historiques, 24 phases, 2770 lots et 42215 groupes sont identiques. L’inversion ciblée restitue exactement les octets antérieurs des trois registres. Les deux nouveaux rôles désignent la file et le refus du répartiteur sélectionné, pas le corps de commande20. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision744_delivery\INDEPENDENT_READBACK.json.
