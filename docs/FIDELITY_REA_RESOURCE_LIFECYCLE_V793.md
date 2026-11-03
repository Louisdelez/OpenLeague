# SYS-01.2-02 — Types de ressources et cycle de vie actuel, V793

Projet F:/OpenLeague. Sept exigences SYS-05.4-01 à07 et l’objectif SYS-01.2-02 sont enrichis. 31 liens supplémentaires réutilisent neuf ancres existantes ; aucun doublon de consommateur, aucune case ni inconnue clôturée. Il s’agit de traçabilité vérifiée, pas de sept fonctionnalités terminées.

## Sources natives

Référence conservée : LoL PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Les122 INIBIN de personnages sont relus ; leurs tailles/SHA256 et leur appartenance aux manifestes RADS sélectionnés correspondent. Les244 champs BaseMP/MPPerLevel concordent en binary32 avec les capacités et croissances actuelles. Les122 SHA source_sha256 du catalogue désignent les exports Stats JSON, également vérifiés ; ils ne désignent pas les INIBIN.

20 PARType sont explicites.102 sont absents et associés au défaut local Mana. L’absence de champ reste distincte du texte natif None. Le défaut historique effectif n’est pas qualifié par ces comparaisons.

Le premier contrôle RADS a refusé la racine F parce que le catalogue conservait ses chemins historiques E. Le successeur utilise ces chemins en lecture seule après comparaison des deux copies : catalogue, référence et deux manifestes. Une seconde tentative a refusé une comparaison exacte binary64 de la santé Garen ; le vérificateur compare désormais la projection binary32 réellement consommée. Les deux scripts échoués sont conservés et identifiés. Le code du jeu et les données ne sont pas corrigés pour faire passer ces contrôles.

## REA réellement exécuté

REA6.4.0/Ghidra12.1.4 analyse une copie exacte du PE original,15973880 octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Deux procédures complètes sont résolues :569560 (2938 instructions) et56C0F0 (864).3802 instructions et deux références sont recoupées avec Capstone et les octets du PE. Les deux CALL56B6CC/56CB56 ciblent8B0630 avec le défaut MP ;56CBC6 réduit le résultat à16bits puis56CBD4 écrit un DWORD à+0x28.

Les six chaînes/littéraux de V264 sont recontrôlés. V264 reste une preuve antérieure pour la construction de la table nominale MP→0 ; ce lot ne l’exécute pas. Ni provider, ni constructeur, ni instruction native de ces lecteurs n’est exécuté. Les limites Ghidra sur les appels indirects et les symboles globaux sont conservées. Session fermée normalement, aucune erreur REA, original inchangé.

## Vérification du consommateur Rust actuel

Commande réelle : `cargo test --locked --offline -p openleague-core --test resource_lifecycle_observation -- --nocapture`. Code0,3 tests réussis,0 échec ;24 avertissements existants. Sources avant/après, données incluses, exécutable et compilateur sont identifiés dans le reçu.

| Cas | Attendu local | Observé |
|---|---|---|
|122 champions|Initialisation à la capacité de base, getters et snapshot cohérents|122 correspondances ; tous les types autres que Mana/Energy ont un taux générique nul|
|22 profils,30 ticks vivants|Régénération conditionnelle depuis un scalaire explicitement injecté à0|Taux observé conforme,660 ticks vivants au total|
|22 morts/réapparitions|Pas de régénération durant la mort ; retour au plein pour Mana/Energy/Wind,à0 pour les autres|22 cycles via apply_damage et advance ;11220 ticks totaux,réapparition à510 après mort à30|
|19 champions spéciaux|Learn et les quatre Cast non pris en charge sont refusés sans mutation du snapshot|95 refus atomiques|
|Garen Q|Apprentissage/lancement sans débit de ressource ni coût de vie ; seconde commande en récupération refusée|Succès puis refus atomique ; cooldown240 ticks|
|Identifiant absent pour le getter de taux|Option None|122 vérifications|

