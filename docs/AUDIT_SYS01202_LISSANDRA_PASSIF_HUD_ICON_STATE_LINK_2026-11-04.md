# SYS-01.2-02 — Lissandra : liaison d’Iceborn au HUD, V1239

4 novembre 2026. Unité `AUD-SYS-01.2-02-LISSANDRA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné ; implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Lissandra-PASSIF-PRESENTATION-HUD`, `OLF-62990175-c05f-5cd4-991e-a49aa264699c` : icône, texte, rang applicable et états Passive/Buff/Ready. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-33bfc5c3-b2ff-58a0-9572-10387ab74d86` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues propres conservés ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/lissandra-passive-iceborn-links-v594.json`, 1110969 octets, SHA `42346eb013b50a07b702444a4c54ae281bce98726c06b7961cd9b0085101e1de`. UTC documentaire 2026-10-26T06:45:54.901685+00:00 ; MD 06:55:02.015442+00:00. Aucune date d’exécution déduite.

V594 : 32 identités natives, 96 associations, trois tâches, 24 sites/48 liens. SOURCE actuel : 38 relations/32 identités. HUD : définition et CharScript client, sans corps serveur établi. Métadonnées/font/INIBIN/Lua/DDF/preloads D inchangés réutilisés. Copies historiques Lissandra ciblées sur E ; origines F-work/D inertes.

Définition : Passive1LuaName=LissandraPassive, icône Lissandra_Passive.dds, BaseMP="304.0" ; six niveaux passifs absents, sans remplacement. Textes personnage4222/passif2216 : prochaine capacité gratuite en Mana toutes les18 secondes ; recharge réduite d’une seconde lorsqu’une capacité de Lissandra gêne le déplacement ennemi. Contrôles issus d’objets exclus ; interaction CDR d’objet distincte. Ready2217 annonce la gratuité. Clé exacte game_buff_tooltip_LissandraPassiveBuff absente du catalogue sélectionné, fichier Buff présent : aucun alias Ready ni fichier manquant déduit. Neuf bindings BuffData, huit résolus/un absent.

Onze Lua structurés, zéro enfant : cinq initialisations littérales, six limites NEWTABLE (Ready6,Q6,W8,E16,R8,WFrozen14), sans corruption déduite. CharScript vide. Passive/PassiveBuff persistants ne définissent pas le lifecycle. Slow conserve BuffName=Slow, Chronokeeper_Timestop.dds et GLOBAL_SLOW.TROY ; RSlow DoesntTriggerSpellCasts=true/IsDamagingSpell=true/SpellDamageRatio=1.0 ne qualifie pas une réduction passive.

Huit preloads sélectionnés ; Buff référence Ready, puis Ready/Start.troy. Vingt-quatre DDF RRemoval/R/E/Q/T/W aux link/coeff vides, sans formule inventée. Seize références communautaires secondaires, CharScript vide. Cinq candidats absents bornés : CharScript sous Scripts, Passive global/preload, Q preload, T INIBIN ; emplacements réels conservés.

Inventaire avant payload : un DDS de2176 octets effectivement lu, aucun préfixe. `DATA/Characters/Lissandra/HUD/Icons2D/Lissandra_Passive.dds` : 64×64 DXT1, mip brut0, membre0.0.0.161 du projet0.0.1.7 ; SHA `345326f849972e43cf0e514175092524e5ebf6567025167ca7d9cc8fc1d2d998`. Taille/MD5/membership vérifiés. Chronokeeper et QWER restent contexte sans payload ajouté. Aucun lookup, pixel, état Ready ou rendu qualifié. Texte relié au témoin natif/mirror Ahri, font D non relu ; locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE : 6 sites/3 fichiers, lecteurs INIBIN/Lua compris. V594 : 24 sites/14 fichiers plus2 lecteurs ; union16 fichiers/30 ancres. Frontières Action/Step/Snapshot, progression, attaques/projectiles, dégâts/mitigation/régénération, boutique/Codex inspectés. CDR/slow/stun/mouvement génériques sont du contexte statique, sans événement Iceborn établi. Learn/Cast/CastAt Lissandra refusés ; absence limitée aux corps examinés.

Provider/StartupHud, barres, QWER-D/F, EzrealBuff0/BuffStack0, F3/Annie restent des acquis partiels. 4 enregistrements QWER/0 non résolus ne constituent pas le passif. Aucun payload/widget Lissandra gratuité/recharge/Ready/texte spécifique établi ; Snapshot/Effects, session et lifecycle restent contexte.

