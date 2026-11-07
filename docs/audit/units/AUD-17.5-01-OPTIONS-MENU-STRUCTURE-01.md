# AUD-17.5-01-OPTIONS-MENU-STRUCTURE-01

Date UTC : 2026-11-01T07:08:34.713354+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Périmètre et décision

Audit des19rôles physiques data/group/textfield du Menu : 1racine de libellés,17groupes et1description audio. Les67contrôles,32descripteurs et5panneaux restent acquis avec leur portée antérieure. Aucun nouveau contrôle enfant compté. Les3includes,3présentations et36nœuds Phreakspace restent hors de cette clôture. Le parent et le goal restent ouverts.

Audit : prêt pour relecture distincte. Implémentation : partielle/non qualifiée pour cette composition. Vérification : documentaire. Acceptation humaine : non demandée. La clôture documentaire est décidée uniquement par delivery-readback.json après code0 et contrôle des liaisons.

## 2. Sources historiques et provenance

XML physique 4.20 Menu_SC4 et catalogue de357nœuds existant, GFX et PE d’origine, exports AS déjà conservés, locale en_GB identifiés dans la preuve. Aucun nouvel export, désassemblage ou exécutable original. Les groupes et textes réutilisent les fenêtres de KEYGRID-STRUCTURE et KEYSECTIONS ; leurs résultats antérieurs ne sont pas annoncés comme réexécutés. Trois fenêtres AS textuelles bornées raccordent les labels racine, avec chevauchement des preuves SAVE conservé.

|Ligne|Rôle|ID|Attributs propres|
|---:|---|---|---|
|2|data|OPT-SRC-cdcd45840424311b|{"saveLabel": "flash_optionsMenu_save", "cancelLabel": "flash_optionsMenu_cancel", "surrenderLabel": "flash_optionsMenu_surrender", "defaultsLabel": "flash_optionsMenu_defaultsLabel", "exitLabel": "flash_optionsMenu_exitGame", "titleLabel": "flash_optionsMenu_title"}|
|11|group|OPT-SRC-f68a57615ce7e99f|{"layout": "twoPerLine"}|
|21|group|OPT-SRC-50cece95232c196d|{"label": "flash_optionsMenu_lbl_graphicsSlider", "style": "header"}|
|57|group|OPT-SRC-ee9374ece841b5ef|{"label": "flash_optionsMenu_kblbl_advancedVideo", "style": "header", "paddingtop": "10"}|
|74|group|OPT-SRC-fb4a1ad230cad8a5|{"strategy": "savecfg"}|
|87|textfield|OPT-SRC-80b57208f9f0d4e9|{"label": "flash_optionsMenu_kblbl_disableAllSoundDescription", "style": "info"}|
|92|group|OPT-SRC-90038d863185425c|{"label": "flash_optionsMenu_lbl_scale", "style": "header", "paddingtop": "-15"}|
|97|group|OPT-SRC-58d657f39776b485|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_healthAndResourceBars", "style": "header"}|
|105|group|OPT-SRC-2fd08d44d8267078|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_alerts", "style": "header"}|
|111|group|OPT-SRC-28d86f6668263dd4|{"onlyshowif": "alienware", "label": "flash_optionsMenu_lbl_alienwareOptions"}|
|115|group|OPT-SRC-54e7affdd2d3c9f1|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_abilityAndAttackDisplay", "style": "header"}|
|121|group|OPT-SRC-12cecd04f1220cd7|{}|
|130|group|OPT-SRC-d3a2ca2371847971|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_minimap", "style": "header"}|
|136|group|OPT-SRC-2e532b29d28811c9|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_chat", "style": "header"}|
|141|group|OPT-SRC-bf62f6372da8595e|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_floatingText", "style": "header"}|
|160|group|OPT-SRC-2b7b9790b918cae9|{"label": "flash_optionsMenu_lbl_controls", "style": "header", "paddingtop": "-15"}|
|165|group|OPT-SRC-14056858024b1b5e|{"onlyshowif": "replay"}|
|171|group|OPT-SRC-82ff94c1740bd0be|{"layout": "twoPerLine"}|
|177|group|OPT-SRC-d078083643f75827|{"layout": "twoPerLine", "label": "flash_optionsMenu_lbl_gameplay", "style": "header"}|

## 3. Consommateurs et contrats

Group → ModelGroup/ViewGroup/mcGroup ; texte → ModelTextfield/ViewLabel/mcLabel. Le tag data n’est pas une fabrique application automatique. Le chemin de production reçoit InitializationData.xml comme objet ; le chargeur XML de debug reste distinct. L’héritage est limité à INISECTION/STRATEGY/PREPENDNOLABELEVENTS, seulement si l’enfant ne possède pas déjà cet attribut.

Les9groupes twoPerLine sélectionnent la stratégie de layout source. Le style header ajoute son padding ; les paddings propres10/-15 restent conservés. Un groupe sans label retire son champ optionnel. La description audio est une rangée de texte, sans nouvelle préférence. Le groupe74 contient9descendants physiques sans override de stratégie : 7curseurs, EnableAudio86 et sa description87. La présentation du texte ne crée pas de préférence. Cela ne prouve ni admission effective ni écriture réussie.

Les six labels racine correspondent à Save/Cancel/Surrender/Exit/Defaults et au titre. Le code pousse les5premiers dans cet ordre ; le titre est affecté séparément. Les sites examinés n’appellent pas explicitement LocalizeText : le contenu exact du payload et son producteur restent à qualifier, sans bug de traduction déduit. Save et Surrender sont initialement désactivés ; Surrender est conditionné au contexte source INGAME/GFXPLAYER et caché sinon. Ce ne sont pas des observations de bouton réel. La petite croix est reliée à Annuler.

