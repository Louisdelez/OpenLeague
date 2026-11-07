# SYS-01.2-02 — Azir : sources et consommateurs des deux branches du passif

**V1185 — AUD-SYS-01.2-02-AZIR-PASSIF-SOURCE-CONSUMER-01.** Audit documentaire/statique borné terminé : identité et texte des sources reliés aux lecteurs, conversion CDR→AS et trajet SunDisc inspectés séparément, écarts et reprises précisés. **CH-Azir-PASSIF-SOURCE reste `a_qualifier`, sa trace `partial_with_open_questions`, son inconnue ouverte.** Un audit nouveau clos, zéro tâche, inconnue ou fonctionnalité close ; aucune exécution actuelle du jeu.

## 1. Question, contrat courant et prérequis

Cible : `CH-Azir-PASSIF-SOURCE`, **OLF-16408636-7d34-5837-b73f-7ae33e3038a5** ; inconnue **OLU-eac5b3b2-6c9e-5d8d-a11b-83ec748e7c9b**. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement non établis ; catalogue officiel 4.20.1 distinct.

La tâche requise demande de qualifier les règles4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions. Critère exact : **« Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve. »** Huit champs du contrat courant sont identiques au snapshot SOURCE V559 : ID, titre, type, required, required_if, dépendances, acceptance, preuves exigées. Ni implémentation ni acceptation complètes ; dépendance `CH-Azir-IDENTITE` encore `a_qualifier` et non acceptée.

Phase D06 et lot D06-CH-Azir gardent `depends_on:[]` ; lot `a_faire`, avec références `requires_packages` D04-SYS-04-1, D04-SYS-04-6, D05-SYS-05-2, D05-SYS-05-4, D14-SYS-14-2, D20-SYS-20-1. Leur satisfaction/consommateur n’est pas qualifié par ce lot ; les références SYS-01.1-01..07 restent `a_valider` avec acceptationfalse. Le contrat courant provient du cache partagé immuable : deux SHA d’entrée vérifiés, **zéro nouveau parsing du registre brut**. Ce cache122 SOURCE/1350contrats est une préparation, pas122audits clos ; changement d’entrée→nouveau snapshot versionné, sans remplacement de la preuve existante.

Critère de fin de **cet audit**, distinct de la fiche complète : relier sources/texte/contrat courant, lire les consommateurs et exceptions des deux branches, séparer démontré/inconnu, et donner reprise/correction précise. Résultat : **14/14 cohérences**, `PASS_STATIC_SOURCE_CONSUMER_AUDIT`, code0. La fiche SOURCE reste incomplète sur valeurs/exceptions/disponibilité ; aucun pourcentage du jeu n’est déduit.

## 2. Sources et acquis réutilisés

V559, du25/10/2026, est conservé : rapport `docs/FIDELITY_AZIR_PASSIVE_CDR_ATTACK_SPEED_SUNDISC_LINKS_V559.md`, preuve `docs/fidelity_azir_passive_cdr_attack_speed_sundisc_links_v559.json` (2681octets), et reçu `docs/reference_requirement_trace_sources/azir-passive-cdr-attack-speed-sundisc-links-v559.json` (**658239octets**, SHA **4c221c14dd3b9ed0c70c822f8963a7925f3148cdbe2c0bccc473250bd86f35b0**). La preuve est `passed:true`, mais `passive_accepted:false`, `SunDisc_activation_qualified:false`, `task_complete:false`. Les trois rôles SOURCE/CONTRAT/SIMULATION et leurs questions restent distincts.

Les **23 membres natifs sélectionnés V559** ont les mêmes identités que les23sources enregistrées et contrôlées dans l’extrait daté V1182. Aucun natif rehashé ou redécodé dans V1185. Leur tableau complet source_id/path/taille/SHA/MD5/release est dans `native_contract_review.json.native_memberships_reused_V559_V1182`, sans recopie des23lignes ici. Les petites preuves documentaires gardent leurs pins V1182. L’ancien reçu313identités incluait natifs, références et code ; il n’est pas relancé.

