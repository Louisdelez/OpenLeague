# SYS-01.2-02 — fournisseur de lumière et consommateur actuel (V186)

Les deux tâches EMPTY063 et SYS-01.2-02 référencent désormais la chaîne native575460→90AEF0→573DD0→867DF0 et la fabrique90ADE0→90A1B0→vtable10D6380/+28=90A4A0→905D80. Les preuves V184/V185 distinguent7régions statiques,4cas de cache et2cas du wrapper avec résultat délégué adapté. Les30cas de recherche du reçu antérieur ne sont pas réexécutés ici.

Le consommateur existant crates/client/src/map_resource_provider.rs, méthode contains, est enregistré avec son identité de source et son ancre exacte. Il traite la présence des noms dans les tables et la délégation au parent. Ce lien ne prétend pas qu’un parseur Light_Env ou le rendu d’éclairage est implémenté.

Contrôles réels :3fiches/copies/traces dans chacune des2bases ;3pointeurs JSON et2refus ; empreintes natives et preuves relues ; ancre du consommateur et associations vérifiées. Les42606états manuels et l’historique sont conservés. Les autres champs des tâches, les sources/consommateurs précédents, les anciennes associations et les inconnues restent inchangés. La validation structurelle globale ne constitue pas une revérification de toutes les empreintes du catalogue.

Preuve : docs/fidelity_light_provider_graph_v186.json. Associations : docs/reference_event_lookup_sources/light-provider-v186.json. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision186/before-light-provider-graph.

Restent ouverts : population effective des tables, contexte historique, intégration du lecteur/rendu et autres exigences du périmètre. Aucun champion, jeu ou tâche générale déclaré terminé.
