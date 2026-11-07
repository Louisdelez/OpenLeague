# Revue indépendante V1154 — bridge D3DX

Date : 2026-11-03  
Décision : **PASS 45/45, aucune anomalie sur l’état final**.

## Confrontation indépendante

La revue a rehashé les six artefacts du manifeste source : `6/6` exacts, sans écart de taille ni de SHA. Les deux runs finaux sont postérieurs au producteur courant et leur projection, hors horodatage, est identique.

Le validateur source a été exécuté séparément : `PASS 38/38`, projection `af9799640f32244f8d954bd841c89305777921767891ca62706216addc2441da`. Son mode par défaut final est en lecture seule : le SHA du reçu de validation est resté identique avant et après l’exécution.

Une troisième exécution physique a été lancée vers `independent_rerun.json` depuis le producteur épinglé. Elle réussit avec 21 contrôles, trois appels `D3DXCompileShader`, zéro proxy vivant, et sa projection est identique aux deux runs source.

## Sources et ABI

La revue a reconstruit l’ABI sans importer les valeurs calculées par le producteur :

- PE32 x86 : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- helper `0x9BE940..0x9BEAFA` : 442 octets, 150 instructions, SHA-256 `494cf3e135f0a42981886996b36b02cd485f7ea1a4f29d64dd770e662139f800` ;
- séquence d’arguments, IAT `0xFA4800`, slots `+0x0C/+0x08`, point d’entrée `main`, profils `vs_2_0/ps_2_0` : concordants ;
- 23 paires de macros relues à `0x1225B10` : ordre et textes exacts.

Les deux DLL D3DX ont été rehashées et leurs tables d’export relues :

- hôte x64, machine `0x8664`, export `D3DXCompileShader` présent ;
- invitée x86, machine `0x14C`, même export présent.

## Exécutions et nettoyage

Les trois reçus — run 1, run 2 et rerun indépendant — concordent :

- vertex `vs_2_0` : HRESULT 0, code 272 octets, CTAB 144 octets, constante attendue présente ;
- pixel `ps_2_0` : HRESULT 0, code 184 octets, CTAB 128 octets, constante attendue présente ;
- erreur syntaxique : `0x80004005`, uniquement un buffer `error X3000` ;
- tous les objets retournés sont libérés avec `Release → 0` ;
- six refus pré-hôte conservent les sorties nulles et n’ajoutent aucun appel D3DX ;
- lecture et seconde libération après release sont refusées ;
- aucun proxy COM ne reste vivant.

## Portée vérifiée

La qualification reste correctement bornée :

- compilation current-host par la DLL x64 actuelle, pas runtime x86 2014 ;
- sources synthétiques sans include portant le contrat exact des 26 macros, pas les deux fichiers FOUR_BLEND complets ;
- compteurs de stop structurels du harness, pas une trace Riot ;
- aucune entrée `0x98D960/0x98C070`, aucun `Create*Shader`, pool, nettoyage possédé original, bind, Draw, Present ou readback de frame.

Les trois blockers suivants restent explicitement ouverts : bridge device `Create*Shader`, pools shader, puis nettoyage possédé `0x9AED50/0x9AEDC0 → 0x9BED40`. La publication ciblée et la fonctionnalité du jeu ne sont pas déclarées terminées.

## Incident supersédé de revue

La première invocation de revue avait utilisé l’ancien comportement du validateur, qui réécrivait son reçu horodaté par défaut et rendait le manifeste obsolète. Le producteur a été corrigé pour rendre le mode sans `--output` strictement non-mutant, puis le reçu et le manifeste ont été régénérés. Toute la présente décision a été recalculée contre ces nouvelles identités finales ; cet incident n’est pas une anomalie résiduelle du lot.
