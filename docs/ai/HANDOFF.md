# OpenLeague — goal et méthode uniquement

Dernière consigne utilisateur : arrêter toutes les modifications d’OpenLeague Plan,de son interface et de ses bases. Aucune installation,aucune migration,aucun retrait implicite. Limiter l’amélioration au goal,aux critères de clôture et à la méthode.

Autorité : docs/audit/AUDIT_CHARTER.md et AUDIT_METHOD.md. SYS-01.2-02 est un audit terminable de chaque exigence ; une fonctionnalité absente correctement établie n’empêche pas sa clôture. Les dimensions audit,implémentation,vérification et acceptation humaine sont indépendantes. Le service Goal reste actif ; son API n’autorise pas la modification du texte de l’objectif,ce cadrage fait donc autorité pour la reprise.

L’intervention logicielle antérieure est gelée. La migration en cours a été interrompue : six tables work_* et la clé meta historical_link_coverage avaient déjà été ajoutées à la base du projet F. Sept définitions de parcours et une version de migration existent ; zéro évaluation,zéro historique de travail,zéro instantané. Les42607états manuels,23historiques,identifiants et anciennes valeurs meta sont inchangés. La base installée sur C est intacte ; la version1.4.0 a seulement été compilée,pas installée. Ne pas déclarer cette migration terminée.

Inventaire et retraits possibles,non exécutés : F:/OpenLeague-work/audit-method-20261030/WITHDRAWAL_INVENTORY.md et .json. Ils recensent9fichiers existants modifiés,10nouveaux fichiers logiciels et leurs sauvegardes/empreintes. Ne pas faire de reset/clean Git,de restauration globale ou de remplacement de base. Vérifier les empreintes et conserver toute évolution postérieure avant un éventuel retrait autorisé.

Les préparations de l’application,tests et binaires restent gelées. Ne pas lancer/restart Plan,ne pas invoquer work_cli ou Store.new pour inspection : ils peuvent migrer automatiquement. L’inspection ultérieure des bases doit rester en SQL lecture seule. Les changements de méthode et les archives exactes des anciennes notes sont conservés.

Mise à jour 2026-11-02 : AUD-22.1-07-TR-01 est terminé comme audit borné (rapport docs/AUDIT_AUD-22.1-07-TR-01.md); l’audit du consommateur RADS/system/locale.cfg et la recherche bornée de defaults.zip sont également consignés dans docs/FIDELITY_LOCALE_FONT_LINKS_4_20.md. Les trois lots clôturent seulement leur portée d’audit; SYS-01.2-02, l’implémentation, la fidélité native et l’acceptation restent ouverts. Prochaine action : choisir une exigence encore ouverte dans le registre et vérifier un seul lien source/consommateur qui n’a pas déjà été audité. Suivre docs/ai/CURRENT.md et ne pas répéter les recherches identiques sans nouvel élément. La restriction documentaire reste active : pas de modification du Plan, de l’UI ou des bases; aucune installation ni migration.

V795 et les travaux antérieurs sont hors du retrait : publication et relecture finalisées avant cette intervention. Aucun sous-agent sans instruction explicite. Les détails de l’intervention et sa restriction actuelle sont conservés dans F:/OpenLeague-work/audit-method-20261030/WORK.json.

Complément 2026-11-02 — AUD-SYS-01.2-02-TRACE-ANCHORS-01 : validation structurelle réussie et 5 759 ancres matérielles sur 5 759 présentes à leurs lignes enregistrées. --verify-files est bloqué par le premier chemin historique E:\OpenLeague hors racines explicitement admises; zéro empreinte du corpus complet vérifiée. Le lot d’audit borné est clos; le parent reste actif et partiel. Prochain lot : une exigence ouverte non déjà couverte, avec source et consommateur F vérifiables, un seul lien et sept critères. Détails/reprise : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.
Complément 2026-11-02 — AUD-CH-AATROX-PASSIF-SOURCE-CONSUMER-01 : audit statique clos pour la liaison Aatrox PASSIF. Sources client exactes rehashées; le code F charge les stats de base et ne présente aucune route passive Aatrox identifiée. Le corps serveur et les clés non attribuées restent inconnus; aucun comportement accepté. Prochain lot atomique : CH-Ahri-PASSIF-ACCEPTANCE. Rapport : docs/AUDIT_CH-AATROX-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md.
Complément 2026-11-02 — AUD-CH-AHRI-PASSIF-SOURCE-CONSUMER-01 : sources client Ahri rehashées, consumer de stats identifié, aucune route actuelle Essence Theft établie. L’audit de liaison est clos; le corps serveur et l’implémentation restent ouverts. Prochaine unité : CH-Akali-PASSIF-ACCEPTANCE. Rapport : docs/AUDIT_CH-AHRI-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md.
Complément 2026-11-02 — AUD-CH-AKALI-PASSIF-SOURCE-CONSUMER-01 : source Akali rehashée et membership concordant; consumer de statistiques identifié; aucun handler Twin Disciplines établi. L’audit de liaison est clos, le corps serveur et l’implémentation restent ouverts. Prochaine unité : CH-Alistar-PASSIF-ACCEPTANCE. Rapport : docs/AUDIT_CH-AKALI-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md.

## 2026-11-02 - AUD-SYS-02.1-04-BLENDER-INVENTORY-01

Cloture limitee : 11 fichiers Blender/sauvegardes inventoriees dans F; huit entrees manifestees verifiees par taille et SHA-256, trois prototypes non manifestes sont explicitement incomplets. Le client charge le GLB Map10; le plugin spawn-mist consomme JSON/PNG reconstruits, pas le .blend. Les hashes JSON/PNG concordent avec le manifeste. La source authentique fogcircle.sco/texture, l’export Blender vers GLB et l’acceptation runtime/visuelle restent ouverts. Aucun code, goal, Plan, base de suivi, installation ni migration modifies. Details : docs/FIDELITY_SCRIPT_BLENDER_LINKS_4_20.md.

Prochaine reprise : une exigence ouverte differente de SYS-01.2-02 avec source F et consommateur reel. Reprendre le mist uniquement si une source native exacte, un recu de conversion/installation ou un nouveau consommateur apparait.

Complément 2026-11-02 — AUD-SYS-01.2-02-RADS-INITIALIZE-CALLEE-01 : frontière statique export RadsInitialize → 0x1003e250 confirmée par REA/Ghidra; aucune route Rust directe identifiée sous les symboles RADS cherchés. Le refus 0x80004005 sur manifeste core absent est hérité et n’est pas un montage réussi. Lot d’audit borné clos; intégration et comportement restent ouverts. Rapport : docs/FIDELITY_RADS_INITIALIZE_CALLEE_BOUNDARY_2026-11-02.md. Reprise conditionnelle à un manifeste exact, un callsite Rust/ABI ou une entrée de branche nouvelle.

Mise à jour corrective 2026-11-02 — Trundle Q : l’INIBIN D est bien relié par le reçu OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d au membre lol_game_client 0.0.1.7. Le JSON déclaré existe sur E; 30 champs consommés plus Coefficient concordent float32 bit à bit entre deux lecteurs, l’export E et la ligne F. Le DDF client exact relie la table locale 0.8–1.2, mais le désaccord avec Coefficient=0.4 et Effect3=100–120 reste ouvert; aucune parité serveur n’est revendiquée. Supplément dans docs/FIDELITY_PROGRESSION_NATIVE_LINKS_4_20.md. Reprendre seulement sur source serveur, preuve de priorité runtime ou nouveau reçu de conversion.

Complement 2026-11-02 — AUD-SYS-01.2-02-ANNIE-PASSIVE-LINK-01 : liaison statique des ressources Pyromania et callsites Annie terminee dans son perimetre. Les historiques de tests du 2026-10-04 sont conserves mais ne valident pas les callsites modifies depuis. La mecanique native, la duree numerique, les etats aux limites et l’acceptation demeurent ouverts. Rapport : docs/AUDIT_SYS01202_ANNIE_PASSIVE_LINK_2026-11-02.md. Reprendre sur une source serveur/native precise ou sur un controle cible des callsites actuels.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1055-HEALTH-LINK-01 : audit borné source/donnée/consommateur terminé pour le bonus de 70 PV de l’objet 1055. Le reçu historique du 14-10 indique 4/4 tests, mais ses hashes shop.rs et progression.rs diffèrent des fichiers F actuels. Ne pas promouvoir ces tests en vérification courante; reprendre sur reçu relié aux hashes présents ou source serveur primaire sur l’ajustement de santé. Aucun code, goal, Plan, base, installation ou migration modifié. Détails : docs/AUDIT_SYS01202_ITEM1055_FLATHPPOOLMOD_2026-11-02.md.

Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1055-AD-LIFESTEAL-01 : liens statiques établis pour +7 AD et +0,03 de vol de vie. Membership/source partagés avec le lot santé précédent, sans nouveau hachage source. Le consumer current ajoute les dégâts d’objet dans ad_components et n’applique le vol de vie que dans basic_attack_hit, avec gardes locales visibles. Le reçu de 4/4 tests est historique; shop.rs et progression.rs diffèrent de la révision exécutée. Le prérequis D01-1 reste a_faire, sans statut modifié. Aucun code, registre, goal, Plan, base, installation ou migration touché. Détails : docs/AUDIT_SYS01202_ITEM1055_DAMAGE_LIFESTEAL_2026-11-02.md.

Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1055-PRICE-01 : lien statique des prix d’achat/vente 440/176 documenté. Reçu d’octobre conservé comme historique; shop.rs actuel a un autre hash. Aucun test courant ou refus de vente exécuté. Reprendre sur une recette liée au code actuel ou une source serveur native. Détails : docs/AUDIT_SYS01202_ITEM1055_PRICE_2026-11-02.md. Aucun registre, Plan, base, installation ou migration modifié.

Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1055-ICON-01 : DDS natif PetAttack.DDS comparé à la copie 1055 (octets/SHA concordants); le plugin d’inventaire courant est enregistré et consomme l’image par ID. Le reçu CPU exact couvre tous les objets et reste valable pour les hashes du module/test/manifeste présents; aucun GPU/pixel/acceptation visuelle n’est établi. Reprise si source, consumer ou overlay change; autrement vérifier les preuves ITEM-1055-SHOP-TEXTE avant de lancer une piste. Rapport : docs/AUDIT_SYS01202_ITEM1055_ICON_2026-11-02.md.

Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1055-TEXT-01 : l’écart FR/en_GB est maintenant établi sur les deux chaînes exactes. La ressource en_GB du client 4.20 existe, membership/hash concordent; la UI actuelle rend le catalogue fr_FR via shop_ui. La fidélité visuelle, l’exécution de la locale et le producteur historique de shop_foundation restent inconnus. La correction est réservée à la tâche ITEM-1055-SHOP-TEXTE, sans modification de données dans ce lot documentaire. Rapport : docs/AUDIT_SYS01202_ITEM1055_TEXT_2026-11-02.md.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-HEALTH-LINK-01 : la source native 1056 (membership manifeste vérifié) et le catalogue officiel 4.20.1 confirment FlatHPPoolMod=60. La ligne shop_foundation est absente; shop::item ne résout donc pas 1056 et quote/buy retourne le refus générique. Le code générique health→max_health existe mais n’est pas atteint pour cet objet. L’audit du lien statique est clos; la fonctionnalité et le test runtime restent ouverts. Reprise précise dans docs/AUDIT_SYS01202_ITEM1056_FLATHPPOOLMOD_2026-11-02.md. Next: examiner la preuve déjà recensée pour ITEM-1056-SERVER-STAT-FlatMPRegenMod sans répéter la collecte de la source native. Aucun statut du plan, goal ou suivi modifié.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-MANAREGEN-LINK-01 : la référence catalogue 4.20.1 donne FlatMPRegenMod=0.6; cette clé n’apparaît pas dans l’export natif 1056 existant, dont la couverture n’est pas qualifiée. Ne pas inférer sa présence ou son absence dans l’INIBIN. Le code a le multiplicateur mana_regen_percent, aucune statistique plate, et l’achat 1056 échoue car son entrée catalogue manque. L’audit documente le gap; feature a_faire. Reprise avec dump natif clé/valeur ou source primaire membre 4.20; ne pas répéter le hash/membership 1056 déjà vérifié. Détails : docs/AUDIT_SYS01202_ITEM1056_FLATMPREGENMOD_2026-11-02.md. Aucun code, registre, goal, interface ou base modifié.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-AP-LINK-01 : valeur officielle FlatMagicDamageMod=15; pas de valeur confirmée par l’export INIBIN existant, dont la couverture n’est pas qualifiée. Le consumer Rust générique ability_power est présent dans shop.rs et progression.rs; l’item 1056 manque du catalogue courant, ce qui entraîne le refus d’achat. Reprise: qualifier la clé native, réutiliser membership/hash déjà établis, intégrer la donnée puis vérifier achat/stat/refus sur la révision courante. Pas de test ni changement produit dans ce lot. Rapport : docs/AUDIT_SYS01202_ITEM1056_FLATMAGICDAMAGEMOD_2026-11-02.md.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-PASSIF-LINK-01 : catalogue officiel et miroir communautaire dérivé concordent sur le passif +4 mana à l’élimination, mais la règle serveur et le cumul ne sont pas prouvés. Le hook world.damage_unit crédite l’or/XP sans consulter les objets; le chemin champion_kills traite uniquement scores/récompenses. Le code item ne porte pas de callback passif, l’objet 1056 est absent et refusé à l’achat. Les hashes/membership de l’INIBIN sont repris, le miroir seul est rehaché. Reprendre avec mapping natif/serveur et règle de cumul; tester ensuite les deux chemins de kill et le nombre de copies. Rapport : docs/AUDIT_SYS01202_ITEM1056_PASSIF_2026-11-02.md. Aucun statut de plan, goal ou suivi modifié.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-ICON-LINK-01 : l’INIBIN sélectionné référence un DDS vérifié et la PNG boutique locale est pixel-identique au DDS après décodage FFmpeg. shop_ui utilise cette PNG par ID, mais shop_foundation et l’admission Map10 excluent 1056; aucun affichage runtime n’est établi. Le manifest DDS du HUD inventaire reste séparé et exclut aussi 1056. Reprise sur admission/catalogue puis capture réelle; ne pas recopier ni re-comparer l’image sans changement source. Aucun test produit ou changement de code/registre/DB. Détails : docs/AUDIT_SYS01202_ITEM1056_ICON_2026-11-02.md.


Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-TEXT-LINK-01 : fontconfig_en_GB.txt membre contient les trois clés texte exactes 1056; le miroir dérivé relie DisplayName/Description/DynamicTooltip. shop_ui consomme item.name et item.description du catalogue local mais pas la locale native; 1056 manque du catalogue et de l’admission Map10, donc aucune infobulle. Les valeurs visuelles et la sémantique serveur restent distinctes. Reprendre sur ajout data/locale et rendu, sans rehash de sources inchangées. Rapport : docs/AUDIT_SYS01202_ITEM1056_TEXT_2026-11-02.md. Aucun code, registre, goal, app ou base modifié.

Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-PRICE-LINK-01 : le natif donne Price=400, CanBeSold=true, SellBackModifier=.4; la référence Data Dragon 4.20.1 confirme 400/160. Le consumer achat lit price, la revente lit explicitement sell_price; pas de calcul depuis sell_multiplier. 1056 absent du catalogue/admission → refus item behavior not implemented, nominal non exécuté. Reprendre après qualification du mode et intégration de ces champs, puis tester achat, fonds insuffisants, vente et refus. Aucune révision produit ou statut modifié. Rapport : docs/AUDIT_SYS01202_ITEM1056_PRIX_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1056-SHOP-INTEGRATION-01 : shop_ui et le cœur ont des consommateurs génériques, mais la donnée/admission 1056 manque; achat/vente ne se résolvent pas et l’inventaire HUD efface les slots sur ID catalogue inconnu. Undo est vide; les actions achat/vente sont immédiates. Le critère task parle de VFX/audio/modèle plutôt que du périmètre boutique. Reprise après résolution de scope/critère puis intégration et contrôles réels. Le présent lot est un audit clos, pas une fonctionnalité terminée. Rapport : docs/AUDIT_SYS01202_ITEM1056_SHOP_INTEGRATION_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1058-AP-LINK-01 : décodage direct de FlatMagicDamageMod=80 dans l’INIBIN membre 4.20; shop_foundation reprend ability_power=80 lié au SHA source; agrégateur et progression consomment l’AP. Map10 interdit explicitement l’achat, et ITEM-1058-SCOPE reste partiel : l’applicabilité sur le mode historique n’est pas conclue. Aucun test/build/runtime. Reprendre sur décision scope/carte puis contrôle inventaire/AP avec facteur d’autel. Rapport : docs/AUDIT_SYS01202_ITEM1058_FLATMAGICDAMAGEMOD_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1058-ICON-LINK-01 : source INIBIN → DDS membre exact → PNG UI 64×64 à pixels RGBA identiques; un second DDS et le manifest d’inventaire incluent aussi 1058. Le consumer shop_ui existe mais la politique Map10 allowed=false cache la ligne. Pas de capture GPU/runtime; scope de disponibilité reste partiel. Rapport : docs/AUDIT_SYS01202_ITEM1058_ICON_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1058-TEXT-LINK-01 : texte natif en_GB et valeur +80 confirmés; le catalogue local utilise du français et shop_ui n’importe pas fontconfig_en_GB ni le tooltip complet. Map10 allowed=false masque la ligne. Reprise après décision de locale/scope, puis rendu UI réel. Rapport : docs/AUDIT_SYS01202_ITEM1058_TEXT_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1058-PRICE-LINK-01 : INIBIN 1058 donne Price=1600, CanBeSold=true; catalogue officiel donne 1120 à la vente; shop_foundation stocke explicitement sell_price=1120. Le multiplicateur .7 n’est pas attribué au natif. L’achat est bloqué par admission Map10; la vente n’a pas ce contrôle dans le consumer. Pas d’exécution. Scope 1058 encore partiel. Rapport : docs/AUDIT_SYS01202_ITEM1058_PRIX_2026-11-02.md.
Complément 2026-11-02 — AUD-SYS-01.2-02-ITEM1058-SHOP-INTEGRATION-01 : les sous-lots relient AP, icône, texte et prix aux consumers. Limites : admission Map10 false, upgrade recipe non représentée dans le catalogue partiel, Undo vide, critère parent incohérent, scope partiel; l’acceptation dépend de ce parent. Aucun test/runtime. Reprise par décision scope/locale/recette/annulation puis intégration et acceptation réelles. Rapport : docs/AUDIT_SYS01202_ITEM1058_SHOP_INTEGRATION_2026-11-02.md.
Correction de reprise 2026-11-02 — Le contexte officiel Data Dragon 4.20.1 de l’objet 1058 contient maps["10"]=false et corrobore l’admission Map10. La différence avec le client 4.20.0.315 reste ouverte; ne pas répéter la recherche du catalogue, réutiliser ce champ et consigner la portée exacte dans ITEM-1058-SCOPE. Les rapports AP, prix et intégration ont été précisés; aucun statut changé.
## 2026-11-02 — reprise après audits Stinger 3101

Lire le complément à la fin de `docs/ai/CURRENT.md` et les rapports `docs/AUDIT_SYS01202_ITEM3101_*_2026-11-02.md`. Les lots attaque-speed, passif, texte et prix sont des audits statiques seulement; leur statut fonctionnel et `ITEM-3101-SCOPE` restent ouverts. Aucun goal, tâche, registre, code, Plan/UI ou base n’a été modifié. Le diagnostic REA/Ghidra est disponible, mais la recherche Ghidra sur l’EXE n’a produit ni Evidence ni snapshot et a été interrompue; reprendre seulement sur une nouvelle piste.

Prochaine action : sélectionner un seul autre besoin ouvert avec source F et consumer courant, vérifier s’il existe déjà un rapport complet, puis fermer uniquement le périmètre réellement établi.

## 2026-11-02 — lot icône Stinger 3101

Audit source/asset/consumer clôt pour les constats statiques. INIBIN → 059_Sheen.DDS membre exact; DDS local et PNG boutique pixel-identiques au natif. shop_ui.rs charge l’image, mais le consumer boutique n’est pas parmi les ancres liées à ITEM-3101-SHOP-ICONE; registre inchangé. Test CPU HUD d’octobre réutilisé, hashes de sources/test/données concordants; aucun rendu boutique exécuté. Reprendre le scope du mode et l’ajout d’ancre seulement après autorisation; prochain lot = autre exigence et nouvelles preuves ciblées. Détails : docs/AUDIT_SYS01202_ITEM3101_ICON_2026-11-02.md.

## 2026-11-02 — lot icône item 3108

Audit source/consumer clos pour le lien statique : INIBIN → DDS natif membre → copie DDS et PNG boutique pixel-identiques; code UI charge par ID, admission locale true. Reçu test CPU HUD réutilisé avec sources identiques; aucun rendu boutique. La trace ne contient pas l’ancre `shop_ui.rs:233`; registre inchangé. La classification `required=false` et la priorité runtime restent ouvertes. Rapport : docs/AUDIT_SYS01202_ITEM3108_ICON_2026-11-02.md.

## 2026-11-02 — lot d’icônes du catalogue boutique

Audit regroupé pour les 33 IDs du reçu `portrait-inventory-v217.json` : INIBIN/DDS/copies matchent les empreintes; toutes les PNG boutique ont les mêmes pixels RGBA que leur DDS. Le catalogue contient 33 objets, admission Map10 31/33 (1038 et 1058 exclus). Le consumer `shop_ui` n’est pas dans les ancres de trace génériques; registre inchangé. Tous les sous-tâches icon sont `required=false`; le rendu, le montage et l’acceptation restent ouverts. Rapport : docs/AUDIT_SYS01202_SHOP_ICON_CATALOG_2026-11-02.md. Prochaine action : prendre une exigence requise non couverte dans un autre système.

## Résultat ciblé — Annie BaseHP (2026-11-02)

Lot clos sur la liaison source native → donnée actuelle → consommateurs pour CH-Annie-IDENTITE-HP. Les empreintes source/D, catalogue F, crates/core/src/lib.rs et progression.rs concordent avec les reçus V515; les trois ancres courantes sont identifiées. Audit seulement : tests d’application/runtime et acceptation non exécutés; croissance et mécanique PV restent distinctes. Statut de plan et registres inchangés. Reprise : choisir un autre champ requis non déjà couvert par le lot V515 des 122 champions; réutiliser ses reçus et contrôler leurs hashes avant toute nouvelle recherche.
## Porte de prérequis à préserver

D01-SYS-01-2 dépend de D01-SYS-01-1. Lecture seule au 2026-11-02 : le paquet préalable reste a_faire et les sept tâches requises SYS-01.1-01 à SYS-01.1-07 sont a_valider; SYS-01.2-02 reste partiel_a_terminer. La référence client est documentée, mais son acceptation n’est pas inscrite. Continuer les audits bornés sans présenter le paquet comme clôturé; reprendre la clôture quand le prérequis aura été accepté selon le processus autorisé. Aucun fichier de suivi ou état n’a été changé.
## Liens de passifs revalidés — Amumu et Cho’Gath

La vérification de fraîcheur réutilise les reçus V550/V551, sans relancer leurs simulations : Amumu 16/16 ancres et fichiers consommateur conformes; Cho’Gath 17/17; INIBIN propriétaires toujours aux SHA attendus. L’anomalie du premier comparateur Cho’Gath était dans la normalisation des séparateurs, corrigée sans divergence produit. Les résultats locaux négatifs ne remplacent pas les règles serveur historiques. Prochaine piste déjà découverte : Alistar/Trample, reçus V552 et revision552_Alistar_discovery; réutiliser ce matériel et vérifier les points Cast, zone/dégâts et phasing conditionnel. Ne pas rehash le reste du corpus ni répéter la découverte.
## Piste Alistar/Trample — fraîcheur confirmée

Le reçu V552 est courant : deux INIBIN rehashés et 18/18 ancres/fichiers Rust conformes. L’ancien diagnostic de refus ne prouve pas le déclenchement. Ne pas répéter la découverte. Pour la suite, prendre une autre exigence requise non couverte, en réutilisant ses sources/consommateurs déjà enregistrés; conserver ouverts le corps serveur et les inconnues Trample jusqu’à une piste native ou un chemin d’exécution qualifié.
## 2026-11-02 — consommateur actuel de carte, audit borné clos

Le lot AUD-SYS-01.2-02-MAP-AVAILABILITY-CONSUMER-01 ferme uniquement le lien du moteur local : server/main charge le terrain TT et active Map10; ClientPacket::Join ne transporte que champion/invocateurs; Simulation::join utilise les spawns Map10 et refuse une septième entrée. La recherche ciblée de champs région/file dans le chemin d’admission ne donne aucun résultat. Tout cela est statique; aucun test/build ou client n’a été lancé. Le payload AIR historique reste absent; SYS-01.3-03 et le parent SYS-01.2-02 restent ouverts, sans statut modifié. Voir docs/AUDIT_SYS01202_MAP_AVAILABILITY_CURRENT_CONSUMER_2026-11-02.md.

Reprise : ne pas réexporter MapGeneratedData ni répéter V95/V192/V254. Poursuivre un autre lot requis avec sources et consommateurs réels déjà disponibles; reprendre la matrice de disponibilité uniquement sur réception d’un payload EUW 4.20 de gameMapEnabledDTOList/getAvailableQueues, ou d’une source primaire datée avec son callsite de sélection. La restriction Goal/Plan/UI/bases reste active.
## 2026-11-02 — lot Anivia `anivia_attack1`

Liaison statique source native → GLB → rôle `attack` confirmée en réutilisant V719 et les fichiers/hashes courants. Le flux d’attaque peut sélectionner ce rôle; la corrélation d’import n’établit pas l’équivalence d’animation 4.20. La tâche clip, sa dépendance de modèle et la fonctionnalité restent ouvertes. Aucun test/build/runtime/rendu, aucune modification du goal, du suivi ou des bases. Détails et conditions de reprise dans `docs/ai/CURRENT.md`; preuve détaillée réutilisée : `docs/fidelity_champion_transition_links_v719.json`.

Prochaine action bornée : qualifier le .anm `anivia_attack1` (pose/canaux, durée/bouclage, événements, transitions, forme/skin) par un lecteur ou une preuve reproductible déjà disponible; comparer avec l’asset GLB courant. Ne pas refaire le scan du corpus ni rehasher ces fichiers inchangés.

Complément du lot Anivia : le natif est `r3d2anmd` version 3. Le parseur local ANM4 refuse ce numéro de version, sans analyser l’animation; ne pas interpréter le refus comme corruption. La doc communautaire LeagueToolkit couvre v3 et répertorie `ltk_anim`; TS-RitoFile annonce les deux magics mais reste expérimental. Ces outils ne sont ni installés ni testés ici. Reprendre avec un parseur v3 déjà disponible/autorisé; ne pas modifier le code produit ni installer un outil sous la restriction active.


## 2026-11-02 — reprise SYS-02.2-04

Le supplément de `docs/FIDELITY_FORMAT_LINKS_4_20.md` ferme l’audit statique de présence/absence des callsites pour Saucer8 et Heal_Plus, pas la tâche fonctionnelle. Les sources D/F ont été comparées; le résultat V45 Heal_Plus est hérité; la sortie SCB reste sans code de sortie. Pas de test/build/run ou de modification du suivi. Reprendre si le journal SCB devient disponible ou si un callsite runtime est ajouté/observé; sinon continuer SYS-01.2-02 sur un lot requis distinct, sans relancer les recherches couvertes.


## 2026-11-02 — reprise Soraka Q VFX

L’icône Q a une chaîne statique source → asset local aux octets identiques → consommateur HUD : native_hud_spells charge et sélectionne Soraka/slot 0; aucun rendu n’a été exécuté. Le manifeste global reste à 486/488. Prochain lot concret : les entrées primaires Amumu/slot 1 et Nunu/slot 3 ont chacune deux sources candidates de SHA différents, priorité native inconnue; déterminer cette priorité avec une preuve existante, sinon conserver le refus et ses conditions. La variante Heimerdinger E InventoryIcon2 est signalée sans fichier recensé, mais n’entre pas dans le compte primary. Soraka VFX reste séparé : AOE_leona_outer.dds est partagé, clés INIBIN 3401378034/4156942032 sans champ vérifié, pas d’événement Q. Ne pas rechercher de nouveau Soraka_Q.dds ni refaire le scan. Reprendre Soraka seulement sur mapping vérifié, événement natif Q ou capture exploitable. Détails : docs/AUDIT_SYS01202_CH_SORAKA_Q_VFX_2026-11-02.md. Aucun test/build/runtime exécuté.


## 2026-11-02 -- reprise SYS-01.2-02 (URF/Cheats)

Lot d'audit du consommateur courant clos pour URF et Cheats: aucun nom/chemin direct en Rust/Tauri et aucune ligne dans le manifeste actif de 7 511 assets. La preuve de valeurs/hash est reutilisee depuis le rapport d'appartenance; aucun code, asset, registre, goal, application ou base n'a ete modifie. Limite: une admission indirecte par provider generique n'est pas exclue. OLU-6c4ea73e et OLU-f76e6025 restent ouverts faute de provenance/selection historique autoritative; les ressources ne sont pas fonctionnellement integrees par ce resultat.

Prochaine action: choisir un lien requis source-consommateur encore non audite a partir du trace existant; ne pas refaire les recherches URF/Cheats/Locale sans nouvelle source de generation, staging ou ordre de montage.

## 2026-11-02 -- reprise SYS-01.2-02 (priorite icones Amumu/Nunu)

Audit borne clos: les deux candidats de chaque icone sont presents dans le manifeste core F, hashes conformes, releases de contenu `0.0.0.40` (Characters/Info) et `0.0.0.25` (Spells/Icons2D). Le manifeste en_GB ne les contient pas. Cette appartenance ne choisit pas le lookup. Amumu a une variation de casse `Auraof`/`AuraOf`; le case-folding RADS reste ouvert avec OLU-3293c388. Le consumer HUD actuel charge les seuls `entries`, donc omet Amumu/1 et Nunu/3; aucun rendu n'a ete execute. Le detail et les hashes sont dans `docs/FIDELITY_SPELL_ICON_GRAPH_V220.md`.

Ne pas refaire ces comparaisons. Reprendre la priorite si une trace du lookup original ou l'ordre effectif du provider apparait; entre-temps auditer un lien requis distinct avec sources et consumer actuels.

