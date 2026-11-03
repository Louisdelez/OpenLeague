# SYS-01.2-02 — Matrice des bundles audio candidats restants, V675

Date UTC : 2026-10-27T12:00:24.245549+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ;catalogue officiel 4.20.1 distinct. V675 est une progression publiée et vérifiée.

## Résultat intégré

Douze fiches audio et SYS-01.2-02 reçoivent les identités natives, les tables complètes de préchargement et les limites des effets automatiques. **438 liens natifs** sont ajoutés et **5 sources de preuve** enregistrées. Les anciennes associations et décisions restent conservées ;aucun statut de tâche ou consommateur fonctionnel n'est promu.

Les **360 fichiers natifs** examinés comme sources liées correspondent aux manifestes sélectionnés. La matrice couvre les déclarations Passive1 à Passive5, les bundles du nom déclaré, les propriétaires des preloads candidats et le premier niveau des ressources qu'ils demandent. Elle n'exécute ni le graphe récursif des préchargements, ni le serveur original.

| Fiche | Identité du bundle déclaré | Preloads | Requêtes | Champs d'effet automatique |
|---|---|---:|---:|---:|
| Aatrox | Nom interne concordant | 2 | 5 | 0 |
| Braum | Nom interne concordant | 1 | 8 | 1 |
| Kalista | Nom interne concordant | 4 | 24 | 3 |
| Leblanc | Nom interne différent | 3 | 10 | 0 |
| Lulu | Nom interne concordant | 2 | 9 | 2 |
| Nami | Nom interne concordant | 0 | 0 | 0 |
| Quinn | Nom interne concordant | 3 | 24 | 2 |
| Rengar | Pas de Lua de ce nom dans DATA | 4 | 35 | 6 |
| Skarner | Nom interne concordant | 1 | 5 | 0 |
| Thresh | Nom interne concordant | 5 | 22 | 0 |
| Yasuo | Nom interne concordant | 2 | 8 | 0 |
| Zac | Nom interne concordant | 1 | 19 | 0 |

## Écarts et distinctions vérifiés

- **LeBlanc :** la déclaration est LeblancPassive, mais le chunk de ce nom initialise BuffName=LeblancNoxianCruelty. La différence est conservée ;ni alias effectif ni callback serveur ne sont déduits.
- **Rengar :** RengarPassive.inibin est présent. Aucun RengarPassive.luaobj de même nom n'est trouvé dans l'inventaire DATA ni parmi les membres correspondants des manifestes inspectés. RengarNewPassive possède ses propres fichiers et son propre BuffName ;il reste une alternative distincte, pas un remplacement automatique.
- **Icônes :** BraumMarkDamageTracker déclare Kennen_MarkOfStorm.dds, NamiPassive déclare Janna_Tailwind.dds et YasuoPassive déclare BlindMonkWOne.dds. Ce sont des métadonnées de buffs, différentes des icônes de personnage déclarées. Elles ne prouvent pas un partage de comportement entre champions.
- **Nami :** le bundle déclaré est disponible ;aucun preload ne fait partie des candidats retenus dans cette matrice. Cela ne prouve pas l'absence de tout préchargement dynamique ou de son passif.

## Préchargements lus complètement

Les **28 fichiers de preload contiennent169requêtes**. Le premier lecteur borné refusait la table ThreshPassiveSouls.preload parce qu'elle contient BBPreloadCharacter. Cette observation initiale est conservée. Une nouvelle version prend explicitement en charge les trois fonctions natives observées :BBPreloadSpell,BBPreloadParticle etBBPreloadCharacter. Les28tables sont alors lues sans erreur ni entrée abandonnée.

La requête de Thresh demande testcube et trouve DATA/Characters/TestCube/TestCube.inibin conforme au manifeste. Ce préchargement natif ne prouve pas la création de cet objet pendant une partie ni son rôle précis. Les sorts, particules et personnages demandés restent séparés.

**13 requêtes, portant sur12noms distincts, n'ont pas de candidat direct dans la recherche par nom de fichier :**

| Champion | Preload | Nom demandé |
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

Ces résultats restent des recherches bornées de noms .troy vers .troybin. Ils ne sont pas des preuves d'assets globalement manquants. Il faut encore qualifier aliases, anciennes dénominations, providers, overrides de skin ou références inutilisées. Aucun effet n'est reconstruit ni substitué dans ce lot.

## Métadonnées et effets automatiques

Les **94 chunks Lua clients** sont lus intégralement ;leurs initialisations récupérées ne s'arrêtent sur aucune instruction non prise en charge et les prototypes ne contiennent aucune fonction enfant. Cela ne fournit pas les callbacks serveur.

Quatorze champs AutoBuffActivateEffect sont conservés avec leurs attaches et métadonnées de skin. Deux occurrences aboutissent à un champ audio :AutoBuffActivateEffect et AutoBuffActivateEffect2 de **RengarQBuffBonusMAX** nomment Rengar_Base_Q_Buf_AttackSpeed.troy, dont SoundPersistent vaut **Play_sfx_Rengar_RengarQ_buffactivate**. C'est une ressource deQ rencontrée par les préchargements ;elle ne valide pas l'audio du passif. Les deux occurrences gardent leurs champs distincts, sans fusion des attaches ni lecture simultanée supposée.

## Source communautaire et code courant

