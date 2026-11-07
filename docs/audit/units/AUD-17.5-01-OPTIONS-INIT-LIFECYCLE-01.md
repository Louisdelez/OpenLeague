# AUD-17.5-01-OPTIONS-INIT-LIFECYCLE-01

UTC : 2026-10-31T06:10:16.962464+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Qualifier le candidat821048,son caller,récupération d’Options et conditions immédiates de déclenchement. Fin documentaire : appel aligné,deux fonctions bornées,lien factory/récepteur,gardes/non-déclenchement et limites relus. Ni invocation réelle ni initialisation unique à vie ne sont inférées.
Audit : producteur terminé,clôture réservée à la relecture séparée. Implémentation : non modifiée. Vérification : désassemblage statique et intégrité exécutés;x86,ActionScript,Rust,jeu,GUI et réseau non exécutés. Acceptation humaine : non demandée. Goal et critères inchangés.

## R2 — Sources et bornes
PE original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — 15973880octets,SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. PE32x86,base préférée0x400000;VA préférées et rôles analytiques,pas adresses de processus ou nomsPDB.
Deux fonctions sauvegardées :820E40..821082 et587B70..588010. La seconde finit parret à58800F;une autre fonction commence immédiatement588010,sans padding. Un scan au premier int3 regroupait les deux :la preuve actuelle exclut la seconde et vérifie toutes les branches directes dans les bonnes bornes. Le candidat brut antérieur reste intact et lié à sa qualification nouvelle.
Factory/préfixe de construction et contrat payload/file/frontend antérieurs réutilisés sur octets et exports inchangés. Aucun nouveau scan d’assets,aucun réexport ni installation. Python,pefile,Capstone/DLL identifiés.

## R3 — Caller et récepteur réels
**820E40** lit le gestionnaire dans global2D77E54 et parcourt ses objets d’interface. À82103E,il prend le champ+98;821044/821046 testent le pointeur;821048 appelle directement82D770 s’il est non nul. Le branchement nul rejoint82104D et poursuit le parcours.
Le préfixe de construction antérieur81F070 lit le même global à81F0A4;la factory8583D0 est appelée à81F36D,puis le résultat stocké en+98 à81F372 et FoundryOptions.swf demandé. Même slotglobal/offset ne prouve pas la permanence d’une allocation entre deux invocations.
**587B70** est le caller immédiat amont :587DA6 appelle820E40. Le chemin d’admission commence par la comparaison signed de global2D788D4 avec2;JGE587BA2 rejoint la sortie. Un test plus tard de global2D77E80 peut éviter la suite;le chemin admis stocke2 à587C98 avant l’appel au parcours.
Consommateur82D770,payload InitializationData,file et frontend ModelFactory antérieurs conservés. Consommateurs OpenLeague de réglages et F11 inchangés;la recherche précise précédente est réutilisée sur1168sources identiques,sans absence universelle d’équivalent revendiquée.

## R4 — Attendu et observé
Deux fonctions complètes,510instructions,23instructions fixes et trois littéraux sauvegardés. Le caller local teste seulement le pointeur Options :pas de lecture locale du drapeau+90,ni bool de chargement/prêt à cet endroit. L’initialisateur82D770 garde son assertion !mInited déjà auditée;un appel direct du parcours n’est pas rendu inoffensif par la garde de phase extérieure.
Le gestionnaire est testé après le stockage de phase2. S’il est absent,l’assertion GUIMenu est appelée puis le global relu :si elle retourne et que le global reste nul,l’appel au parcours est sauté. Une entrée suivante avec phase toujours>=2 saute le bloc;cela ne prouve ni absence de reset ailleurs ni exactement-une-fois par partie. Le chemin alternatif du test2D77E80 porte le diagnostic natif gPTR_Input absent,avec piste de reconnexion;ce libellé n’est pas une panne runtime observée.
Les sept cas suivants sont des observations statiques,pas des exécutions paramétrées originales :

### L1
- Attendu : On normal completion of preceding calls,phase<2 and the later guards allow the interface visit;nonnull Options field+98 invokes82D770.
- Observé : 587B9B/BA2 admit the signed phase branch;phase2 is stored at587C98;587DA6 calls820E40;82103E/1044/1046 select the nonnull field and821048 calls82D770.
- Limite : Source preconditions and normal returns only;actual scheduling,pointers,movie readiness and frontend success unobserved.

### L2
- Attendu : An entry phase>=2 skips the entire earlier initialization block on that invocation.
- Observé : Signed JGE587BA2 targets587FFE,whose path returns58800F before587DA6. Other writers/reset epochs remain outside this proof.
- Limite : Not a lifetime exactly-once guarantee;phase meaning/current value and external mutations unqualified.

### L3
- Attendu : A null Options member skips only its local call and proceeds with the interface visitor.
- Observé : 821046 jumps82104D;there is no call82D770 along this local false branch. No init flag/ready/loader bool is tested at that gate.
- Limite : The manager object and preceding visitor calls still need valid prerequisites;not proof of a safe null manager or a validated missing-feature UX.

