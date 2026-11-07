# SYS-01.2-02 — Lucian : liaison de Lightslinger au HUD, V1240

4 novembre 2026. Unité `AUD-SYS-01.2-02-LUCIAN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné ; implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Lucian-PASSIF-PRESENTATION-HUD`, `OLF-42a45111-17e4-517c-9087-b37857f00225` : icône, texte, rang applicable, armement et consommation du double tir. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-cb333c27-9cae-5183-b90a-7a8ef4120373` ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues propres conservés ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/lucian-passive-lightslinger-links-v595.json`, 1155725 octets, SHA `80bbe5244aff041208f64f89373332f4878c70a079fc3e196c3e46fb8106bad2`. UTC documentaire 2026-10-26T07:01:32.818657+00:00 ; MD07:12:31.019915+00:00. Aucune date d’exécution déduite.

V595 : 35 identités natives, 105 associations, trois tâches, 22 sites/44 liens. SOURCE actuel : 41 relations/35 identités. HUD : définition et CharScript client, sans corps serveur établi. Métadonnées/font/INIBIN/Lua/DDF/preloads D inchangés réutilisés ; copies historiques Lucian ciblées sur E, origines F-work/D inertes.

Définition : LucianPassive/Lucian_Passive.dds ; six niveaux passifs absents sans remplacement. Textes personnage4225/passif2223/armé2224 : après lancement terminé, prochaine attaque en double tir dans six secondes. Second tir : `@f1@` non résolu contre champions/structures, dégâts complets sur sbires/monstres, effets à l’impact. Qbuff2225 répète le passif, sans devenir formule du Q. Clé exacte game_buff_tooltip_LucianE absente ; cinq bindings, quatre résolus/un absent, sans substitution.

Treize Lua structurés, zéro enfant : quatre initialisations littérales, neuf limites NEWTABLE (PassiveAttack8,Shot8,Dummy0,Q4,W8,R10,BasicAttack0,BasicAttack2:0,CritAttack0), sans corruption déduite. Passive déclare25.dds/persistance/non-dissipation ; PassiveBuff déclareLucian_Passive.dds/IsDamagingSpell=false/IsDeathRecapSource=true ; E déclareDraven_Bloodrage.dds/recap. Noms et rôles conservés, sans alias ni attribution du second tir démontrés.

Coefficient Shot/ShotDummy voisin de1,2 : ni formule complète ni résolution de`@f1@`. Six preloads : Buff lie lucian_p_buf.troy/lucian_p_sound_only.troy ; Shot référence rageblade/itemhurricaneattack sans exécution/multiplicité prouvée. Quatre-vingt-quatre DDF, noms anciens/tests conservés, sans LucianPassive ni formule passive déduite. Dix-neuf références communautaires secondaires, seul CharScript explicitement vide. Sept candidats absents bornés : CharScript sous Scripts, Passive global, preloads Passive/Attack/Dummy/Q, CritAttack2 Lua ; emplacements réels identifiés.

Inventaire avant payload : 2 chemins/4352 octets effectivement lus, 2 contenu(s) :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Lucian/HUD/Icons2D/Lucian_Passive.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.172 |
| DATA/Spells/Icons2D/25.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.25 |

Tailles/MD5/membership/SHA documentés ; identité distincte du choix runtime d’icône. Deux contenus distincts ;25.dds reste un candidat global dont la résolution du nom BuffTextureName à l’exécution est ouverte. Draven/E/QWER/particules non relus. Aucun lookup, pixel, charge, animation ou GPU qualifié. Texte relié au témoin natif/mirror Ahri, font D non relu ; locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE : 6 sites/3 fichiers, lecteurs INIBIN/Lua compris. V595 : 22 sites/12 fichiers plus2 lecteurs ; union14 fichiers/28 ancres. Frontières Action/Step/Snapshot, progression, attaques/projectiles, dégâts/mitigation/régénération, boutique/Sword inspectés. Windup/critique/récapitulatif sont du contexte ordinaire, sans second tir établi. Learn/Cast/CastAt Lucian refusés ; absence limitée aux corps examinés.

Provider/StartupHud, barres, QWER-D/F, EzrealBuff0/BuffStack0, F3/Annie restent des acquis partiels. 4 enregistrements QWER/0 non résolus ne constituent pas le passif. Aucun payload/widget Lucian armement/charge/durée/double tir spécifique établi ; Snapshot/Effects, session et lifecycle restent contexte.

