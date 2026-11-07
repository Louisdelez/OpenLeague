# SYS-18.1-05 — dix sources runes et maîtrises

2026-11-01T21:06:00.755141+00:00

Le lot des dix sources et de leurs liens statiques est terminé sous réserve de relecture indépendante. Il ne termine ni les actions de runes/maîtrises, ni la fonction audio, ni le parent SYS-18.1-05 ou le jeu.

## Résultat concret
Dix fichiers originaux sont récupérés sur F comme références : 746 271 octets, tous conformes aux tailles et MD5 natifs. Les 32 admissions antérieures sont conservées.

- assets/sounds/runes/air_event_combinrune_1.mp3 — révision 0.0.0.1, 130572 octets ; MD5 892737b66c9afcf9bc77249165b98546.
- assets/sounds/runes/air_event_runedrop_1.mp3 — révision 0.0.0.1, 40999 octets ; MD5 e13c22024f0142b86aa17c629334c4d2.
- assets/sounds/runes/air_event_runedrop_2.mp3 — révision 0.0.0.1, 69966 octets ; MD5 0b168a75578c02c4d5c48a0823f4a5f3.
- assets/sounds/runes/air_event_runedrop_3.mp3 — révision 0.0.0.1, 95751 octets ; MD5 c7ba174f4cab5457408c95012b43dc8e.
- assets/sounds/runes/air_event_runedrop_4.mp3 — révision 0.0.0.1, 94497 octets ; MD5 33a2315fffc9fdb30185cc75e47ecce9.
- assets/sounds/runes/air_event_runedrop_5.mp3 — révision 0.0.0.1, 95333 octets ; MD5 2fda98938568015a9a91e623071c2fb4.
- assets/sounds/runes/air_event_runedrop_6.mp3 — révision 0.0.0.1, 96169 octets ; MD5 52d96f3240116039dc61f14feccf9d3e.
- assets/sounds/runes/air_event_runedrop_7.mp3 — révision 0.0.0.1, 93372 octets ; MD5 7625bc987f94fcde2b473df427bed73b.
- assets/sounds/masteries/masteries_sfx_addpoint.mp3 — révision 0.0.0.227, 21859 octets ; MD5 50b7a1faa2de769846fd8c242d2c0459.
- assets/sounds/masteries/masteries_sfx_removepoint.mp3 — révision 0.0.0.227, 7753 octets ; MD5 d35e3ba92eed02491980a429948bd29c.

## Provenance et vérifications
Une recherche nouvelle retrouve dix chemins/révisions exacts ; 338 autres candidats restent séparés. Les 77 blocs de contenu sont transportés en deux plages, 695 202 octets ; avec les descripteurs, douze réponses206 acceptées totalisent 696 524 octets. Archive décompressée par Zstandard déjà présent, sans décodage MP3, installation ou téléchargement d’archive entière.

## Consommateurs et identités de clés
La recherche exacte donne 22 lignes dans cinq fichiers : dix constantes AudioKeys publiques, dix appels play et deux déclarations privées de chemin. Les vingt lignes publiques relient chacune des dix clés à un appel natif statique. Les deux constantes privées de MasteriesController portent les mêmes identifiants add/remove, mais désignent masteries_addpoint.mp3 et masteries_removepoint.mp3 ; les XML publics désignent masteries_sfx_addpoint.mp3 et masteries_sfx_removepoint.mp3. Ces chemins ne sont ni fusionnés ni substitués. Leur lecteur/usage privé reste non qualifié.
RunesTransportationController refuse une rune nulle, demande DROP_2 pour BLACK_RUNE et DROP_1 sinon, puis écrit le slot et émet le signal. Le combinateur utilise la longueur de la liste de runes : cas1..5 vers DROP_3..7, sans demande par défaut dans ce sélecteur. Ce constat n’est pas une exécution de la logique ni une qualification générale de l’aléatoire du jeu.
Le callback de combinaison réussie met les slots à jour, prépare la récompense, demande le son puis change l’état et démarre les timers. Récompense, résultat serveur, animations et délais réels restent non exécutés.

## Garde de maîtrises et limites
Le médiateur convertit le delta de clic, appelle augmentation ou diminution, puis choisit le son à partir des codes de résultat. La garde externe décompilée contient des inégalités reliées par ||. Elle est conservée littéralement : pas de remplacement silencieux par && ni d’acceptation comme filtre d’erreur effectif sans qualification ABC/VM. Cet audit ne résout pas les caps4312/4313, la persistance serveur ou les règles des talents.
Le résultat précédent du launcher courant est réutilisé par identité et portée frontend/Tauri, sans absence globale prétendue dans le moteur de jeu. Aucune logique AIR, action utilisateur, communication serveur, GUI, lecture, codec MP3, volume, durée, boucle/fade ou acceptation humaine exécutée.

## Reste et reprise
Le catalogue reste de 2 750 chemins : 42 ont une source admise, 2 708 restent sans payload admis, soit 254 170 327 octets natifs déclarés. Autres langues, voix dynamiques, FLV et limites précédentes restent incluses.
Les sept rubriques documentaires sont remplies pour ce lot : exigence, sources, consommateurs, attendu/observé, manques, corrections réutilisées et preuves/relecture. Goal, critères, registres, code produit, suivi et bases inchangés ; aucune installation ou migration.
Prochain lot : AUD-18.1-05-RANKED-TEAM-SOUND-SOURCES-01 — six clés d’équipes classées partageant trois fichiers à qualifier.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-RUNES-MASTERIES-SOUND-SOURCES-01, dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-RUNES-MASTERIES-SOUND-SOURCES-01 et ce rapport.
