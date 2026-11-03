# SYS-01.2-02 — construction des tables sonores

La recherche dépasse le seul sélecteur SoundBanks/EventLookupTable : trois fonctions natives alignées et14ancres identifient la construction du nom, la résolution du chemin et le lecteur CSV.

6F67E0 choisit le nom ou une chaîne de remplacement, construit un nom Base puis, pour une valeur de skin non nulle, appelle709400. Le format est %1_Skin%2$.2d%3 et le troisième argument pointe sur _EventLookupTable.csv. Le résultat passe au fournisseur virtuel+1C puis à704150 si le chemin retourné est non vide. Cela concorde conditionnellement avec Chogath_Skin02_EventLookupTable.csv ; les valeurs effectives de l’instance et le fournisseur restent à prouver.

704150 ouvre en mode r. Un flux nul suit la sortie d’échec ; un état initial de fin ou une lecture nulle conduit au destructeur puis à AL=1, sans insertion de ligne sur ces chemins. Six fragments originaux ont été exécutés en mémoire isolée avec entrées de registres explicites. Aucun appel, accès fichier, mutation de table ou exécution complète du lecteur n’a été effectué.

Les fenêtres initiales de recherche contiennent des départs non alignés et restent des candidats, sans valeur de preuve de flot. Les trois régions qualifiées partent ensuite de prologues identifiés et sont décodées intégralement.

Les deux tâches EMPTY047 et l’objectif sont enrichis. Trois fiches/copies/traces par base, trois pointeurs exacts et deux refus sont vérifiés ;42606états manuels et historique conservés. La provenance et le caractère intentionnel de la table vide, la sélection réelle Chogath/Skin02 et le consommateur Rust restent ouverts.

Preuve : docs/fidelity_event_lookup_graph_v165.json. Détails : docs/reference_event_lookup_sources/event-lookup-v165.json. Scripts et octets/branches : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision165.
