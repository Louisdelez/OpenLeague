# Invocations : sources et consommateurs — V102

Objectif SYS-01.2-02. Sept exigences SYS-12.3 sont reliées à15 rôles courants :six parcours partiels et une frontière de clonage. Ce travail documente les contrats et leurs limites ;il ne termine pas les invocations du jeu.

## Sources et périmètre du recensement

Neuf scripts originaux sont vérifiés contre les manifestes RADS sélectionnés :Pet,UncontrollablePet,AzirSoldier,H28GEvolutionTurret,LuluFairyAI,MalzaharVoidling,TempMinionAI,YorickPHPet et Zone. Deux lecteurs concordent sur les tableaux d’instructions,constantes et enfants. Les affectations CLOSURE/SETGLOBAL identifient les noms lorsque cette forme est présente. Leur présence ne prouve pas leur sélection effective pour chaque unité.

24 profils candidats sont identifiés :Tibbers,soldats/disque solaire/auxiliaire Azir,deux tourelles Heimer,ShacoBox,MonkeyKingClone,trois ghouls Yorick,Voidling,Spiderling,quatre objets Zyra,LuluFaerie,œuf/mur Anivia,drapeau/mur Jarvan et pilier Trundle. Les champs Data examinés sont relevés avec présence/absence explicite ;les champs d’IA recherchés sont absents de ces24 profils. Cela ne prouve pas une absence de sélection par un autre producteur.

Les122 identités de champions actuelles ont chacune un dossier natif examiné :2492 fichiers INIBIN hors dossiers Skins. Les empreintes et l’appartenance RADS sont vérifiées. La recherche conserve les chaînes exactes et les candidats lexicaux. Les hits incluent des effets,sons et autres faux positifs ;leur présence ne vaut pas une invocation confirmée et leur absence ne prouve pas un kit sans invocation. Les clones sans profil propre,pièges et objets auxiliaires restent à classifier,notamment les familles Maokai,Teemo,Zed,Orianna,Kalista et les formes personnelles. Le sous-ensemble24 n’est jamais présenté comme exhaustif.

Le plan possède déjà96 tâches UNIT nommées pour ces24 profils,quatre par profil :SOURCE,ASSET,BEHAVIOR,SESSION. Elles sont consultées par Store.task et Store.copy_text. Les117 correspondances textuelles totales comprennent aussi15 tâches de sort et six tâches de fichier vide :ces21 lignes ne deviennent pas de nouvelles invocations. Aucune tâche ni coche n’est ajoutée ou retirée par cette étude. Les appels de création détectés dans trois fichiers communautaires (Annie R,Shaco W,Lux R) restent des candidats de ce snapshot ;Lux utilise un auxiliaire TestCubeRender. Ces sources communautaires ne sont pas une autorité native.

## Contrats actuels et observations nouvelles

Tibbers reçoit le propriétaire et l’équipe du cast. La présence du joueur suffit pour combat_owner et pour maintenir le pet :le test observe la survie après mort du propriétaire,le refus d’un ordre de joueur mort et la suppression après retrait. Un cast en attente est annulé si le propriétaire meurt. Le recast sélectionne le pet vivant non expiré du même propriétaire et conserve durée/coût/cooldown ;les valeurs par rang et la limite locale d’un Tibbers sont testées. Aucune règle générale de toutes les invocations n’en est déduite.

Le serveur courant choisit player depuis clients[peer] avant game.command ;le paquet de cette branche ne choisit pas un autre propriétaire. Il s’agit d’une lecture de la chaîne de dispatch et de tests du cœur,aucune session réseau réelle ou preuve globale d’authentification.

Trundle possède un contrat distinct de terrain temporaire avec propriétaire/équipe/début/fin. Le pilier survit à la mort sans prolongation et cesse au départ/fin ;les structures/boss sont exclus de la poussée et du ralentissement testés. Le pilier géométrique n’est pas assimilé à une unité ciblable ou à une tourelle Azir/Heimer.

Le point d’entrée des sorts non implémentés reste une frontière réelle pour le clonage. Les statistiques par rang de Tibbers,les modèles importés et les appels Rust Clone sur des structures de données ne constituent pas une copie historique des statistiques ou de l’apparence d’un champion.

