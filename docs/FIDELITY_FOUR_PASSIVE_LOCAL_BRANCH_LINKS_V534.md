# SYS-01.2-02 — Quatre contrats locaux de passifs, V534

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## Résultat intégré

Les fiches **CH-Annie/Ezreal/Garen/Trundle-PASSIF-SIMULATION-CONTRAT** exposent maintenant **24 branches de leurs politiques locales actuelles**, avec fonctions, gardes, points d'appel, sources et résultats CPU. **12 arêtes natives**, **38 liens de composants partiels**, **un contexte Garen** et **30 nouveaux points de code** sont ajoutés. Deux anciens documents de contexte, un exécutable de tests, son dep-info et trois preuves sont inscrits, soit sept sources nouvelles.

Les quatre questions propres et les quatre questions SOURCE restent distinctes et ouvertes chez leurs propriétaires. **Aucune question créée ou fermée**, aucune acceptation/statut/critère/dépendance, coche, note ou historique utilisateur modifié. Les quatre tâches restent a_faire avec implementation_complete=false et acceptance_complete=false. Leurs parents et les **118 autres contrats** sont identiques. Ces quatre politiques ont été choisies parce que leur code spécialisé a été identifié ; les autres ne sont pas déclarées absentes depuis une recherche lexicale.

## Exécution actuelle vérifiée

Un **nouveau dossier de compilation sur F:** est créé sous revision534_passive_runtime/cargo-target. Depuis le vrai dépôt, la commande exécutée est :

```text
cargo test --locked --offline -p openleague-core --lib passive --message-format=json -- --nocapture
```

L'exécutable Cargo et rustc du toolchain stable Windows/MSVC sont identifiés avec leurs versions et empreintes. Le build utilise le Cargo.lock courant ; aucun téléchargement. Le manifeste, les sources, le C du build script et les ressources littérales sont identifiés avant l'appel. Les objets du compilateur sont reçus depuis le flux Cargo ; l'exécutable de tests et son dep-info proviennent de ce nouveau dossier.

**37 tests réussis, zéro échec, zéro ignoré ;1 890 tests filtrés.** Les résultats propres aux quatre modules sont :

| Module de passif | Tests réussis |
| --- | ---: |
| Annie | 6 |
| Ezreal | 8 |
| Garen | 4 |
| Trundle | 9 |
| Total des quatre modules | 27 |
| Autres tests trouvés par le filtre passive | 10 |

Les dix autres résultats ne sont pas attribués arbitrairement à ces quatre passifs. Les noms exacts et résultats sont conservés dans EXECUTION.json. Les avertissements de compilation restent dans le journal, sans correction étrangère au périmètre.

Binaire : **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision534_passive_runtime\cargo-target\debug\deps\openleague_core-21eb81eb13817108.exe**, **787789824 octets**, SHA-256 **8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97**. Les **1 158 entrées** initiales sont exactes après compilation/exécution ; le dep-info identifie **1 147 dépendances directes** du core. Le parseur existant est réutilisé pour cette liste, sans lui attribuer une fermeture complète des dépendances dynamiques ou de la chaîne d'outils.

Il s'agit du **binaire de tests du core en configuration test**, avec fixtures de politique locale. Aucune instrumentation ne démontre l'exécution de chaque ligne, chaque garde ou chaque appel repéré. Aucun client/serveur livré, partie multiclient, natif historique, VM Lua ou GPU exécuté. Les autres tests du workspace ne sont pas qualifiés par ce filtre. Aucun code ou asset du jeu n'est modifié ; les sorties du build sont privées sur F:.

## Branches et lecteurs réels

