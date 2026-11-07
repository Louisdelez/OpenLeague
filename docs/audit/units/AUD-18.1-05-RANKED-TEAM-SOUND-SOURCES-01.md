# SYS-18.1-05 — trois sources et six clés d’équipes classées

2026-11-01T21:16:11.403478+00:00

Le lot des trois sources et six liens/recherches de clés est terminé sous réserve de relecture indépendante. La fonction audio, les équipes classées, le parent SYS-18.1-05 et le jeu ne sont pas déclarés terminés.

## Résultat concret
Trois fichiers originaux sont récupérés sur F comme références : 294 930 octets, tous conformes aux tailles et MD5 natifs. Les 42 admissions antérieures sont conservées. Team_Accept_1 et Team_Accept_3 ont chacun112 230octets, mais des MD5/SHA différents ; ils ne sont pas fusionnés.

- assets/sounds/rt/Team_Accept_1.mp3 — 0.0.0.120, 112230 octets ; MD5 b46d4f55f2b5654e321a0b638c12a13e.
- assets/sounds/rt/Team_Accept_3.mp3 — 0.0.0.120, 112230 octets ; MD5 6bf4e12b4265c6a20f468aa49a8ded0a.
- assets/sounds/rt/Team_Invite_1.mp3 — 0.0.0.120, 70470 octets ; MD5 36a2e3571dd3add4e98a6764272ba221.

## Provenance et contrôles
Trois chemins/révisions exacts sont retrouvés par une nouvelle recherche ; 51 autres candidats restent séparés. Les27blocs de contenu sont transportés en une plage,189 356octets ; avec les descripteurs,quatre réponses206 acceptées totalisent189 815octets. Zstandard existant décompresse l’archive, sans codec MP3, installation ou archive entière téléchargée.

## Alias et consommateurs
Les six clés XML et leurs attributs sont conservés. Les fichiers sont partagés par paires : RT_TEAM_ACCEPT_1/TEAM_ACCEPT, RT_TEAM_ACCEPT_3/OTHER_TEAM_ACCEPT et RT_TEAM_INVITE_1/TEAM_INVITE. La recherche exacte relève six constantes et quatre play dans quatre fichiers AS. Les trois alias sans préfixeRT n’ont que leur constante dans cette recherche, sans conclusion d’inutilité globale ou absence de route dynamique.
PlayerProxy demande ACCEPT_1 dans onJoinTeamSuccess après récupération du joueur/mise à jour de présence, avant notifications. TeamProxy le demande dans la branche où le résultat de création se convertit en Team. Aucun résultat de service n’est exécuté ou validé par cet audit.
PlayerNotificationController montre les prompts avant d’appliquer deux gardes strictes : différence getTimer/dernier timestamp >10000 pour autre joueur ayant rejoint et >2500 pour invitation. Les timestamps changent dans la branche de requête du son. Horloge, initialisation effective, wraparound, fréquence audible et GUI restent non exécutés.
RankedTeamsProvider déclare soundManager:ISoundProvider = SoundProviderProxy.instance ; RTFacade conserve le provider typé. Le cache AudioProviderImpl, déjà qualifié, est indexé par la clé. Un fichier partagé ne prouve donc pas une même route ni une même instance/cache en fonctionnement.

## Reste ouvert et reprise
Le catalogue reste de2 750chemins :45sources admises,2 705sans payload admis,soit253 875 397octets natifs déclarés. Langues,voix dynamiques,FLV et limites précédentes restent incluses. Le résultat précédent du launcher courant est réutilisé par identité et portée frontend/Tauri, sans absence globale prétendue dans le moteur.
Non exécutés : logiqueAIR/jeu,service/invitation/réseau,GUI,horloge,codec/écoute/lecture,volume,périphérique,durée/boucle/fade ou acceptation humaine. Goal,critères,registres,code produit,suivi et bases inchangés ; aucune installation ou migration.
Les sept rubriques sont documentées pour ce lot : périmètre,sources,consommateurs/recherche bornée,attendu/observé,limites,tâches réutilisées et preuves/relecture.
Prochain lot : AUD-18.1-05-LEGACY-UI-SOUND-SOURCES-01 — huit sources UI anciennes(store/play/champion/combobox/disabled),avec leurs clés et volumes déclarés.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-RANKED-TEAM-SOUND-SOURCES-01, dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-RANKED-TEAM-SOUND-SOURCES-01 et ce rapport.
