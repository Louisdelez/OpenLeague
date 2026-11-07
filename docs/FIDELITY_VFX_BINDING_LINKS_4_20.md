# Gameplay et effets — traçabilité V115

Sept exigences reliées à leurs consommateurs actuels ;aucune complétude native ou visuelle déduite.

# V115 — Impacts Q acceptés

Huit tests Rust exécutés et réussis. Réception OLSR,époque,visibilité,pause,fraîcheur,conflits et rejeu sont contrôlés.

- Admission uniquement depuis contexte accepté OLSR ;pas de hit inféré de la mort ou disparition. `F:\OpenLeague\crates\client\src\ezreal_q_flash_events.rs:67`

- Consommation bornée32 événements,6 propriétaires,délai3 ticks local ;naissances en pause écartées. `F:\OpenLeague\crates\client\src\ezreal_q_flash_events.rs:174`

- Appel réel depuis réception snapshot avant regroupement. `F:\OpenLeague\crates\client\src\main.rs:1181`

- Consommation réelle par adaptateur visuel ;contrôle FoW du dessin indépendant. `F:\OpenLeague\crates\client\src\ezreal_q_flash_live.rs:168`

Les budgets et échéances sont locaux. L’identité serveur acceptée ne prouve pas la fidélité native de tous impacts. Pas de GPU exécuté ni qualification ArrivalHeads déduite. Restent casts,trajectoires,buffs,zones,skins et formes,comparaison effective des candidats.


# V115 — Cast et projectile W

Dix tests Rust passent :six sélection cast,quatre présentation projectile.

- Observation de chaque cast accepté avant regroupement ;conflits Q/W/R retirés. `F:\OpenLeague\crates\client\src\ezreal_w_cast_animation.rs:48`

- Consommation réelle du cast W par sélection animation ;âge1x local. `F:\OpenLeague\crates\client\src\animation.rs:750`

- Position/direction/hauteur provenant de trame OLSR acceptée ;époque et identité vérifiées. `F:\OpenLeague\crates\client\src\ezreal_w_missile_presentation.rs:28`

- Échantillons serveur consommés par effet vivant ;pause et fraîcheur locales distinctes. `F:\OpenLeague\crates\client\src\ezreal_w_missile_live.rs:205`

Le délai releases-8 est local,la fraîcheur projectile0.2s locale. Aucun événement natif serveur ou rendu GPU exécuté. Ce résultat couvre ces consommateurs W,non tous les champions ni leurs variantes.


# V115 — Buff Courage

Treize tests Rust du contrôleur soutenu passent.

- Observation ordonnée par session,époque et trame ;contrat serveur local Courage. `F:\OpenLeague\crates\client\src\garen_w_state.rs:84`

- Âge visible et durée depuis identité started/end ;retiré après expiration. `F:\OpenLeague\crates\client\src\garen_w_state.rs:153`

- Mort,respawn et courage_until expiré refusent une identité active. `F:\OpenLeague\crates\client\src\garen_w_state.rs:166`

- Consommateur vivant du buff soutenu ;appelant natif des six effets non reconstitué. `F:\OpenLeague\crates\client\src\garen_w_live.rs:132`

Contrat local distinct des six effets natifs et du rendu complet. Aucun GPU exécuté. Recherche initiale zones par .zones/PersistentZone/ZoneVisual/zone_effect dans core/client sans résultat ;ne prouve pas absence de tout consommateur,continuer avec les structures gameplay réelles.


# V115 — Zones et variantes

Onze tests Rust passent :dix Trundle W,un alias natif avec360 cas hérités.

- Zone gameplay propriétaire/centre/début/fin ;rayon1000 reconstruction communautaire explicite. `F:\OpenLeague\crates\core\src\trundle_w.rs:93`

- Consommateur animation du lancement/identité de zone ;pas preuve de rendu persistant de surface. `F:\OpenLeague\crates\client\src\trundle_w_animation.rs:97`

- Alias _SkinNN conditionné au propriétaire et disponibilité fournie ;360 cas natifs hérités vérifiés. `F:\OpenLeague\crates\core\src\native_effect_resource_skin_alias.rs:7`