164 observations JSON conservées. Les valeurs d’attendu du cycle de vie sont le contrat local inspecté : elles ne sont pas présentées comme une comparaison avec le serveur Riot. Injecter le scalaire à0 est un diagnostic déclaré, pas une dépense réussie ou un spawn historique. La remise à zéro de rage/fureur/chaleur n’implémente ni leur génération ni leurs dépenses. Le refus d’un sort à coût en vie ne réalise pas sa transaction ni son seuil de survie. Garen Q n’établit pas la gratuité de toutes les capacités None.

Six altérations de preuves sont rejetées : quantité initiale inventée,type Energy substitué,Gnar remis à100,entrée injectée masquée,refus transformé en succès,coût Garen inventé. Ce sont des contrôles de preuves distincts des96 commandes refusées par le core.

## Intégration et conservation

Les fonctions existantes de join,stats,regeneration_rates,advance_regeneration,advance_respawns,classification de ressource,snapshot et dispatch de sorts sont reliées précisément.21 ancres au total sont relues, dont neuf réutilisées pour les nouveaux liens. Les autres ancres historiques restent statiques lorsqu’elles ne sont pas exercées dans ces trois tests.

132 liaisons natives décrivent les champs et les lecteurs du client ; elles ne deviennent pas une autorité de règles serveur. Le premier candidat a été refusé avant modification des registres ou bases : les tâches de rage/fureur/chaleur/coûts en vie exigent exclusivement des ancres marquées frontière seule. Le successeur réutilise seulement les trois ancres existantes d’initialisation, remise à zéro et classification pour leurs nouveaux liens. Les observations des autres fonctions restent dans la preuve sans les promouvoir en consommateurs de ces mécaniques. Le candidat et ses documents sont conservés sous revision793_delivery/REJECTED_*.

Les sept tâches gardent partial_with_open_questions, leurs anciennes questions et les statuts d’implémentation/acceptation. Les cas de chaque tâche précisent les champions réellement observés. La tâche SYS-05.4-08 des ressources secondaires n’est pas incluse dans ce lot.

Fichiers ajoutés : crates/core/tests/resource_lifecycle_observation.rs ; docs/fidelity_rea_resource_lifecycle_v793.json ; ce rapport. Registres enrichis : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Couverture,plan,reprise,CURRENT,HANDOFF,DECISIONS et REA_WORKFLOW actualisés. Aucun code de production ni asset modifié.

Les deux bases du plan reçoivent huit fiches et leurs consignes par deltas ciblés, sans sauvegarde intégrale supplémentaire.42599 autres tâches,42607 états,23 historiques,24 phases,2770 lots et42215 groupes restent conservés dans chaque base. Les inverses exacts des trois registres et la lecture du texte copiable sont vérifiés ; une relecture indépendante et un reçu final suivent la publication.

Preuves sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision793_current_resource/RECEIPT.json ; revision793_resource_sources_final/OBSERVATIONS.json ; revision793_rea_resource_type/observations/bdafe51f-1f44-4d20-a01e-0826a9220201/receipt.json ; revision793_associations_verified/OBSERVATIONS.json ; revision793_delivery_verified/.

## Limites et suite

Génération/décroissance de rage,fureur,chaleur,coûts en vie,modificateurs,timing et valeurs initiales du serveur restent ouverts. Ni rendu,HUD multilingue,réseau multiclient ni jeu complet validés. Le goal reste actif.

Continuer SYS-01.2-02 sur F avec REA. V793 précise sept exigences de ressources et conserve les limites de rage,fureur,chaleur/coûts en vie. La construction native de la table PARType et le contexte réel du provider restent à qualifier ; MP fourni par les callers ne prouve pas le spawn ou les règles du serveur. Poursuivre les associations partielles du recensement V784 et les limites V792 sans répéter les contrôles déjà acquis. La fiche SYS-05.4-08 des ressources secondaires et les76 fiches de localisation restent notamment à examiner au niveau de leurs consommateurs précis. Cinq exigences Battle Training restent ouvertes sans nouvelle entrée historique ; ne pas répéter leurs recherches inchangées. Préserver les preuves, cases, notes, historiques et inconnues.
