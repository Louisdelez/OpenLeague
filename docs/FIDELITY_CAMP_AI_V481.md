# SYS-01.2-02 — Aggro et reset des camps, V481

Les14 fiches CAMP-00..06-AI et CAMP-00..06-SOURCE-RESET sont enrichies dans les registres et les deux bases du plan, avec leurs sources, consommateurs et inconnues propres. Aucune case, note ou entrée d'historique manuel n'est modifiée ; aucun code de gameplay ou asset n'est changé.

Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague. CAMP-00..05 désignent les camps1..6 et CAMP-06 le camp8 Vilemaw ; la relique native7 reste séparée.

## Sources et portée

Six scripts natifs sont réidentifiés et reparsés : Leashed, Aggro, Idle, AIComponentSystem, AIComponentOutOfCombatRegen et NeutralMinionSpawn. Constantes, instructions et empreintes des fonctions sont comparées aux preuves conservées. Les sept INIBIN de monstres sont redécodés : champs présents et absents, notamment MoveSpeed, AttackRange, AcquisitionRange, AIFile, AIScript et AIFileName, restent distincts.

La sélection effective du script d'IA par le moteur natif reste inconnue. Les scripts sont des candidats identifiés, pas la preuve qu'un camp charge chacun d'eux. Leurs helpers de ciblage, compteurs de poursuite, scheduler et composant de régénération ne sont pas qualifiés comme un serveur complet.

Les78 observations Lua historiques sont relues et leurs résultats attendus/observés concordent ; elles ne sont pas rejouées. Elles reposaient sur des adaptateurs d'API et de dispatch. Leurs limites sur FindTargetNearPosition, le plafonnement de SetHP, le soin réellement appliqué et le choix du composant sont conservées. Le seuil local800 ne devient pas le rayon natif850 par simple substitution ; les autres distances et compteurs natifs restent des paramètres de fonctions différentes.

Neuf ancres actuelles sont ajoutées : provocation des membres, conservation de cible, frontière d'acquisition par proximité, seuil de retour, restauration de santé, garde d'attaque engagée de Vilemaw, déplacement, planification et résolution d'attaque. Elles sont distribuées selon AI ou RESET ; la garde propre à Vilemaw ne figure que dans ses deux fiches.

## Vérifications réellement exécutées

Un nouveau programme Rust est compilé/exécuté contre la bibliothèque coreV476 après revalidation de ses entrées, de ses outils, de la bibliothèque et des dépendances. Aucun nouveau cargo build du cœur n'est revendiqué. Reçu : revision481_runtime_checks_retry2/CURRENT_CAMP_AI.json ; commandes, journaux, binaire et observations y sont identifiés.

112 scénarios :7 camps ×2 équipes ×8 profils ;272 contrôles de membres. La vraie grille de navigation est utilisée. Les positions, santé, ticks et next_attack sont contrôlés ; les attaques sont désactivées dans ces112 scénarios pour isoler l'aggro et le reset. Les dégâts passent par apply_damage. Aucun client graphique ni moteur Riot lancé.

| Scénario | Attendu et observé |
| --- | --- |
| Proximité seule | Pas d'acquisition automatique de cible dans le chemin de monstre observé |
| Dégât sans source | Pas de provocation ; santé conservée au tick suivant puis restaurée au prochain cycle d'IA |
| Dégât de joueur | Les membres vivants du camp ciblent le joueur et leur cycle d'IA est réveillé |
| Cible morte | Cible effacée et santé maximale rétablie au prochain cycle d'IA |
| Cible retirée | Même reset après remove_player |
| Distance exacte800 du point d'origine | Cible conservée et santé diminuée conservée |
| Distance exacte801 | Cible effacée, santé maximale rétablie, chemin de retour demandé |
| Cible éloignée de2000 | Conservée par les camps mobiles ; abandonnée par Vilemaw sans attaque engagée |

Les frontières800/801 sont construites sur le côté négatif de X pour obtenir ces distances exactement en f32 avec les coordonnées de cette carte. Elles ne prouvent pas toutes les directions et tous les arrondis. Le reset ne démontre pas l'arrivée finale au point d'origine : les chemins et premiers déplacements sont relevés, mais aucune trajectoire complète avec tous les obstacles n'est acceptée.

