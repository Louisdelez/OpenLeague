# AUD-17.5-01-OPTIONS-QUIT-01

UTC : 2026-10-31T07:19:18.541797+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Quitter et son dialogue :demande,compteur,annulation,confirmation et callbacks immédiats. Audit terminé côté producteur;clôture réservée à la relecture indépendante. Implémentation non modifiée,vérification statique seulement,acceptation humaine non demandée. Fin réelle du client et launcher restent distincts.

## R2 — Sources et identité
PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. XML et sources/outils sont épinglés. VA préférées0x400000,rôles analytiques,pas symboles PDB ou adresses live.
306exports AS3 et anciens p-code réutilisés. Une seule nouvelle classe ViewQuitGameDialog exportée en p-code,avec Java/JPEXS/JVM existants,code0,log/commande/empreintes conservés. Aucun AS exécuté,installation ou réexport identique. Dix-sept méthodes sont retrouvées par octets uniques dans le DoABC original.

## R3 — Chaîne et consommateurs
exitLabel rejoint placedButtons[3]. handleExitClick pose exitWasInvokedFromMenuButton puis émet REQUEST_QUIT;le module branché au stage appelle RequestQuitGame. Un événement QUIT_CONFIRM distinct appelle ConfirmQuitGame. Deux endgamedialog XML existent,onlyshowif game et replay,avec clés de labels différentes;la sélection effective/rendu ne sont pas qualifiés.
Registration exacte :RequestQuitGame→830150,ConfirmQuitGame→830190,DialogOpened→8301B0,DialogClosed→8301F0. Request délègue82EB30;comm+24absent saute la routine. Sinon appel virtuel14(1),prédicat de transportB0 et octet global54 choisissent5ou0. 831C20 crée QuitGame.value en double depuis cet entier et ajoute à la file7971E0.
FoundryOptionsModule.QuitGame confirme directement si value===-1,puis retourne;les autres valeurs appellent displayExitDialogue. Le producteur natif inspecté émet5/0,pas-1. Aucun sens complet des deux prédicats,délai serveur,pénalité ni durée réellement écoulée n’est établi.
Le dialogue relie Confirm et Cancel à des handlers distincts. startCounter notifie DialogOpened. Une valeur positive affiche le compteur,désactive Confirm et programme delay(1);chaque tick décrémente puis allowQuit vide le texte et active Confirm. Une valeur<=0 active seulement le bouton :elle n’arrête pas automatiquement le processus.
Cancel/close pose le compteur0,tue le tween stocké,émet CLOSE,puis notifie DialogClosed. Le parent retire le dialogue,demande CloseMenu seulement pour une origine hors menu,puis efface le flag d’origine. Confirm émet QUIT_CONFIRM bubbling,puis CLOSE,puis DialogClosed;sans garde enabled/compteur ni killTween propre. Aucun clic prématuré ou ordre runtime n’est exécuté.
Deux questions de source restent explicites :display teste spriteInstance.contains(exitDialog) mais ajoute le dialogue à this;deactivate appelle close puis removeChild,alors que le handler CLOSE retire aussi le dialogue. Aucun défaut de hiérarchie,double retrait ou timer n’est déclaré reproduit.
Confirm natif écrit2D788D4=4 et14B1B90=3;Opened/Closed règlent owner+92à1/0. Ces stores ne prouvent ni processus fermé,ni Leave,ni résultat final,ni fenêtre du launcher restaurée. Pointeurs/owners,exceptions et nettoyage ne sont pas qualifiés.
Six consommateurs courants de résultats/départ/retour et l’audit de session sont conservés. Les contrôles postmatch gardent leurs gardes de résultat/session/membre et AppExit/Leave ;ils ne deviennent pas un dialogue Quitter en partie. Recherche exacte des cinq hooks sur1168sources :aucun résultat,ce qui n’exclut pas un équivalent autrement nommé.

