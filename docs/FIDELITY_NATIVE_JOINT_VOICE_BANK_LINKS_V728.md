# SYS-01.2-02 — Chargement conjoint des voix, V728

Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315, EUW/en_GB ;catalogue4.20.1 distinct.

## Résultat

Les dispatchers originaux AFBB60 et AFBE20 chargent les actions et événements dans leur ordre relatif HIRC, pour les banques de base et propres aux skins. Les autres types d'objets HIRC restent exclus. Les noms, le repli et la disponibilité natifs sont ensuite exécutés dans la même image isolée.

364 contextes couvrent668skins,680configurations et12672demandes. Chaque ensemble de banques est testé dans deux ordres opposés explicitement fournis. Aucun de ces ordres n'est présenté comme l'ordre historique.

- 9324 demandes de chargement d'action, dont 38 réutilisent un objet.
- 8860 demandes de chargement d'événement, dont 38 réutilisent un objet.
- 8322 demandes de voix trouvent un événement, dont 10 après repli.

## Provenance et comparaison

L'événement déjà présent conserve sa liste d'actions dans les cas contrôlés. Les actions0403 déjà chargées et0103 présentes sont également réutilisées. Les objets effectivement retenus et les banques d'origine de leurs actions sont enregistrés.

30 provenances d'événements diffèrent des contextes à inscriptions directes V726. Le nom choisi reste identique pour les12672demandes. V726 reste une preuve datée d'un contexte différent ;ce résultat ne détermine pas l'ordre historique ni le média qui serait joué.

## Contrôles exécutés

- 1814 adresses exécutées contrôlées contre le PE.
- Sept diagnostics : première inscription, événement réutilisé, référence d'action absente, identifiant d'action zéro, allocation refusée, lecture refusée et capacité propriétaire nulle.
- Dans le dernier cas, le retour vaut1 et l'événement est inscrit malgré l'absence de place dans le tableau propriétaire. Cela ne valide pas le prérequis d'allocation du véritable appelant.
- Trois gardes de forme du banc ;quatre preuves falsifiées rejetées.
- 387 sources et 29 points de code actuels vérifiés.
- 1279fiches et instructions copiables dans les deux bases ;données manuelles, autres tâches, prérequis et inconnues conservés.

PE : League of Legends.exe, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Python, modules, DLL et scripts sont identifiés dans le reçu. Les cas détaillent attentes, observations, pointeurs, origines et objets réutilisés.

## Portée actuelle

Les consommateurs actuels restent les lecteurs de références, chargeurs de modèles, contrats/dispatchers d'ambiances et points audio déjà présents. Aucun fournisseur complet de voix de champions ou de skins n'est déclaré fonctionnel. La frontière6F78A0 enregistre les demandes et retourne false ;aucun son n'est joué.

## Limites

- Original AFBB60 action and AFBE20 event dispatchers run in serialized relative HIRC order for types3/4. Other HIRC object types are excluded; media target tables are empty. Payload reading,allocation,locks and memcpy are bounded adapters; full bank-file orchestration and historical loading order are not claimed.
- Both base/own bank orders are declared. Reused action/event objects keep their original loaded fields/action list in the exercised corpus. Event origins and actual retained action objects are recorded. V726 direct registrations remain separate dated contexts,not historical precedence.
- Original simple voice naming,fallback and native availability execute in this joint image. Definitions/flags/aliases retain V724 pinned observations; ordinal,empty suffix,position,owner token and backend enable are declared.
- Playback6F78A0 only records a request and returns false. Availability does not establish target graph,media selection/decoding or audible playback. Current game voice wiring,role producers,SFX,locale and AIR selection remain open.
- Allocation/read/absent-action/zero-action and owner-capacity diagnostics use synthetic events. Shape guards are harness refusals,not native bounds validation. Logical frees do not prove physical reclamation.
- Les1278fiches audio de skins/voix de champions et SYS sont enrichies ;cases,notes,historiques et inconnues preserves. Selection AIR distincte.
- Les flags/alias sont verifies de nouveau dans456fichiers de configuration pour le rapprochement ;la construction complete du hero reste hors de cette composition.
- Le corpus prive est conserve une seule fois sur F et pine par le rapport/fiches. Relecture complete depend de sa presence.
- Deux essais preliminaires se sont arretes sur des erreurs du banc : collision du nom x entre module et variable locale,puis verification ASCII affectee par le renommage. Sources conservees ;source verified distincte,essai preliminaire et corpus complet passes.

## Fichiers et preuves

Le [reçu de liaison](fidelity_native_joint_voice_bank_links_v728.json) pointe vers revision728_joint_voice_banks_verified/OBSERVATIONS.json sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Fichiers enrichis : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md, ce rapport et son reçu. Les deux plan.sqlite3 du projet et du bureau reçoivent les instructions ciblées.

Livraison : revision728_delivery/VERIFIED.json puis INDEPENDENT_READBACK.json. Deltas ciblés sans copie intégrale des bases. Aucun code du jeu ni asset modifié. Le goal reste ouvert.
