# Audit SYS-01.2-02 — Heal : cooldown, source native → consommateur

Date : 2026-11-02  
Lot : `SUMMONER-SummonerHeal-SCOPE` / cooldown uniquement  
Résultat : audit statique de cette liaison clos; valeur serveur 4.20 encore indéterminée.

## Contrat et critère de sortie

La tâche `SUMMONER-SummonerHeal-SCOPE` est requise et reste `a_qualifier`. Son titre couvre les cartes, le déblocage, les cibles et les paramètres 4.20; son critère demande une fiche datée avec source/SHA, valeurs et exceptions séparées des inconnues, et disponibilité historique justifiée. Ce lot ne traite que le paramètre de recharge. Critère local : identifier la valeur du fichier natif sélectionné, la valeur de référence 4.20.1, le champ effectivement consommé par OpenLeague, le refus pendant la recharge et l’autorité manquante pour résoudre leur divergence.

## Sources identifiées

- Client fourni : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\SummonerHeal.inibin`, 1 567 octets, SHA-256 `EF988A5B19AD8FC4DB3E210FB76FAE4C826562F21C82128C891DD0332E5BB8C5`. Le SHA recalculé concorde avec `data/4.20/native_summoner_hud.json` (même taille et chemin).
- Le lecteur local en lecture seule `tools/project-plan/reference_inibin.py` a décodé 209 entrées. Le hash calculé de `SpellData*Cooldown1` est `2629301966`; sa valeur dans le fichier est `300.0000`. Les champs `Cooldown`, `Cooldown2` et `Cooldown3` décodés valent aussi `300.0000`.
- Catalogue local Data Dragon officiel version `4.20.1`, `data/4.20/native_summoners_420.json`, SHA-256 `6E2077BEBE889F34B8E27E01DBB7E0B9CC61A8E0B799CDF1226F498751559FC5` : `SummonerHeal.cooldown=[300]`, `range=[850]`; le texte décrit 90–345 PV selon le niveau, 30 % de vitesse pendant 1 s et une réduction de moitié après un soin récent.
- Le fichier actuel `data/4.20/heal_rules.json`, 445 octets, SHA-256 `DF19A7E05AEF52F51345745344A0064692212003397077417BAF8DACC1A5C088`, fixe `cooldown_seconds=240` et note `native_cooldown_conflict=300`. Sa justification pointe vers une copie NerfPlz des notes 4.5. Une page secondaire versionnée des notes 4.5 rapporte bien le passage de 300 à 240 secondes ([historique V4.5](https://wiki.leagueoflegends.com/en-us/V4.5)); elle ne prouve pas à elle seule la configuration du serveur de la partie 4.20.

## Consommateur courant et résultat observé

- `crates/core/src/summoner_heal.rs` (SHA-256 `E7D80ECC10F4A119EFAF1B7581E2EF4CF66D50B0B606DD9DDB406E65E6D68AC5`) charge directement `heal_rules.json` via `include_str!` (ligne 18). Après l’effet, `cast_heal` règle `ready_at` à `tick + spells::seconds(r.cooldown_seconds)` (lignes 82–83). Il ne lit pas l’INIBIN brut.
- `crates/core/src/summoners.rs` (SHA-256 `7AF19297380715624CB37F70AB62DFA9A65F7C8665E49B7699EE495D7A0D56A3`) dirige le sort vers `cast_heal` (ligne 73) et refuse une nouvelle activation si `tick < ready_at`, avec `summoner spell on cooldown` (lignes 67–68).
- Attendu côté fichier client et catalogue : 300 s. Observé côté règle/consumer OpenLeague : 240 s, justifiés par une règle historique locale mais en contradiction avec le défaut client et la ligne 4.20.1. Le chaînage actuel est donc identifié et divergent; l’INIBIN n’est pas une source d’exécution directe du cooldown OpenLeague.

## Cas nominal, refus et limites

- Cas nominal statique : le consumer programme le délai configuré dans `heal_rules.json`; le test existant `heal_restores_owner_and_one_wounded_ally_with_native_speed_and_historical_cooldown` attend `ready_at=7200` pour 240 s (`summoner_heal.rs`, ligne 123). Ce test n’a pas été exécuté pendant ce lot.
- Refus statique : avant l’échéance enregistrée, le dispatch rend l’erreur `summoner spell on cooldown`. Aucun cast en runtime réel ou test Rust n’a été exécuté ici.
- Inconnue à ne pas masquer : les éléments disponibles ne décident pas si 240 s est l’override effectif du serveur 4.20 ou si les 300 s client/catalogue doivent gouverner la reconstitution. Le reçu natif est une ressource client; la copie des notes 4.5 est secondaire; aucune configuration serveur 4.20 ni observation runtime de recharge n’a été trouvée dans ce lot.
- Hors périmètre et encore ouverts pour la tâche entière : disponibilité par carte, déblocage, sélection exacte du coéquipier, source historique du choix de cible et acceptation/runtime. Ne pas changer le statut `a_qualifier`.

## Conclusion et reprise

Critère de liaison rempli pour le seul cooldown : source native, catalogue, donnée OpenLeague, callsites nominaux et refus courant sont reliés avec résultats distincts. La fonctionnalité Heal n’est pas qualifiée par cet audit. Reprendre la décision de valeur seulement avec une source primaire de configuration/serveur 4.20 correspondant à Map10 ou un reçu d’exécution historique qui observe la durée; reprendre les autres clauses sur leurs propres sources. Ne pas refaire le hash ou le décodage de cet INIBIN sans changement de fichier.

Contrôles réellement exécutés : hash SHA-256 du fichier natif et des extrémités locales; décodage INIBIN avec le lecteur déjà présent; inspection ciblée du catalogue 4.20.1, de `heal_rules.json` et des callsites Rust. Aucun test, build, lancement de binaire, modification de code, registre, goal, Plan, application, base de suivi, installation ou migration.