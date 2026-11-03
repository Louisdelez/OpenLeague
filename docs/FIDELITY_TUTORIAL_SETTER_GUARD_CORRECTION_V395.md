# SYS-01.2-02 — rectification du garde public Tutorial, V395

Livraison intégrée. Cibles : MODE-TUTORIAL-SCOPE et SYS-01.2-02 uniquement. La réduction ancienne de V373 est conservée comme preuve datée ; la nouvelle qualification la supplée explicitement, sans réécrire le reçu ni modifier le code jeu. Aucun nouveau corps ou CID n'est proposé.

Référence PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build du 2014-11-17 à17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Le composant AIR0.0.1.119 reste distinct du build du jeu. Projet F:/OpenLeague, privé F:/OpenLeague-work ; E conservé.

## Écart de qualification et preuves

L'ancien reçu Tutorial373, 90884octets/SHA92ff72cda0a5ba7af388ec42bba6ec46aa098908229058f24219cd4b77051b81, réduit /AIR_source_contract/advanced_disabled à choosefalse+Enabledfalse puis post_typebasic et RPC0. Ce résultat omet la condition d'entrée dans le setter privé. L'identité du fichier et les résultats datés de livraison ne sont pas falsifiés ; la conclusion sémantique est trop générale.

La lecture indépendante V393 a trouvé la précision en relisant le corps complet. Son FINAL18548/SHA48b0266ce885383a1d88d28a7f01cbd1c33b59b6e04a43ca9f0b10a879939670 conserve 313 contrôles,63 identités,51 ancres primaires et24 fenêtres propres, dont une précision de qualification ; aucun défaut du jeu exécuté n'est démontré. Six archives E/F,17 classes et leurs copies/alias sont distinctes. SourceV2 réel0/abf178, sceau0/6b32e3 ; les refus privés et anciennes versions restent conservés. Le relecteur est distinct de l'auteur V389, mais ses propres acquis antérieurs restent attribués.

ROOT a confirmé l'ancien objet à17ca96 et les lignes à315734, puis acquis les FINAL393/392 à0998bd. L'avis documentaire V395 a été écrit àd330fe après sauvegarde des sept documents ; il ne modifie aucun registre ni base et ne clôture pas le correctif.

La préparation V395 a contrôlé 62 conditions de source, 29 identités ciblées et 34 ancres. Ses cinq lectures de cas restent statiques : aucune instruction ActionScript n'est exécutée. Deux sélecteurs nominaux, six refus de sélecteur, dix-neuf refus de contenu et quinze gardes ont été exercés dans la préparation ; après le sceau, deux gardes nominaux et six refus supplémentaires ont été observés séparément. Ces séries se recouvrent et ne sont pas des tests du jeu.

Deux binaires AIR119, ClientLibGame et ClientLibDomain, supportent les deux exports CreateTutorialGameController et GameModel. Les chemins enregistrés E et leurs copies F sont physiquement rehashés sans rebinding. Les anciennes identités, le reçu373 et les propriétés du consommateur play25 restent exacts. V393 et les preuves de capture constituent des étapes distinctes des autorités binaires.

ROOT a vérifié 37 pins privés, cinq modules par AST uniquement et les 34 ancres. Le refus privé de symtable sur __file__ et le diagnostic rg sont conservés dans le FINAL de préparation ; ils ne deviennent pas des défauts du jeu. La préparation et cette lecture n'exécutent pas le registrar ou les bases.

## Contrat exact à séparer par corps

chooseTutorialType79–82 assigne isBasicTutorial par le setter public178. Ce setter lit l'ancien getter180 et n'entre dans le corps privé54 que si old!==argument181. Le setter privé compare argumentfalse et la valeur de configuration seulement dans cette branche. Le nom de la propriété, l'argument, le getter final, le champ tutorialType et le payload d'événement ne sont pas interchangeables.

| État du getter à l'entrée | Argument | Lecture Enabled par ce chemin | Assignations dans les corps inspectés |
| --- | --- | --- | --- |
| true | true | Aucune : setter privé sauté | Aucune assignation tutorialType par choose seul ; getter conservé true |
| false | false | Aucune : setter privé sauté | Aucune assignation tutorialType par choose seul ; getter conservé false |
| true | false, configuration lue true | Oui, si le setter privé est atteint | tutorialType reçoit ADVANCED et getter devient false |
| true | false, configuration lue false | Oui, si le setter privé est atteint | tutorialType reçoit BASIC et getter reste true |
| false | true | Aucune : court-circuit argumentfalse dans le privé | tutorialType reçoit BASIC et getter devient true |

