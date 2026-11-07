# AUD-17.5-01-OPTIONS-SURRENDER-01

UTC : 2026-10-31T07:07:23.987009+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Bouton Abandonner de FoundryOptions :états déclarés,canSurrender,publisher/message et demande native immédiate. Audit terminé côté producteur;clôture réservée à la relecture indépendante. Implémentation non modifiée;vérification statique seulement;acceptation humaine non demandée. Règles serveur,vote complet et input physique restent distincts.

## R2 — Sources et héritage
PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. VA préférées0x400000;rôles analytiques,pas symboles PDB ou adresses runtime. XML et scripts/outils/Capstone/DLL sont épinglés.
306exports AS3 et p-code existants réutilisés,sans réexport. Cinq méthodes nouvelles sont retrouvées par octets uniques dans le DoABC. La registration et le site init sont pris dans des fonctions déjà alignées,dont les octets complets sont comparés au PE. Aucune ancienne analyse des commandes ou du vote n’est relancée.
AUD-17.3-06-TEAM-VOTE-01 conserve sa clôture documentaire parente,ses sources et ses huit corrections V1..V8;sa fonctionnalité reste non terminée. AUD-17.3-06-SURRENDER-01 et le prédicat de pause sont réutilisés par identité. Cette nouvelle surface Options ne remplace pas l’interface yes/no du vote.

## R3 — Chaîne réelle et consommateurs
surrenderLabel=flash_optionsMenu_surrender rejoint placedButtons[2]. En INGAME/GFXPLAYER,label/clic sont branchés et enabled=false;dans les autres environnements visible=false. La branche positive ne force pas visible=true :le sprite/timeline et la sélection effective restent ouverts.
Le modèle canSurrender commence false. SetSurrenderData transmet le champ casté Boolean au setter,qui émet SurrenderStateChange. Le handler de vue règle enabled true/false. onSurrenderClick appelle seulement Surrender,sans garde locale enabled/canSurrender;aucun bypass physique n’a été exécuté.
82E8F0 reçoit un booléen. Avant init+90,il mémorise l’octet+91 et retourne. Après init,comm+24 absent saute l’envoi;sinon il construit8319E0 puis ajoute à7971E0. Le site init82E251..82E298 pose+90 et publie true seulement si cached+91 et comm existent. Le modèle false initial ne prouve ni réception ni état serveur. 8319E0 nomme SetSurrenderData et ajoute canSurrender au payload.
Le candidat amont63F722 est un match brut E8/rel32 vers82E8F0;fonction englobante et producteurs du booléen non qualifiés. Ce n’est pas une preuve d’alignement,permission ou règle serveur. La file n’est pas une livraison;ses limites antérieures restent applicables.
La registration associe Surrender→8300C0. Celui-ci exige le contrôleur global2D791A4 et son drapeau initialized+14. Le chemin invalide comporte diagnostic et écriture nulle;il n’est pas un refus gracieux. Slot10 vrai saute fermeture/envoi. Pour la classe déjà qualifiée10DEAC4,ce slot lit paused;la classe réellement sélectionnée n’est pas observée.
Sinon8244F0 ferme les options avant l’appel transport+30. La requête fait6octets :A4,dword issu2D62CBC,bit0 final mis à1. Les sept autres bits ne sont pas initialisés par ces stores;la signification du dword reste ouverte. Résultat d’envoi non vérifié. Aucune création ni acceptation de vote déduite du menu fermé.
La commande chat positive passe par7E3100,avec marqueur/liste et sélectionA4/FB;ce bouton Options n’appelle pas ce helper et transmetA4 directement. Ces routes ne sont pas déclarées identiques. Les sources et écarts V1..V8 restent conservés sans autre majorité,délai ou règle inventée.
Consommateurs actuels :16fragments du vote antérieur relus et inchangés sur le même corpus1168sources. La recherche exacte antérieure est réutilisée après vérification du corpus,pas relancée. Retrait individuel,reconnexion,résultat Nexus et abandon du launcher restent des comportements distincts du vote d’équipe.

## R4 — Contrôles et cas
5méthodes bytecode,3nouvelles fonctions natives complètes,35instructions fixes et deux sites réutilisés vérifiés. Aucun x86,AS,Rust,jeu,réseau,GUI,input physique ou nouveau vote exécuté. Les branches et diagnostics sont des observations de source,aucun crash ou refus en partie reproduit.

### C1
- Attendu : Surrender label/event wiring and declared hidden context are separated from an assumed visible sprite state.
- Observé : placedButtons[2] supplies label. INGAME/GFXPLAYER branch wires click and starts disabled;other environments set visible=false. No visible=true assignment in that branch was found.
- Limite : Positive visibility depends on sprite/timeline/current context;actual movie rendering,focus and physical disabled event suppression are not executed.

### C2
- Attendu : The model starts with canSurrender=false and incoming state updates drive enabled,without becoming authoritative vote admission.
- Observé : SetSurrenderData casts canSurrender to Boolean and model setter emits SurrenderStateChange;view state handler sets enabled true/false. Click handler calls Surrender only and has no own enabled/state guard.
- Limite : Malformed object/coercion and real event order unqualified. No bypass or vote refusal was executed;UI property is not a server authorization rule.

