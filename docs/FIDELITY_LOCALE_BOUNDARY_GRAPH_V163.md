# SYS-01.2-02 — localisation, points d’entrée actuels

76tâches pour19langues sont reliées à14ancres précises dans le code courant. Les19fontconfigs installés sont identiques aux originaux nommés ;12sources de voix en_US sont rehashées. Cette provenance ne prouve pas leur sélection ni leur présentation pour chaque langue.

CLIENT : frontend Tauri et textes français intégrés. HUD : le chargeur de polices observe mais ne retourne pas les traductions ; boutique unique et titres français. AUDIO : chemins fixes de sons d’autels et schéma ambiant sans sélecteur de langue ; ces effets ne prouvent pas un lecteur vocal localisé. LAYOUT : CSS de retour à la ligne et calcul des bounds ; aucun contrôle visuel de débordement dans les19langues.

Les14consommateurs sont enregistrés comme points d’entrée partiels (entry_boundary_only), sans fournir la fonctionnalité complète. Les inconnues sont conservées. Les77fiches/copies/traces sont conformes par base ;42606états manuels et historique préservés, intégrité SQLite ok.

Contrôles supplémentaires :77pointeurs JSON exacts,14ancres et toutes les nouvelles sources vérifiées. Quatre refus passent : fausse complétion, suppression des inconnues, preuve de portée absente et revendication d’une fonctionnalité complète. Aucun jeu, rendu ou audio exécuté ; pas de rehash global des97018sources.

Preuve : docs/fidelity_locale_boundary_graph_v163.json. Détails : docs/reference_locale_boundary_sources/locale-boundaries-v163.json. Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision163.
