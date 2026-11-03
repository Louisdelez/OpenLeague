# SYS-01.2-02 — Disponibilité audio des passifs, V670

Date UTC : 2026-10-27T10:14:05.109682+00:00. Projet : F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW / en_GB ; catalogue 4.20.1 distinct. Le build littéral 2014-11-17 17:46:45 ne qualifie ni fuseau ni déploiement.

## Résultat intégré

Les 122 fiches AUDIO de passif et SYS-01.2-02 reçoivent leurs preuves, limites et instructions restantes dans le registre et les deux bases du plan. 244 liens vers les banques natives sont ajoutés. Aucun consommateur de jeu n'est ajouté : cette enquête établit la disponibilité des ressources et précise les associations encore inconnues.

Les 42 215 exigences restent présentes. Le registre compte 99373 sources et 5 605 consommateurs ; ces nombres ne sont pas un pourcentage de jeu terminé. Aucune case, note, dépendance, critère ou inconnue existante n'est modifié. Aucune validation de passif ou du jeu complet.

## Sources disponibles

- Les 244 banques SFX de base des 122 champions sont présentes, lisibles et conformes aux manifestes sélectionnés. Les 633 fichiers natifs utilisés dans l'audit correspondent à ces manifestes.
- Le lecteur borné v88 relève 4 455 occurrences d'événements et 8 243 entrées de médias intégrés. Ces nombres couvrent les banques de base, pas seulement les passifs et pas nécessairement des identifiants globalement uniques.
- Le parseur tiers wwiser recoupe indépendamment les 4 455 occurrences dans 124 banques contenant des événements. Les 75 338 champs d'identifiants de dépendance sont comparés aux octets natifs. Aucun message d'erreur ni champ ignoré recensé par ce parseur.
- Les champs SoundOnCreate/SoundPersistent des 15 particules précédemment sélectionnées ne fournissent pas le lien recherché. Aucune référence d'événement Play_/Stop_ ni globale audio/sound n'est relevée dans les champs et initialisations racines sélectionnés. Ce périmètre limité ne démontre pas qu'un passif est silencieux.

## Ce qui manque ou reste non qualifié

1. **L'affectation à chaque passif.** Il faut identifier l'événement exact et les conditions natives. Les banques de champion ne suffisent pas à attribuer un son à une capacité.
2. **Le chemin jusqu'au jeu courant.** Les modules audio Q/E/R d'Ezreal et le transport PCM générique sont inspectés, sans être promus en consommateurs de passif. Le code visuel Annie ready ne prouve pas de lecture audio. Le scan ne prétend pas démontrer l'absence totale d'un déclenchement dynamique.
3. **Les dépendances externes.** Parmi 16 IDs médias hors des paires de base, 12 sont retrouvés dans MISC_Global_SFX_audio. Les quatre IDs Malzahar **35244919, 440349231, 472550424, 1058542249** restent sans candidat dans les 594 index de banques SFX et les noms numériques de WEM examinés. D'autres containers ou contextes restent possibles ;aucune reconstruction ne découle automatiquement de cette recherche.
4. **Les priorités.** Trois nœuds externes Ezreal existent dans MISC_Global_SFX_events. Le nœud Zyra 698313483 existe dans Skin01 ;cela ne démontre pas qu'il doit être choisi pour Base. Tryndamere présente 17 IDs d'événements répétés entre ses banques ;Viktor en présente 7. Les sources sont conservées séparément.
5. **La sélection et l'écoute.** Les actions, switch/RTPC, probabilités, boucles, arrêts, bus, mixage, skins et locales restent à qualifier. Aucun décodage, test sonore en jeu ou écoute n'a été exécuté dans ce lot.

## Contrôles exécutés

Le lecteur passe 10 contrôles dont 8 refus : fichier vide, en-tête tronqué, fin tronquée, chunk dupliqué, version non prise en charge, compte HIRC impossible, objet hors limite, compte d'actions incohérent. Ces mutations de contrôle restent en mémoire et ne modifient pas les ressources natives.

Le premier recoupement échoue parce qu'il fusionnait des IDs de banques distinctes. La variante scoped préserve leur portée par banque et passe. Le premier contrôle des instructions copiées échoue sur l'indentation JSON ;la variante scoped décode le JSON effectivement copié et compare son contenu complet. Les deux scripts et journaux échoués sont conservés.

La première publication échoue avec « No space left on device » pendant la grosse écriture du registre, laissant ce seul fichier vide ;les deux autres documents et les bases sont encore intacts. Le registre est restauré depuis la sauvegarde, avec son SHA antérieur exact. Une deuxième tentative échoue pendant l'écriture d'un fichier temporaire ;les documents canoniques restent intacts et ce préfixe temporaire est conservé sur C avec son empreinte. Six anciennes archives JSON sont ensuite compressées sans perte pour créer une marge suffisante. La reprise finale impose une réserve globale et par document, écrit le candidat inchangé par blocs de64Kio dans un fichier temporaire compressé, vérifie son SHA puis remplace chaque document atomiquement. La publication finale et son audit sont distincts des tentatives échouées. Reçus : FAILED_PUBLICATION_RECOVERY.json, ARCHIVE_LOSSLESS_STORAGE.json, PUBLICATION_ADAPTER_RESERVED.json et PUBLISHED_*.json dans le dossier de livraison.

