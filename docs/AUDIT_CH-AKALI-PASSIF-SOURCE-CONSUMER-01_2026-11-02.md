# AUD-CH-AKALI-PASSIF-SOURCE-CONSUMER-01 — 2026-11-02

## Unité et frontière

Tâche CH-Akali-PASSIF-ACCEPTANCE, exigence OLF-770d90f4-f633-5f5b-abb7-e259aa8bfaba, inconnue OLU-5bd4c357-a698-5979-a52c-3bfb85441dd4. Lot limité à la source native enregistrée pour Twin Disciplines et à son consommateur actuel. Le combat complet, les autres capacités et l’acceptation en partie ne sont pas évalués.

Critère attendu : identité/version native vérifiée, consommateur F inspecté, route Akali du passif trouvée ou absence bornée documentée, et condition précise de reprise.

## Sources

La source native enregistrée est OLS-b0f76dda-13f2-5173-bdd8-19f0ecd02a13, DATA/Characters/Akali/Akali.inibin du client 4.20.0.315 : 2 626 octets, SHA-256 351bb89b634ca1bd9cea3778e7eec7e3823a308726b2aa7ff28e635f83e2271d, MD5 b0927c4c54899f2fa008425317960751. Les tailles et empreintes ont été recalculées sur D et correspondent au registre. Le reçu existant confirme le membre DATA/Characters/Akali/Akali.inibin dans lol_game_client 0.0.1.7, release 0.0.1.7.

Le lecteur local existant tools/project-plan/reference_inibin.py a décodé 156 entrées. Les champs nommés contrôlés comprennent Data/Spell1..4 = AkaliMota, AkaliSmokeBomb, AkaliShadowSwipe et AkaliShadowDance, ainsi que BaseHP, BaseMP, MoveSpeed et AttackRange. Les valeurs décodées contiennent AkaliTwinDisciplines, AkaliTwinDisciplines.dds et les clés game_character_passiveName_Akali / game_character_passiveDescription_Akali. Elles établissent des identifiants et références client; elles ne fournissent pas une fonction passive serveur.

Cette exigence ne déclare qu’Akali.inibin comme source native; aucun source_id CharScriptAkali.luaobj n’est lié à la fiche. La recherche historique par index du corpus client reste héritée; elle n’est pas répétée ici, et aucune absence globale au-delà de son périmètre n’est revendiquée.

La source officielle distincte OLS-f64a6467-9591-5012-ae90-afdf2cc5f845 est Data Dragon 4.20.1, en_US, SHA-256 72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404. Son entrée nomme Twin Disciplines et résume séparément un bonus de dégâts magiques sur les attaques et du sort vampirique, tous deux évolutifs selon les statistiques. Ce catalogue 4.20.1 en_US n’est pas le corps serveur du client 4.20.0.315 en_GB.

## Consommateur actuel

L’exigence pointe OLC-93924678-ea15-5516-8f55-08616c5450cc, crates/core/src/lib.rs:149, fonction champion_catalog. Le code F de ce consommateur a été relu dans le lot Aatrox; cette fonction charge data/4.20/champions.json et sa structure ChampionDefinition ne couvre que l’identité et les statistiques de base. La ligne Akali du fichier local présente ces statistiques, pas Twin Disciplines. L’identité F du fichier et du code a été consignée dans le rapport précédent; elle n’est pas une identité native d’Akali.inibin.

Une recherche exacte, insensible à la casse, dans les Rust de crates et launcher ne trouve aucun handler Twin Disciplines/Akali passif. Les occurrences Akali concernent l’acceptation de l’identité dans des fixtures, l’énergie/ressource, ou le système d’achats; elles ne traitent pas Twin Disciplines. Par exemple, shop.rs distingue mana d’énergie et regeneration.rs vérifie le taux d’énergie. Ces consommateurs n’établissent pas le passif.

Le consumer enregistré reste donc un chargeur générique de statistiques. Aucun consommateur courant de la source passive native n’a été trouvé.

## Attendu, observé et limites

| Contrôle | Attendu | Observé |
|---|---|---|
| Identité native | Source client 4.20.0.315, membership concordant | Taille, SHA-256, MD5 recalculés; membership sélectionné concordant |
| Métadonnées | Identifiants passifs distingués du comportement serveur | INIBIN nomme Twin Disciplines/son icône et des clés locales; corps serveur non fourni dans les sources liées |
| Consommateur | Dispatch courant Akali du passif ou absence bornée | Chargeur générique de stats identifié; aucun handler Twin Disciplines dans la recherche Rust |
| Contrôles | Nominal et limite explicités | Lecture INIBIN nominale; énergie et boutique observées comme systèmes distincts; aucun test ou scénario gameplay exécuté |
| Acceptation | Comparaison en partie 4.20 | Non exécutée; aucune acceptation humaine |

L’audit borné de la liaison est clos : la ligne Akali de statistiques possède un consommateur courant, tandis que le passif natif n’a pas de consommateur actuel identifié. L’inconnue reste ouverte pour le corps serveur et les règles exactes. L’implémentation et l’acceptation ne sont pas acquises.

## Reprise précise

Reprendre lorsqu’un corps serveur Akali 4.20, une spécification primaire qui relie ces identifiants natifs aux règles exactes, ou un nouveau dispatch courant devient disponible. Relier ce contenu à un consommateur Akali puis vérifier séparément les déclencheurs, les montants et les refus. Ne pas répéter le même décodage, les hashes ou la recherche Rust sans nouvel artefact.

Aucun code, goal, application de suivi, base, installation ou migration n’a été modifié. Aucun test, build ou lancement du client n’a été exécuté.