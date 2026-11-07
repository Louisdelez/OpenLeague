# SYS-01.2-02 — Sources et lecteurs de localisation, V795

Dix-neuf fiches LOCALE-*-HUD, SYS-22.1-04/06/07 et l’objectif SYS-01.2-02 sont enrichis.49 liens supplémentaires réutilisent sept ancres existantes ; aucun nouveau consommateur n’est créé. Les états, inconnues, acquis et preuves antérieures sont conservés. La portée couvre la traçabilité de la localisation ; les22 fonctionnalités restent partielles.

## Sources natives et code original

Référence : LoL PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Les19fontconfigs natifs et leurs copies installées concordent en taille/SHA256 avec le registre et les manifestes RADS sélectionnés. Les copies historiques de catalogue/manifeste sur E restent en lecture seule et correspondent à F. Ces19ressources nommées ne constituent pas19clients AIR et packs de voix terminés.

Chaque fichier contient12704lignes tr avec12704clés lexicales distinctes ; les ensembles de clés correspondent à en_GB. Deux lignes nominatives Annie/Ezreal par locale sont identifiées avec leur numéro et leur texte exact. Ce recensement de jetons ne qualifie pas la grammaire ou le rendu des valeurs.

REA6.4.0/Ghidra analyse le PE original SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, à partir d’une copie privée sur F. Trois procédures,1135instructions et14références sont recoupées avec Capstone et les octets du PE. Session fermée normalement, aucune erreur REA ; aucun code original exécuté.

| Procédure native | Fait observé dans le code statique | Limite |
|---|---|---|
|790E20|Construit le nom fontconfig à partir de la locale fournie et appelle796350 depuis790F99|Choix de langue et montage historique effectifs non exécutés|
|796350|Reconnaît les déclarations FontConfig/map/fontlib/tr ; référence Localization_Errors.txt et les erreurs de déclaration|Token parser795D10, stockage,échappements,doublons,priorités et recherche complète restent ouverts|
|786E20|Inscrit HandleLocalizeText avec le callback7879A0 via78D610|Le callback lui-même reste à analyser et exécuter|

Six instructions décisives sont conservées avec leurs octets : appel du lecteur, passage du littéral UTF-16tr au parseur de jetons, adresse du callback, nom HandleLocalizeText et appel d’inscription. La décompilation seule n’est pas une preuve d’exécution ou de signature/ownership native complète.

## Consommateurs actuels exercés

Le diagnostic compile directement les sources actuelles native_game_cfg_text.rs, native_hud_font_configuration.rs et native_hud_normal_font.rs, avec rustc et la bibliothèque serde_json du cache identifiés. Les commandes de compilation et d’exécution terminent avec le code0. Il s’agit d’un exécutable de diagnostic des vrais modules ; aucun build complet du client ou rendu Bevy n’est revendiqué.

Les racines de lecture sont explicitement fournies : copies exactes des fontconfigs et du manifeste, locale.cfg de diagnostic. Les fichiers du jeu restent inchangés.46 observations JSON sont conservées.

| Cas | Attendu du contrat local inspecté | Observé |
|---|---|---|
|19locales nominales|Sélection du fichier déclaré et retour des alias/bibliothèques|19sélections conformes|
|19variantes en majuscules|Même recherche insensible à la casse, valeur de locale fournie conservée|19sélections conformes|
|Locale inconnue,clé absente,octet de locale non UTF-8|Refus explicite de lecture/sélection|3refus conformes|
|Directive inconnue,map hors section,encodage invalide,alias répété|Refus du parseur limité de polices|4refus conformes|
|Déclaration tr non terminée|Le lecteur de polices actuel laisse ce domaine de côté|Acceptée ; aucune traduction retournée|

La dernière observation établit une limite existante : le lecteur de polices ne fournit ni dictionnaire de traductions ni validation des chaînes. Elle n’est pas présentée comme une capacité de détection des textes manquants. La sélection des alias de polices ne prouve pas le chargement des TTF,glyphes,GPU ou widgets. Le choix de langue dans le launcher et la session ordinaire n’est pas établi par ces racines de diagnostic.

## Intégration et conservation

Les19fiches HUD réutilisent les deux ancres précises de lecture de locale et de chargement, en complément des frontières tr/structure déjà recensées. SYS-22.1-04/07 relient ces frontières aux sources de texte et au lecteur d’origine ; SYS-22.1-06 relie parse/load/normal_font en conservant son chargeur de police antérieur. Quatorze ancres au total sont relues. Les ancres de boutique,interface et assets de police conservées restent statiques lorsqu’elles ne sont pas parcourues par le diagnostic.

Les tâches marquées entry_boundary_only conservent cette qualification et n’acquièrent aucun consommateur de traduction complète. Les sources,les observations et les instructions copiables sont intégrées au registre et aux deux bases du plan par deltas ciblés.42584autres tâches,42607états manuels,23historiques,24phases,2770lots et42215groupes doivent rester identiques dans chaque base ; relecture indépendante et quick_check sont exécutés avant la clôture documentaire. Aucune sauvegarde intégrale supplémentaire de base.

Fichiers ajoutés : docs/fidelity_rea_locale_text_v795.json et ce rapport. Registres enrichis : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Couverture,plan,reprise et notes AI sont actualisés. Aucun code de production ou asset modifié.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision795_locale_text/OBSERVATIONS_VERIFIED.json ; CURRENT_RECEIPT.json dans le même dossier ; revision795_rea_locale_text/observations/3da1a10b-9ea3-4074-a537-c57cccca24b6/receipt.json ; revision795_delivery/.

## Suite et inconnues

Analyser7879A0 et ses consommateurs de texte, puis795D10 et le stockage/recherche du lecteur796350. Relier les clés HUD aux producteurs et widgets courants, les règles de pluralisation/nombres, les polices/glyphes et débordements. Les57fiches CLIENT/AUDIO/LAYOUT des19locales restent hors de ce lot. Les antérieurs tests graphiques/audio ne sont pas des preuves nouvelles ici. Les22tâches restent partielles ; le goal reste actif.