Le candidat refuse une modification de case, la suppression d'un consommateur et la suppression d'un lien natif. L'inversion du delta restitue les six documents en octets exacts ;l'inversion des mises à jour SQLite restitue l'état logique exact sur copie. La synchronisation normale est idempotente. Pour chaque base publiée : **123 lignes ciblées**, **42 484 autres lignes**, **42 607 états manuels** et **23 entrées d'historique** conservés. Store.task, Store.copy_text, Store.summary et la résolution de trace sont réellement exercés.

| Étape | Code de sortie | SHA-256 du journal |
|---|---:|---|
| V670_AUDIO_AUDIT | 0 | 39360fd9de1802675bee7eea55853d7bcc8d8c3aefa9935442a3d009d38e623d |
| V670_AUDIO_CROSSCHECK | 1 | bec3e0b4caa693dd100e2c3593df962f193da63b67b542a4fec2b384c7c5b7db |
| V670_AUDIO_CROSSCHECK_SCOPED | 0 | 832a2e9e74a3286ea7359fd96e4d2cf15db44dac475a794523619256eaedf34b |
| V670_AUDIO_EXTERNAL | 0 | ae0ef201e264ee632bb0783c08accb825e0ed4f34d00aeb62d9f68f44117b30e |
| V670_AUDIO_PREPARE | 0 | eaa73012c93be374c5298363246058352dd1adbe0e89d49bff932475c1853a16 |
| V670_AUDIO_CHECK | 1 | 5cb3708312d981df2a90eac447efc36a11fc6a24acdb67e644d5c5c00d29348b |
| V670_AUDIO_CHECK_SCOPED | 0 | ce9c23d0560c48f9ea3610f7bb8b9a68d6493bb16c1081321fb460b376eb0fd0 |
| V670_AUDIO_PUBLISH | 1 | 5b61584b598b7a222a9c202c13210da431b80c4c1f51519a8511f25bae80cd6b |
| V670_AUDIO_PUBLISH_STREAMED | 1 | fcd6e70dd47d925a279861f4502ff430a153f942f049aa4bdbe30f11abbb5c71 |
| V670_AUDIO_PUBLISH_RESERVED | 0 | ded040ed0e6d1cd2fb6d5ea1b780769716ad4eb88641ff7602765b54304dcb18 |
| V670_AUDIO_DELIVERY_AUDIT | 0 | a43cebe882755d632084fad3992ff8130cbfe05e53ce0e3add6578105d33a539 |

Les 99 373 sources du registre n'ont pas toutes été rehachées dans ce lot ;la vérification fraîche porte sur les entrées utilisées. Aucun build du jeu, GPU, serveur historique ou test d'écoute n'est revendiqué.

## Fichiers et sauvegardes

Modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ;123 lignes dans chaque base du plan ;couverture, plan, reprise et notes courtes. Ajoutés : ce rapport, docs/fidelity_passive_audio_availability_v670.json et docs/reference_requirement_trace_sources/passive-audio-availability-v670.json.

Les observations, lecteurs, graphes compressés et journaux sont conservés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20, dans les dossiers revision670_passive_audio_audit, revision670_audio_bank_crosscheck_scoped, revision670_audio_external_candidates et revision670_audio_delivery. Le dossier de la première tentative de recoupement reste conservé.

F étant presque plein, trois fichiers JSON de preuves, les trois documents JSON canoniques, cinq autres JSON de suivi et six anciennes archives JSON ont été compressés sans perte par NTFS. Leurs SHA-256 avant/après sont identiques ;aucune preuve supprimée. Les reçus revision670_audio_lossless_storage.json, revision670_canonical_lossless_storage.json, ADDITIONAL_LOSSLESS_STORAGE.json et ARCHIVE_LOSSLESS_STORAGE.json détaillent ces opérations. Les copies de validation temporaires sont sur C ;les preuves durables et le delta réversible sont sur F. Les sauvegardes antérieures restent intactes.

## Prochaine étape

Continuer SYS-01.2-02 sur F:/OpenLeague. V670 est publié et audité dans les122fiches AUDIO de passif et SYS. Les244banques de base existent,633sources natives relues correspondent aux manifestes.4455occurrences événementielles et75338champs ID recoupés avec wwiser, sans erreurs ni skips. La liaison passif→événement→consommateur précis reste ouverte pour122fiches ;aucun consommateur générique ajouté pour gonfler la couverture. Suite concrète : identifier les noms/conditions de déclenchement à partir des métadonnées natives, scripts client/communautaires et ressources de particules au-delà des15candidats déjà sélectionnés, en séparant preuve native et hypothèse lexicale. Examiner Malzahar : IDs35244919,440349231,472550424,1058542249 sans candidat dans594banques SFX et nomsWEM numériques ;vérifier portée, scripts et éventuels flux/containers avant de conclure à des assets manquants. MISC_Global fournit12médias externes et3nœuds Ezreal ;le nœud Zyra698313483 se trouve dans Skin01, ce qui ne prouve pas un fallback Base. Conserver les17IDs Tryndamere et7IDs Viktor répétés entre banques ;priorité historique non qualifiée. Ne pas assimiler les sonsQ/E/R à un passif. Pas de nouvelle écoute/lecture en jeu. Préserver les cases,notes,inconnues et preuves antérieures ;goal actif.
