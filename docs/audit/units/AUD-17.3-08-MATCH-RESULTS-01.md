# AUD-17.3-08-MATCH-RESULTS-01 — Résultats victoire et défaite

2026-10-31 ; F:\OpenLeague ; goal SYS-01.2-02. Parent SYS-17.3-08 « Afficher les résultats de victoire et défaite ». Exigence OLF-bdfdb622-db53-5637-9782-dd807838d670 ; inconnue OLU-826406c9-c536-53ad-81cc-9db5ae36064f. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB,catalogue4.20.1 distinct.

## 1. Périmètre et décision

Question : quelle source terminale produit les faits de victoire/défaite,comment le client les présente-t-il,puis quel raccordement ou quelle preuve manque ? Toutes les clauses de présentation du parent sont couvertes : résultat immuable,membre/équipe,réception,phase,splash,tableau final,dismissal,absence/changement de résultat et frontières de retour. Caméra/audio/minions,backend d’historique et classement sont des consommateurs liés distincts ; ils ne sont pas reconstruits ni déclarés complets dans ce lot.

**Audit documentaire parent terminé sous contrôle de la relecture indépendante. Fonctionnalité complète non terminée.** Le résultat autoritaire et les écrans actuels existent ; ils ne sont pas déclarés manquants. Implémentation : partielle locale,rien modifié. Vérification : nouveaux exports statiques et comparaison d’assets,18tests existants réutilisés,3captures historiques effectivement relues ; aucune partie ou test de jeu relancé. Acceptation humaine : non donnée. Le reçu producteur garde audit_scope_closed=false jusqu’au reçu indépendant delivery-readback.json et à ses sept rubriques.

Critère de sortie du petit lot : source→faits figés→état admis→phase/vue et entrées/sorties décrits avec identités,branches attendues/observées et limites ; chaque écart a une correction unique ou une tâche existante et son entrée de reprise. Aucun objectif ou critère normatif du goal ne change.

Prérequis : D17-SYS-17-3 requiert D20-SYS-20-3 « Connexion et reconnexion »,encore a_faire,qui requiert D20-SYS-20-1. Ces prérequis ne sont pas déclarés acquis par un audit. Le tour précédent est un progrès : audit complet de présentation de reconnexion,270contrôles de relecture et preuves réutilisées. Son erratum V6-fin est conservé : SYS-17.3-08 concerne bien les résultats ;07 concerne la reconnexion. La cérémonie de reddition reste ouverte dans V6,ce renvoi n’en prouve pas l’implémentation.

## 2. Sources natives,contrats et assets

### Référence de ressources et de phase déjà acquise

Quatre documents consommés actuellement sont relus avec source brute et identité : data/4.20/endgame_ui_native.json,native_endgame_default_timing.json,endgame_lua_source_audit.json,native_endgame_lua51_contract.json.

Le catalogue classique pointe DATA/menu/EndOfGame.gfx,SHA-256 3d2f17dd944ca14b66aee9177e25a5c8f4637557758734d5ced34c5f0a479954. Les getters pointent le PE15973880octets,SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le script original DATA/Scripts/EndOfGame.luaobj est5548ca1ce30a6bc2740d787b2bc224c5d11f06d89ca9b2dcd8659e1e4a263379. Les ressources originales sont dans le même déploiement RADS4.20 sur D.

Preuve héritée conservée : valeurs de constructeur/getter par défaut et ancien contrat Lua5.1 avec16cas,dont8avec use_death_animation=false,roundtrip exact et tableaux d’instructions préservés. Le contrat fait intervenir une VM Lua5.1 et des adaptateurs d’API/timers ; ce n’est pas le binaire de VM embarqué du jeu original. On ne relance ni les getters ni les16cas.

Le consommateur courant prend nexus_skin=3.5 et le littéral EOG_SCOREBOARD_PHASE_DELAY_TIME=2.0,soit5.5s. Les huit cas par défaut du contrat conservé demandent EndGame à5.5. Les limites restent explicites : initialisation complète,overrides par mode,appelant et ordonnanceur d’origine,réception réseau et origine de phase non qualifiés. Les autres branches de configuration ne sont pas assimilées au défaut.