## Lua original :47 cas et une limite refusée

Le module Lua5.1 identifié exécute les tableaux d’instructions originaux après adaptation des seules longueurs de chaînes size_t32 vers64. Aller-retour32 exact et empreintes de chaque tableau d’instructions sont conservés. Chaque environnement est vide puis reçoit les seules API nécessaires ;aucun jeu historique exécuté. Les états/ordres sont symboliques et les API moteur sont des observateurs.

18 cas couvrent OnInit/HaltAI des neuf scripts. Les demandes de timers diffèrent :Pet possède scan/recherche à0.15s et peur1s ;plusieurs autres ajoutent fuite0.5s ;Azir demande Update0.15s ;Lulu démarre halted et demande puis arrête peur/fuite. Ces demandes ne prouvent pas le scheduler réel.

16 cas OnOrder sur UncontrollablePet,H28GEvolutionTurret,TempMinionAI,YorickPHPet retournent littéralement true pour quatre marqueurs d’ordre,dont inconnu. Ce n’est ni une preuve d’ordre exécuté ni une interprétation du dispatcher.

11 cas Lulu/Malzahar couvrent propriétaire nul ou présent et trois ordres. Nul déclenche Die avec DAMAGESOURCE_INTERNALRAW,puis false. Lulu utilise GetOwner ;Malzahar utilise GetGoldRedirectTarget. Avec propriétaire présent,les requêtes de mouvement/retour diffèrent. Malzahar HOLD atteint exactement BetPetReturnRadius,non fourni :le banc refuse cette branche. Cette graphie existe dans les constantes originales ;elle n’est ni corrigée ni assimilée à SetPetReturnRadius. L’absence de cette API dans le moteur historique n’est pas prouvée.

Deux cas Azir Update constatent Die lorsque GoldRedirectTarget renvoie nil et aucune demande si un propriétaire existe et Active=false. Ni nullité après mort,ni animation,mouvement moteur,clonage,limite d’invocations ou disponibilité des API ne sont qualifiés par ces profils.

## Vérifications et livraison

- Sept tests Rust existants,hors ligne,nom exact et un test réussi par commande :cinq Tibbers et deux Trundle. Ticks contrôlés/navigation de test,aucun match graphique.
-47 cas Lua originaux et un refus d’API non fournie ;27 refus du lecteur binaire sur copies tronquées,en-tête altéré et octets supplémentaires.
-2578 sources et3434 contrôles source ;36 cas du lecteur de liens,dont35 refus de preuves modifiées. Ces tests de reçu sont distincts des comportements exécutés.

Le premier collecteur comparait littéralement deux casses du même chemin AniviaIceblock.inibin/AniviaIceBlock.inibin. L’échec et le lecteur initial sont conservés ;la comparaison résout désormais le chemin Windows,avec mêmes taille,SHA-256,MD5 et membre RADS exigés. Aucun échec n’est présenté comme un succès.

Les prérequis de la traçabilité SYS-01.1 sont vérifiés. Ceux du lot d’implémentation D12 (D04-SYS-04-6) et l’acceptation restent ouverts. La publication actualise seulement le lecteur,les preuves,les registres,la couverture/reprise et huit fiches dans chacune des deux bases. L’audit contrôle la conservation de toutes les coches,notes,historiques,flags et preuves antérieures,et relit les fiches/copies par Store. Aucun code/asset runtime modifié,aucun jeu/GPU/AIR/serveur communautaire exécuté.

Producteurs,journaux,empreintes des binaires et preuves :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision102. Les chemins E restent des provenances historiques lues seulement.

