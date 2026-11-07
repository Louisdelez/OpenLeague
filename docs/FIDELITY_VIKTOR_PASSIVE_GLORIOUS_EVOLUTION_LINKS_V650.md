# SYS-01.2-02 — Viktor / Glorious Evolution, V650

Date UTC 2026-10-27T01:52:51.974355+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V650 Viktor / Glorious Evolution : 37 sources natives, 111 associations, 24 points actuels et 48 liens de frontière. Hex Core et trois améliorations présents dans les sources ; descriptions3/4/5/6AP par niveau et bonus fixes0/20/40/60. Inventaire initial vide et AP0 aux niveaux1/18 dans le moteur ;quatre achats refusés,sorts refusés. Contrôles distincts de recette,vente et AP réussis.70 refus publics,8 refus de devis API,12 commandes de contrôle réussies,180 ticks et un apport XP serveur. Première assertion de diagnostic sur les slots de recette corrigée,échec conservé. BUILD/RUN corrigés0,1158entrées conservées. Aucun code de jeu modifié,aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Viktor-PASSIF-SOURCE, CH-Viktor-PASSIF-SIMULATION-CONTRAT et CH-Viktor-PASSIF-SIMULATION reçoivent les sources,preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse.37sources natives donnent111associations ;24points courants donnent48liens sur les deux fiches de simulation. Ce sont des frontières ou contrôles distincts,pas des producteurs du passif. Trois questions propres et quatre dépendances sont conservées. Aucun prérequis,critère,statut ou état manuel n’est déclaré terminé.

## Contrat natif et provenance

Découverte :82sources natives (30INIBIN,33Lua,18preloads,fontconfig),huit exclusions,35références communautaires. Complément :trois fichiers Atmas référencés,soit85sources candidates vérifiées. Tailles/SHA et appartenance au manifeste RADS sélectionné vérifiées.37sources sont reliées directement :