### Nouveau contrat de vue,exporté sans exécution ActionScript

Une piste nouvelle précise les comportements de l’interface et de Continue,au-delà des anciens tags de layout : export des classes de DATA/menu/EndOfGame.gfx et DATA/Menu_SC4/EndOfGame_Default.gfx avec Java/JVM/FFDec déjà installés et identifiés par empreintes. Aucun téléchargement ni installation. Commandes headless exactes,horaires,journaux,producteur et fichiers de sortie sont dans results-extraction-receipt.json.

Deux exports code0 :31fichiers pour menu,70pour Menu_SC4,101au total. Les variantes sont distinctes ; aucune sélection native effective n’est prétendue qualifiée. Les scripts ne sont pas exécutés.

| Variante | Source et comportement établi statiquement | Limite |
|---|---|---|
| Classique AS2 | CommandParser enregistre SetIsVictory,OpenSplashScreen,CloseSplashScreen et layout. EndOfGame choisit la vue,compare les valeurs aux littéraux false/0,ouvre par animateTo(...,20),ferme les deux splashs. | Le20n’est pas transformé en durée réelle sans contrat de son moteur. Aucune table de coercition AS2 exécutée ni sélection de movie prouvée. |
| Classique Continue | Les deux classes VictorySplash/DefeatSplash donnent commName=Continue. DefaultButton transmet Press_Continue au relâchement par sa chaîne sendClickMessage/Comm/fscommand. | Ce message ne prouve pas son récepteur C++ ni que l’action historique ouvre un tableau dans le même processus. |
| SC4 AS3 | EndOfGameModule lie DisplaySplash,HideSplash,SetViewport,SetLocKeyModifier ; choisit statique/animé selon useAnimatedSplash. EndOfGameRoot peut revenir au statique si vidéo absente/erreur d’intro. | Les paramètres de démonstration ne sont pas un choix de mode ou de configuration historique. Pas de lecture vidéo ni de fallback réellement exécuté ici. |
| SC4 Continue | Bouton PRESS→Event.CLOSE→handleClose→ExternalInterface.call("EndGame"). LocalizeText et modificateur de clé pilotent le texte ; viewport arrondit son échelle selon son propre code. | Ce contrat n’est pas le Press_Continue classique. Pas d’équivalence automatique avec le garde de relâchement Rust. |

La nouvelle extraction distingue ainsi intention de fermeture,animation,viewport et localisation. Elle ne qualifie pas la fabrique/selector4.20,le handler hôte,les transitions AIR/Maestro ni le rendu natif. Les variantes ne sont pas fusionnées pour remplir les manques l’une de l’autre.

### Dix images actuelles comparées à leurs sources natives

Pour victory,defeat,les six états de bouton et les deux titres : hash DDS original,hash PNG actuel,dimensions et comparaison intégrale des octets RGBA sont enregistrés. **Les10images sont identiques pixel RGBA par pixel RGBA à leurs DDS sources décodés.** Pillow12.3.0,Image,plugins DDS/PNG et module natif sont identifiés. Comparaison strictement en mémoire ; aucun asset créé,retouché ni remplacé.

C’est une preuve de conversion des sources actuelles,pas une preuve de rendu natif,de choix de locale ou de shader. Les titres utilisent des atlas fr_FR avec rectangles déjà sélectionnés ; le consommateur emploie en plus CONTINUER et des chaînes françaises fixes. La référence demandée est EUW/en_GB. Ce décalage de sélection/localisation reste ouvert ; il n’implique pas une corruption des images.

## 3. Consommateurs actuels et faits affichés

