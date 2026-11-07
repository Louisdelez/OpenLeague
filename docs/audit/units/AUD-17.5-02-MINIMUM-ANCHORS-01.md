# AUD-17.5-02-MINIMUM-ANCHORS-01

## 1. Portée et conclusion

SYS-17.5-02 :« Vérifier les ancrages du HUD à la résolution minimale retenue ». La cible minimale retenue n’est pas établie dans la tâche,les consumers et sources de politique nommés examinés. La tâche reste ouverte. Ce sous-lot qualifie seulement les sources/valeurs candidates et l’entrée de reprise ;aucune taille n’est choisie et aucun critère changé.

Audit :qualification source/cible clôturable après relecture,tâche02incomplète. Implémentation :chaîne d’ancrage/viewport existante avec limites conservées. Vérification :lectures/empreintes et données héritées,0nouveau cas produit. Acceptation humaine :non demandée.

## 2. Sources et prérequis

Audits layout et ScreenResolution acceptés,identités/programmes/rapports/critères conservés. Les576fixtures natifs hérités couvrent1024×768,1280×800,1920×1080,2560×1440 ;aucun test natif ou Rust relancé. Le filtre de population impose width>=1024,height>=720,word+8==32,mais catalogue effectif et mode minimal choisi restent non qualifiés.

Lot D17-SYS-17-5 :quatre packages requis restent normativement a_faire. Leurs audits existants ne modifient pas ce statut. Référence4.20.0.315 EUW/en_GB,catalogue4.20.1distinct ;PE et données identifiés dans la preuve.

## 3. Consumers et valeurs à distinguer

|Valeur|Rôle vérifié sur source|Limite|
|---|---|---|
|Minimum demandé|Aucune dimension attestée dans le périmètre inspecté|Pas de preuve globale d’absence de politique ailleurs|
|1024/720|Seuils indépendants de population native|Ni mode1024×720disponible attesté,ni minimum retenu|
|1024×768|Plus petite fixture parmi quatre tailles|Fixture/défaut historique ne vaut pas décision de support|
|1280×800|Construction actuelle WindowResolution en pixels physiques|Demande initiale,pas taille OS observée ni minimum|
|180×120|Contraintes logiques par défaut de Bevy_window0.19.0héritées à la construction|Pas support produit,lisibilité ou enforcement OS démontré|
|1..32768par axe|Garde dimensionnelle de transform avant les autres refus|Pas plage UI supportée ni réussite de toutes les entrées|

La version0.19.0est verrouillée et la source cache est comparée aux octets du membre de l’archive crate dont le SHA256est celui de Cargo.lock ;aucune installation ni compilation. main utilise le constructeur physique via From<(u32,u32)> ;les contraintes de resize sont documentées comme logiques. Le fournisseur HUD lit physical_width/height et ignore dimensions nulles/inchangées ;ancrages/scalar/fractions/aspect/snaps ne choisissent pas une politique de minimum.

## 4. Attendu,observé et contrôles

Attendu :identifier une déclaration minimale ou laisser la cible indéterminée ;ne pas transférer le rôle des defaults/fixtures/seuils. Observé :six catégories séparées,minimal_target=null,576entrées réconciliées aux quatre tailles,source/units/defaults vérifiés.

Recherche nouvelle bornée README/execution_plan/completion_plan :rg code1sans matches,sans stderr. Une lecture JSON décodée avec normalisation des accents évite un faux constat depuis les échappements :0matchdans les deux JSON nommés. Les sources sont identifiées ;aucune absence globale n’en est dérivée. Les explorations initiales tronquées ne servent pas de preuve exhaustive.

Contrôles source de refus :zéro ou>32768,nonfini et overflow restent des branches/mathématiques identifiées,non des refus nouvellement exécutés. Non exécutés :anciens tests/lecteurs,original,AS,Rust,jeu,GUI,OS,rendu,input,audio,réseau ou changement de résolution. Les sorties physiques,clipping et zones de clic à un minimum ne sont pas prouvés.

## 5. Manques et reprise

- **MINIMUM-ANCHORS-TARGET** :No dated/versioned retained minimum W/H with physical/logical units,DPI/aspect/profile and intended HUD coverage is supplied by the named task/policy/consumer sources. Do not choose one of the six contrasted values. Reprise :An existing approved minimum declaration with path/version and units/context,or a separately authorized product decision. Reuse the pinned anchors/layout/provider evidence,then audit this precise target.
- **MINIMUM-ANCHORS-OBSERVATION** :No full HUD original/current visible anchor/clipping/hit-region comparison at a declared minimum is established by four math fixture sizes,source defaults or a catalog filter. Reprise :First supply the minimum contract;then name build/assets/provider/viewport/DPI and the allowed comparison cases. Reuse HUD-LAYOUT-ASPECT-RANGE-01,DPI,PROFILE,PROJECTION and lifecycle corrections;physical/runtime acceptance stays distinct.

L’entrée indispensable est une déclaration datée/versionnée W/H et unités/DPI/profil,ou une décision produit séparément autorisée. Conserver02ouverte ;ne pas réinterpréter un default ou le seuil d’un menu comme accord utilisateur.

## 6. Corrections réutilisées

Aucune correction nouvelle :HUD-LAYOUT-ASPECT-RANGE-01,DPI,PROFILE,PROJECTION,RESIZE-LIFECYCLE et FAILURE-STATE ainsi que les corrections ScreenResolution gardent leurs définitions,critères,prérequis et reprises. Le présent rapport ne les applique pas et ne crée pas de politique locale implicite.

## 7. Preuves et suite

Première tentative conservée :audit_minimum_anchors.py et producer-execution.json(code1),manifeste individuel de checksum absent. v2vérifie l’archive Cargo présente et son membre en mémoire,sans téléchargement ni extraction sur disque.

Dossier :F:\OpenLeague-work\audit-units\AUD-17.5-02-MINIMUM-ANCHORS-01. minimum-anchors-proof.json,audit_minimum_anchors_v2.py,verify_delivery.py,producer-execution-v2.json,reader-execution.json,delivery-readback.json,inputs et recherches archivées. Le lecteur clôture uniquement la qualification documentaire des sources/cible manquante,avec parent02explicitement ouvert.

Suite indépendante :AUD-17.5-03-1080P-ANCHORS-01 — cible1920×1080explicitement nommée dans SYS-17.5-03,avec preuves existantes réutilisées et rendu/acceptation séparés.

Goal,critères normatifs,application,Plan,UI,registres,bases,référence,cache de dépendance et acquis inchangés. Aucune installation,migration,relance,retrait ou suppression.
