# Tutoriel historique : portée des consommateurs et précision des sources — V506

25 octobre 2026 — F:\OpenLeague — SYS-01.2-02. Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

## Résultat intégré

Les cinq fiches MODE-TUTORIAL SCOPE/SELECT/STEPS/RULES/RESULT distinguent maintenant leurs sources partielles déjà identifiées des références de code qui ne consomment pas leur gameplay. Les six liens historiques restent dans les listes brutes, avec leur source, CID et rôle global inchangés. Le résolveur du plan les restitue comme références hors portée : World dans les cinq fiches, plus play dans SCOPE. Aucun de ces liens ne démontre un tutoriel jouable.

Les dix questions existantes restent ouvertes, avec les mêmes identifiants, propriétaires, aspects et statuts. Leurs formulations ont été précisées : les anciennes recherches « None » et « aucun fichier exact trouvé » sont conservées comme constats datés, tandis que les sources partielles désormais liées sont explicitement reconnues. Ancienne question, ancienne condition de résolution et recherches antérieures restent récupérables dans question_history et dans les préfixes de recherche. Aucune inconnue n’est créée ou résolue.

Les cinq fiches MODE-BATTLE-TRAINING sont distinctes et restent exactes, ainsi que leurs critères et questions. Aucune recherche d’archive identique à V462/V463 n’est relancée. Les lacunes de Battle Training ne sont pas utilisées pour déclarer les sources du tutoriel historique absentes.

## Contrat, prérequis et portée

Objectif : relier chaque exigence à une source native et à son consommateur actuel, avec succès/refus/limites vérifiables. Les critères des cinq tâches, required/required_if, dépendances, statuts, entity.map=null, cases, notes et historiques sont conservés. Aucun ID de carte n’est inventé depuis null ; ni traduction 3→12 ni activation EUW n’est déduite d’une ressource physique.

Les lots D01-SYS-01-2 et D11-MODE-TUTORIAL et leurs phases sont conservés dans les prérequis du reçu. Leur achèvement n’est pas présumé. La livraison V428 qualifie quatre rôles de source distincts, dont un seul corps pour STEPS ; elle exclut RULES. La livraison V455 apporte séparément sept requêtes encodées pour RULES. V506 conserve ces frontières, leurs qualifications et leurs réserves de revue/exécution ; elle ne les transforme pas en implémentation du mode.

## Ce qui a réellement été relu

- 137 identités de validation de V428 et huit entrées de V455, dédupliquées avec les sources courantes et autres entrées dans 1402 identités vérifiées au total.
- 387 ancres de source AIR : source/ligne/aiguille relues sur les octets identifiés ; aucune nouvelle décompilation ni exécution AIR.
- 119 fenêtres de source : SHA du texte des lignes sélectionnées comparé au contrat existant.
- TutorialScript.luaobj natif : 49243 octets, SHA256 `22f7319f8dd6cfabc413eefa684da340afff7f36b3e9f7c656cd6d0b72fedfc3`. Le lecteur courant retrouve 100 prototypes enfants ; ce ne sont pas 100 étapes jouables.
- Corps OnTutorialInit antérieurement sélectionné : offset 6277, 1200 octets, SHA256 `3bf1d74df9f5af0e798bad70b3423a58423375a58c9a2d6459ab4e2506703365`. Les métadonnées héritées restent 300 mots, 57 CALL, 74 constantes et huit stockages. Les octets et leur hash sont réidentifiés ; leurs effets ne sont pas exécutés.
- Sept fenêtres de quatre mots d’instruction de V455 sont comparées aux octets natifs. Le booléen encodé true, les symboles de flags non résolus et l’absence d’exécution des CALL restent distincts.
- Recherche fraîche dans 1203 fichiers Rust/JS/HTML/TS inventoriés par rg dans crates et launcher. Six fichiers contiennent les termes recherchés ; ils concernent les records/paquets de chargement, leur replay et leurs tests. Les corps World/play/server sont lus séparément.

L’observation TUTORIAL_SCOPE_OBSERVATIONS.json fait 1034792 octets, SHA256 `639fa2eb50ba289155609541384e61b2950361b1b53c8b4a1a160df53a2cc8d8`. Elle conserve le corpus, les lignes trouvées, les sources et leurs identités. L’absence de correspondance dans d’autres fichiers de ce corpus n’est pas une preuve d’absence de toute implémentation possible.

