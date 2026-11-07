# AUD-17.2-04-PING-VARIANTS-01 — Variantes historiques de ping

Les sources originales contiennent **12 compositions de minimap, 15 effets paramétrés, 8 définitions de particules de monde et 13 références de libellés**. Ce sont des ensembles distincts, sans bijection ou correspondance avec des opcodes démontrée. Le lot identifie les ressources et les consommateurs adjacents ; aucun rendu ou son de ping courant n’est qualifié. Après relecture indépendante, l’audit de cette exigence peut être clos avec la fonctionnalité ouverte.

## R1 — Exigence et limites du lot

- **SYS-17.2-04** : « Afficher et écouter les variantes de ping historiques ».
- Exigence **OLF-d86ccd51-c126-5fa3-a864-6115a9ba2778**.
- Inconnue **OLU-f9d658a7-0c9a-5fba-b500-af7140e1e4aa**, conservée `open`.
- Registre conservé `a_faire`, implémentation et acceptation `false` ; aucun critère normatif modifié.
- Référence LoL 4.20.0.315 PUBLIC Releases/4.20, EUW, en_GB, catalogue 4.20.1. Ni les noms de banque ni les defaults en_US ne qualifient une sélection audio de locale en_GB.

Portée complète de la question d’audit : sources des variantes, références graphiques et audio, consommateurs réels ou absence bornée, attendu/observé, manques et reprises précises. L’entrée/transport/admission de ping reste SYS-17.2-03 et ses fiches PING-POS-* ; ses preuves sont réutilisées sans nouvelle recherche identique. Aucune implémentation implicite du jeu, aucune modification du goal, des critères de clôture, du suivi ou de ses bases.

Phase D17 et lot D17-SYS-17-2 : cette exigence est l’une des neuf tâches du lot. Le prérequis D13-SYS-13-3, « Confidentialité de l’état de jeu », reste `a_faire` et requiert D13-SYS-13-1. Sa validation future concerne notamment la réception et l’audience des événements. Elle n’empêche pas de constater l’absence actuelle de consommateur de variantes. Le goal global et le jeu restent incomplets.

## R2 — Sources, identités et contrats réellement retrouvés

