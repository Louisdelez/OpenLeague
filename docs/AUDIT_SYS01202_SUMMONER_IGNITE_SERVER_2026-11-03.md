# SYS-01.2-02 — Embrasement : mécanique serveur et sources

Date : 2026-11-03. Unité AUD-SYS-01.2-02-SUMMONER-IGNITE-SERVER-01. Exigence parente SYS-01.2-02; tâche SUMMONER-SummonerDot-SERVER, exigence OLF-c13b0fc7-93e2-53ec-aafd-f3200f31b54a.

## Portée et critère

Relier la source historique disponible et les consommateurs locaux de ciblage, dégâts, soin et vision d'Embrasement; préciser cadence, refus, configuration et limites. Clôturer ce seul audit si sources, code courant, attentes, preuves réellement exécutées et corrections nécessaires sont documentés. Le fonctionnement complet de ce sort, les règles de serveur Riot, le réseau, la présentation et l'acceptation sont exclus.

## Sources et preuves antérieures

- Client fourni 4.20.0.315 PUBLIC EUW/en_GB : deploy/DATA/Spells/SummonerDot.inibin, OLS-039538f3-9b97-5d5c-a0da-161181745379, 1 746 octets, SHA-256 da501486c705554143541a7ba767f8e8258521a8d3d525519d10b99a9d65ce66, MD5 6daf50f25ad9ac91692514f84796007a. Le reçu docs/reference_native_skin_loader_sources/native-release-membership.json lie le membre au projet lol_game_client 0.0.1.7, fichier 0.0.1.7. Identité héritée, priorité de chargement effective non qualifiée; ce fichier client ne démontre pas le fonctionnement du serveur.
- Catalogue comparatif officiel 4.20.1 en_US, OLS-22f06d52-9752-5b89-863b-92b0614a555e, data/4.20/native_summoners_420.json:1, /data/SummonerDot : 70–410 dégâts bruts selon le niveau, cinq secondes, portée 600, recharge 180, soins reçus réduits de moitié et vision de la cible qui ne révèle pas les ennemis camouflés. Il s'agit d'une version/locale de comparaison distincte du serveur historique exact. La disponibilité Map10 n'est pas décidée ici.
- data/4.20/ignite_rules.json indique que les cinq ticks espacés d'une seconde avec premier tick immédiat et remplacement proviennent d'une reconstruction communautaire LeagueSandbox; cadence, recouvrement et instantané de niveau du serveur original restent inconnus. Les reçus docs/FIDELITY_SUMMONER_SELECTION_LINKS_4_20.md et docs/audit/units/AUD-17.1-04-SUMMONERS-01.md sont réutilisés pour le nom Ignite/SummonerDot, l'admission locale et les sources; pas de rehash ou nouvelle extraction inchangée.

requirement_trace.py exécuté avec .ai-tools/.venv/Scripts/python.exe pour SUMMONER-SummonerDot-SERVER : code 0; lien OLC-a1d7c55a-749b-518a-9fd0-b2654f72a3b1 sur summoners.rs:47. Le tableau unknown_ids vide et associated_sources_and_current_entrypoints ne prouvent pas les règles gameplay; game_behavior_accepted=false. Aucun registre modifié.

## Consommateurs et prédictions du code courant

summoners.rs:47–73 applique les gardes puis route Ignite vers summoner_ignite.rs:14–23. Après les gardes amont, une cible joueur ennemie, vivante, visible et à 600 unités ou moins reçoit l'effet; cible manquante, inconnue, alliée, morte, trop éloignée ou cachée est refusée avant création de la brûlure et recharge. Les messages sont distincts selon les branches. La distance inspectée est entre positions; le comportement à la bordure d'un modèle historique n'est pas établi.

