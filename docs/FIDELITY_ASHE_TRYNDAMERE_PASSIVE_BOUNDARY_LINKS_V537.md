# SYS-01.2-02 — Sources et frontières des passifs Ashe et Tryndamere, V537

25 octobre 2026 — F:/OpenLeague. **Quatre fiches sont reliées ; aucun passif n'est déclaré terminé.** La référence native est PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45. Fuseau et date de déploiement restent inconnus. Le catalogue officiel 4.20.1 en_US est conservé séparément.

## Résultat intégré

Les fiches PASSIF-SIMULATION-CONTRAT et PASSIF-SIMULATION d'Ashe et de Tryndamere relient leurs critères, leurs sources natives et leurs frontières actuelles. **18 arêtes natives, 36 liens de frontières et 10 nouveaux CID** sont ajoutés. Quatre documents de preuve rejoignent le registre ; aucune nouvelle identité physique de code ou d'asset produit. Tous les anciens objets source/consommateur et leurs rôles restent exacts.

Une question ouverte **OLU-5e9f54f7-b032-51be-92df-2b58d09e4682** appartient au parent **CH-Tryndamere-PASSIF-SIMULATION**. Le contrat Tryndamere la référence sans l'adopter. Les quatre anciennes questions propres et six occurrences de questions des dépendances restent chez leurs propriétaires. Les six dépendances, statuts, critères, acceptations, cases, notes et historiques sont conservés. La fiche SOURCE de chacun et les 115 autres contrats/parents restent identiques. Aucune question fermée.

## Sources natives et autorité

Les définitions des deux champions, les INIBIN de Focus/Battle Fury et les chunks Lua candidats sont relus avec les lecteurs actuels. Les trois chunks retenus sont intégralement consommés, sans prototype de callback enfant ; les métadonnées littérales ne deviennent pas une implémentation serveur. Tous les candidats antérieurs sont conservés, sans choix silencieux d'alias ou de priorité.

Le fichier **DATA/menu/fontconfig_en_GB.txt** fourni avec le client est identifié par sa taille, son SHA et l'appartenance déjà constatée au manifeste sélectionné. Sa copie compilée actuelle est exacte. Les clés suivantes sont liées précisément :

- Ashe : `game_buff_tooltip_Focus` et `game_character_passiveDescription_Ashe` ; seuil de 100 charges, attente de 3 secondes avant accumulation et paramètre de taux `@f1@` non résolu.
- Tryndamere : `game_buff_tooltip_Battle_Fury` et `game_character_passiveDescription_Tryndamere` ; 5 Fury par frappe normale, 10 par critique, bonus de 10 par élimination, texte de décroissance après 8 secondes et +0,35 % de critique par Fury.

Ces valeurs sont **des textes natifs écrits**, pas une exécution du serveur historique. La sélection effective en jeu, les détails des événements et les règles de priorité restent à qualifier. L'ancienne description brute Passive1Desc d'Ashe parle d'une hausse de chance toutes les trois secondes ; la clé localisée et le catalogue décrivent des charges. Les deux sources restent distinctes et intactes ; aucune corruption n'est inventée et aucun nombre `f1` n'est comblé.

## Diagnostic public de Tryndamere

Le pilote dépend du **vrai crate openleague-core sur F**. Il charge la navigation TT réelle, active Map10, joint Tryndamere et un Garen adverse, puis les déplace avec **Action::Move**. Aucun champ joueur, position, critique ou inventaire n'est injecté. Les points demandés sont projetés sur le vrai maillage navigable ; la rencontre atteint une séparation compatible avec l'attaque dans le budget de 2 200 ticks. Cela ne valide pas tous les déplacements ou anciens objectifs de navigation.

**Action::Attack** est accepté. Une vraie préparation non critique vise Garen et est libérée au **tick 799**. Sa santé passe de 616.280029296875 à 568.1555786132812. Tryndamere est vivant, niveau 1, sans objet ; le témoin n'attaque pas. La préparation, les identités, positions, snapshots et résultat restent dans les observations.

À partir de cette chance de critique initiale de 0, le texte natif décrit un gain de 5 Fury, soit **+1,75 point de chance de critique**. Le résultat courant reste **0 %** à la frappe et après les ticks suivants :

