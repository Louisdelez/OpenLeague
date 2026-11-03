# AUD-CH-AATROX-PASSIF-SOURCE-CONSUMER-01 — 2026-11-02

## Unité et frontière

Tâche CH-Aatrox-PASSIF-ACCEPTANCE, exigence OLF-2060db7b-b9dc-5154-905b-9831d95d943c, inconnue OLU-e2ecb048-c712-54e7-b011-85707d6f273a. Lot limité au lien entre les sources déclarées du passif d’Aatrox et leur consommateur courant sur F. Le comportement complet, l’implémentation, l’acceptation en partie et les autres champions restent hors de ce lot.

Critère attendu : identifier les sources natives et leurs versions, inspecter le consommateur réel d’Aatrox, puis établir s’il existe une route courante pour son passif; si elle manque, consigner cette absence et l’entrée exacte qui permettrait de reprendre.

## Sources et identité

Les deux sources natives restent dans le client fourni, version 4.20.0.315 :

- OLS-e1882c8a-4bdd-5a06-96a9-43265dd5271d — DATA/Characters/Aatrox/Aatrox.inibin : 1 997 octets, SHA-256 4d1949dc1ddbd27fd37c2b5dc6d2aa635a738f7bf4547314ae4ddc445eac2483, MD5 0ece2371a08a8b94f4189e85e7727b34. Le reçu de membership correspond à lol_game_client 0.0.1.7 et au membre de release 0.0.1.7.
- OLS-9d0bc15b-2738-5e06-8745-4f9948426dda — DATA/Characters/Aatrox/CharScriptAatrox.luaobj : 56 octets, SHA-256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0, MD5 623b11414d3c337a0d501a5c0ee114bb. Le reçu le rattache à lol_game_client 0.0.1.7, membre 0.0.0.254.

Les empreintes et tailles présentes ont été recalculées sur D et correspondent au registre. Le Lua object est un petit binaire client à signature Lua; il n’est ni une source serveur ni un corps serveur interprété ici.

Le lecteur existant tools/project-plan/reference_inibin.py a décodé le fichier natif en 112 entrées à clés hachées. Le lecteur conservé tools/references/lolpytools/lolpytools_inibin2.py a donné les mêmes 112 clés et, après normalisation des chaînes numériques, aucune différence de valeur. Les champs nommés contrôlés comprennent Data/Spell1..4 = AatroxQ/W/E/R, BaseHP, BaseMP, MoveSpeed et AttackRange. Des valeurs décodées incluent BloodWell, AatroxPassive et les clés de localisation game_character_passiveName_Aatrox / game_character_passiveDescription_Aatrox.

Le même tableau décode aussi des chaînes parlant de Tryndamere, notamment Undying Rage et Mocking Shout. Les noms des propriétés correspondant à toutes ces clés hachées n’ont pas été établis; cette observation ne prouve ni corruption ni attribution à Aatrox.

La référence officielle séparée OLS-f64a6467-9591-5012-ae90-afdf2cc5f845 est Data Dragon 4.20.1, en_US, SHA-256 72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404. Son entrée nomme le passif Blood Well et décrit le stockage des coûts en santé et la récupération après des dégâts fatals, avec un bonus de vitesse d’attaque. Cette description officielle de catalogue ne remplace pas le corps serveur natif 4.20.0.315 ni le texte client en_GB.

## Consommateur réel sur F

L’unique consumer_id attaché à cette exigence est OLC-93924678-ea15-5516-8f55-08616c5450cc, crates/core/src/lib.rs:149, fonction champion_catalog. Le registre conserve un chemin absolu E pour l’identité de ce code; la copie F actuelle a 52 808 octets et le même SHA-256 cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d.

La fonction lit data/4.20/champions.json et construit ChampionDefinition. La structure ne porte que l’identifiant, le nom et huit statistiques de base; la ligne Aatrox du JSON ne contient ni passif, ni sort, ni état de Blood Well. Le JSON F fait 32 052 octets, SHA-256 7cc80048c9460419041134232345d9b4da6d8f4e6795f7236720bef39e99de88. C’est une donnée locale de référence/conversion, non les octets de Aatrox.inibin.

Une recherche exacte et insensible à la casse dans les fichiers Rust de crates et launcher trouve trois occurrences d’Aatrox : un cas de test d’attaque, une fixture du registre spatial et un test générique de régénération de ressources. Aucune ne traite Blood Well. Les modules de passif présents nomment Garen, Ezreal, Trundle et Annie; aucune route Aatrox n’a été trouvée. Le cas d’attaque utilise Aatrox comme participant et Garen comme adversaire, il ne démontre pas un repli d’Aatrox vers Garen.

Le consumer enregistré est donc un chargeur de statistiques générales. Aucun consommateur courant du passif natif ou du CharScript Aatrox n’a été établi.

## Attendu, observé et limites

| Critère | Attendu | Observé |
|---|---|---|
| Sources | Identité native et version établies | Deux fichiers du client 4.20.0.315, empreintes recalculées et membership existant concordant |
| Passif natif | Métadonnées séparées d’un corps serveur | L’INIBIN fournit des identifiants/références; le petit Lua object est client; le corps serveur n’est pas fourni par le contrat de source client consulté |
| Consommateur | Appel direct Aatrox passif ou absence vérifiée dans le périmètre | Le loader de stats est identifié; aucune route Aatrox/Blood Well trouvée dans les sources Rust examinées |
| Contrôle nominal | Lecture native réussie et reproductible | Deux lecteurs lisent les mêmes 112 clés et valeurs normalisées |
| Exécution/acceptation | Partie Aatrox comparée au client 4.20 | Non exécutée; aucune acceptation humaine |

Cet audit statique est clos pour l’identification de la liaison actuelle : la donnée de base Aatrox est chargée, tandis que son passif n’a pas de consommateur courant identifié. L’inconnue OLU reste ouverte pour l’interprétation exacte du comportement serveur et des clés non attribuées. La fonctionnalité n’est pas implémentée ni acceptée par cette conclusion.

## Reprise précise

Reprendre lorsqu’un corps serveur historique d’Aatrox, un contrat natif primaire de passif avec ses clés décodées, ou une nouvelle route d’implémentation Aatrox apparaît. Relier cette source précise au handler courant, puis vérifier séparément la mécanique et le parcours de jeu. Ne pas répéter les mêmes hachages, les deux décodages ou la recherche Rust sans nouvel artefact.

Aucun code, goal, application de suivi, base, installation ou migration n’a été modifié. Aucun test de jeu, build ou lancement du client n’a été exécuté.