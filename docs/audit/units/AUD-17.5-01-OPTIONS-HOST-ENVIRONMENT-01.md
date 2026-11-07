# AUD-17.5-01-OPTIONS-HOST-ENVIRONMENT-01

UTC : 2026-10-31T05:59:10.114580+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Qualifier le producteur natif de InitializationData.environment/xml et son chemin de communication jusqu’au consommateur frontend déjà identifié. Fin documentaire : construction,termes,gardes,file et interfacefrontend reliés par source;valeurs et résultats runtime séparés. Ce lot ne qualifie pas le menu fonctionnel ni le tableau effectif.
Audit : producteur terminé,clôture réservée à la relecture distincte. Implémentation : non modifiée. Vérification : désassemblage statique et intégrité exécutés;aucune exécution x86,ActionScript,Rust,jeu,GUI,réseau ou sondeDLL. Acceptation humaine : non demandée. Goal et critères inchangés.

## R2 — Sources et provenance
PE original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — 15973880octets,SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. PE32x86,base préférée0x400000;les VA sont des repères du fichier,pas un processus lancé.
Preuve frontend précédente et relecture réutilisées après vérification d’empreintes;306exports AS3 conservés,aucun nouvel export ni installation. Préfixe82D770..82E091 antérieur conservé,maintenant complété jusqu’au vrai retour82E5C2. Outils Python,pefile,Capstone et sa DLL identifiés.
Locale par défaut : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\locale.cfg` — SHA256 `053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f`,déclaration en_GB. Cette source ne prouve pas la valeur globale effective2D78D08 ni la brancheCRT active.

## R3 — Payload,file et consommateur
82D770 construit le message via8316E0. Ce constructeur demande InitializationData au constructeur de base785EA0,qui crée un payload avec propriété target. Il crée ensuite le tableau local+40 et le lie à environment. Dans l’initialisateur,le payload reçoit xml à82E210 après838020,puis82E24C appelle7971E0.
**7971E0 est une mise en file,pas une livraison frontend.** Il copie le wrapper via79A4D0 et avance de0x38octets. Les valeurs GFx du wrapper conservent le target et le payload;le tableau environment est rempli par les appels+3C sur la même valeur.
784710 prépare la communication en cherchant Main puis module,et lie updateArray/update via786C50. Main.module est de type FoundryOptionsModule dans la source AS3 existante. 784CA0 appelle786D70 si ses gardes le permettent;786DE0 transfère les payloads+18 dans le tableau lié;le slot+1C invoque la fonction liée si son type correspond. FoundryModule.update retire updateArray.shift(),lit target et appelle le callback lié;InitializationData est ce callback dans Options. Ce raccordement est structurel,non une observation de livraison.
Consommateurs actuels de réglages et F11 conservés. Recherche lexicale précise précédente réutilisée sur les1168sources inchangées;absence des noms exacts ne signifie pas absence de tout équivalent autrement nommé.

## R4 — Construction des termes et contrôles
Ordre du chemin normal ci-dessous. Les producteurs dynamiques restent nommés;aucun tableau DEBUG substitué :
|Famille|Construction|Garde / limite|
|---|---|---|
|locale|locale:+global2D78D08 string,then5FA650→C98719 character transform|Unconditional on normal init path;default CRT branch maps ASCII A..Z to a..z,alternate locale helperC985D6 remains dynamic.|
|map|map:+C9BEFC(field[global2D7878C+4],buffer,radix10)|Unconditional on normal init path;actual map field/formatter result not executed.|
|context|replay when global2D787B8.virtual+B0 returns true;game otherwise|Mutually exclusive source branches;method identity/runtime bool unqualified.|
|name|summoner:+string returned by716CE0(global2D77F48)|Only the game branch reaches this call;getter/cached value/diagnostics saved,actual identity unqualified.|
|features|feature:+each string in list returned by990A80(global2D79104)|Empty begin/end skips;loop advances0x18 bytes;producer activation policy/values remain dynamic.|
|platform|windows|Unconditional literal on normal init path.|
|lighting|alienware|LoadLibraryA("LightFX.dll") nonnull then FreeLibrary;this is not proof of an attached device. No DLL was loaded by this audit.|
|shader|shadermodel3|Unsigned [global2D79078+0x78]>=0xFFFF0300;field producer/effective capability not qualified.|
|mutators|mutator:+each string between[global2D7878C+0x64]and[+0x68]|Empty range skips;loop advances0x18 bytes;actual mutators remain dynamic.|

Locale :5FA650 applique C98719 caractère par caractère. Dans sa brancheCRT par défaut,A..Z deviennent a..z;la branche alternative appelleC985D6. Ainsi,si la valeur source est en_GB et cette branche par défaut est utilisée,le terme devient locale:en_gb. Ce cas conditionnel ne constitue pas une mesure de la locale runtime ni une preuve de visibilité Phreak.
Sonde LightFX : les imports du PE attestent LoadLibraryA/FreeLibrary. Aucun appel n’a été exécuté. Une réussite de chargement ne prouverait pas un périphérique connecté. Le seuil shader est la comparaison numérique unsigned exacte;le producteur du champ et sa valeur ne sont pas inférés.
14fonctions entièrement alignées et bornées,73instructions fixes,19littéraux et2imports identifiés. Toutes les branches directes des fonctions sauvegardées restent dans leurs bornes. Les cas suivants sont des observations de code,pas des exécutions paramétrées originales :

### H1
- Attendu : With valid initialized prerequisites,the payload contains target InitializationData,an environment array and xml,then is queued for frontend processing.
- Observé : 8316E0/785EA0 construct target and payload;environment field+40 assigned to property;82E210 setsxml;82E24C calls7971E0,which copies a0x38-byte queue value. Frontend update routes target to bound InitializationData.
- Limite : Source structure only;valid owner/comm/runtime interface and actual delivery not executed.

### H2
- Attendu : The two context branches select replay or game;the name term is confined to game.
- Observé : Virtual+B0 result tested82DA6F;true branch adds replay then jumps82DBE8;false branch adds game and reaches716CE0/831790 for summoner prefix.
- Limite : Virtual predicate role inferred from branches/literals;no observed match/replay/user identity.

### H3
- Attendu : A source en_GB string on the default CRT transform path produces locale:en_gb,not the debug locale:en_us.
- Observé : Global string appended to locale prefix;5FA650 callsC98719 per character. Its default branch adds0x20 to ASCII A..Z. The supplied default cfg saysen_GB;effective global and CRT branch remain unqualified.
- Limite : Conditional analytical consequence;not a runtime observation or proof that Phreak UI is hidden.

### H4
- Attendu : Optional feature/mutator ranges and capability probes must not be replaced by debug constants.
- Observé : Two ranges loop strings;LightFX LoadLibraryA result controlsalienware;unsigned field threshold controls shadermodel3. Windows literal is separate.
- Limite : Feature/mutator producers,library availability and device/global capability values not observed.

### H5
- Attendu : If movie-update global mode==2 or byte+33!=0,the queue flush is skipped on that call.
- Observé : 784CB1/784CB7 branch past786D70;the caller otherwise tests nonnullcomm then flushes.
- Limite : Flag meaning/current values and later retries not qualified;skip is not a permanent refusal claim.

### H6
- Attendu : Queued data is not proof of invocation;missing array/function bindings have explicit source guards.
- Observé : 786DE0 transfers only for type9;786D70 then clears queued values and resets end before testing function type0xB. Invoke+1C occurs only on matching function type. Transfer virtual returns are not checked here.
- Limite : Normal source path may discard queue without a confirmed frontend call;GFx implementations/errors/exceptions not executed.

### H7
- Attendu : An already-set init flag is not automatically a proven safe duplicate-init refusal.
- Observé : 82D7B2 checks+90 and calls assertion991E60 on nonzero;there is no explicit early return there. The helper may abort/throw/return under unqualified runtime policy.
- Limite : No duplicate-init execution or assertion-policy inference;valid comm/owner prerequisites required.

## R5 — Manques et conditions de reprise
La file doit disposer d’un owner et d’une communication initialisés : le premier enqueue utilise le pointeur+24 sans refus null explicite dans ce chemin. Aucun succès n’est inventé pour prérequis invalides. L’assertion !mInited n’est pas qualifiée comme un refus sûr :si son helper retourne,le code continue.
Sur le chemin normal de flush,le type de tableau9 garde le transfert,mais la file est ensuite nettoyée avant le test de fonction0xB. Les retours du transfert virtuel ne sont pas vérifiés ici. Une file alimentée ne prouve donc ni callback exécuté ni rendu. Exceptions,gestion du pool et politique de reprise restent non exécutées.
- **OPTIONS-EFFECTIVE-CONTEXT** — Manque : The actual global/virtual values and invocation lifecycle are not observed;default locale and static term construction do not establish the full runtime vector. Reprise : Use named producer globals and virtual slots in the term table;qualify the caller candidate821048 with an aligned full function/context before treating it as a lifecycle proof. No DEBUG substitution.
- **OPTIONS-SELECTED-CONTROLS** — Manque : Effective movie/provider and mapped InternalPanel content/public applicability,complete widget/callback graph remain open. Reprise : Require named provider/container/public applicability evidence and reuse pinned movie/XML sources;no filename/asset scan without new lead.
- **OPTIONS-DELIVERY-RUNTIME** — Manque : GFx implementation/binding failure,exceptions,actual frontend invocation and current Options editor lifecycle remain unqualified. Reprise : Preserve queue loss/guard boundaries and real settings consumers;separate scope for safe runtime observation or product correction;do not label a queued message as a successful rendered menu.

## R6 — Correction existante
**HUD-OPTIONS-XML-INPUTS-01** réutilisée avec définition inchangée;aucune nouvelle fiche concurrente ni écriture de registre. Avancée : payload environnement,neuf familles,gardes et communication source reliés au filtre frontend. La fiche reste proposée,non appliquée et ouverte pour contexte effectif,ressources et contrôle complet.
Prochaine reprise discriminante : qualifier les producteurs dynamiques et le caller d’initialisation avant une conclusion de contexte réel. Un candidat E8 relatif à821048 vise82D770;son alignement/caller/lifecycle ne sont pas qualifiés par cette occurrence seule. Pas de scan d’assets ou de réexport identique sans nouvelle source.

## R7 — Livraison,relecture,conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HOST-ENVIRONMENT-01\options-host-environment-proof.json`. Script et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HOST-ENVIRONMENT-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HOST-ENVIRONMENT-01\delivery-readback.json`;elle seule peut clore le sous-lot documentaire après examen des sept rubriques.
Cinq registres,25fichiers gelés et1168sources applicatives inchangés;Git HEAD/branche/76modifications antérieures conservés. Sources originales,locale et exports/proofs antérieurs conservés. Goal,critères,application de suivi,interface et bases inchangés;aucun accès runtime au suivi/bases,aucune installation ou migration.
Clôture limitée au contrat statique de construction et de communication du payload environnement. Le parent SYS-17.5-01 et le goal SYS-01.2-02 restent ouverts;78contrôles antérieurs inchangés,aucun menu fonctionnel,jeu terminé ou acceptation humaine revendiqués.
