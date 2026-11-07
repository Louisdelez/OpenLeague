# SYS-01.2-02 — KogMaw : liaison d’Icathian Surprise au HUD, V1235

4 novembre 2026. Unité `AUD-SYS-01.2-02-KOGMAW-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. Implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-KogMaw-PASSIF-PRESENTATION-HUD`, `OLF-086fa13c-6f9e-5331-a0f3-2046229f2ce0` : icône, texte, rang applicable, état postmortem et durée autoritaires. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-e5478dcd-bb1d-53c0-a2d8-ce042fdcd46e` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs six inconnues propres conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/kogmaw-passive-icathian_surprise-links-v590.json`,1011796octets,SHAd8cea6207e3bd55e2fa0062e61c3a61fdd45bef47fa965fb40c275723d17e790. UTC2026-10-26T05:34:20.800351+00:00 ; MD05:41:34.647050. Dates documentaires, pas de date d’exécution déduite.

V590 :18identités natives,54associations,trois tâches,22sites/44liens. SOURCE actuel24relations/18identités ; HUD deux liens natifs conservés :définition INIBIN et CharScript client,métadonnée sans corps serveur. Captures historiques exactes sur E,origines F-work/D inertes. Métadonnées/font/INIBIN/Lua/DDF/preloads inchangés non relus sur D.

Vivant :Passive1LuaName=KogMawIcathianDisplay,icône KogMaw_IcathianSurprise.dds,six champs de niveau absents,sans zéro inventé. Description4217 :vitesse accrue après mort,explosion après4secondes,100+25×niveau en dégâts bruts. Display2186 annonce4s et @f1@ bruts ; Surprise/Sound2187/2188 sont liés.

Divergence native ouverte :Description/DynamicExtended/DynamicTooltip de Surprise lient9568/10992/11663,160+30×niveau en dégâts magiques. Rôle effectif,priorité et obsolescence non établis ; aucune formule choisie automatiquement. IsDisabledWhileDead=1,CastRadius1000,CastRange1600,Coefficient0,7 et champs projectile ne deviennent pas des règles du passif. DDF20QWER,sans Icathian :@f1@ non résolu,pas formule nulle.

KogMawDead et son Base.inibin existent ; son passif Surprise et QCausticSpittle diffèrent du vivant Display/QKogMawQ,comme ses statistiques. Aucun multiplicateur de vitesse,transition ou priorité de forme adopté. Six Lua entièrement parsés,aucun enfant,cinq initialisations littérales et une limite NEWTABLEpc26 dans Surprise ; deux CharScript vides. Limite du lecteur,pas corruption. Persistance Ready/Display et non-dissipation restent déclaratives.

Quatre preloads :Ready/Display/Surprise,kogmawdead,untargetable,unlockanimation,avertissement sonore,effets base/skin08 ; aucune exécution ou présentation qualifiée. Quatre candidats absents bornés :CharScript sous Scripts,Surprise INIBIN global,Ready INIBIN personnage,DDF de KogMawDead. Vrais fichiers présents reconnus. Dix références communautaires secondaires,CharScript vide.

Inventaire exact avant payload :deux candidats,5744octets. Deux lectures nécessaires :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/KogMaw/HUD/Icons2D/KogMaw_IcathianSurprise.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.252 |
| DATA/Characters/KogMawDead/HUD/Icons2D/KogMaw_IcathianSurprise.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.251 |

Un contenu SHA`63a73248f1697e0a755d3c11c8962c084f100884b8a7badfaca61947e78e1909`,taille/MD5/membership vérifiés. Identité vivant/mort ne qualifie ni alias,lookup,priorité,pixels ni rendu. Texte relié au témoin natif/mirror Ahri,sans font D relu ; locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE6sites/3fichiers,catalogue et lecteurs INIBIN/Lua. V59022sites/12fichiers,plus2lecteurs,union14fichiers. Dispatch interdit les commandes au champion mort ; létal applique HP0,nettoyage et échéance ordinaire,lifecycle restaure ressources/base au terme. Progression/cast vivant refusent KogMaw ; mouvement/vitesse,boutique,projectiles/crédit et régénération sont inspectés.

