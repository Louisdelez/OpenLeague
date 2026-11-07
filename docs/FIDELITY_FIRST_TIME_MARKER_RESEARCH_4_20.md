# Marqueur first_time du patcher — recherche V58

La recherche précise le contrat natif du nom `first_time` et son lien avec la fenêtre de premier lancement. Elle ne démontre pas encore que le chemin construit dans le processus est le fichier `RADS/first_time` fourni. Les tâches EMPTY-032-CLASSIFY et EMPTY-032-RESOLVE restent à qualifier, sans réparation ni acceptation.

Le patcher source est LoLPatcher.exe de la release RADS0.0.0.11, 4 247 544 octets, SHA-256 fd4a4edcd45694e08779373286afdaa6870cd86f9847e4fc9db1d0bd556914cb. Son identité de build0.4.0.122 reste celle déjà qualifiée par SYS-01.1-02 ; elle n'est pas redéduite d'une date ou d'un dossier.

## Faits nouveaux vérifiés

La fonction à0x5C1DC0 est décodée jusqu'au RET0x5C1F36. Les imports exacts GetCurrentDirectoryA et GetFileAttributesA, les littéraux `/` et `first_time`, les branchements et les appels des helpers sont liés à leurs octets. Le résultat d'attributs -1 ou le bit répertoire0x10 passe par la branche helper5CA3D0. Les autres valeurs passent par BL1 puis SETE, donnant le résultat faux avant la copie de BL vers AL. Aucune lecture explicite de taille ou de contenu du marqueur ne figure dans cette branche bornée. Cela ne prouve pas un IO complet ou un usage obligatoire.

Un appel direct est décodé à0x5C37A6, suivi de la copie AL vers BL à0x5C37BB. Dans le suffixe du caller, BL est testé à0x5C3CC8, converti en0/1 puis en double et associé à la clé `popup` autour de0x5C3CEB. Il s'agit d'un flux statique sous le contrat habituel de préservation d'EBX entre appels, pas d'une nouvelle exécution du caller ou du pont natif complet.

Le helper5CA3D0 appelle47C740 avec la valeur de mode2 ;47C740 appelle6F8807. Ce dernier n'est pas qualifié ici comme un thunk d'import. Deux descripteurs RTTI valides donnent basic_filebuf<char> et basic_ostream<char>. Le troisième emplacement supposé n'est pas un locator valide ; aucun type basic_ofstream n'est inventé. Les modes effectifs, erreurs/exception et réussite de création/fermeture restent ouverts.

Le bundle natif exact `Content/Loadable/RiotClient/Release/bundle-chrome.load` est conforme au manifeste patcher0.0.0.11 par release, taille et MD5, puis par SHA-256. Quatre membres originaux sont identiques à leurs copies de revue : ChromeController, InitialLaunchPopupController, la factory de modale et son template. Le listener ClientInit lit `ev.detail.popup`, active la fenêtre initiale ou poursuit vers le gestionnaire Pando ; InitialLaunchEvent ferme cet état avant la suite.

## Contrôles réellement exécutés

| Portée | Attendu | Observé |
|---|---|---|
| Arêtes statiques exactes | Imports, quatorze instructions liées, cibles internes et transfert de retour concordants | Dix contrôles passent, dont trois refus de branche/helper/masque modifiés |
| Source UI | Membres exacts du bundle distribué | Quatre membres concordants, bundle conforme au manifeste et au SHA conservé |
| Callback JS original avec hôte simulé | Popup0 : pas de modale ; popup1 : modale puis suite après fermeture | Sept cas passent ; document, Angular, jQuery, modale, clientInit et Pando sont simulés |
| Message sans detail | Refus explicite du callback | TypeError observée ; aucune correction silencieuse du message |
| Sonde d'attributs x86 | Branches à partir de sept retours d'attributs | Le processus a dépassé les sept assertions puis a échoué sur l'hypothèse RTTI ; les lignes/traces individuelles n'étaient pas sérialisées. Preuve de progression uniquement, pas un reçu exhaustif reconstruit |

Les sources/recevables dans revision58 identifient les programmes, outils, octets exécutés et paramètres. La sonde x86 a émulé uniquement le segment0x5C1EA1–0x5C1EDD dans Unicorn, avec arrêt avant l'appel helper pour les chemins concernés. Aucun patcher Windows, appel OS/CRT IO, serveur, navigateur complet ou service externe lancé. La reprise après l'échec RTTI ne rejoue pas cette sonde. La projection JS est exécutée dans une VM Node isolée avec appels hôtes enregistrés, sans réseau ni rendu.

## Limites et suite précise

1. Identifier le répertoire courant effectif et ses changements avant l'appel5C37A6 ; sans cela ne pas assimiler le nom relatif au fichier RADS/first_time fourni.
2. Qualifier6F8807, le mode2 et les erreurs/exception du helper : une tentative de création n'est pas une création réussie et les erreurs d'attributs ne sont pas distinguées de l'absence par cette branche.
3. Qualifier le pont de sérialisation/dispatch et les appels réels du caller avant de transformer le flux statique et le callback projeté en acceptation d'un premier lancement complet.
4. Identifier un consommateur actuel dédié ou documenter précisément son absence. La recherche bornée dans le launcher et core n'en a pas identifié ; les champs first_time de caméra et de missile sont sans rapport avec ce marqueur.
5. Intégrer seulement les liens prouvés aux exigences/inconnues. La recherche V56 sur les42 autres fichiers vides reste intacte ; aucun marqueur ou asset n'est rempli/remplacé.

Preuves : E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision58/. Les sources et échecs sont conservés. La livraison canonique reste V57 :92 131 sources,265 ancres,918 associations génériques et1 469 frontières seules, soit2 387 lacunes spécifiques visibles. Les six objectifs du Goal et les deux divergences4312/4313 restent ouverts selon leurs états ; les cases, notes, révisions et tout l'historique utilisateur sont conservés.
