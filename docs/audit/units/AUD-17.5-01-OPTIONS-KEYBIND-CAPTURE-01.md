# AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01 — entrée et sortie du mode de capture

Date : 2026-10-31T09:42:41.314402+00:00. Parent SYS-17.5-01, OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Qualifier les deux callbacks Start/End, le helper de transition et le pont booléen directement nécessaire, avec les gardes AS et les consommateurs actuels. Quatre corps normaux et une tranche d'enregistrement ; les services virtuels et le payload opaque ne sont pas explorés récursivement. Le producteur ne clôt pas sa propre portée : voir la relecture séparée.

Audit : conditions et frontières établies. Implémentation : primitives d'input présentes, capture configurable non raccordée par les éléments inspectés. Vérification : statique, preuves CPU anciennes réutilisées. Acceptation : non demandée. La fonctionnalité, le parent et le goal restent ouverts.

## R2 — Sources et provenance

PE original 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Les littéraux `StartKeybindInputMode` à `10C1D10` et `EndKeybindInputMode` à `10C1D28` ont chacun une référence PUSH directe dans les sections exécutables examinées. La tranche `82FD86..82FDAA` relie les callbacks `82FE40` et `82FE60` à l'enregistrement `78D610`. Ce recensement de PUSH n'est pas une preuve d'absence de références indirectes.

Corps normaux : `82FE40..82FE5B`, `82FE60..82FE9E`, `823450..823520`, `82E7E0..82E8E4`, bornes de fin exclusives. Retours précoces, blocs ultérieurs, voisins et padding identifiés. Les suites reprennent exactement aux decoder stops ; les instructions partielles voisines sont conservées dans les inspections, exclues des corps qualifiés.

L'export AS3 original est réutilisé avec identités exactes et provenance du GFX ; aucun nouvel export. Les 32 méthodes et deux groupes de preuves CPU de CAST1 sont conservés à leur portée, sans rejeu ni addition de leurs suites qui se recouvrent.

Deux qualifications d'inspection sont explicites : un ancien candidat de littéral avait été saisi `107550`, au lieu de l'opérande réel `10B7550` ; ses octets restent conservés mais exclus du sens du callback. La cible correcte est `IME_AS2.gfx`. L'immédiat de données `10B6B40`, dont le préfixe est imprimable, n'est pas assimilé à un nom de méthode AS. La preuve nomme ces corrections de lecture ; aucun octet source ni ancien reçu n'est remplacé.

## R3 — Contrats et consommateurs

Start `82FE40` déréférence le global `2D77E54`, sans garde NULL locale, et ne demande la transition que si manager+98 est non nul. Il passe `(7,7,0)` à `823450`, sans tester son AL. End `82FE60` passe `(6,0,0)` sans cette garde externe ; AL nul évite les appels suivants. AL non nul conduit à des appels du manager obtenu par `78D1C0`, virtuels +54 avec `IME_AS2.gfx`, puis +20 avec manager+110. Leurs effets précis restent opaques.

Le helper `823450` peut d'abord vider le flag E9 d'un objet manager+110 et appeler `Text_Entry_Close` / `ClearChatInterrupts`. **Ces effets précèdent** le refus manager+265 non nul, qui retourne AL=0. Un refus n'est donc pas déclaré sans effet.

Sur le chemin accepté, il stocke l'octet bas du troisième argument à +265, appelle l'import original **IMM32.dll!ImmAssociateContext** avec le handle global et zéro, puis obtient un objet du service `2D77E80` par virtuel +4. L'import est identifié dans le PE, pas exécuté.

Avec manager+98 présent : demander 7 depuis un mode autre que 7 appelle `82E7E0(true)` ; quitter 7 vers un autre mode appelle `false` ; rester 7 ou entre deux modes non 7 n'appelle pas ce pont. Le mode antérieur vient de virtuel +34. Ensuite virtuel +30 reçoit le premier argument, manager+80 reçoit le second, et le helper retourne AL=1 **sans vérifier le retour virtuel ni son état final**. Ce statut qualifie le chemin terminé, pas une preuve d'application effective ou de capture fonctionnelle.

Le pont `82E7E0` est gardé par objet+24. Il transmet le booléen et objet+1C à `831820`, puis un temporaire à `7971E0` sur objet+24. Des appels additionnels dépendent du global `2D788C8` et de son flag 81 ; leur sens reste ouvert. Le nom et la matérialisation du payload transmis sont encore opaques : ce lot ne prétend pas avoir prouvé sa réception par le target AS.

Côté AS, `FoundryOptionsModule` enregistre `SetKeybindInputMode` et `KeybindData`. Il relaie respectivement `value as Boolean` et `keys/localizedKeys` vers `ViewApplication`, puis `KeyBindStateHandler`. Le setter local met le flag actif à jour. Le simple événement BindModeStart appelle Start et affiche le dialogue ; il ne positionne pas lui-même ce flag.

