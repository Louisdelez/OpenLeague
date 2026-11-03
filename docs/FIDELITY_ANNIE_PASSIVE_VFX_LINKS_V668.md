# SYS-01.2-02 — Passif Annie : sources et consommateurs VFX, V668

Date UTC : 2026-10-27T08:54:10.560883+00:00. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus ; catalogue officiel4.20.1 distinct.

## Résultat intégré

V668 : fiche VFX du passif Annie reliée à 8 ressources natives et 10 points du code actuel (8 implémentations partielles,2 points communs). 98 champs et4 textures RGBA vérifiés ;11 contrôles dont8 refus. ready2 absent du fichier natif, variantes Freljord non rendues, apparence/attaches/audiences historiques non qualifiées. Anciennes captures conservées,aucun nouveau Bevy/GPU ni acceptation du passif.

La fiche CH-Annie-PASSIF-PRESENTATION-VFX et SYS-01.2-02 sont enrichies dans le registre et les deux bases du plan. Les instructions copiables détaillent les sources, le consommateur partiel, les prérequis et les écarts. Le statut a_faire, la question propre et la dépendance CH-Annie-PASSIF-NETWORK sont conservés. Aucun code de jeu ou asset modifié, aucune case cochée.

## Présent et vérifié maintenant

- Trois chunks Pyromania natifs : métadonnées d’initialisation, aucune fonction enfant. Pyromania_particle déclare AutoBuffActivateEffect=StunReady.troy. Cela ne restitue pas le code du serveur Riot.
- StunReady.troybin : 98 champs reliés au contrat embarqué. 22 valeurs textuelles deviennent scalaires/vecteurs par sanitize_str, la conversion réellement utilisée par l’importeur. Les valeurs brutes restent dans l’audit. Les 98 champs sont égaux après cette conversion explicite ; pas de qualification de coercition du moteur historique.
- Quatre DDS et leurs PNG : dimensions et pixels RGBA identiques. Les 8 ressources natives de ce lot correspondent aux manifestes sélectionnés. Le backing historique E des manifestes reste distinct du projet F ; les copies sont identiques et les gardes du lecteur sont conservées.
- Dix points de code : lecture du contrat, sélection Annie vivante avec pyromania>=4, retrait lors du changement de session/perte d’éligibilité, texture de base, création des quads, horloge, transformée et shader ; enregistrement du matériau et ordre d’exécution dans main. Huit sont des implémentations locales partielles, deux des points communs d’intégration. Aucun n’a été exécuté en Bevy dans ce lot.

## Manques et limites précis

| Élément | État observé | Travail restant |
|---|---|---|
| ready2 | Nom déclaré dans System, section absente du fichier natif | Rechercher la définition et la politique de résolution native ; ne pas inventer l’émetteur |
| ready1_frost / ready2_frost | Définitions et textures présentes | Implémenter les variantes, géométrie et sélection Freljord ; vérifier les autres skins |
| Émetteur de base | Reconstruction locale branchée au snapshot | Qualifier naissance/RNG, UV initiales, courbes, échelle, rotation et attache |
| Blend, couleur, profondeur | Shader local et justification communautaire conservés | Comparer au rendu historique4.20 ; ne pas confondre pixels de texture identiques et rendu identique |
| Déclenchement et audience | Sélection locale sur charges du snapshot | Qualifier consommation, mort/réapparition, changement de session/skin, reconnexion, brouillard et visibilité |
| Captures GPU antérieures | Reçus et pièces disponibles relus ; résultats hérités | Refaire la qualification du code courant puis la comparaison au client natif |
| Chemin diagnostic | annie_ready.rs restreint encore la sortie à E:/OpenLeague/logs | Adapter et vérifier séparément avant de lancer ce diagnostic sur F |

Le reçu historique de rendu ne correspond plus aux octets courants d’annie_ready.rs et main.rs ; le shader et le contrat restent identiques à ce reçu. Le manifeste communautaire ReyEngine a également changé ; son ancienne justification est conservée sans nouvelle qualification. Les preuves DX12/Vulkan précédentes portent sur une fixture et des exécutables identifiés à l’époque. Elles ne sont ni effacées, ni présentées comme de nouveaux tests, ni promues en fidélité visuelle native.

## Contrôles exécutés

