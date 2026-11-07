# SYS-01.2-02 — sources des capacités Garen, Ezreal et Trundle (V237)

Les douze capacités Q/W/E/R ont désormais des liens précis vers leurs fichiers INIBIN 4.20, leurs JSON décodés, les champs sélectionnés et leurs consommateurs de production actuels. Cela enrichit36tâches SOURCE/SIMULATION-CONTRAT/SIMULATION et l’objectif de traçabilité, sans modifier leur statut ni leur acceptation. Le lecteur de chaque formule est identifié ; sa fidélité complète au serveur d’origine reste ouverte.

## Sources et consommation réelle

| Champion | Champs reliés | Preuves actuelles |
|---|---:|---|
| Garen |75|14appels de production, lecteur garen_value et dispatch ;4tests exacts |
| Ezreal |74|4lecteurs dédiés, routes CastAt, formules et constantes distinguées ;8tests exacts |
| Trundle |122|120champs numériques et2textes,4lecteurs dédiés et routes Cast/CastAt ;8tests exacts |

Les12INIBIN et le DDF supplémentaire de Trundle concordent avec les manifestes RADS sélectionnés. Le SHA déclaré dans native_spells_420.json identifie le JSON décodé conservé sous E:/mapslol3v3 ; il ne désigne pas l’INIBIN. Aucun ancien fichier déplacé ou réécrit. Les213ancres sont vérifiées ;86désignent des lecteurs/corps fonctionnels dans la portée examinée. Les routes, gardes et auxiliaires gardent leur qualification propre.

Trundle Q choisit localement la série AD0.8/0.9/1/1.1/1.2 du DDF natif. Elle diffère de Effect3/100 aux quatre premiers rangs. Le Rust ne lit pas ce DDF au runtime : la série y est littérale. Ce choix et les géométries, durées, conversions en ticks et autres constantes locales sont conservés explicitement, sans preuve d’un algorithme serveur Riot.

Ezreal R présente une différence d’un ULP : le lecteur comparatif Python byte×0.1 produit6666663f, tandis que le catalogue, le JSON décodé et le getter natif exécuté avec MXCSR1f80/x87CW037f donnent6766663f. La garde Rust accepte le catalogue mais la formule conserve un littéral0.9f32,6666663f. Aucun correctif du lecteur historique ou du gameplay n’est fait dans cette tâche de traçabilité.

La preuveV234 exécute le parseur original sur les1720octets du véritable INIBIN R, puis19requêtes de valeurs et leurs getters dans une mémoire Unicorn isolée. Les19valeurs concordent avec le catalogue sous le contexte déclaré. Le coefficient compressé suit le MULSS original ; les18chaînes passent par le corps CRT atof original. Les adaptations de fichier, arène, SSO, contexte de locale/thread et cookie restent explicites ; aucun résultat numérique Python ne remplace le corps CRT. Les sections exécutables restent inchangées. Ce n’est pas une exécution du client historique complet, et son contexte FP effectif reste inconnu. Les anciennes vérifications matérielles256vecteurs×4modes sont héritées et pinnées, pas rejouées parV234.

## Vérifications réellement exécutées

V235 compile/découvre openleague-core dans un nouveau target isolé, puis exécute20commandes cargo test --locked --offline avec --exact :20réussites, code0, un test passé et1926filtrés à chaque fois. Rust stable1.96.1 ; aucun build complet du workspace/client/launcher. Le binaire réel est F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision235/cargo-target/debug/deps/openleague_core-21eb81eb13817108.exe,787789824octets, SHA256 cbe1c8e0e74f3a9a99e911462d2cbe84b4745a3dfceb476f96b976c2449b1ee0. Le binaire antérieur46d373... et sa copie historique enregistréeV17 sont conservés.

Les tests couvrent des valeurs admises, plusieurs engagements et des refus précis. Les4tests Garen utilisent une grille synthétique20×20 avec deux Garen. Pour Trundle Q et E, la sélection qualifie principalement valeurs/apprentissage/refus ; elle ne valide pas tous les impacts acceptés ou les poussées. Les noms de certains tests contiennent un ancien libellé «unsupported» : les assertions et routes actuelles priment. Pas de GUI/GPU/audio/réseau ni de recette historique complète.

La revue indépendanteV236 recompute75champs et14appels Garen, vérifie20journaux/codes0,82identités et260contrôles, plus6refus. Son premier reçu est conservé : il exigeait à tort l’identité du chemin du binaire protégé et de la copie historique enregistrée ; la correction vérifie les deux contenus et distingue leurs chemins. Une préparationEzrealV2 resserre les ancres E ; le reçu communV2 retire six déclarations de corps fonctionnels sur des routes/auxiliaires. Ces corrections ne modifient pas le produit.

L’audit final vérifie37sélecteurs et quatre refus de mauvaise affectation/section/bornes,141identités ciblées,213ancres,13appartenances natives et les271liaisons de champ. Quatre refus supplémentaires concernent la provenance SHA, le slot, le littéral R et la contradiction DDF. Les deux bases exposent37fiches/copies/traces, conservent42606états manuels et l’historique, avec integrity_check=ok. Les anciens enregistrements, liens, autres champs des tâches et inconnues sont préservés. Le baseline du catalogue avant intégration est vérifié contre la sauvegarde gzip, pas contre sa version mise à jour.

Validation globale structurelle :98080sources,2226consommateurs,25319inconnues ouvertes. Elle ne rehash pas tout le catalogue ; les141identités sont un audit ciblé distinct. Aucun champion, aucune tâche de simulation entière, aucun jeu ni objectif général déclaré achevé.

## Fichiers et reprise

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et les deux bases du plan. Ajoutés : docs/reference_gameplay_source_links/gameplay-v237.json, docs/fidelity_gameplay_source_graph_v237.json, ce rapport. Les documents de couverture/plan/reprise reçoivent un checkpoint de recherche sans changer les critères ni états de réalisation. Code, ressources et distributions du jeu inchangés.

Preuves sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision231_ezreal_gameplay_source_review,revision232_trundle_gameplay_source_review,revision233_garen_gameplay_source_review,revision234_native_scalar_tenths_review,revision235,revision236_* etrevision237. Scripts :revision236_prepare_scoped_gameplay.py,revision236_qualify_anchor_roles.py,revision237_register_scoped_gameplay.py,revision237_audit_delivery.py. Sauvegardes :revision237/before-scoped-gameplay-graph.

Suite engagée :Annie lit quatre JSON de règles annexes et une définition Tibbers distincte, pas le catalogue HUD. Les sources sont inspectées enV238 ;8tests exacts du binaireV235 copié à l’identique ont passé enV239, sans nouvelle compilation. Ces preuves restent à qualifier puis intégrer. Le candidat d’archivesSYS03.4-07 reste non identifié après la réponse utilisateur ; il ne bloque pas ces autres travaux.
