# Inventaire audio — traçabilité V117

## SYS-16.1-01

Catalogue embarqué par banque ; sources VO loose en_US, langues RADS et autres familles non exhaustives.

Limites : Indexer toutes les langues natives et banques hors sous-ensemble annonceur/ambiance.

## SYS-16.1-02

Le chargeur compare frames, taux et canaux ; audit séparé prouve SHA256 et tranches natives de498 médias.

Limites : Le chargeur ne vérifie pas les empreintes au runtime ; conserver distinction audit et admission.

## SYS-16.1-03

Résolution événement/action/conteneur/playlist/source ;470événements et545alternatives dans tests, aucune source enregistrée manquante.

Limites : Couverture des événements hors catalogue et dispatch actif restent ouverts ; silence généré pas média manquant.

## SYS-16.1-04

Décodeur puis validation métadonnées ; audit498WAV sans PCM tronqué ni entièrement nul.

Limites : Silence partiel ou contenu audible incorrect non qualifié ; aucune écoute ni détection complète du silence avant intégration.

## SYS-16.1-05

RecordedMedia et GeneratedSilence distingués ;source950217071 silence natif, pas WAV obligatoire manquant.

Limites : Inventaire exhaustif des médias obligatoires et création de tâches nommées non identifiés ; ne pas inventer des manques.

## Contrôles

498 médias,17 archives ;470 événements,14482 valeurs natives.28 fichiers,58 contrôles de source,26 cas lecteur dont25 refus.8 tests Rust antérieurs conservés. Aucun test matériel audio. Premier audit offsets absolus incorrect conservé, remplacé par audit relatif DATA.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-16.1-01 | Catalogue embarqué par banque ; sources VO loose en_US, langues RADS et autres familles non exhaustives. | Indexer toutes les langues natives et banques hors sous-ensemble annonceur/ambiance. |
| SYS-16.1-02 | Le chargeur compare frames, taux et canaux ; audit séparé prouve SHA256 et tranches natives de498 médias. | Le chargeur ne vérifie pas les empreintes au runtime ; conserver distinction audit et admission. |
| SYS-16.1-03 | Résolution événement/action/conteneur/playlist/source ;470événements et545alternatives dans tests, aucune source enregistrée manquante. | Couverture des événements hors catalogue et dispatch actif restent ouverts ; silence généré pas média manquant. |
| SYS-16.1-04 | Décodeur puis validation métadonnées ; audit498WAV sans PCM tronqué ni entièrement nul. | Silence partiel ou contenu audible incorrect non qualifié ; aucune écoute ni détection complète du silence avant intégration. |
| SYS-16.1-05 | RecordedMedia et GeneratedSilence distingués ;source950217071 silence natif, pas WAV obligatoire manquant. | Inventaire exhaustif des médias obligatoires et création de tâches nommées non identifiés ; ne pas inventer des manques. |

Reçu : docs/reference_audio_inventory_sources/audio_inventory-links.json. Livraison : docs/fidelity_registry_audio_inventory_links_revision_4_20.json. Les cinq tâches et le Goal restent ouverts.
