# SYS-01.2-02 — Draven : Adoration, charges et or, V565

Date UTC 2026-10-25T22:56:06.048722+00:00. F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et déploiement inconnus ; catalogue officiel4.20.1 distinct.

## Résultat intégré

Les trois fiches CH-Draven-PASSIF-SOURCE, CH-Draven-PASSIF-SIMULATION-CONTRAT et CH-Draven-PASSIF-SIMULATION reçoivent 39 associations vers13 sources natives. Les deux fiches de simulation reçoivent48 liens vers24 points de code, qualifiés `entry_boundary_only`, `provides_feature_consumer=false` pour le passif. SYS-01.2-02 référence le lot. Les prérequis et quatre dépendances sont conservés, ainsi que les trois questions propres. Aucun gameplay modifié, aucun passif accepté.

## Sources natives et limites

| Fichier | Identifiant |
|---|---|
| Draven.inibin | OLS-de854af7-8098-58e8-9090-8d859ab32b6b |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptDraven.luaobj | OLS-2258e080-5901-564d-897c-fa413c7f4a71 |
| CharScriptDraven.preload | OLS-a29ebdd7-cb32-53c0-bac4-736c30fbbacb |
| DravenPassive.inibin | OLS-e25b6e7c-cb0f-58a0-af35-919377e4e75e |
| DravenPassive.luaobj | OLS-2b4cede4-872e-5dbe-970b-b0f720a6aab8 |
| DravenPassive.preload | OLS-450455f7-55c9-5c89-bbfd-f878c70d21d1 |
| DravenPassiveStacks.inibin | OLS-579ab8aa-141d-55d2-b7ed-2073152a10e6 |
| DravenPassiveStacks.luaobj | OLS-16451c34-7292-5f3a-8345-ab3073b4c3a4 |
| DravenSpinning.inibin | OLS-0cf93e84-0cac-5e06-b4f4-34c5da10a84c |
| DravenSpinning.luaobj | OLS-a778cd94-a8ad-5f40-a571-f614328448a4 |
| DravenSpinningReturnCatch.inibin | OLS-92d4a420-d911-5a8e-abca-2123df0ac25c |
| DravenSpinningReturnCatch.luaobj | OLS-a11678fa-71c5-56d9-a8cc-b977e9af3c80 |

Tailles/SHA256 vérifiés contre le registre ; tailles/MD5 conformes aux projets RADS sélectionnés. L’appartenance ne prouve pas la priorité historique de chargement.

Le tooltip natif `game_buff_tooltip_DravenPassive`, fontconfig_en_GB ligne1848, décrit une charge lors d’un rattrapage de hache ou d’une élimination de sbire, monstre ou tour. Une élimination de champion consomme les charges et donne un bonus fixe f4 plus f1 par charge. La mort retire la moitié des charges ; f2/f3 servent aux statistiques d’or. La description de personnage ligne4180 concorde. Les producteurs de ces variables, leur valeur exacte et les règles d’arrondi restent ouverts.

Trois liaisons distinctes conservées : Passive, PassiveStacks et Spinning. Le troisième tooltip concerne Q, pas le passif. Passive1LuaName et Passive1Icon concordent avec BuffName/texture de DravenPassive. Passive1, Passive1Desc et les six niveaux passifs recherchés sont absents ; aucune valeur de repli inventée.

Cinq Lua lus entièrement, sans prototype enfant. Quatre initialisations littérales reconnues. Le lecteur refuse l’initialisation DravenSpinning à `NEWTABLE atpc10` ; cela ne prouve ni corruption ni absence de données. CharScriptDraven a des globals littéraux vides. Passive et PassiveStacks déclarent PersistsThroughDeath/NonDispellable ; ces métadonnées ne prouvent pas le compteur ni la règle de perte de moitié. ReturnCatch déclare PersistsThroughDeath sans reconstituer l’événement de rattrapage.

Deux preloads sont inventoriés, sans qualification visuelle/audio. Sept sources communautaires exactes conservées comme références séparées : CharScript vide, stats, Q.cs explicitement simplifié, quatre ressources de sorts. Q.cs ajoute un buff DravenAxe et une particule ; ce code ne prouve pas une récupération de hache native ni la production de charges Adoration.

## Contrôles exécutés dans le moteur actuel

Programme privé utilisant le vrai openleague_core et Simulation/Map10. Création des joueurs, achats, déplacements, attaques, attente de réapparition et Stop passent par les actions publiques. Aucun ajout direct de santé, position, or, XP, dégâts ou effet.

| Scénario | Récompenses de sbires | Ticks des éliminations | Or net des deux éliminations | Refus |
|---|---|---|---|---|
| draven_fresh_kills | 0 | 2322 / 3943 | 400 / 300 | 19 |
| caitlyn_fresh_kills | 0 | 2399 / 4049 | 400 / 300 | 7 |
| draven_farm_then_kills | 3 | 9578 / 11261 | 400 / 300 | 19 |

Six éliminations de champions et123 baisses de santé observées chez les cibles.71 baisses ont un projectile du joueur dans le snapshot précédent ;52 n’en ont pas. Leur attribution exclusive au joueur n’est pas revendiquée. Le reçu de préparation utilisait le libellé imprécis `champion_impacts` ; la vérification et la publication le remplacent par `observed_target_health_decreases`, sans altérer les observations. La preuve des récompenses repose sur les événements de mort attribués au joueur et les variations nettes de son or.

