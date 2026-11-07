# SYS-01.2-02 — Références de préchargement non résolues, V676

Date UTC : 2026-10-27T12:19:00.663453+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue officiel 4.20.1 distinct. Le lot précédent V675 a modifié le registre et les deux bases ; il est classé comme progression.

## Résultat

Les **12 noms exacts de 13 demandes** ne correspondent à aucun fichier dans les deux manifestes RADS sélectionnés ni parmi les **70 899 fichiers inventoriés dans le deploy fourni**. Ce constat précise une absence dans ce périmètre ; il ne prouve ni qu'un fichier a été perdu lors de l'extraction, ni qu'une ressource doit être reconstruite.

La recherche insensible à la casse dans les formats de métadonnées `.preload`, `.luaobj`, `.inibin`, `.troybin`, `.ini`, `.cfg`, `.txt`, `.json` et `.xml` retrouve ces chaînes dans **huit fichiers de préchargement seulement**, sans erreur de lecture des fichiers trouvés. Les sous-chaînes sont conservées comme telles : le nom Zac sans suffixe OT apparaît aussi au début du nom avec OT. Il ne s'agit pas de deux preuves de redirection.

**99 sources natives** sont vérifiées par taille/MD5 contre les manifestes et par SHA-256. **77 particules aux noms proches** et **14 configurations de personnage/skin** sont décrites sans les sélectionner comme remplacements. Les cinq fiches de champions et SYS-01.2-02 reçoivent **107 liens natifs** et **3 nouvelles sources de preuve**. Aucun consommateur fonctionnel ni état d'acceptation n'est ajouté.

| Champion | Demandes | Particules aux noms proches | Configurations lues |
|---|---:|---:|---:|
| Braum | 3 | 2 | 3 |
| Kalista | 4 | 64 | 3 |
| Lulu | 1 | 2 | 1 |
| Rengar | 3 | 7 | 4 |
| Zac | 2 | 2 | 3 |

## Demandes exactes conservées

| Champion | Préchargement | Nom demandé |
|---|---|---|
| Braum | BraumMark.preload | braum_mark_onestack_sound_tar.troy |
| Braum | BraumMark.preload | braum_base_p_stun_cas.troy |
| Braum | BraumMark.preload | braum_base_p_stun_mis.troy |
| Kalista | KalistaPassiveBuff.preload | kalista_base_e_lethal.troy |
| Kalista | KalistaPassiveBuff.preload | kalista_base_e_tar_lethal.troy |
| Kalista | KalistaPChannel.preload | kalista_base_p_spear_click.troy |
| Kalista | KalistaPChannel.preload | kalista_base_p_ally_click.troy |
| Lulu | LuluPassive.preload | waenasignalnovareverse.troy |
| Rengar | RengarNewPassiveBuffDash.preload | temprengarqhit.troy |
| Rengar | RengarPassiveBuffDash.preload | rengar_leapend.troy |
| Rengar | RengarPassiveBuffDashAADummy.preload | rengar_leapend.troy |
| Zac | ZacWGooMove.preload | zac_skn1_w_chunk_splat.troy |
| Zac | ZacWGooMove.preload | zac_skn1_w_chunk_splat_ot.troy |

## Candidats et limites

- **Braum :** Braum_Base_P_Stun_tar et sa variante Skin01 existent. Ils ne portent pas les suffixes cas ou mis demandés. Aucune équivalence n'est déduite.
- **Kalista :** Temp_Kalista_E_tar_Lethal et des particules Spear/Channel existent. Ni leurs noms ni leurs champs ne démontrent qu'ils remplacent les références lethal/click absentes. Le filtre lexical conserve également des effets d'attaques, de E et de cérémonie ; il ne leur attribue pas la propriété du passif.
- **Lulu :** LuluSignalNova et LuluSignalNovaReverse existent ; WaenaSignalNovaReverse reste distinct. La configuration racine Lulu.inibin contient les noms de ressources et variantes historiques. L'absence de dossier Skins moderne n'est pas présentée comme une absence de skins.
- **Rengar :** des particules Leap_Grass, Leap_Dust et LeapSound sont disponibles, sans correspondance démontrée avec LeapEnd ou TempRengarQHit.
- **Zac :** les deux effets Chunk_Splat de base existent ; les noms demandés contiennent skn1. Les fichiers Base/Skin01 et leurs chaînes Zac/ZacGrumpy sont conservés sans suppression de ce préfixe ni repli automatique vers la base.

La lecture des configurations conserve les chaînes et leurs hachages ; elle ne démontre pas le montage, la priorité d'une variante ou l'exécution d'un effet. Les fichiers binaires audio, textures, maillages et toutes les archives historiques ne font pas partie de la recherche de chaînes de métadonnées.

## Consommateur courant

La recherche littérale des douze noms dans les crates Rust retourne le code 1, sans correspondance. Cela n'exclut pas les consommateurs génériques. Un consommateur pertinent existe : `crates/core/src/native_effect_resource_skin_alias.rs`, fonction `resolve`, documentée avec l'adresse native 7522B0. Il reçoit la disponibilité des ressources par un callback. Son examen statique repère la substitution de `_Base` par `_SkinNN`, ou une insertion avant `.troy`, et la conservation du nom initial si le candidat est indisponible.

