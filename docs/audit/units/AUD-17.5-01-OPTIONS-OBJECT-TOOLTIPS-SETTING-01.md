# AUD-17.5-01-OPTIONS-OBJECT-TOOLTIPS-SETTING-01 — ObjectTooltips

## R1 — Portée et décision

Checkbox ligne108, source des aides de survol pour nouveaux joueurs et consommateurs actuels. Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur seul non clôturant, relecture distincte attendue. Fonctionnalité incomplète, rendu/runtime non vérifiés, acceptation humaine non demandée. Ni toutes les infobulles, ni le seul mode d’entraînement déduits du nom.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index/export AS épinglés. en_GB770 : Show New Player Tooltips. Deux defaults73=1, autres configs fournis sans clé exacte ; ctorargument1/GFXfallback0/provider effectif séparés.

Source HUD.zip/ObjectTooltips.ini1005bytes SHA256 `e7aa3ab38e5c4c822c3205e86ed671ae06c138c9960daf84f2c2625880681bae` déjà recensée :15relations sur Champion,Minion,Turret,HQ,Inhibitor,Shop,SpawnPool. Deux archives natives/copieF identiques et membre/index relus, aucun nouvel export. Les15clés/localisations en_GB sont reprises de l’audit antérieur : métadonnées lexicales, aucun placeholder dynamique, markup non évalué. Pas de contenu à recréer ni de moteur général de calcul de statistiques requis par ces seuls textes statiques.

Audits tooltip source/consumer-boundary et localized-tooltip réutilisés, sans rejouer567identités,488décodages ou ancien lecteur/export. Leur périmètre et sa clôture propre sont conservés ; ce n’est pas une clôture du présent réglage SYS17.5. Audit target et corrections de sélection/popover réutilisés sans réouverture ni modification.

## R3 — Contrat et consommateurs réels

**Menu.** savecfg explicite, pas de updateonclick sur contrôle/ancêtres. Sentinel stringnull ne satisfait pas le gate live. Canonical0/1, NEGATEVIEW, CLIK et journal/Save réutilisés ; source ≠ clic physique, acquittement ou fichier durable.

**Natif.**81F0F8 lit HUD/ObjectTooltips avec argument1 et stocke au byteF4.81F55C captureEDI/820B70 dans un wrapper16bytes/extra0 et enregistre la clé.820B70 convertit via6F5930 puis écrit ownerF4. Si vrai, aucune ouverture explicite ; si faux et enfantD8 existe, requête7939B0(closeTooltip,chaîne vide) puis enfant1B1=0. Si enfant absent, pas de close mais flag changé. Ni requête ni marqueur ne prouvent une fermeture visible.

826240 résout ObjectTooltips.ini via objet ressource2D78F1C+38/vtable1C et cache le pointeur de chaîne2D8282C avec garde bit0 ; extraction inline/heap selon capacity14>=16. Cela ne prouve ni un objet config déjà parsé ni la sélection/montage/provider/lifetime réels.63D89F utilise ce nom résolu dans8B0630 pour Champion/FriendlyTooltip, fallback vide et argument buffer13A0. Un lookup natif précis est établi, pas le choix complet de relation/type/acteur, la lecture de F4 dans le survol, l’évaluation du texte ou sa publication vers le popup.

Libellé, mappings de monde et ce lookup cadrent les aides de nouveaux joueurs. `[Shop]FriendlyTooltip` désigne l’aide sur la boutique du monde, pas toutes les descriptions d’objets achetables. Pas de restriction exclusive BattleTraining/mode ni de règle visibilité/mort/disabled/focus inventée. Les explorations non alignées826250 et premier chargement de schéma incorrect des anciens wrappers sont corrigées en utilisant l’entrée826240 et les structures réellement inspectées ; aucune conclusion d’absence n’en est tirée.