## 2026-11-02 -- reprise SYS-01.2-02 (RLSM defaults.zip)

Sous-audit d'appartenance clos: `defaults.zip` attendu par `files.json`/`oldFiles.json` est absent des deux manifests RLSM selectionnes sur F (core et en_GB), avec comparaison insensible a la casse. L'ancienne recherche D n'a trouve aucun fichier; aucune archive n'a ete extraite. OLU-0ae207ed reste ouvert pour la source de staging/overlay, l'origine du Locale.cfg loose et son selectionneur historique.

Ne refaire aucune recherche identique sans nouveau payload au MD5 attendu ou manifeste/trace de provider.

## 2026-11-02 — reprise provider relic

Audit borné « appelant de production actuel » clos : aucun appel de `PackageProvider` / `source_from_package` dans le code de production recensé; seuls les tests appellent ces API. Le Ring actif prend deux textures directes. Aucun test/build/runtime n’a été exécuté. L’intégration acteur et la fonctionnalité restent ouvertes. Ne refaire ce recensement que si un nouvel appelant ou une trace native de montage apparaît; sinon choisir une relation requise distincte. Détails : `docs/FIDELITY_CHARACTER_PROVIDER_RESEARCH_V167.md`.
## 2026-11-02 — Anivia ANM v3, disponibilité du lecteur

Contrôle borné clos : le code interrogé ne contient que les lecteurs `r3d2anmd` version 4 et les outils connus ne sont pas résolus dans PATH. Réutiliser l’identité et les empreintes V719; aucun binaire n’a été relu/rehaché et aucun parse/test/build/rendu/install/download n’a été fait. L’équivalence `anivia_attack1` ↔ GLB, les canaux, le timing, les événements et transitions restent non qualifiés. Reprendre seulement avec un lecteur v3 disponible/autorisée et un témoin indépendant; sinon passer à une autre liaison requise. Détails dans `docs/ai/CURRENT.md` (unité ANIVIA-ANM-V3-TOOL-AVAIL-01).
## 2026-11-02 — NATIVE-ITEM-1057-SCOPE

Audit documentaire borné clos : le fichier natif exact et sa membership sont réutilisés, son SHA est confirmé; le lecteur v2 confirme `Negatron Cloak`, +35 MR, +50 % regen base, `InStore=0` / `CanBeSold=0`. Aucun ID 1057 dans le catalogue 4.20.1 fourni, la boutique F (33 entrées) ou l’admission Map10 (33). Le consumer statique refuse un achat inconnu avant l’admission; la MR générique n’est atteinte que par un item catalogué. Type/disponibilité client/catalogue classifiés; disponibilité serveur, raison historique et feature restent ouvertes. Aucun test/build/runtime, aucun statut ou base modifié. Reprendre l’enfant conditionnel uniquement sur source primaire d’activation historique. Détails dans `docs/ai/CURRENT.md`.

## 2026-11-02 — SYS-01.2-02, objet 1033 et stat MR

Unité d’audit statique close : la valeur native +25 MR de DATA/Items/1033.inibin (preuve/hash et membership antérieurs réutilisés) correspond à shop_foundation.json; l’objet est admis sur Map10. Le code courant agrège le bonus dans shop::bonuses puis l’applique à progression::stats. Les refus d’ID inconnu et de politique de carte non qualifiée sont identifiés. Pas de test, build, lancement ou rendu. ITEM-1033-SCOPE reste partiel_a_terminer; la fonctionnalité de boutique et SYS-01.2-02 restent ouverts. Détail : docs/ai/CURRENT.md (ITEM-1033-MR-SOURCE-CONSUMER).

Reprise : choisir une autre liaison requise source-consommateur, sans répéter cette correspondance 1033, l’audit Anivia ANM v3 ou le périmètre 1057 en l’absence de nouvelles preuves primaires.

## 2026-11-02 — SYS-01.2-02, résolution du consumer de trace

Le résolveur exact a réussi en UTF-8 (code 0) : la fiche OLF-3a11ace9 est toujours partial_with_open_questions, avec 4 297 entrées natives, 4 958 références, 1 319 liens consommateur et 5 inconnues ouvertes. Les 1 319 sont des relations de cette exigence, distinctes des 403 consommateurs uniques de la révision globale. Le vérificateur global 23 303/22 est une photographie divergente; la révision documentée 92 639/403 est héritée d’un contrôle antérieur et d’un delta ciblé, sans re-scan global dans ce lot. Pas de code, registre, goal, Plan, application, base, test, build, runtime ni rendu modifié/exécuté. Détail : docs/ai/CURRENT.md (SYS-01.2-02-TRACE-RESOLUTION-V803).

Reprise : ne pas répéter le résolveur ni les recherches déjà consignées pour les cinq inconnues. Reprendre une inconnue uniquement sur nouvelle source primaire; sinon choisir une liaison requise distincte déjà présente dans la fiche et dont le consommateur actuel n’a pas de reçu dédié.

## 2026-11-02 — SYS-01.2-02, recherche publique defaults.zip

Recherche publique bornée par MD5 exact et chemin : aucun payload, hash correspondant ou producteur n’a été trouvé dans les résultats. Les guides communautaires ne prouvent que la manipulation manuelle du chemin et sont exclus de la preuve native. Aucun téléchargement/installation. OLU-0ae207ed reste ouvert jusqu’à obtention du payload MD5 attendu ou d’une trace autoritative de staging/overlay. Ne pas répéter la même requête. Détail : docs/ai/CURRENT.md (SYS-01.2-02-DEFAULTS-PUBLIC-SEARCH-V804).

## 2026-11-02 — SYS-01.2-02, prérequis

D01-SYS-01-1 reste incomplet : ses sept tâches SYS-01.1-01..07 sont requises, a_valider et acceptance_complete=false; les cases restent non cochées. reference_client_4_20.json est présent mais ne clôt pas ce paquet. La fiche SYS-01.2-02 indique depends_on=[] malgré le prérequis explicite de la tâche; aucun registre, plan ou statut n’a été modifié. Continuer uniquement la vérification documentaire jusqu’à acceptation préalable; ne pas déclarer le résultat intégré. Détail : docs/ai/CURRENT.md (SYS-01.2-02-PRECONDITION-D01-SYS-01-1-V805).

## 2026-11-02 — SYS-01.2-02, réconciliation du corpus courant

Correction à V803 : les JSON actuels concordent sur 42 215 exigences, 100 405 sources, 5 759 consommateurs et 31 706 inconnues (26 189 ouvertes, 5 517 résolues). Les 92 639/403 et 23 303/22 proviennent de snapshots plus anciens. Le résolveur par tâche reste à 4 297 entrées natives, 4 958 références, 1 319 consumers, 5 inconnues. Aucun re-hachage global ni validation complète lancé; aucune base/goal/registre modifié. Détail : docs/ai/CURRENT.md (SYS-01.2-02-CURRENT-REGISTRY-COUNTS-V806).

## 2026-11-02 — récupération de CURRENT.md

CURRENT.md a été tronqué à zéro octet lors d’une tentative de normalisation des fins de ligne. Il a été reconstruit en état court à partir du snapshot V795 dont le SHA-256 est 798ddc523e2d028d1f9266670ad39b5a2644c3b74683fb9a57b0b024c11bf23a, du HANDOFF intact et des entrées V801–V806 de resume_checkpoint.json. La copie immédiatement antérieure n’a pas été retrouvée; le CURRENT rétabli est une synthèse, pas une restitution octet pour octet. Aucun autre fichier produit ni état de tâche n’a été retiré. Détail et limites dans docs/ai/CURRENT.md.


## 2026-11-02 — SYS-01.2-02, Yasuo : consommateur du passif

