# SYS-01.2-02 — Leona : liaison de Sunlight au HUD, V1238

4 novembre 2026. Unité `AUD-SYS-01.2-02-LEONA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné ;implémentation,vérification et acceptation humaine distinctes.

## 1. Exigence et périmètre

`CH-Leona-PASSIF-PRESENTATION-HUD`,`OLF-7cf9530d-dbd4-5e7c-a849-c63121507da4` :icône,texte,rang applicable et état autoritaire du passif permanent et de la marque cible. Contrat requis,a_faire,implémentation/acceptation false,dépendance NETWORK. `OLU-781fab8a-f274-5253-bce4-c9c7c7936f1e` reste ouverte. Six contrats HUD,NETWORK,SIMULATION,SIMULATION-CONTRAT,SOURCE et ACCEPTANCE avec leurs six inconnues propres conservés ;PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/leona-passive-sunlight-links-v593.json`,1045894octets,SHA`c2b015f7aaee292046c5d3acc792e1a22699c2913da08cb97ae6f78919391b81`. UTC2026-10-26T06:29:20.424262+00:00 ;MD06:37:00.218653+00:00. Dates documentaires,pas d’exécution déduite.

V593 :27identités natives,81associations,trois tâches,22sites/44liens. SOURCE actuel30relations/27identités. HUD un lien natif :définition INIBIN ;les Lua client sont du contexte SOURCE,sans corps serveur établi. Copies historiques Leona ciblées sur E,origines F-work/D inertes. Métadonnées/font/INIBIN/Lua/DDF/preloads inchangés non relus sur D.

Leona.inibin :Passive1LuaName=LeonaSunlightPassive,icône LeonaSunlight.dds,nom/description localisés,QWER et attaque Q renforcée déclarés. Niveaux bruts1/4/7/absent/absent/absent conservés,sans table de dégâts adoptée. Description personnage4220 :sorts infligeant des dégâts appliquent Sunlight pendant3,5secondes ;dégâts de champions alliés consomment la marque pour un supplément magique. Tooltip cible2206 distinct du passif permanent2207 ;`@f2@` demeure non résolu,sans formule moderne ou communautaire substituée.

LeonaSunlight.luaobj déclare nom/icône de marque ;LeonaSunlightPassive.luaobj déclare séparément BuffName=LeonaSunlightPassive,PersistsThroughDeath=true,NonDispellable=true. La persistance du passif permanent ne prouve pas celle de la marque. Q activation DoesntTriggerSpellCasts=false,Q renforcé=true ;preload de l’attaque référence Sunlight. Activation,attaque renforcée et attaque ordinaire restent distinctes ;ordre historique non démontré.

Neuf Lua entièrement parcourus,zéro enfant,neuf initialisations littérales ;CharScript et SolarBarrierTracker vides ne révèlent pas les callbacks serveur. Huit preloads sélectionnés et quatre bindings buff ;ShieldOfDaybreak/SolarBarrier sont du contexte de déclenchement. Particules leona_sunlight_champion.troy/leona_sunlight.troy/leonapassive_tar.troy liées,sans exécution ou rendu accepté. Quatre DDF SolarBarrier(armor/MR×0,2/deux vides),pas formule Sunlight. Treize références communautaires secondaires,CharScriptLeona.cs vide. Quatre candidats absents bornés :CharScript racine,Sunlight personnage,tracker INIBIN/preload ;CharScript sous Scripts,Sunlight global et tracker Lua présents.

Inventaire avant payload ;2chemins/4352octets effectivement lus,1contenu(s) :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Leona/Info/LeonaSunlight.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.37 |
| DATA/Spells/Icons2D/LeonaSunlight.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.37 |

Tailles/MD5/membership/SHA documentés ;identité de ressource distincte du choix de chemin et du rendu. Aucun lookup,rang,état de marque,pixel ou GPU qualifié. Texte relié au témoin natif/mirror Ahri ;pas de font D relu,locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE6sites/3fichiers et lecteurs INIBIN/Lua. V59322sites/12fichiers,plus2lecteurs,union14fichiers/28ancres. Initialisation propriétaire/allié/adversaire,frontières Action/Step/Snapshot,progression,attaques mêlée,dégâts/mitigation/régénération,boutique/Tome et Q Annie inspectés. Learn/Cast/CastAt Leona refusés ;aucun producteur Sunlight établi dans ces corps,sans absence globale déduite.

Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0,F3/Annie sont des acquis partiels. 8enregistrements QWER,0non résolus,ne constituent pas le passif. Aucun payload/widget Leona passif permanent/marque/3,5secondes/propriétaire/consommation spécifique établi. Snapshot/Effects,session et lifecycle restent des contextes statiques ;aucun état d’un autre champion transféré.

