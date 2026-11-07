# SYS-01.2-02 — Agrégats mouvement, corps, clic et caméra, V524

25 octobre2026 — F:\OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue officiel4.20.1 distinct. Date littérale du build2014-11-17 à17:46:45 ; fuseau et date de déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MOUVEMENT** disposent maintenant de liens précis couvrant le mouvement, le corps, la navigation, la poursuite, le volume de clic et la caméra figurant dans leur titre. Leurs **366 sous-tâches RAYON/CHEMIN/BLOCAGE sont conservées exactement**. Le résultat est une qualification des sources et consommateurs actuels, avec des composants partiels et des frontières ; il ne clôture pas les mouvements ou les champions.

3 416 liens sont ajoutés : 28 par fiche, avec24 composants partiels et4 frontières de refus. Les anciens liens de catalogue restent présents comme métadonnées.22 points existants sont réutilisés sans changer leurs rôles globaux, et6 points précis sont ajoutés :

| Source courante | Ligne | Rôle borné |
| --- | ---: | --- |
| crates/core/src/lib.rs |741| Appel du mouvement après la poursuite et avant les attaques |
| crates/core/src/ally_occupancy.rs |775| Capture de l’orientation après le déplacement réservé |
| crates/client/src/picking.rs |63| Volume de clic ennemi, utilisant SelectionRadius |
| crates/client/src/picking.rs |106| Volume de clic allié, utilisant SelectionRadius |
| crates/client/src/ordinary_camera_input.rs |120| Position du joueur dans le Snapshot accepté vers le focus caméra |
| crates/client/src/camera_native.rs |44| Calcul de pose recevant le focus local |

Les anciens CID de commande de caméra provenant de copiesE restent immuables. Leurs sources et les contrepartiesF déjà enregistrées sont hachées et identiques en octets ; les nouvelles références qualifient cette correspondance sans réattribuer un identifiant ancien.

## Sources natives et distinctions conservées

1 220 occurrences sont vérifiées : quatre champs par personnage (MoveSpeed, PathfindingCollisionRadius, SelectionRadius, GameplayCollisionRadius), ainsi que six bindings partagés de DATA/cfg/defaults/Input.ini liés à chaque fiche.1 131 occurrences sont présentes ;89 champs GameplayCollisionRadius restent absents. Une absence facultative n’est ni un zéro, ni un fichier corrompu. Les replis courants65/40 restent des politiques locales distinctes des valeurs natives.

Le rayon de navigation, le volume de sélection et le rayon de combat gardent leurs propres consommateurs. La sélection lit SelectionRadius ; le corps de cible utilisé dans la poursuite lit le rayon de combat facultatif ; le mouvement allié utilise PathfindingCollisionRadius. Aucun de ces champs ne remplace implicitement les deux autres.

Les bindings d’origine corroborentY, Space et les quatre flèches. Le code courant utilise ces contrôles ; cette correspondance ne prouve ni chargement des remappings utilisateur, ni producteur d’événements historique, ni priorité des configurations. Les règles locales de suivi, captureUI, propriétaire/révision et pose caméra sont identifiées séparément.

## Échecs et questions toujours ouverts

Les **46 arrivées attendues non observées en350ticks dans V523** restent des échecs du scénario déclaré. Le budget ne constitue pas un délai historique ni une preuve de blocage infini. Les92 questions correspondantes restent attachées aux sous-tâches CHEMIN/BLOCAGE. Deux questions de caméra restent attachées à SYS-09.4-03 et SYS-09.4-04. Elles sont référencées comme limites liées ; aucun identifiant d’inconnue n’est réassigné au parent.

Le registre entier d’inconnues reste **exact en octets** : aucune question créée, fermée ou réécrite. Aucun parent n’affirme que ses enfants sont acceptés. Les preuvesCPUV519/V523 sont réutilisées et leurs entrées sont revérifiées, sans les attribuer à une nouvelle exécution. Aucun nouveau build ou runtime de jeu, client, caméra, réseau, GPU ou audio n’est exécutéV524. La caméra et les clics sont inspectés statiquement ; leur rendu, l’ergonomie ordinaire et la fidélité humaine ne sont pas acceptés.

## Contrôles réellement exécutés

- Contrats, titres complets, dépendances et prérequis des122 fiches relus. Les122 fichiers natifs de personnage, Input.ini, les sources courantes, les ancres et les preuves réutilisées sont hachés. Les champs présents sont comparés aux valeursf32 courantes et les absences restent explicites.
-73 refus propres au candidat contrôlent entre autres la confusion des rayons, la promotion du catalogue, une fausse acceptation des enfants, une fausse exécution fraîche et la réattribution d’une question enfant. Trois refus du lecteur public contrôlent un consommateur absent, une source étrangère et une acceptation de comportement inventée.
- Les fragments de traçabilité des42 215 tâches sont comparés :122 changent et42 093 restent identiques.42 092 autres objets tâche/trace sont exacts. Les identités, la hiérarchie et le registre d’inconnues sont exacts en octets. Les366 enfants sont vérifiés individuellement.
- Sur une copie privée puis dans les deux bases réelles, les vrais Store.task, copy_text, summary, dépendances et rt.resolve sont utilisés. Chaque question liée est retrouvée chez son propriétaire.123 destinataires sont vérifiés par base ;42 484 autres lignes catalogue,42 607 états/notes et23 historiques restent exacts, ainsi que phases, fiches et groupes. L’intégritéSQLite estOK et les synchronisations normales suivantes sont idempotentes.

