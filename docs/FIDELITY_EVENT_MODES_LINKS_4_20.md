# V94 — Modes temporaires : sources, candidats et consommateurs

Périmètre : SYS-01.2-02, six exigences SYS-11.4. Ce lot livre la traçabilité des sources et des frontières actuelles ; il ne valide ni l’activation historique des événements, ni leur implémentation. Les six exigences et le Goal restent ouverts.

## Récupération native vérifiée

AirGeneratedContent.swf était absent des emplacements D/F/E inspectés. Le manifeste AIR lol_air_client0.0.1.119 attend63377octets et MD5fd8778eedf8d83e22f34660ac37fc166. L’index d’archive identifie précisément live/projects/lol_air_client/releases/0.0.1.119/files/assets/swfs/AirGeneratedContent.swf (ligne585780,fileId2A6420560EC49057). Deux requêtes HTTP par plages bornées ont récupéré sept fragments (descripteur et contenu),avec vérification206,Content-Range,tailles et décompression. Le fichier final correspond au manifeste ;provenance et empreintes sont conservées dans reference_event_modes_sources/recovery.json et archive-index.json.

JPEXS26.4.0 a exporté une seule classe FeaturedGameGeneratedData avec code de sortie0. Java,les JAR,le SWF et l’export sont identifiés dans decompilation.json. Cette opération analyse le fichier ;elle n’exécute pas le client AIR. Les profils,sorties et caches de ce travail sont sur F. Les archives E sont lues sans modification.

Le lecteur vérifie également17exports AIR antérieurs contre3bibliothèques et leur appartenance au manifeste. Il ne prétend pas les avoir redécompilés. Bilan :82sources épinglées,210contrôles source,13ancres actuelles et35cas du lecteur dont34refus. Le vrai lecteur de manifeste refuse aussi une copie modifiée du SWF,une mauvaise release et un membre absent.

## Deux catalogues distincts

| Clé | Données générées | Classe dans la factory |
|---|---|---|
| asc | mode ASCENSION | AscensionGameFlowVariant |
| fbl | mode FIRSTBLOOD | FirstBloodGameFlowVariant |
| nbots | mutateur NightmareBots | NightmareBotsGameFlowVariant |
| ofa | mutateur OneForAll | OneForAllGameFlowVariant |
| ofax | mutateur OneForAllX | OneForAllXGameFlowVariant |
| sr6 | mutateur6v6 | absente de cette table |
| tt6 | mutateur6v6 | HexakillGameFlowVariant |
| tagteam | mutateur TagTeam | FeaturedGameFlowVariant |
| urf | mutateur URF | UrfGameFlowVariant |
| ppp | absente des données générées | PPPGameFlowVariant |

Il y a neuf définitions générées et neuf clés dans la factory,soit dix candidats dans leur union. Ce ne sont pas dix événements actifs. La factory parcourt les données générées,puis associe seulement les clés ayant une classe connue. sr6/ppp restent distincts ;aucune ligne n’est ajoutée pour masquer l’écart. La présence du code sr6 dans HexakillGameFlowVariant ne remplace pas son absence dans initializeGameKeys.

GeneratedContentLoader charge /assets/swfs/AirGeneratedContent.swf,instancie FeaturedGameGeneratedData et transmet key,gameMode,gameMutators. addFeaturedVariants prend le premier mutateur lorsqu’il existe. findVariantForMutator choisit le premier mutateur reconnu,puis le mode,puis INVARIANT. Ces chemins statiques ne démontrent pas l’ordre ou le payload d’une session historique.

## Disponibilité historique laissée inconnue

FeaturedGameFlowVariant.isEnabled consulte EnabledMutators lorsque le mutateur est non vide,sinon EnabledModes. MutatorsConfiguration demande une configuration dynamique avec défautfalse ;il accepte un tableau ou une chaîne JSON et garde le refus en cas de liste absente ou non correspondante. Le catalogue généré ne fournit pas cette activation.

Des recherches web ciblées n’ont fourni aucune preuve primaire datée d’activation EUW adoptable dans ce lot. Les résultats communautaires ou postérieurs ne sont pas utilisés pour fixer une date ;l’ouverture d’une page wiki a été refusée par robots.txt. Voir web-search-notes.json. La date de build ne devient pas une date de déploiement,et chaque candidat conserve historical_EUW_activation=unknown.

## Paramètres client, règles et ressources

Les classes de variantes contiennent des overrides de partie custom : Ascension demande CrystalScar et taille5 ;FirstBlood HowlingAbyss et taille2 ;Hexakill taille6 et choix de carte selon sa clé. Urf/PPP,OneForAll et OneForAllX choisissent des IDs de sélection différents. Les constantes exactes et branches sont dans le reçu. Le texte décompilé Hexakill contient une affectation _gameKey = "tt6" dans la brancheelse ;ce lot conserve cet export sans prétendre avoir exécuté le bytecode ni qualifier un bug historique.

