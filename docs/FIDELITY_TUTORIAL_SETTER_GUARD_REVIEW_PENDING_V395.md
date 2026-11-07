# Rectification de portée Tutorial — V395 en cours

La réduction /AIR_source_contract/advanced_disabled du reçu V373 omet une condition de passage dans le setter public. Son assertion post_type=basic/RPC_type=0 avec Enabledfalse et choosefalse ne suffit pas pour tous les états préalables. Le reçu source V373 est conservé en octets exacts ; ses preuves de livraison restent datées. Aucune défaillance du jeu exécuté n'est démontrée.

Source directement relue : CreateTutorialGameController.as79–82 appelle le setter public178–188 ; le setter privé54–65 n'est appelé que lorsque l'ancienne valeur du getter diffère de l'argument. Si l'ancienne valeur est false et l'argument false, cette chaîne ne relit pas Enabled et n'assigne pas tutorialType.

Contre-cas conditionnel : en supposant isBasicTutorialfalse, tutorialTypeADVANCED et un Enabledfalse hypothétique au moment de choose(false), choose seul conserve ces deux champs. Si createGame88 est ensuite atteint avec le même getterfalse, son expression de requête vaut1. Il ne s'agit pas d'une exécution AS. L'ordre des événements, propertyChange, les setters isBusy, callbacks, providers et lifecycle peuvent intervenir entre corps ; aucun état effectif ou chemin historique joignable n'est garanti.

La lecture indépendante V393 confirme ce garde et conserve les limites de présence Map12, config/defaults et identité BattleTraining. CollecteurV2 réel0/abf178, sceau0/6b32e3 ; FINAL18548/SHA48b0266ce885383a1d88d28a7f01cbd1c33b59b6e04a43ca9f0b10a879939670. ROOT a acquis physiquement ce FINAL et son compagnon avec code0/0998bd. Lectures directes ROOT0/17ca96 et0/315734.

Correction additive V395 en préparation pour MODE-TUTORIAL-SCOPE et SYS-01.2-02 : nouveau reçu et liens explicites suppléant uniquement cette réduction, zéro nouveau corps ou CID. La revue de livraison V396 suivra le vrai ROOT/checkpoint. Capture Custom V384 retenue jusqu'au traitement de cette correction ; le lien CoOp379/383 reste distinct et inchangé.

Le présent avis modifie seulement les documents et la preuve courante de portée. Les quatre registres et les bases restent inchangés, les cases manuelles et inconnues restent ouvertes. Aucun ancien reçu n'est réécrit, aucun test/Rust/AIR/natif/GPU exécuté, aucune acceptation automatique.
