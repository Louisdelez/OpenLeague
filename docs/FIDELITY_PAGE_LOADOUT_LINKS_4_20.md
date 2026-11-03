# Runes, maîtrises et configuration des pages — SYS-01.2-02, V82

Les 18 exigences restantes SYS-08.1, SYS-08.2 et SYS-08.4 sont reliées à 37 points d’entrée précis. Tous restent des frontières à compléter : le code inspecté n’a pas de contrat de page. Aucun code du jeu ni asset modifié, aucune page créée et aucune tâche acceptée. Cette livraison complète les liens de sélection des sorts invocateur de V81 sans les modifier.

## Sources vérifiées

Les 17 exports ActionScript hérités correspondent aux empreintes du recensement AIR, et leurs six bibliothèques originales au manifeste exact lol_air_client 0.0.1.119. Aucun exporteur ou runtime AIR n’a été lancé dans ce lot.

Les 353 fiches sources déjà liées par V50 ont été relues : 296 INIBIN de runes, 57 INIBIN de maîtrises et 359 champs (302 statistiques de runes, 57 nombres de rangs). Les octets et l’appartenance aux manifestes sélectionnés sont vérifiés. Les valeurs natives brutes sont conservées séparément des valeurs du catalogue officiel 4.20.1 en_US, distinct de la référence EUW/en_GB. Aucune différence n’est normalisée silencieusement.

Le catalogue répartit les runes en 62 rouges, 68 jaunes, 66 bleues et 100 noires ; tiers 1 :94, tiers 2 :97, tiers 3 :105. Leur présence ne prouve ni disponibilité historique à l’achat ni inventaire possédé. Les constantes de RuneType initialisent rouge=1, jaune=3, bleu=5, noir=7 et possèdent des setters ; ce sont des IDs de type, pas des comptes de slots.

## Slots et édition de runes

RuneBookController prend la configuration des slots depuis session.summonerCatalog.spellBookConfig. RuneBookUtils.canAddToSlot compare le type et minLevel. Le placement automatique de RunesTransportationController recherche un slot vide correspondant au type et au niveau du compte ; addRuneToPage contrôle la quantité déjà utilisée. Le chemin d’ajout à un slot explicite délègue à addRuneToPage puis au DTO, sans répéter dans ce corps tous les contrôles du placement automatique. RuneSlotView possède également des contrôles de niveau. Ces sources ne constituent pas une preuve de validation serveur exhaustive.

Une page de runes ajoutée est reçue comme SpellBookPageDTO ; son identifiant, son nom et sa sélection sont séparés. La sauvegarde délègue à spellBookService.saveSpellBook. Le code du DTO removePage retire un membre : aucune garde de dernière page ou réparation de sélection n’est attribuée à ce seul corps. La table complète des niveaux de slots, la disponibilité des tiers et les réponses effectives du service EUW restent à qualifier.

## Maîtrises : autorités et limites

Pour le compte local, totalPointsToSpend vient de session.summonerTalentsAndPoints.talentPoints. Une branche de showMasteriesView, utilisée avec un DTO fourni, affecte 30 : elle ne prouve pas un plafond universel de 30 par arbre. L’augmentation contrôle le total dépensé, les points d’activation de la rangée, le prérequis et le maxRank du Talent reçu via summonerCatalog.talentTree. La fonction buildFakeMasteryTree est exclue de cette autorité.

Les maîtrises 4312 et 4313 gardent leur divergence : SpellData.Ranks=4 dans les sources natives, ranks=3 dans le catalogue. Le Talent.maxRank effectif reste inconnu ; aucune valeur n’est choisie à sa place.

MasteryBook.createPage crée un DTO et un nom fondé sur un token ; la limite de pages est remplacée depuis la session, donc l’initialiseur statique 10 ne suffit pas à établir le droit du compte. MasteryPage copie les entrées entre DTO et buffer d’édition. Cette copie n’est pas une commande utilisateur de duplication complète d’une page. La suppression refuse la dernière page et réajuste l’index ; le contrôleur vérifie la sélection puis sauvegarde. La persistance effective du service n’a pas été exécutée.

## Affichage, lancement et reprise

