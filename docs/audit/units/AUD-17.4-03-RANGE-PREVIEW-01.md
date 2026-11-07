# AUD-17.4-03-RANGE-PREVIEW-01 — Aperçus de portée

Date UTC : 2026-10-31T01:22:36.594283+00:00 ; SYS-17.4-03 ; OLF-dfcf608b-5420-5a99-9456-47574b64d7f5 ; inconnue OLU-31cba424-0e7b-5bd2-8c1d-663b9e05da34.

## R1 — Périmètre

Audit du parent entier « Afficher les indicateurs de portée avant confirmation » : sources/formes, aperçu local, confirmation/annulation, géométrie/texture/lifetime, refus et couverture par capacité. Audit clôturable après relecture ; implémentation partielle, vérification héritée/partielle, acceptation humaine non donnée. Aucun critère normatif modifié. D17-SYS-17-4 requiert D09-SYS-09-4 encore a_faire ; autres parents/modes/ciblage restent distincts.

## R2 — Sources historiques et ressources

Référence PUBLIC4.20.0.315 EUW/en_GB, build2014-11-17 17:46:45 sans fuseau/déploiement établi, catalogue4.20.1 distinct. Les488INIBIN distincts des122champions/quatre slots sont lus avec les seules fonctions pures hash/decode du lecteur de comparaison INIBIN v2. Zéro fichier manquant et zéro erreur de décodage. Sur41champs potentiels par slot, une frontière de précision quantifiée apparaît pour VarusQ/CastRangeGrowthDuration ; tous les autres champs comparés concordent avec native_spells_420.json. Il s’agit de comparaison statique, pas du loader natif exécuté.

VarusQ : le champ est codé type2/octet13 à offset91. Le lecteur de comparaison v*.1 en précision Python donne un cast binary32 0x3fa66666 ; le catalogue1.30000007 donne0x3fa66667. Un calcul float32(13)*float32(.1) reproduit ce second résultat, sans prouver l’opération du getter natif. Ce n’est pas une corruption démontrée ; la conversion/arrondi reste ouverte et ajoutée précisément au profil PREVIEW-PROFILE-varus-0. Aucun chiffre de données produit modifié.

Matrice complète : F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\native-range-matrix.json SHA-256 2a2ca68ab5f169dbdba577101c07e326675af7f071c5eb62bf3749a2080128ed. Chaque ligne conserve source/hash, champs présents/absents, catalogue comparé et ID de correction par capacité. Les13appartenances précises au manifeste de targeting-links sont réutilisées ; aucune nouvelle qualification de manifeste sur488fichiers ou priorité historique effective prétendue.

Champs présents : TargettingType488, CastRange486, CastRangeDisplayOverride453, RangeIndicatorTextureName247. CastRange non déclaré pour LissandraR et ZedShadowDash (ZedW) ; conserver repli/contrôleur inconnu, ne pas remplacer par zéro.167overrides non nuls vérifiés ; la matrice garde les valeurs issues du lecteur et la limite de précision ci-dessus. Les noms non vides de texture comptent242DefaultRangeIndicator.dds,1DirectionalCircle.dds,1skillshot_AOE_hecarim.dds,1blank.dds ; champ vide distinct de ressource absente.

Exemples qui interdisent une formule universelle : EzrealQ source CastRange10000/display1150/LineWidth80 ; moteur actuel range1200/radius60 explicitement local/communautaire. AnnieW source range625/angle24.7600002, consommé comme half_angle dans la reconstruction ; sens historique d’angle non qualifié. AnnieR portée600 et rayon250.300003, GarenE portée660/display325/rayon35 : rayon de zone, portée dessin et portée projectile sont distincts.

Textures natives vérifiées dans D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\Textures.zip SHA-256 a5a12516b13b28777bb920dd7637320274a2ab295404c2ba4aaf79d86bbea75e et copie locale exacte :

- Textures/CircularRangeIndicator.dds ; 1048704octets ; SHA-256 668abf43ad171369fa54c5ba60fcb7f2c32550197bd95c686cb2aa1f8d26cc86.

- Textures/CircularRangeIndicator_Dark.dds ; 699192octets ; SHA-256 573b333402c62e7398ff1b4e30d045ef480fc55874c7e78fd5d1182479dff9c6.

- Textures/ConicRangeIndicator.dds ; 262272octets ; SHA-256 93d8b5c34e5ea559097d758718e6d12e6144dc7f5c00036e12d7b459a9773460.

