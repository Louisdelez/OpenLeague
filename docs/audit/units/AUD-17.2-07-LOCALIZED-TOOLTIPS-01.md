# AUD-17.2-07-LOCALIZED-TOOLTIPS-01 — infobulles localisées, audit de l’exigence parente

Date des preuves : 2026-10-30T22:25:57.410316+00:00 → 2026-10-30T22:26:09.888207+00:00. Projet : F:\OpenLeague. Ce document ajoute des conclusions documentaires ; il ne modifie ni le goal, ni ses critères, ni les registres, ni le jeu, ni OpenLeague Plan et ses bases.

Résultat : la disponibilité des références et les limites du consommateur sont établies pour les familles précédemment exclues. La clôture documentaire de cette unité est soumise à la relecture indépendante `delivery-readback.json`. La fonctionnalité SYS-17.2-07 reste ouverte. Aucun pourcentage de jeu terminé ne découle de cet audit.

## R1 — Exigence, périmètre et prérequis

Parent : **SYS-17.2-07 — Afficher les infobulles localisées des capacités et objets** ; exigence **OLF-ea474682-da02-5e40-b0b0-4c3464924e87** ; inconnue **OLU-df7c97bd-60a2-5094-a3a0-9a93877e24c0**. Le registre conserve `a_faire`, `implementation_complete=false`, `acceptance_complete=false` ; l’inconnue conserve `open`. Aucun critère normatif modifié.

Référence : LoL4.20.0.315 PUBLIC Releases/4.20, EUW, en_GB ; catalogue4.20.1. Dépendance du lot D17-SYS-17-2 : D13-SYS-13-3, confidentialité de l’état de jeu, toujours `a_faire`. La présence d’un champ privé ne suffit pas à autoriser son affichage. SYS-07.5-06 et les tâches de localisation restent distincts et ouverts.

Le fragment AUD-17.2-07-TOOLTIP-01 couvrait488références primaires Q/W/E/R,33objets actuels,39références génériques HUD/monde, deux lexiques et cinq sources ActionScript du magasin. Ses exclusions passifs/invocateurs/variantes/catalogue élargi sont traitées ici par inventaire borné, inspection des consommateurs et conditions de reprise. Le fragment ne prouvait pas une fonctionnalité complète ; il est conservé.

Entrées vérifiées : source native déployée sur D:, données4.20 sur F:, ancienne preuve, code courant, identité du goal joint, phase/lot et cinq registres normatifs. Hors portée : implémentation des corrections, fidélité des pixels, politique native non décodée, exécution du jeu, acceptation humaine et reconstruction du reste du jeu.

## R2 — Sources, provenance, inventaire et limites

Les **567 identités de fichiers** de la preuve antérieure ont été relues et comparées ; les trois champs des488QWER n’ont pas été redécodés. La recherche littérale antérieure n’a pas été rejouée : son corpus est inchangé. Les cinq exports AS2 historiques, leur reçu, les39références génériques et les deux archives sont réutilisés ; aucun export ni script ActionScript exécuté maintenant.

Décodeur local existant : `E:\mapslol3v3\tools\import_all_champions.py`, fonctions AST `ini` et `hashkey` uniquement, sans exécuter l’importeur. Il fournit une lecture locale INIBINv2 ; cette réutilisation ne requalifie pas le chargeur natif ni les remplacements UTF-8 du décodeur. Les SHA des statistiques JSON décodées ne sont pas les SHA des INIBIN bruts ; ces dernières identités sont calculées séparément.

| Famille | Périmètre constaté | Ce que ce nombre ne prouve pas |
|---|---|---|
| Q/W/E/R primaires | 488, déjà prouvés ;264sous Characters et224sous DATA/Spells | 488capacités sélectionnées, calculées et présentées |
| Passifs | 122fichiers de base de champion | 122passifs effectivement sélectionnés ou évalués |
| Configurations de sorts | 3237fichiers :1546sous Characters des122champions et1691globaux | 3237sorts jouables ; inclut missiles, buffs, attaques et héritages |
| Complément non primaire | 2724fichiers hors488primaires et hors25Summoner* | 2724variantes visibles ou formes réelles |
| Invocateurs | 25ressources Summoner* ;13entrées du catalogue ;5icônes admises dans HUD actuel | 25invocateurs sélectionnables ni13implémentés |
| Objets | 849fichiers ;280entrées du catalogue officiel4.20.1 ;33chargées par le core ;31admissibles en achat Map10 | 849ou280objets fonctionnels ou achetables sur Map10 |

