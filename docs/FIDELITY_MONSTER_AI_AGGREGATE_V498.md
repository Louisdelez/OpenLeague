# SYS-01.2-02 — Agrégats AI des sept monstres Map10, V498

Projet F:/OpenLeague. Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement inconnus ; catalogue4.20.1 distinct. Cette livraison associe sources, consommateurs et preuves. Elle ne clôture pas une IA, un monstre ou le jeu complet.

## Résultat

Les7fiches WORLD-{TT_NGolem,TT_NGolem2,TT_NWolf,TT_NWolf2,TT_NWraith,TT_NWraith2,TT_Spiderboss}-AI sont reliées à leurs5facettes : AI-CIBLE, AI-ATTAQUE, AI-POURSUITE, AI-RESET et AI-MORT. Les35facettes et leurs35questions sont conservées exactement. Leurs dépendances correspondent exactement à celles des parents ; aucun critère n’est affaibli.

Les91fiches antérieures incluses dans les preuves de camps, source, mort, ciblage, poursuite, attaque et reset restent exactes avec leurs questions.7questions propres aux agrégats exposent l’écart entre la réunion des preuves partielles et le critère de comportement autoritaire sur chemin ordinaire.

163liens natifs et331liens vers des consommateurs existants sont ajoutés, sans nouvelle ancre ni code de gameplay. Une source documentaire est enregistrée. Les entrées/métadonnées conservent leur qualification propre : la présence d’un chargeur ne transforme pas toutes les facettes en comportement complet.

## Chemin serveur courant inspecté

Huit repères de source sont réidentifiés et vérifiés à leur ligne réelle :

| Étape | Consommateur actuel | Portée |
| --- | --- | --- |
| Chargement | server/main.rs : game.enable_map10 | Map10 est initialisé dans le source |
| Scheduler | server/main.rs : garde pause,échéance et catchup<5 | Politique locale de ticks, pas horloge native qualifiée |
| Tick serveur | server/main.rs : game.advance | Point d’appel actuel ; aucun serveur lancé dans ce lot |
| Simulation | core/lib.rs : self.advance_world | Dispatch du monde avec gardes de fin de match |
| Monde | core/world.rs : self.advance_npc_ai | Dispatch de l’IA ; les facettes identifient les branches applicables |
| Publication serveur | server/main.rs : sessions.states | Envoi d’états selon la cadence locale ; pas preuve de réception réseau |
| Destinataire | server/session_host.rs : snapshot_for_atomic | État lié au contexte joueur accepté |
| Projection | core/vision.rs : filtre des unités visibles | Filtre courant par équipe ; pas fidélité native complète du brouillard |

Ces repères sont ajoutés comme références de chemin statique. Le consommateur existant ordinary_simulation_world_dispatch rejoint les parents ; il conserve sa qualification partielle et ses gardes terminales. Une chaîne de code lisible ne démontre pas l’exécution de l’exécutable serveur actuellement installé, un échange réseau, une scène rendue ou une partie ordinaire complète.

## Preuves héritées réidentifiées

Aucun build ni scénario de jeu n’est exécuté dans V498. Les cinq programmes suivants sont réidentifiés avec leurs scripts, commandes, journaux, binaires, bibliothèque, outils et ressources. Leurs entrées concordent toujours avec les fichiers courants. Leurs tests n’ont pas été rejoués.

| Révision | Preuve conservée | Limite principale |
| --- | --- | --- |
| V479 |7camps,17membres : naissance et réapparition | Sauts d’horloge et paramètres locaux ; montage/horloge natifs ouverts |
| V480 |112scénarios de récompenses,272morts | API de dégâts contrôlée ; partage/portée/modificateurs ordinaires non acceptés |
| V481 |112scénarios AI,272membres,2attaques engagées de Vilemaw | Positions contrôlées,attaques inhibées sauf les2coups ; choix des scripts natifs inconnu |
| V496 |112scénarios de priorité/provocation,272membres | Dernier dégât joueur/pet,positions et next_ai contrôlés ; pas priorité native démontrée |
| V497 |97cas d’attaque et21cas de retour/reset | Attaques sur clones sans AI/home ; retours sur spawns avec positions forcées |

