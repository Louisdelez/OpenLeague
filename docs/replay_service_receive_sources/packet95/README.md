# Paquet replay 0x95 — préparation qualifiée en scratch

Source : `League of Legends.exe` 4.20, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Port et intégration

Fichiers à intégrer : `audio_replay_packet95.rs`, `audio_replay_packet95_tests.rs`, fixture `replay_packet95_probe.json`. Module séparé, aucune mutation de production effectuée.

API :

- `acquire_global(b, destination) -> Result<(), Error>` ; `Storage + audio_replay_shared_pair::Boundary`.
- `consume_payload(b, payload, scratch8) -> Result<(), Error>` ; `Boundary`.
- `consume_packet(b, packet, scratch8) -> Result<u8, Error>` ; branche 0x95 déjà sélectionnée par le caller.
- `Boundary::receive_payload(recipient, method, payload) -> Result<(), &'static str>` ; contrat terminal explicite, aucun handler de jeu reconstitué arbitrairement.
- `GLOBAL_PAIR = 0x14C761C`, `SCRATCH_BYTES = 8`.

Le scratch est huit octets frais, disjoints du paquet, des globals et des allocations vivantes. Il n'est pas zéro après destruction, conformément au code natif. Le caller fournit la validité du paquet : ce module ne lit aucun octet de son payload et ne peut en déduire une taille minimale acceptable pour le destinataire réel.

## Preuves de l'ordre

- `58A6F2` : `lea ecx,[ebx+5]`, appel `577E90`, puis `mov al,1` à `58A6FA`. Le pointeur transmis est le paquet original +5 même pour un header étendu. AL1 signifie retour normal de la branche, y compris sans destinataire.
- `577EBD/577EC4` : zéro des deux mots temporaires avant acquisition.
- `5CC144` lit l'objet global, `5CC14D` le contrôle global ; `5CC164` incrémente le compteur fort ; `5CC16B` lit l'ancien contrôle destination ; ses éventuelles dispose/release précèdent la publication.
- `5CC19A/5CC19E` ou `5CC1A8/5CC1AC` : publication du contrôle avant l'objet, avec valeurs capturées conservées malgré les mutations de callback.
- `577ED7` teste l'objet ; `577EDE` lit `[object]` pour obtenir le destinataire ; `577EE1/577EE3` appellent son virtual+0 avec un unique argument payload. Il faut conserver cette indirection supplémentaire.
- `577EEC` relit le contrôle temporaire après l'appel destinataire. `577EFB` décrémente le compteur fort ; `577F05` dispose si nécessaire ; `577F0A` décrémente le compteur faible ; `577F11` relit la vtable avant `577F15` release.

`shared_pair::copy` n'est pas employé : son ordre control/object est différent. Seuls les helpers équivalents `release_control` et `destroy` sont réutilisés directement depuis la production.

## Vérifications réellement exécutées

`probe_packet95.py` exécute les corps originaux dans Unicorn, sans remplacer 588290, 577E90 ou 5CC140 :

- 148 consommateurs passant réellement par le switch 588290, AL1 comparé ; fills 00/A5 ; global nul, objet seul, contrôle seul, paire partagée ; compteurs 0/1/2/MAX ; mutations du global, libération de son propriétaire externe, vtable et compteur faible.
- 192 acquisitions directes, destinations vides/distinctes/identiques/globales ; remplacement avec callbacks modifiant la source ou la vtable.
- 3 468 événements ordonnés : accès aux mots métier sélectionnés, XADD atomiques, entrée des appels virtuels et arguments ; état final de tous les mots sélectionnés comparé.
- Les appels virtuels terminaux sont des adaptateurs d'observation explicites. Ils ne représentent ni le traitement du jeu, ni un destructeur concret. La libération de propriétaire dans un callback est limitée aux comptes initialement vivants 1/2 ; les autres valeurs sont des contrats arithmétiques synthétiques, pas des paires valides garanties.

Harnais `packet95_harness.rs` : 26 modules réels, compilation rustc isolée réussie ; **3 tests passés, 0 échec, 67 filtrés, 0,04 s**. Deux tests comparent les 340 contrats natifs ; le troisième vérifie les erreurs Rust (destinataire indisponible, lecture invalide, débordement, erreur de cleanup combinée).

Le seul warning Rust est l'import `Memory` inutilisé déjà présent dans `audio_announcer_descriptor_insert.rs`. Aucun Cargo, aucun lancement Windows, aucune qualification d'intégration moteur/client dans ce sous-travail.

## Limites explicites

Le chemin nul est natif et complet dans ce périmètre. Pour une paire non nulle, le module transfère correctement l'appel au destinataire explicite ; son corps réel demeure à raccorder. Aucune réception de gameplay fonctionnelle n'est affirmée. Les traces n'incluent pas le prologue, le cookie, les locaux inutiles de pile, ni des accès hors des mots métier sélectionnés. L'émulation séquentielle ne qualifie pas les accès concurrents. Les erreurs Rust libèrent une référence acquise mais ne constituent pas un port de l'unwinding MSVC ; un échec de primitive de cleanup reste signalé.

Les sources/fixtures/empreintes exactes sont consignées dans `packet95_receipt.json`. Tous les fichiers restent dans `E:\mapslol3v3\replay_packet95_agent`.
