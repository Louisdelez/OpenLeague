# SYS-01.2-02 — Sources et récompenses des monstres Map10, V495

Projet F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Objectif : relier chaque exigence à sa source native et à son consommateur actuel, en conservant les limites. Aucune fiche, case, acceptation humaine ou partie complète n’est clôturée par ce travail.

## Résultat

Les fiches SOURCE et AI-MORT des sept types TT_NGolem, TT_NGolem2, TT_NWolf, TT_NWolf2, TT_NWraith, TT_NWraith2 et TT_Spiderboss sont désormais directement reliées aux consommateurs existants de création des camps et d’attribution des récompenses. Les anciens31liens des fiches SOURCE et12liens AI-MORT sont conservés, avec leur qualification propre : métadonnées, entrée et comportement ne sont pas interchangeables.

Aucun consommateur nouveau n’a été implémenté ;154liens supplémentaires pointent vers les fonctions déjà présentes.30liens natifs sont ajoutés. Les35fiches de camps V479/V480 et leurs questions sont conservées exactement. Les14nouvelles questions détaillent les limites propres à chaque monstre et à chaque exigence.

## Sources et contrôles réellement exécutés

175champs courants,25par type, comparés à leurs observations typées V250 : valeurs courantes, catégories, provenance et distinction champs lus/métadonnées préservées. Le lecteur INIBIN relit les fichiers natifs et vérifie114observations de présence/absence/valeur, y compris les deux sorts de projectile des wraiths dans leur fichier de sort distinct.28champs de récompenses supplémentaires sont revérifiés :16présents et12absents. Une absence reste une absence, sans substitution par un zéro natif.

| Catégorie des175champs | Nombre | Portée |
| --- | ---: | --- |
| Copie numérique native de personnage |70| Valeur source retrouvée ; ne prouve pas tous les effets serveur |
| Copie numérique native de sort |2| Vitesse de projectile ; fichier distinct du personnage |
| Transformation locale de timing compatible |14| Formule/ticks locaux, pas horloge native qualifiée |
| Défaut local pour champ natif absent |21| Défaut conservé et explicitement signalé |
| Upgrades non-lane locaux à zéro |42| Politique locale, pas règle historique retrouvée |
| Vitesse de projectile locale à zéro |5| Politique locale de trajet instantané |
| Identité locale |7| Métadonnée |
| Enum local avec contexte UnitTags |7| Classification locale |
| Référence de modèle locale |7| Géométrie/matériaux/runtime non qualifiés par ce contrôle |

Les preuves V479 d’apparition et réapparition et V480 de récompenses ont été réidentifiées par taille/SHA-256, avec leurs bibliothèques, ressources, outils, binaires, journaux et entrées. Leurs entrées concordent toujours avec le projet courant. **Aucun de ces scénarios n’a été rejoué dans V495**, aucun nouveau build ni runtime de jeu n’a été lancé. Les112scénarios et272morts sont hérités, puis filtrés par définition exacte ; les résultats attendus/observés et refus de doublons sont vérifiés dans les observations conservées.

| Type | Camps | Événements de mort hérités | Or local / XP de base | Or global courant |
| --- | --- | ---: | --- | --- |
| TT_NGolem |2,5|32|48 /150|0, défaut natif absent |
| TT_NGolem2 |2,5|32|38 /42|0, défaut natif absent |
| TT_NWolf |3,6|32|28 /144|0, défaut natif absent |
| TT_NWolf2 |3,6|64|14 /12|0, défaut natif absent |
| TT_NWraith |1,4|32|33 /120|0, défaut natif absent |
| TT_NWraith2 |1,4|64|18 /48|0, défaut natif absent |
| TT_Spiderboss |8|16|25 /400|190, présent dans la source native |

Les scénarios hérités couvrent les deux équipes et différents producteurs contrôlés : joueur, propriétaire de Tibbers, tueur mort/éloigné, unité sans propriétaire et bonus d’autels. Les primes observées correspondent aux assertions du test ; le second appel sur la même unité morte ne donne aucun nouveau gain. Le comportement d’une API de dégâts contrôlée ne qualifie pas les règles ordinaires de portée, partage ou ciblage de ses appelants.

