# Sources et consommateurs des archives et index 4.20 — V47

Cette révision traite les liaisons de SYS-01.2-02/03/06. Les tâches d'inventaire SYS-02.1-01/02/06 restent à faire ; aucune acceptation n'est déduite des échantillons.

| Exigence associée | Source et consommateur actuel | Limite restante |
|---|---|---|
| SYS-02.1-01 | Solution native68, configuration en_gb, deux manifestes exacts ; RadsReferenceMembership et Provider::from_catalog | Inventaire original RAF/versions non exhaustif ; filearchives/0.0.0.67 absent ; RAF reconstruits nommés séparément |
| SYS-02.1-02 | Cinq ZIP de la copie fournie,1066entrées ; central_entries, catalogue, appels de démarrage et HUD | Aucune indexation récursive universelle ni liste complète des dépendances ; l'absence d'extension imbriquée n'est pas une analyse de signatures |
| SYS-02.1-06 | Noms natifs, routines et index Rust actuels, projection exacte merged_rows | Une liaison générique résolue seulement ; index global des collisions, aliases, ordre historique et insertion/rehash complets restent ouverts |

Le module actuel et l'hôte de composant comparent720profils de recherche,188sorties de normalisation et72frontières de doublons aux preuves originales héritées. Aucun de ces essais originaux n'est rejoué.2132recherches portant sur1066entrées/1065noms et7gardes de refus sont exercées. Le doublon conserve chaque origine et le dernier identifiant du catalogue explicite ;cela ne prouve pas l'ordre historique.

Quatre profils de normalisation originale écrivent avant le tampon :seule la sortie est comparée au Vec sûr. Le décodeur ZIP complet,le fournisseur Bevy et le jeu historique ne sont pas exécutés. Le corps merged_rows est une projection textuelle avec empreinte et intervalle normalisé. Trois compilations de l'hôte ont échoué (JSON échappé,types Option puis liste de requêtes manquants) ;leurs sources et journaux sont conservés. La correction suivante conserve le module et le helper,ne rejoue aucune commande déjà réussie et compile/exécute l'hôte corrigé.

40contrôles de qualification comprennent le cas nominal,38refus d'altérations et un contrôle numérique équivalent. L'auditeur installé relit les fichiers et les membres des cinq archives ;les états,notes,révisions et historique des cases restent intacts. Les trois tâches futures restent a_faire. Le contrôle final compare toutes les consignes et16échantillons HTTP,avec empreintes de métadonnées et de consignes séparées.

Reçu lié au plan :docs/reference_archive_index_sources/archive-index-links.json. Livraison :docs/fidelity_registry_archive_index_revision_4_20.json. Producteurs,journaux,compilations échouées,projection et qualification :E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision47. Les cinq ZIP sont absents des deux manifestes exacts sélectionnés :aucune appartenance à la release4.20 livrée n’est affirmée,leur provenance de version reste ouverte. Les données et tous les acquis V46/SYS01102 sont préservés. Les six objectifs du Goal restent distincts et leur complétude demeure non démontrée.
