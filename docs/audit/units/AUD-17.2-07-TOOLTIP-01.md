# AUD-17.2-07-TOOLTIP-01 — Sources d'infobulles et frontière de présentation

Contrôle du 30 octobre 2026 ; reçu à 13:17:28 UTC. Parents SYS-17.2-07 « Afficher les infobulles localisées des capacités et objets » et SYS-07.5-06 « Afficher l’infobulle et les conditions d’utilisation d’un actif ». Résultat documentaire de SYS-01.2-02. Aucun changement du Goal, du jeu, du suivi, des registres du plan ou de leurs bases.

## 1. Périmètre, critères de fin et décision

Question : les références et textes d'infobulle sont-ils disponibles pour les quatre capacités principales des 122 champions et les 33 objets du catalogue courant ; quelles étapes consomme réellement le client ?

Critères : comparer les trois champs de texte des 488 lignes de capacités aux INIBIN fournis ; retrouver les clés dans en_GB/fr_FR ; identifier les sources des objets et le constructeur historique de leurs descriptions ; comparer le détail sélectionné de boutique et les consommateurs HUD actuels ; préciser les vrais manques, les absences de champs et les conditions de reprise.

**Audit terminé pour ces sources et leur frontière de consommation actuelle.** La disponibilité des modèles est établie ; leurs producteurs dynamiques et leur présentation complète ne le sont pas. Les tâches parentes restent ouvertes.

| Dimension | État |
|---|---|
| Audit | Terminé pour les champs, clés et consommateurs du périmètre explicite |
| Implémentation | Détail de boutique partiel ; pas de moteur général d'infobulle identifié pour les icônes de capacités/inventaire dans les routes inspectées |
| Vérification | Décodage local, jointures lexicales, identités et source de code contrôlés ; aucune exécution de modèle, du client natif, d'ActionScript ou de rendu |
| Acceptation humaine | Non demandée |

Les passifs, invocateurs et variantes/recasts/formes ne font pas partie des 488 lignes. Une ressource par slot Q/W/E/R n'est pas un kit complet. Les conditions serveur de chaque actif et tous les objets hors catalogue courant restent distincts.

## 2. Sources et provenance

### Champs des capacités et objets

`data/4.20/native_spells_420.json` contient 488 couples champion/slot uniques, soit exactement quatre slots 0..3 pour 122 champions. Pour chaque ligne, le fichier INIBIN fourni désigné par native_resource est lu directement. Trois champs du groupe SpellData sont comparés : DisplayName, Description, DynamicTooltip.

Le décodeur local déjà utilisé, fonctions ini/hashkey de `E:/mapslol3v3/tools/import_all_champions.py`, est réutilisé par extraction AST de ces deux fonctions seulement. Aucun code global de l'importeur n'est exécuté. Tous les fichiers examinés sont de version2. Ce contrôle porte sur les données décodées ; il ne requalifie pas indépendamment tout le parseur INIBIN ni le chargeur original. Le SHA d'une ancienne source JSON indiqué dans l'agrégat n'est pas assimilé au SHA du binaire natif : les identités des INIBIN sont relevées séparément dans le nouveau reçu.

| Champ | Présent dans les INIBIN et égal à l'agrégat | Absent du fichier INIBIN |
|---|---|---|
| DynamicTooltip | 488 | 0 |
| DisplayName | 487 | 1 |
| Description | 487 | 1 |

Les deux champs absents concernent Braum, slot2, BraumE. DynamicTooltip est présent et pointe vers game_spell_tooltip_BraumE. Son modèle contient déjà un titre titleLeft, Unbreakable en en_GB / Incassable en fr_FR. **Ce n'est pas une infobulle entière introuvable.** La priorité ou le fallback historique des champs séparés demeure à qualifier ; aucune clé n'est inventée pour les remplir.

Les 33 objets de `shop_foundation.json` reçoivent chacun leur source INIBIN et leurs clés Data/DisplayName et Data/Description. Les noms actuels correspondent toujours aux textes fr_FR. Les sources des objets 1018, 1051 et 1053 sont retrouvées dans `native_inventory_icons.json` : leur entrée de fondation ne porte pas source_sha256, mais le manifeste conserve item_source/item_sha256. Le catalogue du jeu est préservé.