SpellBookPageDTO.getCombinedStats additionne les effets regroupés par displayName pour un résumé visuel. Cette agrégation localisée ne devient pas une formule de statistiques serveur. Les lecteurs de fichiers et les descriptions n’appliquent pas d’effets de runes ou de maîtrises au jeu.

SelectRunePageCommand appelle selectDefaultSpellBookPage et met à jour current/defaultPage lors du succès. MasteriesManager passe par le provider, puis le contrôleur sauvegarde la sélection. Ces appels ne décrivent pas le paquet natif complet de lancement ni la politique serveur Riot.

Le launcher local inspecté enregistre six commandes, sans CRUD de page. Ses payloads et LaunchSpec portent champion et sorts invocateur. JoinRequest et ResumeRequest n’ont pas de page ; la première structure refuse les champs inconnus, ce qui ne valide pas une page ou ses rangs. Simulation.join initialise depuis les définitions du champion, et stats calcule base, croissance, objets et effets courants. Les corps inspectés ne lisent pas de page. La reprise rattache un joueur existant, sans établir la restauration d’une configuration de pages absente de ces contrats.

Ces constats sont bornés aux points d’entrée nommés ; aucune absence globale d’implémentation n’est déduite d’un simple mot-clé. Aucun serveur, client, réseau, interface ou binaire historique exécuté dans ce lot. Les essais isolés antérieurs restent des preuves datées, pas des tests rejoués maintenant.

## Vérifications et intégration

1230 contrôles de sources/ancrages et 36 cas du lecteur, dont 35 refus attendus. Le lecteur rejette notamment une source remplacée, une rune omise, un champ modifié, un tier inventé, la résolution artificielle des caps, la confusion copie/duplication, résumé/formule serveur ou frontière/implémentation.

