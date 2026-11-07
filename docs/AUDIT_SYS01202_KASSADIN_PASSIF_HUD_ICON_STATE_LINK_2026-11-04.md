# SYS-01.2-02 — Kassadin : liaison de Void Stone au HUD, V1230

4 novembre 2026. Unité `AUD-SYS-01.2-02-KASSADIN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis publication racine. Mécanique, HUD complet et acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Kassadin-PASSIF-PRESENTATION-HUD`, `OLF-6aeb19e4-3b1e-5d97-a30f-30f87c405f9e`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-b5c306f4-c007-5652-8146-493e8f944c0b` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, CONTRAT, SOURCE, ACCEPTANCE et six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V585 UTC 2026-10-26T04:18:41.157350+00:00 ; MD UTC 04:25:41.907876. Dates documentaires, sans date d’exécution déduite.

V585 :13 identités natives/39 associations sur trois tâches. SOURCE actuel :16 relations/13 identités ; HUD :une relation définition. Captures historiques conservées exactement sur E avec provenance/empreintes ; chemins F-work inertes. Métadonnées/font/INIBIN/Lua/preloads ne sont pas relus sur D.

VoidStone, icône personnage Voidwalker_Netherburn et description liée4212 annoncent15% de réduction magique et absence de collision avec les unités ; buff2909 concordant. Empowered2910 décrit @f1@%AS, helper AttackSpeedBoost déclare VoidStoneEmpowered ; activation/paramètres restent non adoptés. NullLance2404 décrit un bouclier magique Q, distinct de la réduction multiplicative. Trois bindings directs résolus sans alias. Six rangs passifs absents ; MR30,croissance0,rayon navigation35,rayon gameplay absent, sans défaut natif inventé.

Cinq Lua entièrement parsés sans prototype enfant, cinq initialisations littérales. CharScript natif non vide :BuffTextureName=Teemo_EagleEye ; classe communautaire CS vide. Buff VoidStone/Kassadin_VoidStone,persistance/non-dissipation restent déclaratifs. Personnage/helper Empowered partagent Voidwalker_Netherburn ; Q/Averdrian_AstralBeam conserve son rôle, sans payload admis. Trois preloads déclarent helperAS,effets Q/shield/transparence/Rvanish et annulation de canalisations, sans exécution/rendu qualifiés. Quatre candidats non retrouvés dans V585 :DDF,VoidStone personnage,Empowered Lua/preload globaux ; VoidStone global et helperAS sont identifiés séparément. Neuf références communautaires restent secondaires.

Inventaire avant capture :six candidats/25344octets. Quatre chemins nécessaires :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Kassadin/Info/Voidwalker_Netherburn.dds | 4224 | 64×64, DXT5, mip brut 0 | 0.0.0.40 |
| DATA/Spells/Icons2D/Voidwalker_Netherburn.dds | 4224 | 64×64, DXT5, mip brut 0 | 0.0.0.25 |
| DATA/Spells/Icons2D/Kassadin_VoidStone.dds | 4224 | 64×64, DXT5, mip brut 1 | 0.0.0.25 |
| DATA/Spells/Icons2D/Teemo_EagleEye.dds | 4224 | 64×64, DXT5, mip brut 0 | 0.0.0.25 |

Quatre payloads sauvegardés/16896octets/trois contenus ; Voidwalker_Netherburn.dds : `99a418aa84ac35fd735124e647d1b3814fe7b2ab0a9cc93e5b4e81192d5d2107` ; Kassadin_VoidStone.dds : `217f075e1ccc85414df4427fb64edd95078a12385407eb0a4d60249aab34c43e` ; Teemo_EagleEye.dds : `5044fcd911ff0eff3383086ba8841c91d735f2ca99a4542ecda61b31dc7325f7`. Copies Voidwalker identiques ; taille/MD5/membership vérifiés. Deux homonymes Teemo_EagleEye sous Kennen/Info et Teemo/Info restent non lus ; leurs MD5 de manifeste diffèrent de Spells. Aucun lookup/priorité/alias/pixel/rendu qualifié. Averdrian reste déclaré, non lu. Localisation en_GB et témoin Ahri identifiés sur miroir F ; aucune relecture font D, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :six sites/trois fichiers. V585 :24sites/15fichiers, plus deux lecteurs. Dégâts typés, pénétration/résistance, réductions, boucliers, AnnieQ/projectiles, attaques physiques, régénération, statistiques/shop, mouvement/occupation et contexte lifecycle/départ sont inspectés.

Ordre courant :Exhaust,pénétration/résistance,courage_until0.7,boucliers ; mécanismes conservés distincts de VoidStone. Cape1033 ajoute25MR, sans multiplicateur15% déduit. Corps vivants/routage allié et résolution des mouvements expliquent le blocage ; navigation n’est pas rayon gameplay, et le fallback communautaire body_radius65/40 du chargeur reste local. Aucun producteur VoidStone identifié dans les corps inspectés, sans absence globale déduite. Refus d’apprentissage/cast Kassadin préservés.

Provider/StartupHud, barres, QWER, Buff0 Ezreal, F3/Annie et snapshot/session/horloges existent sans liaison Kassadin icône/texte/rang/état autoritaire établie. QWER :quatre icônes primaires,zéro variante/unresolved. Autres mécanismes spécifiques conservés sans transfert.

## 4. Attendu, observé et contrôles

Attendu :réduction/collision qualifiées, ressources reliées aux widgets/audiences applicables. Observé :déclarations et voies génériques réelles, liaison spécifique non établie. Sources 84/84, relecture E 92/92 ; consommateurs 74/74, relecture 10/10. Seize entrées/29 fenêtres communes,24ancres V585,six SOURCE et 8pins/23fenêtres directes vérifiés. Capture1 :trois lectures D,deux Voidwalker sauvegardés,puis refus du mip brut1 du troisième fichier. Capture2 :garde d’existence,aucune lecture D. Reprise3 :deux captures E réutilisées,deux lectures D ; total5lectures/21120octets pour4payloads. Ancien compteur imprécis archivé/corrigé. Deux journaux DDS sont des transcriptions outil UTF8LF,pas des stderr originaux ; provenance additionnelle vérifiée par la racine,non couverte par les92contrôles antérieurs. Premier producteur refusé sur deux noms preload majuscules ; attendus corrigés vers littéraux minuscules,avant second passage84/84. Scripts/journaux/contrôles échoués préservés. Collecteur unique74/74 après retrait d’une branche morte avant exécution,original archivé. Brouillon racine corrigé en préflight :citation et compteur entier,originaux archivés avant exécution. Aucun nouveau runtime.

V585 hérité :quatre simulations Kassadin/Ahri,base/Cape1033(coût500,+25MR). Huit AnnieQ magiques bruts80 et huit attaques physiques, tous avec projectiles source/cible témoins.44 refus sans mutation,360ticks de suivi,ni mort/niveau gagné/bouclier actif. Régénération après sorts/avant attaques corrigée,résidu<0,002. Observé magique :80×100/(100+MR),61,5385/51,6129 à30/55MR chez les deux champions. Comparaison0,85 :52,3077/43,8710,écarts9,2308/7,7419 illustratifs du15%,sans qualification de l’ordre historique complet. Physique conforme AD/armure. Bouclier NullLance,dégâts vrais et Empowered non exercés.

Quatre simulations d’occupation Kassadin/Garen :alliée bloque65unités,destination non atteinte ; ennemie traversée chez les deux,destination atteinte. Minima ennemis0,6738/3,0044 ; somme nav65 locale, sans rayon gameplay natif déduit. Passage générique non qualifiant pour Kassadin. Sbires,monstres,pets,murs,déplacements forcés,multicorps et lifecycle non exercés.

Binaire historique6093824octets,SHA`56706f2ff59760215179c816a06feec36419c55770f6c7023341f85060f26806`,BUILD/RUN0 hérités. Ancien CHECK initial refusé car résumé SYS omettait NullLance, puis candidat qualifié ; compteur de catalogue corrigé avant exécution. Preuves initiales conservées, sans replay. Aucun nouveau build,jeu,VM,REA,réseau,GPU,audio/rendu ; Karthus/Karma/Jinx-stockage/Jax/V564 préservés,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Ordre15%/pénétration/résistance/boucliers/autres réductions/arrondis,limites/zéro/simultanéité/sources absentes,types physique/vrai,politique des catégories d’unités/terrain,Empowered/NullLance,lifecycle/session/reconnexion/fin,rangs/lookup/casse/états/audiences et rendu restent ouverts. Quatre candidats absents gardent leur portée historique ; aucun asset3D manquant déduit.

## 6. Correction et reprise

Réutiliser `CH-Kassadin-PASSIF-PRESENTATION-HUD`,NETWORK et SOURCE/SIMULATION. Qualifier15%,ordre/types et absence de collision par catégories sans substituer MR,bouclier Q ou Empowered ; produire état autoritaire et règles effectives. Résoudre ou conserver précisément candidats/icônes/rangs non qualifiés ; relier HUD/audiences avec refus/retrait des données absentes,invalides,périmées ou non autorisées. Vérifier valeurs/limites,boucliers/effets simultanés,alliés/ennemis/champions/sbires/monstres/pets,terrain/multicorps,lifecycle/reconnexion et rendu sur binaires/ressources identifiés. Garder témoins Ahri/Garen/Cape et acceptation humaine distincts. Reprise sur primaire,mapping,producteur/consommateur ou dérive précise,sans replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_kassadin_passive_hud_20261104`,sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9/vérificateur V1226 réutilisés,toutes entrées/archives incluses. Publication :rapport+ajouts CURRENT/HANDOFF,sauvegardes exactes,sept protégés avant/après/readback.

Une clôture bornée après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
