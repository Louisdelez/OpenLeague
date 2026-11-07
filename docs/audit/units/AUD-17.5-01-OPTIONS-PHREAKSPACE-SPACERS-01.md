# AUD-17.5-01-OPTIONS-PHREAKSPACE-SPACERS-01

Date UTC : 2026-11-01T07:44:43.820103+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Portée et statuts

Treize spacers physiques du groupe fourPerLine,après les5structures déjà auditées. Aucun nouveau réglage,aucune clôture des18contrôles. Audit documentaire prêt pour relecture distincte ; implémentation précise partielle/non qualifiée,vérification documentaire,acceptation humaine non demandée. Parent et goal ouverts.

## 2. Sources et identités

|Ligne|ID|Indice parmi24enfants (base0)|
|---:|---|---:|
|15|OPT-SRC-f1ffe06d53bab9f7|0|
|20|OPT-SRC-21c7e2d8e4ff133c|4|
|22|OPT-SRC-fe53ba73fe1ac65d|6|
|25|OPT-SRC-8d66ff3f1012ed2c|8|
|30|OPT-SRC-def21732d3bf9dbe|12|
|32|OPT-SRC-3e8d23653c2923da|14|
|33|OPT-SRC-900b51c78b96f385|15|
|35|OPT-SRC-8c7292030dea2e94|16|
|37|OPT-SRC-38d3106bfa337a1b|18|
|38|OPT-SRC-cc94a917a1afcb1e|19|
|40|OPT-SRC-eca620048df267c3|20|
|42|OPT-SRC-79e0013ab6b819ed|22|
|43|OPT-SRC-e350098303252ecd|23|

XML historique FoundryPhreakspace.xml et catalogue physique identifiés ; mêmes octets/taille/SHA256 que le lot précédent. Les13balises sont vides,sans attribut propre ni enfant,dans le même groupe. Les indices sont physiques,pas des coordonnées ou des lignes rendues. PE/GFX et exports conservés ; six fenêtres nouvelles bornées qualifient les primitives,sans extraction ni désassemblage.

## 3. Consommateurs et règles source

ModelSpacer dérive d’UnifBaseModel ; ViewSpacer dérive de BaseView. La fabrique associe ModelSpacer/ViewSpacer/Sprite,sans wrapper de bitmap propre. Aucun asset manquant ne doit être inventé pour ces cellules vides. Les accesseurs height/width lisent et écrivent directement spriteInstance. ViewSpacer ne fixe pas de minimum et relaie rest comme un seul argument supplémentaire à super.init. Il n’a pas de garde nulle explicite dans ses accesseurs.

BaseView crée le sprite par défaut si son champ est nul,initialise Padding(0,0,0,0),puis lit les attributs de padding. Un attribut absent retourne0 ; les autres valeurs passent à Number sans validation locale dans ce getter. Padding.vertical vaut top+bottom,horizontal left+right. La méthode relayout héritée est vide. Ces règles de source ne sont pas une mesure de taille réelle du sprite.

Le builder N4 déjà audité appelle relayout(cellWidth),avance x de cellWidth et ajoute la vue à currentRow,indépendamment de la largeur que rapporte le spacer. La hauteur de ligne utilise aussi sa hauteur rapportée + padding.vertical. Il ne faut donc ni supprimer ces cellules parce qu’elles sont vides,ni leur inventer une hauteur ; nombre de modèles,vues admises et rendu réel restent distincts.

Les9fenêtres courantes réutilisées sont vérifiées. Une seule requête nouvelle cherche ModelSpacer/ViewSpacer en sous-chaînes sans distinction de casse dans le corpus1168inchangé : zéro occurrence. Ces deux nouveaux alias ne répètent pas la recherche des fichiers ; une implémentation générique de spacing n’est pas déclarée absente. L’admission externe du panneau conserve les limites du lot précédent.

## 4. Attendu et observé

- Treize positions physiques — attendu : 13spacers vides,dans le même groupe et à des indices distincts ; aucun réglage supplémentaire. Observé : Octets,parents et indices0/4/6/8/12/14/15/16/18/19/20/22/23 vérifiés ; ces indices ne deviennent pas des coordonnées affichées.
- Dimensions et padding — attendu : Source des accesseurs,init et fallback précisée sans inventer un asset ou une taille minimale. Observé : Sprite par défaut,accesseurs directs,relayout vide,padding initial0 et attribut absent0 ; ni dimension ni hauteur effectives observées.
- Participation au layout — attendu : La cellule avance selon le builder même si relayout ne redimensionne pas le spacer ; hauteur séparée. Observé : Raccord relayout/cellWidth/currentRow/height+padding réutilisé ; aucune exécution ou simulation du code original.
- Consumer et correction — attendu : Requête nouvelle limitée aux2alias et réemploi de l’objectif de layout réellement commun. Observé : 1168sources inchangées,zéro alias ;9fenêtres réutilisées. Pas de nouvelle correction indépendante ;13notes source liées à la correction existante sans changer ses critères.

