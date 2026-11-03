# SYS-01.2-02 — REA sur le client complet et chemins audio actuels, V745

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Le tour précédent V744 est classé comme progrès : deux fiches, leurs associations et les deux bases ont été modifiées puis relues indépendamment. Cette livraison poursuit le même objectif de traçabilité, sans déclarer le jeu terminé.

## Import complet réussi dans REA

REA6.4.0, Ghidra12.1.4, Java21.0.10 et Node24.22.1 existants sont réutilisés. Une copie exacte du PE original de15973880octets, SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, est analysée. Contrairement aux conteneurs V743/V744, cette entrée est le client complet, sans reconstruction d’en-tête. Aucun jeu n’est exécuté. Toutes les nouvelles analyses et temporaires restent sur F.

Session du29octobre2026, 04:24:48.405–04:34:37.799 UTC, environ589.394s au total. Budget d’import explicite1800000ms ; le timeout600000ms V742 est conservé comme observation antérieure distincte. Cette réussite ne prouve pas que l’allongement du budget était à lui seul nécessaire : la durée de cette nouvelle session est inférieure à600s.

L’import et les requêtes terminent sans erreur. REA décompile AF63B0 et B09F80 :55instructions/165octets recoupés avec Capstone et le PE. Les cinq recherches de références produisent22appels directs : AF63B0 reçoit B09FD4 ; B09F80 reçoit B07634 dans B06C60 ; B05ED0 reçoit16appels, B06370 deux et B05670 deux. Chaque CALL rel32 est décodé et son adresse cible recalculée depuis l’original. Le scan brut des sections exécutables concorde pour ces cinq cibles. Ce contrôle ne prouve pas l’absence d’appels calculés, de références non reconnues ou du producteur de commande20.

Bundle, requêtes, réponses, empreintes et confirmations close_binary/client/transport sont conservés. Le champ générique qualified du runner restefalse ; le présent vérificateur qualifie seulement les résultats précis ci-dessus. Le client complet importé n’équivaut pas à une vérification sémantique complète du jeu.

## Limite du pseudocode et de la signature reconstruite

Sur l’image entière, Ghidra propose une signature par défaut __stdcall, de faible confiance, et une variable in_ECX. Dans le petit conteneur V744, il proposait __thiscall. Les deux résultats sont conservés : ni le nom de convention ni les types reconstruits ne sont traités comme une déclaration C++ originale. Le contrat machine vérifié reste receiver dansECX, arguments sur pile et nettoyage par le callee de12octets pour AF63B0/16pour B09F80. Les instructions et les exécutions natives V744 établissent ce contrat ; aucune annotation n’est forcée pour rendre les analyses artificiellement identiques.

## Initialisation et conservation des objets audio natifs

384nouveaux cas exécutent AF5CE0 entier, la branche objet existant de B09BF0 et AF63B0 entier en mémoire Unicorn32 isolée : six octets de remplissage, quatre identifiants, quatre masques et quatre indices d’auditeur.91adresses d’instruction sont recoupées. Aucune fonction d’allocateur n’est substituée : la branche existante utilise un registre et un nœud fournis ; la création native par allocation reste hors de cette preuve.

Attendu et observé : le constructeur initialise les100octets de l’objet, en conservant uniquement les cinq bits hauts du mode+B provenant du remplissage. Il initialise les16octets d’obstruction/occlusion à+38..+47 àzéro, le masque à1, les champs flottants+48/+4C à1.0, l’identifiant+5C et les flags+60 àC0000001. Le registre existant actualise le masque bas8bits sans réinitialiser l’objet. Après l’écriture(.25,.75), les deux octets valent63/191 pour les indices0/7 ;8/FFFFFFFF donnent192refus sans modification. La seconde inscription conserve ces contrôles et ne change que le masque.768passages de réinscription vérifiés. Le registre et son nœud sont conservés.

Les identifiants0/FFFFFFFF sont des entrées diagnostiques des fonctions directes. Ils ne contournent ni ne qualifient les règles d’admission de l’API publique. Les collisions, objets absents et file complète de V744 restent des preuves héritées, sans nouvelle exécution revendiquée.

## Modèle et routes Rust réellement inspectés

