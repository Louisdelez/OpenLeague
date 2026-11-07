# Liens précis des formats natifs — V45

Cette livraison traite SYS-01.2-02/03/06 en reliant cinq exigences SYS-02.2 à leurs sources et consommateurs actuels. Elle ne réalise ni n'accepte les futures tâches de validation complète des formats. Les six objectifs du Goal restent conservés ; les divergences4312/4313 et les scripts communautaires restent distincts.

## Sources et consommateurs réels

Neuf fichiers natifs exacts correspondent aux manifestes des deux projets sélectionnés par la solution4.20 EUW : Base.inibin, Nexus.skn, nexus.skl, nexus_idle.anm, Saucer8.SCB, TT_Heal_Plus.sco, deux textures de structure/relique et Blue_Minion_Basic.dds. Les tailles/MD5 des membres et SHA256 des fichiers sont contrôlés. La priorité effective d'un provider en exécution n'est pas déduite de l'appartenance à un manifeste.

Treize ancres actuelles relient la conversion hors ligne et les admissions Rust : export_intact_structure_animations.py, catalogue/request/chargement GLTF, recover_map10_particle_scb.py, décodeurs bornés SCO/SCB, et plugin/requête/validation DDS. Les fichiers SKN/SKL/ANM sont convertis hors ligne ; le client consomme les GLB. La branche DDS des sbires est enregistrée et son garde DRAFT vaut false dans le source. Une inscription dans le code ne prouve pas le rendu GPU.

Les versions des exécutables, DLL, PDB et sources sont leur snapshot exact et SHA. La base Git du SDK est consignée séparément ; aucune identité de blob amont n'est inventée. Six sources correspondent aux checksums de leurs documents PDB et aux GUID CodeView des assemblies. Cela reste une correspondance de debug, pas une preuve de compilation reproductible ni de signature cryptographique.

## Attendu, observé et limites

| Cas | Attendu | Observé |
|---|---|---|
| SKN, SKL/ANM, conversion complète SKN/SKL/DDS/ANM | Lecture des échantillons et sortie locale, sans installation |3succès ;21joints/21pistes,63canaux et2885sommets ;positions identiques au GLB déjà installé |
| Entrées à magic invalide ou tronquées | Refus par l'importeur existant |8refus ;les journaux et codes sont conservés |
| SKN major65535/minor1 | Diagnostic explicite du garde de version courant |Accepté par le binaire existant. Cet écart reste ouvert ;aucune acceptation du chargeur Riot n'en découle |
| SCB nominal | Lecture/export |GLB produit avec en-tête valide,mais code de sortie perdu lors du décodage du journal. Le cas est partiel,non rejoué et exclu des succès stricts |
| SCO Heal_Plus | Exécution du module Rust inchangé dans un hôte de composant |132coins et digest de tous les mots `1a1a3e139b9c5bf0` ;1succès et5refus. Types parents fournis,aucun Bevy/GPU ni chargeur SCO générique |
| Altération des preuves | Refuser les identités, ancres, résultats et promotions injustifiées |35contrôles :33refus,1nominal,1contrôle positif de représentation numérique équivalente |

Les exécutions sont celles d'un importeur local et d'un hôte de composant Rust. Aucun processus historique du jeu ni rendu GPU n'est lancé. Les textures ne sont pas remplacées et les GLB produits restent dans le dossier de preuves.

## Registre et reprise

Les anciennes questions génériques de liaison SKL/ANM/DDS sont résolues uniquement pour l'association source/consommateur. Les questions SKN et SCB/SCO restent ouvertes, précisées avec le garde permissif et la preuve partielle. Textes, recherches et historique antérieurs sont conservés. Les cinq tâches SYS-02.2 restent a_faire ; aucune case ni acceptation automatique.

Le reçu `docs/fidelity_registry_format_links_revision_4_20.json` contient les fichiers modifiés, commandes effectivement exécutées, identités, résultats et audit final. L'intégration contrôle les42214consignes,15échantillons HTTP et la conservation des42606états/historique manuels. La qualification globale hérite explicitement des sources V44 et relit les nouvelles entrées/delta ;elle ne prétend pas refaire un scan global.


## Supplément d’audit statique — SYS-02.2-04, consommateur des géométries SCB/SCO (2026-11-02)

### Contrat et provenance

La fiche `SYS-02.2-04` porte le titre « Valider les géométries des fichiers SCB et SCO », reste `required=true` et son état recensé est `a_faire`. Son critère demande l’intégration dans un consommateur réel et une vérification nominale/refus sur la référence 4.20. Ces états ne sont pas modifiés par ce supplément.

