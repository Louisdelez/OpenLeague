## 20 octobre 2026 — Application de suivi Rust/Tauri

Le suivi dispose d’un exécutable autonome avec UI et catalogue embarqués, backend Rust et presse-papiers/dialogues Windows. Sur ce PC, une configuration explicite réutilise la base SQLite originale pour éviter des suivis divergents entre site et application. Les ressources embarquées servent uniquement à initialiser une nouvelle base, jamais à écraser les données existantes. Les crates Tauri sont verrouillées à une famille compatible. Référence : tools/project-plan-desktop/README.md et E:/mapslol3v3/Plan_Tauri_2026-10-20/FINAL_VERIFICATION.json.

## 20 octobre 2026 — Découpage par contenu, sans quota

La demande utilisateur impose un travail précis et une fiche par champion. Les 24 domaines deviennent des parties navigables ; les fiches regroupent naturellement les tâches de leur contenu. Le nombre de tâches dépend du contenu, sans limite artificielle. Les états des anciennes cases globales restent archivés et ne valident pas les enfants. Les classifications de disponibilité sont obligatoires avant toute exclusion. La recette d’un kit dépend de ses tâches nominatives et ne peut pas être remplacée par la réussite d’une compilation.

Audit et justification : docs/PLAN_AUDIT_2026-10-20.md ; vérifications complètes : E:/mapslol3v3/Plan_granulaire_2026-10-20/AUDIT.json et FINAL_VERIFICATION.json.

## Interface du plan simplifiée — 20 octobre 2026

La demande utilisateur porte uniquement sur une UI sobre et épurée. La page locale 10427 utilise maintenant une colonne, blanc/gris, recherche et deux filtres ; colonne latérale, slogan, grande progression, badges et identifiants répétés retirés de la vue courante. Les titres ouvrent les consignes. Copie, coches, lots, notes et sauvegardes restent accessibles ; export/import/base sont dans Options. Phase/recherche/filtre/page sont conservés dans l’URL.

Contrôles réels : recherche précise et fiche de 3816 caractères, notes à la demande, menu de sauvegarde, filtres conservés au rechargement, coche persistante puis retirée et lot de trois tâches annulé ; aucune erreur console et aucun débordement horizontal à la largeur normale observée. Les 9461 états done/notes correspondent exactement au relevé avant modification après annulation des marques de QA. Backend, catalogue et hiérarchie inchangés. Le test HTTP existant est adapté au nouveau titre, sans nouveau test de décoration. La copie annonce sa réussite ; la limite déjà documentée du presse-papiers virtuel reste inchangée.

Preuves et aperçu : E:/mapslol3v3/Plan_UI_minimal_2026-10-20. Aucun code ni test du jeu modifié/exécuté.

---

## Plan HTML et suivi SQLite — 20 octobre 2026

Livraison demandée : plan complet en blocs avec cases à cocher et copie des instructions précises. Application locale : http://127.0.0.1:10427/. Sources : tools/project-plan/. HTML et lanceur créés sur le Bureau. Base persistante : runtime/project-plan/plan.sqlite3 ; aucun démarrage automatique Windows installé.

Le catalogue réel conserve 12 phases, 2604 lots et 9461 tâches. Chaque tâche a ses consignes complètes (objectif, élément ciblé, sources, étapes, dépendances, résultat attendu et preuves). Recherche, filtres, fiches, notes, copie de tâche/lot/phase, annulation, export/import JSON et sauvegarde SQLite disponibles. Les coches sont le suivi local de l’utilisateur et ne modifient pas automatiquement les preuves techniques du jeu. Le registre canonique des tâches est inchangé.

Validation : 12 tests propres à cette application passés (réimportation sans perte de suivi, réouverture SQLite, révisions concurrentes, rollback, annulation, pagination couvrant tous les ID, instructions, sauvegarde/import et HTTP local). JS final contrôlé par node --check. Dans le navigateur : une coche a survécu au rechargement puis a été remise à faire ; un lot de trois tâches et son annulation ont été vérifiés ; recherche précise du Q de Garen, fiche de 3816 caractères et navigation par phase observées. La copie affiche son succès mais le presse-papiers virtuel de Browser Use ne permet pas de relire une écriture du site ; ne pas revendiquer une vérification indépendante du presse-papiers système. Le contenu de copie est contrôlé par les tests API et la fiche rendue. Aucun test du jeu réexécuté ; les marques de QA sont revenues à zéro et ne sont pas du travail produit terminé.