### Textes de langue et fichiers génériques

Les fichiers fournis sont `DATA/menu/fontconfig_en_GB.txt` (SHA256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`) et `fontconfig_fr_FR.txt` (SHA256 `47429564a76830c2cb5a05f7cdad0c62e987532a71789347dccef8322f4d4562`), sous le deploy 0.0.1.68 du client 4.20 sur D.

Chaque profil donne 12704 clés lexicales uniques. Les 1570 clés nécessaires sont retrouvées une seule fois dans chacun : 1462 références de champs de capacités, 66 d'objets, 39 de fichiers génériques et trois libellés du contrôleur de boutique. Ces 3140 jointures ne constituent pas une traduction effectivement affichée.

La lecture utilise les lignes physiques et accepte les espaces/tabulations autour du signe égal et après la valeur. Elle conserve le contenu brut entre guillemets. Une règle trop stricte ne reconnaissait que 12494 déclarations, notamment en excluant la référence XerathArcaneBarrage pourtant présente. L'absence issue de ce filtre n'est pas retenue. Le relevé final reconnaît les 12704 clés ; aucune des 1570 clés interrogées n'est manquante. Échappements, priorité du dictionnaire natif, évaluation et rendu restent des questions différentes.

Deux membres HUD.zip sont aussi comparés entre la copie courante et la copie fournie : ObjectTooltips.ini (15 clés) et DynamicMenuText.ini (24 clés). Le premier décrit des relations d'objets du monde, comme minion/tourelle/champion ami ou ennemi ; il ne représente pas les 33 objets d'inventaire. Le second décrit l'aide du HUD, des attributs et boutons. Leur présence ne prouve pas un branchement aux consommateurs actuels. La qualification de release/montage des ZIP conserve sa limite V226.

### Constructeur historique de boutique

Source : `DATA/Menu_SC4/FoundryItemShop.gfx`, 103724 octets, SHA256 `4aa0368dcd3713d2ccf40439a9482166b597422e8090ae0eff21c4b65063fbee`. Son appartenance au manifeste sélectionné est héritée de `docs/reference_champion_shop_ui_sources/champion_shop_ui-links.json`, sans nouvelle qualification de priorité de chargement.

Cinq sorties de l'export du 14 octobre 2026 à 11:17:29 UTC sont rehashées contre leur reçu d'extraction : tips/Tooltip.as, itemdata/ItemDescription.as, itemdata/description/ComplexNode.as, itemdata/ItemModel.as et Language.as. Le reçu est sous `E:/mapslol3v3/historical_ingame_shop_extraction/fc249aeaf6104972ab607bc87cd6ce40/receipt.json`. Aucun exporteur, Java, FFDec ou ActionScript lancé ici.

Ces sources décompilées établissent des intentions et frontières de code. Elles ne constituent pas l'exécution du runtime historique ni la reconstitution du constructeur d'infobulles des capacités en C++.

## 3. Consommateurs réels et comportement actuel

### Chaîne historique d'objet relue

- Tooltip.as:234-247 affecte le nom et l'icône puis choisit la description : préfixe localisé d'objet désactivé, style groupLimit actif lorsque la limite est atteinte, ou description normale. Les modes de vente utilisent aussi des libellés localisés ; redrawTooltip reçoit une position.
- ItemDescription.as:16-40 découpe les blocs calc et demande CompareSystem.convertStringToCompareNode ; les segments sont recomposés.
- ComplexNode.as:18 retourne node.evaluate().toString(). Le texte est donc susceptible de dépendre d'une expression et de données, pas seulement d'un nom récupéré dans un dictionnaire.

Ces appels ne démontrent pas toute la grammaire, les données fournies par l'hôte, les conditions d'actif ou le résultat graphique. Aucun calcul arbitraire de ce moteur n'est exécuté dans cet audit.

### Boutique Rust et HUD actuels

`shop_ui.rs:419-438` remplit les rôles Text. Detail, lignes 425-428, présente la description simplifiée de l'objet sélectionné, remplace uniquement regen_5s, puis ajoute un avis local de disponibilité Map10. La sélection dépend des interactions Pressed, pas d'un affichage général d'infobulle au survol ; les états Hovered servent notamment au style de contrôles. Les systèmes setup/update sont enregistrés dans main.rs.

`native_hud_spells.rs` charge quatorze widgets d'icône Q/W/E/R/D/F et leurs états. Le code lit notamment ManaCost, pas DynamicTooltip. La couleur reçoit hover=false dans la branche inspectée et aucun Text d'infobulle n'y est créé. `native_hud_inventory` ne produit comme texte que les quantités déjà auditées dans COUNT-01 ; son glisser-déposer n'est pas assimilé à une infobulle.

Le corpus de 498 sources client reste identique à HUD-01 et les trois sélecteurs de glyphes restent ceux déjà qualifiés. La recherche des littéraux DynamicTooltip, game_spell_tooltip_, native_tooltips_map10, ObjectTooltips.ini et DynamicMenuText.ini dans crates ne trouve aucune occurrence. Cette recherche complète la relecture des routes ; elle n'est pas une preuve globale contre tout alias ou code généré Rust.

Le chargement de fontconfig et l'existence des modèles n'équivalent pas à leur résolution, ni à un calcul des tokens Level/Hotkey/Cost/valeurs de sorts, ni à leur rendu enrichi. Les modèles d'Ezreal Q, Braum E et Xerath W sont conservés comme exemples source dans le reçu, avec les limites de contexte/rang/variante.

### Quatre descriptions de régénération

Les objets 1004, 1006, 3801 et 3114 utilisent regen_5s. `core/shop.rs:174-192` calcule une valeur à partir des croissances du champion, du niveau et des bonus de l'objet, puis arrondit. `shop_ui.rs:426` applique unwrap_or(0.) si le joueur ou ce calcul manque, puis formate ce zéro comme une valeur normale.

Un zéro peut aussi être un résultat réel pour un champion sans mana. Le chemin ne distingue donc pas « valeur calculée nulle » et « donnée indisponible ». C'est un constat de code, pas une reproduction graphique nouvelle ni une preuve que toutes les valeurs de régénération sont fausses. Aucun champ de données ni fallback n'est corrigé implicitement ici.

## 4. Contrôles exécutés et résultats attendus/observés

Vérificateur final : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.2-07-TOOLTIP-01/audit_tooltip_sources.py`, code 0.

Premier passage conservé : code1, KeyError source_sha256, parce que le nouveau vérificateur supposait ce champ présent pour tous les objets. Les trois exceptions ont été inspectées ; leurs preuves existaient dans le manifeste d'icônes. Seul le vérificateur a été corrigé. Sa première version est conservée et identifiée dans verification_attempts du reçu ; ce refus initial n'est pas masqué par le succès final.

| Contrôle | Attendu / observé |
|---|---|
| Périmètre des capacités | 488 couples uniques, 122 champions, slots0..3 par champion : conforme |
| Champs INIBIN | 1462 valeurs présentes égales à l'agrégat ; deux absences natives cohérentes pour BraumE : conforme, sans comblement |
| Clés dans les deux langues | 1570 références uniques par profil ; 12704 clés lexicales par fichier ; toutes les références interrogées trouvées |
| Objets | 33 sources et 66 clés établies ; noms fr_FR identiques ; trois provenances réutilisées au lieu de supposer une source perdue |
| Sources génériques | 15 clés du monde et 24 d'aide HUD ; copies ZIP identiques ; rôle distinct des objets d'inventaire |
| Boutique historique | GFX, reçu et cinq scripts exportés conformes aux empreintes ; export/rendu/ActionScript non rejoués |
| Consommateurs | Détail sélectionné partiel confirmé ; aucun producteur général d'infobulle identifié dans les routes inspectées |
| Régénération inconnue | Chemin None→0 confirmé dans le code ; pas de nouvelle exécution ni assimilation à un vrai zéro |
| Conservation | 19 fichiers logiciels gelés identiques à WITHDRAWAL_INVENTORY.json ; aucune base ouverte |
| Relecture indépendante | Cardinalités, clés, absence BraumE, provenances, héritage et absence d'exécution cohérents : PASS |

Le fichier `native_tooltips_map10.json` est aussi qualifié pour éviter une fausse preuve : ses 22 lignes correspondent à leur source en_US (SHA256 `315319cfeb654fe3c404de9551c95e16ee046f5f291de9c10583ad10ab97787d`) ; elles comprennent dix annonces, neuf textes de buffs et trois conseils Treeline. Ce n'est pas un composant d'infobulle exécuté ni une preuve de sélection de la référence en_GB. Aucun des motifs de consommation recherchés dans crates ne le charge.

Contrôles non exécutés : compilation/tests Rust, affichage au survol ou focus, évaluation des expressions, callbacks natifs, coûts/charges dynamiques en partie, réseau, ActionScript, comparaison des pixels et acceptation utilisateur. Les nombres de références trouvées ne sont pas des nombres d'infobulles entièrement réalisées.

## 5. Écarts et inconnues restant ouverts

Les principales données de texte de ce périmètre sont disponibles. Aucun téléchargement, logiciel ou génération d'image supplémentaire n'est nécessaire pour établir cette disponibilité. L'écart actuel ne se résume donc pas à récupérer de nouveau les mêmes fichiers.

Restent à qualifier ou réaliser : identification du champ/événement au survol ou focus ; contexte propriétaire/cible autorisé ; choix de rang/variante ; évaluation des tokens, conditions et expressions ; priorité des champs et des clés ; texte riche/style ; langue effectivement sélectionnée ; placement et fermeture ; rendu et cas limites. Le détail de boutique actuel ne constitue pas ces étapes à lui seul.

Les deux champs absents de BraumE sont natifs ; le modèle dynamique reste présent et traduit. Les champs absents n'impliquent pas une ressource complète perdue. De même, le fichier Map10 en_US, les 39 clés génériques et les marqueurs SpellToolTip ne prouvent pas un moteur d'infobulle fonctionnel.

Les formats/échappements de l'index lexical ne sont pas les résultats du TokenParser/dictionnaire natifs. Les audits antérieurs CALLBACK/PROVIDER/MOUNT/STATE restent conservés avec leurs propres limites ; ils ne sont pas rejoués ni promus en validation de ces milliers de textes.

Inconnues existantes : SYS-17.2-07, `OLU-df7c97bd-60a2-5094-a3a0-9a93877e24c0` ; SYS-07.5-06, `OLU-2d4f9474-8ee4-53bb-b0c5-e9c95688c312`. Elles restent ouvertes. Le présent résultat ajoute la preuve documentaire de disponibilité et les frontières de consommation sans modifier leurs registres.

## 6. Corrections précises et conditions de reprise

Ces clauses sont documentaires, sous les tâches existantes. Chaque capacité/objet nommé se traite séparément ; la première réalisation ne clôture pas les 488 références ou tout le catalogue.

| Clause / rattachement | Résultat unique et critère de fin | Entrée nécessaire |
|---|---|---|
| TIP-ABILITY-EZREAL-Q-01 / SYS-17.2-07 | Premier modèle nommé : Ezreal Q, rang/état identifiés, en_GB ; résoudre uniquement ses tokens avec valeurs autorisées, puis vérifier ouverture, mise à jour et fermeture de son infobulle | Producteur d'événement, contrat des tokens du modèle et source de chaque valeur. Préserver la distinction avec le gameplay du sort |
| TIP-BRAUM-E-PRIORITY-01 / SYS-17.2-07 | Qualifier séparément le rôle des champs absents et de titleLeft du modèle dynamique ; fin : règle de priorité/fallback sourcée, sans inventer de clés | Appelant natif ou contrat local explicitement nommé ; le texte de l'infobulle est déjà disponible |
| TIP-ITEM-1004-CALC-01 / SYS-07.5-06 | Pour l'objet1004, relier l'expression source et sa donnée de régénération au résultat affiché ; vérifier niveau, unité/arrondi, donnée absente et vrai zéro | Contrat CompareSystem ou équivalent local délimité et autorité de la statistique ; ne pas considérer regen_5s comme un évaluateur général |
| TIP-REGEN-UNKNOWN-01 / SYS-22.1-05, SYS-17.2-07 | Distinguer donnée indisponible et résultat nul pour les quatre descriptions concernées ; fin : cas manquant et zéro réel explicitement contrôlés, comportement choisi documenté | Politique de présentation de l'inconnu et états de session/identité ; ne pas remplacer automatiquement un vrai zéro |
| TIP-ITEM-DISABLED-GROUP-01 / SYS-07.5-06 | Pour un objet nommé, présenter son motif désactivé/limite de groupe avec donnée et style source ; fin : autorisation/refus, mise à jour et fermeture vérifiés | État autoritaire et règle de groupe propres à cet objet ; les branches ActionScript ne sont pas des règles du serveur Riot |
| TIP-HUD-ANCHOR-01 / SYS-17.2-07 | Déterminer le rôle d'ancrage de SpellToolTip/StatusMessageToolTip, puis placer un cas nommé sans confondre marqueur et texte affiché | Reprise des deux définitions déjà classées dans CONTEXT-01 et du producteur de tooltip ; aucun besoin de les récupérer à nouveau |
| TIP-LOCALE-RENDER-01 / SYS-22.1-04/06, SYS-17.2-07 | Après branchement d'un cas nommé, comparer en_GB/fr_FR, markup, valeurs, focus/survol, bord de fenêtre et texte long ; fin : identités des ressources/binaires et rendu attendu/observé | Service de texte et valeurs explicitement définis ; styles, glyphes et débordement vérifiés sur le consommateur réel |

Ne pas rouvrir une recherche de sources pour les 488 modèles disponibles. Pour les étapes natives inconnues, rechercher un appelant, une trace ou un contrat nouveau précis. En l'absence d'une telle piste, conserver la limite et poursuivre une autre unité du goal au lieu d'accumuler des liens identiques.

## 7. Livraison et relecture

Fichiers créés uniquement :

- `F:/OpenLeague/docs/audit/units/AUD-17.2-07-TOOLTIP-01.md`, ce résultat.
- `F:/OpenLeague-work/audit-units/AUD-17.2-07-TOOLTIP-01/audit_tooltip_sources.py`, 17473 octets, SHA256 `24db43add96dc0a5e2415139d1d173e6ce14eaef00e4d6b06630b2c0433c12c1`.
- `F:/OpenLeague-work/audit-units/AUD-17.2-07-TOOLTIP-01/audit_tooltip_sources.initial.py`, 16552 octets, SHA256 `a43239896468a801a97efbf8820260a7492deceec8fb19d7d4737bb23b49ccb2`, première tentative conservée.
- `F:/OpenLeague-work/audit-units/AUD-17.2-07-TOOLTIP-01/tooltip-sources-proof.json`, 2148145 octets, SHA256 `190660972a6cc6d433a8ba25eb2dc514e8f6775ad9e8ef74877de05394a1b269`.

Le JSON conserve chaque couple champion/slot et ses trois champs, les 33 objets, les 39 clés génériques, les jointures lexicales avec lignes/empreintes/tokens/tags, quelques modèles source non évalués, les cinq scripts, l'artefact Map10, les ancres de consommateurs, le premier refus corrigé et les inconnues existantes. Les preuves antérieures ne sont pas remplacées.

Les sept rubriques de clôture sont renseignées pour cette portée. Audit terminé ne signifie pas infobulles implémentées, champion terminé ou jeu complet. Goal, code du jeu, application de suivi, registres du plan et bases non modifiés par ce lot ; aucun logiciel installé, aucune migration et aucune case cochée.
