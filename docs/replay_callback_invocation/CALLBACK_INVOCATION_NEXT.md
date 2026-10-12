# Prochaine intégration : invocation des callbacks replay

Lecture statique du PE 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, recalculé pendant cette revue. Source : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`. Aucune invocation exécutée, aucun build, aucune modification production. Les fichiers `invocation_*.txt` ci-joints contiennent les régions ciblées ; les tables sont lues comme données, pas comme instructions.

## Réutiliser les ports existants

`audio_replay_events.rs` porte déjà `729370` (dispatch), `729D70` (mise à jour metadata) et `734130` (wrapper membre ajusté). Les implémentations de son `Boundary` restent dans les tests : pas de raccordement au `Backend` canonique Windows constaté. Les tests existants injectent les consommateurs terminaux ; ils ne prouvent pas leur intégration réelle.

`audio_replay_callbacks::invoke` renvoie encore explicitement une erreur et n'accepte aucun argument. Il faut un dispatch adapté aux signatures et aux valeurs de retour, pas remplacer cette erreur par un succès générique.

Métadonnées déjà portées : construction512 (`727DE0` + suffixe dérivé inline de `728FD0`), clear `7280B0`, destruction `727F80/729D20`, contrôle partagé `5A3220` dans `audio_replay_metadata.rs`. `729D70` est porté dans `audio_replay_events.rs`, mais ses getter/setter virtuels sont encore des frontières. Non portées dans les modules inspectés : `728150` (VT+8), `7281C0` (VT+C), `7285B0` (VT+28), `728830` (VT+3C), `728A60` (VT+5C) et son helper d'insertion `64D040`. Le clear existant préserve précisément le troisième arbre à+18 que `728A60` modifie ; sa destruction existe déjà.

## Chaînes exactes et éléments manquants

| Départ | Chemin source | Frontière à raccorder |
|---|---|---|
| Callback parent `108606C+8` | `5CCEB0` copie `*arg0`, transmet 5 arguments et utilise owner+4/member+8 ; membre `729370` | Wrapper 12 octets distinct de `734130`, qui lit l'ajustement à +12. Puis réutiliser `events::dispatch`. |
| Parent +20 | `109B2D4+8 =65E9E0` ajuste this par +C, puis `738A3A` → service.vtable+34 | VT `10AFE8C+34 =72B2D0` → `72B2F0`. Ce consommateur filtre les types de paquets puis appelle `72EC40`, `72EEC0` et éventuellement `588290`. Aucun de ces consommateurs n'est porté dans les sources core/client inspectées. |
| Parent +24 | `10AFCFC+8 =7341D0` transforme le second argument référencé en valeur, ajuste this, puis `72B950` | Switch réel des événements 1..5, décrit ci-dessous. |
| Bundle +12 / +16 | `1086078+8 =5CCE30` transmet les arguments inchangés à `729B70` / `729C50` | Construction des messages puis stream.vtable+1C = `8F6C20`. Cette méthode appelle implementation.vtable+20 si stream+64 non nul. |
| Bundle +4 / parent +2C par défaut | `734080` → `71EC30` / `733F70` → `586230` | Les deux membres retournent effectivement AL=0 dans le PE. Ces feuilles peuvent être portées fidèlement, sans inventer un consommateur. |

`729370` décode le bas octet du sélecteur : 2→parent+24(event2, contexte référencé), 4→écrit parent+4/contexte et +3C=0 puis event1, 5→event5. Sélecteur3 : sous-types2/3/4→parent+20 ; 5/6→bundle+4/+8 ; 7 et opcodes101/102→metadata.vtable+28/+3C (`7285B0`/`728830`), opcode103→`729D70` puis parent+2C. Les getters/setters de `729D70` visent metadata.vtable+C/+8 (`7281C0`/`728150`). Ces méthodes metadata restent à relier au port de durée de vie existant.

`72B950` : table exacte `72C324` = [72B9A8,72BD30,72C2FB,72C2F9,72C2B3].

- Événements 3 et 4 : retour AL=0, aucune action métier.
- Événement 5 : récupère le shared pair metadata via `729C80`, appelle vtable+5C=`728A60`, puis détruit le temporaire via `5BD3C0`, retourne AL=1. `728A60` recherche/insère la clé dans l'arbre metadata+18 via `64D040`, puis écrit la valeur2. C'est une prochaine branche utile et bornée.
- Événements 1/2 : objets de reporting `5F7000/5F69D0/5F6EA0`, chaînes, logs `5FA170`, état de connexion global `2D788D4`, gestionnaires `2D77E54+E0`, `7F5C70/7F5CC0`. Événement1 peut appeler service.vtable+30=`72AB60` (envoi). Événement2 peut appeler `72B3B0`, service.vtable+18=`72A9C0` (arrêt), puis une branche de déconnexion pendant chargement : `MessageBoxW` via FA4644 et `8A8F50` avec `GetCurrentProcessId`. Ces effets exigent des frontières explicites, pas une validation no-op.

Envoi : l'implémentation no-op `10D5FEC+20 =6FA510` retourne réellement AL=1 sans livraison. L'implémentation active `10D6254+20 =8F77D0` dépend du mutex global `2D6ED50`, de buffers/transformation optionnelle (`CA1EF0/990010`) et de `8FDF70/8FE170`. Un succès no-op ne qualifie donc aucun paquet transmis.

`729B70` construit un message dont le premier octet est 0x68, avec identifiant parent+4, global `2D62878`, booléen inversé, chaîne copiée par `9935D0`, longueur `strlen+0x37`, canal5. `729C50` transmet 7 octets, identifiant parent+4 et argument16 bits, canal6. Attention : le premier octet de ce second message et plusieurs octets de padding du premier proviennent de la pile sans initialisation dans ces méthodes. Les futurs oracles doivent contrôler/qualifier ce résidu, sans l'appeler donnée de protocole reconstruite.

## Flags qui sélectionnent le mode

Preuve détaillée complémentaire : [service_mode_flags_report.md](../replay_service_agent/service_mode_flags_report.md).

`72A780` calcule le bas octet du mode : `service[122] !=0 && service[12F] ==0`. Ces octets appartiennent au membre replay service+60, offsets C2/CF. `59CC60`, appelé par le constructeur `72A3B0`, initialise C2 via dword[C0]=0 à59CE8A et CF via byte[CF]=0 à59CEB1. DisableCatchup/UseLookAhead ciblent A0/D1, pas ces flags.

- VT service+AC=`72C990` → `59CFE0` ou `59D100` : C2=1 à59CFEB /59D134, CF conservé.
- VT service+A8=`72C9C0` → `59D210` : C2=1 à59D29C, CF conservé.
- VT service+A4=`72CA10` → `59D4A0` : C2=1 à59D4E0 et word[CF]=0x0101 à59D4E7 ; le mode devient0.

Les trois premiers appels ne remettent pas CF à zéro après le quatrième. `59CFE0` active C2 avant les vérifications du fichier et l'appel `8B4FB0(...,"rb")` : son échec ne signifie pas C2=0. Le scan de stores de l'agent couvre les plages service72A3B0..738D00 et membre59CC60..59E000 ; aucune exhaustivité sur tout le programme n'est revendiquée.

## Ordre proposé

1. Wrappers d'invocation avec signatures explicites, feuilles source qui retournent0, raccordement de `events::dispatch` au Backend ; refus précis des cibles encore absentes.
2. Branche service événement5 avec arbre metadata `64D040/728A60`, puis getters/setters metadata `728150/7281C0` et méthodes `7285B0/728830`. Vérifier les changements d'état et références contre le natif.
3. Commandes sortantes `729B70/729C50` → `8F6C20`, avec qualification distincte du chemin no-op et du chemin actif encore indisponible.
4. Entrées de mode `72C990/72C9C0/72CA10` et leurs ressources, sans modifier directement les flags pour simuler l'ouverture.
5. Réception `72B2F0` et consommateurs paquet, puis branches de connexion/déconnexion 1/2 de `72B950`, avant toute prétention de frames de jeu ou réseau complet.
