# SYS-01.2-02 — Khazix : liaison d’Unseen Threat au HUD, V1234

4 novembre 2026. Unité `AUD-SYS-01.2-02-KHAZIX-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. Implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Khazix-PASSIF-PRESENTATION-HUD`, `OLF-799298c2-faf5-56cb-9fed-3708ae4a6a86` : icône, texte, rang applicable et état autoritaire. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-d818e7d3-8189-5707-b1a4-f56187f2a2bd` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/khazix-passive-unseen_threat-links-v589.json`,1352627octets,SHA1b039a0cf78f903a873c163203c16a332a222245147430c69c8877c0343b6f3c. UTC2026-10-26T05:18:05.035293+00:00 ; MD05:24:56.481828. Dates documentaires,sans date d’exécution déduite.

V589 :29identités natives,87associations,trois tâches,29sites/58liens. SOURCE actuel35relations/29identités. HUD a deux liens natifs conservés :Khazix.inibin et CharScript client,métadonnée sans corps serveur. Captures historiques exactes sur E,chemins de travail F inertes. Le composant SOURCE réutilise métadonnées/font/INIBIN/Lua/DDF/preloads sans les relire sur D ; lectures additionnelles du peer distinguées ci-dessous.

Vrais emplacements :CharScript à la racine Characters/Khazix,sorts sous Spells. Passive1LuaName=KhazixPassive,icône Khazix_P.dds,ExtraSpell4=KhazixPAttack. Description liée4216 :hors vision ennemie,prochaine attaque de base sur champion avec dégâts magiques et ralentissement. Buff2174 précise deux secondes de ralentissement,avec @f1@/@f2@/@f3@ non résolus ; PDamage2175 décrit l’attaque préparée. Champs Passive1Level et ancien Passive1Desc absents restent absents.

DDF40 :quatre lignes PDamage aux link/coeff vides,donc aucune formule zéro déduite. Effect1..4=3/35/4/3 ne sont pas mappés aux paramètres du passif. Trois clés SpellData non retrouvées dans le font sélectionné :game_spell_tooltip_KhazixPassive,game_spell_description_KhazixPassive,game_spell_description_GreenTerrorBasicAttack ; BuffData présent distinct,sans alias automatique.

Onze Lua entièrement parsés,aucun enfant,deux initialisations vides(CharScript/RInternalCD) et neuf limites NEWTABLE :Passive/PDamage pc16,PSlow14,R/REvo18,RStealth6,attaques0. Limites du lecteur,pas corruption ni callbacks exécutés. Cinq buffs,six preloads,quinze références communautaires secondaires dont CharScript vide. Six candidats absents :deux CharScript sous Scripts,deux Passive globaux,PSlow.inibin et PAttack.luaobj ; vrais fichiers présents reconnus. IsolationQ,chasseRengar,R/furtivité/délai interne restent distincts ; noms et dépendances ne prouvent pas de règle d’armement.

Inventaire avant payload :un candidat exact. SOURCE lit uniquement `DATA/Characters/Khazix/HUD/Icons2D/Khazix_P.dds`,2872octets,64×64,DXT1,mip brut7,membre0.0.0.126 du core0.0.1.7,SHA`113b387657eee8c4584f7f2989e0fc2a2418dfd6370850025caf6e4f2d17e675`. Taille/MD5/membership vérifiés,pas pixels,lookup,priorité ou rendu. Localisation reliée au témoin natif/mirror Ahri,sans font D relu ; locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE6sites/3fichiers,catalogue et lecteurs INIBIN/Lua. V58929sites/14fichiers,plus2lecteurs,union16fichiers. Vision partagée/portée/ligne de vue,projection snapshot_for,dégâts,attaques mêlée,ralentissements/vitesse,régénération,boutique,progression et refus inspectés. Aucun producteur spécifique établi dans les corps sélectionnés,sans absence globale déduite.

Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0 et F3/Annie restent des acquis partiels ; aucune liaison Khazix icône/texte/rang/disponibilité/consommation autoritaire établie. 8enregistrements QWER,0non résolus,ne constituent pas ce passif. Khazix Learn/Cast/CastAt refusés ; lifecycle/session/horloges restent des contextes statiques.

