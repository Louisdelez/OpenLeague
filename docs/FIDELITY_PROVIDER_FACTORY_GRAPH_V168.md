# SYS-01.2-02 — chaîne du fournisseur natif

Deux fonctions complètes et huit ancres vérifient 90B520 -> 9034D0 -> vtable10D64A8, dont le slot+1C est903EE0. Cela relie statiquement le fournisseur testé en V166 à l’affectation du champ champion+20 identifiée en V167. Les quatre cas de résolution V166 et quatre gardes V167 sont hérités et conservés, sans nouvelle exécution complète du constructeur.

Trois fiches/copies/traces par base et trois pointeurs exacts sont vérifiés, avec deux refus de pointeurs invalides. Les42606 états manuels, historiques, sources, anciennes associations et inconnues sont conservés. Les seules données de tâche enrichies sont les preuves et le contexte nouveau.

La création configure aussi un repli via le slot+2C. Les paramètres de l’instance, le démarrage du gestionnaire, ses caches et le repli effectif restent ouverts, ainsi que le chargement CSV, le consommateur Rust et le caractère intentionnel du fichier vide. Aucune tâche complète ni gameplay accepté.

Preuve : docs/fidelity_provider_factory_graph_v168.json. Reçu : docs/reference_event_lookup_sources/provider-factory-v168.json. Recherche et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision168.

Suite : qualifier903590 et le registre global2D78F20, puis confronter le contexte réel aux appels des scanners.
