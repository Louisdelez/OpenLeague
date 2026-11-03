# AUD-22.1-07-TR-01 — Déclaration tr invalide

Relecture : 2026-10-30T10:44:34.181455+00:00. Parent : SYS-22.1-07, « Détecter les chaînes manquantes et débordements sans fallback silencieux ». Ce compte rendu est un résultat d’audit documentaire ; aucun objectif du Goal,code,registre de l’application ou base n’est modifié.

## Décision et périmètre

**Audit terminé avec preuves pour ce constat local.** La fonction `native_hud_font_configuration::parse` accepte une ligne `tr "unterminated` placée après un profil de polices valide. Elle ne valide pas cette déclaration et ne retourne aucune traduction. Son rôle constaté est la configuration de police.

| Dimension | État et portée |
|---|---|
|Audit|Terminé pour le traitement de ce cas par ce lecteur uniquement|
|Implémentation|Détection d’une déclaration tr invalide absente de ce consommateur ; sélection des polices existante|
|Vérification|Partielle : diagnostic Rust isolé hérité et identité/code relus ; aucun oracle natif ou parcours graphique pour ce cas|
|Acceptation humaine|Non demandée ; aucune acceptation fonctionnelle déduite de la clôture d’audit|

Le parent reste ouvert : clés manquantes au moment de leur utilisation,dictionnaire/résolution de texte,autres consommateurs et débordements ne sont pas qualifiés par ce constat.

## Sources et consommateurs

Référence historique : PUBLIC4.20.0.315 EUW/en_GB. Le PE original et `DATA/menu/fontconfig_en_GB.txt` sont présents et leurs identités sont vérifiées. La copie installée du fontconfig concorde avec l’original. L’appartenance aux manifestes sélectionnés est une preuve héritée V795,pas un contrôle de manifestes relancé ici.

L’analyse REA héritée V795 montre le lecteur796350,le littéral UTF-16tr et l’appel au parseur de jetons795D10. Les octets des instructions796BA0/796BAE et du littéral10B7E24 concordent avec le PE. Cela établit une reconnaissance statique de tr ; cela ne détermine pas le résultat natif de la ligne malformée.

Consommateurs actuels relus :

- `crates/client/src/native_hud_font_configuration.rs:5,13,29,37` : retour maps/bibliothèques,branche tr sans analyse du contenu et chargement.
- `crates/client/src/native_zip_provider.rs:116-118` : appel réel du chargeur et transmission à StartupHud.
- `crates/client/src/native_hud_font_assets.rs:49-55` et `main.rs:683` : enregistrement du plugin et consommation des fichiers de police. Ces appels sont observés dans le code ; ils n’ont pas été exécutés graphiquement pour cet audit.

La recherche d’absence est limitée à la fonction parse,sa structure de retour et ce chemin d’initialisation. **Aucune absence globale de validation dans tout le jeu n’est affirmée.** Les ancres existantes OLC-e9cd3e4c-fa95-5e49-83c3-173844d624ef,OLC-79c326e6-ee8a-572d-b787-643995e413e0 et OLC-801ab8ea-c7f5-51ee-9ab0-8a34836fc5da sont identifiées ; aucun lien n’est ajouté au registre.

## Attendu,observé et contrôles

Selon le contrat local inspecté,le lecteur de polices laisse les lignes tr à un autre domaine. Le diagnostic V795 fournit quatre alias et une bibliothèque valides,puis la ligne non terminée. Le résultat enregistré est `accepted=true,error=null`. Ce résultat concorde avec la branche actuelle : elle vérifie seulement la présence de la section.

Preuve d’exécution héritée du 2026-10-30T09:09:46.287373+00:00 : `revision795_locale_text/CURRENT_RECEIPT.json`,compilation et exécution code0. Le diagnostic compile directement trois modules Rust actuels avec la bibliothèque serde_json identifiée. Son entrée est synthétique et déclarée ; aucun fichier du client historique n’a été remplacé pour en faire une source. Le cas n’a pas été rejoué.

Contrôles nouveaux : identités du reçu,du code,du diagnostic,du compilateur,de la bibliothèque,du binaire et des journaux ; concordance de l’observation avec la preuve ; relecture des appels ; identité des ressources natives et contrôle des deux instructions. Les19fichiers logiciels gelés restent identiques à l’inventaire de retrait. Aucun accès SQL,installation,migration,lancement d’application ou nouvelle analyse REA.