Les 3 720 lignes de ressources complémentaires sont identifiées individuellement dans le reçu : `passive_rows`, `non_primary_spell_rows`, `summoner_resource_rows`, `item_rows`. Une ressource peut avoir des champs absents, vides ou contenant une copie d’un autre personnage. Ne pas déduire corruption, version active ou rôle UI de son seul nom.

| Champs des fichiers de base | Présents | Absents | Vides |
|---|---:|---:|---:|
| Passive1Icon | 122 | 0 | 0 |
| Passive1LuaName | 122 | 0 | 1 |
| Passive1Name | 121 | 1 | 0 |
| raw_hash_743602011 | 116 | 6 | 0 |

Le nom `Data.Passive1Name` et l’icône ont une hypothèse de nom confirmée par hash. La description est retrouvée au **hash brut743602011** par son contenu `game_character_passiveDescription_*` ; le nom natif de la propriété et son sélecteur effectif demeurent non qualifiés. Les candidats `Passive1Desc`/`Passive1Description` ne correspondent pas à ce hash. Ne pas inventer la propriété ni utiliser `Passive1LuaName` comme sélection runtime.

Absences exactes de cette propriété brute dans la base : **fiddlesticks, heimerdinger, jinx, kalista, vi, volibear**. **volibear** ne porte pas non plus le champ de nom testé. Ce constat ne signifie pas « aucun passif » ni « aucun texte » : des références peuvent appartenir à un autre slot ou fournisseur natif. Reprise : appel natif/sélecteur nommé pour chaque champion, puis source réellement choisie. Les122lignes restent distinctes ; ne pas résoudre les six cas par un texte de secours commun.

Chaque objet du catalogue280 possède les références de nom/description dans les fichiers examinés. Les312champs DynamicTooltip d’objet présents comprennent cinq chaînes vides ;307chaînes sont non vides. Aucune priorité entre Description et DynamicTooltip n’est déduite de leur présence. Le cas3128 est dans le catalogue280, absent des33objets chargés : existence de son texte ne l’admet pas dans la simulation.

### Lexiques : recherche de candidats, pas exécution du moteur de texte

| Locale | Références candidates distinctes | Communes au fragment | Résolues une fois | Absentes | Ambiguës |
|---|---:|---:|---:|---:|---:|
| en_GB | 3811 | 713 | 3037 | 774 | 0 |
| fr_FR | 3811 | 713 | 3037 | 774 | 0 |

Les774candidats absents par lexique proviennent du complément étendu, qui comprend des ressources internes ou historiques. Aucun de ces candidats absents ne concerne les clés candidates des objets du catalogue280, des13invocateurs nommés ou des champs de passif présents examinés. Ils ne sont donc pas774textes requis manquants en partie. Les listes intégrales sont conservées dans `locale_lexical_extension[locale].missing`. Il faut d’abord une preuve que l’une de ces clés est effectivement sélectionnée par le client4.20 avant de rechercher une ressource de substitution.

Les66valeurs non vides ne commençant pas par game_/flash_ restent des littéraux ou références non classés, dans `non_reference_literals`. Elles ne sont pas automatiquement des traductions manquantes. Clé vide, champ absent, clé candidate absente, clé résolue et référence non classée restent des états différents.

Douze exemples bruts sont enregistrés pour Aatrox(passif), EliseSpiderQ, Flash, Heal et objet1004, en_GB/fr_FR. L’index préserve ligne, SHA du texte brut, tokens @...@ et balises. Pas de qualification de lexer natif, échappements, doublons/priorités, fallback de langue, rôle des balises, expressions CompareSystem ou évaluation runtime. DataDragon contient aussi des templates {{...}} : ils ne sont pas interchangeables avec les tokens du client.

## R3 — Consommateurs réels et chaîne manquante

Le corpus de **1 168 fichiers** Rust/launcher est identique à la preuve référencée : membres et SHA comparés. La recherche précédente DynamicTooltip/game_spell_tooltip_/native_tooltips_map10/ObjectTooltips.ini/DynamicMenuText.ini demeure bornée à ses termes et routes inspectées, elle n’est pas une preuve universelle d’absence de code. La nouvelle recherche de Passive1Name/hash743602011/passiveDescription_/passiveName_/game_spell_description_/game_item_description_ dans `crates/client/src/native_hud*.rs` ne trouve aucun consommateur nommé.