**Annie — cinq branches décrites, neuf liens partiels.** Garde d'identité/vie, incrément plafonné à quatre charges ou consommation offensive, durées locales par niveaux1/6/11 et conversion ceil en ticks, refus de livraison sur durée nulle/cible morte et ordre local Q/E/W/R. Les appels Q acceptés passent après apply_damage ; une cible tuée peut consommer la charge avant que la livraison du stun soit refusée. E augmente sans consommer un stun offensif préparé ; W/R préparent une durée commune lors de leur libération. Les immunités, boucliers de sorts et l'ordre historique complet restent inconnus.

**Ezreal — neuf branches décrites, dix-neuf liens partiels.** Nettoyage après fin/session/retour de l'horloge, rétention des seuls propriétaires vivants valides, contact consommé par l'appelant, gardes de session/équipe, overflow et budget de propriétaires, saturation à cinq avec rafraîchissement partagé180ticks, getter non mutateur, bonus additif et projection privée. Les appels Q/W/E/R, resets, prune, départ, réapparition, fin de partie, stats et snapshot sont identifiés. Les tests locaux couvrent notamment contacts acceptés/rejetés, W allié/soi, expiration à la borne, cadence future et nettoyage. Les gardes d'overflow/budget et toutes les branches ne sont pas annoncées entièrement testées. Les choix d'ancienne vie et d'ordre restent des politiques locales.

**Garen — cinq branches décrites, six liens partiels et un contexte.** Table actuelle des niveaux1/11/16 et délais9/6/4secondes, fractions0.004/0.008/0.02 de la santé maximale par seconde, garde de propriétaire/vie/fin, borne exacte de cooldown, interruptions et événement ennemi sans dégâts. Les unités de lane et les unités alliées sont exclues ; Kind::Monster est ignoré à partir du niveau11, Kind::Boss étant distinct. L'ajout à la régénération, les dégâts et l'appel d'Exhaust sont repérés. La filiation des coefficients via notes4.17/tooltip est héritée ; les détails natifs de boucliers, environnement et ticks restent non qualifiés. Le descripteur de l'include de table reste **false/entry_boundary_only**.

**Trundle — cinq branches décrites, quatre liens partiels.** Table communautaire explicite2/3/4/5/6pourcent, réception de morts, validation de victime, filtres de Trundles vivants ennemis/position/rayon et soin commun. Les deux appels réels sont la mort de champion avant récompense/XP et la transition d'unité finie positive vers morte dans world.rs. Le maximum de santé de la victime est utilisé, sans condition de dernier coup. La formule native f2, les variantes communautaires contradictoires, expirations naturelles, illusions et ordre natif restent ouverts.

Les 23 points d'appel externes sont reliés aux lignes exactes ; les listes et extraits sont dans le reçu. Un appel source est une preuve de structure actuelle, pas une couverture instrumentée de tous ses chemins. Les anciens descripteurs réutilisés restent exacts, avec leur portée d'origine.

## Provenance et questions conservées

Les douze entrées de définitions/métadonnées natives sont recontrôlées sur les manifestes sélectionnés. Elles établissent identité et métadonnées client dans leur portée ; elles ne deviennent pas les callbacks du serveur d'origine. Les textes auxiliaires divergents, les candidats de buff et les choix locaux restent séparés des règles natives.

Les valeurs absentes et exceptions inconnues ne sont pas remplacées par des fixtures. Les tests de politique locale utilisent leurs propres scénarios et ne prouvent pas la disponibilité d'un serveur natif ou d'une ressource manquante. Les questions des dépendances SOURCE sont visibles chez leur vrai propriétaire, sans adoption ni fermeture par les contrats. Les parents conservent leurs huit dépendances et leurs questions.

## Vérifications de publication

Préparation, contrôle privé, publication et audit séparé terminés avec **code0**. **36 faux constats d'association** sont refusés : mauvais propriétaire/lecteur, callbacks ou branches natives inventés, couverture de ligne inventée, table communautaire promue en formule native, acceptation des parents/118autres contrats, adoption des questions SOURCE, identité binaire modifiée, branche retirée, frontière Garen promue et question supprimée. **Quatre refus publics** vérifient identifiants source/consommateur absents, acceptation inventée et inconnue de Veigar étrangère.

