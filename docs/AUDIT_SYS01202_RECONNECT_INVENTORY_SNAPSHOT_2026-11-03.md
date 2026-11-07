# Audit SYS-01.2-02 — inventaire dans le snapshot après reprise (2026-11-03)

## Unité et périmètre

AUD-SYS-01.2-02-RECONNECT-INVENTORY-SNAPSHOT-01 ; parent SYS-01.2-02, rattachement SYS-20.3-02 et SYS-20.3-03. Question : après détachement puis reprise, les identifiants et les quantités de l'inventaire du joueur sont-ils présents dans le snapshot local réassemblé pour la nouvelle époque ? Critères : source et consommateurs identifiés, état initial et final décodés, témoignage d'une pile, refus entre époques, identité des entrées et limites. Le transport réel, le commit ou le rendu côté client et la fidélité du protocole historique sont exclus.

## Sources et consommateurs

V139, `docs/FIDELITY_RECONNECTION_LINKS_4_20.md`, établit la conservation du joueur et la reconstruction de sa route, mais laisse explicitement ouverte la couverture des champs d'inventaire et de l'état client complet. Le test antérieur `crates/server/src/session_host_tests.rs` vérifie un joueur conservé avec une botte injectée, sans décoder son inventaire et ses quantités dans le snapshot après reprise.

La référence native d'inventaire est décrite dans `docs/audit/units/AUD-17.1-05-INVENTORY-01.md` : `HUD.zip` du client PUBLIC 4.20.0.315, SHA-256 76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c, recontrôlé ; ce ZIP contient notamment les ressources d'icônes et compteurs. Il ne définit pas le protocole de reconnexion serveur historique. Cette preuve locale ne doit pas lui être attribuée.

Consommateurs courants : `crates/server/src/session_host.rs` gère reprise et route puis `Host::states` appelle `snapshot_for_atomic` et construit les fragments ; `crates/core/src/vision.rs` produit le snapshot filtré pour le joueur ; `crates/core/src/session_wire.rs` le réassemble et le décode ; `crates/core/src/lib.rs` définit les tableaux de six identifiants et six comptes. La fixture importe directement les modules serveur et le core de F:, sans modification de leur code. L'admission, le temps, l'entropie, les adresses et la déconnexion sont simulés en mémoire.

## Attendu, observé et refus

La fixture admet Garen, puis utilise les commandes d'achat du core pour 1001 et deux 2003. Avant détachement, le snapshot de l'époque 1 est réassemblé à partir de sept fragments et contient les identifiants `[1001, 2003, vide, vide, vide, vide]` et comptes `[1, 2, 0, 0, 0, 0]`. Après poll de silence simulé et reprise, le même joueur est l'unique participant, l'époque passe à 2 ; les sept nouveaux fragments décodent exactement les mêmes tableaux.

L'assembleur initial refuse le premier fragment de la nouvelle époque avec `Context`, et l'assembleur de la nouvelle époque refuse le premier fragment de l'ancienne avec le même motif. Le test porte sur ces premiers fragments, pas sur tous les cas de transport, perte ou ordre réseau.

Témoin distinct : un objet Champion sérialisé est modifié seulement en mémoire pour retirer `inventory_counts` ; la désérialisation donne six zéros. Ce défaut et la convention locale de quantité sont déjà documentés dans AUD-17.1-05-INVENTORY-01 ; cet objet synthétique n'est pas un paquet réellement reçu et ne démontre pas une règle native.

## Exécution et preuves

Depuis `E:/mapslol3v3/audit_reprise_inventaire_20261103` : `cargo run --offline`, code 0 ; Cargo et rustc 1.96.1. Sortie `run.log` SHA-256 c2d9bfb59ad7d08310b20f3091bc2e1eceddeb1ccf33a2ee300f76ea75abf15f. Compilation avec 24 avertissements préexistants du core, sans erreur. `src/main.rs` SHA-256 ad589209b34d1699fbd5aed1515bf7584b3979f32b302bfea2d8a496991b0626. `sha256.json` SHA-256 d8bd4fc1609078da6eb5bfa462584ea1838429ac9046147fa84e5d0791808227 identifie 16 fichiers ; les 16 empreintes ont été relues avant nettoyage. Il recense les principales entrées mais pas individuellement toutes les dépendances compilées.

Le binaire initialement sous `target/debug/audit-reprise-inventaire.exe` a été conservé à la racine de la fixture sous le même nom, SHA-256 4ffc40fc726b2e494ed6c726cb586aebf46e20785c4ffe7763b8fae419b2719e ; l'identité des copies a été comparée. Seuls les intermédiaires Cargo générés sous le dossier target propre à cette fixture, environ 1,30 Go, ont été supprimés après vérification. Le reçu conserve le chemin de compilation initial ; une reproduction Cargo régénère target.

## Écarts, suite et décision

Ce cas local établit la présence des deux tableaux dans un snapshot réassemblé après reprise, et la barrière de contexte pour les deux fragments testés. Il ne démontre ni connexion réseau réelle, ni réception/commit client, ni affichage des icônes ou compteurs, ni conservation d'autres champs privés, ni gestion complète des transitions de visibilité, ni règle de reconnexion Riot 4.20. L'existence de `serde(default)` ne distingue pas dans cet objet l'absence du champ d'un tableau de zéros : cette convention locale préexistante ne décide pas à elle seule d'une correction.

Réutiliser SYS-20.3-02 et SYS-20.3-03. Reprise : identifier versions et binaire client/serveur courants puis vérifier, dans une session locale autorisée, réception et commit après perte/reprise, rendu des deux quantités, états obsolètes, pertes de fragments et autres champs privés ; qualifier la référence historique uniquement avec un artefact ou une trace attribuable. Ne pas répéter cette fixture sans changement pertinent. Aucun correctif n'est proposé pour le cas qui passe ; les tâches plus larges restent ouvertes.

Audit de ce sous-périmètre terminé ; fonctionnalité globale et vérification de parcours restent partielles ; acceptation humaine non établie. Goal parent toujours partiel. Aucun goal, registre, application, interface ou base modifié.