## 4. Attendu, observé et contrôles

Attendu : sort admissible terminé, état armé puis deux tirs selon fenêtre/cibles/effets qualifiés. Observé : précondition absente, contrôles ordinaires seulement. Sources102/102, relecture E133/133 ; consommateurs41/41, relecture E17/17. 106 entrées courantes C, 4 entrées de génération identifiées ; union dédupliquée 106. 99 fenêtres, 28 ancres, 19 configurations/59 chemins matériels vérifiés. SOURCE : deux échecs d’inventaire par namespace avant accès D, archivés ; producteur/relecture uniques code0. C : première collecte arrêtée avant sortie, contrôle supposant BaseMP texte ; valeur native flottante conservée, puis collecte/relecture/scellement code0. Scripts, commandes et sorties brutes archivés avant corrections. 17 captures :13 épinglées V595,4 reçus d’origines F lus maintenant. Resource libellé INIBIN porte le SHAdeb86f29… du JSON communautaire5404 octets, distinct du natifd5e40bcc…/1877 octets. Quatre entrées de génération C sont déjà incluses dans les106 courantes.

V595 hérité : deux parties Map10 Lucian→Annie, base/LongSword1036. Six projectiles physiques non critiques ; AD52.040000915527344→62.040000915527344, mitigation/régénération, résidu inférieur à0,002. Le +10AD ne démontre aucun facteur passif. 102 refus (51/cas), 362 ticks d’attente (181/cas), offsets179/180/181 après Stop. Stop n’est pas un lancement terminé ; six secondes d’attente ne qualifient aucune expiration de charge. Mana au plafond298.8800048828125, rangs/délais nuls ; aucun sort accepté, charge armée ou second tir. Annie ne couvre pas les classes sbires/monstres/structures. Refus : flags snapshot_unchanged/assertion du driver, sans paires brutes. Idle : Mana/offset/only_regeneration, HP numériques aux bornes et snapshots seulement ; régénération intermédiaire attestée par le driver. Guards combat/attente : deux joueurs vivants niveau1 sans CC ; trajets : santé du voyageur/winner seulement. NPC présents. BUILD/RUN bruts0 ; inspection passée dans OBS, code brut non retrouvé.

Binaire historique6034944 octets, SHA `14379fe38a5e149d16823afe2b28a7afd5682c7df2b22e62449e7aad44d1ebc6`, inert ; étiquette revision536_yasuo conservée, sans équivalence courante présumée. Aucun nouveau build, jeu, VM, REA, réseau, GPU, audio ou rendu ; preuves/scripts antérieurs conservés.

## 5. Écarts et inconnues

Déclenchement à fin Q/W/E/R/réactivations, interruptions, refresh/remplacement et`@f1@` restent ouverts. Premier/second tir : délai, consommation, annulation/déplacement/Stop/changement ou disparition de cible, portée/vision/collision/esquive/immunités/boucliers non qualifiés. Critiques partagés/indépendants, mitigation/pénétration/vol de vie/onhit, Rageblade/Hurricane/récursion, attribution kill/assist/recap restent ouverts. Fenêtre6s depuis vrai trigger, simultanéité, lifecycle, texte E, limites du lecteur, HUD/audiences/deux mains/particules/son/réseau distincts. Aucun manque global d’assets déduit des refus.

## 6. Correction et reprise

Réutiliser `CH-Lucian-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier admission/fin de lancement/armement avant tests de double tir. Résoudre facteur/classes/progression sans adopter1,2 ; vérifier deux tirs, frontières6s, refus/interruptions/cibles, événements concurrents et lifecycle. Tester critiques/onhit/attribution sur leurs contrats propres. Résoudre texte et mappings sans alias ; relier état autoritaire, charge/durée, icône/texte/audience au HUD et retirer données invalides/périmées/non autorisées. Vérifier séparément rendu/audio/réseau et acceptation humaine. Reprise sur preuve/mapping/producteur/consommateur nouveau ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_lucian_passive_hud_20261104`, sourceproof/current_consumer_review, manifestes/scripts/commandes/journaux/archives, result/finalpeer. Préparateur57f8545c/gate19cac4e4 hérités byte-exacts V1239 ; inputs courants/génération/archives inclus. Publication après revue : rapport, ajouts CURRENT/HANDOFF, deux sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
