# Qualification de fermeture du client normal

Ce dossier est une préparation indépendante du manifeste déjà figé de `client_shutdown_refresh`. Le script n'a pas été exécuté ; aucune fenêtre, compilation ou qualification GUI n'a été lancée par son auteur.

Le root fournira explicitement le SHA256 du **nouvel exécutable construit**. Aucun ancien exécutable n'est qualifié implicitement. Exemple à compléter, depuis PowerShell :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -B 'E:\mapslol3v3\client_shutdown_refresh\gui_qualification\qualify_gui_shutdown.py' --run --exe 'E:\OpenLeague\target\debug\openleague-client.exe' --exe-sha256 '<SHA256 du nouveau build>' --output-dir 'E:\mapslol3v3\client_shutdown_refresh\gui_qualification\observations\run-unique' --startup-seconds 90 --settle-seconds 5 --exit-seconds 30
```

Le chemin de sortie doit être nouveau et sous `E:\mapslol3v3`. Les variables `OPENLEAGUE_*` héritées sont refusées avant lancement afin d'éviter d'activer involontairement les sondes existantes. Le client reçoit **zéro argument** et conserve le comportement normal, les données et `Game.cfg` de son projet compilé. Le script ne lance ni serveur ni launcher et ne modifie aucun fichier produit ; les éventuelles écritures effectuées par le client normal restent celles de ce client.

Le script vérifie le SHA initial, lance directement le binaire avec stdout/stderr vers deux fichiers, retient son PID et un handle OS de cette durée de vie. Il vérifie l'image de processus, attend une unique fenêtre visible au titre exact `OpenLeague - developpement 4.20`, `WaitForInputIdle` et une réponse à `WM_NULL`. La fenêtre doit rester réactive pendant la période de stabilisation. Juste avant l'unique `WM_CLOSE`, PID, titre, image de processus et réactivité sont revérifiés. Aucun broadcast, `process::exit`, kill, arrêt d'un autre processus ou injection d'erreur ne fait partie du dispositif.

Par défaut, l'attente avant fermeture est bornée à 90 secondes (dont cinq de stabilité) et l'attente après fermeture à 30 secondes. Les appels d'observation du message pump sont eux-mêmes bornés à 100/200 ms. `qualification.json` est publié après lancement puis à chaque étape importante et à la sortie ; il conserve le PID, HWND, titre/classe/rectangle, chronologie, diagnostics, code de sortie, empreintes initiale/finale du binaire et empreintes des journaux. Les derniers appels Win32 et les opérations de fichiers peuvent ajouter une courte durée aux délais d'attente. Un timeout ou une interruption produit un échec durable et **laisse le processus lancé vivant** s'il n'est pas sorti. Le rapport le dit explicitement ; il faut alors examiner ce PID précis. Les journaux d'un processus encore vivant portent `final=false` et peuvent continuer de croître.

Pour PASS : sortie 0 après le `WM_CLOSE` ciblé, exactement un `NATIVE_RUNTIME_SHUTDOWN` et un `NATIVE_RUNTIME_AFTER_RUN`, ordre service/runtime/Application, absence d'erreurs collectées, horloge effectivement initialisée (QPF=1, QPC>=4), propriétaires temporaires retirés, workers effectivement créés tous achevés/fermés, compteurs CRT appariés. Le checkpoint conserve la section Shared identifiée `0x2D6ED58` ; après destruction du runner seul l'observateur du rapport de sections subsiste, sans erreur. Ce dernier compte ne prétend pas mesurer directement le nombre d'appels `DeleteCriticalSection` du système.

La visibilité et la réponse du HWND ne constituent pas une inspection des pixels. Le résultat ne qualifiera pas le jeu complet, les performances, tous les défauts OS ou la fermeture avec des sessions multijoueur actives. Les codes d'erreur injectés restent couverts séparément par les tests préparés du module Rust ; ce runner n'ajoute pas de CLI d'erreur.

Voir `render_clock_audit.md` : le rendu peut continuer après `Last`, mais les ressources extraites inspectées ne contiennent pas de producteur d'horloge native. Les empreintes sources du relevé sont consignées dans `manifest.json`. Cette conclusion est statique ; le runner ne revendique pas une instrumentation de tous les appels QPC après fermeture.