V808 clôt le sous-audit statique de la frontière consommateur, pas le passif : la chance actuelle est base + croissance + objets, sans doublement Yasuo; le bouclier générique stocke/absorbe, et son appel de production relevé est Barrière. Le couple mouvement Yasuo → charge → dégâts champion/monstre → octroi de bouclier n’est pas établi dans les chemins inspectés. V533/V536 réutilisés, aucune preuve native re-hachée, aucun test/build/runtime exécuté. `CH-Yasuo-PASSIF-SOURCE`, `CH-Yasuo-IDENTITE`, l’inconnue OLU-5dd3c2d5-ecf3-521d-ac2c-f471376ddfcc et SYS-01.2-02 restent ouverts. Aucun statut, registre, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_YASUO_PASSIVE_CURRENT_CONSUMER_2026-11-02.md`.

Reprendre uniquement sur source primaire de la formule/du déclencheur natif ou sur changement identifié d’un consumer.

## 2026-11-02 — SYS-01.2-02, objet 1001 — V809

Audit borné source-consommateur clos, fonctionnalité et tâche ouvertes. Le reçu natif existant et son hash sont réutilisés : FlatMovementSpeedMod=25. Le catalogue local correspond; shop::bonuses alimente movement_speed. Le test boots_group_is_unique_and_dagger_changes_attack_cadence passe (1/1) : +25 à l’achat, doublon BootsNormal refusé sans débit, vitesse restaurée à la vente. ITEM-1001-SCOPE reste partielle, l’enfant ITEM-1001-SERVER-STAT-FlatMovementSpeedMod reste à faire et D01-SYS-01-1 n’est pas accepté. Aucun état du registre, Plan, app, base ou goal changé.

Ne pas refaire l’extraction native. Après acceptation du prérequis, exécuter le test existant de distance de déplacement (movement.rs::native_q_and_boots_speed_match_actual_thirty_tick_walk_distance) et vérifier les limites carte/session restantes. Détail : docs/AUDIT_SYS01202_ITEM1001_MOVEMENT_SPEED_2026-11-02.md.

## 2026-11-02 — SYS-01.2-02, objet 1006 — V810

Audit du lien PercentBaseHPRegenMod clos, pas de la fonctionnalité : source native enregistrée 4.20.0.315 (OLS-60f3e978-0395-543a-9a71-2dc78d2d8522, SHA-256 9a3f1e1f2862760d12fa51beac8944e3d9e566aa8b6d13bded6f40144e388d48, membership correspondant) et décodage 0.5 réutilisés. Donnée locale 0.5; le consommateur shop::bonuses → regeneration_rates applique 1 + bonus. Test ciblé courant réussi : deux achats = 2× base, vente = 1.5×, progression recalcule la croissance. ITEM-1006-SCOPE/SERVER restent partiels; aucun état de tâche, Plan, app, base ou goal changé.

Prochaine relation : item 1004 PercentBaseMPRegenMod; vérifier le cas nominal positif sur champion utilisant le mana et l’exclusion déjà testée pour champion sans mana. Détail V810 : docs/AUDIT_SYS01202_ITEM1006_BASE_HP_REGEN_LINK_2026-11-02.md.

## 2026-11-02 — V811, récupération des horodatages du checkpoint

Correction documentée dans docs/AUDIT_RESUME_CHECKPOINT_TIMESTAMP_RECOVERY_2026-11-02.md. Le remplacement de timestamp a touché 1 413 champs. 1 278 ont été restaurés depuis le snapshot du 27 octobre après concordance du contenu; V808/V809/V810 ont été rétablis depuis leurs reçus; 131 champs sans valeur originale récupérable sont null. Le checkpoint est JSON valide et le résolveur resume lit la prochaine action ITEM-1004 avec code 0. Une copie du fichier endommagé est dans le dossier Temp. Les tâches, le goal, le Plan, l’application et sa base n’ont pas changé.

## 2026-11-02 — SYS-01.2-02, item 1004 : régénération de mana (V812)

Audit borné clos pour la liaison PercentBaseMPRegenMod=0.25 natif → shop_foundation.json → shop::bonuses → regeneration_rates. Reçu natif antérieur OLS-0122f422-2fd9-5404-a8af-6bdf08c07ee6, 545 octets et SHA-256 419502ab9518d8796f5aea415eb8c5837beeae2f83a937acae68ed98555d61c5 réutilisés, sans re-hash. Contrôle Rust temporaire hors dépôt : Ahri 1.2/s, puis 1.5/s avec 1004; gain réel 1.500092 sur 30 ticks hors fontaine; vente restaure 1.2/s; Cargo exit 0.

Le test unitaire existant pour Ahri/Akali est réutilisé du lot précédent (1/1); aucun scénario d’achat sur champion manaless, aucun cumul/niveau, sémantique serveur historique ou acceptation n’est prouvé. Deux premiers essais de diagnostic ont exposé la fontaine et le garde outside allied shop; le scénario final les contrôle. ITEM-1004-SCOPE/SERVER restent partiels; aucun registre, tâche, goal, code produit, Plan, UI, app ou base modifié. Aucun install/migration. Rapport : docs/AUDIT_SYS01202_ITEM1004_BASE_MP_REGEN_LINK_2026-11-02.md.

Reprise : sélectionner un lien requis distinct avec source native réutilisable et consommateur courant identifié; un seul lien, un nominal, une limite, inconnues explicites; ne pas répéter les lots documentés. D01-SYS-01-1 reste non accepté.

## 2026-11-02 — SYS-01.2-02, item 1011 : FlatHPPoolMod (V813)

Audit borné clos pour source native 4.20 → catalogue → consumer PV. Reçu source OLS-f8e5fecb-5d3b-5826-a19a-24af43e2df5d, 560 octets, SHA-256 e9431e7c57900819bb504786ca78037f9a734db98162e46a7bed1585466ee597, réutilisé; aucune relecture/re-hash. Valeur native enregistrée 380, prix 1000, CanBeSold=true; shop_foundation correspond et Map10 admet l’objet.

Probe cargo run --offline exit 0 : 999 or → refus sans changement; 1000 or → Garen +380 PV max (616,280 → 996,280), vie courante conservée; vente → PV max initial et 700 or. Cargo a émis 24 avertissements sans échec; artefacts dans target existant, probe temporaire supprimé. ITEM-1011-SCOPE/SERVER restent partiels; règles serveur historiques, cumul, disponibilité globale et sémantique PV courant restent ouverts. Aucun code, registre, goal, Plan, app ou base modifié. Rapport : docs/AUDIT_SYS01202_ITEM1011_FLAT_HP_POOL_LINK_2026-11-02.md.

Reprise : choisir un lien requis distinct avec source déjà vérifiée et consumer actuel; faire un seul audit traçable réussite + limite, sans répéter les lots documentés. D01-SYS-01-1 n’est toujours pas accepté.

## 2026-11-02 — SYS-01.2-02, item 1018 : FlatCritChanceMod (V814)

Lien d’audit source native → données de boutique → statistique de critique clos pour le champ 1018. Source OLS-0d8167ff-4a6a-5162-aaa4-070ff1c5814d, 4.20.0.315, 533 octets, SHA-256 3cdd918dd0e86ac8cf43a36424e2aab965c2cfcd26c11f301f5dd3e9efb4bf5b; membership matches_selected_project_manifest concordant. Reçu réutilisé, aucun re-hash.

Probe Map10 cargo run --offline exit 0 : 729 or refuse sans mutation; achat à 730 porte Garen de 0 à 0.150000006 de chance critique; dégâts inchangés; vente revient à 0 et crédite 511. 24 avertissements Rust non bloquants. Limite : pas de combat/tirage RNG/parité serveur; la fixture qui place six 1018 à la main ne prouve pas l’achat et n’a pas été exécutée. ITEM-1018-SCOPE/SERVER restent partiels; aucun statut, code produit, goal, Plan, app ou base modifié. Rapport : docs/AUDIT_SYS01202_ITEM1018_CRIT_CHANCE_LINK_2026-11-02.md.

Reprise : choisir une exigence distincte avec source native réutilisable et consommateur actuel; vérifier une réussite et une limite. D01-SYS-01-1 reste à valider.

## 2026-11-02 — SYS-01.2-02, item 1029 : FlatArmorMod (V815)

Audit borné clos pour le lien source native → shop_foundation → armor de stats. Source OLS-4be229f5-8e25-5e28-b080-77c8c9dad43a, 4.20.0.315, 528 octets, SHA-256 9596f0efec5a87ee6dca380d042f94cff48a1e73ba965fdc61955d72075526ab; membership manifeste concordante. FlatArmorMod=15; catalogue armor=15 et admission Map10 true. Reçu réutilisé, sans re-hash.

Test courant ciblé native_start_and_buy_apply_to_combat_stats réussi (1 passé, 0 échoué, 1926 filtrés) : achète 1036 puis 1029, vérifie argent restant 165 et armure Garen +15. La vente et le refus de 1029 ne sont pas vérifiés. ITEM-1029-SCOPE/SERVER restent partiels; aucun statut, code source, Plan, application, base ou goal changé. Rapport : docs/AUDIT_SYS01202_ITEM1029_FLAT_ARMOR_LINK_2026-11-02.md.

Reprise : nouveau lien requis non audité, avec source et consumer actuels; une réussite et une limite, sans répétition des lots documentés. D01-SYS-01-1 reste ouvert.

## 2026-11-02 — SYS-01.2-02, item 1051 : FlatCritChanceMod (V816)

Lien d’audit clos pour FlatCritChanceMod : source OLS-52920235-455a-506b-a9a5-8c32fbda196c, 4.20.0.315, 526 octets, SHA-256 ad41973e83a09bd9138de4a06b3025c0c6aae48028e5405a4386cf9d3553a681, membership sélectionnée concordante. Champ 0.07999999821186066 et catalogue identiques; aucun re-hash.

Test ciblé courant réussi : native_crit_components_stack_sell_and_cap_without_changing_base_damage (1/1, 1926 filtrés). Deux achats 1051 donnent 0,16; vente d’un retire 0,08; dégâts inchangés. Les six entrées 1018 de la fixture sont injectées manuellement, pas achetées. Aucun tirage de combat ou comportement historique. ITEM-1051-SCOPE/SERVER restent partiels; aucun code, statut, Plan, app, base ou goal modifié. Rapport : docs/AUDIT_SYS01202_ITEM1051_CRIT_CHANCE_LINK_2026-11-02.md.

Reprise : nouveau lien requis non audité; une réussite et une limite; pas de répétition des lots documentés. D01-SYS-01-1 reste à valider.

## 2026-11-02 — SYS-01.2-02, item 1052 : FlatMagicDamageMod (V817)

La lecture ciblée du binaire 1052 ferme le manque du reçu précédent : 577 octets et SHA-256 courant égal au source registry; hash Data*FlatMagicDamageMod=3524488927 présent, brut string 20. La source est OLS-40885383-cc97-5bd3-9f81-211026fb4d4c et membership sélectionnée concordante. Le catalogue local a ability_power=20. L’interprétation de cette chaîne en valeur numérique n’exécute pas le convertisseur du serveur original.

Test ciblé courant two_altar_power_bonus_uses_the_current_item_power réussi (1 passé, 0 échoué, 1926 filtrés) : 20 AP à l’achat, 22 avec deux autels, 0 après vente. ITEM-1052-SCOPE/SERVER restent partiels; disponibilité serveur et gameplay historique ouverts. Aucun statut, code produit, Plan, app, base ou goal modifié. Rapport : docs/AUDIT_SYS01202_ITEM1052_ABILITY_POWER_LINK_2026-11-02.md.

Reprise : lien source-consommateur distinct, un succès et une limite; ne pas répéter les sources déjà traitées. D01-SYS-01-1 reste à valider.

## 2026-11-02 — SYS-01.2-02, item 1036 : FlatPhysicalDamageMod (V818)

Audit borné clos pour le lien source native → catalogue → statistique de dégâts. Source OLS-69ccc5a1-3126-52c6-a584-f9cfe8f7b781, 4.20.0.315, 578 octets, SHA-256 e6ed2a72317ed8295f74351663e0d94124b46c48f61db02cbc479849a3e86731, membership concordante; FlatPhysicalDamageMod reçu sous forme string 10 et damage local=10. Pas de re-hash.

Résultat V815 réutilisé : native_start_and_buy_apply_to_combat_stats achète 1036 et constate +10 damage local (1/1, 1926 filtrés). Pas de rerun en V818, pas de mesure de hit réel. ITEM-1036-SCOPE/SERVER restent partiels; statuts, code, Plan, app, base et goal inchangés. Rapport : docs/AUDIT_SYS01202_ITEM1036_DAMAGE_LINK_2026-11-02.md.

Reprise : autre lien requis, un cas nominal et une limite. D01-SYS-01-1 reste à valider.

## 2026-11-02 — SYS-01.2-02, item 1042 : PercentAttackSpeedMod (V819)

Lien source native → shop_foundation → cadence Rust clos pour l’objet 1042. OLS-6a0aee4b-4dc4-5377-8d10-2249a9bdcc5a, 559 octets, SHA-256 7a69325ffca20442c839e7e0acedb719f93f4144a073b147661957c5ff1f4a75, membership sélectionnée concordante; champ 0.15000000596046448 réutilisé sans re-hash.

Test courant boots_group_is_unique_and_dagger_changes_attack_cadence passe 1/1 : 1042 réduit le nombre de ticks d’attaque; vente restaure l’original. Le refus porte sur le doublon de bottes 1001. Pas de mesure d’une attaque réelle ni sémantique serveur. ITEM-1042-SCOPE/SERVER restent partiels; aucun code, tâche, Plan, app, base ou goal modifié. Rapport : docs/AUDIT_SYS01202_ITEM1042_ATTACK_SPEED_LINK_2026-11-02.md.

Reprise : nouveau lien requis distinct, un succès et une limite, statuts inchangés. D01-SYS-01-1 reste ouvert.

## 2026-11-02 — SYS-01.2-02, item 1053 : recette, AD et vol de vie (V820)

Audit borné clos pour source native → recette 1036 → données locales → stats/attack consumer. Source OLS-db739366-3781-58b7-b7c8-dbc67a297e8f, 563 octets, SHA-256 bb7db97c466730d2b2902d68fd64b4341f322b3352d936d0621670b05756d05d, membership concordante; aucun re-hash. Champs reçus : Price=440, RecipeItem1=1036, FlatPhysicalDamageMod string 10, PercentLifeStealMod=0.0799999982; le total catalogue est 800, vente 560.

Tests ciblés courants passés : native_recipe_credits_sword_and_sale_removes_attack_and_lifesteal_stats (1/1) et ordinary_attack_heals_from_mitigated_damage_without_overheal (1/1). Le premier vérifie fusion de recette, +10 AD/+8% lifesteal et vente; le second vérifie 8% des dégâts post-mitigation et clamp de PV max. La parité avec Riot 4.20 n’est pas qualifiée. ITEM-1053-SCOPE/SERVER restent partiels; aucun code, statut, Plan, app, base ou goal modifié. Rapport : docs/AUDIT_SYS01202_ITEM1053_LIFESTEAL_LINK_2026-11-02.md.

Reprise : nouvelle exigence source-consommateur requise, sans ré-audit des items listés; succès et limite documentés. D01-SYS-01-1 reste ouvert.


## V821 — preuve courante item 1055

Audit du lien local AD/vol de vie clos pour sa portée testée : 4/4 tests d’intégration courants réussis. Le reçu natif et le membership des audits précédents sont réutilisés. Les deux tâches restent a_faire, implementation/acceptance false; la réussite ne qualifie pas le serveur historique. Rapport : docs/AUDIT_SYS01202_ITEM1055_CURRENT_TEST_LINK_2026-11-02.md.

Prochaine action : choisir une exigence source-consommateur distincte, hors items 1001, 1004, 1006, 1011, 1018, 1029, 1036, 1042, 1051, 1052, 1053 et 1055; privilégier les reçus et consumers courants déjà établis, puis vérifier un nominal et une limite. D01-SYS-01-1 et SYS-01.2-02 restent ouverts. Ne modifier aucun statut, goal, plan, application ou base de suivi.


## V822 — échelles de base revalidées contre le worktree courant

Les12différences d’un ULP du reçu ancien ne sont plus présentes dans le manifeste courant : 122/122 valeurs sont exactes dans le test réel du consumer/AssetServer (2 tests passés). Fizz skin 105000 demande 0x6766a63f, égal à la référence. Le résultat ne qualifie ni chargement GLTF/GPU ni sélection historique effective des fichiers; la tâche apparence Fizz reste ouverte. L’ancien reçu est gardé tel quel; addendum dans docs/FIDELITY_ACTUAL_RUST_BASE_SCALE_4_20.md.

Prochaine action : ouvrir uniquement le maillon effectif de OLU-29959b0b-cd97-5abc-95c8-cd9eb1520f01 à partir des reçus existants V24–V37; préciser son entrée manquante et son consumer Rust. Ne pas refaire les campagnes REA complètes ni modifier les statuts, goal, Plan, application ou base de suivi.


## V823 — SYS-01.2-02, frontiere `system.cfg`

Le controle source-consommateur de `RADS/system/system.cfg` est clos pour le code actuel : la source OLS-daf85bfb-e3ba-57d2-a854-e4a20e822e76 declare EUW, mais aucune lecture du fichier/cles `system.cfg`, `DownloadURL` ou `DownloadPath` n'a ete trouvee dans les sources Rust/launcher inspectees. Le demarrage normal prend sa racine dans le projet compile (`main.rs:518`) puis lit le catalogue/HUD depuis cette racine (`main.rs:599-600`). La source est referencee par SYS-01.1-01 et SYS-01.1-03, pas par SYS-01.2-02. Detail : `docs/FIDELITY_LOCALE_FONT_LINKS_4_20.md`.

Ce resultat ferme uniquement l'inventaire du consommateur courant pour ce fichier; le bootstrap historique, la release effective, l'ordre des overlays et le demarrage EUW restent a prouver. Ne pas refaire le meme grep. Prochain petit lot : reprendre OLU-29959b0b-cd97-5abc-95c8-cd9eb1520f01 sur les recus V24-V37 pour un seul appelant/chemin de configuration historique; condition de reprise : trace native liee a la release qui montre le chemin effectivement selectionne. A defaut, consigner l'entree manquante et choisir un autre lien source-consommateur deja muni de preuves reutilisables. Goal et statuts restent actifs/inchanges.


## V824 — identite des consommateurs courants dans SYS-01.2-02

La resolution courante de la fiche contient 1 319 consommateurs. Controle cible ajoute au rapport `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` : les 54 entrees taguees `current_workspace` correspondent a 15 fichiers F:; tailles/SHA-256 enregistres et ancres ligne/needle exactes : 54/54, aucun echec. Le controle preexistant de 5 759 ancres reste reutilise. Les 1 265 autres consommateurs ne sont pas des sources `current_workspace`; les empreintes de ces elements et la pertinence semantique globale ne sont pas certifiees par ce lot. Aucun registre/tache/goal/Plan/app/base n'a change.

Prochaine action : reprendre l'inconnue OLU-29959 uniquement sur une trace native liee a la release qui etablit le chemin de configuration effectif; ne pas relancer l'inventaire d'ancres ni les hashes globaux. SYS-01.2-02 reste `partiel_a_terminer`, avec cinq inconnues ouvertes.


## V825 — verification ciblee du lien source/consumer sur F:

Extension du controle d'ancres : 1 305 consommateurs sur 1 319 resolvent vers F:. Pour ces 1 305, les chemins source/consumer relatifs concordent, les SHA-256/tailles du registre correspondent a 423 fichiers uniques et les ancres ligne/needle passent 1 305/1 305. Les 277 anciennes sources E:\OpenLeague ont ete verifiees via leur chemin relatif exact sur F:; aucune lecture/ecriture de E:. Les 14 autres consumer paths appartiennent a E:\mapslol3v3 : hashes non revalides ici; preuve d'ancres precedente 5 759/5 759 reutilisee. Le lien semantique complet, les sources natives et les cinq inconnues restent ouverts. Rapport : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.

Reprise : ne pas relancer les ancres ni la validation d'empreintes F deja faite. OLU-29959 requiert encore une trace native liee a la release qui etablit le chemin de configuration effectif; a defaut, poursuivre un autre lien source-consumer requis sans recu dedie. Registre de taches/goal/Plan/app/base inchanges.


## V826 — les 14 consumers externes ne sont pas des consumers du jeu F:

Roles et chemins : diagnostics `audit_assets.py`, readers LeagueToolkit pour les formats ANM/SKL/SKN/SCB, verification de references et generation de rapports dans `E:\mapslol3v3`. Recherche bornee dans les sources/manifeste de F: sans reference aux emplacements specifiques; fixtures F: vers E: sont d'autres chemins d'observation. Les 14 restent dans le registre sans etre comptes comme consumers gameplay OpenLeague. Les 1 305 consumers F: de V825 restent verifies par chemins/hashes/ancres. Aucun contenu E: ni registre n'a ete modifie; details dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.

Suite : ne pas refaire les controles d'ancres/source F. OLU-29959 requiert encore une trace native de la release qui identifie la configuration effectivement choisie; en parallele, poursuivre les relations de code F: requises sans recu semantique dedie. Goal/tache restent ouverts.

## V827 — SYS-01.2-02, objet 3108 : lien AP

Réutilisé : INIBIN natif 3108 décodé à 30 AP, hash/membership inchangés; l’entrée locale a ability_power=30 et la même empreinte de source. Le chemin courant passe par catalogue, shop::bonuses, puis progression::stats. La table Map10 autorise 3108. Le binaire existant map10_shop_admission-a6a46c157264e4a3.exe a été exécuté directement : 5/5 passés, dont achat des 31 admis (incluant 3108), refus atomique de 1038/1058 et métadonnée inconnue. L’achat est vérifié, mais le test ne mesure pas les AP de 3108. cargo test n’a pas compilé à cause de l’ouverture refusée du .cargo-build-lock; pas de rebuild. Le rapport docs/AUDIT_SYS01202_ITEM3108_ICON_2026-11-02.md distingue cette limite.

Clôture de ce seul sous-audit AP statique. Restent tâche/goal, prérequis D01-SYS-01-1, cinq inconnues, CDR numérique natif, test AP spécifique, rendu boutique et lien de trace shop_ui.rs:233. Aucun code, registre, Plan, suivi ou base modifié. Reprendre sur un lien distinct déjà prouvé; ne pas relancer le décodage 3108 ou les rescans globaux.

## V828 — SYS-01.2-02, vitesse d’attaque 3101

Le binaire unitaire existant a passé shop::tests::boots_group_is_unique_and_dagger_changes_attack_cadence : 1/1. La Dague 1042 confirme le consumer partagé Bonuses.attack_speed → cadence; la vente restaure la base, le doublon de bottes est refusé. Les hashes courants du consumer et des catalogues correspondent au reçu de l’audit 3101. Pas de recompilation. Ce test ne passe pas 3101 et ne vérifie pas +0,4 pour cet objet. Détails et SHA du binaire : docs/AUDIT_SYS01202_ITEM3101_ATTACK_SPEED_2026-11-02.md.

Le consumer générique est vérifié; le comportement 3101 et le serveur historique restent ouverts. Aucun code, registre, Plan, app, base ou goal modifié. Suite : une exigence distincte avec source native et consumer courants déjà prouvés; éviter les rehashes et résolveurs globaux.

## V829 — SYS-01.2-02, maîtrise 4312 : audit réutilisé

Le lot d’audit du consommateur courant est déjà documenté : `FIDELITY_MASTERY_NATIVE_RESOURCE_RESEARCH_4_20.md` précise qu’aucun consommateur de maîtrise n’est intégré/appelé dans le périmètre Rust inspecté. La source native `DATA/Talents/4312.inibin` (117 octets, SHA-256 `4f9649272546f535b97c1f5728b8c07391cee20a046a04f1af9324ee2e415676`) est reliée au manifeste sélectionné; l’écart `SpellData.Ranks=4` / catalogue Data Dragon 4.20.1 `ranks=3` et l’autorité AIR du `Talent.maxRank` reçu sont déjà détaillés dans les rapports de maîtrises et de pages.

Critère d’audit : identifier un consumer actif ou documenter son absence dans un périmètre borné, avec la limite et la condition de reprise. Résultat : l’absence du consumer courant est auditée; le plafond historique effectif, la disponibilité EUW et la fonctionnalité de maîtrises restent ouverts. Une recherche ciblée actuelle n’a trouvé qu’un commentaire de non-prise-en-charge dans `passive_gold.rs:19`; aucun nouveau scan, test, build, rapport ni code n’est nécessaire pour répéter ce constat.

Reprise uniquement avec une nouvelle preuve primaire du lecteur natif ou du payload EUW 4.20 `Talent.maxRank`, puis un consumer Rust vérifiable. Ne pas assimiler la présence du fichier ou le catalogue 4.20.1 à une preuve de plafond/ disponibilité historique. Goal et registres de tâches inchangés; audit de présence du consumer clos, feature non terminée.

Références réutilisées : `FIDELITY_MASTERY_CAP_AUTHORITY_4_20.md`, `FIDELITY_MASTERY_NATIVE_RESOURCE_RESEARCH_4_20.md`, `FIDELITY_PAGE_LOADOUT_LINKS_4_20.md`.
## V830 — SYS-01.2-02, objet 1028 : FlatHPPoolMod

Source native OLS-7a32193c-65dc-5a1e-b22f-bd25de211842 rehachée (605 octets, SHA-256 228dc37a…f5b082), membership au manifeste sélectionné; valeur décodée déjà enregistrée : 150 PV. La donnée locale porte le même hash et la valeur 150, admission Map10 vraie. Le chemin shop::bonuses → progression::stats a été exercé par trois tests directs existants : achat +150 sans soin instantané, vente avec clamp sans réanimation, persistance niveau/mort/réapparition; le test de refus générique boutique passe aussi. Binaire existant SHA-256 46D373…F74E6D, sans recompilation. Rapport : docs/AUDIT_SYS01202_ITEM1028_HEALTH_POOL_2026-11-02.md. Sous-audit de ce lien clos; ITEM-1028-SCOPE, serveur historique et acceptation restent ouverts.

## V831 — SYS-01.2-02, objet 1027 : FlatMPPoolMod

Source native OLS-b2c39141-e7bc-585f-aff1-804f84914c55 rehachée (548 octets, SHA-256 0f9a8f…c378852), membership au manifeste sélectionné; valeur décodée déjà enregistrée : 200 mana. La donnée locale a le même hash et l’admission Map10 est vraie. Le test direct existant confirme +200 au maximum d’Ahri, aucun effet sur la ressource énergie d’Akali et aucun revenu mana inventé par l’objet 1004 pour Akali : 1/1. Même binaire préexistant, sans recompilation. Rapport : docs/AUDIT_SYS01202_ITEM1027_MANA_POOL_2026-11-02.md. Sous-audit de ce lien clos; ITEM-1027-SCOPE, sémantique serveur et acceptation restent ouverts.

Prochain lot borné : ITEM-1026-SCOPE, Blasting Wand. Qualifier uniquement son champ natif de puissance magique, son membre de manifeste et le chemin shop::bonuses → progression::stats; vérifier si un test courant mesure cet ID, puis un cas nominal et une limite. Ne pas refaire les liens 1027/1028. Goal et registres de tâches restent inchangés.
## V832 — SYS-01.2-02, objet 1026 : FlatMagicDamageMod

La source native OLS-6b884efb-f313-5720-8023-497e92cb7925 a été rehachée et décodée avec le lecteur INIBIN local en lecture seule : 40 AP, 860 or, InStore et CanBeSold vrais; membre du manifeste 4.20 vérifié. Le catalogue local porte AP 40 et le même SHA source; Map10 admet 1026. Le lien shop.rs → progression.rs est établi statiquement. Les trois contrôles précompilés passent : achat normal dans la boucle des 31 objets admis, refus atomique 1038/1058, et admission inconnue refusée. Binaire SHA-256 7791975…4A80; aucun rebuild. Aucun test ne mesure les AP de 1026 après achat; le comportement statistique runtime reste ouvert. Rapport : docs/AUDIT_SYS01202_ITEM1026_ABILITY_POWER_2026-11-02.md. La tâche complète ITEM-1026-SCOPE reste partielle.

Prochain lot : choisir une exigence requise distincte avec source primaire et consumer courant déjà disponibles; définir avant vérification un nominal et une limite/refus, puis séparer lien statique, comportement exécuté et lacune. Réutiliser les reçus existants et ne pas refaire les audits 1026–1028. Goal et registres restent actifs/inchangés.
## V833 — SYS-01.2-02, objet 3801 : recette et stats

La source native OLS-fe282525-62eb-5edb-94f0-9a24c47f5350 est rehashée et membre du manifeste 4.20. Le décodage en lecture seule confirme Price=20, composants 1028/1006, +200 santé, +50 % de régénération et InStore/CanBeSold vrais; la donnée locale porte le même hash et un prix total de 600. Deux tests directs passent : composition au coût incrémental de 20 avec consommation des deux composants et stats non doublées; limite générique empêchant de consommer deux fois le même emplacement. Binaire core préexistant SHA-256 46D373…F74E6D; aucun rebuild. Rapport : docs/AUDIT_SYS01202_ITEM3801_RECIPE_STATS_2026-11-02.md.

Audit du parcours recette/consumer clos. ITEM-3801-SCOPE reste partiel : prix de vente natif, règles serveur, disponibilité historique et acceptation non établis. Aucun code ni statut modifié. Prochain lot : une exigence requise distincte, en réutilisant les preuves existantes et en définissant le cas nominal/la limite avant contrôle; ne pas refaire le parcours 3801 ou les objets 1026–1028.

## V834 — SYS-01.2-02, objet 1031 : recette et armure

Le sous-audit local source/donnée/consumer est clos : recette 1029→1031, coût restant 450, +40 armure, admission Map10. Deux tests existants passent (nominal et refus sans mutation) sur le binaire précompilé SHA-256 46D373…F74E6D; la provenance de compilation face aux sources actuelles n’est pas certifiée. Le V802 sur 1033 a également reçu un contrôle de test réutilisé, sans vérifier directement sa valeur de base ou sa vente. Rapports et limites : docs/ai/CURRENT.md et docs/AUDIT_SYS01202_ITEM1031_ARMOR_RECIPE_2026-11-02.md.

ITEM-1031-SCOPE et SYS-01.2-02 restent ouverts; disponibilité historique, prix de vente serveur, priorité runtime et acceptation restent à prouver. Aucun code, registre, goal, Plan, application ou base modifié. Suite : une liaison requise distincte après déduplication; éviter les lots déjà cités ci-dessus.


## V835 — SYS-01.2-02, objet 1038 : admission Map10

Audit documentaire du chemin source→catalogue→admission→refus clos pour Map10. InStore=true dans l’INIBIN n’est pas une preuve d’admission sur la carte; la donnée locale et le comparatif officiel Data Dragon 4.20.1 indiquent tous deux le refus 1038. Le consumer shop::buy_item rejette avant devis. Le test atomique 1038/1058 est réutilisé depuis V832, sans nouvelle exécution; son binaire du 21 octobre n’est pas relié aux sources actuelles. La disponibilité historique 4.20.0.315/EUW, les autres cartes et l’acceptation restent ouvertes. Rapport : docs/AUDIT_SYS01202_ITEM1038_MAP10_REFUSAL_2026-11-02.md.

ITEM-1038-SCOPE et SYS-01.2-02 restent partiels. Aucun code, registre, goal, Plan, app ou base modifié; aucun test/build exécuté dans V835. Prochaine unité : ITEM-1037-SCOPE, après réutilisation contrôlée des reçus existants.


## V836 — SYS-01.2-02, objet 1037 : bonus de dégâts

La source native 1037 et son membership existants sont réutilisés; le catalogue local concorde sur FlatPhysicalDamageMod=25 et le prix 875. Map10 autorise l’objet; shop::bonuses et progression::stats sont ses consumers actuels. Les cinq empreintes des sources/catalogues sont identiques à V832. Le test précompilé des 31 objets admis inclut 1037 pour achat, inventaire et débit, sans mesurer Stats.damage. Aucun test n’a été relancé; le binaire d’octobre n’est pas relié exactement aux sources courantes. Rapport : docs/AUDIT_SYS01202_ITEM1037_DAMAGE_PURCHASE_2026-11-02.md.

Lien d’audit local documenté; ITEM-1037-SCOPE reste partiel et le bonus +25 n’est pas validé en runtime. Disponibilité historique, revente native et acceptation restent ouvertes. Aucun code, statut, goal, Plan, application ou base modifié. Prochain lot : une exigence requise distincte, choisie après déduplication.


## V837 — SYS-01.2-02, objet 2003 : consumer consommable

Source native OLS-60c40120-0caa-524d-949f-a67b04c48944 et membership réutilisées; le consumer Rust actuel use_item/advance_consumables est identifié. L’effet 150 PV/15 s est porté par la donnée locale appuyée sur la description/fiche 4.20.1; le corps serveur historique n’est pas récupéré. Les reçus potion du 4 octobre sont complets=false et leurs six empreintes suivies diffèrent de l’arbre courant; aucune preuve de test actuelle n’en est déduite. Aucun test/build relancé. ITEM-2003-SCOPE et SYS-01.2-02 restent ouverts. Détails réutilisés : docs/potion_sources.json, docs/potion_integration_progress.json, docs/potion_live_validation.json, docs/potion_network_validation.json; décision de fraîcheur : docs/ai/CURRENT.md.

Suite précise : ITEM-2004-SCOPE, comparer son SpellName et son consumer mana au même jeu de reçus sans répéter les validations communes.


## V838 — SYS-01.2-02, objet 2004 : consumer mana

La source OLS-7280ca15-830f-5756-a845-ac1a23ff6cf1 identifie FlaskOfCrystalWater et sa membership. Le catalogue local associe la même empreinte à 100 mana/15 s, prix 35 et admission Map10. use_item et advance_consumables sont les consumers actuels; les gardes sans mana/mana plein sont présentes. Les valeurs d’effet proviennent de la référence 4.20.1, le corps serveur n’est pas récupéré. Réutiliser les reçus potion incomplets du 4 octobre avec la réserve de fraîcheur V837; aucune suite exécutée dans ce lot. Détails dans docs/ai/CURRENT.md et les quatre reçus potion.

ITEM-2004-SCOPE reste partiel; acceptation et preuve serveur/runtime actuelles ouvertes. Aucun code, registre, goal, Plan, application ou base modifié. Suite : autre relation requise sans reçu dédié après déduplication.


## V839 — SYS-01.2-02, unité item 2001

Audit statique terminé pour la présence/absence du consumer actuel : source native déjà comparée, ID absent de shop_foundation.json, achat/quote Core et UI liés au catalogue; 2003/2004 sont contrôles nominaux statiques. Aucun test/build/runtime. Fonctionnalité 2001 et appartenance EUW/Map10 restent inconnues; aucun statut parent modifié. Rapport : docs/AUDIT_SYS01202_ITEM2001_CONSUMER_ABSENCE_2026-11-02.md.

Prochain lot : choisir une liaison distincte après déduplication; éviter de rouvrir 2001 sans export décodé, membership ou règle serveur versionnée. Goal parent actif.


## V840 — SYS-01.2-02, unité item 3135

Audit statique du passif 35 % clôturé pour source, donnée, admission Map10, Stats et consumer de mitigation. Exécution actuelle non prouvée : reçus du 4 octobre incomplets et plusieurs empreintes consumer/catalogue modifiées. Aucune tâche parente/statut, goal, Plan, application ou base modifiée; aucun test/build/runtime lancé.

Prochaine unité : choisir une relation distincte après déduplication. Garder la vérification runtime 3135 ouverte; reprendre sur autorisation de vérification conforme aux consignes ou sur nouvelle preuve runtime liée aux sources présentes. Détails : docs/AUDIT_SYS01202_ITEM3135_MAGIC_PENETRATION_CONSUMER_2026-11-02.md.

## V841 — SYS-01.2-02, item 3035

Rapport documentaire ajouté pour le lien natif 3035 → catalogue/admission Map10 → Stats → pénétration physique → mitigation. Le sous-audit statique est clos; aucune exécution des tests, compilation, binaire ou runtime. Empreintes courantes et écarts sont consignés dans le rapport. La fidélité serveur/réseau, la precedence runtime, l’empilement et l’acceptation sont ouverts. Tâches, goal, Plan, UI et bases de suivi inchangés. Étape suivante : une liaison distincte non couverte, après déduplication.

## V842 — SYS-01.2-02, item 3134

Nouvelle cartographie statique limitée à `Effect2Amount=10` → bonus local d’armure plate → consumer physique, en réutilisant le lien commun et les empreintes du rapport V841. Source native rehachée, membership et comparaison communautaire 72/72 identifiés. Tests repérés mais non exécutés; pas de build/runtime. Rapport : `docs/AUDIT_SYS01202_ITEM3134_FLAT_ARMOR_PENETRATION_2026-11-02.md`. L’objectif global, les tâches, l’app, l’UI et la base sont inchangés.

## V843 — SYS-01.2-02, item 3020

Cartographie statique bornée du champ `Effect1Amount=15` jusqu’au bonus local et au consumer de dégâts magiques. Source rehashée, membership, admission Map10 et test source réutilisable. Le résumé de comparaison mentionne une clé native manquante sans l’identifier; les 52 champs communautaires `Values.Data` ciblés sont présents dans l’INIBIN. Pas de test/build/runtime; sémantique serveur et acceptation ouvertes. Rapport : `docs/AUDIT_SYS01202_ITEM3020_FLAT_MAGIC_PENETRATION_2026-11-02.md`. Goal et statuts inchangés.

## V844 — SYS-01.2-02, item 3136

Le champ INIBIN générique `Effect1Amount=15` est relié sémantiquement au passif via le texte primaire natif en_GB; source de localisation hachée et membership confirmés. Catalogue/admission/consumer commun réutilisés, tests sources identifiés mais non exécutés. Le mapping documentaire de cet effet est clos; exécution actuelle et sémantique serveur restent ouvertes. Rapport : `docs/AUDIT_SYS01202_ITEM3136_MAGIC_PENETRATION_2026-11-02.md`. Goal, tâches, app et base inchangés.

## V845 — SYS-01.2-02, item 3114

Le champ natif `PercentBaseMPRegenMod≈0,6`, le tooltip en_GB, la donnée Map10 et le consumer courant de régénération ont été reliés. Le sous-audit statique est clos. Le contrôle gameplay 1004 hérité est explicitement limité et ne prouve pas 3114; aucun test/build/runtime de 3114 exécuté. Rapport : `docs/AUDIT_SYS01202_ITEM3114_BASE_MANA_REGEN_2026-11-02.md`. Objectif et app inchangés.


## V846 — reprise SYS-01.2-02

Réutiliser V841–V845 pour les liens natifs. Le binaire penetration exécuté directement a passé 7/7 tests sur le simulateur local; empreintes et limites sont dans docs/AUDIT_SYS01202_PENETRATION_CURRENT_TESTS_2026-11-02.md. La commande Cargo a été bloquée avant test par l’accès refusé à target/debug/.cargo-build-lock, donc aucun build n’est revendiqué. Prochaine unité bornée : preuve runtime locale propre à 3114 (+60 % de régénération mana, un tick/seconde non plafonné, vente et cas non-mana). Le statut parent demeure ouvert; pas de modification de goal, registre, Plan, UI, app, base ou checkpoint.

## V847 — reprise SYS-01.2-02

Réutiliser le rapport de traçabilité, supplément V847. Le résolveur nominal/refus et la validation de structure passent sous Python `.ai-tools/.venv` 3.12.14; Python système 3.10.11 échoue sur Path.is_junction. Aucun fichier source n’a été re-haché par la validation. Ne pas relancer verify-files tant que les 11 289 sources E:/OpenLeague et 2 803 chemins hors allowlist n’ont pas une politique explicite. Les cinq inconnues OLU-3293, OLU-29959, OLU-6c4, OLU-f76 et OLU-0ae restent ouvertes; reprendre seulement sur une nouvelle preuve primaire. Parent toujours partiel. Registres, tâches, goal, Plan, app/UI/base inchangés.

## V848 — reprise OLU-3293

Ne pas répéter les cas zéro-state déjà exécutés. REA/backends ne sont pas disponibles localement et rea-agents n’est pas en cache; aucun téléchargement ni setup permis sous la restriction actuelle. Reprendre uniquement avec un backend déjà autorisé ou un artefact primaire du writer de 0x14ae870 et des tables effectives. Les cinq inconnues du parent restent ouvertes.

## V849 — reprise skin reference

Vérification ciblée Morgana base : OLS-1cb4... (INIBIN SHA c99edc...) vers OLC-e1d9.../native_skin_reference.py:31. Nominal 25000 exact; mismatch 25001 refusé. Le helper F (SHA 8649...) correspond à l’identité E enregistrée; aucune lecture E. Le module insère toutefois E en tête d’import, contourné par préchargement du vrai helper F pour ce test. Parent de fidélité toujours partiel; poursuivre une seule autre relation explicite F/D, sans étendre ce résultat aux skins ou au rendu.


## V850 — reprise SYS-01.2-02

Le SkinID 25001 de Morgana skin 1 est lié à `MeshSkin1`/FallenMorgana par le consumer courant et correspond exactement à la ligne du registre; l’ID 25002 est refusé. Probe Python 3.12.14 avec helper F préchargé : l’import ordinaire vise encore E:/OpenLeague et demeure non qualifié. Mapping statique seulement, aucune preuve runtime/visuelle, tâche et statut inchangés. Rapport : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, supplément V850.

Prochaine action : sélectionner une relation source-consommateur active distincte avec ses preuves enregistrées; ne pas répéter V849/V850 ni rouvrir les cinq inconnues sans nouvelle source primaire. Goal actif; aucun changement de goal, registre, Plan, app ou base.



## V851 — reprise SYS-01.2-02

Replay complet du registre peau réussi : 668/668, compteurs concordants. 656 SkinID explicites résolus, 5 équivalents, 7 Renekton ambigus. Pour les SkinID 58000–58006, `Skins/SkinNN/SkinNN.inibin` et la section dans `Renekton.inibin` donnent des échelles différentes (dédié 1,56 sauf Skin04 à 1,48; parent 1,60). Condition de reprise : preuve primaire de priorité du chargeur 4.20 ou trace runtime du fichier/échelle chargés. L’import normal du module n’est pas qualifié car il privilégie E:/OpenLeague; le replay a injecté le helper F: et lu la référence D:. Pas d’installation, code ou statut changé. Rapport : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, supplément V851.

Prochaine action : rechercher uniquement la preuve de priorité pour le conflit Renekton à partir d’un nouvel indice natif; si absente, conserver les 7 inconnues de valeur effective et passer à un lien distinct déjà étayé. Goal actif, app et base inchangées.



## V852 — reprise SYS-01.2-02

Les 8 fichiers Renekton en conflit ont été comparés au manifeste client sélectionné : 8/8 concordent. Parent Renekton.inibin : contenu 0.0.1.7; configs dédiées base + Skin01–06 : contenu 0.0.0.249. Ceci atteste la provenance RADS, pas la priorité effective. La recherche publique ciblée n’a trouvé aucune règle 4.20; Riot 2017/LeagueToolkit ne couvrent pas ce comportement historique. Conditions de reprise : provider natif 4.20 ou trace runtime exact fichier + SkinScale. Pas de changement de code/status/goal/app/base. Rapport : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, suppléments V851–V852.



## V853 — reprise SYS-01.2-02

Sources 4312/4313 liées au registre actif et membres du manifeste client. Audit courant du runtime : aucun consumer gameplay de maîtrise; les rangs natifs 4 versus Data Dragon 3 ne prouvent pas `Talent.maxRank`. Audit consommateur clos pour l’absence actuelle, fonctionnalités et tâches toujours ouvertes. Reprendre avec lecteur natif/server payload du plafond et consumer gameplay. Rapport : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V853; détails : docs/FIDELITY_MASTERY_NATIVE_RESOURCE_RESEARCH_4_20.md.



## V854 — reprise SYS-01.2-02

Revalidation item 1027 : sous-trace sans inconnue de lien; source native et consumer enregistrés. Les quatre hashes courants code/données correspondent au reçu V828; le binaire V831 exact exécute le test 1027 1/1. Cargo a échoué avant test sur accès refusé au build-lock, aucune recompilation. Simulateur seulement; scope item et acceptation restent ouverts. Rapport : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md V854; détail V831 dans docs/AUDIT_SYS01202_ITEM1027_MANA_POOL_2026-11-02.md.


## V855 — reprise SYS-01.2-02

Lien ciblé 1033 terminé : source OLS-46571491 et consumer OLC-b38bc16e; fichier natif rehaché, membership RADS confirmé, FlatSpellBlockMod=25 relié au magic_resist=25 du catalogue puis aux stats et à la mitigation. Deux tests directs sur le binaire existant passent. Le test 1033 ne couvre pas l’achat ni l’assertion numérique +25; le refus testé porte sur 1057. ITEM-1033-SCOPE et le parent restent ouverts. Aucun code, registre de tâches, goal, app ou base de suivi modifié. Rapport : docs/AUDIT_SYS01202_ITEM1033_MAGIC_RESIST_2026-11-02.md et supplément V855 dans docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

Reprise sur une paire source-consumer distincte dans le registre parent, sans répéter les vérifications stables 1027/1033. Priorité aux petits lots clôturables; conserver inconnues et critères précis, distinguer audit local, feature et acceptation historique/humaine.

## V856 — reprise SYS-01.2-02

Potion 2003 : source item rehachée et membre RADS 0.0.1.7; INIBIN = UseEffect/RegenerationPotion/MaxStack 5. La valeur 150/15 vient du catalogue 4.20.1, non de l’INIBIN item. Le consumer existant est consumables.rs:8/25, mais n’est pas relié dans le sous-trace, qui ne liste que shop.rs:69. Le INIBIN et le luaobj du sort sont dans le registre global mais pas dans la trace 2003; ils ne sont pas décodés/exécutés. Quatre tests directs passent sur le binaire SHA-256 46D373…F74E6D; aucun build. ITEM-2003-SCOPE reste partiel. Rapport : docs/AUDIT_SYS01202_ITEM2003_HEALTH_POTION_2026-11-02.md; index V856 : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

Reprise : traiter ITEM-2004-SCOPE à part avec le même critère, sans répéter les contrôles 2003; conserver le goal, l’application de suivi et ses bases inchangés.

## V857 — reprise SYS-01.2-02

Item 2004 vérifié : INIBIN natif 518 octets rehaché, membership 0.0.1.7, UseEffect/FlaskOfCrystalWater/MaxStack5. Catalogue 4.20.1 = 100 mana/15 s; la donnée locale concorde. Nouveau test direct Ignite vs 2004 réussi; le +100 mana/450 ticks et le refus sur champion manaless sont réutilisés de V856 après revalidation des empreintes. Le sous-trace ne relie pas consumables.rs ni le INIBIN/luaobj natifs du sort. Pas de build ni changement de code/statut/trace/app/base. Rapport : docs/AUDIT_SYS01202_ITEM2004_MANA_POTION_2026-11-02.md; index V857 dans docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

Prochaine unité : ITEM-3024-SCOPE (source dans le parent, consumer courant, rapport ciblé absent). Ne pas répéter 2003/2004; distinguer lien local, fidélité historique et acceptation.


## V858 — reprise SYS-01.2-02

ITEM-3024-SCOPE : mapping statique source → donnée locale → consumer documenté. Source INIBIN rehachée; membership RADS cohérent. Catalogue local : 950, recette 1027/1029, 250 mana, 20 armure et 0,1 CDR; la ligne native décodée n’affiche pas de champ numérique CDR. Map10=true local n’établit pas l’historique. Un test direct agrégé passe (plafond CDR et clamp négatif), sans test isolé 3024. La tâche reste partielle; aucune fonctionnalité ni acceptation complète n’est déclarée. Aucun code, statut, trace, goal, app ou base de suivi modifié. Le statut Git n’a pas pu être lu : accès F:\OpenLeague refusé par le bac à sable. Détail : docs/AUDIT_SYS01202_ITEM3024_GLACIAL_SHROUD_2026-11-02.md.

Prochain lot : vérifier précisément les IDs/sources/consumer de ITEM-3025-SCOPE; réutiliser les preuves stables et ne pas rejouer 2003/2004/3024.


## V859 — reprise SYS-01.2-02

ITEM-3025-SCOPE : source native 4.20.0.315 vérifiée (546 octets, hash concordant, membership release 0.0.0.243). Valeurs décodées : Price 750, InStore/CanBeSold vrais, +60 armure, +500 mana, recipe 3057/3024. L’item est absent du catalogue local et de Map10; shop.rs le refuse comme non implémenté avant la garde de carte. Le test de refus générique 1057 passe 1/1, mais 3025 n’a pas été directement passé au runtime. Ne pas convertir l’absence locale en décision historique de disponibilité. Tâche toujours a_qualifier; aucune tâche/trace/goal/code/Plan/app/base modifiée. Rapport : docs/AUDIT_SYS01202_ITEM3025_ICEBORN_GAUNTLET_REFUSAL_2026-11-02.md.

Prochain lot : vérifier la source officielle /data/3025 depuis son enregistrement versionné; ensuite ITEM-3026-SCOPE.


## V860 — complément source 3025

La source Data Dragon 4.20.1 OLS-b3343643 a été relue et son SHA (676c7ec0…ae259c1) concorde. L’entrée /data/3025 confirme base 750, total 2900, sell 2030, recette 3057/3024, stats +500 mana/+60 armure/+30 AP, +10 % CDR et Spellblade. Le champ maps est null : pas de décision historique Map10. La non-présence locale et le refus de shop.rs restent constatés; ne pas les confondre avec une interdiction historique. Le test exact 3025 demeure à faire si l’on doit qualifier le refus runtime. Aucun statut/goal/registre/code/Plan/app/base changé.

Reprise : passer à ITEM-3026-SCOPE; revenir sur 3025 seulement avec une source carte 10 ou une décision documentée de périmètre.


## V861 — décision de périmètre 3026

La source officielle Data Dragon 4.20.1 est explicite : Guardian Angel (3026) a maps["10"]=false et maps["12"]=false. L’INIBIN client confirme prix de base 1500, composants 1033/1031, armure 50 et MR 40; le catalogue précise total 2750, vente 1100 et passif de résurrection. L’absence locale Map10 est cohérente. Le consumer actuel refuse « not implemented » avant sa vérification Map10; test générique 1057 déjà réutilisé, pas de test 3026. Décision historique de périmètre documentée; aucun statut, goal, code, Plan, app ou base modifié.

Prochain lot : ITEM-3027-SCOPE; ne pas répéter les contrôles sources et génériques déjà prouvés.


## V862 — reprise ITEM-3027-SCOPE

La source native 3027 est re-hachée et le membership RADS du registre concorde. Le catalogue officiel 4.20.1 qualifie prix/recette/stats et les deux passifs; le champ maps manque, donc pas de preuve historique pour Map10. Le catalogue local et l’admission Map10 n’ont pas de 3027; shop.rs applique le refus « not implemented ». Le test générique 1057 de V859 est réutilisé, pas rejoué; aucun test 3027/pasif. Statut a_qualifier inchangé, aucune modification goal/registre/code/app/base.

Reprise : ITEM-3028-SCOPE; revenir à 3027 uniquement avec une preuve carte ou une décision de périmètre, et une source du passif natif si implémentation requise.


## V863 — reprise ITEM-3028-SCOPE

La source native 3028 rehachée concorde avec les champs officiels base 140, recette 1004/1033/1004, +25 MR et +50 % de régénération de mana de base. La source 4.20.1 donne total 1000, revente 700 et Mana Font (1,5 % du mana manquant par 5 s), mais n’a pas de champ maps. Objet absent des données boutique locales; consumer explicite de refus. Test générique 1057 réutilisé, aucune exécution de 3028/passif. ITEM-3028 reste a_qualifier. Aucun statut/goal/registre/code/Plan/app/base changé.

Reprise : ITEM-3029-SCOPE; revenir sur 3028 avec preuve Map10 ou source passive utile, sans répéter les hashes.


## V864 — décision Map10 pour 3029

La source officielle 4.20.1 marque explicitement la variante Rod of Ages (Crystal Scar) 3029 comme maps[10]=false. L’INIBIN est re-haché, base 740, recette 3010/1026, 450 PV et mana; le catalogue fixe total 2800, 60 AP, charges à 40 s et Valor’s Reward. L’absence locale Map10 est cohérente; shop.rs la refuse actuellement comme non implémentée. Le test générique de V859 est réutilisé. Aucun test direct ou changement de statut. ITEM-3029-SCOPE reste ouvert dans le registre malgré la preuve source de disponibilité.

Reprise : sélectionner la prochaine sous-tâche source-consumer après 3029, sans refaire les contrôles génériques.


## V865 — décision Map10 pour 3031

La source 4.20.1 est explicite : Infinity Edge 3031 a maps["10"]=false. L’INIBIN rehaché concorde sur prix de base 645, recette et bonus de dégâts/critique; catalogue officiel total 3800, revente 2660, passif 250 %. Données locales absentes, consumer refuse comme non implémenté avant sa garde Map10. Test inconnu 1057 réutilisé; aucun test 3031. Décision historique de périmètre documentée; task status a_qualifier inchangé.

Prochain lot : ITEM-3035-SCOPE.


## V866 — reprise item 3035

Reprise du rapport statique existant; source native rehachée concordante. Deux tests directs du binaire existant réussissent : dégâts sur unités avec 3035+3134 (100 armure, résultat attendu 100/1,55) et limites de effective (55, plancher 0, armure négative inchangée, invalides refusés). Aucun rebuild. Les tests ne couvrent pas le seul 3035. Map10 local=true, mais le catalogue officiel 4.20.1 omet maps; disponibilité historique reste inconnue. Serveur/acceptation non vérifiés. ITEM-3035-SCOPE partiel, aucun statut/code/goal/registre/app/base modifié.

Prochain lot : sélectionner la prochaine relation active non couverte; ne pas rejouer les tests 3035.


## V867 — reprise ITEM-3040-SCOPE

Source native 3040 rehachée. INIBIN InStore=0/UseEffect=true/SpellName ItemSeraphsEmbrace; Data Dragon 4.20.1 confirme achat direct interdit, évolution from 3003, stats, Insight et Mana Shield. Champ maps absent. Shop local n’a ni 3003 ni 3040 et le consumer refuse l’ID absent; recherche ciblée ne trouve pas de consumer d’évolution ou d’actif dans crates/core/src. Cela ne décide ni l’évolution historique ni Map10. Aucun test/runtime 3040. Statut a_qualifier inchangé; pas de code/status/goal/registre/Plan/app/base modifié.

Reprise sur source primaire de l’évolution et restrictions carte.


## V868 — décision Map10 pour 3041

La source officielle 4.20.1 confirme maps[10]=false pour Mejai’s Soulstealer. INIBIN rehaché : base 965, recette 1052, InStore=true; catalogue officiel total 1400 et passif à charges. L’admission locale est absente et le consumer refuse avant la garde carte; cela concorde avec l’indisponibilité Map10. Test inconnu 1057 réutilisé, pas de test direct 3041. Tâche a_qualifier inchangée.

Prochain lot : ITEM-3042-SCOPE.


## V869 — reprise ITEM-3042-SCOPE

INIBIN 3042 rehaché (585 octets); InStore=0, SpellName=Muramana, recette/évolution liée à 3004, +25 dégâts/+1000 mana/+25 % regen. Data Dragon 4.20.1 confirme purchasable=false, Awe et toggle Muramana. maps absent. Aucune donnée locale 3004/3042; consumer shop refuse les IDs absents. Test générique 1057 réutilisé; aucun test 3042. Ne pas confondre absence de données avec restriction Map10. Statut a_qualifier inchangé.

Reprise sur source d’évolution et périmètre carte.

## V870 — reprise ITEM-3043-SCOPE

Le natif 3043 (4.20.0.315) et le catalogue officiel 4.20.1 ont été vérifiés séparément. Le catalogue fixe purchasable=false et maps[10]=false; l’ID manque au shop local et le consumer renvoie item behavior not implemented. Le test générique couvre 1057 uniquement, sans preuve runtime spécifique à 3043. La recette officielle from=3008 contre les champs natifs RecipeItem1-4=0 reste à qualifier; l’évolution n’est pas acceptée.

Sous-audit version/catalogue/Map10 documenté. ITEM-3043-SCOPE reste a_qualifier; ne pas toucher au registre. Prochain lot vérifié dans le registre : ITEM-3044-SCOPE (Phage).
## V871 — reprise ITEM-3044-SCOPE

Natif 4.20.0.315 et catalogue officiel 4.20.1 vérifiés : Phage, base 565/total 1325, recette 1028+1036, purchasable=true, maps=null. Le catalogue et l’admission locale ne contiennent pas 3044; shop.rs refuse le comportement absent avant contrôle de carte. Le test générique inconnu couvre 1057 uniquement. Pas de test direct 3044. La disponibilité Map10 ne peut être inférée de maps=null ni de InStore=1.

Identité, prix et recette documentés; admission Map10/runtime non acceptées. ITEM-3044-SCOPE reste a_qualifier. Reprise uniquement si une source primaire Map10 ou une observation reproductible du client 4.20.0.315 devient disponible; ensuite test direct de 3044. Lot suivant après cette décision : ITEM-3046-SCOPE.
## V872 — reprise ITEM-3046-SCOPE

Phantom Dancer 3046 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; prix 520/total 2800, recette 1018+3086+1042, purchasable=true, maps=null. L’ID et l’admission Map10 sont absents du projet; shop.rs refuse le comportement non catalogué. Le test 1057 ne prouve pas 3046. Ne pas inférer Map10 à partir de InStore=1/maps=null; test direct non exécuté.

La fiche source est documentée, l’acceptation carte/runtime reste ouverte. ITEM-3046-SCOPE reste a_qualifier. Reprise uniquement si une source primaire Map10 ou une observation reproductible 4.20.0.315 tranche ce point. Suivant vérifié dans le registre : ITEM-3047-SCOPE (Ninja Tabi).
## V873 — reprise ITEM-3047-SCOPE

Ninja Tabi 3047 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 375/total 1000, recette 1001+1029, purchasable=true, maps=null. L’ID manque au catalogue local et à l’admission Map10; shop.rs le refuse comme non implémenté. Le test 1057 ne couvre pas l’ID 3047; aucun test direct exécuté.

Fiche source établie, disponibilité Map10 et runtime non acceptés. ITEM-3047-SCOPE reste a_qualifier. Reprise seulement avec une source Map10 ou une observation reproductible 4.20.0.315; ensuite test direct. Suivant vérifié : ITEM-3048-SCOPE (Seraph's Embrace).
## V874 — reprise ITEM-3048-SCOPE

Seraph's Embrace 3048 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés. Source native non achetable directement; la fiche officielle dit purchasable=false, from=3007 et maps[10]=false. L’ID et 3007 manquent au shop local; refus générique avant règle de carte. Aucun test direct 3048 ni actif; test 1057 réutilisé uniquement.

La décision Map10 est établie pour le catalogue officiel 4.20.1. L’évolution et son runtime ne le sont pas; ITEM-3048-SCOPE reste a_qualifier. Reprise sur source primaire/consumer 3007→3048. Suivant vérifié : ITEM-3050-SCOPE.
## V875 — reprise ITEM-3050-SCOPE

Zeke's Herald 3050 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; prix 800/total 2450, recette 3067+1053, purchasable=true, maps=null. L’ID manque au catalogue local et à l’admission Map10; shop.rs refuse l’ID absent. Le test générique couvre 1057 seulement; pas de test direct d’achat/aura 3050.

Source, prix et recette documentés; Map10 et aura runtime non acceptés. ITEM-3050-SCOPE reste a_qualifier. Reprise sur preuve primaire Map10 et consumer d’aura, sans refaire les sources vérifiées. Suivant : ITEM-3056-SCOPE.
## V876 — reprise ITEM-3056-SCOPE

Ohmwrecker 3056 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 750/total 2600, recette 2053+3067, purchasable=true. Le catalogue indique explicitement maps[12]=false mais ne donne pas de décision maps[10]. La ligne locale manque et shop.rs refuse l’ID absent; le test générique porte sur 1057, aucun test direct 3056 ou actif.

Ne pas inférer l’inclusion Map10 par absence de clé. ITEM-3056-SCOPE reste a_qualifier. Reprise sur preuve primaire Map10/observation client, puis test direct et actif. Suivant vérifié : ITEM-3057-SCOPE (Sheen).
## V877 — reprise ITEM-3057-SCOPE

Sheen 3057 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 365/total 1200, recette 1027+1052, purchasable=true, maps=null; into inclut 3025. L’ID manque au catalogue local/admission Map10; shop.rs le refuse avant la garde carte. Test générique sur 1057 seulement, aucun test direct 3057 ou Spellblade.

Fiche d’identité/prix/recette établie; Map10 et effet restent ouverts. ITEM-3057-SCOPE reste a_qualifier. Reprise sur une source primaire Map10 puis test direct, sans refaire les vérifications acquises. Suivant vérifié : ITEM-3060-SCOPE.
## V878 — reprise ITEM-3060-SCOPE

Banner of Command 3060 : source native 4.20.0.315 rehachée et Data Dragon 4.20.1 vérifié; base 280/total 3000, recette 3105+3108, purchasable=true, maps=null. L’ID manque au catalogue local; shop.rs refuse avant le contrôle de carte. Le test inconnu 1057 ne teste pas 3060; aucune preuve runtime d’aura ou Promote.

Identité/prix/recette documentés; Map10 et effets restent ouverts. ITEM-3060-SCOPE reste a_qualifier. Reprise sur source primaire Map10 et consumer Promote, sans répéter les hashes ou le test générique. Suivant vérifié : ITEM-3065-SCOPE.
## V879 — reprise ITEM-3065-SCOPE

Spirit Visage 3065 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 700/total 2750, recette 3211+3067, purchasable=true, maps=null. ID absent du catalogue local; shop.rs le refuse avant la garde de carte. Le test générique couvre 1057 uniquement; pas de test direct d’achat ou du passif.

Identité/prix/recette établis; Map10 et runtime restent ouverts. ITEM-3065-SCOPE reste a_qualifier. Reprise sur source primaire Map10 puis test direct, sans répéter les preuves acquises. Suivant vérifié : ITEM-3067-SCOPE, status partiel.
## V880 — reprise ITEM-3067-SCOPE

Kindlegem 3067 a une entrée native 4.20.0.315 et une ligne locale. Natif: base 450, recette 1028, InStore=1. Data Dragon: base 450/total 850/sell 595, recette 1028, maps=null. L’entrée locale (850, recette 1028, +200 HP/+10 % CDR, sell 595) est cohérente; l’admission Map10 locale est true, dérivée du catalogue 4.20.1.

La configuration et l’identité sont vérifiées, mais elle ne prouve pas seule la disponibilité historique Map10 du client 4.20.0.315. Aucun test direct/runtime 3067. ITEM-3067-SCOPE reste partial_a_terminer; ne pas toucher au registre. Reprise sur source Map10 ou justification de maps=null→allow, puis test direct. Vérifier ensuite ITEM-3068-SCOPE.
## V881 — reprise ITEM-3068-SCOPE

Sunfire Cape 3068 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 850/total 2600, recette 1031+1011, purchasable=true, maps=null. L’ID manque au shop local et à l’admission Map10; shop.rs le refuse avant la garde carte. Le test générique 1057 ne couvre pas 3068; aucun test direct/passif.

Identité, prix et recette établis; disponibilité Map10 et passif runtime restent ouverts. ITEM-3068-SCOPE reste a_qualifier. Reprise sur source primaire Map10 puis test direct, sans refaire les sources/hash. Suivant vérifié : ITEM-3069-SCOPE.
## V882 — reprise ITEM-3069-SCOPE

Talisman of Ascension 3069 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 635/total 2100/sell 840, recette 3096+3114, purchasable=true, maps=null. InStore=true ne qualifie pas Map10. L’ID manque au shop local et shop.rs le refuse. Test générique ID 1057 seulement; pas de test direct de l’achat, Favor, groupe GoldBase ou actif.

Fiche source établie, Map10/runtime ouverts. ITEM-3069-SCOPE reste a_qualifier. Reprise sur source Map10 puis vérification directe des effets, sans répéter la recherche source/catalogue. Suivant vérifié : ITEM-3070-SCOPE.
## V883 — reprise ITEM-3070-SCOPE

Tear of the Goddess 3070 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 140/total 720, recette 1027+1004, into 3003/3004, purchasable=true, maps=null. ID absent du shop local; shop.rs le refuse. Le test mana 1027 ne prouve ni achat ni stacking Tears; aucun test direct de la charge.

Identité/prix/recette documentés; Map10 et évolution restent ouverts. ITEM-3070-SCOPE reste a_qualifier. Reprise sur source Map10 et test direct de cadence/plafond, sans refaire les sources vérifiées. Suivant : ITEM-3071-SCOPE.
## V884 — reprise ITEM-3071-SCOPE

The Black Cleaver 3071 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 1263/total 3000, recette 3134+1028, purchasable=true, maps=null; valeurs et passif de réduction d’armure définis au catalogue. L’ID manque à shop_foundation/admission; shop.rs refuse avant la garde Map10. Le test générique 1057 ne prouve pas 3071; pas de test direct d’achat/passif.

Fiche source/prix/recette établie, Map10 et runtime non acceptés. ITEM-3071-SCOPE reste a_qualifier. Reprise sur source Map10 ou observation reproductible, puis test direct des charges. Suivant vérifié : ITEM-3072-SCOPE.
## V885 — reprise ITEM-3072-SCOPE

The Bloodthirster 3072 : natif 4.20.0.315 et catalogue Data Dragon 4.20.1 vérifiés; base 1150/total 3500, recette 1053+1038, purchasable=true, maps[10]=false et maps[12]=false. L’absence locale Map10 est cohérente avec cette restriction; shop.rs refuse néanmoins par la branche générique d’ID absent. Test 1057 seulement, aucun runtime Bloodthirster.

Source et exclusion Map10 du catalogue établies; fonctionnalité non implémentée/acceptée et statut a_qualifier inchangé. Reprise runtime lorsque l’implémentation est travaillée, sans refaire le lot source. Suivant vérifié : ITEM-3073-SCOPE.
## V886 — reprise ITEM-3073-SCOPE

Tear of the Goddess (Crystal Scar) 3073 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 140/total 720, recette 1027+1004, into 3007/3008. La fiche officielle exclut explicitement maps 10/12/1; aucune valeur map8. L’ID manque au shop Map10; le consumer le refuse avant la garde carte. Test générique 1057 seulement; pas de runtime 3073/charge.

Exclusion Map10 et fiche source documentées; comportement non implémenté/accepté et task status a_qualifier inchangé. Ne pas traiter l’absence de maps[8] comme inclusion. Suivant vérifié : ITEM-3074-SCOPE.
## V887 — reprise ITEM-3074-SCOPE

Ravenous Hydra (Melee Only) 3074 : natif 4.20.0.315 et Data Dragon 4.20.1 vérifiés; base 600/total 3300, recette 3077+1053, purchasable=true, maps=null. L’ID manque au shop local et shop.rs le refuse; aucune validation runtime de l’achat, de la restriction melee, Cleave ou Crescent. Test générique 1057 uniquement.

Fiche source/prix/recette établie; Map10 et effets restent ouverts. ITEM-3074-SCOPE reste a_qualifier. Reprise sur preuve Map10 et test direct complet, sans répéter les sources vérifiées. Suivant : ITEM-3075-SCOPE.
Complément 2026-11-02 — V888 / ITEM-3075-SCOPE : le lien de la source native vers le consumer courant est vérifié sur l’exigence `OLF-a1955857-23c0-59c3-b845-3e9fbaba609d`. Le SHA lu sur l’INIBIN 4.20.0.315 (502 octets) correspond au registre; la trace et le refus statique `shop.rs` sont reliés. Data Dragon 4.20.1 exclut Map10, mais la disponibilité historique 4.20.0.315 n’est pas établie. Audit de liaison clos; scope, implémentation et acceptation Thornmail restent ouverts. Aucun test/build/runtime exécuté. Rapport intégré à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V888); reprendre sur preuve primaire Map10, sans rehash ni test générique répété.
Complément 2026-11-02 — V889 / ITEM-3077-SCOPE : liaison source native 4.20.0.315 → catalogue 4.20.1 → consumer `shop.rs` statiquement vérifiée; empreinte enregistrée de l’INIBIN de 596 octets confirmée. Le catalogue 4.20.1 n’a pas de champ `maps` pour 3077 et le catalogue local ne contient pas l’ID. Audit de liaison clos seulement; scope Map10, implémentation et acceptation restent ouvertes. Pas de test/build/runtime direct. Détail intégré dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V889); reprendre sur preuve primaire 4.20.0.315 sans répéter les contrôles déjà faits.
Complément 2026-11-02 — V890 / ITEM-3078-SCOPE : source native 4.20.0.315 rehachée (589 octets; empreinte égale au registre), valeurs lues et lien vers le consumer de boutique courant vérifiés. L’objet manque aux catalogues locaux; Data Dragon 4.20.1 n’expose pas de champ `maps`. Seul le sous-audit de liaison est clos; la portée Map10, l’implémentation et l’acceptation restent ouvertes. Aucun test/build/runtime direct. Détails dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V890); reprendre sur preuve primaire datée sans refaire les contrôles.
Complément 2026-11-02 — V891 / ITEM-3083-SCOPE : l’exclusion Map10 est explicite dans le catalogue officiel Data Dragon 4.20.1 (`maps[10]=false`), cohérente avec l’absence locale de l’objet; le lien source/consumer natif est vérifié. L’audit de décision au niveau du catalogue est terminé. Pas de lancement du client ni de test; aucune feature terminée et aucun statut de registre changé. La preuve exacte d’exécution du build 4.20.0.315 reste conditionnée à une source primaire datée. Rapport intégré à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V891).
Complément 2026-11-02 — V892 / ITEM-3089-SCOPE : exclusion Map10 explicitement établie par Data Dragon officiel 4.20.1 (`maps[10]=false`), cohérente avec l’absence locale; INIBIN 4.20.0.315, empreinte et consumer courant sont reliés. Sous-audit de scope catalogue terminé, sans test/build/runtime ni feature déclarée. Le statut du registre n’a pas changé. Ne reprendre qu’en présence d’une source primaire 4.20.0.315 contradictoire. Détail intégré à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V892).
Complément 2026-11-02 — V893 / ITEM-3112-SCOPE : exclusion Map10 établie au niveau du catalogue officiel 4.20.1 (`maps[10]=false`); empreinte INIBIN 4.20.0.315 confirmée et liaison au consumer courant réutilisée. Sous-audit du périmètre catalogue terminé, mais bouclier/runtime/features non exécutés ni acceptés. Aucun statut de tâche modifié. Détail intégré dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V893); rouvrir seulement sur preuve primaire contradictoire pour 4.20.0.315.
Complément 2026-11-02 — V894 / ITEM-3128-SCOPE : le catalogue officiel 4.20.1 exclut Deathfire Grasp de Map10 (`maps[10]=false`); l’INIBIN exact 4.20.0.315 et le consumer de boutique courant sont liés. Audit du scope catalogue terminé; actif, fonctionnalité et runtime non validés. Aucun statut de tâche modifié. Ne reprendre que sur preuve primaire 4.20.0.315 contradictoire. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V894).
Complément 2026-11-02 — V895 / ITEM-3139-SCOPE : exclusion Map10 explicite dans Data Dragon officiel 4.20.1; source native et liaison au consumer de boutique courant vérifiées. Sous-audit du périmètre catalogue terminé; l’actif et la feature ne sont pas exécutés ni acceptés. Aucun statut de tâche modifié. Réouverture seulement sur preuve primaire 4.20.0.315 contradictoire. Détail intégré à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V895).
Complément 2026-11-02 — V896 / ITEM-3141-SCOPE : exclusion Map10 explicite dans le catalogue officiel 4.20.1, source native 4.20.0.315 et consumer shop reliés. Sous-audit de scope catalogue terminé; passif de stacks, runtime et feature ne sont pas validés. Aucun statut de tâche n’a changé. Reprise seulement sur preuve primaire 4.20.0.315 contradictoire. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V896).
Complément 2026-11-02 — V897 / ITEM-3154-SCOPE : exclusion de Wriggle's Lantern sur Map10 explicite dans Data Dragon officiel 4.20.1; INIBIN natif et consumer sont reliés. Sous-audit du scope catalogue terminé, sans test/runtime ni feature jungle/ward déclarée. Statut de tâche inchangé; ne rouvrir que sur source primaire 4.20.0.315 contradictoire. Détails dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V897).
Complément 2026-11-02 — V898 / ITEM-3157-SCOPE : exclusion Map10 explicite dans Data Dragon officiel 4.20.1; empreinte native 4.20.0.315 et consumer de boutique reliés. Sous-audit du scope catalogue clos; stase/runtime/feature non acceptés. Aucun statut modifié. Réouverture uniquement sur preuve primaire contradictoire du build cible. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V898).
Complément 2026-11-02 — V899 / ITEM-3166-SCOPE : l’entrée officielle 4.20.1 réserve Bonetooth Necklace à Rengar et exclut Map10; la source native et le consumer courant sont reliés, SHA vérifié. Sous-audit de scope catalogue terminé; totem/trophées et runtime non validés. Aucun statut n’a changé. Réouverture uniquement sur preuve primaire 4.20.0.315 contradictoire. Détails dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V899).
Complément 2026-11-02 — V900 / ITEM-3167-SCOPE : statut boutique et exclusion Map10 explicites dans Data Dragon officiel 4.20.1; `InStore=0` natif concordant, INIBIN et consumer reliés. Sous-audit de scope terminé; totem/trophées/runtime non acceptés. Aucun statut de tâche modifié. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V900).
Complément 2026-11-02 — V901 / ITEM-3168-SCOPE : l’entrée officielle 4.20.1 et l’INIBIN natif indiquent tous deux l’état hors boutique; `maps[10]=false` et la restriction Rengar sont explicites. Sous-audit de scope terminé; fonctionnalité et runtime non validés. Aucun statut modifié. Détails dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V901).
Complément 2026-11-02 — V902 / ITEM-3169-SCOPE : variante Rengar hors boutique et exclue de Map10 dans Data Dragon officiel 4.20.1; `InStore=0` natif concorde, liens source/consumer vérifiés. Sous-audit catalogue terminé; fonctionnalité non acceptée. Aucun statut modifié. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V902); reprendre uniquement sur source primaire contradictoire.
Complément 2026-11-02 — V903 / ITEM-3171-SCOPE : entrée officielle 4.20.1 hors boutique et exclue de Map10; l’INIBIN 4.20.0.315 indique `InStore=0`, empreinte vérifiée et consumer relié. Sous-audit catalogue terminé; passif/totem/runtime non acceptés. Aucun statut de tâche modifié. Réouverture seulement sur preuve primaire contradictoire. Détails intégrés à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V903).
Complément 2026-11-02 — V904 / ITEM-3175-SCOPE : fiche officielle 4.20.1 hors boutique et exclue de Map10; INIBIN natif de 591 octets, SHA-256 conforme au manifeste, InStore=0; lien source/consumer confirmé. L’ID absent des catalogues locaux est refusé statiquement par shop.rs:86. Audit documentaire du scope clos; précédence effective et runtime exact 4.20.0.315 restent ouverts. Actif/totem/trophées non implémentés ou acceptés. Aucun test/build/runtime ni statut de registre modifié. Reprendre seulement sur source primaire contradictoire; ne pas répéter le hash, la lecture INIBIN, le lookup ou la fiche 4.20.1. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V904).
Complément 2026-11-02 — V905 / ITEM-3180-SCOPE : Data Dragon officiel 4.20.1 indique purchasable=true mais maps[10]=false; l’INIBIN natif (592 octets, SHA-256 conforme) indique InStore=1, champ général qui ne contredit pas la restriction de carte. Source/consumer reliés; ID absent des catalogues locaux et refus statique dans shop.rs:86. Sous-audit catalogue terminé seulement; précédence effective et runtime exact 4.20.0.315 ouverts. Actif/passif non implémentés ou acceptés. Aucun test/build/runtime ni statut de registre modifié. Reprendre seulement sur preuve primaire contradictoire; ne pas répéter les contrôles. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V905).
Complément 2026-11-02 — V906 / filtre ITEM-3181-SCOPE : la fiche Data Dragon 4.20.1 intégrée ne contient que maps[1]=false; maps[10] absent. Ne pas inférer Map10. Le lot reste différé sans recherche supplémentaire, source/consumer non réaudités et statut inchangé. Reprendre sur preuve primaire datée 4.20.0.315 ou preuve de sélection runtime Map10. Référence : completion_tasks_2026-10-20.json, ITEM-3181-SCOPE.
Complément 2026-11-02 — V907 / OLU-29959 : les deux fichiers default locale de 37 octets (client D: et copie F:) sont byte-identiques, SHA-256 053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f, locale en_GB. Le consumer F est appelé au démarrage HUD par main.rs:600 → native_zip_provider.rs:116 → native_hud_font_configuration.rs:38 et lit directement la copie F. Cela ferme le maillon consumer de la copie courante seulement. Origine du Locale.cfg loose historique, writer/staging, arguments et précédence provider/overlay restent inconnus; OLU-29959 n’est pas close. Aucun test/build/runtime ni statut modifié. Reprise sur trace primaire de writer ou sélection effective 4.20.0.315; ne pas refaire les hashes ou la lecture statique. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V907).


## V908 — reprise SYS-01.2-02

Lot documentaire en_GB shop clos : le PE client 4.20.0.315 (SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`) relie par REA/Ghidra l’enregistrement natif `getLocalizedText` (`FUN_00818320`) à `FUN_007879a0`; le token checker `FUN_00795d10` accepte les formes UTF-16 `%i/%s/%I/%n` selon des paramètres typés. Le callback garde deux appels indirects non résolus. Le consumer Rust actuel `shop_ui.rs` n’appelle pas cet API et le parseur de fontconfig accepte mais ignore `tr`. Trois reçus code 0 et leurs SHA sont consignés dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.

