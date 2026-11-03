# SYS-01.2-02 — Vladimir : Pacte de sang, V545

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et date de déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat et intégration

Les trois fiches CH-Vladimir-PASSIF-SOURCE, CH-Vladimir-PASSIF-SIMULATION-CONTRAT et CH-Vladimir-PASSIF-SIMULATION reçoivent21 arêtes vers sept sources natives. Les deux fiches de simulation reçoivent20 liens vers dix frontières réelles, toutes `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence ce lot. Phases, lots et prérequis sont relevés dans le reçu ; leurs sorties ne sont pas déclarées achevées.

Trois questions propres et quatre dépendances restent exactes, y compris les propriétaires des questions de dépendance. Aucun inconnu ajouté ou fermé. Statuts, critères, cases, notes et historique préservés.

## Sources et limites natives

| Fichier | Identifiant |
|---|---|
| Vladimir.inibin | OLS-969fda7a-863a-560c-a30d-c22dc8778d3a |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| VladimirBloodGorged.inibin | OLS-8cb283ca-cbda-5a03-b29a-65c6f830ff0e |
| VladimirBloodGorged.luaobj | OLS-d47f1e46-d502-504f-8b93-6f72ecd0c4d2 |
| VladimirBloodGorged.preload | OLS-309fefdb-8a4b-5f57-a6e0-c26769abc9c2 |
| CharScriptVladimir.luaobj | OLS-9d70fdcf-5115-55eb-94f9-424faea1c84a |
| CharScriptVladimir.preload | OLS-9b97aea9-1188-559c-b449-09b98793b365 |

Les sept fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. La recherche couvre la définition, les fichiers Spells/VladimirBloodGorged et les CharScript du champion ; elle ne prouve pas une absence mondiale de code serveur.

La définition déclare Passive1LuaName=VladimirBloodGorged, identique au BuffName littéral. Le BuffData.DynamicTooltip de l’INIBIN lie exactement game_buff_tooltip_VladimirBloodGorged, ligne2905 du font anglais. La description du champion à4305 confirme : **40PV bonus donnent1AP et1AP donne1.4PV bonus, sans cumul du passif avec lui-même**. f1 affiche la puissance supplémentaire, f2 les PV supplémentaires ; les producteurs effectifs de ces valeurs ne sont pas qualifiés.

Les deux Lua sont entièrement parsés et ne contiennent aucun prototype de callback enfant. Le buff de224octets fournit notamment le nom, la texture Vladimir_BloodGorged.dds et des booléens de persistance/non-dissipation. Le CharScript de56octets ne contient qu’un RETURN. Aucune VM ou règle serveur originale n’est exécutée. Les preloads vladimirtidesofbloodcost, vladdeathparticle, vladimirbloodgorged et apbonusdamagetotowers restent des références déclarées, pas des effets validés.

Passive1 est absent et n’est pas remplacé par0. Le vieux texte mentionnant Ryze, les chaînes AP30/45/60 et les niveaux1/6/16 sont conservés sans adoption comme politique active. BaseMP est le nombre0 et MPPerLevel la chaîne"0" ; cette distinction reste visible. Les deux JSON communautaires et le CharScriptVladimir.cs vide de cette copie sont pinés avec leur provenance ; ils ne deviennent pas une implémentation originale.

## Consommateur réel et diagnostic

Le chemin courant relie join, commandes Buy/Sell, buy_item/sell_item, refresh_item_caps, shop::bonuses, stats, advance_passive_gold et advance. shop::bonuses additionne séparément AP et PV ; stats expose actuellement AP des objets multiplié par l’éventuel bonus d’autels et PV de base+croissance+objets. Le contexte sans autels des essais ne qualifie pas l’ordre natif avec multiplicateurs. Le chargement des données de champion et la présence de statistiques génériques ne constituent pas le producteur du passif.

Quatre parties Map10 avec navigation réelle, deux Vladimir et deux Ahri témoins, achètent publiquement1052 puis1028 ou1028 puis1052. Les objets coûtent435 et400 pour825or initial : le second achat est d’abord refusé. Les ticks normaux apportent8or à2250 puis8à2400 ; aucun or, vie, puissance, expérience ou état de passif n’est injecté. Le champion reste vivant au niveau1, sans victoire. L’or passif est utilisé pour financer le scénario, pas pour qualifier le timing du serveur historique.

Après le second achat, les trente ticks suivants sont échantillonnés, puis les deux objets sont revendus. Le cas Ahri contrôle la mécanique générique ; les prédictions Crimson Pact ne lui sont pas attribuées.

| Mesure Vladimir, mêmes résultats dans les deux ordres | Observé | Prédiction issue du texte pour ces seuls bonus |
|---|---:|---:|
| PV de base | 542.7999877929688 | identiques |
| PV des objets |150|150|
| AP des objets |20|20|
| PV supplémentaires du passif |0|28|
| AP supplémentaires du passif |0|3.75|
| Total PV |692.7999877929688|720.7999877929688|
| Total AP |20.0|23.75|

Les ventes ramènent les capacités à542.7999877929688PV et0AP. Ahri passe de514.4000244140625 à664.4000244140625PV avec20AP, puis retrouve ses valeurs initiales. Les calculs textuels excluent explicitement la réutilisation des bonus produits par le passif. **La stabilité de bonus absents ne prouve pas qu’une politique non récursive est implémentée.**

Vingt refus publics : par partie, joueur inconnu, objet inconnu, case hors limites, case vide et or insuffisant. Les snapshots complets sont comparés avant/après le groupe initial de quatre refus, puis séparément avant/après le refus d’or insuffisant, dans chaque partie. Le premier groupe ne capture pas chaque état intermédiaire. Achat valide, financement naturel, statistiques, ventes et stabilité passent les assertions du diagnostic ; cela démontre l’écart décrit, pas une réussite de fidélité du passif.

Build et exécution retournent0. Le core non-test est celui du projet, servi par le cache Cargo ;1158 entrées de source/ressource, les anciens artefacts et les identités/checksums de dépendances du Cargo.lock racine restent exacts. Binaire exécuté : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-vladimir-passive-conversion-probe.exe` ;6005760octets ; SHA-256 `6257760d18d26dfbf10447f89b692f5ff34864220a3f6465b88248714d51f388`. Source Rust, outils, manifestes, verrous, logs et commandes sont pinés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision545_Vladimir_passive_probe\OBSERVATIONS.json`. Aucun client historique, serveur natif, GPU, réseau ou validation visuelle/audio exécuté.

## Correction de l’inspection et conservation

La première inspection a échoué sur la recherche d’un descripteur F pour passive_gold_rules.json. Le registre conservait seulement son chemin E. Ce n’était pas un fichier de jeu manquant : les deux chemins ont des octets identiques, vérifiés. La reprise distincte `revision545_Vladimir_inspection_qualified_v2` ajoute l’identité F sans modifier le descripteur E ; le script initial est conservé et piné. Aucun registre ou gameplay n’avait été publié lors de cet échec. Les paramètres d’or sont une ressource courante décodée, pas du code serveur original.

Inspection qualifiée, prepare, check, publish et audit réussis.60 associations invalides et quatre graphes invalides sont refusés : faux bonus, stabilité présentée comme non-récursivité validée, texte ancien adopté, source/binaire altéré, question étrangère ou dépendance retirée. Les quatre nouvelles preuves et la ressource F ajoutent cinq sources au registre.

Par base réelle : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, integrity_check et sync_catalog idempotent vérifiés. Trois fragments de traçabilité changent,42212 restent exacts ;42211 autres objets tâche/trace et anciens descripteurs conservés. IDs, hiérarchie et registre des inconnus restent identiques en octets.

Réexamen :42215 exigences,98856 sources,2855 consommateurs ;26189 questions ouvertes et5517 résolues.2855 ancres et527 fichiers actuels exacts, zéro divergence ;17 auxiliaires conservés. Ce n’est pas un nouveau contrôle physique de toutes les sources.8348 fiches CH au seul chargeur partagé restent une file de recherche et non un taux de complétion.

## Fichiers et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/vladimir-passive-conversion-links-v545.json ; preuve docs/fidelity_vladimir_passive_conversion_links_v545.json. Quatre lignes données/consignes changent par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF sont actualisés avec sauvegardes ; anciens champs conservés. Scripts exécutés sur F et archivés. Aucun code gameplay/asset changé, aucun stage/reset/commit.

Restent ouverts : corps serveur original, producteurs f1/f2, bonus hors objets, niveaux, ordre avec multiplicateurs, arrondis, mort, transitions et présentation. Aucun champion ou jeu complet n’est déclaré.

Continuer SYS-01.2-02 depuis revision546_trace_review/REVIEW.json. V545 Vladimir publié et audité : sept sources,21 arêtes,20 liens vers10 frontières,3 questions propres et4 dépendances préservées. Deux ordres Ruby1028/Tome1052 avec or ambiant naturel :692.7999878PV/20AP contre prédiction textuelle720.7999878PV/23.75AP ; conversions absentes dans ces cas. Ahri témoin,30ticks stables,ventes et20refus publics vérifiés. Pas de preuve de politique non récursive à partir de bonus absents ; f1/f2,niveaux,multiplicateurs,mort/arrondis restent ouverts. Ancien texte Ryze/AP/niveaux conservé. Échec initial d’inspection dû au chemin de registre E pour passive_gold_rules ; source F ajoutée avec identité E conservée, inspection qualifiée_v2 réussie. Aucun gameplay modifié/passif accepté. Ne pas republier ou relancer ce lot sans cause nouvelle. Examiner ensuite Galio et la conversion de résistance magique vers puissance : identifier sources exactes et producteurs courants avant diagnostic.107 autres contrats/parents de passifs restent à examiner ;8348CH au seul chargeur partagé est une file de recherche, pas un taux de complétion. Goal actif.
