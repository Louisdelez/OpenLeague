# Correction du nom du point d'entrée des vagues — V89

La description V88 de SYS-10.5-01 nommait à tort enable_world. Le code réel contient Simulation::enable_map10. Sa méthode initialise next_slot depuis initial_wave_seconds ; advance_world traite ensuite ce scheduler. Les deux ancres de V88 pointaient déjà sur les bonnes lignes. Ce correctif porte sur la description du consommateur, sans modification du gameplay.

La présente preuve corrige explicitement cette mention dans docs/reference_waves_sources/waves-links.json et les descriptions V88 qui la reproduisent. Les documents et consommateurs V88 sont conservés comme historique, non réécrits ; leur nom erroné ne doit plus être utilisé comme nom de symbole. Le reçu courant contient la description précédente, les ancres conservées et deux rôles précis identifiant la méthode réelle et l'affectation initiale.

105 identités de sources sont vérifiées, incluant le lecteur et le reçu V88. Le lecteur V88 relit ses894 contrôles source ; trois contrôles de composition vérifient son résultat, le nom/corps de la méthode et la conservation des ancres. Douze cas du lecteur courant sont qualifiés, dont onze refus : faux nom, fausse ligne, source altérée, omission de l'historique, clôture ou exécution native inventée, mauvaise inconnue et contournement de vérification.

La valeur native75 concorde toujours ; l'origine de l'horloge et la sémantique du scheduler historique restent ouvertes. Aucun programme historique, jeu, Rust ou Blender lancé. Aucun code/asset du jeu changé. Seules les métadonnées/consignes de SYS-10.5-01 et du Goal sont actualisées dans les deux bases, avec conservation des cases, notes et historique.

| Tâche | Correction | Limite maintenue |
|---|---|---|
| SYS-10.5-01 | Correction explicite de la mention enable_world dans V88 : la méthode réelle est Simulation::enable_map10, qui initialise next_slot depuis initial_wave_seconds. Les deux ancres V88 pointaient déjà sur les bonnes lignes ; leur identité est conservée. advance_world déclenche ensuite au tick prévu. Aucune méthode enable_world n’est appelée par ce chemin. | Qualifier l’origine d’horloge et les frontières de scheduler moteur ; la concordance du champ75 ne démontre pas à elle seule l’exécution historique. |

Reçu : docs/reference_wave_entry_sources/wave_entry-links.json. Livraison : docs/fidelity_registry_wave_entry_links_revision_4_20.json. Le périmètre gameplay et le Goal restent ouverts.
