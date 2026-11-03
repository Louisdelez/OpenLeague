# SYS-01.2-02 — Ressources secondaires, V794

La fiche SYS-05.4-08 et la tâche de traçabilité SYS-01.2-02 sont enrichies sur F:/OpenLeague. Neuf liens réutilisent des ancres existantes : treize consommateurs sont maintenant associés à la fiche, y compris son lecteur dans le plan. Aucune mécanique de production n’est modifiée, aucune case n’est cochée.

## Référence et limites natives

Quatorze fichiers de LoL4.20.0.315 EUW/en_GB sont relus et concordent avec les manifestes RADS sélectionnés. Les copies de catalogue/manifeste conservées sur E et F correspondent ; E reste une référence historique en lecture seule. Les INIBIN, scripts et texte de menu établissent des identités et descriptions, pas les callbacks du serveur.

Les cinq chunks Lua sélectionnés sont entièrement parsés et ne contiennent aucun prototype de fonction enfant. Annie nomme « Pyromania Marker ». Ezreal nomme « EzrealRisingSpellForceBuff », alors que le chunk disponible initialise « EzrealRisingSpellForce ». Le texte lié indique10% pendant6secondes,5charges ; un ancien alias indique15% et Passive1Desc contient du texte d’Ashe. Ces divergences restent explicites et non résolues. Aatrox, Mordekaiser et Yasuo restent des références d’auteur, sans validation de leurs compteurs par ce lot.

REA6.4.0 a été invoqué pour vérifier la version installée. Les fichiers de preuve de l’analyse REA/Ghidra V793 et le PE original sont rehashés. Cette analyse de PARType reste héritée et distincte des compteurs secondaires : aucune nouvelle décompilation ni règle serveur n’est revendiquée ici. REA reste l’outil du goal pour les investigations binaires pertinentes.

## Contrôles exécutés

Commande : `cargo test --locked --offline -p openleague-core --test secondary_resource_observation -- --nocapture`.

Résultat final : code0,2 tests réussis,0 échec ;24 avertissements existants. Les sources, données, compilateur, binaire de test et journaux sont identifiés dans le reçu. Les contrôles utilisent les commandes publiques, apply_damage et le vrai Simulation.advance, avec navigation plate, positions, niveaux, rangs, équipes, vie et mana explicitement fournis.

| Parcours | Attendu du contrat local | Observé |
|---|---|---|
|Annie E|Monter jusqu’à4 sans dépasser|1,2,3,4,4 ; nouvelle commande en récupération refusée sans mutation du snapshot|
|Annie W|Consommer au relâchement et étourdir|Consommation au tick1508, étourdissement observé|
|Annie mort/réapparition|Effacer une charge active|1 avant mort,0 à la mort et à la réapparition au tick2430|
|Ezreal W|Gagner sur les contacts, pas sur le lancement|Cinq contacts aux ticks9,12,15,18,21 ; charges1 à5|
|Ezreal R au plafond|Rafraîchir sans dépasser5|Cinq contacts aux ticks52,54,56,58,61 ; expiration au tick241|
|Statistique et projection|Bonus temporaire, compteur propre au lanceur|Intervalle d’attaque43→30→43 ticks ; DTO propriétaire de3champs, absent des projections générique et des5adversaires|
|Refus pendant W|Refuser tant que l’incantation est engagée|« skill blocked during cast », snapshot inchangé|

Le premier essai a échoué car le banc attendait « skill on cooldown » pour Ezreal. Le dispatch refuse d’abord pendant l’incantation. Seul l’attendu du test a été corrigé ; source et reçu du premier essai sont conservés. La simulation avec cinq adversaires sert à tester plusieurs contacts : ce n’est pas une partie3v3.

## Intégration

Les nouveaux liens couvrent Annie E/W, la remise à zéro à la mort, Ezreal prune/getter/bonus de vitesse, leur appel par stats/advance et la projection individuelle. Les autres liens antérieurs restent conservés. Les deux bases du plan reçoivent seulement les deux fiches et leurs consignes copiables. Les états manuels, notes, historiques, prérequis et inconnues restent inchangés ; publication par deltas, sans sauvegarde intégrale supplémentaire. Une relecture indépendante vérifie les trois registres et les deux bases.

Fichiers ajoutés : crates/core/tests/secondary_resource_observation.rs, docs/fidelity_secondary_resource_lifecycle_v794.json et ce rapport. Registres enrichis : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Couverture, plan et reprise sont actualisés.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision794_secondary_resources/OBSERVATIONS.json ; revision794_current_secondary_final/RECEIPT.json ; revision794_delivery/.

## Restant ouvert

Les autres ressources secondaires nominatives, les callbacks serveur et leur ordre, les conditions de remise à zéro d’Ezreal non parcourues ici, les autres sorts/contacts et les priorités d’alias restent à qualifier. Les anciens tests UDP/VFX ne sont pas relancés et ne deviennent pas des preuves nouvelles. Aucun rendu, transport réseau, écran ordinaire ou jeu complet accepté. La tâche et le goal restent ouverts.