Racine originale : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/`.

### Compositions de minimap

`DATA/menu/hud/minimap.ini` : 17 707 octets, SHA-256 **197b401bea7eb4d4999a65ca28e11f85a7607b6cbc010e94ab3f85d1521ffde9**. Les sections `[Pings]`, `[PingEffect1..15]`, `[PingType1..12]` contiennent **224 champs** vérifiés : deux compteurs, 150 paramètres d’effet et 72 références de couches.

Chaque effet contient AlphaStart, AlphaFadeSpeed, ScaleStart, ScaleSpeed, StartDelay, Life, OnDeathFadeSpeed, RepeatCount, Color et Blend. Les valeurs brutes sont conservées : notamment `Life=0` pour certains effets et `RepeatCount=3` pour d’autres. Leur présence ne prouve ni la formule de mise à jour, ni les unités, ni la signification de zéro, ni si le compte désigne des répétitions supplémentaires. Le callback natif de sélection et l’évaluateur temporel restent à qualifier.

| Profil source | Couches 1 / 2 / 3 ; effet associé |
| PingType1 | PingMarker.dds → 1 ; Ring.tga → 2 ; Ring2.tga → 3 |
| PingType2 | PingMarker_green.dds → 1 ; Ring_green.tga → 2 ; Ring2_green.tga → 3 |
| PingType3 | PingMarker_red.dds → 1 ; Ring_red.tga → 2 ; Ring2_red.tga → 3 |
| PingType4 | PingMarker_Danger.dds → 1 ; Ring_Danger.tga → 2 ; Ring2_Danger.tga → 3 |
| PingType5 | PingMarker_tintable.dds → 4 ; Ring_tintable.tga → 5 ; Ring2_tintable.tga → 6 |
| PingType6 | PingMarker_tintable.dds → 7 ; Ring_tintable.tga → 8 ; Ring2_tintable.tga → 9 |
| PingType7 | PingMarker_tintable.dds → 10 ; Ring_tintable.tga → 11 ; Ring2_tintable.tga → 12 |
| PingType8 | PingMarker_tintable.dds → 13 ; Ring_tintable.tga → 14 ; Ring2_tintable.tga → 15 |
| PingType9 | PingMarker_tintable.dds → 4 ; Ring_Danger.tga → 2 ; Ring2_Danger.tga → 3 |
| PingType10 | PingMarker_tintable.dds → 7 ; Ring_Danger.tga → 2 ; Ring2_Danger.tga → 3 |
| PingType11 | PingMarker_tintable.dds → 10 ; Ring_Danger.tga → 2 ; Ring2_Danger.tga → 3 |
| PingType12 | PingMarker_tintable.dds → 13 ; Ring_Danger.tga → 2 ; Ring2_Danger.tga → 3 |

Les **15 textures uniques** référencées ont chacune un candidat direct dans les répertoires inspectés : cinq PingMarker DDS 32×32 sous `DATA/Images/UI`, et dix anneaux TGA 256×256 sous `DATA/menu/MiniMapIcons`. Identités, dimensions et en-têtes conservés dans le reçu. Ces contrôles ne sont pas un décodage intégral d’image ni une preuve de pixels GPU. La recherche trouve un candidat unique dans ces racines ; la priorité du résolveur natif n’est pas exécutée.

Les types numériques ne sont pas renommés arbitrairement « danger », « MIA » ou numéros de paquets. Par exemple, plusieurs compositions emploient le même PingMarker_tintable avec des effets/couleurs différents ; le contexte qui les choisit reste une question distincte.

### Particules de monde

Les huit `.troybin` de `DATA/Particles` sont lus par les seules fonctions AST du lecteur existant `tools/native_troy.py`, sans import de son module ni lancement de script de production. Le lecteur v2 borné expose valeurs, hash de champ, type, offset et octets bruts ; aucune exécution du moteur natif n’est revendiquée.

| Définition originale | Champs décodés |
| ping-attack.troybin | 19 |
| ping-caution.troybin | 47 |
| ping-comehere.troybin | 48 |
| ping-command.troybin | 74 |
| ping-danger.troybin | 48 |
| ping-defend.troybin | 22 |
| ping-mia.troybin | 80 |
| ping-omw.troybin | 79 |

Total : **417 champs**, **35 références de ressources**. Deux références ont un candidat exact ; 33 ont un candidat DDS alors que la référence demande un TGA. La règle TGA→DDS n’est pas qualifiée par cette ressemblance de nom. Le modèle `ping-omwarrow.sco` est identifié comme candidat exact. `alpha_20_03.tga` conduit à un nouveau candidat précis dans `DATA/Shared/Particles/alpha_20_03.dds` ; il n’est pas déclaré manquant après la recherche limitée initiale dans les seuls répertoires locaux de particules.

Toutes les références ont un candidat dans les racines inspectées, sans substitution ni copie de fichiers. Cela ne certifie pas leur résolution au chargement, leurs matériaux, la simulation, l’animation, le placement ni le rendu. Les familles attack, caution, comehere, command, danger, defend, mia et omw proviennent des noms de définitions, sans preuve que chacune corresponde à un unique événement réseau ou libellé.

### Bouton de ping et libellés

Les layouts originaux `DATA/menu/hud/Elements/ShadowIslesMinimapRight.ini` et `ShadowIslesMinimapLeft.ini` contiennent chacun **PingHover, PingClicked, PingOverlay**, avec `Enabled: 0`, atlas HUDAtlas, couches 4/5/6, rectangles/UV et ancres droite/gauche distincts. Les trois états de bouton ne sont pas les douze compositions de ping reçu. Les fragments exacts et les empreintes des deux layouts sont dans le reçu. Leur chargement dans les ressources de HUD ne prouve pas un callback de survol/clic ni une interface de ping fonctionnelle.

`ping.ini` et les treize références Offense/Danger/Throttled/General sont réutilisés du lot SYS-17.2-03. Aucun texte rendu en en_GB ni signal sonore n’est démontré par un identifiant lexical. Les huit bindings par défaut ont déjà été identifiés dans ce lot ; ils ne sont pas recherchés à nouveau.

### Audio : candidats présents, identité du ping non établie

| Banque candidate HUD | Octets / SHA-256 | Observation bornée |
|---|---|---|
| `DATA/Sounds/Wwise/SFX/Shared/HUD_Global_events.bnk` | 7 980 / `274924403ef4a067e96ec8b6ea0f6dab92c13c676fb1659de63e9260d7d3a689` | Sections BKHD/HIRC/STID ; 190 objets HIRC, dont **59 identifiants de type 4**. |
| `DATA/Sounds/Wwise/SFX/Shared/HUD_Global_audio.bnk` | 545 296 / `1897d35738d0a0dfe138b37dd5e237313dbd96f44fe661c9c5f044376e5249a9` | Sections BKHD/DIDX/DATA/HIRC/STID ; **53 entrées média DIDX** bornées dans DATA. |

Ce sont des banques HUD candidates, pas des banques de ping certifiées par ce lot. STID ne donne ici que des noms de banques. Les 59 identifiants ne sont pas 59 pings ; les 53 entrées ne sont pas 53 sons de ping. Aucun événement nominatif de ping ni chaîne événement→action/graph→média n’est qualifié, aucun média décodé ou écouté. L’absence de chaîne textuelle « ping » dans ces deux conteneurs ne prouve pas l’absence de ses médias. Aucun nom d’événement n’est deviné par force brute.

Le reçu `docs/reference_audio_settings_sources/audio_settings-links.json`, daté du 23 octobre 2026 à 06:14:43 UTC, est réutilisé. Dans le Game.cfg original et sa copie locale, `[Volume] PingsVolume=1.0` est vérifié à la ligne 159 ; les deux fichiers gardent le SHA-256 **02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e**. Ce paramètre par défaut ne prouve pas qu’un gain soit effectivement appliqué à une voix. Lecture des octets seulement : le chargeur de settings susceptible de migrer une configuration n’est jamais appelé.

Manques historiques précis : sélecteur de variante selon événement/contexte/équipe/mode ; évaluateur des effets et priorité de résolution ; appel/identité audio et chaîne média ; comparaison native visuelle et audible. Reprise sur un callback/xref nommé, une archive/index qualifiés ou une capture originale datée discriminant cette question. Pas de recherche externe ou REA répétée sans piste nouvelle.

## R3 — Consommateurs courants et absence bornée

Le corpus des **1 168 fichiers de code** est identique, par appartenance et empreintes, à celui déjà contrôlé par le lot de ping de position. Son absence de commande/événement de ping est réutilisée : les types d’entrée, d’action, de sortie et les routes serveur ont été inspectés dans SYS-17.2-03 ; ils ne sont pas présentés comme un nouveau test de ce lot.

Une seule nouvelle recherche de noms discriminants couvre PingType, PingEffect, PingHover/PingClicked/PingOverlay, PingMarker, PingsVolume, HUD_Global et les huit noms de particules. Elle ne donne aucun consommateur dans ce corpus. Motif exact et liste vide conservés ; ce constat textuel est rapproché des vrais points d’entrée :

| Consommateur inspecté | Acquis et frontière |
|---|---|
| `crates/client/src/native_minimap.rs:67` | Profil de six styles de marqueurs ; import explicite de cinq images background/cercles/strip/relique. Pas de consommateur des sections PingType/PingEffect. Nœuds de marqueurs/FoW déjà présents, sans réception de ping. |
| `data/4.20/native_minimap_profile.json` | Clés schema/map/strip_count/styles/source/marker_size_policy ; aucun groupe de pings exporté. Le Minimap.ini source peut contenir davantage que ce profil sélectionné. |
| `crates/client/src/map_audio.rs:7` | Sons réels de relique et d’autel ; leur existence est conservée. Aucun événement de ping lié à ces branches. |
| `crates/client/src/map_audio_requests.rs:82` | Liste explicite de cinq définitions d’émetteurs d’ambiance ; autre particule → « unqualified ambient particle ». Ce refus local d’ambiance n’est pas un refus de ping exécuté. |
| `crates/client/src/main.rs:876` | Systèmes d’ambiance réellement enregistrés après les événements et positions. Aucun branchement de ping identifié. |
| `crates/client/src/pcm_audio.rs:1` | Transport PCM existant ; échantillons remis au mixeur/épuisement ne constituent pas fin matérielle audible ou événement natif de fin. |
| `crates/client/src/native_particle_class.rs:1` | Classification et sélection de classe existent ; elles ne constituent pas l’exécution de ces huit définitions de ping. |
| `crates/client/src/native_user_settings.rs:33` | Ressource de settings et texte parsé disponibles. Aucune application de PingsVolume à un son de ping identifiée ; chargement/migration non exécutés. |

L’inventaire direct des **6 554 fichiers locaux** sous assets/data ne trouve aucun nom de fichier libre correspondant aux pings/anneaux ciblés. C’est une recherche de noms explicites : les atlas, archives et membres sous noms différents peuvent contenir des pixels. On ne déclare pas tout l’atlas ou tout le backend audio manquant. Les états PingHover/PingClicked/PingOverlay peuvent être présents dans des ressources HUD chargées génériquement sans être pilotés.

La conclusion porte sur l’absence de chemin de présentation de variantes de ping identifié dans ces sources et routes actuelles. Elle ne signifie pas absence de moteur graphique, de sons, d’images génériques ou de ressources originales sur la machine.

## R4 — Attendu, observé et contrôles exécutés

**206 contrôles documentaires réussis** : identités/registres, champs et compositions, candidats de ressources, en-têtes, structures des banques, prérequis et conservation. Le lecteur indépendant contrôle ensuite ces données et les sept rubriques. La décision de clôture dépend de son résultat.

| Cas | Attendu pour la fonctionnalité | Observé / limite |
|---|---|---|
| Chaque profil PingType1..12 | Trois couches et effets appropriés visibles selon le bon événement et le temps. | Composition écrite retrouvée, quinze textures candidates ; aucun rendu de ping courant exécuté. |
| Chaque définition de monde | Définition, textures/modèle et comportement du bon événement observés. | Huit définitions/417 champs lisibles ; références résolues seulement comme candidats ; pas de simulation/rendu qualifié. |
| Son de chaque variante applicable | Appel/ID/graph/média exacts et sortie audible, ou silence historique explicitement établi. | Banques et index présents ; identité sonore de ping non récupérée. Aucune écoute ou absence sonore native revendiquée. |
| Durée, répétition, changement d’équipe/époque | Apparition, progression, expiration/retrait et absence de rejeu établis. | Valeurs d’écriture présentes, évaluateur et chemin reçu manquants ; aucun test de cycle de ping. |
| Type, ressource ou son invalide | Refus explicite selon contrat, sans substitution ou fuite. | Pas de dispatcher de ping ; refus générique d’ambiance uniquement lu. Aucune erreur de ping exécutée. |
| Volume et perte de périphérique | Gain/mute appliqué, résultat indépendant du visuel et sortie contrôlée. | PingsVolume par défaut et transport PCM identifiés ; gain et sortie de ping non démontrés. |

Les tests anciens de minimap sont référencés uniquement via la preuve précédente : dix-neuf tests CPU datés du 23 octobre, dont quatre contrôles adjacents d’entrée/Move. Aucun ne devient un test de variante ou d’écoute. Ils ne sont ni relancés ni requalifiés par le nouvel inventaire.

**Non exécutés maintenant :** compilation/tests Rust, client/serveur ou réseau, processus original, REA, entrée OS, décodage intégral d’image, téléversement GPU/captures de pixels, décodage/lecture/capture audio. Aucun binaire de jeu n’est lancé ou remplacé. Les seuls exécutables utilisés sont les outils locaux existants de lecture/contrôle, avec leurs scripts identifiés.

La première piste de texture alpha limitée aux répertoires de particules principaux a été précisée vers Shared/Particles après une recherche exacte nouvelle ; ce n’est pas une ressource manquante démontrée. Un chemin supposé audio_settings.rs était absent : les vrais settings et références audio existantes ont ensuite été inspectés, sans conclure à l’absence du sous-système.

## R5 — Corrections précises et conditions de reprise

**28 fiches `proposed_not_applied`** sont proposées hors registre. Douze concernent chacune un profil PingType, huit une définition de monde ; les autres traitent des comportements communs distincts. Chaque fiche du reçu contient objectif unique, critères de fin, dépendances, entrée de reprise et preuve attendue. Aucune correction n’est appliquée implicitement.

| ID / résultat unique | Critère de fin | Entrée nécessaire à la reprise |
| **PVAR-SELECTOR-01** — Relier un événement de ping historique aux compositions minimap/monde et à son identité sonore. | Identifier le callback natif et la table de sélection par événement/contexte ; distinguer les12 profils graphiques,8 définitions de monde et13 libellés. Enregistrer les cas non sonores et inconnus sans inventer de bijection/opcode. | Xref/callback natif ou capture originale datée avec événement, équipe/mode et sélection des ressources. Dépendances : Preuves SYS-17.2-03 ; configuration originale Minimap.ini/ping.ini. |
| **PVAR-RESOURCE-01** — Qualifier la résolution des références de textures et du modèle de ping. | Établir les chemins/priorités et la règle TGA→DDS ou refus ; résoudre alpha partagé et modèle omw sans substitution silencieuse ; contrôler les ressources choisies. | Lecteur natif de résolution ou archives/index qualifiés et références brutes des8troybin et12profils. Dépendances : Sources DATA/Images/UI,MiniMapIcons,Particles,Shared/Particles ; alias jamais qualifié par le seul même stem. |
| **PVAR-MINIMAP-COMPOSITOR-01** — Composer les trois couches d’un profil PingType avec son cycle d’effet. | Implémenter le consommateur des champs AlphaStart/AlphaFadeSpeed/ScaleStart/ScaleSpeed/StartDelay/Life/OnDeathFadeSpeed/RepeatCount/Color/Blend avec unités et interprétation native qualifiées, dont Life=0 et répétition. | Fonction native de mise à jour/dessin ou observation temporelle comparative ;15effets sources disponibles. Dépendances : PVAR-RESOURCE-01 ; MM-PROJECTION-01 ; ne pas traiter les valeurs comme équations déjà récupérées. |
| **PVAR-MINIMAP-TYPE-01** — Qualifier et afficher le profil source PingType1. | Raccorder exactement couche1=PingMarker.dds/effet1; couche2=Ring.tga/effet2; couche3=Ring2.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-02** — Qualifier et afficher le profil source PingType2. | Raccorder exactement couche1=PingMarker_green.dds/effet1; couche2=Ring_green.tga/effet2; couche3=Ring2_green.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-03** — Qualifier et afficher le profil source PingType3. | Raccorder exactement couche1=PingMarker_red.dds/effet1; couche2=Ring_red.tga/effet2; couche3=Ring2_red.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-04** — Qualifier et afficher le profil source PingType4. | Raccorder exactement couche1=PingMarker_Danger.dds/effet1; couche2=Ring_Danger.tga/effet2; couche3=Ring2_Danger.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-05** — Qualifier et afficher le profil source PingType5. | Raccorder exactement couche1=PingMarker_tintable.dds/effet4; couche2=Ring_tintable.tga/effet5; couche3=Ring2_tintable.tga/effet6, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-06** — Qualifier et afficher le profil source PingType6. | Raccorder exactement couche1=PingMarker_tintable.dds/effet7; couche2=Ring_tintable.tga/effet8; couche3=Ring2_tintable.tga/effet9, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-07** — Qualifier et afficher le profil source PingType7. | Raccorder exactement couche1=PingMarker_tintable.dds/effet10; couche2=Ring_tintable.tga/effet11; couche3=Ring2_tintable.tga/effet12, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-08** — Qualifier et afficher le profil source PingType8. | Raccorder exactement couche1=PingMarker_tintable.dds/effet13; couche2=Ring_tintable.tga/effet14; couche3=Ring2_tintable.tga/effet15, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-09** — Qualifier et afficher le profil source PingType9. | Raccorder exactement couche1=PingMarker_tintable.dds/effet4; couche2=Ring_Danger.tga/effet2; couche3=Ring2_Danger.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-10** — Qualifier et afficher le profil source PingType10. | Raccorder exactement couche1=PingMarker_tintable.dds/effet7; couche2=Ring_Danger.tga/effet2; couche3=Ring2_Danger.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-11** — Qualifier et afficher le profil source PingType11. | Raccorder exactement couche1=PingMarker_tintable.dds/effet10; couche2=Ring_Danger.tga/effet2; couche3=Ring2_Danger.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-MINIMAP-TYPE-12** — Qualifier et afficher le profil source PingType12. | Raccorder exactement couche1=PingMarker_tintable.dds/effet13; couche2=Ring_Danger.tga/effet2; couche3=Ring2_Danger.tga/effet3, vérifier ce profil sur minimap avec chronologie/couleur/échelle ; refuser référence indisponible et retirer ses nœuds à expiration/fin de session. | Profil source et15effets épinglés ; sélection native ou adaptation explicitement locale pour ce profil. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01, PVAR-MINIMAP-COMPOSITOR-01 ; réception de ping SYS-17.2-03. |
| **PVAR-WORLD-ATTACK-01** — Qualifier et rendre la définition de monde ping-attack. | Intégrer les champs bruts de ping-attack.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-CAUTION-01** — Qualifier et rendre la définition de monde ping-caution. | Intégrer les champs bruts de ping-caution.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-COMEHERE-01** — Qualifier et rendre la définition de monde ping-comehere. | Intégrer les champs bruts de ping-comehere.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-COMMAND-01** — Qualifier et rendre la définition de monde ping-command. | Intégrer les champs bruts de ping-command.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-DANGER-01** — Qualifier et rendre la définition de monde ping-danger. | Intégrer les champs bruts de ping-danger.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-DEFEND-01** — Qualifier et rendre la définition de monde ping-defend. | Intégrer les champs bruts de ping-defend.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-MIA-01** — Qualifier et rendre la définition de monde ping-mia. | Intégrer les champs bruts de ping-mia.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-WORLD-OMW-01** — Qualifier et rendre la définition de monde ping-omw. | Intégrer les champs bruts de ping-omw.troybin, textures et modèle éventuel au vrai consommateur de particules ; qualifier placement, durée, couches et retrait sans assimiler classification à simulation/rendu complet. | Définition v2 et références disponibles ; sélection native et contrat d’exécution de cette définition. Dépendances : PVAR-SELECTOR-01, PVAR-RESOURCE-01 ; réutiliser le moteur de particules existant après inspection. |
| **PVAR-AUDIO-IDENTITY-01** — Identifier les événements et médias réellement utilisés par les variantes de ping. | Relier les appels/IDs natifs à leurs banques/actions/sons/médias ; distinguer sons communs, variantes et absence sonore explicite ; créer un contrôle nominatif par cas réellement identifié. | Appel natif nommé ou capture audio/événement identifiée ; banques HUD candidates disponibles mais leurs59IDs ne sont pas des noms de ping. Dépendances : PVAR-SELECTOR-01 ; ne pas choisir arbitrairement un événement ou un média DIDX. |
| **PVAR-AUDIO-VOICE-01** — Raccorder les événements de ping qualifiés au lecteur audio actuel. | Utiliser les graphes/médias identifiés avec admission, durée, gain et arrêt propres ; aucun son arbitraire, aucun pending/PCM épuisé appelé écoute matérielle ; qualifier échec/doublon/fin de session. | PVAR-AUDIO-IDENTITY-01 terminé et un cas sonore identifié ; réutiliser le backend/transport PCM existant. Dépendances : SYS-16.4-03 pour PingsVolume ; SYS-16.4-04 pour perte périphérique ; réception de ping SYS-17.2-03. |
| **PVAR-PRESENTATION-LIFECYCLE-01** — Borner la durée et la propriété des présentations de ping reçues. | Créer/mettre à jour/retirer visuel et son pour un événement admis selon contrat d’identité/équipe/époque, déduplication et expiration ; aucun ancien ping rejoué à la reconnexion. | Contrat de livraison et événement accepté SYS-17.2-03 ; sélections et durées qualifiées. Dépendances : PVAR-SELECTOR-01 ; PING-POS-DELIVERY-01 ; ressources/profils/voix correspondants. |
| **PVAR-HUD-BUTTON-STATES-01** — Relier les trois états du bouton de ping de la minimap. | Consommer PingHover/PingClicked/PingOverlay sur le bon layout avec input et annulation réels ; conserver Enabled=0 par défaut hors contexte et comparer rectangles/UV/couleur. | Trois records deslayouts ShadowIsles gauche/droite et callback natif ou contrat local explicitement déclaré. Dépendances : Sources HUD atlas déjà présentes ; SYS-17.2-03 pour geste ; pas de confusion bouton avec les12PingType. |
| **PVAR-END-TO-END-01** — Comparer le rendu et le son des variantes identifiées sur un parcours local réel. | Exécuter les profils/événements effectivement qualifiés avec clients/serveur/assets identifiés ; comparer visuel et audio séparément, refus/volumes/sessions inclus ; chaque variante conserve son résultat propre. | Sélecteurs, ressources, profils de minimap/monde et audio terminés et vérifiés ; référence native comparable ou limites nommées. Dépendances : SYS-17.2-03, PVAR-SELECTOR-01 et fiches nominatives concernées ; aucun succès global depuis un cas isolé. |

Les preuves attendues détaillées sont conservées par ID dans `proposed_corrections` du reçu : comparaison par profil/définition, refus, retrait et source précise. Le contrat audio exige d’abord l’identité des cas réellement sonores ; on ne crée pas douze copies de sons arbitraires sur la base de douze indices graphiques. Après identification, chaque cas sonore garde un contrôle nominatif et un résultat propre. Les différences de modes, d’équipe, de locale et de destinataires ne sont pas déclarées identiques par défaut.

## R6 — Réutilisation et décision séparée

- **SYS-17.2-03 / PING-POS-*** : entrée, message, admission, rafales et livraison déjà découpés ; pas de duplication de ce travail.
- **SYS-16.4-03** : volumes par catégorie, dont PingsVolume ; une constante ou un Game.cfg chargé ne vaut pas gain appliqué.
- **SYS-16.4-04** : sortie/perte de périphérique, conservée comme tâche distincte.
- **MM-PROJECTION-01** : projection/contrôleur historique de minimap ; pas de nouvelle inversion arbitraire.

| Dimension | Résultat du lot |
|---|---|
| Audit | Sources, consommateurs/absence, limites et reprises documentés ; clôture de SYS-17.2-04 limitée à l’audit après relecture indépendante réussie. |
| Implémentation | Présentation de variantes de ping absente du chemin courant identifié ; ressources et sous-systèmes génériques déjà présents conservés. |
| Vérification | Contrôles documentaires et de données réussis ; aucune variante visible/audible courante vérifiée. |
| Acceptation humaine | Aucune acceptation de fonctionnalité revendiquée. |

Restent ouverts la tâche, l’inconnue d’origine, les 28 propositions et les contrats historiques non qualifiés. Ni la présence de fichiers ni les 206 contrôles ne terminent le jeu. Le reçu principal garde `audit_scope_closed=false` ; le reçu indépendant peut fermer les sept rubriques de ce lot, sans éditer le goal ni les statuts du plan. Le goal global demeure actif/incomplet.

## R7 — Livrables et conservation

Nouveaux fichiers uniquement : `audit-unit.json`, `verify_variants.py`, `ping-variants-proof.json`, `verify_delivery.py`, `delivery-readback.json` dans `F:/OpenLeague-work/audit-units/AUD-17.2-04-PING-VARIANTS-01/`, et ce rapport dans `F:/OpenLeague/docs/audit/units/`.

Reçu principal SHA-256 **4aae17167d07cdbb78f413d4fc5b6c1df84f6897e3183144d4e8434f3e9b9702** ; contrôles exécutés à **2026-10-30T21:42:48.355533+00:00**. Le reçu inclut les sources exactes, lignes, champs, ressources, hashes, résultats, recherches limitées et propositions. Aucun ancien reçu remplacé.

Les **19 fichiers logiciels gelés**, les **six documents de contexte/méthode**, les **cinq registres normatifs**, HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, branche main et les 76 fichiers suivis déjà modifiés restent identiques. Aucun logiciel installé, aucune migration ni modification de critères, aucune base ouverte, aucun service Plan ou jeu démarré. Les 6 554 ressources locales sont lues comme inventaire de noms, sans copie/conversion/installation d’assets.

Relecture reproductible si un changement identifié le justifie : Python existant, options `-X utf8 -E -B`, lecteur `verify_delivery.py --check-only` sans écriture. Le producteur utilise une création exclusive et ne doit pas être relancé contre son reçu existant. Reprise fonctionnelle sur une fiche précise et son entrée, sans recherche inchangée en boucle. Prochain lot d’audit du même ensemble : **SYS-17.2-05**, notifications d’objectifs et d’éliminations ; préserver les limites de l’ancien résumé terminal.
