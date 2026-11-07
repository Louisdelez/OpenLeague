# SYS-01.2-02 — P15, investigation REA de la référence native

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-PATCHER-P15-REA-XREF-STOP-01`. **Investigation d'outillage close avec échec conservé ; question historique ouverte.** Ce document complète l'audit statique P15 et ne déclare pas la boîte de dialogue, le launcher ou le goal terminés. L'écran `PATCHER::P15` est une entrée de l'inventaire `SYS-01.1-04`, pas une tâche autonome à basculer de statut.

## Question et frontière

Question unique : quelles références du binaire hôte original pointent vers la chaîne `Riot::Client::PatcherUI::DisplayCloseWarning`, et permettent-elles d'établir la condition d'affichage et les branches Oui/Non ? Le JavaScript `ChromeController.js` demande la fermeture via `riot.client.exit`, mais ne décrit pas la décision native. Les quatre clés `quit_warning_*` du texte `en_GB` identifient le dialogue, pas son déclenchement. REA devait seulement chercher les références à une adresse donnée, puis inspecter au plus un appelant si la référence était obtenue.

Source exacte : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/projects/lol_patcher/releases/0.0.0.11/deploy/LoLPatcher.exe`, PE32 x86, **4 247 544 octets**, SHA-256 `fd4a4edcd45694e08779373286afdaa6870cd86f9847e4fc9db1d0bd556914cb`. La chaîne ASCII exacte commence à l'offset fichier `0x39BD38`, dans `.rdata`, VA `0x79CD38` calculée depuis les en-têtes PE. Cela prouve la présence de la chaîne dans le binaire fourni ; son usage runtime et sa relation à une procédure restent inconnus.

## Exécution réellement observée

Le runner épinglé `E:/mapslol3v3/audit_sys01202_patcher_p15_rea_20261103/rea_p15_one_shot.mjs` (SHA-256 `320e3dba8121d4352541532c5cdd0a3d10cebbcec936625f89065bfc0cf07d1c`) a créé une copie privée du PE identique sur E et une session MCP locale **REA 6.4.0 / Ghidra 12.1.4 / SDK 2.3.1**. Son `TEMP`, `TMP` et répertoire de travail étaient sous `E:/mapslol3v3/audit_sys01202_patcher_p15_rea_20261103/observations/baecc6e0-326a-4ef0-8561-b6f4d7c6fb05`. Le jeu et le patcher original n'ont pas été lancés ; aucun logiciel n'a été installé.

| Étape | Attendu | Observé |
| --- | --- | --- |
| `open_binary` | ouvrir la copie x86 de SHA exact | succès, réponse `format=pe`, `architecture=x86`, SHA conforme ; durée serveur 150,59 ms |
| `xrefs({address:"0x79cd38"})` | références statiques exploitables ou liste vide qualifiée | **échec `provider_timeout`**, opération `xrefs`, `timeout_ms=600000` ; durée serveur 600 601,42 ms ; aucune liste fournie |
| Analyse d'un appelant | au plus une procédure si xref obtenu | **non exécutée**, car aucun xref n'a été retourné |
| `export_evidence_bundle` | bundle conservé | échec distinct `execution_failure`, `operation=write`, `reason=io` sur le chemin E ; ne pas lui attribuer la cause du timeout |
| Fermeture | fermer binaire et transport | `close_binary` acquitté ; fermeture client et transport attestées par le reçu |

Une seule session, une seule cible et **zéro retry**. `xrefs_count=null` signifie absence de résultat de l'outil, pas « zéro référence native ». Aucun `list_segments`, appel direct Ghidra, scan alternatif ou nouvelle tentative n'a été effectué. Le bundle a échoué, mais les requêtes/réponses MCP, le journal et le reçu de session sont conservés sous `observations/baecc6e0-326a-4ef0-8561-b6f4d7c6fb05/`. Le reçu de session `receipt.json` a le SHA-256 `3444d56df16cea65d5956fe8e439bca2ad8075c08ca49d51ced3c61d05874b9d` ; la réponse xrefs `002-xrefs-response.json` a le SHA-256 `9ecef2a4c2ee77ca0d92e7bf900e1da8737ff450def458a610f48b5868c80b31`.

Le validateur `validate_p15_rea_stop.py` relit le PE original, la copie, les en-têtes PE, le runner, le reçu, **tous les artefacts épinglés**, les réponses MCP et le journal : **`PASS_FAILURE_PRESERVED 24/24`**. Il confirme que les cinq JSON protégés ont les mêmes SHA-256 avant/après et à la relecture ; ce contrôle ne constitue pas une revue globale de toutes les écritures du disque F. Aucun test Rust, jeu, rendu ou acceptation humaine n'a été exécuté pour cette investigation.

## Décision et condition de reprise

L'investigation est close comme **`TOOL_FAILURE_PRESERVED`**. La condition hôte de P15, la présence d'un appelant, l'ordre d'apparition de la modale et les réponses Oui/Non restent **inconnus**. La réponse REA marque l'erreur comme `retryable`, mais la méthode du goal interdit une relance identique sans élément nouveau après ce timeout de dix minutes. Gate : `STOP_AFTER_SINGLE_PATCHER_P15_XREF_PROVIDER_TIMEOUT_NO_IDENTICAL_RETRY`.

Reprendre seulement avec un projet Ghidra persistant déjà analysé et vérifié pour ce **PE exact**, un diagnostic concret du fournisseur corrigeant ce timeout, ou une preuve primaire indépendante et attribuable du parcours hôte Oui/Non. Toute nouvelle session devra poser une nouvelle question/entrée, conserver l'identité du binaire et ses propres reçus, puis recouper les instructions avec les octets originaux. La source JS, les traductions et le consommateur Tauri peuvent être reliés par l'audit statique P15 sans inventer ce comportement natif.

Ce document, `validate_p15_rea_stop.py` et `p15_rea_stop_result.json` sont préparés **sur E uniquement**. Aucun code produit, asset, Plan, goal, application de suivi, base ni registre protégé n'est modifié par cette préparation.
