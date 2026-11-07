# SYS-01.2-02 — Sejuani : sources et consommateurs VFX du passif, V1395

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SEJUANI-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Sejuani-PASSIF-PRESENTATION-VFX`, `OLF-c757576f-a6ea-5248-96e5-8d6ad762a4dc` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-83e9eee7-4eed-540f-8f0d-45910e9ff659` et SOURCE `OLU-c343cabd-629e-5a8e-b382-96643ece0db2` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/sejuani-passive-frost-armor-links-v623.json`,3190776 octets, SHA `378bb20cec5658386dc9d88a893aba039c7c4aaad8fd7bea482de8f32c52ded0`. UTC documentaire2026-10-26T15:50:40.232089+00:00, sans heure d’exécution déduite.

91 identités natives :30 INIBIN,40 Lua,19 preloads,DDF/font. V623 conserve273 associations/30 sites. Quarante chunks consommés selon les reçus, sans prototype enfant :32 initialisations littérales,93 globals,huit limites NEWTABLE. Globals conservés par chemin complet. CharScript56 vide ; Passive186 porte Sejuani_passive.dds, BuffName SejuaniPassive et PersistsThroughDeath. Définition Sejuani_Passive.dds et Display193 conservent leur casse distincte, sans équivalence de provider déduite.

Buff2607 et description4270 : infliger des dégâts par attaque ou capacité donne de l’armure et une réduction des ralentissements pendant2s ; un buff déjà actif gagne2s de durée. Magnitude f1, progression et plafond restent inconnus. PARType/Passive1/niveaux absents, BaseMP287,20001220703125 ; Mana courant distinct. Héritage critique allié/AttackRate non adopté. DDFW bonushealth×0,1 ne résout pas f1.

Frost Armor propre reste distinct de Frost, marque ennemie d’E. Seize BuffData :10 résolutions, six clés absentes conservées sans alias (ArcticAssault,NewE,PassiveDisplay,EliseHumanEHeal,PassiveStacks,PassiveHitBuff). PassiveHeal249 expose EliseHumanEHeal/EliseHumanE.dds ; aucun soin ou bouclier déduit. PassiveStacks188 expose BuffName SejuaniPassiveMS, sans compteur/plafond démontré.

Six chunks portent neuf champs AutoBuff reconnus. FrostTracker déclare Sejuani_Frost.troy pour la marque ennemie ; R déclare stun/slow. W End/Removal portent uniquement l_hand/r_hand et EnrageDamage Buffbone_Glb_Weapon_1 : ces os seuls ne prouvent pas une création. Aucun AutoBuff reconnu dans les cinq chunks passifs sélectionnés, sans absence native inférée.

19 preloads,6399 octets,83 références typées :47 particules/35 sorts/un personnage. Discovery1195410 octets/SHA b90cf839… conserve les textes ; reconstruction CRLF exacte des19 identités. CharScript893 précharge notamment Passive/Display/Stacks. Display226 précharge sejuani_passive.troy,root,sejuani_passive_self.troy ; dépendances propres identifiées, sans recette/événement qualifiés. PassiveHeal196 précharge deux particules nommées heal_buff ; leurs noms ne définissent aucun soin. Dépendances QWER séparées.

Deux DDS E relus,64×64 : Sejuani_Passive.dds2176 octets,DXT1/mip0,membre161,SHA96024a04… ; Sejuani_Frost.dds4224 octets,DXT5/mip1,membre68,SHA35dd0f61…. Un homonyme particule22000 octets reste manifeste seulement. Qualification de sélection antérieure conservée : ni ce payload ni Elise ouverts, aucun manifeste reparsé. Identité/en-tête ne prouve pas lookup/variante/pixels. Source_sha256 Mana=5803cb91… identifie le JSON communautaire5011 octets ; INIBIN natif1807 octets/610a02fd… distinct.

## 3. Consommateurs actuels

18 fichiers relus, dont16 Rust/deux lecteurs Python ;36 ancres exactes. Dix-sept fichiers SOURCE/frontières antérieurs et32 contextes concordants. Recherche Sejuani/FrostArmor sans occurrence dans ces16 Rust, sans absence globale revendiquée.

`slows.rs:9` choisit le ralentissement non expiré le plus fort ; sa préparation applique la durée de contrôle générique. `progression.rs:100` calcule armure base/croissance/objets/effets existants et retrait Exhaust. `summoner_exhaust.rs:23` lit sa réduction de défense, puis sa route de lancement accorde le slow. Aucun producteur Frost Armor identifié ici. Réduction de durée Courage et résistance à l’amplitude du slow restent distinctes.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ; aucune qualification de recette passive, owner/attache/pose, clip, registration ou pixels.

## 4. Attendu et observé

Attendu : dégâts admissibles produisant le buff propre et présentation attribuable. Hérité V623/HUDV1267 : profils niveau1 base/Tissu1029/Bottes1001 ;18 attaques sortantes,neuf physiques entrants,trois Q Annie,84 refus,six trajets sans reprise,neuf relevés boutique/six transactions.

Armure29,54/44,54/29,54 ; vitesse340/340/365. Les647 relevés d’armure hérités restent génériques pendant les séries d’attaques. Les dégâts ordinaires exercent le déclencheur candidat sans bonus observé ; sa magnitude exacte reste inconnue car f1 non résolu. Aucun sort Sejuani accepté.

228 relevés Exhaust,elapsed0..75 par cas : armure−10,slow0,3,vitesse238/238/255,5 pour elapsed<75 ; valeurs de base à75. Les543 relevés d’attente suivants restent génériques. Réinterprétation documentaire des valeurs scalaires héritées : aucun supplément d’armure/réduction du slow ; aucune expiration d’un Frost Armor réellement produit démontrée.

Neuf paires physiques relues face au modèle d’armure courant et trois Q comparés aux attendus hérités, tolérance0,002PV. Dommages dérivés, sans paires PVcible adjacentes brutes ; soins non vérifiés, refus flags seulement, garde NPC universelle absente. Qsansshield et référence Elise ne prouvent aucun bouclier.

Actuel :43/43 documentaires,68/68 cohérence séparée par le même agent ;six opérations journalisées exit0. Anciens72/72 et69/69 réutilisés. Le JSON probe46724475 octets a déjà été vérifié/décodé par current01 ; collecteur et cohérence réutilisent les scalaires qualifiés sans refaire ce décodage. Identités recontrôlées à la publication, aucun gain chronométrique annoncé.

Premier BUILD101 conservé avec ses deux E0559 (champ target sur Summoner). Version privée _target utilisant SummonerTarget : BUILD/RUN bruts0. Reçus et ancien journal relus ; aucune réparation du jeu ici. Binaire6153728 octets/SHAd3944590… inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

f1/progression, événements/cibles, ordre armure/slow, clamps, extension/plafond/expiry et lifecycle ouverts. Recette, déclenchement, lookup/providers/casse, attache/horloge/arrêt, pixels et transport non qualifiés. Marque ennemie, buff propre, métadonnées Elise et homonyme particule restent séparés. Trois profils niveau1 ne couvrent pas tous les événements/variantes ; limites V564/Nami conservées.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants : politique native/recette ; état réel/armure/résistance au slow ; attribution réseau ; consommateur VFX/ressources. Chacune définit objectif, prérequis, critères de fin et reprise. Conserver les contrôles Tissu/Bottes/Exhaust. Reprendre sur nouvelle preuve native, mapping/callsite, capture précise, dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_sejuani_passive_vfx_20261106`, evidence_review/coherence_review, gardes, journaux et qualification de sélection. `next_lot.json` cible Shaco, ligne de couverture vérifiée ; chercher d’abord un audit équivalent.

Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
