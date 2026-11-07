# AUD-CH-AHRI-PASSIF-SOURCE-CONSUMER-01 — 2026-11-02

## Unité et frontière

Tâche CH-Ahri-PASSIF-ACCEPTANCE, exigence OLF-b32ca84b-e174-540a-a53f-c8aa1fa222ad, inconnue OLU-a71e6457-b833-5eb9-ba5f-4da2df110954. Lot limité à la source et au consommateur courant du passif d’Ahri. Aucun sort, autre champion, lancement client, comportement accepté ou intégration complète du jeu n’est qualifié ici.

Critère attendu : établir l’identité/version des sources natives, lire le consommateur réel sur F, puis identifier le handler Ahri du passif ou en établir l’absence dans un périmètre reproductible. Documenter les refus et l’élément précis nécessaire à la reprise.

## Sources

Les entrées natives sont dans le client fourni, version 4.20.0.315 :

- OLS-ebe56d83-7db2-5e90-9639-46ad85990f30 — DATA/Characters/Ahri/Ahri.inibin : 2 671 octets, SHA-256 341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2, MD5 9bd7b6f4d858caad7912a58a81195d17. Le reçu de membership existant concorde avec lol_game_client 0.0.1.7 et son membre de release 0.0.1.7.
- OLS-1986a11a-8b07-5029-8abc-a74f2d251451 — DATA/Characters/Ahri/CharScriptAhri.luaobj : 56 octets, SHA-256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0, MD5 623b11414d3c337a0d501a5c0ee114bb. Le reçu le rattache à lol_game_client 0.0.1.7, membre 0.0.0.254. Cette empreinte est la même que celle de CharScriptAatrox.luaobj vérifié au lot précédent.

Les tailles, SHA-256 et MD5 ont été recalculés sur D et correspondent aux identités inscrites. Le fichier luaobj est un petit artefact client; aucune source ou fonction serveur n’a été récupérée à partir de lui.

Le lecteur existant tools/project-plan/reference_inibin.py a décodé 125 entrées hachées de Ahri.inibin. Les champs nommés contrôlés comprennent Data/Spell1..4 = AhriOrbofDeception, AhriFoxFire, AhriSeduce et AhriTumble, ainsi que BaseHP, BaseMP, MoveSpeed et AttackRange. Les chaînes incluent AhriPassive, Ahri_SoulEater.dds et les clés game_character_passiveName_Ahri / game_character_passiveDescription_Ahri. Le lecteur a été exécuté en lecture seule; le second lecteur n’a pas été rejoué, car aucune divergence de décodage n’a été observée dans ce lot et la double lecture du lot précédent avait confirmé le contrat du lecteur sur un autre fichier.

La référence officielle séparée OLS-f64a6467-9591-5012-ae90-afdf2cc5f845 est Data Dragon 4.20.1, locale en_US, SHA-256 72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404. Son entrée nomme le passif Essence Theft et décrit des charges gagnées lorsque les sorts touchent des ennemis, puis un soin déclenché par le sort suivant après neuf charges. Il s’agit d’un descriptif de catalogue version 4.20.1, pas d’un corps natif serveur 4.20.0.315 ni d’un texte localisé en_GB.

## Consommateur actuel

L’exigence référence OLC-93924678-ea15-5516-8f55-08616c5450cc, crates/core/src/lib.rs:149, champion_catalog. Le code de F vérifié au lot précédent lit data/4.20/champions.json et construit une entrée à dix champs de base. La ligne Ahri contient id, nom, santé, mana, dégâts d’attaque, armure, résistance magique, vitesse de déplacement, portée d’attaque et cadence d’attaque; elle ne porte pas le passif. L’entrée du catalogue et la fonction Rust sont des consommateur(s) de statistiques, non du passif natif.

La recherche actuelle Ahri dans les fichiers Rust sous crates et launcher ne trouve pas de dispatch Essence Theft. Les occurrences inspectées sont des fixtures ou des consommateurs génériques d’attaque, de sélection, de portrait, de ressources et de régénération. Elles n’exécutent pas le passif. Le chemin de saisie crates/client/src/spell_input.rs accepte des slots au sol pour Annie, Trundle et Ezreal; sa fonction retourne false pour Ahri/slot 1. Le test qui couvre cette condition n’a pas été exécuté pendant cet audit.

Aucun consommateur courant du passif natif Ahri ou du CharScriptAhri.luaobj n’a été établi. Le lien courant confirmé reste le chargeur générique des statistiques.

## Attendu, observé et limites

| Contrôle | Attendu | Observé |
|---|---|---|
| Identité native | Les sources du client 4.20.0.315 correspondent à leurs reçus et memberships | Deux sources rehachées; tailles, SHA/MD5 et memberships concordent |
| Métadonnées de passif | Identifiants natifs distingués du corps serveur | INIBIN contient des identifiants et clés de localisation; le petit luaobj client ne livre pas le corps serveur |
| Consommateur F | Handler courant du passif ou absence délimitée | Chargeur de statistiques identifié; aucun handler Essence Theft trouvé dans la recherche Rust ciblée |
| Référence catalogue | Le descriptif de passif reste attaché à sa version/locale | Data Dragon 4.20.1 en_US, distinct du client 4.20.0.315 en_GB |
| Exécution/acceptation | Comportement Ahri ordinaire comparé à la référence 4.20 | Non exécuté; aucune acceptation humaine |

L’audit statique de cette liaison est clos : les données de base d’Ahri ont un consommateur actuel et le passif n’a pas de consommateur actuel identifié. L’inconnue OLU reste ouverte pour le corps serveur original et la sémantique complète de la mécanique. Aucun passif, sort ou champion n’est déclaré terminé.

## Reprise précise

Reprendre si un corps serveur original Ahri, un contrat primaire complet reliant les clés native/localisées au passif, ou un nouveau handler courant est fourni. Relier cette preuve au code et qualifier séparément les déclencheurs, plafonds, refus et soin en partie. Ne pas refaire les hashes déjà vérifiés ni la recherche Ahri inchangée sans nouvel artefact.

Aucun code, goal, application de suivi, base, installation ou migration n’a été modifié. Aucun test, build ou lancement du client n’a été exécuté.