Ces lectures décrivent les instructions des branches sous les valeurs déclarées, retour normal et absence d'intervention pertinente ; elles ne garantissent pas des états durables. Elles ne sont pas des sorties d'un runtime AS. GameModel.tutorialType126–133 possède lui-même un setter bindable : il écrit son backing field puis notifie propertyChange si la valeur diffère ; cette notification peut intervenir avant les affectations _isBasicTutorial59/64. Le getter193–195 lit le backing field. Cette frontière doit être séparée du simple libellé BASIC/ADVANCED d'une instruction. Le payload propertyChange186 utilise newValue=argument, pas le getter après le setter privé : avec oldtrue/argumentfalse/Enabledfalse, une émission éventuelle peut annoncer false tandis que le getter demeure true. La présence d'un listener et son comportement ne sont pas établis.

Contre-cas de l'ancienne réduction : au moment de choose(false), supposer isBasicTutorialfalse et tutorialTypeADVANCED, avec un Enabledfalse hypothétique. Le setter privé n'est pas appelé ; ce chemin ne relit pas Enabled et n'affecte pas tutorialType. Si createGame est ensuite atteint avec le même getterfalse, son expression de requête à88 fournit1. Il ne s'agit ni d'un chemin historique observé, ni d'une garantie que les valeurs restent inchangées entre les corps.

createGame84–88 assigne proxiedOnError, puis isBusy avant de lire le getter dans l'expression isBasicTutorial?0:1. Le setter isBusy et les notifications éventuelles sont des frontières supplémentaires. Les interventions, callbacks, propertyChange, exceptions, providers et lifecycle restent inconnus ; aucun résultat RPC effectif n'est inféré de l'état d'un branchement antérieur.

Master1741–1757 garde sa portée : branche sur tutorialType après initialisation, lookup3/1, choose(true/false), puis demande de création. Le lookup nullable, l'ordre des callbacks et le modèle au callsite restent distincts. La correction n'établit ni configuration EUW, ni contenu SWF, disponibilité, cartes/files, montageMap12, scénario, règles ou partie jouable.

## Consommateurs et conservation

L'intégration réutilise les anciennes identités et scopes réellement applicables après lookup current/history/origin, sans requalifier play25 ou world185 comme feature Tutorial. Aucun nouveau corps n'est ajouté. L'archive AIR et l'export dérivé restent distincts ; leurs chemins E/F sont physiquement vérifiés, sans rebinding ni ancienne source remplacée.

Le reçu correctif identifie l'ancien chemin et le pointeur de la réduction suppléée, les nouveaux cas, les limites entre corps et les sources réelles. Les anciens inputs restent des préfixes exacts, les anciens records/flags/scopes/assessments/statuts, les quatre voisines Tutorial, toutes les autres tâches et inconnues sont conservés. entity.map reste null, aucun champ d'acceptation n'est promu.

## Intégration et contrôles

Le registrar ROOT puis l'audit ont réellement terminé avec le code 0. L'audit constate 62 contrôles source, 29 identités et 34 ancres, cinq lectures de cas, deux sélecteurs nominaux, six refus de sélecteur et dix-neuf refus de contenu. Ce sont des contrôles du contrat, de ses liens et de sa conservation ; aucun test AIR/Rust/natif/GPU n'a été exécuté.

Un seul reçu source est ajouté (OLS-5da525a9-f52f-5bba-9491-d70bb709efcb), aucun nouveau CID. Les deux cibles réutilisent play25 (OLC-b5b58c30-faf2-5364-9bc8-e071c5bc36ba) en entry_boundary_only/false, avec les mêmes listes, scopes et flags. Les 98 579 anciennes sources, 2 408 consommateurs, les anciens préfixes d'inputs, champs/statuts/assessments, quatre voisines et toutes les autres tâches restent exacts. Le registre d'inconnues est conservé intégralement. entity.map reste null et world185 garde son rôle Map10.

Dans chacune des deux bases physiquement distinctes, seules les données et instructions des deux fiches ont été actualisées. Les vrais Store.task/copy_text et resolve sont contrôlés via SQLite mode=ro/query_only sans initialisation de Store. Les instructions et copies avec notes éventuelles, les 42 606 états manuels et notes, 23 historiques et catalogues hors cible sont exacts. Aucune case ou acceptation n'est modifiée.

