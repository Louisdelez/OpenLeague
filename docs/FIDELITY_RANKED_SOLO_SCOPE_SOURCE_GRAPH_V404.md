# SYS-01.2-02 — sources du parcours classé Solo, V404

Le lot rattache quatre bibliothèques AIR4.20 et sept exports dérivés à MODE-RANKED-SOLO-SCOPE et SYS-01.2-02, dans les fiches, traces et instructions copiables des deux bases réelles du plan. Il ajoute un reçu source, aucun CID et aucun lien nouveau vers un corps de jeu. Les anciens consommateurs restent inchangés. Le mode jouable et l'objectif global restent ouverts.

## Référence et prérequis

PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB ; date de build littérale2014-11-17 à17:46:45, fuseau et déploiement non établis. Le catalogue4.20.1 et le composant AIR0.0.1.119 sont distincts. Aucun service EUW effectivement disponible n'est déduit de ces identités.

Le paquet D01-SYS-01-1 possède sept tâches techniquement vérifiées, sans acceptation humaine ; cette livraison ne les accepte pas. Les dépendances et états datés sont conservés dans revision404_prerequisite_scope_review_v1.json. Projet F:/OpenLeague, travail privé F:/OpenLeague-work ; E préservé.

## Contrat vérifié

Master1716, branche booléenne true : assigne ranked et RANKED_GAME_SOLO avant initializeForNewGame1729. La provenance du booléen et la conservation de l'état pendant les appels restent des prémisses. La branche PREMADE voisine ne qualifie pas RankedTeam.

GameQueueManager209/223 filtre une collection fournie par rankedtrue et minimumParticipantListSize1. Ce minimum ne fixe ni maximum de groupe, duo, carte, type effectif de file, classement, MMR, LP ou placements. La demande compatible est matchmakerService/getAvailableQueues avec[] ; proxy concret, transport et réponse restent fournis ou inconnus.

setAvailableQueues248 peut retourner tôt pour le même type sans pending. Le callback valide réinitialise currentGameType à null508 avant catalogue509 puis pending512 ; aucun refiltrage SOLO n'est garanti par cette chaîne. Le callback de refus vide le catalogue. Ces constats de code ne décrivent pas l'état d'un service historique.

Les implications entre corps exigent retours normaux et absence d'intervention externe, réentrante, de notification ou de lifecycle pertinente. Aucun état durable, modèleAS ou parcours historique exécuté n'est affirmé.

## Sources et consommateurs

La qualification382 et la revue385 restent des phases distinctes. L'auteur exact n'est pas nommé par FINAL382 ; sa relation same_author371/373/378/380 est conservée. Le rapport385 nomme ROOT comme relecteur distinct de382 ; les autres attributions restent datées.

La capture unique post384 a attendu la livraison384, la revue387, sa liaison réelle et le signalROOT. Le lookup privé current/history/origin a confronté onze contenus et33records. Les quatre autorités et sept exports réutilisent leurs identités physiquesE ; copiesF et anciens exportsE sont rehashés séparément. Les exports sont du texte dérivé, jamais une autorité binaire originale.

Aucun corps RankedSolo n'est qualifié par ce lot. world185 Map10 garde sa portée ; aucune frontière Tutorial/main72 n'est forcée comme feature. Cette conclusion est bornée aux recherches inspectées, sans absence globale d'implémentation déduite. Les98 581 sources antérieures,2 408 consommateurs, flags/scopes/assessments/history/origin, préfixes d'inputs et autres champs restent exacts. Les quatre voisines SELECT/RULES/RANK/RESULT et toutes les autres tâches sont inchangées.

Delta : reçu OLS-70329e35-712b-5ce8-a0b7-8bcc3e113eb5, aucun CID. MODE-RANKED-SOLO-SCOPE.entity.map reste null ; SYS-01.2-02.entity reste null. Les inconnues restent ouvertes, sans carte ou autorité serveur inventée.

## Contrôles réellement exécutés

Registrar ROOT et audit séparé ont terminé0. L'audit constate125contrôles source,43identités,36ancres, deux sélecteurs nominaux, six refus de sélecteur et24refus de contenu. Les18contrôles de simulation,98AST/sélecteurs,49métadonnées et91sceau privés sont des phases séparées et recouvrantes, pas des tests du jeu.

