# SYS-18.1-02 — disponibilité indexée des conteneurs

2026-11-01T16:49:27.891454+00:00

Lot indexé terminé sous réserve de relecture ; parent ouvert pour les octets/membres des cinq sources. Aucune image, écran ou jeu complet revendiqué.

Extraire les images du patcher depuis les fichiers fournis
Le résultat « Extraire les images du patcher depuis les fichiers fournis » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Sources et résultat
Lecteur PeaZip7z/ZSTD préexistant : index exact160749522octets,1736660743octets lus en mémoire et7757905lignes. Aucun fichier décompressé complet écrit.7notices/lignes témoins exactement reproduites.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-assets.load ; fileId 1C7C08542CA77434 ; ligne 4554589 ; 54448044octets ; MD5 attendu 0b9e2bb8b82f9ea32549f666a1c294d8.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-dev.load ; fileId DA84F587FDA8E2A2 ; ligne 4554593 ; 449240octets ; MD5 attendu d5eec71317fa25d43430f0a0cbdd5e5f.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-hub-news-A.load ; fileId 45A24657E2837EBC ; ligne 4554595 ; 665232octets ; MD5 attendu b4d1b90a862d2e30820444a8608abf6b.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-hub-news-B.load ; fileId 8C0A980B7A5C1B31 ; ligne 4554596 ; 1380368octets ; MD5 attendu 518ff65771d7d6b9dd5e68bd8b6a94e3.
- live/projects/lol_patcher/releases/0.0.0.11/files/Content/Loadable/RiotClient/Release/bundle-vendor-lib.load ; fileId 6DDAD51DB7F439EE ; ligne 4554600 ; 7397172octets ; MD5 attendu cfadc55c2ccf445a38d34abe7be68b6e.

## Refus et précision de méthode
Parse path and require exact live equality; raw substring and size are insufficient.
Les12JSON Maclive sont exclus par le champ path. Certains ont la même taille, tous un autre fileId. Le champ link est vide.
Deux analyses préparatoires code1 conservées : la recherche par sous-chaîne laissait12occurrences hors portée non qualifiées ; la sonde a réfuté l’hypothèse de chemins simples et conservé les vrais objets JSON. Les deux décodeurs ont retourné0 et le même flux ; classification finale depuis leurs sorties, sans troisième lecture.

## Attendu, observé, limites

### KNOWN-LIVE-CONTROLS
Attendu : Seven retained notices and line numbers exactly match.
Observé : 7/7known entries and lines match;12live target notices are unique.
Limite : Metadata only, not new recovered bytes.

### OTHER-PREFIX-REFUSAL
Attendu : Require exact parsed path, refuse Maclive substring hits.
Observé : 12Maclive entries excluded. Some have equal size; all have different IDs and an empty link field.
Limite : No platform/byte equivalence inferred from size or substring.

### CANDIDATE-NOT-PAYLOAD
Attendu : Find five indexed candidates and preserve payload uncertainty.
Observé : Five live entries match native expected size; fileIds and source lines identified. Payload paths remain absent and MD5 unverified.
Limite : No remote availability, archive offset map or image population proven.

### BOUNDED-METHOD
Attendu : Use an existing decoder and retain actual failures.
Observé : Existing PeaZip7z/ZSTD returned0 twice with identical in-memory streams. Initial analyses returned1; final classification reused their outputs with no third stream.
Limite : No installation, full decoded file, whole archive download or image extraction.

## Reprises ouvertes

### PATCHER-INDEXED-PAYLOAD-NOT-RECOVERED
Les cinq notices sont identifiées mais leurs octets LOAD et populations de membres/images ne sont pas qualifiés.
Reprise : Réutiliser les fileIds/tailles/MD5 exacts ; identifier la récupération par plages antérieure, puis qualifier seulement un payload admissible par manifeste et parse LOAD.

### PATCHER-REMAINING-MEDIA-WORK
Copies individuelles, pixels/frames et usage rendu des115images restent aux limites du lot précédent.
Reprise : Réutiliser ses notes par membre ; aucun nouveau scan identique des trois racines.

## Sept rubriques
- 1 : Périmètre indexé des cinq sources, parent complet conservé.
- 2 : Index épinglé et7témoins ; métadonnées distinctes du payload.
- 3 : Lecteur existant et pipeline documentaire réels, aucun launcher modifié.
- 4 : Deux codes décodeur0 et analyses1 conservés ; classification et contrôles actuels précis.
- 5 : Cinq payloads et leurs membres restent une entrée exacte de reprise.
- 6 : Préfixe exact corrigé documentairement, sans tâche produit ou critère nouveau.
- 7 : Preuves immuables et relecture distincte, goal/Plan/bases inchangés.

Candidats identifiés et faux positifs Maclive qualifiés ; la récupération des octets et l’audit des membres restent à faire. Le parent demeure ouvert.
Exécutés : lecture index par outil présent et contrôles documentaires. Non exécutés : récupération distante de payload, export/décodage image, jeu/launcher/AIR/Rust/GUI/GPU/réseau, REA, ancien test/lecteur. Aucun ancien code0 inventé.
Ajouts uniquement : ce rapport et F:\OpenLeague-work\audit-units\AUD-18.1-02-MISSING-CONTAINER-AVAILABILITY-01. Goal, critères, produit, suivi, registres et bases conservés.
Prochain lot : AUD-18.1-02-ARCHIVE-RANGE-RECOVERY-01 — Identifier la méthode de récupération par plages déjà utilisée ; rattacher les cinq fileIds live à un payload contrôlable, sans téléchargement intégral d’archive.
