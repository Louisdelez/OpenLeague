# SYS-18.1-06 — dépendances liste, texte et layout Chrome (007)

Date : 2026-11-02 (Europe/Zurich)  
Lot documentaire : `AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01-007-CHROME-LIST-TEXT-LAYOUT-AND-FAMILY-REVIEW-01`  
Décision : **lot source borné terminé après relecture indépendante**. La famille Chrome et la tâche parente restent ouvertes.

## Périmètre et sources

Ce lot traite uniquement les cinq dépendances Blix nommées par le lot 006 : `DataScroller`, `DataGroup`, `Text`, `VirtualizedVerticalLayout` et `VerticalLayout`, avec les utilitaires directement utilisés pour mesurer/ajuster les tailles. La source est le dépôt AIR 4.20 admis sous `docs/reference_air_sources/review/lib__blix__BlixComponent_dat`; le transport natif lié est `original/lib/blix/BlixComponent.dat` (manifest local : release `0.0.1.119`, 64 366 octets, SHA-256 `b446f54eb70bbfbff868ab8a9e06ce39d8c89fd7a2f91fde324476309ff85477`). Le catalogue des routes, l’index des sources et leurs empreintes sont épinglés dans la preuve 007.

Les preuves acceptées 003–006 sont réutilisées. Aucune recherche de style antérieure, préfixe natif, décompilation, extraction d’archive ou requête large n’a été rejouée. L’état Git préexistant est conservé.

## Résultats établis dans les méthodes source

- `DataScroller` : `createChildren` (lignes 84–135) construit les groupes/contrôles de défilement; `updateLayout` (365–470) calcule aire visible, barres et positions depuis la taille disponible, le padding et la politique des barres. La taille réelle des textes/lignes n’est pas calculée par cette méthode.
- `DataGroup` : constructeur (44–64) choisit `VirtualizedVerticalLayout` par défaut; `updateLayout` (246–303) retourne sans mesure lorsqu’il manque algorithme ou factory; `renderItems` (305–376) refuse un renderer qui n’est pas `IItemRenderer`. La limite `maxSkipped` et les cas relevés restent liés à la source, sans simuler de liste vivante.
- `Text` : `updateLayout` (304–346) ne tronque que si `_truncateToFit` est actif et le champ n’est pas en autosize; `truncateText` (367–384) réduit le texte selon les métriques AIR. Le texte visible, les dimensions de police et l’infobulle effective ne sont pas mesurés ici.
- `VirtualizedVerticalLayout` : `updateLayoutEntry` (72–136) obtient les tailles et positions via l’élément de layout; `getOffset` (138–145) divise l’écart par `hauteur + gap` sans garde explicite zéro dans cette méthode; bounds et fenêtre de rendu figurent aux lignes 147–163. C’est un risque source conditionnel, pas un échec reproduit.
- `VerticalLayout` : contraintes (103–124) et mise en page (126–256) combinent tailles/minima, padding, gaps, alignement et `FitSizesUtil`. `ElementSizeUtil` lit les contraintes de layout et passe par `setAvailableSize`; `VirtualizedLayoutBase` borne le rendu par viewport/buffer (0,15).
- Les sources enfants déjà auditées relient `ChromeTicker` aux groupes mesurés et au sizer; `ChromeContextAlertView` utilise un layout vertical et des textes dynamiques. La file d’alertes est pilotée par son contrôleur; les alertes épaisses dépendent de la visibilité du navigateur. Le chargement source vise `assets/data/alerts/storeAlerts.xml`, non présent dans l’arbre admis recherché pour ce lot. Cela ne prouve pas une absence globale du fichier.
- Les liens de symboles/timelines des deux thèmes sont repris des preuves 004–006. Ils n’établissent ni le thème effectivement chargé, ni l’état de domaine AIR, ni le rendu.

## Cas et résultats attendus/observés

| Cas source statique | Attendu | Observé |
|---|---|---|
| Configuration nominale de liste | groupe avec layout et renderer mesurables | le constructeur fournit le layout par défaut; les bornes sont demandées à la factory/layout |
| Mesure verticale nominale | tailles, gaps et padding contribuent aux positions | les méthodes et fenêtres ci-dessus contiennent ces opérations |
| Texte trop long | troncature seulement sous configuration applicable | branche de troncature conditionnelle présente; métriques natives non exécutées |
| Factory ou algorithme absent | ne pas inventer de bounds | retour anticipé source présent |
| Mauvais type de renderer | refus explicite | exception source `Renderer must be of type IItemRenderer` présente |
| Hauteur d’item + gap nulle | vérifier un garde avant division | aucun garde explicite dans la méthode auditée; cas AIR non exécuté |
| Fichier de script d’alertes | identifier l’entrée et sa disponibilité | chemin source identifié, fichier absent de l’arbre admis ciblé; entrée à fournir pour reprendre |
| Consommateur actuel | conserver le résultat borné du contrôle 003 | les dix fichiers déjà recensés ont la même empreinte; l’en-tête/menu statique et le hook `CloseRequested` restent les seuls constats littéraux pertinents de ce contrôle |

Les cas sont des vérifications de clauses de source. Aucun AS/AIR/AVM, launcher, jeu, rendu, mesure de pixels ou scénario utilisateur n’a été exécuté.

## Revue des critères de clôture du lot

1. **Source et algorithme** — les cinq dépendances exactes et les méthodes de mesure/layout utilisées sont identifiées, avec transport natif, tailles, empreintes et fenêtres de lignes.
2. **Ressources, états et consommateur** — les relations déjà établies en 003–006 sont reprises; les contrôles courants sont rehashés sans relancer la recherche. Le script d’alertes absent de l’arbre admis et les états runtime restent explicitement inconnus.
3. **Relecture et décision** — cas nominaux, refus et limite de division sont rapportés; le readback indépendant vérifie les sources, anciennes preuves et livrable 007. Seul ce lot borné est clos.

## Restes et reprise

- **Famille Chrome : ouverte.** Thème actif, domaine/fournisseurs, police/locale, mesures de rendu et comportement du flux externe ne sont pas observés. Les frontières `CHROME-NATIVE-SKIN-AND-RUNTIME-STATE` et les autres limites de 006 sont conservées.
- **Tâche parente SYS-18.1-06 : ouverte** (`a_faire`; implémentation et acceptation non complètes). L’audit de ce petit lot ne mesure pas toutes les dimensions/ancrages d’écran et ne couvre pas les 51 familles/788 composants.
- **Produit : non terminé.** Le launcher actuel n’a pas été modifié par ce lot; les sources AIR documentées ne constituent pas une fonctionnalité reproduite.
- Reprise précise : fournir/admettre la source `assets/data/alerts/storeAlerts.xml`, puis instrumenter séparément l’hôte AIR exact avec thème, domaine, locale, police, viewport et état connus pour établir les dimensions effectives. Continuer ensuite la couverture Chrome, puis les autres familles, en réutilisant les preuves 003–007.
- Le reçu 006 est conservé tel quel : le main proof et le readback déclarent la séquence 6, tandis que son reçu accepté porte la valeur 4. Cette incohérence de reçu n’est ni corrigée ni propagée; le présent lot est explicitement séquence 7.

## Modifications et preuves

Ajout documentaire uniquement : ce rapport et les preuves immuables `family-coverage-proof-007.json`, `delivery-readback-007.json` et `accepted-delivery-007.json` dans le répertoire du lot sous `F:\OpenLeague-work\audit-units`. Aucun fichier produit, plan, registre normatif, goal, application de suivi, base de données, installation ou migration n’a été modifié.
