# SYS-01.2-02 — Effets Meter de Init, V738

Référence PUBLIC4.20.0.315 EUW/en_GB ; banques candidates de voix en_US, sélection historique ouverte.

## Résultat et sources

Init.bnk contient huit ressources HIRC19 du plugin Meter 0x810003. Leurs huit références dans les slots des bus sont vérifiées dans les octets originaux. Les chaînes d’ancêtres des banques candidates permettent de préciser les ressources associées à chacune des 1 278 fiches de voix et skins ; elles ne prouvent pas une exécution de chaque effet pour chaque action.

Le producteur original7062A0 enregistre le plugin dans un contexte déclaré. AF85A0/B254C0/B253F0/B3DF60/B3E040/B3E0B0 chargent ensuite les huit corps originaux consécutivement. Les paramètres de32octets correspondent aux25octets sérialisés, y compris l’expansion du booléen. Les527adresses exécutées correspondent au PE original ; aucun accès mémoire bas n’est admis. Deux diagnostics conservent le succès natif1 avec pluginFFFFFFFF/paramètre0 lorsque l’enregistrement manque ou que l’allocation du paramètre échoue.

## Consommateurs actuels et contrôles

31modules actuels sont compilés hors ligne, sans remplacement des déclarations par des stubs. Le chargeur de section charge les huit corps HIRC19 assemblés dans une section dédiée. Les paramètres correspondent aux captures natives. Deux profils reproduisent huit objets sans paramètres, par plugin absent puis allocation refusée. Une dernière ressource tronquée est refusée avec sept objets antérieurs conservés. Les quatre profils sont déchargés : aucune ressource détenue ni allocation restante dans le banc. La libération native n’est pas exécutée par cette comparaison.

Six rôles précis sont ajoutés : section, ressource, installation et bloc de paramètres, libération actuelle, frontière ENVS statique. Cette dernière est associée à SYS uniquement. Les cinq autres rôles restent limités à ce composant. Quatre métadonnées falsifiées sont rejetées.

La section ENVS de112octets est décodée en quatre courbes, huit points et36champs comparés aux octets originaux et à WWiser. Le lecteur courant reconnaît ENVS mais retourne une erreur explicite. Cette frontière est inspectée statiquement ; aucun lecteur ENVS natif ou courant n’est exécuté ici.

## Intégration et limites

1 279fiches, trois registres, les documents de couverture/reprise et les deux bases reçoivent les liens et les instructions copiables. Les cases, notes, historiques, prérequis, inconnues et autres tâches sont conservés par deltas ciblés, sans nouvelle copie complète des bases.

Deux erreurs du banc restent conservées : une chaîne println incorrecte a empêché la première compilation ; un simulateur visant toute allocation32octets refusait également le tableau de huit références. Le banc final vise précisément l’allocateur des paramètres. Aucun code du jeu n’a été modifié pour faire passer ces contrôles.

Allocateurs, verrous et services mémoire sont fournis. Les paramètres Meter ne constituent pas une instance DSP active sur bus. ENVS, HIRC8/STMG, HIRC14, montage historique, locale effective, médias, décodage et lecture restent à qualifier. Aucun jeu complet ou son audible accepté.

[Reçu](fidelity_init_meter_links_v738.json). Corpus privé : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision738_*. Livraison : revision738_delivery/VERIFIED.json.


## Relecture finale et fichiers modifiés

La relecture indépendante confirme les 1 279 fiches et les deux bases, les huit paramètres Meter, les références de bus recalculées et les 527 adresses natives. Les 36 champs ENVS restent qualifiés comme données source uniquement. Les trois registres retrouvent exactement leurs empreintes précédentes par inversion des fragments. Les autres tâches, cases, notes, historiques, prérequis et inconnues sont conservés. Les deux bases passent PRAGMA quick_check et les instructions copiables contiennent les anciens et nouveaux contextes.

Fichiers de registre : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Suivi : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md. Preuve : docs/fidelity_init_meter_links_v738.json et ce rapport. Bases ciblées : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Scripts, sources des sondes, journaux et échecs conservés dans le corpus V738 sur F. Aucun code de jeu ni ressource originale modifié.

Contrôles exécutés : huit chargements originaux, deux diagnostics natifs, 31 modules Rust compilés hors ligne, huit comparaisons de paramètres, trois diagnostics Rust dont troncature avec sept objets conservés, quatre déchargements de profils, quatre falsifications, audit des associations et relecture des deux bases. Le déchargement natif, les lecteurs ENVS et le jeu complet ne sont pas exécutés. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision738_delivery\INDEPENDENT_READBACK.json.
