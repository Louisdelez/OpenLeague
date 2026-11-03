# SYS-01.2-02 — Banque Init et bus audio, V737

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Les banques candidates de voix restent en_US ; leur sélection historique reste ouverte.

## Sources et résultat natif

Init.bnk contient 91 objets : 79 bus HIRC8, quatre états HIRC1 et huit effets HIRC19. Sa taille de 6 890 octets, son SHA-256 et son MD5 correspondent au membre sélectionné du projet lol_game_client 0.0.1.7, contenu 0.0.1.4. Cette appartenance ne prouve pas son ordre historique de montage.

Les 2 825 champs sont comparés aux octets originaux : 2 682 champs des objets et 143 champs STMG. La section STMG de 570 octets contient dix groupes d’états, seize transitions, une courbe de commutation et 21 valeurs par défaut. Les quatre IDs de bus référencés par les sons/conteneurs/ActorMixers des voix sont présents ; leurs chaînes de parents sont contrôlées.

Le code original B10320/B115C0 initialise le gestionnaire RTPC, puis AFB320 lit STMG. Les dix groupes et les 21 valeurs par défaut sont relus en mémoire et comparés aux sources. AFBD40/B044E0 et AFBF00 chargent ensuite les 79 bus et les quatre états dans l’ordre physique de la banque. Les propriétés, effets, RTPC, états et position passent dans les lecteurs originaux ; les curseurs atteignent exactement les fins des 79 corps de bus. Les 4 053 adresses exécutées correspondent aux octets du PE original. Aucun accès mémoire bas/nul n’est admis.

Deux contrôles supplémentaires retournent le refus natif 2 sans objet ajouté au propriétaire : enfant sans parent chargé et allocation de fabrique refusée.

## Consommateurs Rust actuels

31 modules actuels sont compilés hors ligne par leurs chemins originaux, sans remplacer les déclarations par des stubs. Les lecteurs de propriétés et de blocs RTPC concordent avec les 79 captures natives. Les huit abonnements contenus dans ces blocs conservent IDs, scalings, points et bits exacts. La comparaison RTPC qualifie le parseur et ses compteurs, pas l’installation complète des abonnements dans le moteur courant.

Le chargeur de section refuse les 79 corps HIRC8 avec chacune des politiques Reject et SkipNativeDefaults : 158 refus. Les corps connus ne sont pas ignorés silencieusement. Six diagnostics vérifient référence absente, classe erronée, allocation refusée, troncatures et bloc RTPC vide. Quatre falsifications des preuves sont rejetées.

Quatre rôles précis sont ajoutés : lecteur de propriétés, lecteur RTPC, refus de section HIRC8 et frontière de l’orchestration actuelle. Cette dernière fonction est compilée et inspectée statiquement ; elle n’est pas exécutée comme chargement complet dans cette comparaison.

## Intégration et conservation

1 279 fiches sont enrichies : SYS, 668 skins et 610 tâches de voix. Chaque association conserve ses banques candidates et ajoute seulement les IDs de bus directs et leurs ancêtres identifiés. Aucun usage de tous les bus par chaque action n’est déduit.

Les trois registres, les documents de couverture/reprise et les deux bases locales reçoivent ces liens et les instructions copiables. Cases, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Les deltas réversibles sont ciblés ; aucune copie intégrale supplémentaire de base.

## Essais conservés et limites

Le premier index ne reconnaissait pas ulStateID : échec conservé, puis correction explicite. Le premier essai d’un bus utilisait le contexte mémoire bas du banc hérité ; il ne qualifie pas l’initialisation historique. Le banc final impose un contexte extérieur valide, déclaré avec extension de position désactivée, et refuse tout accès mémoire bas. Un verrou d’états non pris en charge, puis un gestionnaire de groupes absent, ont arrêté les essais suivants. Ces échecs sont conservés ; le banc final ajoute le verrou observé et charge les vrais groupes par STMG.

Allocateurs, verrous, copies bornées et transports Windows GetLastError/TlsGetValue/SetLastError sont fournis. La construction du contexte extérieur et le lancement historique restent ouverts. Les huit effets HIRC19 et ENVS ne sont pas chargés par ce parcours ; aucune instance DSP ni sortie audible n’est validée. Le chargement HIRC8 actuel, le raccordement HIRC14, médias/décodage/mélange et client normal restent à qualifier. Aucun code de jeu ni asset modifié.

[Reçu](fidelity_init_bus_links_v737.json). Corpus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision737_*. Livraison : revision737_delivery/VERIFIED.json.


## Relecture finale et fichiers modifiés

La relecture indépendante confirme les 1 279 fiches et les deux bases, les 91 objets Init, 2 825 champs et 4 053 adresses natives. Les chaînes de parents sont recalculées depuis les références source propres à chaque fiche. Les empreintes des trois registres précédents sont retrouvées par inversion exacte des fragments modifiés. Les autres tâches, cases, notes, historiques, prérequis et inconnues sont conservés. Chaque base retourne `PRAGMA quick_check = ok`.

Fichiers de registre : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Suivi : `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`. Preuve publique : `docs/fidelity_init_bus_links_v737.json` et ce rapport. Bases ciblées : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3`. Scripts, journaux, tentatives échouées et deltas réversibles sont dans le corpus V737 sur F. Aucun code de jeu ni ressource originale modifié.

Contrôles réellement exécutés : lectures sources et STMG, lecteurs natifs des 79 bus et quatre états, comparaison au PE, vérification des champs et consommateurs, deux refus natifs, compilation hors ligne de 31 modules actuels, 79 comparaisons de propriétés et 79 blocs RTPC, 158 refus HIRC8, six diagnostics, quatre falsifications rejetées, livraison et relecture indépendante. La tâche globale reste ouverte. Reçu : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision737_delivery\INDEPENDENT_READBACK.json`.