La SOURCE courante porte **29 relations natives /24 identités uniques**. Le membre supplémentaire par rapport à la sélection V559 est `DATA/Characters/Azir/CharScriptAzir.luaobj`, **OLS-7de61578-7b77-5cb2-9512-9e9955856102**,56octets, SHA `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0`, déjà connu et contrôlé V1182. Ce chemin à la **racine** ne contredit pas l’absence du sous-dossier `Azir/Scripts` dans l’emplacement choisi V559. Pas de nouveau fichier manquant, ni de décodage du56octets, ni d’absence globale de sources inférée.

Identité propriétaire Azir.inibin : **OLS-455f1e7f-eab0-565c-849f-a8272b6420fd**, SHA `d425d77b0811ff9bdfc2d91e23c61751bf9be065953b637036310875fff30986`. Azir, AzirSunDisc, AzirTowerClicker et le rôle nommé AzirSoldiersTowerClicker gardent leurs sources distinctes. Membership RADS et chaînes nommées ne qualifient pas priorité VFS, admission historique, serveur ou rendu.

## 3. Contrat natif : deux branches écrites, politiques encore inconnues

| Branche/objet | Documenté par la source | Limite ouverte |
|---|---|---|
| Will of the Emperor | Infobulle1697 : **1,25 %AS pour1 %CDR**, bonus courant `@f1@%` | `f1` est le placeholder du **bonus AS courant affiché**, pas un taux d’accumulation comme Ashe. Fournisseur/valeur affichée, unités, plafond, ordre, niveaux et arrondis serveur non qualifiés. |
| Disc of the Sun | Même infobulle : clic sur ruine, activation toutes les3min, désintégration sur1min, exclusion des ruines de tourelles Nexus/inhibiteur ennemies | Ruines admissibles, commande, propriétaire, création/stats/ciblage, interruptions, destruction, réactivation et politiques exécutées inconnues. Les3min/1min sont des textes, pas des chronométrages natifs. |
| Disponibilité SunDisc | Second binding1698, AzirPassiveAvailable : possibilité depuis une tourelle détruite | Nom d’état et texte ne prouvent pas sa production ou son admission dans le moteur courant. |
| Métadonnées/rangs | Passive1LuaName=AzirPassive, icône Azir_Passive.dds ; niveaux Azir absents ; acteurs et scripts nommés distincts | **TowerClicker1/4/7 n’est pas un rang du passif Azir** ; valeurs absentes non remplacées par défaut. |

Les deux bindings complets sont dans le sous-reçu ; la description en_GB4160 et le catalogue4.20.1 restent descriptifs. Le texte fixe1,25 ne suffit pas à démontrer une implémentation serveur ni une formule exécutée sur tous les cas.

V559 avait entièrement lu **11 Lua sans prototype enfant**, avec **huit limites NEWTABLE** du lecteur de littéraux : AzirIsChannelingPassive pc6, AzirPassive pc10, AzirPassiveAvailable pc12, TeleportBlocker pc8, Unavailable pc8, TowerBuff pc6, TowerBuffChaos pc6, TurretStatIncrease pc6. Les trois CharScript de la sélection donnent des globals littéraux vides. **Limites de lecture, pas corruption.** Cinq preloads et six références communautaires ne deviennent ni callbacks serveur original, ni règles de skin, ni rendu exécuté. La provenance JSON Stats décodé/INIBIN brut demeure distincte ; aucun nouveau défaut de hash n’est ouvert.

## 4. Consommateurs réels et résultats statiques par branche

Relecture actuelle : **24/24 ancres V559 +6/6 ancres SOURCE conformes ;21/21 fichiers nécessaires inchangés depuis V559** (12Rust,7JSON locaux,2lecteurs Python), empreintes stables durant la lecture. Treize pins communs V1183 et onze V1184 sont réemployés avec leurs intersections, pas additionnés en nouveaux fichiers. Les six CID SOURCE sont catalogue/lecteurs/hash helpers/inspection Lua ; leur scope d’audit ne prouve pas les fonctionnalités.

**CDR→AS.** `shop.rs215–245` somme séparément CDR et AS ; Codex3108 donne CDR0,1/AP30, Dague1042 AS≈0,15. `progression.rs88` expose la CDR plafonnée ; le dénominateur d’attaque118–128 utilise croissance, AS d’objet et modificateurs nommés, **sans lire la CDR ni un terme Azir**. Le chemin période→préparation→next_attack→libération reste ordinaire ; Azir lance un projectile2600, dont l’arrivée atteint `basic_attack_hit` puis dégâts physiques. Lancement et impact sont distincts ; ni cette attaque ni l’AS d’objet ne sont les soldats ou le SunDisc. Conclusion bornée : conversion CDR→AS absente de la formule inspectée, sans requalification du contrat historique complet.

