# AUD-17.3-01-LOADING-PRESENTATION-01 — écran de chargement champion, skin et équipe

Preuves du 2026-10-30T22:39:36.141525+00:00 au 2026-10-30T22:39:39.068357+00:00. Projet actuel F:\OpenLeague. Référence LoL4.20.0.315, EUW/en_GB, catalogue4.20.1. Audit documentaire uniquement : aucun changement du goal, de ses critères, de Plan, de ses bases, du jeu ou de ses ressources.

Résultat : les ressources disponibles et les preuves natives avancées sont identifiées ; la sélection actuelle transporte le champion et l’équipe, mais pas une identité de skin jusqu’à une carte de chargement. Le portrait HUD et les anciens diagnostics GPU ne prouvent pas cet écran. La clôture documentaire de cette unité dépend de la relecture indépendante R1–R7 ; la fonctionnalité demeure partielle et le registre reste inchangé.

## R1 — Exigence exacte et limites du lot

**SYS-17.3-01 — Reproduire l’écran de chargement avec champion, skin et équipe**. Exigence `OLF-2ffda321-9b6c-5cac-85ee-b5bd79d30ba7` ; inconnue `OLU-ac85c18c-d131-517e-83a7-d0987d643c48`. Statut hérité `a_faire`, implémentation et acceptation `false`, inconnue `open`. Aucun critère normatif modifié.

Lot D17-SYS-17-3, neuf tâches. Son prérequis D20-SYS-20-3 « Connexion et reconnexion » conserve `a_faire` et dépend de D20-SYS-20-1. La lecture de ces dépendances n’autorise pas à les marquer satisfaites. Les critères fonctionnels exigent une présentation réelle et vérifiée ; cet audit ne leur substitue pas un inventaire.

Périmètre parent : champion, skin, équipe, source/selector/provider, consommateur actuel, présentation et cycle de vie de l’écran. Les tâches SYS-17.3-02 progression réelle, SYS-17.3-03 erreur/retour et SYS-17.3-09 fermeture/crash restent distinctes, reliées comme dépendances. Les états historiques sont référencés par SYS-01.1-06. Hors portée : implémenter ces fonctions, redémarrer le client ou le suivi, rejouer REA/GPU, reconstruire une image, migrer ou ouvrir une base.

L’audit précédent AUD-17.2-07-LOCALIZED-TOOLTIPS-01 a apporté une clôture documentaire vérifiée ; son reçu indépendant est conservé. Il est classé **progress**, pas attente ni état de fonctionnalité terminée. La pièce jointe du goal est relue ; son ancien chemin E est historique, le projet autorisé est F.

## R2 — Sources, provenance et preuves réutilisées

### Ressources de chargement réellement disponibles

Manifeste `data/4.20/native_champion_loading_assets.json`, import historique `docs/native_champion_loading_assets_import.json`. Sélection : fichier de base de chaque champion, INIBIN de son répertoire Skins, fichiers libres dont le nom contient LoadScreen. Ce critère de découverte ne certifie pas tous les skins historiques ni toutes les variantes de noms.

| Périmètre contrôlé | Observé maintenant | Limite |
|---|---|---|
| Champions | 122répertoires | Pas122écrans ou kits fonctionnels |
| Fichiers listés | 1178sources natives et1178copies importées ; taille/SHA exacts | Aucun fichier recréé ou copié dans ce lot |
| Images | 720DDS, en-têtes dimensions/mips/fourcc égaux au manifeste | Pixels non redécodés maintenant ; aucune qualification GPU |
| Configurations | 458INIBIN de base/skin présents | Contenu et skin ID natifs ne se déduisent pas du seul nom |
| Raccordement | provider_connected=false, rendered=false dans le manifeste | La réussite de l’import n’est pas un écran rendu |

Les 337380062octets listés sont vérifiés sur source D et copie F, sans duplication supplémentaire. Chaque entrée conserve champion, chemin logique, origine, copie et empreintes dans `asset_rows` ; les122compteurs sont séparés dans `per_champion_counts`. Les720contrôles d’en-têtes sont dans `DDS_header_checks`. Aucun écart d’identité détecté. L’ancien décodage Pillow ne devient pas une exécution native ni une relecture fraîche des pixels.

### La meilleure preuve acquise prime sur une ancienne impasse

