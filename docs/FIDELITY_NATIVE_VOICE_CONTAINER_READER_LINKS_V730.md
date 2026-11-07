# SYS-01.2-02 — Lecteur des conteneurs de voix, V730

Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Les chemins des voix examinées portent en_US ; leur sélection historique reste ouverte.

## Résultat vérifié

Les 2 562 conteneurs du corpus passent le constructeur, l'inscription et le lecteur complet originaux, avec leurs enfants créés à partir des identifiants natifs : 11 052 créations de sons et 11 054 entrées de playlist. L'ordre des playlists, leurs poids, les enfants chargés, les paramètres et la consommation exacte du payload sont vérifiés. Les 81 838 champs sources retenus des conteneurs sont comparés aux octets des banques.

Les 594 références OverrideBusId non nulles correspondent à trois bus type 8 du fichier original Init.bnk. La fabrique originale crée ces identifiants avant le lecteur ; les payloads, parents, réglages et mixage des bus ne sont pas chargés. Les sources audio des enfants ne sont pas chargées non plus.

Le lecteur active le bit de poids pour 14 conteneurs à partir des valeurs insérées, alors que leur indicateur sérialisé vaut zéro. Les 6 conteneurs séquentiels stockent des identifiants sans poids. Deux entrées répétées présentes dans le corpus restent conservées.

## Exécution et contrôles

Les fonctions B1D610/B1D370/B1DD80 construisent et inscrivent le conteneur ; B1E5C0 lit le payload complet, AE1970 charge les enfants et B1E7B0/B1D430 insèrent la playlist. B226A0 crée les enfants et B02680 les bus nécessaires. Les 2309 adresses exécutées sont comparées au PE original SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

| Cas de diagnostic | Attendu | Observé |
|---|---:|---:|
| Enfant absent du registre | 15 | 15 |
| Identifiant d'enfant nul | 14 | 14 |
| Doublon dans la playlist aléatoire | 35, première insertion conservée | Conforme |
| Doublon dans la playlist séquentielle | 1, doublon conservé | Conforme |
| Entrée de playlist hors liste d'enfants | 1, identifiant conservé | Conforme |
| Poids 25 000 avec indicateur sérialisé nul | 1, poids activés | Conforme |
| Allocation du lecteur refusée | 2 | 2 |
| Bus requis absent | 2 | 2 |

L'échec d'allocation produit 52 au niveau du lecteur de propriétés, normalisé en 2 au retour AF2C39. Ce cas n'est pas qualifié comme échec d'allocation de playlist. Les trois gardes de forme (taille trop courte, trop longue, identifiant différent) sont des refus du banc ; elles ne prouvent pas la sécurité du lecteur historique face à un fichier corrompu. Quatre falsifications des observations sont refusées par le vérificateur.

## Consommateurs et intégration

Les 569 sources et 29 points de code actuels sont vérifiés. audio_selection.rs consomme le contrat d'ambiance existant ; son champ uses_weight est fourni par le contrat et les séquences sont refusées. Aucun fournisseur complet de voix de champions ou de skins n'est déclaré fonctionnel.

Les 1 279 fiches (668 skins, 610 voix de champions et SYS), leurs liens de sources et leurs instructions copiables dans les deux bases sont enrichis. Les états manuels, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Les liens avec les 12 672 demandes antérieures restent hérités et datés ; aucune voix n'est jouée par cette vérification.

## Limites et essais conservés

- Original sound factories B226A0 prepare real child object identities, then container factory B1D610,constructor B1D370,initializer B1DD80 and full reader B1E5C0 execute per container.
- Required OverrideBusId values match actual Init.bnk type8 objects. B02680 creates those source-bound IDs when needed; bus payloads,parent tree,settings and mixing are not loaded or qualified.
- Children are factory-initialized only: no sound-source payload,codec,media or audio playback is loaded. Each container uses a fresh manager,not the whole historical bank order.
- Native child loading AE1970 and playlist reading B1E7B0/B1D430 execute,including insertion/growth functions. Stored fields,children and playlists are compared with exact source bytes; all base FX/RTPC/property semantics are not individually accepted merely from success.
- Pool allocation and logical free are bounded transports. Full ownership teardown,physical release,historical parent/bus activation and live selection/history remain open.
- Weighted mode is derived while inserting entries; the serialized weight byte is not a valid substitute. Sequence playlists retain IDs without storing the supplied weights.
- Diagnostic malformed shapes are harness refusals,not claims about native malformed-bank safety. First hook setup ambiguity,missing-child exploratory result and first full-corpus missing-bus failure remain preserved. Bus dependency is explicitly supplied by original factory from native Init source,not patched out of the original payload.
- Les 1 278 fiches audio de skins/voix et SYS sont enrichies sans changement des cases, notes, historiques, inconnues ou critères de fin.
- Les 12 672 demandes de voix et le graphe de médias proviennent des reçus V728/V729 conservés ; ces demandes ne sont pas réexécutées ici.
- Le chemin local des voix reste en_US ; la sélection historique EUW/en_GB n'est pas qualifiée.
- Le consommateur Rust audio_selection charge le contrat d'ambiance, reçoit uses_weight comme donnée et refuse mode!=0. Aucun chargement des banques de voix ni conversion de leurs poids dans ce consommateur n'est démontré.
- Les deux entrées de playlist répétées du corpus sont conservées. Les diagnostics montrent que le lecteur séquentiel accepte les doublons tandis que le lecteur aléatoire retourne 35 après la première insertion.
- Preuves privées conservées une seule fois sur F ; deltas ciblés compressés, sans copie complète des bases.

Les essais exploratoires sont conservés : enregistrement de hook ambigu, lecteur sans enfants, puis lecture arrêtée sur un bus absent. Le banc checked fournit les dépendances natives identifiées dans les sources, sans supprimer les champs du payload. Chaque conteneur reste isolé dans un nouveau registre ; ce n'est pas le chargement historique de banques entières.

## Livrables

Le [reçu de liaison](fidelity_native_voice_container_reader_links_v730.json) référence les preuves uniques sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision730_container_loader_checked/OBSERVATIONS.json, revision730_container_dependencies/OBSERVATIONS.json et revision730_container_associations/OBSERVATIONS.json.

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Documents de suivi : coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md, HANDOFF.md. Deux plan.sqlite3 mis à jour par deltas ciblés. Aucun code du jeu ou asset modifié.

Livraison : revision730_delivery/VERIFIED.json ; relecture indépendante réussie dans INDEPENDENT_READBACK.json. Le goal reste ouvert.
