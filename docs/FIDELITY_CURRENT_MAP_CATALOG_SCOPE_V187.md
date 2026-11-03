# SYS-01.2-02 — portée du catalogue actuel (V187)

Le client initialise Map10Catalog dans main.rs. Son constructeur lit le cas map10-original-files du contrat embarqué et le parent récupéré now. Les25fichiers natifs cités sont relus et leurs SHA256 concordent ; le contrat contient42entrées. Light.dat et Light_Env.dat pointent vers Levels/Map10. Les noms de ces deux fichiers sont absents des lignes du manifeste global récupéré.

Le contrôle nominal des deux chemins Map10 passe. Trois refus du contrôleur de portée passent : mauvaise carte Map11, entrée Light_Env manquante, chemin Light.dat remplacé par celui de Map11. Ce sont des contrôles documentaires de liaison ; aucune exécution Rust ou du renderer n’a été faite ici.

Les deux sources lumineuses de Map10 et celles de Map11 sont épinglées séparément dans la preuve. Les tâches EMPTY063 concernent Map11. Le consommateur contains lié en V186 reste un consommateur générique de noms de ressources ; le catalogue Map10 ne qualifie pas un chargement de Map11.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision187/CURRENT_MAP_CATALOG_SCOPE.json. Script : revision187_map_catalog_scope.py dans le répertoire parent. Statuts, cases et inconnues inchangés. Suite : rattacher cette limite de portée aux fiches, puis poursuivre les associations restantes.