### C3
- Attendu : The native state publisher has distinct pre-init,post-init/no-comm and queued-message branches.
- Observé : 82E8F0 stores input byte at+91 before+90init;after init,it skips absent+24comm or constructs8319E0 and appends7971E0. Host init sets+90 then queues true only when cached+91 and communication are nonzero.
- Limite : No queue/delivery/consumption observed;cached false relies on model defaults in that init path. No lifetime/retry guarantee or full permission producer qualified.

### C4
- Attendu : State-message construction and frontend receipt are linked while upstream permission remains precisely open.
- Observé : 8319E0 names SetSurrenderData and writes canSurrender from supplied byte. Source frontend model route is matched in original bytecode. Raw caller candidate63F722 targets82E8F0 but its enclosing function is not qualified.
- Limite : No server timing,eligibility,mode or quorum inferred from the Boolean. Candidate raw E8 bytes are a resume lead,not an aligned producer proof.

### C5
- Attendu : The native Surrender callback has controller guards and a normal predicate skip,with invariant failures named honestly.
- Observé : 8300C0 requires controller2D791A4 and initialized byte14 or reaches diagnostic/null-write path. Slot10 true skips close/send;the inherited known class reads paused but actual runtime vtable is unobserved.
- Limite : Invalid context is not a graceful refusal;logger/assert/null store not executed. No generalized controller-class or server policy inferred.

### C6
- Attendu : A normal request is distinct from an accepted vote or a closed menu confirming success.
- Observé : Predicate false calls8244F0 then sends6bytes through transport virtual30:opcodeA4,dword2D62CBC,final bit0set1. Other7bits are not initialized by these stores;return is not checked.
- Limite : Identity meaning,other bits,transport validity,dynamic pause state and server receipt/result unqualified. Menu close occurs before the send attempt.

### C7
- Attendu : Options and chat surrender routes are compared without silently treating different local gates as one implementation.
- Observé : Existing chat helper7E3100 includes marker/list and context-selectedA4/FB;Options callback sendsA4 directly without that helper. Prior source audits and8vote correction definitions are retained.
- Limite : No full wire equivalence or alternateFB meaning claimed. Quorum,timers,server state,results and reconnection remain in existing corrections.

### C8
- Attendu : Actual current consumers and vote audit closure are reused without confusing launcher abandonment with a team vote.
- Observé : Closed team-vote source audit retains16current consumer fragments and an exact query over the identical1168source corpus. Retire/reconnect/result consumers are partial existing behavior,not vote service.
- Limite : Query is inherited after source identity verification,not rerun. Current gameplay functionality and Options button not implemented by this documentary delivery.

## R5 — Écarts et reprise
- **SURRENDER-BOOLEAN-UPSTREAM** — Manque : Upstream permission producer around raw candidate63F722,actual controller vtable/instance and effective game/mode/server eligibility remain unqualified. Reprise : Decode the enclosing caller with a bounded prologue/CFG and source-backed inputs if this is the next question;server timing/quorum/rules still require native4.20source or a controlled trace under V1.
- **SURRENDER-DELIVERY-RULES** — Manque : Actual state delivery,transport identity/other packet bits,server vote admission/results and physical disabled/visible/focus behavior are unobserved. Reprise : Reuse existing queue and V1..V8 contracts;qualify one named receiver/rule or actual runtime scenario separately. Never use enabled,menu closure,AL return or A4 request as accepted vote evidence.
- **SURRENDER-CURRENT-SERVICE** — Manque : Current team-vote service and Options surface integration remain functional gaps;individual retirement/launcher abandonment is not a substitute. Reprise : Reuse HUD-OPTIONS-ENTRY-01 and SYS-17.3-06/V1..V8 criteria under a separate authorized product scope;preserve existing reconnect,retire,Nexus-result and launcher flows.
La publication,les états enabled/visible et les règles de scrutin sont trois niveaux distincts. Les inputs malformés,exceptions,instances,delivery,quorum,délai,identités et résultats restent ouverts. Pas d’autorité serveur donnée au champ de présentation et pas de qualification d’un refus sûr à partir de l’échec d’invariant.

## R6 — Corrections réutilisées
HUD-OPTIONS-ENTRY-01 garde sa définition et son statut proposé,non appliqué. Les huit fiches SYS-17.3-06/V1..V8 sont reprises telles quelles depuis l’audit clos du vote. Aucun doublon,aucune modification de statut normatif ni nouvelle correction produit.
Avancée documentaire :source de l’état Options,publisher/cache/init,message et commande directe sont liés. La règle amont,le service de vote,la résolution,la reprise et l’interface actuelle restent des corrections fonctionnelles séparées,avec les critères existants.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SURRENDER-01\options-surrender-proof.json`. Spécification/scripts isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SURRENDER-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SURRENDER-01\delivery-readback.json`;elle seule clôt ce sous-lot après les sept rubriques.
Cinq registres,25fichiers gelés,1168sources et Git HEAD/branche/76modifications antérieures conservés. PE,movie,XML et anciennes preuves conservés. Goal,critères,Plan/UI/bases inchangés;aucune installation,migration,restart ou chargeur productif exécuté.
Clôture limitée au contrat statique du bouton Surrender Options et à ses manques nommés. SYS-17.5-01 et SYS-01.2-02 restent ouverts;la clôture documentaire du vote antérieur reste conservée,sa fonctionnalité demeure incomplète. Aucun menu,service de vote ou jeu complet déclaré terminé.
