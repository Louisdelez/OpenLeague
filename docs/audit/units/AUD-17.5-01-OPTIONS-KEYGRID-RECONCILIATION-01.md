# Raccourcis — réconciliation du keygrid physique

## 1. Portée et décision

AUD-17.5-01-OPTIONS-KEYGRID-RECONCILIATION-01, goal SYS-01.2-02, parent SYS-17.5-01. Jointure des192déclarations exactes de FoundryOptionsKeybinds.xml, sans nouveau test de jeu. Le lot release précédent constitue un progrès vérifié. Audit : réconciliation clôturable après relecture. Implémentation : non modifiée ni qualifiée par les comptes. Vérification : identités et livraisons. Acceptation humaine : non demandée. Ni le parent ni le goal ne sont terminés.

## 2. Sources et règles

Source XML13896octets, SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e, index physique357nœuds dont192dans ce fichier. Le snapshot coverage-delta-proof-v2 et sa relecture versionnée sont conservés, inchangés. Les six anciennes associations propres sont gardées. Les livraisons postérieures sont lues et épinglées, sans relancer leurs lecteurs/tests.

Seuls target_declaration/target_declarations explicitement possédés par une livraison relue peuvent ajouter une association. Identité=version SHA de source+ID+offsets+octets du tag. Index complet recopié, prochaine cible, mention d’un parent ou preuve partagée ne constituent pas un audit propre. Les producteurs/readers historiques disposant de reçus sont liés à leurs codes0 et sorties correspondantes ; aucun reçu absent n’est inventé pour un ancien audit déjà accepté.

## 3. Consumers et portée des preuves

La bibliothèque normalisée référence chaque preuve, relecture, programme, rapport et critères/gaps/corrections d’origine. La matrice par identité renvoie au champ propriétaire exact, pas au seul nom d’événement : les occurrences game/replay restent différentes. Les consumers et leurs limites se trouvent dans les audits sources relus ; cette jointure ne les réexécute pas et ne requalifie aucune mécanique.

Les conteneurs ne disparaissent pas du plan : keygrid, quickbindlayout et11sections repliables ont des comportements d’édition, boutons globaux normal/rapide, focus ou repli non clos par les enfants. Les groupes/libellés/wrappers sont comptés comme inventaire structurel, pas comme fonctionnalités absentes. L’include est une frontière de source distincte.

## 4. Résultat attendu et observé

| Classe documentaire | Nombre |
|---|---:|
| Contrôles feuilles avec association à une portée d’audit relue |154|
| Contrôles feuilles restant sans audit propre |3|
| Conteneurs avec comportement restant à qualifier |13|
| Structure, groupes et libellés recensés |21|
| Include dont l’expansion reste ouverte |1|
| Total des identités physiques |192|

Définition des feuilles : keybind, keybindsingle, quickbindcomponent, checkbox. Dénominateur157feuilles ;154associations propres et3sans preuve propre. Le snapshot précédent en associait6 ;148associations uniques supplémentaires sont reliées, sans doublon. Ces chiffres décrivent la couverture documentaire de ce fichier, jamais un pourcentage de jeu terminé. Aucun contrôle runtime n’est validé par ce compte.

Contrôles réellement exécutés : source/index/snapshot et reçus, chaque octet de tag, champs propriétaires et domaines, jointure exhaustive/déduplication, partition des192nœuds, corpus1168fichiers et fichiers gelés. Codes et empreintes de ce producteur et de sa relecture conservés. Non exécutés : anciennes recherches/lecteurs/tests, jeu/Rust/native/AS/GUI/réseau ou émulation, app/base/loader de production. Toutes les clauses non auditées restent nommées.

## 5. Ce qui reste ouvert

Trois feuilles n’ont pas de portée propre acceptée dans les livraisons inspectées :

- **OPT-SRC-6ce93b95a2c80a4a**, XML36 : checkbox General/BindSysKeys, ancêtre macosx. Il faut qualifier platforme/provider/consumer et limites, sans l’exclure silencieusement parce que le poste courant est Windows.
- **OPT-SRC-4083e4714c1c0787**, XML79 : evtChampionOnly. Il faut inspecter bindings et filtres de cible actuels avant de déduire une absence d’implémentation.
- **OPT-SRC-56ce51176f328b6e**, XML81 : evtUseChampSwap avec gate mutator:TagTeam. Le gate n’établit ni disponibilité du mode ni ressources de champions manquantes.

Les13conteneurs et leurs clauses restent en pending_containers. Le sibling exact FoundryOptionsInternalKeybinds.xml reste absent au chemin contrôlé ; l’expansion provider n’a pas été observée. Cette absence locale ne prouve pas une absence universelle de packages ou une indisponibilité historique. Reprise de cette frontière seulement avec nouvelle source/version ou trace de provider, sans répéter les anciennes recherches globales.

Les154associations conservent les questions de callbacks/provider, remap/persistance, UI/entrée/effet/autorité et vérification réelle de leurs audits. Elles ne prouvent pas154fonctionnalités implémentées. Le périmètre primaire Menu/Phreakspace et les autres exigences du goal ne sont pas clos par ce fichier.

## 6. Actions restantes et non-duplication

Trois petits lots d’audit sont nommés dans pending_leaf_audits, un par feuille. Ils demandent les sept rubriques et la réutilisation des preuves/corrections avant toute proposition nouvelle. Prochain lot : **AUD-17.5-01-OPTIONS-KEYBIND-CHAMPION-ONLY-01** sur XML79. BindSysKeys puis ChampSwap demeurent recensés ; leur ordre peut suivre les entrées disponibles.

Les conteneurs doivent recevoir des audits bornés de leurs actions propres en réutilisant factory/capture/cast-mode. Aucune nouvelle correction fonctionnelle dans cette réconciliation : une absence d’audit n’est pas la preuve d’un défaut produit. Les définitions existantes restent liées, sans modifier critères/états des tâches ni créer de doublons. Toute implémentation dépend d’une autorisation produit distincte et de ses prérequis réels.

## 7. Livraison et limites de clôture

Preuve et rapport isolés sur F, bibliothèque normalisée et matrice192identités vérifiables, relecture séparée des sept rubriques et reçu réel. Ancien snapshot, preuves,25fichiers protégés,5registres et Git conservés. Aucun goal/critère normatif/Plan/UI/base changé ; aucune installation/migration/redémarrage.

La seule clôture possible est celle de la réconciliation de ce fichier. Elle rend les portées restantes concrètes ; elle ne clôture ni les trois feuilles, ni les conteneurs/include, ni le parent, ni le jeu.
