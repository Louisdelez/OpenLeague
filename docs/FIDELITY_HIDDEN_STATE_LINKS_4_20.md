# Informations cachées et audiences — liens V106

Sept exigences liées à14 consommateurs partiels du protocole local. Aucun lien natif inventé,aucun objectif de confidentialité globale clôturé.

## Recherche antérieure conservée

Les mentions non intégré décrivent la phase préparatoire. La livraison et son contrôle final sont identifiés ensuite.

# Filtrage des informations cachées — recherche V106

Objectif SYS-01.2-02 ;sept exigences SYS-13.3. Le tour précédent V105 a intégré sept exigences et audité les deux bases. Cette étape produit des preuves fraîches,mais ne clôture pas les objectifs de confidentialité.

## Contrat courant

31 champs sont recensés dans Snapshot. snapshot_for retire les joueurs/unités cachés et utilise des projections distinctes pour les attaques,projectiles et capacités. snapshot_for_atomic ajoute des canaux de la route locale OLSR et le récapitulatif de mort du destinataire. Le serveur legacy utilise snapshot_for avant state_datagrams ;session_host utilise snapshot_for_atomic avant current_state_packets. Ce protocole est local,explicitement distinct du réseau historique LoL.

Une référence textuelle à un champ n'est pas une preuve de filtrage complet. Le roster,les résultats,kill_events et les diagnostics demandent une qualification séparée de leur portée publique. Les événements de mort contiennent identités,assists,first_blood et killer_gold,sans position ;l'absence de position n'établit pas à elle seule leur politique d'audience historique.

## Dix tests exécutés

Chaque commande cargo --locked --offline sélectionne exactement un test. Quatre tests core couvrent snapshots cachés,perte de poursuite,audience des attaques et retrait de présentation. Quatre tests client couvrent minimap/retrait d'entités,voix Ezreal R à perte de visibilité et observation des révocations entre trames reçues. Deux tests serveur couvrent récapitulatif privé par route authentifiée et omission atomique à la limite de trame.

Les dix passent ;commandes,noms,logs et empreintes des binaires sont dans hidden-state-tests.json. Il s'agit de simulateurs contrôlés,de fixtures CPU et d'adaptateurs locaux. Le test de session utilise les routes hôte puis un nouvel encodeur d'époque ;il ne réalise pas une partie réseau complète avec déconnexion physique. Le test audio vérifie les objets de voix et l'absence de rejeu,pas une écoute ni tous les sons positionnels. Aucun GPU ou client historique exécuté.

## Limites précises à traiter

SYS-13.3-01/02 :vérifier tous les canaux qui pourraient exposer position,ressources ou buffs ;retirer le Champion masque ses champs,mais ne suffit pas à qualifier les journaux annexes.

SYS-13.3-03/04 :relier chaque journal d'effet et chaque famille audio à son producteur d'audience ;les attaques et le R d'Ezreal ne représentent pas l'intégralité des effets/sons.

SYS-13.3-05/06 :la minimap testée retire les marqueurs absents. health::update enlève les barres absentes après disponibilité du snapshot,de la caméra et de sa transformation ;les retours précoces méritent une vérification propre. Ne pas déclarer le nettoyage de toutes les interfaces prouvé par la seule minimap.

SYS-13.3-07 :qualifier le parcours complet d'authentification,reprise,trames anciennes et état autorisé reconstruit. Le récapitulatif privé testé est une partie seulement de ce périmètre.

## Suite

Construire les associations exactes,identifier les contrats locaux explicites et les éventuelles sources natives pertinentes,qualifier le lecteur et ses refus,puis intégrer au registre et aux deux bases. Les comportements non établis restent ouverts. V105 reste la dernière livraison intégrée ;les cases sont inchangées.


## Contrat local explicite et livraison finale

Les sources de contrat sont le code actuel Snapshot/vision,attack_presentation et les routes session/legacy,leurs tests et le relevé de portée. attack_presentation indique explicitement un protocole local distinct du wire original. Les preuves ne permettent donc pas d'ajouter des sources natives de protocole à ces sept exigences ;leurs native_inputs existants sont conservés sans substitution.

Le lecteur vérifie37 fichiers et85 contrôles. Sa qualification contient37 cas,un nominal et36 refus de preuves ou de portée altérées. Les dix tests déjà exécutés dans cette révision sont conservés avec logs/binaires réinspectés. Le registre et les deux bases reçoivent sept exigences plus SYS-01.2-02. Les cases et inconnues restent ouvertes. Le résultat effectif des contrôles de livraison est dans docs/fidelity_registry_hidden_state_links_revision_4_20.json.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-13.3-01 | Current snapshot_for removes hidden players and units before legacy serialization;atomic route begins from this projection. | Qualify every auxiliary position/history channel and native/local policy;31 fields are a census,not complete confidentiality. |
| SYS-13.3-02 | Removing the whole hidden Champion/Unit removes their embedded buff/resource fields;separate journals are not covered by this fact. | Audit each journal,score,result and optional channel for private resources/buffs and authorize each public field. |
| SYS-13.3-03 | Attack journal combines supplied historical audience and current source visibility;targeted tests verify rejection and pending-event retirement. | Qualify audiences for every other effect family and original producer policies;local journal limits are not Riot constants. |
| SYS-13.3-04 | Ezreal R OnCast audio retires on connection/fog/death/model/authorization gaps without replay in the tested CPU path. | Audit every positional sound family and actual playback;one voice fixture does not prove all sound confidentiality. |
| SYS-13.3-05 | Minimap consumes filtered actors and its marker-removal test passes. Health bars consume filtered snapshot actors. | Qualify health-bar cleanup on missing snapshot/camera/transform and all UI caches;no fresh GPU observation. |
| SYS-13.3-06 | Minimap retires owned entities/materials when sources disappear;health update despawns absent actors after its preconditions. | Qualify all public-state caches and early returns under vision/session changes;do not equate one UI cleanup with global cleanup. |
| SYS-13.3-07 | Authenticated host projects each route through snapshot_for_atomic;decode_datagram separates local session context. Tests isolate own death recap and revoke audio between received frames. | Qualify full reconnect handshake and every restored channel with stale/foreign frames;tested recap/new sender epoch is not an ordinary full reconnect match. |

Reçu : docs/reference_hidden_state_sources/hidden_state-links.json. Livraison : docs/fidelity_registry_hidden_state_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