Le camp de Vilemaw contient une seule unité : le contrôle « mort partielle du camp » est inapplicable et reste false, distinct des six camps à plusieurs unités. Les preuves de réapparition ont de nouveaux identifiants et des limites d’horloge explicites. Le délai local part de la détection du dernier mort ; le montage et l’horloge du serveur historique ne sont pas démontrés.

## Limites ouvertes

- Vilemaw : récompenses de base présentes et texte natif TTBossBuff retrouvé. L’application du buff, sa durée, ses destinataires et ses effets complets restent non établis.
- Wolves/wraiths : acquisition locale475 sans champ AcquisitionRange retrouvé dans ces profils. Une valeur locale n’est pas convertie en valeur native par cette liaison.
- Résistance magique, récompenses globales et autres défauts absents restent classés par champ. Le modèle et la présentation ont leurs propres fiches à poursuivre.
- Zéros d’upgrades des monstres, transformations d’attaque en ticks et règles de partage/récompense restent des politiques locales ou des correspondances partielles.
- Horloge initiale, positions/hauteurs effectives, sélection des scripts et règles de réapparition natives restent à qualifier. Les observations de navigation et scénarios contrôlés sont distincts d’une partie historique.
- Aucune nouvelle preuve GPU, animation, audio, réseau ou validation humaine. Aucun asset manquant n’est déduit de cette absence de preuve.
- Les preuves privées F:/OpenLeague-work et les binaires antérieurs constituent des dépendances locales ; leur portabilité n’est pas démontrée.

## Vérification du registre et des consommateurs publics

42214instructions comparées,14modifiées,42200inchangées. Les35fiches de camps et questions héritées restent exactes.1274identités de fichiers revérifiées.15sélecteurs nominaux,16sélecteurs invalides refusés,4contrôles négatifs de profil/champ natif et3refus du registre public : mauvais propriétaire, faux statut résolu, condition de résolution absente. Les conditions de fin, dépendances et préfixes historiques sont conservés.

Publication et relecture indépendante des quatre registres et des deux bases requises avant le point de reprise final. L’intégrité SQLite, les cases, notes utilisateur,23historiques et les autres lignes sont contrôlés par le vrai Store.task/copy_text en lecture seule. Aucune modification du moteur ou des assets de jeu.

## Anomalies conservées

Deux lectures exploratoires ont présumé une structure liste/cases : les camps sont un dictionnaire et la preuve spawn utilise une clé camps. Les lectures ont été corrigées sans modifier les preuves.

La première préparation a refusé le contrôle de mort partielle appliqué à Vilemaw seul. Le dossier de préparation n’existait pas encore, les registres et bases n’avaient pas été modifiés. Le contrôle corrigé exige true uniquement pour les camps à plusieurs unités et false pour le boss seul. Le script initial est conservé dans revision495_delivery.initial_failed.py ; les observations héritées n’ont pas été réécrites. La seconde préparation et les contrôles candidats ont réussi.

## Livrables

- docs/reference_monster_behavior_sources/monster-source-death-v495.json :14associations,175champs, références et événements exacts par type, limites et identités.
- docs/fidelity_monster_source_death_v495.json :preuve de publication et des deux bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json :intégration du registre, historique conservé.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md :reprise mise à jour.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision495 :baselines,préparation,contrôles candidats,audit et point de reprise.

Le goal reste actif. Suite :consommateurs précis de ciblage et poursuite des sept monstres, en recoupant V481 et les scripts natifs, sans confondre la conservation d’une cible avec son acquisition.

Bilan final vérifié :30liens natifs,154liens consommateurs existants,0ancre,1source,14questions ouvertes,0résolution. Graphe :98671sources/2542consommateurs/25746inconnues ouvertes/5517résolues avec historique. Deux bases :15lignes documentaires actualisées,42591autres lignes exactes,42606états/notes et23historiques conservés,intégritéok. Sous-inventaire105à reprendre,403partielles,32exclusions ouvertes ;aucun pourcentage de jeu terminé. Publication et audit réussis.
