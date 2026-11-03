# SYS-01.2-02 — Sources audio candidates, V672

Date UTC : 2026-10-27T11:01:16.838532+00:00. Référence PUBLIC 4.20.0.315 EUW/en_GB ;catalogue 4.20.1 distinct. Projet F:/OpenLeague. Le lot précédent V671 est une progression vérifiée, pas un blocage.

## Résultat intégré

Les instructions copiables de **15 fiches audio de champions et SYS-01.2-02** exposent maintenant les chaînes candidates entre déclarations, particules, préchargements, événements et médias. Le registre, le graphe de traçabilité et les deux bases du plan sont réconciliés. 153 liens natifs sont ajoutés et 6 sources sont enregistrées. Aucun consommateur de gameplay n'est ajouté ni accepté.

La découverte V671 est relue et confrontée aux fichiers actuels : **74 particules, 78 champs audio et 34 noms distincts**. Les 594 banques SFX sont indexées. **32 noms correspondent à un événement dans 19 banques** ;79 identifiants médias candidats sont trouvés dans des plages DIDX existantes. Aucun nœud ou média de ces 32 chaînes n'est sans candidat dans le périmètre inspecté. Cette disponibilité ne prouve pas la sélection effective ni la lecture.

Les 153 sources natives retenues comme liens correspondent aux manifestes sélectionnés. Le parseur wwiser traite séparément chaque banque concernée, sans erreur ni saut signalé. Ses événements/actions sont comparés au lecteur binaire borné ;14 989 champs d'identifiants sont recoupés avec les octets natifs. Le graphe complet conserve les conditions, conteneurs, actions et autres champs ;leur sémantique n'est pas exécutée.

## Affectations à confirmer, sans confusion de périmètre

Le préfixe du nom audio détermine uniquement la fiche où examiner la piste. Il ne prouve ni identité du passif, ni nécessité de l'effet, ni déclenchement serveur. La colonne des preloads compte les fichiers ayant une référence explicite parmi les 3 016 fichiers inspectés, avec la syntaxe BBPreloadParticle/Name reconnue. Les appels dynamiques, alias ou autres grammaires ne sont pas exclus par une absence de correspondance.

| Fiche | Déclaration native Passive1LuaName | Particules | Noms audio | Preloads candidats | Noms sans événement SFX |
|---|---|---:|---:|---:|---|
| Aatrox | AatroxPassive | 12 | 1 | 1 | aucun dans ce scan |
| Braum | BraumMarkDamageTracker | 2 | 2 | 1 | aucun dans ce scan |
| Draven | DravenPassive | 8 | 1 | 1 | aucun dans ce scan |
| Kalista | KalistaPassiveBuff | 2 | 2 | 3 | aucun dans ce scan |
| Katarina | Voracity | 1 | 1 | 1 | aucun dans ce scan |
| Leblanc | LeblancPassive | 8 | 4 | 2 | aucun dans ce scan |
| Lulu | LuluPassive | 1 | 1 | 1 | aucun dans ce scan |
| Lux | LuxIlluminationPassive | 2 | 1 | 4 | aucun dans ce scan |
| Nami | NamiPassive | 3 | 1 | 0 | aucun dans ce scan |
| Quinn | QuinnPassive | 14 | 4 | 2 | aucun dans ce scan |
| Rengar | RengarPassive | 3 | 1 | 3 | aucun dans ce scan |
| Skarner | SkarnerPassive | 7 | 6 | 1 | Play_sfx_SkarnerSkin03_SkarnerPassiveBuffMinion_buffactivate |
| Thresh | ThreshPassiveSouls | 5 | 4 | 4 | aucun dans ce scan |
| Yasuo | YasuoPassive | 3 | 2 | 1 | Play_sfx_YasuoSkin02_YasuoPassiveMSShieldOn_buffdeactivate |
| Zac | ZacPassiveChunkDrop | 3 | 3 | 1 | aucun dans ce scan |

Exemples qui empêchent une attribution automatique :

- **LuxPassive_tar** est préchargé par LuxIlluminationPassive, mais aussi LuxMaliceCannonMis, SkarnerFractureMissile et NightmareBotLuxRCannonMis. Une ressource partagée ne valide pas tous ces comportements.
- **Thresh_SpinningScythe_Passive** est référencé par ThreshQPassive3 et ThreshQPassive4 ;il ne faut pas le fusionner sans preuve avec le passif des âmes.
- QuinnWPassiveReady et ZacWGooMove conservent leurs noms historiques. Le mot Passive ou la lettre W ne remplace pas l'analyse du véritable appel et de ses conditions.
- Nami possède des champs audio et un événement disponibles, mais aucun preload reconnu dans ce scan pour les trois particules candidates. Cela ne signifie pas que ces ressources sont absentes ou inutilisées.
- DravenPassive et LuxIlluminationPassive offrent des preloads homonymes à leur déclaration ;c'est une piste plus directe, pas encore une preuve d'exécution serveur.

## Deux recherches encore ouvertes

Les noms suivants sont inscrits dans des particules natives conformes au manifeste mais aucun événement de même identifiant n'a été trouvé dans les **594 banques SFX examinées** :

- Play_sfx_SkarnerSkin03_SkarnerPassiveBuffMinion_buffactivate : **3639181578**.
- Play_sfx_YasuoSkin02_YasuoPassiveMSShieldOn_buffdeactivate : **2473124821**.