Le sous-audit source/consumer est clos; pas de fonctionnalité ni acceptation en_GB déclarée. `LOCALE-en_GB-SOURCE`/`LOCALE-en_GB-HUD` restent `a_faire`; le parent demeure partiel. Pas de test, build, runtime, code ou registre modifié. Aucun logiciel installé.

Reprise : réutiliser V795/V908; ne pas relancer les trois imports REA. Pour le parent, sélectionner un autre lien source-consumer requis sans reçu ciblé. Le checkpoint JSON conserve l’ancien pointeur ITEM-3024; ne pas le traiter comme une nouvelle tâche puisque V858 en contient déjà le reçu. Goal, Plan, app, bases et statuts restent inchangés.

## 2026-11-02 — SYS-01.2-02 / ITEM-1039 (V909)

Réutiliser le reçu natif enregistré : DATA/Items/1039.inibin, 614 octets, SHA-256 `7ecd4d535edda6a44f39718a2adeaed8634e324522615d6aca7e9e19c7dbdb57`, membre `lol_game_client` 0.0.1.7 concordant. Data Dragon 4.20.1 décrit Hunter’s Machete (prix 400, purchasable, `maps[12]=false`); `maps[10]` absent. Le consumer courant `shop.rs:86` refuse statiquement l’ID, absent du catalogue local, avec `item behavior not implemented`. `map10_available` n’a pas d’entrée : résultat inconnu, pas refus de carte prouvé.

Lot d’audit source → référence → consumer clos; fiche et fonctionnalité restent ouvertes. Le lecteur INIBIN n’a pas résolu les clés candidates de prix/admission; pas de test/build/runtime. Trace `unknown_ids=[]` malgré les questions Map10 et décodage : ne pas modifier les registres sous les restrictions actuelles. Reprise seulement sur preuve primaire des champs/Map10 ou autorisation explicite de corriger les associations d’inconnues. Ne pas refaire le hash ni reparcourir les deux JSON. Goal, Plan, app, UI, bases et statuts sont inchangés. Rapport : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V909).

## 2026-11-02 — SYS-01.2-02 / ITEM-1062 (V910)

Réutiliser le membership source existant : `DATA/Items/1062.inibin`, client 4.20.0.315, 493 octets, SHA-256 `62c047e23e1bd472f737d66c285266f4b21caa6d1da13d7413007e7f5a9c4eed`, projet `lol_game_client` 0.0.1.7, membre release 0.0.0.239. Data Dragon 4.20.1 exclut explicitement Map10 (`maps[10]=false`). L’ID manque du catalogue et de l’admission locale; le chemin core shop refuse statiquement l’ID absent.

Audit du lien terminé; tâche et fonctionnalité ouvertes. Pas de test/build/runtime ni décodage des champs natifs. La précédence historique reste inconnue et `unknown_ids=[]` sur cette fiche malgré la limite; aucune donnée de suivi n’a été modifiée. Reprendre ITEM-1062 seulement sur mapping natif vérifié ou preuve de sélection 4.20.0.315; pour le parent, choisir une autre exigence requise sans reçu ciblé. Ne pas refaire le membership/catalogue. Rapport : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V910).


Complément V911 — Le recensement courant relie structurellement 42 215 tâches aux 42 215 exigences; parmi 24 727 requises, 378 ont des références mais pas de source native, et 37 n’ont que le consommateur Plan. Réutiliser V96/V156/V787/V170 sans répéter leurs analyses. Le parent SYS-01.2-02 garde cinq inconnues et demeure partiel. Le validateur complet échoue actuellement sur `WindowsPath.is_junction`; aucun hash global n’a été vérifié. Reprise : interpréteur compatible (ou autorisation distincte de corriger le validateur), puis classification par petits groupes. Détails : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V911). Aucun registre, statut, goal, application de suivi ni base de données modifié.


Complément V912 — Pour les validations requirement_trace, utiliser `.ai-tools/.venv/Scripts/python.exe` (3.12.14); la limitation WindowsPath de V911 venait de Python système et est corrigée. Le contrôle structurel passe. `--verify-files` passe les 5 759 ancres, puis s’arrête sur 14 092 sources hors allowlist; ne pas ajouter de racines automatiquement. Dans les 86 313 sources autorisées, 86 310 SHA/tailles concordent; trois records non liés divergent (V912). Réutiliser ces reçus et ne pas rehasher les concordants. Goal partiel avec cinq inconnues. Détails : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V912). Aucun registre, statut, goal, application ou base modifié.

Reprise : `docs/resume_checkpoint.json` reste inchangé et son `next_action` pointe encore vers ITEM-3024-SCOPE; le reçu V858 est déjà présent. Ne pas refaire ce lot. Le checkpoint JSON n’a pas été modifié sous la restriction actuelle.

Complément V913 — Nuance au V912 : l’ancien root `E:\OpenLeague` est explicitement inscrit comme `previous_root`. Le validateur a donc vérifié six fichiers sources versionnés, huit archives et huit reçus de version par `source_versions.py`. Les 14 086 autres chemins hors racines restent non vérifiés. Le refus d’allowlist persiste; aucune racine générale n’a été ajoutée. Voir la section V913 du reçu.