Les deux copies courantes sur F ont été comparées aux fichiers originaux sur D : `Saucer8.SCB` correspond octet pour octet (SHA-256 `D0D033CF3D23990D1ADA3363FEC5D955EF0B85AC3E0B46649EDCC4F653200228`) et `TT_Heal_Plus.sco` correspond octet pour octet (SHA-256 `B7D941AF9D76B44834F513717EEB4AAF6067B1FE61124559DE38518239CAA2E3`). L’appartenance aux manifestes de la solution 4.20 est la preuve V45 conservée dans ce même rapport; l’égalité des copies ne démontre pas la priorité de chargement historique.

### Contrat local observé

`crates/client/src/nexus_complex_mesh.rs:4-7,67-75` épingle les octets de Heal_Plus et de Saucer8. Le décodeur local accepte ces entrées par égalité exacte; la branche Saucer8 lit une géométrie déclarée de 80 sommets et 80 triangles (240 coins), tandis que `heal_plus_sco.rs` impose le texte ASCII, 24 sommets, 44 faces triangulaires `lambert1` et 132 coins. Les empreintes courantes de `nexus_complex_mesh.rs` et `heal_plus_sco.rs` sont respectivement `991E0066EB7A7A418BA84861DAC35459051B31248DBF40F70031E26577175B8D` et `36FE1B823ED708DE014C17C298C704E9148FE337938D84817C96977DED310A11`.

Résultat nominal attendu du contrat local : 240 coins pour la géométrie Saucer8 et 132 coins pour Heal_Plus. Pour Heal_Plus, le reçu V45 rapporte une exécution dans un hôte de composant : un succès, cinq refus et le digest de tous les mots source `1a1a3e139b9c5bf0`. Cette preuve est héritée et n’a pas été rejouée. Pour Saucer8, V45 rapporte un GLB produit avec un en-tête valide mais l’observation du code de sortie a été perdue; ce cas demeure partiel et n’est pas compté comme succès strict.

Les refus applicables au contrat local sont l’entrée étrangère ou modifiée, tronquée, prolongée, non ASCII ou dont les comptes/indices/faces diffèrent. Les tests présents décrivent ces cas, mais aucun test ni build n’a été exécuté pendant cette reprise. Le message du décodeur SCB indique « three pinned originals » alors que quatre entrées SCB nommées sont admises dans le code (Nexus, Sparkle, Crown et Saucer8); c’est une incohérence de diagnostic, pas une preuve d’échec géométrique.

### Consommateur réel et conclusion de portée

La recherche statique courante des références à `PICKUP_SOURCE`, `HEAL_PLUS_SOURCE` et `Geometry::decode` trouve leurs branches d’admission et leurs tests. Les callsites de production trouvés chargent `Geometry::original()`/`sparkle()` dans `nexus_complex_host.rs:31` et `Geometry::crown()` dans `nexus_crown_live.rs:210`; aucun callsite de production ne transmet Saucer8 ou Heal_Plus au décodeur. `PICKUP_SOURCE` est consommé par le test de géométrie Saucer8; le décodage Heal_Plus est consommé par les tests de `heal_plus_sco.rs`. Le chemin normal de jeu ne rend donc pas ces deux ressources via ces décodeurs.

**Audit statique clos uniquement pour la présence/absence du consommateur local : le décodeur et ses limites sont identifiés, et l’absence d’appel de production est établie dans les modules inspectés. SYS-02.2-04 reste ouvert** : l’export SCB n’a pas de code de sortie conservé, aucun appel de production n’intègre les deux géométries, et le rendu ou l’équivalence visuelle native ne sont pas qualifiés. Cela ne clôt ni la fonction, ni la tâche, ni le goal.

### Conditions précises de reprise

1. Pour Saucer8, récupérer le journal donnant le code de sortie du producteur V45 ou rejouer uniquement l’exporteur hors ligne existant sur les octets épinglés, en conservant commande, code de sortie et hash de la sortie; comparer ensuite sommets, triangles et coins au résultat attendu.
2. Pour satisfaire le critère « consommateur réel », identifier ou intégrer un callsite de jeu pour chacune des ressources, puis vérifier le chemin nominal et les refus sur les hashes courants sans confondre le parseur compilé ou un test unitaire avec un rendu runtime.
3. Conserver comme limites ouvertes la priorité du provider natif, la pose/pivot, matériau/texture, VFX et capture GPU; les preuves V45 ne les qualifient pas.

Contrôles réellement exécutés ce tour : comparaison SHA-256 natif D ↔ copie F pour les deux ressources; inspection statique ciblée des références Rust et des callsites de géométrie. Aucun test, build, export, lancement de jeu, modification de code, de registre, de goal, de Plan ou de base n’a été effectué.
