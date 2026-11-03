# SYS-01.2-02 — Paramètres et notifications des événements audio, V783

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. SYS-01.2-02 et SYS-02.2-07 restent partiels.

## Résultat vérifié

Quatre exécutions isolées chargent les six banques originales, enregistrent l’objet audio2000001, appellent706850, publient réellement la frame par AEB000/B08440, créent une voix native, capturent le décodage puis exécutent l’arrêt global705080 et la destruction704C30.

| Profil | Entrée | Observation attendue et obtenue |
| --- | --- | --- |
| idle1 | Marchand idle1, cookie0, âge0 | Événement910296305 → action82305448 → conteneur8082 → son799533143 → média372594015 ; lecture depuis0 |
| callback | Marchand idle2, cookie fourni, âge0 | PostEvent flags5/callback704A40 ; notification1 à l’arrêt ; interface slot4 puis slot0(argument1) |
| seek_half | Marchand idle2, cookie0, âge0,5s | AEB080/AEB010 reçoivent500ms ; premier échantillon décodé à22 050 |
| callback_seek_half | Marchand idle2, cookie fourni, âge0,5s | Même seek natif, puis notification1 et ordre des méthodes identique |

Chaque profil produit6buffers de1 024échantillons PCM16, comparés au WAV réel du média avec une erreur maximale1. Les deux profils de seek couvrent la plage[22 050,28 194[ ; les deux autres[0,6 144[. Total :24 576échantillons et8frames actives capturées. Les décalages proviennent des structures de travail du décodeur natif, pas d’une découpe substituée dans le lecteur.

Chaque exécution équilibre1 791allocations suivies et libère21handles simulés ; les trois workers terminent avec0. Le second arrêt retourne1 sans nouvel événement de service. Les4exécutions totalisent7 164allocations/libérations ;7 264adresses distinctes de blocs natifs (28 759relevés cumulés) sont recoupées avec les octets du PE. Le zéro d’allocations est limité au périmètre suivi du banc.

## Notifications et frontière du banc

Le callback original704A40 reçoit ici le type1 et une structure contenant le cookie fourni, l’objet2000001, l’identifiant de lecture1 et l’événement910296306. Il appelle les slots4 puis0(argument1) de l’objet lié. Les méthodes de cet objet sont des services observables fournis au banc ; leur implémentation ordinaire dans le jeu n’est pas qualifiée.

Le type4 n’est pas observé dans ces parcours. Il est visible dans la fonction décompilée, mais cette révision ne lui attribue pas le sens « durée » et ne prouve pas son déclenchement réel.

Deux premiers essais callback échouaient dans le banc à0x32002800 : le token de la méthode de destruction entrait en collision avec celui du service COM de désenregistrement. Ils avaient reçu le callback1 et appelé le slot4, mais leur arrêt n’était pas terminé (377allocations suivies restantes). Les reçus FAILED sont conservés. Le retry change uniquement les trois tokens des méthodes fournies vers des adresses libres ; les octets natifs et les données d’origine restent identiques. Ces échecs ne sont pas présentés comme des défauts du jeu.

## Consommateurs Rust actuels

Le banc compile directement les fichiers inchangés `crates/core/src/audio_event_post.rs` et `audio_object_callbacks.rs`, avec leur identité SHA256. Il exécute `dispatch` contre les quatre appels natifs : nom, objet, flags, callback, cookie, retour et seek. Il compare aussi `deliver(Kind::Bound,1,...)` aux deux notifications natives, avec l’ordre slot4/slot0 et l’argument1.

Quatre comparaisons passent. Six contrôles locaux supplémentaires passent : événement vide retournant0 sans backend, refus des chaînes avec NUL ou non ASCII, refus des âges NaN/+inf/-inf. Ces contrôles locaux ne prouvent pas les refus natifs correspondants. Le fichier source du banc, le compilateur, sa version, la commande, le binaire et sa sortie réelle sont conservés. Ce n’est ni un build du workspace ni une exécution du jeu Rust ; les closures Post/Seek restent des frontières fournies.

Deux ancres sont ajoutées au registre : `audio_object_callbacks::deliver`, qualifié sur ce sous-contrat, et `audio_launch_dispatcher::dispatch`, inspecté statiquement. Le parent natif7067B0 sélectionne706850 pour un objet lié ou706910 autrement ; il est analysé par REA mais pas exécuté ici. Les douze ancres existantes sont conservées. Les sélecteurs d’arrêt global5/8 restent refusés par le consommateur Rust de commandes de banque inspecté.

## REA et intégrité

REA/Ghidra analyse704A40,AEB080,AEB010,7067B0,704A00 et706850 :6fonctions,237instructions,9références. L’identité des octets, les exports et la fermeture de session sont vérifiés. AEB010 prépare une commande0x23 après lookup de l’événement ; l’exécution sélectionnée conduit au décalage PCM observé.

Quinze altérations de preuves/contrats sont rejetées par les validateurs, notamment effacement du seek, modification des échantillons, du callback, du cookie ou de l’ordre de destruction. L’audit vérifie aussi le correctif exact des tokens d’adaptateurs.

## Sources et preuves

- PE original : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Banque événements : `NPC_Map10_SFX_events.bnk`, SHA256 `613e6c75090ed1277e2e737cce1d5f24431be9d1fb5835cc71ad4816e0353e26`.
- `assets/audio/ambient/372594015.wav`, SHA256 `e46317fba12d840e2a2fa611966616bbff1310255cc787866674028df7c5b83a`.
- `assets/audio/ambient/306723203.wav`, SHA256 `c25b0fed8cfa00d59db9bf983a56e16924f5efb3ddee4f636c90faf61ecd7c89`.
- Racine des reçus : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.
- `revision783_event_idle1`, `revision783_event_seek_half`, `revision783_event_callback_distinct_services`, `revision783_event_callback_seek_half_distinct_services` : observations réussies.
- `revision783_event_callback/FAILED.json`, `revision783_event_callback_seek_half/FAILED.json`, `revision783_callback_adapter_collision.json` : échecs et correction conservés.
- `revision783_current_execution/OBSERVATIONS.json` : compilation/exécution des modules Rust et comparaison native.
- `revision783_rea_event_parameters/observations/14a2becb-72ff-4c08-a4a1-a3022d6b1d70/receipt.json` : REA.
- `revision783_associations/OBSERVATIONS.json` et `revision783_delivery` : liens, publication réversible et relecture des registres/deux bases.

## Limites et modifications

Les trois événements environnementaux à plusieurs actions restent à qualifier dans cette chaîne. Âges négatifs/hors durée, callback4, parent/unbound, objets/émetteurs du jeu, lectures simultanées, streaming, boucles et autres locales restent ouverts. Heap/pools, TLS, verrous, horloge, COM et transports de threads/événements sont fournis. Aucun périphérique audio réel ni jeu historique exécuté. Le suivi exclut mappings des banques, mémoire de configuration, réservations physiques et ressources Windows ; descripteurs/pool19 restent ouverts.

Seuls les preuves, liens et deux fiches dans les registres et les deux bases, ainsi que les documents de couverture/reprise, sont modifiés. Aucun code Rust ni asset du projet modifié. Les cases, notes, historiques, inconnues et prérequis sont conservés. Aucun statut de fidélité globale ou d’acceptation humaine n’est accordé.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V783 qualifie idle1/idle2, âge0/500ms et callback1 avec méthodes d’objet fournies. Prochaine étape : qualifier les trois événements environnementaux à plusieurs actions, leur sélection et leurs voix simultanées ; examiner le caller7067B0 et le chemin non lié706910/704A00 avec les vrais contrats de registre. Garder ouverts callback4 et son sens, autres âges/seek, streaming/IO, objets et émetteurs du jeu, descripteurs/pool19, concurrence, provider/locale et autres exigences. Les wrappers Rust comparés ne fournissent pas encore tout le backend ; arrêt global5/8 encore refusé. Préserver sources, preuves et états manuels.