**SunDisc.** Les corps de picking→commande→définition→spawn→mort→tick ont aussi été lus, et pas seulement un enum :

- `picking.rs43–86` filtre alliés/morts ; `main.rs1456–1507` émet Attack pour cible admise, sinon Move ou Cast/CastAt selon contexte. Aucun clic GUI sur une ruine effectué.
- Action n’a pas de commande SunDisc dédiée ; les handlers Attack gardent un ennemi vivant, et les routes cast/cast_at inspectées ne donnent pas de handler SunDisc. Les gardes d’état/protection peuvent refuser plus tôt que `invalid enemy target` : aucun nouveau refus n’est exécuté ici.
- `enable_map10` charge **27définitions/18structures** depuis map10_world.json, puis ajoute **Tibbers**, sans clé AzirSunDisc dans cette configuration. `spawn_unit` exige une définition ; `unknown NPC definition` est une branche lue statiquement avant allocation, pas un test réalisé. **Tibbers et le spawn générique ne sont pas SunDisc.**
- La mort conserve les structures ordinaires à zéroPV, prévoit240s pour l’inhibiteur et termine sur Nexus. Le tick gère camps/vagues/retraits/restaurations configurés. Ces trajets ne qualifient pas une ruine→activation→SunDisc avec propriétaire, statistiques, durée et recharge. Une structure morte conservée n’est pas son activation en Disque.

Conclusion bornée : pas de producteur/activation SunDisc qualifié dans ces handlers/configuration/corps inspectés. Les ressources natives SunDisc existent ; aucune absence globale d’assets ou scripts n’est conclue.

Une requête nouvelle précise cherche Azir/SunDisc/Shurima/TowerClicker dans **huit Rust nommés + map10_world.json**, neuf chemins : code1, zéro hit, journal `azir_named_body_world_search.txt`. Elle ne répète pas un scan global1149fichiers. Les conclusions reposent aussi sur les formules et appels lus ; alias, producteur externe et code hors périmètre non globalement exclus.

## 5. Attendu, observé et vérifications exécutées

| Contrôle | Attendu / observé |
|---|---|
| Contrat courant et prérequis | Bons rôle/OLF/critères ; huit champs SOURCE égaux à V559 ; identités/prérequis/acceptations gardés ouverts. Réemploi du cache avec deux SHA conformes,0parsing brut. |
| Réemploi des sources |23identités V559→V1182 conformes ;29relations/24SOURCE expliquées ; sous-reçu documentaire15/15 ; zéro hash/décodage natif nouveau. |
| Branche CDR→AS | Vérifier si CDR atteint la cadence : champs séparés et absence de terme dans la formule effectivement lue ; AS d’objet existante distincte. |
| Branche SunDisc | Identifier admission et producteur : routes ordinaires retrouvées, mais pas SunDisc qualifié dans ces corps ; aucun test GUI/ruine/création. |
| Contrôle courant |21pins +24/6ancres conformes ; recherche bornée neuf chemins, zéro hit attendu ; aucune absence globale inférée. |
| Intégration |**14/14 cohérences**, `PASS_STATIC_SOURCE_CONSUMER_AUDIT`, code0 : une seule unité d’audit, aucune fonctionnalité close. |

Exécutés : réemploi vérifié du cache via `reuse_current_task_contract.py` (0parsing des gros registres), `review_native_contract.py`, `review_current_consumers.py`, recherche nommée consignée et `integrate_azir_review.py`, avec Python existant `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B`. Les reçus E listent les observations/empreintes. L’intégration ne lit que les petites preuves et le cache ; aucun ancien script mutateur importé ou exécuté.

Les observations V559 restent datées, **non rejouées** : trois cas sans objet/Codex/Dague, **58/58/50ticks,18impacts,51refus**. Codex fournit CDR0,1/AP30 sans accélération observée ; Dague AS positif distinct. Ce résultat ancien concorde avec la formule lue, sans nouvelle mesure ni preuve du build de l’ancien exécutable à partir des octets actuels. Aucun clic de ruine/SunDisc n’avait été exercé. Un refus de sort ne teste pas l’activation d’un passif.

