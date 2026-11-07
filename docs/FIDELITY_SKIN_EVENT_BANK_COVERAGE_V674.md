# SYS-01.2-02 — Événements de skins et couverture des banques, V674

Date UTC : 2026-10-27T11:38:25.248564+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ;catalogue officiel 4.20.1 distinct. Le lot V673 précédent est une progression publiée et vérifiée.

## Résultat intégré

Les fiches **CH-Skarner-PASSIF-PRESENTATION-AUDIO**, **CH-Yasuo-PASSIF-PRESENTATION-AUDIO** et **SYS-01.2-02** distinguent désormais deux références événementielles non satisfaites d'une absence de banques. 42 liens natifs supplémentaires et 5 sources de preuve sont intégrés, avec leurs limites. Les anciens contextes et preuves restent conservés.

**Les 970 banques attendues par les deux manifestes sélectionnés sont toutes présentes et leurs octets correspondent aux membres de release.** Il n'y a aucun chemin de banque manquant ni supplémentaire dans cette comparaison. Le périmètre comprend594banques SFX et376autres banques. Les970fichiers se lisent au format88 sans erreur.

Les deux identifiants recherchés n'apparaissent **ni comme événement HIRC, ni comme identifiant de nœud HIRC, ni comme mot de32bits en little-endian dans les octets de ces banques**. Cela décrit précisément les banques de cette référence ;cela ne prouve pas tous les montages historiques, aliases, paquets externes ou appels serveur.

## Références concernées

- **Play_sfx_SkarnerSkin03_SkarnerPassiveBuffMinion_buffactivate**, ID3639181578, est explicitement inscrit dans une particule native du skin.
- **Play_sfx_YasuoSkin02_YasuoPassiveMSShieldOn_buffdeactivate**, ID2473124821, est explicitement inscrit dans une particule native du skin.

Les champs des particules sont relus et comparés aux observations antérieures. Les36sources natives retenues dans les liens de ce lot sont conformes aux manifestes. Les banques propres aux skins sont bien disponibles :l'audio entier du skin ne peut donc pas être déclaré manquant à partir de ces deux noms.

| Contexte | ID de skin non trouvé | Banques disponibles du champion, base/skins/SFX/VO | ID de base trouvé | ChampionSkinName, base / skin |
|---|---:|---:|---:|---|
| Skarner Skin03 | 3639181578 | 8 | 1184809146 | SkarnerBase / SkarnerSkin03 |
| Yasuo Skin02 | 2473124821 | 10 | 2417538304 | Yasuo / YasuoSkin02 |

Les événements de comparaison apparaissent dans Skarner_Base_SFX_events.bnk et Yasuo_Base_SFX_events.bnk. **Ils ne sont pas substitués aux noms demandés.** Aucune règle de repli n'est démontrée par leur seule présence.

## Configuration et montage restent distincts

Le champ MeshSkin.ChampionSkinName est identifié par son hash2142495409 et sa valeur native. Les quatre configurations sont conservées, avec leurs autres champs textuels. Le nom de base de Yasuo est Yasuo, et non YasuoBase :une convention de nom inventée ferait perdre cette distinction.

Ces valeurs et les chemins de banques ne démontrent pas leur ordre de chargement, la priorité base/skin, le traitement d'un événement inconnu ou les aliases appliqués par le runtime. Les répertoires VO/en_US restent des chemins de ressources ;ils ne sont pas promus en preuve de locale effective EUW/en_GB. Aucun chargement historique de banque, décodage audio, son audible ou partie de jeu n'est exécuté.

## Contrôles réellement exécutés

1. Lecture et identification des970banques ;comparaison chemin/taille/MD5 aux manifestes sélectionnés, puis conservation des SHA-256.
2. Comparaison exhaustive de l'ensemble des chemins .bnk des manifestes avec les chemins scannés :970attendus,970observés,zéro manque,zéro supplément.
3. Deux cas nominaux positifs :les événements de base sont trouvés. Un parcours indépendant des en-têtes HIRC confirme le nombre d'objets de type4 du lecteur d'événements.
4. Quatre refus :entrée vide,en-tête tronqué,corps tronqué et version de banque89 hors contrat88. **Sept contrôles source dont quatre refus**, tous réussis.
5. Recherches littérales des deux noms dans les crates Rust et les preloads natifs. Leur absence de correspondance dans ces recherches ne prouve pas l'absence de tout appel dynamique.
6. Les preuves de hachage/refus du chemin ambiant V672 sont héritées après revalidation des empreintes du code courant. Elles ne sont pas réexécutées dans ce lot et ne deviennent pas une qualification du jeu complet.

