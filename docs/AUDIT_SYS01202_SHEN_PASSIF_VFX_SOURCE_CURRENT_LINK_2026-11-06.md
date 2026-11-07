# SYS-01.2-02 — Shen : sources et consommateurs VFX du passif, V1397

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SHEN-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Shen-PASSIF-PRESENTATION-VFX`, `OLF-5ee054a6-4bbb-5318-9713-4fc1cf62c624` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-8c323b91-232b-5b28-81c2-3417c0847633` et SOURCE `OLU-04e3da3d-9951-56a5-9806-01762e0e0757` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct.

Primaire `reference_requirement_trace_sources/shen-passive-ki-strike-links-v625.json`,2818218 octets,SHA `6171366a907ad4947badbdba945438949038af8241fab4b8bc5fd780da8661dc`, UTC documentaire2026-10-26T16:24:40.047291+00:00. Complément V549 `shen-passive-onhit-links-v549.json`,550731 octets,SHA `575beb664e4aacb0e1ddcc326df98a5e41f79975e186866e70b6b63b7cb6566a`, daté2026-10-25T19:04:30.502699+00:00. Ces dates ne sont pas des heures d’exécution.

V625 :57 identités natives (22 INIBIN,20 Lua,13 preloads,DDF/font),171 associations/26 sites. Les18 identités du V549 sont un sous-ensemble exact des57, pas18 ressources supplémentaires. Aucun essai V549 fusionné avec V625. Source V549 sans client_lua standard ne signifie pas absence de Lua : son ki_lua correspond exactement au ShenKiAttack277 du V625.

Vingt chunks consommés selon les reçus, sans prototype enfant :15 initialisations littérales,72 globals,cinq limites NEWTABLE. Globals conservés par chemin complet. CharScript56 vide ; Marker221 lie Shen_KiStrike.dds et des drapeaux, sans callback serveur. KiAttack277 demeure limité à NEWTABLE pc10 ; TPAShen et flags non adoptés comme sélection effective ou gameplay, pas de corruption conclue.

Définition Marker,ExtraSpell1=ShenKiAttack,Energy/BaseMP chaîne200.0. Passive1=9 ne prouve pas une durée. Description WIP4273 :8s ; buff2622 :9s, bonus magique f1+f3[10%PVbonus], restitution f2 énergie, réduction1s par attaque sbire/champion. Ancien texte KiAttack/PVmax distinct. Choix8s/9s,basePV,f1/f2/f3,progression et état initial restent inconnus. V549 conserve ces conflits et n’établit aucune priorité de provider. DDFQ/soins et réduction additionnelle Feint ne comblent pas les valeurs passives.

Douze BuffData résolus/onze clés distinctes, deux bindings Marker2622 sans priorité déduite. Trois chunks portent six champs AutoBuff : Feint déclare **Effect**=shen_Feint_self.troy ; StandUnitedShield déclare **Event**=DeathsCaress_buf.troy ; WayOfTheNinjaCooldown garde quatre champs vides. Event n’est pas réécrit en Effect. Aura/Marker/HardCooldown/Cooldown et OnPreDamagePriority ne démontrent ni état prêt, ni callback ou lifecycle.

13 preloads,2758 octets,33 références typées :15 particules/18 sorts. Discovery970670 octets/SHA3d2ece0e… conserve les textes ; reconstruction CRLF exacte des13 identités. Marker168→Aura/HardCooldown ; Aura256→shen_kistrike_ready_indicator.troy/Cooldown/HardCooldown ; HardCooldown→Aura. KiAttack98 précharge globalhit_red.troy. Indicateur/impact candidats identifiés, sans création, attache, horloge, arrêt ou variante qualifiés. Les sorts sont dans DATA/Spells ; inventaire antérieur Characters/Shen/Spells corrigé, sans absence d’assets déduite.

