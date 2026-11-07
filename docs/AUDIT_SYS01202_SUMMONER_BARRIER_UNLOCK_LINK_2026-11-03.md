# Audit SYS-01.2-02 — Barrier : niveau de déblocage, source → consumers

Date : 2026-11-03  
Lot : `SUMMONER-SummonerBarrier-SCOPE` / seuil de niveau uniquement  
Résultat : la règle AIR historique de sélection est retrouvée; l’admission OpenLeague ne dispose d’aucun niveau de compte pour l’appliquer.

## Contrat et critère de sortie

`SUMMONER-SummonerBarrier-SCOPE` est une exigence requise, toujours `a_qualifier`. Son critère vise les cartes, le déblocage, les cibles et les paramètres 4.20. Ce lot se termine en identifiant le seuil publié, le consumer historique qui l’utilise, le parcours OpenLeague qui reçoit le choix et l’écart observable, sans prétendre que la fonctionnalité est terminée.

## Source et consumer historique AIR

- Le catalogue Data Dragon officiel local `data/4.20/native_summoners_420.json` (version 4.20.1, SHA-256 `6E2077BEBE889F34B8E27E01DBB7E0B9CC61A8E0B799CDF1226F498751559FC5`) indique pour `SummonerBarrier` `summonerLevel=4`. Il s’agit du catalogue 4.20.1 distinct du client 4.20.0.315.
- Le binaire AIR `lib/ClientLibChampionSelectionCore.dat`, enregistré dans `reference_air_sources/manifest-index.json` en release `0.0.1.119` (201 868 octets, MD5 `F3FC61C6F4EA808AD33CEBA46FCEB4C7`, SHA-256 recalculé `E757C10E659493BF6FC280DAE70C2E2F46D18152FFA5D85046B772DE30910BE5`), correspond au hash d’entrée du reçu de décompilation `decompilation-full.json`.
- Dans la source décompilée `CreateSpellSelectionsCommand.as` (4 178 octets, SHA-256 `579E2BFE8EDA19478C2EA1DC60182338EE17D255E77B44C5339F79B28941CF72`), la commande prend le niveau de compte et fixe `isEnabled` selon `_loc5_.minLevel <= summonerLevel` ainsi que l’exclusion du mode (`line 92`). Elle crée ensuite un `SpellSelection` désactivé si le seuil n’est pas atteint : c’est la règle d’activation UI observée, pas une preuve de refus serveur contre un client modifié.
- `ChampionSelectionControllerNew.as` (36 403 octets, SHA-256 `57D5694AA92CA377140DF8B5176897E43B7AE54067B35CA3B773B2D3067C7106`) fournit `selectionData.session.summonerLevel.summonerLevel` à cette commande (ligne 168). `Spell.as` (6 185 octets, SHA-256 `E50B2B33E7A35B1F7388E5AF626AFF0FD81F53EFA86664DF888D487A021AC40B`) reçoit `obj.minLevel` (lignes 28–41) et expose `minLevel`.
- Limite de correspondance : le catalogue 4.20.1 appelle le seuil `summonerLevel`; le modèle AIR consomme `Spell.minLevel` fourni par son objet. Le payload historique de `SummonerBarrier` reliant directement ces deux noms/valeurs n’est pas présent dans le reçu consulté. Les deux sources indiquent le même seuil de 4 dans leur contexte, mais leur sérialisation commune n’est pas prouvée ici.

## Consumer OpenLeague courant

