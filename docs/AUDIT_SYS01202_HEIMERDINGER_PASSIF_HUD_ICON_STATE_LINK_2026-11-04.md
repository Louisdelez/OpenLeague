# SYS-01.2-02 — Heimerdinger : liaison de Repair Bots au HUD, V1221

4 novembre 2026. Unité `AUD-SYS-01.2-02-HEIMERDINGER-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Aura, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Heimerdinger-PASSIF-PRESENTATION-HUD`, `OLF-f6fbeb8b-8ff9-5e86-963f-e976365cbb09`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-66dc9221-fda2-583e-b13a-91be0062eef6` reste ouverte.

Ce lot distingue source HeimerdingerPassive, buff reçu TechmaturgicalRepairBots, régénération de base/croissance/objets, soins reçus, Garen, Tibbers et tourelles H-28G. Leur infrastructure générique ne qualifie pas l’aura.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V576 UTC2026-10-26T01:31:44.175992+00:00 ; MD01:39:12.194758, dates documentaires distinctes sans date d’exécution déduite.

Dix identités datées réutilisées sans relire métadonnées, font, Lua ou DDF D. Trente associations historiques concernent trois tâches. HUD possède deux relations natives : définition `OLS-2aab7108-d777-5bd8-a50e-242fd1909004` et CharScript `OLS-8b1e02b6-5256-5114-b62f-35e7e3917b0d`, métadonnées client sans corps serveur original.

Passive1LuaName=HeimerdingerPassive ; définition, buff source et buff reçu déclarent Heimerdinger_Passive.dds. Passive1Desc et PassLev1Desc1..4 sont null : description4200 demeure candidate, sans liaison de champ prouvée. Les niveaux recherchés non retrouvés ne fournissent ni zéro ni rang.

Deux bindings exacts : tooltip1992, champions alliés proches et tourelles H-28G, f1 en PV par cinq secondes ; tooltip2756, régénération accrue et SourceName du buff reçu. Nom4376 lié par Passive1Name ; description4200 candidate sans liaison de champ prouvée. Producteur f1, portée, auto-application, catégories et arrondis restent inconnus. HeimerdingerQ/Nano Repair Bots restent séparés, sans substitution au personnage.

Trois Lua entièrement parsés, initialisations littérales sans prototype enfant ; CharScript globals vides. Deux preloads établissent des références, pas une exécution. PersistsThroughDeath=true pour la source ; champ absent sur le destinataire, sans false ni politique de mort déduits. DDF16 entrées Q/W/E/R sans passif ni TechmaturgicalRepairBots seulement dans ce fichier ; ses coefficients ne fournissent pas f1. Huit références communautaires et CharScript vide restent secondaires.

Observations historiques capturées exactement E, origines F-work inertes. Chaînes en_GB et témoin Ahri réel vérifiés sur miroir F, sans relire font D ; locale effective ouverte. Inventaire exact avant lecture DDS :

| Chemin | Octets / format | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Heimerdinger/HUD/Icons2D/Heimerdinger_Passive.dds | 2176 / 64x64 DXT1, mip brut=0 | 0.0.0.204 |

Un chemin/contenu, SHA256 `4782fee2c565ec8a7971323d35ecd97c37e11024cbeecfa309ddc258f4ec61cd`. Taille/MD5 conformes au manifeste ; aucun OLS créé. Basename partagé ne prouve pas lookup, alias, priorité, pixels ou rendu. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE : six sites sur trois fichiers, catalogue et cinq helpers dans deux lecteurs. Rôles conservés sans promotion en HUD.

regeneration_rates calcule base/croissance avec bonus d’objets. advance_regeneration ajoute séparément Garen et applique received_multiplier avant plafonnement HPmax. Ignite/TrundleW sont des modificateurs distincts. Aucune contribution RepairBots identifiée dans les corps inspectés. La valeur par seconde locale ne fournit pas automatiquement f1 par cinq secondes.

Tibbers possède création, commandes, régénération propre et aura de dégâts ennemis ; cette voie ne devient ni H-28G ni régénération alliée. Provider/StartupHud, barres, sélecteurs QWER, Buff0 Ezreal et diagnostic F3/Annie existent sans liaison RepairBots icône/texte/rang/f1/état établie. Snapshot/projection/session/horloges génériques ne fournissent pas cette qualification ; aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : aura qualifiée, états autoritaires source/destinataire et ressources reliés aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources61/61, consommateurs58/58, contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;12 fichiers/22ancres V576 et sixSOURCE ;9 pins/20 fenêtres directes. Entrées, fenêtres et configurations vérifiées ; diagnostics historiques non rejoués. Source réussie sans correction/relance. Préflight healing48→45 corrigé avant exécution ; premier collecteur refusé sur l’attendu erroné zéro variante active non résolue, puis second réussi après correction statique. Scripts et journal échoué archivés. Précision documentaire ultérieure nom4376/description4200 sans rejouer le collecteur ;58contrôles statiques hérités, relecture E distincte conservée. Neuf icônes QWER dont quatre primaires et cinq variantes ; E/InventoryIcon2 HeimerdingerE_E2.dds non résolu dans l’import courant, sans absence passive/globale native déduite.

V576 hérité : deux cas publics Map10, Heimerdinger et Ahri alliés, Annie ennemie ; dix impacts projectiles sans critique,30refus,1200ticks de suivi et186 de déplacement. Ahri récupère1.301599979PV/s, ou1.952399969 avec1006(+50%), à250 puis1250.999634unités ; mêmes taux pendant déplacement, résidus<0.002. Ces distances ne définissent ni portée native ni aura nulle. Refus Learn/Cast/CastAt ne testent aucun déclenchement réussi.

Trois diagnostics BUILD0/RUN101 conservés : arrivée initiale, destinations projetées au même centre occupé, puis comparateur Hecarim/Ahri bloqué. La variante qualifiée teste uniquement deux cas Heimerdinger, BUILD/RUN0 historiques ; aucun correctif de navigation prétendu, V564 reste ouvert. Binaire hérité6043648octets, SHA256 `cc9ce770ae29e10c909d612489e306d65a876d1156f49e8a6317902773990e8f`. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu.

## 5. Écarts et inconnues

f1/formule/niveaux/unités/arrondis, portée, cadence, auto-application, catégories H-28G/champions, plusieurs sources/cumuls, entrée/sortie, mort/réapparition, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Régénération ordinaire, santé affichée ou référence d’icône ne remplit pas ces contrats.

## 6. Correction et reprise

Réutiliser `CH-Heimerdinger-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs et f1 ; produire aura source/destinataire, portée/catégories/cadence/cumuls et H-28G sans adopter Tibbers ; qualifier identité/session/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier distances autour d’une portée qualifiée, plusieurs sources, niveaux/objets/modificateurs, entrée/sortie, mort/reconnexion et rendu identifié. Préserver témoins génériques, échecs historiques et acceptation humaine distincte. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_heimerdinger_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Filtre du préparateur corrigé : seules les sorties courantes sont exclues, leurs copies archivées sont désormais vérifiées ; anciennes versions exactes et reçu E conservés, sans replay source/consommateur. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
