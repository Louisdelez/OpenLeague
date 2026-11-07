# SYS-01.2-02 — Lecteur des objets sonores, V731

Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Les voix examinées portent le chemin en_US ; leur sélection historique reste ouverte.

## Résultat vérifié

Les 11 055 objets sonores passent la fabrique B226A0 et le lecteur complet B22AF0, avec AFA240, B02000/B01ED0 et B00A50. Les 77 651 champs retenus des objets sont comparés aux octets originaux. Les états du parseur et de la source, les identifiants de parents/bus et la consommation complète des payloads sont vérifiés.

| Sources originales | Nombre | État observé |
|---|---:|---|
| Fichier diffusé, type 1 | 10 922 | Identifiants conservés, offset/taille mis à zéro, drapeaux transformés |
| Fichier embarqué, type 0 | 113 | Identifiants, offset absolu et taille conservés |
| Plugin 0x650002, paramètres de taille nulle | 20 | Chemin B01ED0 ; identifiant source conservé, fichier/plugin à FFFFFFFF |

Le dernier état ne prouve pas la création du plugin ni la génération de silence. Aucun média n'est décodé ou joué.

Les 11 052 rattachements à un parent de type 5 et les 3 rattachements à un parent de type 7 correspondent à des objets présents dans la même banque que leur enfant. Ces nombres comptent les rattachements, pas les parents distincts. Les deux références directes à un bus existent dans Init.bnk. Les fabriques originales créent ces dépendances et le lecteur rattache le son aux objets correspondants. Les payloads des parents et bus, leurs réglages et leur mixage restent ouverts.

Les 1919 adresses exécutées correspondent au PE original SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Chaque son utilise un nouveau registre ; le dispatcher AF8170 et le chargement historique de banques entières ne sont pas exécutés.

## Diagnostics vérifiés

| Cas | Attendu | Observé |
|---|---|---|
| Parent absent | Retour 1, sans parent | Conforme |
| Bus requis absent | Retour 2, curseur 27 | Conforme |
| Type de plugin non pris en charge | Retour 2, curseur source 21 | Conforme |
| Type de flux 3 pour une source fichier | Retour 2, curseur source 29 | Conforme |
| Bits source à 255 | Masquage, état source 645 | Conforme |
| Flux préchargé, type 2 | Offset/taille conservés, drapeaux transformés | Conforme |
| Allocation du vecteur d'enfants refusée | Retour 2, curseur 31, aucun rattachement | Conforme |
| Rechargement d'un son existant | Retour 1, curseur 23 après le bloc FX, parent conservé | Conforme |

Trois gardes du banc refusent une taille incorrecte ou un identifiant différent ; elles ne qualifient pas la sécurité du lecteur historique face à un fichier corrompu. Quatre falsifications d'observations sont rejetées.

Le nom initial du diagnostic d'allocation évoquait les propriétés. Une nouvelle trace indépendante démontre que l'échec se produit dans AFF610, appelé par AE0A10 lors du rattachement au parent. Cette correction conserve la source et la preuve brutes et les complète par revision731_allocation_boundary/OBSERVATIONS.json.

## Consommateurs et intégration

Les 569 sources et 29 points de code actuels sont vérifiés. Ils restent des lecteurs de référence, modèles et fonctions audio d'ambiance ; aucun fournisseur complet de voix de champions ou de skins n'est déclaré fonctionnel.

Les 1 279 fiches (668 skins, 610 voix de champions et SYS), leurs liens de sources et leurs instructions copiables dans les deux bases sont enrichis. Les autres tâches, cases, notes, historiques, prérequis et inconnues sont conservés. Les 12 672 demandes antérieures restent héritées et ne constituent pas des lectures sonores exécutées ici.

## Limites

- Original B226A0 factory,full sound reader B22AF0,source parser AFA240,source setters B02000/B01ED0 and base reader B00A50 execute under one fresh manager per sound. Owner argument is explicitly zero; historical dispatcher AF8170 and whole-bank order are not executed.
- Actual parent IDs/types are matched in the same bank, then factory initialized with B1D610(type5) or B24C20(type7). Optional bus IDs match original Init.bnk type8 records and use B02680. Parent/bus payloads and mixing are not loaded.
- Source state and cursor are verified against serialized bytes. Twenty plugin0x650002 zero-size parameter blocks take B01ED0,which stores source ID but sets file/plugin fields to FFFFFFFF; no plugin instance or generated audio is demonstrated.
- Full base reader execution does not individually qualify every FX/property/RTPC semantic. Existing-object reload diagnostic skips the base body after its FX block,as the original reader flag specifies.
- Pool allocation and logical frees are bounded transports; no ownership teardown or physical release claim. Source identity/length guard refusals are harness protections,not native malformed-input safety.
- No decoder,media mount,threaded mixer,historical bank precedence,EUW/en_GB voice selection or audible playback is qualified. V728 requests and V729 media graphs remain inherited.
- Current reference and ambient audio consumers remain to be linked precisely; the native reader result does not implement a complete current voice provider.
- Les 1 278 fiches audio de skins/voix et SYS sont enrichies sans changer les cases, notes, historiques, inconnues ou critères de fin.
- Le diagnostic nommé reader_property_allocation_refused dans la preuve brute concerne en réalité le vecteur d'enfants du parent. La trace supplémentaire démontre B00AF7/AE0C80/AE0A10/AFF610, retour 2 au curseur 31 ; le libellé corrigé est parent_child_vector_allocation_refused.
- Les 12 672 demandes de voix, leurs graphes et médias proviennent des reçus antérieurs ; ces demandes ne sont pas réexécutées ici.
- Les chemins de voix restent en_US ; leur sélection historique EUW/en_GB n'est pas qualifiée.
- Les consommateurs actuels identifiés restent des références, modèles et fonctions audio d'ambiance. Aucun fournisseur complet de voix n'est accepté.
- Preuves uniques et deltas ciblés compressés sur F ; aucune nouvelle copie complète des bases.

## Livrables

Le [reçu de liaison](fidelity_native_voice_sound_reader_links_v731.json) référence les preuves uniques sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision731_sound_loader/OBSERVATIONS.json, revision731_sound_dependencies/OBSERVATIONS.json, revision731_allocation_boundary/OBSERVATIONS.json et revision731_sound_associations/OBSERVATIONS.json.

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Documents de suivi : coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md, HANDOFF.md. Deux plan.sqlite3 mis à jour par deltas ciblés. Aucun code du jeu ou asset modifié.

Livraison : revision731_delivery/VERIFIED.json ; relecture indépendante réussie dans INDEPENDENT_READBACK.json. Le goal reste ouvert.