Complément V914 — Ne pas relancer `requirement_trace.py --verify-files` sous l’implémentation actuelle : 36 chemins consommateurs absolus sous C:\Users sont lus avant allowlist, et le reçu `native-release-membership.json` sous E:\OpenLeague est parsé sans comparaison de son SHA enregistré. Les 17 autres ancres absolues sont sous E:\mapslol3v3, racine admise. V914 détaille les comptes et la correction nécessaire; aucune modification de code ou de registre n’a été autorisée.
Complément V915 — ITEM-3181-SCOPE : le chaînage source native → Data Dragon 4.20.1 → consommateur Rust a été établi statiquement. SHA natif revalidé (564 octets); le consommateur local ne connaît pas l’ID 3181 et le refuse comme non implémenté. Data Dragon ne fournit que maps[1]=false et omet maps[10]; InStore=1 dans l’INIBIN ne tranche pas l’admission sur cette carte. N’exécuter ni test/build/runtime pour revendiquer un comportement observé; aucun n’a été lancé dans ce lot. La partie audit du lien est terminée, mais ITEM-3181-SCOPE reste a_qualifier jusqu’à une preuve primaire 4.20.0.315 d’admission Map10. V906 est complété, pas contredit. Reçu : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v915. Aucun statut de tâche/checkpoint, code, goal, application ou base modifié.
Complément V916 — ITEM-3184-SCOPE : le catalogue officiel 4.20.1 fournit une décision explicite maps[10]=false. Le natif 4.20.0.315 (624 octets, SHA noté dans V916) indique InStore=1 et recette 3044/1037; ce flag générique ne renverse pas la restriction de carte. L’absence locale entraîne le filtrage et le refus générique. Classification du catalogue auditée; priorité effective runtime et fonctionnalité restent ouvertes. Aucun build/test/runtime ni changement de registre. Reprendre la priorité seulement si un manifeste/mount qualifié ou une capture exacte 4.20.0.315 apporte une nouvelle preuve. Reçu : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v916.
Complément V917 — ITEM-3204-SCOPE : classification de catalogue tranchée par maps[10]=false dans la référence officielle 4.20.1. Source native rehachée (573 octets); InStore=1 reste générique et ne contredit pas l’exclusion. L’objet est absent du catalogue/admission locale et le consumer actuel le refuse faute de définition. Aucun test/build/runtime exécuté. Le sous-audit catalogue est terminé; tâche/implémentation et priorité du client exact 4.20.0.315 demeurent ouverts. Reprendre cette limite seulement sur une source primaire de build contradictoire ou une preuve de montage/priorité runtime. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v917.
Complément V918 — ITEM-3205-SCOPE : maps[10]=false et maps[12]=false dans Data Dragon 4.20.1. Source native 555 octets rehachée; SpellName=SpiritLantern distingue l’ID 3205 du 3204. Absence locale et refus générique confirmés statiquement, sans test/build/runtime. La classification de catalogue est terminée; l’implémentation n’existe pas et le chargement exact du build reste non qualifié. Reprendre la question runtime uniquement avec une nouvelle preuve primaire de montage/priorité ou capture 4.20.0.315. Reçu : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v918.
Complément V919 — ITEM-3206-SCOPE : maps[10]=false/maps[12]=false dans la référence officielle 4.20.1; coût, composants et revente concordent entre source native et catalogue. Le consumer local omet l’objet et le refuse comme non implémenté. SpellName natif AtmasImpalerDummySpell est non interprété; garder cette question séparée de la disponibilité Map10. Aucun test/build/runtime. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v919. Reprendre sur preuve de build contradictoire pour la carte, ou traiter séparément les passifs/SpellName.
Complément V920 — ITEM-3207-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1. Source native 599 octets rehachée; base, recette, sell coefficient et statistiques recoupés au catalogue. Objet absent localement; refus générique réutilisé du consumer commun, sans exécution. La classification est auditée, mais intégration, passif jungle et priorité runtime du build restent séparés et ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v920.
Complément V921 — ITEM-3208-SCOPE : maps[10]=false/maps[12]=false dans Data Dragon 4.20.1. Natif 613 octets rehaché; variante gardée distincte de 3207 par recette et SpellName. Absence locale/refus générique observés statiquement, sans exécution. L’audit catalogue est borné; implémentation, effets et priorité runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v921.
Complément V922 — ITEM-3209-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1; valeur native, recette et revente recoupées. SpellName=ItemSpiritStoneLizardDummy est non interprété. L’objet est omis du catalogue local et refusé génériquement. Aucun test/build/runtime exécuté. Classification catalogue terminée; fonctionnalité et priorité runtime du build restent ouvertes. Reprise sur preuve primaire contradictoire pour l’admission ou lot distinct sur le passif. Reçu : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v922.
Complément V923 — ITEM-3250-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1. Source native 599 octets rehachée; coût, composant et stats confirmés. Absence locale et refus générique observés statiquement, sans exécution. La classification catalogue est terminée; fonctionnalité Homeguard et sélection runtime exactes restent séparées et ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v923.
Complément V924 — ITEM-3255-SCOPE : maps[10]=false/maps[12]=false dans la référence officielle 4.20.1; source native, coût et composant confirmés. Objet absent localement; refus générique constaté statiquement, sans exécution. La classification catalogue est documentée, pas la fonctionnalité ni le chargement exact du build. Reprendre l’admission si une source primaire contredit la référence. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v924.
Complément V925 — ITEM-3260-SCOPE : maps[10]=false/maps[12]=false dans Data Dragon 4.20.1. Natif 590 octets rehaché; composant et statistiques recoupés. Absence locale et refus générique constatés statiquement; aucun test/build/runtime. Classification catalogue terminée; fonctionnalité Homeguard et sélection runtime restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v925.
Complément V926 — ITEM-3265-SCOPE : maps[10]=false/maps[12]=false dans la référence officielle 4.20.1. Source native rehachée, composant et stats recoupés; objet absent de l’admission locale et refusé génériquement. Aucun test/build/runtime. Classification catalogue terminée; fonctionnalité et priorité runtime exactes restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v926.
Complément V927 — ITEM-3270-SCOPE : maps[10]=false/maps[12]=false, ressource native et recette vérifiées, aucun objet dans l’admission locale; le consumer refuse génériquement. Aucun test/build/runtime. La classification de catalogue est terminée; intégration et sélection runtime restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v927.
Complément V928 — ITEM-3275-SCOPE : maps[10]=false/maps[12]=false dans la référence officielle 4.20.1; ressource native, coût et composant vérifiés. Absence locale/refus générique établis statiquement; aucun test/build/runtime. La classification catalogue est faite, l’intégration et la sélection runtime restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v928.
Complément V929 — ITEM-3280-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1. Natif 613 octets rehaché; composant et mouvement confirmés. Absence locale/refus statique, sans exécution. La classification catalogue est faite; fonctionnalité et priorité runtime restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v929.
Complément V930 — ITEM-3340-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1. Natif 631 octets rehaché; coût nul, actif et SpellName recensés; règles d’usage non exécutées. Absence locale/refus générique établis statiquement. Classification catalogue terminée; usage, fonctionnalité et priorité runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v930.
Complément V931 — ITEM-3341-SCOPE : maps[10]=false dans la référence 4.20.1; aucune valeur maps[12]. Natif 630 octets rehaché, actif/trinket nommé mais non exécuté. Absence locale et refus générique statiques. Classification Map10 terminée; Map12, effet, intégration et priorité runtime ouverts. Reprendre les questions manquantes sur preuve dédiée, sans inférer la valeur absente. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v931.
Complément V932 — ITEM-3342-SCOPE : maps[10]=false dans la référence 4.20.1; maps[12] absent. Natif 630 octets rehaché, actif nommé mais non exécuté. Absence/refus locaux vérifiés statiquement. Classification Map10 terminée; Map12, effet, intégration et sélection runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v932.
Complément V933 — ITEM-3345-SCOPE : maps[10]=false/maps[12]=false/maps[1]=false dans la référence 4.20.1. Natif 593 octets rehaché; CanBeSold=0 et actif nommé mais non exécuté. Absence locale/refus générique vérifiés statiquement. Classification catalogue terminée; intégration, actif et priorité runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v933.
Complément V934 — ITEM-3361-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1; natif 652 octets rehaché, recette 3340 et SpellName notés. L’arrondi 332,5→333 n’est pas qualifié; actif non exécuté. Absence/refus statiques. Classification catalogue terminée; effets et priorité runtime ouverts. Reçu : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v934.
Complément V935 — ITEM-3362-SCOPE : maps[10]=false/maps[12]=false dans la référence 4.20.1. Source native 646 octets rehachée, recette et SpellName identifiés; arrondi 332,5→333 non qualifié. Absence/refus statiques; aucun test/build/runtime. Classification catalogue terminée; effet et intégration ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v935.
Complément V936 — ITEM-3363-SCOPE : maps[10]=false, maps[12] absent dans la source 4.20.1. Natif 639 octets rehaché; composant et actif nommé recensés, non exécutés; arrondi vente non qualifié. Absence et refus statiques. Classification Map10 faite; autres limites restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v936.
Complément V937 — ITEM-3364-SCOPE : maps[10]=false; maps[12] absent dans la référence 4.20.1. Source native rehachée, recette/SpellName identifiés, effet non exécuté et arrondi non qualifié. Absence/refus locaux statiques. Classification Map10 terminée; autres limites ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v937.
Complément V938 — ITEM-3405-SCOPE : source native et catalogue concordent sur RequiredChampion=Rengar; maps[10]=false/maps[12]=false. Le natif 605 octets a été rehaché. Les effets de trophées ne sont pas exécutés; l’objet manque de la boutique et le consumer le refuse génériquement. Classification catalogue terminée; mécaniques/runtime restent ouvertes. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v938.
Complément V939 — ITEM-3406-SCOPE : InStore=0 natif concorde avec purchasable=false; RequiredChampion=Rengar et maps[10]/maps[12]=false dans la référence. Source 591 octets rehachée. Le consumer local omet et refuse l’objet; aucun test/runtime. Classification catalogue terminée; effets Rengar/runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v939.
Complément V940 — ITEM-3407-SCOPE : InStore=0/purchasable=false, Rengar requis, maps[10]/maps[12]=false. Source native rehachée; aucun achat local, refus statique; pas de test/runtime. Classification terminée; effets de trophées et priorité runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v940.
Complément V941 — ITEM-3408-SCOPE : InStore=0/purchasable=false, RequiredChampion=Rengar et maps[10]/maps[12]=false concordent entre natif et catalogue. Natif 586 octets rehaché; absence/refus statiques, pas d’exécution. Classification terminée; effets Rengar et runtime restent ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v941.
Complément V942 — ITEM-3409-SCOPE : InStore=0/purchasable=false, Rengar requis, maps[10]/maps[12]=false. Natif rehaché; refus local générique statique. Aucun test/runtime. Classification catalogue terminée; effets Rengar et sélection runtime ouverts. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v942.

Complément V943 — ITEM-3410-SCOPE : Map10 explicitement exclue et objet non achetable dans Data Dragon 4.20.1; restriction Rengar et lien SpecialRecipe=3169 concordent avec le natif relu/rehaché. Entrée absente localement, refus/filtrage établis par lecture de code seulement. Audit catalogue borné terminé; fonctionnalité et sélection runtime non qualifiées. Aucune tâche/goal modifiée. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v943.

Complément V944 — ITEM-3411-SCOPE : conserver séparées l’achetabilité globale et l’exclusion officielle de Map10. Source native 3411 relue/rehachée; restriction Rengar, prix nul, sans recette. Consumer local : entrée absente, état `None`, refus générique à l’achat direct; statique seulement. Actif et disponibilité/sélection runtime restent ouverts. Aucun goal/registre changé. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v944.

Complément V945 — ITEM-3412-SCOPE : classification catalogue Map10/Rengar/prix/recette qualifiée par le natif relu/rehaché et la référence officielle 4.20.1. ID absent du consumer; filtrage/refus vérifiés statiquement. Actif et sélection effective par le runtime non prouvés. Aucun goal/registre changé. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v945.

Compléments V946–V948 — ITEM-3413/3414/3415-SCOPE : classification catalogue Map10/Rengar/prix/recette clôturée par ID avec empreintes natives propres et référence officielle commune. Absence/filtrage/refus observés par lecture statique seulement. Effets des trinkets et sélection runtime non qualifiés; statuts registre préservés. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v946 à #v948.

Compléments V949–V951 — ITEM-3416/3417/3418-SCOPE : fiches natives relues/rehachées. 3416 : exclusion Map10 explicite; 3417/3418 : clé Map10 absente, inconnue à reprendre sur source primaire ou preuve d’exécution pertinente. Catalogues locaux incomplets; filtrage/refus statiques seulement. Aucun goal/registre changé. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v949 à #v951.

Compléments V952–V954 — ITEM-3419/3420/3421-SCOPE : classification de non-achat/Rengar qualifiée; Map10 non qualifié car clé absente du catalogue officiel. Sources natives propres rehashées; IDs absents localement, résultat consumer statique seulement. Reprise uniquement sur preuve Map10 primaire ou exécution datée. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v952 à #v954.

Complément V955 — ITEM-3422-SCOPE : lien spécial 3169 qualifié au niveau des métadonnées; achat global refusé, restriction Rengar. Map10 non qualifiée (`maps[10]` absente), consumer local absent, vérification statique seulement. Reprise sur source Map10 primaire; aucune tâche/goal modifiée. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v955.

Compléments V956–V958 — ITEM-3450/3451/3452-SCOPE : classification catalogue Map10 conclue par ID; restriction Rengar, prix nul et recette absente. `purchasable=true` de 3450 ne lève pas maps[10]=false. Natif rehashé; actifs non exécutés, consumer absent/refus statique, runtime non qualifié. Aucun goal/registre changé. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v956 à #v958.

Compléments V959–V961 — ITEM-3453/3454/3455-SCOPE : statut Map10 explicite faux pour les deux premiers, absent/inconnu pour 3455. Lien SpecialRecipe=3169 de 3455 qualifié en métadonnée seulement. Natif rehashé; absence/refus statiques, actifs/runtime ouverts. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v959 à #v961.

Complément V962 — ITEM-3460-SCOPE : classification catalogue Map10/achat/recette terminée; aucun champion requis indiqué, actif AscWarp et sélection runtime non vérifiés. Consumer absent/refus statique. Aucun goal/registre modifié. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v962.

Compléments V963–V964 — ITEM-3504/3508-SCOPE : 3504, champ `maps` absent; 3508, `maps[10]=false`. Métadonnées prix/recette comparées; consumer local absent/refus statique. Ne pas assimiler InStore/purchasable à une admission de carte. Runtime/fonctionnalité non exécutés. Aucun goal/registre changé. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v963–#v964.

Compléments V965–V967 — ITEM-3599/3706/3707-SCOPE : champ Map10 absent; ne pas inférer depuis `maps[12]` ou InStore. Métadonnées prix/recette qualifiées par natif et 4.20.1. Consumer absent/refus statique; The Black Spear et runtime non exécutés. Aucune tâche/goal modifiée. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v965 à #v967.

Compléments V968–V970 — ITEM-3708/3709/3710-SCOPE : coûts/recettes qualifiés, Map10 inconnue car la référence ne précise que maps[12]. Catalogues locaux absents; résultat consumer vérifié statiquement, runtime non testé. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v968 à #v970.

Compléments V971–V973 — ITEM-3711/3713/3714-SCOPE : prix/recettes qualifiés, mais aucun champ Map10; ne pas inférer depuis maps[12]. Catalogues locaux absents, observation consumer statique uniquement. Aucun goal/registre changé. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v971 à #v973.

Compléments V974–V976 — ITEM-3715/3716/3717-SCOPE : métadonnées prix/recette qualifiées; Map10 inconnue, la référence ne donnant que maps[12]. Consumer local absent, vérification statique. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v974 à #v976.

Compléments V977–V979 — ITEM-3718/3719/3720-SCOPE : prix/recettes qualifiés; Map10 non établie par l’unique maps[12] présent. Consumer absent/refus statique; aucun effet ou runtime testé. Aucun goal/registre changé. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v977 à #v979.

Compléments V980–V982 — ITEM-3721/3722/3723-SCOPE : prix/recettes qualifiés, Map10 non établie à partir de maps[12]. Consumer absent/refus statique; runtime non exécuté. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v980 à #v982.

Compléments V983–V985 — ITEM-3724/3725/3726-SCOPE : prix et recettes qualifiés, Map10 non renseignée. Consumer local absent, observation statique seulement. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v983 à #v985.

Compléments V986–V987 — ITEM-3800-SCOPE absent du shop local; Map10 inconnue. ITEM-3801-SCOPE conserve l’intégration existante et son statut partiel : données/shas concordent, admission locale vraie, test statique existant. La source 4.20.1 n’a pas maps; l’admission historique n’est pas prouvée. Test non exécuté. Reprendre sur source Map10 primaire puis validation du test/runtime. Aucun goal/registre modifié. Preuves : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v986–#v987.

Bilan V988 — 45 ITEM-SCOPE auditées : 14 exclusions Map10 explicites; 31 Map10 inconnues. L’intégration locale de 3801 est conservée, mais son allowlist historique manque de source Map10. 44 tâches restent `a_qualifier`, une reste partielle; aucun statut modifié. Reprendre les inconnues sur preuve primaire nouvelle, 3801 sur preuve Map10 puis test existant autorisé. Les cinq inconnues parent et le prérequis D01-SYS-01-1 restent ouverts. Aucun goal/registre/app/base/code modifié. Preuve : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v988.

V989–V990 — Audit ITEM-3024 statique terminé : INIBIN, DDragon 4.20.1, shop/admission/UI reliés; cas positif 3024 et refus 1058 vérifiés dans les données/tests source, non exécutés. Correction V988 : `basic.maps[10]=true` est le défaut du contrat local, donc 14 exclusions explicites et 31 vrais par défaut; 3801 concorde. Le comportement du client 4.20.0.315 reste non prouvé; tâche 3024 et checkpoint non modifiés. Reprendre à une relation différente. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v989–#v990.

V991 — ITEM-3025-SCOPE : lien `3024.into -> 3025` audité. Natif et DDragon concordent; Map10 hérite le défaut true du contrat local, mais 3025 est absent des catalogues et refusé comme non implémenté. Refus fonctionnel actuel ≠ exclusion historique. Aucun test/runtime, statut ou checkpoint modifié. Reprendre à la prochaine relation source/consumer distincte. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v991.

V992 — ITEM-3187-SCOPE : upgrade de 3024, native/4.20.1 concordants; Map10=true par défaut. Missing feature établie : item absent des deux catalogues et refusé comme non implémenté. Tests non exécutés; couverture existante ne détecte pas les items omis. Reprise : intégrer l’item seulement dans un lot autorisé, puis qualification runtime/version. Aucun statut/checkpoint modifié. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v992.

V993 — ITEM-3110-SCOPE : reprendre la preuve historique seulement sur une source primaire 4.20.0.315 ou une observation datée du client exact donnant l’admission Map10. L’objet n’est pas intégré au shop/admission; UI/achat ont été inspectés statiquement, tests non lancés. Le fallback `basic.maps[10]` est le contrat local, pas une preuve de runtime. L’audit source-consumer de ce lot est terminé, mais la tâche registre reste `a_qualifier` et la fonctionnalité ouverte. Voir V993 dans AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

V994 — ITEM-3082-SCOPE : audit statique terminé pour la relation recipe→consumer. Reprendre Map10 sur preuve native propre au client 4.20.0.315 ou exécution datée. L’item est absent de l’admission et du shop; aucun comportement d’achat/effet intégré. Ne pas confondre le défaut basic.maps du contrat local avec l’historique. Aucun test lancé, statut `a_qualifier` conservé. Voir V994 dans AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

V995 — ITEM-3143-SCOPE : le lien source-consumer est audité statiquement. Reprendre la disponibilité Map10 sur preuve client 4.20.0.315; reprendre l’effet `RanduinsOmen` en lot fonctionnel avec validation dédiée. L’item manque des catalogues locaux, tests non lancés et tâche `a_qualifier` conservée. Voir V995 dans AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

V996 — Piste prioritaire suivante : récupérer la sémantique des clés hashées et le consumer historique de `LEVELS/Map10/Items.inibin`. Concordance exacte avec les 85 IDs DDragon 4.20.1 explicitement maps[10]=false et avec les 33 admissions locales; forte présomption de liste d’exclusion, mais noms de champs/lecteur non prouvés. Réutiliser cette analyse pour 3025/3082/3110/3187/3143; ne pas recommencer le scan des 95 IDs. Fonctionnalités shop/effets et runtime restent ouvertes. Voir V996 dans AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

V997 — Ne pas généraliser la sémantique de `Items.inibin` depuis d’autres cartes : seul Map10 concorde exactement avec les exclusions DDragon. Garder l’interprétation de denylist comme forte inférence Map10, pas preuve exécutée. Les fiches d’objets restent à qualifier jusqu’à identification des clés/lecteur. Reprise ciblée uniquement si une nouvelle piste native apparaît; ne pas refaire les comparaisons de listes. Voir V997.


Complément 2026-11-02 — V998 : nouvelle piste LoLPatcher.exe présente dans le release patcher, avec chaînes SetLanguageFile, Failed to write locale file et chemins de locale; elles ne prouvent pas que le binaire a produit le loose locale.cfg ni que le démarrage historique l’a choisi. Le payload livré en_GB est rehashé; OLU-0ae207ed demeure ouverte. Reprise sur xrefs via outil déjà disponible, source/symboles ou reçu de staging; ne pas relancer les mêmes scans. Aucun binaire lancé, test/build/install/migration, goal, registre, checkpoint, code, application ou base modifié. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v998.


Complément 2026-11-02 — V999 : piste producteur locale.cfg reliée statiquement à LoLPatcher via REA/Ghidra existants; pas d’installation. Cas en_gb→en_GB avec wt prédit les mêmes 37 octets/SHA que la ressource fournie et sa copie F. Reprendre uniquement sur trace/delta d’update datée, input et sélection effective provider/overlay au démarrage 4.20.0.315; ne pas répéter la recherche de chaînes/manifeste. OLU-0ae reste ouverte, SYS-01.2-02 demeure partiel. Aucune exécution du patcher, test/build, modification goal/registre/checkpoint/app/base. Preuve : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v999.


Complément 2026-11-02 — V1000 : réutilisation croisée des preuves V999/V37 pour locale.cfg. Hash du patcher, du client 4.20.0.315 et des deux fichiers locale revalidés. Le producteur REA/Ghidra transforme conditionnellement en_gb en en_GB; le reçu d’exécution native existant a lu les mêmes 37 octets sous root/backend fournis. Lien conditionnel producteur→lecteur audité; le patcher n’a pas été exécuté dans cette passe. OLU-0ae reste ouverte faute de reçu d’update input→fichier et de preuve du bootstrap/provider/overlay effectif. Ne pas répéter V37/V999. Aucun goal, statut, registre, checkpoint, code, app ou base modifié. Voir docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v1000.

## Reprise 2026-11-02 — SYS-01.2-02 / V1001 Aatrox Q

Lot source → consommateur audité statiquement pour `CH-Aatrox-Q-SOURCE`: source brute et membership exacts, JSON `/0` confronté au brut, hachages restants listés; consumer actuel relié à son refus explicite Aatrox. 15 champs restent sans nom, conversion/sémantique et disponibilité Map10 non qualifiées. Le sous-audit de liaison est clos; la tâche registre demeure `a_qualifier`, preuve/acceptation inchangées, fonctionnalité absente. Reprendre uniquement sur un dictionnaire natif/lecteur qualifié ou une nouvelle source primaire. Tâches d’implémentation déjà prévues : `CH-Aatrox-Q-SIMULATION-CONTRAT`, `CH-Aatrox-Q-SIMULATION` après dépendances. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v1001`.

Reprise du dépôt : `node .ai-tools/project.mjs resume` code 0, état Git non lisible (head/branch/changes `null`; accès F refusé), checkpoint encore orienté vers ITEM-3024. Ne pas supposer l’arbre propre ni réécrire le checkpoint sous la restriction courante. Aucun test/build/runtime, aucun changement code/statut/goal/registre/Plan/app/base.

## Reprise 2026-11-02 — V1002 Aatrox Q tooltip

Un des 15 hashes précédemment non nommés est résolu : `2287725201 = BuffData.DynamicTooltip`, valeur native `game_buff_tooltip_AatroxQ`. Le texte en_GB est dans la ressource originale byte-identique locale. Le parseur Rust fontconfig ignore les lignes de traduction et aucune utilisation de la clé n’est présente dans les sources de production inspectées; le sort reste refusé par `Simulation::cast`. 14 hashes, les règles gameplay, la disponibilité Map10 et `CH-Aatrox-IDENTITE` restent ouverts. Reprendre seulement sur un dictionnaire/lecteur natif nouveau ou un consumer de traduction qualifié; ne pas répéter le scan. Rapport : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v1002`. Aucun code, registre, goal, app ou base modifié; aucun test/build/runtime.


## Reprise 2026-11-02 — V1003/V1004 Aatrox Q/W

V1003 clôt le contrôle local des hashes Aatrox Q : 14 restent sans nom et aucune préimage vérifiable n’a été trouvée; reprendre sur table INIBIN 4.20 ou outil de conversion. V1004 audite Aatrox W : source/release et 125 champs de l’export reliés, un hash BuffData.DynamicTooltip résolu; tooltip SpellData existe en en_GB, tooltip BuffData exact absent avec clés Life/Power distinctes; code Rust refuse le sort et ignore les traductions. Tâche W reste `a_qualifier`; identité, sémantique, Map10 et acceptation ouvertes. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md#v1003` et `#v1004`. Ne pas répéter les scans; aucun changement code/registre/checkpoint/goal/app/base, aucun test/build/runtime.

## Reprise V1005 — SYS-01.2-02 / Aatrox W

Vérification ciblée des quatre clés BuffData.DynamicTooltip sur les assets Life/Power : les ressources natives sont membres du projet client 4.20 sélectionné et leurs quatre chaînes en_GB sont présentes (rapport V1005). Cela ferme uniquement la provenance ressource→texte des états. La clé générique reste absente, aucun consumer de texte de sort n’est relié, et Simulation::cast refuse toujours Aatrox. Pas de test/build/runtime ni modification de code, statut, goal, registre, checkpoint, application ou base. Prochaine piste utile : source ou trace qui relie buff actif et sélection de tooltip; ne pas rebalayer les mêmes clés.
## Reprise V1006 — OLF-476a / NATIVE-ITEM-1005-SCOPE

Source OLS-201d… vérifiée : Meki Pendant, 390, InStore=0, CanBeSold=1, FlatMPRegenMod=1.4 et chaînes en_GB concordantes (+7/5 s). Membership 4.20.0.315 exacte. Le catalogue DDragon 4.20.1 et shop_foundation n’ont pas de ligne 1005; le consumer OLC-77ca… refuse achat/vente faute de définition. Cela qualifie le refus d’achat, pas l’usage historique hors boutique ni Map10. La tâche reste a_faire sans changement de base. Reprise uniquement sur preuve primaire de possession/usage/vente; ne pas répéter l’extraction, locale ou catalogue.
## Reprise V1007 — OLF-b1d8 / NATIVE-ITEM-1007-SCOPE

Source 1007 et membership vérifiés; le texte en_GB concorde avec FlatHPRegenMod=3. InStore=0 et l’absence des catalogues cadrent avec le refus, tandis que CanBeSold=1 n’établit pas la vente d’un inventaire legacy. Map10 et le producteur de possession restent inconnus; le consumer ne possède pas de bonus santé plat. La tâche demeure a_faire. Reprendre sur preuve primaire de mode, attribution ou vente; réutiliser V1007/V1006, sans répéter les recherches.
## Reprise 2026-11-02 — V1008 / ITEM-1043-SCOPE

Le natif 1043 indique Price=900, InStore=1, CanBeSold=1 et +30% AS; son SHA/membership 4.20 sont concordants. Le catalogue et l’admission Map10 locaux n’ont pas de ligne, et shop.rs::buy_item refuse à l’étape lookup. Liaison statique documentée, disponibilité historique et runtime ouverts; aucune donnée, tâche, statut, goal, app ou base modifié. Reprise seulement avec une source primaire Map10 4.20.0.315 et un test sur target accessible. Rectification V880 : cooldown.rs contient un achat 3067 dans un lot de cinq objets; son test ciblé n’a pas démarré (verrou target, accès refusé). Voir le détail V1008 dans l’index d’audit.
## Reprise 2026-11-02 — V1009 / ITEM-1063-SCOPE

Le natif 1063 4.20.0.315 est rehashé et décodé; Data Dragon officiel 4.20.1 indique maps[10]=false. Le consumer courant refuse l’ID car son catalogue est absent, pas par une règle Map10 explicite. Révision de catalogue 4.20.1 tranchée; disponibilité dans le client exact, runtime et acceptation ouverts. Reprendre seulement avec une liste boutique Map10 primaire 4.20.0.315. Pas de code, registre, statut, goal, app ou base modifié. Détail V1009 dans l’index d’audit.
## Reprise 2026-11-02 — V1010 / ITEM-1056 FlatMPRegenMod

La source brute 1056 contient bien `Data*FlatMPRegenMod=0.6`; les deux lecteurs locaux concordent et le contrôle positif 1005 donne 1,4. L’export `native_item_audit.json` était incomplet pour ce champ. Audit source→consumer statique clos, fonctionnalité toujours absente : pas d’entrée 1056 dans shop_foundation, pas de mana plate dans shop.rs, et aucun achat/effet exécuté. Réutiliser l’addendum V1010 dans le rapport dédié; ne pas répéter le décodage ou les hashes sans changement de source. Aucun code, task registry, goal, Plan, interface ou base de suivi modifié. Prochaine action du goal : prendre une exigence ouverte différente avec source native et consumer courant identifiables.
## Reprise 2026-11-02 — V1011 / NATIVE-ITEM-1500-SCOPE

