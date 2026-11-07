# Recherche sur les 43 autres fichiers vides — V56

Les 43 sources restantes sont relues à leur chemin exact et restent vides. Leurs noms se répartissent en 34 journaux réseau, trois S_OK, un first_time, une configuration du patcher, un journal d’erreurs de localisation, un CSV d’événements sonores, un Light.dat et un user.cfg RADS. Ces catégories de noms ne suffisent pas à établir leur rôle ou leur activation.

Six fichiers sont dans le déploiement du jeu. Deux correspondent aux membres sélectionnés : le CSV de Chogath Skin02 et LEVELS/map11/Light.dat. Les quatre autres, le journal de localisation et trois journaux réseau, ne sont pas listés dans ces projets sélectionnés. Les 37 fichiers extérieurs demandent leur propre contrat de journal, configuration ou état RADS.

Le fichier `data/config.prop` du patcher est aussi un membre distribué exact : release de membre **0.0.0.8**, conservée dans le projet `lol_patcher` **0.0.0.11**, taille zéro, MD5 d41d8cd98f00b204e9800998ecf8427e. Son contenu ne démontre pas une troncature après distribution ; les règles du parseur restent séparées.

La recherche statique dans les deux binaires identifiés conserve 19 littéraux et 53 références immédiates candidates. Les octets des chaînes, des références et des fenêtres de code concordent. Les limites des fonctions complètes, de leurs appels et de leur activation restent ouvertes. Aucun programme ni instruction d’origine n’est exécuté.

Pour `first_time`, la fenêtre candidate appelle les imports identifiés GetCurrentDirectoryA et GetFileAttributesA, assemble le nom avec `/`, compare les attributs et passe par des helpers encore non qualifiés. Il faut prouver le répertoire courant du caller et le comportement du helper 5CA3D0 avant d’affirmer une création ou de lier définitivement ce chemin au fichier RADS fourni.

Pour `Light.dat`, une branche demande le mode texte `rt` et utilise le format `%d %d %d %d %d %d %d`. Les méthodes virtuelles 0x18 et 0x20 du lecteur ainsi que le provider et le répertoire du caller restent à identifier ; le comportement sur un flux vide n’est pas déduit de ces seuls octets. Pour les CSV de sons et le journal de localisation, les conditions d’appel et le mode effectif restent aussi ouverts.

Les chaînes S_OK relatives à la validité des releases du patcher sont séparées des chaînes HRESULT du binaire du jeu. Les littéraux Network Logs et netlog demandent encore le traçage du producteur de noms et de l’initialisation du writer. Les dates inscrites dans les noms de journaux ne fixent ni le déploiement de 2014 ni son fuseau.

Le consommateur de diagnostic existant `Full_project_audit_2026-10-20/collect_audit.py::inventory` est repéré. Son code saute les erreurs de stat ; un simple compte ne garantit donc pas une lecture exhaustive. Un premier essai borné a atteint l’étape suivante après trois assertions de métadonnées, puis a échoué sur le nom d’encodage UTF-16. Les dictionnaires de résultats n’étaient pas encore sérialisés : seuls l’échec, la source et cette progression du contrôle sont conservés. La reprise corrige uniquement le décodage de texte binaire et ne rejoue pas ces contrôles ni l’ancien recensement global. Aucune nouvelle recette exhaustive du lecteur de métadonnées n’est annoncée.

**Recherche partielle, intégration au graphe encore à faire.** Aucun consommateur de gameplay, rôle obligatoire, fallback, intention de fichier vide ou besoin de réparation n’est qualifié pour l’ensemble de ce lot. Les 86 tâches CLASSIFY/RESOLVE et leurs questions restent ouvertes. Aucun fichier rempli, remplacé ou reconstruit ; aucune case, note ou révision modifiée.

Preuves : `E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision56/remaining-empty-artifact-research.json`, `native-empty-artifact-reader-windows.json`, `native-artifact-literal-bindings.json` et `empty-artifact-research-initial-failure.json`. La livraison canonique reste V55 : 91 506 sources, 256 ancres et 2 387 associations génériques.

Suite : qualifier les contrats précis des readers/writers et leurs callers, conserver les frontières entre journaux, marqueurs et ressources sélectionnées, puis intégrer les liens prouvés et affiner les recherches/conditions de résolution des inconnues. Les six objectifs originaux du Goal restent actifs.
