# SYS-01.2-02 — préparation des120passifs réseau, V666

UTC 2026-10-27T07:28:02.747505+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau et déploiement non établis ;catalogue4.20.1 distinct.

## Résultat et état de livraison

Les120fiches restantes possèdent maintenant une inspection et des instructions individuelles prêtes pour publication.358sources natives sélectionnées sont rehashées,23points de code identifiés et2046associations préparées. Les17frontières communes sont distinctes des6points partiels d’Annie,Garen et Trundle. Les360fiches SOURCE/CONTRAT/SIMULATION antérieures sont contrôlées sans réécriture,ainsi que les120packages et leurs prérequis.120questions propres et123paires de questions parentes sont conservées.

**Les associations V666 ne sont pas encore publiées dans les registres ni les bases du plan.** Aucune case ou validation du jeu n’est changée. Le lot canonique précédent reste V665 :99335sources/5557points.

## Exécution réelle

Le binaire lie le vrai core et inclut reconnect,clock_delivery,pause,session_host et session_client. Pour chacun des120champions,il crée trois connexions UDP locales,contrôle la projection initiale cachée,applique un dégât37 par API serveur,refuse une commandeStop dupliquée,reprend le même joueur sous une nouvelle époque,puis observe une mort serveur et le retour normal480ticks plus tard. Le temps Host de récupération est diagnostique et n’avance pas la simulation. Session77 initialisée explicitement ;aucune injection directe de PV,position,rang,buff ou tick ;clés OS non journalisées.

Le scénario Annie apprend et lance E par commandes publiques :pyromania=1. Celui de Garen observe le timestamp d’interruption après le dégât. Celui de Trundle utilise des déplacements publics puis une mort adverse à portée ;le vrai soin partiel fait passer579.280029296875à591.6056518554688pour un maximum victime616.280029296875et un ratio local2%. Aucun de ces contrôles n’est la recette complète du passif.

Total :360connexions clientes,1209états reçus,13744datagrammes,846requêtes et59395ticks. Les120doublons de commandes sont refusés et les120reconnexions gardent l’état complet. Les fragments sont réassemblés dans l’ordre inverse avec doublons avant/après complétion. Les autres clients restent détachés après récupération du propriétaire. Les117autres champions sont contrôlés pour leur état courant générique,ce qui ne démontre ni l’absence ni la complétude d’un producteur de passif.

## Écart de représentation numérique conservé

1199états correspondent exactement à la valeur JSON brute attendue. Dans10états de décès,un nombre du récapitulatif change de représentation. L’écart se reproduit par le cycle JSON direct,indépendamment d’UDP. Le vrai décodeur death_recap.decode_view retrouve exactement les mêmes valeursf32 ;les autres champs du snapshot restent exacts. Aucun changement de code ou assouplissement silencieux :les écarts attendus/observés,le chemin JSON et les résultats du décodeur sont enregistrés.

| Champion | États concernés | Valeur source | Valeur JSON reçue |
|---|---:|---:|---:|
| Annie | 2 | 511.67999267578125 | 511.6799926757813 |
| Brand | 2 | 507.67999267578125 | 507.6799926757813 |
| Nami | 2 | 489.32000732421875 | 489.3200073242187 |
| Velkoz | 2 | 507.67999267578125 | 507.6799926757813 |
| Zyra | 2 | 479.32000732421875 | 479.3200073242187 |

Chemin concerné : /death_recap/rows/0/true_damage/health_removed ;phases ordinary_death_API et one_tick_before_normal_respawn. Les deux premiers RUN se terminent101sur l’égalité brute d’Annie. Le diagnostic diff localise l’écart ;le diagnostic typed conserve l’écart et vérifie séparément le cycle JSON et le vrai consommateur f32. Les sources,binaires et journaux des échecs sont conservés. Ne pas décrire1209snapshots comme parfaitement identiques en JSON brut.

## Vérifications et preuves

| Commande finale | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 555704d5abc29217e9439f94cbd25e099e9a8b67e2e2e451faf2fb8f630f7426 |
| RUN | 0 | ed9d1430ae6ab67dd1e700057c242563bc94aa34896abbb8a95ab5800e76d90f |

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-passive-network-matrix-probe-typed.exe ;7862784octets ;SHA-256 f44e562a66cd965a66caa177685c41f03e65423904aa19fa3f0654199345f156. Cargo.lock/checksums alignés,binaire non-test,1163entrées inchangées. L’inspection indépendante recontrôle1542identités/pins,les sources natives,les phases,les appartenances des questions et les bitsf32 des écarts. Les six registres restent inchangés.

Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_inspection\OBSERVATIONS.json. Runtime :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_probe_typed\OBSERVATIONS.json. Instructions individuelles :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_preparation/TASK_INSTRUCTIONS.json. Reçu public :F:\OpenLeague\docs\fidelity_passive_network_matrix_preparation_v666.json. Matrice antérieure :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision666_passive_network_matrix\OBSERVATIONS.json.

## Limites et suite

Les données natives sélectionnées décrivent les champs de passif et les chunks clients ;elles ne livrent pas les callbacks serveur,les audiences ou le protocole natifs. La réapparition générique480ticks ne valide aucune résurrection propre à un champion. Le mana générique n’est pas une réserve passive qualifiée. Main graphique,GPU,HUD,audio,partie multiclient complète et acceptation humaine ne sont pas exécutés ici.

Continuer SYS-01.2-02 : publier en un lot les120fiches PASSIF-NETWORK préparées dans revision666_passive_network_inspection/OBSERVATIONS.json, avec leurs instructions complètes dans revision666_passive_network_preparation/TASK_INSTRUCTIONS.json. La qualification est faite :358sources natives sélectionnées/358liens,23nouveaux points (17partagés et6spécifiques),2046associations ;120questions propres et123paires de questions parentes à conserver. Ne pas recopier toute la matrice190Mo dans chaque association : utiliser les lignes compactes de l’inspection et leurs pointeurs,conserver les360fiches amont comme contexte. Prévoir121cibles avec SYS,42486autres lignes par base,42607états manuels et23historiques. Étendre le mécanisme de livraison V665 avec validation des qualifications par fiche,source et question ;ne pas marquer toutes les associations comme feature_complete. Après ajout de quatre nouvelles preuves et23points,graphe attendu99339sources/5580consommateurs si aucun autre changement. Runtime typed BUILD/RUN0 :1209états reçus,1199exacts bruts,10écarts de nombre dans le recap d’Annie/Brand/Nami/Velkoz/Zyra ;roundtripJSONdirect et véritable decode_view f32 exacts. Conserver les deux RUN101 et ces10écarts,ne pas écrire1209états bruts exacts. Trois cas spécifiques seulement :EAnnie→charge1,dégâtGaren→timestamp,une mort procheTrundle→soin avec ratio local2%. Les117autres cas ne prouvent pas absence ou complétude de producteur particulier. F dispose de peu d’espace : compresser chaque sauvegarde privée immédiatement après scan/SHA avant de créer la suivante ;restaurer exactement la sauvegarde projet dans le candidat,comme l’adaptateur V665. Ne pas supprimer bases actives ni preuves enregistrées. Après publication,auditer les deux bases et le graphe,mettre à jour couverture/reprise ;la liste PASSIF-NETWORK au seul chargeur peut devenir vide sans aucun passif complet. Poursuivre ensuite les autres rôles précis du goal. Goal actif.

Modifiés dans le projet :ce rapport,son reçu et les documents coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md. Les valeurs précédentes sont sauvegardées. Aucun code de jeu,asset,registre canonique ou base active modifié par cette préparation.
