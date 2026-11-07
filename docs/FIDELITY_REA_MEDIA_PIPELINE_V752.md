# SYS-01.2-02 — Médias natifs, décodeur résident et transport courant, V752

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Ce lot relie des sources aux consommateurs actuels de SYS-01.2-02 et SYS-02.2-07. Aucun code produit ni asset modifié. Les anciennes preuves et qualifications sont conservées.

## Résultat et portée

Le décodeur Vorbis résident original est désormais exercé dans la chaîne source B0ED50, à la place du fournisseur synthétique V751. Les31 WEM sont identiques aux entrées DIDX/DATA de trois banques originales ;67 sources distinctes sont identifiées (PE,manifeste,banques,WEM,WAV). Le constructeur B3F360,initialisation B3F720,lecture B3F4B0,libération B3F620 et getter B27E80 sont originaux. L’arrêt B3F900 et le destructeur avec suppression B3F2B0 sont appelés explicitement.

31 lectures complètes à44100Hz sans pitch correspondent aux4633573 échantillons des WAV existants avec un écart maximal de1 unité PCM16. Ce résultat n’est pas une égalité bit à bit. Le module courant crates/core/src/audio_media.rs est compilé inchangé et relit ces WAV ;ses sorties float32 sont identiques à leur conversion PCM16 et présentent la même limite face au natif.

Trois lectures supplémentaires du média613697413 à48000Hz avec pitch-1200,0,+1200 produisent respectivement96513,48258,24129 frames,atteignent le statut terminal17 et restent finies. Le lecteur courant conserve44100Hz et44337frames pour ce média. Aucune équivalence de leurs formes d’onde ou du rééchantillonnage courant n’est revendiquée.

## REA : résultats et limite explicite

REA6.4.0 utilise le PE original complet. Source League of Legends.exe :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, sous D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy.

Deux sessions sont conservées. La première analyse B3F360,B3F720,B3F4B0 puis termine en erreur de résolution de B3F620 ;sa fermeture est confirmée. La seconde analyse B3F900,B35D90,B364E0 et enregistre explicitement B3F620/B27E80 non reconnus comme procédures. Leurs premières instructions sont inspectées séparément. Les six fonctions totalisent535 instructions et16 références recoupées avec le PE ;deux instructions individuelles ne sont pas présentées comme deux fonctions complètes. Les deux sessions sont fermées. Aucun démarrage normal du jeu original n’est revendiqué.

## Chaîne native et mémoire

34 lectures,9398 appels B0ED50 et4802473 mots de sortie. L’inventaire comprend1024 blocs machine distincts dont les octets sont comparés au PE ;ce ne sont pas1024 instructions. Les sections de code sont protégées en lecture/exécution. La mémoire basse reste non mappée. Les corps des feuilles d’allocation/libération interceptées ne sont pas qualifiés comme exécutés.

595840 demandes et595840 libérations source sont vérifiées sur les flux complets. Pendant le rééchantillonnage,un emprunt source peut traverser une frontière entre deux blocs de sortie ;l’audit suit ce lifetime cumulatif. Les605408 allocations et605408 libérations sont appariées,aucune allocation restante après arrêt/destructeur. Le pool de banc borné à16MiB ne réutilise que les adresses déjà libérées pour la même taille et le même allocateur d’origine,avec remise à zéro. Le pool historique reste hors qualification.

Le masque natif mono est4,format PCM16 ;la sortie est float32 mono. Le flux est résident,non bouclé,avec pointeur et taille WEM fournis. Le type de décodeur est choisi explicitement par le banc,et non retrouvé par une sélection de banque en jeu. Les offsets DIDX sont relatifs au début DATA ;leurs offsets absolus et hashes sont vérifiés séparément.

Le resampler est initialisé par B28B60. Les deux wrappers de filtre B28810 sont exécutés en identité/bypass avec historique nul fourni ;la limite B16FA0 reçoit le callback expliciteFFFFFFFF. Le mode faible latence et le décalage initial-8 sont des choix du banc. job+38=1 évite le mixage final. Pas d’effets réels,auxiliaires ou sortie sonore. Les objets englobants,leurs constructeurs et le bootstrap Init complet restent ouverts.

## Contrôles exécutés et refus

