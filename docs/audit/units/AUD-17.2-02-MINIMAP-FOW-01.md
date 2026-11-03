# AUD-17.2-02-MINIMAP-FOW-01 — Vision et brouillard de minimap

Date : 2026-10-30T21:11:42.787062+00:00. Projet F:\OpenLeague. Lot de l’audit SYS-01.2-02.

Résultat : la source shader, les producteurs de masque/publication, le raccordement au dessin et les limites de SYS-17.2-02 sont identifiés. La relecture indépendante décide de la clôture documentaire. Fonctionnalité partielle ; aucune validation actuelle de pixels ni acceptation humaine, aucun achèvement du goal.

## R1 — Exigence et périmètre

**SYS-17.2-02 — Afficher les zones de vision et brouillard sur la minimap** ; exigence **OLF-f32a1c04-9634-5487-b706-75ca0774c103** ; inconnue **OLU-c0b22951-bc81-5434-82d4-cadec1fa0366**, ouverte. Statut normatif `a_faire`, réalisation et acceptation `false`, conservés. Aucun critère normatif ni texte de goal modifié.

Phase D17, paquet D17-SYS-17-2 « Minimap, messages et score », neuf tâches ; prérequis D13-SYS-13-3. Les conditions D13 de vision/masque restent distinctes. Le précédent lot des marqueurs a son audit relu, sans terminer leur implémentation. [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.2-02-MINIMAP-FOW-01/audit-unit.json) définit ce lot : formule et données originales, masque/publication, texture, rectangle/UV, gardes de dessin et refus.

Exclusions : compléter les marqueurs, pings/notifications, toutes les mécaniques de furtivité/vision ou tout le moteur GPU. Une correction fonctionnelle n’est pas exécutée implicitement dans cet audit. Le tour précédent était un progrès vérifié, pas une attente de processus à relancer.

## R2 — Sources et dépendances effectivement reliées

Référence : LoL4.20.0.315, PUBLIC/Releases/4.20, EUW/en_GB, build2014-11-17 17:46:45, fuseau et date de déploiement non établis ; catalogue4.20.1.

Le HLSL original `DATA/Shaders/HLSL/HUD/MinimapFoW.ps_2_0`, **209octets**, est identique à la copie `data/4.20/native_minimap_fow.ps_2_0`, SHA-256 `e2f77d176b3c7fa159c95fff9f3acfcb7b54e8dbfa1c3d3c14a7daa6e70598ba`. Le binaire original voisin `_0.bin`,268octets, est disponible avec mot de version `0002ffff` ; il est identifié, **pas exécuté ni déclaré équivalent au WGSL compilé**.

Les deux sources expriment : échantillon du canal rouge r ; sortie noire RGB0 ; alpha **(1−r)×0,64**. Le WGSL actuel ne remplace pas cette valeur par hauteur, densité atmosphérique ou masque d’acteurs. La même formule source ne prouve ni le bytecode produit, ni les samplers, ni le mélange/format/couleur du framebuffer. Les conventions de prémultiplication donnent la même contribution RGB pour cette source noire ; cela ne qualifie pas tout l’état de mélange natif.

L’entrée `map10_terrain.inibin` est identique au fichier original LEVELS/Map10/terrain.inibin. `fow_settings` lit cette configuration et ses défauts hérités ; la chaîne actuelle exige le mode upscale Map10. **fadeStart/fadeFinish sont des seuils de hauteur**, pas des vitesses temporelles de fade. Les paramètres temporels proviennent d’un autre contrat. Le SCB et le rectangle de minimap sont ceux déjà vérifiés dans le lot précédent.

Le raccordement Bevy a été suivi dans les **sources de la version0.19.0 configurée** :

- Cargo.toml sélectionne explicitement **vendor/bevy_render**. Le fichier réellement inspecté est vendor/bevy_render/src/render_phase/draw.rs, pas simplement la copie de cache du registre. Son contenu pour ce fichier est identique au membre de l’archive de version ; cela n’affirme pas que tout vendor est inchangé.
- bevy_ui_render vient du paquet de registre verrouillé ; l’archive locale correspond au checksum de Cargo.lock et le fichier ui_material_pipeline.rs au membre de cette archive.
- `UiMaterialPlugin::build` enregistre d’abord le dessin standard. Ensuite le plugin minimap enregistre GuardedDraw sous le même type DrawUiMaterial<FogMaterial>. La vraie méthode add_with remplace l’index de type ; la vraie file UI récupère ce même index par `id::<DrawUiMaterial<M>>()`. Le raccordement est donc établi par le code configuré, pas par le seul commentaire du plugin.