- Textures/LineRangeIndicator.dds ; 349680octets ; SHA-256 d10c8078d61c5d35d6cce32b7c9e7aacb38d4afe534e5cb671b11be441f05620.

- Textures/MinimapCircularRangeIndicator.dds ; 87536octets ; SHA-256 ac2f324a468eaf2d5241e3a235bf374e0a4aaee62414d665ed255a3704b785ce.

- Textures/SemicircleRangeIndicator.dds ; 1048704octets ; SHA-256 0fd4e98f8a34dc98e641c73fff565180b0daf9676e59c38da14944dc39611442.

- Textures/TEMP_CircularRangeIndicatorDirectional.dds ; 1398256octets ; SHA-256 a051fef05079e35da70983cbdbe8059cdfce4fb94ee5ec89f8f18d5f080690b3.

Les sept DDS sont conformes au contrat natif de payload. Trois PNG de lecture sans retouche conservent exactement le RGBA du premier mip. Native resource catalogue retrouve CircularRangeIndicator ; le mapping spécifique DefaultRangeIndicator n’est pas établi par ces sources nommées (catalogue partagé, ZIP ciblé et chemin loose ciblé). Cela ne prouve pas une absence globale ; ne pas substituer CircularRangeIndicator sans contrat d’alias/fallback.

- Relu avec view_image : F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\native-textures\CircularRangeIndicator.png ; Anneau cyan lumineux avec intérieur sombre. SHA-256 77c5fe9b500c6c7a3391bb904f1b00662496d55c85814102b749af133d6a05e3. Pixels de ressource seulement, pas géométrie/scale/temps du jeu.

- Relu avec view_image : F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\native-textures\ConicRangeIndicator.png ; Secteur conique cyan avec bord orné et symbole à la pointe. SHA-256 95d649956e712d751932bfa20b6966a7be2f8aa996df3c091217dd97faada816. Pixels de ressource seulement, pas géométrie/scale/temps du jeu.

- Relu avec view_image : F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\native-textures\LineRangeIndicator.png ; Bande rectangulaire cyan sombre avec bord orné. SHA-256 c2acd86abd9e36d40aecdbea27d5f88283070c31d44757e178c99955f0b07712. Pixels de ressource seulement, pas géométrie/scale/temps du jeu.

## R3 — Consommateurs réels

Corpus1168fichiers inchangé. Main choisit la touche, lit curseur/ray puis produit Cast/CastAt et send_action ; Shortcuts expose slot/learn, sans état d’aperçu pending. ground_target est un routeur par champion/slot, pas un indicateur. Les retours si curseur/caméra/ray indisponibles et gates shop/fin/ready sont conservés.

L’unique correspondance du champ CastRangeDisplayOverride dans le code précis est ezreal_e.rs validant BLINK_RANGE : vrai consumer de gameplay, pas renderer d’aperçu. Ne pas déclarer ce champ inutilisé globalement. Recherche bornée RangeIndicator|CastRangeDisplayOverride|\btargeting_preview\b|\baim_preview\b|\bpending_aim\b|\bpreview_target\b dans1168sources Rust/JS/HTML, puis inspection des véritables consumers.

Le rendu projeté actuel existe : projected_live::update est branché après annie_q_vfx::update et suit Flights.projection_frames issu de missile_journal. Ezreal R suit r_samples_3d autorisés et FoW courant. Ce sont des effets après lancement. Certains anciens rapports « pas de live emitter branché » restent datés et ne décrivent plus le câblage actuel ; ils sont conservés, pas réécrits. Ni ces effets ni leurs tests ne qualifient une portée avant confirmation.

- F:\OpenLeague\crates\client\src\spell_input.rs:1 — fixed key intent lacks pending preview state ; SHA-256 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf.

- F:\OpenLeague\crates\client\src\main.rs:1366 — input command and resource/focus boundary ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1439 — immediate cursor dispatch and send boundary ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:871 — ordinary Annie projected update wiring ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\projected_live.rs:158 — ordinary Annie projectile projection ; SHA-256 18abd01c488019d106e5335b57f38c0a4a6d2f23826acd2ab917e6582eb77fcf.

- F:\OpenLeague\crates\client\src\annie_q_vfx.rs:363 — Annie owner journal producer ; SHA-256 f6731218c244ede991d65657f0120ceaf4bdb113733fc6cfc568aea8ade9d8b4.

- F:\OpenLeague\crates\client\src\ezreal_r_projected_live.rs:164 — ordinary Ezreal R sample projection ; SHA-256 49e279a029c0e48af36a0ee3448440750b1b41105720ca7f7977461abdf6bdbc.

