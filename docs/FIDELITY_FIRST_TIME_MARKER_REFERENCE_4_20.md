# first_time : sources natives et limites intégrées — V59

Les exigences EMPTY-032-CLASSIFY et EMPTY-032-RESOLVE disposent de nouvelles relations vers le patcher original0.4.0.122/RADS0.0.0.11 et les membres exacts de bundle-chrome. Les consommateurs actuels dédiés restent non identifiés ; aucune ancre de fonctionnalité n'est ajoutée et les deux associations génériques restent comptées comme lacunes.

Le prédicat relatif first_time teste GetFileAttributesA après construction depuis le CWD. Le mode2 du helper mène à la chaîne w. Neuf nouveaux cas exécutent6F8807→6F8765→6F8810 dans Unicorn avec open/close/seek explicitement simulés :succès/échec,lecture,binaire,modes invalides,noreplace et échec de seek. Aucun fichier réel créé ou tronqué ; ce résultat ne prouve pas une création Windows réussie. Douze candidats d'appel des wrappers CWD sont localisés ; ni leurs fenêtres statiques ni les journaux natifs n'établissent le CWD au caller5C37A6.

Les dix contrôles statiques V58 et les sept cas/1refus du callback original sont hérités, pas rejoués. Quatre membres du bundle d'origine sont conformes ; le listener ClientInit lit popup et active la modale de premier lancement. Le flux source du registre vers popup est statique,le pont natif complet et le rendu restent ouverts. Le premier échec RTTI après la boucle d'attributs est conservé ; aucune ligne de résultat manquante n'est reconstruite.

27 contrôles de source/portée précèdent la publication. Les deux questions gardent leur texte,leurs recherches et conditions antérieurs,avec un complément précis :CWD effectif,lien absolu vers RADS/first_time,IO/erreurs/exception,pont popup et consommateur actuel. La classification intentionnelle/obligatoire et la décision de réparation restent non acceptées. Aucune ressource remplie ou supprimée.

Reçu : docs/reference_first_time_marker_sources/first-time-marker-reference.json. Livraison : docs/fidelity_registry_first_time_marker_revision_4_20.json. Les six objectifs initiaux,les preuves V57/V58 et SYS-01.1-02 ainsi que les états manuels sont conservés. Les lacunes spécifiques visibles restent2387 :918génériques et1469frontières seules. Goal actif.
