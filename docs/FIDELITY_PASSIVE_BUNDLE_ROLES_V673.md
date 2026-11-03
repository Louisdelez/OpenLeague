# SYS-01.2-02 — Identité et rôle des bundles de passifs Draven/Lux, V673

Date UTC : 2026-10-27T11:22:13.098356+00:00. Projet F:/OpenLeague. Référence native PUBLIC 4.20.0.315 EUW/en_GB ;catalogue 4.20.1 distinct. Le lot V672 précédent est une progression publiée et vérifiée.

## Résultat intégré

Les fiches **CH-Draven-PASSIF-PRESENTATION-AUDIO**, **CH-Lux-PASSIF-PRESENTATION-AUDIO** et **SYS-01.2-02** exposent les chemins natifs exacts, les identités des bundles et les limites de leur contenu. 42 liens sont ajoutés avec leurs rôles ;5 sources de preuve sont enregistrées. Les anciennes associations restent conservées.

**37 fichiers natifs** sont identifiés et comparés aux manifestes sélectionnés. Les noms déclarés par les personnages correspondent exactement au BuffName des chunks racines :DravenPassive et LuxIlluminationPassive. Cela qualifie leur identité statique, sans prouver le chargement historique effectif ou les callbacks serveur.

Les tables de préchargement complètes contiennent **9 requêtes :4 sorts et5 particules**. Les alternatives de même nom sont conservées ;aucune priorité de provider, de skin ou de banque n'est choisie arbitrairement.

### Draven

Déclaration et BuffName : **DravenPassive**. Chunk : `DATA\Characters\Draven\Spells\DravenPassive.luaobj`. Fonctions enfants : **0**.

| Requête native | Nom demandé | Fichiers candidats |
|---|---|---:|
| BBPreloadSpell | dravenpassivestacks | 2 |
| BBPreloadParticle | draven_recall_sound.troy | 0 |
| BBPreloadParticle | draven_recall_sound_reaper.troy | 0 |
| BBPreloadSpell | dravenrecalloverride | 1 |
| BBPreloadSpell | dravenspinningattack2 | 3 |
| BBPreloadSpell | dravenspinningattack2crit | 3 |
| BBPreloadParticle | draven_base_p.troy | 1 |
| BBPreloadParticle | draven_base_p_lesser.troy | 1 |

### Lux

Déclaration et BuffName : **LuxIlluminationPassive**. Chunk : `DATA\Spells\LuxIlluminationPassive.luaobj`. Fonctions enfants : **0**.

| Requête native | Nom demandé | Fichiers candidats |
|---|---|---:|
| BBPreloadParticle | luxpassive_tar.troy | 1 |

## Ce que ces sources prouvent et ce qu'elles ne prouvent pas

**Draven.** Le bundle est sous DATA/Characters/Draven/Spells. Une première recherche limitée à DATA/Spells ne l'avait pas trouvé ;la recherche dans le dossier du personnage l'a retrouvé. Cette erreur de chemin exploratoire ne devient pas une preuve de source manquante. Le preload charge aussi des sons de rappel et des variantes d'attaque. Le rattachement d'un fichier à cette liste n'en fait pas automatiquement un déclenchement du passif.

**Lux.** Le bundle déclaré LuxIlluminationPassive est sous DATA/Spells et précharge luxpassive_tar.troy. Le fichier **LuxIlluminatingFraulein** porte un autre BuffName ;il déclare AutoBuffActivateEffect=LuxDebuff.troy, une attache C_Buffbone_GLb_Head_Loc et un override SteelLegionLux. Ces métadonnées sont conservées comme celles d'un buff distinct. Elles ne prouvent ni alias avec le passif déclaré, ni sélection automatique de skin, ni rendu.

**Callbacks.** Les sept chunks clients lus en entier contiennent zéro fonction enfant. Leur initialisation fournit des métadonnées et termine sans instruction non prise en charge dans ce lot. Les valeurs PersistsThroughDeath, NonDispellable ou DoesntTriggerSpellCasts sont conservées, sans en déduire un algorithme de stacks, une récompense, des dégâts ou une chronologie de déclenchement. Aucun callback serveur original n'est récupéré ou exécuté.

## Contre-exemple communautaire conservé séparément

Les classes CharScriptDraven et CharScriptLux du dépôt communautaire inspecté sont vides. Une recherche littérale trouve toutefois **Play_sfx_Lux_LuxIlluminationPassive_hit dans Buffs/Ascension/AscBuff.cs**, dans OnActivate. Cet appel appartient au mode Ascension de cette implémentation communautaire.

La chaîne statique inspectée est AscBuff.OnActivate → ApiFunctionManager.PlaySound → PacketNotifier.NotifyS2C_PlaySound → S2C_PlaySound.WriteBody. Le notifier transmet le nom et OwnerNetID ;le writer communautaire écrit une chaîne fixe de1024octets puis l'identifiant propriétaire. Les fichiers, lignes et extraits exacts sont conservés. Aucun serveur, paquet ou réseau n'est exécuté ici ;ce code ne devient ni une source native Riot ni un consommateur Rust du passif de Lux. Il montre surtout que le nom d'un son ne prouve pas son usage exclusif.

