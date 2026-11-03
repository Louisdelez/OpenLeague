# Itérateur natif et découverte des skins non-base

Les instructions originales tournent dans Unicorn ; aucun programme historique ni DLL original chargé sur l'OS hôte. Le bootstrap V13 est conservé. Les scanners902ad0/905620/905a00 appellent maintenant la vraie factory8b4830, le provider physique8b6380/8b9e30 et ses méthodes virtuelles. Les seuls retours de recherche proviennent des appels Win32 réels en lecture seule, avec bornes et refus des racines/reparse/handles inconnus. Le filtre de dossiers1 est transmis à l'API ; aucun filtre Python ne remplace l'interprétation native des attributs.

Corpus installé :546identités officielles non-base,267configurations dédiées/2136champs effectivement comparés aux getters originaux antérieurs,279cas sans dédié dans cette seule map non-base. Découverte normalisée (seul préfixeDATA retiré pour comparer),choix de nom,drapeau dédié,SHA,ID typé et scalaires concordent ; aucune différence masquée. La locale en_GB provient de son default37octets lu par le code original dans chaque contexte froid. Le premier corpus exploratoire conserve séparément son état initial de locale.

Limites natives : le conteneur extérieur à un contexte et les arguments champion/skin/racineDATA restent fournis. Aucun constructeur global de packages,contexte base/legacy/fallback,overlay historique,montage RADS réussi ou OS/NLS/FP historique n'est déduit. Les279maps sansdédié ne prouvent pas l'absence du skin. Les12écarts d'échelle de base installés restent ouverts et non corrigés.

Consommateur actuel inspecté : ClientPacket::Join déclarechampion et summoners ; Champion n'a pas de champ cosmétique dédié ; receive appelle animation::request(id,championname,Catalog,AssetServer) lors de la première création visuelle. C'est une revue statique des déclarations et de l'appel ordinaire, pas une nouvelle exécution Rust/rendu. L'alias de ressource de particules accepte unOwner fourni ; le backend d'icônes s'insère dans le formatter d'annonces. Ces rôles sont distincts du choix du modèle d'un skin. Les occurrences Bevy skin_index désignent le squelette.

Neuf tests installés qualifient noms/types natifs,filtre de dossiers,dossier absent,composition scanner→alias→getters,fermeture anticipée,NUL/nonASCII/mode/horsracine,handle inconnu/champsAPI refusés,reset froid et identités invalides. Les corrections de préparation avant installation sont conservées : échappementNUL du petit wrapper,extraction des champspub(crate) et métadonnéesHTML. Le premier essai exploratoire attendait à tort un IDtexte au lieu de l'entier natif ; sa source et son reçu restent conservés. Aucun helper V13 ni donnée/code de production du jeu modifié.

Les8736questions de dispatch et96questions Renekton non-base sont précisées avec ancien texte/conditions/recherches et statuts conservés ; toutes restent ouvertes. Les autres inconnues et preuves sont préservées. Les sources Microsoft actuelles sont archivées intégralement avec SHA et en-têtesHTTP ; ms.date et LastModified sont distincts de leur ancien résumé de recherche et d'une preuve2014.

Reproduction depuis E:/OpenLeague :

    python -B -m unittest discover -s tools/project-plan -p test_original_directory_iterator_reference.py -v
    python -B tools/project-plan/exercise_original_directory_iterator.py --root E:/OpenLeague --output <nouveau-recu.json>

[Corpus](reference_native_skin_loader_sources/original-directory-iterator-execution.json). [Contrat FindFirstFileExA](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-findfirstfileexa),[Contrat FINDEX_SEARCH_OPS](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ne-minwinbase-findex_search_ops).
