# SYS-01.2-02 — Sources audio et choix du décodeur, V753

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Ce lot relie les sources aux consommateurs actuels de SYS-01.2-02 et SYS-02.2-07. Aucun code produit ni asset modifié. Le goal et les inconnues restent ouverts.

## Résultat

Les587 en-têtes HIRC Sound de six banques sont identifiés par type2,ID,offset,taille et SHA256. Ils correspondent aux42 sources d’ambiance et545 sources d’annonceur recensées. Les banques VO sont celles des chemins en_US observés :pas de qualification exhaustive en_GB.

Le lecteur original AFA240 produit les métadonnées ;B02000 ou B01ED0 construit la ressource selon la branche observée dans B22AF0. B27D40 et B093C0 choisissent ensuite le constructeur :47 résidents B3F360 (260octets),539 streamés B3FCA0 (308octets),1 généré B31C80 (84octets). Les587 constructeurs et destructeurs avec suppression sont exécutés ;aucune allocation de décodeur restante. Ce reçu ne décode pas les539 flux streamés ni le son généré.

L’enregistrement AEAED0/B09520 appelle B09610/AF95A0 pour agrandir réellement le registre vide. L’entrée0x40001 contient les callbacks stream puis résident. Le registre est ensuite libéré explicitement par le banc ;le teardown global historique n’est pas qualifié.

## Du membre de banque aux samples

Pour31 médias d’ambiance,le banc utilise désormais l’en-tête natif et la fabrique,au lieu du choix direct du constructeur de V752. B01E00/AF94A0/AF93E0 retrouve les octets WEM via la table native de médias et incrémente la référence1→2. B02040/AFC0D0/B09970 la ramène2→1 après arrêt/destructeur.

Le descripteur de média et sa table sont fournis par le banc à partir des membres DIDX/DATA vérifiés. La production et l’enregistrement historiques de ces descripteurs ne sont pas exécutés. Le verrou physique est adapté dans une exécution isolée ;aucune concurrence native qualifiée.

31 flux complets,9066 blocs B0ED50,4633573 samples. Les sorties sont identiques bit à bit aux sorties natives V752 correspondantes ;elles restent à un écart maximal de1 unité PCM16 des WAV convertis. Les588432 allocations/libérations et579211 emprunts/libérations source sont appariés. 1073 blocs machine distincts sont contrôlés contre le PE ;ce ne sont pas1073 instructions. Les133 blocs du reçu fabrique sont contrôlés séparément.

Le pool de banc est borné et réutilise seulement les allocations déjà libérées de même taille/origine. Code original protégé en lecture/exécution ;mémoire basse non mappée. Feuilles d’allocation et verrouillage fournies explicitement. Voix/parent fournis,mode faible latence,décalage-8,filtrage identité et mixage final évité restent des conditions du banc.

## REA réellement utilisé

Deux sessions REA6.4.0 fermées sans erreur :14 fonctions,632 instructions désassemblées et28 références. Fonctions7062A0,AEAED0,B09520,B09590,706240,B3FCA0,B22AF0,AFA240,B02000,B01ED0,B27D40,B093C0,B09610,B01E00. Les corps,adresses,instructions,pseudocodes et appels directs sont recoupés avec le PE original.

League of Legends.exe :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862,sous D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy. Les copies d’analyse,logs et preuves sont sur F. L’analyse statique de B22AF0 ne prouve pas l’exécution de sa continuation B00A50. Pas de lancement normal du client historique.

## Consommateurs actuels

Sonde privée Cargo generate-lockfile --offline puis build --locked --offline et exécutable :codes0. Quatre modules actuels compilés inchangés,audio_announcer_catalog,audio_selection,audio_playlist,audio_random ;fichiers de dépendances et hashes contrôlés.

original_catalog et Source::kind conservent545 sources :544 RecordedMedia et1 GeneratedSilence. Les42 ID sound/source d’ambient_contract correspondent aux banques. Source::kind ne distingue pas les médias résidents/streamés ;il ignore stream_type. Le contrat Sound d’ambiance n’expose pas plugin_id/stream_type. Ces résultats ne constituent pas une fabrique de décodeurs actuelle.

Deux rôles précis kind et ambient_contract sont ajoutés. Les rôles original_catalog et populate existants sont réutilisés sans modifier leurs qualifications. populate est inspecté seulement dans ce lot :lecture WAV et validation frames/taux/canaux. Le lecteur WAV exécuté en V752 est une preuve antérieure,non une nouvelle compilation ici. Le client Bevy entier,le playback ordinaire et le son audible restent hors qualification.

## Cas nominaux,refus et limites

Fabrique :doublon→2,même doublon avec callbacks nuls→2 ;nouvelle entrée avec un callback nul→31. Registre conservé. ID non enregistré,type source0 ou échec d’allocation résident/stream→décodeur nul et notification d’échec. La notification AECEE0 est interceptée ;sa sémantique aval n’est pas qualifiée.

Lecteur d’en-tête :stream0→résident ;stream1/2→stream ;stream3/MAX→statut2 ;plugin low-nibble3→2. Codec non enregistré0x50001 accepté par le lecteur,mais refusé séparément par la fabrique. Sept copies mémoire physiquement complètes testées ;aucune sécurité sur buffer tronqué revendiquée.

Rust :stream0,1,2,3,MAX restent RecordedMedia pour0x40001 ;trois plugins inconnus sont refusés. Les huit cas documentent le contrat actuel sans le promouvoir en équivalent natif.

Six falsifications d’audit refusées :mauvais offset HIRC,type résident altéré,libération absente,callbacks inversés,enregistrement natif DIDX inventé,validation stream Rust inventée. Ces refus de métadonnées sont distincts des exécutions natives/Rust.

Premier script fabrique :erreur de syntaxe avant exécution,source conservée. Premier audit :calculs réussis,mais regroupement des catalogues actuels parmi les liens natifs ;version corrigée avant publication. Seuls PE et six banques sont liés comme sources natives ;les catalogues restent des sources de comparaison actuelles. Scripts et observations antérieurs conservés.

## Livraison et suite

Preuve docs/fidelity_rea_bank_factory_v753.json. Détails privés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision753_*. Trois registres et documents coverage/completion_plan/resume_checkpoint enrichis. Deux fiches/deux bases mises à jour avec delta compressé ciblé ;cases,notes,historiques,autres tâches et inconnues conservés. Les reçus VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED distinguent publication,relecture et contrôle final.

À poursuivre :propriétés HIRC complètes B22AF0/B00A50,construction voix/parent,ingestion/enregistrement natifs DIDX,streaming,boucles/seek et génération. Puis effets/mixage,orchestration actuelle,Init,autres médias/locales et sortie physique. Ce lot ne termine ni le système audio ni le jeu.