| Preuve héritée | Acquis retenu | Limite conservée |
|---|---|---|
| V685 | Création90B520/provider Ahri0retourné, cache hit et requêtes/teardown | Contexte virtuel/adaptateurs déclarés ; pas montage/processus historique complet ni UI |
| V686 | 12profils de six modèles x skins0/1,45hits/15misses, transferts enregistrés | Flux Python/handles virtuels ; DDS nommés ne sont pas des pixels uploadés |
| V687 | 41cas de sélecteur,12DDS/en-têtes,28premières frontières,12replis synthétiques | Entrées diagnostiques ; loader98A7F0non exécuté dans cette preuve |

Les reçus et leurs `source_audit` sont hachés et conservés, avec leurs dates, comptes, limites et consommateurs. Les116identités de leurs sources épinglées ont également été vérifiées sans écart ; cela ne reconstitue pas les environnements hôte ni leurs états d’exécution. Exemple exact hérité V687 : Ahri0/flags0→AhriLoadScreen.dds ; Ahri1/flags0→AhriLoadScreen_1.dds ; Ahri1/flags2→AhriLoadScreen_1_LE.dds. Ce n’est pas une sélection LE effective de la partie actuelle. Les anciens noms de ressources non résolus, les profils arrêtés et les adaptateurs restent ouverts. Ne pas relancer l’impasse HeapReAlloc de V684 : V685/V686 ont déjà avancé dans un contexte distinct.

Les **51 régions natives** des contrats loading_consumer_sources, loading_metadata_sources et loading_record_tree_sources sont comparées directement au PE4.20original, SHA 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le lecteur distingue `size` des deux premiers contrats et `bytes` du troisième. Une longueur est vérifiée contre l’hex encodé. Les zones virtuelles nulles du PE sont distinguées des octets présents dans le fichier ; elles ne prouvent pas une valeur globale runtime ni le sens serveur d’un champ.

### Rendu antérieur : deux preuves de portée différente

V712 : essai réel antérieur du client actuel en session locale directe, Vulkan/RTX3060 ; client/serveur terminent code0, session invalide refusée code1. Les journaux, trace du portrait et PNG sont relus par empreinte. Le PNG1280×800 a été inspecté maintenant avec `view_image` : scène Map10, Garen sur sa plateforme, HUD/portrait et minimap. **Aucun écran de cartes de chargement observé**. La capture est ancienne ; aucun nouveau processus ou bureau courant n’a été observé. Les122portraits chargés dans le journal ne signifient pas122sélections affichées ; une sélection Garen est documentée.

V717 :18opérations diagnostiques natives de textures Direct3D9, pixel blanc par défaut relu, registre/shutdown sous initialisation conditionnelle ; aucun appel privé de pilote exécuté, portrait_loader_complete=false, frame_rendered=false. Ne pas transformer ces textures réelles en portraits rendus. Les feuilles hôte/adaptateurs, environnement et frontières48AC16restent celles de la preuve héritée ; elles exigent leur propre requalification avant une nouvelle exécution. Aucun REA/D3D9/GPU rejoué ici.

## R3 — Consommateurs actuels et chaîne de bout en bout

**1 168 fichiers** de source Rust/launcher sont identiques au corpus référencé, membres et empreintes vérifiés. Une nouvelle recherche bornée dans **508 fichiers** client/launcher, motifs native_champion_loading_assets/loading_source/LoadScreen, ne trouve aucun usage nommé de ces ressources. Cette absence est limitée aux motifs et aux routes inspectées ; elle ne prouve pas universellement l’absence de tout code de chargement.

L’association historique « Process metadata only » est insuffisante comme résumé actuel : des ports de métadonnées/provider/cache, une sélection de portrait HUD et des preuves natives plus avancées existent. Ils sont conservés et distingués de la continuation UI encore refusée. Aucun consommateur réel n’est présumé manquant sur la seule base du nom d’un répertoire.

| Dimension | Source / acquis | Consommateur réel et écart |
|---|---|---|
| champion | 122 native character directories and720 LoadScreen images; provider/selector native proof retained | LaunchSpec.champion -> JoinRequest.champion -> Champion/RosterEntry.champion -> base HUD selected; no loading-card consumer identified Bind a loading participant champion identity to the chosen native portrait and actual loading view. |
| skin | 458base/skin configs; V6866models x skins0/1; V687flags0/2 and LE/fallback requests are declared probes | No skin field in actual LaunchSpec, JoinRequest, Champion or RosterEntry. Skin/model source ports are not selected session skin admission. Authoritative selected skin/availability and variant selector through launcher/session/view, no implicit base substitution. |
| team | Native1724-byte Standard consumer retained; exact team-row/placement policy not established from opaque25-byte payload | Server-produced RosterEntry.team and id exist; process playing state lacks participant card/team view Audience, identity, team mapping and positions for six Map10participants; source/native comparison remains required. |
| screen_lifecycle | Standard metadata/record/cache/provider/portrait source chain; conditional D3D9texture diagnostics and old direct-client run have different scopes | Three explicit Standard refusal boundaries, current modern HUD render, no complete Standard card layout/ready/view ownership identified Loading view open/update/close, rollback and transition; reuse SYS17.3.02/.03/.09 for progress/error/return rather than call playing complete. |

