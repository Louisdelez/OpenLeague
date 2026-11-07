# Cadrage du goal SYS-01.2-02

## Autorité et restriction actuelle

Objectif : « Auditer chaque exigence et établir ses sources,son implémentation actuelle,ses écarts,ses preuves et les actions restantes. »

La demande utilisateur du30octobre2026 précise cet objectif dans la pièce jointe386bc402. Sa consigne ultérieure restreint l’amélioration au goal,aux critères de clôture et à la méthode de travail. Toute modification d’OpenLeague Plan,de son interface et de ses bases est arrêtée. Aucune installation,aucune migration et aucun retrait de ces changements ne sont autorisés implicitement par ce cadrage. Leur inventaire est F:/OpenLeague-work/audit-method-20261030/WITHDRAWAL_INVENTORY.md.

Le périmètre du jeu demeure dans le plan d’implémentation. Le goal d’audit n’exige pas de reconstruire toutes les fonctionnalités avant de terminer l’audit. Son achèvement ne signifie pas que le jeu est terminé.

L’outil disponible permet de lire le goal et de changer son statut,mais pas de modifier le texte d’un objectif actif. Ce document fait donc autorité pour sa reprise et complète le pointeur historique du service. Le goal n’est ni déclaré terminé ni mis en pause par ce document.

## Conditions de clôture d’une unité d’audit

Une unité possède un identifiant et un périmètre explicites. Sept rubriques doivent être documentées et leurs preuves examinées :

1. Exigence précise et frontières du périmètre.
2. Sources historiques pertinentes,provenance,identité et limites ; ou recherches effectuées,source non retrouvée et entrée de reprise.
3. Consommateurs réels dans le code ; ou absence constatée après une recherche délimitée et reproductible.
4. Comportement observé,contrôles pertinents réellement exécutés et résultats attendus/observés. Nommer ceux non exécutés.
5. Écarts,limites et conclusions restant indéterminées.
6. Corrections nécessaires,réutilisées ou proposées avec ID stable,objectif unique et critères de fin. Justifier explicitement une absence de correction.
7. Livrable,preuves identifiées et datées,version/périmètre des sources et relecture de cohérence.

Une fonctionnalité absente peut avoir un audit terminé. Une source introuvable reste introuvable : documenter les recherches et la conclusion indéterminée. Un blocage d’audit n’est retenu que si une entrée précisément identifiée empêche de satisfaire les rubriques nécessaires ; décrire son impact et la condition de reprise. Ne pas convertir automatiquement un blocage en audit terminé.

Un fragment réussi clôture seulement son périmètre explicite. Une exigence parente demeure ouverte tant que ses autres clauses n’ont pas été auditées. L’achèvement global nécessite la couverture de toutes les unités requises et une vérification de ces rubriques ; il ne se déduit pas du nombre de liens,du volume de preuves ou des tests réussis.

## Quatre dimensions de compte rendu

Ces dimensions sont des règles documentaires ; elles ne sont pas déployées dans l’application par la présente restriction.

- Audit : à examiner,en cours,terminé avec preuves,bloqué par une entrée identifiée.
- Implémentation : non évaluée,absente,partielle,implémentée.
- Vérification : non exécutée,partielle,échec,réussie pour un périmètre explicite.
- Acceptation humaine : non demandée,à valider,acceptée,refusée,non applicable avec justification.

Les anciens statuts,cases et notes sont hérités. Ils ne deviennent pas automatiquement des audits terminés. Une réussite technique demeure limitée aux critères couverts ; l’acceptation humaine exige une décision explicite lorsqu’elle s’applique.

## Mesure et bilan

Conserver le taux historique de couverture des liens avec sa date et sa définition. Documenter séparément audits clos,corrections implémentées et vérifiées,parcours complets vérifiés,blocages par nature. Pour chaque mesure : numérateur,dénominateur,exclusions,règle d’agrégation et limites. Compter une fois les unités atomiques ; exclure leurs parents et les regroupements administratifs. Documenter toute variation du dénominateur.

Aucune pondération,estimation de temps ou conversion de liens en pourcentage de jeu terminé. Les comparaisons hebdomadaires reposent sur des instantanés datés et des identifiants : audits clôturés,écarts corrigés,parcours vérifiés,blocages levés,nouvelles lacunes et réouvertures. En l’absence d’un instantané comparable,indiquer « comparaison indisponible ».

## Méthode et prochain lot

La méthode détaillée,le gabarit de compte rendu,les règles de recherche/REA et le prochain lot documentaire sont dans AUDIT_METHOD.md. Un seul lot actif par défaut. Les corrections fonctionnelles sont décrites pour une exécution distincte ; elles ne sont pas réalisées implicitement au titre du goal d’audit.

La restriction actuelle prévaut sur les préparations antérieures relatives au logiciel du plan. Les sources applicatives préparées et les ajouts partiels de base sont gelés ; aucun retrait n’est exécuté sans nouvelle instruction. Les travaux V795 et antérieurs sont conservés.