- F:\OpenLeague\crates\client\src\ezreal_r_passive_presentation.rs:244 — R sample state independent of aim ; SHA-256 2cc35d5ad565f11939b7eef40b1f7d2397936d852202be9bf5c19fc055e5decc.

- F:\OpenLeague\crates\core\src\ezreal_e.rs:74 — existing display range gameplay consumer ; SHA-256 b1ca5f9f517a60be0c74abd332182294df7f466b211f5ee6f40485100d671c73.

- F:\OpenLeague\crates\core\src\ezreal_q.rs:1 — current Q geometry policy ; SHA-256 5181ae36f00db4991dff6495d8c594a079c95e760c7072f3cb241888e131ed8c.

## R4 — Attendu, observé et vérifications

20tests CPU réussis réutilisés : onze de lifetime/ownership Annie projected, huit de host/profil/geometry/FoW EzrealR projected et un de ground routing. Sept fichiers sources correspondent au manifeste du run avancé, journal terminal code0. Ce ne sont ni20tests de preview ni une qualification GPU/OS actuelle.

- ezreal_r_projected_live::tests::current_xyz_enters_native_height_shader_input_without_ground_or_actor_lookup : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::projected_profile_matches_original_group2_offsets_and_exact_texture_names : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::same_batch_y_gap_incarnation_change_rebuilds_and_updates_only_owned_inputs : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::uniform_xyz_change_reuses_geometry_but_replaces_exact_material_inputs : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::host_spawns_unique_no_batch_draws_and_preserves_foreign_materials_on_loss : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::missing_no_batch_duplicate_identity_and_revision_overflow_revoke_all_owned_draws : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::geometry_transform_or_removal_rebuilds_or_withholds_the_projected_draw : attendu ok, observé ok (hérité, non rejoué).

- ezreal_r_projected_live::tests::paused_xyz_keeps_provenance_but_reauthorizes_under_current_fow_and_then_retires : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::batched_removal_waits_for_all_particle_frames_and_preserves_last_pose : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::minimized_view_preserves_hidden_clock_but_consumes_owner_end : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::initialization_clock_matches_native_deferred_reset : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::native_owner_loss_bridge_matches_fifteen_original_frames_and_defers_cleanup : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::native_visibility_activation_bridge_matches48_original_sequences : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::native_pose_bridge_matches45_live_original_factory_provider_profiles : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::normal_adapter_follows_native_frames_and_owner_end_without_nonfinite_geometry : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::released_draw_removes_entity_and_both_owned_assets : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::native_owner_scale_reader_and_simple_child_match_ten_original_profiles : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::normal_lifetime_camera_exit_reentry_suspends_and_reuses_particles : attendu ok, observé ok (hérité, non rejoué).

- spell_input::tests::only_supported_ground_slots_route_to_position_command : attendu ok, observé ok (hérité, non rejoué).

- projected_live::tests::finished_resource_rejects_live_owner_before_pose_update : attendu ok, observé ok (hérité, non rejoué).

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire de test enregistré {'path': 'E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe', 'sha256': 'e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd', 'bytes': 350254080}.

### P1 — Sources complètes du catalogue

Attendu : Relier chaque capacité recensée à ses champs natifs réels, sans inventer les absents.

Observé : 488INIBIN distincts lus, zéro manque/erreur ; une frontière de précision de décodage quantifié sur VarusQ CastRangeGrowthDuration, autres champs comparés concordants. CastRange absent pour LissandraR/ZedW.

Limite : Identité de fichiers fournis, pas488priorités provider ou décisions d’affichage validées ; conversion native du champ Varus non exécutée.

### P2 — Portée de dessin contre gameplay

Attendu : Séparer portée affichée, rayon de zone, angle/largeur et distance de projectile.

Observé : EzrealQ CastRange10000/display1150/LineWidth80 contre politique actuelle range1200/radius60 ; AnnieW range625/angle24.7600002.

Limite : Aucune formule universelle de preview, demi-angle/diamètre ou correction du gameplay inférée.

### P3 — Textures et alias

Attendu : Réutiliser sources valides et qualifier texture réellement résolue.

Observé : Sept DDS conformes au contrat/archive ; trois PNG sans retouche relus, pixels base-mip égaux. DefaultRangeIndicator cité242fois nonempty, mapping non qualifié.