Audit statique source/membership/catalogues/consumer clos pour la classification boutique : 1500 est un enregistrement natif membre, InStore=0, CanBeSold=0, sans entrée catalogue. Refus par lookup déduit du code, non exécuté. Usage en autre mode, producteur serveur et disponibilité historique restent inconnus. Tâche et statuts conservés; détails et conditions de reprise dans docs/AUDIT_SYS01202_ITEM1500_SCOPE_2026-11-02.md. Ne pas ajouter l’item à la boutique sur cette seule preuve. Prochaine action : choisir une autre exigence ouverte non déjà auditée avec source et consumer actuels.
## Reprise 2026-11-02 — V1012 / NATIVE-ITEM-1501-SCOPE

Audit de classification boutique clos statiquement : source/membership 4.20.0.315 et traduction en_GB native concordent sur « Fortification »; InStore=0, CanBeSold=0; l’ID manque des catalogues. Le consumer d’achat le refuserait par lookup. Aucun runtime, producteur, usage en mode ou effet n’est établi. Tâche/status conservés. Reprise uniquement sur nouvelle source primaire d’usage; détails : docs/AUDIT_SYS01202_ITEM1501_SCOPE_2026-11-02.md. Prochaine action : autre relation requise non déjà couverte.
## Reprise 2026-11-02 — V1013 / NATIVE-ITEM-1502-SCOPE

Audit statique de classification boutique clos : source/membership 4.20 et locale en_GB native identifient « Reinforced Armor », InStore=0, CanBeSold=0, sans entrée de catalogue. shop.rs refuserait l’ID au lookup; aucun achat, affichage ou effet n’a été testé. Le nom/icon Netherrift n’établit pas la disponibilité du mode. Tâche/status conservés. Détails : docs/AUDIT_SYS01202_ITEM1502_SCOPE_2026-11-02.md. Reprendre seulement sur nouvelle preuve primaire d’usage.
## Reprise 2026-11-02 — V1014 / NATIVE-ITEM-1503-SCOPE

Audit statique source/catalogue/consumer clos pour la classification boutique : Warden’s Eye, description Stealth detection, mais InStore=0/CanBeSold=0 et aucune entrée catalogue. shop.rs le refuserait par lookup; aucun effet ou achat exécuté. Mécanisme, producer, mode et disponibilité serveur inconnus. Tâche/status conservés; rapport : docs/AUDIT_SYS01202_ITEM1503_SCOPE_2026-11-02.md. Reprise uniquement sur preuve primaire du producer/activation.
## Reprise 2026-11-02 — V1015 / NATIVE-ITEM-1504-SCOPE

Audit statique de classification boutique clos : source/membership 4.20 et locale native nomment Vanguard; InStore=0, CanBeSold=0, aucun catalogue. shop.rs le refuserait au lookup, non exécuté. Une fonction de défense de tourelle n’est pas établie par TurretShielder/Vanguard. Tâche/status conservés. Rapport : docs/AUDIT_SYS01202_ITEM1504_SCOPE_2026-11-02.md. Reprise seulement sur preuve primaire d’usage ou d’attribution.
## Reprise 2026-11-02 — V1016 / NATIVE-ITEM-1505-SCOPE

Audit de classification boutique clos statiquement : source/membership 4.20 et locale donnent Lightning Rod; InStore=0, CanBeSold=0, aucun catalogue. Refus shop par lookup prévisible, non exécuté. Les noms ne prouvent pas un comportement électrique/de tourelle. Tâche/status conservés. Rapport : docs/AUDIT_SYS01202_ITEM1505_SCOPE_2026-11-02.md. Reprendre sur preuve primaire d’usage.

## Reprise 2026-11-02 — V1017 / Garen E Effect1

Lien natif GarenE.inibin → native_spells_420.json → spells.rs et trois tests ciblés documentés dans docs/AUDIT_SYS01202_GAREN_E_EFFECT1_LINK_2026-11-02.md. Audit fermé uniquement pour le calcul des pulsations et ses rangs; implémentation globale partielle, runtime historique/acceptation non vérifiés. Les deux appels --exact initiaux ont rendu 0 test; les filtres corrigés ont rendu 1/1 chacun. Aucun rebuild, code, statut, registre, goal, Plan, application ou base changé. Le checkpoint resume_checkpoint.json reste inchangé et désigne ITEM-3024, déjà couvert par V858; ignorer ce pointeur. Prochaine action : choisir un autre lien exigé sans reçu ciblé, réutiliser le dossier existant et ne pas reprendre les recherches terminées sans source nouvelle.

## Reprise V1018 — SUMMONER-SummonerHeal-SCOPE / cooldown

Le sous-audit source→consumer du cooldown est clos statiquement : `SummonerHeal.inibin` et Data Dragon 4.20.1 = 300 s; `heal_rules.json` injecte 240 s dans `cast_heal`; l’appel en recharge est refusé par `summoners.rs`. Le test existant est seulement inspecté, pas exécuté. L’override 4.5 est corroboré par une copie secondaire des notes, pas par une config serveur 4.20; la valeur effective reste indéterminée. Ne pas rehasher/décoder ce fichier sans changement. `SUMMONER-SummonerHeal-SCOPE` reste `a_qualifier`; reprendre avec une source primaire serveur/Map10 4.20 pour le cooldown, et traiter séparément carte, déblocage et cible. Détail : `docs/AUDIT_SYS01202_SUMMONER_HEAL_COOLDOWN_LINK_2026-11-02.md`.
## Reprise V1019 — SUMMONER-SummonerBarrier-SCOPE / cooldown

Lien statique confirmé : `SummonerBarrier.inibin` décodé = 210 s, catalogue 4.20.1 = 210, règle chargée par `summoners.rs` = 210; refus sous cooldown identifié. Le test existant a été seulement inspecté. La note `barrier_rules.json` « original inibin cooldown to be checked » est dépassée mais n’a pas été modifiée. Tâche toujours `a_qualifier`: disponibilité Map10, unlock, modificateurs et acceptation ouverts. Reprise sur source serveur/Map10 4.20; ne pas redécoder cet INIBIN. Le `resume` prescrit a encore renvoyé le checkpoint ancien ITEM-3024; V1018/V1019 sont plus récents, ne pas rejouer ITEM-3024. Rapport : `docs/AUDIT_SYS01202_SUMMONER_BARRIER_COOLDOWN_LINK_2026-11-03.md`.
## Reprise V1020 — SUMMONER-SummonerBarrier-SCOPE / unlock

Audit statique clos pour le lien de seuil, pas pour le sort : catalogue 4.20.1 `summonerLevel=4`; binaire AIR release 0.0.1.119 et source décompilée établissent le filtre UI `Spell.minLevel <= session.summonerLevel` + disponibilité du mode. Dans OpenLeague, env `OPENLEAGUE_SUMMONERS` → `JoinRequest(champion,summoners,credentials)` → `join_with_summoners` ne comporte aucun niveau; la simulation ne vérifie que les doublons. Ne pas inférer un refus serveur AIR du filtre UI. Mapping du payload minLevel→catalogue non établi; Map10/unlock restent ouverts et la tâche `a_qualifier`. Reprendre avec objet/service de sorts AIR 4.20 et preuve serveur Map10; implémenter ensuite via le ticket existant `SUMMONER-SummonerBarrier-SERVER` sous un lot autorisé. Reçu : `docs/AUDIT_SYS01202_SUMMONER_BARRIER_UNLOCK_LINK_2026-11-03.md`.

Observation de reprise 2026-11-03 : `node .ai-tools/project.mjs resume` termine avec code 0 mais désigne encore ITEM-3024 comme prochaine action. Ce checkpoint est antérieur aux reçus V858 et V1017–V1020; ne pas rejouer ITEM-3024 et ne pas modifier le checkpoint sous la restriction actuelle.
## Reprise V1021 — SYS-01.2-02 / payload AIR de déblocage

Ne pas recommencer le traçage AIR des sorts : V1021 relie GeneratedContentLoader → AirGeneratedContent.swf → Spell.minLevel → inventaire actif → filtre de mode/niveau. Entrée manifeste attendue : release 0.0.1.119, 63 377 octets, MD5 fd8778eedf8d83e22f34660ac37fc166. Binaire introuvable dans les emplacements D:, E: (sortie air_119) et F: (référence) inspectés. Prochaine étape uniquement si l’asset exact est récupéré : vérifier taille/MD5, exporter avec FFDec existant, relever Barrier spellId/minLevel/gameModes, comparer à Data Dragon 4.20.1. Sans cet asset, maintenir l’inconnue; ne pas attribuer le seuil 4 à minLevel. La tâche reste a_qualifier. Le checkpoint resume reste obsolète (ITEM-3024) et ne doit pas être rejoué.
## Reprise V1022 — recherche communautaire terminée

La recherche web exacte (MD5 + nom + chemin release) n’a trouvé aucun binaire ou miroir exploitable. Le seul résultat utile est un relevé secondaire qui mentionne le chemin en 0.0.1.119, sans le fichier ni le hash : https://www.trojaner-board.de/161078-kaspersky-241-bearbeitete-objekte.html. Ne pas répéter cette recherche sans piste nouvelle. Reprendre seulement avec un paquet complet versionné ou une copie locale du SWF, contrôler 63 377 octets et MD5 fd8778eedf8d83e22f34660ac37fc166, puis extraire les sorts avec FFDec existant.
## Reprise V1023 — périmètre local déjà vérifié

La recherche exacte du SWF n’a rien trouvé dans Downloads, Desktop, Documents, AppData\Local\Temp, AppData\Local\Riot Games, C:\Riot Games ou C:\ProgramData\Riot Games. Ce n’était pas un scan complet de C:. Ne pas relancer sur ces chemins sans indice nouveau. FFDec existe à E:\mapslol3v3\AIR_routes_4_20_2026-10-20\tool\ffdec\ffdec.jar (5 271 501 o) et Java JDK 21 est dans PATH; donc si le SWF exact (0.0.1.119, 63 377 o, MD5 fd8778eedf8d83e22f34660ac37fc166) est fourni ou retrouvé, l’analyse peut reprendre sans installation.
## Reprise V1024 — SYS-01.2-02 / SUMMONER-SummonerBoost-SCOPE

Le lien source natif → consumer a été borné et documenté dans R8 du reçu AUD-17.1-04 : le client release 0.0.1.68 contient SummonerBoost.inibin (699 o, SHA-256 282F624C129929A2FA5785673642D71CACB780C0B40BA41CD453D00539B1E59E); l’INIBIN donne Cooldown=210 et CastRange=200. Le catalogue 4.20.1 le nomme Cleanse et indique summonerLevel 6, sans prouver la disponibilité Map10 ou le serveur EUW 4.20. Le type Rust Spell ne contient que cinq variantes ; aucun Cleanse n’est décodable/dispatché. Constat statique clos, pas de réussite fonctionnelle ni de refus runtime vérifié. Garder SUMMONER-SummonerBoost-SCOPE a_qualifier. Reprendre sur une config/code serveur daté ou le payload AIR 4.20 exact ; ne pas refaire de recherche sans nouvelle piste.

## Reprise V1025 — SYS-01.2-02 / ITEM-3024-SCOPE

L’ancien checkpoint conseillait ITEM-3024, mais le rapport ciblé existe déjà et son cas CDR avait été exécuté; ne pas le rejouer. Le nouveau rapprochement utilise la source native LEVELS/Map10/Items.inibin (657 o, SHA-256 2E0E874E036429FEE1BDA6C5D1942F8E217EDA7468B6B5BEA5EAC0A4288456F7) : 3024 absent, 1038/1058 présents. Avec V996–V997, cela soutient fortement une liste d’exclusion Map10; le consumer natif et la clé hachée restent inconnus. Data Dragon 4.20.1 basic.maps[10] et l’admission locale sont true, donc l’item est probablement non exclu mais la disponibilité historique 4.20.0.315 n’est pas prouvée. Détail dans AUDIT_SYS01202_ITEM3024_GLACIAL_SHROUD_2026-11-02.md, addendum V1025. Reprendre uniquement sur dictionnaire/callsite natif ou configuration serveur primaire. Le gate de package est toujours ouvert : D01-SYS-01-2 requiert D01-SYS-01-1, dont les 7 tâches restent a_valider. Aucun registre/statut, checkpoint, plan, code, application ou base n’a été changé.

## Reprise V1026 — ITEM-3143-SCOPE

Le sous-audit source→consumer courant est clos statiquement : trace OLF-45609b34-573c-55d6-bfa1-464da6703161 → INIBIN OLS-a6dcc395-ef09-5e97-ae74-04b9126a6925 / Data Dragon 4.20.1 → consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b (shop.rs:86). Source native 566 o, SHA-256 9C980D7CAE3AC440C3A357BDBFB55BB2CD38B19783CACF02A4AE933C8A11DA1C; values and missing local entries documented in trace anchors V1026. No runtime/test: 3143 is absent from both current shop catalogue and admission list, so only the static generic refusal is established. Keep ITEM-3143-SCOPE a_qualifier until Map10’s hashed field/native reader or primary server evidence decides historical availability. Do not rerun hashes or V996–V997 census. D01-SYS-01-1 remains the open gate for D01-SYS-01-2.

## Reprise V1027 — ITEM-3082-SCOPE

L’exigence ITEM-3082-SCOPE n’avait pas de reçu ciblé; la trace existante liait déjà OLF-53ee578c-b800-564a-a0bf-42c83a518bc8 à l’INIBIN OLS-12fef547-9f30-5a7f-9eaa-b949c4142590 et au consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b. Audit statique V1027 : source native 524 o, SHA-256 EBE8A910A280130402274F8DC66E1793FA87B2A04C658B78C7C9E9874A09D0FB; Data Dragon 4.20.1 concorde sur recette 1029+1029 et +45 armure. Aucune ligne catalogue/admission locale : le chemin de code prédit « item behavior not implemented » avant Map10. Carte 10 probable non-exclusion selon V996–V997, historique non prouvé; aucun test runtime. Garder ITEM-3082-SCOPE a_qualifier. Reprendre seulement avec la clé/lecteur natif de LEVELS/Map10/Items.inibin ou une source serveur primaire, sans répéter les hashes/analyses existants.

## Reprise V1028 — ITEM-1054-SCOPE / Doran’s Shield

Ne pas répéter le hash ou le décodage INIBIN : le reçu natif et sa membership sont déjà concordants. Le lot clos est seulement le lien statique source→consumer. Le catalogue 4.20.1 n’a pas de décision `maps[10]`, et les catalogues locaux ne contiennent pas 1054; `shop.rs` prédit un refus générique avant Map10. Garder le scope `a_qualifier` jusqu’à une source primaire serveur/config/capture Map10 de 4.20.0.315; traiter les passifs séparément. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V1028). Aucun statut ni registre modifié.
## Reprise V1029 — ITEM-1074-SCOPE / Doran’s Shield (Showdown)

Décision bornée acquise pour le catalogue 4.20.1 : `maps[10]=false`. La corrélation V996–V997 implique que 1074 figure dans la liste native Map10, sans qualifier encore son lecteur/effet sémantique; disponibilité réelle 4.20.0.315 probable exclue, pas prouvée par runtime. Aucun hash ni census à répéter. Garder `ITEM-1074-SCOPE` ouvert jusqu’au mapping de clé/callsite natif ou à une preuve primaire serveur/capture 4.20.0.315. Détail : journal V1029. Gate D01-SYS-01-1 encore non accepté; aucun statut ni registre changé.
## Reprise V1030 — ITEM-1075-SCOPE / Doran’s Blade (Showdown)

Réutiliser les hashes/membership INIBIN et le census Map10 V996–V997. Le catalogue 4.20.1 dit `maps[10]=false`; la correspondance native suggère exclusion, mais le lecteur/champ historique reste non établi. Garder `ITEM-1075-SCOPE` ouvert jusqu’à une preuve primaire du consumer Map10 ou une configuration/capture 4.20.0.315. Ne pas refaire le census ni les hashes. Détail : journal V1030. Aucun registre/statut/checkpoint modifié. Prochain candidat non commencé : vérifier d’abord l’existence d’un reçu pour `ITEM-1076-SCOPE`, puis n’auditer que son entrée distincte.
## Reprise V1031 — ITEM-1076-SCOPE / Doran’s Ring (Showdown)

Ne pas refaire hash ni census. Le catalogue 4.20.1 exclut Map10 et V996–V997 impliquent une présence dans la liste Map10; le lecteur de cette liste et la disponibilité du client 4.20.0.315 restent inconnus. Le reçu natif ne qualifie pas l’AP, la régénération ni le passif de mana; ne pas les importer de Data Dragon comme preuve serveur. Reprendre sur un mapping/callsite natif ou une preuve primaire datée. Tâche reste `a_qualifier`; feature non implémentée. Détail V1031 dans le journal. Prochain candidat : valider d’abord l’absence de reçu avant d’ouvrir un nouvel ID.
## Reprise V1032 — ITEM-1080-SCOPE

Ne pas refaire le hash/décodage INIBIN, le catalogue 4.20.1, le census Map10 V996–V997 ni les recettes V919/V922. Sous-audit statique source→consumer clos; tâche a_qualifier, car la disponibilité Map10 4.20.0.315 n’est pas décidée. Le catalogue en_US 4.20.1 dit maps[10]=false, mais la liste native et son lecteur restent sémantiquement inconnus. Reprendre seulement sur un mapping/callsite de cette liste ou une configuration/capture serveur primaire datée; qualifier le passif séparément. Aucune fonctionnalité ni statut n’est déclaré terminé. V1032 ajouté aux reçus; goal, plan, suivi, bases, code et checkpoint inchangés.

### Caveat de chemins V1032

Les chemins de source enregistrés pointent encore vers E:/OpenLeague, mais les hashes vérifiés des deux copies F: correspondent aux reçus. Ne pas refaire ces hashes sans changement des fichiers. L’alignement des chemins du registre/base attend une autorisation séparée; pour le moment la provenance de contenu est établie et le chemin absolu reste signalé comme périmé.

## Reprise V1033 — ITEM-2004-SCOPE

V857 couvre déjà les valeurs natives/catalogue et le test direct historique; ne pas rehasher ni rerun. V1033 établit le chemin de consommation actuel lib.rs:615 → consumables.rs:8–23 → lib.rs:727/advance_consumables, absent de la sous-trace qui ne relie que shop.rs:69. Le consumer local est confirmé, mais l’effet serveur 4.20.0.315 ne l’est pas. Le registre/base ne peut pas être réaligné sous la consigne actuelle. Reprendre ce lien seulement après autorisation distincte de mise à jour des registres, ou sur une preuve primaire du sort. D01-SYS-01-1 reste le prérequis non accepté; pas d’intégration, test ou changement de statut.

## Reprise V1034 — ITEM-2009-SCOPE

Réutiliser la source/membership native item et le catalogue 4.20.1. Le SpellName mène à ItemMiniRegenPotion.inibin et LuaObj enregistrés mais non décodés/exécutés; aucun code OpenLeague n’implémente l’objet et shop.rs refuse génériquement. L’entrée officielle n’a pas de maps, est non achetable et ne décide pas comment le biscuit est attribué. Le miroir LeagueSandbox-Default est modifié et contradictoire; ne pas l’utiliser comme preuve. Tâche reste a_qualifier. Reprendre sur source primaire du sort/acquisition; lier les nouvelles ressources dans la base seulement avec autorisation distincte. D01-SYS-01-1 reste le gate d’intégration.

## Reprise V1035 — ITEM-2010-SCOPE

Le lien source→catalogue→refus shop est établi. Ne pas déduire la Map10 depuis inStore=false; l’entrée 4.20.1 n’a pas de champ maps. Le SpellName commun avec 2009 ne suffit pas : les effets officiels des deux IDs diffèrent. Sort natif disponible dans les registres mais non décodé/exécuté; miroir communautaire V1034 non probant. Tâche reste a_qualifier et D01-SYS-01-1 reste le gate. Reprendre sur une preuve primaire d’attribution/effet; registre/base non modifiables sans autorisation distincte.

## Reprise V1036 — ITEM-2037-SCOPE

Ne pas refaire les hashes ni le census V996–V997. Data Dragon 4.20.1 exclut explicitement 2037 de Map10; la liste native corrélée suggère l’exclusion, sans identifier son lecteur ni qualifier 4.20.0.315. Item natif Price=350/MaxStack=3; effet porté par SpellName PotionOfGiantStrength, ressource native enregistrée mais non décodée/exécutée. Localement le shop renvoie le refus générique. Reprendre sur source serveur primaire ou décodage contrôlé; tâche reste a_qualifier, D01-SYS-01-1 reste le gate.

## Reprise V1037 — ITEM-2039-SCOPE

Source INIBIN, membership, catalogue officiel et refusal shop établis; ne pas rehacher. La classification Map10 false est 4.20.1; le lien corrélé V996–V997 ne nomme toujours pas le lecteur natif. Le SpellName PotionOfBrilliance mène à des ressources de sort enregistrées mais non liées/décodées/exécutées. Tâche reste a_qualifier, effet serveur et usage local non établis. Reprendre sur preuve primaire ou exécution contrôlée; D01-SYS-01-1 demeure le gate.

## Reprise V1038 — ITEM-2040-SCOPE

Ne pas refaire le hash de 2040, décodage, catalogue 4.20.1 ni rapprochement Map10 V996–V997. L’INIBIN prouve l’entrée générique `InStore=true`, 500 PO, 3 piles; le catalogue 4.20.1 marque `maps[10]=false`. La corrélation avec la liste Map10 reste sans lecteur/champ nommé. OpenLeague n’a ni item ni admission; `shop.rs` prédit le refus générique avant la règle de carte. Garder la qualification historique 4.20.0.315 ouverte; reprendre seulement sur le lecteur/champ natif de la liste ou une preuve primaire serveur/configuration datée. Ensuite préférer une exigence dont le lien peut être conclu sur les preuves déjà enregistrées. V1038 est un audit de lien statique, pas une feature terminée. Goal, plan, application, bases, registre de tâches et checkpoint inchangés.
## Reprise V1039 — OLU-3293 / global CRT de locale

Nouveau point d’entrée vérifié : source exacte OLS-0d51b5dc…; 26 tests directs de `0x14ae870` à zéro et un magasin immédiat à `1` dans l’image principale, VA `0xCA99C9`; API Windows de locale présentes dans l’import table. Ne pas rehash ni refaire le balayage des 27 références. Prochaine action : retracer la fonction/caller et son chemin d’initialisation, puis déterminer l’état CRT/thread réellement transmis et les tables de locale avant d’exercer la branche non nulle. L’absence d’un import `setlocale` n’est pas une preuve que le processus reste en locale C. Cette preuve statique resserre la question, elle ne la clôt pas. Le résolveur parent demeure `partial_with_open_questions` avec cinq inconnues; goal, registres, application, bases et checkpoint inchangés.
## Reprise V1040 — branche CRT qui marque une locale non-C

Erratum : VA d’instruction `0xCA99C7`, opérande global à VA `0xCA99C9`. Le chemin local compare un paramètre non nul à `L"C"` via le callee `0xCB6B7E`; comparaison différente → store 1 dans `0x14AE870`. Cela ne prouve pas que l’initialisation historique appelle la routine ni que le paramètre soit `en_GB`. Prochaine étape : identifier la frontière de fonction/callers et la provenance du paramètre, puis qualifier CRT/thread et tables de locale. Le PDB de build déclaré manque; aucun désassembleur vérifié disponible dans les chemins testés et installation interdite. OLU-3293 reste ouverte. Goal, registres, code, app, bases et checkpoint inchangés.
## Reprise V1041 — provenance de Locale.cfg

Réutiliser identities, hashes et membership V1041; ne pas refaire les parsings ni le census des xrefs. Prochain lot : tracer les appels autour de LoLPatcher VA 0x4AB48D–0x4AB501 et établir l’écriture ou l’emballage du contenu, puis la source de la valeur en_GB. Si aucun décodeur déjà disponible, laisser ouvert et ne rien installer. Ne pas réécrire le catalogue qui épingle E alors que les données sont sur F. Garder distincts DATA/cfg/defaults/locale.cfg (37 o), RADS/system/locale.cfg (12 o), le consumer natif et la politique OpenLeague. Fermer OLU-0ae207ed seulement avec preuve de sortie/provenance; OLU-29959b0b reste distincte pour contexte effectif/provider/startup/overlay. Aucun statut ou goal à modifier.
## V1042 — erratum V1041 / consommateur locale.cfg

Sous-audit source → sélection du profil clos statiquement : le chemin Rust main.rs → native_zip_provider.rs → native_hud_font_configuration.rs existe et le fichier local correspond au défaut 4.20. Preuves V795 réutilisées sans relancer les tests. Ce résultat ne qualifie ni la génération par le patcher, ni les traductions, le rendu ou le client complet. OLU-0ae207ed et OLU-29959b0b restent ouvertes. Preuve détaillée et conditions de reprise : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, section V1042.

## V1043 — résultat de recherche PDB

Piste exacte LoLPatcher.pdb (GUID 1c5218f899cf4741be88500125edccea, Age 173) close pour les recherches déjà faites : Symbol Server renvoie 404 sur les clés AD et 173; aucun résultat indexé pertinent. Ce n’est pas une preuve d’absence partout. Ne pas répéter ces requêtes. OLU-0ae207ed reste ouverte; reprise sur un nouveau PDB/source/décodeur déjà disponible. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V1043.

## Reprise V1044 — génération et déploiement de Locale.cfg

Ne pas répéter les hashes/membres/PDB V1041–V1043 ni l’analyse déjà sauvegardée du writer. Réutiliser V1044 : la chaîne statique identifie un writer wt qui transforme locale=en_gb en octets identiques à la référence 37 octets. C’est une clôture d’audit statique du candidat, pas une preuve d’exécution ou de déploiement. OLU-0ae207ed reste ouverte jusqu’à observation du chemin physique et des octets après écriture dans une copie isolée; OLU-29959b0b demande séparément l’ordre de démarrage, le provider et les overrides. Reprendre l’analyse de 0x4af8a0 seulement quand le Ghidra déjà disponible peut créer son temporaire dans un emplacement autorisé. Aucun code, registre, goal, plan, application ni base de données à modifier.
## Reprise V1045 — URF/Cheats

Le LoLPatcher.exe 4.20 exact a été écarté comme producteur par nom pour les littéraux testés. Réutiliser le résultat; ne pas répéter ce scan. Pour OLU-6c4ea73e et OLU-f76e6025, chercher seulement un nouveau composant/manifest/overlay ou une trace de montage effective. Un chemin construit dynamiquement demeure possible; l’absence de littéral ne clôt pas l’inconnue historique.
## Reprise V1046 — URF/Cheats dans le client d’origine

Les chemins directs testés sont absents du PE client identifié en V1046. Avec V1045, les candidats LoLPatcher et client sont désormais épuisés pour ces références textuelles directes. Ne pas refaire ces scans. Reprendre sur un nouveau xref/loader, une autre source de production ou une observation de montage effectif; chemins calculés et overlays restent inconnus.
## Reprise V1047 — ITEM-3025-SCOPE

Réutiliser la source Data Dragon 4.20.1 hachée, l’INIBIN natif et l’inspection du consumer de V1047. Ne pas répéter le rehash, la lecture /data/3025 ou le test générique 1057. Pour qualifier l’historique, obtenir une source native/merchant Map10 du build 4.20.0.315 ou une preuve serveur d’époque. Le refus actuel item behavior not implemented est un manque de fonctionnalité, pas une interdiction historique. Test exact 3025 seulement si un harness existant le permet sans modifier le code sous la restriction actuelle.
## Reprise V1048 — ITEM-3026-SCOPE

Réutiliser V1048 et ses hashes; ne pas rehash ni rejouer le test générique 1057. Il manque une preuve native/merchant Map10 du client 4.20.0.315 pour décider l’acceptation historique. Le refus local est un manque d’implémentation. Un test direct 3026 ne sera utile qu’après ajout autorisé de l’entrée et de sa règle de carte; ne pas modifier le code ou les registres sous la restriction active.
## Reprise V1049 — ITEM-3027-SCOPE

Réutiliser V1049 et les hashes du consumer V1048; ne pas répéter les rehashes ni le test générique de refus. Il manque une preuve native Map10 du client 4.20.0.315 pour décider l’acceptation historique. Le refus actuel est une fonctionnalité absente. Reprendre après découverte d’une source native merchant/Map10 ou d’une preuve serveur/historique; tester directement 3027 seulement après une intégration autorisée.
## Reprise V1050 — ITEM-3028-SCOPE

Réutiliser V1050, les hashes du consumer V1048 et la source Data Dragon déjà hachée; ne pas rejouer les rehashes ou refus génériques. Il manque une preuve native Map10 de 4.20.0.315 pour conclure la disponibilité historique. Reprendre sur une liste merchant/Map10 native ou une preuve d’époque; vérifier 3028 directement seulement après intégration autorisée.
## Reprise V1051 — ITEM-3029-SCOPE

Réutiliser V1051 et les hashes de consumer V1048; ne pas refaire les scans et tests génériques. La preuve Data Dragon 4.20.1 maps[10]=false n’est pas la décision historique exacte pour 4.20.0.315. Reprendre sur une table merchant/Map10 native, un autre artefact exact de la version, ou une preuve serveur/historique. L’intégration du 3029 reste de la feature work.
## Reprise V1052 — ITEM-3031-SCOPE

Réutiliser V1052 et les hashes du consumer V1048; ne pas répéter les rehashes ou refus génériques. La restriction officielle 4.20.1 ne tranche pas l’historique 4.20.0.315. Reprendre sur une table merchant/Map10 native ou preuve serveur/historique; le runtime OpenLeague reste sans définition et admission 3031.

## Reprise V1053 — ITEM-3084-SCOPE

Réutiliser le reçu natif 3084 et la source officielle Data Dragon 4.20.1 consignés dans docs/AUDIT_SYS01202_ITEM3084_OVERLORDS_BLOODMAIL_2026-11-03.md. La liaison statique au consumer est close : absence du catalogue et de l’admission Map10, refus courant item behavior not implemented. Ne pas refaire les hashes ni le refus générique. La disponibilité historique Map10 reste ouverte; reprendre uniquement sur une table/configuration Map10 native du build 4.20.0.315 ou une observation reproductible. ITEM-3084-SCOPE reste a_qualifier; aucune intégration, aucun statut, goal, Plan, application ou base n’a été modifié.


## Reprise V1054 — ITEM-3085-SCOPE

