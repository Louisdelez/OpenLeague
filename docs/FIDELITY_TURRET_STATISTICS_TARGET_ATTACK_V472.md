# SYS-01.2-02 — Tours et fontaines : statistiques, ciblage et attaque, V472

24 fiches sont enrichies : SOURCE, AI-CIBLE et AI-ATTAQUE pour TT_OrderTurret1–4 et TT_ChaosTurret1–4. Les huit définitions correspondent à douze instances de bâtiments dans la configuration Map10 actuelle. Le résultat est un rattachement vérifié aux sources et aux chemins du code ; la fidélité complète du comportement reste à établir.

## Valeurs natives stockées et valeurs locales

Les huit fichiers de personnage INIBIN et les huit fichiers de sort d’attaque sont relus. Les 200 champs des définitions courantes sont comparés au relevé typé V243 ; leurs champs natifs présents ou absents sont revérifiés. Un champ absent ne devient pas une preuve de valeur par défaut. Les anciens relevés et leurs classifications sont conservés séparément.

| Définition, pour les deux équipes | PV dans le fichier natif | PV locaux | Cooldown local | Windup local |
|---|---:|---:|---:|---:|
| Turret1 | 1600 | 2350 | 37 ticks | 7 ticks |
| Turret2 | 1300 | 2050 | 37 ticks | 7 ticks |
| Turret3 | 1900 | 2650 | 37 ticks | 7 ticks |
| Turret4, fontaine | 9999 | 9999 | 1 tick | 20 ticks |

Pour les tours, les PV locaux valent donc la base native stockée plus 750. Le code communautaire Map10 attribue un bonus de 250 par joueur adverse aux tours hors fontaine. Pour trois adversaires, ce bonus donne 750. Cette correspondance ne démontre ni l’origine du générateur local, ni la règle effective du serveur Riot. Le moteur local utilise ici les PV fixes de sa définition ; son calcul d’upgrades est réservé aux sbires de voie.

Le code communautaire contient aussi des modifications programmées d’armure, résistance magique et dégâts, à partir de 480 secondes puis par pas de 60 secondes, avec des limites selon le type de tour. Cette branche est documentée comme référence communautaire, sans exécuter son moteur de statistiques ni la prendre pour une source Riot. Le niveau moyen calculé dans spawn_unit est rangé dans _spawn_level ; il ne devient pas une croissance native démontrée.

Les vitesses missile natives et locales correspondent en float32 : 1200 pour les tours et 500 pour les fontaines. Le rayon 88.4 correspond aussi en float32 ; son texte décimal n’est pas la valeur Python exacte issue du binaire. Les ticks d’attaque se reproduisent avec la formule binary64 déjà recensée, mais cela ne qualifie pas le calcul natif. En particulier, 37 ticks ne doivent pas être présentés comme une durée serveur Riot déduite du seul offset.

Les fontaines sont protégées inconditionnellement par le chemin protected courant. Leurs récompenses stockées ne constituent donc pas une preuve d’attribution via cette route de dégâts. Leur résistance magique locale 0 reste distincte de l’absence de Data/SpellBlock dans le fichier natif.

## Sélection des cibles et attaques

Sept fonctions de Turret.luaobj sont reparsées et comparées au reçu natif antérieur : OnInit, OnCallForHelp, OnReceiveImportantCallForHelp, TimerFindEnemies, PutTargetInTargetList, UpdateTargetList et HaltAI. Constantes, bornes de lignes et empreintes des instructions correspondent. OnInit contient InitTimer/TimerFindEnemies avec 0.15 ; le script contient turretTargetList et FindTargetInAcR. Le dispatcher natif effectif n’est pas exécuté ni établi par cette seule présence. Data/AI et Data/AIScript sont absents dans les huit fichiers de personnage inspectés ; cela ne prouve pas l’absence d’un dispatcher ailleurs.