| Tâche | Consommateur constaté | Travail ouvert |
|---|---|---|
| SYS-08.1-01 | RuneType expose quatre IDs de couleur modifiables ; le catalogue compare296 runes de tiers1/2/3. Le launcher actuel ne propose que champion et sorts invocateur. | Qualifier la disponibilité EUW et les configurations de slots effectives ; ne pas assimiler les296 définitions à296 runes achetables. |
| SYS-08.1-02 | RuneBookUtils compare type et minLevel du slot ; le placement automatique parcourt spellBookConfig reçu de la session. Le join local ne porte pas de compte ni page. | Récupérer/qualifier la table de slots et niveaux,les restrictions de tiers et leur application serveur ; le placement explicite ne suffit pas à prouver tous les gardes. |
| SYS-08.1-03 | Le budget local AIR vient de summonerTalentsAndPoints.talentPoints ; augmentation contrôlée contre totalPointsToSpend. La branche de vue avec DTO fourni utilise30, sans prouver un plafond universel par arbre. Aucun budget/page dans le join local. | Qualifier les plafonds par compte/arbre et le payload historique ; conserver le budget global distinct des rangs et des seuils de rangée. |
| SYS-08.1-04 | AIR consomme pointsToActivate,prereqTalentGameCode et maxRank du catalogue reçu ; buildFakeMasteryTree ne fait pas autorité. Les caps4312/4313 restent inconnus malgré Ranks4 natif/catalogue3. | Qualifier le talentTree effectif et les règles serveur de prérequis/seuils ; ne pas substituer la table factice ou Ranks au DTO. |
| SYS-08.1-05 | JoinRequest strict contient champion et sorts,aucune page ; session_host appelle join_with_summoners. Le refus de champs inconnus ne valide pas une page ou un rang. | Implémenter/qualifier le contrat de pages et leur validation serveur autoritaire après qualification des règles ; conserver le refus de protocole distinct du refus sémantique. |
| SYS-08.2-01 | AIR ajoute une page reçue du service et conserve pageId,name,current ; le launcher local n’expose aucun CRUD de page dans ses commandes inspectées. | Définir création et nom local selon les contraintes historiques qualifiées,persistance et identité ; ne pas utiliser la base des tâches comme inventaire de compte. |
| SYS-08.2-02 | Le DTO de rune contient les slots ; saveSpellBook délègue au service. Le chemin Tauri actuel ne reçoit pas ces entrées. | Ajouter édition,sauvegarde atomique et erreurs de pages après qualification type/niveau/quantité ; vérifier relecture réelle. |
| SYS-08.2-03 | MasteryBook.createPage crée un DTO et un nom par token ; maxMasteryPagesAllowed est remplacé depuis la session. Aucune commande de page locale inspectée. | Qualifier limites et noms,puis créer/persister des pages locales ; ne pas fixer10 depuis le seul initialiseur statique. |
| SYS-08.2-04 | MasteryPage copie les entrées DTO dans un buffer volatile et les recopie à la sauvegarde ; MasteriesController appelle saveMasteryBook. Aucun éditeur de rangs local inspecté. | Implémenter édition/relecture des rangs et refus sémantiques ; les entrées copiées ne prouvent pas une application d’effets. |
| SYS-08.2-05 | Les copies ObjectUtil de MasteryPage isolent les buffers d’édition ; elles ne démontrent pas une commande utilisateur de duplication d’une page. LaunchSpec ne stocke pas de pages. | Qualifier la duplication demandée,allouer une identité indépendante et vérifier l’absence de partage mutable ; aucune duplication native complète déduite de la copie du buffer. |
| SYS-08.2-06 | MasteryBook refuse la suppression de la dernière page et réajuste l’index ; validateCurrentPage rétablit une sélection. SpellBookDTO.removePage retire seulement le membre dans ce corps. | Implémenter suppression/persistance en conservant une sélection valide et qualifier séparément runes/maîtrises ; ne pas attribuer au DTO rune la garde mastery. |
| SYS-08.2-07 | Les302 champs de runes sont relus comme données ; Simulation.join initialise depuis la définition du champion et stats calcule base/croissance/objets/effets sans entrée de page dans ce chemin. | Qualifier l’application et l’ordre des bonus de runes puis les vérifier au premier tick ; le résumé AIR et le lecteur de sources ne réalisent pas les effets serveur. |
| SYS-08.2-08 | Les57 Ranks et leur catalogue sont relus ; le join et stats inspectés n’ont pas de page de maîtrises. Les deux divergences de caps restent ouvertes. | Qualifier et appliquer chaque effet/condition/ordre des maîtrises ; aucune formule serveur inférée des descriptions ou du nombre de rangs. |
| SYS-08.4-01 | SelectRunePageCommand appelle selectDefaultSpellBookPage et met à jour current/defaultPage sur succès. Le payload local play et JoinRequest ne portent pas de page. | Transmettre et valider l’identité/contenu/version de page rune retenue ; la sélection de service AIR ne prouve pas le paquet de lancement natif. |
| SYS-08.4-02 | MasteriesManager appelle setSelectedPageByID puis MasteriesController sauvegarde le livre ; le payload local join_local et JoinRequest ne portent pas de page. | Qualifier/transmettre la page de maîtrises et l’autorité de son contenu ; aucun protocole Riot déduit de ce provider client. |
| SYS-08.4-04 | SpellBookPageDTO.getCombinedStats somme les effets par displayName pour l’affichage. Les statistiques du jeu local n’ont pas d’entrée de page. | Comparer affichage et calcul serveur au premier tick pour toutes les familles,arrondis et conditions ; ne pas adopter l’agrégation localisée du résumé comme formule serveur. |
| SYS-08.4-05 | AIR conserve la sélection dans les livres/providers ; le superviseur local ne conserve que champion/sorts/capacités de session. Aucun état de page dans LaunchSpec inspecté. | Implémenter et vérifier conservation des pages après retour,redémarrage et erreurs ; le maintien des seuls sorts ne couvre pas la configuration complète. |
| SYS-08.4-06 | La reprise locale rattache le contexte de joueur existant ; ResumeRequest contient version,contexte,clé et nonce,sans pages. La présence d’un mécanisme de reprise ne prouve pas leur restauration. | Ajouter pages et version de configuration à l’état autoritaire,puis vérifier reconnexion et refus d’une modification concurrente ; payload/reprise historique non qualifiés. |

Reçu : docs/reference_page_loadout_sources/page_loadout-links.json. Livraison : docs/fidelity_registry_page_loadout_links_revision_4_20.json. Les 18 périmètres et le Goal restent ouverts.
