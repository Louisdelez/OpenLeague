# SYS-01.2-02 — Dr. Mundo : sources et régénération, V542

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à 17:46:45. Fuseau et date de déploiement non établis ; catalogue officiel 4.20.1 distinct. **Traçabilité partielle, sans acceptation du passif ni du jeu.**

## Résultat intégré

Les fiches CH-DrMundo-PASSIF-SOURCE, CH-DrMundo-PASSIF-SIMULATION-CONTRAT et CH-DrMundo-PASSIF-SIMULATION reçoivent 18 liens vers six sources natives. Les deux fiches de simulation reçoivent 20 liens vers dix points de code, tous qualifiés `entry_boundary_only` et `provides_feature_consumer=false`. Leurs anciens lecteurs de source et chargeur partagé sont conservés sans être présentés comme une mécanique acceptée. SYS-01.2-02 référence le lot.

Les phases D01/D06, lots, prérequis et états effectifs sont conservés dans le reçu. Cette inspection ne valide pas les sorties complètes des phases. Les trois questions propres, quatre dépendances, références aux questions des dépendances, critères, statuts et acceptations restent inchangés. Aucun inconnu ajouté ou fermé.

## Sources vérifiées

| Source native | Identifiant |
|---|---|
| DrMundo.inibin | OLS-43c7dad5-4d18-5a75-8800-427dc769783c |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nevershade.inibin | OLS-547ed526-7f52-5ce9-aed6-61d6b1e14379 |
| Nevershade.luaobj | OLS-3cfb623d-a227-5cee-a355-5f61863c961e |
| CharScriptDrMundo.luaobj | OLS-85ddc7be-bb00-5ff5-9ade-d97f143cf706 |
| CharScriptDrMundo.preload | OLS-3273daf8-1716-5b53-a37c-e39aa6552d1e |

Les six fichiers correspondent aux tailles/SHA du registre et aux tailles/MD5 des projets du manifeste RADS sélectionné. La découverte couvre les noms Nevershade dans DATA/Spells, la définition et les CharScript du champion ; elle ne constitue pas une recherche exhaustive du serveur original.

DrMundo.inibin déclare Passive1LuaName=Nevershade et PassLev1Desc1=game_character_passiveDescription_DrMundo. Nevershade.inibin lie directement game_buff_tooltip_Nevershade. Le font anglais, lignes 2349 et 4181, annonce dans les deux cas **0,3 % de la vie maximale régénérée chaque seconde**. Le coefficient 0,003 est une conversion arithmétique de ce texte, pas une exécution du serveur original.

La même définition conserve un ancien Passive1Desc : bonus de dégâts20/30/40% sous40% de vie. Ce texte contradictoire n’est pas adopté comme règle active. BaseStaticHPRegen vaut exactement1.5520000457763672 dans le binaire ; BaseFactorHPRegen est la chaîne `0`, BaseHPRegen est absent. Aucun champ absent n’est remplacé par zéro. La chaîne facteur0 ne prouve pas une absence de mécanique serveur.

Les deux Lua sont entièrement parsés, sans prototype de callback enfant. Nevershade déclare BuffName, NonDispellable et PersistsThroughDeath ; le CharScript contient seulement un retour. Les textures DrMundo_AdrenalineRush.dds du buff et DrMundo_AdrenalineRush2.dds de la définition restent distinctes, sans alias ni priorité inventée. Le preload mentionne nevershade et apbonusdamagetotowers : charger une ressource ne démontre pas son effet.

Les copies communautaires Stats/DrMundo, Spells/Nevershade et CharScriptDrMundo.cs sont identifiées avec leur provenance enregistrée. La classe C# locale est vide ; cela ne prouve pas l’absence mondiale d’une autre source. Ces copies ne deviennent pas le code serveur natif.

## Consommateur courant et diagnostic

Le core charge champion_growth_420.json, dont drmundo.health_regen=1.552 et health_regen_growth=0.15. regeneration_rates calcule la base et les bonus de régénération des objets ; advance_regeneration ajoute le chemin Garen existant. Le chemin de stats calcule la vie maximale de base, la croissance et les objets. Le Cristal1028 de shop_foundation ajoute150PV et0% de régénération. Ces ressources sont identifiées et reliées comme entrées actuelles, sans attribuer leur SHA de JSON à un INIBIN natif.

Deux parties Map10 utilisent le vrai core non-test, la navigation réelle, les commandes publiques Buy, Move, Attack et Stop. Garen blesse Dr. Mundo par frappes ordinaires puis est arrêté. Chaque observation dure180ticks, soit six secondes. Dr. Mundo reste vivant, niveau1 et sous sa vie maximale ; aucune cible ou windup ennemi ne subsiste pendant la fenêtre. Aucun champ de vie, dégât ou soin n’est injecté directement.

| Mesure | Sans objet | Cristal de rubis1028 |
|---|---:|---:|
| Vie maximale | 582.52001953125 | 732.52001953125 |
| Régénération de base, PV/s | 1.5520000457763672 | 1.5520000457763672 |
| Supplément annoncé par le texte, PV/s | 1.7475600242614746 | 2.1975600719451904 |
| Vie initiale | 321.228515625 | 428.099365234375 |
| Vie finale | 330.5394287109375 | 437.4102783203125 |
| Ticks de début/fin | 1059 / 1239 | 1107 / 1287 |
| Frappes ennemies ordinaires | 6 | 7 |
| Somme des soins au-delà de la base | 0 | 0 |