Limite : Absence dans ces catalogues/zip ne prouve pas absence globale; aucun remplacement silencieux par CircularRangeIndicator.

### P4 — Aperçu avant confirmation

Attendu : Intention locale produit un visuel sans envoyer l’action puis confirme/annule selon mode.

Observé : Main sélectionne une touche et envoie Cast/CastAt directement après curseur/ray. Shortcuts expose slot/learn, aucun état pending preview identifié.

Limite : Pas de parcours de confirmation/annulation ni capture GUI d’aperçu courant.

### P5 — Préserver les projections existantes

Attendu : Ne pas déclarer le moteur projeté absent ni l’assimiler à l’aperçu.

Observé : AnnieQ suit missile_journal/projection_frames; EzrealR suit échantillonsR3d et FoW courant. Main branche effectivement ces consumers.

Limite : Effets après lancement et tests de rendu/ownership ne prouvent pas portée avant confirmation ; vieux rapports non branchés restent datés.

### P6 — Consumer scalaire existant

Attendu : Préserver l’usage actuel d’un champ de portée sans l’appeler renderer.

Observé : Recherche précise1168sources trouve CastRangeDisplayOverride dans ezreal_e.rs, validation de BLINK_RANGE.

Limite : Ce consumer gameplay n’est pas un aperçu ni une preuve de résolution texture/forme.

### P7 — Refus et durée de vie

Attendu : Pas de visuel/envoi périmé après focus, mort, fin, cible/terrain/caméra/ressource invalides.

Observé : Gates de commands et retours sans curseur/ray présents; effets projetés savent retirer leurs ressources après perte/fin et ont tests hérités.

Limite : Aucun état d’aperçu actuel pour démontrer ces refus de bout en bout; tests composants limités.

### P8 — Couverture par capacité

Attendu : Découper la qualification par capacité et décider non applicable sur preuve.

Observé : Matrice488profils avec identifiant stable et source/champs propres; gabarit de correction commun explicite.

Limite : 488profils proposés ne sont pas488aperçus implémentés; TargettingType seul ne décide pas l’applicabilité.

229 contrôles documentaires producteur réussis. Nouvelles opérations : lecture488INIBIN, comparaison des champs, lecture7DDS et export/inspection3PNG. Non exécutés maintenant : tests Rust, jeu, REA, binaire original, GPU, réseau, SQL, clavier physique ou nouveau parcours d’aperçu. Une texture valide ne prouve pas affichage avant confirmation.

## R5 — Écarts et conditions de reprise

Restent ouverts : contrôleur de visée historique et applicabilité de chaque type/profil, alias/fallback DefaultRangeIndicator, valeurs manquantes/getter, conversion quantifiée de VarusQ, forme/angle/largeur/portée effectifs, intention locale, confirmation/annulation et refus/teardown de preview. L’inconnue OLU-31cba424-0e7b-5bd2-8c1d-663b9e05da34 reste open. Entrée native requise : getter/caller/trace de TargettingType, CastRangeDisplayOverride et RangeIndicatorTextureName dans le targeter actif, et getter type2 pour Varus ; aucun nouveau scan aveugle des488fichiers déjà vérifiés.

## R6 — Corrections et découpage

Aucun écart fonctionnel corrigé. Trois fiches de mode réutilisées (définitions conservées dans le reçu02) :

- CAST-MODE-MODEL-01 — Reuse cast mode/release policy and editor transaction; preview owns visual intent before confirmation and must not be counted as server cast or post-cast projectile VFX.

- CAST-MODE-ABILITY-01 — Reuse cast mode/release policy and editor transaction; preview owns visual intent before confirmation and must not be counted as server cast or post-cast projectile VFX.

- CAST-MODE-RELEASE-01 — Reuse cast mode/release policy and editor transaction; preview owns visual intent before confirmation and must not be counted as server cast or post-cast projectile VFX.

Six travaux transversaux proposés :

### PREVIEW-INTENT-01 — Créer un état de visée locale distinct d’un sort lancé.

Tâches existantes : SYS-17.4-02, SYS-17.4-04.

Travail : Lier session/joueur/capacité/mode/cible/curseur à une intention avant envoi; définir entrée/sortie et resélection. ; Conserver apprentissage, inventaire et gates existants; le serveur ne reçoit aucune commande avant confirmation prévue.

Critères de fin : État observable avant send_action; aucune mutation gameplay, double cast ou intention d’une autre session. ; Annulation, changement de slot, mort/contrôle/fin/focus ou perte ressource effacent état et visuel.