HUD de réapparition et sélection forme/animation sont inspectés séparément :le compte à rebours ordinaire ne démontre pas une phase passive4s. Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0/F3Annie restent des acquis partiels. 4enregistrements QWER,0non résolus,ne constituent pas la liaison KogMaw. Aucun producteur/payload/HUD spécifique postmortem établi dans les corps sélectionnés,sans absence globale déduite. Session/départ/fin et autres résurrections restent des contextes statiques.

## 4. Attendu, observé et contrôles

Attendu commun des textes :phase mobile après mort puis explosion4s,formule à résoudre. Observé :commandes mortes refusées,aucune perte de santé ennemie dans les scénarios,puis réapparition générique. Sources63/63,relecture E114/114 ; consommateurs51/51,relecture E24/24. 95entrées,102fenêtres,28ancres,20configurations/58chemins matériels contrôlés ; prose dérivée des données. SOURCE :producteurs[1,0],attendu «dead» corrigé vers l’erreur réelle «champion dead»,originaux/échec/commandes/journaux enveloppés conservés,sans changer les données ni relire D. C :première collecte51/51 et relecture24/24 conservées. Gel initial invalide :deux journaux du driver encore en écriture(0→277,607→1121octets). Ancien gel/fichiers archivés ;607octets antérieurs reconstruits avec SHA exact,explicitement distincts d’originaux retenus. Re-gel après fin réelle du driver,41/41pins relus,sans rejouer collecte/relecture. Un essai de sealer par basename refusé,script/commande/traceback transcrit conservés,chemins complets corrigés. Logs binaires et transcriptions exploratoires restent distingués.

V590 hérité :deux parties Map10 publiques,KogMaw victime/Annie attaquante,base546,16HP ou696,16 après Ruby1028(+150HP,400or).32baisses de santé,14+18,avec projectiles Annie→KogMaw ; deux morts,une première élimination400 par partie indépendante,victime niveau1. Positions atteintes espacées de100unités,contrôles publics sans injection.

Refus :15avant mort+55pendant+12après réapparition PAR CAS,soit30+110+24=164au total. Les55morts couvrent0/1/119/120/121×(quatreCast,quatreCastAt,Move/Attack/Stop). Le texte «douze» du MD est ainsi précisé parcas,pas12total. Flags snapshot_unchanged enregistrés ; paires before/after absentes,égalité non recalculable indépendamment. Frontières119/120/121 encadrent4s à30ticks/s locaux,sans qualifier l’horloge native.

480frames après mort par cas,960total :jusqu’à479,HP0,position/mana,identitékogmaw et échéance fixes ; ennemi à100unités,pleine santé,aucun dégât d’explosion observé. Cette distance n’établit pas le rayon natif. À480,retour base/HP/mana et Move fonctionne. Délai480ticks=16s ordinaire,distinct du passif4s. Snapshots locaux,pas réception réseau.

BUILD/RUN historiques0,binaire6043136octets,SHA`3b8eb3abde50f1190def29204d6bc8d734ade0ec1412d9f267c2941d06c5b73f`,sans équivalence courante présumée. Aucun nouveau jeu/build/VM/REA/transport réseau/GPU/audio/rendu ; anciens échecs conservés,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Formule/type,priorité des textes,@f1@,transition acteur/forme,vitesse/accélération,ciblabilité/invulnérabilité,collisions et permissions restent ouverts. Origine du chronomètre,rayon/bords,cibles,attribution,dégâts/boucliers,actions engagées et simultanéité ne sont pas qualifiés. Crédit/départ du respawn,résurrectionYorick,lifecycle/reconnexion/fin,HUD/countdown,rendu/skins et audio/réseau restent distincts. Aucun manque de modèle déduit du défaut de gameplay.

## 6. Correction et reprise

Réutiliser `CH-KogMaw-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Résoudre formule et transition sans adopter les champs isolés. Qualifier état temporaire,permissions/vitesse/ciblabilité,horloge4s,explosion/rayon/dégâts/attribution et articulation au crédit/respawn. Relier forme,icône,texte,rang,durée/audience au producteur ; refuser ou retirer données absentes,invalides,périmées ou non autorisées. Vérifier niveaux,causes de mort,cibles multiples,frontières temps/espace,événements engagés,résurrections et lifecycle,sans explosion double/retardée. Rendu/audio/réseau et acceptation humaine séparés. Reprise sur primaire,mapping,producteur,consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_kogmaw_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. f9 et vérificateur804f69 hérités byte-exacts de V1234,tous inputs/archives inclus. Publication :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