| Étape | Acquis observé | Écart restant |
|---|---|---|
| Références sources | Trois champs primaires et inventaire complémentaire identifiés | Sélection native et appartenance visible de chaque référence non prouvées |
| Sélection/admission | Loadout D/F, slots primaires et catalogue limité existent | Passifs, transformations, recasts et priorité Description/DynamicTooltip non raccordés à un consommateur complet |
| Localisation | Chaînes lexicales en_GB/fr_FR et noms actuels français | Sélection de langue, lookup natif, fallback et glyphes de l’infobulle non qualifiés |
| Valeurs dynamiques | Ancien ItemDescription/CompareSystem dans cinq sources AS2 ; calcul actuel de régénération | Pas d’évaluateur arbitraire relié aux stats/rang/niveau/état ; valeur absente peut devenir0 |
| Présentation | Détail d’objet sélectionné dans un Text simple ; icônes HUD et couleurs d’état | Popover au survol/focus, texte riche, placement et durée de vie complète non identifiés sur les routes inspectées |

Sources réellement inspectées, fragments et lignes exactes dans le reçu :
- `F:\OpenLeague\crates\client\src\shop_ui.rs:298` — shop_identity (jusqu’à341).
- `F:\OpenLeague\crates\client\src\shop_ui.rs:368` — shop_selected_detail (jusqu’à441).
- `F:\OpenLeague\crates\client\src\shop_ui.rs:238` — shop_plain_widget (jusqu’à244).
- `F:\OpenLeague\crates\core\src\shop.rs:1` — item_model (jusqu’à48).
- `F:\OpenLeague\crates\core\src\shop.rs:173` — regen_subset (jusqu’à192).
- `F:\OpenLeague\crates\client\src\native_hud_spells.rs:8` — spell_icon_renderer (jusqu’à56).

La boutique sélectionne sur **Interaction::Pressed** ; Hovered choisit un état graphique. Le détail425–428affiche `i.description.replace("{regen_5s}",...)` avec notice de carte. Le type `shop::Item` ne consomme pas `rich_description` ; sa présence dans le JSON n’est pas une mise en forme exécutée. `regeneration_tooltip`174–192calcule seulement la régénération de base par niveau, sans tous bonus/passifs ; `unwrap_or(0.)` dans le client confond indisponible et vrai zéro dans cette route. Le sélecteur de couleur sait traiter hover, mais le renderer d’icônes appelle `color(...,false,false)` ; ce n’est pas une infobulle active.

Acquis de cycle de vie conservés : player retenu pour le bon identifiant/session ; sélection inventory invalidée si l’objet change ; fin de partie ferme le panneau. Le bloc de changement d’identité vide `presentation.inventory`, sans réinitialiser `f.inspected`. Ce constat statique est précis ; aucune contamination visuelle intersession n’a été reproduite. Un futur popover doit posséder sa propre règle d’invalidation, pas hériter implicitement de ce détail persistant.

## R4 — Attendu, observé et vérifications réellement exécutées

**988 contrôles documentaires réussis** dans `verify_tooltips.py`. Ils relisent les entrées, états de registre, identités de sources, corpus, champs décodés et fragments exacts ; leur réussite ne compte pas comme988tests de gameplay.

| Cas | Attendu de l’audit | Observé |
|---|---|---|
| Nominal sources | Expliquer les familles omises et vérifier leurs identités | 122bases,2724compléments,25Summoner*,849items ;488primaires réutilisés |
| Nominal exemples | Lire exactement un texte par langue, sans lui inventer de valeur | 12exemples uniques ; valeurs et balises brutes conservées, non évaluées |
| Absence de champ | Conserver absent au lieu de déclarer le champion incomplet | Nom absent sur volibear ; hashdescription absent sur six bases ; ancien BraumE absent seulement pour DisplayName/Description |
| Clé lexicale absente | Distinguer candidat interne et texte requis | 774candidats absents/locale, aucune ambiguïté ; nécessité UI non prouvée |
| Littéral ou vide | Ne pas transformer toute chaîne en clé | 66valeurs non classées ; champs vides/absents comptés séparément |
| Admission | Ne pas activer un item à partir de sa description | 3128hors33actuels ;31/33admis par contrat Map10, distinct du catalogue280 |
| Consommateur | Relever ce qui existe et ce qui manque | Détail sélectionné et calcul régénération ; pas de preuve de popover complet sur routes inspectées |
| Conservation | Préserver travaux antérieurs, goal, app et bases | 25fichiers protégés, cinq registres et Git conservés ; aucun accès aux bases |

