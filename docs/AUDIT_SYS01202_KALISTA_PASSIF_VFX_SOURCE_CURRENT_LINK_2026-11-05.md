# Kalista — liaison bornée de Martial Poise aux consommateurs visuels

## 1. Exigence et portée

2026-11-05, V1356 ; `AUD-SYS-01.2-02-KALISTA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; SYS-01.2-02 ; `CH-Kalista-PASSIF-PRESENTATION-VFX` ; `OLF-99cfacce-fc6a-5aa4-94d2-d9e13b5bce8f`. Relier déclarations, événements et consommateurs nécessaires. Audit terminé pour cette liaison bornée ; tâche complète, inventaire, fonctionnalité et acceptation ouverts.

Implémentation partielle : verrou d’annulation conservé, ordre différé et bond non établis dans les corps inspectés. Vérification documentaire réussie ; diagnostics historiques non rejoués. Acceptation humaine non donnée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/kalista-passive-martial_poise-links-v663.json`,4917535octets, SHA256 `04c682946b734f5447451199cb88d51b6d7fffa2389deaf422ea54eab61a6572`, copie E externe. Date documentaire2026-10-27T05:52:35.261747+00:00, sans date d’exécution déduite. LoL4.20.0.315/EUW/en_GB hérité, catalogue4.20.1 distinct.25 ressources sélectionnées/75 associations sur trois tâches. Aucun accès D, chemins natifs inertes.

Le contexte114Lua est conservé :90 initialisations reconnues,24 limites. Onze vues pertinentes sont réutilisées,10 initialisations/31 affectations ;MysticShot NEWTABLEpc8 est une limite,non corruption. Aucun AutoBuff dans ces onze vues ne prouve une absence globale. Cinq identités de preloads conservées,corps non rouverts ;216 candidats apparentés restent contextuels,non promus en ressources passives acceptées.

KalistaPassiveBuff déclare icône/nom/persistence. Commander/TalentReaper,Shen Shadow Dash,RumbleDangerZone restent littéraux,sans import de formule ou effet étranger. Huit lignes DDF vides ne donnent pas la trajectoire. C# communautaire non vide avec speculative/TODO reste une référence secondaire,non callback serveur ou code Rust qualifié.

Nom4385 et buff2132 liés. Texte : attaque non annulable,échec hors vision,Move pendant préparation d’attaque/Pierce,bond au lancement,paliers de bottes,arrière+25%. Distances/vitesses exactes ouvertes. Description4209 présente mais non liée par PassLev1Desc1 absent ;Passive1/Desc/rangs absents non valeurs par défaut. CardMasterBasicAttack absent,ShenShadowDash11842 présent mais étranger,non adopté.

DDS héritée Kalista_Passive :2176octets,64×64,DXT1,mipbrut0,membre0.0.1.7,SHA `db6ca23da81f605537944ac65f62feae13369e4c9b0aa305bd1eb43482fb1ea0`. Identité/en-tête hérités,sans nouvelle lecture DDS ou pixels/provider qualifiés. Provenance source_sha256 embarquée de champion_resources distincte de l’INIBIN sélectionné,non corruption déduite.

## 3. Consommateurs réels