Le reçu de couverture est : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision674_manifest_bank_coverage\OBSERVATIONS.json. L'observation principale est : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision674_skin_event_audit\OBSERVATIONS.json. Chaque banque, configuration, particule, commande et limite possède son identité et son résultat dans ces documents.

## Livraison et conservation

Les contrôles sur copie refusent une acceptation automatique, la suppression d'un consommateur et le retrait d'un lien natif. L'inversion documentaire retrouve les octets d'origine ;l'inversion SQLite retrouve l'état logique d'origine. Les véritables lecteurs Store.task,copy_text,summary et trace sont exercés ;les JSON des instructions copiables sont comparés structurellement. La synchronisation normale reste idempotente.

Les deux bases relues contiennent chacune trois lignes enrichies. Les42604autres lignes,42607états manuels et23entrées d'historique sont conservés, ainsi que critères,dépendances,anciens contextes et registre des inconnues. Aucun consommateur fonctionnel,code ou asset de jeu n'est ajouté. Les gros documents utilisent des temporaires compressés,une réserve d'espace,des blocs64Kio et un remplacement atomique après vérification SHA. Les grandes copies JSON devenues inutiles sont libérées avant les sauvegardes SQLite ;aucune preuve n'est supprimée.

| Commande exécutée | Code | SHA-256 du journal |
|---|---:|---|
| V674_SKIN_EVENT_AUDIT | 0 | 578f06592f83c66da3d2b748abba0cd74846431ddf7d78314346a25be204f92e |
| V674_MANIFEST_BANK_COVERAGE | 0 | 510397947f7c2e6a285ad6d5877230b41136f9b19a6c38fb6598ed6cf8fbe9b4 |
| V674_SKIN_EVENT_PREPARE | 0 | 024a379f1d75e656cb8f47d165555dc21073c4771856dba755510c0efd3afaaf |
| V674_SKIN_EVENT_CHECK | 0 | 1b960e64910e63b7179b0361cdcdd944ee18cb57bbb123c2417f98df7e04b8f2 |
| V674_SKIN_EVENT_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V674_SKIN_EVENT_DELIVERY_AUDIT | 0 | 01ee803a992b517ba29d85832e872512974bc211361ca34c1232bda8c37c97c6 |

## Fichiers mis à jour

- docs/completion_tasks_2026-10-20.json :contextes et instructions des trois fiches.
- docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json :liens et sources.
- docs/reference_requirement_trace_sources/skin-event-bank-coverage-v674.json :reçu d'association.
- docs/fidelity_skin_event_bank_coverage_v674.json :audit de publication.
- docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md :couverture et reprise.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 :bases du plan.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision674_* :scripts exécutés,journaux,observations,deltas réversibles et sauvegardes.

## Limites et suite

Les deux références restent non résolues au runtime. Aucune absence globale de média,aucune nécessité de reconstruction et aucun repli vers la base ne sont déduits. Les anciens écarts Malzahar et Voracity/KatarinaPassive restent ouverts. Aucun champion,passif ou jeu complet n'est accepté à partir de ce lot.

Continuer SYS-01.2-02 sur F:/OpenLeague. V674 Skarner/Yasuo AUDIO + SYS publié/audité. Les970banques attendues aux manifestes sont toutes présentes et conformes (594SFX,376autres). Aucun événement,nœud ou mot32bits pour3639181578/2473124821 ;aucune banque manquante dans ce périmètre. Banques des skins présentes ;événements de base1184809146/2417538304 disponibles,mais aucun repli prouvé. ChampionSkinName :SkarnerBase/SkarnerSkin03 et Yasuo/YasuoSkin02,ne pas fabriquer systématiquement un suffixeBase. Suite : inspecter le montage et la résolution audio de skin côté natif/courant si une source précise existe ;sinon conserver ces deux références non satisfaites et avancer sur les13autres fiches candidates V672,leurs callbacks/preloads et consommateurs réels. Ne pas boucler sur le même inventaire complet ;ne pas remplacer ni reconstruire les sons sans preuve. Conserver les inconnues Malzahar et Voracity/KatarinaPassive,les effets partagés et la séparation source/activation/écoute. Préserver les cases/notes/historiques ;publication par réserve,temporaires compressés,blocs64Kio et SHA. Surveiller l’espace des copies SQLite surC. Goal actif.