Preuves et aperçu : E:\mapslol3v3\Local_plan_app_2026-10-20. Le service local reste lancé pour l’utilisation de la page. Après redémarrage, utiliser le lanceur du Bureau ; la base conserve les coches et notes.

---

## Plan d’exécution structuré — 20 octobre 2026

À la demande de l’utilisateur, le plan est réorganisé en phases → petits lots → tâches → résultat attendu. Plan principal : docs/OpenLeague_PLAN_DE_TRAVAIL_A_Z.md. Détails : docs/OpenLeague_PLAN_DETAILS/ (12 fiches). Hiérarchie machine : docs/execution_plan_A_Z.json. Copies du Markdown et des fiches sur le Bureau.

12 phases, 2 604 petits lots de une à six tâches, 9 461 tâches conservant leurs ID et statuts. Le plan principal contient 392 actions transversales ; les fiches de phase contiennent une fois chacune toutes les tâches, y compris les contenus nominatifs. Les dépendances de tâches, lots et phases ont été contrôlées sans cycle ; aucun des 24 domaines, 114 lots historiques ou 37 exigences n’est retiré. Le registre completion_tasks_2026-10-20.json reste la source des statuts et preuves, inchangée octet pour octet.

Prochaine action de réalisation : P01-L0001, puis les lots prêts de la phase courante. La première référence jouable est Garen/Map10 à six clients ; la qualification croisée du jeu entier est maintenue en P11, puis livraison autonome en P12. Cette livraison modifie uniquement les documents de planification. Aucun code/asset/binaire, résultat de test produit, état d’acceptation, statut ou texte du Goal modifié.

Preuves de structure et publication : E:\mapslol3v3\Structured_execution_plan_2026-10-20.

---

## Audit complet et plan détaillé — 20 octobre 2026

La demande active était l’audit de l’original 4.20, du projet, du plan et du Goal, puis un Markdown sur le Bureau. Audit livré dans docs/OpenLeague_Audit_Complet_et_Plan_A_Z_2026-10-20.md ; copie Bureau identique ; registre docs/completion_tasks_2026-10-20.json : 24 domaines, 114 lots et 37 exigences conservés, 9 461 tâches détaillées avec dépendances et critères.

Faits actuels : lecture complète des 7 511 membres du manifeste (7 508 identiques, trois documents de travail préservés, aucun autre écart/manquant) ; client original 71 453 fichiers dont 67 vides ; cinq catalogues officiels 4.20.1 téléchargés. Routage de sorts pour Garen/Annie/Trundle/Ezreal seulement (16 emplacements partiels, 472 sans route), 33 objets de simulation, launcher de préparation locale. Aucune clôture de kit complet ou de jeu entier.

Build courant 31ec67495ea4165b6ce1c91dc0c766b60ebb47f2bafca72451b2e34c10710edd, 762552 octets : 3 565 tests exécutés le 18 octobre (core1923/client1541/serveur50/launcher40/Bevy11), deux ignorés séparés. Lecteur admis jobs2 relancé en lecture seule le 20 octobre : code0 ; aucun Cargo/test produit réexécuté par cet audit. Les observations GUI du 20 octobre et leur fermeture sont liées dans le rapport : pause/reprise, E, Q lancé, mort/respawn et retour observés ; particules individuelles/impact Q précis et audio nouveau non qualifiés.

Le Goal lu reste paused, avec texte historique du 4 octobre ; l’outil ne permet pas d’en éditer l’objectif en place. Son statut et son texte n’ont pas changé. Les vieux champs de runtime/tests et les notes ci-dessous restent historiques ; le résumé daté de l’audit et la promotion courante nommée priment. Aucun code, asset, binaire, index Git, commit ou push modifié. Les travaux non validés (Magicdust/archives de tests, projectiles de monde) restent candidats, sans adoption implicite.

