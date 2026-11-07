# RADS : source exacte, création d’archive et recherches natives

Le code original RiotRadsIO.dll (SHA60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521) est exécuté sous Unicorn avec les feuilles et le tas DLL virtuels déclarés, sans lancer un programme historique sous Windows. Les instructions observées sont comparées aux octets du DLL fourni. Le chemin d’archive découle du mot de release du payload, distinct de la release du manifeste. Le constructeur ajoute le suffixe /*.raf ; aucun nom Archive_1.raf n’est inventé.

Le corpus préexistant reconstruit contient119 versions et70268 entrées archivées. L’expérience utilise seulement la version67 : index2455octets etDAT2514269octets,34payloads exacts déjà contrôlés. Index,noms,offsets et compression sont reconstruits ; ils ne sont pas les octets d’un conteneur historique récupéré. Les originaux D: restent intacts.

| Cas | Attendu | Observé |
|---|---|---|
|32, dossier original absent|Échec réel sans source substituée|Pointeur nul,aucune lecture|
|33, alias exact du conteneur reconstruit|Énumération et lecture d’index|2455octets lus,gestionnaire non nul|
|36,34noms originaux et majuscules|Mêmeoffset/taille/DAT|68succès exacts|
|36,absent/vide/suffixe absent|AL0,offset0,taille0,DATvide|Trois refus exacts|
|36,destruction des chaînes de sortie|Tas du gestionnaire inchangé|73blocs avant/après les recherches|

Les essais34/35 sont conservés comme échecs d’assertions du harnais, sans accès invalide ni arrêt forcé.34 exigeait à tort une chaîne physique alors que le moteur renvoie son chemin logique,validé maintenant via l’alias exact déjà gardé.35 exigeait à tort des sorties u32 inchangées ; les instructions10048F61/10048F67 les mettent explicitement à zéro. Les entrées,API,instructions natives et bornes ne sont pas modifiées par les corrections. Une première préparation statique s’était arrêtée avant tout essai car son extrait n’atteignait pas les deux ret16 ; producteur initial et correction sont conservés.

Les essais32/33 viennent du tour précédent ;34/35/36 sont frais. La qualification ajoute11contrôles dont cinq refus explicites de contrat/source/receipt manquant ou modifié,et conserve les14contrôles source antérieurs. L’outil courant audit_rads_archive_factory.py consomme et vérifie les reçus exacts. Il s’agit d’un consommateur de référence, pas d’une implémentation du provider Rust.

Les handles physiques sont fermés par le code original avant cleanup hôte.73blocs et5handles DLL virtuels restent : aucun teardown complet n’est revendiqué. Le DAT n’est pas lu dans ces expériences. Une ancienne preuve séparée lit/décompresse34ressources ; elle est relue sans rerun et conserve son avertissement concernant les anciennes gardes de mémoire. Le montage complet,les priorités et lectures ordinaires,les branchescore4/6/22 et leur cycle complet,currentRust,les conditions historiquesconfig/OS/NLS/FP/TLS et les autres inconnues du Goal restent ouverts. Aucun test Cargo,acceptation humaine ou achèvement du jeu n’est déduit.

Preuves : [qualification](reference_native_skin_loader_sources/native-rads-archive-factory-reference.json),[intégration](fidelity_registry_rads_archive_factory_revision_4_20.json).