| Tick | Mesure | Gain attendu selon le texte natif | Chance observée |
| --- | --- | --- | --- |
| 799 | Frappe normale | +1,75 point | 0 % |
| 800 | after_stop_1_ticks | +1,75 point | 0.0 % |
| 829 | after_stop_30_ticks | +1,75 point | 0.0 % |
| 1009 | after_stop_210_ticks | +1,75 point | 0.0 % |

L'attente maximale de 210 ticks représente sept secondes après la frappe, sans nouvelle attaque, donc avant les huit secondes mentionnées par le texte pour la décroissance. Cette comparaison borne le constat ; elle ne reconstitue pas l'ordonnancement du serveur original. **Le gain n'est pas corrigé.** Production sur critiques ou morts, plafond, consommation Bloodlust, valeurs initiales et autres interactions restent ouverts.

Le champ de snapshot `mana` vaut 100, et le catalogue courant distingue le type Battlefury. **Ce scalaire n'est pas assimilé à un compteur Fury qualifié.** Les chemins d'initialisation et de régénération sont des frontières observées, pas une preuve du mécanisme complet.

## Ashe : observation et limite

Une partie séparée active la vraie Map10 et joint Ashe. Sans attaque ni injection, les ticks ordinaires atteignent **90, 900 et 5 400**, soit 3, 30 et 180 secondes. Ashe reste vivante, sans objet, et sa statistique de critique de base reste à 0 %.

**Ce résultat ne prouve pas l'absence de Focus.** Le nombre de charges, le taux `f1` et la condition des 100 charges n'ont pas été qualifiés. Aucun critique garanti ni remise à zéro n'est déclaré testé. La fiche relie les sources et frontières actuelles tout en gardant ces questions ouvertes. Le second exécutable reprend explicitement cette observation d'Ashe comme preuve héritée ; il ne la présente pas comme une nouvelle exécution.

## Contrôles, chemins et provenance

Le témoin Garen passe de 0 à 8 % après achat réel d'un gant 1051, puis revient à 0 % après vente. Joueur inconnu, cible inconnue et cible propre sont refusés avec les résultats exacts conservés. Les deux compilations et exécutions privées renvoient le code 0 ; les contrôles de collecte réussissent. **Code 0 de collecte ne signifie pas que les passifs sont acceptés.**

Les dix points de code sont : tick, ordre d'attaque, profil et statistique critique, échantillonneur, sélection et libération de l'attaque, frappe/dégâts, initialisation de la ressource et garde de régénération par type. Chacun est `entry_boundary_only`, `provides_feature_consumer=false`, `feature_scope_complete=false`. La formule, la frappe et les gardes génériques ne sont pas promues en Focus ou Battle Fury.

Les hashes `source_sha256` de champion_resources.json pour Ashe et Tryndamere correspondent aux **JSON Stats décodés**. Les deux JSON, leurs identités natives distinctes et le reçu de provenance antérieur sont recontrôlés. Leur différence avec le SHA d'un INIBIN n'est ni une source manquante ni une corruption nouvelle. La donnée actuelle et la portée des lecteurs antérieurs sont conservées.

## Binaires et portée d'exécution

Les nouveaux pilotes utilisent des dépendances qui appartiennent toutes au verrou Cargo racine, à l'exception de leur propre paquet privé. Compilation **--locked --offline**. Le core est réutilisé depuis le cache validé (`fresh=true`) ; seuls les pilotes distincts sont compilés. Les **1 158 entrées de code/ressources** restent exactes avant/après, ainsi que les anciens exécutables, manifestes, verrous, sources et artefacts conservés.

- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-ashe-tryndamere-passive-probe.exe : 5973504 octets ; SHA-256 `4670977346ebb26c7d662c6456a91e2e507d0f0019195e4b35b66cc9ddf2c31c`.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-tryndamere-after-ticks-probe.exe : 5961216 octets ; SHA-256 `1ddcfe2547dfac613ffe9ae43db3d33b52d4b797194d4f32fbce356990d7f27f`.

Le premier diagnostic couvre l'attente d'Ashe et la première frappe de Tryndamere. Le second reprend seulement Tryndamere et ajoute les mesures à 1/30/210 ticks ; le premier résultat et son exécutable ne sont pas écrasés. Aucun serveur, client natif, VM Lua, GPU, réseau ou partie multiclient n'est exécuté. Les 37 tests CPU V534 restent des preuves antérieures distinctes et ne sont pas relancés.