Les archives de dépendances ont été lues **sans extraction ni installation**. `.cargo-checksum.json` était absent dans les répertoires consultés ; la preuve utilise les archives et la sélection de patch réelle. Aucune source de dépendance n’a été modifiée. Cette analyse ne prétend pas exécuter un build courant ni certifier tous ses inputs transitifs.

## R3 — Producteurs, publication et dessin

**1. Sources et vue CPU.** `fow_champion_sources` synchronise les champions alliés vivants et les unités alliées admises. Les rayons/géométries sont lus dans les ressources courantes ; le traitement est lié à Map10VisionView, à l’identité de son instance/vue, à la session et à l’équipe. Un changement de vue incohérent ou un échec révoque le statut. Le cycle peut être **sain et budgété** : sa réussite ne certifie pas que tout le snapshot a été régénéré. `represented_tick` identifie le cycle représenté, pas chaque source/pixel actualisé.

Le sélecteur client admet lane/Pet/Turret/Fountain. Le serveur, pour les autres unités alliées vivantes, applique un fallback building_radius ; inhibiteur/Nexus ne sont pas dans le sélecteur client. Les autels possédés participent à la vision de point côté serveur, mais ne sont pas consommés par ce synchroniseur de cercles. Ces différences de sélection sont constatées dans le code ; elles ne prouvent pas à elles seules un défaut de pixels en situation réelle ou la règle historique correcte. Les cas neutres, wards/pièges, révélations particulières et spectateurs ne deviennent pas qualifiés depuis le seul succès des cercles.

**2. Expansion et publication d’image.** `fow_visibility_texture` prend le masque128×128 et produit une image512×512 R8Unorm. Elle vérifie équipe, vue, tick du cycle, descripteur, horloge et compteurs avant de commettre les timestamps/publications. Une vraie expansion crée un **nouvel ImageId de transport** et retire l’ancien propriétaire Main. Un reset sans expansion ne devient pas une source GPU admissible ; les erreurs invalident la publication. Le contenu initial des coins a une allocation locale explicite, sans affirmation sur l’allocation native d’origine.

Un masque CPU, une publication de révision/épisode, une image extraite et une image préparée sont des étapes différentes. `same_episode` ne certifie pas tous les ticks et l’upload non échu conserve la dernière publication valide selon la cadence courante. Aucune fraîcheur complète n’est déduite de l’ImageId ou du tick seul.

**3. Extraction et passes GPU.** `fow_gpu` reprend la publication admissible au clock puis la revalide à l’extraction. Il distingue propriétaire courant, propriétaire remis à Render, replay et compteur de récupération ; une ressource Main absente ne laisse pas une ancienne admission certifiée. Le handoff précède la préparation générique des images.

La source préparée doit contenir des données et être512×512 R8Unorm ; les quatre destinations (deux fade, horizontal, output) sont512×512 RGBA8Unorm. La clé conserve publication/révision/épisode, recovery, texture source, allocations et vues. Le travail préparé est revalidé avant trois commandes : **fade, flou horizontal, flou vertical**. La disponibilité est inscrite après l’encodage des trois commandes, avant le camera_driver. Ce n’est **ni un acquittement de fin GPU ni une preuve de dessin ou de pixels**.

La politique locale réinitialise l’historique si session/équipe ou allocations des destinations changent ; une nouvelle publication/source seule ne le réinitialise pas. Un changement de vue doit aussi produire une identité d’encodage valide. Les compteurs/dépassements et replay en attente ferment la disponibilité, au lieu d’un raccourci « first_done donc prêt ».

**4. Overlay Main.** `native_minimap_fow::update` utilise le roster uniquement pour retrouver l’équipe du viewer local, **jamais ses positions d’acteurs**. Il exige le contexte session de la minimap de base, son rectangle, le viewer d’équipe0/1 et les images FoW. Le nœud reprend ce rectangle, utilise GlobalZIndex81 et une texture output. Ticket contient session, équipe, nœud, matériau et image. Absence de contexte/rectangle/ressource → retrait et ticketNone ; la texture du matériau est mise à jour si le handle change.

