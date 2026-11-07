# AUD-17.5-03-1080P-ANCHORS-01

## 1. Portée et décision

SYS-17.5-03 :« Vérifier les ancrages du HUD à 1920 × 1080 ». La sélection des observations1080et leur raccord aux consumers sont vérifiés ;la tâche complète reste ouverte faute de contexte natif/pixels1080comparables. Aucun minimum n’est choisi depuis cette cible.

Audit :confrontation documentaire clôturable après relecture,comparaison complète non qualifiée. Implémentation :consumers layout/viewport/bounds/panels/text/anneaux existants avec limites conservées. Vérification :sources et données/captures héritées,0nouveau test produit. Acceptation humaine :non demandée.

## 2. Référence et données réutilisées

4.20.0.315 EUW/en_GB,catalogue4.20.1distinct. Les données natives déjà enregistrées donnent144cas layout,576cas bounds et3cas de transfert de dimensions pour les valeurs fournies1920/1080. Ce sont des sous-ensembles d’observations,pas de nouvelles exécutions du natif ou du Rust et pas des comptes de contrôles.

reference-1080-recorded-bounds.json sélectionne48groupes au profil explicite scalar1,dirty et initialisation sentinelle :41non vides,7vides,697références d’éléments sur703,6non affectées. Les sorties natives enregistrées sont conservées en bits et reliées à leur indice source. Aucun rectangle visible ou état rendu n’est déduit d’un groupe vide ou d’une union de bounds.

## 3. Consumers réels et frontières

Quatre routes directes transform sont relues :panels,text_batch,recharge_rect,group_bounds ;include_motion=false et group_offset=None. Les144cas math1080comprennent48sans mouvement fourni et96avec mouvement fourni ;cela ne prouve pas un producteur de mouvement intégré aux quatre routes.

Le fournisseur courant de viewport prend physical_width/height,marque les groupes non vides dirty sur changement et rafraîchit les bounds. Le corps du test CPU1280→1920et la réutilisation de cache sont identifiés,non exécutés. Les18fenêtres de consumers du layout,les recherches existantes et leurs limites sont réutilisées sans nouvelle query.

Précision HUD-VIEWPORT-UNIT-PROVENANCE-01 :l’ancien JSON minimum disait physical input dimensions pour les cas natifs. Il s’agit de dimensions du propriétaire fournies au harness ;le producteur Game original et son mapping logique/physique/DPI restent non qualifiés. Le consumer Bevy physique est établi séparément. Ancien JSON,relecture et critères conservés ;aucune réécriture silencieuse.

## 4. Preuves graphiques et contrôles

Quatre PNG reliés aux deux rapports historiques viewport/panels ont exactement1280×800pixels et leurs SHAcorrespondent aux métadonnées du6octobre. La capture F:/OpenLeague/logs/native-hud-panels-vulkan.png a été inspectée visuellement :panneau partiel en bas à gauche,bandeau en haut à droite,pas un référentiel original/courant1080. Aucune image nouvelle créée.

Les manifests historiques gardent leurs binaires,diagnostics et limites ;main/provider/panels ont des dérives de source selon le rapport concerné. Une correspondance du module viewport ne qualifie pas le build graphique entier. Ces quatre images sont refusées comme preuve1920 ;aucune absence globale d’autres captures n’est affirmée.

Attendu :cas natifs1080séparés des cas d’autres tailles,référence48exacte,consumers actuels liés,captures1280non promues. Observé :144/576/3et48groupes exacts,source actuelle relue et aucun PNG inspecté en1920. Sources,Git,25fichiers protégés,5registres et1168sources courantes inchangés.

Non exécutés :anciens tests/lecteurs,calcul original/émulation,AS/Rust/jeu,GUI/OS/GPU,réseau,installation ou migration. Une inspection d’image existante ne vaut ni exécution du jeu ni acceptation humaine.

## 5. Manques et reprise

- **1080-NATIVE-COORDINATE-CONTEXT** :The original upstream viewport/DPI/profile/context producer and framebuffer mapping are not established by supplied1920x1080owner fields or the current physical Window consumer. Reprise :Named original Game/viewport/profile producer with units,DPI/scale and matching scene/context,or explicit versioned local contract;reuse HUD-LAYOUT-PROFILE-01,DPI and PROJECTION.
- **1080-FULL-RENDER-COMPARISON** :The four inspected historical graphics captures are1280x800and partial,with main/provider/panel source drift;they are not a comparable original/current1920x1080HUD pair. Other project captures are not globally claimed absent. Reprise :A named same-context reference4.20and current1920x1080pair with exact builds/assets/profile/DPI and selected renderer coverage,or a newly supplied existing artifact/receipt meeting that contract. No broad unchanged scan or transfer of the old build qualification.
- **1080-RENDERER-AND-REFUSAL-COVERAGE** :Recorded group bounds and48motion-free math cases do not prove all selected panels/text/icons/overlays/hit regions,clipping,resource failures or cache invalidation rendered at1080. Reprise :Use the existing SYS-17.5-03task and layout/render correction dependencies. Name each actually selected consumer/resource family and verify nominal,missing/stale/wrong geometry/DPI,visibility and refusals separately under product execution authorization.

## 6. Corrections conservées

Aucune nouvelle correction produit :SYS-17.5-03garde son objectif et ses critères ;les notes d’exécution précisent ses entrées/cas sans le marquer terminé. Les dix corrections layout restent inchangées,notamment PROFILE,DPI,PROJECTION,ELEMENT-MOTION,GROUP-OFFSET et FAILURE-STATE. La présence du test ou des fixtures ne remplace pas leurs preuves manquantes.

## 7. Livraison et suite

Dossier :F:\OpenLeague-work\audit-units\AUD-17.5-03-1080P-ANCHORS-01. anchors-1080-proof.json,reference-1080-recorded-bounds.json,audit_1080_anchors.py,verify_delivery.py,producer-execution.json,reader-execution.json et delivery-readback.json. Le lecteur clôture uniquement cette confrontation de preuves,avec parent03explicitement ouvert.

Suite :AUD-17.5-04-RESIZE-ANCHORS-01 /SYS-17.5-04 — audit des ancrages après redimensionnement,en réutilisant les acquis et en séparant les événements/fournisseurs du cycle OS/GPU.

Goal,critères normatifs,application,Plan,UI,registres,bases,ressources,captures et acquis inchangés. Aucune installation,migration,relance,retrait ou suppression.
