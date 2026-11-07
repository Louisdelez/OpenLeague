# SYS-01.2-02 — Lee Sin : liaison de Flurry au HUD, V1237

4 novembre 2026. Unité `AUD-SYS-01.2-02-LEESIN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. Implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-LeeSin-PASSIF-PRESENTATION-HUD`, `OLF-1b04b412-cd1b-516f-b29e-a559a2c6953b` : icône,texte,rang applicable et état autoritaire de Rafale/charges/énergie. Contrat requis,a_faire,implémentation/acceptation false,dépendance NETWORK. `OLU-d554fe24-a5d7-5faf-8397-48e4f76c27ca` reste ouverte. Six contrats HUD,NETWORK,SIMULATION,SIMULATION-CONTRAT,SOURCE et ACCEPTANCE avec leurs six inconnues propres conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/leesin-passive-flurry-links-v592.json`,1048053octets,SHA9b0ab6f17faa4fdf61e555b576c682f5f352c529b02c724fc3d3c2ff401e2a15. UTC2026-10-26T06:12:42.027038+00:00 ; MD06:20:28.787740. Dates documentaires,pas de date d’exécution déduite.

V592 :25identités natives,75associations,trois tâches,20sites/40liens ;le marqueur Shen figure uniquement comme preuve contradictoire,pas comme contrat adopté LeeSin. SOURCE actuel29relations/25identités ; HUD deux liens natifs :définition INIBIN et CharScript client,métadonnée sans corps serveur. Copies historiques LeeSin ciblées sur E,origines F-work/D inertes. Métadonnées/font/INIBIN/Lua/DDF/preload inchangés non relus sur D.

Description4219 :après une capacité,les deux prochaines attaques gagnent40% de vitesse et rendent15Energy chacune. Buff Flurry1724 confirme vitesse et15énergie. LeeSin.inibin :PARType=Energy,BaseMP="200.0",BaseStaticMPRegen="10.0",icône LeeSinPassive.dds,QWER déclarés BlindMonkQOne/WOne/EOne/RKick.

Incohérences conservées :Passive1LuaName="Shen Passive Marker",fichier exact présent,texte Ki Strike2622 décrivant Shen. Passive1Desc décrit Jax,PassLev1Desc2..4 annoncentMana+40/+60/+80%,Passive1Level1..6 valent3/7/11/15/absent/absent. Aucun renommage,normalisation,substitution ou adoption comme rangs/formule de Rafale ;rôle historique inconnu.

Preload personnage :BlindMonkPassive et variante cosmétique. Deux Lua portent les mêmes littéraux :BuffName=BlindMonkFlurry,BuffTextureName=BlindMonkPassive.dds,particule blindMonk_passive_buf.troy,L_hand/R_hand. Noms d’icônes distincts ;égalité des littéraux ne qualifie ni alias,comportement serveur ni rendu.

Onze Lua entièrement parsés,aucun enfant,quatre initialisations littérales et sept limites NEWTABLE :BasicAttack0,QOne12,QTwo6,WOne8,WTwo12,EOne18,RKick18. Limites du lecteur,pas corruption. ETwo déclare TriggersSpellCasts=true/DoesntTriggerSpellCasts=false,persistance/non-dissipation,sans réactivation admissible ni proc qualifié. Un preload sélectionné ne rend pas les autres absents ;DDF16QWER sans formule Flurry,pas zéro inventé. Quatorze références communautaires secondaires,CharScript vide. Six candidats absents bornés :CharScript sous Scripts,Flurry INIBIN global/Flurry Lua,Passive INIBIN/preload/cosmetic INIBIN ;fichiers présents ailleurs reconnus.

Inventaire avant payload :deux chemins,5744octets. Deux lectures nécessaires :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/LeeSin/HUD/Icons2D/LeeSinPassive.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.188 |
| DATA/Spells/Icons2D/BlindMonkPassive.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.25 |

Un contenu SHA`596538ebe84f4fab6616aee15449b3f24a4a2ca0ef357c636d3e24e1198e1649`,tailles/MD5/membership vérifiés. LeeSinPassive et BlindMonkPassive ne sont pas aliasés par cette identité. Aucun lookup,priorité,rang/charges,pixel ou rendu qualifié. Texte relié au témoin natif/mirror Ahri,sans font D relu ;locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE6sites/3fichiers,catalogue et lecteurs INIBIN/Lua. V59220sites/10fichiers,plus2lecteurs,union12fichiers. Ressources/plafond/régénération/coûts,statistiques/cadence,attaques mêlée,dégâts,boutique,progression et refus inspectés. LeeSin Learn/Cast/CastAt non admis ;aucun producteur Flurry établi dans les corps sélectionnés,sans absence globale déduite.

Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0 et F3/Annie sont des acquis partiels. 5enregistrements QWER,0non résolus,ne constituent pas le passif. Aucun payload/widget LeeSin icône/texte/rang/charges/durée/remboursement spécifique établi. Snapshot/Effects,session,départ/lifecycle restent des contextes statiques ;aucun état d’un autre champion transféré.

## 4. Attendu, observé et contrôles

Attendu :sort admissible accepté,puis deux attaques accélérées et restitution d’énergie selon une règle qualifiée. Observé :précondition absente,sorts refusés,contrôles génériques seulement. Ce lot ne prétend donc mesurer ni déclenchement,ni charges,ni montant de remboursement passif. Sources77/77,relecture E157/157 ;consommateurs43/43,relecture E26/26. 101entrées,93fenêtres,26ancres,19configurations/55chemins matériels contrôlés ;prose dérivée des données. SOURCE :un producteur réussi sans reprise,huit commandes enveloppées code0. C :trois collectes,deux reprises statiques(chemin historique du binaire puis comparaison float32 de Dagger) ;relecture seule reprise pour casse de prose,collecte réussie non rejouée. Scripts,commandes,sorties/retours exacts archivés avant corrections ;drivers terminés puis gels distincts. Précontrôle racine :compteurs adaptés au schéma C avant exécution,originaux et diff conservés,sans retoucher S/C. Provenance héritée ambiguë :resource.source_sha256 b5f20a… identifie le JSON communautaire LeeSin malgré le libellé INIBIN ;ce hash déclaré non rehashé ne devient pas une identité native.

V592 hérité :trois parties Map10 publiques,base/Sapphire1027/Dagger1042,six attaques puis Stop et180ticks par cas. Dix-huit impacts mêlée,source LeeSin/cible Annie,windup.release au tick exact,non critiques ;mitigation physique/régénération,résidu enregistré0,tolérance0,002. Les cinq intervalles par cas sont46/46/40ticks. Dagger change la cadence ordinaire,ne démontre pas les40% natifs. Sapphire augmente la Mana déclarée sans changer le plafond Energy200.

Énergie constamment200,rangs/délais0 ;taux déclaré10/s mais aucune récupération depuis déficit ni15énergie par charge mesurée.81refus atomiques enregistrés,27par cas,joueur inconnu/soi/slot invalide/Learn-Cast-CastAtQWER avant/après. Flags snapshot_unchanged hérités ;paires before/after absentes,égalité non recalculable indépendamment.540ticks après Stop vérifient la régénération attendue. Joueurs niveau1/vivants,scoreskills/deaths0,winner/resultnull et NPC présents/vivants aux snapshots examinés ;pas absence globale de NPC ni extrapolation à tous les ticks.

BUILD/RUN historiques0,binaire6042112octets,SHA`e7fbd0c0e55e2124ffe6658ea8af6ad66d1d39801d75f44125478cc7785f72ea`,inert,sans équivalence courante présumée. Inspection initiale supposait six niveaux absents,script exact conservé ;qualifiée séparée attend3/7/11/15/None/None. Code1 initial attesté MD73–75,sans log brut retrouvé dans le dossier inspection_verified vide ;pas relecture/exécution originale prétendue. Inspection qualifiée passée dans OBS,code retour brut non retrouvé ;Rust non rejoué pour cette correction documentaire. Aucun nouveau jeu/build/VM/REA/transport réseau/GPU/audio/rendu ;anciennes preuves conservées,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Mappings Shen/Flurry/icônes/champs Jax-Mana-niveaux et consommateur historique restent ouverts. Admission Q1/Q2,W1/W2,E1/E2,R,trigger/réactivations,refresh/remplacement,durée/expiration/charges sont non qualifiés. Consommation départ/impact,annulations/échecs,cibles/simultanéité,bonusAS/plafond/interactions et remboursement sous/plafond avec coût/régénération restent ouverts. Lifecycle,HUD/audiences/effets des mains,rendu/animations/audio/réseau distincts. Aucun manque global de modèle ou texture déduit de la précondition absente.

## 6. Correction et reprise

Réutiliser `CH-LeeSin-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Résoudre les contradictions sans adopter Shen/Jax/Mana ni les niveaux bruts. Qualifier les sorts/réactivations admissibles et leur acceptation avant les tests de proc. Définir charges/durée/refresh/consommation ;vérifier deux attaques accélérées,retour normal et15énergie par attaque sous plafond/proche plafond,ordre coût/régénération et refus. Relier icône/texte/rang/charges/audience/retrait des données absentes,invalides,périmées ou non autorisées au HUD. Vérifier niveaux,cibles/annulations,frontières temps/charges,effets concurrents,lifecycle/nettoyage,rendu/audio/réseau et acceptation distincte. Reprise sur primaire,mapping,producteur,consommateur ou dérive précise ;aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_leesin_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. f9 hérité byte-exact ;rootgate dérivé804f69 pour les seuls compteurs du schéma C,originaux/diff conservés,tous inputs/archives inclus. Publication :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ;goal/Plan/UI/bases/registres/code/assets inchangés.