## R4 — Vérifications et cas
17méthodes bytecode,6fonctions natives,36instructions fixes et registration conservée vérifiés. Aucun x86,AS,Rust,jeu,GUI,input,réseau,émulation ou arrêt de processus exécuté. Les tests de session antérieurs restent hérités.

### C1
- Attendu : Menu Quitter and confirmation have separate events and bridge requests,with source-backed labels and origin flag.
- Observé : Exit label index3;handleExitClick sets exitWasInvokedFromMenuButton and emits REQUEST_QUIT;module stage listeners call RequestQuitGame or ConfirmQuitGame on distinct events.
- Limite : Stage/listener and actual context not executed. XML has game/replay endgamedialog nodes;effective selected instance and rendered locale remain unobserved.

### C2
- Attendu : Native request publishes a value under explicit local branches and missing communication skips that routine.
- Observé : 830150 delegates82EB30. Nonnullcomm+24 precedes virtual14(1),predicate virtualB0 and global byte54;branch selects5 or0,constructor831C20 writes double value and queue7971E0 is called.
- Limite : Predicate meanings,owner/transport/global pointer validity and queue delivery are not qualified. No native count/clock/server penalty inferred.

### C3
- Attendu : AS QuitGame value-1 confirms directly;value0/positive values follow presentation/countdown rather than automatic process termination.
- Observé : Module QuitGame has exact Number(-1) branch→Confirm then return. Other values call displayExitDialogue;updateCounter<=0 allows the confirm button,while positive value schedules1second decrement callbacks.
- Limite : Scoped native request emits5/0,not-1;another producer is unqualified. Actual elapsed time,scheduler and nonfinite/fractional/invalid input policy remain open.

### C4
- Attendu : Dialog cancellation cancels its stored timer and notifies closure without issuing QUIT_CONFIRM in its own body.
- Observé : close sets count0,killTween,Event.CLOSE,then QuitGameDialogClosed. Parent handler removes dialog and only calls CloseMenu when request did not originate from menu;origin flag is cleared.
- Limite : Event ordering/reentrance,display membership and eventual native reaction not executed. No claim every cancellation keeps/removes the correct view.

### C5
- Attendu : Confirm event is distinguished from disabled-state enforcement and full timer cleanup.
- Observé : handleConfirmButton emits bubbling QUIT_CONFIRM,then CLOSE,then DialogClosed;it has no own enabled/countdown guard or killTween. Module listener sends ConfirmQuitGame.
- Limite : No physical early-confirm bypass proved. Callback may affect subsequent flow;timer disposal and source lifecycle need separate qualification.

### C6
- Attendu : Repeated display/close/deactivate routes are described without inventing an observed runtime defect.
- Observé : display tests spriteInstance.contains(exitDialog) but adds it to this ViewApplication;deactivate calls exitDialog.close then removeChild,while close listener also removes it.
- Limite : Two source questions,not reproduced bugs. Actual object hierarchy,event dispatch/cleanup and duplicate removal/timer effects are unobserved;new correction names the exact scenarios.

### C7
- Attendu : Native confirm and dialog-notification callbacks do not prove the process exited or launcher was restored.
- Observé : Confirm830190 writes globals2D788D4=4 and14B1B90=3. DialogOpened/Closed set owner+92to1/0. No process wait,Leave receipt or restored launcher is observed.
- Limite : Global consumers/full shutdown ownership,cleanup/penalties/result,network completion and OS window behavior remain separate.

### C8
- Attendu : Existing postmatch exit and launcher evidence remains useful without being relabeled as a midmatch Quitter dialogue.
- Observé : Six current source fragments and old session readback are preserved;two RETURN corrections retain their definitions. Exact quit hook query over1168sources is empty.
- Limite : Bounded query only. Existing result/session/member guards and AppExit/Leave paths are not an implemented QuitGame dialogue or current original parity proof.