| Ressource | Octets | SHA-256 |
|---|---:|---|
| Viktor.inibin | 1424 | b054dbaa0d56dfa53c5687c8d7b0ce67c07c7eb6b3deec7cd2080d3b56299a89 |
| CharScriptViktor.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptViktor.preload | 1674 | ced58a60506904a4737c9df12d2ae4ab5f6c97eb2f041ad7bfe06f40ae9dc572 |
| ViktorPassiveAPPerLev.luaobj | 388 | 5cb5222954eb3d2c55f637b81305f58f531195617c8a8ef24d929b14eb847ae2 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| 3200.inibin | 562 | 64108956accafedf54f992978e5284e14bc7b94e10225d0fd52130747f8ba832 |
| 3200.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| 3196.inibin | 577 | 566853970686c169a9ba270150eb0d11b8a8ad1597344916c3ad3836a3c49acd |
| 3196.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| 3196.preload | 99 | 8551b0525b02412e500d83fbd68c67fa15a38e28ab1cb5f443e758a16e6cd874 |
| 3197.inibin | 572 | 14c6dbae5f050966e8113c0b9c3e2626e5abef56d908c51f2f475e681659a7c9 |
| 3197.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| 3197.preload | 97 | 509eeb487373d53422f4925bb315cfa205e28001616941e67692e2267a4c7123 |
| 3198.inibin | 566 | 1323be7e6f405cb13ab04e3d1116e94f361a7f1b44f650f720758413555ef826 |
| 3198.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| 3198.preload | 96 | 2775a502d86b4219a64f280e00673a5bb71c953bb416bc5697d8966d18202f7d |
| ViktorQAug.inibin | 42 | 79e04ce5123e4395c46862c6c67ac5f805f9fe3d2eec26a2744cc6c8a9f89e89 |
| ViktorQAug.luaobj | 280 | 54b907b979b8712d803e75da81858a63c507d7c042d2d9c85b7d7d3041c44faf |
| ViktorWAug.inibin | 42 | a11efd9bc8e1f141216baa6b5f4b447b7ba08d34045b65f1d1d7b5b9fa1c5fad |
| ViktorWAug.luaobj | 280 | 10c97a3f167592d0135129c3ad64e62976d2e6388d6feda324d5ed3ff6cb9279 |
| ViktorEAug.inibin | 42 | b63193390a5a34f342003b8f3cd93f40cbc117ee8efe7962e4b45ac2f5ff4060 |
| ViktorEAug.luaobj | 280 | b20d32cd1ec86c50409dc4dd64938d8165aeada72aaa159cb353c05d64b29947 |
| ViktorQWAug.inibin | 43 | 0b17010fbea2fb329252aa655147a1ce47c1eed38999b697d3a6302a00dc58f2 |
| ViktorQWAug.luaobj | 281 | 4f00809eb7bbd61575c1acbfb3a09f26a4d288d1e2d0c5cccca5470f0533fff2 |
| ViktorQEAug.inibin | 43 | 401179a14dcf4e85d42c0ab227285fa8961df5e4a3bbdbb9fad862656d13f0cc |
| ViktorQEAug.luaobj | 281 | 501689638eb3b1eaed483388b81ebc117222db3f6210ced547342547d49bf90b |
| ViktorWEAug.inibin | 43 | fc11762c5525e25262d67c27ebedcc87cc8104c8ca68fdaf53809d2af6d5bb5b |
| ViktorWEAug.luaobj | 281 | 5946cd0094d5e99bd7478846c6bd3f2110566939c27356dc0c6d5f67650faa78 |
| ViktorQWEAug.inibin | 44 | f8612b9a5b30a362ed99474b5a38c19d10001d9798b71cb812d92f642eddfd1b |
| ViktorQWEAug.luaobj | 282 | c5af9d09577e0ae5623df61d26ae922eed702fa3b8da8dd5f4b2f772705a9efc |
| ViktorPowerTransfer.inibin | 1353 | de7cf33fc1298d47dab320cc6814175bf472ba93ce8924de54d833dcf38c8ec8 |
| ViktorGravitonField.inibin | 1353 | dd0b48fa4402d5e2d0aa56e75870618390d66191e6ac1b308086177a1a88a538 |
| ViktorDeathRay.inibin | 1394 | a83e15a99da463341ce07449ea0b88a57dab4308f5c12f8c8a7c5a8d9c38a830 |
| ViktorChaosStorm.inibin | 1402 | 439b4becbb450c13d475c0a038b33fcf2444bb9217006644821262033c7f10f9 |
| AtmasImpalerDummySpell.inibin | 1078 | 0ac3531130812e7f19e7e2f2c48800f94b13f2bd9181e14c2b4d0f03eb7ce46b |
| AtmasImpalerDummySpell.luaobj | 334 | a7acf5a982a615a1fa5d2fee82f9b702f105e603a3103c30324b895feab83e9b |
| AtmasImpaler.luaobj | 155 | 030eae982c68fdd1428428a564d6bd356956a14317b2826be20eacf00099635d |

Viktor.inibin lie exactement Passive1Name et PassLev1Desc1 au texte Glorious Evolution. Passive1LuaName vaut ViktorBlah ;aucun fichier de ce nom dans ces85candidats,ce qui ne constitue pas une absence universelle. Le preload lie ViktorPassiveAPPerLev et sept combinaisons Q/W/E/QW/QE/WE/QWE. Le script AP emploie ViktorStormTimer et ViktorChaosStormGuide.dds ;ces métadonnées ne donnent pas la formule exécutée. PersistsThroughDeath ne valide pas un cycle de vie.

| Objet | AP par niveau,texte | AP fixe | Mana fixe | Prix incrémental | Recette | En boutique |
|---|---:|---:|---:|---:|---|---|
|3200|3|0|0|0|aucune|non|
|3196|4|20|150|1000|3200|oui|
|3197|5|40|300|1000|3196|oui|
|3198|6|60|500|1000|3197|oui|

