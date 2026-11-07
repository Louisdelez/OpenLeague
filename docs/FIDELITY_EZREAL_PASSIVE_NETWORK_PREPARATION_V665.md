# SYS-01.2-02 — préparation des liens réseau du passif Ezreal, V665

Date UTC : 2026-10-27T06:46:30.082857+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue officiel4.20.1 distinct.

## État de livraison

Les sources, les points de code et les essais sont préparés et vérifiés. **Les associations V665 ne sont pas encore publiées dans le registre canonique ni dans les deux bases du plan.** La tâche et le goal restent ouverts. Ce rapport n’annonce ni le passif complet ni un jeu terminé.

L’implémentation locale existe : les contacts Q/W/E/R alimentent un compteur privé ; la projection du propriétaire transporte session,owner,stacks ; la présentation cliente vérifie identité et fraîcheur. Les36points sélectionnés comprennent23consommateurs partiels réels et13frontières communes. Cette distinction doit être conservée lors de la publication.

## Sources et divergences conservées

Sept sources natives sont revérifiées et correspondent aux manifests sélectionnés. Le champ PassLev1Desc1 lie la description10%/6secondes/max5, conforme au catalogue4.20.1. Le champ Passive1Desc contient une ancienne description d’Ashe : elle n’est pas adoptée. Passive1LuaName indique EzrealRisingSpellForceBuff, alors que le chunk disponible EzrealRisingSpellForce nomme EzrealRisingSpellForce et son icône. Le texte de l’alias Buff parle de15%/75% ; il reste distinct du texte lié. Ces éléments ne prouvent ni priorité de chargement ni règles serveur originales.

CharScriptEzreal.luaobj ne contient pas de callback ; le chunk RisingSpellForce contient les noms de buff et texture, sans fonction enfant. La classe communautaire CharScriptEzreal.cs inspectée est vide. Les neuf recherches de chemins loose pour l’alias Buff restent bornées à ces chemins ; elles ne prouvent pas une absence dans toute archive ou provider.

| Source | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Ezreal\Ezreal.inibin | 2475 | df9e79cde5b2560bf9a834dfbb332517131fc1c1762aee30e55472169ac608bf |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Ezreal\Scripts\CharScriptEzreal.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Ezreal\Scripts\CharScriptEzreal.preload | 2564 | 3746541f551f26038389cfd23361689701eb645018e474bbb428786b3ff32ed1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\EzrealRisingSpellForce.inibin | 61 | 7723c1fa78b3fdf8f70d4f5389587984df112dd2845190d28378147c256157e2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\EzrealRisingSpellForce.luaobj | 168 | 9a5fc01c16a5eb6aa9e483493d2322ac706abde13b90f8f4104abb0fb01574f0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\EzrealRisingSpellForce.preload | 365 | f77766ac36a6715ca8b4a9dd3ff088ce82736bf4951d37681a57a877905a2ca8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

## Exécution vérifiée

Quatre scénarios séparés lancent Q,W,E,R par commandes authentifiées dans le vrai core. Chacun utilise trois clients UDP locaux et les vrais modules Host,Registry,Client et présentation. Huit appels explicites à l’API serveur award_experience(2525) placent propriétaires et cibles au niveau6. Ce contrôle n’est pas une attribution d’XP autorisée au client. Le déplacement et l’apprentissage passent par les commandes publiques ; aucun rang,position,PV ou buff n’est injecté directement. La session77 et le temps Host diagnostique sont déclarés séparément du tick de simulation.

| Contrôle attendu | Résultat observé |
|---|---|
| Un lancement seul ne donne pas de cumul | Compteur0 après lancement dans les quatre scénarios |
| Contact Q/W/E/R accepté | Compteur1 ; dégâts effectifs ; cadence AA43→40ticks |
| Audience privée | Seul le propriétaire reçoit son cumul ; l’autre Ezreal reçoit son propre0 ; Garen n’a pas ce DTO |
| Réassemblage et doublons | 77états exacts ; fragments inversés et dupliqués ; pas de cumul supplémentaire |
| Reconnexion au cumul1 | Quatre récupérations : même joueur et état,epoch+1 ; ancienne trame refusée ; aucune avance du tick liée aux60s du temps Host |
| Expiration serveur | Cumul1 à179ticks puis0 à180 ; cadence revenue à43 |
| Mort avec cumul actif | Un secondQ rétablit1 ; dégâts serveur létaux ; DTO absent au décès |
| Valeur de présentation invalide | 20copies DTO malformées refusées : propriétaire/session erronés,cumul6,mort,mauvais champion |
| Fraîcheur cliente | Ancienne époque,canal malsain et ancien échantillon masqués ; doublon au même tick en pause ne rafraîchit pas le délai local0,2s |

Total : cinq contacts de sorts,77états,903datagrammes,51requêtes,8215ticks. Le décès utilise une API serveur de dégâts et non une commande cliente. Les clés sont produites par l’OS et ne sont pas journalisées. Les copies malformées de présentation sont explicitement synthétiques ; elles ne modifient pas la simulation.

