# SYS-01.2-02 — Priorités/escalade des tours et soins/protections des fontaines, V473

Seize fiches sont enrichies : AI-PRIORITE et AI-ESCALADE pour les six définitions de tours, AI-SOIN et AI-PROTECTION pour les deux fontaines. Les liens aux sources, les fonctions actuelles et les limites sont intégrés aux deux bases du plan. Aucune de ces fiches n’est déclarée terminée par ce seul travail.

## Tours : frontière actuelle et règle encore non démontrée

Cinq fonctions de Turret.luaobj sont reparsées et comparées au relevé V472 : OnCallForHelp, OnReceiveImportantCallForHelp, TimerFindEnemies, PutTargetInTargetList et UpdateTargetList. Leurs constantes et empreintes de bytecode correspondent. Leur disponibilité ne prouve pas le dispatcher effectif des tours TT ni toutes les conditions de représailles.

Le code communautaire TurretAI.CheckForTargets contient une classification et une branche examinant un champion ennemi qui cible un champion. Il reste une référence communautaire, distincte du serveur Riot et du moteur Rust actuel.

Dans le chemin Rust inspecté, le choix porte sur l’ennemi admissible le plus proche. Le chemin d’attaque prend Unit.damage pour construire Pending. Ces deux points sont désormais liés aux fiches comme frontières partielles : ils ne prouvent ni une reprise de cible après l’agression d’un allié, ni une escalade des dégâts avec remise à zéro.

Le relevé conserve les corps Unit, Pending et advance_npc_ai, ainsi que les recherches bornées dans world.rs, damage.rs, attacks.rs et combat.rs. Aucun compteur d’impacts successifs ni appel d’aide propre aux tours n’y a été identifié. Cette observation ne constitue pas une recherche exhaustive de toute implémentation possible dans le dépôt.

Douze liens au chargeur générique Map10 restent conservés dans l’historique, mais sont affichés hors de la portée démontrée pour ces comportements. Les deux points précis existants gardent provides_feature_consumer=false. Aucun rôle global n’est modifié pour masquer une lacune.

## Pistes natives qui ne suffisent pas à établir l’escalade

Le fichier S5Test_TowerWrath.luaobj est présent et reparsé. Le chunk inspecté contient des métadonnées et des noms d’effets, sans fonction enfant. Son nom ne prouve aucune liaison à la formule d’escalade des tours TT.

Les douze libellés/description des objets 1500 à 1505 sont relus dans fontconfig_en_GB.txt. Ils désignent notamment pénétration d’armure, fortification, armure renforcée et détection. Ils ne fournissent pas à eux seuls la formule d’impacts successifs, son plafond ou son reset. Ces pistes sont enregistrées comme références non liées à la règle, pas comme couverture native acquise. La source effective et le consommateur de l’escalade restent à établir.

## Fontaines : le soin réel et ses limites

La boucle normale appelle advance_interactions. Elle programme le prochain soin à partir du tick courant, lit le point de départ de chaque équipe, sélectionne les champions vivants dans un rayon de 1000 et ajoute 15 % de leur santé maximale toutes les secondes, avec plafonnement. Le résultat santé est multiplié par received_multiplier, qui combine les politiques locales Ignite et Trundle W. Le calcul ne passe pas par Simulation::heal : seule la fonction de modificateur est partagée.

Pour les ressources, restores_resource admet Mana et Energy. Le même pourcentage est ajouté à la ressource maximale avec plafonnement ; le modificateur de soins reçu n’est pas appliqué au mana dans cette formule. Ces constats décrivent le code présent, pas une qualification de toutes les règles historiques.

Les constantes concordent avec le Fountain.cs communautaire fourni : 0.15 et fréquence 1000 ms. Le code communautaire vérifie son équipe et ParType ; son point de fontaine et son traitement du temps restent distincts du point de départ et des ticks utilisés localement. La source native 4.20 des constantes, des conditions et des positions effectives reste à qualifier.

Le test existant interactions::tests::fountain_only_heals_living_allies_without_overheal a été lu. Il injecte santé/mana et ticks, vérifie un allié soigné, un ennemi non soigné par cette fontaine, un mort inchangé et le plafonnement. Il n’est pas exécuté dans V473 et ne sert pas de preuve de réussite actuelle.

## Protection : distinguer bâtiment, défense et joueur

La fontaine est localement protégée inconditionnellement par protected ; son attaque passe par le ciblage et la résolution partagés. La portée native stockée 1200 est relue pour les deux définitions. Cela ne démontre pas toutes les règles de protection de la zone, de pénétration, de cadence ou d’état des joueurs.

ProtectionManager.HandleFountainProtection, dans le code communautaire, applique ou retire des bonus défensifs à un champion selon sa déconnexion. Fountain.Update appelle cette méthode après sa branche de restauration de ressource. Cette règle est séparée de l’immunité du bâtiment et n’est pas présentée comme une protection générale des alliés dans Rust, ni comme une preuve Riot.

## Vérifications et préservation

- Cinq callbacks natifs et un chunk de métadonnées relus ; douze lignes de localisation et quatorze ancres de consommateurs vérifiées.
- Cinq refus du collecteur : définition non-fontaine, type incorrect, équipe incorrecte, script d’IA tronqué, buff tronqué.
- Dix-sept sélecteurs nominaux et dix-huit invalides ; sept refus publics concernant propriétaire/statut/condition de résolution et fausse qualification de portée.
- Les 42 214 textes de traçabilité sont comparés : 16 changés, 42 198 identiques. Les sorties des autres fiches restent identiques, hors enrichissement de SYS.
- Publication et audit indépendant réussis : 17 fiches par base ; 42 606 états/notes et 23 historiques préservés exactement, 42 589 autres lignes du catalogue inchangées ; intégrité SQLite correcte.

Le lot ajoute huit liens natifs, 44 liens consommateurs, six nouvelles ancres de soin, deux sources documentaires et seize questions propres. Douze liens génériques sont requalifiés sans suppression. Aucune inconnue n’est résolue, aucun gameplay ou asset n’est modifié, aucune case n’est cochée. Aucun build, moteur natif, test Rust, client graphique ou runtime CSharp n’est exécuté.

## Livrables et suite

Reçu : docs/reference_turret_sources/turret-priority-fountain-v473.json. Preuve : docs/fidelity_turret_priority_fountain_v473.json. Les quatre registres, les fiches des deux bases, la couverture et la reprise sont actualisés. Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision473 et revision473_delivery.py, revision473_check.py, revision473_finish.py dans son parent.

Continuer les fiches AI/ACCEPT des huit bâtiments, en consolidant leurs propres exigences et refus, puis les modèles, textures, animations et sons. Le sous-inventaire du chargeur contient 450 associations à examiner, 74 partiellement qualifiées et 16 exclusions (quatre audio, douze comportements). Ce n’est pas le compteur d’achèvement du jeu. Le champ previous_scope_exclusions conserve désormais toutes les exclusions ; previous_audio_exclusions garde uniquement les quatre anciennes fiches audio. Le Goal reste actif.