La chaîne actuelle `LaunchSpec.champion`→JoinRequest→Champion/RosterEntry contient champion et équipe serveur. `LaunchSpec` transmet OPENLEAGUE_CHAMPION et OPENLEAGUE_SUMMONERS. Les DTO inspectés LaunchSpec, JoinRequest, Champion et RosterEntry ne portent **aucun champ skin**. La présence d’un paramètre skin dans un port natif de cache ou dans un test de modèle ne raccorde pas ce choix à la session. Le contrat JoinRequest porte deny_unknown_fields ; aucun essai de désérialisation nouveau n’est revendiqué.

Le plugin `native_hud_portraits` consomme **native_champion_portraits.json**, source Info/IconSquare, sélectionne le champion du joueur courant et dessine AvatarImage dans le HUD. Son traceur conserve alternate skins/forms/framebuffer pending. Les images LoadScreen du manifeste1178ne sont pas ses portraits. `RosterEntry{id,champion,team,score}` existe, mais aucune disposition des six cartes de chargement n’est identifiée sur les routes examinées.

Refus du véritable adaptateur Standard actuel, après préparation des noms et appel du cache :
- `resource provider90AD00 manager is not published`.
- `loading resource is borrowed; standard UI continuation after90AD00 is unavailable`.
- `loading resource factory90B520 is unavailable`.

Ces trois branches expriment manager non publié, résultat emprunté sans continuation et fabrique absente. Le stub57D6FEreste explicite. La mise à jour d’un enregistrement25octets ou un cache hit n’est pas une réussite de l’écran ; les règles exactes de team/skin/positions ne sont pas déduites des octets opaques. Le statut launcher `playing` décrit un état de processus, pas tous les joueurs chargés.

Fragments source exacts et identités :
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:67` — launcher_launch (jusqu’à89).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:182` — launcher_status (jusqu’à200).
- `F:\OpenLeague\crates\core\src\vision.rs:15` — public_roster (jusqu’à22).
- `F:\OpenLeague\crates\core\src\lib.rs:154` — champion_snapshot (jusqu’à207).
- `F:\OpenLeague\crates\core\src\lib.rs:303` — legacy_join (jusqu’à319).
- `F:\OpenLeague\crates\core\src\session_transport.rs:48` — session_join (jusqu’à59).
- `F:\OpenLeague\crates\core\src\lib.rs:764` — snapshot_producer (jusqu’à785).
- `F:\OpenLeague\crates\client\src\native_hud_portraits.rs:17` — current_hud_portrait (jusqu’à36).
- `F:\OpenLeague\crates\core\src\audio_replay_windows_loading_packets.rs:32` — standard_loading_boundary (jusqu’à74).
- `F:\OpenLeague\crates\core\src\audio_loading_screen_packet.rs:36` — packet_ui_boundary (jusqu’à75).
- `F:\OpenLeague\crates\client\src\main.rs:681` — renderer_plugins (jusqu’à718).

## R4 — Résultats attendus, observés et contrôles

**285 contrôles documentaires réussis** avec `verify_loading_v2.py`. Aucun de ces contrôles n’est déclaré test de gameplay ou acceptation de l’écran.

| Cas | Attendu | Observé |
|---|---|---|
| Ressources listées | Origines/copies identiques, pas réussite inventée | 1178paires valides ;720en-têtes et458configs présents |
| Réemploi nominal | Conserver le provider retourné et sélecteurs acquis | V685/V686/V687relus ; anciennes frontières/adaptateurs explicites |
| Champion/skin/équipe | Tracer chaque identité jusqu’au consommateur | Champion/équipe actuels ; aucun skin transporté dans les DTO examinés ; carte complète non identifiée |
| Refus Standard | Ne pas convertir les erreurs en écran réussi | Trois frontières nommées conservées, inspection statique ; pas réexécutées |
| Ancien rendu | Identifier ce que montre vraiment la capture | V712Garen/HUD ; loading_screen_observed=false |
| GPU natif | Ne pas confondre diagnostics et présentation | V717conditionnel, loader et frame ouverts |
| Lecteur d’audit | Accepter les contrats de longueur existants | V1s’arrête KeyError:size ; V2lit size/bytes explicitement et termine code0 |
| Conservation | Aucune modification de l’application, critères, bases ou jeu | Git et25fichiers protégés/cinq registres identiques |

