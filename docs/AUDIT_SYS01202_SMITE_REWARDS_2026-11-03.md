# SYS-01.2-02 — Châtiment : récompenses et variantes de jungle

Date : 2026-11-03. Unité AUD-SYS-01.2-02-SMITE-REWARDS-01. Exigence parente SYS-01.2-02; tâche SUMMONER-SummonerSmite-SERVER, exigence OLF-d6d459b8-0631-5624-b23d-b4f65551c033.

## Portée et critères

Relier les informations disponibles sur les récompenses d'un grand monstre au parcours courant de Châtiment; distinguer récompense ordinaire de mort, bonus propre à Châtiment et refus des variantes d'objet. Vérifier ce que démontre le test de récompense existant. Ne pas réauditer les 28 profils de ciblage déjà traités dans V279, ni qualifier l'ensemble du sort, la carte, le réseau ou l'acceptation.

## Sources, provenance et acquis

- Source client fournie 4.20.0.315 PUBLIC EUW/en_GB, OLS-a9ff6721-0b18-5b47-9d06-2c247b7f39b8, DATA/Spells/SummonerSmite.inibin, 817 octets, SHA-256 aa0fda30f20711dc422e9ab73133cb491e6c9d158aacfbe4cd8735a085dacc1d et MD5 1a891f8e7e2cc66ed62b2b98c23edbc6. Le reçu de membership natif rapporte le projet lol_game_client 0.0.1.7 et membre 0.0.1.7; priorité runtime non qualifiée. V279 décode CastRange=760.0000; ceci ne prouve pas la géométrie serveur.
- Catalogue officiel comparatif 4.20.1 en_US, OLS-22f06d52-9752-5b89-863b-92b0614a555e, data/4.20/native_summoners_420.json:1 /data/SummonerSmite : tableau 390–1000 de dégâts bruts sur 18 niveaux, portée 760, recharge 90 et texte mentionnant des bonus dépendant des grands monstres. Le texte ne précise ni chaque bonus ni son application sur Map10. Le catalogue ne qualifie pas à lui seul le serveur historique EUW/en_GB.
- Réutiliser docs/FIDELITY_SMITE_TARGET_GRAPH_V279.md : profils, provenance des tags, limites des cibles et trois tests exécutés antérieurement sur le binaire V235 identifié dans ce rapport. Ces tests ciblaient l'admission, pas les bonus; ils n'ont pas été rejoués ici et ne prouvent pas la révision courante. Les hashes n'ont pas été répétés.

La lecture .ai-tools/.venv/Scripts/python.exe -B tools/project-plan/requirement_trace.py --root F:/OpenLeague --task SUMMONER-SummonerSmite-SERVER est sortie avec code 0. Elle relie sources et dispatch OLC-a1d7c55a-749b-518a-9fd0-b2654f72a3b1; unknown_ids vide et game_behavior_accepted=false ne démontrent pas une mécanique complète. Aucun registre modifié.

## Parcours courant et distinctions

summoners.rs:47–73 dirige le sort vers summoner_smite.rs:62–94. Après les gardes de cible et d'état, le code applique les dégâts bruts par apply_damage puis inscrit une recharge locale provisoire de 90 secondes. L'application appelle le chemin partagé de dégâts; world.rs:355–392 gère notamment la réaction du camp et :420–451 attribue l'or et l'expérience ordinaires selon ses règles. Ces récompenses génériques ne constituent pas les bonus spécifiques au lancement de Châtiment.

Le fichier data/4.20/smite_rules.json:393 indique explicitement que les variantes d'objets et récompenses Smite de camp ne sont pas prises en charge. Dans cast_smite :70–77, un objet parmi les 31 identifiants jungle listés, ou un objet inconnu du catalogue local, est refusé avant la branche de dégâts et de recharge. Ce refus est une politique actuelle; il ne prouve pas que ces objets ou bonus devaient s'appliquer au mode historique.

## Attendu, observé et limites de test

Le catalogue de comparaison décrit des bonus liés aux grands monstres, sans les détailler pour Map10. Observation statique du chemin et déclaration de limites locales : aucun producteur de bonus de camp propre à Smite n'est identifié dans cast_smite; la politique locale indique explicitement qu'ils manquent. La recherche ciblée de noms Smite et reward/bonus/bounty dans crates/core/src et smite_rules.json n'a produit que la déclaration et le nom de test générique; elle ne prétend pas exclure toute logique sous d'autres noms ailleurs. Les récompenses ordinaires après mise à mort restent présentes.

summoner_smite_tests.rs:172–187 attend qu'un monstre tué accorde de l'or et de l'expérience et refuse un second coup. Il ne vérifie pas de bonus spécifique Smite. Son assertion d'aggro utilise all sur les autres unités du camp vivantes sans exiger explicitement qu'il en existe : elle peut réussir pour une collection vide; ce constat n'établit pas que la fixture actuelle soit vide ni que la mécanique d'aggro échoue. La plupart des fixtures :3–11 désactivent les interactions; le test distinct :105–117 réactive la vision. Aucun test n'a été exécuté ici.

Contrôle Python en lecture seule exécuté, code 0 : les 18 montants locaux correspondent au tableau du catalogue; présence des 31 IDs refusés, de la déclaration de bonus manquants, de l'appel de dégâts partagés, des ancres d'or/XP et de l'assertion universelle. Contrôle de texte/données uniquement, sans compilation, simulation Rust ou partie.

## Corrections et conditions de reprise

Audit de ce périmètre terminé; implémentation des bonus/variantes explicitement manquante, fonctionnalités génériques partielles; vérification en jeu non exécutée et acceptation humaine non donnée. SCOPE reste requis et a_qualifier; SERVER et NET restent conditionnels et a_qualifier, implementation_complete=false et acceptance_complete=false.

Réutiliser SUMMONER-SummonerSmite-SCOPE pour déterminer les bonus et variantes applicables à Map10 à partir d'une source serveur 4.20 attribuable ou d'une observation historique fiable. Réutiliser SERVER pour intégrer uniquement les bonus effectivement établis et la gestion des objets appropriée; NET pour leurs événements et états. Après qualification, tester grand monstre vivant non tué puis tué, comparaison or/XP génériques et bonus spécifique, cible/refus, objets pris en charge et refusés, ainsi que non-duplication. Pour le test d'aggro, exiger d'abord au moins une autre unité vivante du camp avant de vérifier sa cible. Ne pas inventer de bonus Map10 à partir du tooltip général ni répéter V279 sans nouvelle piste.

Relecture : portée, provenance, consommateurs, cas et limites, corrections existantes et preuves datées renseignés. Aucun code, registre, goal, application de suivi ou base modifié; aucune installation ni migration.