## Manques et actions restantes

Le manque établi est une **couverture de validation dans ce consommateur**,pas un fontconfig à télécharger ou une texture à reconstruire. La grammaire native,la responsabilité du lecteur de textes et le diagnostic destiné à l’utilisateur restent à qualifier.

Ces précisions réutilisent des tâches existantes ; elles ne créent aucune tâche dans l’application :

| Action documentaire | Résultat unique et critère de fin | Condition de reprise |
|---|---|---|
|TR-RESP-01,sous SYS-22.1-04|Identifier le consommateur courant chargé de lire/résoudre les traductions HUD. Fournir la chaîne clé→table→usage,ou une absence établie par recherche bornée.|Code de ce consommateur accessible ; ne pas supposer que le lecteur de polices en est responsable.|
|TR-CONTRAT-01,sous SYS-22.1-07|Qualifier la règle native de ce cas et son diagnostic. Comparer le cas valide et le cas non terminé avec attendu/observé,sources et limites.|Nouvelle question portant sur795D10 ou une source équivalente ;795D10 n’a pas encore été qualifié. Ne pas refaire l’analyse796350 inchangée.|
|TR-DIAG-01,sous SYS-22.1-07|Planifier le diagnostic dans la couche réellement responsable. Critère : comportement explicite et vérifié selon le contrat retenu,sans substitution silencieuse.|Après TR-RESP-01 et TR-CONTRAT-01. Si le contrat historique reste indéterminé,le signaler ; aucune politique inventée. Toute réalisation fonctionnelle exige une instruction distincte.|

Pour ces actions : sources utilisables = fontconfig natif,PE et preuve V795 ; limites = analyse native statique et diagnostic Rust isolé. Fichiers de départ inspectés = ceux ci-dessus. Travail = identifier/qualifier avant modification. Preuves attendues = identité des entrées,contrôles attendus/observés et chaîne de consommation. Dépendances et reprise sont explicites dans le tableau. Aucun changement arbitraire du lecteur de polices n’est prescrit.

## Clôture du lot

Les sept rubriques du cadrage sont couvertes : portée,sources,consommateurs,observations,limites,actions et preuves. L’incertitude native est identifiée et n’empêche pas de terminer le constat actuel. Aucune correction fonctionnelle ni aucun parcours complet ne sont déclarés terminés.

Prochain résultat documentaire proposé : AUD-22.1-07-KEY-01,qualifier le rôle du fallback `Inconnu` dans la boutique actuelle. Sortie : consommateur exact,entrée déclenchante,effet constaté et lien avec la détection d’une clé manquante ; rester dans cette seule chaîne avant d’aborder les débordements. Cela reste une autre partie ouverte de SYS-22.1-07.

## Identités de preuve

Les fichiers restent dans leurs emplacements existants ; aucune copie volumineuse n’est produite.

| Preuve | SHA256 |
|---|---|
|Lecteur de configuration actuel|500ea12ef4fffd40ccf856169d59b2a9c17194620c22bacbe7c7422fc329bf14|
|Reçu Rust V795|d533e67e245f57821a1309f8fe91249b47d34215b82c43c7a6652c45c3839a5e|
|Diagnostic Rust source|37f18600e28a92e3559be121dfbeba5b3bcc64fcdc4b77e192297c840e656452|
|Binaire du diagnostic hérité|4be3abbcff81e1987d2274e7344f0de61cc09c02fdcae75f229e14241dc322ff|
|Journal d’exécution hérité|1cc96d2a40986cac49388beec213c69141a481add8788998acbb3de49c645da5|
|PE original|402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862|
|Réponse REA796350 héritée|7130ae9aaa09a944d0e6548eb7da8f511f4dc94e88d70c354d77e21e1d3bfc9e|

Chemins : sources dans `F:/OpenLeague/crates/client/src/` ; reçu,diagnostic et journaux dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision795_locale_text/` ; réponse REA dans `revision795_rea_locale_text/observations/3da1a10b-9ea3-4074-a537-c57cccca24b6/007-analyze_function-response.json`. Rapport historique de portée : `docs/FIDELITY_REA_LOCALE_TEXT_V795.md`. Question parente conservée : OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f.