## Détail par exigence

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-12.3-01 | Tibbers reçoit owner et team du lanceur au spawn ;combat_owner attribue le crédit au joueur présent. Les scripts LuluFairyAI et MalzaharVoidling consultent respectivement GetOwner et GetGoldRedirectTarget,avec Die si nul. Les 24 profils natifs et neuf scripts sont identifiés,mais leur montage par invocation reste distinct. | Qualifier les producteurs natifs de propriétaire/équipe et leur stabilité sur chaque type ;GetOwner et GoldRedirectTarget ne deviennent pas des synonymes par leurs usages voisins. Étendre au clonage et aux objets auxiliaires. |
| SYS-12.3-02 | Le serveur route Command depuis clients[peer] vers game.command(player,action),sans identifiant de propriétaire fourni par cette branche. cast_tibbers sélectionne le pet du lanceur ;le guide conserve coût/cooldown et refuse une commande morte au point d’entrée. Sept tests Rust incluent propriétaire distinct. Quatre callbacks natifs OnOrder renvoient true même pour un ordre inconnu ;ce retour ne qualifie pas le dispatcher. | Qualifier les sessions réseau réelles,les commandes forgées et le dispatcher natif complet ;les enums restent symboliques. Malzahar HOLD atteint BetPetReturnRadius,API non fournie dans le banc,et reste non qualifié. |
| SYS-12.3-03 | Tibbers utilise les règles locales par rang,45 secondes,et redirige un recast vers le pet vivant non expiré. Les tests vérifient trois rangs,un seul spawn et expiration sans prime. Le pilier Trundle expire à6 secondes dans son contrat local. Les callbacks OnInit natifs demandent des timers distincts ;leur scheduling moteur n’est pas exécuté. | Qualifier durée et plafonds pour chaque invocation,les recasts concurrents et toutes les morts/expirations. Les constantes locales et commandes de timer ne prouvent pas les plafonds historiques des tourelles,plantes,ghouls ou clones. |
| SYS-12.3-04 | Le test Rust observe Tibbers survivant à la mort du joueur mais supprimé si ce joueur est retiré ;un cast encore en attente est annulé à la mort. Le pilier Trundle survit à la mort sans prolongation mais disparaît au départ/fin. Lulu/Malzahar demandent Die quand le getter fournit nil ;AzirSoldier.Update utilise GoldRedirectTarget et fait de même. | Qualifier ce que les getters natifs renvoient réellement après mort,déconnexion,reconnexion ou remplacement. Un propriétaire nul ne prouve pas une règle de mort du propriétaire ;ne pas généraliser la politique Tibbers. |
| SYS-12.3-05 | Le point d’entrée des sorts refuse actuellement les champions hors branches implémentées. Tibbers reconstruit ses statistiques par rang et ne constitue pas un clone. MonkeyKingClone.inibin et les métadonnées de kit de Shaco/Leblanc/Yorick sont des entrées natives recensées,mais ne fournissent pas à eux seuls une règle de copie des statistiques/apparences. | Identifier les producteurs effectifs de clones,les champs copiés/actualisés et les skins sélectionnés,puis leurs consommateurs actuels. Les imports de formes et les Clone Rust de structures de données ne prouvent aucun clonage de champion. |
| SYS-12.3-06 | Le pilier Trundle possède owner/team/center/rank/début/fin et agit via les cercles de navigation ;ses filtres excluent structures/boss des cibles de poussée/ralentissement. Les deux tests correspondants sont frais. Les sources Azir,H28GEvolutionTurret,Jarvan et plantes sont distinctes,avec 24 profils candidats identifiés. | Qualifier séparément terrain temporaire,unité ciblable,tourelle,plante,piège et objet visuel ;la géométrie locale Trundle ne qualifie pas les constructions Azir/Heimer ni tous les ciblages. |
| SYS-12.3-07 | Le plan contient déjà96 fiches UNIT pour les24 profils inspectés,quatre par profil,consultées par Store.task et Store.copy_text. Les122 kits sont parcourus sur2492 INIBIN hors Skins,avec candidats lexicaux conservés et absence de correspondance non interprétée comme absence d’invocation. Trois fichiers communautaires contiennent des appels de création candidats,dont un auxiliaire Lux. | Prouver l’exhaustivité par les producteurs des kits,les clones sans profil dédié,les pièges et objets auxiliaires ;classifier les faux positifs lexicaux et les formes personnelles. Les24 profils ne forment pas une liste complète et aucune fiche existante n’est supprimée ou cochée. |

Reçu : docs/reference_invocation_sources/invocation-links.json. Livraison : docs/fidelity_registry_invocation_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
