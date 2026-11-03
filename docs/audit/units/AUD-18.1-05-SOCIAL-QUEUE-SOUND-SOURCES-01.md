# SYS-18.1-05 — neuf sources sociales, chat et file d’attente

2026-11-01T20:56:25.694848+00:00

Le lot de neuf sources et de leurs liens/recherches de consommateurs est terminé sous réserve de relecture indépendante. Il ne termine ni la fonction audio, ni le parent SYS-18.1-05, ni le jeu.

## Résultat concret
Neuf sources originales sont récupérées uniquement comme références sur F : 249 963 octets, tous conformes aux tailles et MD5 natifs. Les 23 admissions antérieures sont conservées.

- assets/sounds/buddy_invite.mp3 — révision 0.0.0.1, 30077 octets ; MD5 0e50b63208c8516f8d165e8fa5a4f2b7.
- assets/sounds/standard_msg_receive.mp3 — révision 0.0.0.1, 8546 octets ; MD5 8fef61957e22c7b2b3ab8d36e77312f9.
- assets/sounds/pm_receive.mp3 — révision 0.0.0.1, 28667 octets ; MD5 bd3f936a0e7436e1a1c81dffc2de5448.
- assets/sounds/chat/air_event_invited_1.mp3 — révision 0.0.0.1, 28171 octets ; MD5 334c7bc4e3f8877108385282363a6619.
- assets/sounds/join_chat.mp3 — révision 0.0.0.1, 8129 octets ; MD5 892d3a0d34f2e84360ae44e09fd6d481.
- assets/sounds/leave_chat.mp3 — révision 0.0.0.1, 8129 octets ; MD5 33d8196af0d8d94f5b053a3c689a360f.
- assets/sounds/restrict_chat.mp3 — révision 0.0.1.58, 18268 octets ; MD5 732799b18b069add0d4365b80b54e681.
- assets/sounds/chat_room_request.mp3 — révision 0.0.0.1, 19805 octets ; MD5 c9731bcdbbf08a88f5e2d53623a514d8.
- assets/sounds/matchmakingqueued.mp3 — révision 0.0.0.1, 100171 octets ; MD5 a8315ccfa8c7bedb134a18b0ead8b62c.

## Provenance et contrôles
Une recherche nouvelle identifie neuf chemins/révisions exacts ; 302 autres candidats restent séparés. Trente et un blocs de contenu sont transportés en huit plages, 204 528 octets de corps ; avec les descripteurs, dix-sept réponses206 acceptées totalisent 205 105 octets. Aucun ancien succès rejoué, archive entière téléchargée ou logiciel installé. Zstandard existant décompresse l’archive, pas le codec MP3.

## Consommateurs et limites établis
Les neuf clés donnent 32 lignes AS exactes dans dix fichiers : neuf constantes, vingt-deux appels play et un appel de fabrique. PlatformInviteActionFactory.playSound délègue au fournisseur réel. SOUND_CHAT_ROOM_REQUEST n’a que sa déclaration constante dans cette requête ; sa route dynamique/sérialisée reste inconnue, sans conclusion d’inutilité globale.
SOUND_GAME_INVITE est demandé par un handler d’invitation de salon et par ShowGameInviteAction. Le nom ne signifie donc pas uniquement invitation à une partie. Le son MATCHMAKING_QUEUED apparaît dans des transitions vers la sélection, pas comme preuve d’un son lors de toute entrée initiale en file.
Les deux CoreChatTextArea viennent de classes/modules différents, mod/cs et mod/man ; leurs gardes de fournisseur diffèrent. Les chemins et sources sont conservés séparément. TailedChatView vérifie la présence du fournisseur par type de message. ChatRoomView filtre certains messages bloqués et conditionne les sons au paramètre de route.
La restriction de chat distingue le rôle visiteur et le passage vers un état suspendu qui n’était pas déjà restreint. Le bip privé vérifie une liste non vide, un utilisateur local et un dernier expéditeur différent de soi. Ces gardes de source ne prouvent pas une session, un filtre ou une notification effectivement exécutés.

## Correction documentaire héritée
Une phrase anglaise du content-map du lot de sélection précédent disait « five », alors que les données structurées contenaient sept descripteurs. L’erratum identifie la source et le champ ; les sept sources, MD5 et preuves acceptées restent inchangés. La phrase du nouveau plan mentionne correctement les neuf cibles. Aucun artefact antérieur n’est écrasé.

## Reste ouvert
Le catalogue garde 2 750 chemins : 32 sources sont maintenant admises, 2 718 chemins restent sans payload admis, soit 254 916 598 octets natifs déclarés. Les langues, voix dynamiques, FLV, références XML non rapprochées et limites antérieures restent incluses.
Non exécutés : messages ou invitations réels, réseau, host AIR/Flash, logique originale, GUI, codec MPEG, écoute/lecture, volume/périphérique, durée/timing/boucle/fade ou acceptation humaine. Le contrôle précédent du launcher courant est réutilisé par identité et portée frontend/Tauri, sans absence globale affirmée dans le moteur de jeu.

## Clôture et reprise
Les sept rubriques sont documentées : périmètre, sources, consommateurs/recherche bornée, attendu/observé, limites, tâches réutilisées et preuves/relecture. Goal, critères, registres, code produit, suivi et bases restent inchangés ; aucune installation ou migration.
Prochain lot : AUD-18.1-05-RUNES-MASTERIES-SOUND-SOURCES-01 — dix événements runes/maîtrises et dix sources à qualifier, avec réutilisation des indices/contrats et recherches seulement nouvelles.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-SOCIAL-QUEUE-SOUND-SOURCES-01, dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-SOCIAL-QUEUE-SOUND-SOURCES-01 et ce rapport.
