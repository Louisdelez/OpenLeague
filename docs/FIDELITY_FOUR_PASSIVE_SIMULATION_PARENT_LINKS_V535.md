# SYS-01.2-02 — Chemins des quatre simulations de passifs, V535

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral du2014-11-17 à17:46:45 ;fuseau/déploiement inconnus. Catalogue officiel4.20.1 distinct.

## Résultat intégré

Les quatre fiches **PASSIF-SIMULATION** d'Annie, Ezreal, Garen et Trundle relient maintenant les composants locaux déjà examinés aux chemins actuels de commande et de tick. **12 arêtes natives**, **71 liens de composants partiels**, **un lien de contexte Garen** et **15 nouveaux points de code** sont intégrés. Les liens comprennent38composants des contrats locaux et33occurrences des nouveaux points de dispatch. Deux documents de preuve sont ajoutés ; aucune nouvelle identité physique de code ou d'asset.

Les huit dépendances, quatre questions propres et huit questions des enfants restent conservées chez leurs propriétaires. **Aucune question ajoutée ou fermée**, aucun statut/critère/acceptation, coche, note ou historique changé. Les quatre parents restent partiel_a_terminer avec implementation_complete=false et acceptance_complete=false. Tous leurs enfants et les118autres parents sont identiques. Une union de liens et des tests partiels ne deviennent pas une acceptation complète du parent.

## Attendu et observé

| Point du critère parent | Observation | Limite |
| --- | --- | --- |
| Chemin ordinaire autoritaire | Entrées de commande et de tick identifiées dans le core et le serveur local | Le serveur n'est pas exécuté dans ce lot |
| Composants effectifs du passif |38composants locaux du lot V534 conservés, plus33liens de dispatch | Pas d'équivalence complète aux règles natives |
| Succès et refus | Contrats locaux et résultats CPU V534 identifiés et rehachés | Pas de nouveau lancement de tests ni instrumentation de chaque chemin |
| Dépendances et questions |8dépendances et12questions parent/enfants distinctes conservées | Aucune acceptation des enfants déduite de leur présence |
| Rôle des lecteurs SOURCE |18liens de lecteurs restent dans les tâches d'audit | Ils ne sont pas ajoutés comme mécanique de simulation |

## Consommateurs ordinaires inspectés

**Simulation.command**, lib.rs:598, rejette l'état terminé, le joueur inconnu ou mort et applique ses gardes de contrôle/cast. Les bras **Action::Cast** et **Action::CastAt**, lignes622/623, délèguent aux chemins de sort avec cible ou point. Ces chemins couvrent aussi leurs refus ; un échec ciblé n'est pas une preuve d'absence de tous les passifs ou sorts.

**Simulation.advance**, lib.rs:685, suit les gardes de fin de partie, incrémente le tick, avance le monde puis vérifie à nouveau la fin avant les systèmes suivants. Les appels Annie Q/W/R, Ezreal Q/W/E/R, régénération Garen et monde pour les morts d'unités Trundle sont repérés aux lignes exactes. Les callbacks plus précis, charges, soins, nettoyages et propriétaires avaient été examinés dans les24branches locales V534 ; leurs liens sont préservés.

Le **serveur local** lit un peer connu, contrôle la séquence et l'état de pause, puis appelle game.command. Sa boucle de rattrapage appelle game.advance suivant sa politique de tick. Les deux nouveaux descripteurs de ces appels décrivent **des sources seulement**. Le fichier serveur ne fait pas partie de l'exécutable des tests du core et aucun serveur, réseau, login ou propriété d'authentification complète n'est qualifié ici.

Les quinze nouveaux points regroupent six entrées/dispatchs communs, trois étapes Annie, quatre Ezreal, une régénération Garen et une étape monde pour Trundle. Leurs33occurrences dans les quatre parents sont distinctes des38liens locaux hérités. Tous les descripteurs restent partiels, feature_scope_complete=false et gameplay_accepted=false.

## Frontière entre lecture de source et mécanique

Les outils reference_inibin et lua51_reference sont de vrais lecteurs des tâches SOURCE. Ils ne sont pas appelés comme mécanique par la simulation Rust de ces passifs. Les **18 références de ces lecteurs** restent visibles dans leurs dépendances mais ne sont pas copiées dans la liste de composants de simulation des parents.

Les politiques locales déjà identifiées dans les tâches SOURCE peuvent aussi participer à la simulation parce que leurs fonctions de charges, soin ou mort produisent réellement ces effets dans le core. Leur portée et leurs anciens descripteurs sont conservés exactement. **Le contexte d'include Garen reste false/entry_boundary_only.** Aucune reclassification globale d'un lecteur ou d'une frontière n'est effectuée.

## Preuves d'exécution héritées

Le lot V534 avait compilé un binaire de tests du core dans un dossier neuf surF et exécuté37tests avec succès, dont27propres aux quatre politiques. Ces résultats, les1158entrées de source/ressource et les1147dépendances directes sont conservés et leurs identités recontrôlées. **Aucun test, build, serveur, jeu historique, VM Lua, GPU ou partie multiclient n'est exécuté dans ce lot V535.** Aucun code ou asset produit modifié.

