# SmartCastOnKeyRelease — checkbox XML242

## 1. Portée et décision

Unité AUD-17.5-01-OPTIONS-SMARTCAST-RELEASE-01, goal SYS-01.2-02, parent SYS-17.5-01. Une identité physique seulement : OPT-SRC-64f15322fb24fba8. Le précédent lot temporel est un progrès vérifié. Cette association devient clôturable après relecture ; le parent et la fonctionnalité restent ouverts. Implémentation : composants d’entrée présents, préférence release non appliquée/qualifiée. Vérification : documentaire uniquement. Acceptation humaine : non demandée.

## 2. Sources exactes

FoundryOptionsKeybinds.xml:242, SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e : checkbox selected="0", ini="[HUD]SmartCastOnKeyRelease", label identifié dans en_GB. Ancêtre onlyshowif=game, aucun gate propre. Les octets et offsets sont vérifiés contre l’index physique. Ce n’est pas une affectation de touche GameEvents ni l’un des13flags Quickbinds.

L’audit cast-mode existant identifie la clé absente du defaults/Game.cfg fourni et présente à1 dans Config/Game.cfg:33 de l’utilisateur fourni. Selected0, fallback0 du modèle et valeur utilisateur1 sont des faits distincts : aucune valeur effective de session ou défaut patch déduite, aucune corruption affirmée. Les offsets/empreintes des deux configurations et du PE sont conservés. Les occurrences PE0x8363b0/0x836d7c restent de simples localisations de valeur ; aucune fonction/getter n’est déclarée identifiée à ces adresses.

## 3. Contrat frontend et consumers réels

Réutilisation des21fenêtres checkbox déjà acquises : InteractiveModelComponent.buildIniSettings sépare HUD et SmartCastOnKeyRelease avant le modèle checkbox. ModelCheckbox appelle ReadGameCfg avec fallback"0" en environnement ingame/GFXplayer, avec normalisation source non équivalente à un refus strict des textes arbitraires. Utility renvoie le fallback en GFXplayer ; le provider ingame demeure une frontière. Valeurs NULL/nonchaîne, état/provider effectifs et comportement natif ne sont pas prouvés ici.

La stratégie déclarée par défaut du SerializeableValue est regular. Cette case et ses ancêtres héritables n’ont pas strategy=input ; l’appartenance au keygrid ne suffit pas à lui attribuer la sérialisation d’un keybind. Les fenêtres de journal/undo, Save et Update groupé identifient le couple section HUD / clé SmartCastOnKeyRelease ; le payload documentaire dans la preuve n’a pas été exécuté. Les guards disabled/sélection et la conversion booléen/texte sont conservés comme source de famille, sans transfert d’un état UI réellement observé. Aucun callback int10/AutoAcquireTarget, dispatch natif ou effet de ciblage n’est attribué à cette option.

L’audit cast-mode fournit six fenêtres Rust relues : spell_input.rs:1..54 crée une intention à l’appui frais, le relâchement retire la touche held ; main.rs:1366..1501 sélectionne et envoie les actions actuelles sous ses gardes. La clé HUD/SmartCastOnKeyRelease n’est pas reliée à ce déclencheur par les preuves inspectées. Le loader générique Game.cfg conserve des données sans prouver leur application. Sa recherche bornée vide sur1168fichiers est réutilisée après vérification des identités ; aucun nouveau scan ni absence sémantique globale affirmée.

## 4. Attendu et observé

Attendu : une association source/consumer/écart, valeurs distinctes et action déjà prévue. Observé : checkbox game/HUD identifiée, source de famille reliée, consumer keydown conservé, application au relâchement non qualifiée. Le snapshot coverage-delta-v2 classait cette case en inventaire seulement ; il reste intact, ce lot ajoute une preuve propre à l’identité.

Contrôles exécutés : octets XML, configurations et libellé, empreintes et fenêtres réutilisées, critères existants, cohérence et fichiers protégés. Les14anciens contrôles composants du cast-mode restent hérités dans leur portée ; zéro relance. Non exécutés : jeu/Rust/native/AS/GUI/réseau, émulation originale, clavier physique, indicateur, annulation réelle, Save/restart ou loader de production. Codes réels et empreintes du producteur/lecteur dans leurs reçus.

## 5. Inconnues et reprise

- RELEASE-NATIVE-PROVIDER : callback/getter/provider réel, valeur effective, sync et writer/readback. Reprise avec entrée native discriminante ou contrat local explicite ; pas de nouvelle recherche PE entière inchangée.
- RELEASE-CURRENT-TRIGGER : préférence appliquée à appui/relâchement, intention en attente, indicateur, annulation et transitions focus/session. Reprise par CAST-MODE-RELEASE-01, source/contrat de déclenchement et autorisation produit distincte.
- RELEASE-UI-DURABILITY : menu visible/actif/désactivé/refusé, Apply/Cancel/Reset/Save, fichier absent/invalide et nouveau processus. Reprise avec consumer/fixtures identifiés et autorisation d’exécution distincte. La conversion de famille ne prouve pas un refus natif des textes non canoniques.

## 6. Corrections réutilisées

CAST-MODE-RELEASE-01 couvre déjà précisément cette préférence ; CAST-MODE-MODEL-01, CAST-MODE-ABILITY-01, CAST-MODE-EDIT-01, les cinq génériques BIND et HUD-OPTIONS-ENTRY-01 sont conservés comme dépendances dans leurs portées originales. Zéro correction nouvelle, aucun critère modifié. Les fiches originales définissent source/contrat, cas nominal, appui/relâchement, absence/invalide, pas de double cast/après perte focus, stockage correct et relance. SYS-17.4-03 conserve l’indicateur et SYS-17.4-08 la capture de saisie : rien n’est déclaré livré par la case seule.

## 7. Livraison et cohérence

Preuve et rapport isolés sur F, reliés aux programmes/sources et ancienne couverture par empreinte/pointeur. Relecture séparée des sept rubriques et reçu réel ; seule cette association documentaire peut être close. Corpus1168,25fichiers protégés et5registres inchangés ; aucun retrait du travail antérieur. Goal/critères normatifs/Plan/UI/bases, installations et migrations inchangés. Aucune ancienne analyse ni test relancé.

Suite : rapprocher toutes les identités physiques du keygrid des lots acceptés, distinguer contrôles interactifs et structure, puis nommer les portées restantes. Ce sera une réconciliation de preuves, pas une mesure de jeu terminé.
