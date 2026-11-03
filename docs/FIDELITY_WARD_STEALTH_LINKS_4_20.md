# Balises,invisibilité et révélation — liens V105

> **Précision V1131 (2026-11-03).** La phrase historique ci-dessous sur la « déconnexion » dépasse les assertions des tests retenus : le test de retrait contrôlait les dégâts et la présence de la brûlure, et le test de visibilité conservait le lanceur. Un contrôle ultérieur démontre la visibilité après `Simulation::remove_player` dans une fixture locale, mais pas après détachement réseau réel. Voir `AUDIT_SYS01202_IGNITE_REMOVED_SOURCE_VISION_2026-11-03.md`. Les observations et reçus V105 restent conservés.


Sept exigences liées à14 rôles. Une portée Ignite partielle,six frontières. Aucun objectif gameplay clôturé.

## Recherche préparatoire conservée

Les mentions non intégré ci-dessous décrivent uniquement la première étape de recherche. La livraison finale est identifiée plus bas.

# Balises, invisibilité et révélation — recherche V105

Objectif SYS-01.2-02 ;exigences SYS-13.2-01 à07. Le tour précédent V104 a intégré sept exigences vision et audité le registre et les deux bases. Cette nouvelle étape fournit des sources et contrôles préparatoires ;aucune tâche cochée ou déclarée complète.

## Inventaire borné

Le catalogue local DataDragon4.20.1 est interrogé sur les noms/descriptions contenant les mots ward,trinket,stealth,invisible,reveal et variantes.44 objets candidats sont conservés,y compris variantes de carte et colliers de Rengar ;ce critère lexical n'est pas une liste exhaustive de tous les effets de vision.

Cinq dossiers de personnages dont le nom contient ward ou trinket :GhostWard,SightWard,VisionWard,YellowTrinket,YellowTrinketUpgrade. Les fichiers directs sont recensés sans les skins. Les93 fichiers natifs trouvés concordent avec les manifestes sélectionnés. Ils comprennent49 INIBIN et44 Lua ;les INIBIN sont décodés,les Lua sont relus par deux parseurs concordants. Aucune instruction native n'est exécutée.

42 Lua ne contiennent que RETURN sans constantes ni sous-fonctions,dont CharScriptSightWard,CharScriptVisionWard,2043.luaobj et2044.luaobj. Les deux autres sont conservés avec leurs instructions ;aucun effet de jeu ne leur est attribué ici. DATA/Items/2047.luaobj et3460.luaobj n'ont pas été trouvés aux chemins recherchés. Cela n'établit pas l'absence globale de leurs producteurs historiques.

## Carte10 et consommateur actuel

Les descriptions de2043/2044 mentionnent limites,détection et durées,mais leurs maps.10 sont explicitement false dans le catalogue. Les autres objets de vision doivent être examinés selon leur propre entrée. Une clé maps.10 absente est conservée comme telle,elle ne devient pas une autorisation observée.

Aucun des44 objets candidats n'est présent dans les définitions shop_foundation examinées ni dans les entrées correspondantes du catalogue d'admission local. Dans buy_item,la recherche de comportement intervient avant l'admission Map10 :ces objets rencontrent d'abord « item behavior not implemented » si les gardes de boutique passent. Ceci est une lecture du code,non un nouveau test d'achat de44objets. Ne pas présenter l'erreur d'indisponibilité Map10 comme le chemin actuellement exercé pour ces balises.

## Révélation Ignite

Quatre tests actuels ont été exécutés avec filtre exact,un test par commande cargo --locked --offline. La cible brûlée reste visible à l'équipe du lanceur jusqu'à expiration ;le test vérifie le retrait àtick150. La mort du lanceur ne supprime pas la brûlure,la mort de la cible la supprime,la déconnexion du lanceur conserve la révélation restante. Le remplacement par un second lanceur reste une politique communautaire explicitement nommée.

Ces tests sont des états contrôlés du simulateur,non une partie historique. Ils ne prouvent ni true sight,ni révélation de toutes les unités proches,ni règles universelles de rupture d'invisibilité. Les logs,commandes et binaires sont épinglés dans ignite-reveal-tests.json.

## Travail suivant

