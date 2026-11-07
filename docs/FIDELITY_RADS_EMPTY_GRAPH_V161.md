# SYS-01.2-02 — rôles RADS distincts

Trois marqueurs S_OK et user.cfg sont reliés à leurs rôles natifs, soit huit tâches et SYS-01.2-02. S_OK intervient dans un filtre de noms via _stricmp : trois instructions exactes et les empreintes ont été contrôlées. Ce filtre ne prouve ni contenu, ni cycle de création, ni intégrité de release.

Le lecteur user.cfg SettingsFile::Load est identifié par trois régions et neuf ancres. Cinq cas du fragment EOF original ont été exécutés en mémoire isolée : états3/1/7/5 et continuation0. Les registres d’entrée sont explicites ; le backend de fichier, le setter complet et le chemin de repli ne sont pas exécutés. Les binaires exacts et leurs SHA sont consignés dans le reçu détaillé.

Les neuf fiches/copies/traces sont conformes dans les deux bases, avec intégrité SQLite,42606états manuels et historique préservés. Les quatre fichiers natifs restent vides. Aucun consommateur Rust inventé ni tâche clôturée.

La vérification supplémentaire des sélecteurs a détecté /facts, absent du reçu agrégé. Les neuf liens ont été corrigés vers /associations ou leur entrée précise. L’ancien sélecteur est refusé et l’état antérieur conservé ; lecture et copie des deux bases revérifiées après correction. Le contrôle structurel général seul n’avait pas détecté ce défaut.

Limites : origine des fichiers archivés, ouverture réelle, chemin de repli, cycle des marqueurs et équivalence Rust restent ouverts. Aucun jeu ou patcher complet lancé ; aucun rehash global des97017sources.

Preuve : docs/fidelity_rads_empty_graph_v161.json.
Détails : docs/reference_rads_empty_sources/rads-empty-v161.json.
Scripts, preuves et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision161.