## Consommateurs actuels et preuves héritées

La recherche littérale DravenPassive/LuxIlluminationPassive/LuxIlluminatingFraulein/DravenNewPassive dans les crates Rust n'a aucune correspondance. Ce périmètre n'exclut pas un traitement générique ou dynamique. Aucun nouveau consommateur fonctionnel n'est enregistré à partir de cette absence.

Les résultats V672 de hachage et de refus par le chemin ambiant restent **hérités** :les fichiers actuels utilisés par cette sonde sont rehachés et identiques. La sonde Rust n'est pas relancée dans V673. Les 32 chaînes audio candidates et les79IDs médias du lot précédent ne sont pas présentés comme de nouvelles conversions ou une écoute. Aucune exécution de Bevy ou du jeu complet.

## Vérifications effectivement exécutées

- Cas nominaux :les deux tables natives de preload sont consommées complètement par une grammaire bornée ;8entrées pour Draven et1pour Lux. Les déclarations, BuffName, fichiers et membres de release concordent.
- Six refus du lecteur de preload :table absente, fonction inconnue, nom dynamique, chemin au lieu d'un nom, deuxième table et appel supplémentaire.
- Deux refus du lecteur Lua :en-tête invalide et fichier tronqué.
- Au total :**10 contrôles source dont8refus**. Tous réussissent. Ce lecteur est un outil d'audit, pas une VM Lua historique ni un chargeur de jeu.
- Trois altérations du candidat de livraison sont refusées :acceptation automatique, retrait de consommateur et retrait de lien natif.
- Inversion documentaire exacte en octets ;inversion SQLite exacte au niveau logique. Lecteurs réels Store.task/copy_text/summary/trace exercés ;JSON copiable comparé structurellement et synchronisation idempotente.
- Publication relue dans les deux bases :3lignes ciblées,42604autres lignes,42607états manuels et23entrées d'historique conservés. Dépendances, critères, anciens contextes et registre des inconnues restent inchangés.

| Commande exécutée | Code | SHA-256 du journal |
|---|---:|---|
| V673_PASSIVE_BUNDLE_AUDIT | 0 | b695c912aceb98bcd70bd98913dc7459c26d649b7b10e34426654547061e819c |
| V673_PASSIVE_BUNDLE_PREPARE | 0 | f8a7540ff51f1b7bc0c1d4ee6ed95b3ce4450e5426596d64bc9e3c39c04571e8 |
| V673_PASSIVE_BUNDLE_CHECK | 0 | 1b960e64910e63b7179b0361cdcdd944ee18cb57bbb123c2417f98df7e04b8f2 |
| V673_PASSIVE_BUNDLE_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V673_PASSIVE_BUNDLE_DELIVERY_AUDIT | 0 | 20e1851594fc75c7e83170a74866a3dff845c71d0d432e151054a838a41e21b9 |

## Fichiers et preuves

- docs/completion_tasks_2026-10-20.json :contextes et instructions copiables enrichis.
- docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json :liens et preuves.
- docs/reference_requirement_trace_sources/passive-bundle-roles-v673.json :reçu des associations.
- docs/fidelity_passive_bundle_roles_v673.json :audit de livraison.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision673_passive_bundle_audit\OBSERVATIONS.json :observations natives, contrôles et recherches.
- docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md :couverture et reprise.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 :bases vérifiées.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision673_* :scripts exécutés, journaux, deltas réversibles et sauvegardes.

Aucun code ou asset de jeu modifié. Aucun champion, passif ou jeu complet accepté. Les conditions d'activation, le lien entre buffs, la sélection des ressources, les priorités, l'arrêt et l'écoute restent à qualifier. Les deux événements Skarner/Yasuo non retrouvés dans le scan SFX V672 et les inconnues antérieures restent ouverts.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V673 Draven/Lux AUDIO + SYS publié et audité :identités déclarées/BuffName vérifiées,37sources natives conformes,9requêtes preload,7chunks sans fonctions enfants. Les preloads Draven comprennent rappels et attaques ;LuxIlluminatingFraulein/LuxDebuff est un buff distinct. Classes communautaires Draven/Lux vides ;AscBuff joue le son Lux pour Ascension, pas le passif. Suite : qualifier les noms audio V672 sans événement dans594banques SFX (SkarnerSkin03 3639181578,YasuoSkin02 2473124821), en examinant les configurations de skin et le montage des banques, puis poursuivre les autres chaînes candidates sans réattribuer automatiquement les ressources partagées. Conserver les inconnues Malzahar, Voracity/KatarinaPassive et activation serveur. Les preuves V672 de la route ambiante sont héritées après revalidation des sources, non réexécutées V673. Aucune acceptation ni coche automatique. Publication :réserve de disque,temporaires compressés/blocs64Kio/SHA/remplacement atomique ;surveiller aussi l’espace C des copies SQLite. Goal actif.