| Rôle | Consommateur réel | Établi / frontière |
|---|---|---|
| Déclencheur légal courant | core/world.rs:414 ; lib.rs:684–721 | Destruction du Nexus fixe winner et l’avancée capture la fin. SYS-10.3-08 reste le lot de victoire légale ; un winner injecté dans un test ne vaut pas une partie ordinaire. |
| Résultat immuable | core/match_results.rs:15–28 | Premier résultat conservé ; gagnant filtré0/1 ; roster figé avec champion,niveau,KDA,or,inventaire,session/tick et métadonnées Nexus. Pas de cause explicite de reddition. |
| État envoyé | core/lib.rs:764–796 ; vision.rs:137–154 | result est cloné dans le snapshot ; filtre courant des corps visibles distinct du roster final. La divulgation historique exacte reste une politique à qualifier,aucune donnée non suivie inventée. |
| Admission/commit | client/session_client.rs:141–158 ; main.rs:1327–1340 | État accepté dans la route de session,puis snapshot committé avant presented. Cela ne constitue pas à lui seul une validation complète des invariants internes de MatchResult. |
| Phase | client/endgame_timeline.rs:1–24 | Clock keyed(session,ended_tick),démarre au premier résultat reçu et fixe la limite locale5.5 ; absence/changement réinitialise. Pas de compensation de latence/native scheduler revendiquée. |
| Splash victoire/défaite | client/native_endgame_ui.rs:1–47 | Résultat.players sert à trouver l’équipe du membre local ; membre absent→pas de splash éligible. Affichage après deadline,avant dismissal. Choix bleu/rouge,rectangles/titres et états de bouton réellement raccordés. |
| Récapitulatif final | client/match_results_ui.rs:12–42 | Après view.dismissed,affiche faits du roster figé,et non players vivants. Victoire/défaite selon équipe locale ; absence d’équipe→PARTIE TERMINÉE. Présentation locale de champion,niveau,KDA,or restant et durée ; ne pas la présenter comme toutes les statistiques historiques ou les récompenses. |
| Continue et même frame | native_endgame_ui::update ; câblage main.rs:848–855 | Garde press+relâchement survolé,avant deadline inactif ; dismissal retire le splash dans la même Update,avant tableau. Le traitement local ne prouve pas callback natif ou retour Tauri. |
| Sortie | session_departure.rs:10–42 | Bouton après dismissal et résultat correspondant à session/membre,AppExit::Success ; erreur sécurisée conserve reprise. SYS-17.3-09 reste le lot de retour au launcher. |
| Stockage | server/main.rs:208–223 ; result_store.rs | Publication idempotente non écrasante et synchronisée,avec nouvelle tentative sur erreur ; ne prouve pas historique de profil/classement/récompense. |
| Cérémonie | nexus_ceremony.rs:1–29 | Consomme métadonnées du Nexus perdant et échéance de skin. Camera/audio/minions ont des consommateurs liés ; anciennes notes les disant absents ne suffisent pas à conclure sur leur état courant. Leur fidélité complète n’est pas démontrée par la seule présence. |

Les systèmes sont réellement inscrits et ordonnés dans main : réception→horloge de phase/splash→tableau/retour. Le corpus des1 168sources Rust/launcher est relu avec contenu et appartenance inchangés. Aucun code de jeu modifié.

Invariants à ne pas élargir : la capture serveur normale borne winner0/1 et fige le résultat,mais les vues inspectées s’appuient sur ce contrat. Absence de résultat,membre local manquant,changement de session,ancien résultat ou données discordantes doivent conserver des critères explicites ; on ne prétend pas avoir testé toutes les entrées négatives possibles. view.session et Clock.key ont des portées différentes,compatibles avec un résultat unique normal par session,à préserver lors de toute extension.

La durée affichée divise ended_tick par30,qui correspond au tickrate courant. Le format arrondi d’or n’ajoute pas une mesure de revenu total. L’inventaire est conservé dans le résultat mais pas affiché par ce texte local. Aucun dommage,CS,récompense ou classement absent n’est rempli fictivement.

## 4. Preuves d’exécution et de rendu réutilisées

### Dix-huit tests de composants et sources actuelles

Le runtime avancé Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2,SHA-256 31ec67495ea4165b6ce1c91dc0c766b60ebb47f2bafca72451b2e34c10710edd,est lié à sa promotion,compilation terminale code0,read0 distinct code0,qualification et journaux terminaux vérifiés.

**18lignes réellement « ok »** :2résultats core,3phase/Lua,2tableau,4splash,3cérémonie Nexus,3départ et1stockage. Dix sources ciblées correspondent exactement au run,y compris main.rs et les consommateurs de vue. Les essais vérifient notamment : roster final après départ,absence de résultat,choix bleu/rouge,geste non armé,deadline,passage splash→tableau dans la même frame,skin différé et publication idempotente.

