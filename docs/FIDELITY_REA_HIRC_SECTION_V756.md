# SYS-01.2-02 — Sections HIRC complètes et propriété des références, V756

Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, région EUW/en_GB ; catalogue4.20.1 distinct. Association des sources aux consommateurs actuels, sans modification du code produit ni des assets. SYS-01.2-02 et SYS-02.2-07 restent ouvertes.

## Résultat vérifié

Le véritable AFB630 charge les sections HIRC entières, dans leur ordre sérialisé. Init.bnk fournit91objets :79bus,4états et8effets Meter. Sixbanques fournissent2425objets :739sons,524conteneurs,28acteurs,551actions,538événements,20atténuations et25effets Silence. Aucun objet de ces sections n’est omis ;tous les corps sont consommés jusqu’à leur dernier octet. Les sources sont préservées. V755 testait seulement les lecteurs2/5/7 ;ce résultat ajoute le dispatch complet de ces sept sections.

Les sixbanques sont ENV_Map10_SFX_events(183objets),NPC_Map10_SFX_events(261),Announcer_Global_Female1_VO_events(867),Announcer_Map8_Female1_VO_events(256),Announcer_Tutorial2_events(393),Announcer_Tutorial_events(465). Les VO de ce lot sont en_US :ce n’est pas une couverture exhaustive en_GB.

BKHD produit le contexte de chaque banque. STMG initialise le gestionnaire natif. Le producteur natif7062A0 enregistre Meter,Silence et le codec observé ;c’est un profil explicite,non la preuve de tous les producteurs historiques. Les8paramètres Meter et25paramètres Silence sont construits et comparés aux octets des sources.

AFC410 libère les références détenues par chaque banque à travers les vraies méthodes virtuelles de toutes les classes chargées. Le holder revient à pointer/count/capacity nuls et chaque index retrouve l’état précédant cette banque. Les2425objets de ces banques ne restent pas alloués. Les6222allocations et5918libérations,contrôles inclus,laissent304allocations du contexte Init/managers/capacités encore vivant. Elles ne sont pas annoncées libérées :le teardown global historique demeure ouvert.

## Comparaison au Rust actuel

Une sonde compile32modules complets inchangés. Cargo generate-lockfile --offline,build --locked --offline puis exécution terminent avec code0. Les identités du programme,des sources,du verrou,du depfile et des journaux sont conservées.

Les septsections complètes sont testées sous Reject et SkipNativeDefaults :14refus. Douze proviennent d’un lecteur de classe HIRC non implémenté. Les deux de Tutorial2 proviennent du premier effet Silence :le créateur enregistré n’est pas implémenté. Son corps est déjà consommé avant le refus ;ce n’est donc pas le même arrêt que les lecteurs non implémentés.

Les huitparamètres Meter concordent exactement avec le natif. Les25effets Silence sont refusés avec leur créateur enregistré. Avec registre vide,les25retournent1 mais gardent pluginFFFFFFFF et paramètre nul :ce résultat n’est pas une fonctionnalité Silence achevée. Le nettoyage courant retire les ressources et rend toutes les allocations de ces essais. Le véritable unload_effects ne prend en charge que les effets,alors que le natif AFC410 traite les classes hétérogènes du holder.

Cinq rôles existants sont réutilisés sans réécrire leur qualification :lecture bornée,load_effect,load_section,installation du paramètre et refus du créateur Silence. Un rôle précis est ajouté pour Holder::unload_effects ;aucune tâche n’est promue terminée.

## Limites et contrôles

Neuf contrôles natifs :section vide→1 ;compteur tronqué→56 ;descripteur tronqué→56 ;corps inconnu tronqué→7 ;corps inconnu complet→1 ;huit Meter→1 ;préfixe Meter suivi d’un corps inconnu tronqué→7 ;préfixe suivi d’un descripteur tronqué→56 ;échec de réservation→2. Les préfixes chargés restent possédés puis sont libérés correctement. Dix-huitcomparaisons Rust vérifient ces cas sous deuxpolitiques ;Reject refuse volontairement les tags inconnus plutôt que de les ignorer.

Six falsifications contrôlées sont rejetées :objet omis,corps incomplet,libérations supprimées,paramètre Meter altéré,chargeur complet indûment déclaré et Silence sans enregistrement indûment promu.

Un premier essai Rust supposait que toute banque commençait par une classe non implémentée. Tutorial2 commence par Silence ;le code a correctement refusé son créateur. Le banc a été corrigé pour vérifier cette cause et sa position exacte. L’essai initial et son journal sont conservés,aucun code produit corrigé ou remplacé.

L’exécution native est isolée en mémoire :allocateurs/verrous physiques/TLS/last-error et journal5642D0 adaptés explicitement ;instructions originales de copie/chargement/destruction vérifiées. Pas de concurrence ou démarrage historique complet qualifié. ENVS,DIDX,DATA,voix,exécution des actions,lecture audio,mixage et sortie physique ne sont pas qualifiés par ce lot.

## REA et sources

REA6.4.0,SDK2.3.1,Ghidra12.1.4,JDK21.0.10.7. Session réelle sur le PE complet :10fonctions,941instructions et67références contrôlées. AFB630,AF8170,AFBB60,AFBE20,AF8350,AF85A0,AFC410,AF7940,AF7A40,AF7D90. Export,fermetures du binaire/client/transport réussis,aucune erreur. Les1621blocs exécutés sont également comparés aux octets du PE.

League of Legends.exe :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk :6890octets,SHA25641d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les huitidentités natives et les modules actuels sont reliés au registre avec leurs sources,offsets,tailles et empreintes. Les originaux sont sous D:/LeagueOfLegendsV2 ;les nouvelles preuves sous F.

## Livraison et suite

Preuve docs/fidelity_rea_hirc_section_v756.json ;reçus détaillés F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision756_*. Troisregistres et documents de reprise enrichis ;deuxfiches dans deuxbases locales. Deltas compressés ciblés,aucune copie intégrale de base. Cases,notes,historiques,autres tâches et inconnues conservés. VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED documentent les contrôles de livraison.

Prochaine étape :orchestration de banque complète autour du caller natif AF9BCE et du consommateur actuel audio_bank_memory_reader.rs,ordre/prérequis des sections STMG/ENVS/DIDX/DATA,chargement et déchargement. Puis relier la production des voix et leurs consommateurs. Charger une section HIRC ne prouve ni l’exécution d’un événement ni un son audible ni le jeu terminé.