Non exécutés maintenant : compilation ou tests Rust, original LoL, exécution native isolée/REA, AS2, rendu GPU, capture de l’infobulle, souris/clavier réels, réseau, installation ou migration. Aucun binaire du jeu n’a été exécuté. L’interpréteur Python existant est utilisé seulement pour lire les fichiers et écrire ces nouveaux livrables. Aucun besoin de rejouer REA pour compter les références présentes ; une reprise native doit viser un sélecteur précis, avec état nécessaire et résultat discriminant, après avoir réutilisé les anciennes preuves.

## R5 — Écarts et conditions exactes de reprise

| Question ouverte | Ce qui manque | Entrée nécessaire à la reprise / arrêt |
|---|---|---|
| Passif des six bases incomplètes pour les champs testés | Sélecteur et source réellement retenus ; nom natif de hash743602011 | Appel/xref ou témoin natif nommé par champion. Pas de nouveau balayage identique des122bases. |
| Formes/recasts | Rôle UI et ordre de priorité des multiples SpellData | État/form/slot autoritatif et consommateur natif ou contrat local ciblé EliseSpiderQ ; traiter Jayce/Nidalee séparément. |
| 774clés candidates absentes | Rien ne prouve encore leur nécessité en partie | Un appel4.20sélectionnant exactement une clé de la liste ; sinon conserver candidate_absent sans chasse communautaire générique. |
| D/F et valeurs | Rendu de texte et provenance du délai courant, notamment Heal/Smite | Réutiliser audit SUMMONERS et sa limite240/300/90 ; une nouvelle source ou décision explicite avant recherche répétée. |
| Calculs d’objet/capacité | Types/unités/arrondis, états requis et indisponibilité ; pas de moteur complet | Un template et modèle de valeur nommé : EzrealQ ou item1004 ; résultat attendu vs observé, sans0de substitution. |
| Lookup/markup de langue | Priorités/échappements/evaluation, glyphes et retour de langue | Contrat natif ou local explicite par cas en_GB/fr_FR, puis rendu réel. |
| Popover et lifecycle | Cible, ancre, focus, propriétaire, changement de session, taille écran | Un consommateur autorisé et cas visuel instrumenté ; ne pas qualifier avec le détail boutique. |
| État du jeu et permission | Dépendance D13 encore ouverte | Contrat de divulgation pour valeurs affichées ; pas de lecture d’un corps caché par simple présence du champ. |

Ces inconnues n’empêchent pas de constater les limites de la chaîne actuelle ; elles empêchent de déclarer la fonctionnalité fidèle et terminée. L’audit s’arrête au périmètre établi. Aucune accumulation de liens externes, recherche communautaire ou téléchargement sans cette nouvelle entrée discriminante.

## R6 — Corrections réutilisées et compléments atomiques

Sept corrections existantes réutilisées, sans les recopier dans le registre ni les déclarer appliquées :
- `TIP-ABILITY-EZREAL-Q-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-BRAUM-E-PRIORITY-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-ITEM-1004-CALC-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-REGEN-UNKNOWN-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-ITEM-DISABLED-GROUP-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-HUD-ANCHOR-01` — voir le fragment TOOLTIP-01 et ses critères conservés.
- `TIP-LOCALE-RENDER-01` — voir le fragment TOOLTIP-01 et ses critères conservés.

Sept compléments **proposed_not_applied**, rattachés au même parent et à la même inconnue. Ce sont des fiches documentaires ; aucune tâche, case, historique ou base de Plan n’est modifié. Les familles ne sont pas de nouvelles tâches globales « tous les champions ». Le cas Aatrox/Elise/Flash/Heal/3128 reste séparé ; après qualification du mécanisme, chaque champion, variante ou objet encore requis doit conserver son propre identifiant de contenu et sa preuve, dans les lignes du reçu.

### TIP-PASSIVE-AATROX-01

Objectif : Aatrox: relier nom/description du passif au contenu montré.

Écart / limite : Nom Data.Passive1Name et description au hash brut743602011 présents; nom natif de cette seconde propriété et sélection effective non qualifiés. LuaName historique ne prouve pas la sélection.

