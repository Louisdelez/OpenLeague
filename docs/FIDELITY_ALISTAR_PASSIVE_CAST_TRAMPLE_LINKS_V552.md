# SYS-01.2-02 — Alistar : Trample, V552

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Alistar-PASSIF-SOURCE, CH-Alistar-PASSIF-SIMULATION-CONTRAT et CH-Alistar-PASSIF-SIMULATION reçoivent24 arêtes vers8 sources natives. Les deux fiches de simulation reçoivent36 liens vers18 points actuels, qualifiés `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence le lot. Les anciens lecteurs et le chargeur partagé sont conservés sans promotion en implémentation.

Phases, lots et prérequis sont relevés dans le reçu. Trois questions propres et quatre dépendances conservées. Aucun inconnu ajouté ou fermé ; aucun statut, critère, case, note ou historique manuel modifié.

## Sources et limites natives

| Fichier | Identifiant |
|---|---|
| Alistar.inibin | OLS-d5c1b177-fd59-591e-9d2a-d471b3deaea4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| AlistarTrample.inibin | OLS-d001921d-95c4-5b57-a0cf-b604b6ac04af |
| AlistarTrample.luaobj | OLS-5db6caf8-aa2a-5a3d-8fc4-bc96a397edd1 |
| AlistarTrample.preload | OLS-a7459a74-278f-5d38-b311-40c8c8cb5c2f |
| Colossal Strength.inibin | OLS-956ef09e-4da1-5ad2-8995-bdf1070c1848 |
| ColossalStrength.luaobj | OLS-e3d7f28a-8383-5580-bed3-d418c6136ade |
| Trample Buff.inibin | OLS-f55a5c20-da91-51eb-9093-6d8368b486c1 |

Les8 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets RADS sélectionnés. Découverte antérieure revalidée. La définition Passive1LuaName=Colossal Strength concorde avec BuffName du script ColossalStrength. AlistarTrample.luaobj déclare séparément BuffName=Trample Buff et IsDeathRecapSource=true. Les deux icônes déclarées sont Minotaur_ColossalStrength.dds. Ces noms sont gardés distincts ; aucun ordre d’alias ou corps serveur n’est inventé.

Deux liens directs de tooltip : Colossal Strength.inibin→game_buff_tooltip_Colossal_Strength ligne1791 ; Trample Buff.inibin→game_buff_tooltip_Trample_Buff ligne2782. Le premier décrit un déclenchement après sort, la traversée des unités, des dégâts magiques par seconde proches sur ennemis/bâtiments pendant3s et des dégâts doubles aux sbires. f1 total, f2 base et f3 AP n’ont pas de fournisseurs qualifiés. Le second décrit l’état actif. La description du champion liée4152 reste distincte.

Passive1 est absent. Passive1Desc évoque une réduction des dégâts des tourelles ; les descriptions suivantes évoquent400/600PV, avec niveaux6/12/18. **Ces données anciennes ne sont pas adoptées comme règles de Trample.** Deux Lua entièrement parsés, sans prototype enfant ; cela ne constitue pas une exécution du serveur. Un preload déclare des particules de piétinement, nez, tête et main ; leur nom ne prouve pas leur rendu. Cinq références communautaires sont distinguées des sources natives.

CharScriptAlistar.luaobj et .preload ne sont pas présents dans le seul répertoire Characters/Alistar/Scripts sélectionné ; son listing est conservé. Les fichiers directs Spells existent. Cette absence locale ne prouve aucune absence mondiale de serveur ou de ressources.

## Consommateurs actuels et exécution

Consommateurs inspectés : join, stats, Learn/next_rank, commande publique, Cast ciblé, CastAt, cône et exécution du W d’Annie, dégâts communs, régénération, tick, vitesse, occupation des alliés et filtrage d’équipe, profils/rayons de collision. La boucle réelle appelle advance_allied_motion ; le module ally_occupancy reconstruit les placements, routes et réservations entre champions alliés. **Ce système n’est pas une implémentation du phasing conditionnel de Trample.** Aucun test d’interpénétration ou de contacts avec les PNJ n’est revendiqué ici.

Deux parties publiques Map10 avec déplacements, arrêts et commandes normales, sans injection de position, PV, mana, or, XP, dégâts ou effets. Les deux joueurs restent vivants au niveau1 ; aucune fin de partie.

| Cas | Attendu selon les chemins courants inspectés | Observé |
|---|---|---|
| Alistar/Garen | Learn, Cast et CastAt non implémentés |4Learn→champion skill progression not implemented ;4Cast→champion spell not implemented ;4CastAt→champion ground spell not implemented |
| Alistar après refus | Aucun déclencheur de Trample accepté |91ticks817→908 ;aucun impact, mana et recharges inchangés, rangs0 |
| Annie/Garen, témoin distinct | W appris puis accepté, impact après8ticks |Cast805, impact813 ;rangW1, coût70mana et recharge240ticks ;un impact sur91ticks |

L’impact W réduit les PV de616.2800293 à563.3421021, soit52.9379272PV nets. Le calcul courant avant la régénération du même tick vaut52.9901581. Le diagnostic emploie une tolérance0.2PV entre dommage et delta net ; la différence de0.0522308 ne devient pas une règle native de Trample. Le W d’Annie est un témoin fonctionnel d’une autre capacité, pas un déclenchement de Trample.

24 refus publics possèdent chacun une comparaison de snapshot complet inchangé :17Alistar,7Annie. Les cinq gardes communes couvrent joueur inconnu, slots Cast/CastAt/Learn invalides et point non fini. Alistar ajoute les12refus des quatre slots ;Annie ajoute W non appris puis nouvelle tentative pendant son cast. L’intervalle91ticks après refus ne valide ni une durée native de3s, ni l’expiration, ni les dégâts ou la traversée des unités de Trample.

## Exécutions, échecs et conservation

Le premier build privé a échoué avec E0277 : Stats n’implémente pas Serialize. Le diagnostic corrigé sérialise seulement les scalaires MR cible et AP source, dans revision552_Alistar_passive_probe_qualified. Ancien script, source, manifeste, verrou et journal conservés et pinés. **Aucun code du moteur n’a été changé.** Build et run corrigés :code0 ;core non-test réutilisé du cache.1158 entrées core/ressources et anciens artefacts exacts ;verrou privé aligné sur les identités/checksums du Cargo.lock racine.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-alistar-passive-cast-trample-probe.exe` ;6002176octets ;SHA256 `08a61924bd3fd3330e7610eb99b835bf9e6063424497c370fa03ca995fd2faa3`. Reçu runtime : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision552_Alistar_passive_probe_qualified\OBSERVATIONS.json`. Aucun historique LoL, serveur original, VM Lua, GUI, GPU, réseau ou audio exécuté.

Le premier check du registre a été lancé avant la fin de prepare et a refusé sur PREPARED.json absent. Il est conservé dans revision552_Alistar_COMMAND_CHECK.json/.log. Après prepare0, le même contrôle a été exécuté via revision552_alistar_check_after_prepare.py, reçu CHECK_QUALIFIED ;code0. Il n’a pas été présenté comme réussi avant sa reprise.

Inspection, prepare, check qualifié, publish et audit réussis.72associations invalides et4graphes invalides refusés, dont faux déclenchement, Annie assimilée à Trample, champ absent remplacé, absence locale présentée comme globale, durée déduite d’un refus, question étrangère et dépendance retirée. Deux bases :4destinataires mis à jour par base ;42603autres lignes de catalogue,42607états manuels et23événements historiques exacts. Store.task/copy_text/summary, dépendances/questions, intégrité et synchronisation idempotente vérifiés.3fragments modifiés,42212exacts ;42211autres objets tâche/trace conservés. IDs, hiérarchie et inconnus identiques en octets.

Graphe42215exigences,98884sources,2960consommateurs ;26189questions ouvertes/5517résolues.2960ancres et527fichiers courants exacts, zéro divergence ;aucun nouveau recensement physique des98k sources.8334CH au seul chargeur partagé constitue une file de recherche, pas un taux d’achèvement.

## Fichiers modifiés et suite

Registres : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/alistar-passive-cast-trample-links-v552.json ;preuve docs/fidelity_alistar_passive_cast_trample_links_v552.json. Couverture, plan, reprise, CURRENT et HANDOFF actualisés avec sauvegardes. Scripts de diagnostic et de livraison archivés ;anciens artefacts conservés. Aucun gameplay ni asset modifié ;aucun stage/reset/commit.

Restent ouverts : déclenchement sur sort accepté, fournisseurs et formules f1/f2/f3, niveaux/AP, rayon, cadence, rafraîchissement, cibles et double dégâts aux sbires, durée effective, phasing, mort/réapparition et présentation.

Continuer SYS-01.2-02 depuis revision553_trace_review/REVIEW.json. V552 Alistar publié/audité :3fiches,8sources natives,24arêtes,36liens vers18frontières false. Learn/Cast/CastAt refusés pour4slots chacun ;91ticks817→908 après refus ne sont pas un déclenchement. Témoin Annie W accepté805,impact813,dégâts nets52.93793 après régénération ;pas Trample.24refus publics exacts. Deux bindings Colossal Strength/Trample Buff,2Lua sans callbacks,1preload,5références communautaires. f1/f2/f3,formules,rayon,cadence,refresh,cibles et phasing conditionnel ouverts. Deux CharScript absents seulement du répertoire choisi. Anciennes descriptions tourelle/HP et niveaux6/12/18 non adoptés. Occupation des alliés reconstruite inspectée,pas de test de traversée conditionnelle. Échec privé de compilation Stats conservé,correction de deux scalaires seulement ;premier check lancé avant PREPARED refusé puis repris après prepare0,logs conservés. Aucun code de jeu modifié/passif accepté.100autres contrats/parents de passifs restent à examiner ;8334CH au seul chargeur partagé est une file de recherche. Examiner ensuite Nunu/Visionary :identifier les ressources natives et le lien attaques→prochain sort sans coût,les consommateurs actuels de compteurs/attaque/coût et les refus de sorts,avec témoin distinct si disponible. Ne pas inventer un déclencheur exécuté depuis des métadonnées. Goal actif ;ne pas republier V552 sans cause nouvelle. Découverte Nunu déjà effectuée :revision553_Nunu_discovery/OBSERVATIONS.json,11sources natives,3bindings,4Lua sans callbacks,2preloads,5références communautaires. Visionary.luaobj :NEWTABLE pc8 non pris en charge par le lecteur de littéraux,pas un fichier corrompu ;les autres métadonnées sont littérales. Visionary_marker BuffName Visionary et Visionary_Counter BuffName Visionary Counter restent distincts. Textes2898 et4242 :5attaques puis sort gratuit ;ancien texte chance/aléatoire,descriptions Yuralia10% et niveaux1/6/11 non adoptés. Runtime,inspection qualifiée et publication Nunu restent à faire. Ne pas relancer cette découverte sans cause nouvelle.

## Supplément de fraîcheur — contrôle source/consommateur au 2026-11-02

Le reçu V552 et sa preuve sont toujours byte-identiques (SHA-256 du reçu : 3a29ec4ae56390affd872a54217244bb8816168a6511b176fa05d23f3498c8ef; preuve passed=true). Alistar.inibin (2 091 octets, SHA-256 a28be95a739ed43258abc5a0d5c9c10f6746a647c8af6de2a1c74e480e2adae5) et AlistarTrample.inibin (1 438 octets, SHA-256 2077a5ac82881b788a78165a6f40e1aaa8dfd32c95b8820d0af8ed0915120d01) conservent leurs pins. Les 18 ancres Rust du reçu sont présentes aux lignes enregistrées; les 18 fichiers correspondants gardent les empreintes V552.

Le diagnostic runtime antérieur est réutilisé, pas relancé : Learn, Cast et CastAt d’Alistar sont refusés par le contrat local; 91 ticks après ces refus n’observent pas de Trample. Le contrôle positif Annie W est un sort d’un autre champion et ne constitue pas un déclenchement. Ce contrôle ferme seulement la fraîcheur de la liaison source/frontières courantes. Le callback serveur, les fournisseurs f1/f2/f3, la portée et cadence, les cibles, le phasing conditionnel et l’acceptation restent inconnus. Aucun test ou build exécuté dans ce supplément; CH-Alistar-PASSIF-SOURCE et les tâches fonctionnelles restent ouvertes.