## R5 — Manques et reprise
- **QUIT-HIERARCHY-TIMER** — Manque : Effective containment,parent removal/event order,timer disposal/reentrance and disabled/focus input are not observed despite two precise source interactions. Reprise : Qualify the exact contains/addChild and deactivate→close→remove paths under an identified authorized runtime or explicitly versioned local reconstruction;keep unobserved defects labeled as questions.
- **QUIT-NATIVE-CONTEXT** — Manque : Native delay predicates,value-1producer,actual callback owner/queue delivery and consumers of phase globals remain unqualified. Reprise : Choose one named native predicate/phase consumer or controlled trace;reuse5/0value builder and17original methods. A queued command or phase store cannot stand for actual exit.
- **QUIT-CURRENT-EXIT** — Manque : Current Quitter dialogue and real process/Leave/launcher restoration after that cause remain unqualified;postmatch Return is distinct. Reprise : Use HUD-QUIT-DIALOG-LIFECYCLE-01 plus unchanged RETURN corrections in a separate authorized product/runtime scope;identify binaries/assets/context and observe cancellation,one confirmation,process termination and restored launcher separately.
Les labels seuls ne prouvent pas la locale affichée. Confirmation,notification de dialogue et état global ne sont ni une acceptation de shutdown ni un reçu OS. Valeurs nonfinies,récurrences,perte/reprise de contexte,allocation et sécurité des pointers/owners restent non qualifiées.

## R6 — Corrections
HUD-OPTIONS-ENTRY-01 et les deux RETURN corrections conservent leurs définitions/statuts. RETURN porte sur le processus/launcher,et le retour postmatch ne couvre pas le dialogue en partie. Une proposition documentaire distincte,pas ajoutée au registre :
**HUD-QUIT-DIALOG-LIFECYCLE-01** — Qualifier le cycle du dialogue Quitter et son consommateur actuel sans confondre confirmation et sortie réelle.
- Écart : Dialogue historique :parent testé différent du parent addChild,fermeture/retirage multiples possibles,timer/confirm sans garde locale ;aucun comportement runtime ni équivalent actuel qualifié.
- Travail : Réutiliser sources/bytecode et callbacks;observer ou choisir explicitement un contrat local versionné pour hiérarchie,événements,timers,origine menu/hors menu,valeurs5/0/-1,annulation/confirmation et sortie. Conserver lecteurs et sorties existants;ne pas recopier un défaut supposé sans qualification.
- Fin : Un scénario identifié par contexte prouve ouverture,compteur,annulation sans confirmation,confirmation unique,fermeture/timer sans effet retardé et perte/reprise de contexte. Les deux questions de hiérarchie/retirage ont une observation ou une limite précise. Demande native,états globaux,processus fermé,Leave et launcher restauré ont des preuves séparées.
- Reprise : Runtime GFx/AS autorisé et ressource/contexte identifiés,ou contrat local de reconstruction explicitement accepté dans une tâche produit distincte. Aucune exécution originale ni correction produit implicite au titre de cet audit.
- Dépendances : HUD-OPTIONS-ENTRY-01, RETURN-WINDOW-RESTORE-01, RETURN-REASON-ROUTE-01. Statut proposé,non appliqué;critères normatifs inchangés.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-QUIT-01\options-quit-proof.json`. Export ciblé,log,spécification et scripts isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-QUIT-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-QUIT-01\delivery-readback.json`;elle seule clôt le sous-lot après sept rubriques.
Cinq registres,25fichiers gelés,1168sources,Git HEAD/branche/76modifications antérieures,PE/movie/XML et preuves antérieures conservés. Goal,critères,Plan/UI/bases inchangés. Aucun accès runtime aux bases,installation,migration,restart ou exécution d’un chargeur productif.
Clôture limitée au contrat statique Quitter/dialogue et aux manques nommés. SYS-17.5-01 et SYS-01.2-02 restent ouverts;aucune fonctionnalité actuelle,sortie réelle,launcher restauré,menu ou jeu complet déclaré terminé.