Réutiliser la preuve native/membership item_shop-links et le consumer partagé documentés dans docs/AUDIT_SYS01202_ITEM3085_RUNAANS_HURRICANE_2026-11-03.md. Le lien statique est clos; la feature reste absente, Map10 4.20.0.315 n’est pas décidé, et SpellName=AtmasImpalerDummySpell n’est pas relié au passif Runaan 4.20.1. Reprendre seulement sur source Map10/merchant du build exact, observation reproductible ou callsite natif du passif. Ne pas refaire les hashes ni le refus générique. Aucun statut, goal, Plan, application ou base modifié.


## Reprise V1055 — ITEM-3086-SCOPE

Réutiliser la preuve native/membership et la référence officielle 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3086_ZEAL_2026-11-03.md. Le lien statique au consumer actuel est clos; la disponibilité Map10 4.20.0.315 n’est pas décidée et la feature n’est pas intégrée. Reprendre uniquement sur une source native Map10/merchant du build exact ou une observation reproductible. Ne pas rehash ni répéter le refus générique. ITEM-3086-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1056 — ITEM-3087-SCOPE

Réutiliser le reçu natif/membership et la référence Data Dragon 4.20.1 consignés dans docs/AUDIT_SYS01202_ITEM3087_STATIKK_SHIV_2026-11-03.md. Le lien statique au consumer est clos; l’admission historique Map10 4.20.0.315, le passif et l’intégration restent non qualifiés. Reprendre seulement sur source native/merchant Map10 du build exact ou observation reproductible. Ne pas rehash ni refaire le refus générique. ITEM-3087-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1057 — ITEM-3090-SCOPE

Réutiliser le reçu natif et la référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3090_WOOGLETS_WITCHCAP_2026-11-03.md. L’audit statique boutique est clos; l’objet reste absent du consumer, Map10 historique est indécidé et le lien ZhonyasHourglass → actif n’est pas prouvé. Reprendre uniquement sur preuve native Map10/merchant du build exact, observation reproductible ou callsite d’effet déjà disponible. Ne pas rehash ni relancer la recherche lexicale sans nouvel indice. ITEM-3090-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1058 — ITEM-3091-SCOPE

Réutiliser le reçu natif/membership et la référence officielle 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3091_WITS_END_2026-11-03.md. Le lien statique au consumer est clos; Map10 historique 4.20.0.315 reste indécidé et l’objet/passifs ne sont pas intégrés. Reprendre seulement sur source native Map10/merchant exacte ou observation reproductible. Ne pas rehash ni refaire le refus générique. ITEM-3091-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1059 — ITEM-3092-SCOPE

Réutiliser le reçu natif/membership et la référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3092_FROST_QUEENS_CLAIM_2026-11-03.md. L’audit statique du refus boutique et de l’absence de handler textuel est clos. L’admission historique Map10, l’actif, Tribute et GoldBase restent non qualifiés. Reprendre seulement sur source Map10/merchant du build exact, observation reproductible ou callsite natif/dispatch disponible. Ne pas refaire les hashes ni le scan lexical. ITEM-3092-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1060 — ITEM-3093-SCOPE

Réutiliser le reçu natif/membership et la référence officielle 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3093_AVARICE_BLADE_2026-11-03.md. Le lien statique boutique est clos; l’admission Map10 historique et les passifs restent non qualifiés, et aucun handler nommé du SpellName n’a été trouvé. Reprendre sur source native Map10/merchant exacte, observation reproductible ou mapping de passif prouvé. Ne pas refaire les hashes ni la recherche textuelle ciblée sans nouvel indice. ITEM-3093-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1061 — ITEM-3096-SCOPE

Réutiliser le reçu natif/membership et la référence officielle 4.20.1 documentés dans docs/AUDIT_SYS01202_ITEM3096_NOMADS_MEDALLION_2026-11-03.md. Le lien statique boutique est clos; la disponibilité Map10 historique, Favor et le groupe GoldBase restent non qualifiés. Reprendre seulement sur preuve native Map10/merchant exacte, observation reproductible ou callsite/règle de groupe autoritative. Ne pas refaire les hashes ou la recherche lexicale sans indice nouveau. ITEM-3096-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1062 — ITEM-3097-SCOPE

Réutiliser le reçu natif/membership et Data Dragon 4.20.1 dans docs/AUDIT_SYS01202_ITEM3097_TARGONS_BRACE_2026-11-03.md. Le lien statique au refus boutique est clos; l’admission Map10 historique, Spoils of War, les charges et GoldBase restent non qualifiés. Reprendre sur source Map10/merchant du build exact, observation reproductible ou callsite/contrat serveur natif. Ne pas rehash ni refaire la recherche textuelle sans nouvel indice. ITEM-3097-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1063 — ITEM-3098-SCOPE

Réutiliser le reçu natif/membership et la référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3098_FROSTFANG_2026-11-03.md. Le refus boutique et l’absence d’un handler Frostfang nommé sont documentés; la mention King's Tribute concerne Trundle, pas cet item. Map10 historique, Tribute et Gold Income restent ouverts. Reprendre seulement sur preuve native Map10/merchant du build exact, observation reproductible ou callsite item autoritatif. Ne pas rehash ou rescanner sans nouvel indice. ITEM-3098-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1064 — ITEM-3100-SCOPE

Réutiliser la preuve native/membership et le catalogue 4.20.1 consignés dans docs/AUDIT_SYS01202_ITEM3100_LICH_BANE_2026-11-03.md. Le consumer boutique refuse l’objet absent; le lien AtmasImpalerDummySpell → Spellblade n’est pas établi. Map10 4.20.0.315 reste à prouver. Reprendre uniquement sur source native Map10/merchant, observation reproductible ou callsite d’effet exact. Ne pas refaire les hashes ni la recherche lexicale sans indice nouveau. ITEM-3100-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1065 — ITEM-3102-SCOPE

Réutiliser le reçu natif/membership et la référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3102_BANSHEES_VEIL_2026-11-03.md. Le lien boutique est statiquement clos, mais Banshee's Veil est absent du consumer et le commentaire sur les spell shields ne prouve pas l’effet. Map10 historique reste à établir. Reprendre sur source native Map10/merchant du build exact, observation reproductible ou callsite d’effet. Ne pas refaire les hashes ou la recherche lexicale sans nouvel indice. ITEM-3102-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.


## Reprise V1066 — ITEM-3104-SCOPE

Réutiliser le reçu natif/membership et la référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3104_LORD_VAN_DAMMS_PILLAGER_2026-11-03.md. Le lien statique boutique est clos; le refus courant est un item absent, pas une preuve d’interdiction historique. Les valeurs maps de 4.20.1 ne tranchent pas Map10 en 4.20.0.315. Reprendre uniquement sur source native Map10/merchant exacte ou observation reproductible. ITEM-3104-SCOPE reste a_qualifier; aucun statut, goal, Plan, application ou base modifié.

## Reprise V1067 — ITEM-3105-SCOPE

Réutiliser le reçu natif/membership et le hash Data Dragon 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3105_AEGIS_OF_THE_LEGION_2026-11-03.md; ne pas refaire les hashes ni le contrôle consumer générique. La liaison statique est close, mais l’objet manque au consumer actuel et cela ne prouve aucune interdiction historique. Reprendre uniquement sur table marchand/admission Map10 du build 4.20.0.315, lecteur natif identifié ou observation reproductible. L’aura et l’intégration restent des travaux fonctionnels distincts; ITEM-3105-SCOPE reste a_qualifier. Aucun statut, code, goal, application ou base modifié.
## Reprise V1068 — ITEM-3106-SCOPE

Réutiliser le reçu natif/membership et le hash catalogue 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3106_MADREDS_RAZORS_2026-11-03.md; réutiliser le contrôle shop partagé V1067. Ne pas rehash ni répéter le refus générique. La liaison source → consumer est close statiquement; maps[12]=false ne tranche pas Map10 4.20.0.315 et InStore=1 n’est pas une admission de carte. Reprendre seulement sur table marchand/admission native, lecteur identifié ou observation reproductible. Le passif Maim reste une tâche distincte; ITEM-3106-SCOPE demeure a_qualifier. Aucun statut, code, goal, application ou base modifié.
## Reprise V1069 — ITEM-3106-SCOPE, source communautaire

Le lien communautaire consulté dans le rapport ITEM-3106 étaye que Madred's Razors était réservé à Classic Twisted Treeline après le patch 4.20 et retiré en 5.11. Traiter cela comme corroboration secondaire, pas comme preuve exacte du client fourni 4.20.0.315. Ne pas répéter cette recherche ni les hashes/contrôles génériques. Clore la disponibilité exacte seulement sur note Riot attribuable, table native/reader Map10 du build ou observation reproductible; le passif Maim et l’implémentation restent séparés. Tâche a_qualifier, statut inchangé.
## Reprise V1070 — ITEM-3111-SCOPE

Réutiliser le reçu natif/membership et le catalogue 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3111_MERCURYS_TREADS_2026-11-03.md ainsi que le contrôle consumer partagé V1067. Ne pas refaire les hashes ni la recherche d’availability non datée. La liaison source/consumer est close statiquement; Map10 historique 4.20.0.315 reste indécidé et InStore=1 n’est pas une preuve de carte. Reprendre seulement sur table/reader natif, note officielle datée ou observation reproductible. Tenacity, feature et acceptation restent des travaux distincts; tâche a_qualifier, statut inchangé.
## Reprise V1071 — ITEM-3113-SCOPE

Réutiliser le reçu natif et la source Data Dragon 4.20.1 consignés dans docs/AUDIT_SYS01202_ITEM3113_AETHER_WISP_2026-11-03.md, ainsi que le refus shop partagé V1067. Ne pas rehash ni répéter la recherche communautaire : elle n’établit qu’une présence ultérieure en février 2015, pas l’admission 4.20.0.315. Reprendre sur table/reader native Map10 datée, note officielle précise ou observation reproductible du client exact. ITEM-3113-SCOPE reste a_qualifier; statut et fonctionnalité inchangés.
## Reprise V1072 — ITEM-3115-SCOPE

Réutiliser le reçu natif/membership et le catalogue 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3115_NASHORS_TOOTH_2026-11-03.md ainsi que le contrôle shop partagé V1067. Ne pas rehash, interpréter SpellName=Malady comme passif, ni refaire les recherches de disponibilité non versionnées. Reprendre uniquement sur table/reader natif Map10 exact, note officielle datée ou observation reproductible du client 4.20.0.315. Le passif, l’implémentation et l’acceptation restent séparés; ITEM-3115-SCOPE demeure a_qualifier.
## Reprise V1073 — ITEM-3116-SCOPE

Réutiliser le reçu natif/membership et le SHA de référence 4.20.1 du rapport docs/AUDIT_SYS01202_ITEM3116_RYLAIS_CRYSTAL_SCEPTER_2026-11-03.md; ne pas rehash ni refaire le refus générique de shop.rs. La liaison statique est close pour ce sous-lot; Map10 sur le client PUBLIC 4.20.0.315 ne l’est pas. Reprendre seulement sur une table native marchande/admission datée avec lecteur identifié, source Riot attribuable, ou observation reproductible du client exact. Le passif Rylai, l’intégration boutique, l’implémentation et l’acceptation restent distincts; ITEM-3116-SCOPE demeure a_qualifier. Aucune tâche, aucun goal, plan, application ou base modifiés.

## Reprise V1074 — ITEM-3116 / Items Map10

Réutiliser le reçu Items.inibin V1025, les décodeurs existants et les trois reçus REA sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision1074_*. Aucun hash ni census à refaire. Fait ciblé : 3116 n’apparaît pas parmi les valeurs décodées de LEVELS/Map10/Items.inibin. Limite déterminante : le PE dit que seuls les items listés dans LEVELS/[MapName]/Items.ini sont en boutique; aucun Items.ini n’a été trouvé dans deploy/LEVELS et son lien au binaire Items.inibin est inconnu. L’interprétation antérieure « liste d’exclusion » entre en tension avec ce texte. Ne pas conclure l’admission Map10. Les appels REA search_strings/xrefs/resolve ont expiré à 180 s et sont fermés; ne pas les répéter sans nouveau chemin d’analyse. Reprendre sur un Items.ini exact, un mapping vérifiable INI→INIBIN, un consumer obtenu par une méthode différente ou une observation reproductible. Tâche a_qualifier; feature et acceptation distinctes; goal actif.

Complément V1074 : absence de nom Items.ini confirmée par rg --hidden --no-ignore dans le corpus local D:/LeagueOfLegendsV2/4.20 et F:, et aucun hit dans les recherches ciblées LeagueSandbox/Web. Ne pas élargir par répétition à des recherches génériques. Reprendre si la copie originale 4.20/Map10, une archive attribuable, ou un mapping INI→INIBIN est fourni/identifié.

## Reprise V1075 — ITEM-3116 et listes Map10

Réutiliser les 98 correspondances UnpurchasableItemList/Item0…Item97 et les deux lecteurs consignés dans l’addendum V1075 du rapport ITEM-3116. Les références PE aux listes d’inclusion et de non-achat sont distinctes et peuvent coexister; ne plus présenter leur existence comme contradictoire. 3116 est absent de la liste non achetable décodée, mais l’admission finale reste inconnue : les valeurs effectives it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly, la liste d’inclusion, le provider et le runtime n’ont pas été établis. Recherche textuelle et sections candidates déjà bornées; reprendre sur une configuration, un constructeur/consumer ou une observation native nouvelle. Ne pas répéter les appels REA expirés ni changer les statuts.

## Reprise V1076 — ITEM-3116-SHOP-ICONE

Réutiliser la comparaison DDS/PNG et le membership consigné dans l’addendum V1076 du rapport ITEM-3116; ne pas recréer ou re-décoder les images inchangées. Le chemin boutique filtre les objets avant de charger ui/items/{id}.png; 3116 manque de la définition et de l’admission. Reprendre après décision du scope et intégration : vérifier le rendu réel, le traitement des refus et la comparaison à la référence. L’audit des pixels est clos; tâche, runtime et acceptation restent ouverts.

## Reprise V1077 — ITEM-3116-SHOP-TEXTE

Réutiliser les trois clés et les lignes en_GB consignées dans l’addendum V1077 du rapport ITEM-3116; ne pas rehash la locale inchangée ni répéter la recherche bornée. Le consumer boutique utilise les champs du catalogue, sans ligne 3116; @Value@ et la locale effective ne sont pas qualifiés. Après qualification du scope et intégration de 3116, vérifier les textes, la valeur de vente, les refus et le rendu runtime. Audit statique clos; tâche et acceptation ouvertes.

## Reprise V1078 — paramètres d’inclusion Map10

Réutiliser le désassemblage et les adresses de l’addendum V1078 : constructeurs 0x4F29F0/0x4F2A70, champs 0x12396EC/0x12396FC, consumer 0x5B6600 et setter potentiel 0x574A30 via table 0x1084F24. Les zéros initiaux ne sont pas une preuve des valeurs effectives; le dispatch et la source de configuration restent inconnus. Reprendre avec un callsite ou une configuration primaire, ou une observation reproductible du client exact. Ne pas refaire le balayage .text ou les REA expirés sans indice nouveau. Le scope, la fonctionnalité et l’acceptation restent ouverts.

## Reprise V1079 — ITEM-3116-SHOP-PRIX

Réutiliser la lecture et les reçus du rapport ITEM-3116, addendum V1079. Ne pas confondre Price natif 605 et Item.price total du consumer local : référence comparative 2900, composants 2295, crédit statique conduisant à 605. La vente demande sell_price explicite; 2030 est une valeur 4.20.1, pas un SellBackModifier natif établi. Après qualification de ITEM-3116-SCOPE et intégration des données, vérifier les cas inventaire vide/composants, refus, vente et runtime. Aucun statut modifié.

## Reprise V1080 — configuration d’inclusion Map10

Réutiliser Constants.var Map10, source OLS-687ba5a2-460e-57d9-9e82-244a7d49b8c1 et hashes de l’addendum V1080. Les deux affectations valent 0 dans cette copie; la chaîne statique est 0x591E08 → 0x6A2BC0 → résolveur 0x6A2930 et lecteur 0x6A27D0 → recherche 0x6A2770 → dispatch virtuel 0x6A28FA → setter 0x574A30. Le chemin/provider final, les overlays et l’ordre des écritures restent inconnus. Reprendre sur cette priorité et le dispatch effectif; ne pas traiter les zéros comme observation runtime ni refaire les hashes inchangés. Tâche et acceptation ouvertes.

## Reprise V1081 — résolveur Constants Map10

Réutiliser V1081 : 0x6A2930 construit Constants{suffixe}.var; 0x90AEF0 peut réutiliser un fournisseur existant ou en créer un. Dans la branche créée, vtable 0x10D6380 slot +0x1C=0x90A480 mène à 0x905CA0, dont le repli conditionnel transmet le même nom. Ne pas supposer de suppression de suffixe ni une priorité de fichiers. Reprendre sur la valeur produite par 0x5B26E0, le fournisseur et sa chaîne effective; les deux zéros du Constants.var local restent une preuve conditionnelle, non runtime.

## Reprise V1082 — ITEM-3116-SHOP-RECETTE

Réutiliser les reçus recette/prix et le contrôle statique de l’addendum V1082. 3116 manque des définitions/admissions; aucun test générique inspecté ne prouve son achat. Après ITEM-3116-SERVER et décision Map10, vérifier directement consommation, case libérée, fonds, inventaire plein, graphe invalide et rendu. Les erreurs explicites sont antérieures aux écritures inspectées; ne pas prétendre à une atomicité face aux interruptions sans preuve. Tâche, runtime et acceptation ouverts.

## Reprise V1083–V1084 — santé et passif 3116

Réutiliser les lectures INIBIN et les ancres shop/progression/slows/damage consignées dans le rapport ITEM-3116. La santé native textuelle 400 correspond au catalogue; le bonus local n’est pas atteint par achat 3116 absent. Les valeurs natives négatives du passif ne doivent pas être transmises directement à prepare_slow, qui exige une fraction positive. Reprendre sur un producteur primaire et les règles de conversion/cumul, puis vérifier santé et ralentissement dans le runtime après qualification du scope et intégration. Aucune tâche ou acceptation ne change.

## Reprise V1085 — origine du suffixe

Réutiliser le constructeur 0x5B2280, setter 0x5B2590, getter 0x5B26E0 et les deux appels directs documentés dans V1085. Le chemin -missionMode est conditionnel; le dispatch 0x54 lit une structure dont la provenance et la valeur restent inconnues. Le scan couvre E8 directs seulement. Reprendre sur les arguments réellement fournis, le producteur de la structure et la résolution fournisseur; ne pas assimiler suffixe initial vide ou exemple CLASSIC à la valeur runtime Map10.

## Reprise V1086–V1087 — puissance et préchargements 3116

Réutiliser les deux lecteurs, les sources/empreintes et les chunks Lua consignés en V1086–V1087. Le consumer local AP applique le multiplicateur d’autels; l’entrée 3116 est absente. Les noms préchargés sont des dépendances client, sans producteur de passif établi; ItemSlow contient des métadonnées Frozen Mallet et ne doit pas être assimilé automatiquement à Rylai. Reprendre sur le callsite ou script serveur primaire et, après intégration, vérifier statistique, sort et passif en runtime. Aucun statut ou acceptation modifié.

## Reprise V1088 — objet du dispatch de suffixe

Réutiliser V1088 : vtable 0x10AFDD0 slot +0xF0 → wrapper 0x72B2D0 → 0x72B2F0; constructeur 0x730560, fabrique 0x72F540. Le balayage E8 direct ne couvre pas les appels virtuels. Reprendre sur le callsite virtuel et le producteur de la structure alimentant le dispatch 0x54; son type et son contenu ne sont pas établis. Ne pas attribuer de valeur runtime Map10.

## Reprise V1089–V1090 — serveur et boutique 3116

Réutiliser les chemins et limites des addenda V1089–V1090 du rapport ITEM-3116. Distinguer filtre UI sans émission, refus serveur conditionnel et séquence déjà commit; aucun paquet ni achat 3116 n’a été exécuté. Undo local reste désactivé/no-op; le HUD d’inventaire est distinct. Après qualification et intégration, vérifier les transactions, refus, séquence, inventaire/HUD et contrat historique d’annulation; clarifier les critères de SHOP sans changer le registre sous la restriction actuelle.

## Reprise V1091 — paquet de synchronisation et mode

Réutiliser la comparaison et les sources épinglées de V1091 : 0x54 correspond fortement à SynchVersionResponse, +0x986 au champ gameMode. Ne pas confondre cette identification avec une preuve de CLASSIC ou de l'admission 3116 en Map10. Reprendre sur une capture 4.20 EUW fiable ou une source primaire de la valeur reçue; vérifier provenance, contexte et encodage. Aucun paquet ni jeu exécuté.

## Reprise V1092 — Heal, cible et niveau

Réutiliser le rapport AUDIT_SYS01202_SUMMONER_HEAL_TARGET_LEVEL_2026-11-03.md et l'audit préalable du cooldown. Code local : cible automatique par ratio puis ID; montants selon le niveau du bénéficiaire. Ne pas confondre ces choix et le tooltip 4.20.1 avec une preuve du serveur historique; ne pas réexécuter les hashes sans indice nouveau. Reprendre sur source serveur 4.20 attribuable ou observation historique pour niveau, sélection, égalité et refus. Après qualification, vérifier avec les tâches SERVER et NET existantes; statuts et bases inchangés.

## Reprise V1093 — Flash et destination au sol

Réutiliser AUDIT_SYS01202_SUMMONER_FLASH_COMMAND_2026-11-03.md et la traçabilité V81 : cinq variantes actuelles, D/F sans point, CastAt réservé au chemin des compétences de champion. Compléter séparément SCOPE, SERVER et NET après qualification; vérifier position, bornes et refus sur preuve historique, puis exécuter les tests ciblés. Ne pas inférer les règles de Flash à partir d'Ezreal E ni répéter les hashes inchangés.

## Reprise V1094 — Ignite, premier tick et vision

Réutiliser AUDIT_SYS01202_SUMMONER_IGNITE_SERVER_2026-11-03.md : first_tick_immediate est une clé non consommée par Rules et le premier tick est appelé directement; qualifier la cadence historique avant correction. La branche de visibilité lue ne démontre pas la clause de camouflage et le test de déconnexion ne vérifie pas visible_to. Reprendre sur source serveur 4.20 ou observation fiable, puis vérifier cadence, recouvrement, furtivité et déconnexion dans les tâches existantes; ne pas refaire les hashes inchangés.

## Reprise V1095 — Châtiment, bonus de camp et objets

Réutiliser AUDIT_SYS01202_SMITE_REWARDS_2026-11-03.md et les tests historiques de ciblage V279 sans les rejouer sans changement. Distinguer or/XP ordinaires, bonus de camp propres à Smite et refus des objets jungle. Reprendre la qualification sur serveur 4.20 ou observation historique Map10; après intégration, tester explicitement bonus non létal/létal, non-duplication et aggro avec autre unité vivante vérifiée.

## Reprise V1096 — Fatigue et vitesse d'attaque

Réutiliser AUDIT_SYS01202_EXHAUST_EFFECTS_2026-11-03.md, les reçus réseau 2026-10-03 et témoin V645 sans les assimiler à une preuve Riot ou à la révision courante. La formule locale retire 0,3 des bonus d'attaque; qualifier la formule historique avec plusieurs niveaux de bonus, puis vérifier durée/tenacité, dégâts bruts et familiers. Les tâches SCOPE/SERVER/NET et leur acceptation restent ouvertes.

## Reprise V1097 — frontière d'apparition des vagues

Réutiliser V88/V470 et le complément V1097 dans FIDELITY_WAVES_LINKS_4_20.md. Vérifier les seuils locaux 179/180 et une erreur de définition par voie, puis plan figé et vague après réapparition; aucun de ces cas n'a été exécuté ici. Qualifier séparément le compteur et les erreurs du scheduler historique avant correction; conserver SYS-10.5-02 et les tâches SUPER ouvertes.

## Reprise V1098 — relique, cadence et second ramassage

Réutiliser V87 et le complément V1098 dans FIDELITY_OBJECTIVES_LINKS_4_20.md. Séparer script communautaire à seuil 250 ms, contrôle local à chaque tick et cadence Riot inconnue. Conserver le reçu réseau historique et sa revendication non corroborée par les tests ciblés actuels; vérifier deux ramassages réels, égalités et entrées/sorties entre contrôles avec binaires identifiés avant de qualifier SYS-10.4-09.

## Reprise V1099 — autels et instantané du R d'Ezreal

Réutiliser V87 et le complément V1099 de FIDELITY_OBJECTIVES_LINKS_4_20.md : multiplication locale de l'AD total avant décomposition, puis bonus consommé et brut figé au cast R. Qualifier l'assiette historique et le moment d'échantillonnage; comparer sans/avec autels et objet AD, et perte des autels avant/après cast. Aucun test Rust ni partie n'a été exécuté dans V1099.

## Reprise V1100 — audience des autels

Réutiliser V87 et le complément V1100 de FIDELITY_OBJECTIVES_LINKS_4_20.md. Établir d'abord si la progression doit être publique selon le serveur 4.20 ou une décision de conception, puis tester deux équipes/autel neutre et possédé en comparant projections, paquets legacy/sécurisés et diagnostic. Pas de violation ou de rendu observés; aucun serveur ni test exécuté dans V1100.

## Reprise V1101 — preuve API d'autel hors vision

Réutiliser la fixture, le binaire et le résultat conservés dans E:/mapslol3v3/relic_altar_audit_probe et le complément V1101 de FIDELITY_OBJECTIVES_LINKS_4_20.md. La projection locale est observée dans une fixture sans unités, avec lock isolé distinct; aucun paquet ou client graphique testé. Qualifier séparément le contrat Riot et les deux transports sur des binaires identifiés; ne pas assimiler le BroadcastPacket Map8 communautaire à un appel Map10.

## Reprise V1102 — codecs d'autel en mémoire

Réutiliser E:/mapslol3v3/altar_wire_audit_probe et le complément V1102. Les codecs OLST fragmenté et OLSR préservent la projection dans la fixture, pas une preuve d'émission/livraison ou de règle Riot. Tester séparément les routes serveur réelles, les deux audiences avec monde non vidé et le contrat historique; conserver les statuts ouverts.

## Reprise V1103 — seuils locaux des vagues

Réutiliser E:/mapslol3v3/wave_cap_audit_probe et le complément V1103 de FIDELITY_WAVES_LINKS_4_20.md : seuils 178/179/180 et exclusion d'un mort observés dans une fixture de premier créneau. Ne pas confondre ce compteur local avec le compteur Riot; erreur de spawn, suite des vagues et partie réelle restent à vérifier.

## Reprise V1104 — créneau sauté et place libérée

Réutiliser E:/mapslol3v3/wave_retry_audit_probe et le complément V1104 : dans la fixture locale, deux places libérées avant le créneau suivant permettent ses unités mais ne reproduisent pas le créneau sauté. Ne pas étendre cette preuve au reste de la vague, à un échec de création ou au serveur Riot; qualifier ces points séparément.

## Reprise V1105 — second ramassage de relique

Réutiliser E:/mapslol3v3/relic_second_pickup_probe et V1105 dans FIDELITY_OBJECTIVES_LINKS_4_20.md : deux pickups et leurs frontières ont passé dans une fixture à sauts de temps. Vérifier séparément la partie continue, les deux audiences et la politique Riot historique; conserver le reçu réseau ancien et les statuts intacts.

## Reprise V1106 — autels et R d'Ezreal

Réutiliser E:/mapslol3v3/altar_ezreal_audit_probe et le complément V1106 : la capture et la perte après lancement ont été exécutées dans une fixture synthétique. L'impact conserve le bonus local fixé au lancement. Ne pas assimiler ce comportement à la formule Riot; rechercher seulement lorsqu'une source serveur attribuable ou une capture 4.20 mesurée devient disponible, puis couvrir les variations AD/AP et le timing. Conserver les tâches et preuves existantes.

## Reprise V1107 — outils externes du registre

Réutiliser le complément V1107 et E:/mapslol3v3/trace_external_identity_audit : identité et ancres des 14 liens externes sont établies pour huit fichiers, mais ni leur exécution ni leur pertinence sémantique ne le sont. Ne rejouer qu'en cas de modification des fichiers/registres ou d'anomalie nouvelle. Le goal et les cinq inconnues du parent demeurent ouverts.

## Reprise V1108 — Ahri Q

Réutiliser E:/mapslol3v3/ahri_q_audit_probe et docs/AUDIT_SYS01202_AHRI_Q_SOURCE_DISPATCH_2026-11-03.md. Les 19 champs ciblés et les refus d'apprentissage/lancement sont vérifiés; le HUD ne prouve pas une mécanique jouable. Reprendre après source serveur ou capture historique nouvelle et traiter progression, ciblage, mécanique, réseau et présentation séparément dans les tâches existantes. Ne pas modifier leurs statuts au titre de ce contrôle.

## Reprise V1109 — consommateurs hors fiche et doublons

Réutiliser E:/mapslol3v3/trace_remaining_consumer_audit et le complément V1109. Les 4 402 identités relatives hors parent sont vérifiées sur F:, les 39 chemins absolus restent hors périmètre. Deux fiches contiennent chacune un doublon du même ID : compter liens et ID distincts séparément. La correction AUD-TRACE-CONSUMER-UNIQUE-01 est une proposition seulement; ne rien modifier dans le registre ou l'application sous la restriction actuelle. La sémantique et le goal restent ouverts.

## Reprise V1110 — matrice des refus de capacités

Réutiliser E:/mapslol3v3/champion_spell_refusal_audit et AUDIT_SYS01202_CHAMPION_SPELL_REFUSAL_MATRIX_2026-11-03.md : 118 IDs, 472 tâches et 1 416 refus API sont rapprochés; les quatre autres champions sont témoins d'apprentissage Q uniquement. Reprendre sort par sort avec sources et règles qualifiées, puis tests fonctionnels et parcours réels. Les 472 tâches et l'ensemble du goal restent ouverts.

## Reprise V1111 — consumers absolus et archives Cargo

Réutiliser E:/mapslol3v3/trace_absolute_consumer_audit et le complément V1111 : 39 liens, 18 fichiers, 17 membres d'archives et six checksums locaux concordants. Les sources et archives n'identifient pas un binaire exécuté et ne prouvent pas la sémantique. Les partitions des 5 759 IDs sont non simultanées. Ne rejouer qu'après changement ou pour répondre à une question précise nouvelle.

## Reprise V1112 — liens de ressources de sorts