La revueROOT a vérifié48pins d'acquisition, six scriptsAST, dix définitions de métadonnées comparées exactement à leurs sources et36ancres. Les deux brouillons et le reçu de revue expliquent le compteur de sortie51 séparé. Les anciennes versions et trois refus privés (garde__new__, importctypes refusé par le préflight avant chargementDLL, clé de sealer) restent conservés ; aucun défaut produit n'en est déduit.

Les deux bases distinctes contiennent les données et instructions exactes des deux fiches. Les vrais Store.task/copy_text/requirement_trace.resolve sont relus via SQLite URI mode=ro/query_only et authorizer, sans Store.__init__. Les copies incluent les notes éventuelles. Dans chacune :42 606états et notes,23historiques et catalogue hors cible exacts ; integrity_check ok. Aucune case ni acceptation modifiée.

Les sauvegardes brutes précèdent le reçu, les trois remplacementsJSON et les deux transactions optimistes distinctes. La séquence n'est pas globalement atomique ; aucun rejeu ou rollback automatique n'est effectué. La preuve brute du registrar est conservée avant l'annexe d'audit ; six anciennes versions documentaires sont sauvegardées avant cette publication.

Aucun processus du jeu original, AIR, VM, buildRust ou GPU n'est exécuté. Le contrôle global est structurel : source_hashes_verified est l'entier0 ; rehashs physiques ciblés séparés. Le graphe vaut98 582sources/2 408consommateurs ;25 321inconnues ouvertes/5 517résolues, sans mesure de pourcentage du jeu.

## Fichiers et suite

Livrables : docs/reference_ranked_solo_scope_sources/ranked-solo-scope-source-contract-v404.json ; docs/fidelity_ranked_solo_scope_source_graph_v404.json ; ce rapport ; trois registres et deux bases locales du plan. Couverture, plan et reprise suivent ces preuves. Scripts, sorties et sauvegardes : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision404.

Revue indépendante414 après le vrai checkpointROOT404. La captureTeam411 reste fermée avant FINAL414 et signalROOT. CoOp3rôles412 puis Custom3rôles427 sont des lots distincts. Les sources Custom419/424,422/425,423/426, cartes générées417/418 et Tutorial392/397,394/399,400/402 restent privées tant que leurs propres raccordements ne sont pas livrés.

SYS-03.4-07 : archive non identifiée, réponse utilisateur « je n'en sais rien » ; AnvilKit piste seulement. Inconnue OLU-78ef8b13-b7d3-58c4-b632-7ecf25a2f8c0 conservée. Goal actif, aucun cochage automatique et aucune acceptation globale.

## Revue indépendante V414 — 2026-10-24T06:31:29.765575+00:00

Le relecteur distinct de l'auteur de préparation404, de382 et du ROOT a terminé l'audit avec le code0 :465contrôles,56identités,36ancres, quatre autorités AIR et sept exports. Delta exact : un reçu, aucun CID et aucun nouveau lien vers un corps de jeu. Les anciens records, portées, flags, assessments, inputs en préfixe, quatre voisines et inconnues restent exacts.

Les deux bases distinctes sont relues en RO/query_only avec authorizer et les vrais Store.task/copy_text/requirement_trace.resolve, sans initialisation ni substitution de modules. Les identités des modules publics ordinaires sont relevées. Chaque base conserve42 606états et notes,23historiques et le catalogue hors cible. Les données et instructions des deux fiches et leurs copies sont exactes.

La suite propre de l'audit comprend deux sélecteurs nominaux et onze refus attendus. Le supplément21contrôles comprend deux nominaux de métadonnées et treize refus, sans DB ; il reste séparé de la suite ROOT2/6/24, de la préparation53 et du sceau32. Les séries se recouvrent et ne sont pas additionnées en tests du jeu. Les refus privés de structure et ceux du préparateur404 sont conservés ; aucun refus de livraison ni défaut produit n'est observé.

Toutes les connexions et lectures de la revue sont terminées. Ce rattachement ouvre zéro base et conserve les quatre registres ; les sept anciennes versions documentaires sont sauvegardées en octets exacts. Le contrat minimum1, le reset du callback et les prémisses d'intervention restent inchangés. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision414_independent_ranked_solo_scope_source_delivery\FINAL_EXECUTION_RECEIPT.json. Goal actif ; prochaine capture Team411 seulement après le checkpoint réel de cette liaison et le signalROOT.