Le chemin local admet les types Turret/Fountain, filtre les cibles par équipe, santé, visibilité, protection et distance acquisition+rayon, puis choisit la distance minimale. La mise à jour normale programme next_ai à huit ticks plus tard. Cette sélection du plus proche ne qualifie pas les priorités de la liste native, les appels d’aide ou l’escalade de dégâts.

L’admission d’une attaque vérifie next_attack, la santé et la portée de la cible. Le Pending mémorise Unit.damage ; le temps d’impact est calculé avec le windup et le trajet à la vitesse missile. La résolution appelle hit_result avec le type d’attaque physique. Les conditions de maintien, lancement et présence de la source sont conservées dans le relevé du corps de fonction. Aucun appel graphique ou sonore n’en est déduit.

La fontaine utilise un cooldown d’un tick et un windup de vingt ticks. Le code peut donc admettre plusieurs attaques en attente avant leur impact ; ce lot ne mesure pas cette cadence en partie et ne l’accepte pas comme native.

## Contrôles réellement exécutés

- Huit personnages et huit sorts reparsés, 200 champs locaux relus, sept prototypes Lua comparés ; 37 identités de fichiers contrôlées.
- Quarante ancres de consommateurs contrôlées dans les fichiers courants. Six nouvelles ancres distinguent admission de classe, choix de la distance minimale, rafraîchissement, capture des dégâts, disponibilité de l’attaque et protection des fontaines.
- Six refus du collecteur : mauvaise identité, mauvais type, ticks booléens, mauvaise équipe, bytecode tronqué, PV natifs modifiés.
- Vingt-cinq sélecteurs nominaux, vingt-six sélecteurs invalides refusés ; trois refus du validateur public pour propriétaire incohérent, fausse résolution ou condition de résolution vide.
- Comparaison des 42 214 textes de traçabilité par le lecteur réel : 24 changés, 42 190 identiques ; les autres fiches restent identiques hors enrichissement de SYS.
- Publication puis audit indépendant des quatre registres et des deux bases : 25 fiches par base, 42 606 états/notes et 23 historiques conservés exactement ; 42 581 autres lignes du catalogue inchangées ; intégrité SQLite correcte.

Le lot ajoute 56 liens natifs, 48 liens vers les consommateurs, six consommateurs précis, une source de preuve et 24 questions propres aux tâches. Aucune question n’est résolue. Aucun code de gameplay, asset ou case d’acceptation n’est modifié. Aucun moteur natif, client graphique, runtime Rust/CSharp, build ou test de jeu n’est exécuté dans V472. Les tests historiques restent hérités.

Une première préparation a refusé avant toute publication en raison d’un import de sélecteur incorrect (d469.select absent). L’import a été corrigé vers le sélecteur réel hérité de V468. La préparation suivante, les contrôles candidats, la publication et l’audit ont réussi ; l’échec n’est pas une preuve d’exécution du jeu.

## Livrables et limites restantes

Les registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, fidelity_unknowns_4_20.json et completion_tasks_2026-10-20.json sont enrichis, ainsi que les fiches des deux bases du plan. Reçu : docs/reference_turret_sources/turret-statistics-target-attack-v472.json. Preuve : docs/fidelity_turret_statistics_target_attack_v472.json. Scripts, sauvegardes et vérifications détaillées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision472 et les scripts revision472_delivery.py, revision472_check.py, revision472_finish.py dans son parent.

Il reste à qualifier les règles natives effectives et l’exécution ordinaire, les priorités/appels d’aide, l’escalade des dégâts et sa remise à zéro, les soins et protections de fontaine, puis la présentation et la recette des bâtiments. Les sources communautaires et les valeurs locales ne remplacent pas ces preuves.

L’inventaire particulier du chargeur Map10 comporte 466 associations à examiner, 70 partiellement qualifiées et quatre exclusions audio conservées. Ce décompte ne représente pas l’achèvement du jeu. Le Goal reste actif.