Ces assertions ne sont pas18parties normales ; certaines injectent winner ou appellent directement le producteur de dégâts. Elles ne requalifient pas toutes les dépendances,chaque binaire courant ou le rendu GPU. Aucun essai répété maintenant. Les anciens résumés d’octobre5 sont conservés,mais leurs limites « non implémenté » ne sont pas réattribuées aux versions plus avancées sans inspection.

### Victoire ordinaire conservée,avec trois frontières de qualification

Observation nommée endgame_ordinary_observation/run-20261013-1713-fade-fixed/observation.json : passed=true pour ses gates déclarées,complete=false,aucune injection d’état,6participants dont1GUI+5UDP. Le résultat reçu puis sauvegardé est encore disponible et identique : session1791911630542225100,ended_tick25858,winner0,six Garen,Nexus perdant équipe1. Le résultat persiste sous son chemin historique E ; cela ne prétend pas être la base actuelle du projet F.

Le run conserve sources et binaires identifiés,client_exit_code0/server_exit_code0. Il a exercé les consommateurs réels Continue/tableau/Return par entrée programmatique. Ni clic physique,ni retour réel Tauri,ni sixGUI,ni temps exact d’exposition GPU ne sont qualifiés. La stratégie et les règles reconstruites ne prouvent pas la totalité du combat/IA natifs.

Comparaison aux dix sources actuelles conservée : certaines sont identiques,notamment native_endgame_ui.rs et match_results_ui.rs ; d’autres ont changé,notamment le core et main.rs. Les captures restent des preuves historiques de leur version ; les18tests plus récents correspondent aux sources ciblées actuelles. Aucune différence d’empreinte ne devient automatiquement une régression ni une requalification globale.

L’ancien gate framebuffer_reviewed=false reste intact. Deux captures sauvegardées de ce run ont été réellement ouvertes avec view_image maintenant ; la présente unité ajoute une revue visuelle de portée précise sans réécrire ce gate ni promouvoir tout le run :

| Image conservée | Constat visible relu | Limite |
|---|---|---|
| ui/native-splash.png | Grand cadre bleu VICTOIRE,titre et CONTINUER lisibles,Hud/map encore derrière,horloge14:21. | Pas de comparaison framebuffer natif ; HUD visible n’est pas déclaré bug sans référence du même état. |
| ui/results-panel.png | VICTOIRE équipe1,durée14:21,trois Garen par équipe ; or2539/1179/1368 puis2239/2239/2239 ; bouton retour entièrement visible. Aucun splash ne chevauche ce tableau. | Un seul point de vue graphique ; aucun clic physique ni launcher Tauri observé dans ces pixels. |

Troisième image effectivement relue : session_lifecycle_game/results_before_layout_fix.png,liée à une ancienne défaite ordinaire sans winner injecté. Affiche DÉFAITE équipe2,durée18:45,un Garen ; bouton retour recouvert en partie par l’ancien HUD. Ce défaut historique est conservé,avec sa version ; il ne prouve pas le même défaut actuel. Le tableau plus récent et les tests de hiérarchie montrent l’acquis ultérieur. Cette image n’est pas une preuve actuelle symétrique de défaite à six joueurs.

Les binaires historiques du run ordinaire sont identifiés dans la preuve,ainsi que les captures,runtime,résultat reçu et résultat sauvegardé ; aucun binaire n’a été exécuté maintenant. Les3captures sont des images héritées réellement vues,et non des captures nouvelles ou une déclaration d’acceptation humaine.

## 5. Attendu/observé et contrôles du lot