Condition de reprise : Autorisation produit distincte, politique normal/rapide et identité locale prêtes.

Dépendances : CAST-MODE-MODEL-01 ; SYS-17.4-08. État proposed_not_applied.

### PREVIEW-RESOURCE-01 — Résoudre les textures et profils d’indicateurs sans alias inventé.

Tâches existantes : SYS-17.4-03.

Travail : Réutiliser les sept DDS valides; identifier résolution DefaultRangeIndicator/alternatives/fallback plutôt que substituer au hasard. ; Relier chaque profil applicable au provider/membre/texture et au matériau approprié, erreurs visibles pour ressource non résolue.

Critères de fin : Sources et résultat effectif comparés; native DDS/cache/PNG cohérents; aucun placeholder qualifié complet. ; Alias/fallback et texture manquante refusés ou indisponibles explicitement jusqu’à preuve.

Condition de reprise : Autorisation produit; pour DefaultRangeIndicator, nouveau caller/provider/alias exact dans le client original ou contrat local marqué.

Dépendances : PREVIEW-NATIVE-CONTROLLER-01. État proposed_not_applied.

### PREVIEW-SURFACE-01 — Projeter un aperçu local sur les surfaces autorisées.

Tâches existantes : SYS-09.4-07, SYS-22.3-05.

Travail : Réutiliser terrain/ray/caméra existants; qualifier unités, hauteur, origine/orientation, cercle/cône/ligne et clipping. ; Conserver rendu de projectile séparé; traiter surfaces manquantes, redimensionnement et caméra invalide sans géométrie non finie.

Critères de fin : Géométrie attendue/observée sur voies/base/jungle/paliers applicables, avant confirmation; rotation/portée respectent profil. ; Ressources propres libérées, pas de retrait de matériaux étrangers, aucun effet de projectile simulé pour représenter une intention.

Condition de reprise : Autorisation produit, profil applicable et ressource résolue, terrain restauré identifié.

Dépendances : PREVIEW-INTENT-01 ; PREVIEW-RESOURCE-01. État proposed_not_applied.

### PREVIEW-CONFIRM-CANCEL-01 — Confirmer ou annuler un aperçu sans commande concurrente.

Tâches existantes : SYS-17.4-02, SYS-17.4-04, SYS-17.4-08.

Travail : Définir clic/appui/relâchement selon mode qualifié; clic d’annulation ne lance pas accidentellement Move/Attack/Cast. ; Revalider l’action au moment de confirmation, retirer l’aperçu une seule fois et laisser le serveur autoritaire.

Critères de fin : Une confirmation émet une action correcte; annulation/perte focus/zéro cible n’en émet aucune selon contrat. ; Pas de double envoi sur repeat/réponse ancienne/changement session; teardown attendu/observé.

Condition de reprise : Autorisation produit et intention/modes existants; tests injectés distincts du vrai parcours clavier/GUI.

Dépendances : PREVIEW-INTENT-01 ; CAST-MODE-ABILITY-01 ; CAST-MODE-RELEASE-01. État proposed_not_applied.

### PREVIEW-NATIVE-CONTROLLER-01 — Qualifier le contrôleur historique de forme/portée et ses règles d’affichage.

Tâches existantes : SYS-04.6-03, SYS-04.6-04, SYS-04.6-05, SYS-04.6-06.

Travail : Suivre getters/callers natifs TargettingType, CastRangeDisplayOverride, RangeIndicatorTextureName et transitions de confirmation. ; Qualifier rôle de CastRadius/LineWidth/angle, bornes/override/missing, résolution DefaultRangeIndicator; ne pas imposer collisions serveur à un dessin.

Critères de fin : Applicabilité et formes documentées sur preuve; absence de champ conservée inconnue avec repli natif nommé. ; Aucune parité historique déduite du seul type numérique, fichier DDS ou helper local.

Condition de reprise : Nouvelle trace originale ou analyse REA ciblée sur getter/caller nommé ; tous488fichiers et sept DDS sont déjà identifiés, ne pas les rechercher à nouveau.

Dépendances : Nouvelle entrée native discriminante. État proposed_not_applied.

### PREVIEW-QUALIFICATION-01 — Qualifier un vrai parcours aperçu→confirmation/annulation.

Tâches existantes : SYS-17.4-03, SYS-22.3-05.

Travail : Identifier binaires/source/assets; capturer aperçu avant action puis résultat de confirmation et d’annulation. ; Contrôler sortie de portée, cible absente, ressources/caméra/focus/session invalides; réutiliser preuves des composants sans les promouvoir en GUI.