Onze classes communautaires de personnage inspectées sont vides. **CharScriptKalista** est non vide :OnActivate enregistre des listeners d'attaque et de fin de déplacement ;le script contient des calculs de déplacement et des appels d'animation/mouvement. Il comporte aussi des TODO et des paramètres explicitement commentés comme spéculatifs. Ses lignes et son identité sont conservées ;il n'est ni exécuté ni promu en source serveur Riot ou en implémentation Rust acceptée.

La recherche littérale des noms déclarés, AutoBuffActivateEffect, PreLoadBuildingBlocks, BBPreloadParticle et BBPreloadSpell dans les crates Rust ne trouve aucune correspondance. Cette recherche n'exclut pas un traitement générique ou dynamique. Les preuves de la route ambiante V672 sont héritées après revalidation de leurs entrées actuelles ;la sonde Rust n'est pas réexécutée ici. Aucun client complet, audio audible ou rendu GPU n'est exécuté.

## Contrôles réellement exécutés

- Quatre contrôles nominaux :différence LeBlanc préservée ;INIBIN Rengar disponible malgré l'absence de Lua de même nom et alternative non substituée ;requête native de personnage conservée ;toutes les entrées des tables reconnues retenues.
- Six refus du lecteur de preload :table absente, fonction inconnue, nom dynamique, chemin au lieu d'un nom, deuxième table et appel ajouté.
- Deux refus du lecteur Lua :en-tête invalide et fichier tronqué. **12 contrôles source dont8refus**, tous réussis dans la version élargie.
- Trois altérations du candidat de livraison refusées :acceptation automatique,retrait de consommateur,retrait de lien natif.
- Inversion documentaire exacte en octets et inversion SQLite exacte au niveau logique ;lecteurs réels Store.task/copy_text/summary/trace exercés ;JSON copiable comparé structurellement et synchronisation idempotente.
- Relecture des deux bases :13lignes ciblées,42594autres lignes,42607états manuels et23entrées d'historique conservés. Critères,dépendances,anciens contextes et inconnues restent inchangés.

| Commande exécutée | Code | SHA-256 du journal |
|---|---:|---|
| V675_BUNDLE_MATRIX_AUDIT | 0 | 77a3d8ac78b6f53d8b515ea272105f5be39e00649135dc32427d444613f8e6e9 |
| V675_BUNDLE_MATRIX_EXPANDED | 0 | 1347ee643a69dd5578d69c143ca74feaf717f155ec3e4cd8651d219b1c34d9b5 |
| V675_BUNDLE_MATRIX_PREPARE | 0 | a9ed1dacf10e720421b42570965b2d8555f82daed2f5cb965ed62da07400b988 |
| V675_BUNDLE_MATRIX_CHECK | 0 | 7e1e97a0605d63d69d281d67ce66dd6362eb3a1134530654784697a095c75e57 |
| V675_BUNDLE_MATRIX_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V675_BUNDLE_MATRIX_DELIVERY_AUDIT | 0 | 7b7d5a44b3753e342dbe948029a756d83b277b611d0de0f0b2622efecb0d8732 |

## Fichiers et preuves

- docs/completion_tasks_2026-10-20.json :contextes et instructions des treize fiches.
- docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json :liens et preuves.
- docs/reference_requirement_trace_sources/remaining-audio-bundle-matrix-v675.json :associations.
- docs/fidelity_remaining_audio_bundle_matrix_v675.json :audit de publication.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision675_bundle_matrix_audit_expanded\OBSERVATIONS.json :observation élargie avec tables, métadonnées, sources et limites.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision675_bundle_matrix_audit/OBSERVATIONS.json :premier résultat, avec refus de la table Thresh, conservé.
- docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md :couverture et reprise.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 :bases vérifiées.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision675_* :scripts,journaux,deltas et sauvegardes.

Aucun code ou asset de jeu modifié. Aucun callback serveur original récupéré, aucune priorité de skin ou de banque acceptée, aucun passif ou jeu complet validé. Les écarts V674 et les inconnues antérieures restent ouverts.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V675 publié/audité :12fiches audio + SYS,360sources natives,28preloads/169requêtes,94chunks sans fonctions enfants. Dix BuffName concordent ;LeBlanc déclareLeblancPassive mais le chunk nommeLeblancNoxianCruelty ;RengarPassive a un INIBIN mais pas de Lua correspondant dans DATA,et RengarNewPassive reste distinct. Suite :qualifier les13requêtes de particules sans candidat direct (12noms) recensées dans V675 pour Braum,Kalista,Lulu,Rengar,Zac :comparer aux manifestes,aux noms/aliases et aux overrides de skin avant toute conclusion d’absence ou reconstruction. Le préchargementTestCube de Thresh est lu et présent. Les effets AutoBuff de RengarQBuffBonusMAX portent un sonQ,non promu en passif. Kalista communautaire contient logique de déplacement,TODO et paramètres spéculatifs ;ne pas l’accepter comme serveur natif. Conserver les références Skarner/Yasuo V674 non satisfaites malgré970banques présentes,les inconnues Malzahar/Voracity et les métadonnées partagées. Aucun consommateur de gameplay ajouté ;activation,priorités et écoute ouvertes. Préserver cases/notes/historiques ;réserve disque et écriture atomique des gros JSON. Goal actif.