Ce ticket Main n’accorde aucune disponibilité GPU. Une équipe/session encore identique pendant une connexion interrompue ne qualifie pas le comportement réseau d’affichage ; **MM-READINESS-01** est réutilisé. Le brouillard du monde, l’omission des acteurs serveur et cet overlay sont trois consommateurs distincts.

**5. Binding et vraie garde de Draw.** `prepare_binding`, ordonné après **Encoded**, appelle ready_for_team, vérifie la texture actuelle RGBA8Unorm/D2/512×512/sample_count1 et prend ses TextureId/TextureViewId. Il crée le bind group sur **la vue actuelle**, avec sampler linéaire clamp/LOD0 explicite ; l’ancien PreparedUiMaterial n’est pas utilisé comme certificat de cette vue.

Au vrai Draw, la clé courante est recalculée. Elle doit être égale à celle liée et désigner le nœud et matériau de l’item/batch. Sinon le dessin est supprimé. Une absence de render resource, une session/équipe erronée, une allocation/vue remplacée ou un nœud/matériau différent n’est pas remplacé par un handle CPU ou une booléenne ancienne. La révocation prend effet à la prochaine extraction cohérente ; elle ne revient pas rétroactivement sur du travail extrait/en vol.

**6. UV et contenu.** Le test de landmarks compare la projection de structures au paramètre (scale,−scale,0,1) du SCB pour deux rectangles. Il établit une relation CPU de coordonnées. Il n’échantillonne pas une texture GPU de la frame courante et ne prouve pas les régions réellement visibles, les valeurs postprocess, le clipping/DPI ou les pixels finaux.

## R4 — Vérifications réellement exécutées

**135 contrôles documentaires et d’identité réussis** dans verify_fow.py ; syntaxe vérifiée. Contrôles nouveaux : provenance HLSL/config, sources courantes, dépendances réellement configurées et raccordement add_with→queue→GuardedDraw. Les sources du corpus1168fichiers sont inchangées ; les deux sources de dépendance sont contrôlées séparément de ce corpus.

| Cas | Attendu selon le code/contrat inspecté | Observé et portée |
|---|---|---|
| Source shader | Même canal rouge, noir, alpha0,64 | Source originale copiée exactement ; formule WGSL retrouvée. Pas de compilation/équivalence GPU. |
| Cycle source sain | Publication seulement sur cycle/vues/audience cohérents | Gardes et commentaires de budget inspectés ; pas de « snapshot entièrement régénéré » déduit. |
| Pas de vraie expansion / source absente / reset | Aucune source de transport admise par défaut | Branches d’invalidation et replay identifiées. |
| Handles/ticket Main présents, aucune image GPU préparée | Refus de disponibilité et de Draw | Code réel et cas CPU hérités ; aucun faux positif de rendu à partir d’Assets<Image>. |
| Session/équipe/allocation/vue différentes | Clés incompatibles, binding retiré ou dessin supprimé | Chaîne de revalidation et prédicat effectif retrouvés. |
| Nœud/matériau du batch différents | Pas de dessin via ce ticket | Comparaison au vrai Draw reliée à la sélection Bevy. |
| Commandes encodées | Encoded readiness limitée au contexte vérifié | Ce signal est distinct d’un readback ou des pixels d’un matériau. |
| Inhibiteur/Nexus/autel | Ne pas prétendre les sélections identiques | Différences serveur/client documentées avec reprise par source nommée. |
| Ancien GPU réussi | Conserver date et périmètre, comparer dérives | Preuves d’octobre réutilisées ; transport courant changé, minimap actuelle non qualifiée. |
| Conservation | Aucun changement des acquis | 25fichiers protégés, cinq registres et Git avant/après inchangés ; bases non ouvertes. |

Trois cas FoW du reçu19tests CPU du23octobre sont réutilisés, sans relance :

| Cas conservé | Portée réelle |
|---|---|
| `original_minimap_alpha_and_actual_map_landmarks_share_native_fow_uvs` | Réussite CPU héritée du23octobre ; non relancée |
| `actual_overlay_system_tracks_rectangle_handle_team_and_retires_on_session_loss` | Réussite CPU héritée du23octobre ; non relancée |
| `draw_gate_rejects_stale_session_team_allocation_view_material_and_node` | Réussite CPU héritée du23octobre ; non relancée |