Trois essais privés précédents ont fini en RUN101 : le diagnostic utilisait d’abord un point E identique à la position courante,puis un point dont le cercle d’arrivée touche du terrain bloqué. Sources,binaires et journaux restent conservés. La copie public_arrival conserve ces deux refus sans mutation du snapshot,puis trouve une arrivée acceptée par les contrôles du moteur. Aucun changement du jeu n’a été nécessaire.

| Commande réussie | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 10c0f263a93edd4cec0ff89eeddac73f539870141641f77aaaed814373c41597 |
| RUN | 0 | 72196be00b831d13fa69f38afaa7c6a442129300a77054ed0d9e3f2aff49658d |

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-ezreal-network-probe-public-arrival.exe ; 7862272octets ; SHA-256 ce4d088bbf1fa83a800bac93fdaa817e9c5fefcf1c1860dc8952dcd0d2257000. Binaire non-test ; identités/checksums Cargo.lock alignés. Les1164entrées code/ressources sont inchangées avant/après. L’inspection indépendante recontrôle les sources,les journaux et les valeurs de chaque phase.

## Consommateurs

| Fichier et ligne | Ancre | Portée | Vérification de ce lot |
|---|---|---|---|
| crates/core/src/ezreal_passive.rs:28 | `pub(crate) fn clear_ezreal_passive(` | Partiel local | Lecture seule |
| crates/core/src/ezreal_passive.rs:32 | `pub(crate) fn remove_ezreal_passive_owner(` | Partiel local | Lecture seule |
| crates/core/src/ezreal_passive.rs:33 | `pub(crate) fn prune_ezreal_passive(` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_passive.rs:50 | `pub(crate) fn accepted_ezreal_ability_contact(` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_passive.rs:65 | `pub fn ezreal_passive_stacks(` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_passive.rs:75 | `pub(crate) fn ezreal_passive_attack_speed_bonus(` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_passive.rs:83 | `pub struct OwnerPassive ` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_passive.rs:85 | `pub(crate) fn ezreal_passive_self_projection(` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_q.rs:244 | `self.accepted_ezreal_ability_contact(identity.owner,identity.team,identity.session);` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_w.rs:267 | `if result.is_ok() { self.accepted_ezreal_ability_contact` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_e.rs:322 | `Ok(_) => self.accepted_ezreal_ability_contact` | Partiel local | Chemin exercé |
| crates/core/src/ezreal_r.rs:279 | `self.accepted_ezreal_ability_contact(identity.owner,identity.team,identity.session);` | Partiel local | Chemin exercé |
| crates/core/src/progression.rs:123 | `+ self.ezreal_passive_attack_speed_bonus(id)` | Partiel local | Chemin exercé |
| crates/core/src/vision.rs:147 | `snapshot.ezreal_passive_self = self.ezreal_passive_self_projection(viewer);` | Partiel local | Chemin exercé |
| crates/client/src/ezreal_r_passive_presentation.rs:44 | `pub(crate) fn reset_session(` | Partiel local | Chemin exercé |
| crates/client/src/ezreal_r_passive_presentation.rs:49 | `pub(crate) fn begin_epoch(` | Partiel local | Chemin exercé |
| crates/client/src/ezreal_r_passive_presentation.rs:61 | `fn passive_value(` | Partiel local | Chemin exercé |
| crates/client/src/ezreal_r_passive_presentation.rs:186 | `pub(crate) fn observe_accepted_frame(` | Partiel local | Chemin exercé |
| crates/client/src/ezreal_r_passive_presentation.rs:233 | `pub(crate) fn passive(` | Partiel local | Chemin exercé |
| crates/client/src/native_ezreal_passive_hud.rs:13 | `const ICON_QUERY:` | Partiel local | Lecture seule |
| crates/client/src/native_ezreal_passive_hud.rs:40 | `fn load(` | Partiel local | Lecture seule |
| crates/client/src/native_ezreal_passive_hud.rs:69 | `fn icon_image(` | Partiel local | Lecture seule |
| crates/client/src/native_ezreal_passive_hud.rs:195 | `fn update(` | Partiel local | Lecture seule |
| crates/core/src/lib.rs:209 | `pub struct Snapshot` | Frontière commune | Chemin exercé |
| crates/core/src/vision.rs:208 | `pub fn snapshot_for_atomic(` | Frontière commune | Chemin exercé |
| crates/server/src/session_host.rs:57 | `pub fn handle(` | Frontière commune | Chemin exercé |
| crates/server/src/session_host.rs:158 | `pub fn states(` | Frontière commune | Chemin exercé |
| crates/server/src/reconnect.rs:173 | `pub fn prepare_input<` | Frontière commune | Chemin exercé |
| crates/core/src/session_wire.rs:21 | `pub fn encode(` | Frontière commune | Chemin exercé |
| crates/core/src/session_wire.rs:77 | `pub fn push(` | Frontière commune | Chemin exercé |
| crates/client/src/session_client.rs:142 | `pub fn frame(` | Frontière commune | Chemin exercé |
| crates/client/src/session_client.rs:176 | `pub fn take_ready_states(` | Frontière commune | Chemin exercé |
| crates/client/src/session_client.rs:98 | `pub fn welcome(` | Frontière commune | Chemin exercé |
| crates/client/src/session_client.rs:188 | `pub fn presented(` | Frontière commune | Chemin exercé |
| crates/client/src/main.rs:969 | `fn receive(` | Frontière commune | Lecture seule |
| crates/client/src/session_connection.rs:205 | `pub fn decode_datagram(` | Frontière commune | Lecture seule |

