# SYS-01.2-02 — Lulu/Pix : liaison du passif au HUD, V1241

4 novembre 2026. Unité `AUD-SYS-01.2-02-LULU-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné ; implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Lulu-PASSIF-PRESENTATION-HUD`, `OLF-7463df07-4169-5d3b-9f65-ff928df095ff` : icône, texte, rang applicable, propriétaire/porteur et état de Pix. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-bb880733-baee-5f62-99da-260dbe1f683a` ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues propres conservés ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/lulu-passive-pix-links-v596.json`,1443220 octets, SHA `deee809f5a20da12cab7ff2221f07b207a2aa584e0f091ef6bb284a8e0e39c20`. UTC documentaire2026-10-26T07:21:13.067898+00:00 ; MD07:28:59.243744+00:00. Aucune date d’exécution déduite.

V596 :60 identités natives/180 associations/trois tâches/22 sites/44 liens. SOURCE actuel :67 relations/60 identités. HUD :un lien définition ; Lua clients contexte SOURCE, sans corps serveur établi. Métadonnées/font/INIBIN/Lua/DDF/preloads D inchangés réutilisés ; copies historiques Lulu ciblées sur E, origines F-work/D inertes.

LuluPassive/Lulu_PixFaerieCompanion.dds ; six niveaux absents sans remplacement. Textes personnage4226/passif2232 : trois projectiles magiques guidés, interceptables par d’autres unités ; total`@f1@`/`@f2@` non résolu. EShield2231 :Pix suit le protégé et aide ses attaques ; EBurn2230 :révélation de l’unité suivie aux alliés ; R2234 distinct. Quatre bindings résolus.

Vingt-neuf Lua structurés, zéro enfant :25 initialisations littérales, dont deux CharScript vides ; quatre limites NEWTABLE(FaerieBurn4,FaerieShield16,QMissile12,QMissileTwo12), sans corruption/callback serveur déduits. Treize preloads relient Passive/Run/Off,Spawn/Backup,Buddy/Robot,Override/Temp,AttackAid/Linger,Burn/Shield/contrôleurs,E/Q ; dépendances sans création ou effet joué prouvés.

LuluFaerie et son CharScript présents :description héritée Caitlyn,BaseDamage24,portée/sélection"0" ne deviennent pas formule de Pix. Missile passif vitesse900/portée25000,contrôleur1000/350,Coefficient≈1,2/coût-recharge0 restent attachés à leurs ressources. Contrôleur garde EzrealMysticShot ; missiles Q gardent EzrealEssenceFlux/EnchantedCrystalArrow et portées950/1000 distinctes. Aucun alias réécrit.

FallenAngel_DarkBinding/LuluShred,OriannaCommandRedact/LuluShield,3114_Malady/NautilusPassive,Sunfire Cape Self,Rune Prison restent des noms/contextes. Popup Snared,priorité pré-dégât,persistance/recap ne prouvent ni contrôle,lifecycle ni attribution. Quatre DDF LuluQ,dont f1→spelldamage×0,133 et trois vides,ne résolvent pas les variables passives. Vingt-et-une références communautaires,CharScript Lulu seul établi vide. Six candidats absents bornés ; emplacements présents conservés.

Inventaire avant payload : `DATA/Spells/Icons2D/Lulu_PixFaerieCompanion.dds`,5616 octets,64×64 DXT5,mip brut7,membre0.0.0.80 du projet0.0.1.7 ; SHA `3b1172b0de9052c14275f2c683b8dabcef5b0627335bd34aaf9fc31828a622c1`. Taille/MD5/membership vérifiés. Un seul payload observé ; namespaces/priorité runtime restent ouverts. Lulu_CommandPix,icônes héritées/QWER/particules/modèles non relus. Aucun lookup,pixel,modèle,attachement ou rendu qualifié. Texte relié au témoin natif/mirror Ahri,font D non relu ; locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE :6 sites/3 fichiers,lecteurs INIBIN/Lua compris. V596 :22 sites/12 fichiers plus2 lecteurs ; union14 fichiers/28 ancres. Action/Step/Snapshot,progression,attaques/projectiles,dégâts/mitigation/régénération,boutique/Tome inspectés. Windup/critique/recap restent contexte ordinaire,sans producteur Pix établi dans ces corps ni absence globale déduite.

Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0,F3/Annie sont des acquis partiels. 7 enregistrements QWER/0 non résolus ne constituent pas Pix. Aucun payload/widget propriétaire/porteur/assistance/salve/transfert spécifique établi ; Snapshot/Effects,session et lifecycle restent contexte.