Prochaine séquence du plan : référentiel et suivi cohérents → kit Garen complet et systèmes Map10 → partie six clients jusqu’aux résultats → autres contenus, launcher/services, recette et paquet autonome. Ne pas remplacer cette séquence par une nouvelle revendication de complétude à partir d’un micro-lot technique. Le registre explicite les tâches partielles et celles dont le périmètre reste à classifier.

Preuves détaillées : E:\mapslol3v3\Full_project_audit_2026-10-20. Le jeu reste incomplet ; la livraison présente est l’audit et le plan.

---

# Décisions communes aux agents

## 2026-10-15 — Continuité indépendante du fournisseur

Décision : partager les règles via Rulesync et garder l'état du projet dans des fichiers Markdown versionnables. Les agents utilisent les mêmes sources, avec des fichiers de compatibilité générés. Le modèle ou l'abonnement choisi ne devient pas la source de vérité du projet.

Raison : pouvoir reprendre OpenLeague dans Codex, Claude Code, OpenCode, Gemini CLI, Copilot ou Kimi sans reconstruire le contexte depuis une conversation unique.

Les plans détaillés existants restent les références de périmètre et de preuve. CURRENT.md et HANDOFF.md en sont des index courts ; ils ne clôturent aucune fonctionnalité. Une passation enregistre les tests effectivement exécutés, leur révision et leurs limites.

La mémoire Basic Memory utilise uniquement docs/ai/memory/, en local, avec configuration et index propres au projet. Les notes restent lisibles sans MCP. Les conversations privées, index, dépendances installées et exports restent dans des répertoires ignorés.

Les outils d'indexation de tous les historiques et les changements d'agent ne sont pas lancés automatiquement à chaque reprise. Le contexte transféré doit être borné au projet et au besoin de l'utilisateur.

## 2026-10-17 — Relief et préparation du rendu R

La grille de hauteur dense est indépendante des cellules de navigation : une zone non traversable conserve sa hauteur. Le lecteur proposé refuse les données manquantes ou invalides, et ne les remplace jamais par zéro. Son interpolation f32 est une reconstruction locale distincte de la parité x87 native.

Le candidat de matériau prépare ses images avant le calcul FoW, puis exige une preuve fraîche au dessin réel. Le mesh se reconnaît par MainEntity, la caméra Render est contrôlée séparément. Ces corrections sont relues en Source mais non installées. Tests isolés, compilation produit, observation ordinaire et preuve GPU restent des états distincts.

Preuves : E:\mapslol3v3\Root_Ezreal_R_geometry_checkpoint_v1\evidence.json

## 2026-10-17 — Pose R, propriété du graphe et temps local

Le lancement R visible appartient à une session et un ordinal. Les observations intermédiaires sont traitées avant coalescence ; une interruption ou perte de visibilité interdit la relecture du même lancement. La pose ne retire que son nœud dans son graphe capturé. Un graphe absent ou remplacé garde un seul retrait en attente, sans arrêter une animation étrangère.

Le clip restauré reste à son âge réel : sa durée ne se comprime pas pour masquer l’écart avec la fenêtre locale d’une seconde. Les tests CPU, l’observation du jeu et la fidélité native restent des preuves distinctes. La hauteur initiale du R dépend de la pose et du relief ; aucune hauteur inventée n’est publiée pour combler une donnée inconnue.

Preuve : E:\mapslol3v3\Root_Ezreal_R_cast_animation_checkpoint_v1\evidence.json

## 2026-10-17 — Séparer observation, données et runtime successeur

L’observation R du runtime H2 reste attachée à son binaire et à son protocole ordinaire. Les captures relatives à l’appel API ne prouvent pas le temps d’acceptation serveur. Le coût de mana ne se déduit pas d’un relevé pendant la régénération de fontaine.

La qualification CPU du successeur Map10 ne transfère pas une qualification visuelle du parent. Une couleur présente dans les pixels DDS natifs ne doit pas être remplacée arbitrairement ; le filtrage et la parité GPU restent à vérifier séparément. Le refus local d’une cellule bloquée ne prouve pas un défaut global de navigation ni une politique native. Les propositions Source non intégrées et les analyses statiques conservent leur statut propre.

