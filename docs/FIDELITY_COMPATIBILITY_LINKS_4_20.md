# Compatibilité — traçabilité V149

V149 compatibility:six local requirements,six explicit boundary roles.518 source pins,542 checks,29 reader cases including28 refusals.506 owned Rust files searched. Historical Dx12 capture bytes reverified;both current executables differ from recorded binaries. No hardware,installer,Rust test or game execution;all platform qualification remains open.

## SYS-22.4-01

Le contrat de compilation exige Windows sans définir de versions Windows prises en charge pour le paquet final.

Reste à faire : Définir et tester les versions Windows et le paquet final sur des installations propres.

## SYS-22.4-02

Le launcher utilise WGPU_BACKEND ou vulkan par défaut ; ce choix ne constitue pas une matrice GPU mesurée.

Reste à faire : Mesurer les GPU/pilotes/backends disponibles et documenter succès et refus par configuration.

## SYS-22.4-03

Le bundle Tauri est désactivé. WebView2 est cité comme prérequis de compilation ; aucun bootstrap installé n’est qualifié.

Reste à faire : Qualifier détection, absence et installation de WebView2 dans le paquet final.

## SYS-22.4-04

Le moniteur PCM observe le décodeur et les échantillons remis au mixeur, pas la reconnexion ou la sortie audible du périphérique.

Reste à faire : Tester sélection, déconnexion et reconnexion des périphériques audio et les erreurs correspondantes.

## SYS-22.4-05

La perte de focus invalide les gestes de caméra ; cette logique ne prouve pas le parcours clavier/souris sur un compte propre.

Reste à faire : Tester les entrées et transitions de focus sur un compte Windows propre avec le paquet final.

## SYS-22.4-06

roster lit les données depuis CARGO_MANIFEST_DIR ; sessions lance les binaires target/debug. Ces dépendances au poste de développement sont des écarts observés.

Reste à faire : Inventorier et éliminer les dépendances au poste de développement du paquet livré puis tester hors dépôt.

Contrats locaux distincts des politiques historiques Riot. Le reçu Dx12 est conservé avec ses limites ; sa capture a le même SHA-256 mais les exécutables actuels ont changé. Aucun test matériel, installation, runtime WebView2 ou lecture audio exécuté. Les recherches source ne prouvent pas une absence dans les dépendances.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-22.4-01 | Le contrat de compilation exige Windows sans définir de versions Windows prises en charge pour le paquet final. | Définir et tester les versions Windows et le paquet final sur des installations propres. |
| SYS-22.4-02 | Le launcher utilise WGPU_BACKEND ou vulkan par défaut ; ce choix ne constitue pas une matrice GPU mesurée. | Mesurer les GPU/pilotes/backends disponibles et documenter succès et refus par configuration. |
| SYS-22.4-03 | Le bundle Tauri est désactivé. WebView2 est cité comme prérequis de compilation ; aucun bootstrap installé n’est qualifié. | Qualifier détection, absence et installation de WebView2 dans le paquet final. |
| SYS-22.4-04 | Le moniteur PCM observe le décodeur et les échantillons remis au mixeur, pas la reconnexion ou la sortie audible du périphérique. | Tester sélection, déconnexion et reconnexion des périphériques audio et les erreurs correspondantes. |
| SYS-22.4-05 | La perte de focus invalide les gestes de caméra ; cette logique ne prouve pas le parcours clavier/souris sur un compte propre. | Tester les entrées et transitions de focus sur un compte Windows propre avec le paquet final. |
| SYS-22.4-06 | roster lit les données depuis CARGO_MANIFEST_DIR ; sessions lance les binaires target/debug. Ces dépendances au poste de développement sont des écarts observés. | Inventorier et éliminer les dépendances au poste de développement du paquet livré puis tester hors dépôt. |

Reçu : docs/reference_compatibility_sources/compatibility-links.json. Livraison : docs/fidelity_registry_compatibility_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
