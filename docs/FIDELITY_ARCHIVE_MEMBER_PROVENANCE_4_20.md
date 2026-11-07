# Provenance des membres des cinq archives — V48

Cette révision couvre les sources et consommateurs de SYS-01.2-02/03/06 ;elle n'accepte pas les tâches d'inventaire SYS-02.1-01/02/05.

Les cinq ZIP fournis sont absents des deux manifestes sélectionnés. En revanche,leurs enfants ont une correspondance précise :1059fichiers,7répertoires,48570309octets décodés. Les1059fichiers sont identiques par SHA-256 aux fichiers plats de la copie fournie ;les1066sorties ZIP correspondent aux empreintes du lecteur natif conservées.1058fichiers correspondent aussi aux chemins,tailles et MD5 des membres des manifestes exacts. Chaque correspondance conserve projet,release de projet,release de membre,chemin,taille,MD5,SHA et archive/ordinal/offset d'origine.

L'exception est DATA/menu/HUD/hud1366x768.ini,384octets,SHA256 f3f960416487bd4b89ca1c505d5397d4536d63c5986dcc7bf9756e73717ae36e. Le ZIP et le fichier plat sont identiques,mais aucun des deux projets sélectionnés ne le recense. Sa version/origine ou sa création éventuelle reste à établir. L'identité des autres contenus ne prouve pas l'origine historique des conteneurs ZIP ;aucune hypothèse de reconditionnement officiel ou local n'est transformée en fait.

| Exigence associée | Liaison établie | Ce qui reste ouvert |
|---|---|---|
| SYS-02.1-01 | Conteneurs,fichiers plats,manifestes sélectionnés et versions individuelles | Origine/version des conteneurs,RAF67 absent,exception HUD384octets,inventaire global |
| SYS-02.1-02 | Population complète des cinq ZIP et empreintes des enfants | Dépendances et récursion hors de ces cinq archives,preuve de l'alias runtime |
| SYS-02.1-05 |1059associations exactes de fichiers importés à leurs sources et empreintes | Exception nonlistée,autres imports et contrats de conversion |

Le consommateur Python RadsReferenceMembership.inspect est réellement exécuté sur1059fichiers. Les sites Rust from_catalog,read_optional,Archive::read,la requête FastHUD et le démarrage ordinaire sont inspectés comme sources. Cette comparaison n'exécute aucun décodeur Rust,fournisseur Bevy,jeu historique ou nouvelle expérience originale. Les préfixes DATA/menu et DATA/Spells sont des correspondances de chemins pour les manifestes,et non une preuve d'enregistrement d'aliases natifs.

39contrôles de qualification comprennent le nominal,37refus d'altérations et un contrôle numérique équivalent. L'erreur initiale de comparaison de casse du chemin HUD/hud est conservée ;sa correction garde les tailles/SHA stricts et ne modifie aucun original. Trois questions existantes sont affinées sans clôture. Les tâches futures restent a_faire ;cases,notes,révisions et historique intacts. Les six objectifs du Goal restent conservés,leur complétude n'est pas démontrée.

Reçu :docs/reference_archive_member_sources/archive-member-provenance.json. Livraison :docs/fidelity_registry_archive_member_revision_4_20.json. Tables,journaux,auditeur et producteurs :E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision48. V47 et toutes les preuves antérieures restent conservées. Les travaux de liaison des scripts,Blender et autres imports restent prévus ;cette découverte de provenance des archives est traitée d'abord.