La capture privée casterXZ+denseY au début du cast et la pose restaurée R_foot à 1 seconde constituent la prochaine politique locale explicitement choisie. Elle permet de poursuivre sans le serveur Riot original ; elle ne qualifie ni ses valeurs ni son timing, et n’est pas encore installée par ce checkpoint.

Les 24 domaines, 114 tâches et 37 exigences restent ouverts. Preuve : E:\mapslol3v3\Root_R_GUI_dense_audits_checkpoint_v1\evidence.json

## 2026-10-17 — Politique verticale locale et rendu partiel du R

La hauteur courante est produite par la politique locale explicite `map10_restored_r_release_local_v1`, sans substituer une origine cachée ou une hauteur 0 en cas d’absence. La projection réseau reste un fait courant visible ; le dessin exige une autorisation FoW actuelle distincte du stamp de pose figée. Le groupe 2 original constitue une tranche intégrée, pas le R complet. Les tests/compilations ne sont pas une observation GPU, audio ou native. Un futur constat GUI sera consigné séparément ; l’historique reste conservé.

Les 24 domaines, 114 tâches et 37 exigences restent ouverts. Preuve : E:\mapslol3v3\Root_R_current_vertical_render_checkpoint_v1\evidence.json

## 2026-10-17 - Presentation locale bornee des Sparks et impacts R

Le groupe 1 original et les trois sons d impact sont raccordes selon des politiques locales explicites, avec la meme atomie OLSR et les gardes de visibilite courantes. Le merge conserve les deux suspensions audio et les quatre revocations Sparks. Les tests/compilations ne qualifient ni GPU, audio observe, performances ni parite native. Une observation ordinaire future sera consignee separement. L historique et tous les domaines ouverts sont conserves.

Les essais 9445 (erreur de type avant execution client) et 81626 (1 199 tests client reussis, un census incorrect) restent archives comme echecs non qualifies. H3 ne change que l assertion du test pour compter les composants Actor. Les deux corrections de test ne changent ni production ni inventaire ; seule la nouvelle qualification H3 complete produit les resultats presentes.

Les 24 domaines, 114 taches et 37 exigences restent ouverts. Preuve : E:\mapslol3v3\Root_R_audio_sparks_checkpoint_v3\evidence.json

## 2026-10-17 - W, OnCast R et flash : comportement local explicite, archive locale bornee

Les 70 cas nouveaux portent le total a 3 217 apres vrais build0/read0, sans effacer les echecs H1/H2, la correction H3 ni ses observations. Le W joue la fenetre locale du clip a vitesse normale. Le OnCast conserve les trois PCM entiers et se retire sur perte d autorisation sans replay tardif. Le flash groupe3 emploie un ancrage terrainY local et son propre etat visuel ; il ne draine pas la file audio. Le journal et la naissance audio ont des horizons distincts. L archive locale append-only de 243 ressources preserve les 15 anciens packs ; aucune portabilite complete ni publication n est revendiquee.

Ces preuves de compilation et de tests CPU ne qualifient ni pixels, son observe, performance, callbacks natifs, ni kit ou jeu complet. Une observation ordinaire future consigne ses propres preuves, eventuellement l audio du seul processus jeu. Les 24 domaines, 114 taches et 37 exigences restent ouverts. Preuve : E:\mapslol3v3\Root_W_OnCast_flash_guarded_pack_checkpoint_v2\evidence.json

## 2026-10-17 - Un lot commun pour les groupes d impact R

Les 53 nouveaux cas portent le total a 3 270 apres vrais build0/read0. Magicdust, spinlines et Rays sont regroupes avec la retention de 150 ticks ; Flash reste herite. Le collecteur visuel et l audio restent distincts. Les comportements locaux declares ne sont pas presentes comme fidelite native complete.