La tentative V1 est préservée dans verify_loading.py et attempt-1-failure.json : échec du lecteur d’audit, pas défaut du jeu ou des sources. Aucune preuve finale écrite par cette tentative. V2 est un nouveau fichier ; les contrats sources n’ont pas été normalisés ni réécrits.

Non exécutés maintenant : tests/compilation Rust, lancement client/serveur/launcher, parcours de sélection/chargement, entrée OS réelle, réseau, GPU, original LoL, REA, import ou décodage des pixels, installation/migration. Les exécutions historiques et la revue du PNG sont étiquetées séparément. Les empreintes des anciens reçus ne qualifient pas les exécutables reconstruits depuis ; aucun binaire courant n’est annoncé accepté.

## R5 — Ce qui reste ouvert et entrée de reprise

| Écart | Ce qu’il manque précisément | Reprise autorisable et borne d’arrêt |
|---|---|---|
| Skin de session | Identité/admission autoritative et propagation ; source trouvée ne vaut pas choix validé | Contrat nommé Ahri0/Ahri1 et DTO consommateur ; pas collecte de tous les skins au hasard |
| Portrait sélectionné | Flags/LE/fallback du record et loader jusqu’au draw | Un record de session réel ou contrat local explicite, puis Ahri1 ; ne pas rejouer les41cas inchangés |
| Provider Standard | Publication/durée de vie du manager et continuation après90AD00 | Réutiliser V685/V686, entrée et sortie nommées ; garder trois erreurs si prérequis absent |
| Équipe et disposition | Roster préchargement, mapping local/adverse et slots/ordre natifs | Témoin natif des lignes/positions ou contrat local distinct ; vérifier3+3sans déduire capacité d’un scoreboard |
| Vue et transitions | Consommateur loading-card, textes/glyphes/DPI, ouverture/fermeture et ressources | État réel, renderer autorisé et vue instrumentée ; SYS17.3.02/.03/.09gardent leurs clauses |
| Noms/ressources auxiliaires | Usage effectif des noms encore non résolus dans anciennes sondes | Nouvelle requête sélectionnée nommée ; pas reprise des recherches sans source nouvelle |
| Contexte natif/driver | Environnement/feuilles adaptatrices et frontière privée48AC16 | Nouvelle qualification explicite nécessaire pour un essai natif ; aucune installation ou sonde pilote implicite |

Ces manques empêchent la fin de la fonctionnalité ; leur constat sourcé et la délimitation des consommateurs permettent la clôture documentaire de cet audit après relecture. Les champs privés ou opaques, variantes, positions et noms non qualifiés restent inconnus, sans valeur inventée ni repli silencieux. Recherche arrêtée ici ; une nouvelle exploration doit apporter l’entrée discriminante indiquée.

## R6 — Corrections nécessaires, petites unités et critères

Tâches existantes réutilisées, sans changer leurs statuts : `SYS-01.1-06`, `SYS-17.3-02`, `SYS-17.3-03`, `SYS-17.3-09`, `D20-SYS-20-3`. Les cinq fiches ci-dessous sont **proposed_not_applied** et restent hors des registres/applications. Chaque cas Ahri est nominatif ; les122champions et leurs skins ne sont pas ramenés à une tâche globale. Après un mécanisme qualifié, les lignes par champion et ressource fournissent les unités de vérification distinctes.

### LOAD-AHRI-SKIN1-IDENTITY-01

Objectif : Transporter la sélection Ahri skin1 jusqu’à un état de chargement autorisé.

Écart : Les sources et deux branches natives existent, mais aucune identité de skin n’est transportée par les DTO inspectés.

Travail et consommateur : Définir identité et autorité, validation/disponibilité, propagation launcher -> JoinRequest -> participant de chargement, puis consommateur nommé. Conserver refus des skins inconnus.

Critères de fin : Ahri0 et Ahri1 restent distincts pour le même participant/session; absent/invalide explicitement indisponible, aucun base fallback silencieux.

Entrée nécessaire à la reprise : Contrat de sélection/admission de skin pour Ahri et un consommateur de loading-card autorisé, sans confondre skin de modèle et portrait.