## 4. Attendu, observé et contrôles

Attendu :sort Leona admissible accepté,marque appliquée,puis événement allié admissible consommant la marque et ajoutant les dégâts qualifiés. Observé :précondition absente,sorts Leona refusés ;contrôles ordinaires seulement. Sources86/86,relecture E101/101 ;consommateurs42/42,relecture E28/28. 100entrées,95fenêtres,28ancres,20configurations/57chemins matériels contrôlés ;prose dérivée des données. Précontrôles puis collectes SOURCE/C réussis au premier essai ;11 commandes SOURCE code0. Scellement C :échec cp1252 puis correction UTF-8,script initial et reçu issu de transcription outil conservés,sans journal brut inventé. Gel initial28fichiers conservé ;gel complet31 couvre aussi le driver inutilisé et le supplément,sans recollecte. Provenance héritée :resource libellé INIBIN porte le SHA ba3a1414… du JSON communautaire Leona7763octets,distinct du natif447c1517… ;valeurs locales et identité native ne sont pas confondues.

V593 hérité :deux parties Map10,Leona/Annie alliées équipe0,Ahri adverse équipe1 ;propriétaire0/20AP avec Tome1052. Trois attaques ordinaires Leona puis trois Q Annie par cas :six impacts physiques et six magiques au total. Windup/libération/cible et projectile allié témoignent des chemins ordinaires ;mitigation/régénération isolées,tolérance0,002. Q Annie80magiques bruts/60mana/120ticks de recharge. Modifier l’AP de Leona ne modifie pas ces Q ordinaires,sans tester Sunlight. Trois Q par cas ne qualifient pas Pyromania comme passif substitué.

54refus,27par cas,et attente416ticks de recharge/360après séquence,208/180par cas. Rangs/recharges Leona nuls ;aucune marque obtenue,attente supérieure à3,5secondes non qualificative d’expiration. Refus :flags snapshot_unchanged et assertion du driver,sans paires brutes before/after. Attentes :flags only_regeneration hérités,pas recalcul indépendant de chaque tick. NPC présents18initial/80final par cas ;joueurs niveau1 aux snapshots/guards explicites,transport public borné par ses seuls contrôles. Inspection passée dans OBS ;code retour brut non retrouvé.

Binaire historique6048768octets,SHA`60a89121a40f100f33686b97b3cf4e84dff353a7c2b43a85e76f3120727593a7`,inert,sans équivalence courante présumée. Étiquette de dossier revision536_yasuo conservée sans changer l’identité Leona. Codes BUILD/RUN et statut d’inspection décrits selon les supports réellement conservés. Aucun nouveau jeu/build/VM/REA/transport réseau/GPU/audio/rendu ;anciens scripts et preuves conservés,sans nettoyage ni copie de bases.

## 5. Écarts et inconnues

`@f2@`,progression/statistique de référence,propriétaire et attribution restent ouverts. Admission Q/attaque renforcée,W/E/R,application/refresh/remplacement/cumul,multi-Leona et durée non qualifiés. Consommation par allié/Leona/attaque/sort/familier/DoT,dégâts nuls ou simultanés,cibles champions/sbires/monstres/bâtiments,boucliers/immunités/invulnérabilité,mitigation/pénétration/récursion et kills/assist restent ouverts. Lifecycle,mort/réapparition/déconnexion,HUD/audiences/particules,rendu/animations/audio/réseau distincts. Aucun manque global d’asset déduit de l’application absente.

## 6. Correction et reprise

Réutiliser `CH-Leona-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Résoudre montant/table/niveaux et attribution sans adopter les niveaux bruts ;qualifier les événements admissibles des sorts Leona avant les tests de marque. Définir état propriétaire/cible,durée3,5secondes,refresh/cumul et consommation ;vérifier application→consommation/dégâts et refus sans marque,expirée,mauvais propriétaire/équipe. Couvrir frontières temps,niveaux,cibles,interruptions/annulations,événements concurrents et lifecycle. Relier icône/texte/marque/propriétaire/durée/audience au HUD avec retrait des données absentes,invalides,périmées ou non autorisées. Vérifier séparément rendu/audio/réseau et acceptation humaine. Reprise sur nouvelle source/mapping/producteur/consommateur ou dérive précise ;aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_leona_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. f9 et35efd7 hérités byte-exacts V1237,tous inputs/archives inclus. Publication racine après revue indépendante :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ;goal/Plan/UI/bases/registres/code/assets inchangés.
