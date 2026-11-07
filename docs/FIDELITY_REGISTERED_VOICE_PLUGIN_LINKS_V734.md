# SYS-01.2-02 — Registre natif et paramètres Silence, V734

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Les six banques candidates restent des ressources en_US ; leur sélection historique n’est pas établie.

## Résultat

La fonction originale7062A0 contient les enregistrements Vorbis, Meter FX et Silence Source. Les arguments immédiats, wrappers AEAED0/AEAF30, producteurs B09520/B09590, insertion B09610 et croissance AF95A0 sont reliés et exécutés dans un registre déclaré initialement vide. Les étiquettes proviennent des chaînes du PE original, pas du seul nom donné par un outil.

Le producteur installe le codec0x40001 et les plugins0x810003/Meter et0x650002/Silence. Pour Silence, les créateurs sont B3ED70 (source) et B3ED50 (paramètre). Les entrées du registre sont réellement produites par le code original avant chaque chargement HIRC19 ; aucun pointeur inventé ne remplace le créateur testé.

| Ressources originales | Profil natif produit par7062A0 | Modules Rust actuels sous les mêmes entrées |
|---|---|---|
| 320 ressources Silence0x650002 | Paramètre installé : vtableFF36FC et trois scalaires originaux, via B3ED50/B3EE50/B3EEB0 | Enregistrement accepté, puis refus explicite du créateur par MeterCreators ; ressource nettoyée |
| 2 ressources0x6A0003 de Sion, nommées Delay par WWiser | Aucune entrée correspondante dans ce profil ; retour1 avec pluginFFFFFFFF et paramètre0 | Même absence de correspondance et aucun paramètre installé |

Les 320 ressources Silence se répartissent dans les banques candidates Nidalee96, Quinn112, Swain64, Udyr32 et Warwick16. Les deux Delay appartiennent à la banque Sion de base. Il s’agit du nombre d’objets sources ; leur rattachement à plusieurs fiches ne crée pas autant de ressources supplémentaires et ne prouve pas leur sélection par chaque action.

Le manque Silence est ici une implémentation actuelle refusée explicitement, alors que les données et le créateur natifs sont disponibles. Pour Delay, ce test qualifie seulement l’absence dans ce producteur ; il ne prouve ni l’absence globale d’un autre créateur ni l’usage historique de ces deux objets.

## Vérifications

Les 322 objets, leurs paramètres, en-têtes et empreintes, 3226 champs du relevé source et 619 adresses natives distinctes sont vérifiés. Les mêmes octets sources alimentent le test Rust. Sept modules actuels sont compilés par leurs chemins, dont Table::register ; le registre provient des arguments de l’original. Les 322 profils d’enregistrement et 322 refus de doublons passent ; 320 refus Silence et deux Delay sans installation sont explicitement observés.

Le probe reprend les déclarations Error et Resource/Store des sources actuelles ; trois types imbriqués inutilisés et les interfaces mémoire/verrou sont fournis par le banc. Aucun crate complet ni client normal n’est compilé ou exécuté. Les sources, compilateur, binaire et journaux sont identifiés ; l’exécutable est relancé lors de l’audit.

Onze diagnostics natifs contrôlent les doublons, une allocation de registre codec refusée suivie des deux enregistrements de plugins, l’échec d’allocation du paramètre, son clonage, les valeurs par défaut, les trois setters et leurs refus. L’Init de longueur nulle produit les valeurs1/0/0. SetParamsBlock lit trois floats même avec une longueur déclarée nulle lorsque les12octets sont présents : ce test ne fournit pas de mémoire tronquée. Quatre falsifications sont refusées.

Deux préparations ont été corrigées avec preuves conservées : l’identifiant codec inclut le type1, donc0x40001 ; le créateur utilise l’allocation alignée ADA610 via B18410. Le banc fournit cette interface avec alignement16 et maintient la liste stricte des verrous. Il ne simule pas le gestionnaire mémoire historique complet.

## Intégration et limites

42 fiches sont enrichies : SYS, 21skins et20voix de champions. Les1237autres fiches audio deV733 restent inchangées. Deux nouveaux rôles pointent vers Table::register et vers le refus du créateur dans MeterCreators. Ce dernier lien est ajouté uniquement aux fiches avec Silence, pas aux dix fiches Sion portant uniquement Delay. Les 16 sources et 32 points de consommation liés sont contrôlés.

Les trois registres, leurs textes copiables dans les deux bases, coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md sont mis à jour. Les cases, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Aucun code du jeu ou asset modifié.

L’installation d’un paramètre Silence ne qualifie pas le générateur, son calendrier, les échantillons, le mélange ou le périphérique audio. Le démarrage historique, les autres producteurs, HIRC14, bus et lecteur complet restent ouverts. Les profils V733 vide/Meter ne sont pas réécrits : ce sont des cas déclarés différents.

[Reçu de liaison](fidelity_registered_voice_plugin_links_v734.json). Corpus sur F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision734_registered_voice_plugins_aligned, revision734_registered_plugin_controls, revision734_rust_registered_plugins et revision734_registered_plugin_associations_scoped. Livraison : revision734_delivery/VERIFIED.json ; relecture indépendante dans INDEPENDENT_READBACK.json.


## Relecture finale

La relecture indépendante réussit sur 42 fiches et deux bases avec intégrité ok : 322 objets de six banques, 3 226 champs sources, 619 adresses natives, 11 diagnostics et quatre refus de falsification. Les 320 installations natives de paramètres Silence sont distinguées des 320 refus du créateur actuel ; les deux ressources Delay restent sans entrée dans ce profil de registre. Les sept modules Rust ont été compilés et exécutés comme composant isolé ; aucun jeu complet ou son audible accepté.

Les trois registres retrouvent leurs empreintes précédentes par inversion exacte des fragments modifiés. Les 42 565 autres tâches et tous les états, notes, historiques, phases, lots et groupes sont inchangés dans les deux bases. Les 1 237 autres fiches audio V733 restent intactes. Les six documents de suivi reçoivent ce constat sans modifier les bases. Reçu : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision734_delivery\INDEPENDENT_READBACK.json`.