- `crates/client/src/main.rs` (SHA-256 `EBA4E38B4C5C244426E74FEEB70ED351E9CDDCB58E2507CFCD1BFC771DC4B620`, ligne 616) lit le choix depuis `OPENLEAGUE_SUMMONERS`; il ne lit pas de niveau de compte.
- `crates/core/src/session_transport.rs` (SHA-256 `139A7CE15AC5261DEE15FE0AA60716FB1BB6993ECD9ACB0D41C34ACB84AB00BC`, ligne 50) définit `JoinRequest` avec `version`, `champion`, `summoners`, `recovery_key` et `request_nonce`, sans compte/niveau/unlock. `deny_unknown_fields` est activé.
- `crates/server/src/session_host.rs` (SHA-256 `AE65F3A022F1D235751DBA408BA1A8856398F9E47943DDD3302B4F1428BC0BA7`, ligne 82) transmet `request.champion` et `request.summoners` à `join_with_summoners`.
- `crates/core/src/summoners.rs` (SHA-256 `7AF19297380715624CB37F70AB62DFA9A65F7C8665E49B7699EE495D7A0D56A3`, lignes 32–42) vérifie les doublons puis stocke les deux sorts. Aucun niveau ou seuil n’est passé. Son commentaire de module dit explicitement que les déblocages de compte restent à faire.
- Recherche bornée des termes `summoner level`, `account level`, `spell unlock` et équivalents dans les sources Rust `core`, `server` et `client` : seul ce commentaire de travail a correspondu; aucun contrôle de niveau n’a été localisé dans ce parcours.

## Attendu, observé et refus

- Règle UI effectivement lue : une option est activée si l'objet AIR fournit `minLevel <= summonerLevel` et si le mode l'autorise. Le catalogue 4.20.1 donne `summonerLevel=4` pour Barrier, mais le payload liant cette valeur au champ AIR `Spell.minLevel` manque. Le refus UI sous le niveau 4 est donc conditionnel à cette correspondance et n'est pas prouvé par ces deux fichiers seuls.
- Observé dans OpenLeague : le client envoie uniquement les deux valeurs de sorts; le serveur/core n’a pas de niveau avec lequel refuser Barrier sous le niveau 4. La route de sélection et l’absence de garde sont établies statiquement, pas par un essai d’admission exécuté.
- Aucun test, build, client AIR ou serveur de partie n’a été exécuté pendant ce lot.

## Limites, reprise et conclusion

L’audit du lien d’unlock OpenLeague est clos comme **écart d’implémentation identifié** : la source/catalogue porte un seuil, l’AIR historique le consomme dans l’UI, le consumer courant ne reçoit ni ne vérifie ce niveau. La fonctionnalité et la tâche entière restent ouvertes. L’accès Map10 n’est pas prouvé par `modes=[CLASSIC,…]`; l’application côté serveur historique n’est pas établie par le filtre AIR; l’identité exacte du payload `Spell.minLevel` pour Barrier reste inconnue.

Reprendre la valeur de payload avec l’objet/service de sorts 4.20 qui fournit `Spell.minLevel`; reprendre l’implémentation avec la tâche existante `SUMMONER-SummonerBarrier-SERVER` et une source d’autorité de niveau de compte. Pour vérifier le refus, il faudra un parcours nominal niveau 4 et un refus niveau 3 en sélection et à l’admission serveur. Ne pas ajouter un nouveau ticket ni modifier les registres dans cette méthode documentaire.

Contrôles réellement exécutés : empreintes SHA-256/MD5 du binaire AIR, des sources décompilées, du catalogue et des consumers; comparaison avec le manifeste AIR et le reçu de décompilation; lecture ciblée des filtres AIR et de la requête OpenLeague. Aucun test/build/runtime, code, donnée, registre, goal, Plan, application ou base de suivi modifié; aucune installation/migration.
## Addendum V1021 — origine exacte du payload AIR et condition de reprise

La piste précisée dans le client décompilé est le contenu compilé local, et non un service de spell book : GeneratedContentLoader.as fixe /assets/swfs/AirGeneratedContent.swf (ligne 29), extrait spells puis construit chaque Spell avec new Spell(obj) (lignes 155, 190–198). Spell.as copie obj.minLevel; InitializeClientDataAction.as injecte le dictionnaire obtenu dans l’inventaire (ligne 38). InventoryController.getActiveSpells() filtre ensuite active, puis CreateSpellSelectionsCommand filtre mode et minLevel <= summonerLevel. Cela prouve la chaîne statique de consommation AIR et localise la source du payload.