Les scénarios se recouvrent par camp et facette. Ils ne sont pas additionnés comme de nouvelles parties indépendantes ni comme des validations complètes. Les anciens essais refusés et leurs limites restent conservés dans les dossiers de preuves ; leur présence n’est pas convertie en réussite.

## Limites maintenues dans les parents

- Acquisition, sélection et réacquisition natives : choix de Leashed/Aggro/Idle, helpers, priorités et compteurs restent ouverts. Les valeurs475 locales des wolves/wraiths ne deviennent pas des champs natifs retrouvés.
- Le dernier dégât positif attribuable à un joueur ou au propriétaire d’un pet remplace la cible dans les scénarios locaux. Une source joueur forcée morte peut être admise par l’API puis rejetée au poll ; les règles des appelants ordinaires restent à qualifier.
- Temps d’attaque, cadence, annulations, contrôles, effets et modificateurs complets ne sont pas acceptés comme règles historiques.
- Variantes natives : petit spectre à750ou0 selon le sort candidat ; Vilemaw avec plusieurs vitesses de ressources contre0dans le chemin générique local. Le choix effectif reste non établi.
- Retours :12parcours mobiles déplacés et7cas au home terminent dans le seuil local5avec chemin vide ; un grand spectre s’arrête à3,264643unités. Deux déplacements forcés du boss restent immobiles pendant120ticks à vitesse0. Ni tous les terrains, ni une arrivée exactement au centre, ni une mobilité/immunité native du boss ne sont démontrés.
- Vilemaw :le stun est explicitement refusé pour politique non qualifiée ; les sorts spéciaux et toutes les annulations ne sont pas raccordés par cette réunion de preuves. Pour TTBossBuff, le raccordement courant n’est pas démontré dans la portée inspectée ; aucune absence globale n’en est déduite.
- Récompenses :champs natifs absents, défauts locaux, crédit joueur/propriétaire, bonus autels, partage et bénéficiaires ordinaires restent séparés. Les valeurs disponibles ne prouvent pas toute l’économie du serveur historique.
- Partie ordinaire, réseau, présentation GPU/audio et validation humaine restent à démontrer. Les preuves privées et binairesV476 restent des dépendances locales ; portabilité non établie.

L’agrégat exige toujours : « Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes. » Les preuves disponibles ne suffisent pas à clôturer ce critère. Aucun enfant ni parent n’est accepté automatiquement.

## Contrôles actuels

1355identités directement revérifiées.42214instructions comparées :7modifiées,42207inchangées. Les35facettes,91fiches antérieures, dépendances et critères sont exacts.8sélecteurs nominaux et9invalides ;4refus de composition (facette absente, dupliquée, autre profil, type inattendu) et3refus du lecteur public (mauvais propriétaire, fausse résolution, condition de résolution absente).

Publication et audit indépendant avec les quatre registres et le vrai Store.task/copy_text des deux bases. Les cases/notes des42606lignes et23historiques restent exacts. Aucune modification du moteur ou d’asset ; aucune coche. La préparation et les contrôles candidats ont réussi sans nouvel échec ; la chaîne statique n’a pas été lancée comme serveur.

## Livrables

- docs/reference_monster_behavior_sources/monster-AI-aggregate-v498.json :7associations,35facettes,5programmes de preuves,8repères statiques et limites.
- docs/fidelity_monster_AI_aggregate_v498.json :preuve de publication et des bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json :registre enrichi avec7questions propres ouvertes.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md :couverture et reprise.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision498 :baselines, préparation, contrôles candidats, audit, sauvegardes et point de reprise.

Goal SYS-01.2-02 actif. Suite :les7fiches PRESENT-MODEL de monstres ; vérifier les modèles effectivement sélectionnés, sources natives, géométrie/squelette et consommateurs avant toute reconstruction, en conservant les questions AI ouvertes.

Bilan final vérifié :163liens natifs,331liens consommateurs existants,0ancre,1source,7questions ouvertes,0résolution. Graphe :98678sources/2554consommateurs/25781inconnues ouvertes/5517résolues avec historique. Deux bases :8lignes documentaires actualisées,42598autres lignes exactes,42606états/notes et23historiques conservés,intégritéok. Sous-inventaire70à reprendre,438partielles,32exclusions ouvertes ;aucun pourcentage de jeu terminé. Publication et audit réussis.