Binaire hérité :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision534_passive_runtime\cargo-target\debug\deps\openleague_core-21eb81eb13817108.exe ;SHA-256 **8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97**. Il s'agit du binaire de tests du core ; la disponibilité et le succès de ses fixtures ne ferment pas les inconnues des règles serveur d'origine, des branches non couvertes ou du serveur livré.

Les douze entrées natives conservées établissent identité et métadonnées dans leur portée. Les descriptions auxiliaires, noms de buff, paliers communautaires et choix locaux ne sont pas promus en callbacks natifs. Les quatre questions parent et les huit questions enfants restent distinctes, sans adoption ni fermeture.

## Contrôles de publication

Inspection, préparation, contrôle privé, publication et audit séparé :**codes0**. **Quarante faux constats d'association sont refusés** :mauvais propriétaire ou composant,union déclarée acceptée,lecteur d'audit présenté comme gameplay,règles natives ou instrumentation inventées,questions enfants fermées,nouveau test CPU ou serveur fictif,lecteur injecté,dépendance supprimée,inconnue enfant adoptée et identité binaire altérée. **Quatre refus publics** protègent les identifiants source/consommateur absents,l'acceptation de jeu inventée et une inconnue Veigar étrangère.

Les **quatre extraits** ciblés changent, **42 211 autres extraits** restent exacts ;**42 210 autres objets tâche/trace** sont identiques. IDs,hiérarchie et fichier des inconnues sont exacts en octets. Tous les anciens objets source/consommateur et leurs portées restent identiques.

Dans chaque base :**cinq destinataires**, **42 602 autres lignes catalogue exactes**, **42 607 états manuels** et **23 historiques exacts**. Store.task,copie,résumé,résolution,deux dépendances,propriétaires des questions,intégrité SQLite et synchronisation normale idempotente vérifiés.

Réexamen global frais :**42 215 exigences**, **98 813 sources**, **2 764 CID**, **527 fichiers actuels**, toutes ancres et identités de consommateurs exactes,zéro divergence. **26 186 questions ouvertes**, **5 517 résolues**, **17 auxiliaires conservés**. Les **8 370 fiches CH** au seul chargeur partagé restent une file d'inspection, sans pourcentage de jeu terminé ni preuve d'absence. Aucun nouveau hash physique global des98 813sources revendiqué.

## Fichiers et suite

- Modifiés :docs/completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json et cinq lignes de données/consignes dans chacune des deux bases. Données manuelles,IDs,hiérarchie,inconnues et critères conservés.
- Reçu :docs/reference_requirement_trace_sources/four-passive-simulation-parent-links-v535.json ;preuve :docs/fidelity_four_passive_simulation_parent_links_v535.json.
- Inspection :revision535_passive_parent_inspection/OBSERVATIONS.json ;sauvegardes/candidat/contrôles/audit :revision535_passive_parent ;commandes revision535_passive_parent_COMMAND_*.json/.log.
- Réexamen :revision536_trace_review/REVIEW.json ;prochaine découverte :revision536_other_passive_contract_discovery/DISCOVERY.json. Couverture,plan documentaire,reprise,CURRENT et HANDOFF actualisés avec sauvegardes et champs antérieurs conservés. Aucun stage/reset/commit.

La découverte suivante recense les118autres contrats,relit leur structure native et collecte les candidats Rust bornés. Les éventuels zéros de recherche ne démontrent pas une absence globale ; les mentions textuelles ne sont pas des consommateurs de mécanique acceptés. Aucun lien ni statut de ces118contrats n'est modifié.

Poursuivre SYS-01.2-02 depuis revision536_trace_review/REVIEW.json (8370CH au seul chargeur partagé,sans absence globale inférée). Examiner les118autres PASSIF-SIMULATION-CONTRAT depuis revision536_other_passive_contract_discovery/DISCOVERY.json :structure native relue et candidats Rust bornés,questions propres/SOURCE conservées. Un ID cité,un chunk sansCALL ou zérohit lexical ne prouve pas une mécanique ni une absence ;inspecter les corps et leurs appelants,les producteurs et la portée des scripts avant nouveau lien. Les quatre simulations V535 sont publiées/auditées :71composants partiels/1contexte,33liens de dispatch,15CID,12arêtes natives,8dépendances et4questions propres+8enfants conservées. Les18lecteurs SOURCE d’audit ne sont pas du gameplay. Commande/tick du serveur examinés seulement en source ;37tests CPU V534 hérités et identités recontrôlées,pas rejoués et pas serveur/natif/GPU/multiclient qualifié. Ne pas republier V534/V535 ni recompiler sans changement ou nouvelle cause. Préserver118autres contrats/parents,questions de sources/modèles/rig/textures/matériaux,854dépendances MODELE,17auxiliaires et copiesV5311347exactes. Goal actif.
