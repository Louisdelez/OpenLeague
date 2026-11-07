# SYS-01.2-02 — Riven : sources et consommateurs VFX du passif, V1392

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-RIVEN-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Riven-PASSIF-PRESENTATION-VFX`, `OLF-528158e2-7936-5094-ab63-a414c5b16dc2` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-8affc27b-92a2-5357-a865-e22df41a0477` et SOURCE `OLU-c3a62150-f497-57ef-b487-289580343bef` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/riven-passive-runic-blade-links-v620.json`,2757887octets,SHA `35ef0e912d1e284dcf7297d1bb1c94918f4205b54efef5432a6c56b3974303c5`. UTC documentaire2026-10-26T14:49:59.674663+00:00, sans heure d’exécution déduite.

66 identités natives :19INIBIN,28Lua,17preloads,DDF/font. V620 conserve198associations/26sites ; union SOURCE/frontières32ancres. Les28chunks sont consommés selon les reçus, sans prototype enfant :20initialisations littérales,126globals,huit limites NEWTABLE. Globals gardés par chemin complet. CharScript56 vide ;RivenPassive158 porte BuffName/PersistsThroughDeath/NonDispellable, sans icône ni callback démontré.

Définition RivenPassive/RivenRunicBlades.dds. Description4267 :les capacités chargent la lame,jusqu’à trois charges,une consommée par attaque avec bonus physique. Tooltip2558 conserve f1/f2/f3 ;AABoost2559 décrit la prochaine attaque renforcée. Formule,producteurs,durée et événements admissibles non résolus. PARType=None/BaseMP0 décrit l’absence de mana,pas les charges. Niveaux1/4/7 puis absents non adoptés comme progression complète.

Quatre chunks comportent huit champs AutoBuff reconnus :trois GLOBAL_SLOW.troy dans des contextes LightsaberMissile/Ezreal,plus cinq champs vides de WindSlashReady. Aucun n’est substitué au passif. Métadonnées Akali/Renekthon/Minotaur conservées sans adoption sémantique.

**AABoost595 demeure non qualifié à NEWTABLE pc18.** Ses constantes contiennent `Riven_Base_P_Buff.troy`, `Riven_Skin05_P_Buff.troy`, `r_hand` et des noms de champs d’effet/attache. Candidats identifiés,sans affectation effet→os,choix de skin ou événement prouvés. AutoCooldownByLevel22/18/14/10/6 ne devient ni durée ni bonus. Cette limite est conservée explicitement.

17preloads6843octets/88références typées :50particules/38sorts. Texte du discovery retenu et reconstruction CRLF exacte des17identités. CharScript précharge apbonusdamagetotowers/rivenpassive/rivenqlockout. Passive154 précharge rivenmartyr/rivenpassiveaaboost ;aucun preload AABoost dédié dans cette sélection partielle,sans absence globale inférée. Dépendances QWER,marth et unlock restent distinctes ;préchargement ne prouve pas création/arrêt.

Deux DDS E relus,2872octets chacun,64×64DXT1,mip7,même SHA `ff0d2eca71182e842cffff3b2fe4f2f2503bd81c52b997dc1a9d8e19d64ea760`. Chemins Characters/Riven/HUD/Icons2D et Spells/Icons2D ;membres0.0.0.191/0.0.0.45 hérités. Identité/en-tête ne prouvent pas lookup/variante/pixels. Source_sha256 None=a2880c55… identifie le JSON communautaire4092octets ;INIBIN natif1155octets/395c3467… distinct. DDF QWER et comparaisons communautaires réutilisés,sans recette passive numérique adoptée.

## 3. Consommateurs actuels

15 fichiers relus,dont13Rust/deux lecteurs Python ;32ancres exactes. Quatorze fichiers SOURCE/frontières antérieurs et27contextes concordants. Recherche Riven/Runic sans occurrence dans ces13Rust,sans absence globale revendiquée.

`lifesteal.rs:4` mène au dégât physique ordinaire avec montant raw ;`attacks.rs:284` détermine critique,présentation et cadence,avec empowered/Trundle distincts. `damage.rs:79` applique multiplicateur,mitigation,boucliers puis PV ;`progression.rs:40` expose les composants AD. Aucun producteur Runic identifié dans ce périmètre. Le contrôle Épée est expliqué par l’AD générique.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Ni leur présence,ni un owner générique,ni le client projeté ne démontrent recette passive,attache r_hand,pose,clip,registration ou pixels.

## 4. Attendu et observé

Attendu :charges produites/consommées et présentation attribuable. Hérité V620/HUDV1264 :deux profils niveau1,base/Épée1036+10AD ;12attaques ordinaires,54refus,362ticks d’attente,quatre trajets aboutis sans reprise. Cinq échantillons boutique,achat/vente/rachat :AD56,04/66,04/56,04/66,04.

Douze paires attendu/observé sauvegardées relues,concordantes à0,002PV :47,00552368–47,00553894 ou55,39338684–55,39340210. Modèle physique ordinaire hérité compatible ;aucun bonus passif qualifié. Aucun sort Riven accepté :génération,consommation,expiration et bonus de charges non exercés. Ressource0/max0 et362échantillons d’attente ne prouvent aucun compteur ou expiration.

PV cible adjacents avant/après absents,dommages dérivés hérités ;refus avec flags sans snapshots bruts. Soins non vérifiés,aucune garde NPC universelle. Deux profils,niveau1,une cible ne couvrent ni autres événements ni variantes.

Actuel :38/38contrôles documentaires,64/64cohérence séparée par le même agent ;six opérations journalisées exit0. Ancien48/50 et qualification50/50 conservés :deux égalités strictes entre dégâts dérivés corrigées vers la tolérance0,002 déjà déclarée,variation maximale≈0,00001526PV. Clarification de libellé également conservée,sans changement de jeu ou nouvelle exécution. Deux incidents de préparation actuels (nom de modèle absent,substitution de texte absente) transcrits sans faux journal brut,rectifiés avant les opérations du lot.

Trois JSON et deux reçus anciens BUILD/RUN0 relus ;binaire6075904octets/SHAc0729e20… inerte,jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Politique des charges et bonus,Qrecasts/R,formule/progression,durée/cap/rafraîchissement,consommation lancement/impact ouverts. Candidats AABoost,choix de variante,création/owner/attache/horloge/arrêt,lookup/pixels non qualifiés. Critique,on-hit,boucliers/immunités,cibles multiples,interruptions,mort/respawn et attribution réseau restent à vérifier. Acquis QWER/None et limites V564/V606 conservés ;aucune acceptation supplémentaire.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants :politique native/recette ;état de charges et impact réel ;attribution réseau ;consommateur VFX/ressources. Chacune définit objectif,prérequis,critères de fin et entrée de reprise. Réutiliser les contrôles AD/Épée. Reprendre sur nouvelle preuve native,mapping/callsite,capture précise,dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_riven_passive_vfx_20261106`,evidence_review/coherence_review,gardes,journaux et corrections héritées. `next_lot.json` cible Rumble,ligne de couverture vérifiée ;chercher d’abord un audit équivalent. Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent,sans revue indépendante.
