# SYS-01.2-02 — Fabrique de ressources et chargement Standard, V684

UTC 2026-10-27T15:46:46.589803+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. V683 est classé comme progression : preuves publiées et consommateurs du cache vérifiés. Ce lot relie la fonction appelante réelle et réconcilie les recherches existantes ; il ne rejoue pas les exécutables natifs ni le Rust.

## Résultat intégré

La fiche **SYS-17.3-01 — Reproduire l’écran de chargement avec champion, skin et équipe** et le registre SYS-01.2-02 disposent désormais de sources précises pour la limite de chargement Standard. Le descripteur `OLC-6e68f4b7-37a4-57e1-a122-2a8986c845a1` désigne `crates/core/src/audio_replay_windows_loading_packets.rs:44`, méthode initialize_standard_record_owned. Aucun des5606descripteurs précédents ne visait ce fichier ; la source était déjà enregistrée et son empreinte actuelle est contrôlée.

Le code existant prépare le nom/skin, refuse l’absence du manager, appelle réellement audio_loading_resource_cache::resolve et conserve deux autres issues incomplètes : hit emprunté sans continuation UI ; miss sans fabrique90B520. Ce point est **entry_boundary_only**, provides_feature_consumer=false et executed_in_current_probe=false. Il ne s’agit ni d’une nouvelle implémentation de jeu ni d’un chargement accepté. La branche Tutorial et la création d’acteur étudiée en V683 restent distinctes.

## Réconciliation des preuves natives

| Profil | Preuve recontrôlée | Limite exacte |
|---|---|---|
| Anciennes sondes à mémoire hôte réelle, Ahri/skin0, environnements vide et contrôlé | 55 fichiers figés hachés ; deux traces et leurs générateurs relus | HeapReAlloc128→256 pendant attach RADS ; aucun retour INI ou fournisseur |
| Recherche ultérieure à tas virtuel et agencement géré reconstruit | Reçu et expérience31, producteurs et entrées rehashés | DLL attach retourne1 ;563membres de locale parcourus ; RadsInitialize retourne0x80004005, core1.7 non raccordé |
| Recherche d’archives reconstruite | Reçus de qualification, sources et journal revérifiés | 68hits/3misses d’index hérités ; données/ordre historique/montage/teardown complet non qualifiés |

Ces profils ne sont pas interchangeables. **L’ancien arrêt HeapReAlloc n’est pas présenté comme un blocage global de toutes les recherches RADS.** Le parcours à tas virtuel a progressé au-delà, avec ses propres adaptateurs. La provenance des lectures de ce parcours est explicite : flux Python en lecture seule et handles virtuels ; ce ne sont pas des appels Win32 ReadFile. Les anciennes formulations contradictoires restent conservées dans leurs lots ; le contexte courant renvoie aux corrections.

La fonction originale90B520 est redécodée jusqu’à son ret8 et huit ancres sont vérifiées dans le PE courant : répertoire90B4A0, construction9034D0, insertion90CEF0, publication90B651, lecture INI8B0630, récursion90AD00, parent par slot2C et visite90B270. La publication du cache **précède** le retour INI : un pointeur en cache ne suffit donc pas à prouver une initialisation complète. La qualification de la visite comme synchrone est conservée depuis le lot CRT ; aucun abonnement persistant n’est déduit.

## Vérifications réellement exécutées

- Audit en lecture seule des sources actuelles, des empreintes et des deux anciennes traces. Quatre altérations de preuves sont refusées : faux succès fournisseur, mauvaise taille de réallocation, faux attach DLL, retrait du refus de fabrique Rust.
- Réconciliation avec les recherches ultérieures et leur provenance. Les anciens300contrôles,563membres et68hits/3misses sont **hérités et recontrôlés documentairement**, pas réexécutés ici.
- Préparation, quatre refus de delta documentaire, inversion exacte des documents et de l’état logique SQLite, idempotence, publication et relecture des deux bases.
- **Aucune compilation Rust/Cargo, aucune nouvelle exécution native, aucun client graphique lancé.** Ces contrôles qualifient la traçabilité de SYS-01.2-02, pas le fonctionnement complet de SYS-17.3-01.

Attendu et observé : sources et consommateur identifiés avec leur portée réelle ; fausses promotions refusées ; anciennes preuves et données utilisateur conservées. Deux fiches mises à jour,42 605autres lignes identiques,42 607états manuels et23historiques inchangés. 11 sources de preuve ajoutées, deux liens natifs, un consommateur recensé et un lien de fiche ajouté. Graphe : 99457 sources et5607consommateurs ;26189inconnues ouvertes et5517résolues inchangées. Le graphe ne rehache pas toutes ses sources ; les identités de ce lot sont contrôlées séparément.