## 4. Attendu, observé et contrôles

Attendu :vision et formule historiques qualifiées,armement/attaque magique/ralentissement autoritaires,puis HUD. Observé :vision locale cohérente mais fidélité4.20 ouverte,attaques physiques ordinaires sans supplément ni ralentissement,liaison spécifique non établie. Sources64/64,relecture E105/105 ; consommateurs47/47,relecture E22/22. 92entrées,93fenêtres,35ancres,18configurations/54chemins matériels contrôlés. Prose dérivée des données. SOURCE :deux producteurs[1,0],attendu DDF corrigé du booléen présumé vers la liste réelle de quatre formules vides,originaux/échec/journaux binaires enveloppés conservés. C :une collecte,sans reprise,préparations et erreur d’affichage cp1252 conservées comme transcriptions distinctes. Le peer a relu deux identités natives D(2009+56=2065octets) malgré la consigne de réutilisation,plus six exists sans payload ;aucune répétition. Avec le DDS SOURCE,total trois payloads4937octets. Ce décompte distingue composants et lot,sans prétendre D=0.

V589 hérité :deux parties Map10 publiques,base/+20AP après Tome1052. Par cas30ticks immobiles hors vision,déplacement en ligne de vue dégagée,deux attaques,retrait par distance,90ticks cachés,retour visible,deux attaques,180ticks finaux. Total240ticks cachés immobiles et360finaux visibles,distincts des trajets/attaques. Visibilité ennemie et présence dans snapshot_for concordent dans les frames enregistrées ; projection propre conservée. Cela n’est ni furtivitéR,ni vision native qualifiée,ni réception réseau.

Huit impacts mêlée non critiques,windup source/cible et release au tick exact,dégâts physiques ordinaires avec régénération,tolérance0,002. Aucun dégât magique supplémentaire,entrée slow ou changement de vitesse cible. Quatre champions vivants,niveau1,rangs/délais Khazix nuls.32refus sans mutation selon comparaisons enregistrées,notamment attaque adverse sur Khazix caché ; snapshots avant/après non embarqués,égalité non recalculable indépendamment. R/évolutions non exécutés. Écart au texte observé avec la vision actuelle,sans montant natif de dégâts/slow qualifié.

BUILD/RUN historiques0,binaire6120960octets,SHA`13e1b546ed5a5b4defae0fef81f979a9a6a6fe09d612a86bcddf879e938e7f64`,sans équivalence courante présumée. Aucun nouveau jeu/build/VM/REA/transport réseau/GPU/audio/rendu ; anciens échecs conservés,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

f1/f2/f3,niveaux/coefficient/slow,mapping des clés et valeurs restent ouverts. Vision partagée,rayons,obstacles/buissons/révélations,tours,sbires/pets,équipes/spectateurs et furtivité ne sont pas qualifiés historiquement. Armement/maintien/consommation/réarmement,annulations,cibles nonchampions,simultanéité,ordre physique/magique/slow,immunités,boucliers,lifecycle,Hud/audiences et rendu restent ouverts. Aucun asset présent déclaré manquant.

## 6. Correction et reprise

Réutiliser `CH-Khazix-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Identifier formules et vision4.20 sans adopter les chiffres isolés. Qualifier armement,maintien en vue,consommation sur champion et réarmement avec cibles/annulations ; séparer R/évolutions/charges/délai interne/isolationQ. Relier disponibilité,icône,texte,rang,audience et retrait des états absents,invalides,périmés ou non autorisés au HUD. Vérifier dégâts/ralentissement2s/effets concurrents,lifecycle/réseau/rendu et acceptation humaine distincte. Reprise sur primaire,mapping,producteur,consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_khazix_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. Préparateur f9 byte-identique,vérificateur V1226 adapté uniquement aux deux noms de champs C constatés (readback passed,all_explicit_config_names),sans affaiblir les contrôles ; copies/diff conservés,toutes entrées et archives incluses. Publication :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
