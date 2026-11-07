# SYS-01.1-03 — Client de partie et configurations serveur disponibles

Relevé du 20 octobre 2026. Identification statique : aucun logiciel historique ou serveur n’a été lancé.

## Build du client de partie

Le binaire natif fourni est **4.20.0.315**, canal **PUBLIC**, branche **Releases/4.20**. Chaînes de build embarquées : **Nov 17 2014**, **17:46:45**. Fuseau non établi. Horodatage PE distinct : **2014-11-18T01:55:38+00:00**. La date de déploiement EUW reste inconnue. Le catalogue officiel **4.20.1** n’est pas le numéro du binaire.

- Racine : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20`.
- Binaire : `RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`.
- Taille : **15 973 880 octets** ; SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**.
- Release de solution RADS : **0.0.1.68** ; région configurée **EUW**, locale **en_GB**. Le manifeste de langue et les cinq sources du contrat existant sont revérifiés, sans modifier ce contrat.
- Contrat antérieur conservé : [reference_client_4_20.json](reference_client_4_20.json).

## Configurations disponibles et leurs consommateurs

| Ensemble | Configuration et sélection | Port / protocole | Origine et limite |
|---|---|---|---|
| LeagueSandbox fourni | `GameServerConsole/Settings/*.template` et `bin/Debug/net6.0/Settings/*.json` | Port CLI par défaut **5119**, ENet Patch420 | Copie communautaire modifiée, annonce 4.20.0.315 ; pas un serveur Riot original |
| Registre communautaire | `Settings/MasterRegistry.json`, variables `LOLSBX_*`, puis défauts | Master HTTP **0.0.0.0:8080**, `master.db` | Découverte de serveurs ; distinct du serveur de partie et de Riot |
| OpenLeague Rust courant | `OPENLEAGUE_SERVER`, `OPENLEAGUE_ALLOW_PAUSE`, `OPENLEAGUE_OWNED_STDIN` | **127.0.0.1:5896**, UDP JSON local | Serveur reconstruit ; Map10 activée dans le code, 30 Hz localement |
| Défauts natifs livrés avec le client | `DATA/cfg/defaults/GamePermanent.cfg`, `Game.cfg`, `GameFeatures.cfg`, configurations client/système | Réglages livrés ; aucune instance serveur déduite | 37 fichiers recensés ; certains contiennent des champs réseau/serveur, leur exécution côté serveur n’est pas prouvée |

### LeagueSandbox : parcours réel de lecture

Le consommateur `GameServerConsole/Program.cs` sélectionne le JSON explicite `--config-json`, sinon le fichier `--config` (défaut `Settings/GameInfo.json`), sinon la ressource embarquée `Resources.GameInfo`. Le défaut peut être écrit sur disque lorsque le fichier manque. `Properties/Resources.resx` pointe vers `Settings/GameInfo.json.template` : ce template contient des commentaires Json.NET ; l’échec d’un parseur JSON strict n’en fait pas un fichier corrompu.

`GameServerLib/Config.cs` lit `game`, `gameInfo` et `players`, puis `GameConfig.Map`, `GameMode` et `DataPackage`. `GameServerLib/Program.cs` transmet la configuration au serveur ; `Server.cs` charge les réglages et initialise `Packets/PacketServer.cs`, dont le constructeur utilise `Version.Patch420` et `Address.Any`. Le numéro annoncé dans `Config.VERSION_STRING` est 4.20.0.315 ; il est distingué de l’identité relue dans le binaire natif.

`--config-gameserver` et `--config-gameserver-json` concernent `GameServerSettings` et son lancement automatique du client dans le bloc **DEBUG**. Les fichiers JSON absents à côté des sources ne sont pas présumés absents de la sortie compilée : les deux emplacements sont inventoriés séparément.

**Huit fichiers disponibles**, y compris copies/templates, regroupés par leur vrai chemin :

| Fichier relatif à D:/LeagueOfLegendsV2/4.20/GameServer | Valeurs utiles, sans données joueur | SHA-256 |
|---|---|---|
| `GameServerConsole/bin/Debug/net6.0/Settings/GameInfo.json` | Map11, CLASSIC, 1 joueur ; sbires True | `306909914b3f5835769deae72c82362a4c5b719cb1fbe3b78211f6354b14398c` |
| `GameServerConsole/bin/Debug/net6.0/Settings/GameInfo.json.template` | Map1, CLASSIC, 1 joueur ; sbires False | `4780687feffd9c6cd3de155bb9b571aa48a74cc4d5551c1248585bf71837f2f6` |
| `GameServerConsole/bin/Debug/net6.0/Settings/GameServerSettings.json` | AutoStartClient=true ; consommé en DEBUG uniquement | `cc743841bd21c548016405f653a3b4b7699acb5c6d0c6f13745e54d1b50a295c` |
| `GameServerConsole/bin/Debug/net6.0/Settings/GameServerSettings.json.template` | AutoStartClient=true ; consommé en DEBUG uniquement | `cc743841bd21c548016405f653a3b4b7699acb5c6d0c6f13745e54d1b50a295c` |
| `GameServerConsole/bin/Debug/net6.0/Settings/MasterRegistry.json` | Registre local configuré ; heartbeat 15 s ; Public=True | `0ab3d5098ddbf1800f21ec8d93865d7b6ab1e41b70b2c4a33e08152b41a157c7` |
| `GameServerConsole/Settings/GameInfo.json.template` | Map1, CLASSIC, 1 joueur ; sbires False | `4780687feffd9c6cd3de155bb9b571aa48a74cc4d5551c1248585bf71837f2f6` |
| `GameServerConsole/Settings/GameServerSettings.json.template` | AutoStartClient=true ; consommé en DEBUG uniquement | `cc743841bd21c548016405f653a3b4b7699acb5c6d0c6f13745e54d1b50a295c` |
| `GameServerConsole/Settings/MasterRegistry.json` | Registre local configuré ; heartbeat 15 s ; Public=True | `0ab3d5098ddbf1800f21ec8d93865d7b6ab1e41b70b2c4a33e08152b41a157c7` |

Le template utilise **Map1**, un joueur, `MANACOSTS_ENABLED=false`, `COOLDOWNS_ENABLED=false`, `MINION_SPAWNS_ENABLED=false`, cheats activés et forcedStart 60. Le JSON net6 présent utilise **Map11**, un joueur bleu, mana/coûts, recharges et sbires activés, cheats activés, `TRAINING_MODE=false`, forcedStart 10. Ce relevé ne présente aucun de ces profils comme une configuration 3v3 Map10 achevée.

Révision source communautaire observée : `b37c75483abf66048af7c914e7fab700efaa5e21`, avec modifications locales conservées. Le projet cible **net6.0**, et `GameServerConsole.runtimeconfig.json` déclare Microsoft.NETCore.App **6.0.0** ; un DLL de sortie est présent, sans exécution ni qualification de compatibilité.

### Registre HTTP local

`GameServerLib/MasterRegistry.cs` sélectionne d’abord un `LOLSBX_MASTER_URL` non vide et ses variables associées, puis `Settings/MasterRegistry.json`, puis des défauts dont l’URL est vide. Noms pris en charge : `LOLSBX_MASTER_URL`, `LOLSBX_SERVER_NAME`, `LOLSBX_REGION`, `LOLSBX_PUBLIC_HOST`, `LOLSBX_DESCRIPTION`, `LOLSBX_PUBLIC`, `LOLSBX_HEARTBEAT`.

Le fichier présent configure une URL de boucle locale, `Public=true`, heartbeat **15 secondes** ; noms, hôtes et descriptions utilisateur ne sont pas exportés. Le programme distinct `master-server/src/main.rs` lit `LOLSBX_PORT` et `LOLSBX_DB`, avec défauts 8080 et `master.db`. Il n’a pas été démarré.

### Serveur Rust OpenLeague

`crates/server/src/main.rs` lit l’adresse `OPENLEAGUE_SERVER` puis effectue `UdpSocket::bind`. Sans variable : **127.0.0.1:5896**. Le launcher `launcher/src-tauri/src/sessions.rs` impose cette même adresse locale au serveur et au client qu’il démarre.

La pause est permise uniquement par `OPENLEAGUE_ALLOW_PAUSE=1`. `OPENLEAGUE_OWNED_STDIN` absent signifie indépendant ; `1` active la propriété via le pipe du launcher ; les autres valeurs sont refusées dans `owned_session.rs`. Map10 et le contexte de ciblage au sol sont activés explicitement au démarrage. `crates/core/src/lib.rs` fixe **30 Hz** : c’est une politique locale, pas une fréquence serveur Riot démontrée.

Les sources montrent le protocole UDP JSON local. L’égalité d’un numéro de patch ne prouve pas que le client historique ENet peut se connecter à ce serveur Rust. Cette compatibilité reste **non établie**. Le présent travail identifie ces réglages sans remplacer le transport ni modifier le moteur.

### Défauts fournis dans le client

Les 37 fichiers des racines `Config/`, `RADS/system/` et `DATA/cfg/` sont recensés avec leurs SHA dans le contrat. Les valeurs retenues de `GamePermanent.cfg` incluent `NetConfig.localaddr=127.0.0.1`, `NumClients=1`, `TeamID=100`, `batchPackets=1`. `ServerPerformanceTweaks.OverallServerFPSCap` conserve son littéral **.033** et son commentaire, sans conversion arbitraire en fréquence validée. Dans `Game.cfg`, les deux timeouts de reconnexion valent 15000 ; les unités ne sont pas inventées ici. La présence de ces champs dans les ressources client n’identifie pas une configuration de production Riot.

## Écarts et inconnues

- Les anciens `start-server.bat` et `.sh` pointent vers **bin/Debug/net8.0**, absent. Les sources et la sortie disponible sont **net6.0**. Écart documenté ; aucun de ces anciens scripts n’a été modifié ou lancé.
- Aucun serveur de production Riot ni sa configuration d’exploitation n’est identifié dans les racines fournies. Les réglages communautaires et locaux ne le remplacent pas comme preuve historique.
- Aucun service distant, exécution serveur, fidélité complète du protocole ou configuration 3v3 complète n’est qualifié par cet inventaire.
- Aucun secret, clé de connexion ou profil de joueur n’est copié dans le contrat ; seules les valeurs utiles explicitement autorisées par le filtre de relevé sont exportées.

## Intégration et vérification

Contrat : [reference_game_server_4_20.json](reference_game_server_4_20.json). Lecteur : `tools/project-plan/game_server_reference.py`. Tests : `test_game_server_reference.py`. Résultats et fichiers modifiés : [reference_game_server_4_20_verification.json](reference_game_server_4_20_verification.json).

Le contexte de la seule tâche **SYS-01.1-03** consomme l’identité, les réglages, les chemins et l’empreinte du contrat. Le générateur de consignes existant et le catalogue SQLite partagé par le site et Tauri les restituent. Les tâches voisines et les états manuels sont préservés.

| Contrôle | Attendu | Observé / preuve |
|---|---|---|
| Identité du client | 4.20.0.315 PUBLIC, source exacte | Binaire et référence à cinq sources relus et hachés |
| Configurations disponibles | Fichiers réels et consommateurs distingués | 8 configurations communautaires, 37 fichiers client, 3 contrats de consommateurs |
| Template JSON commenté | Lecture sans inventer de corruption | Lecture Json.NET compatible pour les commentaires et virgules finales, résumés filtrés |
| Absence/modification/autre version | Refus explicite du vérificateur | Cas négatifs dans les tests ciblés et leurs journaux |
| Version annoncée/protocole/origine | Pas de serveur Riot ou de compatibilité déduite | Origines séparées et inconnues explicites |
| Suivi utilisateur | Aucun état changé | Comparaison intégrale avant/après liée dans le reçu final |

Depuis E:/OpenLeague :

```powershell
python -B tools/project-plan/game_server_reference.py --root E:/OpenLeague
python -B tools/project-plan/test_game_server_reference.py
```

Les fichiers source et les preuves antérieures sont conservés. La tâche est techniquement traitée et reste **à valider par l’utilisateur** ; aucune case ne sera cochée par ce travail.