NightmareBots distingue trois libellés/icônes et le profil des bots ;ces références ne prouvent pas l’inventaire complet des ressources ni leurs effets. Les overrides de sélection/carte/taille ne constituent pas une liste de champions ou d’objets interdits. Le consommateur local play valide le catalogue global et les sorts ;map10_available concerne Map10. Leur présence n’implémente pas des restrictions par événement.

Les consommateurs canonical_task_key,Store.task et Store.copy_text sont reliés comme frontières de plan. Aucune tâche nouvelle d’événement confirmé n’est créée :la confirmation datée et le découpage précis des règles/ressources restent à faire. Aucun identifiant existant n’est réattribué.

## Fin et abandon

QuitPracticeGameAction appelle quitGame. Seul onQuitGameSuccess réinitialise la carte,nettoie et retourne au flux de partie custom ;onServiceRequestError signale l’échec. MasterGameController distingue GAME_OVER et le contrôleur de résultats. Ces chemins génériques ne sont pas une recette spécifique à chaque événement.

Le superviseur Rust local distingue reprise,session rejointe et session détenue. abandon refuse une session rejointe ou un client encore ouvert,avant run.drain ;resume conserve ses gardes. capture_final_results capture le résultat local. Aucun processus de jeu n’a été lancé pour ce lot,aucun retour visuel ni scénario réseau n’est revendiqué.

## Conservation et travail restant

Les registres et deux bases reçoivent uniquement les métadonnées/consignes de ces six exigences et du Goal. Les anciennes preuves,états manuels,notes,historique et indicateurs de validation sont conservés. Les inconnues sont précisées,sans clôture. Le travail restant est indiqué pour chaque tâche ci-dessous. Le périmètre D11 d’activation reste un prérequis ouvert pour l’implémentation des événements ;ce lot D01 de traçabilité ne le valide pas.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-11.4-01 | AirGeneratedContent.swf récupéré correspond au manifeste AIR119 et déclare neuf candidats. La factory possède neuf clés différentes : sr6 seulement généré,ppp seulement dans la factory. GeneratedContentLoader et addFeaturedVariants relient ces deux sources. Le roster courant et le lecteur de date restent des frontières ; aucune annonce datée primaire EUW adoptée. | Recenser les annonces primaires datées et leurs régions,relier les événements réellement actifs aux configurations ; conserver les deux ensembles de candidats distincts et ne pas prendre une date de build pour une activation. |
| SYS-11.4-02 | FeaturedGameFlowVariant.isEnabled lit EnabledMutators ou EnabledModes via MutatorsConfiguration,avec défautfalse. La liste effective doit être fournie par DynamicClientConfigManager ; le SWF généré ne remplace pas ce payload. Les consommateurs locaux de date/service définissent des limites et ne qualifient aucun événement actif. | Établir une décision datée par candidat avec payload/annonce régionale ; garder chacune des activations inconnue tant que cette preuve manque. Un mode absent de la factory ne suffit pas à prouver son absence globale. |
| SYS-11.4-03 | Les variantes définissent des paramètres client de custom : sélection,carte et parfois taille. Les stratégies serveur restent distinctes. canonical_task_key et Store.task sont les consommateurs actuels de définition et lecture des fiches ; aucune nouvelle tâche événement confirmée créée par ce lot. | Après confirmation des événements retenus,créer des fiches précises de règles avec identités stables,conditions,refus et consommateurs ; ne pas créer un périmètre confirmé depuis les seuls candidats AIR. |
| SYS-11.4-04 | Le catalogue récupéré et les paramètres des variantes donnent des clés et contextes de ressources. Les titres/icônes/ressources sont référencés,mais pas un inventaire complet du mode. canonical_task_key et Store.copy_text sont des frontières du plan courant. | Recenser chaque ressource native du mode confirmé avec provenance,puis créer ses fiches précises ;une classe ou une clé ne prouve pas toutes les ressources ni leurs animations. Aucun jeu de fiches complet créé ici. |
| SYS-11.4-05 | Les overrides AIR concernent surtout picks,cartes et tailles de parties custom ;ils ne constituent pas une liste de restrictions de champions/objets. Le launcher actuel valide le catalogue global et les sorts ;map10_available applique une disponibilité Map10. | Retrouver restrictions effectives des événements confirmés,exceptions et versions serveur ;relier les consommateurs locaux par événement. Ne pas appliquer implicitement la disponibilité Map10 à tous les modes. |
| SYS-11.4-06 | QuitPracticeGameAction attend le succès de quitGame avant nettoyage et retour au flux de partie custom ;sur erreur il expose une erreur. MasterGameController distingue GAME_OVER et le contrôleur de résultats. Le superviseur local possède resume/abandon,avec gardes des processus et sessions détenues ;ces chemins ne sont pas des recettes événementielles. | Qualifier fin normale,abandon,erreur,reconnexion et retour au client pour chaque événement retenu avec preuves locales ordinaires ;conserver les restrictions du superviseur et ne pas assimiler une commande envoyée à un retour réussi. |

Reçu : docs/reference_event_modes_sources/event_modes-links.json. Livraison : docs/fidelity_registry_event_modes_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