| Cas | Attendu précis | Observé / limite |
|---|---|---|
| Victoire et défaite du membre local | Choix cohérent avec le roster final,actifs bleu/rouge adéquats | Source actuelle et tests bleu/rouge conservés ; victoire ordinaire plus avancée et ancienne défaite relues,portées distinctes. |
| Résultat absent/membre absent/identité | Ne pas afficher un résultat trompeur ou ancien | Branches absence et membre lues,tests ciblés ; invariants discordants complets à qualifier,aucun succès généralisé. |
| Deadline et réinitialisation | Caché avant la phase,geste ignoré avant deadline |5.5par défaut,horloge locale et tests conservés ; overrides et origine de phase native/réseau restent ouverts. |
| Continue | Retrait du splash avant tableau,aucune superposition résiduelle | Garde armé et test de même frame ; image du tableau actuel de son époque sans splash. Handler historique et geste physique non qualifiés. |
| Départ après fin | Résultat et joueurs finaux conservés | Source et essais de roster immuable/stockage ; retour vers vrai launcher séparé. |
| Import d’images | Provenance/pixels actuels non inventés |10hashes DDS/PNG,dimensions et RGBA exacts ; choix de langue et fidélité de rendu non déduits de l’égalité. |
| Texte,locale,viewport et animation | Source/variante exactes,pas de substitut silencieux | Contrats natifs distincts ; présentation française fixe,échelle/tween/glow/textes natifs non qualifiés globalement. |
| Redditions/autres causes | Résultat et cérémonie adaptés à la cause réelle | Reprise de SYS-17.3-06/V6-fin ; pas de cause explicite actuelle ; aucune fausse preuve par winner injecté seul. |
| Persistance et statistiques | Résultat figé unique et contenu tracé | Fichier historique reçu/sauvegardé relu ; historique de profil,classement et récompenses restent dans leurs tâches propres. |

Contrôles réellement exécutés : extract_results.py,code0,2sous-commandes FFDec code0,101scripts nouveaux ; verify_match_results.py,code0,**220contrôles documentaires réussis**,dont comparaison des10images existantes ; lecture effective de3images héritées. verify_delivery.py produit une relecture indépendante des sept rubriques,avec le nombre exact et tous les attendus/observés dans son reçu.

Non exécutés maintenant : Rust/Cargo,jeu original ou local,VM Lua,ActionScript,GPU,réseau,partie,vote,clics et captures nouvelles. Le seul traitement de nouveaux scripts est un export statique headless avec outil existant. Aucun asset retouché,aucun résultat ou succès de partie fabriqué. Les220contrôles ne sont pas220nouveaux tests de jeu.

## 6. Résolu,écarts et corrections atomiques

Résolu dans l’audit : chaîne complète des faits figés vers les deux vues actuelles ; source et contrats de deux variantes natives distingués ; pixels des10images actuelles comparés aux DDS ; composant de phase/dismissal/persistance actuel relié à18tests ; victoire ordinaire historique et ancienne défaite relues avec leurs limites. L’ancienne absence de revue des deux framebuffers est comblée pour les observations visuelles décrites,avec gate initial conservé. Aucun écart fonctionnel corrigé pendant ce lot.

Ouverts : sélection/callbacks de variante,locale et substitution de titres,textes et contenus complets,origine de phase/overrides,parité de présentation et certaines frontières de vie du résultat,comparaison actuelle des deux issues et retour réel. Caméra/audio/minions,sixGUI,historique/classement et récompenses demeurent séparés ; présence de code,PNG ou gate partiel ne vaut pas leur achèvement.

Réutilisation des vrais objectifs du plan :


- SYS-10.3-08 : Déclencher la victoire uniquement après destruction légale du Nexus

- SYS-10.6-02 : Jouer une victoire bleue par destruction ordinaire du Nexus rouge

- SYS-10.6-03 : Jouer une victoire rouge par destruction ordinaire du Nexus bleu

- SYS-10.6-06 : Vérifier les résultats et récompenses uniques des six joueurs

- SYS-16.3-07 : Déclencher les annonces de victoire et défaite

- SYS-17.3-06 : Créer et résoudre un vote d’abandon selon les règles historiques

- SYS-17.3-09 : Retourner au launcher après fermeture ou crash du client de partie

- SYS-19.2-07 : Persister les statistiques et l’historique des parties

- SYS-20.5-06 : Comparer résultat, inventaires et ressources des clients au serveur final

- SYS-23.3-01 : Jouer victoire et défaite dans chaque mode requis

- SYS-23.3-05 : Vérifier l’unicité des résultats et récompenses de chaque parcours


Les six propositions suivantes sont proposed_not_applied ; dépendances et critères sont documentaires,aucun registre du plan ou critère du goal modifié. La correction V6-fin conserve son erratum exact,non recopié comme une fausse tâche de reconnexion.