## Vérification de livraison

Inspection, préparation, contrôle privé, publication et audit séparé : **codes 0**. **64 faux constats** sont refusés : propriétaire incorrect, frontière absente, mécanique inventée, condition Focus100 inventée, zéro assimilé à absence, scalaire mana appelé Fury, texte appelé exécution, défaut déclaré corrigé, serveur fictif, toutes branches acceptées, mesure ou binaire altéré, question enfant adoptée, dépendance retirée, taux f1 inventé et hash décodé appelé INIBIN. Quatre refus du lecteur public couvrent identifiants absents, acceptation inventée et question parent adoptée par le contrat.

Quatre extraits de trace changent ; **42 211 autres extraits** et **42 210 autres objets tâche/trace** sont exacts. IDs et hiérarchie sont identiques en octets. Les **31 704 anciens objets inconnus** sont identiques, avec un ajout chez le seul parent Tryndamere. Les anciens descripteurs et les questions de Yasuo, modèles, rig, textures, matériaux et navigation sont conservés.

Dans chacune des bases projet et application de bureau : **5 destinataires**, **42 602 autres lignes catalogue**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie complète des consignes propres à chaque champion, résolution, dépendances, propriétaires, intégrité et synchronisation normale idempotente sont vérifiés.

Réexamen courant : **42 215 exigences, 98 823 sources, 2 780 CID**, ancres et identités exactes sur **527 fichiers**, zéro divergence, **26 188 questions ouvertes, 5 517 résolues**, 17 auxiliaires conservés. Les **8 364 fiches CH** au seul chargeur partagé sont une file d'examen ; ce nombre ne mesure pas la complétion du jeu. Ce réexamen n'est pas un nouveau recensement physique de toutes les sources.

## Fichiers et suite

- Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json ; cinq lignes de données/consignes par base. Aucun statut manuel ou critère changé.
- Reçu : docs/reference_requirement_trace_sources/ashe-tryndamere-passive-boundary-links-v537.json ; preuve : docs/fidelity_ashe_tryndamere_passive_boundary_links_v537.json.
- Inspection : revision537_passive_inspection/OBSERVATIONS.json ; diagnostics : revision537_ashe_trynd_probe et revision537_trynd_after_ticks_probe ; sauvegardes/candidat/refus/audit : revision537_passive ; commandes : revision537_passive_COMMAND_*.json/.log.
- Réexamen : revision538_trace_review/REVIEW.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF sont actualisés avec sauvegardes et conservation des champs antérieurs. Aucun stage, reset ou commit.

Continuer SYS-01.2-02 depuis revision538_trace_review/REVIEW.json : 8 364 fiches CH au seul chargeur partagé restent une file de recherche, sans absence ou complétion inférée. Priorité suivante : Jax depuis revision538_Jax_passive_candidate/OBSERVATIONS.json, ses candidats natifs, les différentes infobulles et le chemin de statistique ; qualifier les frappes successives et le taux f1 sans choisir silencieusement un ancien texte de troisième frappe. Poursuivre les 115 autres PASSIF-SIMULATION-CONTRAT depuis revision536_other_passive_contract_discovery_qualified/DISCOVERY.json, leurs sources natives et les chemins génériques ou pilotés par données avant tout lien. Le corpus lexical ne couvre pas tous les alias/macros/configurations ; zéro hit ne prouve aucune absence. V537 Ashe/Tryndamere est publié et audité : quatre fiches, 18 arêtes natives, 36 liens de frontières, 10 CID, une nouvelle question chez le parent Tryndamere uniquement. Son gain critique demeure 0 contre +1,75 point selon texte natif après frappe et 1/30/210 ticks ; le défaut n’est pas corrigé. Ashe : condition 100 charges, taux f1, attaque garantie et reset restent non qualifiés ; ne pas conclure depuis sa statistique 0 %. Les hashes resource.source_sha256 sont des JSON Stats décodés, pas des INIBIN. Conserver les preuves V536 Yasuo et V535/V534, sans republier ni relancer les diagnostics ou tests sans cause nouvelle. Préserver critères, statuts, dépendances, questions propriétaires, cases, notes, historiques et 17 auxiliaires. Goal actif.