Les observations comportent172 états de membres réinitialisés et100 conservant leur cible. Les34 membres des cas sans source attendent leur échéance d'IA précédente : par exemple santé990 au tick3001, santé1000 au tick3008 pour le grand spectre. Ce délai est distinct du réveil provoqué par un dégât attribué à un joueur.

## Attaque engagée de Vilemaw

Deux scénarios supplémentaires, un par équipe, laissent cette fois l'attaque normale actuelle se déclencher. Le joueur est d'abord à200unités du boss, puis déplacé à2000après l'engagement. Les deux résultats concordent :

- Début au tick18001, résolution au tick18031.
- La cible reste conservée pendant l'attaque engagée, malgré sa sortie de portée.
- Le coup est réellement accepté et réduit la santé du joueur ; un événement Started puis un unique Resolved avec succès sont observés.
- Reset au cycle d'IA suivant, tick18033 : cible effacée, santé maximale du boss et position stationnaire conservées.

Cette politique est une reconstruction locale déclarée dans le code. Elle ne prouve ni les sorts spéciaux de Vilemaw, ni toutes les annulations, changements de cible, contrôles, projectiles ou présentations natives. Les scénarios précédents désactivant les attaques ne sont pas utilisés pour effacer cette exception.

## Essais corrigés et contrôles

Deux premiers programmes ont échoué, avec sources et journaux conservés :

1. Attente incorrecte d'une restauration dès le tick suivant un dégât sans source. Le programme attend maintenant la vraie échéance next_ai et conserve aussi l'état au premier tick.
2. Attente incorrecte d'une distance exactement800 après addition en f32 : un cas mesurait800,0005. La construction a été déplacée vers X négatif et la distance exacte reste vérifiée ; le seuil du moteur n'a pas été modifié.

Le troisième programme réussit. Il n'efface pas les deux échecs ni ne les transforme en succès. Aucun correctif de gameplay ne découle de ces ajustements du programme de mesure.

Contrôles supplémentaires :18 refus de scripts malformés (trois altérations par script),15 sélecteurs nominaux et16 invalides ;3 refus du lecteur public pour mauvais propriétaire, résolution indue et condition de résolution vide. Les42 214 instructions sont comparées :14 changent et42 200 restent identiques. Toutes les autres exigences et inconnues sont conservées, notamment V479/V480.

Publication et relecture indépendante :15 fiches par base ;42 606 états/notes,23 historiques et42 591 autres lignes du catalogue conservés exactement ; intégrité SQLite correcte. Les fichiers directement épinglés et entrées de compilation sont vérifiés séparément de la seule structure du graphe.

## Limites et suite

Restent ouverts : sélection native des scripts et helpers, rayon et compteur effectifs, contrôle/reprise de poursuite, soins du composant natif, retour complet de tous les membres, reset des timers/effets/orientation/animation, attaques et cadence ordinaires, sorts de Vilemaw, rendu, son et comportement en partie complète. Les14 questions restent ouvertes ; aucune acceptation humaine ou globale déduite des tests.

Modifiés : quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json ; deux bases du plan ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu, asset ni donnée manuelle modifié.

Nouveaux livrables : docs/reference_camp_sources/camp-ai-v481.json, docs/fidelity_camp_ai_v481.json et ce rapport. Scripts et preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision481*. Les dossiers runtime_checks et runtime_checks_retry gardent les échecs ; runtime_checks_retry2 contient l'exécution réussie.

Sous-inventaire du chargeur :237 associations encore génériques,279 partielles et24 exclusions conservées dont12 audio. Il reste14 fiches de camps dans ce sous-inventaire : SOURCE et ACCEPT pour chacun des7 camps. La suite reliera ces agrégats à leurs preuves et limites sans confondre leur réunion avec une validation en partie. Goal actif.

Ajouts :82 liens natifs,109 liens consommateurs,9 ancres,2 sources,14 questions ouvertes,0 résolution. 55 fichiers directement épinglés. Graphe :98637 sources,2479 consommateurs,25614 ouvertes,5517 résolues avec historique.
