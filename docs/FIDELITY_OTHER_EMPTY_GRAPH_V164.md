# SYS-01.2-02 — lecteurs des fichiers vides restants

Six tâches, pour Localization_Errors.txt, ChogathSkin02EventLookupTable.csv et map11/Light.dat, sont reliées aux lecteurs/clé natifs identifiés. Les trois fichiers restent vides et intacts.

Le journal de localisation passe le mode2 dans la chaîne constructeur ; la table sélectionne w. Six régions et cinq ancres sont vérifiées sur le binaire exact. Light.dat et SoundBanks/EventLookupTable sont contrôlés par deux régions et neuf ancres. Le lecteur Light.dat utilise rt et un format de sept entiers ; la clé sonore mène au lecteur de configuration. Aucun processus natif exécuté.

La sélection effective de map11/Light.dat et de la table spécifique au skin Chogath reste non qualifiée. Une clé générique ne prouve pas le chargement du fichier précis ; une sortie de journal ne prouve pas pourquoi son archive est vide. Aucun consommateur Rust ni caractère intentionnel des fichiers déduit.

Sept fiches/copies/traces par base sont conformes ;42606états manuels et historique préservés, intégrité SQLite ok. Sept pointeurs exacts vérifiés ; champ absent et association à une autre tâche refusés. Les données hors périmètre et inconnues restent conservées.

Preuve : docs/fidelity_other_empty_graph_v164.json. Détails : docs/reference_other_empty_sources/other-empty-v164.json. Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision164.
