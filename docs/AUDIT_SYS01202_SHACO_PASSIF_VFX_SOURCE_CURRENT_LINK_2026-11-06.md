# SYS-01.2-02 — Shaco : sources et consommateurs VFX du passif, V1396

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SHACO-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Shaco-PASSIF-PRESENTATION-VFX`, `OLF-494a2242-daf1-5c3a-990c-c1b1f024aeb7` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-ab36385f-efcc-56ee-8949-d9f001d068a6` et SOURCE `OLU-e14e6307-c494-5a75-9828-bc58390ba174` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/shaco-passive-backstab-links-v624.json`,3266853 octets, SHA `a153b0745fe68f67cd24bd422b9c87f493a0e62d836e3a0c3fafa745438d9ac9`. UTC documentaire2026-10-26T16:07:27.661336+00:00, sans heure d’exécution déduite.

62 identités natives :19 INIBIN,28 Lua,13 preloads,DDF/font. V624 conserve186 associations/28 sites. Les28 chunks sont consommés selon les reçus, sans prototype enfant :28 initialisations littérales,73 globals, aucune limite NEWTABLE. Globals conservés par chemin complet ; cela ne qualifie pas un serveur complet. CharScriptShaco,FromBehind et CastFromBehind font56 octets chacun et exposent des globals vides, pas un prédicat arrière démontré.

Backstab214 porte Jester_CarefulStrikes.dds,BuffName,PersistsThroughDeath et NonDispellable. Buff1702 et description4271 concordent :20% de dégâts supplémentaires depuis le dos. « Attacking »/« striking a unit » ne fixe pas secteur, instant, catégories de dégâts/cibles, critiques/clones ou ordre. PARType/Passive1/niveaux absents,BaseMP297,20001220703125 ; Mana courant distinct. Héritage régénération mana et DDFE bonusAD×1 non adoptés comme formule passive.

Six tooltips exactement résolus. Un seul chunk porte un champ AutoBuff reconnu : TwoShivPoison→global_slow.troy, contexte E distinct. Aucun AutoBuff reconnu dans Backstab ne prouve l’absence de ses effets. Spell4=HallucinateFull,ExtraSpell1=Hallucinate ; correction antérieure de la prose de découverte conservée avec les variantes distinctes.

13 preloads,3349 octets,47 références typées :sept particules/39 sorts/un personnage. Discovery857956 octets/SHA32b64a71… conserve les textes ; reconstruction CRLF exacte des13 identités. CharScript287→Backstab/apbonus/traplimiter_shaco/shacoclonedanceoverride. Backstab279→castfrombehind,absolutezero_tar.troy,twoshivpoison,frombehind. Dépendances identifiées sans création/attache/horloge ou activation qualifiée. Hallucinate/Applicator préchargent Backstab, sans prouver l’éligibilité effective du clone.

Deux DDS E relus,8448 octets/un contenu,64×64 DXT5/mip0 : Characters/Shaco/HUD/Icons2D et Spells/Icons2D/Jester_CarefulStrikes.dds, membres153/25, même SHA `acc3d18619469bce01668d85172e22bec244907a3e7c58022eaaa961d8932183`. Aucun alias étranger/particule ouvert. Identité/en-tête ne prouve pas lookup/variante/pixels. Source_sha256 Mana=9e389785… identifie le JSON communautaire4865 octets ; INIBIN natif2171 octets/87fd3a1e… distinct. Comparaisons QWER héritées, sans autorité serveur supplémentaire.

## 3. Consommateurs actuels

17 fichiers relus, dont15 Rust/deux lecteurs Python ;34 ancres exactes. Seize fichiers SOURCE/frontières antérieurs et29 contextes concordants. Recherche Shaco/Backstab sans occurrence dans ces15 Rust, sans absence globale revendiquée.

`lifesteal.rs:4` applique le dommage physique ordinaire sans test de facing. `entity_facing.rs:34` capture les directions seulement pour Garen/Trundle ; déplacement nul conserve l’orientation. `entity_yaw.rs:2` porte le calcul natif de yaw, distinct de la politique reconstruite de production des directions. `attacks.rs:314` appelle capture_facing au démarrage d’attaque. Shaco conserve facing absent, sans remplacement par zéro.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Ni orientation publique ni présence des moteurs génériques ne qualifie le bonus, la recette passive, owner/attache/pose, clip, registration ou pixels.

## 4. Attendu et observé

Attendu : condition arrière qualifiée, dommage modifié et présentation attribuable. Hérité V624/HUDV1268 : quatre profils niveau1,base_face/base_dos/Épée1036_face/dos ;24 attaques ordinaires non critiques,724 ticks d’attente,108 refus,12 trajets sans reprise,dix relevés boutique/six transactions.

Relecture documentaire des24 frappes : positions source/cible, direction cible[8,0] et yaw≈−89,999992° concordants. Cosinus recalculés+1 pour12 frappes de face et−1 pour12 au dos. Ces deux géométries courantes ne qualifient ni le secteur natif ni l’instant de son test. Facing Shaco omis aux48 côtés d’impacts, inconnu conservé.

AD57,580002/67,580002 ; dégâts ordinaires45,148041–45,148071 ou52,988953, identiques face/dos à équipement égal. Vingt-quatre paires attendu/observé et modèles ordinaires hérités concordent à0,002PV près. Illustration×1,2≈54,177646/63,586752, sans adoption d’une formule native complète. Aucun bonus arrière observé dans ces contrôles.

Aucun sort Shaco accepté. Mana plein et181 ticks d’attente/cas ne qualifient ni consommation ni lifecycle du passif. Dommages dérivés sans PVcible adjacents bruts ; soins non vérifiés, refus flags seulement et garde NPC universelle absente restent des limites.

Ancien collecteur : KeyError facing consigné, champ optionnel omis ; revue OBSERVATIONS_REVIEW sur le même RUN réussi, sans rejeu. Identité du script initial conservée comme donnée inerte. L’égalité historique au RUN brut reste une preuve héritée, sans nouveau parsing de ce RUN ici. Correction Hallucinate distincte de cette reprise.

Actuel :40/40 documentaires,69/69 cohérence séparée par le même agent ;six opérations journalisées exit0. Anciens69/69 et63/63 réutilisés. Trois JSON et deux reçus anciens BUILD/RUN0 relus ; binaire6138880 octets/SHAf9338438… inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Secteur/seuil, instant attaque/dégâts, orientation requise ou indisponible, catégories de cibles/dégâts/sorts/clones, critiques/réductions, ordre/clamps et lifecycle ouverts. Applicabilité VFX, recette, déclenchement, lookup/providers, attache/horloge/arrêt, pixels et transport non qualifiés. Quatre profils niveau1 ne couvrent pas tous les événements ; QWER,HallucinateFull/Hallucinate et limites V564/Nami conservés.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants : prédicat natif/événements ; bonus réel de dégâts arrière ; géométrie/événements réseau ; consommateur VFX/ressources. Chacune définit objectif, prérequis, critères de fin et reprise. Conserver les contrôles face/dos/Épée et l’orientation inconnue explicite. Reprendre sur nouvelle preuve native,mapping/callsite,capture précise,dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_shaco_passive_vfx_20261106`, evidence_review/coherence_review, gardes et journaux. `next_lot.json` cible Shen, ligne de couverture vérifiée ; chercher d’abord un audit équivalent.

Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
