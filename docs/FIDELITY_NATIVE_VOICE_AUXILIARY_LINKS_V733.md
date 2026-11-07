# SYS-01.2-02 — Atténuations et ressources d’effets des voix, V733

Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Les banques disponibles portent des chemins en_US ; leur sélection historique pour en_GB reste ouverte.

## Résultat intégré

Les 535 objets auxiliaires de 183 banques candidates sont reliés aux sources natives et aux consommateurs actuels : 213 HIRC14 (atténuations, 231 courbes) et 322 HIRC19 (ressources d’effets). Les 8 068 champs du parseur WWiser sont vérifiés sur les octets originaux ; le décodage indépendant recoupe 6 026 champs. Les en-têtes, identifiants et empreintes de chaque payload sont vérifiés.

Les fonctions natives AF8350/B214D0/B216D0 et AF85A0/B25170/B254C0 sont exécutées sur chacun des 535 objets dans un registre neuf. La table du dispatcher rattache explicitement les types14 et19 à leurs lecteurs. Les 747 adresses natives distinctes des cas nominaux et diagnostics correspondent aux octets du PE original SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les courbes, sélecteurs, transformations de scaling et curseurs finaux sont contrôlés.

## Écarts constatés dans le consommateur actuel

| Entrée | Attendu dans le profil déclaré | Observé | Limite restante |
|---|---|---|---|
| 213 objets HIRC14 | Le lecteur natif charge les courbes | Native : succès ; Rust : refus explicite avant consommation/allocation | Corps HIRC14 et fournisseur d’atténuation de banque non qualifiés dans le chemin actuel |
| 322 objets HIRC19, registre vide | Ressource chargée, aucune entrée de plugin disponible | Natif et Rust : retour1, pluginFFFFFFFF, paramètre0 | Un succès de lecture ne rend pas l’effet utilisable |
| Les mêmes 322 objets, registre Meter uniquement | Le plugin Meter ne correspond pas aux plugins des voix | Rust : mêmes 322 succès sans installation | Implémentation/intégration des plugins650002 (320 objets) et6A0003 (2 objets) non établies |
| Créateur courant inconnu | Refus explicite et nettoyage | Erreur unqualified plugin creator, ressources libérées dans le banc | Aucun DSP original déduit du refus |
| Capacité propriétaire nulle | Distinguer enregistrement et propriété | Succès et objet inscrit, sans entrée propriétaire | Ce statut n’est pas une preuve de prise en charge complète |
| Payload tronqué | Refus | Rust : Truncated | Aucune entrée manquante inventée |

Six rôles de consommation sont ajoutés aux points précis : load_effect, load_section, BankResource::load, install, Registry::create et spatial_controls::apply. Les deux derniers contrôles de chemin load_section/spatial::apply sont identifiés par lecture du code, sans prétendre les avoir exercés dans le probe. Le registre d’atténuation fourni manuellement à spatial::apply n’établit pas son alimentation depuis les HIRC14 originaux.

Le probe compile six modules Rust réels par leurs chemins actuels. Il reprend les déclarations Error et Resource/Store de leurs fichiers ; trois types d’erreur imbriqués inutilisés et les interfaces mémoire/verrous sont fournis par le banc. Ce n’est ni une compilation du crate complet ni une exécution du client. L’exécutable et les sources sont identifiés ; 644 cas HIRC19, 213 refus HIRC14 et 3 contrôles supplémentaires passent, avec une relecture d’exécution indépendante après la compilation.

## Refus et correction de preuve

Douze diagnostics natifs passent : réutilisation des objets14/19, lecture absente, allocation de fabrique refusée, capacité propriétaire nulle, allocation de courbe refusée (52), absence de courbes (2), points vides (31) et créateur de paramètre nul. Quatre falsifications sont refusées par le contrôle : mauvaise classe, mauvais scaling, plugin faussement déclaré installé et consommation tronquée.

L’ancien reçu de diagnostics nommait par erreur supplied_empty=true le cas doté d’une entrée à créateur nul. Le nouveau reçu conserve la valeur réelle count=1, corrige ce libellé à false et réexécute les douze cas. Les anciennes preuves restent intactes. Le registre vide des 535 cas nominaux n’est pas concerné par cette correction.

## Portée des liens et conservation

1278 fiches de voix/skins et SYS sont enrichies, avec leurs textes copiables dans les deux bases. Les objets sont associés aux banques déjà candidates de chaque fiche ; ce lien ne prouve pas que chacun est sélectionné par l’action de voix. 193 sources identifiées et les 35 points de consommation liés sont contrôlés. Six rôles nouveaux sont ajoutés sans remplacer les précédents.

Les cases, notes, historiques, statuts, inconnues, prérequis et autres tâches sont conservés. Le goal et les fonctionnalités audio restent partiels. Les cônes et tables RTPC/paires des objets originaux sont nuls ; aucune qualification générale de leurs variantes non nulles n’est déduite.

Les limites détaillées figurent dans [le reçu de liaison](fidelity_native_voice_auxiliary_links_v733.json). Corpus et reçus uniques : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision733_auxiliary_sources, revision733_auxiliary_native, revision733_auxiliary_controls_verified, revision733_rust_auxiliary et revision733_auxiliary_associations.

Registres concernés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json. Suivi : coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md. Livraison : revision733_delivery/VERIFIED.json ; relecture indépendante dans INDEPENDENT_READBACK.json.


## Relecture finale

La relecture indépendante réussit : 1 279 fiches, deux bases avec intégrité ok, six nouveaux consommateurs, 535 objets, 8 068 champs et 747 adresses natives. Les champs se répartissent en 1 070 champs d’en-tête et 6 998 champs de corps. Le premier vérificateur les supposait tous à l’intérieur du corps ; `revision733_independent_readback_verified.py` accepte exclusivement les deux champs d’en-tête attendus, avec contrôle de leurs noms, tailles, positions et valeurs. Aucun écart d’octets ni de valeurs dans les sources. Le script initial et le diagnostic `READBACK_HEADER_CORRECTION.json` sont conservés.

La relecture restaure les empreintes des trois registres précédents par inversion exacte des seuls fragments modifiés. Les 41 328 autres tâches, 42 607 états manuels, 23 entrées d’historique, 24 phases, 2 770 lots et 42 215 groupes sont identiques dans chaque base. Aucun état de tâche ou d’inconnue n’est promu. Les six documents de suivi reçoivent ce constat sans modifier les bases.
