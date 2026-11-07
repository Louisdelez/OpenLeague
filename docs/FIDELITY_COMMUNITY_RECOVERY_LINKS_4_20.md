# Sources natives et ressources communautaires — V97

Objectif SYS-01.2-02 : relier précisément six exigences SYS-02.3 à leurs sources et aux consommateurs actuels. Ceci ne clôt ni ces six tâches ni le jeu.

## Résultats vérifiés

- Cinq ZIP du deploy natif relus : 1066 entrées, 1065 noms distincts. Le seul nom partagé entre archives est le répertoire vide `Textures/`, pas deux fichiers concurrents. Copies F identiques aux archives natives. Ce périmètre borné ne recense pas tous les disques et ne découvre pas de nouvel original manquant.
- Deux alternatives natives Urf.inibin et defaults/Cheats.cfg correspondent aux manifestes sélectionnés ; les fichiers loose divergent. Copies F vérifiées. Provenances conservées séparément, priorité de montage historique inconnue. Code de vérification courant F, backing des manifestes historique E explicite et en lecture seule.
- 797 scripts de l'inventaire communautaire existant relus par SHA ; pas de recherche exhaustive de nouveaux scripts. GarenQ conserve neuf divergences sur dix durées par rang. Les champs natifs nommés correspondent aux valeurs locales utilisées. La résolution C#/assemblages et la contradiction de tooltips restent ouvertes. Le fichier communautaire non suivi est identifié par ses octets, pas par le HEAD de base de son arbre modifié.
- Documentation primaire DivineSkins enregistrée avec URL, commit et SHA. Les formats de paquets modernes documentés ne prouvent pas une compatibilité avec 4.20. Le SKN natif Garen fournit un contexte de format et d'appartenance au manifeste ; le consommateur actuel demande des GLTF. Aucun paquet de skin, installeur ou logiciel DivineSkins exécuté.

## Contrôles et limites

860 sources épinglées ; 909 contrôles source. 30 cas du lecteur dont 29 refus sur identité, périmètre, rôle, consommateurs et inconnues. Les mutations de reçu testent son intégrité ; elles ne constituent pas des tests du jeu.

Le reçu `consumer-tests.json` identifie Python, le producteur, les modules, les données et le journal des six tests communautaires réussis. Dix cas du véritable restaurateur ont été exécutés dans un répertoire temporaire F : restauration native exacte, conservation d'un fichier identique, sept refus (divergence locale, membres, taille, SHA, chemin dangereux, politique interdite, type de politique invalide) et acceptation d'octets opaques dont le SHA est exact. Ce dernier résultat démontre la limite réelle du contrat : intégrité des octets, pas compatibilité ou fidélité4.20. Aucun fichier d'asset réel modifié, aucune option force.

La collecte, les tests et les comparaisons sont de lecture/source ou utilisent des copies temporaires. Aucun jeu, serveur historique, AIR, renderer GPU ou audio observé. Pas de nouveau test Rust dans ce lot ; les ancrages Rust sont inspectés, pas exécutés ici. Les preuves historiques restent séparées des contrôles frais.

## Sources web épinglées

