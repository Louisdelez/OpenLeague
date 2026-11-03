# SYS-01.2-02 — sources Équipe classée et consommateurs actuels, V411

Livraison analytique intégrée : six bibliothèques AIR119 et quatorze exports dérivés reliés aux fiches MODE-RANKED-TEAM-SCOPE et SYS-01.2-02, leurs traces et leurs instructions copiables dans les deux bases du plan. Un reçu source ajouté ; aucun CID ou nouveau lien vers un corps de jeu. SELECT, RULES, RANK et RESULT restent des voisines distinctes, sans validation globale.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build2014-11-17 à17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 et composantAIR0.0.1.119 distincts. Projet F:/OpenLeague, travail privé F:/OpenLeague-work, E préservé.

## Sources et phases distinctes

Qualification386 :113contrôles/45identités/63ancres, quatorze classes et six famillesAIR119. Revue390 :52contrôles/51identités/63ancres,32fenêtres et sept lectures conditionnelles ; aucun modèleAS exécuté. Les six archivesE ont été fraîchement rehashées par390, distinctement de ses copiesF et des observations héritées de386. Ces compteurs ne sont pas additionnés en tests du jeu.

La structure411131contrôles/49pins est une préparation de contrat et de noms, sans lookup, projection ou simulation. L'auteur du386, le relecteur390 et l'auteur de préparation411 doivent rester explicitement attribués ; aucune auto-indépendance rétroactive.

Les sources386/390 et leurs readiness originales false sont conservées. La préparation411 a acquis une capture unique post404/414 après la liaison et le signal ROOT. Lookup sur vingt contenus, quarante records current/history/origin et74 fichiers physiques rehashés. Douze candidats locaux inspectés restent du contexte ; aucun corps de jeu Équipe classée n'est qualifié par ce lot. Les anciens CID, chemins E/F et origines restent inchangés.

## Contrat source conditionnel

Master.playAnotherGame2433 commence par copies, réinvitations et cleanup. CAP a priorité. Si le switch2451/2452 lit RANKED_TEAM_GAME ou RANKED_GAME_PREMADE, restartRankedTeamGame2498 assigne rankedtrue, PREMADE et JOIN_QUEUE, appelle initializeForNewGame puis handleSelectMapContinue, lit ensuite rankedTeamName pour createRankedTeamLobby et réinvite les participants fournis. Le nom et l'état antérieurs ne sont pas supposés conservés au travers de ces appels. allowedtoPlayAgain2418 est une méthode distincte, sans garde automatique imputée au redémarrage.

GameQueueManager.getQueues, branche PREMADE229–234 : rankedtrue et minimumParticipantListSize>1 seulement. Ce filtre ne teste pas teamOnly ; il ne qualifie ni mode historique Équipe classée, taille effective, carte, disponibilité, identité ou éligibilité de l'équipe.

La garde distincte InviteQueueManager.isRankedTeam98 exige configuration sélectionnée non nulle, ranked et teamOnly. Les setters d'ID et de nom ne prouvent pas la propriété de l'équipe ni une validation serveur. L'ID déclaré Number traverse un getterint puis actionNumber : aucune coercition ou valeur effective n'est exécutée.

Sous conditions de module/provider actif, ClientModuleInvite construit et publie les contrôleurs ; Master conserve le contrôleur retourné par le provider. InviteSystemManager demande GameInvites/ServiceEnabled avec argument littéraltrue puis lit getBoolean. L'argument n'est pas sa valeur effective. La branche active connecte les listeners ; la désactivation les déconnecte, notamment le listener de salon classé.

Legacy319 émet rankedTeamLobbyCreatedSignal(name), sans appel serveur direct. Si le signal est livré au handler connecté183 et que la garde ranked&&teamOnly est vraie, le factory construit l'action avec queueId/name et le service fourni. Dans doInvocation, l'action appelle createArrangedRankedTeamLobby ; l'adaptateur233/242 déclare lcdsGameInvitationService/createArrangedRankedTeamLobby avec[queueId,teamName]. Le cast du résultat en LobbyStatus et complete() ne prouvent ni réponse non nulle ni salon créé.

Toutes ces implications exigent retours normaux et absence d'intervention externe, réentrante, de notification ou de lifecycle pertinente. Transport, réponses, injection, configuration effective, roster, disponibilitéEUW, matchmaking, MMR, LP et résultats restent ouverts. Le fallback PREMADE de Solo ne suffit pas à qualifier ce parcours.

## Consommateurs et conservation

Le lookup current/history/origin a comparé vingt contenus et quarante records. Douze candidats locaux ont été inspectés et conservés comme contexte, sans corps Équipe classée qualifié par ce lot. Les anciennes listes, portées et identités restent strictement égales. Aucun main72, play25 ou world185 n'est promu par proximité de nom ; cette conclusion ne prouve pas une absence globale d'implémentation.

Conserver les anciens records et chemins physiquesE/F séparés, flags/scopes/assessments, inputs en préfixe, autres champs et statuts, quatre voisines, autres tâches et inconnues. MODE-RANKED-TEAM-SCOPE.entity.map et SYS.entity restent distincts. Le résultat analytique doit être visible dans les vrais task/trace/instructions/copies des deux bases, avec cases, notes et historiques conservés.