Le premier vérifie des chaînes source et des coordonnées/arithmétiques CPU ; le second crée des tickets et nœuds Main sans rendre une texture FoW réelle ; le troisième utilise des identifiants contrôlés pour le prédicat. Les sources listées du reçu sont intactes ; tous les inputs transitifs core/vendor/GPU ne sont pas figés par ce reçu. Les noms de tests ne sont pas une observation native ou graphique nouvelle.

Contrats hérités non réexécutés : paramètres6cas, cadence d’upload8cas, driver14cas. Le driver trace les appels begin/upload/fade/blur/end par adaptateurs ; il n’exécute pas le device D3D complet.

Preuves GPU historiques séparées : diagnostic Vulkan32chaînes/96comparaisons de stages,64pixels par stage, tolérance1octet ; readback live du5octobre indiquant88niveaux de rouge. Ce ne sont pas des pixels de minimap actuelle ni une comparaison D3D originale. Leurs métadonnées et anciennes anomalies de loader Vulkan sont conservées ; captures/binaires non réinspectés ici. Les sources fow_gpu et fow_visibility_texture ont changé. Le shader de postprocess peut être inchangé sans qualifier son transport actuel.

Les anciens textes « GPU non connecté », « raw mask seulement » ou en-têtes de modules ne décrivent pas nécessairement les acquis ultérieurs : le code montre une chaîne et une garde de dessin existantes. Inversement, ces acquis ne qualifient pas l’ensemble des pixels. Les messages height fade sont distingués du fade temporel.

**Non exécutés maintenant** : Cargo/tests Rust, REA, client original, jeu, GPU, capture/readback courant, entrée OS ou session réseau. Aucune installation, migration ni redémarrage. Les recherches initiales de métadonnées de cache manquantes ont été réorientées vers les archives et le patch sélectionné ; aucune intégrité de tout vendor n’a été inventée.

## R5 — Corrections et conditions de reprise

Onze fiches **proposed_not_applied**, chacune avec un objectif, des prérequis, une entrée nommée et des preuves attendues. Elles ne modifient aucun plan normatif, goal ou base.

| ID | Travail unique | Critère de fin du futur correctif | Entrée nécessaire à la reprise |
|---|---|---|---|
| `MFOW-INHIBITOR-INPUT-01` | Contribution de l’inhibiteur allié | Comparer règle de vision originale, contribution serveur et source/masque client pour un inhibiteur nommé vivant/mort/supprimé, ou justifier sa suppression. | Descripteur/rayon/filtre original et état autoritaire ; SYS-13.1-07. |
| `MFOW-NEXUS-INPUT-01` | Contribution du Nexus allié | Même comparaison bornée pour le Nexus seul ; la différence de sélection source ne prouve pas un défaut de pixels observé. | Règle originale et source du Nexus, avec cas isolable ; SYS-13.1-07. |
| `MFOW-ALTAR-INPUT-01` | Contribution d’un autel possédé | Comparer une transition de possession/verrouillage selon la politique Map10 originale et le masque courant. | Source de vision d’autel originale et état courant filtré ; SYS-13.1-07. |
| `MFOW-NATIVE-SOURCE-01` | Un vrai descripteur/producteur d’acteur | Relier un acteur nommé à son descripteur original et vérifier éligibilité, empreinte/rayon et retrait ; pas de complétude wards/pièges/spectateurs déduite d’un cercle. | Descripteur/provider original et entrée courante de cet acteur ; SYS-13.1-01. |
| `MFOW-CADENCE-01` | Une cadence complète de publication | Comparer horloges, budget, upload, fade et non-échéance/reset/refus sur une transition nommée ; distinguer tick représenté et régénération complète. | Producteur d’horloge original et trace alignée source/publication/encodage ; SYS-13.1-07. |
| `MFOW-FIRST-READY-01` | Affichage initial ou indisponible | Qualifier initialisation/reset/perte de ressource/récupération selon une règle conserver/retirer/assombrir/chargement explicitement établie. | Appelant original de fallback ou politique locale acceptée et scénario courant. |
| `MFOW-RECOVERY-DRAW-01` | Récupération réelle des allocations et vues GPU | Vérifier remplacemens d’allocation/vue, équipe/session/source et recovery avant/après encodage/dessin sur un vrai backend. | Build courant, contexte de device/rendu et sortie/readback identifiés. |
| `MFOW-NATIVE-SAMPLE-BLEND-01` | Sampling, mélange et conversions natifs | Comparer un cas sampler/blend/render-target original/courant avec le bytecode natif et des pixels numériques. | États D3D/target/oracle original et backend courant, pas seulement les sources de shader. |
| `MFOW-SPATIAL-CONTENT-01` | Une région réelle du masque | Suivre une zone visible/occluse et sa frontière :128brut→512étendu→postprocess→pixels minimap, avec orientation/UV exacts. | Région et frame alignées, masque, texture et rectangle ; MM-PROJECTION-01. |
| `MFOW-CURRENT-PIXELS-01` | Une frame actuelle du brouillard de minimap | Avec build/assets figés, comparer pixels minimap pour équipes0/1 et transitions nommées de vision/resize/session, séparément du brouillard du monde. | Exécution/capture courante autorisée et oracle original ; MM-GRAPHICAL-01. |
| `MFOW-VIEW-MODE-01` | Un autre mode ou réglage natif | Qualifier un mode nommé et sa politique d’audience/réglages/dimensions, admis ou refusé sans substitution silencieuse. | Appelant original de mode/override et valeur courante typée. |