| Commande | Code | SHA-256 du journal |
|---|---:|---|
| AUDIT_SOURCE_TYPED | 0 | 59365068d521acc43ff0d149a31c57156d62768c4296b1ca4181ac610faa7304 |
| INSPECTION | 0 | 66ab87a05680f877f001eede3d485fa2f0149de7c9d92276ff6280d58148ef2e |
| PREPARE | 0 | 71266bd37742a6bb0bbd52e341480239a25a81186912160c4a3e2c2a9766e011 |
| CHECK | 0 | 8e5b3e26b6fbdc876d0b337f872d43fbb3693d718194b9d24f6923fb3fea5733 |
| PUBLISH | 0 | 82575c2585403b17390d90a1679699089842e255f3c26f52805b4007c2ed98df |
| AUDIT | 0 | 5bf2b94f90055a6e9d45d2adafc901fcba90aa31c0a6496c956427cf5f7935dc |

11 contrôles de source dont8refus : champ modifié, groupe inventé, champ supprimé, identité native fausse, chemin traversant, Troy tronqué, Lua invalide et pixel altéré. Les 20 falsifications d’association et4graphes invalides sont refusés. Les mutations de test sont en mémoire ou dans un dossier temporaire, jamais sur les originaux.

Le premier audit (code1, journal F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision668_AUDIT_SOURCE.log) comparait directement des chaînes natives à leurs nombres convertis. Une nouvelle version utilise le vrai convertisseur, conserve les données brutes et passe. L’ancien script et son échec restent conservés. La préparation rectifie aussi le champ des prérequis : requires_packages contient six prérequis, tandis que depends_on du lot est vide. La dépendance de tâche réseau reste inchangée.

Dans chaque base :2 lignes ciblées vérifiées,42605autres lignes de catalogue,42607états manuels et23historiques identiques. Store.task,copy_text,dépendances,rt.resolve,intégritéSQLite et synchronisation normale idempotente vérifiés. Un fragment de trace change ;42214restent identiques. Identités, hiérarchie et inconnues restent identiques en octets. Aucune question fermée.

La revue globale contrôle les42215exigences et les5600ancres/empreintes de consommateurs : aucun écart. Le graphe contient99358sources ;ce lot ne rehache pas l’intégralité des sources. Les122fiches VFX sont retenues dans le reçu compact, dont121restent dans la file d’examen du loader commun.

## Fichiers et sauvegardes

Modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ;deux lignes dans chaque base ;docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json et notes CURRENT/HANDOFF. Ajoutés : ce rapport, le reçu et la vérificationV668. Les11ressources déjà présentes sur disque mais absentes du registre sont identifiées ;quatre sources de preuve sont ajoutées.

Sauvegardes exactes des deux bases conservées sur F en gzip9, décompression/SHA vérifiés. La base candidate de test est temporaire sur C, vérifiée puis supprimée ;elle se reconstruit à partir de before-project.json, TARGET_ROWS.json et VERSIONS.json via db_update. Les fichiers d’archives identiques regroupés par liens physiques gardent leurs chemins/octets ;ils sont immuables, copier avant toute édition.

Preuve : F:\OpenLeague\docs\fidelity_annie_passive_vfx_links_v668.json. Reçu : F:\OpenLeague\docs\reference_requirement_trace_sources\annie-passive-vfx-links-v668.json. Audit : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision668_annie_passive_vfx_audit_typed\OBSERVATIONS.json. Inspection : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision668_annie_passive_vfx_inspection/OBSERVATIONS.json. Revue globale : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision669_trace_review\REVIEW.json. Les journaux et scripts exacts sont conservés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V668 Annie PASSIF-PRESENTATION-VFX et SYS publiés/audités dans les deux bases ;8sources natives,10consommateurs (8partiels/2frontières),98champs,4textures RGBA exactes. 11contrôles dont8refus,20falsifications et4graphes invalides refusés. ready2 déclaré sans définition dans StunReady.troybin ;Freljord ready1_frost/ready2_frost et textures présents mais non rendus. Déclencheurs,attaches,blend,couleurs,audiences/visibilité et comparaison native ouverts. Les anciennes preuvesGPU sont conservées,non rejouées ;annie_ready.rs/main.rs ont changé. Le diagnostic conserve un chemin E:/OpenLeague/logs,ne pas le lancer surF sans traiter cette limite séparément. Poursuivre les121fiches VFX de passif encore reliées au seul loader commun dans revision668_annie_passive_vfx_delivery/NEXT_PASSIVE_VFX_QUEUE.json ;commencer Ezreal en distinguant icôneHUD et effetsR des VFX propres au passif,puis inspecter les autres métadonnées et consommateurs. Graphe99358sources/5600consommateurs ;5600ancres et SHA courants exacts,aucun écart. IDs/inconnues/hiérarchie/cases/notes/historiques conservés. Sauvegardes exactes des deux bases en gzip9 surF,copie de test surC supprimée après contrôle et reproductible par TARGET_ROWS/VERSIONS. Archives anciennes liées physiquement immuables ;ne jamais éditer en place. Goal actif.