Dépendances : `D20-SYS-20-3`.

Preuves attendues : Identified source/code/binaries; expected and observed for named participant/skin/team, explicit unknown/refusal; real render and lifecycle only after separately authorized implementation.

Sources : ressources nommées R2, profils hérités et fragments R3 du reçu. État : `proposed_not_applied` ; aucune implémentation autorisée implicitement par cet audit.

### LOAD-AHRI-PORTRAIT-SELECTOR-01

Objectif : Lier une carte Ahri au bon portrait LoadScreen.

Écart : V687 prouve des requêtes de nom sous entrées déclarées, pas la sélection actuelle ou une image rendue.

Travail et consommateur : Réutiliser AhriLoadScreen.dds/AhriLoadScreen_1.dds et le cas LE du sélecteur; qualifier le fournisseur et valeur de flags, puis chemin DDS/texture.

Critères de fin : Cas Ahri0/Ahri1 avec source exacte; LE seulement si état justifié, ressource absente et fallback conforme à source; image réellement choisie/rendue vérifiée.

Entrée nécessaire à la reprise : Provenance du flag/record de la session et contexte de loader nommé; ne pas refaire les41anciens cas inchangés.

Dépendances : `LOAD-AHRI-SKIN1-IDENTITY-01`.

Preuves attendues : Identified source/code/binaries; expected and observed for named participant/skin/team, explicit unknown/refusal; real render and lifecycle only after separately authorized implementation.

Sources : ressources nommées R2, profils hérités et fragments R3 du reçu. État : `proposed_not_applied` ; aucune implémentation autorisée implicitement par cet audit.

### LOAD-STANDARD-PROVIDER-01

Objectif : Raccorder le consommateur Standard au fournisseur et à sa continuation.

Écart : Backend courant refuse manager absent, cache emprunté et fabrique manquante; V685 provider retourné sous adaptateurs ne ferme pas ces branches.

Travail et consommateur : Conserver propriété des chaînes/cache et refus; choisir l’adaptateur le plus avancé V685/V686, publication manager et continuation57D6FE, sans faux succès.

Critères de fin : Un cas Ahri0 atteint le vrai consommateur suivant; trois refus encore observables quand leur prérequis manque; rollback/teardown et propriété attestés.

Entrée nécessaire à la reprise : Contexte manager/nom/skin/durée de vie et entrée native ou contrat local explicite. Ne pas reprendre l’ancienne impasse HeapReAlloc déjà dépassée.

Dépendances : `SYS-01.1-06`.

Preuves attendues : Identified source/code/binaries; expected and observed for named participant/skin/team, explicit unknown/refusal; real render and lifecycle only after separately authorized implementation.

Sources : ressources nommées R2, profils hérités et fragments R3 du reçu. État : `proposed_not_applied` ; aucune implémentation autorisée implicitement par cet audit.

### LOAD-TEAM-MAP10-ROWS-01

Objectif : Attribuer les six cartes Map10 aux participants et équipes corrects.

Écart : Roster id/champion/team existe; projection/loading-view et règles natives de disposition non qualifiées.

Travail et consommateur : Utiliser identité serveur; qualifier slots, équipe locale/adverse, ordre et états d’indisponibilité à partir de la source ou d’un contrat local explicitement distinct.

Critères de fin : 3+3 participants identifiés une fois; équipe correcte, aucune duplication ni révélation hors contrat, changement/retrait/réassociation refusés ou réconciliés.

Entrée nécessaire à la reprise : Contrat de roster avant chargement et source native ciblée des lignes/positions, pas un score ou une capacité5/6tirée d’un autre film.

Dépendances : `D20-SYS-20-3`.

Preuves attendues : Identified source/code/binaries; expected and observed for named participant/skin/team, explicit unknown/refusal; real render and lifecycle only after separately authorized implementation.

Sources : ressources nommées R2, profils hérités et fragments R3 du reçu. État : `proposed_not_applied` ; aucune implémentation autorisée implicitement par cet audit.

### LOAD-CARDS-RENDER-LIFETIME-01

Objectif : Afficher et détruire l’écran de chargement des six cartes de la session.

Écart : Inventaire1178 et portrait HUD ne sont pas une vue de chargement; la chaîne de texture native demeure partielle.

Travail et consommateur : Créer un consommateur réel après identité/selector/team; ancrages, textes, DPI/tailles, ouverture/mise à jour/fermeture et libération des ressources; brancher erreurs/reprise aux tâches existantes.