### L4
- Attendu : If manager is still null after the assertion returns,the upstream visit is skipped despite phase already set2 on this normal path.
- Observé : 587D95 calls assertion991E60;587D9D reloads the global and587DA4 skips587DA6 ifzero. Phase write587C98 precedes these sites.
- Limite : Assertion abort/throw/return policy unqualified;no automatic same-phase retry is present at this entry gate,external reset/calls may exist.

### L5
- Attendu : A zero late global2D77E80 check bypasses the phase store and interface visit in this block.
- Observé : 587C89 jumps587F59 before587C98/587DA6;diagnostic and later cleanup remain. Earlier code already used the global,so this is not a safe null-at-entry refusal.
- Limite : Global writers/intervening calls and initial object validity are unknown;no parameterized native null case executed.

### L6
- Attendu : Calling the visitor again with nonnull Options has no local already-initialized gate.
- Observé : Its Options subsequence has only the pointer test before82D770;the earlier host audit separately saves that initializer’s+90 assertion and lack of explicit early return.
- Limite : Does not assert a repeated runtime call occurred or that an assertion is a safe rejection. At-most-once is conditional on outer phase being retained and this route being used.

### L7
- Attendu : Factory/load,visit,queue and frontend execution must remain separate claims.
- Observé : Both construction and visitor read global2D77E54/member98;previous82D770 source queues the payload. This caller proof does not change the saved queue-transfer/invoke failure boundaries.
- Limite : Allocation lifetime,effective resources,live environment,delivery and actual rendered/current Options lifecycle remain open.

## R5 — Limites et reprise
Le test tardif de global2D77E80 n’est pas une preuve de refus sûr d’un objet nul à l’entrée :le préfixe l’utilise déjà. Les assertions peuvent interrompre,jeter ou revenir selon une politique non qualifiée. Les callbacks des autres interfaces sont hors du contrat Options et supposés revenir normalement pour ce chemin.
Phase/pointeurs non observés;ordonnancement,réentrance,remises à zéro,autres routes et durée de vie restent ouverts. Une garde de phase locale n’est pas une garantie à vie. Pointeur non nul ne prouve ni readiness,communication liée,livraison ni rendu;les limites de file antérieures restent valides.
- **OPTIONS-RUNTIME-LIFECYCLE** — Manque : The scheduler,phase resets/other callers,actual pointer lifetime and readiness/runtime outcomes are unobserved. Reprise : Use phase-global2D788D4 and the qualified587B70 entry with named scheduling/reset evidence;separate normal static guards from live invocation and exceptions.
- **OPTIONS-EFFECTIVE-RESOURCES-CONTEXT** — Manque : Live environment values,effective movie/provider and mapped InternalPanel content/applicability remain open. Reprise : Reuse named globals/virtual producers,three movie variants and source include/filter proofs;new provider/container or effective producer evidence required before broad scans.
- **OPTIONS-FUNCTIONAL-CONTROLS** — Manque : Full widget/callback/control-state graph and actual current Options opening/edit/apply/cancel/focus/persistence are not qualified. Reprise : Reuse HUD-OPTIONS-ENTRY-01 and real settings consumers;take one source-backed widget/callback result next,with distinct product authorization and runtime evidence if implementation is requested.

## R6 — Corrections réutilisées
**HUD-OPTIONS-XML-INPUTS-01** conserve sa définition et reste proposée,non appliquée. Avancée :le déclenchement natif local et sa phase amont sont reliés au consommateur. **HUD-OPTIONS-ENTRY-01** est aussi réutilisée sans changement pour le parcours fonctionnel restant. Aucune nouvelle tâche concurrente ni écriture de registre.
Le candidat821048 n’est plus une recherche à refaire. Réutiliser ces fonctions et les garde-fous de file;une preuve de scheduler/reset ou une nouvelle source de ressource/contexte est nécessaire avant d’étendre la conclusion. Sinon poursuivre un contrôle/callback concret du menu dans les exports existants.

## R7 — Livraison,relecture et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INIT-LIFECYCLE-01\options-init-lifecycle-proof.json`. Script et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INIT-LIFECYCLE-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INIT-LIFECYCLE-01\delivery-readback.json`;elle seule peut clore ce sous-lot après les sept rubriques.
Cinq registres,25fichiers gelés et1168sources inchangés;Git HEAD/branche/76modifications antérieures conservés. Sources originales et preuves antérieures intactes. Goal,critères,application de suivi,interface et bases inchangés;aucun accès runtime au suivi/bases,aucune installation ou migration.
Clôture limitée au contrat statique du caller et des conditions immédiates d’initialisation Options. SYS-17.5-01 et SYS-01.2-02 restent ouverts;78contrôles logiques antérieurs inchangés,aucun menu/jeu complet ni acceptation humaine revendiqués.
