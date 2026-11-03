# Audit SYS-01.2-02 — compétences, session et reprise (2026-11-03)

## Périmètre et critères

Unité AUD-SYS-01.2-02-SKILL-SESSION-RESUME-01 ; parent SYS-01.2-02. Quatre exigences liées : SYS-05.1-02 refus sans point, SYS-05.1-03 répétition et double dépense, SYS-05.1-04 identité de commande, SYS-05.1-05 conservation des points à la reprise. Ce lot vérifie un chemin local séquentiel avec deux joueurs, des refus et un point non dépensé avant/après reprise. Il n'établit pas une concurrence réelle, un réseau réel, les autres chemins d'entrée ni le serveur historique.

## Sources et traçabilité

`FIDELITY_SKILL_LINKS_4_20.md` V77 a relié les données de compétence et les consommateurs et décrit ces quatre comportements comme des conclusions de lecture, avec limites. Les octets natifs `LEVELS/Map10/ExpCurve.inibin` (200 octets, SHA-256 88c26d8999f8e95a6b2bc8e453a5a4186229ea4ef88f3e8e37e8c1dde8a22561) et `DATA/Characters/Garen/Garen.inibin` (1 065 octets, SHA-256 17268558d84561f9b59e89a312dfdf2888971c9202a7abc0a7a6f1c97b0105d5) concordent avec le reçu V77. Ces sources client/données d'auteur ne prouvent pas la comptabilité de points, l'authentification ou la concurrence du serveur Riot.

Relecture en lecture seule de `docs/fidelity_requirement_trace_4_20.json` : chaque fiche ci-dessous a zéro `native_inputs` direct, une référence indirecte vers la preuve V77, trois consommateurs, une inconnue et le statut `partial_with_open_questions`. Le fait que des sources natives soient décrites dans V77 ne crée pas de lien direct dans ces fiches ; aucune modification du registre n'est faite.

| Tâche | Identité | Inconnue conservée |
|---|---|---|
| SYS-05.1-02 | OLF-6d3c3f2a-5d64-56d8-ba0e-35231308a2e6 | OLU-b2ec14bc-0f80-5e1e-b29b-93982b30034f |
| SYS-05.1-03 | OLF-68e13e43-96a8-5676-b658-5b0f963ce4ae | OLU-7c01bbcf-8868-57e2-92e9-94359208458e |
| SYS-05.1-04 | OLF-cf33ed2b-0de2-5404-a8f8-1fe1330fbeb8 | OLU-834069ef-49d5-5b3c-a7b6-a5d3714d406d |
| SYS-05.1-05 | OLF-133a861f-d50f-56df-ba51-76f2d9db19a0 | OLU-4a6eb061-5609-5b92-ade5-70785196dd35 |

Consommateurs : `crates/core/src/progression.rs::next_rank/learn` vérifie notamment `sum(ranks)<level` avant mutation ; `crates/server/src/session_host.rs` route la commande sur le joueur du contexte authentifié ; `reconnect.rs` qualifie la session, l'adresse, la clé et la séquence ; `session_wire.rs` assemble les snapshots. L'XP contrôlée est attribuée par `Simulation::award_experience`, pas par une commande réseau de joueur.

## Attendu et observé

La fixture utilise les modules serveur réels et le core courant, avec deux joueurs Garen A et Annie B. Les messages passent par sérialisation/désérialisation courante puis `Host::handle` en mémoire. Identités, temps et entropie sont injectés ; aucune valeur de secret n'est imprimée.

- A niveau 1 dépense son point sur Q. Le rejeu de la séquence 1 est refusé `StaleSequence`. Une séquence 2 nouvelle pour W reçoit `no skill points` ; son rejeu reçoit `StaleSequence`. Les rangs de A et B restent inchangés après refus.
- Un contexte B avec clé A, puis un message B depuis l'adresse A, sont refusés `Unauthorized` ; les états sérialisés des deux joueurs restent inchangés. B peut ensuite apprendre W avec son propre contexte.
- L'API réelle reçoit 300 XP injectés pour A, qui atteint niveau 2 avec rangs `[1,0,0,0]` et donc un point disponible selon la formule locale. Les deux sessions expirent lors d'un poll de temps simulé ; seule A est reprise, même joueur, époque 1 vers 2, B restant détachée. Les snapshots de A avant et après reprise contiennent niveau 2 et les mêmes rangs ; le point calculé reste 1. Les anciens identifiants de A sont refusés. Une nouvelle commande authentifiée apprend W ; le snapshot suivant contient `[1,1,0,0]` et zéro point calculé.

Ces résultats sont des observations pour les séquences choisies. Ils ne prouvent ni l'atomicité sous concurrence réelle, ni tous les refus/époques, ni une persistance après redémarrage, ni la présentation client.

## Contrôles et preuves

Depuis `E:/mapslol3v3/audit_skill_session_resume_20261103`, Python 3.12 du venv F: avec `-B trace_sources.py` : code 0 ; `trace_sources.py` SHA-256 0e2b5ed2045e75f6b277f6ed7b4b9a7e91a0a6264efee44a020f78de0cef2754, `trace_sources.json` SHA-256 a1b7a281fdc0c9c95d8d657a622f16d44b6478ade81fe83552f5249ce061a414. Neuf empreintes et quatre fiches ont été relues indépendamment.

`cargo generate-lockfile --offline` puis `cargo run --offline --locked`, code 0 ; Cargo/rustc 1.96.1 ; 24 avertissements préexistants du core et un avertissement de copie faute de hard link, sans erreur finale. Le scénario a été relancé après ajout de l'XP et des assertions finales ; les sources et journaux précédents sont conservés. `run.log` SHA-256 734f2cc4931e226445d8136e0e038335e64bae0378852268fc54e3652d325b49 ; `sha256.json` SHA-256 24207ba633b6e4474e7c408ab70d09ee120f23ca588785e6bce3f740395e4004 : 21 empreintes relues avant nettoyage, sans prétendre énumérer toutes les dépendances. Le binaire final conservé à la racine du dossier a pour SHA-256 f9777ee2195e2ad6b5d50a0ecce9045b4709120ec4b1f7b8f8d7d9fad939a5f8. L'exécutable de la première version a été écrasé par la recompilation avant sa copie ; son hash et son journal sont conservés, pas son binaire. Les seuls intermédiaires Cargo de cette fixture, environ 1,31 Go, ont été supprimés après vérification du binaire final.

## Écarts et reprise

Les quatre liens natifs directs manquent dans la trace consultée et les questions historiques restent ouvertes. Les résultats ci-dessus sont une preuve locale ciblée, pas une décision historique ni la clôture des tâches. Réutiliser SYS-05.1-02 à 05 : qualifier les sources historiques attribuables du comptage, des autorisations, des doublons et de la reprise ; définir les politiques de séquence et de persistance, puis exercer concurrence réelle, transport, client et cas de redémarrage avec versions identifiées. Ne pas assimiler la sérialisation en mémoire à un échange réseau, ni une suite de messages à une course. Une modification ultérieure des registres nécessite une autorisation compatible avec la restriction courante.

Audit de ce sous-périmètre terminé ; implémentation et vérification globales restent partielles, acceptation humaine non établie. Aucun code produit, goal, application de suivi, registre ou base modifié.
