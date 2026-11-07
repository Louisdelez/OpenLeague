# Cycle de vie du contexte racine — référence 4.20

La source9062C9/9062D1 écrit le premier argument dans le mot0 du contexte148. Les lecteurs903B30/9042F0 et906740 parcourent cette chaîne : le mot0 est un lien suivant dans ces usages. Le premier prototype supposait une vtable immédiate unique et a échoué avant résultat ; il est conservé, aucun candidat destructeur de cette piste n’a été exécuté. Les extraits statiques sont bornés, sans prétention de CFG complet.

Deux images neuves sont exercées sous le profil cache/configuration/enregistrement déjà déclaré, ToolsConfig absent, ECX0, CRTencoding fourni et33exportsoptionnels explicitement absents. Après le vrai startupCRT, l’essai20 laisse exécuter9933E0/5648A0/564AF0/564900. L’essai21 ajoute564C20 et ne présente ensuite plus d’adaptateur de construction/affectation/destruction de chaîne ou d’allocation moteur aux cinq entrées sélectionnées. Restent18copiesoctets,5diagnostics,1atexit fourni et11vérificationscookie dans ce nouvel intervalle ; ces frontières restent explicites. Le callbackatexitobservé est5D8BF0, pas une preuve de l’ordre de sortie historique.

| Cas | Attendu et observé |
|---|---|
| Contexte neuf | Racine148octets, mot0nul, six valeurs exactes : now,Content/Src,Content/Built,Content/Loadable,DATA,-data_overlay_now |
| Chaînes | Longueurs3/11/13/16/4/17 ; capacités15/15/15/31/15/31 ; les deux longues possèdent chacune un vrai buffer32octets |
| Original906740 | Libère les deux buffers et le nœud148, efface2D78F20et2D78F24 ; aucune lecture du stockage libéré |
| Liste déjà vide | Deuxième appel sans opération de tas |
| Composition singleton/CRT | Deux workers sortent normalementCRT0 ; handles/sémaphores fermés nativement ; parent956 retiré parCA915B puis slot/14locks parCA9341/CB027B |
| Tas réel | Essai20 :37allocations/37libérations ; essai21 :42/42 ; zéro bloc/indexTLS/section avantcleanuphôte |
| ConsommateursRust actuels | Cinq tests/deux groupes passent : noms moteur et texte de métadonnées ; anciens corpus32/408/custom rejoués sans nouvelle exécution native |

Les portsRust initialize_name/copy_fresh_name/destroy_name et destroy_string sont des consommateurs réels de la représentation24octets et de ses règles de copie/destruction. Ils ne qualifient pas une implémentationRust complète de906740 ni une affectationgénérale564C20. Le providerfichierCRT et PackageProvider existent déjà et ont été inspectés ; l’absence de chaîne d’adresse n’établit aucune absence sémantique.

L’ordre de retrait est une composition déclarée du harnais. Aucun binaire historique n’est lancé comme processusWindows. Le C observateur actuel est chargé parPython ; le tas physique est possédé par le helperRust actuel dans son processus séparé. Les valeurs de tas enregistrées sont celles de l’hôte actuel, pas des octets retrouvés de2014. SourcePE/DLL inchangée ; pas de sourceRust/C de production modifiée.

Restent ouverts : plusieurs contextes créés par la configuration native, désallocateur personnalisé, I/O non vides, ordre historique complet, montage/prioritésbase/legacy/overlays, locale-source/génération, OS/NLS/FP historiques, contentions et backendTLSfallback concretRust ; autres exigences/consommateurs, divergencesAIR4312/4313 et contradictions communautaires. L’inconnue composée est affinée, pas fermée. Les anciens reçus et états manuels sont conservés.

Preuves : [composition](reference_native_skin_loader_sources/original-root-context-lifecycle.json), [intégration et audit](fidelity_registry_root_lifecycle_revision_4_20.json).