**Courant.** Shop affiche un détail persistant pour l’objet sélectionné, texte simple/description et sous-ensemble regen ; ce n’est pas un survol d’acteur. Les icônes QWER sont un autre rendu. picking::target est un picker d’intention de combat enemy-only ; allied_target concerne Heal et son rayon. Ils fournissent une géométrie existante, pas une identité de survol persistante universelle. Le consumer de commandes et target_info interne/pub(crate) ne doivent pas devenir une API publique de tooltip ou révéler des acteurs cachés.

Snapshot/recipient/réception et données visibles existent, mais pas de raccord nommé ObjectTooltips/world-hint dans1168fichiers. Conclusion complétée par les vrais corps/consommateurs ; pas d’absence globale des aides, du texte, des assets ou de tous les tooltips. TARGET-01-SELECTION et TIP-POPOVER-LIFETIME-01 restent distincts : leurs futurs cas propres ne valident pas ce cas monde.

## R4 — Attendu et observé

Sept cas : portée/défaut, no-live Save, requête close true/false/enfant nul, ressource/lookup, domaines actuels, ownership/refus et application/Save ouverts. Cinq fenêtres natives nouvelles et32instructions attendues ; bool partagé par octets. Mappings15 et lexical metadata repris, source membre et identités vérifiés sans réévaluation native. Corpus/Git, cinq registres et25fichiers protégés conservés.

Contrôles documentaires Python seulement. Aucun x86/AS/Rust/jeu/GUI/input/réseau/loader productif, ancien test/lecteur/export, installation/migration/restart exécuté. closeTooltip/flag1B1 ne sont pas une preuve de popup observé ; activation0/1, sélection de texte, refus, localisation/markup, viewport et persistance restent non exécutés.

## R5 — Manques et reprise

- OBJECTTIP-NATIVE-HOVER : lecteur F4/survol, type/relation/sujet/mode, lifetime/provider et show/close ack ouverts. Reprise sur une branche nommée depuis contrôleur/getter identifié ou contrat local explicite autorisé ; pas refaire l’inventaire.
- OBJECTTIP-CURRENT-PRODUCER : pas de world-hint route, pickers de combat/Heal différents d’une ancre d’inspection. Réutiliser géométrie/données visibles avec identité owner/session/entity stable, sans modifier les intentions ni exposer target_info interne.
- OBJECTTIP-CURRENT-TEXT :15références/texte déjà présents, consommateur monde/markup/locale/ancre non raccordé. Reprendre un hint statique nommé, sans chantier de toutes les formules de sorts/objets ni nouveau contenu.
- OBJECTTIP-SAVE-LIFECYCLE :0/1/close/leave/hidden/dead/disabled/ancre/focus/session/window et cancel/default/Save/reload non exécutés. Build/assets/provider et cycle spécifique monde requis ; critères futurs EzrealQ/objet1004 ne constituent pas ses preuves.

Impacts et entrées de reprise précis dans la preuve ; restent ouverts après le seul audit limité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01, TIP-POPOVER-LIFETIME-01 et TARGET-01-SELECTION conservées textuellement, comme mécanismes liés dont les périmètres restent distincts. Proposition HUD-OBJECT-TOOLTIPS-SETTING-01 porte le flag et une aide monde qualifiée, par exemple Champion/FriendlyTooltip ; les autres familles/variants doivent rester recensés jusqu’à qualification séparée, sans réussite globale déduite d’un cas. Aucun second moteur de tooltip ou réécriture de boutique imposé. Critères de ressource/sujet/ancre/markup et rendu/refus/lifecycle/Save réellement exécutés détaillés ; proposition non appliquée, aucun registre modifié.

Prochain lot : EnableLightFx ligne112, conditionalienware et updateonclick=true. Distinguer contrôle/API matériel et éclairage du jeu ; aucune installation/activation de pilote ou matériel. Lot suivant non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-OBJECT-TOOLTIPS-SETTING-01\object-tooltips-setting-proof.json` SHA256 `3a14f3a20808310238724b45ffa985ac0139447c703719eb2b533a9bc36c384a` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-OBJECT-TOOLTIPS-SETTING-01\verify_object_tooltips_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-OBJECT-TOOLTIPS-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; fonctionnalité/parent/goal ouverts. Nouveaux documents isolés seulement ; goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés.
