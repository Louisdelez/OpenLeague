# Audit MapScrollSpeed replay — SYS-17.5-01

## 1. Exigence et frontières
Unité `AUD-17.5-01-OPTIONS-MAP-SCROLL-SPEED-REPLAY-01`: XML166 `OPT-SRC-6914610cfa4f446e` sous groupe165 `OPT-SRC-14056858024b1b5e` onlyshowif replay. La clé reste **[HUD]MapScrollSpeed**, scale1, option flottante44; le suffixe `_replay` appartient au libellé explicite. Middlemouse45,20commandes replay, fonctionnalité et parent/goal non clos par cette unité.

## 2. Sources et exposition
en_GB762: **Screen edge camera move speed**. Le factory compare une entrée exacte replay. Un groupe refusé retourne null avant initialisation, donc ses enfants ne sont pas créés par ce chemin. L’allowlist d’héritage contient seulement INISECTION/STRATEGY/PREPENDNOLABELEVENTS; la condition parent n’est pas recopiée comme attribut du slider. Game seul ne satisfait pas ce groupe, son homologue163 a son propre filtre game. Casse/espaces ne sont pas normalisés. Ce sont des observations de source; vecteur livré et UI non mesurés.
Label explicite, même appliedScale0.01/valeur/provider/native44 que le contrôle normal: réutilisation du lot195/680, sans redésassemblage ni nouvel export. Float44/callback837b70/setter8355b0/record82d0d0/refresh7e3c20 et limites normalisées sont acquis documentairement, pas exécutés ici.

## 3. Consommateurs actuels et limites
Pan normal fixe150, gardes de session/focus/follow et pose native existent. native_replay_service porte configuration/lifecycle/transport dans des types audio_* et l’attache à un runtime canonique. Ces sources et leurs noms ne prouvent ni une portée audio seule ni un contrôleur de caméra de replay de match. Aucun service créé, attaché ou exécuté par l’audit. La recherche1168 fichiers sans liaison explicite MapScrollSpeed est réutilisée après contrôle d’identité du corpus, jamais relancée. Les20déclarations ReplayOptions et dix SelectPlayer sans binding fourni restent un catalogue de source, pas des commandes appliquées.

## 4. Attendu et observé
Six cas de source: sous-arbre replay permis conditionnellement, game refusé pour ce groupe, casse/espaces exacts, même clé/autre libellé, conservation des limites, inspection des consommateurs réels. Quatre configurations.5000 inchangées réutilisées; pas de valeur effective ni Save/reload. Aucun AS/x86/Rust/UI/OS/réseau/émulation ni ancien test/lecteur/export exécuté. Aucun nouveau désassemblage ou query d’absence.

## 5. Manques et reprise
Les cinq constats **MAP44-HOST/NOTIFY/MOTION/CURRENT/CFG** du lot normal restent ouverts, mêmes IDs et conditions de reprise: pas cinq nouveaux écarts. La preuve JSON en conserve la définition exacte et sa provenance.
**MAP44-REPLAY-CONTEXT** — Manque: Contexte replay effectivement admis: propriétaire/session/horloge, activation du groupe et consommateur de caméra/scroll recevant la même préférence44. Impact: Le libellé et20déclarations de commandes historiques ne prouvent pas un lecteur de match actif; les services de configuration/transport existants ne qualifient pas ce raccord. Ne pas qualifier une portée audio seule d’après les noms audio_*. Reprise: Entrée nommée de contrôleur replay/horloge/admission et lecture MapScrollSpeed44, ou contrat local explicitement versionné puis correction autorisée. Réutiliser les sources partagées et ne pas répéter la recherche générale du PE.

## 6. Corrections réutilisées
**HUD-OPTIONS-MAP-SCROLL-44-01** inclut déjà game/replay; **CAMERA-CONTEXT-PERSISTENCE-01** conserve provider/activation/bindings du replay. Aucun doublon ni nouvelle correction proposé. Leurs définitions restent intactes, non appliquées; cette unité apporte seulement l’application au nœud166 et le manque de contexte propre. Le contrat et les écarts partagés ne deviennent pas une fonctionnalité terminée.

## 7. Livraison et vérifications
162 contrôles producteurs réussis; relecture séparée encore requise pour clôture documentaire propre. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MAP-SCROLL-SPEED-REPLAY-01\verify_map_scroll_speed_replay.py`, preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MAP-SCROLL-SPEED-REPLAY-01\map-scroll-speed-replay-proof.json`. Source XML/GFX/PE/en_GB/AS, rapports et corpus épinglés; HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,76 modifications suivies antérieures,25 fichiers protégés et5 registres conservés. Nouveaux scripts/spec/preuve/rapport isolés uniquement. Goal/critères/Plan/UI/bases/produit et anciennes preuves inchangés; aucune installation/migration/redémarrage. Fonctionnalité non qualifiée, vérification statique, acceptation humaine non demandée. Suite: `AUD-17.5-01-OPTIONS-REPLAY-MIDDLE-MOUSE-SPEED-01`, XML167 `OPT-SRC-6790776f61108f6f`, clé propre ReplayMiddleMouseScrollSpeed.