La première inspection privée attribuait une exécution à clear_ezreal_passive sans preuve de passage dans cette branche. La version scope conserve la première et marque ce point comme lecture seule. Elle est la version à publier. Le main graphique,le provider d’icônes,les polices et le rendu GPU ne sont pas exécutés ici. L’exécution de l’objet de présentation ne prouve pas son affichage à l’écran.

## Limites et travail suivant

Les règles locales ne sont pas des callbacks natifs récupérés. Les cumuls2à5,rafraîchissements au plafond,contacts multiples,W allié/soi et toutes les variantes de boucliers ne sont pas fraîchement qualifiés dans ce lot. Les tests existants restent des preuves historiques à relire selon leur portée. Après reconnexion du propriétaire,les deux autres routes restent détachées dans ces scénarios.

La visibilité initiale et le rapprochement sont exercés ; une nouvelle perte de vision avec passif actif n’est pas testée ici. La politique filaire Riot et ses audiences exactes restent inconnues. La règle de fraîcheur0,2s du client est locale,distincte de l’expiration serveur6s.

Les quatre fiches explorées et leurs prérequis sont conservés ; seule CH-Ezreal-PASSIF-NETWORK est préparée pour la publication suivante. Six packages prérequis sont enregistrés dans l’inspection sans acceptation implicite. Aucun statut,case,note ou historique du plan n’a été changé.

Continuer SYS-01.2-02 : publier les associations de CH-Ezreal-PASSIF-NETWORK préparées dans revision665_Ezreal_network_inspection_scope/OBSERVATIONS.json, puis vérifier les deux bases avec Store.task/copy_text et le graphe. La version scope corrige le marqueur clear_ezreal_passive : inspection statique, exécution non démontrée ; garder la première inspection. 7 sources natives,36 points dont23 consommateurs partiels réels et13 frontières communes. Ne pas recopier le qualificatif Aatrox "tous entry_boundary_only" : le producteur et le compteur propriétaire Ezreal existent. Réutiliser la garde de publication V664 en adaptant explicitement source/compteurs/qualifications/marqueurs et en conservant inconnues,critères et six prérequis. Registre et bases n’ont pas encore été modifiés pour V665. Diagnostic réussi revision665_Ezreal_network_probe_public_arrival/OBSERVATIONS.json : BUILD/RUN0,1164entrées inchangées,Q/W/E/R et un secondQ,77états,903datagrammes,51requêtes,8215ticks,4reconnexions positives,20DTOmalformés refusés. Trois anciens RUN101 conservés : arrivée E identique ou terrain bloqué ; la copie public_arrival garde deux refus explicites puis une arrivée admissible. 8attributionsXP par API serveur sont des contrôles explicites, pas de l’XP gagnée en partie. Conserver les divergences natives : Passive1LuaName=EzrealRisingSpellForceBuff,chunk disponible EzrealRisingSpellForce,texte alias15pct/75pct,description liée10pct/6s/max5 et ancien Passive1Desc parlant d’Ashe. Aucun callback/protocole natif complet n’est établi. Éviter de saturer F : la préparation précédente fait deux backupsSQLite et sixJSON ; après capture DATABASES_BEFORE, archiver avec SHA décompressé le backupdesktop privé non référencé avant de créer candidate-project.sqlite3. Prévoir restauration explicite et adapter le reçu final d’archives ; ne pas supprimer preuve enregistrée ni base active. Après publication/audit, mettre à jour couverture et reprise ; puis traiter les autres PASSIF-NETWORK avec une matrice des consommateurs communs et de leurs exceptions. Le goal reste actif.

## Preuves et documents

Reçu public : F:\OpenLeague\docs\fidelity_ezreal_passive_network_preparation_v665.json. Inspection : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision665_Ezreal_network_inspection_scope\OBSERVATIONS.json. Exécution : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision665_Ezreal_network_probe_public_arrival\OBSERVATIONS.json. Collecte : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision665_Ezreal_network_discovery\OBSERVATIONS.json. Les six registres sont vérifiés inchangés. Couverture,plan,reprise et notes courtes reçoivent uniquement cet état de préparation ;leurs anciennes valeurs sont conservées. Espace libre F observé avant cette écriture : 2411831296octets. Aucun nettoyage de preuves ni base active.