### RESULTS-NATIVE-VARIANT-01 — Qualifier la variante et le callback natifs

Écart : Classic AS2 et SC4 AS3 ont des contrats distincts ; sélection originale non qualifiée et Continue local ne prouve pas callback historique.

Travail : Relier provider/selector4.20 aux paramètres de victoire et ouverture/fermeture ; classicPress_Continue versus SC4Event.CLOSE→EndGame ; conserver choix local explicitement nommé si historique inconnu.

Critère de fin proposé : Variante et appelant établis pour le mode/profil visé,avec contrat de fermeture réel ; aucun mélange de contrats ou démo promu en preuve.

Entrée de reprise : Callsite/provider4.20 nommé ou observation originale discriminante,avant reconstruction de comportement.

Réutilisation : SYS-17.3-09.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


### RESULTS-LOCALIZATION-01 — Raccorder langue et contenu des résultats

Écart : Titres atlas fr_FR et textes français fixes sur référenceEUW/en_GB ; dictionnaire/atlas natif dynamique non qualifié.

Travail : Réutiliser clés flash_endOfGame_victory/defeat/continue et contrat de locale ; choisir titres/textes/bouton et formatter,avec fallback explicite et provenance.

Critère de fin proposé : en_GB/fr_FR demandés affichent les éléments adéquats et les mêmes faits autoritaires ; absence/fallback tracés,aucun atlas français présenté comme sélection nativeen_GB.

Entrée de reprise : Provider de locale et variante établis,message/asset exact et comparaison rendue définis.

Réutilisation : RESULTS-NATIVE-VARIANT-01.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


### RESULTS-PHASE-ORIGIN-01 — Qualifier origine et règles de phase

Écart : 3.5+2=5.5s est un défaut identifié ; horloge locale démarre au premier résultat reçu,ni propagation native ni override/décalage/reprise qualifiés.

Travail : Conserver défauts et preuvesLua ; identifier événement terminal,base de temps et configuration effectifs ; décider contrat de reprise etlatence sans inventer compensation.

Critère de fin proposé : Déclencheur et échéances effectifs définis et observés,absence/changement de résultat réinitialise correctement ; valeurs par défaut distinctes des overrides.

Entrée de reprise : Source de configuration et producteur de phase nommés,ou politique locale explicitement décidée ; nouveau cas ciblé avant exécution.

Réutilisation : SYS-10.3-08, SYS-17.3-07.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


### RESULTS-PRESENTATION-PARITY-01 — Qualifier la présentation du résultat sélectionné

Écart : Assets et coordonnées classiques sont utilisés,mais ouverture/tween/glow,viewport et substituts de texte natifs ne sont pas reproduits ou qualifiés globalement.

Travail : Comparer la variante choisie à la vue courante : layout,ordre,titres,bouton,fade et états ; conserver atlas/images sources et délimiter caméra/audio/minions déjà partiels.

Critère de fin proposé : Comparaison du même état et profil documentée avec bornes/gestes lisibles,sans prendre une conversion RGBA ou un snapshot pour rendu fidèle complet.

Entrée de reprise : Variante/locale établies et référence de vue du même état ; intervention fonctionnelle autorisée distincte si correction requise.

Réutilisation : RESULTS-NATIVE-VARIANT-01, RESULTS-LOCALIZATION-01, SYS-16.3-07.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


### RESULTS-LIFETIME-CONTENT-01 — Qualifier cohérence et durée de vie du résultat affiché

Écart : Le chemin normal serveur fige les faits ; vue/splash dépendent du membre local et de dismissed,mais contrat des cas absents/discordants et couverture complète des contenus restent bornés.

Travail : Conserver roster figé/persistance et définir invariants résultat-session-joueur-gagnant,fin valide,champ absent et contenu du tableau ; ne pas substituer des statistiques non suivies ni réutiliser un état de vue ancien.

Critère de fin proposé : Résultat valide affiché à chaque équipe une seule fois ; absence/ancien contexte/incohérence ne montre pas un résultat trompeur ; contenus manquants explicites et départ n’altère pas le roster final.

