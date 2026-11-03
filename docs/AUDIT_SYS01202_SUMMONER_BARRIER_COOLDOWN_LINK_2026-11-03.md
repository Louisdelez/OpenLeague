# Audit SYS-01.2-02 — Barrier : cooldown, source native → consommateur

Date : 2026-11-03  
Lot : `SUMMONER-SummonerBarrier-SCOPE` / cooldown de base uniquement  
Résultat : liaison statique source→règle→consumer confirmée à 210 s; portée historique Map10 et acceptation restent ouvertes.

## Contrat et critère de sortie

La tâche `SUMMONER-SummonerBarrier-SCOPE` est requise, statut `a_qualifier`, avec implémentation et acceptation non closes. Son titre couvre les cartes, le déblocage, les cibles et les paramètres 4.20. Ce lot vérifie uniquement le cooldown de base : valeur de l’INIBIN client sélectionné, référence 4.20.1, règle réellement chargée, calcul de la prochaine disponibilité et refus pendant la recharge.

## Source et référence

- `SummonerBarrier.inibin` dans le client fourni, release `0.0.1.68` : 842 octets, SHA-256 `EB5286B0753B762E074120B579012660DB7EA2DF08039203E091554FC6FAC940`. L’empreinte recalculée correspond à celle de `data/4.20/barrier_rules.json`.
- Décodage en lecture seule avec `tools/project-plan/reference_inibin.py` : 62 entrées; le hash calculé de `SpellData*Cooldown` est `1229951523`, valeur observée `210.0000`.
- `data/4.20/native_summoners_420.json` (catalogue officiel 4.20.1, SHA-256 `6E2077BEBE889F34B8E27E01DBB7E0B9CC61A8E0B799CDF1226F498751559FC5`) donne `SummonerBarrier.cooldown=[210]`, `range=self`, et un bouclier 115–455 pendant 2 s.
- `data/4.20/barrier_rules.json` (1 467 octets, SHA-256 `3113FD41B73D63EF967CF4B3CC2C8172B1EFE919161532C51B1E0A4AC908E3E1`) encode `cooldown_seconds=210.0`; sa source INIBIN enregistre aussi `native_cooldown=210.0000` et le SHA ci-dessus. Son annotation `classification: "Decoded reference; original inibin cooldown to be checked"` est désormais dépassée par la valeur native décodée et mérite une correction dans un lot de données autorisé. Elle n’a pas été modifiée ici.

## Consommateur courant et cas observables

`crates/core/src/summoners.rs` (SHA-256 `7AF19297380715624CB37F70AB62DFA9A65F7C8665E49B7699EE495D7A0D56A3`) charge `barrier_rules.json` (ligne 28). La branche Barrier applique le bouclier au lanceur puis fixe `ready_at` avec `spells::seconds(r.cooldown_seconds)` (lignes 76–86). Le dispatch commun refuse un sort si `tick < ready_at` (lignes 67–68).

- Attendu source/catalogue : 210 s.
- Observé dans la règle effectivement chargée : 210 s; l’appel courant programme donc `tick + seconds(210)`.
- Cas nominal existant : `barrier_has_native_duration_cooldown_and_level_endpoints` attend `ready_at=6300` (ligne 115). Test inspecté, non exécuté.
- Limite/refus : pendant la période définie par `ready_at`, le code retourne `summoner spell on cooldown`. Ce refus est établi statiquement, sans exécution runtime.

## Limites et reprise

Ce lot confirme le cooldown de base côté client/catalogue/règle locale; il ne prouve pas l’éligibilité de Barrier dans une partie Map10, l’unlock de compte au niveau 4 malgré le champ catalogue, les modificateurs de cooldown, l’effet de bouclier en partie ni l’acceptation humaine. Le `CastRange=1200.0000` natif n’est pas interprété comme une portée de ciblage : le catalogue dit `self` et cette question reste hors de ce lot.

Reprendre les questions de disponibilité sur une source primaire de configuration/serveur 4.20 pour Map10 ou un reçu d’exécution équivalent. Corriger l’annotation de provenance de `barrier_rules.json` uniquement dans un lot autorisé de modification des données. Ne pas redécoder ou rehasher l’INIBIN sans changement de fichier.

Contrôles exécutés : SHA-256 de la source native et des trois fichiers locaux; décodage du champ avec le lecteur présent; lecture ciblée du catalogue et des callsites. Aucun test, build, exécution de binaire, code, donnée de jeu, registre, statut, goal, Plan, application, base de suivi, installation ou migration modifié.