Les9fenêtres du consommateur actuel (entrée/F11/input/HUD/settings) sont reprises et revérifiées contre leurs fichiers réels. Les requêtes nominales antérieures restent identifiées ; elles ne sont pas relancées. Leur absence de résultats ne prouve pas une absence globale de framework ou de comportement. La composition précise du Menu courant reste non qualifiée.

## 4. Attendu, observé et contrôles

- 19roles nominaux — attendu : 1data+17groupes+1texte, octets et locales exacts, aucun nouveau contrôle enfant. Observé : 19identités vérifiées, sources de fabrique et locales liées, zéro nouveau contrôle ; exécution produit non effectuée.
- Frontière audio — attendu : Le groupe74 transmet sa stratégie aux descendants sans override ; EnableAudio86 reste dans ce groupe. Observé : Neuf descendants physiques sans override : sept curseurs, EnableAudio et sa description ; effet et persistance non exécutés.
- Conditions et présentation — attendu : Conserver alienware/replay, padding10/-15 et absence de label ; ne pas inventer une admission ni des mesures. Observé : Attributs exacts et branches source liés ; admission, glyphes, positions et dimensions non qualifiés.
- Six labels racine et actions — attendu : Ordre Save/Cancel/Surrender/Exit/Defaults, titre séparé ; ne pas assimiler label et action réussie. Observé : Affectations exactes et conditions source reliées ; cycles hérités conservés, traduction du payload et boutons réels non observés.

Contrôles nouveaux : identités/octet des19déclarations, locales, parentés, attributs, fenêtres source/consommateur, références des anciens cycles, corpus1168, Git et25fichiers protégés/5registres avant/après. Producteur et lecteur documentaire distincts ont leurs propres scripts, sorties et codes réels. Aucun jeu/AS/Rust/GUI/réseau exécuté ou émulé ; aucun nouveau test produit.

## 5. Écarts et conditions de reprise

- MENU-STRUCTURE-TREE — manque : La composition effective, l’enveloppe data, les contextes admis et le provider de production ne sont pas qualifiés par les fichiers physiques ou le chargeur debug. Reprise : Entrée nommée InitializationData.xml/producteur ou schéma local explicitement versionné ; réutiliser les preuves HOST et des panneaux, sans nouvelle recherche générique inchangée.
- MENU-STRUCTURE-RENDER — manque : Disposition, glyphes, mesures, retour à la ligne, clipping, padding signé, focus et ressources ne sont pas observés dans un menu réel. Reprise : Menu et renderer autorisés avec assets et viewport identifiés ; cas normal/texte long/label absent/deux colonnes/ressource absente ; ne pas convertir le code de layout en mesure observée.
- MENU-STRUCTURE-LABEL-ACTIONS — manque : Les sites d’affectation ne prouvent pas où les six labels racine sont traduits, ni leurs événements exécutés ; providers et effets/persistance conservent leurs limites héritées. Reprise : Payload et provider de texte nommés, puis observations autorisées des boutons réels et des cycles existants ; ne pas conclure à un bug de traduction à partir de clés XML seules.

## 6. Corrections précises

HUD-OPTIONS-MENU-STRUCTURE-01 est proposée, non appliquée : assembler les19rôles ci-dessus. Réutiliser HUD-OPTIONS-KEYGRID-STRUCTURE-01 pour les primitives, HUD-OPTIONS-ENTRY-01 et HUD-OPTIONS-PANELS-01 pour l’entrée et les panneaux ; conserver les critères SAVE/CANCEL/DEFAULTS et leurs inconnues. Aucun nouvel objectif de bouton ou préférence ajouté à partir d’un libellé.

- Les19identités ont un rendu ou un refus explicite dans un menu réel identifié ; ordre, styles, titres absents, padding positif/négatif et texte multiligne ont attendu/observé.
- Les contextes alienware et replay sont admis ou refusés selon une entrée nommée ; une condition non qualifiée n’est pas activée arbitrairement.
- Les six libellés utilisent un provider identifié ; labels manquants et sprites absents ont une politique explicite ; aucune hypothèse de traduction tirée des seuls sites d’affectation.
- La présentation seule ne modifie ni binding ni préférence ; les mutations audio, Save, Cancel et Defaults restent vérifiées dans leurs scopes existants ; EnableAudio conserve sa stratégie héritée du groupe audio et le texte reste non interactif.

Reprise de la correction : Autorisation produit distincte, menu/arbre/provider identifiés ; réutiliser les preuves de primitives et cycles sans relancer la même recherche.

## 7. Livraison, intégrité et suite

Dossier de preuves : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MENU-STRUCTURE-01. Main : menu-structure-proof.json ; relecture : delivery-readback.json ; reçus : producer-execution.json et reader-execution.json. Le producteur ne s’auto-déclare pas clos. Les scripts et références identifiés permettent une relecture sans exécution originale. Les preuves antérieures sont conservées.

Un premier contrôle a échoué : il attendait seulement7descendants du groupe audio. Le XML et les parentés montrent9descendants, dont EnableAudio et sa description. L’échec et son script sont conservés ; la version2 corrige l’attendu sans masquer le contrôle. Aucun main/rapport n’a été produit par la tentative échouée.

Les19associations de rôle complètent la partition documentaire locale : 67+32+5+19+6=129. Ce n’est ni un taux de jeu terminé ni la clôture de l’option menu. Prochain lot : AUD-17.5-01-OPTIONS-MENU-INCLUDE-BOUNDARIES-01 (3includes physiques). Les3présentations et36nœuds Phreakspace restent distincts.

Aucune modification du goal, des critères normatifs, du Plan, de l’interface, des bases ou des registres. Aucune installation, migration, restauration ou relance. Les76modifications suivies antérieures restent conservées.