Arrêter les recherches inchangées sur le HLSL ou l’API de dessin déjà reliés. La reprise doit apporter un appelant, descripteur, règle, contexte de rendu ou frame comparée précisément identifié. Une garde logique, un test CPU, une trace d’encodage et un rendu réel demeurent des preuves différentes. Le manque d’oracle original reste explicite, sans substitution par une simple image plausible.

## R6 — Résultat et réemploi

Réutilisés : **SYS-13.1-01**, **SYS-13.1-07**, **SYS-13.3-06**, **MM-READINESS-01**, **MM-GRAPHICAL-01**, **MM-PROJECTION-01**, **HUD-LAYOUT-DPI-01**, **HUD-LAYOUT-PROJECTION-01**. Les sous-fiches nouvelles couvrent les producteurs/contributions et la passe FoW propre à cette exigence, sans recréer les corrections de marqueurs ou du cadre.

Résolu dans cet audit : source HLSL/config, différence des étapes de disponibilité, publication/ownership, texture et view courantes, sélection réelle du Draw, tests et vieux GPU correctement bornés, reprises atomiques. La garde n’est pas seulement une fonction isolée non utilisée : sa connexion à la file UI a été suivie dans la dépendance configurée.

Restent ouverts : tous les producteurs natifs et sources de vision, écarts de contribution, cadence/fraîcheur complète, mode initial/indisponible, récupération GPU réelle, sampler/blend/rasterisation natifs, contenu spatial et pixels courants, modes d’audience supplémentaires. Audit, implémentation, vérification en exécution et acceptation humaine sont indépendants. La clôture documentaire ne termine pas la fonctionnalité, le paquet neuf tâches, la minimap, le moteur ou le jeu.

## R7 — Livraison et conservation

[Preuve principale](F:/OpenLeague-work/audit-units/AUD-17.2-02-MINIMAP-FOW-01/minimap-fow-proof.json), 201638 octets, SHA-256 `7cecde782071d64330048518a3efdf4634023be03e0d9fc0e0d0dc89dd07cd4d` ; `audit_scope_closed=false` jusqu’à la [relecture indépendante](F:/OpenLeague-work/audit-units/AUD-17.2-02-MINIMAP-FOW-01/delivery-readback.json), autorité de clôture des sept rubriques.

Nouveaux fichiers uniquement : ce rapport, audit-unit.json, verify_fow.py, minimap-fow-proof.json, verify_delivery.py, delivery-readback.json dans le dossier isolé du lot. Les fonctions utilitaires existantes sont copiées par extraction AST ; l’ancien producteur n’est ni importé ni réexécuté. Création exclusive des reçus, aucune preuve antérieure remplacée.

Relecture sans écriture :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.2-02-MINIMAP-FOW-01\verify_delivery.py' --check-only
```

HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, main,76fichiers suivis déjà modifiés conservés. Les19fichiers logiciels gelés, les six documents de contexte et les cinq registres conservent leurs empreintes. Les dépendances, archives et sources n’ont été que lues. Aucun goal, critère, application/UI, code produit, registre/statut ou base modifié ; aucune base ouverte. Aucune installation, migration, relance, suppression ou mutation Git.