Critère de fin : Un seul passif sélectionné pour le bon champion/session; texte en_GB/fr_FR et valeurs justifiés; référence absente/ambiguë explicitement indisponible.

Entrée nécessaire à la reprise : Sélecteur natif ou contrat local explicite pour Aatrox, puis contexte actuel et consommateur de popover autorisé. Répéter séparément par ligne des122champions.

Dépendances : `TIP-HUD-ANCHOR-01`, `TIP-LOCALE-RENDER-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-FORM-ELISE-SPIDER-Q-01

Objectif : Elise: sélectionner la référence SpiderQ en forme araignée.

Écart / limite : Fichier et texte ne prouvent pas état de transformation, priorité entre SpiderQ et SpiderQCast ou retour humain.

Critère de fin : Cas humain/araignée, transition et fermeture invalidant le contenu précédent; absence de forme/état refusée sans mauvais Q de secours.

Entrée nécessaire à la reprise : Contrat de sélection forme/slot/session et témoin natif ciblé EliseSpiderQ; variantes Jayce/Nidalee restent des unités distinctes.

Dépendances : `TIP-ABILITY-EZREAL-Q-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-SUMMONER-FLASH-01

Objectif : Flash: présenter son infobulle D ou F selon loadout.

Écart / limite : 25fichiers auxiliaires ne sont pas25sorts sélectionnables; catalogue13 et HUD5admis ne fournissent pas de popover.

Critère de fin : D/F corrects; texte locale et paramètres Flash provenant de source autorisée; loadout absent/retiré invalide le contenu.

Entrée nécessaire à la reprise : Sélecteur loadout D/F et contrat de valeur/rendu Flash; réutiliser audit SUMMONERS, pas une nouvelle recherche générique.

Dépendances : `AUD-17.1-04-SUMMONERS-01`, `TIP-HUD-ANCHOR-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-SUMMONER-HEAL-POLICY-01

Objectif : Heal: rendre explicite la provenance du délai affiché.

Écart / limite : Audit antérieur:240local vs300client; une chaîne native ne résout pas cette différence. Smite90 est aussi provisoire.

Critère de fin : Cas Heal avec politique locale identifiée et vérité native distincte; aucune fidélité native affirmée sur une valeur locale provisoire.

Entrée nécessaire à la reprise : Décision/contrat de référence ou producteur natif qualifié Heal; réutiliser la recherche antérieure plutôt que la relancer.

Dépendances : `AUD-17.1-04-SUMMONERS-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-ITEM-CATALOG-3128-01

Objectif : Objet3128: qualifier séparément contenu et admission.

Écart / limite : 280entrées de catalogue et849fichiers sources ne sont pas33objets actuellement chargés, ni autant d’achats valides Map10.

Critère de fin : Pour cet objet seul: références/locale, admission par carte/contexte et source d’état; si non admis, refus explicite sans activation implicite par présence de texte.

Entrée nécessaire à la reprise : Contrat d’admission et consommateur ciblé de cet objet, au-delà du simple registre de ressources.

Dépendances : `AUD-17.1-05-INVENTORY-01`, `TIP-ITEM-DISABLED-GROUP-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-REFERENCE-CLASSIFICATION-01

Objectif : Classer une référence auxiliaire avant de la traiter comme contenu affichable.

Écart / limite : Fichiers de missiles, buffs, BasicAttack et copies de noms étrangers; champs absents/vides et clés lexicales manquantes ne prouvent pas une corruption.

Critère de fin : Cas EliseSpiderEBuff: nom Pantheon observé conservé, aucun affichage automatique ni remplacement inventé; sélecteur source décide de l’usage.

Entrée nécessaire à la reprise : Nouvel appel/sélecteur natif nommé ou contrat local; pas une nouvelle collecte des mêmes chaînes.

Dépendances : `TIP-FORM-ELISE-SPIDER-Q-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### TIP-POPOVER-LIFETIME-01

Objectif : Fermer/invalider le contenu au changement d’ancre, propriétaire et session.

Écart / limite : Détail boutique persistant et réinitialisation inventory ne prouvent pas un popover; f.inspected ne se réinitialise pas dans le bloc identité inspecté.

Critère de fin : Un cas EzrealQ et un objet1004: ouverture, mise à jour, sortie/suppression d’ancre, perte de focus, changement session, fin de partie; valeur indisponible distincte de zéro.

