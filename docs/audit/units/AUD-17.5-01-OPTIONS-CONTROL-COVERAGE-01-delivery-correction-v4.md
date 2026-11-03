# Correction de livraison — réconciliation Options

## 1. Périmètre
Correction de provenance deAUD-17.5-01-OPTIONS-CONTROL-COVERAGE-01; aucune modification des357associations ou des84livraisons de l’instantané, ni du goal,du plan ou du jeu.

## 2. Erreur conservée
Le lecteurv2réutilisait mp dans la boucle des anciennes preuves. Son footer main_proof/producer_proof et sa review pointaient donc vers SummonerStates, malgré des contrôles de matrice réussis. Le reçu historique delivery-readback.json reste conservé et ne doit pas servir de reçu de clôture de la matrice. La version3a refusé l’ajout postérieur du dossierScreenResolution; son échec est conservé.

## 3. Correction
Le lecteurv4 utilise des variables distinctes, vérifie le chemin/hash propres après la boucle, et conserve explicitement l’instantané84en excluant le seul lotScreenResolution commencé après. Lire désormais delivery-readback-v4.json et independent-review-v4.json. Toute agrégation future doit sélectionner explicitement ce lecteur pour cette unité.

## 4. Attendu et observé
Attendu:main_proof=control-coverage-proof-v2.json SHA f79f08d1112da304de5d0910a092b48a8599f27fe9b521ad479a28a049bc5d82, aucun changement de matrice. Observé:identité exacte,1633contrôles producteurs et6193de relecture, code0/stderr vide.54IDs nominatifs,18parent/clause,285inventaire/famille; aucune mesure de jeu terminé.

## 5. Limites
Correction documentaire seulement. Les limites fonctionnelles et les manques du rapport-v2restent ouverts; aucune case,acceptation humaine ni exigence parente clôturée. Aucun ancien code/preuve/rapport réécrit.

## 6. Reprise
Continuer ScreenResolution XML12depuis la source exacte et les consumers actuels. Réutiliser ce reçu-v4et son actual_execution; ne pas copier les anciens pointeurs canoniques invalides.

## 7. Preuves
Main:F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-COVERAGE-01\control-coverage-proof-v2.json
Reader:F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-COVERAGE-01\delivery-readback-v4.json
Review:F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-COVERAGE-01\independent-review-v4.json
Exécution:F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-COVERAGE-01\reader-execution-v4.json
Contrôle supplémentaire:relecture des champs émis et du reçu code0effectuée après écriture. Sources/corpus/Git/protections conservés par la relecturev4.