Le manifeste docs/reference_air_sources/manifest-index.json référence assets/swfs/AirGeneratedContent.swf en release 0.0.1.119, 63 377 octets, MD5 fd8778eedf8d83e22f34660ac37fc166. Le fichier est absent des emplacements testés F:\OpenLeague\docs\reference_air_sources\original\assets\swfs, E:\mapslol3v3\output\Launcher_420_Research\air_119\assets\swfs et du déploiement client D: contrôlé; rg --files n’en a trouvé aucune copie sous les trois racines D:, E: (AIR release) et F: (référence AIR).

**Résultat du lot :** audit statique clos pour l’identification du producteur et de toute la chaîne AIR; la valeur Barrier de spells reste non vérifiable tant que le binaire n’est pas retrouvé. Le nombre summonerLevel=4 du catalogue Data Dragon ne doit donc pas être renommé en minLevel par supposition. Fonctionnalité et tâche requise restent ouvertes.

**Reprise précise :** retrouver ou restaurer l’asset de release 0.0.1.119, puis valider taille et MD5 ci-dessus; l’extraire avec FFDec déjà présent; relever sur l’entrée Barrier spellId, minLevel et gameModes; comparer ce payload au catalogue 4.20.1. Si l’asset exact n’est pas disponible, conserver l’inconnue et ne pas répéter les recherches sur AIR déjà décompilé. Aucun code, test, build, runtime, registre, goal, application ou base de suivi modifié; aucune installation ou migration.

Sources AIR vérifiées : GeneratedContentLoader.as (9 341 o, SHA-256 E00C8A8FE62E88F171990BB7E1DB295BEE77EE6E843EFE11CCA71D0874EA5F4A); InitializeClientDataAction.as (8 439 o, D08969BC5A3D86E710A5CFAD43EAD4E5C920853C9859F9B230E4D3229F1FA864); InventoryController.as (16 394 o, 78C940DE04832DFE6E4C34CD20C63291C568D5BD8AF8DC87F80A5905CE8FFF47); CreateSpellSelectionsCommand.as et Spell.as ont les mêmes SHA-256 que le reçu V1020.
### Vérification communautaire bornée V1022

Recherche web le 2026-11-03 par MD5 exact, nom du fichier et chemin de release : aucun dépôt/téléchargement correspondant au hash n’a été trouvé. Un ancien résultat de forum/malware répertorie le chemin AirGeneratedContent.swf sous la release 0.0.1.119, mais ne fournit pas l’asset ni son empreinte; ce n’est qu’une confirmation secondaire du chemin attendu : https://www.trojaner-board.de/161078-kaspersky-241-bearbeitete-objekte.html. Ne pas utiliser ce résultat pour renseigner les valeurs du payload. Ne pas répéter cette recherche hash/nom sans nouveau miroir, paquet ou index d’archives. La condition de reprise reste la récupération du binaire exact, puis contrôle de ses 63 377 octets et du MD5 du manifeste.
### Recherche locale bornée V1023

Recherche exacte du nom AirGeneratedContent.swf sans correspondance dans les dossiers C: existants suivants : Users\loicd\Downloads, Desktop, Documents, AppData\Local\Temp, AppData\Local\Riot Games, C:\Riot Games et C:\ProgramData\Riot Games. Il s’agit d’un périmètre ciblé, pas d’un scan complet du disque C:. L’analyseur déjà disponible est E:\mapslol3v3\AIR_routes_4_20_2026-10-20\tool\ffdec\ffdec.jar (5 271 501 octets); Java vient de JDK 21 dans PATH. Aucune installation n’est requise. Ne pas rescanner ces mêmes dossiers sans nouvelle piste. Reprise toujours conditionnée à l’asset exact et au contrôle taille/MD5.