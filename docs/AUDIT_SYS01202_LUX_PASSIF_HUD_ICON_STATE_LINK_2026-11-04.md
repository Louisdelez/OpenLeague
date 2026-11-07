# SYS-01.2-02 — Lux : liaison d’Illumination au HUD, V1242

4 novembre 2026. Unité `AUD-SYS-01.2-02-LUX-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné ; implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Lux-PASSIF-PRESENTATION-HUD`, `OLF-cf3961dc-3ed7-5897-a75b-ea6590a2117b` : icône,texte,rang applicable,passif du porteur et marque par cible. Contrat requis,a_faire,implémentation/acceptation false,dépendance NETWORK. `OLU-5c1fce74-a76c-5437-aeeb-4eea9c29c4b2` ouverte. Six contrats HUD,NETWORK,SIMULATION,SIMULATION-CONTRAT,SOURCE et ACCEPTANCE avec leurs inconnues propres conservés ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/lux-passive-illumination-links-v597.json`,1205536 octets,SHA `1f21dc5a6d6e407b2d61fa4ee811fa31df708ed016f834d622ce940a901acc72`. UTC documentaire2026-10-26T07:35:52.290480+00:00 ; MD07:43:34.235450+00:00. Aucune date d’exécution déduite.

V597 :37 identités natives/111 associations/trois tâches/22 sites/44 liens. SOURCE actuel :40 relations/37 identités. HUD :un lien définition ; Lua clients contexte SOURCE,sans corps serveur établi. Métadonnées/font/INIBIN/Lua/preloads D inchangés réutilisés ; copies historiques Lux ciblées sur E,origines F-work/D inertes.

LuxIlluminationPassive/LuxIlluminatingFraulein.dds ; six niveaux absents sans remplacement. Textes personnage4227/passif2241 :sorts infligeant des dégâts appliquent six secondes d’Illumination ; attaques de Lux consomment la marque avec dégâts magiques. `@f1@`/`@f2@` et progression/niveau restent non résolus. Marque cible2240 distincte du passif porteur ; EEnd2239 et QMis2242 contexte,quatre bindings BuffData résolus. R Description9606/DynamicTooltip11700 déclenche puis rafraîchit selon le texte,sans ordre d’événements exécuté établi.

Quatorze Lua structurés,zéro enfant :deux initialisations littérales(CharScript vide/passif),douze limites NEWTABLE(attaques0,marque8,Q14,QDummy0,QMis10,E6,EToggle2,R6,RMis6,W2),sans corruption/callback serveur déduits. DoesntBreakShields=false/DoesntTriggerSpellCasts=true/PersistsThroughDeath=true/NonDispellable=true ne prouvent pas interactions ou persistance de marque cible.

Sept preloads :QMis/E/RMis référencent la marque ; passif/RMis luxpassive_tar.troy,contexte sans gameplay/rendu qualifié. Coefficient/Coefficient2 nuls du passif/marque ne signifient pas dégâts nuls. R principal :0,75/CD80/coût100/portée25000/rayon250 ; RMis :≈0,7/CD60/coût0/portée3500/rayon≈299,3 ; vitesse3000 commune. Champs de ressources conservés séparément,sans politique arbitrairement choisie.

Quatre clés exactes SpellData Description/DynamicTooltip du passif/marque absentes ; leurs BuffData présents,sans substitution. Lux.ddf candidat absent,aucune formule inventée. Vingt références communautaires,seul CharScript établi vide. Vingt-six NightmareBotLux exclus du standard,sans qualification de contenus. Cinq chemins candidats absents bornés ; emplacements réellement présents conservés.

Inventaire avant payload :1 chemins/2872 octets lus,1 contenu(s) :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Spells/Icons2D/LuxIlluminatingFraulein.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.25 |

Tailles/MD5/membership/SHA documentés. Un seul payload lu ; deux membres homonymes ont même taille et MD5. La priorité des namespaces reste ouverte. QWER, particules, modèles et NightmareBot non relus. Aucun lookup,pixel,marque ou rendu qualifié. Texte relié au témoin natif/mirror Ahri,font D non relu ; locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE :6 sites/3 fichiers,lecteurs INIBIN/Lua compris. V597 :22 sites/12 fichiers plus2 lecteurs ; union14 fichiers/28 ancres. Action/Step/Snapshot,progression,attaques/projectiles,dégâts/mitigation/régénération,boutique/Tome inspectés. Windup/critique/recap restent contexte ordinaire,sans application/consommation Illumination établie dans ces corps ni absence globale déduite.

Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0,F3/Annie restent des acquis partiels. 4 enregistrements QWER/0 non résolus ne constituent pas le passif. Aucun payload/widget propriétaire/cible/marque/durée/consommation/R-refresh spécifique établi ; Snapshot/Effects,session et lifecycle restent contexte.

## 4. Attendu, observé et contrôles

Attendu :sort admissible appliquant la marque,puis attaque la consommant ; R déclenchant/rafraîchissant selon contrat. Observé :tous les sorts Lux refusés,aucune marque obtenue. Attaques sans marque et180 ticks après Stop ne qualifient consommation,expiration6s ou R. Sources107/107,relecture E141/141 ; consommateurs43/43,relecture E18/18. C115 courantes/13 génération/union118 ; 99 fenêtres/28 ancres/19 configurations/59 chemins matériels vérifiés. SOURCE : 12 commandes code0, deux productions réussies ; ajout d’un input réellement consulté, première production archivée, sans échec ni rejeu D. C : génération[1,1,0], deux erreurs avant création du collecteur ; erreur d’enveloppe initiale sans octets bruts, invocation identique ensuite capturée réellement. Collecte/relecture uniques code0. 18 captures : 13 épinglées V597, cinq origines supplémentaires lues maintenant. Resource SHA15a64f13… désigne le JSON communautaire6778 octets, distinct du natif5239a91f…/2148 octets. C : dix inputs de génération déjà courants, trois du lecteur supplémentaires ; union118.

V597 hérité :deux parties Map10 Lux→Annie,base/Tome1052,+20AP ; AD53.54399871826172 inchangé. Six projectiles physiques non critiques,mitigation/régénération,résidu inférieur à0,002. Aucun supplément observé dans ces contrôles,ne déterminant pas une formule passive. 54 refus(27/cas),360 ticks d’attente(180/cas),Mana plafonné334,rangs/délais nuls. Refus : assertions/flags snapshot_unchanged sans paires brutes. Attente/intervalles : assertions de régénération sans série HP complète. Guards combat/attente : vivants niveau1 sans CC ; trajets : santé du voyageur/winner seulement. NPC présents dans snapshots, sans garantie globale par tick. BUILD/RUN bruts0 ; inspection OBS passée, code brut inconnu.

Binaire historique6039552 octets,SHA `94d0ce38507fc777d5f8526c05dc2620cbecab3c2ee96363e33c5859235a908f`,inert ; étiquette revision536_yasuo conservée,sans équivalence courante présumée. Aucun nouveau build,jeu,VM,REA,réseau,GPU,audio ou rendu ; scripts/preuves antérieurs conservés.

## 5. Écarts et inconnues

Application Q/E/R,cibles,`@f1@`/`@f2@`/niveau/AP,état propriétaire-cible,refresh/remplacement/simultanéité restent ouverts. Consommation départ/impact,annulation/projectiles en vol/Stop/cible disparue,portée/vision/collision non qualifiés. Ordre R avec/sans marque,dégâts/consommation/réapplication,versions principale/missile,réactivation/explosion E,multiples cibles,boucliers/immunités/procs/critiques/objets/récursion/attribution restent ouverts. Lifecycle,textes manquants,douze limites du lecteur,marque visuelle/HUD/icône/animation/son/réseau distincts. Aucun manque global d’assets déduit des refus.

## 6. Correction et reprise

Réutiliser `CH-Lux-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier admission/application/état et montant sans adopter zéro coefficient comme politique. Vérifier application→consommation/dégâts,frontières6s depuis vraie marque,R avec/sans marque et ordre des événements. Couvrir refus/annulations/cibles/interruptions/multiplicité et lifecycle. Résoudre texte/lecture sans alias ni NightmareBot ; relier état autoritaire,propriétaire/cible/durée/audience au HUD et retirer données invalides/périmées/non autorisées. Vérifier séparément rendu/audio/réseau et acceptation humaine. Reprise sur preuve/mapping/producteur/consommateur nouveau ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_lux_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. Préparateur57f8545c/gate19cac4e4 hérités byte-exacts V1241 ; inputs courants/génération/archives inclus. Publication après revue :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
