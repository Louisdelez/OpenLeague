# Sources et consommateurs du comportement des monstres — V101

Objectif SYS-01.2-02 :relier sept exigences SYS-12.2 à14 rôles du code courant. Cinq parcours partiels et deux frontières pour l’acquisition et l’interruption de reset. Ce lot ne termine pas l’IA des monstres et ne modifie pas ses règles locales.

## Référence native et consommateurs

Six scripts natifs sont identifiés et comparés aux manifestes RADS sélectionnés :Leashed,Aggro,Idle,AIComponentSystem,AIComponentOutOfCombatRegen et NeutralMinionSpawn de Map10. Deux lecteurs concordent sur les instructions,constantes et enfants. Les noms de fonctions viennent des affectations CLOSURE/SETGLOBAL quand elles existent ;les fonctions de table restent identifiées par index et plage de lignes. La présence de ces scripts ne prouve pas lequel est effectivement monté pour chaque monstre.

Sept profils INIBIN (deux golems,deux wolves,deux wraiths,Vilemaw) correspondent aux sources sélectionnées. Leurs valeurs GoldGivenOnDeath/ExpGivenOnDeath correspondent aux définitions locales. AcquisitionRange est300 pour les golems et1200 pour Vilemaw ;il est absent des quatre autres profils examinés,dont la valeur locale475 reste à qualifier.

Le code actuel conserve une cible hostile vivante ;dans le bloc étudié,la recherche par proximité est réservée aux voies,tourelles et fontaines. damage_unit réveille les membres vivants du même camp lorsque combat_owner existe. Une recherche dans tous les autres producteurs reste nécessaire avant de déclarer une absence globale d’acquisition de monstre.

## Leash et régénération :résultats nouveaux

Leashed déclare LEASH_RADIUS850,LEASH_PROTECTION_RADIUS750,INNER_RELEASH_RADIUS750,RELEASH_RADIUS1150 et LEASH_COUNTER_THRESHOLD10. Son TimerRetreat et ses appels sont conservés en instructions ;ils ne sont pas assimilés à une patience complète qualifiée. Rust utilise actuellement distance(home)>800 ou absence de cible,puis un chemin vers home et health=max_health,avec un traitement distinct de Vilemaw immobile lorsqu’une attaque est engagée.

FindNewTarget et le composant OutOfCombatRegen ont été exécutés dans le module Lua5.1 existant. Seules les longueurs size_t des chaînes ont été adaptées32 vers64bits,avec aller-retour exact et mêmes tableaux d’instructions. Les API moteur sont des observateurs ;le chargement/dispatch des composants est adapté et seuls les deux chunks identifiés sont exécutés. Les autres composants fear/flee/taunt sont recensés comme demandes,leurs corps ne sont pas exécutés dans ce banc.

48 cas de FindNewTarget couvrent états halted/retreat/attack/idle,roam0/1/2,cible absente et distances849.999/850/850.001. Le helper ne cherche qu’en roam hostile hors halted/retreat. Il demande FindTargetNearPosition à partir du point de leash,avec850 ;une cible à850 est acceptée,au-delà il demande Start de régénération puis Retreat. Ce refus en retreat ne prouve pas un refus global de reprise :OnTakeDamage et LeashedCallForHelp sont d’autres callbacks dont le dispatch reste ouvert.

30 cas de régénération couvrent halted/attack,taux absent/0/.25 et PV0/50/99/100/150 pour MaxHP100. Le taux absent devient0.125 ;les overrides0 et.25 sont conservés. Un état halted ou HP<=0 ne demande aucun soin. Sinon,le callback demande SetHP(HP+MaxHP*taux),sans plafonnement propre. Le plafonnement éventuel,la cadence effective et les effets de SetHP sont à qualifier dans le moteur. Le premier banc attendait à tort un soin à zéro et un plafonnement ;son assertion a échoué. Source et journal de cet échec restent conservés,et les78 cas complets ont été réexécutés après correction.

Deux imports/composants inconnus sont refusés par les adaptateurs du banc. Ces gardes ne sont pas des politiques attribuées au moteur historique.

## Réapparition,récompenses et preuves héritées

La preuve V42 des callbacks NeutralMinionSpawn est relue par identité de source et empreintes récursives des instructions. Ses27 cas de mort sont hérités :18 morts séquentielles produisent huit demandes de timer,les huit répétitions de dernière mort en produisent huit autres,un nom inconnu ne change aucun camp. Aucun de ces27 scénarios n’est rejoué ici et le producteur natif d’événement/doublon reste inconnu.

L’identité Python enregistrée dans cette ancienne expérience diffère du Python courant ;elle demeure dans le reçu historique. La relecture actuelle vérifie source/instructions et données d’observation,elle ne prétend pas reproduire l’ancien environnement. Les identités du Python et du Lua utilisés pour les78 cas frais sont épinglées séparément.

Le code Rust arme spawn_at seulement lorsqu’il est absent et que tous les membres sont morts ou retirés. Son test de camp vérifie la mort partielle puis le respawn à la frontière prévue. Le test d’aggro/récompenses observe les cibles du camp,le crédit exclusif d’XP et l’or du tueur. Les champs de récompense natifs correspondent,mais les bonus,propriétaires,annulations et tous les doublons doivent encore être qualifiés. Les horaires initiaux100/180/600 et les champs natifs15/95/515 ne sont pas assimilés à une même horloge par cette livraison.