## 4. Attendu, observé et contrôles

Attendu : capacité admissible acceptée consommant un état prêt sans Mana ; contrôles admissibles réduisant sa recharge. Observé : préconditions absentes, contrôles ordinaires seulement. Sources105/105, relecture E120/120 ; consommateurs40/40, relecture E12/12. 105 entrées, 97 fenêtres, 30 ancres, 19 configurations/58 chemins matériels vérifiés. SOURCE : émissions[0,0], relecture[1,0], préflight[0,1,0] ; sélecteur Slow corrigé puis nom de sortie préflight distinct, scripts/JSON/journaux bruts archivés avant corrections. Setup inline échoué : transcription, retour individuel et stdout brut indisponibles. C : collecte/relecture/scellement réussis sans reprise. Le raccourci C «16CSvides» signifie16 références, seul CharScript établi vide. Resource INIBIN porte le SHA23f9c9… du JSON communautaire4226 octets, distinct du natif0740bff…/1232 octets. 18 captures :13 épinglées V594,5 origines F lues maintenant. Contrôles racine étendus à106 entrées C, dont une de génération.

V594 hérité : deux parties Map10 Lissandra→Annie, base/Codex3108 ; 30AP/10%CDR ordinaires, Mana max304. Six impacts physiques à distance avec projectile source/cible, non critiques ; mitigation/régénération, résidu inférieur à0,002. 102 refus (51/cas), 1082 ticks d’attente (541/cas), offsets539/540/541 après Stop. Stop n’est pas un départ prouvé de recharge ; attente autour de18 secondes non qualificative. Mana plafonné304, rangs/délais QWER nuls ; aucun sort accepté/coût payé/contrôle de capacité appliqué. Codex ne qualifie ni CDR passive ni exclusion des contrôles d’objets. Refus : flags snapshot_unchanged/assertion du driver, sans paires brutes. Frames d’attente : ticks/Mana/booléens, HP absents ; régénération attestée par le driver. Guards combat/attente : deux joueurs vivants niveau1 sans slow/stun ; trajets : santé du voyageur/winner seulement, sans garantie de niveau universelle. NPC présents. BUILD/RUN bruts0 ; inspection passée dans OBS/attestée MD, code brut non retrouvé.

Binaire historique6034432 octets, SHA `87969cf38558b5209af8283e55e6a9ad363c5b447f5f1630e9ad3ff6d1593205`, inert ; étiquette revision536_yasuo conservée, sans équivalence courante présumée. Aucun nouveau build, jeu, VM, REA, réseau, GPU, audio ou rendu ; scripts/preuves antérieurs conservés.

## 5. Écarts et inconnues

Initialisation/prêt/recharge/départ des18 secondes, consommation par capacité/réactivation, interruptions/annulations, Mana insuffisant/sous plafond restent ouverts. Événements admissibles, propriétaire/équipe/cibles, multiplicité, simultanéité, minimum et transition prête, immunités/boucliers, exclusion objets et interaction CDR restent indéterminés. Texte PassiveBuff, six limites du lecteur, rôles des trois états, lifecycle, HUD/audiences/Ready-Start, animations/VFX/audio/réseau restent ouverts. Aucun manque global d’assets déduit des sorts refusés.

## 6. Correction et reprise

Réutiliser `CH-Lissandra-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier admission/états/horloges avant tests positifs de gratuité et réduction1s. Vérifier coûts ordinaires/gratuits avec Mana insuffisant, refus sans mutation, événements propres/objets, cibles et frontières temporelles, interactions et lifecycle. Résoudre texte/métadonnées sans alias silencieux ; relier état autoritaire, texte, icône, disponibilité/audience au HUD, retirer données invalides/périmées/non autorisées. Vérifier séparément rendu/audio/réseau et acceptation humaine. Reprise sur nouvelle preuve/mapping/producteur/consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_lissandra_passive_hud_20261104`, sourceproof/current_consumer_review, manifestes/scripts/commandes/journaux/archives, result/finalpeer. Préparateur/gate V1239 dérivés f9/35efd7 pour couvrir aussi l’entrée de génération C ; originaux/diff conservés, tous inputs/archives inclus. Publication après revue : rapport, ajouts CURRENT/HANDOFF, deux sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
