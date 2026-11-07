# SYS-01.2-02 — textes de 33 objets et lecteurs existants, V454

Les33 fiches ITEM-*-SHOP-TEXTE du catalogue local sont reliées aux clés natives, aux traductions françaises et au lecteur de détail existant. Les objets1004,1006,3801,3114 sont aussi reliés au helper de régénération existant. Leur union est ajoutée à SYS-01.2-02. Aucun code de jeu ni nouveau CID n’est créé.

## Résultat

34 fiches et leurs instructions copiables sont mises à jour dans les deux bases réelles.37 liens objet→corps existant et2 liens à SYS sont ajoutés ;un reçu de source supplémentaire. Les2 408 consommateurs gardent leur identité et leur portée. Les anciens inputs et consommateurs restent en préfixe ;les statuts, cases, notes, flags et inconnues sont conservés.

Objets :1001,1004,1006,1011,1027,1028,1029,1031,1033,1036,1037,1038,1042,3801,1051,1018,1053,1026,1052,1058,3108,3114,3067,3101,3024,3134,3035,3135,3136,3020,2003,2004,1055. Ce sont les33 objets du catalogue local, pas tous les objets LoL4.20.

## Sources et lecteurs

Le reçu docs/reference_item_text_sources/item33-source-consumer-links-v454.json associe un sélecteur propre à chaque objet ;SYS reçoit l’union exacte /associations.

Sources :33 DATA/Items/*.inibin du client fourni4.20, clés DisplayName/Description et traductions natives fontconfig_fr_FR. La provenance RADS est héritée du reçu item-shop et n’est pas présentée comme une nouvelle traversée des manifestes. La référence générale EUW/en_GB4.20.0.315 demeure distincte de ces textes FR.

Donnée réellement consommée :data/4.20/shop_foundation.json chargée par shop.rs. Ce chemin ne lit pas les clés INIBIN ni ne valide source_sha256 à l’exécution.

Lecteur OLC-aac58deb-7844-52e0-833d-634ad3c7bf3c :shop_ui.rs425–428, description de l’objet inspecté, remplacement du placeholder et notice Map10. Helper OLC-25f0f6cd-ce29-5893-8ee7-36bfd81febbd :shop.rs174–192, seulement pour quatre objets à placeholder. Il utilise croissance, niveau et bonus locaux ;HP a priorité,sinon MP dépend de uses_mana. Absence de joueur/helper donne la valeur de remplacement0. L’équivalence avec les statistiques serveur et le calculateur natif n’est pas établie.

Les identités E et F restent séparées, même à octets égaux. Aucun ancien record n’est réaffecté.

## Vérifications et incident conservé

La comparaison native antérieure a réellement terminé code0/758de9 :33 noms et33 descriptions FR uniques correspondent au catalogue. Les descriptions sont égales à la comparaison explicite calc→{regen_5s},br→saut de ligne,autres balises retirées. Cette preuve et les refus du décodeur restent datés ;ils ne sont pas relabellisés tests V454.

V454 a vérifié53 identités physiques, six fenêtres de corps, les33 associations et leurs prérequis de phase/lot.34 sélecteurs nominaux acceptés,5 sélecteurs étrangers/non canoniques refusés. La préparation a terminé code0/9eed90.

L’enregistrement a terminé **code1/b8822f**, après les remplacements de registres et commits des deux bases :son contrôle final accédait directement à un champ selector absent de certaines références historiques. L’échec et le script original sont conservés. Aucun rejeu du registrar ni rollback automatique n’a été effectué.

La récupération séparée corrige uniquement cet accès optionnel dans le vérificateur. Elle compare la totalité du delta aux sauvegardes et relit les vrais Store.task,Store.copy_text,requirement_trace.resolve et make_instruction des deux bases. Elle a terminé code0 ;son observation exacte est dans ROOT_COMMAND_OBSERVATIONS.json. Aucune écriture DB ou registre n’a été effectuée par la récupération ;la preuve manquante a été créée seulement après réussite des vérifications.

Attendu :seules34 fiches et leurs liens changent. Observé :les trois registres sont strictement égaux à la reconstruction depuis sauvegardes ;42 180 autres exigences actives identiques ;anciens sources/consommateurs intacts ;registre des inconnues identique en octets.

Dans chaque base :34 fiches relues,42 606 états/notes et23 historiques exacts,42 572 autres lignes de catalogue identiques,intégrité ok. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et base desktop désignée par C:/Users/loicd/AppData/Local/OpenLeague Plan/connection.json. Vérifications en mode=ro/query_only.

Les sauvegardes précèdent trois remplacements JSON puis deux transactions SQLite. Pas d’atomicité globale revendiquée. Le compteur source_hashes_verified=0 décrit la validation structurelle et reste distinct des53 identités ciblées. Une erreur de citation du premier générateur documentaire a aussi été conservée (code1/bb0493,avant écriture) ;aucun faux succès n’en est déduit.

## Limites

30 hashes déclarés concordent. Pour1018,1051,1053,source_sha256 est absent ;aucun hash déclaré contradictoire. Les trois comparaisons false initiales sont conservées et interprétées comme absences, sans les convertir en correspondances.

1038 et1058 sont refusés par la sélection normale d’achat Map10. Le lecteur générique reste conditionnel à un identifiant inspecté résolu ;aucune acquisition ou sélection effective n’est affirmée. Les langues FR et en_GB restent distinctes.

Les textes et expressions calc ne prouvent pas rendu complet, statistiques serveur, conditions, charges ou cooldowns. Les producteurs retrouvés sont des corps statiques ;leur présence ne prouve pas la dernière exécution historique. Aucun producteur, test Rust, jeu original, VM, AIR ou GPU n’est exécuté par ce lot.

## Livrables et suite

Trois registres et34 lignes tasks par base modifiés ;reçu,preuve JSON et ce rapport ajoutés. Couverture,plan,reprise et notes courtes actualisés,anciennes versions brutes sauvegardées. Aucun code ou donnée du jeu modifié.

Preuves :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision454/ROOT_COMMAND_OBSERVATIONS.json,ACTUAL_FAILURE.json,RECOVERY_DELIVERY_AUDIT.json,ROOT_EXECUTION_RECEIPT.json. Team445 et Solo444/446 conservés ;revue447 et Tutorial450/451 restent ouverts. Le lot ITEM repose sur ses propres sources et ne dépend pas de cette revue Team.

SYS-01.2-02 et le goal restent ouverts. Aucune case, tâche, champion ou jeu complet n’est déclaré terminé par ce lot.
