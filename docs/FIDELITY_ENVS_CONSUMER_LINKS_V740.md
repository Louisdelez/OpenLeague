# SYS-01.2-02 — Consommation ENVS et composants actuels, V740

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Ce lot établit des liens source/consommateur ; il ne termine pas le moteur audio.

## Résultats originaux et attentes

La banque Init.bnk reste identifiée par son SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004 ; son ENVS occupe112octets à6778, avec quatre courbes et huit points. Les36champs sont vérifiés contre les octets originaux. Le PE PUBLIC4.20.0.315 porte le SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Après le lecteur STMG et le chargement ENVS originaux sous gestionnaires déclarés, ADECF0 est exécuté sur36évaluations, bornes et valeurs extérieures comprises. Les attentes indépendantes appliquent la conversion B148B0 puis les opérations f32 dans leur ordre original ; les valeurs et indices correspondent exactement.

B199D0 est exécuté entièrement avec AED6C0 et B19CA0 : sept profils,49cas et98triplets de sortie aux offsets+14/+18/+1C. Le mode1 applique les courbes de gain0et2 ; le mode2 les contourne. Les profils couvrent deux flags actifs, chacun désactivé, tous deux désactivés et chaque pointeur de courbe manquant. Deux enregistrements sélectionnent les auditeurs0et7 avec des valeurs distinctes. Les octets owner+38/+40 sont multipliés par la constante native 0x3B808081 puis par100 : ce n’est pas une division par100. Les triplets et84appels de courbe concordent avec une reconstruction indépendante des opérations.

Les descripteurs de voix, propriétaire et auditeurs sont fournis au banc. Volume de base0, gain propriétaire0.5, transition absente et atténuation neutre en cache sont explicites. Les branches de recherche de ressource, de courbes de distance et de cône ne sont pas qualifiées. Les1620adresses observées correspondent au PE, aucun accès mémoire bas n’est autorisé. Les courbes sont libérées après restauration de leurs pointeurs d’origine ; les transports d’allocation/libération, verrous, mémoire et TLS restent fournis.

## Consommateurs actuels

Les fichiers réels audio_curves.rs et audio_gain.rs sont compilés hors ligne, sans modification. Curve::bus_gain, Curve::evaluate et amplitude sont exécutés avec les points originaux. Les36évaluations et les98triplets d’un assemblage privé concordent bit à bit. Cet assemblage n’est pas une orchestration ENVS du produit. Trois rôles précis sont reliés : conversion de gain, interpolation et conversion du volume de base. Six refus locaux passent : NaN, scaling impropre à bus_gain, courbe vide, abscisses non croissantes, interpolation non supportée et volume infini. Ils ne sont pas présentés comme la politique d’erreur du client original.

Le lecteur audio_bank_memory_reader.rs refuse encore ENVS ; la preuve V739 est conservée comme antérieure. audio_mix::Contract::evaluate est inspecté : il calcule séparément des contrôles RTPC de bus et l’atténuation. Il n’est pas promu en consommateur des voix ENVS. La recherche des points d’entrée ne prouve aucune absence globale d’autre implémentation.

## Contrôles, conservation et limites

Quatre falsifications sont rejetées : résultat altéré, normalisation par le mauvais facteur, sélection incorrecte d’auditeur et fausse revendication d’orchestration produit. Le premier banc natif tentait une capture de retour via un emplacement déjà réservé à un transport ; il est conservé avec son échec. Le banc corrigé observe le chargement de retour original. Une première compilation Rust a échoué sur une parenthèse de la sonde ; sa source et son journal sont conservés, le produit n’a pas changé. Les exécutions finales reviennent avec le code0.

Deux fiches sont enrichies : SYS-01.2-02 et SYS-02.2-07. Le registre, les deux bases et leurs instructions copiables gardent les états manuels et les preuves antérieures. Les deltas ciblés évitent toute nouvelle copie complète de base. Le résultat ne résout ni l’usage ENVS dans une partie historique, ni le producteur des octets, ni le chargement courant, ni une sortie audible. Les consommateurs de filtre B18EBE/B197C7 restent à qualifier.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md ; ce rapport et docs/fidelity_envs_consumer_links_v740.json. Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Scripts, journaux et reçus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision740_*. Aucun code produit ou asset modifié.

[Preuve](fidelity_envs_consumer_links_v740.json). Livraison : revision740_delivery/VERIFIED.json ; relecture indépendante à contrôler avant revendication finale. Goal ouvert.


## Relecture finale

La relecture indépendante passe :112octets ENVS et36champs contrôlés,1620adresses natives comparées au PE,36évaluations et49cas recalculés indépendamment,98triplets et84appels de courbe exacts. Les deux modules Rust, le binaire, les journaux, les six refus et la composition diagnostique restent identifiés. Le registre contient100311sources et5668consommateurs ; seuls six fichiers de source sélectionnés sont revérifiés dans ce lot, aucune revérification intégrale de toutes les sources n’est revendiquée.

Les deux bases passent quick_check ;42605autres tâches,42607états manuels,23historiques,24phases,2770lots et42215groupes sont inchangés. L’inversion ciblée retrouve les octets antérieurs des trois registres. Les instructions copiables et tous les anciens contextes sont vérifiés. Aucun statut manuel ou inconnu n’est promu. L’erreur de délimiteur du préparateur de publication est conservée ; elle a empêché toute exécution du premier préparateur et a été corrigée avant publication.

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision740_delivery\INDEPENDENT_READBACK.json. Les contrôles d’assemblage restent privés ; ENVS courant, producteur historique des valeurs, filtre et sortie audible restent ouverts.
