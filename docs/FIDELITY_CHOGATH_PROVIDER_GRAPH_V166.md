# SYS-01.2-02 — fournisseur de la table Chogath

Les scanners originaux 902AD0/905620/905A00 enregistrent Chogath_Skin02_EventLookupTable.csv dans le contexte DATA explicitement fourni. Le slot +1C de la vtable 10D64A8 pointe sur 903EE0 ; ce résolveur original retourne le chemin attendu pour le nom exact et sa variante en minuscules. Un nom absent retourne une chaîne vide ; une entrée contenant NUL est refusée par l’adaptateur. Quatre cas ont réussi dans la recherche conservée ; leurs empreintes ont été revérifiées lors de cette intégration.

L’itérateur utilise os.scandir en lecture seule. Les adaptateurs de chaînes, allocation et formatage sont explicités dans le reçu. Le fichier natif reste vide (0 octet). Aucun processus historique n’a été lancé. Le champ +20 d’une instance de champion n’est pas prouvé lié à ce fournisseur au démarrage historique ; ouverture CSV, consommateur Rust et caractère intentionnel du fichier vide restent ouverts.

Deux tâches EMPTY-047 et SYS-01.2-02 sont reliées dans le registre et les deux bases du plan. Trois fiches/copies/traces sont vérifiées par base, trois pointeurs JSON et deux refus sont contrôlés. Les 42606 états manuels et l’historique sont conservés. Les anciennes sources, associations et inconnues sont préservées. Aucun objectif global n’est clôturé.

Preuve : docs/fidelity_chogath_provider_graph_v166.json. Source : docs/reference_event_lookup_sources/chogath-provider-v166.json. Recherche et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision166.

Suite : qualifier le lien de l’instance champion vers le fournisseur concret et poursuivre les consommateurs encore partiels. L’observation Git avec accès autorisé fonctionne ; le refus sandbox précédent n’établissait pas une corruption Git.