## Contrôles réellement exécutés

- Deux commandes Rust hors ligne avec noms exacts world::tests::monster_kill_xp_is_exclusive_and_camp_retaliation_is_shared et world::tests::camps_respawn_only_after_all_monsters_die :un test réussi chacune,zéro échec. Navigation synthétique et ticks contrôlés ;aucun jeu graphique lancé.
-78 cas d’instructions originales Lua5.1 et deux refus d’adaptateur ;aucun moteur historique exécuté.
-18 refus du lecteur Lua sur copies d’octets :en-tête,troncature et octets supplémentaires pour chacun des six scripts.
-58 identités,331 contrôles source et33 cas du lecteur de liens,dont32 refus de preuves altérées. Ces mutations sont des tests de traçabilité,distincts des scénarios Lua et Rust.

Les modifications portent sur le lecteur,les registres,les documents de couverture/reprise et huit fiches de chaque base. L’audit final compare les snapshots,préserve les états manuels,notes,historique et flags,et exerce Store.task/Store.copy_text. Il n’est pas un test de l’interface graphique. Les prérequis de traçabilité sont vérifiés ;les prérequis aval de gameplay et l’acceptation restent ouverts. Aucun code/asset runtime modifié.

Producteurs,journaux et preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision101. Les chemins E de V42 restent des références historiques en lecture seule.

## Détail par exigence

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-12.2-01 | Leashed.FindNewTarget est exercé avec rayon850,inclusif,origine de leash et gardes de roam/état. AcquisitionRange natif300 pour deux golems et1200 pour Vilemaw correspond aux profils locaux ;475 des wolves/wraiths reste une valeur locale non trouvée dans ces quatre champs. Le bloc Rust de recherche par proximité vise voies/tourelles/fontaines ;les monstres y conservent une cible existante. | Qualifier la sélection effective de Leashed ou autre script,FindTargetNearPosition et les producteurs actuels de cible de monstre ;ne pas assimiler le rayon850 du script au champ AcquisitionRange ni déclarer une absence globale sur ce seul bloc. |
| SYS-12.2-02 | damage_unit réveille les membres vivants du même camp lorsque combat_owner existe,en fixant target=source et next_ai=0. Le test Rust existant observe cette aggro partagée. LeashedCallForHelp possède un corps natif distinct de OnTakeDamage ;ses mots et constantes sont reliés,mais son appelant moteur reste inconnu. | Qualifier le dispatch natif des renforts,les équipes,types de dégâts,propriétaires et distances ;un réveil local de tout le camp ne prouve pas ces règles historiques. |
| SYS-12.2-03 | Leashed déclare850/750/750/1150 et un seuil de compteur10. La source TimerRetreat est conservée. Rust demande le retour quand distance(home)>800 ou cible absente,avec une exception pour une attaque Vilemaw engagée. | Qualifier le déclenchement natif complet,les compteurs et rayons selon le script effectivement monté ;le seuil local800 ne devient pas850 sans comparaison et acceptation. |
| SYS-12.2-04 | Le composant natif OutOfCombatRegen demande par défaut HP+0.125*MaxHP seulement si HP>0 et état non halted ;il ne plafonne pas lui-même la valeur passée à SetHP. Des taux fournis0/.25 sont conservés. Rust remet immédiatement health=max_health dans la branche home. | Qualifier le scheduler,Start/Stop,le plafonnement de SetHP et la sélection effective du composant ;la demande Lua de soin est distincte du soin moteur réalisé et du reset instantané local. |
| SYS-12.2-05 | FindNewTarget ne cherche pas de cible en AI_RETREAT,INACTIVE ou RUN_IN_FEAR ;d’autres callbacks natifs OnTakeDamage/LeashedCallForHelp restent des voies distinctes à qualifier. Rust peut attribuer une cible par dommage au camp puis la conserver dans advance_npc_ai,mais la branche home peut la vider. | Qualifier l’interruption du reset via les véritables événements natifs et leur équivalent Rust,puis tester reprise,distance,état et soin ;le refus du helper FindNewTarget ne prouve pas un refus global de reprise. |
| SYS-12.2-06 | Rust arme spawn_at une seule fois quand tous les membres sont morts ou absents,avec respawn_seconds ;un test actuel vérifie les morts partielles et la frontière du respawn. La preuve V42 de NeutralMinionDeath est relue par identité et tableaux d’instructions :une répétition de dernière mort demande à nouveau un timer dans son hôte observateur. | Qualifier l’unicité du producteur natif de mort,les timers moteur et l’ancrage initial ;les27 cas V42 sont hérités,non réexécutés ici. Garder distinct le garde local et la requête du callback original. |
| SYS-12.2-07 | GoldGivenOnDeath/ExpGivenOnDeath des sept profils correspondent aux valeurs locales. damage_unit refuse une cible déjà morte,crédite combat_owner et réserve l’XP de monstre/boss au propriétaire ;le test Rust observe crédit exclusif et or. Les bonus autel et récompenses globales sont séparés. | Qualifier les doublons et tous les producteurs de dégâts,les crédits de pets et modificateurs natifs ;les champs de base exacts et le test courant ne prouvent pas l’économie complète ni son acceptation. |

Reçu : docs/reference_monster_behavior_sources/monster_behavior-links.json. Livraison : docs/fidelity_registry_monster_behavior_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
