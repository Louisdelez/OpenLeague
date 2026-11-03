# Audit SYS-01.2-02 — coût HUD de Yasuo W (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-YASUO-W-HUD-COST-01 ; parent SYS-01.2-02 ; réutilisation de CH-Yasuo-W-PRESENTATION-HUD. Question : que retourne le calcul client quand Yasuo W est appris, prêt et autorisé mais que ses champs de coût sont absents ? Les résultats doivent couvrir ces rangs, des gardes et un témoin nominal, en identifiant les sources, adaptations et limites. Ce lot ne valide pas une partie jouable, l'affichage graphique ou une règle Riot.

## Sources et consommateurs

V1113 et FIDELITY_HUD_COST_GRAPH_V230.md ont constaté que ManaCost1 à ManaCost5 manquent dans l'INIBIN client et l'export 4.20 ; leur conclusion sur l'erreur HUD était statique, sans exécution Yasuo. Source originale `DATA/Characters/Yasuo/Spells/YasuoWMovingWall.inibin`, 949 octets, SHA-256 424577841fb8cab0399469a3b1ba799a759914df86621e5d0f096e85242b5443 ; export `F:/OpenLeague/data/4.20/native_spells_420.json` SHA-256 0cae6f5c167aa852e8f86e7f3298d7c797727d5cc92616dcb856ac15c8af5d14. Ces identités ont été relues ; l'absence de champs est réutilisée des contrôles antérieurs et ne définit pas le défaut historique de coût.

Consumer courant `crates/client/src/native_hud_spells.rs`, SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d : `player_states` lit le rang, la récupération, l'état du joueur puis la valeur de coût ; `state` choisit l'état du slot. Lecture statique en aval : `native_hud_summoners.rs::all_states` propage l'erreur et `native_hud_spells.rs::update` appelle `clear`, qui retire ses entités et matériaux suivis. Cette propagation n'a pas été exécutée avec Bevy ni observée à l'écran ; aucune autre partie du HUD n'est couverte par cette conclusion.

## Attendu et observé

- Apprentissage réel local : `Simulation::command(Learn {slot:1})` pour Yasuo refuse `champion skill progression not implemented` ; le rang W reste 0. Le contrôle ne démontre donc pas un état actuellement atteignable par une partie normale.
- Injection explicite en mémoire : aux rangs W 1 à 5, joueur vivant et sort prêt, les fonctions client extraites retournent chacune `native spell cost unknown`, comme attendu. Cela confirme le résultat de la fonction, pas un rendu réel.
- Témoins de garde : rang non appris `[2,2,2,2]` ; W rang 1 injecté en récupération `[2,4,2,2]` ; W rang 1 injecté avec joueur mort `[2,3,2,2]`.
- Témoin distinct : apprentissage local d'Annie E accepté ; sort prêt `[2,2,0,2]`, puis mana injecté à zéro `[2,2,5,2]`. Le témoin ne démontre pas la sémantique native de Yasuo.

## Exécution et preuves

La fixture sous `E:/mapslol3v3/audit_yasuo_w_hud_20261103` extrait textuellement `state` et `player_states` du fichier client, et compile avec le core courant de F:. La seule adaptation du fragment est le chemin de `include_str!` vers le même JSON original sur F: ; `src/original.rs.txt` et `src/extracted.rs` sont conservés et comparables. `prepare.py`, la fixture, les entrées principales et leurs 14 empreintes vérifiées sont dans `input_sha256.json` SHA-256 f2df661cbb8065d7a0a331c60855abb5521003f97e1a1f46d6db1efa1cf80226 ; ces empreintes ne constituent pas la liste de toutes les dépendances compilées.

`cargo run --offline --locked` : code 0 ; Cargo/rustc 1.96.1 ; 24 avertissements préexistants du core, aucune erreur finale. `run.log` SHA-256 8783f2c5207c116b09b8756b9d9602e653fe4c7664ba4ab59ff75ee695048cae. Une première compilation de la fixture avait échoué sur l'utilisation incorrecte de `as_deref` pour un tableau ; elle a été corrigée dans la fixture seulement et `build_failure.log` est conservé. Le binaire initial `target/debug/audit-yasuo-w-hud.exe` a été recopié à la racine de la fixture et vérifié SHA-256 bfe71343d383f4f9270f6bcff3d0c4bda6a5d2ee3022aecd634bb649e635ee29. Les seuls intermédiaires Cargo générés sous ce target, environ 1,26 Go, ont été supprimés après comparaison des empreintes.

## Écarts et reprise

La fonction actuelle ne peut pas produire les quatre états de sorts dans le cas injecté ; la lecture du code indique ensuite un effacement des entités suivies par ce module. Ni événement Bevy ni affichage n'ont été exécutés. L'apprentissage est lui-même non implémenté pour Yasuo ; l'absence de coût dans une ressource client ne prouve ni coût nul ni traitement serveur historique. L'existence et l'effet du défaut historique, la ressource utilisée et la fidélité de l'affichage restent ouverts.

Réutiliser CH-Yasuo-W-PRESENTATION-HUD : qualifier source native du comportement sans ManaCost et ressource utilisée, implémenter séparément la progression nécessaire puis vérifier les quatre états, une situation de ressource insuffisante si applicable, la récupération, la mort et le rendu du HUD en session identifiée. Un coût ne doit pas être inventé. Les tâches de simulation et d'acceptation restent distinctes. Ne pas rejouer ce test isolé sans nouvelle entrée ou modification pertinente.

Audit du calcul borné terminé ; progression, présentation en partie, fidélité historique et acceptation humaine restent ouvertes. Aucun changement du goal, du code produit, d'OpenLeague Plan, de ses registres ou de ses bases.
