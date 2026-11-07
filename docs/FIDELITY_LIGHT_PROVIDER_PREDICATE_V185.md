# SYS-01.2-02 — fournisseur et prédicat Light_Env (V185)

La fabrique90ADE0 appelle90A1B0, qui installe la vtable10D6380. Son slot+28 vaut90A4A0. Cette méthode appelle905D80 avec la table objet+8, le nom demandé et le parent objet+10. La recherche utilise90D1D0 et délègue au slot+28 du parent en cas d’absence locale. Quatre régions complètes décodées, cinq ancres et la vtable vérifiées.

Deux exécutions du wrapper original contrôlent les arguments, les retours0/1 et la pile. Le résultat de905D80 est explicitement adapté ; aucun test complet du prédicat n’est revendiqué. Le reçu existant map_resource_lookup_contract.json conserve30cas natifs antérieurs, non réexécutés ici.

Consommateur actuel trouvé : crates/client/src/map_resource_provider.rs, méthodes contains/resolve, source épinglée avec lignes dans la preuve. Ne pas réimplémenter ce consommateur ni déduire une intégration éclairage depuis sa seule présence.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision185/LIGHT_PROVIDER_PREDICATE.json. Script : revision185_light_predicate.py dans le répertoire parent. À intégrer aux liens des tâches EMPTY063 ; fournisseur historique effectif, tables et rendu restent ouverts. Aucune case ni inconnue clôturée.
