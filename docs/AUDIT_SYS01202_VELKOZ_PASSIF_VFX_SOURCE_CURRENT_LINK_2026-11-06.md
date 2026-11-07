# SYS-01.2-02 — Velkoz : Organic Deconstruction et consommateurs VFX, V1419

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VELKOZ-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Velkoz-PASSIF-PRESENTATION-VFX`, `OLF-a7cc48f2-c87b-5f1d-b0a2-23ed5b9fa28d` : relier marqueur, Apply/Stack/Tracker/Proc, dépendances et consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. SOURCE V648 et HUD V1292 réutilisés ; QWER complet, réseau, dégâts et présentation complète restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/velkoz-passive-organic-deconstruction-links-v648.json`,3673934 octets,SHA `e301b5b29bc3890f442d9c0b952277874dd80a61a127a421b1d3475000cec81c`. UTC documentaire 2026-10-27T00:30:55.938741+00:00. Métadonnées et captures E réutilisées ;aucun accès D/F/OpenLeague-work renouvelé.

Dix-neuf ressources primaires :cinq INIBIN,sept Lua,cinq preloads,DDF,font ;63 voisins non promus. Sept chunks directs parmi36 vues Lua sans prototype enfant :24 initialisations littérales,12 limites NEWTABLE,22 globals. CharScript,ResearchApply et RResearchBuildup56 vides.

Définition1188 :VelkozPassive/Velkoz_Passive.dds ;Passive1/Desc et six niveaux non résolus. Marqueur171 →2.dds ;Stack156 →Velkoz_Passive.dds ;Proc154 →VelkozPassive.dds. Tracker90 et marqueur déclarent persistance,sans timer/lifecycle exécuté.

Font2868 :sorts qui touchent,troisième touche,dégâts vrais @f1@,perte après sept secondes sans touche. **Les attaques ordinaires rafraîchissent seulement,sans ajouter de marques.** Texte cible2871/SourceName emploie attacks,non promu contre cette règle précise. Nom4478/description4302 conservés ;f1/échelons inconnus. DDF36 lignes sans lien/coefficient renseigné. Deux AutoBuff reconnus,QSlow/WSlow →GLOBAL_SLOW.TROY,distincts du passif. Miroir font vérifié par identité,sans reparcours sémantique.

Cinq identités preload,1071 octets :Char585,Apply96,Stack98,Proc196/SHA `a59639cd3ac5039b89ee411c6e69d66615eccffeb70f3796423bdc832f1b5125`,RBuildup96. Rôles hérités :Apply→Stack→Tracker,Proc particules loop/proc,RBuildup→Apply. Texte brut et références typées non présents dans les copies sélectionnées,donc inconnus ;ni application,fréquence R,owner/attache ou rendu déduits.

Deux DDS relus dans E,2176 octets chacun,64×64 DXT1,mip brut0 :VelKoz_Passive/SHA `16cb534ede7a9bc1014fb908b9d835e4e25999c27274d8c9e41574bc6e545426`,2.dds/SHA `ce1936a371c8004390b8433281f3e099c16fe0180dc4c67a7aa34fba738ef576`. Membership200/25 du projet0.0.1.7 hérité. Proc VelkozPassive.dds non retrouvé par basename exact insensible à la casse dans le manifeste70286 membres déjà examiné. Proc_icon_source_gap.json conservé,sans réécriture vers Velkoz_Passive ni nouveau recensement. Autre provider/alias,skin et pixels restent ouverts. StatsJSON communautaire distinct de l’INIBIN.

## 3. Consommateurs réels

Quatorze fichiers actuels,douze Rust et deux lecteurs Python ;29 ancres concordantes. Treize sources/frontières,36 contextes,14 entrées VFX communes,deux liens d’animation ordinaire et font inchangés.

attacks.rs:167 →basic_attack_hit ;lifesteal.rs:17 →apply_damage Physical. Profil ordinaire missile8000 relié au BasicAttack natif,aucun faisceau historique rendu qualifié. summoner_ignite.rs:6 charge ignite_rules.json et:32 applique True ;native_summoners_420.json est sous cfg(test),non source runtime ajoutée. Aucun producteur Velkoz nommé dans douze préfixes Rust inspectés ;ancienne recherche client réutilisée après garde,conclusion bornée.

True générique,owner/projection/chargement,widget Ezreal et animations ordinaires ne produisent pas le compteur ni les effets de déconstruction.

## 4. Attendu, observé et contrôles

Attendu :relier étapes/dépendances,établir producteur ou manque borné et reprise. Observé :déclarations reliées ;touches de sorts,compteur,refresh/proc et rendu non établis.

33/33 contrôles documentaires,58/58 de cohérence séparée du même agent. HUD114/114 et107/107 hérités. Six reçus d’impacts physiques non critiques relus,L1/L18,trois chacun,missiles8000 ;résidus inférieurs à0.002PV.618 calculs PV/régénération hérités,196 pendant les attaques et422 après,sans recalcul.

Ces attaques sans marques sont compatibles avec le texte natif. Elles ne testent ni génération par sorts,ni rafraîchissement d’une marque existante,ni troisième sort.211 ticks après chaque dernier impact sur cible non marquée ne démontrent aucune expiration native de sept secondes. Learn/Cast/CastAt refusés ;aucun sort qualifié activé.

Témoin Embrasement distinct :cinq applications14 aux0/30/60/90/120,statut absent dès150 ;181 frames attendues/observées dérivées,sans paires PV brutes individuelles. Pas de soustraction indépendante rejouée ni de f1/politique native déduits. Six trajets publics,sans réordre ;4440 ticks des cas +2092 du témoin =6532 ;deux apports XP diagnostiques100000.58 refus flags,sans toutes les paires individuelles ;aucune progression naturelle complète,mort ou fin de partie qualifiées.

BUILD/RUN hérités0,ancien RUN345835 et1158 dépendances non relus. Binaire6077952/SHA `77a57a995bc4dd9ff8772f95d6e02366eb5e72f1864465ebc4241b91597bff50`,identité inerte. Ancien KeyError du catalogue de tests et scripts d’inspection initial/corrigé conservés ;en-tête erroné direction/movement-speed du pilote gardé comme contexte,corps/observations d’attaques distincts.

Six productions actuelles réussies,sans échec propre. Aucun nouveau build,jeu,décodage natif,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

f1/échelons,multitouches/cibles,consommation/refresh/overlap,fréquence R,ordre boucliers/immunités,expiration/lifecycle,audiences,Proc icon,recette/provider/skin et pixels restent ouverts. **Le rendu des marques et du proc reste non qualifié.** Attaques sans marques et Embrasement ne prouvent pas le passif complet. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json conserve quatre clauses :POLICY-01 qualifie règles/présentation ;SPELL-STACK-01 produit le compteur et rafraîchit seulement sur attaque ;NETWORK qualifie compteur/transitions/audiences ;VFX relie étapes et rendu. TRUE-DAMAGE-01,PROC-ICON-SOURCE-01 et HUD-BINDINGS-01 existants restent des dépendances séparées. Un sort minimal admis suffit au premier cas,sans attendre tout QWER. Préconditions,fins et reprises précises.

Reprendre sur source/capture/callsite ou règle de provider nouvelle,ou dérive ;implémentation sous autorisation distincte. next_lot.json vise Vi :chercher ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_velkoz_passive_vfx_20261106` :projections,fenêtres,reçus d’impacts,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