Les autres événements de ces champions ne sont pas substitués. Il reste à examiner les contextes de skin, montages, alias, génération et éventuelles banques hors du périmètre SFX. Ce constat ne démontre pas un asset définitivement manquant et ne justifie pas une reconstruction. Les inconnues antérieures Malzahar et l'alias Voracity/KatarinaPassive sont conservés. Les nouveaux écarts sont explicités dans les contextes des fiches sans fermer ni réécrire le registre des inconnues.

## Consommateur actuel et contrôles exécutés

La fonction event_id de crates/core/src/audio_release.rs et le préfiltre/match de crates/client/src/map_audio_requests.rs sont extraits du code actuel et compilés dans une sonde Rust. Les chemins include_str sont relocalisés en gardant leurs octets ;Cue et le retour de texte sont des adaptateurs explicites. Le parseur JSON, Bevy, le client complet et le matériel audio ne sont pas exécutés.

- 34 hachages correspondent aux identifiants utilisés pour rechercher les banques.
- Le lookup refuse les 74 noms de particules avec unqualified ambient particle.
- Le préfiltre Audio-Emitter_ exclut les 74 particules.
- Le lookup ambiant nominal et quatre contrôles de limites sont exercés :non-ASCII, NUL et259caractères refusés ;258acceptés.
- Le lecteur de banques refuse une entrée vide, un en-tête tronqué et un corps tronqué.
- Une recherche littérale des noms de particules/événements dans les crates Rust ne trouve aucune correspondance. Ce résultat ne prouve pas l'absence de tout routage dynamique.

Build et exécution de la sonde :codes0. Son binaire, son code, le compilateur, les fichiers inclus et les journaux sont identifiés dans l'observation. Aucune nouvelle conversion audio, écoute ou exécution du jeu n'a eu lieu. Le script d'audit émet un avertissement Python concernant un échappement de regex ;les contrôles terminent avec le code0. Le script exécuté et son journal restent inchangés pour préserver la preuve.

## Publication et conservation

Le contrôle sur copie refuse trois altérations :acceptation automatique d'une case, suppression d'un consommateur et retrait d'un lien natif. L'inversion documentaire reconstitue les octets initiaux ;l'inversion SQLite reconstitue l'état logique initial. Les véritables lecteurs Store.task, copy_text, summary et trace sont exercés ;les JSON copiables sont décodés structurellement et comparés. La synchronisation normale est idempotente.

Les deux bases contiennent chacune16lignes enrichies ;les 42591 autres lignes,42607états manuels et23entrées historiques sont conservés. Critères, dépendances, anciens contextes et preuves restent inchangés. Les gros documents sont écrits par blocs64Kio dans des temporaires compressés, vérifiés par SHA puis remplacés atomiquement après vérification de l'espace disponible.

| Commande exécutée | Code | SHA-256 du journal |
|---|---:|---|
| V672_NAMED_AUDIO_AUDIT | 0 | e398c9dd47009172a22e6f2b12df2bcfc892a0e170b92b2afb336cdd4c93fb84 |
| V672_NAMED_AUDIO_PREPARE | 0 | dc9b1b647c01039efa18e6354bef45a7c2c4779bf3bfa3414804cde30d0d9666 |
| V672_NAMED_AUDIO_CHECK | 0 | defdeea1208db8b72e7ec371b59701536cf9190cd98ff5244e32549212897936 |
| V672_NAMED_AUDIO_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V672_NAMED_AUDIO_DELIVERY_AUDIT | 0 | 8bde9912ba63103cd245733840ab4b131b3f1e41bfc1f570e97eb48d7b7adb53 |

## Fichiers et preuves

- Registre : docs/completion_tasks_2026-10-20.json.
- Traçabilité : docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json.
- Reçu : docs/reference_requirement_trace_sources/named-particle-audio-chains-v672.json.
- Vérification de livraison : docs/fidelity_named_particle_audio_chains_v672.json.
- Observation native/current-code : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision672_named_audio_audit\OBSERVATIONS.json.
- Graphes de banques : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision672_named_audio_audit\BANK_GRAPHS.json.gz.
- Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.
- Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3.
- Scripts et deltas privés : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision672_*.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V672 publié/audité :15fiches audio + SYS,74particules et34noms examinés ;32événements reliés à19banques,79IDs médias candidats. Qualifier les associations sémantiques à partir des déclarations/preloads :DravenPassive et LuxIlluminationPassive possèdent des preloads homonymes ;prouver leurs callbacks/alias avant de qualifier les événements du passif. Ne pas attribuer automatiquement les WPassive/BasicAttackPassive, ThreshQPassive3/4, NightmareBot ou les références croisées Lux/Skarner au passif. Deux IDs événementiels sans correspondance dans594banques SFX :3639181578 SkarnerSkin03_SkarnerPassiveBuffMinion et2473124821 YasuoSkin02_YasuoPassiveMSShieldOn. Examiner leur montage/skin/aliases sans inventer un média ou conclure à une absence globale. Le chemin map_audio_requests ignore/refuse les74particules ;pas de consommateur gameplay ajouté. Conserver les inconnues V670 Malzahar, priorités et V671 Voracity/KatarinaPassive. Pour publier les gros documents, réserve globale/per-document, blocs64Kio, SHA et remplacement atomique. Cases/notes/historiques conservés. Goal actif.