Le baseline reel de 16 packs conserve 7 490 lignes ; deux archives existantes ajoutent cinq ressources, donnant 18 packs, 7 495 lignes et 248 ressources surveillees. Le lecteur successeur multiZIP est distinct du lecteur historique WCF. Aucun runtime intermediaire ni observation future n est invente. Ces preuves CPU ne qualifient pas les pixels, performances, sons, calendrier natif, portabilite, kit ou jeu complet. Les 24 domaines, 114 taches et 37 exigences restent ouverts. Preuve : E:\mapslol3v3\Root_R_impact_all_groups_pack5_checkpoint_v1\evidence.json


## 2026-10-17 - Diagnostics locaux bornes du launcher

Le lot de quatre fichiers conserve uniquement des codes fixes issus des flux stdout/stderr, sans journal brut ni collecte de stdin/env/arguments. Six tests actifs et une fixture ignoree restent distincts. La distribution demeure inchangee ; aucune absence de message ne devient une preuve audio. Les observations futures et la fidelite du jeu restent non qualifiees. Preuve : E:\mapslol3v3\Root_Launcher_bounded_child_diagnostics_checkpoint_v1\evidence.json


## 2026-10-17 - Integration groupee W/E et diagnostics R

Les 31 fichiers conservent les composants relus : missile W courant, preparation animee E et observation OnCast par codes fixes bornes. La distribution ajoute seulement les cinq ressources W originales. Les deux fixtures ignorees ne comptent pas comme tests passes. Ni le premier sink ni les compilations ne prouvent l audibilite ; la tentative Pack5 sans R demeure non qualifiante. Preuve : E:\mapslol3v3\Root_Ezreal_WE_OnCast_diagnostics_pack5_checkpoint_v1\evidence.json


## 2026-10-18 - E courant, trois groupes et cinq textures originales

Lot unique depuis3337 :105 tests supplementaires reellement passes,46cibles/37Rust/2DATA/5DDS/2distribution. Les trois groupes du missile courant utilisent une RNG partagee et les gardes FreshDraw/FoW privees. Le binding runtime est une politique locale nommee, pas une capture d instance historique. Les19 packs anterieurs sont conserves ; pack20 ajoute cinq DDS exacts. Aucun effet depart/arrivee ni audio E nouveau, aucune qualification native, GPU, visuelle ou du jeu complet. Preuve : E:\mapslol3v3\Root_Ezreal_E_full_current_renderer_checkpoint_v4\evidence.json


## E flashes, R sampler et Pause — suivi technique

Lot E flashes / R sampler / Pause : 3477 tests passes (1910 core, 1468 client, 48 serveur, 40 launcher, 11 Bevy), dix operations fraiches et trois compilations normales, puis relecture0 et promotion reelles. 28 cibles : 9 remplacements et 19 ajouts ; 2222 sources et 1142 Rust selectionnees. La premiere tentative reste archivee en echec : core1910, serveur48 et client1467 passes, un setup de test Pause refuse. Une seule fixture utilise desormais un vrai handshake de reprise ; les 27 autres postimages et la production restent identiques. Les deux groupes flashes E, le correctif du sampler R et la pause autoritaire sont integres. Les trois DDS originales sont ajoutees au pack21 (7508 lignes, 261 ressources gardees). La politique locale des flashes dure au plus 0,75 s ; les autres groupes du cast E et son audio restent incomplets. Observation H4 conservee : blink E vu, projectile E non confirme, niveau4 puis defaite13:02, aucun R ni captureaudio. Aucune observation du runtime courant, qualification GPU/audio/native ou completion globale n’est deduite des tests. Preuves : E:\mapslol3v3\Root_Ezreal_E_release_flashes_R_sampler_pause_checkpoint_v3\evidence.json

Observer normalement la pause et la reprise, E appris et lance vers une cible visible, puis R appris au niveau 6. Consigner uniquement les effets, HUD et sons effectivement observes, puis fermer jeu et launcher. Les flashes locaux E, le sampler R et Pause sont integres; aucun resultat GUI ou audio futur ne vaut acquis.

<!-- ezreal-e-release-flashes-r-sampler-pause-v3 -->


## Arrival E audio, boutique et recapitulatif prive — suivi technique

