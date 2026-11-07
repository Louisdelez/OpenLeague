# Objets2 à6 — tableau des cinq slots restants

## 1. Périmètre et fin précise
`AUD-17.5-01-OPTIONS-KEYBIND-ITEM2-6-MATRIX-01` dans SYS-17.5-01 / SYS-01.2-02. Vingt déclarations physiques, quatre par slot1..5. Critère : différences XML/touches/locale/Text et mapping de chaque slot établis, contrats/écarts communs réutilisés, sept rubriques relues. Ni fonctionnalité ni jeu déclarés complets.

## 2. Sources réutilisées
Item1 **300/631** déjà accepté ; 34 fragments AS, quatre états génériques, contrats natifs et leurs limites, sources actuelles, cinq anciens résultats CPU, onze objectifs existants et rapprochement de labels/DF modes référencés par SHA/pointeur. Aucun flow natif/AS/ancien test/lecteur réexécuté, aucun export/installation. Champs Item1 normal_alias_event et quickbind_section exclus du transfert commun et instanciés par ligne ci-dessous ; alias effectifs toujours ouverts. Text issus du même membre HUD natif déjà qualifié, archives/capture conservées ; aucun asset recréé.

## 3. Tableau source et consommateur
| Objet | Slot | Touche | Text natif | Déclarations XML |
|---|---:|---|---|---|
| 2 | 1 | Digit2 | InventoryItemHotKey1 | 25, 89, 98, 107 |
| 3 | 2 | Digit3 | InventoryItemHotKey2 | 26, 90, 99, 108 |
| 4 | 3 | Digit5 | InventoryItemHotKey3 | 27, 91, 100, 109 |
| 5 | 4 | Digit6 | InventoryItemHotKey4 | 28, 92, 101, 110 |
| 6 | 5 | Digit7 | InventoryItemHotKey5 | 29, 93, 102, 111 |

Pour chaque objet : défaut **[touche]**, smart **[Shift][touche]**, self **[Alt][touche]**, smart1 deploy/user ; normal et flagselfflat absents dans ces trois fichiers seulement, pas une absence globale de mode/asset. Quinze traductions en_GB vérifiées (Use/Quick/Self par objet), normal réutilise le label Use. Quatre déclarations réelles par objet, pas de ligne autonome smart+self ou Level synthétique ; quatre états du modèle commun conservés.
Table actuelle **1,2,3,5,6,7**, premier just_pressed : chaque touche ci-dessus donne son **UseItem(slot)**, avant D/F/capacités. Les objets/quantités viennent du slot actuel, pas d’un ID d’objet fixe. **Digit7 correspond au slot5, pas à un septième slot**. Vision4 et événement evtUseItem7 séparés ; leurs règles ne sont pas déduites de cette table. Action actuelle porte slot seulement ; modes/cibles et remappage effectifs non qualifiés. Source/refus core et limites de consommables reconstruits réutilisés, pas de nouveau gameplay prouvé.

## 4. Attendu/observé et contrôles
340 contrôles statiques producteurs réussis ; cinq cas de tableau couvrent XML, chords, Text/locale, mapping/route et réutilisation des frontières. Recherche bornée de30 noms nouveaux sur1168 sources figées, aucun match, sans absence sémantique globale déduite. Ancienne recherche de libellés/flows et cinq anciens résultats CPU réutilisés sans les rejouer ; aucun essai Rust/jeu/OS/GUI/réseau ou émulation. Relecture indépendante requise.

## 5. Manques et reprise
Quatre écarts communs d’Item1 restent applicables individuellement aux cinq slots : provider/alias, keymap/mode/persistance, libellé dynamique, parcours physique/comparaison native. Chaque entrée de preuve conserve source/pointeur, manque, impact et condition de reprise. Reprise produit séparément autorisée sur objet supporté nommé, mapping/refus/priority/focus/erreurs/edit/relaunch par slot ; ne pas assimiler préférence stockée et objet actif implémenté. Text natifs présents, raccord au producteur de label encore ouvert.

## 6. Travaux réutilisés
Aucun correctif nouveau ou appliqué. Réutiliser BIND-LOAD/SAVE/ITEM-DISPATCH/ITEM-LABELS/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER et CAST-MODE-MODEL/ITEM/EDIT/RELEASE ; conserver INV-HOTKEY-LABELS-01 comme seconde référence du même raccord de labels. Vues documentaires D/F→CAST-MODE-SUMMONER-01 inchangées, aucune réécriture des critères/registre/preuves. Le tableau fournit cinq instances de vérification dans ces objectifs existants, pas cinq copies de leur infrastructure.

## 7. Livraison et limite de clôture
Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-ITEM2-6-MATRIX-01\keybind-item2-6-proof.json`, script `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-ITEM2-6-MATRIX-01\audit_keybind_items2_6.py`. **Les six slots ordinaires couvrent24 déclarations physiques auditées**, Item1 séparément puis20 ici, aucun nouveau contrôle HUD logique ou test runtime compté. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 76 modifications suivies antérieures, 25 protégés, cinq registres, contexte/corpus1168 inchangés. Goal/critères normatifs, produit, Plan/UI/bases et preuves antérieures conservés ; nouveaux documents isolés seulement. Audit de ce tableau clôturable après lecture ; fonctionnalité, parent et goal ouverts. Prochain lot : deux déclarations distinctes evtUseVisionItem et evtUseItem7, leur identité/consommateur ou manque précis, sans inventer septième slot.
