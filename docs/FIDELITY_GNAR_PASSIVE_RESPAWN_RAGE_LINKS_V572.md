# SYS-01.2-02 — Gnar : rage après réapparition publique, V572

Date UTC 2026-10-26T00:40:30.081220+00:00. F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus,catalogue4.20.1 distinct.

## Résultat et intégration

Les trois fiches CH-Gnar-PASSIF-SOURCE,CH-Gnar-PASSIF-SIMULATION-CONTRAT et CH-Gnar-PASSIF-SIMULATION,ainsi que SYS-01.2-02,reçoivent de nouvelles preuves et instructions. Les24 sources natives et24 points de code déjà reliés par V571 sont conservés et réutilisés. **Aucun doublon de lien natif ou consommateur ajouté.** Quatre sources de preuves supplémentaires enregistrées. Trois inconnues propres et quatre dépendances conservées.

V571 ne pouvait pas mesurer le gain de rage : la jauge était déjà pleine à100/100. Le présent lot exerce une mort puis une réapparition ordinaires et observe ensuite la ressource à0/100. Dans cette situation non saturée,aucun gain de rage n’est observé pendant les attaques émises ou reçues. Cela précise un écart du moteur actuel ; la formule native,la valeur initiale native et la transformation restent non qualifiées. Aucun gameplay ni asset modifié.

## Essais réellement exécutés

Trois simulations Map10 séparées,Gnar bleu et Annie rouge. Déplacements publics vers les points proches de x7534.9819 et7684.9819,z7000,ajustés par le vrai navigateur. Annie reçoit un ordre d’attaque jusqu’à la mort de Gnar,puis Stop. La simulation avance jusqu’à la réapparition effective ; les personnages rejoignent ensuite les points de test par Move/Stop. Aucun changement direct de santé,position,ressource,XP,rang,or ou effet,ni événement artificiel de dégâts.

| Cas | Impacts pour la mort | Délai de réapparition | Impacts après réapparition | Ressource après/finale | Refus | Suivi |
|---|---:|---:|---:|---|---:|---:|
| respawn_idle | 14 | 480 ticks | 0 | 0.0/0.0 | 18 | 600 ticks |
| respawn_outgoing_attacks | 14 | 480 ticks | 6 | 0.0/0.0 | 18 | 600 ticks |
| respawn_incoming_attacks | 14 | 480 ticks | 6 | 0.0/0.0 | 18 | 600 ticks |

Les trois morts surviennent après14 impacts d’Annie chacune,soit42 impacts de préparation. Chaque impact est associé à un projectile présent au tick précédent ; les pertes correspondent à la mitigation physique courante,la régénération et le plafonnement du coup létal étant pris en compte. La réapparition survient exactement au tick annoncé,480 ticks après la mort,soit16 secondes à30Hz. La santé revient au maximum et la ressource passe de100 à0. Le contrat natif d’initialisation ou de rage n’est pas déduit de ce comportement courant.

Après réapparition,le cas au repos et les deux séries de6 attaques émises/reçues conservent la ressource à0/100. Chaque série est suivie sur600 ticks,soit20 secondes ; total1800 ticks. Les12 impacts postérieurs sont associés au projectile source/cible attendu et suivent la mitigation physique avec résidu inférieur à0.002. Les statistiques suivies restent identiques dans chaque scénario. Le seuil de transformation n’est pas atteint et aucune capacité n’est exécutée : ce lot ne valide ni déclenchement,ni durée,ni expiration de Mega Gnar.

Les54 refus atomiques comprennent9 commandes pendant la mort (Move,Attack,Cast dans chacun des trois cas),puis45 commandes après réapparition (joueur inconnu,attaque de soi,slot invalide et12 Learn/Cast/CastAt par cas). Les snapshots sont identiques avant/après chaque refus.

## Échecs conservés et attribution des dégâts

Le diagnostic initial près de la voie compile(code0),mais l’exécution échoue(code101) sur une attribution de projectile. Un second binaire d’observation compile(code0) et reproduit cet échec(code101) en enregistrant les états avant/après.

Au tick3048 du cas d’attaque émise,Annie perd10.0654296875 points corrigés de la régénération. Aucun projectile de Gnar ne figure dans l’état précédent ; son projectile48 dégâts,id19,vitesse1500 vient seulement d’être créé dans l’état suivant. Des sbires bleus ciblent également Annie. Cette baisse n’est donc pas comptée comme impact démontré de Gnar. La source exacte de cette baisse n’est pas qualifiée par ce seul diagnostic.

Le successeur utilise une autre zone rejointe par commandes publiques et passe toutes les assertions d’attribution. Il ne retire ni sbires,ni monstres,ni règles du moteur. Les deux essais échoués,sources,manifestes,verrous,binaires,commandes,journaux et capture sont conservés et pinés dans INPUTS_BEFORE.previous_artifacts du successeur. Ils ne sont ni effacés ni requalifiés en réussite.

## Sources et consommateurs

