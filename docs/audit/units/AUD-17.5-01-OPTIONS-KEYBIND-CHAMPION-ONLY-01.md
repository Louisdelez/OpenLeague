# evtChampionOnly — contrôle XML79

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-KEYBIND-CHAMPION-ONLY-01, goal SYS-01.2-02, parent SYS-17.5-01. Une identité physique : OPT-SRC-4083e4714c1c0787. La réconciliation précédente est un progrès vérifié et conservé. Cette unité termine l'association de ce contrôle après relecture, sans clôture de fonctionnalité ou parent. Implémentation : filtre géométrique et règles de certains sorts présents, raccord d'un état utilisateur non qualifié. Vérification : documentaire seulement. Acceptation humaine : non demandée.

## 2. Sources natives

FoundryOptionsKeybinds.xml:79, version SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e : keybind event=evtChampionOnly, ancêtre game, stratégie input/GameEvents, aucun gate propre. Index, offsets et octets du tag contrôlés. Defaults/Input.ini:423 déclare [`]. Les overrides deploy/user fournis n'ont pas de ligne pour cet événement. Locale en_GB:455 : Target Champions Only.

Ce binding brut ne qualifie ni touche physique Backquote, ni AZERTY/QWERTY, ni maintien/bascule, ni option toggle moderne. Le nom et la catégorie ne déterminent pas toutes les actions affectées. Aucun paramètre/fichier natif n'est reconstruit ou modifié.

## 3. Consumers réels et acquis préservés

L'audit AUD-17.4-05-ATTACKMOVE-CHAMPONLY-01 est réutilisé, avec ses limites et sa clôture documentaire historique ; son ancien parent flag n'est pas transféré à ce parent. La famille keybind/capture/provider déjà acquise dans les lots de raccourcis est reliée à cette occurrence input, sans la confondre avec les flags Quickbinds.

**picking.rs:16..85** contient réellement champions_only : les champions ennemis vivants sont candidats, et les unités supplémentaires ne sont ajoutées que si le booléen est faux. Ignite et Exhaust passent true selon leur règle propre. Le picker utilise la géométrie/rayon de sélection ; le fallback local160des types sans champ conserve son statut de reconstruction et n'est pas requalifié ici.

**main.rs:1439..1501** transmet `skill == Some(3)` au picker dans la branche de ciblage. Ce filtre fixe par slot n'est pas un état activé par [`]. Ground-skill peut suivre CastAt ; clic sans cible peut produire Move sous ses conditions. Les sorts/terrain/attaque-déplacement ne reçoivent aucune nouvelle sémantique depuis le seul booléen. **spell_input.rs:4..54**, gates de commands, validation autoritaire **attacks.rs:137..155**, projection viewer **vision.rs:137..169** et appel de session_host sont conservés. Inspection de cible, filtre d'ennemis et sélection pour attaque/sort demeurent distincts.

## 4. Attendu, observé et contrôles

Attendu : une association physique et native avec le vrai consumer partiel, sans faux constat d'absence du filtre. Observé : filtre présent, raccourci/user-state→actions non qualifié. Les recherches antérieures sont réutilisées sur corpus1168fichiers identique : quatre lignes picking pour le booléen et deux lignes de tests dans la recherche KeyA/X/Backquote/Shift. Elles ne prouvent pas une absence sémantique globale et ne sont pas relancées.

Neuf anciens contrôles composants restent hérités : deux géométriques, quatre annulation/refus/visibilité d'attaque et trois poursuite/ordre. Zéro nouveau test produit. Contrôles exécutés : identités XML/config/locale, fenêtres existantes, pointeurs/empreintes, critères et cohérence. Non exécutés : jeu/Rust/native/AS/GUI/réseau, émulation, clavier physique, maintien/bascule, mode utilisateur, superposition de cibles et persistance. Codes réels des programmes documentaires et empreintes dans les reçus.

## 5. Inconnues et reprise

- CHAMPONLY-HISTORICAL-STATE : handler/provider, décodage, maintien/bascule et reset. Reprise : callback/trace native discriminante ou contrat local explicitement accepté, sans inventer une politique moderne.
- CHAMPONLY-CURRENT-ROUTE : état utilisateur vers actions, terrain vide, sorts allié/soi/ennemi, inspection et interaction attaque-déplacement. Reprise par les corrections CHAMPONLY existantes, en réutilisant le vrai filtre et les gardes serveur, avec autorisation produit distincte.
- CHAMPONLY-CAPTURE-DURABILITY : mode activé/désactivé/refusé, capture texte/focus/session, remap/reload et résultat physique non vérifiés. Reprise avec owner/provider, cas isolés autorisés et fondations BIND ; la preuve Q→Enter existante reste dans sa portée, aucun nouveau leak ChampionOnly n'est affirmé.

## 6. Corrections réutilisées

**CHAMPONLY-INPUT-01** : source/contrat de touche et maintien/bascule/reset, état indépendant de slot3, captures et vraies dispositions clavier identifiées. **CHAMPONLY-ROUTE-01** : booléen existant réutilisé, actions qualifiées, superpositions/types/sol vide et interaction attaque-déplacement, visibilité et autorité préservées. **CONTROL-NATIVE-ACTION-01** conserve sa portée historique plus large ; ce lot ne termine pas ses autres événements.

Les cinq génériques BIND-LOAD/SAVE/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER-01 restent des dépendances dans leurs portées originales. Les définitions complètes et critères sont liés par JSON Pointer/empreinte, pas réécrits. Zéro correction nouvelle : le manque est déjà découpé en entrée et routage. Aucun nouveau rayon, priorité ou règle de cible n'est inventé.

## 7. Livraison et suite

Association, preuve et rapport isolés sur F, relecture distincte des sept rubriques et reçu réel. Corpus1168,25fichiers protégés,5registres et Git préexistants inchangés. Aucun goal/critère normatif/Plan/UI/base changé ; aucune installation/migration/redémarrage ni loader de production.

Le snapshot keygrid précédent reste daté et intact : ce lot résout documentairement l'une de ses trois feuilles pending, sans annoncer de progression fonctionnelle. Suite : evtUseChampSwap XML81 sous mutator:TagTeam ; General/BindSysKeys XML36 et les conteneurs/include demeurent ouverts. Ne pas déclarer le parent ou le jeu terminés.
