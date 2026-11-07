# SYS-01.2-02 — Héritage et ressources d’atténuation, V736

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Les banques candidates de voix restent en_US ; leur sélection historique n’est pas établie.

## Résultat

Les 13 818 objets de sons et conteneurs de 183 banques contiennent 30 307 champs de positionnement vérifiés. Parmi eux, 816 objets déclarent leur propre positionnement et 223 possèdent une référence d’atténuation. Ces données sont distinguées des 213 ressources HIRC14 elles-mêmes.

Les lecteurs originaux HIRC2/5/7/14 chargent les objets dans 364 contextes conservant les deux ordres de banques précédemment déclarés. Les liens parents et les origines retenues sont comparés à V732. Le getter AF19E0 remonte les parents réellement chargés, recherche la ressource via AF9530 et exécute sa libération de référence originale. Il renvoie le premier champ du dernier point de la courbe sélectionnée. Ce champ n’est pas un gain final évalué.

Les 35 310 recherches donnent 21836 résultats présents et 13474 absences de portée. Les compteurs de référence restent équilibrés. Les 213 atténuations originales sont représentées dans les contextes. Les 3349 adresses exécutées sont comparées aux octets du PE original.

## Comparaison avec le Rust actuel

Le texte courant complet de audio_spatial_controls.rs est compilé comme préfixe du composant de diagnostic, avec un point d’entrée ajouté dans le même module pour appeler son getter privé. Six autres modules actuels sont compilés par leur chemin : audio_control_refresh, audio_rtpc_manager, audio_active_voice_cache, audio_curves, audio_parameter_getters et audio_random. Aucun corps de fonction du jeu n’est modifié ni remplacé. Cargo fonctionne hors ligne avec lockfile, compilateur et exécutable identifiés ; pas de cache incrémental.

Les chaînes complètes de parents et les courbes sont projetées explicitement dans le registre Rust. La sélection du parent et les valeurs exactes des 35 310 recherches correspondent au natif. Le contrôle de apply porte sur la sélection, avec pose absente et sans propriétés ni RTPC fournis ; il ne qualifie pas les autres calculs de cette fonction. Huit diagnostics vérifient les ressources absentes, sélecteurs invalides, courbes absentes ou vides, valeurs non finies et hiérarchie vide. Quatre falsifications de preuves sont refusées.

Le composant V733 du chargeur est relancé séparément sur ses sources inchangées : les 213 corps HIRC14 sont toujours refusés. Le calcul fonctionne donc avec un registre fourni, mais cette réussite ne démontre pas un chargement de banque vers ce registre. Cette limite reste ouverte, sans remplacer la source par une fixture opérationnelle.

## Intégration

1 279 fiches sont enrichies : SYS, 668 skins et 610 voix de champions. Les associations réutilisent précisément leurs contextes V732. Les recherches portent sur tous les objets chargés de ces contextes ; aucune sélection de chaque objet par chaque action n’est déduite.

Deux rôles précis sont ajoutés : getter de portée actuel et sélection du parent actuel. Les liens existants, dont la limite du chargeur, restent conservés. Les anciens rôles V733 gardent leur portée datée ; ils ne sont pas réécrits comme s’ils avaient alors été compilés.

Registres : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Les deux bases locales reçoivent les instructions copiables. Cases, notes, historiques, prérequis et inconnues sont conservés ; les modifications sont enregistrées par deltas réversibles sur F.

## Limites et suite

L’ordre historique, le dispatcher complet des banques, les bus chargés avec leurs données, le raccordement HIRC14 actuel, les effets Delay, médias, décodage, mélange et périphérique restent à qualifier. Les actions/événements/effets sont exclus de ce chargement ciblé. Les fabriques de bus utilisées pour les dépendances restent distinctes de leurs payloads. Les allocateurs et verrous sont fournis ; la libération de référence est observée, pas la destruction finale de toutes les ressources. Aucun client normal ni son audible exécuté ou accepté.

[Reçu](fidelity_attenuation_hierarchy_links_v736.json). Corpus F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision736_positioning_sources, revision736_native_attenuation_hierarchy, revision736_rust_attenuation et revision736_attenuation_associations. Livraison : revision736_delivery/VERIFIED.json.


## Relecture finale et fichiers modifiés

La relecture indépendante confirme les 1 279 fiches, les deux bases et les 35 310 comparaisons. Les instructions natives, les champs sources, les origines retenues, les chaînes de parents et les valeurs exactes des derniers points sont contrôlés. Les empreintes des trois registres précédents sont retrouvées par inversion exacte des seuls fragments modifiés. Les autres tâches, cases, notes, historiques, prérequis et inconnues sont conservés. Chaque base retourne `PRAGMA quick_check = ok`.

Fichiers de registre : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Suivi : `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`. Preuve publique : `docs/fidelity_attenuation_hierarchy_links_v736.json` et ce rapport. Bases ciblées : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3`. Scripts, journaux et deltas réversibles sont dans le corpus V736 sur F. Aucun code de jeu ni ressource originale modifié.

Contrôles réellement exécutés : lectures et recherches natives, comparaison des octets au PE original, vérification des champs et consommateurs, compilation hors ligne des sept modules sélectionnés, comparaison Rust des 35 310 résultats, huit diagnostics, refus de quatre falsifications, relance séparée du chargeur HIRC14, livraison et relecture indépendante. Les 213 refus du chargeur restent ouverts. La tâche globale reste ouverte. Reçu : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision736_delivery\INDEPENDENT_READBACK.json`.
