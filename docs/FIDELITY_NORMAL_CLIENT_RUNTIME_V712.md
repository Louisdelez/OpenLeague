# SYS-01.2-02 — Client courant et portée du chargement, V712

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct.

V712 : client actuel compilé par Cargo sur F, démarrage réel avec serveur local, backend Vulkan RTX3060, carte/Garen/HUD/portrait observés et capture1280x800 ; refus de session invalide code1, fermetures normales client/serveur code0. Ce chemin direct ne qualifie pas l écran historique de chargement Standard, ses skins/équipes, le launcher ou la fidélité native.

## Contrôles exécutés

| Contrôle | Attendu | Observé |
|---|---|---|
| Compilation client Cargo locked/offline | Code0 | Code0 ;1289 entrées source inchangées ;393 artefacts rapportés |
| Compilation serveur Cargo locked/offline | Code0 | Code0 |
| Configuration privée invalide | Refus avant renderer | Code1 ;message explicite ;aucun AdapterInfo |
| Entrée réelle du client et rendu | Fenêtre et image de la scène | Vulkan, RTX3060, pilote610.88 ;capture1280x800 inspectée |
| Portrait sélectionné | Portrait du champion local | Garen, source ui/native420/portraits/garen.dds ;122 portraits annoncés chargés |
| Fermeture par Alt+F4 | Fin du client et départ serveur | Codes0/0 ;aucune terminaison forcée ;ordre service/runtime/application rapporté |
| Ancienne bibliothèque V711 | Conserver son identité | SHA identique ;nouvelle bibliothèque de build distincte |

Client : F:\OpenLeague\target\debug\openleague-client.exe ;SHA256 d10c068b691dedf827863c72b752b135a67c5b1da36d85a20d9acc976951a306. Serveur : F:\OpenLeague\target\debug\openleague-server.exe ;SHA256 e1190778ff5567e275258ead15d1744d9f9698b152cb42039f24b9df9ace13cb.

Commandes : `cargo build --locked --offline -p openleague-client --message-format=json-render-diagnostics`, puis même commande pour openleague-server. Profil dev optimisé avec debuginfo ;CARGO_INCREMENTAL=0 uniquement dans ces processus pour limiter le stockage. Artefacts frais et réutilisés distingués dans le reçu. Pas de téléchargement.

Le code de main.rs:651, DefaultPlugins, est relié au client fraîchement construit et à sa fenêtre observée ;la scène setup demande maps/twisted_treeline.glb. Le HUD utilise native_hud_portraits::setup/update. Ce chemin est distinct du consommateur Standard audio_replay_windows_loading_packets::initialize_standard_record_owned : celui-ci conserve des erreurs explicites et n est pas démontré par la scène Map10. Les17 descripteurs précédents restent inchangés ;aucun rôle fonctionnel ou état accepté n est promu.

![Capture du client courant](../..//OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision712_normal_client_runtime/frame.png)

## Limites et anomalies

- Entrée directe documentée avec serveur loopback, pas parcours du launcher ni session privée authentifiée.
- Capture via le mécanisme existant et trace du portrait : variables de processus uniquement ; pas de changement source, configuration utilisateur ou option WGPU persistante.
- 1289 sources Rust/WGSL/Cargo contrôlées avant et après ; pas de reconstruction hermétique de toutes les dépendances ni d inventaire préalable de toutes les données embarquées.
- Le journal indique122 portraits chargés, mais une seule sélection Garen et une seule image sont observées. Aucun skin alternatif ou écran de chargement historique accepté.
- Le caller Standard initialize_standard_record_owned conserve ses refus manager non publié, continuation après cache emprunté et fabrique90B520 ; il n est pas exécuté par cet essai.
- Création/rendu/fermeture modernes observés ; pas de mapping des catégories natives0/1/2 ni preuve physique de libération GPU ou qualification des ressources2014.
- Anomalies conservées : manifeste externe de couche Vulkan TikTok introuvable (non bloquant dans cet essai), activation pickup seven-group refusée, avertissements de compilation303client/24core/6serveur. Aucun réglage système changé.
- Les inconnues historiques de portraits, transport/UV/sampler/couleur, Kalista288octets et12noms restent ouvertes.

## Livraison et conservation

Les preuves détaillées sont dans [le reçu](fidelity_normal_client_runtime_v712.json) et F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision712_normal_client_build et revision712_normal_client_runtime. La preuve de publication est revision712_delivery/VERIFIED.json, distincte de cette observation d exécution.

Registre, trace et catalogue : ajout ciblé sur SYS-01.2-02 et SYS-17.3-01. Deux lignes de contenu par base seront contrôlées ;cases, notes, historique, prérequis et toutes les autres lignes doivent rester identiques. Sauvegardes limitées aux fragments et lignes modifiés, avec inversion des octets vérifiée ;aucun snapshot intégral de base.

Suite : qualifier le véritable consommateur d écran de chargement Standard (manager/bootstrap,90B520,publication/inscription978820,skin/équipe et scène). La scène Map10 fraîchement observée fournit une preuve du renderer courant, pas une clôture de SYS-17.3-01 ou du jeu.