Cas natifs sur copies mémoire du WEM613697413 :entrée nominale→1 ;signature RIFF incorrecte→7 ;en-tête11octets→7 ;formulaire WAVE incorrect→7 ;taille RIFF déclarée nulle→1,acceptée. Toutes les copies sont immuables pendant l’exécution et les allocations finales sont libérées. Les originaux ne sont pas modifiés.

Cargo generate-lockfile --offline,build --locked --offline et exécution de la sonde Rust :codes0. Le fichier de dépendances cite le module courant exact ;le client Bevy entier n’est pas compilé. Pour34 lectures,la sortie vide préserve le curseur,les lectures par257frames restituent le PCM complet et la fin remplit la queue de zéro.

Six refus sur copies WAV :en-tête tronqué→Truncated ;mauvaise signature RIFF,formulaire WAVE ou taille RIFF nulle→InvalidRiff ;format non PCM16→UnsupportedFormat ;fmt absent→MissingChunk. Les frontières natives utilisent WEM,les frontières Rust WAV :la comparaison ne porte que sur l’enveloppe RIFF commune et n’établit pas un parseur identique.

Les31 WEM valides sont refusés par le lecteur actuel réservé au WAV PCM16 :18 UnsupportedFormat et13 Truncated. Ce dernier diagnostic reflète son analyse de chunks/alignement avant sélection de format ;il ne démontre pas une corruption des WEM. Le lecteur courant n’est pas un décodeur Vorbis.

Six falsifications de preuves sont refusées par l’audit :offset banque absolu altéré,libération destructeur absente,hash de samples modifié,acceptation native de taille RIFF nulle effacée,décodeur Vorbis courant inventé,comparaison unitaire attribuée à un flux rééchantillonné. Ces vérifications de métadonnées sont distinctes des refus réellement exécutés.

## Échecs conservés

Le premier banc supposait à tort le masque mono1 ;l’observation établit4. Un préparateur utilisait un alias d’encodage Python invalide et n’a rien exécuté ;la copie corrigée utilise utf-8-sig. Le premier allocateur monotone épuisait16MiB ;la variante bornée réutilise uniquement les allocations libérées. Le premier test de fermeture omettait l’arrêt après initialisation réussie ;la variante corrigée appelle arrêt puis destructeur. Aucun changement produit n’est justifié par ces échecs de banc.

Le premier audit demandait un appariement de source dans chaque bloc de sortie ;il est corrigé pour les emprunts traversant les blocs. Un second essai confondait une liste de références avec une référence unique ;les deux diagnostics/scripts sont conservés. L’audit final revision752_media_associations_verified passe. Les erreurs REA restent visibles et ne sont pas transformées en réussite d’analyse des fonctions non reconnues.

## Livrables et intégration

Rapport docs/FIDELITY_REA_MEDIA_PIPELINE_V752.md et preuve docs/fidelity_rea_media_pipeline_v752.json. Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision752_media_reused_pool,revision752_media_boundaries_checked,revision752_rust_media,revision752_rea_media_pipeline,revision752_rea_media_remaining,revision752_media_associations_verified,revision752_delivery.

Les trois rôles existants decode,Playback::read et consommateur de filtre client sont réutilisés sans modifier leurs qualifications historiques. La preuve contextualise précisément les deux premiers exécutés et le troisième seulement inspecté. Aucun rôle dupliqué ou nouveau consommateur déclaré.

Trois registres,coverage.json,completion_plan.json,resume_checkpoint.json et notes de reprise sont enrichis ;deux lignes ciblées de chacune des bases projet et application sont mises à jour. Cases,notes,historiques,autres tâches,prérequis,inconnues et contexte antérieur doivent être conservés. Les reçus VERIFIED.json,INDEPENDENT_READBACK.json et FINAL_VERIFIED.json distinguent publication,relecture indépendante et contrôle final. Aucun snapshot intégral supplémentaire des bases.

## Suite

Qualifier la fabrique et le choix du fournisseur natif à partir de la banque,les constructeurs/propriétaires englobants,boucles,seek,streaming et intégration ordinaire. Puis effets,métadonnées non vides,mixage B267F0,caller B0DFC0,ENVS/auxiliaires/bus,commande20/état étendu,Meter,Init complet,autres médias/locales et sortie physique. Le goal demeure actif ;ce lot ne termine ni le système audio ni le jeu.