Critères de fin : Captures réelles et chronologie montrent zéro envoi avant confirmation et une seule action attendue ensuite; annulation laisse serveur inchangé. ; Nettoyage visuel/ressources vérifié; périmètre par capacité et géométrie annoncé, pas122champions complets à partir d’un exemple.

Condition de reprise : Autorisation produit et profils/contrôleur local/surface/confirmation disponibles.

Dépendances : PREVIEW-INTENT-01 ; PREVIEW-SURFACE-01 ; PREVIEW-CONFIRM-CANCEL-01. État proposed_not_applied.

Découpage par capacité :488IDs uniques PREVIEW-PROFILE-<champion>-<slot> sont dans native-range-matrix.json, avec source et données propres. Exemple PREVIEW-PROFILE-ezreal-0, PREVIEW-PROFILE-annie-1, PREVIEW-PROFILE-lissandra-3 et PREVIEW-PROFILE-zed-1. Le gabarit per_ability_profile_template précise travail, critères, reprise et dépendances ; chaque profil doit décider applicable/non applicable sur preuve avant d’implémenter un indicateur. Aucun type numérique seul ne décide cette applicabilité ; aucune case du Plan créée.

Critères communs des profils : Décision applicable/non applicable justifiée par source exacte et comparée au comportement attendu/observé. ; Si applicable, aperçu visible avant émission de commande, bonne géométrie/ressource et retrait à confirmation, annulation, focus/session/perte capacité. ; Cas hors portée, cible absente, ressource manquante et valeur non qualifiée refusés ou explicitement indisponibles ; aucune réussite globale tirée de la seule texture.. Reprise : Autorisation produit distincte, PREVIEW-INTENT-01 et PREVIEW-RESOURCE-01 disponibles, source de cette capacité identifiée ; en cas de donnée native manquante, nouveau getter/provider ou trace originale nommée.

Tâches inspectées, états conservés :

- SYS-17.4-01 / OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a — Persister les raccourcis de capacités et d’objets ; a_faire.

- SYS-17.4-02 / OLF-4e001528-e50b-579e-ae58-e6eb088040f5 — Persister les modes de lancement normal et rapide ; a_faire.

- SYS-17.4-04 / OLF-7d5673b3-8e78-5446-831f-05ffd51d5849 — Gérer le lancement sur soi et les modificateurs de ciblage ; a_faire.

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat ; a_faire.

- SYS-04.6-03 / OLF-df17c475-1eca-5da9-9a47-424c7ac7e7bd — Résoudre les intersections des zones circulaires ; a_faire.

- SYS-04.6-04 / OLF-4fde7c95-dccc-5061-a7dd-6f2f9db9da15 — Résoudre les intersections des cônes ; a_faire.

- SYS-04.6-05 / OLF-489929d9-74fa-5dd0-b8f5-fedd55ee018c — Résoudre les intersections des lignes et projectiles ; a_faire.

- SYS-04.6-06 / OLF-496b5905-419f-5232-97ff-2d4df6221f41 — Appliquer les limites de portée au lancement ; a_faire.

- SYS-09.4-07 / OLF-2fce7673-9d42-5799-833b-f72e89a9071a — Tester les commandes dans les bases, voies, jungle et passages étroits ; a_faire.

- SYS-22.3-05 / OLF-ef132142-cbae-5804-af6e-26ad2a73320d — Qualifier l’échelle UI et la lisibilité à la résolution minimale ; a_faire.

## R7 — Livraison et conservation

Nouveaux fichiers uniquement dans ce lot : audit-unit.json, native-texture-inspection.json, native-textures/ troisPNG, verify_range_preview.py, native-range-matrix.json, range-preview-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. audit_scope_closed=false dans le producteur, clôture du parent seulement après relecture des sept rubriques.488profils proposés ne sont pas488fonctionnalités terminées.

19fichiers logiciels gelés, six documents de contexte/méthode, cinq registres normatifs et Git suivi vérifiés inchangés. Aucune base ouverte, goal/critère/registre/produit/tracker modifié, installation, migration ou restart. Anciens reçus, échecs et périodes de preuve préservés. Preuve principale F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\range-preview-proof.json SHA-256 8170905f720dc238f004731a7ee836e7089cc640eb739d79f781faad7fcb4e35 ; relecture F:\OpenLeague-work\audit-units\AUD-17.4-03-RANGE-PREVIEW-01\delivery-readback.json.