Lot Arrival E audio, boutique et recapitulatif prive : 3513 tests passes (1923 core, 1489 client, 50 serveur, 40 launcher, 11 Bevy), dix operations fraiches et trois compilations normales, puis relecture0 et promotion reelles. 23 cibles : 10 remplacements et 13 ajouts ; 2235 sources et 1151 Rust selectionnees. Le journal accepte Arrival dispose de son propre watermark audio, independant des VFX, avec un mix local explicite ; la boutique affiche un entier et le recapitulatif reste reserve au joueur mort selon les faits autorises. Trois WAV completes decodees des medias originaux sont archivees dans le pack22 local (7511 lignes, 264 ressources gardees). Cette archive locale ne constitue pas une livraison portable complete. La reparation du parent3477 et son echec anterieur restent conserves, ainsi que ses observations ordinaires sans deduction de reussite. Dans la GUI3477 fermee, E et ses recharges ont ete observes ; le niveau6 a ete atteint, R appris puis lance avec recharge80 et mana389/488. La capture du processus contient un signal PCM (pic6595, RMS329), sans validation humaine de l audibilite ni de la fidelite native. Les deux pressions synthetiques de Pause de la GUI3477 ne qualifient pas une reaction utilisateur normale. Aucune observation du runtime courant, audibilite, qualification GPU/native ou completion globale n est deduite des tests. Preuves : E:\mapslol3v3\Root_Ezreal_E_arrival_audio_shopgold_death_recap_pack22_checkpoint_v1\evidence.json

Observer avec les entrees ordinaires E et son arrivee, le compteur entier de la boutique et le recapitulatif prive apres une mort survenue en jeu. Conserver une preuve audio propre au processus si disponible, sans deduire l audibilite d un AudioSink. La pause/reprise reste a verifier par un controle utilisateur ordinaire distinct : les deux pressions synthetiques de la GUI3477 ne constituent pas une reussite. Consigner seulement les faits observes, puis fermer jeu et launcher. Aucun resultat visuel, audio, natif ou full-game ne vaut acquis.

<!-- ezreal-e-arrival-audio-shopgold-death-recap-pack22-v1 -->


## ArrivalHeads, bouton Pause et flash Q — suivi technique

Lot ArrivalHeads, bouton Pause et flash Q : 3565 tests passes (1923 core,1541 client,50 serveur,40 launcher,11 Bevy), dix operations fraiches et trois compilations normales, puis relecture0 et promotion reelles. Le premier essai24 reste un echec reel :1923 core et50 serveur passes,1540 client passes et une assertion Q echouee. La seule reparation conserve les projections Q historiques et verifie leur admission OLSR ; aucun code de production ni nom de test ne change. Le preflight de reparation refuse avant mutation et la reparation effectivement installee restent lies separement. 24 cibles :7 remplacements et17 ajouts ;2252 sources et1165 Rust selectionnees. Les deux groupes ArrivalHeads restent une reconstruction locale bornee ; le bouton Pause suit la demande et son acquittement autoritaires. Le flash Q consomme seulement un impact accepte deja projete, avec terrain public et controles FoW/epoch propres. Trois DATA compile-time sont ajoutes ;22 packs,7511 lignes et264 ressources gardees sont conserves sans nouvel asset de distribution. La GUI3513 precedente a observe le blink E, les compteurs entiers de boutique et le recapitulatif prive au deces puis son retrait au respawn. Son rapport PCM identifie une variante E dans la sortie du processus ; cela ne qualifie ni l ecoute humaine ni le mixage natif. Pause n a pas ete actionnee dans cette session precedente. Les echecs et reparations3477 restent lies comme historique. Aucune observation du nouveau runtime, qualification GPU/audio/native ou completion globale ne decoule des tests. Preuves : E:\mapslol3v3\Root_Ezreal_E_arrival_heads_pause_Q_flash_checkpoint_v2\evidence.json

Observer normalement le bouton Pause, son acquittement autoritaire et la reprise recue ; apprendre E et observer les groupes ArrivalHeads avec capture audio du seul processus si utile, puis lancer Q sur une cible visible pour observer un impact accepte. Conserver les refus, absences et limites comme faits. Fermer ensuite jeu et launcher. Aucun resultat visuel, humain, natif ou full-game ne vaut acquis.

<!-- ezreal-e-arrival-heads-pause-q-flash-v2 -->