Une donnée de touche n'est traitée que si le flag est actif **et** une grille enregistrée existe. Le modèle distingue binding absent, Esc avant application, application refusée, succès et suppression des conflits. Tous les états terminaux demandent End par le helper d'affichage ; succès, unbound et annulation utilisent 0/0, échec 1,5/0,3 et interruption 0/0,3 pour le délai/durée déclarés. End est appelé immédiatement par le helper, sans attendre la fin du tween. Les temporisations et le stage réels ne sont pas observés.

End AS n'appelle le callback externe que si le flag local est actif ; il ne le vide pas lui-même. La fermeture de menu vide ce flag **avant** l'annulation de grille : l'appel End conditionnel peut donc être sauté. Le host peut gérer sa propre transition de fermeture ; son ordre n'est pas qualifié et aucun bug n'est déclaré sur cette seule lecture. La branche de type de statut inconnu masque les boutons, affiche le message, programme le masquage à 5000 ms et demande End ; son nettoyage du listener de stage n'est pas assimilé à celui du helper terminal.

Le module debug ajoute/retire un listener KEY_DOWN et met en queue `SetKeybindInputMode=true/false`. Il est distinct de la preuve native ; il ne valide ni l'acquittement original ni le payload opaque.

Les vrais consommateurs courants conservent leurs gardes QWER : première pression non répétée, Ctrl au keydown, remise à zéro sur perte de focus et refus/gates des commandes. Leurs sources et preuves CPU concordent, sans rejeu. La recherche de cinq noms de routes de capture dans les 1168 fichiers du corpus ne trouve aucun hit. C'est une absence lexicale bornée, pas une absence dynamique globale. Ces gardes ne constituent pas un éditeur de bindings ou un dialogue de capture configurable.

## R4 — Attendu et observé

166 instructions de corps normaux, huit instructions d'enregistrement et 40 points fixes sont identifiés sur les octets. Les cas couvrent Start sans wrapper, transition vers 7, refus 265 avec pré-effets possibles, End vers 6, garde de réception AS, fermeture/End conditionnel et protections courantes focus/repeat. Chacun porte sa nature et ses preuves dans le JSON.

Les sources AS, les identités CPU héritées, 1168 fichiers du corpus, 25 fichiers protégés, cinq registres et Git sont contrôlés. Une commande de lecture a échoué avant Python sur un chemin d'outil mal transcrit, puis a réussi avec le chemin correct ; elle n'a modifié aucun fichier. Aucun jeu, x86, AS, Rust, GUI, input physique, OS/IME, réseau, export inchangé, installation ou migration exécuté.

## R5 — Manques et conditions de reprise

- `CAPTURE-NATIVE-PAYLOAD` : target/value construits par `831820`, publication `7971E0` et réception AS réelle. Reprendre cette frontière nommée avec les receivers déjà établis, sans utiliser la queue debug comme substitution.
- `CAPTURE-SERVICE-CONTEXT` : objets et champs réels, méthodes virtuelles +30/+34, focus/IME et lifetime. Nécessite un contexte/version/vtable ou une nouvelle preuve primaire ; AL=1 n'établit pas le post-état.
- `CAPTURE-CLOSING-ORDER` : fermeture host, touches tardives, stage, timers/tweens et nettoyage des échecs. Réutiliser les audits menu/cancel/lifecycle ; une observation réelle serait distincte et autorisée séparément.
- `CAPTURE-CURRENT-CYCLE` : capture/édition configurable, conflits, sauvegarde, annulation et reprise. Réutiliser les corrections existantes sous autorisation produit distincte.

Les impacts et entrées précises sont dans la preuve. Ces frontières ouvertes n'annulent pas les conditions statiques établies et ne sont pas converties en fonctionnalité terminée.

## R6 — Corrections conservées et suite

Les dix corrections de bindings/modes et `HUD-OPTIONS-ENTRY-01` gardent leurs définitions et leur statut proposé, non appliqué. Aucun doublon ni modification normative. Les limites du cache, filename, valeur et copie restent acquises à leur portée ; aucune nouvelle analyse de ces sujets.

Prochain lot fini : `AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01`, le constructeur de payload `831820` et l'interface de publication appelée à `82E87D`. Un seul producteur et une frontière, sans exploration récursive des services virtuels, runtime ou clavier. Les noms de callbacks, les exports et les routes AS n'ont pas à être redécouverts.

## R7 — Livraison et relecture

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01\keybind-capture-proof.json`, SHA256 `1ddd78d82797048d6b654238cd134f994ca2e29b8d3d975002677b1ba6d34e8c`. Producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01\verify_keybind_capture_v2.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01\audit-unit.json`. Quatre inspections et leurs scripts identifiés. Relecture : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

La première synthèse a échoué avant exécution sur le mot réservé Python `return` utilisé comme clé nommée. Le script et le reçu d'échec sont conservés ; la v2 nomme le champ `return_contract`. Aucun résultat natif n'est déduit de cet échec.

Nouveaux artefacts documentaires isolés uniquement. Goal, critères, registres, code, assets, suivi, interface, bases et preuves antérieures inchangés. Aucun achèvement du parent ou du goal, aucune fonctionnalité complète ni acceptation humaine.
