# Audit SYS-01.2-02 — vision Embrasement après retrait du lanceur (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-IGNITE-VISIBILITY-REMOVED-SOURCE-01 ; parent SYS-01.2-02 ; exigence SUMMONER-SummonerDot-SERVER OLF-c13b0fc7-93e2-53ec-aafd-f3200f31b54a et SYS-13.2-06 ; NET distinct. Question : dans la simulation courante Map10, la cible brûlée reste-t-elle visible pour un allié après retrait du lanceur et jusqu'à quel instant ? Critères : sortie de vision ordinaire démontrée, sort réellement lancé, source réellement retirée, état de l'effet, visibilité et snapshot comparés avant/après, bornes et refus, preuves et limites. Le retrait local n'est pas assimilé à une déconnexion réseau.

## Sources et consommateurs

Réutilisation de `AUDIT_SYS01202_SUMMONER_IGNITE_SERVER_2026-11-03.md` V1094 : source client 4.20.0.315 `DATA/Spells/SummonerDot.inibin`, OLS-039538f3-9b97-5d5c-a0da-161181745379, SHA-256 da501486c705554143541a7ba767f8e8258521a8d3d525519d10b99a9d65ce66 ; catalogue comparatif officiel 4.20.1 OLS-22f06d52-9752-5b89-863b-92b0614a555e. Identités reprises du reçu V1094, non rehashées ici. La source client et la description du catalogue ne prouvent pas le comportement d'un serveur Riot après départ ou déconnexion.

Le test courant `summoner_ignite.rs::disconnected_source_does_not_cancel_remaining_damage_or_target_reveal` vérifie après suppression du joueur des dégâts et la persistance de la brûlure, pas la visibilité ; un autre test vérifie visibilité et expiration avec lanceur présent. La recherche bornée dans `crates/core/src` et `crates/core/tests` n'a pas identifié de test associant les deux opérations. `summoner_ignite.rs` crée l'effet avec l'équipe source ; `vision.rs::visible_to` utilise cette équipe et l'expiration, puis `snapshot_for` filtre la cible ; `attacks.rs::remove_player` est ici le chemin local public de retrait. Map10 et ses interactions sont actives : sans interactions, visible_to a un retour anticipé qui rendrait le test non probant.

## Attendu et observé

La fixture charge la navigation locale, crée un lanceur Garen, une cible ennemie et un observateur allié. Elle place temporairement la cible hors de vision ordinaire : `visible_point_to=false`, `visible_to=false`, cible absente du snapshot. Elle la remet à portée, utilise `cast_summoner_on` puis la replace au point éloigné et appelle `Simulation::remove_player` sur le lanceur. Les positions, la suppression des unités et les instants sont fournis par la fixture ; ce déplacement n'est pas une commande de joueur.

Après retrait, à tick 0, le lanceur est absent, la vision ordinaire reste fausse, la cible est visible et présente dans le snapshot de l'observateur. À tick 149, l'effet subsiste et les mêmes résultats sont observés. À tick 150, son expiration, l'effet est absent, la vision ordinaire reste fausse, la cible n'est plus visible ni incluse dans le snapshot. Le point de vision ordinaire est recontrôlé à chaque instant nommé. Un identifiant de cible inexistant et une équipe 2 sont refusés par `visible_to` dans cet état Map10.

Cette exécution constitue une preuve du comportement **local** précis pour le retrait de source. Elle ne démontre pas une déconnexion récupérable : V139 indique qu'un détachement de session conserve le joueur. Elle ne démontre pas non plus la règle Riot, la furtivité, tous les types de vision ou un transport réseau.

## Exécution et preuves

Dans `E:/mapslol3v3/audit_ignite_visibility_source_removed_20261103` : `cargo generate-lockfile --offline` puis `cargo run --offline --locked`, code 0 ; Cargo/rustc 1.96.1, 24 avertissements préexistants du core, aucune erreur. Code `src/main.rs` SHA-256 c1c1580d8271a0ecdb66356d736762e5da364515421f9cd79bf33fdc44bb274f ; `run.log` SHA-256 bd0d13546d98e217d5acf4d2642d91adfc6e931d46995723415a400914323ad6. `sha256.json` SHA-256 36d4951534726f8184d733f5074673241ce65d691d8dd060cb9bb3e7820e79e3 : 13 fichiers relus et identiques avant nettoyage, liste non exhaustive des dépendances compilées.

L'exécutable initial `target/debug/audit-ignite-vision.exe` est conservé à la racine de la fixture après comparaison d'empreinte : SHA-256 375d4d6070cc430f6596d1d79a9f839949e96082f3dc33c8f3730acd975ade72. Seul le target Cargo généré pour ce test, environ 1,24 Go, a été supprimé. Le reçu garde son ancien emplacement de compilation ; une nouvelle compilation régénère target.

## Correction documentaire et reprise

`FIDELITY_WARD_STEALTH_LINKS_4_20.md` V105 affirmait que la déconnexion conservait la révélation. Les quatre tests et le reçu examinés n'établissent pas conjointement visibilité et retrait, ni une déconnexion réelle ; V1094 avait déjà signalé la limite du test nommé. Une précision est ajoutée au début de V105 en conservant sa formulation et ses preuves historiques. Ce nouveau test établit le résultat ci-dessus pour `remove_player`, pas pour une session détachée.

Réutiliser SUMMONER-SummonerDot-SERVER et SYS-13.2-06 pour qualifier les règles historiques, notamment furtivité et recouvrement ; SUMMONER-SummonerDot-NET pour le chemin réseau et ses audiences. Reprendre le cas déconnexion avec session identifiée et état de détachement réel, puis source serveur 4.20 attribuable ou capture fiable pour la fidélité historique. Aucun changement produit n'est justifié par ce seul scénario réussi ; ne pas le rejouer sans modification pertinente.

Audit de ce cas local terminé ; fonctionnalités et parcours réseau globaux restent partiels, acceptation humaine non établie. Aucun changement du goal, du code produit, d'OpenLeague Plan, de ses registres ou bases.
