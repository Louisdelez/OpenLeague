# V1480 — Heimerdinger : contrat connu des Repair Bots

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-HEIMERDINGER-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Heimerdinger-PASSIF-SIMULATION-CONTRAT, exigence OLF-a55e0ef8-e547-55c8-a9cf-f9d25e7b4f28, parent SYS-01.2-02. Audit borné de seize branches connues :aura de régénération, destinataires et consommateurs sélectionnés. SOURCE a_qualifier,phase D06,six prérequis du lot et propriétaires d’inconnues conservés ; tâche complète,fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale2014-11-17 17:46:45 ; fuseau/déploiement inconnus,catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/heimer-passive-repair_bots-links-v576.json :822284octets, SHA256 5318db42215c8a134d319633fda3520fff6c4db013b3c3ad35fa9e229c9a2d0b, du26octobre2026. Rapport FIDELITY_HEIMERDINGER_PASSIVE_REPAIR_BOTS_LINKS_V576.md :SHA256 12b09939dbd35c26111095f8ff96774ff6452cf07457033bda5d3e37f9d3221e. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Dix identités natives aux rôles distincts,huit références communautaires séparées,deux preloads. Définition→HeimerdingerPassive→TechmaturgicalRepairBots est une chaîne déclarée de source vers buff reçu,pas une exécution serveur. Icône Heimerdinger_Passive.dds commune,identités de buffs distinctes.

Trois Lua entièrement parsés historiquement,sans prototype enfant,trois initialisations littérales et cinq globals. Le buff source déclare PersistsThroughDeath=true ; le buff reçu ne contient pas ce champ. Absence non transformée en false ou en politique de cycle de vie.

Quatre clés en_GB vérifiées :aura source1992,buff reçu2756,description4200 et nom. Texte :champions alliés proches et tourelles H-28G reçoivent une régénération bonus,f1 en PV par cinq secondes. Montant,fournisseur,niveaux,portée et cadence effective restent inconnus. L’unité d’affichage ne prouve pas des impulsions toutes les cinq secondes.

Le DDF contient16entrées actives Q/W/E/R,sans passif ni TechmaturgicalRepairBots. Il ne fournit pas f1 ; cette recherche locale ne prouve pas une absence générale. Les textes alternatifs HeimerdingerQ/Nano Repair Bots restent distincts du binding du personnage. Aucune texture,animation ou modèle manquant déduit.

## 3. Consommateurs réels

Vingt-cinq entrées concordent avec V576 :seize Rust,deux lecteurs Python,sept JSON. Avec le miroir en_GB,26identités gardées. Trente-trois fenêtres :32communes réutilisées et une sur Tibbers. Vingt-trois ancres enregistrées dont22frontières entry_boundary_only,provides_feature_consumer=false pour Repair Bots. Tous les renvois de branches aboutissent aux fenêtres contrôlées.

regeneration_rates compose base/croissance et bonus d’objets. advance_regeneration ajoute le passif Garen et applique le multiplicateur de soin reçu,puis plafonne la santé. Ignite/TrundleW sont des traitements partagés distincts :leur effet sur l’aura Heimerdinger n’est pas exercé.

annie_r crée explicitement Tibbers,gère ses ordres,sa régénération propre et une aura de dégâts magiques. Ce chemin existant n’est ni une tourelle H-28G ni une aura de réparation. Connexion,commandes,statistiques,dégâts,snapshot et réapparition sont des mécanismes génériques ; aucun producteur Repair Bots identifié dans les corps inspectés.

Recherche littérale Heimerdinger/Techmaturgical/RepairBots/H28G sur seize Rust sélectionnés :zéro occurrence,sans absence globale ou inspection des1158dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire :séparer régénération générique,objet témoin et aura native non qualifiée. Observé :59/59contrôles documentaires et83/83cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build,test Rust,jeu ou REA.

V576 hérité :deux simulations publiques Heimerdinger/Annie/Ahri,cinq attaques reçues par Ahri chacune,sans injection directe selon les preuves. Dix impacts physiques avec projectiles témoins,trente refus atomiques et1200ticks de suivi,plus186ticks de déplacement. Les phases proches/éloignées durent300ticks chacune et comportent des mesures sous le plafond de santé.

Régénération Ahri1.3015999794006348PV/s ; objet1006 +50%,soit1.9523999691009521. Ces mêmes taux expliquent les variations à250 et1250.9996337890625unités,puis pendant le déplacement ; résidu inférieur à0.002 selon V576,sans nouveau recalcul float32. Les distances ne définissent ni intérieur/extérieur ni frontière de portée native. Ces essais ne qualifient pas une aura de valeur zéro.

Les sorts Heimerdinger restent refusés dans les parcours testés. Auto-application,tourelles H-28G,multiples sources,niveaux,mort/réapparition et réseau/rendu ne sont pas exercés.

Trois anciens diagnostics BUILD0/RUN101 conservés. Premier :assertion d’arrivée ; observateur :destinations projetées sur le même centre7534.981934/6934.240234 ; variante séparée :comparateur Hecarim avec Ahri bloquée près du départ,cause exacte ouverte. Aucun sous-cas de ce processus échoué n’est présenté comme reçu réussi. Successeur qualifié :deux cas Heimerdinger seulement,BUILD/RUN0 ; comparateur Hecarim non qualifié et non remplacé.

Exécutable qualifié uniquement identifié en données :6043648octets,SHA256 cc9ce770ae29e10c909d612489e306d65a876d1156f49e8a6317902773990e8f. Aucun accès/lancement ; verrou,toolchain et1158entrées non revalidés. Défaut déplacement V564 et diagnostics non résolus conservés.

## 5. Écarts et conclusions ouvertes

Restent montant/unité/cadence f1,portée,cibles,auto-application,cumul,apparition/disparition du buff,composition avec régénération/modificateurs,niveaux,tourelles H-28G,cycle de vie,réplication et présentation.

Question OLU-72221c16-5c1f-5687-b319-7791de6008e6 et dépendances/propriétaires SOURCE conservés ; aucune inconnue fermée. Les défauts de préparation/navigation des diagnostics ne constituent pas une formule d’aura ni une réussite native.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json,préfixe COR-SYS-01.2-02-HEIMERDINGER-REPAIR-BOTS-,suffixe -01 :AMOUNT,UNIT,CADENCE,RADIUS,TARGETS,SELF,STACKING,BUFF-REMOVAL,REGEN-COMPOSITION,HEAL-MODIFIERS,H28G,LEVELS,LIFECYCLE,PROJECTION,PRESENTATION,VERIFICATION. Objectif unique,tâche liée,prérequis,travail,fin distincte et condition de reprise présents pour chacune.

Reprendre sur source nouvelle faisant autorité,fournisseur retrouvé,consommateur modifié ou cas supporté indispensable non couvert ; aucune correction fonctionnelle enregistrée/implémentée ici. Un comparateur de déplacement nécessite d’abord des arrivées publiques valides et sa propre preuve.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_heimerdinger_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2466entrées groupées préexistantes conservées. Prochain Irelia depuis122paires ;88candidats hors34unités nommées,sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète,fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent,sans revue indépendante ni acceptation humaine. Publication :rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal,Plan/UI/bases,registres,produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée,sans gain de temps mesuré.