Dix-sept Rust et un JSON complets,37 ancres fraîches : `lib.rs:149` ; `lib.rs:533` ; `lib.rs:598` ; `lib.rs:685` ; `lib.rs:744` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `progression.rs:131` ; `spells.rs:101` ; `annie_w.rs:29` ; `damage.rs:53` ; `damage.rs:38` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:10` ; `regeneration.rs:32` ; `world.rs:226` ; `world.rs:244` ; `attacks.rs:17` ; `attacks.rs:29` ; `attacks.rs:129` ; `attacks.rs:141` ; `movement.rs:53` ; `shop.rs:261` ; `vision.rs:79` ; `lib.rs:624` ; `lib.rs:668` ; `attacks.rs:131` ; `attacks.rs:304` ; `attacks.rs:303` ; `attacks.rs:326` ; `attack_presentation.rs:40` ; `attack_animation.rs:210` ; `attack_animation.rs:229` ; `animation.rs:542` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, sauf projected_live,attack_animation,animation dans client/src ;profil dans data/4.20/attack_contracts.json. Profil Kalista actuel identique au V663 : période1.5197600126s,préparation0.5500000119s,ratio0.5,missile2600,cant_cancel=true. Champ natif CantCancelWhileWindingUp brut1/hash3109850202 hérité. Attacks charge le profil,fixe cancelable=!cant_cancel,puis cancel_windup refuse l’annulation.

Move appelle cette garde avant p.destination=Some(point). Ce refus ne mémorise donc pas un ordre de bond dans ce chemin. Stop garde le verrou ;le raccourci d’ordre répété ne crée pas un nouvel ordre. Acquis préservé,non assimilé au passif complet. Vision générique avant lancement et projectile ordinaire restent distincts de la politique native complète.

Kind contient Basic,Critical,GarenQ,TrundleQ ;le consommateur client sélectionne attack/crit pour les deux premiers. Ce pont ordinaire ne qualifie ni trajectoire ni clip de bond. Projection Annie distincte. Recherche Kalista/MartialPoise sur17Rust : zéro hit,sans absence de mécanisme générique déduite. Profil JSON traité séparément.22 comparaisons V663 et34 contextuelles concordent ;16 communs sous-ensemble,14 mécanismes VFX et2 animations ordinaires réutilisés.32 ancres SOURCE/jeu antérieures conservées avec leurs identités,sans exécution de lecteurs natifs.

## 4. Attendu, observé et contrôles

Attendu : conserver cant_cancel et distinguer capture d’ordre,bond et rendu. Observé :93/93 contrôles documentaires,103/103 de cohérence séparée du même agent. V1311 unifié69/69 documentaire,63/63 cohérence et7/7 intégration hérités,non rejoués. Le schéma unifié est référencé par empreinte,sans faux composants source/current ni copie intégrale supplémentaire. Pas de décodeur indépendant.

V663 hérité :huit cas Kalista/Annie,niveaux1/18,sans/avec achat public1001 ;20attaques,24essais Stop/Move avant/arrière pendant préparation,132refus publics,16860ticks. Kalista refuse12commandes,tire etreste fixe jusqu’à lancement+30 ;Annie accepte12commandes,annule le tir etmarche. Quatre achats,40trajets,12apports XP diagnostiques. Bottes vérifient la marche,pas la formule de bond absent. Aucun état injecté ni nouvelle dérivation des positions/f32.

Binaire historique6100992octets/SHA `ea5371890bf03abc400ee4384f1dbaf5157720c22bba20a63a695fb3e38a4de3`,non rouvert. Ancien probe7509876octets/RUN et1158dépendances restent inertes ;BUILD/RUN0 hérités. Six opérations documentaires journalisées réussies ;aucun nouveau build,jeu,natif,GPU,REA,probe,réseau ou reconstruction graphique. V564 ouvert.

## 5. Écarts et inconnues

Capture différée,fenêtre d’ordre,lancement,distances/vitesses,paliers,arrière25%,collisions/terrain/contrôles,Pierce,vision/cible et lifecycle restent ouverts. Applicabilité,ressource/variante,clip,pose,attache et pixels non qualifiés. Oathsworn/W/R restent distincts. Absence AutoBuff dans onze vues ou présence de texte/DDS ne démontre pas l’effet manquant ou rendu. Aucun inventaire complet,tâche VFX,inconnue ou acceptation fermé.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json :martial-poise-visual-resource-policy,queued-lunge-authoritative-event-and-trajectory,lunge-animation-attachment-render-lifecycle. Objectif,prérequis,critères et reprise explicites ;réutiliser les propositions COR-KALISTA antérieures,conserver cant_cancel,qualifier les autres politiques avant correction du jeu. Aucun registre modifié.

Prochain lot CH-Karma-PASSIF-PRESENTATION-VFX ;sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs,sans recensement global ni probe inchangé.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_kalista_passive_vfx_20261105/` :evidence_review,coherence_review,corrections_and_restart,operations/journals,reçus. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée close ;tâche complète,feature,inconnues et goal ouverts. Publication :rapport et ajouts CURRENT/HANDOFF avec archives exactes ;goal/Plan/UI/bases/registres/code/assets inchangés.