- [DivineSkins/celestial-releases](https://raw.githubusercontent.com/DivineSkins/celestial-releases/25ae4d865faf6b2eae4ac66dd05f6f99ab517b00/README.md) — commit `25ae4d865faf6b2eae4ac66dd05f6f99ab517b00` ; SHA `62bfefca240abff4cd16014c7c1cb98820a16ed84fa561c327319fd2d6260c1e`.
- [DivineSkins/divine-wiki](https://raw.githubusercontent.com/DivineSkins/divine-wiki/b0ea714e3037609dc1345d69a5d66efafa88d32e/README.md) — commit `b0ea714e3037609dc1345d69a5d66efafa88d32e` ; SHA `13be15019120d4726ba15348232b72d705e1d0ab70991dad1b3496e282b27e0a`.

## Intégration et reprise

Le lecteur installé vérifie les preuves et les douze ancrages actuels. Les registres reçoivent des arêtes natives, communautaires et locales distinctes. Trois exigences ne possèdent encore que des points d'entrée, trois ont un consommateur partiel ; aucun indicateur d'acceptation n'est promu. Les prérequis du lot aval restent ouverts ; les prérequis du travail de traçabilité sont relevés dans `phase-and-package-context.json`.

La publication sauvegarde les registres et les deux bases avant mutation, ne modifie que sept fiches, puis contrôle les consignes via les méthodes réelles Store.task et Store.copy_text. Les coches manuelles, notes, historique, flags de tâches, sources anciennes et SYS-01.1-02 sont conservés. Voir le reçu final pour l'état observé des contrôles de livraison ; le présent rapport ne remplace pas cette preuve.

## Exigences et limites précises

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-02.3-01 | Le scan borné du deploy natif retrouve cinq ZIP déjà connus et1066 entrées relues avec CRC/SHA ;leurs copies F correspondent.1065 noms distincts,le seul nom répété étant le marqueur vide Textures/ de deux archives. Les consommateurs Rust d’index et de ZIP sont identifiés ;ce scan ne couvre pas toutes les archives locales ni les ressources encore manquantes. | Étendre la recherche aux archives non indexées et aux autres racines pertinentes,avec périmètre explicite et rapprochement des ressources manquantes ;qualifier les montages et collisions au lieu de conclure depuis le seul index. |
| SYS-02.3-02 | Le lecteur RADS F compare les deux fichiers loose Urf.inibin et Cheats.cfg à leurs alternatives exactes :les loose divergent,les alternatives correspondent aux manifestes sélectionnés et leurs copies F sont identiques. Les deux origines sont conservées ;l’ordre de sélection runtime reste inconnu. | Conserver version,taille,hash et candidats pour chaque doublon rencontré ;qualifier la sélection effective avant remplacement. Les deux cas exacts ne démontrent pas une politique exhaustive pour tous les doublons. |
| SYS-02.3-03 | Deux documents primaires DivineSkins sont épinglés à leurs commits. Ils décrivent fantome,modpkg et ZIP structurés dépendant du patch courant ;aucune compatibilité4.20 n’y est qualifiée. Un SKN natif Garen est identifié et comparé au manifeste. Le client actuel demande des Gltf ;le restaurateur ne vérifie pas la sémantique4.20. | Évaluer un paquet précis et son contenu,versions de formats,rig,animations,textures et droits de réutilisation pertinents ;relier une conversion vérifiée à nos consommateurs. Aucun paquet DivineSkins ni Celestial téléchargé ou exécuté dans ce lot. |
| SYS-02.3-04 | La comparaison nommée GarenQ est réexécutée en lecture seule :neuf écarts sur dix durées communautaires,les champs natifs correspondent aux valeurs locales utilisées. Les797 sources de l’inventaire communautaire sont relues par SHA. Six tests de comparaison passent,mais ni code C# ni gameplay natif ne sont exécutés. | Évaluer les autres outils et ressources sur leurs contrats précis,dispatch et versions ;ne pas généraliser les résultats GarenQ aux autres capacités ou aux assemblages non inspectés. Les tooltips natifs contradictoires restent explicitement ouverts. |
| SYS-02.3-05 | Les documents DivineSkins ont des commits exacts ;les ressources communautaires conservées ont des SHA relus. Le Git snapshot du Q communautaire est une observation antérieure d’arbre modifié,et son chemin est non suivi :le base HEAD ne devient pas la version exacte du fichier. Les consommateurs de comparaison et d’historique sont reliés. | Conserver pour chaque ressource retenue URL/commit quand établi,état de l’arbre,hash et preuve de correspondance native ;qualifier le parcours complet d’adoption. Un ContentFormatVersion ou un dossier nommé4.20 ne prouve pas le patch. |
| SYS-02.3-06 | Le restaurateur actuel refuse sept cas contrôlés dont fichier local divergent,membre/tailles/SHA/politique invalides. Il restaure aussi un diagnostic opaque si son SHA est exact :son contrat porte sur l’intégrité,non sur le format ou la fidélité4.20. Le lecteur RADS qualifie séparément les membres exacts. | Qualifier une garde de correspondance4.20 dans les vrais chemins d’adoption/conversion et de remplacement moderne ;ne pas assimiler checksum réussi,import réussi ou membre natif à la fidélité complète. Aucun remplacement de ressource réelle effectué. |

Reçu : docs/reference_community_recovery_sources/community_recovery-links.json. Livraison : docs/fidelity_registry_community_recovery_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
