# SYS-18.1-05 — huit sources des sons de sélection

2026-11-01T20:46:35.659302+00:00

Le lot des huit sources /champSelect/ et de leurs relations statiques est terminé sous réserve de relecture indépendante. La fonction audio, le parent SYS-18.1-05 et le jeu restent ouverts.

## Résultat concret
Sept sources originales récupérées sur F totalisent 637 368 octets. Chaque fichier correspond exactement à la taille et au MD5 natifs du manifeste sélectionné. Le fichier lockinchampion.mp3, déjà admis, est réutilisé par identité sans téléchargement. Les huit fichiers totalisent 675 423 octets.

- assets/sounds/champSelect/lockinchampion.mp3 — 0.0.0.1, 38055 octets ; MD5 0cdb34ed9bf0ce8cbaf2462406c8d16b.
- assets/sounds/champSelect/yourturn.mp3 — 0.0.0.1, 67835 octets ; MD5 36030536bfd8690149b84a79f6835ec9.
- assets/sounds/champSelect/browseskins.mp3 — 0.0.0.1, 30496 octets ; MD5 16af3999470e0f39d13f5d74e4ee7a8c.
- assets/sounds/champSelect/exitchampionselect.mp3 — 0.0.0.1, 96569 octets ; MD5 ad5b12e51b03ed63d6c0d3b8bdfd5258.
- assets/sounds/champSelect/countdown10seconds.mp3 — 0.0.0.1, 190216 octets ; MD5 23fc4843de545fef6b5dff9d3e51be86.
- assets/sounds/champSelect/phasechangedrums2.mp3 — 0.0.0.1, 65184 octets ; MD5 c3aabdb6412d4aa67827a34e986649c2.
- assets/sounds/champSelect/traderequested.mp3 — 0.0.0.7, 38706 octets ; MD5 5a961399807edec2e8a2fd03bdbba8ee.
- assets/sounds/champSelect/unlockcelebration.mp3 — 0.0.1.89, 148362 octets ; MD5 314a7eeec2cb3de5e89ff2e1fb7958b3.

## Provenance et contrôles exécutés
Une recherche nouvelle retrouve les sept chemins exacts et leurs révisions propres ; 224 autres chemins ou versions restent séparés. Cinquante-cinq blocs d’archive sont regroupés en trois plages de contenu, 388 724 octets ; avec les descripteurs, dix réponses206 acceptées totalisent 389 667 octets. Taille, étendue, identité et corps sont conservés. Aucun téléchargement d’archive entière, installation ou lecture de média. Zstandard déjà présent décompresse l’archive et ne décode pas le MP3.

## Consommateurs natifs concrets
Les huit clés apparaissent dans 17 lignes AS exactes : huit constantes et neuf références de comportement, dont cinq appels play, un stop et trois appels de fabrique. Six appelants sont inspectés avec ChampionSelectionCommandFactory et PlaySoundCommand. La fabrique crée bien PlaySoundCommand avec le fournisseur ; execute délègue la clé à ISoundProvider.play. Aucun de ces codes n’est exécuté.
Le résultat antérieur du launcher courant est réutilisé par empreinte et portée frontend/Tauri. Il ne démontre pas une absence dans tout le moteur de jeu ou son HUD.

## Ordre, refus et limites à conserver
LockInCommand demande le son avant championSelectCompleted : le son ne prouve pas une confirmation serveur. Le contrôleur de tour demande le son quand le pickMode change vers actif ; les opérations de fenêtre natives voisines restent non exécutées.
ChampionSkinController.useSkin demande le son avant les refus de disponibilité, skin désactivé ou déjà choisi. Le timeout de 750ms arrive ensuite pour la sélection ; il ne prouve pas un retard de ce premier son. Le handler LCDS de trade demande le son avant setPendingTrade, sans prouver une transaction réseau.
Le son de départ est demandé dans STATE_GAME_STARTING seulement lorsque queuePosition==1. Le compte à rebours est demandé pour un temps restant >0 et <=10, un joueur actif et un nouveau tour ; un changement de tour arrête le précédent. Ni ce prédicat ni le nom countdown10seconds.mp3 ne prouvent la durée audible ou le producteur d’horloge.
Le son de phase est demandé avant l’affichage du tip ; le son de célébration dépend d’un teamSkinRental non nul, déverrouillé et d’une partie non nulle. Ne pas généraliser ce cas à tous les déverrouillages de propriété. Les sources et lignes exactes sont conservées.

## Ce qui reste ouvert
Le catalogue conserve 2 750 chemins médias : 23 ont une source native admise, 2 727 restent sans payload admis, soit 255 166 561 octets natifs déclarés. Les autres langues, voix dynamiques et FLV, les références XML non rapprochées et les limites précédentes restent incluses.
Non exécutés : codec MPEG, durée mesurée, écoute/lecture, changement de volume/périphérique, événements réseau, host AIR/Flash, logique native, session GUI, horloge, boucle/fade ou acceptation humaine. Aucun code produit, goal, critère, registre, suivi ou base modifié ; aucune installation ou migration.

## Clôture et reprise
Les sept rubriques sont documentées : périmètre, sources, consommateurs, attendu/observé, manques, corrections existantes et preuves/relecture. Seul ce lot de sources se clôt ; la présence d’un appel ne vaut pas fonctionnement reproduit.
Prochain lot : AUD-18.1-05-SOCIAL-QUEUE-SOUND-SOURCES-01 — neuf événements sociaux/chat/file d’attente et neuf sources à qualifier, par chemin/révision/taille/MD5 ou recherche bornée non concluante.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-CHAMPSELECT-SOUND-SOURCES-01, dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-CHAMPSELECT-SOUND-SOURCES-01 et ce rapport.