Les 23 occurrences de native_inputs déjà liées aux cinq exigences sont conservées exactement : SCOPE 12, SELECT 5, STEPS 1, RULES 1, RESULT 4. Ce sont des liens, pas 23 ressources nouvelles ni 23 comportements terminés. Aucun rôle natif supplémentaire n’est inventé ou dupliqué pour augmenter le compte.

## Source partielle et manque par fiche

| Fiche | Source déjà identifiée, conservée | Ce qui reste à qualifier |
|---|---|---|
| SCOPE | AIR119, collection générée, garde de setter et lookup conditionnel | Classe/provider/collection effectifs, namespaces BASIC/ADVANCED, montage, réponse de service et disponibilité régionale datée |
| SELECT | Données fournies, acquisition du provider, guide et filtre conditionnels | Liste/composition réellement produites, flags/pools/ownership, réponses serveur et sélection jouable |
| STEPS | Un corps OnTutorialInit et 100 prototypes présents dans TutorialScript physique Map12 | Scénario monté, résolution bibliothèque/hostcalls, timers/événements, conditions de passage et toutes les autres étapes |
| RULES | Sept requêtes SetInputLockFlag avec argument true | Valeurs des flags, effets moteur, déverrouillages, restrictions complètes et passerelle Rust réelle |
| RESULT | DTO/providers, prédicats WIN, slot indexé, désactivation et retour conditionnels AIR | Bridge natif/PressContinue vers AIR, callbacks effectifs, résultat/retour ordinaires, calcul et attribution des récompenses, fidélité |

Les arguments de service 0/1 restent distincts des ID de carte 3/1 employés par certaines branches AIR. Le Luaobj physique Map12 et la demande d’une bibliothèque .lua restent des observations séparées de leur montage et de la résolution de la bibliothèque .luaobj disponible. Un signal Tutorial, une constante ou le nom d’un type de chargement ne choisit pas un scénario et ne prouve pas sa victoire.

## Pourquoi les consommateurs sont hors portée

World `Simulation::enable_map10` charge map10_world.json, définitions, structures, camps, voies et interactions de Map10. Le contrat demandé est celui du tutoriel historique, dont le contexte effectif reste inconnu. Le même CID peut rester pertinent pour les tâches de Map10 déjà qualifiées ; son rôle global et toutes ces autres associations restent inchangés.

Le CID play supplémentaire dans SCOPE était déjà qualifié globalement entry_boundary_only/provides_feature_consumer=false. Son corps reçoit champion/sorts et démarre une session locale. Il n’établit pas l’admission du tutoriel, son provider ou ses étapes. La qualification par exigence évite désormais de le présenter parmi les consommateurs du gameplay demandé.

Les éléments actuels nommés Tutorial dans les paquets/records/replay de chargement et leurs tests sont des consommateurs de leurs contrats de chargement. Ils ne sont pas promus en consommateurs du scénario, des étapes ou des règles. Les contrôles CPU Map10 V504/V505 restent également distincts et ne sont pas rejoués ou réattribués au tutoriel.

## Attendu, observé et refus

| Contrôle | Attendu | Observé |
|---|---|---|
| Sources/ancres/fenêtres | Identités et sélections conformes aux contrats partiels hérités | 1402 identités, 387 ancres, 119 fenêtres vérifiées |
| Lua invalide | Refus du tronqué, de données finales supplémentaires et d’un en-tête invalide | Trois refus du lecteur réel |
| Corps modifié | Une modification en mémoire ne conserve pas le SHA sélectionné | Différence constatée ; fichier natif inchangé |
| Portée du plan | Aucun consommateur du gameplay démontré par les liens World/play ; liens conservés hors portée | Cinq fiches, six références hors portée, listes brutes identiques |
| Questions ouvertes | Identités/statuts/aspects conservés ; anciens textes/conditions/recherches récupérables | Dix questions affinées, zéro création/résolution ; compteurs et tous les autres enregistrements exacts |
| Refus publics | Fausse feature, preuve détachée, consommateur non membre, doublon ; mauvais propriétaire/statut/condition des inconnues | 50 refus via le validateur public |
| Historique de question retiré | Garde de livraison refuse la perte de l’ancien constat | Dix refus de garde ; le lecteur générique ne contrôle pas ce nouvel historique et n’est pas présenté comme le refusant |
| Conservation | Seuls les cinq textes de traçabilité changent parmi 42214 ; Battle Training et critères exacts | 42209 textes de traçabilité identiques ; cinq fiches Battle Training et leurs questions exactes |