## Intégration et contrôles

Registrar ROOT et audit séparé terminés avec code0. Audit :213 contrôles source,77 identités,63 ancres,2 sélecteurs nominaux,9 refus de sélecteur,24 refus de contenu ; zéro test du jeu. Les44 contrôles privés AST/métadonnées/RAM,22 contrôles de constantes et le sceau restent des phases séparées.

Les vrais Store.task/copy_text et requirement_trace.resolve ont vérifié les deux fiches de chacune des deux bases distinctes via URI mode=ro/query_only et authorizer, sans Store.__init__ ni substitution de modules. Dans chaque base,42606 états et notes,23 historiques et tous les autres catalogues restent exacts ; integrity_check ok. Les copies incluent leurs notes éventuelles.

Sauvegardes brutes avant reçu, trois remplacements JSON et deux transactions optimistes distinctes ; séquence non globalement atomique, aucun rejeu ou rollback automatique. Preuve brute du registrar conservée avant l'audit. Six anciennes versions documentaires conservées avant cette publication. Les refus privés V3 et V4 de constantes restées Solo sont retenus et corrigés avant publication ; aucun défaut produit n'en est déduit.

Graphe98583 sources/2408 consommateurs,25321 inconnues ouvertes/5517 résolues. Contrôle global structurel : source_hashes_verified entier0 ; rehashs physiques ciblés séparés. Aucun processus du jeu original, AIR, VM, Rust ou GPU exécuté.

## Fichiers et suite

Livrables : docs/reference_ranked_team_scope_sources/ranked-team-scope-source-contract-v411.json ; docs/fidelity_ranked_team_scope_source_graph_v411.json ; ce rapport ; trois registres et deux bases locales du plan. Scripts, sorties et sauvegardes : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision411. Couverture, plan et reprise suivent les preuves.

Revue indépendante415 après ce checkpoint ROOT. CoOp412 attend ensuite FINAL415, sa liaison et le signal ROOT. Custom427 puis Tutorial428 restent des préparations séparées, avec leurs gates propres. Les sources430, le triage432 et la qualification433 restent séparés des livraisons de graphe.

À cette livraison, le delta est un reçu source, aucun CID ni nouveau consommateur de jeu. La revue indépendante415 de livraison reste à effectuer. Les readinessfalse des sources386/390 et FINALfalse de la structure411 ne sont pas des acceptations. Aucun cochage automatique. Goal et jeu ouverts. Archive SYS-03.4-07 non identifiée, question conservée.

## Revue indépendante V415 — 2026-10-24T07:34:29.715644+00:00

L'audit final V3 du relecteur distinct de386, de la préparation411 et du ROOT a terminé avec code0 :558 contrôles,101 identités,63 ancres, six autorités AIR et quatorze exports. Le delta est exactement un reçu, aucun CID ni nouveau lien vers un corps de jeu. Les anciens records, portées, flags, assessments, préfixes d'inputs, quatre voisines et inconnues restent exacts.

Les deux bases distinctes ont été relues via URI mode=ro/query_only/authorizer avec les vrais Store.task/copy_text/requirement_trace.resolve, sans Store.__init__ ou substitution de modules. Chacune conserve42606 états et notes,23 historiques et tout le catalogue hors des deux cibles. Les42214 fiches actives comprennent42212 autres fiches/traces inchangées ; ces populations ne sont pas confondues.

Les2 sélecteurs nominaux,9 refus de sélecteur et24 refus de contenu sont des contrôles de métadonnées, sans test produit. Le supplément46 vérifie notamment les colonnes réelles SQLite, les11 identités ciblées, les deux bases physiquement distinctes, connection.json et les observations ROOT ; il reste séparé des558. Sceau22 et compagnon71 restent séparés également.

Les refus privés sont conservés : comparaison listes/dictionnaires V2, ouverture RO non escaladée du diagnostic, authorizer qui refusait aussi le PRAGMA de lecture du supplémentV1 et confusion du sceauV1 entre fiches actives et états manuels. Les corrections concernent le lecteur et le sceau ; aucun défaut produit n'en est déduit. Le premier essai de liaison ROOT a également refusé deux compteurs numériques attendus à tort comme booléens, avant toute mutation ; sa version et son refus sont conservés, puis cette garde de représentation est corrigée. Le seul fichier brut effectivement checkpointé, REGISTRATION_RAW_PROOF_OBSERVED, est exact. Un second nom historique de copie est absent et non requis par le contrat courant ; aucune copie synthétique n'est inventée.

Toutes les lectures et connexions sont closes. Cette liaison ouvre zéro base, laisse les quatre registres inchangés et sauvegarde les sept anciennes versions documentaires en octets exacts. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision415_independent_ranked_team_scope_source_delivery\FINAL_EXECUTION_RECEIPT.json. Le contrat PREMADE/teamOnly, les lectures tardives et les dépendances de providers/serveur restent bornés. Goal actif ; prochaine capture Coop412 seulement après le checkpoint réel de cette liaison et le signal ROOT.