Critères de fin : Écran complet champion/skin/équipe observé sur3v3, deux tailles au minimum; source de chaque image/texte, pas de carte périmée après session/erreur/fin de chargement; aucune confusion avec playing.

Entrée nécessaire à la reprise : Contrats des cartes, état de transition réel et renderer autorisé; le diagnostic D3D9V717 ne qualifie pas une frame de portraits.

Dépendances : `LOAD-AHRI-PORTRAIT-SELECTOR-01`, `LOAD-STANDARD-PROVIDER-01`, `LOAD-TEAM-MAP10-ROWS-01`, `SYS-17.3-02`, `SYS-17.3-03`, `SYS-17.3-09`.

Preuves attendues : Identified source/code/binaries; expected and observed for named participant/skin/team, explicit unknown/refusal; real render and lifecycle only after separately authorized implementation.

Sources : ressources nommées R2, profils hérités et fragments R3 du reçu. État : `proposed_not_applied` ; aucune implémentation autorisée implicitement par cet audit.

### Quatre dimensions séparées

| Dimension | État |
|---|---|
| Audit | Périmètre parent documenté : champion, skin, équipe, écran/lifecycle ; clôture seulement après R1–R7 indépendants. |
| Implémentation | Partielle : session champion/équipe, portraits HUD et ports de source existent ; écran historique complet non démontré. |
| Vérification | Réussite documentaire285contrôles ; sources/identités et fragments actuels. Exécutions natives/GUI héritées, sans nouvelle recette fonctionnelle. |
| Acceptation humaine | Aucune acceptation de la fonctionnalité demandée ni revendiquée. |

Aucun écart fonctionnel n’a été corrigé dans ce lot. Résolu pour l’audit : l’ancien résumé « métadonnées de processus seulement » est complété par les véritables acquis/provider/selector/renderer et leurs frontières ; les manques de transport skin, de cartes d’équipe et de continuation sont identifiés. La tâche et l’inconnue d’origine restent ouvertes. Le goal global n’est pas terminé.

## R7 — Livraison, conservation et relecture indépendante

Nouveaux fichiers uniquement :
- [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/audit-unit.json) — périmètre préalable.
- [verify_loading.py](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/verify_loading.py) — tentativeV1conservée.
- [attempt-1-failure.json](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/attempt-1-failure.json) — échec borné et cause.
- [verify_loading_v2.py](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/verify_loading_v2.py) — lecteur abouti.
- [loading-proof.json](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/loading-proof.json) — preuves et lignes sources.
- [AUD-17.3-01-LOADING-PRESENTATION-01.md](F:/OpenLeague/docs/audit/units/AUD-17.3-01-LOADING-PRESENTATION-01.md) — rapport.
- [verify_delivery.py](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/verify_delivery.py) — lecteur indépendant.
- [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.3-01-LOADING-PRESENTATION-01/delivery-readback.json) — décision documentaire de relecture.

Reçu brut : 3084970octets ; SHA-256 **be9a94e99dd338e031fa6bb227b60a0fd1fd87c289d9d53d68921009fc37c705**. `audit_scope_closed=false` dans ce reçu évite la clôture par le producteur lui-même. Le lecteur indépendant vérifie champs, identités, cas/refus et conservation ; son reçu seul peut clôturer ce lot documentaire.

Git main/HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca :76fichiers suivis déjà modifiés conservés. **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs** et pièce jointe du goal inchangés. Aucun retrait ou remplacement de travail antérieur. Aucune base ouverte, aucun Store/work_cli/server de suivi invoqué, aucune installation, migration, suppression ou relance. Le goal, ses critères et son statut ne sont pas modifiés.

Relecture attendue : sept rubriques, définition exacte/phase/dépendances, images/configs source-copie, régions du PE, profils natifs limités, PNG/trace historique, chaîne champion/skin/team et erreurs, cinq corrections atomiques et quatre dimensions. `--check-only` relit sans écrire ; ne pas répéter les mêmes contrôles sans nouvelle raison.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.3-01-LOADING-PRESENTATION-01\verify_delivery.py' --check-only
```

Condition d’arrêt : conclure ce lot après relecture ; poursuivre ensuite une autre exigence non auditée. Ne pas transformer l’inconnue native du loader ou du pilote en obstacle répétitif à l’audit de toutes les autres fonctions. Les reprises spécifiques demeurent R5 ; aucune modification du suivi n’est nécessaire pour conserver cette preuve.
