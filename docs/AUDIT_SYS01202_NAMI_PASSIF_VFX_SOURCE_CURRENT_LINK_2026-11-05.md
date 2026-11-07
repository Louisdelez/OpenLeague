# Nami — Surging Tides : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1380 ; `AUD-SYS-01.2-02-NAMI-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Nami-PASSIF-PRESENTATION-VFX` ; `OLF-74e562b7-1640-51ac-b787-9e52adbe62e3`. Audit de liaison borné terminé. Mouvement ordinaire présent ; contact allié et bonus du passif non qualifiés. Vérification documentaire fraîche, essais historiques hérités, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat et prérequis conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/nami-passive-surging-tides-links-v606.json`, 2736464octets, SHA `db571e21224ee2e4622b8df70b44d9de061af2db9d70577405b1c1b30ea37bf4` ; copie E identique. LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.63identités natives,26Lua,12initialisations/50globals,14limites NEWTABLE. Trois Lua56 vides ne prouvent aucune absence d’animation. HUD V1250 :55/55documentaires et39/39cohérence historiques.

Porteur NamiPassive247 : icône Janna_Tailwind.dds, nom NamiPassive, DoesntTriggerSpellCasts/persistence/NonDispellable. Bénéficiaire positif NamiPassiveDebuff209 : NamiPassive.dds, NamiPassivett, AutoBuffActivateEffect=Nami_Base_P_buf.troy. Aucun bone déclaré ici. NamiRunSpeed90 ne définit pas la formule. Cinq AutoBuff : effet bénéficiaire, effets E/R et bones R distincts. Casse Global_Slow/global_slow préservée ; alias Janna/Minotaur/Zyra non règles étrangères adoptées.

Sept tooltips résolus ;2326 décrit contact des compétences sur alliés,40+@f1@ de vitesse,1.5seconde ; description4237 concordante. @f1@ non résolu. Passive1 et rangs1–4 zéro textuels, rangs5–6 manquants, non progression numérique.22métadonnées de sorts,24DDF aux liens/coefficients vides,28références communautaires secondaires ; CharScript communautaire vide, W à cible unique non rebonds complets. Sept absences candidates bornées, non absence globale de ressources.

Deux DDS distincts : propre2872octets/64×64/DXT1/mip7/membre137 ; Janna partagé4224/64×64/DXT5/mip1/membre25. Identité non lookup/pixels/rendu. Douze preloads identifiés,4310octets ; contenu non qualifié. Découverte attendue970768octets, SHA `3595ca96ed889f3d948d230c500cf22c9c00d0f48d5ca1451fa19b15e63276d4`, absente des captures sélectionnées et des candidats E exacts/SHA consultés. Aucun ancien F-work/D consulté, aucune absence globale affirmée. Reprise précise documentée.

Captures qualifiée1455099/probe2009157 vérifiées ;46entrées,44pinnées historiquement/deux ultérieures,45payloads nonEXE relus. Quatre identités binaires inertes ; aucun binaire rouvert. Provenance actuelle source_sha25651992d07… du JSON communautaire4995octets, distincte de l’INIBIN natif1337octets/SHA2a961442… ; caveat conservé.

## 3. Consommateurs réels

Dix Rust complets,29ancres dans evidence_review.json sous `F:/OpenLeague/`. Refus sorts/rangs dans spells/progression/annie_w ; movement calcule définition+objets, modificateurs génériques et slows, puis softcaps. ally_occupancy utilise vitesse/TICK_RATE et collision/planification ; projected_live filtre Annie. Aucun nom Nami/SurgingTides trouvé dans ces dix corps, absence bornée. Onze comparaisons sélectionnées recouvrent25fichiers F contextuels ; quatre binaires inertes hors25.14mécanismes communs/deux animations ordinaires concordants, non recette Nami.

## 4. Attendu et observé

Attendu : liens précis, acquis et échecs préservés, lacunes et reprise vérifiables. Observé :66/66contrôles documentaires,117/117cohérence séparée du même agent, non pair indépendant. Six opérations documentaires exit0. Lecture exploratoire root initialement erronée sur mapping/liste, corrigée et transcrite ; sources inchangées.

V606 hérité : deux cas publics Map10/trois joueurs, Nami21/Annie22 ennemie/Ahri23 alliée. Base/Bottes25+Tome20AP : vitesse Nami335/360, alliée330, AP0/20, mana377.2399902.102refus,184ticks d’attente, huit trajets mesurés,512samples/198fullspeed ; six arrivées réussies et deux échouées. Aucun contact de compétence Nami avec allié exercé, aucun bonus observé ; attente44/45/46 non expiration d’un buff actif.

Deux échecs concernent Ahri23 :180samples chacun,24fullspeed/156zero,36unités restantes, destination déjà null avant Stop, arrived=false/nominal_passed=false. Collecte et contrôles réussis, mais nominal_walk_checks_all_passed=false/movement_fidelity_accepted=false. Trois essais antérieurs BUILD0/RUN101 conservés ; final BUILD/RUN0/0 signifie collecte achevée, non réparation navigation. Raw command JSON relus ; OBSpassed ne constitue pas reçu terminal d’inspection. Binaire principal6086144octets/SHA2c869cb5… inerte, trois autres identités distinctes.

Tableaux V1250 hérités sans recalcul : attentes sans PV/positions,12snapshots de bornes ; refus sans paires brutes complètes, exclusion universelle NPC non qualifiée. Aucun nouveau build/jeu/natif/GPU/REA/probe.

## 5. Écarts et inconnues

Activation/éligibilité, @f1@, cumul/rafraîchissement, durée réelle, lifecycle et présentation restent ouverts. Navigation Ahri distincte du mouvement Nami. V564 Diana/Garen décrit un défaut d’arrondi/collision ; ce contexte n’établit pas la cause des deux échecs V606. Preuve V564413659octets/SHAe0c76ed2… et tâche existante CH-Ahri-MOUVEMENT-CHEMIN reliées sans changer le registre. Preloads/recette/lookup/attache/rendu/audio et acceptation restent ouverts.

## 6. Corrections et reprise

Quatre clauses précises dans corrections_and_restart.json : contact allié ; formule/durée/vitesse ; particule/icônes/provenance ; diagnostic d’arrivée du bénéficiaire sur la tâche Ahri existante. Objectifs, prérequis, critères de fin et entrées de reprise explicites. Correction produit distincte à autoriser ; aucune nouvelle tâche de registre ni formule inventée.

Prochain candidat `CH-Nasus-PASSIF-PRESENTATION-VFX` dans next_lot.json : rechercher d’abord un audit équivalent. Réutilisation des extraits et mécanismes inchangés ; recherches/REA/compilation seulement sur question précise nouvelle. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_nami_passive_vfx_20261105/` : evidence_review.json, coherence_review.json, corrections_and_restart.json, journaux, result.json et reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2367 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal/Plan/UI/bases/registres/produit/assets inchangés ; tâche complète, fonctionnalité, inconnues, parent et jeu ouverts.
