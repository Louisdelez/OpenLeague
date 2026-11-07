# AUD-17.5-01-OPTIONS-NUMERIC-COOLDOWN-SETTING-01 — NumericCooldownFormat

## R1 — Portée et décision

Dropdown122/options0..3 et mode de texte des recharges. Audit limité, producteur non clôturant/relecture distincte requise. Fonctionnalité menu complète, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Formateur/lecture/consumer actuels déjà présents, pas à reconstruire ; aucune acceptation humaine ou validation globale.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS épinglés. Choix123..126 : None/Seconds/Minutes + Seconds/Minutes, valeurs chaînes0..3 ; enGB769/881..884. Defaults141/user32/deploy34=1. Read32natif0/0/GFXfallback0/provider effectif distincts du cfg courant et de son refus clé absente.

Vraies classes factory model/components/ModelDropdown et view/components/ViewDropdown consultées ; premier chemin deviné sans components absent, pas d’absence de classe conclue. Exports antérieurs réutilisés sans nouvelle exportation, modèle/view dropdown distincts du checkbox. Save/shared journal réutilisés. Numeric audit/report et QWER/readback conservent leurs périmètres ; aucun lecteur séparé numérique inventé. Formatter84cases/son Rust et log ciblé inchangés, antérieurs et non rejoués ; ancienne intégration widgets/main/client différente, pas de requalification courante par345anciens tests.

## R3 — Contrat et consommateurs réels

**Dropdown.** Model charge options enfants, localise labels, getSelectedIndex par indexOf exact. setValue ignore chaîne non présente ; setSelectedIndex change valeur seulement inbounds, mais émetCHANGE même horsborne. Init sans datasource lit GameCfg fallback0 ; datasource/restoreDefaults séparés. SerializeableValue commence NULL, premier set définit baseline, suivants journalisent ; interactions valeurcfg inconnue/première sélection/sync à vérifier, pas normalisées silencieusement. Override setValue ne transmet pas son second argument Boolean à setSelectedIndex : un syncfalse ne prouve pas à lui seul absence de journalisation. View INDEX_CHANGE→selectedIndex→USER_CHANGE ; click joue son, sync change index, deactivate ferme liste. Pas d’applyLiveUpdate explicite, strategyregular/no updateonclick ; UI physique/CLIK/host effectif non exécutés.

**Natif.**83434A→837BF0/mode0 ; scalaireC998CC→index37. Initial read8B1C20 avec0/0, keytable37→836D99. Même helper change avant postreturn, pas d’absence d’effet :7D7940 lit réellement37 via835080. Mode0 écrit byte0 à sortie et retourne ; nonzeroceil et branches. Rawseconds>=60, mode2minutes:seconds, mode3minutes calculées depuis ceil ;59.x arrondi60 reste secondes car seuil sur rawseconds. Sous binary32.7, %0.1f ; seuil/au-dessus entier. Autres modes nonzero suivent entier, pas rejet0..3 déduit du menu. Champs/messages/effectifs runtime restent séparés.

**Formateur antérieur.**84cas positifs modes−1,0,1,2,3,4 et14temps ; seuil strict.7/60/sourceformats/varargs acquis, printf et lookup jadis adaptés. Nouvelle source statique relie vrai lookup37 ; aucun ancien x86 ou printf rejoué. Octets CRT/locales restent NUM-COOLDOWN-PRINTF. Zéro/négatifs/nonfinis hors84cas, ne pas inventer validation native depuis l’API locale.

**Courant.** native_hud_cooldown_text::mode(settings.text) lit réellement HUD/NumericCooldownFormat, erreurs si clé absente ; integer reader existant. Actual update appelle ce mode puis snapshot_values_with_mode pour QWER/D-F depuis deadlines/ticks ; format puis présence des valeurs/flags pilote textes et glyph layer. Ancien wrapper par défautmode1 n’est pas le chemin actuel configurable. Format API refuse temps nonfini/négatif/hors signed32, mode0 et secondes0→None ; ces limites locales restent distinctes. Autres modes nonzero conservent fallbacksecondes. Erreur mode/valeur nettoie la couche numérique ; pas d’observation actuelle pixels/clock/smoothing. Loaded reader présent, éditeur/transaction de choix pas qualifié ; query nommée ResMutLoaded vide est bornée, pas une preuve d’absence de tout stockage mutable.

## R4 — Attendu et observé

Sept cas : valeurs/default, dropdown limites, natif37,84formats repris, acquis courants, dérive d’ancienne intégration et application/Save ouverts. 5fenêtres/26instructions nouvelles, deux seuils et septlittéraux, tables37 et helpers réutilisés vérifiés. Rust/log ciblés identiques, pas de345tests relancés ou nouvelle validation du HUD. Cinq registres/25protégés/corpus/Git conservés.

Contrôles documentaires Python/source seulement ; aucun AS/x86/Rust/jeu/GUI/input/réseau/loader, ancien test/lecteur/export, install/migration/restart. Nominal physique0..3, unknown/index/refus/focus/session/resize et Save/cancel/default/reload restent non exécutés. Chaîne source/ancien test ciblé ne prouve pas succès de l’édition, rendu natif exact ou persistance.

## R5 — Manques et reprise

- NUMCOOLDOWN-MENU-APPLY : éditeur/transaction versLoaded et cycle appliquer/annuler/default/Save/reload non qualifiés. Reprise HUD-OPTIONS-ENTRY et mutation/provider autorisés, sans réécrire formatter.
- NUMCOOLDOWN-ADMISSION : unknown string/index/NULLbaseline/sync et événements physiques non exécutés. Reprise contexte/provider/politique explicite, sources ModelDropdown/SerializeableValue ; ne pas clamp rawcfg ou déduire refusbackend de la liste0..3.
- NUMCOOLDOWN-PRINTF : vrai CRT/locales encore ouvert dans84cas adaptés. Reprendre tâche existante NUM-COOLDOWN-PRINTF avec nouvelle entrée originale/localisée, pas rejouer printfPython.
- NUMCOOLDOWN-RENDER-LIFECYCLE : actuel glyph/clock/owner/session/window/ready/invalid non observé, vieille intégration différente. Build/assets autorisés et cas QWER/D-F du réglage ; NUM-CURRENT-RENDER conservé, sans exiger ici la totalité des18widgets.

Impacts et conditions discriminantes dans la preuve ; limites ouvertes après seul audit borné.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY et définitions exactes du rapport numérique111/114 pour NUM-COOLDOWN-PRINTF/NUM-CURRENT-RENDER conservées. Proposition HUD-NUMERIC-COOLDOWN-SETTING-01 porte uniquement choix/transaction/Loaded/Save et comportements visibles0..3 ; formatter et consumer existants gardés. Numéro de mode ne modifie pas recharge serveur ; aucun chantier de122champions ou nouveau format générique. Proposition non appliquée, registres inchangés.

Prochain ShowNeutralCamps131 : réglage, état camp/entités minimap/visibilité distincts, audits existants d’abord. Non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NUMERIC-COOLDOWN-SETTING-01\numeric-cooldown-setting-proof.json` SHA256 `dfca3dfc5dffd8d534feeca4ecef62408bf33077254d5646552f7edb512cd906` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NUMERIC-COOLDOWN-SETTING-01\verify_numeric_cooldown_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NUMERIC-COOLDOWN-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json/INDEPENDENT-REVIEW.md. Seul périmètre documentaire pourra être clos ; Goal/critères, code/assets, Plan/UI/bases, registres et anciennes preuves inchangés, nouveaux documents isolés seulement.