Deux DDS E relus,64×64 : KiStrike5616 octets,DXT3/mip7,membre25,SHAeb6ba2fe… ; Grey2176 octets,DXT1/mip1,membre77,SHA96e32790…. Chemins partagés Spells/Icons2D,aucun alias étranger/particule ouvert. Identité/en-tête ne prouve pas lookup/variante/pixels. Source_sha256 Energy=36b32344… correspond au JSON communautaire7980 octets ; INIBIN natif2559 octets/df5b5610… distinct.

## 3. Consommateurs actuels

16 fichiers relus, dont14 Rust/deux lecteurs Python ;32 ancres exactes. Quinze fichiers SOURCE/frontières antérieurs et28 contextes concordants. Recherche Shen/KiStrike sans occurrence dans ces14 Rust, sans absence globale revendiquée.

`regeneration.rs:10` utilise la restauration générique Mana/Energy ; `lifecycle.rs:24` l’admet pour Energy. `progression.rs:110` exclut le mana d’objet hors Mana. `lifesteal.rs:4` applique le dégât physique ordinaire sans cycle Ki ; `shields.rs:47` absorbe un montant générique. Taux10/s statique hérité, pas une mesure de restitution au plafond. Les limites HUD Energy du V1269 restent héritées.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ; aucune qualification de recette passive, owner/attache/pose, clip, registration ou pixels.

## 4. Attendu et observé

Attendu : disponibilité qualifiée, attaque magique supplémentaire, restitution et délai réduit, présentation attribuable. V625/HUDV1269 : trois profils niveau1 base/Rubis1028/Saphir1027 ;18 mêlées,813 ticks d’attente,81 refus,six trajets sans reprise,neuf relevés boutique/six transactions.

AD60,17 inchangé,PVmax570,8/720,8/570,8 ; dégâts50,469711–50,469727 ordinaires, identiques avec Rubis. Dix-huit paires attendu/observé sauvegardées relues à0,002PV près. Dix-huit paires brutes énergie200→200,max200 malgré Saphir : restitution sous plafond non exercée. Aucun sort Shen accepté ; boucliers absents aux36 côtés d’impacts, Feint non exercé.

271 frames d’attente par cas ;280 ticks entre troisième et quatrième impacts. À30Hz actuels, cela dépasse8s/9s sans qualifier période native ou expiration d’un état Ki jamais produit. Les813 frames restent à200. Rang/délais propres génériques ne sont pas un timer Ki.

V549 reste séparé : neuf attaques contre Ahri,profils base/Rubis/Épée, dégâts≈49,77664/49,77664/58,04932 ordinaires ; énergie200 pleine. Ces neuf observations héritées ne sont pas ajoutées aux18 du V625. Ni restitution ni bonus magique qualifié dans ces contrôles.

Dommages dérivés sans PVcible adjacents bruts ; soins non vérifiés, refus flags seulement et garde NPC universelle absente restent des limites. Actuel :42/42 documentaires,70/70 cohérence séparée par le même agent ;six opérations journalisées exit0. Anciens66/66 et57/57 réutilisés.

Trois JSON et deux reçus anciens V625 BUILD/RUN0 relus ; binaire6078976 octets/SHAc6d30a0b… inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau, aucune ancienne expérience rejouée.

## 5. Écarts et limites

Provider8s/9s,PVbonus/max,f1/f2/f3,progression,initialisation,consommation/événements/cibles,ordre réduction1s/Feint,clamps/lifecycle ouverts. Applicabilité/recette, lookup prête/grise, attache/horloge/arrêt, pixels, HUD Energy et transport non qualifiés. Trois profils V625 niveau1 ne couvrent pas tous les événements ; V549,QWER et limites V564/Nami conservés distincts.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants : politique native/provider/recette ; on-hit réel/énergie/recharge ; événements réseau ; consommateur VFX prêt/impact. Chacune définit objectif, prérequis, critères de fin et reprise. Conserver Rubis,cap200 et exclusion mana d’objet. Reprendre sur nouvelle preuve native,mapping/callsite,capture précise,dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_shen_passive_vfx_20261106`, evidence_review/coherence_review,gardes et journaux. `next_lot.json` cible Shyvana,ligne de couverture vérifiée ; chercher d’abord un audit équivalent.

Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
