# SYS-01.2-02 — Chargement natif des actions de voix, V727

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue 4.20.1 distinct.

## Résultat

Les 3 540 actions des 364 banques de voix sont chargées par le dispatcher original AFBB60 et le lecteur B222C0 :3 510 actions0403 et30actions0103. Les cibles, flags, propriétés, sous-types et valeurs chargées sont confrontés aux octets originaux.

Le lecteur B225A0 traite les propriétés simples, AF2B90 les plages, B2D3E0 la suite0403, B2F150/B2EDE0 la suite0103. Le transport de lecture, l'allocation et les copies mémoire sont fournis au banc isolé. Le chargement complet des fichiers et du moteur reste distinct.

424 champs de propriété14 sont multipliés par48, modulo2^32, avec la constante embarquée12100F4=48000. Aucun taux effectif historique ou unité de lecture sonore n'est déduit. Les autres propriétés restent comparées comme mots bruts.

Les 3 382 événements sont chargés après les actions et interrogés par la disponibilité native. Ils retournent le statut3 avec zéro cible média dans le contexte fourni. Aucune lecture sonore n'est démontrée.

## Rechargement et limites de précédence

Les essais de rechargement conservent la même action0403 déjà marquée chargée ;une action0103 présente est aussi réutilisée. Les nouvelles valeurs de cible/délai fournies dans le second payload ne remplacent pas les valeurs initiales dans ces cas.

V726 inscrivait directement les actions et événements dans des registres déclarés. Ce test exerce le dispatcher d'action en amont. Les résultats V726 restent datés et ne deviennent pas une preuve de la précédence historique. Le dispatcher d'événements et le chargement conjoint de banques restent à qualifier.

## Vérifications exécutées

- 364 banques,3 540 actions,3 382 événements ;424 champs de délai.
- 964 adresses exécutées comparées au PE.
- Dix diagnostics : délai simple, plage de délais, flags2/128, exceptions0103, deux rechargements, trois échecs d'allocation.
- Six gardes du banc ;quatre falsifications de preuve rejetées. Les gardes ne constituent pas des refus du parser natif.
- 387 sources et 29 ancres actuelles vérifiées.
- 1 279 fiches avec leurs instructions dans les deux bases :668audio de skins,610voix de champions et SYS. Cases, notes, historiques, autres tâches et inconnues conservés.

Exécutable : League of Legends.exe, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Python, modules et scripts sont identifiés dans le reçu. Les contrôles détaillent attentes et observations.

## Consommateurs actuels

Le contrat actuel Action.properties utilise une table f32 issue de JSON. L'inclusion ambient_audio_selection.json et le dispatcher existant restent des consommateurs d'ambiances/contrats fournis. Ils ne constituent pas un lecteur équivalent B222C0 des banques de champions. Les liens conservent les frontières réelles sans déclarer les voix fonctionnelles.

## Limites

- Original AFBB60 action dispatcher,factory/registry,B222C0 target/boolean/property reader,B225A0 scalar reader,AF2B90 range reader,and subtype readers execute unchanged. Actual source payload bytes are supplied through declared readonly bank reader transport AF7940/AF7A40. Whole file/worker/startup loading remains open.
- Allocator and memcpy are bounded transport adapters; diagnostic allocation failures and logical free callbacks do not qualify host allocator behavior or physical reclamation. Fresh action/event manager state is declared separately per bank.
- Global12100F4 retains embedded48000. Property14 words are multiplied by48 modulo2^32; historical runtime reconfiguration and effective media rate are not established. Other property words remain raw bits; no float/int semantic promotion is inferred.
- All corpus actions are0403 or0103,header alternate byte0 and no range properties. Range/alternate/exception cases are explicit diagnostic payloads,not historical assets. Harness rejects malformed inputs before native parsing; no native bounds-safety claim.
- Original event payload loader and availability query are checked after native action loading,with target tables empty. No media graph,selection,decode,playback,current-game voice wiring or historical joint bank order is qualified.
- Les1278fiches de voix de champions et audio de skins,plus SYS,sont enrichies sans cocher de case. AIR SELECT reste distinct et inchange.
- Le corpus prive reste pine sur F,sans seconde copie integrale. Les fiches lient les actions par banque et par evenements nommes des contextes V726 ;ce rapprochement ne rejoue pas toute la voie de nommage ni le dispatch complet de banque.
- V726 utilisait les constructeurs/inscriptions directs. AFBB60 teste ici reutilise les actions0403 deja chargees et les0103 presentes. Les deux preuves ont des contextes differents ;aucune priorite historique n est promue.
- Le premier essai complet s est arrete sur une garde du banc : la limite de taille du dernier payload d action etait encore active pendant la lecture d un evenement plus long. La source et l echec sont conserves. Le banc corrige met a jour cette limite avant chaque evenement ;essai preliminaire et corpus complet passes.

## Fichiers et preuves

Le [reçu de liaison](fidelity_native_voice_action_reader_links_v727.json) référence le corpus privé revision727_action_reader_checked/OBSERVATIONS.json sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Fichiers du projet enrichis : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md, ainsi que ce rapport et son reçu JSON. Les deux plan.sqlite3 du projet et de l'application bureau reçoivent les instructions ciblées.

Livraison : revision727_delivery/VERIFIED.json puis INDEPENDENT_READBACK.json. Deltas ciblés, sans copie intégrale des bases. Aucun code du jeu ou asset modifié. Le goal reste ouvert.