Les quatre objets sont réservés à Viktor et invendables selon leurs champs natifs. Les descriptions exactes proviennent de fontconfig_en_GB lignes6823–6826. Les nombres sont établis ;leur producteur et la liaison dynamique f1 ne le sont pas. La comparaison aux quatre entrées du reçu boutique V80 est fraîche ;son audit complet n’est pas réexécuté. Les valeurs de prix natifs sont distinguées du total de recette et des valeurs de revente du catalogue.

Le CharScript et quatre scripts objets sont vides. Leur SpellName AtmasImpalerDummySpell pointe vers des métadonnées Disintegrate/Deathfire Grasp ;AtmasImpaler porte son propre nom/icône. Aucun comportement d’Annie,Atma ou de cet actif n’est emprunté.35chunksLua sans fonctions enfants ont été relus ;huit limites NEWTABLE restent dans le reçu. Les preloads et marqueurs ne prouvent ni choix d’augmentation ni rendu.

Les35références communautaires sont séparées. Le CharScript C# est vide ;les corps Q/W/E/R simplifiés ne fournissent pas de progression Hex Core. Les recherches bornées dans Rust et les scripts C# sont conservées avec les fichiers parcourus ;elles ne prétendent pas à une absence dans toutes les archives.

## Consommateurs et diagnostic actuel

