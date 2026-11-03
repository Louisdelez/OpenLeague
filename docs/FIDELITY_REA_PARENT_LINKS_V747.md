# SYS-01.2-02 — Parent ENVS, frames et décodeur PCM, V747

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. V746 est un progrès vérifié : associations et plan modifiés, puis relus indépendamment. Cette suite conserve l’objectif source → exigence → consommateur, sans déclarer le jeu terminé.

## Fonctions et ressources originales

REA 6.4.0/Ghidra 12.1.4 importe le PE original complet. Les neuf fonctions, 2 533 instructions et 13 références sont recoupées avec les octets du client. Session fermée normalement ; original et copie inchangés. Les signatures de décompilation restent des hypothèses, pas les déclarations C++ originales.

Client : 15 973 880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk : 6 890 octets, SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les 112 octets ENVS, 36 champs et points des courbes sont vérifiés contre la banque originale.

B17486 appartient à B171F0, une fonction de 1 250 octets. B15086 appartient à B15030. Les appelants repérés sont respectivement B17A60 et B0ED50 : ils constituent les prochaines entrées pour suivre les contrôles vers le filtre. Leur simple présence ne qualifie pas le transport complet.

## Parent exécuté et sélection des branches

Le parent entier B171F0 et son helper de gain B170C0 sont exécutés en mémoire Unicorn isolée, après les lecteurs originaux STMG/ENVS. Les sept profils ENVS, quatre dispositions d’auditeurs et six couples d’octets donnent 168 cas par branche.

- Bits bas de voice+12B à 1 : B18530 est réellement appelé avec le descripteur et la liste de sorties du parent. Les 252 paires aux offsets 240/244 correspondent aux points originaux ; 216 évaluations de courbes sont observées.
- Bits bas à 0 : B168E0 est appelé. Les 252 paires gardent le filtre de base à 240 et la valeur antérieure à 244 ; aucune évaluation de ces courbes ENVS LPF n’est observée.
- Gain de sortie nul : 16 cas couvrent les flags du parent 0/4 et les bits bas 0/1. Aucun des deux chemins spatiaux n’est appelé. Les flags 0 deviennent 2 et produisent les sorties [1,0] ; les flags 4 restent 4 et produisent [1,1]. La voix et les paires de filtre sont conservées.

Total : 352 cas, 528 paires, 2 972 adresses natives distinctes vérifiées. Arguments de dispatch, état du parent, voix avant/après, courbes et libérations sont conservés. Aucun accès mémoire bas. Les autres gains observés ne sont pas assimilés à un mixeur complet.

Les contextes fournis déclarent notamment un pointeur de bus racine nul, des contrôles de voix déjà en cache, un auxiliaire de voix nul et des sorties préallouées. Les feuilles d’allocation/verrous/TLS/transport du banc restent explicites. Démarrage historique, propriété réelle des voix, autres chemins du bus et PCM restent hors de cette preuve.

## Autre entrée de file et consommateur Rust

La référence supplémentaire vers B06370 est B08440, qui publie un marqueur de frame opcode 0. B05670 reçoit les deux appels déjà repérés dans B06370. Cela borne les voies directes étudiées, sans prouver l’absence globale du producteur de commande 20.

B08440/B20E90 et les branches de file sont exécutés sur 90 cas : 36 files vides sans publication, 54 frames publiées et 27 signaux de worker. Les cas couvrent fin exacte de page, passage à une autre page, compteur FFFFFFFF → 0 et handle de signal nul/non nul. Le padding du paquet provient de trois remplissages déclarés de pile.

Les mêmes 90 cas passent dans Context::publish_frame actuel. État, table, octets des pages, compteur et ordre des événements concordent. Un contrôle local de page trop courte retourne Truncated sans modifier la file ni signaler le worker ; le header du buffer de frame fourni est écrit avant ce refus. Ce comportement local ne constitue pas un refus natif de mémoire invalide.

Quarante fichiers Rust actuels sont compilés inchangés, confirmés par les dépendances du compilateur. Compilation et exécution retournent 0, hors ligne et sans incrémental. Les verrous, SetEvent et memcpy natifs sont des adaptations explicites ; aucune exécution de thread physique, attente, croissance de file, commande audio ou périphérique n’est revendiquée.

## Route PCM actuelle : présence et limite

L’inspection syntaxique syn de trois fichiers distingue les blocs cfg(test). Le module pcm_audio est déclaré et son plugin est ajouté dans run_client. Decoder::next appelle réellement Controller::process_voice dans le code ordinaire quand le filtre optionnel est présent.

PcmAudio::new initialise filter à None. controlled_filter l’affecte à Some ; filtered délègue à cette méthode. Les autres activations découvertes par la recherche littérale bornée sont dans des tests. Le décodeur existe donc déjà ; la liaison des sorties ENVS 240/244 à FilterControl reste non établie. Cette inspection ne compile ni n’exécute le client ordinaire, n’étend pas les macros et ne prouve pas une absence globale de route dynamique.

## Contrôles et conservation

Six falsifications sont rejetées : sortie parent altérée, mauvais gate de mode, mauvais flags silencieux, incrément de frame vide, filtre présenté actif par défaut et activation de test présentée ordinaire. Deux compteurs hérités du banc silencieux ont été corrigés à partir des lignes réelles : quatre profils et deux dispositions. Le premier reçu reste conservé. Une erreur de syntaxe du vérificateur a été corrigée avant son exécution ; le fichier et le diagnostic initiaux restent conservés.

Trois rôles sont ajoutés : publication de frame exécutée, API d’activation de filtre inspectée et consommation optionnelle par le décodeur inspectée. SYS-01.2-02 et SYS-02.2-07 sont enrichies. Les trois registres, coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md sont mis à jour avec ce rapport et son reçu. Les deux bases du plan sont synchronisées par deltas ciblés ; cases, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Aucun code produit ni asset modifié.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision747_rea_envs_parent ; revision747_envs_parent_native ; revision747_envs_parent_alternative ; revision747_envs_parent_silent_checked ; revision747_native_frame ; revision747_rust_frame_routes ; revision747_associations_checked ; revision747_delivery. Les reçus VERIFIED.json et INDEPENDENT_READBACK.json distinguent publication et relecture.

Restent ouverts : transport 240/244 via B17A60/B0ED50/B15030 et production actuelle des contrôles, parent avec bus/auxiliaires, corps 20 et état étendu, orchestration ENVS, Meter, Init STMG/HIRC8/HIRC14, médias, locale et son audible. Goal actif.