Relever les producteurs réels de balises,limites,expiration/destruction et groupes d'inventaire ;distinguer les restrictions de carte des fonctions globales. Examiner les sources de l'invisibilité des champions et les pièges/invocations au-delà du critère lexical choisi. Qualifier les descriptions et valeurs contre les fonctions natives disponibles ou déclarer un contrat local explicite. Construire les associations précises et leur lecteur avant l'intégration au registre et aux bases. SYS-13.2 reste ouvert ;V104 reste la dernière livraison intégrée.


## Recherche supplémentaire et livraison

289 fichiers natifs supplémentaires ont été recherchés dans huit dossiers de champions,quatre pièges,AnnieTibbers et SummonerDot. Ils concordent tous avec les manifestes. Le premier nom Tibbers ne trouvait aucun fichier ;le chemin réel AnnieTibbers a été identifié puis ses cinq fichiers recensés. Le premier inventaire est conservé. Le sous-ensemble choisi ne prouve pas l'exhaustivité de l'invisibilité ou des pièges. La recherche lexicale courante a couvert639 fichiers core,12 serveur et498 client ;ses rares occurrences sont des commentaires/diagnostics et ne démontrent pas une absence globale de fonctions sous d'autres noms.

Le lecteur vérifie418 fichiers et1245 contrôles ;37 cas de qualification,dont36 refus. Les382 fichiers natifs correspondent aux manifestes. Les quatre tests Ignite sont les exécutions actuelles enregistrées dans les reçus ;aucune instruction native,partie historique ou pixels GPU exécutés. Les fonctions buy_item,spawn_unit,visible_to,map10_available,advance_world,target_info,cast_ignite,advance_ignite et la sélection de sources client sont reliées avec leur portée précise. Les commentaires ou enums ne deviennent pas une implémentation générale.

Le registre et les deux bases sont mis à jour pour les sept exigences et SYS-01.2-02,avec audit séparé de préservation. Voir docs/fidelity_registry_ward_stealth_links_revision_4_20.json pour le résultat effectif de livraison. Toutes les questions restent ouvertes et les cases restent manuelles.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-13.2-01 | Green ward native metadata and empty callbacks recovered. Current shop has no candidate item definition;buy_item refuses missing behavior before map availability. | Historical placement,three-ward overwrite policy and lifetime producer remain unqualified. Map10 exclusion is separate from global ward behavior. |
| SYS-13.2-02 | Vision ward metadata and empty callback recovered;visible_to is a current information boundary,not true-sight implementation. | Qualify stealth detection and public ward identity,one-ward limit and historical target categories. |
| SYS-13.2-03 | Catalogue contains distinct map restrictions and reveal-item descriptions. None of44 lexical item candidates has current shop behavior/admission. UI has six inventory slots with trinket applicability open. | Resolve complete map-specific availability,active/passive reveal producers and trinket lifecycle;missing map flag is not observed permission. |
| SYS-13.2-04 | World update and entity-kind enum provide lifecycle boundaries;no Ward kind or dedicated ward lifetime qualified here. | Qualify native duration/HP/hit-count,expiry/destruction/overwrite and owner-departure behavior through actual producer/consumer. |
| SYS-13.2-05 | Eight champion candidate directories inspected;current visible_to and target_info do not establish complete invisibility transitions. | Identify native activation,delay,attack/spell/damage rupture and detection policies per champion. Lexical search cannot establish absence under other names. |
| SYS-13.2-06 | Current Ignite reveals only its target to caster team;four exact tests verify expiration,target/source death,disconnect and community replacement policy. | Qualify other reveal capabilities and native overlap/stealth semantics. Current Ignite tests do not prove true sight or area revelation. |
| SYS-13.2-07 | Four trap profiles and AnnieTibbers resources recovered. Current vision source selection includes eligible pets;trap-category and stealth semantics remain separate. | Qualify each trap/summon producer,vision source eligibility,owner/team changes and hidden-state filtering. Do not equate pet visibility with all traps. |

Reçu : docs/reference_ward_stealth_sources/ward_stealth-links.json. Livraison : docs/fidelity_registry_ward_stealth_links_reward_stealth_4_20.json. Les sept tâches et le Goal restent ouverts.