Les récompenses nettes sont400 pour le premier sang et300 ensuite, identiques à la règle ordinaire du consommateur actuel et au témoin Caitlyn. Les paiements ambiants de8 aux frontières locales de75s puis5s sont retranchés par tick avant comparaison. Aucun supplément observé. Ces nombres ne sont pas une qualification des formules historiques de l’Adoration.

Après trois sbires crédités à Draven, le résultat reste400/300. Récompenses observées des sbires :13.800003051757812 au tick3685,18.999984741210938 au tick4120,19.20001220703125 au tick8611. Des projectiles du joueur et les morts correspondantes sont conservés ; ces montants concordent avec les récompenses ordinaires des unités. Le test ne prétend pas avoir observé trois charges internes : aucun compteur Adoration n’est qualifié.

45 refus publics avec snapshot inchangé : acteurs/cibles/objets/emplacements invalides, apprentissage et casts Draven non pris en charge, attaque des victimes mortes. Les réapparitions puis secondes éliminations passent par l’écoulement naturel des ticks.

Attendu selon le contrat natif partiel : charges et bonus spécifiques, avec producteurs f1/f4 encore inconnus. Observé : chemins ordinaires de récompense et aucune valeur supplémentaire dans ces cas. La recherche actuelle et les24 points relient les frontières de création, progression, attaque, dégâts, attribution, paiement d’or, réapparition et refus ; ils ne sont pas présentés comme l’implémentation complète de Draven.

## Identité et vérification

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-draven-passive-adoration-gold-probe.exe` ; 6084096 octets ; SHA256 `d99d2f34c5880f84aa44ea903052da8606b15d6ebaaa91d3fb8ef04fd0a9eeb3`. Build et run : code0. Cargo.lock aligné avec le projet, dépendance openleague_core non-test vérifiée.1158 entrées core/ressources et anciens artefacts exacts. Le reçu runtime inclut les sources, journaux et empreintes. Les preuves V564, y compris les deux diagnostics échoués, et les tentatives V563 restent conservées.

Inspection, prepare, check, publish, audit : code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite :4 destinataires vérifiés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques conservés exactement. Store.task,copy_text,summary,dépendances,rt.resolve,intégrité et synchronisation idempotente contrôlés.3 fragments de trace changés,42212 inchangés.

Identifiants, hiérarchie et inconnues identiques en octets. Revue fraîche du graphe :42215 exigences,98936 sources,3208 consommateurs ;3208 ancres exactes et fichiers courants conformes,zéro divergence.26189 questions ouvertes/5517 résolues inchangées. Cette revue n’est pas un recensement physique de toutes les sources ni une mesure d’achèvement du jeu.

## Ce qui manque et reste ouvert

- Producteurs natifs f1/f2/f3/f4, compteur, durée/persistance, consommation, perte de moitié et arrondi.
- Rattrapage effectif de hache, événements de monstre et tour, attribution par familier, assistance, décès de Draven et cas simultanés : non testés ici.
- HUD, synchronisation réseau, animations, VFX et sons du passif : non qualifiés.
- Le défaut de déplacement V564 reste non corrigé ; les parcours réussis ici ne l’annulent pas.

Ces lacunes ne démontrent pas des textures absentes. Les métadonnées client et déclarations communautaires restent distinctes du code serveur historique. Aucune tâche, aucun champion ni le jeu déclarés terminés.

## Fichiers

Registres `completion_tasks_2026-10-20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_sources_4_20.json` enrichis ; reçu `reference_requirement_trace_sources/draven-passive-adoration-gold-links-v565.json` ; preuve `fidelity_draven_passive_adoration_gold_links_v565.json` ; ce rapport ; couverture, plan, checkpoint,CURRENT,HANDOFF et deux bases du plan mis à jour avec sauvegardes. Aucun code gameplay ni asset modifié.

Continuer SYS-01.2-02 depuis revision566_trace_review/REVIEW.json. V565 Draven publiée/auditée:3fiches,13sources,39associations,24points/48liens de portée limitée. Trois scénarios publics(Draven frais,Caitlyn témoin,Draven après3sbires crédités):6éliminations champions400/300or seulement,123 baisses de santé observées,45refus atomiques. Pas de compteur/cashout Adoration qualifié. Native5Lua dont4littéraux et1NEWTABLE non pris en charge;3bindings,2preloads,7sources communautaires. f1/f2/f3/f4 et perte de moitié/arrondi restent ouverts. Q communautaire simplifié et CharScript vide ne sont pas les règles natives. Préserver INPUTS_BEFORE.previous_artifacts de revision565_Draven_passive_probe,qui conserve les trois probes V564,les deux diagnostics V564 échoués et la chaîne nearbyV563. Aucun statut/case/inconnu fermé. Reprendre le prochain passif restant à qualifier,par exemple Elise,après inspection de ses formes et consommateurs réels;ne pas traiter un chargeur générique comme le passif. Les annulations de déplacement V564 restent ouvertes et distinctes. Goal actif.