**Quatre extraits changent,42 211 autres extraits restent exacts ;42 210 autres objets tâche/trace sont identiques.** IDs, hiérarchie et fichier des inconnues sont exacts en octets. Tous les anciens objets source/consommateur et leurs portées restent identiques.

Dans chaque base : **cinq destinataires**, **42 602 autres lignes catalogue exactes**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie, résumé, résolution, dépendance SOURCE, propriétaires des questions, intégrité SQLite et synchronisation normale idempotente sont vérifiés.

Réexamen global frais : **42 215 exigences**, **98 811 sources**, **2 749 CID**, **527 fichiers de consommateurs**, toutes ancres et identités exactes, zéro divergence. **26 186 questions ouvertes**, **5 517 résolues**, **17 auxiliaires conservés**. Les **8 374 fiches CH** au seul chargeur partagé restent une file à examiner, pas une preuve d'absence ou un pourcentage de jeu terminé. Aucun nouveau hash physique global des98 811sources revendiqué.

## Fichiers et preuves

- Modifiés : docs/completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json ; cinq lignes de données/consignes dans chacune des deux bases du plan. Inconnues, IDs, hiérarchie et données manuelles conservés.
- Reçu : docs/reference_requirement_trace_sources/four-passive-local-branch-links-v534.json ; preuve : docs/fidelity_four_passive_local_branch_links_v534.json.
- Runtime : revision534_passive_runtime/EXECUTION.json, CARGO_COMMAND.json, COMPILER_ARTIFACTS.json, INPUTS_BEFORE.json et journal ; compilation privée conservée.
- Inspection : revision534_passive_branch_inspection/OBSERVATIONS.json ; sauvegardes/candidat/contrôles/publication/audit : revision534_passive_branch.
- Réexamen : revision535_trace_review/REVIEW.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et champs antérieurs conservés. Aucun stage/reset/commit.

## Suite du Goal

Découverte des quatre parents PASSIF-SIMULATION effectuée : huit dépendances, quatre questions propres et huit questions enfants distinctes. Les 38 composants locaux et le contexte Garen sont distingués des **18 liens de lecteurs SOURCE d'audit**, qui ne sont pas promus comme mécanique de simulation. Aucun lien parent n'est publié par cette découverte. Les118autres parents restent à examiner sans inférence d'absence.

Poursuivre SYS-01.2-02 depuis revision535_trace_review/REVIEW.json (8374CH au chargeur partagé seul,sans absence globale inférée). Prochain lot :quatre parents PASSIF-SIMULATION Annie/Ezreal/Garen/Trundle depuis revision535_passive_parent_discovery/DISCOVERY.json :8dépendances,38composants locaux/1contexte,4questions propres+8questions enfants conservées. Ne pas promouvoir les18lecteurs SOURCE d’audit comme gameplay de simulation. Qualifier chaque chemin/critère parent dans sa portée ;une union de liens,un appel lexical et les37tests CPU ne ferment pas les règles natives inconnues. V534quatre contrats publié/audité :ne pas republier.24branches/12arêtes natives/39liens actuels/30CID,4questions CONTRAT et4SOURCE propriétaires inchangées. Tests réellement compilés hors ligne dans revision534_passive_runtime/cargo-target :37pass/0fail,dont27spécifiques ;binaire787789824octets SHA8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97,1158entrées exactes et1147dépendances directes. Ne pas relancer sans nouvelle cause ni qualifier l’instrumentation complète ou le jeu natif.118autres contrats restent à inspecter,sans quota ni affirmation d’absence. Préserver12déclarations/5groupes multivalués/Talon vide/descriptions Ezreal-Talon,questions modèles/rig/textures/matériaux,854dépendances MODELE,17auxiliaires et copiesV5311347exactes. Goal actif.