Contrôles réels : XML statique,octets/parents/ordre/attributs,fenêtres nouvelles et champs hérités,nouvelle requête bornée,corpus/Git/25fichiers protégés/5registres avant/après. Producteur et lecteur documentaire distincts avec scripts,sorties et codes réels. Pas de jeu/AS/Rust/GUI/réseau,émulation,rendu ou test produit.

## 5. Écarts et reprise

- SPACERS-BOUNDS-RENDER — Dimensions réelles du sprite,effet des setters,hauteur de ligne,pixels et clipping ne sont pas observés. Le code ne fixe pas de taille minimale et le relayout vide ne mesure aucun résultat. Reprise : Renderer/menu/provider/viewport autorisés et nommés ; observations de spacers seuls/mélangés,tailles explicites,padding et limites de largeur,via HUD-OPTIONS-FOUR-PER-LINE-01.
- SPACERS-ADMISSION-NULL — Admission effective des13vues et comportement d’un sprite/type manquant restent non qualifiés ; les accesseurs n’ont pas de garde explicite et le provider original n’est pas exécuté. Reprise : Arbre effectif et ressources/types nommés,avec refus ou adaptation locale versionnée explicitement observés ; ne pas déduire une exception ou un refus gracieux du seul code.
- SPACERS-CURRENT-CONSUMER — Les deux alias de classe n’apparaissent pas dans le corpus courant ; une implémentation générique de spacing peut exister mais son raccord précis reste non qualifié. Reprise : Consumer ou adaptation de layout précis,avec mêmes13IDs et données/rendus vérifiés ; pas de répétition de cette requête sans nouvelle piste.

Les gaps de structure/provider et les inconnues des includes restent conservés par référence ; aucun résultat de parsing ou d’admission historique n’est inventé.

## 6. Correction réutilisée

Aucune correction indépendante ajoutée. HUD-OPTIONS-FOUR-PER-LINE-01 couvre déjà explicitement les espaces,vues absentes,tailles/paddings et refus dans ce même groupe. Sa définition et ses critères sont conservés par digest. Les13sources sont des notes d’exécution documentaires,non appliquées ; ce lot ne modifie aucune fiche normative.

- Relier les13positions source à une vue non éditable,avec le même ordre parmi les24enfants ; ne pas les supprimer au motif qu’elles n’ont pas de bitmap propre.
- Conserver les accesseurs de dimension délégués au sprite et le relayout vide,ou déclarer explicitement une adaptation locale versionnée ; ne pas fabriquer une hauteur/minimum/largeur d’asset.
- Conserver padding initial0 et fallback0 des attributs absents ; les valeurs non absentes passent à Number sans validation locale dans ce getter.
- Distinguer l’argument rest emballé,les modèles/vues admis et les refus de ressource/type ; les gardes ou politiques ajoutées doivent être identifiées.

Preuves nécessaires : Arbre et13sources identifiés,provider/contexte/viewport, Spacers seuls ou mêlés aux contrôles,dimensions/hauteurs/paddings explicitement fournis, Vue/sprite manquant ou incompatible,largeur limite et ordre de cellules, Attendu/observé du rendu et des données avant/après,aucun réglage édité. Reprise : Autorisation produit distincte et consumer/renderer/provider nommés ; reprendre la correction existante avec ces13sources et ses critères conservés.

## 7. Preuves et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-PHREAKSPACE-SPACERS-01. Preuve phreak-spacers-proof.json,scripts audit_phreak_spacers.py/verify_delivery.py,reçus producer-execution.json/reader-execution.json,relecture delivery-readback.json. Le producteur ne s’auto-clôture pas ; le lecteur distinct examine les sept rubriques et clôture les13rôles uniquement.

Partition36sans doublon : 5structures +13spacers +18contrôles. Prochain lot : AUD-17.5-01-OPTIONS-PHREAKSPACE-GRID-CHECKBOXES-01 (11checkboxes du groupe,avec7autres contrôles séparés). Aucun taux de jeu terminé ou menu fonctionnel déclaré.

Goal,critères normatifs,Plan,UI,bases,registres,ressources et modifications antérieures inchangés. Aucune installation,migration,relance,restauration ou suppression.