Entrée nécessaire à la reprise : API/lifecycle du futur consommateur autorisé, anchor ownership et contrat focus/pointeur; capturer attendu/observé à plusieurs tailles.

Dépendances : `TIP-HUD-ANCHOR-01`, `TIP-REGEN-UNKNOWN-01`, `TIP-LOCALE-RENDER-01`.

Contrôles et preuves attendus : Source+selector+expected/observed per named content; unavailable, identity/lifecycle and locale boundaries; actual presentation only after authorized implementation.

Sources/consommateurs et travail : partir de la ligne native identifiée dans le reçu, des fragments R3 et de la correction existante ; qualifier sélection/valeurs puis brancher un seul consommateur seulement dans une intervention d’implémentation autorisée. État : `proposed_not_applied`.

### Quatre dimensions, sans confusion de clôture

| Dimension | État justifié |
|---|---|
| Audit documentaire de cette unité | Couverture des familles, chaîne, écarts et reprises établie ; clôture uniquement si la relecture indépendante valide R1–R7. |
| Implémentation | Partielle : détail boutique et régénération existent ; l’ensemble des infobulles localisées reste ouvert. |
| Vérification | Réussie pour les contrôles documentaires ci-dessus ; comportement/rendu de la fonctionnalité non exécuté ici. |
| Acceptation humaine | Aucune acceptation de la fonctionnalité demandée ou revendiquée. |

Le goal SYS-01.2-02 demeure actif ; cet audit de SYS-17.2-07 ne le termine pas. Aucun écart fonctionnel n’est corrigé dans ce lot. Résultat clôturable : les exclusions du fragment sont désormais inventoriées et reliées aux consommateurs/conditions de reprise, sans source ou réussite inventée.

## R7 — Livrables, identités, conservation et relecture

Nouveaux fichiers uniquement :
- [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01/audit-unit.json) — périmètre avant exécution.
- [verify_tooltips.py](F:/OpenLeague-work/audit-units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01/verify_tooltips.py) — lecteur d’audit et contrôles.
- [tooltips-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01/tooltips-proof.json) — reçu brut et lignes sources.
- [AUD-17.2-07-LOCALIZED-TOOLTIPS-01.md](F:/OpenLeague/docs/audit/units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01.md) — présent rapport.
- [verify_delivery.py](F:/OpenLeague-work/audit-units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01/verify_delivery.py) — relecture indépendante sans importer le producteur.
- [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.2-07-LOCALIZED-TOOLTIPS-01/delivery-readback.json) — résultat de relecture R1–R7, produit séparément.

Preuve brute : F:\OpenLeague-work\audit-units\AUD-17.2-07-LOCALIZED-TOOLTIPS-01\tooltips-proof.json ; **8150490 octets**, SHA-256 **73f1b5d3f3b743d812eb51589aec34037886fcf24e0fd23813c91eadb853c1d5**. Son `audit_scope_closed=false` est intentionnel : le producteur ne prononce pas sa propre clôture. Le reçu indépendant décide seulement de la clôture documentaire de ce lot, pas de l’état du registre.

Git : main, HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,76fichiers suivis déjà modifiés, état conservé avant/après. **19 fichiers logiciels gelés** et **six documents de contexte/méthode**, soit25fichiers protégés, inchangés ; **cinq registres normatifs** inchangés. Anciennes preuves et versions échouées conservées. Aucune base ouverte ; aucun lancement de Plan, serveur, Store, CLI de suivi ou migration. Aucun retrait de l’intervention gelée.

Relecture : contrôler les identités, refaire la lecture bornée des champs et lexiques sans import du producteur, vérifier les fragments réels et les absences/refus, les sept rubriques, les corrections non appliquées et la conservation. Le lecteur peut être utilisé avec `--check-only` pour ne pas écrire de nouveau reçu ; ne pas rejouer un contrôle inchangé sans raison nouvelle.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.2-07-LOCALIZED-TOOLTIPS-01\verify_delivery.py' --check-only
```

Condition d’arrêt : terminer après cette relecture documentaire ; ne poursuivre les inconnues qu’avec les entrées discriminantes de R5, sans modifier le goal ou les critères. Le prochain lot de l’audit doit prendre une autre exigence non couverte et réutiliser ce reçu. Aucun statut global n’est modifié ici.