| Étape | Code réellement reçu | SHA256 du journal |
|---|---:|---|
| V684_BOUNDARY_AUDIT | 0 | 33caf230e080b51476d6c542389b9ef4d9549d19eef2fb6169223ed07a986569 |
| V684_RECONCILE | 0 | 83aa70566d66e87f1d0545c878d8cb9c6313b3da2db928e04746ba2779036cfe |
| V684_SNAPSHOT_LZX | 0 | dbe9056b1b4a5a9fd28492197e838660211bbb32a9c312fe28ccd634efe8172e |
| V684_PREPARE | 0 | c4e7ecf7b25ba64365918474912c2bd87dfeba2d600e95fbb1a7efc46003d98f |
| V684_CHECK | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V684_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V684_DELIVERY_AUDIT | 0 | 8d5798b47cce14fe50658331d7842e27aff838518b0401e6321393a17c7dc1d0 |

## Limites et écarts encore ouverts

kernel32.dll et ntdll.dll de SysWOW64 ont changé depuis les sondes figées du10octobre. Les empreintes attendues et observées sont conservées dans l’audit. Cela limite leur reproductibilité immédiate sur l’OS actuel ; aucune modification des DLL système n’a été faite. Ce constat ne transforme pas des ressources du jeu en assets manquants.

La composition de90B520 avec le contexte réellement choisi, FallbackPackage, les priorités, la continuation du chargement Standard et le teardown restent à qualifier. Les tests historiques d’Ahri ne valent pas pour les cinq champions V683, ni pour tous les skins. Les12noms de ressources non retrouvés dans les profils antérieurs restent ouverts. Le projet n’est pas déclaré complet et aucune case n’est cochée automatiquement.

EXE : SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. RiotRadsIO.dll : SHA256 `60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521`. Leurs chemins complets et tous les producteurs sont dans l’[audit](F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision684_provider_boundary_reconciliation\OBSERVATIONS.json). Le reçu publié est `docs/reference_requirement_trace_sources/provider-standard-boundary-v684.json` ; la vérification est `docs/fidelity_provider_standard_boundary_v684.json`.

Neuf anciens snapshots SQLite clos V683/V673/V672 sont compressés LZX sans suppression après contrôles d’accès exclusif et WAL absent/vide : gain alloué 2568953856octets, tailles logiques et SHA inchangés. Les bases actives ne sont pas compressées.

## Fichiers modifiés et suite

docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json ; les deux bases locales du plan ; le reçu, la vérification et ce rapport. Couverture et reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Les registres d’identités, phases et inconnues restent byte-exact. Aucun code moteur ni asset modifié.

Continuer SYS-01.2-02 sur F:/OpenLeague. V684 est une progression publiée de traçabilité : SYS-17.3-01 et SYS-01.2-02 reliées à la fabrique native et au véritable initialize_standard_record_owned. Le consommateur refuse manager absent, hit sans continuation UI et miss sans fabrique ; aucun de ces états ne termine le chargement. Ne pas refaire le cache V683 ni confondre ses acteurs avec la branche Standard. Avant de composer90B520 avec les contextes de ressources, inspecter F:/OpenLeague/tools/project-plan/original_rads_runtime_reference.py, original_filesystem_bootstrap_reference.py et la chaîne E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision24/recovered_manifest_reference.py. La recherche ultérieure à tas virtuel a déjà DLL attach=1,563membres de locale et RadsInitialize=0x80004005 avec core1.7 non raccordé ; les archives reconstruites ont68hits/3misses, flux Python et handles virtuels. Le profil ancien à mémoire hôte réelle reste arrêté à HeapReAlloc128→256, mais ce n’est pas un blocage universel. Choisir explicitement le profil de composition utile, conserver les adaptateurs et qualifier les éléments manquants sans remplacer un résultat de fournisseur. Les deux DLL système actuelles diffèrent des empreintes anciennes : ne pas réutiliser les feuilles OS comme preuves fraîches. Publication cache avant INI, parent/fallback, visite synchrone et destruction restent à confronter dans la chaîne. Conserver12noms non résolus, autres inconnues, critères et états. Aucune acceptation UI/GPU/audio/jeu ; goal actif.
