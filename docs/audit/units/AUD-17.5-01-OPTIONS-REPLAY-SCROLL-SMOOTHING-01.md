# Audit ReplayScrollSmoothingEnabled — SYS-17.5-01

## 1. Périmètre et source
Unité `AUD-17.5-01-OPTIONS-REPLAY-SCROLL-SMOOTHING-01`, XML174 `OPT-SRC-756aed1b732ae612`, case **[HUD]ReplayScrollSmoothingEnabled** avec filtre direct replay, groupe layout171 sans condition. Variante normale173 autre clé/game; slot46 commun. Les20commandes replay, le zoom et le jeu global ne sont pas clos par cette unité; parent/goal restent ouverts.

## 2. Exposition, label et contrat partagé
Pas de label propre: générateur partagé `flash_optionsMenu_event_`+event donne **flash_optionsMenu_event_ReplayScrollSmoothingEnabled**, en_GB777 **Camera smoothing enabled**. Deux tranches source bornées du générateur relues, aucun export ou AS exécuté. Prédicat exact replay, sans trim/casefold. Game seul ne satisfait pas la case; un vecteur nonstandard contenant les deux termes peut permettre les deux contrôles indépendants. Vecteur livré/UI non mesurés.
Slot46, aliases et bool helper/cache/flags61/62 réutilisés du lot181/518 sans désassemblage/recherche répétés. Défaut bool calculé par premier appel contexte et clé par deuxième: replay cohérent donne1, normal0, mais aucune stabilité/provider/valeur de session observée. Même slot ne signifie pas même clé ou default à copier.

## 3. Consommateurs et données actuels
Defaults80 replay1 et78 normal0, copie identique. User/deploy seulement normal0: ne pas déclarer un override replay à partir de cette présence. Quatre inputs épinglés réutilisés, candidat F:/OpenLeague/Config/Game.cfg toujours absent.
Zoom smoothing, maintien/restrictions focus, séquence/pose et pan/follow existent. Service replay actuel conserve configuration/lifecycle/transport et attache au runtime canonique; son nom ne prouve ni portée audio seule ni moteur caméra de replay. Corpus1168 inchangé; queryclé0 partagée réutilisée sans répétition.20déclarations de commandes restent sources, pas commandes appliquées ou replay actif qualifié.

## 4. Attendu et observé
Six cas de source: nominal replay, game/refus, casse/espaces, alias/defaults, consumers actuels et corrections réutilisées. Sources/labels/configs/identités relus et sept rubriques préparées. Aucun original/x86/AS/Rust/UI/OS/réseau/émulation, ancien test/lecteur/export, nouveau désassemblage/query d’absence ou loader exécuté. Aucun effet visuel ni Save durable déduit.

## 5. Manques et reprise
Les quatre constats **SMOOTH46-CONTEXT/READERS/CURRENT/SAVE** gardent exactement leurs IDs, définitions et conditions de reprise du lot normal; pas quatre nouveaux écarts replay.
**SMOOTH46-REPLAY-CONTEXT** — Manque: Contexte replay actif: owner/session/horloge/entrée caméra et consumer46 recevant les flags61/62 dans ce contexte. Impact: Le filtre, label et défaut1 ne prouvent pas un lecteur de replay caméra ni son lissage. Les services existants et20déclarations de commandes restent acquis, sans portée audio seule déduite de noms audio_*. Reprise: Contrôleur replay/clock/admission et lecteur61/62 nommés, ou politique locale versionnée avec autorisation produit. Réutiliser l’analyse46; aucune nouvelle recherche sans cette entrée.

## 6. Corrections existantes
**HUD-OPTIONS-SCROLL-SMOOTHING-46-01** et **CAMERA-CONTEXT-PERSISTENCE-01** réutilisées avec leurs définitions intactes et non appliquées. La première inclut déjà normal/replay et defaults distincts; aucune nouvelle correction en doublon. La seconde ne devient pas20commandes implémentées à partir de cette case. Aucun registre/Goal/critère/suivi changé.

## 7. Vérification et livraison
130 contrôles producteurs passés; lecteur séparé requis pour clôture documentaire propre. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-REPLAY-SCROLL-SMOOTHING-01\verify_replay_scroll_smoothing.py`, preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-REPLAY-SCROLL-SMOOTHING-01\replay-scroll-smoothing-proof.json`. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,76 modifications suivies préexistantes,25 fichiers protégés/5 registres/corpus1168 inchangés. Nouveaux scripts/spec/preuve/rapport isolés uniquement; aucune installation/migration/redémarrage ou modification Plan/UI/bases/produit/anciennes preuves. Fonctionnalité non qualifiée, vérification statique, acceptation humaine non demandée. Suite: `AUD-17.5-01-OPTIONS-AUTO-ACQUIRE-TARGET-01`, XML178 `OPT-SRC-3665618143ac2f6f` AutoAcquireTarget.