summoner_ignite.rs:19–39 crée cinq ticks, stocke le niveau du lanceur borné à 1–18, applique immédiatement le premier puis prévoit un tick par seconde avant expiration à cinq secondes. Pour une cible qui survit sans remplacement, la lecture prédit 5 × 14 = 70 au niveau 1 ou 5 × 82 = 410 au niveau 18, avant absorption éventuelle par les boucliers. Un second lancement remplace l'effet existant; la mort du lanceur ne retire pas automatiquement l'effet, mais l'attribution après disparition de la source reste non qualifiée. Ces prédictions ne sont pas des résultats de jeu exécutés ni des règles serveur Riot confirmées.

healing.rs:9–13 et :38–39 utilise un multiplicateur 0,5 pendant la brûlure, combiné aux autres règles locales puis plafonné à la santé maximale. vision.rs:79–93 rend la cible visible pour l'équipe source pendant l'effet si les conditions de ce chemin sont réunies; sans interactions, la fonction retourne visible plus tôt. Ce chemin ne teste pas le camouflage avant son retour pour Ignite; il ne démontre donc pas la clause de non-révélation. Il ne prouve pas non plus l'absence globale d'un autre mécanisme de furtivité.

## Écart de configuration et contrôles

ignite_rules.json:10 expose first_tick_immediate=true. La structure Rules de summoner_ignite.rs:4–6 ne contient pas ce champ et n'a pas deny_unknown_fields; cast_ignite fixe next_tick au tick courant puis appelle apply_ignite_tick sans condition à :19–22. Par lecture, modifier seulement cette clé ne pilote donc pas le premier tick; aucun fichier n'a été modifié pour expérimenter cette prédiction. La question de la cadence historique reste distincte de cet écart entre configuration apparente et consommateur.

Les tests existants summoner_ignite.rs:53–119 décrivent notamment totaux sur 18 niveaux, cinq ticks, refus, soins, visibilité, boucliers et remplacement. Ils ont été lus et non exécutés pendant ce lot. Le test disconnected_source_does_not_cancel_remaining_damage_or_target_reveal ne vérifie que les dégâts et la présence d'effet après retrait du lanceur : malgré son nom, il n'appelle pas visible_to et ne prouve pas la révélation après déconnexion. Un ancien rapport cite une réussite de test ciblé à sa date; elle n'est pas une nouvelle exécution ni une preuve de la révision courante.

Contrôle Python en lecture seule exécuté, sortie 0 : comparaison des 18 valeurs du catalogue, lecture des paramètres locaux, présence de first_tick_immediate dans JSON et absence dans Rules, appel immédiat et ancre de vision. Ce contrôle inspecte texte et données, sans exécuter la mécanique Rust. Aucun test Rust, jeu, réseau ou build exécuté.

## Écarts et conditions de reprise

Audit statique de ce périmètre terminé; mécanique locale partielle; tests de jeu non exécutés; acceptation humaine non donnée. SUMMONER-SummonerDot-SCOPE reste a_qualifier et requis; SERVER et NET restent a_qualifier, conditionnels au scope, implementation_complete=false et acceptance_complete=false. L'absence d'unknown_ids dans la trace ne ferme pas les inconnues ci-dessous.

Réutiliser SCOPE pour qualifier carte et serveur de référence; SERVER pour qualifier cadence, instantané, remplacement, portée et réception des soins, et décider puis rendre explicite le contrat de first_tick_immediate; NET pour audiences et réplication. Après définition historique sourcée, vérifier premier tick, cinq instants, recouvrement, mort/déconnexion, portée limite, soins et boucliers. Vérifier explicitement la cible camouflée et la visibilité après déconnexion : le test nommé ci-dessus ne couvre pas ce dernier cas. Reprendre l'identification historique sur serveur 4.20 attribuable ou observation enregistrée fiable, et la correction d'interface de configuration après choix du contrat; ne pas refaire les hashes inchangés.

Relecture : périmètre, provenance, consommateurs, attendu/observé, limites, corrections existantes et preuves datées sont renseignés. Aucun code, registre, goal, application de suivi ou base modifié; aucune installation ni migration.