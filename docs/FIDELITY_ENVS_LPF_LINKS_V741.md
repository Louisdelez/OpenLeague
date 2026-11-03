# SYS-01.2-02 — Courbes LPF ENVS et composants de filtre, V741

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Ce lot établit les liens source/consommateur sans déclarer le moteur audio terminé.

## Source et consommateur original

Init.bnk : SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les112octets ENVS à6778 et leurs36champs sont vérifiés ; les courbes1/3 ont chacune deux points et scaling0. PE : SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

B18530 est exécuté entièrement après le chargement original STMG/ENVS sous gestionnaires déclarés. Les168cas couvrent sept profils et quatre dispositions : auditeur0 seul, auditeur7 seul, plusieurs auditeurs avec addition ou groupement. Les valeurs des deux auditeurs sont distinctes. Les profils couvrent les deux courbes actives, mode2, chaque flag désactivé, les deux désactivés et chaque pointeur de courbe absent.

Les252paires aux offsets240/244 et216appels ADECF0 sont comparés aux calculs indépendants issus des points originaux. L’offset240 reçoit le maximum du filtre de base et de la courbe3 ;244 reçoit la courbe1 lorsqu’elle est appliquée, sinon la valeur antérieure reste conservée. Les entrées proviennent d’octets multipliés par0x3B808081 puis100. Les profils finaux ont les bits bas de voice+12B à1, cohérents avec la branche du parent B1748C/B174B9 inspectée statiquement. Le parent et le producteur historique de ces flags ne sont pas exécutés. Les premières explorations directes avec bits bas0 sont conservées, sans qualification du parent.

Les2558adresses du parcours, alloca/memset, lecture de canal B20CB0 et sélection AEDED0 comprises, correspondent au PE. Les structures voix/propriétaire/auditeurs/devices et le canal1 sont fournis ; atténuation neutre en cache et pointeur auxiliaire nul sont déclarés. Les courbes sont libérées ; aucun accès mémoire bas. Les autres valeurs de gain observées sont conservées mais ne qualifient pas un mixeur complet.

## Composants natifs et Rust

Les huit contrôles non négatifs observés servent ensuite d’entrées à deux contrôles séparés :80cas du fragment setter B15086..B150CA et72cas de la fonction B35530 complète. Le setter conserve les flags pending et borne les valeurs finies ; deux entrées hors bornes sont des diagnostics explicites. La fréquence couvre les trois rates44100/48000/96000 et les modes bruts0/1/255. Les97adresses supplémentaires sont vérifiées. Ce banc ne démontre pas le transport historique des sorties240/244 vers ces composants.

Quatre modules Rust réels et leur fichier inclus sont compilés hors ligne : audio_curves.rs, audio_filter.rs, audio_filter_transition.rs, audio_pcm.rs et audio_filter_expand.rs. Curve::evaluate reproduit les252paires dans une composition privée ; Controller::update_target et cutoff concordent avec80écritures et72fréquences natives. Les historiques de filtre et champs non concernés restent inchangés. Six refus locaux sont vérifiés : NaN et infini sans mutation du contrôleur, rate0, contrôle101, courbe vide et entrée de courbeNaN. Ils ne sont pas assimilés à une politique de refus native.

Trois rôles précis sont enregistrés : évaluation des courbes LPF, écriture de cible et conversion de fréquence. Aucun code produit n’est modifié. Le lecteur courant refuse encore ENVS selon V739 ; aucune orchestration actuelle équivalente à B18530 ou chaîne PCM n’est revendiquée.

## Vérifications, conservation et limites

Quatre falsifications sont rejetées : sortie LPF altérée, mauvais facteur de normalisation, mauvais flag de parent et fausse revendication de consommateur complet. Deux essais du banc de capture du retour de fréquence ont échoué à leur assertion d’adresse finale. Ils sont conservés. La capture finale utilise une instruction FSTP explicitement bornée par son adresse de fin, vérifiée séparément ; elle n’est pas comptée comme instruction originale. Compilation et exécution Rust finales retournent0.

Deux fiches sont enrichies : SYS-01.2-02 et SYS-02.2-07. Les deltas ciblés préservent cases, notes, historiques, prérequis, inconnues et preuves précédentes, sans copie complète de base.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md ; ce rapport et docs/fidelity_envs_lpf_links_v741.json. Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Corpus privé : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision741_*.

Restent ouverts : parent B17486, producteur owner+38/+40, transport des sorties240/244, raccordement ENVS courant, instances Meter, Init STMG/HIRC8/HIRC14, médias, montage historique, locale et son audible. Aucun jeu complet accepté.

[Preuve](fidelity_envs_lpf_links_v741.json). Livraison : revision741_delivery/VERIFIED.json ; relecture indépendante à contrôler avant revendication finale. Goal ouvert.


## Relecture finale

La relecture indépendante passe :112octets ENVS/36champs contrôlés ;2558adresses du consommateur/setup et97adresses des composants séparés vérifiées contre le PE. Les252paires,216appels,80cibles et72fréquences sont recalculés ; les sources Rust, le binaire et les journaux concordent. Huit fichiers de source sélectionnés sont revérifiés dans ce lot, sans revérification globale de toutes les sources du registre.

Les deux bases passent quick_check.42605autres tâches,42607états manuels,23historiques,24phases,2770lots et42215groupes sont inchangés. L’inversion ciblée retrouve les octets précédents des trois registres ; instructions copiables et anciens contextes sont conservés. Aucun inconnu ni statut manuel n’est promu. Les deux erreurs de capture restent conservées.

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision741_delivery\INDEPENDENT_READBACK.json. Les raccordements historiques et actuels demeurent ouverts ; le goal reste actif.