Une sonde compile48fichiers source actuels inchangés et exécute les deux fonctions de audio_bank_deferred_consumer. Chacune refuse les480paquets originaux de commande20 avant tout service de corps, consommation ou mutation d’état. Huit contrôles supplémentaires couvrent marqueur de frame, élimination d’opcode inconnu40, taille invalide pour24 et refus des propriétaires/pending non vides. Les services non attendus provoqueraient un échec ; ils ne simulent aucun unload. Aucun déchargement de banque réussi n’est revendiqué par ces contrôles.

Une seconde sonde compile cinq fichiers source actuels et compare384cas de Registry::register avec la projection native count/mode/mask/dirty. La deuxième inscription n’alloue pas et préserve ces champs. Quatre contrôles locaux vérifient deux refus d’allocation et deux refus d’identifiant public. Le modèle RegisteredSources ne représente ici que les sources et ces champs ; les16octets d’obstruction/occlusion et les autres champs natifs étendus ne sont pas reconstruits ni exécutés en Rust. Le scénario après writer ne compare que les champs présents dans le modèle actuel. Aucune allocation physique ni libération n’est qualifiée.

Un audit syntaxique utilise syn2.0.119 sur12fichiers sélectionnés par recherche bornée, dont lib.rs. Il distingue les blocs cfg(test) et résout les deux modules de test externes du répartiteur main-SFX. Les cinq implémentations dispatch_command découvertes appartiennent aux tests ; six appels de route restent hors de ces blocs. Les quatre modules concernés sont déclarés dans lib.rs sans cfg(test). Le code normal audio_normal_frame::run_locked appelle réellement common.consume, qui délègue à RetryServices::dispatch_command, méthode requise sans défaut. Ce constat est statique : pas de compilation du client ordinaire, expansion des macros, résolution exhaustive des traits/features ou preuve globale d’absence de backend. Les adaptateurs de test ne sont pas promus en intégration normale.

Les deux sondes produit couvrent53fichiers source distincts, confirmés par les dépendances rustc. Les trois compilations privées et trois exécutions terminent0, hors ligne, sans incrémental ; aucun code produit ni asset modifié.

## Vérifications, conservation et suite

Six falsifications sont rejetées : défauts natifs erronés, réinscription qui remettrait les contrôles àzéro, refus bancaire marqué consommé, projection présentée comme état étendu, adaptateur de test présenté comme production, conteneur synthétique présenté comme source entière. Le premier audit d’associations a rejeté uniquement la forme des séparateurs de chemin D:/ versus D:\ ; la taille et le SHA correspondaient. Ce reçu d’échec est conservé ; la correction normalise le chemin sans relâcher le contrôle des octets.

Quatre rôles précis sont ajoutés : projection actuelle d’inscription, deux refus de répartiteurs bancaires, frontière statique du dispatch de frame normal. Une source de preuve est ajoutée. Les fiches SYS-01.2-02 et SYS-02.2-07 sont enrichies ; associations antérieures, inconnues et prérequis conservés. Les deux bases du plan sont synchronisées par deltas ciblés, sans sauvegarde intégrale supplémentaire et sans modifier cases, notes manuelles ou historiques.

Fichiers modifiés : ce rapport, docs/fidelity_rea_full_image_links_v745.json, les trois registres completion_tasks_2026-10-20/fidelity_requirement_trace_4_20/fidelity_sources_4_20, coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md, puis le guide REA_WORKFLOW.md et la décision d’interprétation des signatures après relecture indépendante.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision745_rea_full_image, revision745_owner_initialization_native, revision745_rust_dispatch_boundaries, revision745_rust_owner_projection, revision745_rust_routes, revision745_associations_checked et revision745_delivery. La publication et sa relecture indépendante ont leurs reçus séparés VERIFIED.json/INDEPENDENT_READBACK.json.

Restent ouverts : producteur/enqueue amont de20, backend normal et routes non résolues, représentation étendue des objets et corps20 Rust, raccordement ENVS, parent B17486, transport240/244, Meter, Init STMG/HIRC8/HIRC14, médias, locale et audio. Le goal reste actif.


## Relecture finale

La relecture indépendante réussit : identité du PE complet et des réponses REA,55instructions/22appels,384cas natifs,960refus et384projections Rust, conditions des adaptateurs de test recoupés. Les deux bases passent quick_check ;42605autres tâches,42607états manuels,23historiques,24phases,2770lots et42215groupes sont identiques. Inversion exacte des trois registres, anciennes instructions et contextes conservés. Quatre rôles ajoutés ; états étendus et backend normal restent ouverts. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision745_delivery\INDEPENDENT_READBACK.json.