## 4. Attendu, observé et contrôles

Attendu :attaque du porteur acceptée,Pix accompagnant de trois projectiles magiques selon ses règles. Observé :attaques propres de Lulu acceptées,aucun supplément magique Pix constaté dans ces cas. L’absence de sort accepté n’explique pas cette lacune sur ses attaques ; E refusé empêche séparément le transfert.

Sources101/101,relecture E125/125 ; consommateurs42/42,relecture E18/18. 108 entrées C,4 de génération identifiées,union108 ; 99 fenêtres/28 ancres/19 configurations/59 chemins matériels vérifiés. SOURCE : huit commandes enveloppées et deux scellements directs code0,sans échec ni reprise. C : inspection préparatoire[1,0](KeyError),script/journaux bruts archivés avant correction ; collecte/relecture/scellement uniques code0. 18 captures :13 épinglées V596,5 origines F lues maintenant. Resource libellé INIBIN porte le SHA2c2e49e6… du JSON communautaire6192 octets,distinct du natifa266de6d…/1880 octets. Quatre entrées de génération C déjà incluses dans108 courantes. Racine :premier assemblage arrêté sur un tag documentaire absent ; garde alignée sur les champs existants(non enregistré/runtime non qualifié),originaux préservés,sans changer SOURCE/C.

V596 hérité :deux parties Map10 Lulu→Annie,base/Tome1052,+20AP ; AD46.36800003051758 inchangé. Six impacts physiques issus de six projectiles propriétaires,non critiques,mitigation/régénération,résidu inférieur à0,002. Aucun dommage supplémentaire observé dans les contrôles conservés ; cela ne mesure pas un scaling Pix. 54 refus(27/cas),360 ticks après Stop(180/cas),sans durée native attribuée au passif. Mana plafonné292.3999938964844,rangs/délais nuls. Refus :flags snapshot_unchanged/assertion du driver,sans paires brutes. Idle et intervalles :assertions de régénération, pas de série HP complète ; absence supplémentaire bornée aux impacts,flags et snapshots conservés. Guards combat/attente :joueurs vivants niveau1 sans CC ; trajets :santé du voyageur/winner seulement. NPC présents ; aucune absence globale de familier/modèle déduite. BUILD/RUN bruts0 ; inspection passée dans OBS,code brut non retrouvé.

Binaire historique6039040 octets,SHA `27280e4fc7f54185a056dc7a2c5ad0ef7f99ea71df96c0d1ce3eefb7f6e00dff`,inert ; étiquette revision536_yasuo conservée,sans équivalence courante présumée. Aucun nouveau build,jeu,VM,REA,réseau,GPU,audio ou rendu ; scripts/preuves antérieurs conservés.

## 5. Écarts et inconnues

Création/suivi/déplacement/lifecycle de Pix,distinction propriétaire/porteur/source,`@f1@`/`@f2@`,progression/AP/partage entre bolts restent ouverts. Déclenchement/cadence,annulation/simultanéité,trajectoires/origine/guidage/interception/ordre-rayons-cibles et transfert pendant salve non qualifiés. E allié/ennemi,renouvellement/retour,Override/AttackAid/Linger/Off,origine des Q,dégâts magiques/résistances/procs/critiques/récursion,kill/assist/recap/vision restent ouverts. Modèle/animation/attachement,icônes/VFX/audio/réseau distincts. Aucun manque global d’assets déduit des résultats.

## 6. Correction et reprise

Réutiliser `CH-Lulu-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier création/porteur/déclencheur et formule sans adopter24/1,2/0,133. Vérifier trois projectiles,interceptions/dégâts/attribution sur attaques propres,puis transfert E et Q depuis Pix déplacé. Couvrir refus/annulations/cibles/frontières/simultanéité et lifecycle. Étendre le lecteur seulement pour une question précise,en conservant les originaux. Relier état autoritaire,porteur/salve/vision,texte/icône/audience au HUD ; retirer données invalides/périmées/non autorisées. Vérifier séparément rendu/audio/réseau et acceptation humaine. Reprise sur preuve/mapping/producteur/consommateur nouveau ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_lulu_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. Préparateur57f8545c/gate19cac4e4 hérités byte-exacts V1240 ; inputs courants/génération/archives inclus. Publication après revue :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