La préparation réussie contrôle six sélecteurs nominaux et sept refus. La comparaison des 42214 lignes d’instructions de traçabilité n’est pas une exécution des 42214 tâches. Les vrais lecteurs Store.task/copy_text, requirement_trace.resolve et instructions des six fiches concernées, SYS inclus, sont contrôlés séparément dans les deux bases.

## Incidents conservés et reprise de publication

Première préparation : KeyError added_consumer_ids dans le sélecteur SYS hérité ; la nouvelle association de source n’avait pas fourni sa liste vide attendue. Aucune base ou registre n’avait été écrit. Le script et les sauvegardes/reçu de cette tentative restent sous revision506. La reprise distincte revision506_retry fournit ce champ vide et prépare le candidat avec code 0.

Le candidat a passé ses contrôles, puis la première publication a terminé à 1 lors de la relecture finale : le champ qualified_existing_consumer_ids du contexte SYS était vide alors que le sélecteur SYS hérité conservait ses consommateurs existants. Les quatre documents et deux bases avaient déjà été écrits ; aucune preuve publique de réussite n’avait été créée. Ce résultat n’est pas déclaré réussi rétroactivement.

La reprise explicite vérifie que les quatre documents et les deux bases correspondent exactement aux sorties de cette première publication et que toutes les données manuelles sont intactes. Elle corrige uniquement le champ de contexte SYS, met à jour la donnée/instruction de cette seule ligne dans chaque base, puis exécute les vrais lecteurs et compare les quatre documents finaux attendus. Le script original, le marqueur de publication, les sauvegardes avant correction et les preuves RECOVERY_* sont conservés. L’audit final utilise le même correctif explicite de construction attendue ; la recette finale identifie donc le script de reprise, pas seulement le script initial.

Aucune correction ne touche le code du jeu, les critères, les questions et leurs statuts, les cases ou les historiques. Les six fiches sont intégrées et vérifiées après cette reprise ; cela ne vaut pas acceptation du tutoriel.

## Fichiers et limite finale

Rapport docs/FIDELITY_TUTORIAL_CURRENT_SCOPE_V506.md ; reçu docs/reference_tutorial_mode_roles_sources/tutorial-current-scope-v506.json ; preuve docs/fidelity_tutorial_current_scope_v506.json. Registres fidelity_sources, fidelity_requirement_trace, completion_tasks et fidelity_unknowns ; deux bases du plan ; couverture, plan et reprise. Scripts et preuves sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision506*.

Python est utilisé pour la collecte, les contrôles et la publication. Aucun jeu original, AIR, VM Lua, processus de jeu, compilation Rust, GPU ou audio n’est exécuté. Aucun binaire ou asset de jeu n’est modifié. Les anciennes exécutions de qualification et de revue restent attribuées à leurs reçus, sans être comptées comme nouvelles.

Les sources partielles permettent de préciser le plan. Elles ne fournissent pas encore le contexte natif effectif, toutes les étapes et règles, le consommateur de gameplay, le résultat/retour ordinaire ou l’acceptation humaine. Le tutoriel, Battle Training, SYS-01.2-02 et le jeu restent ouverts.

Bilan vérifié : 2 sources de preuve ajoutées ; aucun CID, lien natif ou consommateur nouveau. 23 occurrences natives et tous les records de consommateurs exacts. Six références hors portée sur cinq fiches ; dix questions affinées, anciennes formulations/conditions/recherches conservées, zéro résolution/création. Graphe : 98704 sources / 2608 consommateurs / 25827 ouvertes / 5517 résolues avec historique. Deux bases : six fiches relues, 42600 autres lignes de catalogue exactes ; 42606 états/notes et 23 historiques exacts, intégrité OK. Collecte 0, première préparation 1 avant mutation, préparation reprise/candidat 0, première publication 1 après écriture sans preuve de réussite, reprise explicite/audit 0. Sous-inventaire :19à reprendre/477partielles/44lignes horsportée encore ouvertes, dont27audio ;deux liens World de tâches TTpartielles restent comptés séparément. Aucun test du jeu ni acceptation.