Entrée de reprise : Contrat de contenu/invariants défini sur le consommateur réel et entrées négatives nommées ; reprise des tâches de résultats/synchronisation existantes.

Réutilisation : SYS-10.6-06, SYS-20.5-06, SYS-19.2-07, SYS-17.3-06/V6-fin.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


### RESULTS-REAL-OUTCOMES-01 — Qualifier les deux issues sur le parcours installé

Écart : Victoire ordinaire1GUI/5UDP et ancienne défaite existent,mais pas de comparaison complète actuelle des deux issues,gestes physiques et retour réelTauri.

Travail : Réutiliser18tests et images conservées ; après changement ou cas discriminant,observer victoire/défaite des deux équipes avec identités/binaires/ressources,Continue→tableau→sortie réelle ; séparer sixGUI et acceptation humaine.

Critère de fin proposé : Deux issues et gestes réellement observés dans la version retenue,avec chronologie et absence de chevauchement ; retourTauri ou absence explicitement constaté,sans exiger ni prétendre sixGUI pour une simple capture locale.

Entrée de reprise : Version et cas manquant précis disponibles ; preuve historique insuffisante seulement pour ce cas ; pas de répétition à l’identique des18tests ou du run déjà conservé.

Réutilisation : SYS-10.6-02, SYS-10.6-03, SYS-23.3-01, SYS-17.3-09.

Preuve attendue : Source/contrat et consommateurs exacts,attendu/observé des seules branches affectées,preuves datées avec identités si exécution ; technique distincte de rendu complet et acceptation humaine.


## 7. Livraison et conservation

Nouveaux fichiers uniquement. Seul nouveau document du dépôt : docs/audit/units/AUD-17.3-08-MATCH-RESULTS-01.md. Sous F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01 : cadrage,extracteur,101scripts exportés,deux journaux,reçu d’export,lecteur d’audit,preuve,lecteur indépendant et futur reçu. Chaque reçu est une création exclusive,les fichiers exécutés et les anciennes preuves ne sont pas remplacés.

Les19fichiers logiciels gelés,les six documents de contexte/méthode et les cinq registres normatifs restent identiques ; appartenance/contenu du corpus1 168sources vérifiés. Git : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,branchemain,76modifications suivies préexistantes et statut exact conservés. Aucun add/commit/reset/clean/checkout. Aucun sous-agent.

Goal et critères inchangés. Suivi/UI/bases inchangés. Aucune base ouverte,aucun appel Plan/work_cli/Store,aucune installation,migration,suppression ni relance d’application. Les ressources sur D,les captures/outils/provenances sur E et les assets actuels sur F sont lus seulement ; aucun PNG/DDS changé.

Relecture R1–R7 : parent et prérequis ; sources natives et export/provenance/pixels ; consommateurs réels ; attendu/observé et exécutions réutilisées ; manques/reprise ; six corrections précises et tâches réellement correspondantes ; identités/dates/conservation. audit_scope_closed=false dans le producteur ; delivery-readback.json établit la clôture documentaire après les sept rubriques. Le parent fonctionnel,son inconnue et le goal global restent ouverts.

Identités nouvelles avant relecture :


- F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\audit-unit.json ; 2408octets ; SHA-256 68155d2d7df6ba253d5d5d71e50be8ff1e6a52a8e0c1e2bcdc60eb87202278ab

- F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\extract_results.py ; 2985octets ; SHA-256 f78dbd25392474a7d8f26809f7ffc545cbd43e3a2d1a25dda9e15c3ee77735c0

- F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\results-extraction-receipt.json ; 33316octets ; SHA-256 d95fa392f53d4fe61d9c213fe2627df44e1c07b659b8b2a0d779fd558cadea84

- F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\verify_match_results.py ; 29378octets ; SHA-256 92a2c2cd3d8709315cf279d6649d031f7f00dd279a4dbb222b1b3e7398db549c

- F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\match-results-proof.json ; 258841octets ; SHA-256 cffb21024e7a16e2a2f22c0531ab7ee87c282ee253e4865848fa897b2a93656e


Le reçu indépendant identifie le rapport et son lecteur,sans référence circulaire ni modification d’une preuve antérieure.
