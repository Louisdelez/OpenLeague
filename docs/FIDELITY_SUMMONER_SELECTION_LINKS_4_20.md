# Sélection et transmission des sorts invocateur — SYS-01.2-02, V81

Cinq exigences reliées à vingt rôles actuels : trois périmètres partiels et deux frontières seules. Aucun code du jeu ni asset modifié. Aucun programme historique, serveur, client, interface ou exporteur exécuté dans cette vérification.

## Sources et contrat

Huit exports ActionScript hérités du recensement AIR sont relus et comparés à leurs empreintes enregistrées. Leurs trois bibliothèques originales correspondent au manifeste exact lol_air_client0.0.1.119. Les exports ne sont pas de nouvelles décompilations ni une exécution AIR.

CreateSpellSelectionsCommand prend les sorts actifs fournis par InventoryController, filtre gameModes, puis utilise minLevel et isSpellDisabledForMode pour leur disponibilité. Pour un mode inconnu, le repli utilise la carte :8 vers ODIN,7/12 vers ARAM, les autres vers CLASSIC. La Forêt torturée porte mapId10. Un mode connu conserve son identité : il ne faut pas appliquer inconditionnellement CLASSIC à toute partie Map10. Les listes actives et les désactivations viennent de données d’inventaire ; leur payload effectif EUW historique n’est pas récupéré par ce lot.

Le catalogue officiel4.20.1 conservé est sémantiquement identique à data/4.20/native_summoners_420.json. Ses treize sorts sont associés chacun à un INIBIN natif conforme aux manifestes de la référence. Les niveaux et modes sont des valeurs du catalogue de comparaison, pas des valeurs prétendument extraites de ces INIBIN ni une réponse effective du service. Les champs SpellData sélectionnés sont conservés, avec null pour un champ absent.

SpellSelectCommand transmet deux spellId à gameService.selectSpells. confirmSpells peut reprendre/permuter les sorts existants lors du remplacement d’un choix. Ce code client ne prouve pas l’ensemble des paires autorisées/refusées côté serveur Riot ; aucune règle distante n’est inventée.

## Consommateurs actuels et écarts

Les deux listes HTML proposent Aucun et cinq variantes : Barrier,Heal,Exhaust,Ignite,Smite. Les deux commandes Tauri valident ces noms et refusent un doublon non nul. Simulation.join_with_summoners refuse également le doublon avant de créer le joueur, puis conserve les deux slots. Les slots vides restent autorisés par cette garde. Le niveau du compte, la carte et le mode ne sont pas des paramètres des chemins de sélection/join inspectés. Cela ne constitue pas une preuve d’absence globale de toute politique ailleurs dans le jeu.

La chaîne statique suivie est : sélecteurs D/F → invoke play/join_local → JSON de LaunchSpec → OPENLEAGUE_SUMMONERS → lecture du client → JoinRequest → session_host → Simulation. Une variable absente devient [null,null] ; un JSON invalide déclenche expect et ne produit pas silencieusement une paire valide. La reprise d’un join compare champion, paire et nonce. Aucun message réel n’a été envoyé pour ce lot.

Le protocole local porte VERSION=1 et sérialise des noms enum. Ignite correspond à SummonerDot. Les IDs numériques du catalogue et des DTO AIR sont distincts de ces noms ; la version du protocole ne suffit pas à qualifier une table d’IDs versionnée4.20. Les huit autres entrées du catalogue ne sont pas déclarées supportées.

## Vérifications

109 contrôles de sources et d’ancrages ;31 cas du lecteur, dont30 refus attendus : manifeste/export ou empreinte remplacés, sort omis, niveau/mode/ID inventé, confusion numéro de protocole/catalogue, ajout de Flash au support local, confusion Ignite/SummonerDot, frontière présentée comme implémentation et tâche déclarée terminée. Les tests portent sur la traçabilité, pas sur le gameplay.

Le premier sélecteur du refus de version correspondait à plusieurs lignes du fichier ; il a été remplacé par l’entrée unique prepare_join et une vérification dans son corps. Le lecteur initial est conservé dans revision81/audit_summoner_selection_reference_initial.py. Aucune publication n’avait eu lieu lors de ce refus.

## Catalogue comparé

| Sort | ID catalogue | Niveau compte catalogue | Modes catalogue |
|---|---|---|---|
| SummonerBarrier | 21 | 4 | ARAM, CLASSIC, TUTORIAL, ODIN, ASCENSION |
| SummonerBoost | 1 | 6 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerClairvoyance | 2 | 8 | CLASSIC, ODIN, TUTORIAL, ASCENSION |
| SummonerDot | 14 | 10 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerExhaust | 3 | 4 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerFlash | 4 | 8 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerHaste | 6 | 1 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerHeal | 7 | 1 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerMana | 13 | 1 | CLASSIC, ODIN, TUTORIAL, ARAM, ASCENSION |
| SummonerOdinGarrison | 17 | 1 | ODIN |
| SummonerRevive | 10 | 1 | CLASSIC, TUTORIAL |
| SummonerSmite | 11 | 10 | CLASSIC, TUTORIAL |
| SummonerTeleport | 12 | 6 | CLASSIC, TUTORIAL |

## Liens par exigence

| Tâche | Frontière seule | Consommateur constaté | Travail ouvert |
|---|---|---|---|
| SYS-08.3-01 | True | AIR filtre active,minLevel et désactivation par mode ; les deux listes locales proposent cinq noms plus Aucun, sans niveau de compte transmis au join. | Récupérer/qualifier le catalogue et les désactivations effectives EUW4.20 ; ajouter et vérifier le niveau du compte et ses gardes, distinct du niveau du champion. |
| SYS-08.3-02 | False | Les deux commandes Tauri refusent un nom hors des cinq variantes ou un doublon non nul ; Simulation refuse le doublon avant création. Les slots vides restent possibles. AIR confirmSpells permute les choix lors du remplacement ; son appel selectSpells ne prouve pas la politique serveur. | Qualifier toutes les paires interdites et le traitement des slots vides dans les modes historiques, puis exercer les refus serveur réels ; aucune règle distante déduite du seul client. |
| SYS-08.3-03 | True | AIR choisit un mode connu ou un repli selon mapId, puis filtre gameModes et les désactivations. Le chemin local de sélection/join inspecté ne reçoit ni mode ni carte ni niveau de compte. | Relier les règles de disponibilité à la configuration effective de partie et les vérifier avant lancement et côté serveur ; les modes Data Dragon ne sont pas un payload de désactivation historique. |
| SYS-08.3-04 | False | Le protocole local porte VERSION=1 et sérialise cinq noms enum ; AIR sélectionne deux spellId et le catalogue4.20.1 possède treize IDs numériques. VERSION=1 ne versionne pas le catalogue historique. | Définir et vérifier le contrat versionné de correspondance des IDs/catalogue, migration et refus ; conserver le protocole local distinct du transport Riot. |
| SYS-08.4-03 | False | Deux valeurs sont suivies depuis les select HTML, les invoke play/join_local, LaunchSpec, la variable JSON, JoinRequest, session_host et Simulation. Le rejeu compare aussi la paire. Cette lecture statique couvre cinq variantes et deux slots optionnels. | Exercer la transmission effective avec serveur/client et tous les IDs retenus, l’ordre D/F, erreurs et reconnexion ; ni réseau ni interface ni fidélité complète exécutés dans ce lot. |

Reçu : docs/reference_summoner_selection_sources/summoner_selection-links.json. Livraison : docs/fidelity_registry_summoner_selection_links_revision_4_20.json. Les cinq périmètres et le Goal restent ouverts.