Le texte condensé garde son plafond de trois consommateurs. Les28 nouveaux liens par fiche sont vérifiés dans le graphe complet et le reçu ; le texte condensé n’est pas présenté comme toute la qualification. Les cases de suivi et les exigences d’acceptation humaine ne sont pas modifiées.

## Incident de reçu et récupération vérifiée

Préparation et contrôle finissent au code0. Le publisher met à jour les fichiers et les deux bases et vérifie leurs résultats, puis retourne **1** en construisant le reçu final : le champ all_declared_goals_reached avait été fourni deux fois. Ce journal et ce résultat initial sont conservés.

La récupération ne relance pas le publisher. Elle compare de nouveau les six fichiers actifs aux candidats, le reçu à sa copie de travail, puis vérifie indépendamment les deux bases déjà mises à jour. Elle écrit uniquement le reçu/preuve manquant et les marqueurs de récupération. Aucun fichier enregistré ni base n’est réécrit par cette récupération. Son code de retour est0. Un audit indépendant finit ensuite au code0 et confirme la conservation et l’idempotence. Les transactions et écritures restent séquentielles ; aucune atomicité globale n’est revendiquée.

Preuves : revision524_COMMAND_PUBLISH.json/log pour l’échec initial ; revision524_RECOVERY_COMMAND_PUBLISH.json/log ; RECEIPT_RECOVERY_VERIFIED.json ; revision524_RECOVERY_COMMAND_AUDIT.json/log ; DELIVERY_AUDIT.json. La réparation du reçu ne corrige pas le défaut de déplacementV523.

## Réexamen global et suite à traiter

Un réexamen global en lecture seule est enregistré dans **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision525_trace_review\REVIEW.json**. Il valide le graphe et les identités de42 215 exigences, puis recontrôle les2 655 ancres et les octets de leurs509 fichiers courants : aucune divergence. Les17 consommateurs auxiliaires intentionnels restent présents.

Il recense9 476 fichesCH dont le seul consommateur applicable est le chargeur partagé de définitions. C’est une file de qualification, pas une preuve d’absence de fonctionnalité. Le recensement distingue aussi385 fiches sans liaison native,3 214 sans consommateur non-plan applicable,1 908 avec seulement des frontières explicites et20 180 portant des questions ouvertes. Ces catégories se chevauchent et ne mesurent pas une progression du jeu. Les98 761 fichiers sources ne sont pas tous rehachés par ce réexamen ; il ne remplace pas une vérification de leur disponibilité.

La prochaine entrée est constituée des122 fichesIDENTITE et de leurs2 440 champs enfants. Leur titre inclut aussi les rayons, qui ne figurent pas parmi ces20 enfants : les fiches de rayons existantes doivent être inspectées avant toute conclusion ou modification du plan.

## Fichiers et état final

Modifiés : docs/fidelity_sources_4_20.json ; docs/fidelity_requirement_trace_4_20.json ; docs/completion_tasks_2026-10-20.json ; les deux bases locales. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md reçoivent le nouveau contexte après sauvegarde de leurs versions précédentes.

Ajoutés : docs/reference_requirement_trace_sources/champion-movement-aggregate-links-v524.json ; docs/fidelity_champion_movement_aggregate_links_v524.json ; présent rapport. Deux sources sont ajoutées : inspection et reçu. Aucun code produit, asset, lecteur ou pack n’est modifié.

Graphe :42 215 exigences actives,98 761 sources,2 655 consommateurs,25 919 questions ouvertes et5 517 résolues avec historique. Travail détaillé sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision524_inspection et revision524. La migrationGnarV522 et les écartsV523 restent conservés. Aucun champion ou jeu complet n’est déclaré terminé. Ne pas republierV524.

Poursuivre SYS-01.2-02 à partir du réexamen global courant F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision525_trace_review/REVIEW.json :9476fichesCH ontseulementlechargeurpartagécomme lienapplicable,cequipointeuntravaildequalificationetnonuneabsenced’implémentation. Commencerles122CH-*-IDENTITE eninspectantleurs20enfants/2440champs etlesvraisconsommateurs existants,avec sourcesetécartsV512–V517 conservés. Leurtitre inclutaussilesrayons,absentsdelaliste20 :inspecterlesfichesMOUVEMENT-RAYONexistantesavanttouteconclusionoumodificationdedépendances. Gardercaméra/clic/corps/rayonnavigationdistincts,V522Gnar et46échecsV523/92questionsenfantsouverts. Les2655ancres/fichiersdecodesontrevérifiés,maislederniercontrôleglobalnesubstituepasunhashdes98761sources. Préservercritères,identités,25919questionsouverteset5517résolues,17auxiliaires,cases/notes/historiques. Ne pas republierV524 ;Goal entier actif.
