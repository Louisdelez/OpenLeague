# SYS-01.2-02 — Fatigue : effets et vitesse d'attaque

Date : 2026-11-03. Unité AUD-SYS-01.2-02-EXHAUST-EFFECTS-01. Exigence parente SYS-01.2-02; tâche SUMMONER-SummonerExhaust-SERVER, exigence OLF-50f6cfa2-9dc5-5930-b427-4fbb2d04f685.

## Périmètre et critère

Relier les valeurs et la durée comparatives aux consommateurs locaux des quatre familles d'effets : déplacement, vitesse d'attaque, défenses et dégâts sortants. Distinguer les formules de vitesse, leur durée et les preuves réellement observées. Ce sous-audit ne clôt ni disponibilité historique sur Map10, ni sélection, réseau complet, présentation, application serveur Riot ou acceptation humaine.

## Sources et preuves existantes

- Client fourni 4.20.0.315 PUBLIC EUW/en_GB : DATA/Spells/SummonerExhaust.inibin, OLS-a9450574-18d4-511b-b522-4e58f450a6fe, 1 030 octets, SHA-256 6a5abea4267a826834be6789b34d340db6839275c4cc580a8ff8d7111a0a4175, MD5 e49280c82b2018c73f8f16b2a67b8b29. Le reçu de membership natif relie le fichier au projet lol_game_client 0.0.1.7 et membre 0.0.1.7; priorité runtime non qualifiée. Une identité de fichier client ne démontre pas les règles serveur.
- Catalogue officiel comparatif 4.20.1 en_US, OLS-22f06d52-9752-5b89-863b-92b0614a555e, data/4.20/native_summoners_420.json:1 /data/SummonerExhaust : -30 % vitesse de déplacement et d'attaque, -10 armure/résistance magique, -40 % dégâts infligés, 2,5 secondes, portée 650, recharge 210. Le texte ne fixe pas l'ordre arithmétique de tous les bonus. Version/locale distinctes du serveur historique exact.
- data/4.20/exhaust_rules.json:2–12 documente les valeurs locales et qualifie comme non établis géométrie, ordre de vitesse d'attaque, durée du ralentissement avec ténacité, dégâts bruts et familiers. docs/FIDELITY_SUMMONER_SELECTION_LINKS_4_20.md couvre déjà la sélection; docs/FIDELITY_URGOT_PASSIVE_ZAUN_TOUCHED_LINKS_V645.md:62–67 couvre déjà la liaison locale des malus pour un témoin Urgot. Aucun hash de ressource inchangée n'a été répété.

requirement_trace.py exécuté avec .ai-tools/.venv/Scripts/python.exe pour SUMMONER-SummonerExhaust-SERVER : code 0, source native/catalogue et dispatch OLC-a1d7c55a-749b-518a-9fd0-b2654f72a3b1 reliés. unknown_ids vide et associated_sources_and_current_entrypoints ne démontrent pas l'intégralité de la mécanique; game_behavior_accepted=false. Aucun registre modifié.

## Consommateurs et calculs locaux

summoners.rs:47–74 dirige Fatigue vers summoner_exhaust.rs:55–90, qui exige un champion ennemi vivant à distance de centre au plus 650 et visible, puis applique grant_slow séparément de exhaust_until et fixe la recharge. Les règles de distance au centre et de visibilité sont locales; aucun cast n'a été exécuté ici.

progression.rs:100–107 soustrait 10 aux défenses; :119–127 soustrait 0,3 à la somme des bonus de vitesse avant calcul de l'intervalle d'attaque, avec facteur minimal 0,05 et délai minimal 12 ticks. Exemple arithmétique hors arrondi/planchers : avec +100 % de bonus, le facteur local passe de 2,0 à 1,7. Si l'on multipliait plutôt la vitesse totale par 0,7, le facteur serait 1,4. Le catalogue ne suffit pas à choisir la formule historique; cette comparaison indique une question, pas une erreur historique prouvée.

summoner_exhaust.rs:38–53 donne 0,6 aux dégâts physiques/magiques d'un champion source sous effet et 1 aux dégâts bruts; damage.rs:79 consomme ce facteur. Le ralentissement peut être purgé séparément, tandis que exhaust_until conserve les autres effets; le profil local traite la durée de ce ralentissement via l'aide de Garen W. L'ordre exact historique, la résistance aux contrôles, les dégâts des familiers et le comportement des dégâts bruts restent à qualifier.

## Attendu, observé et vérifications

Cas nominal statique : pour une cible valide et en l'absence de modificateurs supplémentaires, les valeurs locales correspondent aux constantes 30 %, 10, 40 % et 2,5 secondes; avec le taux local de 30 ticks/s, cela donne une expiration attendue à 75 ticks. Les refus pour cible absente/inconnue/alliée/morte, au-delà de 650 ou non visible précèdent l'application du ralentissement, sous réserve des contrôles amont. Ces cas n'ont pas été exécutés ici.

Preuves héritées distinctes : docs/exhaust_network_validation.json rapporte passed=true le 2026-10-03 sur serveur SHA-256 2db0ebf8525badd7918e53d153b1f19c019c8f7fb44a8c18fc13f452f03abf3c; son scénario local couvre notamment ralentissement, réduction d'armure, attaques et purge Q, mais pas tout le réseau, les effets visuels ou la fidélité Riot. docs/exhaust_render_validation.json rapporte un rendu HUD sur client identifié, sans cast FX/audio ni acceptation humaine. V645 rapporte aussi un témoin local de facteurs 0,6/0,6/1 puis expiration au tick 75 sur un ancien binaire; ces preuves ne qualifient pas la révision courante ou le serveur Riot. Elles n'ont pas été rejouées.

Les tests source summoner_exhaust.rs:123–279 décrivent effets, refus, purge, dégâts, mort et rafraîchissement; ils ont été lus, non exécutés ici. La méthode d'exécution de l'ancien scénario réécrit son reçu et lance un serveur : elle n'a pas été relancée. Le contrôle Python en lecture seule exécuté ici a retourné 0 : champs 650/210 du catalogue, constantes locales, ancres des consommateurs et calcul 1,7 contre 1,4. Il ne lance pas Rust et ne démontre pas la formule historique.

## Écarts et reprise

Audit statique de ce seul périmètre terminé; implémentation locale partielle; anciennes vérifications limitées au binaire/scénario décrit; acceptation humaine non donnée. SCOPE, SERVER et NET restent a_qualifier, implementation_complete=false et acceptance_complete=false.

Réutiliser SUMMONER-SummonerExhaust-SCOPE pour établir disponibilité et source serveur de référence, SERVER pour qualifier formule d'attaque avec plusieurs bonus, dégâts bruts/familiers, durée et cumul, puis corriger seulement les écarts démontrés; NET pour transmission et réplication. Reprendre la décision historique sur une source serveur 4.20 attribuable ou une observation historique fiable, notamment avec bonus d'attaque différents et effets de ténacité. Vérifier ensuite bornes, refus, expiration, purge, défense et dégâts sans supposer qu'une preuve de formule locale vaut fidélité historique.

Relecture : portée, provenance, consommateurs, attendu/observé, limites, tâches de correction et preuves datées renseignés. Aucun code, registre, goal, application de suivi ou base modifié; aucune installation ni migration.