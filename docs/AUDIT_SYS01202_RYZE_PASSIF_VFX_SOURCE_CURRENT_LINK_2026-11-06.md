# SYS-01.2-02 — Ryze : sources et consommateurs VFX du passif, V1394

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-RYZE-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Ryze-PASSIF-PRESENTATION-VFX`, `OLF-58c4c7ec-d13d-5159-a2ed-04b1beb88f54` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-693cf106-3d29-563b-97fb-fb49477e82fc` et SOURCE `OLU-5a40194b-e801-54be-97fe-b59b0ab5d86d` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/ryze-passive-arcane-mastery-links-v622.json`, 2253112 octets, SHA `359ed899dd52d112a7c772154b0bdc91c4b74cfe3ee0545c0f32eb6c699e63d6`. UTC documentaire 2026-10-26T15:34:48.236720+00:00, sans heure d’exécution déduite.

30 identités natives : 14 INIBIN, huit Lua, six preloads, DDF et font. V622 conserve 90 associations/28 sites. Huit chunks consommés selon les reçus, sans prototype enfant : cinq initialisations littérales, 27 globals, trois limites NEWTABLE. Globals conservés par chemin complet. CharScript56 vide ; arcanemastery381 porte BuffName « Arcane Mastery », Ryze_SpellStrike.dds et des drapeaux. Aucun callback ou lifecycle serveur démontré.

Buff1687 et description4269 : lancer un sort retire une seconde aux autres sorts. Q CDR2/4/6/8/10% est distinct de cette réduction fixe. PARType absent, BaseMP342,3999938964844 ; classification locale Mana distincte. Anciens textes AP à faible vie, niveaux1/6/16 et constantes AutoCooldown ne sont pas adoptés comme politique du passif. Quatre tooltips exactement résolus, sans réécriture d’alias.

Trois paires INIBIN avec/sans espaces conservent des SHA différents : arcane mastery/arcanemastery, Rune Prison/runeprison, Spell Flux/spellflux. Priorité et équivalence des providers inconnues. Un seul chunk porte deux champs AutoBuff reconnus : desperatepower, effet Ryze_Dark_Crystal_DesperatePwr_Glow.troy sur bag_d. Ce contexte R ne qualifie pas Arcane Mastery. Overload, spellflux et spellfluxmissile restent limités par NEWTABLE ; SurprisePartyFiddlesticks demeure une constante étrangère non qualifiée.

Six preloads, 1383 octets, 18 références typées : 12 particules/six sorts. Discovery667716 octets/SHA b53870d0… conserve les textes ; reconstruction CRLF exacte des six identités. CharScript213 précharge arcanemastery/apbonusdamagetotowers/overload. Aucun preload Arcane dédié dans cette sélection partielle, sans absence globale inférée. Les dépendances QWER ne prouvent pas création, attache, arrêt ou applicabilité au passif.

DDS E relu : Characters/Ryze/HUD/Icons2D/Ryze_SpellStrike.dds, 4224 octets, 64×64 DXT5/mip0, membre0.0.0.254, SHA `802c9069ebb4da70a88719b32424edb9857e4270fe1c03a7cbef438f349c11e2`. Identité/en-tête ne prouve pas lookup, variante ou pixels. Source_sha256 Mana=f4d5e56b… identifie le JSON communautaire5164 octets ; INIBIN natif1842 octets/8d77d2a5… distinct. DDF et comparaisons QWER hérités, sans autorité serveur supplémentaire.

## 3. Consommateurs actuels

17 fichiers relus, dont15 Rust/deux lecteurs Python ; 34 ancres exactes. Seize fichiers SOURCE/frontières antérieurs et31 contextes concordants. Recherche Ryze/ArcaneMastery sans occurrence dans ces15 Rust, sans absence globale revendiquée.

`cooldown.rs:11` convertit un délai initial avec CDR plafonnée ; il ne retranche pas une seconde aux autres échéances. `spells.rs:101` et `progression.rs:159` refusent explicitement les capacités/progressions non implémentées, dont Ryze. `summoners.rs:85` utilise son propre délai sans CDR d’objet. Mana et affichage génériques hérités restent acquis.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence ne qualifie ni recette passive, owner/attache/pose, clip, registration ou pixels.

## 4. Attendu et observé

Attendu : un lancement Ryze accepté réduit un autre délai actif, avec événement et présentation attribuables. Hérité V622/HUDV1266 : trois profils niveau1, base/Codex3108/Saphir1027 ; 18 projectiles physiques, trois Barrier, 726 ticks d’attente, 84 refus, six trajets sans reprise et trois achats.

Dix-huit paires attendu/observé sauvegardées relues à0,002PV près, dégâts≈46,166748. Six IDs de projectile distincts par partie, sans unicité globale revendiquée. Aucun sort Ryze accepté ; délais propres nuls aux36 côtés des impacts. Cas nominal du passif non exercé.

Contrôle générique dix secondes : 300/270/300 ticks, recalcul f32 cohérent. Les762 snapshots d’échéance Barrier (36 côtés d’impacts et726 frames d’attente) gardent la même échéance initiale+6300 ; compte à rebours ordinaire confirmé. Cela ne qualifie pas l’éligibilité native des invocateurs au passif.

**Frontière clarifiée par neuf échantillons bruts :** dans les trois parties, bouclier115 présent à+59 ticks, déjà absent à+60 puis+61 ; expires_at=initial+60. L’ancien rapport disait « jusqu’au tick60, absent au tick61 ». Cette formulation est précisée ici ; ancien rapport et captures conservés. Aucun changement du jeu ou de règle native.

Saphir augmente la capacité342,4→542,4 sans remplissage immédiat ; aucun sort Ryze n’en teste la consommation. Sortants sans PVcible adjacents bruts, healing_checked=false, refus flags seulement et garde NPC universelle absente restent des limites.

Actuel : 39/39 documentaires, 68/68 cohérence séparée par le même agent ; six opérations journalisées exit0. Anciens71/71 et65/65 réutilisés. Trois JSON et deux reçus anciens BUILD/RUN0 relus ; binaire6081536 octets/SHA4da60cda… inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Événement de cast, slots admissibles/exclus, invocateurs, recasts/annulations, clamp/arrondis, ordre avec CDR, lifecycle et providers ouverts. Applicabilité VFX, recette, création/attache/horloge/arrêt, lookup/pixels et transport non qualifiés. Trois profils niveau1 ne couvrent pas tous les événements/variantes. Acquis QWER et limites V564/Nami conservés ; aucune acceptation supplémentaire.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants : politique native/effets applicables ; lancement accepté et réduction réelle ; attribution réseau ; consommateur VFX/ressources. Chacune définit objectif, prérequis, critères de fin et entrée de reprise. Conserver les contrôles CDR/Barrier/Mana et la frontière exacte du bouclier. Reprendre sur nouvelle preuve native, mapping/callsite, capture précise, dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_ryze_passive_vfx_20261106`, evidence_review/coherence_review, gardes et journaux. La clarification Barrier est détaillée dans inherited_report_boundary_clarification de coherence_review. `next_lot.json` cible Sejuani, ligne de couverture vérifiée ; chercher d’abord un audit équivalent.

Sept rubriques relues ; une unité de liaison bornée close, zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