Les26 payloads natifs candidats et13 références communautaires de V571 sont revérifiés par taille/SHA ; les24 descripteurs de consommateurs sont identiques et leurs ancres relues. Les décodages natifs et comparaisons RADS antérieurs sont réutilisés avec identité d’octets vérifiée,**sans prétendre avoir rejoué le parser ou le contrôle de membership**.

Les chemins pertinents existants sont join/mana: def.mana,advance_respawns et son filtrage Mana/Energy/Wind,les attaques/dégâts,regeneration_rates/restores_resource,stats et les commandes. Gnarfury n’est pas dans les types remis au plein à la réapparition : le chemin courant lui affecte0. La régénération ordinaire de ressource reste0. Le défaut de génération à l’attaque/combat est maintenant observé depuis cette jauge vide dans les cas testés. Les frontières du code ne sont pas promues en implémentation complète du passif.

Les sources natives restent celles décrites dans [V571](FIDELITY_GNAR_PASSIVE_RAGE_GENE_LINKS_V571.md) :Gnar/GnarBig,GnarPassive,états de rage/transformation/fatigue,15 secondes et paramètres f1/f2/f3/f4/f5/f7/f8. Les limites NEWTABLE de cinq Lua restent ouvertes ; les constantes20/18/16/14/12 et RocketTristana ne sont pas adoptées comme règles de fatigue. WProc/Hyper reste distinct. Aucune absence de texture,modèle ou animation n’est déduite de ces essais.

## Vérification de la livraison

Exécutable du successeur : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-gnar-public-respawn-rage-center.exe`,6059520 octets,SHA256 `94b11682bd9e9c5a3361e988862ea1ca19430fcabbaf04db850293b31d3a2b45`. BUILD/RUN code0 ; openleague_core non-test,verrou privé aligné sur les identités/checksums racine.1158 entrées core/ressources et chaîne historique conservées. Aucun jeu/serveur historique exécuté,aucun rendu ou transport réseau qualifié.

Inspection,prepare,check,publish,audit : code0. Le vérificateur de livraison est adapté à l’absence de nouveaux liens :les42215 fragments génériques de trace restent identiques,puisque ce lecteur n’affiche que les premiers liens natifs/consommateurs. **Les instructions complètes des quatre destinataires contiennent bien la preuve V572 et ses limites**,vérifiées via Store.copy_text. Le préparateur original est conservé,le script de vérification distinct est piné dans CANDIDATE_CHECK.72 associations invalides et4 graphes invalides refusés.

Dans chacune des deux bases SQLite :4 destinataires mis à jour,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques conservés. Intégrité,résolution des sources/questions/dépendances et synchronisation idempotente contrôlées. Identifiants,hiérarchie et inconnues restent identiques en octets. Les descripteurs existants des sources et consommateurs sont inchangés.

Revue globale fraîche :42215 exigences,98964 sources,3360 consommateurs ;3360 ancres exactes,zéro divergence.26189 questions ouvertes/5517 résolues inchangées. Cette revue structurelle ne re-hashe pas toutes les sources et n’est pas un pourcentage de jeu terminé.

## Travail restant et fichiers

- Qualifier les valeurs natives de rage,la génération/décroissance,les seuils et délais,la quantité initiale,mort/réapparition et fatigue.
- Qualifier et intégrer les paramètres de statistiques,le changement de forme,le remplacement des sorts et les interactions.
- Vérifier séparément réseau,HUD,animations,VFX et audio ; garder les inconnues ouvertes jusqu’à leurs preuves propres.
- Conserver le défaut de déplacementV564 : les routes de ces essais ne le corrigent pas.

Modifiés : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json ; reçu reference_requirement_trace_sources/gnar-passive-respawn-rage-links-v572.json ; preuve fidelity_gnar_passive_respawn_rage_links_v572.json. Couverture,plan,checkpoint,CURRENT,HANDOFF et deux bases actualisés avec sauvegardes. Scripts/journaux/observations :revision572_Gnar* sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun statut,case ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision573_trace_review/REVIEW.json. V572 réutilise les24sources/24consommateurs de Gnar V571 sans doublons et ajoute les preuves après réapparition :3morts publiques,42impacts de préparation,480ticks de délai,ressource100→0 puis0/100 pendant6attaques émises,6reçues et1800ticks de suivi;54refus. Le gain nul après respawn est maintenant observé hors saturation,mais formule native,initialisation et transformation restent ouverts. Deux diagnostics de voie BUILD0/RUN101 conservés :baisse de santé sans projectile source attendu au tick3048,capture disponible;successeur zone centrale BUILD/RUN0. Préserver revision572_Gnar_respawn_center/INPUTS_BEFORE.previous_artifacts et toute la chaîne. Vérificateur de livraison distinct adapté aux0liens nouveaux :fragments génériques inchangés,texte copiable complet mis à jour et vérifié. Aucun statut/case/inconnu fermé. Reprendre ensuite un autre passif de la file après inspection réelle,par exemple Gragas. Défaut déplacementV564 ouvert;goal actif.