| Point actuel | Ancre |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/shop.rs:43 | pub fn starting_gold( |
| crates/core/src/shop.rs:46 | pub fn catalog( |
| crates/core/src/shop.rs:51 | pub fn map10_available( |
| crates/core/src/shop.rs:69 | fn item( |
| crates/core/src/shop.rs:79 | pub fn quote( |
| crates/core/src/shop.rs:85 | pub fn quote_with_counts( |
| crates/core/src/shop.rs:99 | fn plan_in( |
| crates/core/src/shop.rs:215 | fn bonuses( |
| crates/core/src/shop.rs:248 | fn shop_guard( |
| crates/core/src/shop.rs:261 | pub fn buy_item( |
| crates/core/src/shop.rs:294 | pub fn sell_item( |
| crates/core/src/shop.rs:314 | fn refresh_item_caps( |
| crates/core/src/shop.rs:337 | pub fn swap_items( |
| crates/core/src/shop.rs:326 | pub fn swap_items_checked( |

Le catalogue runtime et sa table admission Map10 omettent les quatre IDs. Cela ne prouve pas une interdiction native sur Map10. join initialise six slots vides ;les routes de boutique et stats sont génériques. Le dispatch de sorts ne propose pas Viktor.

| Vérification | Attendu selon la référence ou le contrôle | Observé |
|---|---|---|
|Prototype initial|Texte natif :prototype au départ|Inventaire vide aux niveaux1/18|
|Puissance du prototype|3AP niveau1,54AP niveau18 selon la description|0AP ;écart conservé|
|Achats3200/3196/3197/3198|Définitions nécessaires avant test d’éligibilité|item behavior not implemented pour Viktor et Annie|
|Restriction Viktor|Rejet spécifique pour un autre champion|Non atteinte ;le même refus générique arrive avant|
|Learn/Cast/CastAt Q/W/E/R|Entrées effectives à identifier|Refus avant/après contrôles,aucune mutation|
|Recette ordinaire1029→1031|300 puis450or ;15 puis40armure ;slot0 consommé|Conforme,les slots sont des indices|
|Vente ordinaire1031|Déplacement0→5,remboursement525,retrait40armure|Conforme ;ne valide pas la vente interdite du Hex Core|
|Objet AP1052|Achat435,bonus20AP ;vente305,retrait du bonus|Conforme ;ne valide pas AP par niveau|
|Refus|Aucun changement du snapshot|70refus publics et8devis API refusés|
|Attente|Observer si un prototype arrive plus tard|90ticks par cas,aucun prototype ;observation bornée|

Total :12commandes de contrôle réussies,180ticks,un award_experience(100000) serveur explicite pour le niveau18. Aucune injection directe d’or,inventaire,rangs,position ou horloge. Aucun combat,gain XP naturel,mort,retour,reconnexion,rendu,audio ou réseau exécuté par ce diagnostic.

## Échec initial et correction

La première compilation passe,mais RUN échoue :le diagnostic attendait l’ID1029 dans quote.consumed alors que plan_in/credit pousse l’indice0. Ce test était erroné. Le diagnostic corrigé vérifie le slot0 et son contenu1029 avant achat. Le code du jeu reste identique. Le dossier revision650_Viktor_passive_probe et son exécutable sont conservés ;le succès est dans revision650_Viktor_passive_probe_slotchecked avec un autre exécutable.

Avant CHECK et publication,un nom de clé interne hérité vi_passive_glorious_evolution_links_v650 a été corrigé en viktor_passive_glorious_evolution_links_v650 dans les quatre fiches candidates. Les anciennes copies ont été sauvegardées en gzip avec comparaison décompressée ;versions et instructions candidates recalculées,registres et bases actifs inchangés à cette étape. CANDIDATE_CONTEXT_CORRECTION.json conserve la vérification. PREPARE emploie le script initial ;CHECK/PUBLISH/AUDIT emploient revision650_viktor_delivery_contextchecked.py,les deux scripts étant conservés.

Binaire corrigé :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-viktor-hexcore-slotchecked-probe.exe ;6034944octets ;SHA-256 ba4d8b7fed82f2904e13959a584a7c1d1998aaf83a52a7d0c3106e364558e3a4. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs,profile.test=false. Dépendances/checksums alignés sur Cargo.lock racine ;1158entrées moteur et ressources conservées avant/après.

## Correction de la preuve historique

Le premier AUDIT a échoué sur une empreinte de docs/fidelity_sources_4_20.json :le complément natif avait ajouté cette entrée historique à la liste des dépendances supposées immuables. Ce registre change lors de la publication. La réparation conserve l’identité initiale et son archive baseline vérifiée dans historical_registry_inputs_not_live_dependencies,la retire des seules dépendances vivantes et conserve le premier audit échoué. Reçu public,empreinte enregistrée,preuve et versions des deux bases sont actualisés ;les données et instructions des tâches restent identiques. HISTORICAL_PIN_REPAIR.json décrit les sauvegardes et contrôles. Le nouvel AUDIT_RECHECK est réussi ;ce correctif ne change ni le diagnostic ni le jeu. Les deux sauvegardes privées de bases prises pour la réparation sont archivées séparément avec vérification SHA.

## Contrôles de livraison

| Étape | Code | SHA-256 journal |
|---|---:|---|
| BUILD | 0 | 217f9eb70cf544f96fefda283430152fc3b39c0d7b53141b3ee92358e5296876 |
| RUN | 0 | 79bc4c413ff3fe0d78c5d56dd1b84551402fa626e4f23fbdc6670dee0af02ebd |
| prepare | 0 | 16e3c280e5da24f1aaa0aea403fad90ba06feb4962be9eb3ca2537067ae52026 |
| check | 0 | 44b503d741ffbf8c742a7743a4f88e7cf0335da9d93ef7a43ec9891de4e4d335 |
| publish | 0 | 34da93975c6f574ace84d4577a16093e157f6ac13dd62aaa9dc8987cd0c60fd8 |
| audit_recheck | 0 | 00c49ac1a92a506d078796411345520d6e11f88fc8101af18f41d6416fe0f7eb |

Reprise,découverte,complément,inspection :0.60associations falsifiées et quatre graphes invalides refusés. Store.task/copy_text et résolution des dépendances vérifiés. Trois fragments courts changent,42212restent identiques. Deux bases,quatre destinataires :42603autres lignes du catalogue,42607états manuels et23historiques conservés. Intégrité et synchronisation idempotente confirmées.5199ancres de consommateurs et empreintes courantes vérifiées,99275sources enregistrées. La revue globale ne rehache pas toutes les sources historiques et ne mesure pas le pourcentage d’achèvement du jeu.

## Fichiers et conservation

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Registres d’inconnues,d’identifiants et hiérarchie identiques. Reçu :docs/reference_requirement_trace_sources/viktor-passive-glorious-evolution-links-v650.json. Preuve :docs/fidelity_viktor_passive_glorious_evolution_links_v650.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision650_Viktor_discovery\OBSERVATIONS.json. Complément :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision650_Viktor_hexcore_followup/OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision650_Viktor_passive_probe_slotchecked\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision650_Viktor_inspection/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision650_Viktor/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision651_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

Neuf copies privées de validation archivées après audit,avec SHA décompressée vérifiée avant retrait des doublons bruts ;gain logique2463608374octets. Sources enregistrées,preuves,binaires et bases actives conservés. Restauration explicite par revision650_restore_validation_snapshots.py,non exécutée après archivage.

## Correction de la prochaine étape

Le premier script de clôture a terminé la revue globale avec5199ancres exactes,puis a refusé une hypothèse erronée :Vladimir possède déjà des liens et le diagnostic V545. Aucun rapport ni document de reprise n’avait été écrit par cette tentative. Le script suivant réutilise la revue réellement réussie,vérifie son journal et conserve la tentative initiale. Les preuves V545 sont relues comme héritées,pas exécutées à nouveau. La collecte Vladimir fraîche est conservée ;le prochain contrat sélectionné est Xerath.

## Manques et suite

Restent ouverts :attribution initiale et timing,producteur AP/f1,arrondis et exclusions,coûts/éligibilité,choix sans doublon,combinaisons et dernière amélioration R,liaison inventaire-compétences,vente interdite,annulation/inventaire plein,mort/retour/reconnexion. Sorts modifiés,réseau,sauvegarde,HUD,tooltips,icônes,particules,animations et audio demandent leurs preuves propres. Aucune case ni question fermée ;Viktor et le jeu ne sont pas terminés.

Continuer SYS-01.2-02 depuis revision651_trace_review/REVIEW.json. V650 Viktor publié et audité :37sources natives,111associations,24points/48liens. Hex Core et améliorations retrouvés ;descriptions AP3/4/5/6par niveau+0/20/40/60fixes. Inventaire initial vide et AP0 niveaux1/18 ;achats et sorts refusés,restriction champion non atteinte. Contrôles ordinaires recette/vente/AP réussis.70refus publics,8devis refusés,12commandes réussies,180ticks,un apport XP. Première assertion quote.consumed corrigée de ID1029 vers slot0 ;échec préservé,nouveau binaire. Producteur AP,choix et effets des augmentations,lifecycle et présentation restent ouverts. V651 Vladimir PASSIF Crimson Pact :découverte fraîche après correction du registre terminée,57sources natives et23références communautaires,quatre exclusions. Texte natif :40PVbonus donnent1AP,1AP donne1,4PVbonus,sans cumul avec soi-même. CharScripts natif/C# vides ;DDF0,15bonushealth concerne SanguinePool,pas le passif. La revue retrouve le lot V545 déjà intégré :sept sources,21associations,10frontières et deux ordres d’achats avec témoin Ahri. Conserver cette preuve héritée,sans la présenter comme réexécutée ;ne pas dupliquer son diagnostic. Première découverte avant correction conservée ;collecte actuelle dans revision651_Vladimir_discovery_postrepair/OBSERVATIONS.json. Aucun nouveau diagnostic moteur Vladimir exécuté. Prochain lot retenu :Xerath PASSIF Mana Surge,contrat encore au chargeur partagé ;identifier texte natif,déclencheurs,cibles,valeurs et producteurs courants avant diagnostic. Snapshots V650 archivés/restaurables par revision650_restore_validation_snapshots.py. Goal actif.