- Descripteur visuel Garen limité au skin de base ;autres variantes non qualifiées. `F:\OpenLeague\crates\client\src\garen_w_profile.rs:14`

La recherche initiale par noms de zones était insuffisante :Effects.trundle_w contient effectivement une Zone. Ne pas conclure que toutes zones visuelles existent à partir du gameplay/animation. La recherche du module alias dans crates ne trouve que sa déclaration lib.rs ;activation depuis les effets courants non identifiée,formes encore ouvertes. Aucun GPU ni processus natif exécuté.


# V115 — ArrivalHeads et flash Q actuels

Quatorze tests passent :profil ArrivalHeads2,hôte ArrivalHeads5,hôte flashQ7. Ressources DDS,admissions,pertes de permission/époque,connexion,caméra et pause exercées en hôte CPU.

- Deux groupes ArrivalHeads lus avec contrôle des octets originaux ;attachement et départ locaux. `F:\OpenLeague\crates\client\src\ezreal_e_arrival_heads_profile.rs:30`

- ArrivalHeads déjà intégré au client courant ;ne pas traiter comme absent. `F:\OpenLeague\crates\client\src\main.rs:743`

- Flash Q déjà intégré ;tests CPU ne prouvent pas rendu GPU. `F:\OpenLeague\crates\client\src\main.rs:738`

- Politique locale nommée map10_e_committed_arrival_heads_ground_local_v1. `F:\OpenLeague\crates\client\src\ezreal_e_arrival_heads_profile.rs:8`

Le libellé de tâche avant intégration ne doit pas masquer les plugins présents. Cette observation ne clôture pas la qualification des candidats :rendu GPU actuel,comparaison native et acceptation restent distincts. Aucun asset ni code produit modifié.


## Qualification

60 fichiers,141 contrôles,32 cas lecteur dont31 refus.56 tests Rust conservés ;aucun GPU ou processus natif exécuté.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-15.2-01 | Observation de chaque cast accepté avant regroupement ;conflits Q/W/R retirés. Consommation réelle du cast W par sélection animation ;âge1x local. | Bounded W cast selection only;all spell launch effects and native timing remain open. |
| SYS-15.2-02 | Position/direction/hauteur provenant de trame OLSR acceptée ;époque et identité vérifiées. Échantillons serveur consommés par effet vivant ;pause et fraîcheur locales distinctes. | W exact current server position only;all projectile trajectories/native interpolation remain open. |
| SYS-15.2-03 | Admission uniquement depuis contexte accepté OLSR ;pas de hit inféré de la mort ou disparition. Consommation réelle par adaptateur visuel ;contrôle FoW du dessin indépendant. | Q accepted impact presentation only;all impact effects and native visibility remain open. |
| SYS-15.2-04 | Observation ordonnée par session,époque et trame ;contrat serveur local Courage. Consommateur vivant du buff soutenu ;appelant natif des six effets non reconstitué. | Sustained Courage only;native six-effect caller and all buff lifecycles remain open. |
| SYS-15.2-05 | Zone gameplay propriétaire/centre/début/fin ;rayon1000 reconstruction communautaire explicite. Consommateur animation du lancement/identité de zone ;pas preuve de rendu persistant de surface. | Gameplay zone and cast animation do not identify the complete persistent surface renderer. |
| SYS-15.2-06 | Alias _SkinNN conditionné au propriétaire et disponibilité fournie ;360 cas natifs hérités vérifiés. Descripteur visuel Garen limité au skin de base ;autres variantes non qualifiées. | Native alias resolver exists but active visual dispatch and form selection are not identified;Garen descriptor is base-only. |
| SYS-15.2-07 | ArrivalHeads déjà intégré au client courant ;ne pas traiter comme absent. Flash Q déjà intégré ;tests CPU ne prouvent pas rendu GPU. | ArrivalHeads and Q plugins already installed;CPU host tests do not qualify current GPU/native visual fidelity or human acceptance. |

Reçu : docs/reference_vfx_binding_sources/vfx_binding-links.json. Livraison : docs/fidelity_registry_vfx_binding_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