Ce module et son contrat doivent maintenant être exercés sur les demandes réelles ; ils ne sont pas exécutés par V676. L'identité du module et la recherche de ses références sont conservées dans le point de reprise privé. Aucune preuve ancienne de ses tests n'est présentée comme fraîchement rejouée.

## Vérifications : attendu et observé

| Contrôle | Attendu | Observé |
|---|---|---|
| Comparaison exacte nom/manifeste/deploy | Conserver les correspondances et absences sans inventer d'alias | Zéro correspondance exacte pour les 12 noms ; inventaire de 70 899 fichiers |
| Contrôle positif Zac de base | Trouver un nom natif connu dans les deux recherches | Zac_W_Chunk_Splat présent dans le manifeste et le deploy |
| Casse | Comparer les noms ASCII sans modifier leur contenu | Variante `.TROY` reconnue ; nom conservé en minuscules pour comparaison |
| Ressources proches | Ne pas accepter un alias lexical | 77 candidats, tous avec alias_qualified=false |
| Entrées hors contrat | Refuser chemin, absolu, expression, mauvaise extension, NUL et non-ASCII | Six refus sur six |
| Lectures de métadonnées trouvées | Conserver champs, lignes et offsets ou signaler erreur | Huit fichiers lus, zéro erreur |
| Candidat documentaire altéré | Refuser acceptation automatique, retrait de consommateur et retrait de lien | Trois altérations refusées |
| Réversibilité et copie | Reconstruction documentaire exacte, inversion logique SQLite, instructions identiques | Contrôles réussis et synchronisation idempotente |
| Bases réelles | Modifier uniquement les six tâches ciblées | 42 601 autres lignes, 42 607 états manuels et 23 historiques conservés dans chaque base |

Les contrôles source comprennent trois cas nominaux et six refus. Le code de jeu, le rendu GPU, l'audio et le serveur historique ne sont pas exécutés.

## Exécutions et incident conservé

Le premier essai a quitté avec le code 1 sur `KeyError: own_questions_preserved` en assemblant le rapport, avant toute intégration documentaire. Il demandait un champ absent de l'observation précédente. Son script et son journal restent conservés : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision669_V676_PRELOAD_REFERENCE_AUDIT.log`, SHA-256 `2489e6256dbde6d8e636d0909d72c137534b15cfb78fc2e3f32174ff3e96ccf3`. Une nouvelle version retire cette dépendance inutile ; les exigences et inconnues viennent toujours des registres courants lors de la préparation. Un passage supplémentaire ajoute les configurations racines, notamment celle de Lulu.

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| V676_PRELOAD_REFERENCE_QUALIFIED | 0 | 07436dbe9247181cef10ef079c5550fb04a8941b854686866a47aca0ddbd66a6 |
| V676_PRELOAD_REFERENCE_LEGACY | 0 | 35057ddcef6a0332508cb33e1293f4444d1c773e73a0d6bf7460e445bdcc2cf4 |
| V676_PRELOAD_REFERENCE_PREPARE | 0 | 9945aba31f4f7a57a217f63dac5061e53f85c25d06f061645207b3aaeecc3681 |
| V676_PRELOAD_REFERENCE_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V676_PRELOAD_REFERENCE_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V676_PRELOAD_REFERENCE_DELIVERY_AUDIT | 0 | 959fe409b7925de973fd1fa6c7a554bb2fc65a025e51b8ff170af595cdb433c0 |

## Fichiers modifiés et preuves

- docs/completion_tasks_2026-10-20.json : contextes et instructions des six tâches.
- docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json : associations et preuves.
- docs/reference_requirement_trace_sources/unresolved-preload-names-v676.json : liens détaillés.
- docs/fidelity_unresolved_preload_names_v676.json : vérification après publication.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision676_preload_reference_audit_with_legacy\OBSERVATIONS.json : noms, sources, champs, résultats et limites.
- docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md : couverture et reprise.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 : bases relues avec les lecteurs réels.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision676_* : scripts, essais successifs, sauvegardes et journaux.

Les inconnues, critères, dépendances et contextes antérieurs sont préservés. Aucun code ni asset de jeu n'est modifié. Aucun champion, passif ou jeu complet n'est déclaré terminé.

## Prochaine action

Continuer SYS-01.2-02 sur F:/OpenLeague. V676 publié et vérifié : les 12 noms de 13 demandes sont absents des deux manifestes sélectionnés et des 70 899 fichiers du deploy ; huit preloads les citent, sans autre référence littérale dans les formats inspectés. 77 particules proches restent des candidats lexicaux, 14 configurations dont les racines historiques sont conservées. Suite concrète : examiner et exercer le consommateur existant crates/core/src/native_effect_resource_skin_alias.rs (resolve, référence native 7522B0), ses appels et son contrat data/4.20/effect_resource_skin_alias_contract.json sur ces demandes et les skins officiels. Il transforme _Base en _SkinNN ou insère un suffixe avant .troy selon disponibilité ; vérifier ses résultats exacts sans promouvoir le callback de disponibilité adapté en montage natif réel. Ne pas refaire un inventaire de noms déjà qualifié. Conserver les références non résolues tant que redirection, utilisation et nécessité ne sont pas prouvées ; aucune reconstruction automatique. Garder les écarts V674, LeBlanc/Rengar, Malzahar/Voracity et les comportements serveur ouverts. Préserver les cases, notes et historiques. Goal actif.