À chacun des180ticks, la vie observée correspond à la seule base calculée en f32. La comparaison additionnant le supplément textuel donne un écart négatif par tick ; sa somme est conservée dans les observations et ne doit pas être prise pour une seconde simulation contrefactuelle cumulée. L’objet augmente bien la vie maximale de150PV ; le supplément textuel passerait de1.74756 à2.19756PV/s, soit +0.45PV/s. Cette augmentation de régénération n’est pas observée.

**Écart borné établi : dans ces deux scénarios niveau1, le soin proportionnel décrit par le texte n’apparaît pas dans la régénération courante.** Le diagnostic ne qualifie ni cadence historique exacte, ni interactions, niveaux2..18 ou présentation. Il ne répare pas le passif dans cette tâche de liens source/consommateur.

Contrôles limites :30ticks à pleine vie avant achat dans chaque cas restent plafonnés ; joueur inconnu, cible inconnue et cible alliée soi-même sont refusés avec leurs erreurs exactes. regeneration_rates d’un joueur inconnu renvoie None. Six refus Attack et deux retours None sont vérifiés.

## Échecs conservés et exécution

Le premier driver supposait à tort que l’achat de150PV maximum remplissait immédiatement ces150PV. Il échoue après achat (582.5718PV observés pour732.52 maximum). Le code courant conserve la vie puis la plafonne au nouveau maximum. Le scénario corrigé contrôle la vie pleine **avant** achat, dans un nouveau répertoire et un nouveau binaire. L’ancien driver, son exécutable et ses journaux restent identiques. Une parenthèse surnuméraire dans le premier script d’inspection a également empêché son démarrage ; le script original est conservé et le script qualifié distinct s’exécute avec succès. Ces erreurs d’outillage ne sont pas présentées comme des défauts du jeu.

Build et exécution qualifiés : codes0. Core non-test en cache, src_path F:/OpenLeague/crates/core/src/lib.rs ; identités, versions et checksums des dépendances alignés sur Cargo.lock racine. Les1158 entrées source/ressource, registres avant publication, anciens binaires et locks sont exacts. Aucun ancien diagnostic relancé. Aucun code produit ou asset modifié.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-mundo-passive-healing-qualified-probe.exe` ; 5948416 octets ; SHA256 `6068f6e674df413fc1a91e81f6b390f0d5d79c3c46d23677641a1a519cf2e28e`. Le manifeste privé, lock, code du driver, outils, commandes, journaux et identités sont dans revision542_DrMundo_passive_probe_qualified/OBSERVATIONS.json. Aucun serveur ou client original, VM Lua, GPU ou réseau exécuté.

## Validation de la livraison

Inspection, prepare, check, publish et audit réussis.54 associations invalides et quatre graphes invalides sont refusés : source manquante, question étrangère, faux résultat, dépendance supprimée, passif faussement accepté, vieux texte pris pour règle, alias d’icône ou cadence native inventés, entre autres.

Dans chacune des deux bases réelles : quatre fiches actualisées ;42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task, copie des instructions complètes, dépendances, questions, summary, integrity_check et sync_catalog idempotent vérifiés. Trois fragments changent,42212 sont exacts ;42211 autres objets tâche/trace conservés. Identifiants, hiérarchie et registre des inconnus identiques en octets. Aucun ancien descripteur supprimé ou réécrit.

Réexamen courant :42215 exigences,98843 sources,2825 consommateurs ;26189 inconnues ouvertes et5517 résolues. Les2825 ancres et les octets de527 fichiers correspondent ; zéro divergence,17 auxiliaires. Ce contrôle n’est pas un nouveau contrôle physique de toutes les98k sources.8354 fiches CH au seul chargeur partagé restent une file de recherche, pas un pourcentage d’achèvement.

## Fichiers et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/mundo-passive-healing-links-v542.json. Preuve : docs/fidelity_mundo_passive_healing_links_v542.json. Quatre lignes données/consignes actualisées par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF sont mis à jour avec sauvegardes ; leurs anciens champs sont conservés. Scripts exécutés sur F, copies archivées. Aucun stage/reset/commit.

Restent ouverts : corps serveur original et producteur actuel du supplément, cadence historique, mort/réapparition, réduction et amplification des soins, niveaux supérieurs, autres changements de vie maximale, rendu et priorités d’icônes. Aucune case de réalisation n’est cochée par ce diagnostic.

Continuer SYS-01.2-02 depuis revision543_trace_review/REVIEW.json. V542 DrMundo est publié et audité : trois fiches, six sources natives,18 arêtes et20 liens vers10 frontières. Nevershade et la description anglaise annoncent0.3%maxHP/s ; les deux fenêtres180ticks ne montrent que1.552PV/s de base. Cristal1028 augmente la vie maximale150 sans modifier cette base ; supplément textuel attendu1.74756/2.19756PV/s non observé. Ancien texte20/30/40% de dégâts, facteur littéral0 et variantes d’icône conservés. Tentative initiale de diagnostic et erreur de syntaxe conservées, contrôles corrigés qualifiés. Aucun code de jeu modifié, aucun passif accepté, inconnus/statuts/cases conservés. Ne pas republier V542 ni relancer ces diagnostics sans cause nouvelle. Examiner ensuite Singed : conversion mana vers vie, exacts noms natifs Empowered Bulwark/Empowered_Bulwark, description25PV pour100mana, consommateur actuel de stats et achat/vente d’objet mana. Vérifier les sources natives et le sens mana maximal/courant avant toute qualification ; le lookahead font/mirror n’est pas encore une preuve enregistrée.110 autres contrats/parents restent à examiner ;8354CH au seul chargeur partagé sont une file de recherche, pas un taux de complétion. Goal actif.
