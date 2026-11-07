# SYS-18.1-05 — huit chemins de sons UI anciens

2026-11-01T21:33:59.102325+00:00

Le lot des huit cibles et liens/recherches de consommateurs est terminé sous réserve de relecture indépendante. La fonction audio, les parcours UI, le parent SYS-18.1-05 et le jeu restent ouverts.

## Sources et décomptes
Les huit chemins natifs sont conservés et conformes à leur taille/MD5 : 587 535 octets déclarés sommés par chemin, six identités SHA256 distinctes totalisant 360 331 octets. Les paires normal/désactivé des sons de combobox ont des octets identiques mais gardent leurs noms, clés et attributs. Les 45 admissions précédentes ont été comparées par taille/MD5 : aucune ne fournissait ces nouvelles cibles.

- assets/sounds/openstore.mp3 — 0.0.0.1, 25216 octets ; MD5 d59ab2744e46d0529610fb2fa70b46db.
- assets/sounds/closeplayscreen.mp3 — 0.0.0.1, 55456 octets ; MD5 dc495b426b552bb2e253af5b97265b35.
- assets/sounds/summon_champion.mp3 — 0.0.0.1, 42384 octets ; MD5 ee38c2b0701985d9885ecb4667bdc859.
- assets/sounds/button_locked.mp3 — 0.0.0.1, 10071 octets ; MD5 0840656836bae6da9a2ff37934a50756.
- assets/sounds/cb_item_rollover.mp3 — 0.0.0.1, 133246 octets ; MD5 de18ded0d7ff604480cb3116770a25f5.
- assets/sounds/cb_item_rollover_disabled.mp3 — 0.0.0.1, 133246 octets ; MD5 de18ded0d7ff604480cb3116770a25f5.
- assets/sounds/cb_rollover.mp3 — 0.0.0.1, 93958 octets ; MD5 65d4c1d468f2fccf5bae83616e904dd7.
- assets/sounds/cb_rollover_disabled.mp3 — 0.0.0.1, 93958 octets ; MD5 65d4c1d468f2fccf5bae83616e904dd7.

## Archive : alias conservés et reçus distincts
Huit chemins/révisions exacts sont retrouvés ; 307 autres candidats restent séparés. Les huit cibles correspondent à sept identifiants de descripteur : le descripteur partagé garde ses deux lignes logiques. Une autre paire d’octets identiques a deux identifiants d’archive différents ; l’identité d’octets ne se déduit donc pas du seul ID.
Les34blocs uniques sont transportés en cinq plages,196 382octets de contenu. Avec les descripteurs,12réponses206 distinctes totalisent197 101octets. Le résultat de récupération compte13références d’utilisation car le descripteur commun est réutilisé unefois,sans nouvelle requête HTTP. Ces mesures restent séparées. Aucun alias perdu ou ancien succès rejoué ; Zstandard existant décompresse l’archive sans codec MP3.

## Consommateurs et limites
La recherche exacte relève14lignes dans quatre fichiers : huit constantes,quatre play,une liaison de constructeur et un défaut de clé. SOUND_GAME_TYPE_SELECT_CLICK et SOUND_CHAMPION_SUMMON n’ont que leur constante dans cette requête ; leurs routes dynamiques/sérialisées restent ouvertes sans conclusion d’inutilité globale.
Le store passe sa clé au troisième paramètre de ScalingButtonX,puis AudioButton. Le champ s’appelle _mouseDownSoundKey mais le listener réel est MouseEvent.CLICK. Le ToggleButtonBar relie disabledOverKey à son handler de ROLL_OVER et teste l’état enabled de la barre. SoundComboBox retourne si isOpen lors du survol du contrôle ; ses branches enabled/provider choisissent les clés normal/désactivé. Aucun événement GUI n’est exécuté.
Cinq volumes XML valent zéro ; ce sont des déclarations, pas une mesure audible. Le provider construit les voix de champion à partir de locale/skinName dans assets/sounds/{locale}/champions ; le fichier générique summon_champion.mp3 ne remplace pas ces voix et ne qualifie pas les122champions.

## Échec conservé et relecture
La qualification_v1 s’arrête sur une erreur de syntaxe avant tout résultat de qualification. Son source est conservé comme texte non exécuté. Une version distincte corrige l’espacement, passe la vérification AST puis termine avec code0 ; aucune source native ou preuve précédente n’est réécrite.

## Reste et prochain lot
Le catalogue reste de2 750chemins :53avec source admise,2 697sans payload admis,pour253 287 862octets déclarés sommés par chemin. Ces décomptes ne sont pas des assets uniques ni un pourcentage du jeu. Toutes langues,voix dynamiques,FLV et limites précédentes restent incluses.
Non exécutés : logiqueAIR/jeu,GUI,réseau,codec/écoute/lecture,volume/périphérique,durée/boucle/fade ou acceptation humaine. Le contrôle précédent du launcher courant est réutilisé par identité et portée frontend/Tauri ; aucune absence globale prétendue dans le moteur.
Les sept rubriques sont remplies pour ce lot ; goal,critères,registres,code produit,suivi et bases inchangés. Aucune installation,migration ou application relancée.
Prochain lot : AUD-18.1-05-AIR-TUTORIAL-EN-GB-VOICE-SOURCES-01 —24voixAIR du tutoriel en_GB. Les24candidatsen_US restent explicitement différés ; cela ne qualifie pas le fonctionnement du modeBattleTraining ni les autres langues.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-LEGACY-UI-SOUND-SOURCES-01, dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-LEGACY-UI-SOUND-SOURCES-01 et ce rapport.