Non exécutés : jeu, client/serveur original, ancien probe/validateur, décodeur/VM Lua, tests/compilationRust, GUI/GPU/rendu/audio/réseau, REA, installation/migration. Aucun nouveau scénario de refus en partie, délai natif mesuré ou acceptation humaine. Les14contrôles sont des cohérences documentaires, pas14tests runtime.

## 6. Corrections avec les rôles existants et reprise précise

| Tâche conservée | Critère concret pour une reprise distincte |
|---|---|
| **CH-Azir-PASSIF-SOURCE** | Conserver deux branches, acteurs/IDs, versions et valeurs textuelles ; f1 bonus affiché et politiques non résolues explicitement séparés ; qualifier admission historique et exceptions. Ni lecteurs SOURCE, preloads, TowerClicker ni absence locale de Scripts ne clôturent la fiche. |
| **CH-Azir-PASSIF-SIMULATION-CONTRAT** | Contrat primaire attribuable pour unités/plafond/ordre/arrondis/niveaux de CDR→AS ; séparément ruines/exclusions/commande/propriété/stats/cibles/3min/1min/interruption/destruction/répétition du SunDisc. Préciser toute reconstruction locale. Aucun niveau TowerClicker transféré ; pas de règle d’inhibiteur/Tibbers adoptée. |
| **CH-Azir-PASSIF-SIMULATION** | Après contrat qualifié, vérifier conversion réelle sans CDR/avec CDR, changements d’objet/retrait, plafond/limites et timing des projectiles ; contrôler l’AS générique séparément. Pour SunDisc : ruine admissible→activation→création propriétaire/stats→désintégration/recharge ; tester ruines exclues/alliées/ennemies, vivant/mort, indisponibilité, interruption et refus sans mutation. Rapporter attendu/observé et identités des binaires/ressources. |

Aucun nouvel ID ou acteur créé ; aucune inscription de ces corrections dans le registre. Source/callsite serveur attribuable, observation primaire reproductible propre à la branche ou dérive courante sont les conditions de reprise. Sans entrée nouvelle, ne pas relancer les hashes, attentes, décodeurs ou recherches f1 en boucle. L’inconnue OLU-eac5… reste chez SOURCE ; corps serveur et admission historique non résolus.

Prochain préflight possible : **Blitzcrank SOURCE** depuis V1182/V544 et ses preuves disponibles, sans ouvrir une nouvelle enquête ici ni convertir l’audit présent en implémentation.

## 7. Livraison, clôture bornée et conservation

Les parties natives15/15, contrat courant et code alimentent `result.json`14/14 ; ce sont des composantes de **la seule unité AUD-SYS-01.2-02-AZIR-PASSIF-SOURCE-CONSUMER-01**. Sept rubriques satisfaites dans sa frontière : objectif/fin, sources, consommateurs, attendu/observé, contrôles exécutés/non exécutés, écarts/reprise/correction et preuves/décision. Relecture indépendante/publication à tracer séparément ; aucune tâche SOURCE, inconnue ou fonctionnalité close.

Staging exclusivement `E:\mapslol3v3\audit_sys01202_azir_passive_source_20261103` : reçus/notes/scripts, contrat réemployé, log de recherche, intégrateur, résultat, rapport et publisher gardé **non exécuté à la préparation**. Cible prévue : `F:\OpenLeague\docs\AUDIT_SYS01202_AZIR_PASSIF_SOURCE_CONSUMER_2026-11-03.md` et append V1185 dans CURRENT/HANDOFF seulement. Publisher : petites preuves et21pins courants, cache immuable/extracteur et réemploi épinglés ; cinq JSON protégés plus completion_tasks/execution_plan contrôlés avant/après ; aucun natif rehashé.

Reprise Git root consignée dans `E:\mapslol3v3\resume_sys01202_20261103_v1184.txt` : main, HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications antérieures conservées ; aucun acte Git du lot. La matrice V1182 reste historique ; les notes indiquent seulement que sa candidature Azir possède maintenant cette relecture bornée. Aucun code/asset produit, Goal, Plan, UI, application ou base modifié. **SOURCE, trace, inconnue, SYS-01.2-02 et jeu restent ouverts.**
