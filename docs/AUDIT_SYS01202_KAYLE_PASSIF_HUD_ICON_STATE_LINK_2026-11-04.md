# SYS-01.2-02 — Kayle : liaison de Holy Fervor au HUD, V1232

4 novembre 2026. Unité `AUD-SYS-01.2-02-KAYLE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. L’implémentation et l’acceptation restent distinctes.

## 1. Exigence et périmètre

`CH-Kayle-PASSIF-PRESENTATION-HUD`, `OLF-26d9a547-06dc-5378-b5e0-0c52c7af56b0` : icône, nom, description, rang applicable et état autoritaire. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-252986d6-5572-5e3f-95f3-7a5d648aa558` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE et leurs six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/kayle-passive-holy_fervor-links-v587.json`, 900010 octets, SHA47a42e98470c0b17f549dd4d069ee23d5742b9776bbbafc2d561beb877884d7d. UTC2026-10-26T04:48:20.090426+00:00 ; MD04:55:27.599650. Dates documentaires, sans date d’exécution déduite.

V587 :15 identités natives,45 associations,trois tâches,22 sites/44 liens. SOURCE :18 relations/15 identités ; HUD :une relation définition. Captures historiques exactes conservées sur E,chemins de travail F inertes. Métadonnées/font/INIBIN/Lua/DDF/preloads inchangés non relus sur D.

Passive1LuaName=JudicatorHolyFervor,icône Kayle_Passive.dds. Description liée4214 et buff2121 :attaque d’un champion,réduction de3% armure/RM pendant5secondes,maximal cinq cumuls. Debuff2122 signale des résistances réduites. Les textes ne tranchent pas composition,renouvellement ni ordre d’application. L’ancien Passive1Desc d’aura de vitesse d’attaque et PassLev1Desc2/3/4 de mana restent séparés ; six champs Passive1Level absents ne deviennent pas des zéros.

Cinq Lua entièrement parsés,aucun enfant ; trois initialisations littérales qualifiées,CharScript vide,buff et debuff. Deux limites d’interprétation NEWTABLE :Q pc14,E pc18 ; aucune corruption déduite. Icône du buff Judicator_DivineBlessing.dds et icône personnage/debuff Kayle_Passive.dds ont des rôles distincts ; persistance/non-dissipation déclaratives,sans callbacks serveur exécutés. Trois preloads :Q cite judicatorholyfervordebuff ; E mentionne skin07,halo et animation,sans qualification du skin de base. DDF huit lignes Q/E,aucune formule passive ; coefficients de dégâts distincts des réductions de résistances. Trois chemins candidats historiquement absents :preloads globaux HolyFervor/HolyFervorDebuff et inibin personnage du passif. Dix références communautaires secondaires,dont CharScript vide.

Inventaire exact du manifeste core0.0.1.7 avant payload :un candidat pour les deux basenames déclarés. Judicator_DivineBlessing.dds non retrouvé par basename exact dans ce manifeste ; ni alias W ni absence universelle. Une lecture documentaire :`DATA/Characters/Kayle/HUD/Icons2D/Kayle_Passive.dds`,2176octets,membre0.0.0.200,64×64,DXT1,mip brut0,SHA`0b2a8bbe23f1b65d1140269a4d02e54df38c9edd826be037637dcb1ad5212fd3`. Taille/MD5/membership vérifiés. Aucun pixel,lookup,priorité de montage,état ou rendu qualifié. Texte en_GB relié au témoin natif/mirror Ahri,locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE :6 sites/3 fichiers,catalogue et fonctions INIBIN/Lua ; frontière V58722sites/12fichiers,plus2lecteurs,union14fichiers. Statistiques,mitigation,attaques mêlée,projectiles Annie Q,régénération,pénétration,boutique,progression et refus sont inspectés. Ajustement Trundle et pénétration restent distincts de Holy Fervor. Aucun producteur spécifique identifié dans les corps inspectés,sans absence globale déduite.

Kayle Learn/Cast/CastAt et Q/E ne sont pas admis dans les cas hérités. Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0 et F3/Annie sont des acquis partiels ; aucune liaison Kayle icône/texte/rang/cumuls/durée à un état autoritaire établie. 5 enregistrements QWER,0non résolus,ne constituent pas ce passif. Snapshot/session/horloges/départ et lifecycle restent des contextes statiques.

## 4. Attendu, observé et contrôles

Attendu natif :réduction effective armure/RM sur champion puis présentation de l’état qualifié. Observé :défenses inchangées,dégâts ordinaires,refus Kayle,liaison HUD spécifique non établie. Sources58/58,relecture E84/84 ; consommateurs65/65,relecture E16/16. 112 entrées,90fenêtres,28ancres,18configurations/53chemins matériels contrôlés. Scripts,commandes et journaux binaires sont identifiés. Première agrégation SOURCE :30refus directs,quatre refus AnnieQ imbriqués omis ; originaux archivés,compteur corrigé34,sans rejeu natif. Une substitution préparatoire consommateur a produit un appel read à trois arguments :TypeError avant JSON final,puis NameError annie_rules après contrôles et avant sortie. Les deux tentatives sont archivées exactement avant correction ; chargements AnnieQ/E explicités. Trois collectes réelles[1,1,0],deux reprises,sans modification du jeu. Les chiffres de prose sont dérivés des données du lot.

V587 hérité :deux parties Map10 neuves,Kayle contre Ahri,Annie alliée témoin. Base armure20,88/RM30 ; défense35,88/55 après Cloth1029(+15,300or) et Cloak1033(+25,500or). Par cas,six attaques Kayle,Q Annie,attente jusqu’à181ticks après la sixième attaque,puis septième attaque et second Q. Tous vivants,niveau1.

14 impacts physiques mêlée Kayle,source/cible et Windup.release au tick exact,non critiques ; quatre impacts magiques Annie Q,projectiles source/cible identifiés,raw80. Mitigation ordinaire avec régénération,tolérance0,002 ; armure/RM inchangées à chaque tick. Premier Q à+14ticks ;167ticks d’attente par cas,334au total,distincts des180ticks de suivi par cas,360au total. Points+149/+150/+151/+181 ne prouvent pas l’expiration d’un debuff absent.34refus sans mutation :joueur inconnu,soi,slot invalide,Kayle Learn/Cast/CastAt,Q Annie en délai.

BUILD/RUN historiques0,binaire6059520octets,SHA`5fb07c28ffd802f24856ea915cd548535b59e8a1c480f265c50a6f7a164e8cba`. Contrôle local nominal conforme,écart au passif natif documenté. Aucun nouveau jeu/build/VM/REA/réseau/GPU/audio/rendu ; anciennes preuves/échecs conservés,sans équivalence présumée avec le binaire courant.

## 5. Écarts et inconnues

Composition/renouvellement/ordre,base/bonus,résistances nulles/négatives,cumuls par cible,plafond,attaques annulées,multi-cibles,pénétration et réductions concurrentes restent ouverts. Q/E,portée/splash/sources alliées et effets indirects ne sont pas qualifiés. Mort,réapparition,déconnexion,fin,nettoyage,réseau,audiences,compteur,durée,locale,ressource buff manquante et rendu restent ouverts. Aucun modèle/texture manquant n’est déduit de l’absence de mécanique.

## 6. Correction et reprise

Réutiliser `CH-Kayle-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Établir les règles de composition/renouvellement et paramètres ; qualifier application autoritaire par cible et déclenchements Q/E,sans importer une règle moderne. Relier ensuite icône/texte/rang/cumuls/durée/audience aux widgets ; refuser ou retirer les états absents,invalides,périmés ou non autorisés. Vérifier attaques1à6,plafond,cibles multiples/annulées,frontières temporelles,mitigations physiques/magiques,effets concurrents et lifecycle. Retrouver l’icône buff sur preuve de provenance ou conserver son indisponibilité. Reprise sur nouveau mapping,primaire,producteur,consommateur ou dérive pertinente ; aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_kayle_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/journaux/archives,result/finalpeer. Préparateur f9 et vérificateur V1226 réutilisés ; toutes entrées et archives incluses. Publication :ce rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une seule clôture d’audit borné après contrôles ; zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