Réutiliser E:/mapslol3v3/champion_spell_source_link_audit et AUDIT_SYS01202_CHAMPION_SPELL_SOURCE_LINKS_2026-11-03.md : 7 082 fiches associées à 488 couples et 488 fichiers relus. Ce n'est ni 7 082 audits complets, ni une validation des règles; poursuivre par source serveur/capture et consumer effectif, sort par sort. Les tâches et le goal restent ouverts.

## Reprise V1113 — valeurs et absences des sorts

Réutiliser E:/mapslol3v3/champion_spell_numeric_audit et AUDIT_SYS01202_CHAMPION_SPELL_NUMERIC_FIELDS_2026-11-03.md. Pour 488 sorts : 11 776 comparaisons numériques, 910 absences bilatérales, deux textes Karma Q conservés et conversion native antérieure bornée. Aucun défaut ou règle serveur inféré des seules absences; Yasuo W reste à qualifier côté HUD/ressource. Poursuivre par capacité et consumer réel.

## Reprise V1114 — définitions d'objets

Réutiliser E:/mapslol3v3/item_source_link_audit et AUDIT_SYS01202_ITEM_NATIVE_SOURCE_LINKS_2026-11-03.md : 280 définitions natives vérifiées, 33 IDs dans le catalogue courant et 247 absents. Ne pas interpréter ces 247 comme tous achetables en Map10; qualifier disponibilité et règles objet par objet avant correction. Le goal reste ouvert.

## Reprise V1115 — statistiques de 33 objets

Réutiliser E:/mapslol3v3/item_catalog_stat_audit et AUDIT_SYS01202_ITEM_CATALOG_STATS_2026-11-03.md : 334 correspondances, 29 clés de vol de vie absentes, quatre chemins stats exécutés en fixture. Vérifier séparément les défauts natifs, admission, achat et effets, sans assimiler ces quatre contrôles à une boutique complète.

## Reprise V1116 — 247 objets et Map10

Réutiliser E:/mapslol3v3/item_map10_priority_audit et AUDIT_SYS01202_ITEM_MAP10_PRIORITY_2026-11-03.md. Prioriser les 150 candidats `purchasable`/InStore sans les déclarer disponibles; 83 exclusions explicites ne concernent que le catalogue 4.20.1 et 14 autres sont non achetables globalement. Réutiliser V1075–V1085 : clés UnpurchasableItemList identifiées, inclusion distincte et flags effectifs encore inconnus. Ne pas répéter les scans inchangés.


## Reprise V1117 — rectification Map10

Réutiliser V1075–V1085 et la rectification dans AUDIT_SYS01202_ITEM_MAP10_PRIORITY_2026-11-03.md : noms de clés et coexistence des listes établis; provider, suffixe, surcharges et flags effectifs restent ouverts. Ne pas reprendre l'ancienne formulation V1116 sur l'absence de nom ou une contradiction supposée.

## Reprise V1118 — graphe de recettes candidats

Réutiliser E:/mapslol3v3/item_recipe_graph_audit et AUDIT_SYS01202_ITEM_CANDIDATE_RECIPE_GRAPH_2026-11-03.md. Les groupes 60/68/19 ne sont qu'un ordre hypothétique de dépendances : qualifier les admissions et objets avant toute implémentation. Les trois variantes Viktor exigent de qualifier l'origine de 3200; pas d'achat testé.

## Reprise V1119 — liste native et garde cliente

Réutiliser E:/mapslol3v3/map10_native_shop_guard_audit et AUDIT_SYS01202_MAP10_NATIVE_SHOP_GUARD_2026-11-03.md : instructions PE et 98 valeurs vérifiées; 150 candidats absents de cette liste. Qualifier séparément provider, flags d'inclusion, cache et décision serveur avant de conclure à l'admission; aucun runtime historique exécuté.

## Reprise V1120 — achats Map10 et preuve Viktor antérieure

Réutiliser E:/mapslol3v3/map10_shop_purchase_matrix et AUDIT_SYS01202_MAP10_SHOP_PURCHASE_MATRIX_2026-11-03.md : 247 refus d'IDs absents, 2 refus Map10, 31 succès locaux en fixture. Pour 3200 et ses améliorations, réutiliser aussi FIDELITY_VIKTOR_PASSIVE_GLORIOUS_EVOLUTION_LINKS_V650.md : texte natif de départ et essais antérieurs existent, producteur historique et build courant en partie restent ouverts.

## Reprise V1121 — cache natif Map10

Réutiliser E:/mapslol3v3/map10_original_parser_audit et AUDIT_SYS01202_MAP10_ORIGINAL_CACHE_ITEMS_2026-11-03.md : wrapper/cache/parseur originaux exercés sur 98 entrées sous racine et locale déclarées, sans client réel. Item20 texte est converti correctement; Item98 utilise le défaut. Qualifier séparément bootstrap/provider/surcharges, flags et serveur avant admission historique.

## Reprise V1122 — boucle et arbre natifs Map10

Réutiliser E:/mapslol3v3/map10_original_list_loop_audit et AUDIT_SYS01202_MAP10_ORIGINAL_LIST_LOOP_2026-11-03.md. Boucle originale, arbre, recherche et garde sont exécutés par séquences isolées avec état et racine fournis; 150 candidats absents de l'arbre de fixture. Provider, flags, construction réelle et décision serveur restent ouverts.

## Reprise V1123 — ventes locales Map10

Réutiliser E:/mapslol3v3/map10_shop_sale_matrix et AUDIT_SYS01202_MAP10_SHOP_SALE_MATRIX_2026-11-03.md : 31 ventes nominales, piles 2003/2004 et ventes d'objets exclus injectés. Qualifier séparément règles Riot, recettes, effets et parcours UI/réseau; les cas injectés ne prouvent pas l'acquisition.

## Reprise V1124 — lecture native isolée de Constants.var

Réutiliser E:/mapslol3v3/map10_original_constants_audit et AUDIT_SYS01202_MAP10_ORIGINAL_CONSTANTS_READER_2026-11-03.md : fichier réel, registre synthétique à deux objets, flags 0/0; variantes 1 et BAD uniquement en mémoire. Les tests n'établissent pas la sélection historique du fichier, la configuration complète ou la décision serveur.

## Reprise V1125 — composants identiques

Réutiliser E:/mapslol3v3/map10_duplicate_recipe_audit et AUDIT_SYS01202_MAP10_DUPLICATE_RECIPES_2026-11-03.md : 18 cas locaux pour 3114/3101/3134, sans preuve historique ou parcours UI/réseau. Les tâches SHOP-RECETTE restent ouvertes.

## Reprise V1126 — composition native Map10

Réutiliser E:/mapslol3v3/map10_native_composed_audit et AUDIT_SYS01202_MAP10_NATIVE_COMPOSED_LISTS_2026-11-03.md : lecture des flags puis boucles dans une instance par cas, entrée réelle 0/0 et témoin synthétique 1/0. Ne pas inférer le provider, le mode, l'absence de surcharge ou l'admission serveur effective.

## Reprise V1127 — mode et constructeur natifs Map10

Réutiliser AUDIT_SYS01202_MAP10_NATIVE_MODE_OBJECT_2026-11-03.md et ses deux scripts isolés : 20 cas de branche et recherche sur objet natif partiel avec 1062/1039. Ne reprendre le bootstrap ou la décision d'achat qu'avec une trace de mode/provider/paramètres finaux ou une nouvelle piste serveur attribuable ; ces essais ne prouvent pas une partie.

## Reprise V1128 — contrôle client et autorité boutique

Réutiliser AUDIT_SYS01202_SHOP_CLIENT_GROUP_2026-11-03.md et E:/mapslol3v3/audit_shop_quote_group_20261103. Le cas 3020 possédé puis 1001 est reproduit entre fragments clients et core ; poursuivre HUD-SHOP-BUY-FEEDBACK-01 avec clic/ECS, serveur et réception du refus, puis qualification de la politique souhaitée. Pas de règle historique déduite.

## Reprise V1129 — inventaire après reprise locale

Réutiliser AUDIT_SYS01202_RECONNECT_INVENTORY_SNAPSHOT_2026-11-03.md et la fixture E:/mapslol3v3/audit_reprise_inventaire_20261103. SYS-20.3-02/03 restent ouverts pour les autres états, transport, commit et rendu : ce test ne lance aucun client ni réseau et ne démontre pas le protocole historique.

## Reprise V1130 — coût HUD Yasuo W

Réutiliser AUDIT_SYS01202_YASUO_W_HUD_COST_2026-11-03.md et E:/mapslol3v3/audit_yasuo_w_hud_20261103. Cinq rangs injectés confirment l'erreur de calcul ; Learn Yasuo reste refusé. Reprendre CH-Yasuo-W-PRESENTATION-HUD après qualification du défaut/ressource et de la progression, puis vérifier le vrai rendu ; ne pas inventer de coût.

## Reprise V1131 — visibilité Ignite après retrait local

Réutiliser AUDIT_SYS01202_IGNITE_REMOVED_SOURCE_VISION_2026-11-03.md et E:/mapslol3v3/audit_ignite_visibility_source_removed_20261103. La vision locale a été testée avec remove_player et un observateur allié, sans réseau. Qualifier séparément détachement récupérable, audiences réseau, furtivité et comportement Riot ; l'ancienne formulation V105 est précisée.

## Reprise V1132 — rig Veigar et consommateur

Réutiliser AUDIT_SYS01202_VEIGAR_RIG_CONSUMER_2026-11-03.md et E:/mapslol3v3/audit_veigar_rig_runtime_20261103. Les trois entrées V527 sont inchangées et le code sélectionne le GLB par défaut ; CH-Veigar-MODELE-RIG / OLU-29dbb803-7d62-54e9-a39e-acfedede9e66 restent ouverts. Toute correction, validation de pose et rendu exigent une étape distincte autorisée.

Piste suivante à qualifier sans présumer d'absence : SYS-05.1-02 à 05, dépense d'un point et reprise des rangs. V77 établit des sources et consommateurs ; quatre fiches de trace inspectées n'ont pas de native_inputs direct. Vérifier les preuves et périmètre exact avant tout test ou modification, sans toucher aux registres.

## Reprise V1133 — compétences, session et point disponible

Réutiliser AUDIT_SYS01202_SKILL_SESSION_RESUME_2026-11-03.md et E:/mapslol3v3/audit_skill_session_resume_20261103 : commandes en mémoire, refus et point disponible repris puis dépensé. SYS-05.1-02 à 05 conservent leurs inconnues ; sources natives directes non liées, concurrence réelle, transport, client et serveur historique restent à qualifier. Ne pas modifier les registres sous la restriction actuelle.

## Reprise V1134 — UV spatiaux terrain Map10

Réutiliser AUDIT_SYS01202_MAP10_BLENDER_TERRAIN_UV_2026-11-03.md et E:/mapslol3v3/audit_map10_blender_uv_20261103. Deux objets, 78 boucles, conversion glTF/Blender et divergence numérique avec c233 simulé ; poursuivre SYS-02.4-03 sur les autres morceaux, bords inter-objets et rendu qualifié avant décision d'une correction.

## Reprise V1135 — UV et bords Jungle1

Réutiliser AUDIT_SYS01202_MAP10_JUNGLE1_UV_BATCH_2026-11-03.md et E:/mapslol3v3/audit_map10_jungle1_uv_batch_20261103 : 34 objets et 1 728 boucles, 99 bords exacts entre objets, sans rendu. Poursuivre SYS-02.4-03 avec autres matériaux, frontières approchées/partielles et échantillonnage ou rendu qualifié ; aucune correction automatique.

## Reprise V1136 — UV et images des deux matériaux terrain

Réutiliser AUDIT_SYS01202_MAP10_CROSS_MATERIAL_UV_2026-11-03.md et E:/mapslol3v3/audit_map10_cross_material_uv_20261103. Les 82 objets et 25 bords exacts inter-matériaux sont documentés ; poursuivre SYS-02.4-03/04 sur bords proches/partiels, orientation et échantillonnage effectifs puis rendu comparatif. Ne pas corriger les UV automatiquement.

## Reprise V1137 — modèle CPU d'échantillonnage terrain

Réutiliser AUDIT_SYS01202_MAP10_TERRAIN_UV_SAMPLING_2026-11-03.md et E:/mapslol3v3/audit_map10_texture_uv_samples_20261103. Échantillons bruts calculés sous hypothèse top-vers-bas et LOD0, pas des pixels rendus ; qualifier orientation et échantillonnage réels avant comparaison visuelle et décision SYS-02.4-03/04.

## Reprise V1138 — orientation sampler Blender terrain

Reutiliser docs/AUDIT_SYS01202_MAP10_BLENDER_TEXTURE_SAMPLING_2026-11-03.md et E:/mapslol3v3/audit_map10_blender_sampling_20261103/resultats_scale16.json. L orientation V inversee est qualifiee pour le noeud Blender isole sur 78 boucles, pas pour Bevy/GPU ni pour toute la carte. La reprise exige un rendu Bevy controle au meme emplacement avec version d asset, capture ou lecture GPU et qualification du LOD/melange avant toute correction UV ou texture. Ne rejouer ni le modele CPU V1137 ni la grille Blender sans nouvelle question.
## Reprise V1139 — consommateur et sampler terrain Bevy

Réutiliser `docs/AUDIT_SYS01202_MAP10_BEVY_TERRAIN_CONSUMER_2026-11-03.md` et `E:/mapslol3v3/audit_map10_bevy_consumer_20261103/cargo_test_bin_retry.log`. Ne pas transférer l'orientation Blender `UVMap.001`, les contrats `projected_*` ou les valeurs de reset globales au draw terrain. Reprendre seulement avec une nouvelle piste : soit un draw natif Map10 liant les DDS aux appels texture/sampler U/V, min/mag/mip, LOD bias, max mip et upload ; soit un contrôle GPU Bevy chargeant les deux PNG, capturant les descriptors et relisant des pixels. Le second qualifie le renderer actuel, pas à lui seul la fidélité 4.20. `SYS-02.4-03`, `SYS-02.4-04` et le goal parent restent ouverts.

## Reprise V1140 — pixels GPU terrain actuels

Réutiliser `docs/AUDIT_SYS01202_MAP10_BEVY_GPU_TEXTURE_SAMPLING_2026-11-03.md` et le reçu `E:/mapslol3v3/audit_map10_bevy_gpu_sampling_20261103/resultats.json` (SHA-256 `7c85614ecdba75fef2bcb9ff38ac33fd78d612310c576403a23d3940e1b40174`). Ne rejouer le compute que si PNG, décodeur, descriptor, shader, wgpu ou backend change. Pour le rendu actuel complet, ouvrir un lot raster identifié avec caméra, maillage, matériau, shader et pixels. Pour la fidélité historique, exiger un draw Map10 4.20 liant les DDS à `SetTexture`, adresse U/V, min/mag/mip, LOD bias, max mip et upload ; le probe Vulkan ne remplace pas cette preuve. `SYS-02.4-03`, `SYS-02.4-04` et le goal parent restent ouverts.

## Reprise V1141 — chaîne native texture/sampler du terrain

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_SAMPLER_2026-11-03.md` et les reçus `native_terrain_exact_path_execution.json` (`85fd491aef6fc66e1ceccede8e28a417635649f44674e905a04f33090f0366f6`), `native_terrain_sampler_setter_execution.json` (`f2dcfc154d98a390cb4f4036a3ab40269b637b5fc1d177b14a13812e0a18c924`) et `backend_flag_code_owned_state.json` (`fae9cdc8c38fec60ef1f2a4394e2d0403d3192dac609241b9b9315ca19ce7378`) sous `E:/mapslol3v3/audit_map10_native_sampler_20261103`. Ne répéter ni scan PE, ni probes backend, sauf changement du binaire, des adresses ou nouvelle contradiction. Acquis : fields `+0x24/+0x28/+0x2c` vers `s4/s8/s9`, `s8/s9=CLAMP`, et état code-owned du setter `s0..s3=WRAP`, `s4=CLAMP`. Reprendre seulement avec une nouvelle entrée : exécution provider/loader donnant les vrais handles DDS, producteur avant draw pour MAG/MIN/MIP/LODbias, lien du descripteur type 9 de `0x9BF910` au terrain, ou capture live du draw/pixels D3D9. Une mutation externe historique du flag reste hors preuve. `SYS-02.4-03`, `SYS-02.4-04` et le goal parent restent ouverts ; ne pas modifier les registres sous la restriction actuelle.

## Reprise V1142 — chaîne loader des DDS terrain

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_LOADER_2026-11-03.md` et `E:/mapslol3v3/audit_map10_native_loader_20261103/native_terrain_loader_execution.json` (SHA-256 `93bb6a09f0d1953a5ee262dcbfae3a52fc9eace1d7441921fb09bc12aef6d003`). Ne rejouer ni les trois loaders ni les lectures/SHA sans changement des DDS, du PE ou du contrat provider. Acquis : trois entrées/factory/constructeur/initialiseur originaux, champs `+0x24/+0x28/+0x2c`, neuf lectures intégrales, métadonnées et global colormap. La reprise exige une nouvelle entrée concrète : provider historique/montage, exécution `0x98A030→0x98A460` avec provider `+0x14/+0x1c/+0x28` et stream `+0x08/+0x1c/+0x24/+0x00`, puis catégorie `texture+0x94` et backend virtuel `+0x60` à `0x9BB247`. V689 qualifie la chaîne CPU inférieure sur portraits, pas ces textures. Décodage/upload D3D, draw/pixels et parent restent ouverts ; ne pas modifier les registres sous la restriction actuelle.

## Reprise V1143 — I/O et chaîne CPU des DDS terrain

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_DDS_IO_2026-11-03.md` et `E:/mapslol3v3/audit_map10_native_dds_io_20261103/native_terrain_dds_io_execution.json` (SHA-256 `0a4dc5b7d80d9147264616dab5429eb3a95078f2c7635940d5219adb1a261b5d`). Ne rejouer ni les I/O ni la chaîne CPU si le PE, les trois DDS et les contrats d'adaptateurs restent identiques. Acquis : corps originaux jusqu'à `0x9BB247`, cinq opérations I/O ordonnées, égalité tailles/SHA, arguments de création et résolution `+0x60→0x9C2D40`; l'appel backend n'a pas été exécuté. Reprendre uniquement sur une piste nouvelle : tracer la factory de `0x9C3E30` jusqu'à l'écriture de `[0x2D79078]+0x14` ou capturer cette écriture en runtime, puis qualifier `0x9C2D40`; pour les pixels, suivre `0x9BB110→0x9B6C10→0x9BB190 / D3DXLoadSurfaceFromMemory` avec un DDS Map10 identifié. Provider RADS, D3DX 2014, COM/GPU, upload/draw/pixels et parent restent ouverts. Ne pas modifier les registres, le goal, le Plan, l'application ou les bases sous la restriction actuelle.

## Reprise V1144 — publication du backend D3D9

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_PUBLICATION_2026-11-03.md`, `E:/mapslol3v3/audit_map10_native_backend_publication_20261103/native_backend_publication_static.json` (SHA-256 `a3d9e5bf4049ee2fe855f6ec4d8d09b3ae4dea3832d3674aae9e0e30f4352c02`) et `factory_execution_reuse_assessment.json` (`f84e002ad1fa4138bc4e149c50d56dc86d50ce1c15845b50f09ab3800f969a92`). Acquis : provider D3D9 dans `renderer+0x10`, passage original de `&renderer+0x14` au slot `+0x10→0x9C3E30`, et preuve V716 séparée `0x9C3E30→0x9C1430→0x9C40C8→vtable 0x10E2F30`. Ne répéter ni V714/V716 ni les scans statiques si le PE ne change pas. Reprendre seulement par un span composé minimal `0x981102` jusqu'au retour factory, vérifiant le store dans le vrai champ sous profil conditionnel clairement séparé ; le nominal exige une qualification sûre de `0x48AC16`. Ensuite seulement, qualifier `0x9C2D40` et l'upload Map10. Parent, COM/GPU, upload/draw/pixels restent ouverts ; ne pas modifier registres, goal, Plan, application ou bases.

## Reprise V1145 — publication composée conditionnelle

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_COMPOSED_2026-11-03.md`, `E:/mapslol3v3/audit_map10_native_backend_composed_20261103/native_backend_composed_execution.json` (SHA-256 `2f2f22d9cea29781165603ef9942447a857d9fcefc9feee9e53577607d0bb028`) et le garde `reuse_and_risk_guard.json` (`bcb4c296bd0491fadf67c5b44713ea9aa3f31370dffedd0c18a73e394bb9f224`). Acquis conditionnel : caller original, vrai champ `renderer+0x14`, factory/constructeur/store originaux et vtable `0x10E2F30`; appel privé non transmis, nettoyage hôte complet. Ne pas rejouer ce profil sans changement. Le nominal reste bloqué à `0x48AC16`; ne jamais transmettre une requête privée inconnue. Teardown natif et 27 allocations restent ouverts. Pour la suite terrain, partir de l'objet publié et qualifier `0x9C2D40` jusqu'à `CreateTexture`, puis l'upload `0x9BB110→0x9B6C10→0x9BB190 / D3DXLoadSurfaceFromMemory` avec un DDS Map10 identifié. Parent, upload/draw/pixels restent ouverts ; ne pas modifier registres, goal, Plan, application ou bases.

## Reprise V1146 — création backend avant upload

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_TEXTURE_CREATE_2026-11-03.md`, `E:/mapslol3v3/audit_map10_native_backend_texture_create_20261103/native_backend_texture_create_execution.json` (SHA-256 `66f6b895d80afdf75b6b945600043fc61395cf8f4f452628edddf81fe32862cd`) et l'ABI `native_backend_texture_create_abi.json` (`2b806176a43db18c5eb482280539ad0ef8b5792c9c614f41a4e2617d5dc795f3`). Acquis conditionnel : trois créations COM actuelles par les wrappers originaux, wrappers natifs dans `request+0x38`, stop sûr `0x9BB4EC`. Ne pas répéter ces créations sans changement. `texture+0x90/+0x8c` restent ouverts car leurs stores sont postérieurs à l'upload. Reprendre par petits lots : `0x9BB53D→0x9BB110`, puis `0x9BB54F→0x9B6C10`, puis `0x9BB557→0x9BB190/D3DXLoadSurfaceFromMemory` avec vrais octets/SHA; observer ensuite `0x9BB76B` et `0x98961F/0x989624`. Nominal 2014, teardown et draw/readback restent séparés. Ne pas modifier registres, goal, Plan, application ou bases.

## Reprise V1147 — upload et publication propriétaire

Réutiliser `docs/AUDIT_SYS01202_MAP10_NATIVE_TEXTURE_UPLOAD_2026-11-03.md`, `E:/mapslol3v3/audit_map10_native_texture_upload_20261103/native_texture_upload_execution.json` (SHA-256 `4ae5b0a5a2047c2278d6e1470cd6ec4282768aa5c4805053c9e593d66c119c3d`) et l'ABI `native_texture_upload_abi.json` (`8450c894b635907acac267e68c3d6fcc6ca8308ed79ff4c2008a31129f99e849`). Acquis conditionnel : trois chemins originaux `LockRect→copie CPU→UnlockRect`, payloads/readbacks SHA identiques, stores `0x9BB76B→+0x90` puis `0x989624→+0x8C`, arrêt sûr `0x98962A`. Ne pas rejouer V1143–V1147 sans changement du PE, des DDS, du runtime ou des contrats. Reprendre seulement par une piste nouvelle : petit lot post-`0x98962A` avec vrai contexte d'`AddRef`/enregistrement et retour du loader ; puis consommation des handles par slots/samplers/shaders ; enfin draw identifié, `Present` et readback de frame. Traiter séparément nominal privé `0x48AC16` et teardown natif ; ne jamais envoyer une requête privée inconnue au pilote. L'upload actuel ne prouve ni rendu ni fidélité 2014. Ne pas modifier registres, goal, Plan, interface, application ou bases.

## Reprise V1148 — enregistrement post-publication et retour complet

Réutiliser `docs/AUDIT_SYS01202_MAP10_POST_PUBLICATION_RUNTIME_2026-11-03.md`, `E:/mapslol3v3/audit_map10_post_publication_20261103/post_publication_runtime_execution.json` (SHA-256 `a2fbd67a7b9d33ad0012e698dd4574b626d9f5991379a0ceae5a11f2cbefb6fe`) et la validation `post_publication_runtime_validation.json` (`82017bdce51ea9b420e969920b2a7d41fd8839867b0da8235e2de5b526a798c3`). Acquis conditionnel : gestionnaire original construit, AddRef direct `1→2`, seconde référence d'enregistrement `2→3`, arbre et collection vérifiés, `owner+0x88`, libération temporaire, flag prêt et trois retours `AL=1/ret 0x0C`; readbacks inchangés, zéro accès invalide. Ne pas rejouer V1143–V1148 sans changement du PE, des DDS, du runtime ou des contrats. Reprendre uniquement avec une nouvelle trace consommateur : résolution du nœud/handle enregistré vers les slots texture/samplers/shaders, puis draw Map10 identifié, `Present` et readback de frame. REA peut aider à borner les fonctions, mais son pseudo-code ne remplace ni les octets ni le runtime. Garder séparés le nominal privé `0x48AC16`, le runtime historique 2014 et le teardown natif complet ; ne jamais transmettre la requête privée inconnue au pilote. Ne pas modifier registres, goal, Plan, interface, application ou bases.

## Reprise V1149 — owners DDS vers consommateur terrain

Réutiliser `docs/AUDIT_SYS01202_MAP10_REGISTERED_TEXTURE_CONSUMER_RUNTIME_2026-11-03.md`, le reçu `E:/mapslol3v3/audit_map10_registered_texture_consumer_20261103/registered_texture_consumer_runtime_execution.json` (SHA-256 `ce4bde2628c5385580f2812cb4182856bf4e581da1e758d3f9ef24e8fd547cf2`), les octets natifs (`641613397c3bb70e38d5a86136a66d8ce65951044c4beea01dae05a72489be3e`) et la validation (`65b22a9ad7055525b6d3419bd5b163dc393fd604934ea501b920bde2eb1bb2d8`). Acquis conditionnel : les owners V1148, et non `owner+0x88`, sont ABI-compatibles avec `0x983CB0`; identité source→owner→wrapper→proxy D3D9 préservée jusqu'aux `SetTexture s4/s8/s9`; `0x95A480` applique U/V `CLAMP` à `s8/s9`; zéro accès invalide, aucun draw. Ne rejouer V1143–V1149 qu'en cas de changement du PE, des trois DDS, du runtime ou d'un contrat. Prochaine reprise clôturable : identifier un caller terrain Map10 qui réutilise ces owners dans un draw borné, puis qualifier séparément shader, draw, `Present` et readback de frame. Le bind `s4` de V1149 appelle directement le consommateur avec le stage déjà qualifié par V1141 ; ne pas le présenter comme l'exécution complète de `0x95A730`. Garder séparés le runtime 2014, `0x48AC16` et le teardown natif ; ne jamais transmettre la requête privée inconnue. Ne pas modifier registres, goal, Plan, interface, application ou bases.

## Reprise V1150 — appelant terrain jusqu'à la frontière pré-draw

Réutiliser `docs/AUDIT_SYS01202_MAP10_CALLER_TO_DRAW_BOUNDARY_RUNTIME_2026-11-03.md`, `E:/mapslol3v3/audit_map10_draw_boundary_runtime_20261103/map10_draw_boundary_runtime_validation.json` et la confrontation indépendante `E:/mapslol3v3/audit_map10_v1150_evidence_audit_20261103/REVIEW_V1150_ACCEPTANCE_CONFRONTATION_V2.md`. Acquis conditionnel : chemin original `0x95AFC0 -> 0x95AD40 -> 0x95A730`, owners sources exacts seulement pour `s4/s8/s9`, arrêt à `0x95B112` avant l'appel `backend+0x20`, arguments `[0,0,0,3,0,1]`, aucun draw/HRESULT/`Present`/readback frame. Les `s0..s3`, constantes, déclaration, VB, IB, sélection shader et helper restent explicitement fixtures/adaptateurs ; ne pas les requalifier en ressources historiques. Ne rejouer ce lot que si le PE, les DDS, le runtime, les contrats ou l'une de ces hypothèses change. La reprise suivante doit d'abord identifier les ressources géométriques et shaders historiques nécessaires ; seulement ensuite exécuter séparément un draw sûr et identifié, puis `Present` et une lecture de frame. Les trois readbacks actuels sont du contenu texture, jamais des pixels rendus. Garder séparés runtime 2014, chemin pilote privé et teardown natif ; ne pas modifier registres, goal, Plan, interface, application ou bases.

## Reprise V1151 — identités géométrie/shaders et vue REA réutilisable

Réutiliser `docs/AUDIT_SYS01202_MAP10_GEOMETRY_IDENTITY_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_SHADER_IDENTITY_STATIC_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_RESOURCE_IDENTITY_REA_2026-11-03.md` et `docs/REVIEW_SYS01202_MAP10_RESOURCE_IDENTITY_REA_2026-11-03.md`. Les réponses et le snapshot sont sous `E:/mapslol3v3/audit_map10_rea_resource_identity_20261103`; ne pas réimporter le PE pour les dix mêmes requêtes. Acquis statiques : selector 0 `0x9596D0→context+0x04`, déclaration D3D9 `0x9C2880`, 107 VB/IB issus du `room.nvr`, producteurs shader `0x98C070/0x98D960`, paire `0x9AEE30`, résolution `0x9C22E0` et liaison D3D9 `0x9BEF40`. Les validateurs passent 38/38, 21/21, 16/16, 15/15, 34/34 et 11/11.

Ne pas promouvoir V1150 : ses buffers/déclaration restent fixtures, ses indices shader -1 et handles nuls sont inférés statiquement. Restent ouverts la jonction selector+VB/IB dans un même batch historique, la compilation/publication réelle des deux objets FOUR_BLEND, leur liaison, Draw/Present/pixels et l'intégration Rust. Le lot géométrie suivant peut vérifier la continuité même-run jusqu'à `0x95B112`, sans draw. Le lot shader suivant peut appeler uniquement `0x98D960/0x98C070`, capturer deux handles publiés puis nettoyer et s'arrêter avant paire/bind/draw. Le `ghidra.log` global n'a pas été archivé ; ses trois erreurs hors périmètre sont une observation de tour seulement. Ne modifier ni registres, Goal, Plan, interface, bases ni produit sous la restriction actuelle.