Les sauvegardes brutes précèdent le reçu, les trois remplacements JSON et les deux transactions optimistes BEGIN IMMEDIATE distinctes. Cette séquence n'est pas globalement atomique. Aucun rejeu ni rollback automatique n'a été fait. La preuve brute du registrar est conservée avant l'annexe de l'audit.

L'avis de portée courant de la preuve373 renvoie désormais au correctif395 intégré. Le reçu373, ses anciens liens et résultats datés ainsi que le document d'avis pending restent préservés ; seul le résumé courant de l'état du correctif et une annexe documentaire changent. La revue indépendante de livraison396 doit encore vérifier le résultat enregistré.

## Fichiers et suite

Livrables : docs/reference_tutorial_setter_guard_sources/tutorial-setter-guard-correction-v395.json, docs/fidelity_tutorial_setter_guard_correction_v395.json, ce rapport, trois registres et deux bases du plan. Couverture, plan, reprise et notes courantes sont mis à jour. Scripts, sauvegardes et observations réelles : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision395.

Graphe structurel : 98580 sources / 2408 consommateurs ; 25321 inconnues ouvertes / 5517 résolues. source_hashes_verified est l'entier0 pour ce contrôle global ; le rehash physique ciblé est séparé. Ces nombres ne mesurent pas un pourcentage de jeu terminé.

Suite : revue indépendante396 après le vrai checkpointROOT395 ; aucune nouvelle capture384 avant sa fin. Custom380/381, Solo382/385, Team386/390, Tutorial SELECT392/397 et RESULT394/399 sont des qualifications privées distinctes. RESULT doit reprendre les deux précisions de399, sans réécrire394. OnTutorialInit400 reste un corps statique, en revue402 ; montage et effets hôte non qualifiés. Continuer le même objectif source/consommateur, sans acceptation automatique.

Les codes ROOT, mutations et contrôles DB réellement observés sont détaillés ci-dessus. La correction concerne la qualification documentaire et ses vrais consommateurs plan/trace/copie ; aucun code jeu, runtime AS/Lua/natif, build Rust, GPU ou générateur n'est exécuté.

SYS-01.2-02 et le jeu restent ouverts. L'archive SYS-03.4-07 demeure non identifiée ; AnvilKit reste une piste et OLU-78ef8b13-b7d3-58c4-b632-7ecf25a2f8c0 est conservée ouverte.

## Relecture indépendante V396 — 2026-10-24T04:51:48.448335+00:00

Le relecteur distinct des auteurs de V393, de la préparation395 et de la publicationROOT a réellement terminé l'audit avec le code0. Il a vérifié les égalités des42 214 fiches et42 214 traces ainsi que40identités ciblées,34ancres et5lectures de cas. Le compteur84646 comprend surtout ces comparaisons par ligne ; ce ne sont pas84646tests du jeu. Supplément33contrôles/16identités, préparation25 et sceau20 restent des phases séparées.

Le delta exact est un reçu et aucun CID. Les anciens records/sources/flags/scopes/assessments/inputs, quatre voisines, autres fiches et registre d'inconnues sont préservés. Les deux bases distinctes ont été relues en modeRO avec les vrais Store.task/copy/resolve et les notes :42606états manuels et23historiques exacts chacune. Le reçu373 et l'avis pending daté restent immuables ; seule la notice courante du proof373 et une annexe du rapport373 avaient changé.

La suite autonome du relecteur2nominaux/6refus de sélecteur/11formes est distinguée de la suite producteur2/6/19 attribuée sans rejeu. Aucun refus propre d'audit. Les cinq cas restent conditionnels : garde public, notificationModel avantflag, argument d'événement distinct du getter et RPC aprèsisBusy. Aucune séquence atomique, exécutionAS ou acceptation de jeu n'est déduite.

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision396_independent_tutorial_setter_guard_correction_delivery\FINAL_EXECUTION_RECEIPT.json. Les versions publiques antérieures sont conservées en octets exacts dans revision395/pre-independent-V396-link-versions. Ce rattachement ne se connecte à aucune base et conserve les quatre registres. Goal actif ; prochaine étapeV384 Custom avec capturepost395 explicitement autorisée après ce checkpoint.
