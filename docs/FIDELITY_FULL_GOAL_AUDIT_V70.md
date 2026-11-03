# Audit des six objectifs du Goal — V70

Les six objectifs SYS-01.2-01 à06 restent intacts. V70 relie sept exigences SYS-04.1 de statistiques à 18 ancrages de rôles et cinq ressources natives d'auteur. Aucun des sept périmètres complets n'est terminé ou accepté. Le travail porte sur le référentiel D01, sans prétendre réaliser toute la phase D04.

| Objectif original | Évidence actuelle | Travail ouvert |
|---|---|---|
| 01 — Identifiants stables | 42757 identités et liens structurels vérifiés | Acceptation humaine non déduite |
| 02 — Sources et consommateurs | 92639 sources et 403 ancres ; sept liens précisés | 860 liens génériques, 1479 frontières seules ; statistiques, diagnostics, données/schémas, horloges, construction, Map10 et combat partiels |
| 03 — Origine, version, SHA | Aucune métadonnée manquante ; 57 entrées/delta et 403 ancres contrôlées | V69 héritée ; pas de nouveau scan global ou d'exécution native/serveur |
| 04 — Natif/Data Dragon | Comparaisons et recherches conservées | Deux caps4312/4313 : autorité historique effective et rôle de Ranks4 face à ranks3 |
| 05 — Scripts communautaires | Études et17profils GarenQ conservés avec leurs rôles | Dispatch original, arguments, retours, effets réels et autres évaluations nominatives |
| 06 — Inconnues | 30835 questions structurées ; sept recherches affinées | 25321 ouvertes,5514résolues ; aucune clôture nouvelle |

## Résultats et limites de V70

Cinq ressources sont relues et qualifiées par les manifestes exacts : Garen.inibin, GarenW.inibin, TrundlePain.inibin, Map10/ExpCurve.inibin et Map10/Constants.var. Leurs champs sont des valeurs d'auteur ; ils ne prouvent pas la formule du serveur, son ordre de modificateurs ou ses arrondis.

Huit valeurs de croissance Garen concordent avec la table courante à1e-5près. Deux noms initiaux de propriétés de régénération et six alias sont absents des recherches bornées : ce n'est pas un écart numérique ni une absence globale de la donnée. Aucun zéro de remplacement n'est inventé. Les17seuils XP des niveaux2à18concordent numériquement ;Level1n'est pas fabriqué. Le minimum natif signé de modificateur cooldown est−0.4, distinct de la réduction maximale locale+0.4 ;le minimum de secondes0concorde. GarenWEffect1vaut20aux cinq rangs et TrundleREffect2vaut40aux trois rangs. Les scalaires ne qualifient pas leurs politiques complètes.

Les fonctions growth_total et ad_components exactes et leur type de résultat sont extraits sans modification puis compilés dans un programme isolé. 27cas passent :21niveaux (1à18et0/19/255) comparés à une somme rationnelle indépendante des taux par niveau avec tolérance1e-5,plus six cas AD exacts sur l'ordre local,les branches négatives et NaN. Cinq valeurs de croissance diffèrent d'un ULP de la valeur rationnelle idéalement arrondie. La parité d'arrondi historique reste non qualifiée ;le clamp de niveaux n'est pas un refus des niveaux hors plage.

Le helper AD ajoute base/croissance/objet avant l'autel,puis applique un ajustement signé éventuel. Avec ajustement0,le total existant négatif ou NaN est préservé ;avec l'ajustement non nul testé,un plancher0s'applique. Aucun refus explicite des entrées invalides n'est déduit. La décomposition conserve base réelle,total et bonus signé. Le chemin GarenW amplifie l'armure d'objet séparément des défenses de niveau. L'agrégation d'objets possède ses règles locales de déduplication. Le système complet d'ordre/base/bonus/plafonds reste ouvert.

Achat et vente appellent le recalcul des plafonds,avec préservation absolue puis clamp des pools courants ;le code laisse la politique native de cette opération non qualifiée. Le gain de niveau est identifié,sans déduire les transformations. TrundleR capture et stocke des valeurs de statistiques ;Q relit l'AD actuel à l'impact. Ces exemples ne terminent pas toutes les politiques d'effets actifs ou leur calendrier original.

Le premier collecteur utilisait seulement la forme minuscule du nom Garen dans la table de sorts et a échoué avant publication. Sa version est conservée ;la réparation normalise uniquement la recherche de casse et garde la comparaison des vraies valeurs. Les helpers terminés ne sont ni reconstruits ni rejoués. Aucune Simulation,application,serveur,Blender,ancienne sonde ou exécution native effectuée.

## Vérification et conservation

34contrôles de source,30contrôles de contrat dont29refus et27contrôles de livraison passent. Les42214consignes actives et14couples HTTP lecture/copie concordent. Dix seules métadonnées/consignes changent :trois du référentiel et les sept exigences de statistiques. Les92609anciens enregistrements et384anciens consommateurs restent identiques ;57entrées/delta et403ancres sont contrôlées,avec portée V69héritée.

Les42606états manuels,notes,révisions et22historiques sont conservés. Tauri pointe sur la même base ;sa fenêtre native n'est pas observée. Aucun Rust/C de production,asset,lock ou binaire du jeu modifié. Un lecteur Python de preuves est ajouté. Les sept questions restent ouvertes,avec conservation des anciennes recherches,textes et conditions. Les champs natifs ne sont pas promus en règles serveur qualifiées.

## Périmètre restant

Les liens génériques passent de867à860 ;les1479frontières sont conservées,sans nouvelle frontière. Le compte combiné passe de2346à2339,ce qui ne signifie pas sept fonctionnalités terminées. Les805lignes brutes sans lien natif incluent des contrats locaux légitimes ;la baisse de5vient de liens précis sur des ressources d'auteur et n'est pas une preuve de comportements complets.

Restent ouverts7périmètres statistiques,8diagnostics,8données/schémas,8horloges/coordonnées,7construction,6Map10 et15combat,les deux caps,les autres évaluations communautaires et GarenQ. Le candidat d'archives07reste générique,la restauration08frontière seule ;les deux reçus spécialisés datés restent distincts des binaires actuels. La correction Cargo est préservée :metadata --locked --offline --no-deps ne prouve pas consommation/validation des locks ni construction reproductible. Les42autres fichiers vides,12décisions d'adoption et la chaîne parent du marqueur restent dans la reprise.

États des six objectifs :01/03/06àvalider,02/04/05partiels ;aucune acceptation humaine inférée. Goal actif. Rapport :docs/FIDELITY_STAT_LINKS_4_20.md. Livraison :docs/fidelity_registry_stat_links_revision_4_20.json. Audit JSON :docs/fidelity_goal_completion_audit_20261022_V70.json. V69,SYS-01.1-02 et toutes les preuves antérieures sont conservés.
