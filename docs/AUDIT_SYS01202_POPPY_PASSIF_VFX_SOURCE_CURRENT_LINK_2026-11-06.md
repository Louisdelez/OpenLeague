# SYS-01.2-02 — Poppy : sources et consommateurs VFX du passif, V1389

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-POPPY-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, gameplay et acceptation humaine restent ouverts.

## 1. Exigence et frontières

`CH-Poppy-PASSIF-PRESENTATION-VFX`, `OLF-a545e925-eee5-5d25-89ff-7d8b39c2309f` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnue VFX `OLU-34251252-b288-51db-aef9-194681c61af4` et SOURCE `OLU-dc640e3c-4498-54a4-8370-196bd16624fa` ouvertes. Phase et prérequis examinés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/poppy-passive-valiant-fighter-links-v615.json`,2297425octets, SHA `c6e844b55e2501a483853517247d8d82cc53ccfb061c4c93dca9aa3e95eee3a8`. UTC documentaire2026-10-26T13:12:13.878593+00:00, sans heure d’exécution déduite.

46 identités natives :12INIBIN/19Lua/14preloads/font. 15 initialisations littérales,49globals,quatre limites NEWTABLE ; zéro prototype enfant selon les reçus ne qualifie pas un serveur original. Globals conservés par chemin complet. CharScript56 vide. ValiantFighter224 lie Poppy_ValiantFighter.dds/BuffName/PersistsThroughDeath/NonDispellable, sans callback ou lifecycle accepté.

Sept chunks portent12champs AutoBuff. Quatre déclarations d’effets concernent R/E :DiplomaticImmunity_tar.troy et HeroicCharge_cas2.troy. ETarget porte six champs vides et des métadonnées RumbleDangerZone ; huit BuffData sont résolus, dont une référence étrangère VayneCondemn. Ces liens ne deviennent pas des mécaniques d’autres champions. Dans deux Push, l’identifiant moteur `False` demeure non résolu ; il n’est pas remplacé par le booléen false. Passive1=9,texte Jax,niveaux3/7/11/15 et anciens pourcentages de mana ne sont pas une progression du passif.

Font2471/description4255 :dégâts physiques/magiques dépassant10%desPVcourants réduits de50%,hors structures. Partie excédentaire/coup entier,égalité,ordre résistances/boucliers/régénération et sources/types admissibles restent indéterminés. Textes WIP et scripts communautaires ne comblent pas ces inconnues.

14 preloads3382octets et43 références typées :22particules/21sorts. Discovery698579octets/SHAaf87b38e05b9c85995344fd428f46dbf2045f39128c4b6095d99d5086366ac96 retient le texte ; reconstruction CRLF exacte des14identités. CharScript précharge apbonusdamagetotowers/poppyvaliantfighter/poppyparagonmanager. ValiantFighter108 précharge `poppyvaliantfighter_eff.troy`. Dépendance identifiée, sans création/owner/attache/horloge ou rendu qualifiés ; les effets R/E restent des contextes séparés.

Deux DDS E relus,4224octets chacun,64×64DXT5,mip1, même SHA `f28c16773e27597d0d9c9597268ed1dd098680fdd8cc0283d3b1a6c811bab27e`. Chemins Characters/Poppy/HUD/Icons2D et Spells/Icons2D ; membres0.0.0.235/0.0.0.25 hérités du projet0.0.1.7. Identité/en-tête ne prouvent ni lookup, variante ou pixels. Mana source_sha b520131f… correspond au JSON communautaire5077octets ; natif1816octets/SHA730a4c4d… distinct.

## 3. Consommateurs actuels

16 fichiers inspectés, dont14Rust/deux lecteurs Python ;30ancres SOURCE/frontières relues. Identités des15fichiers antérieurs et29contextes inchangées. Recherche nominative sans hit dans ces14Rust, sans absence globale revendiquée.

`damage.rs:79` conduit multiplicateur sortant→Courage0,7/ou1→pénétration/mitigation→absorb_shields→PV. `shields.rs:47` consomme un montant remaining. Aucun seuil Poppy identifié dans cette route. Courage et bouclier à montant ne qualifient pas Valiant Fighter.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence et le client projeté générique ne prouvent ni recette passive, registration, clip ou pixels.

## 4. Attendu et observé

Attendu :réduction fidèle et présentation attribuable. Hérité V615/HUDV1259 :trois cas niveau1, base/Rubis1028+150PV/Cape1033+25RM. AD61,97/armure28,72 ;PVmax559,08/709,08/559,08 etRM30/30/55. Neuf attaques sortantes,18physiques entrants,sixQAnnie,81refus,360ticks d’attente,sixtrajets aboutis.

Les24événements restent conformes aux dégâts ordinaires à0,002près :physiques≈39,16252,Q≈61,53846 ou51,61290. Dix événements au-dessus/quatorze dessous du seuil illustratif après mitigation :5/3,1/7,4/4 par cas. Classements et arithmétique recomparés sur les captures conservées ; aucune formule native adoptée. Les contrôles Rubis/Cape fonctionnent, aucune réduction du passif observée.

Six paires Q de PV bruts avant/après relues :delta+régénération concorde avec l’observé sauvegardé. Pour18physiques, PV après bruts non sauvegardés, observé dérivé hérité ; cette limite est maintenue. Aucune égalité exacte,structure,bouclier positif,dégât pur,multisource ou mort/respawn exercés. Refus avec flags sans snapshots bruts,attentes sans âge de buff et absence de garde NPC universelle conservés.

Actuel :39/39 documentaires,62/62 cohérence par le même agent ;six opérations journalisées exit0. Contrôles HUD55/55 et49/49 hérités. Ses anciennes corrections de chemin MD, de découpe avant apply_damage et de libellés restent identifiées comme corrections de méthode, sans fix jeu.

Trois JSON et deux reçus bruts anciens BUILD/RUN0 relus. Binaire6135296octets/SHA32b4ea468478ac52b01b82aaf7982f90a6ddc603dd0a550022a4c2d07585420c inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau. Lecture des modèles de scripts explicitement UTF-8 ; texte de prochaine action conservé lisible, sans retouche des preuves gelées antérieures.

## 5. Écarts et limites

Formule,ordre et admissibilité restent inconnus ; recours aux PVcourants confirmé par texte uniquement. Producteur d’effet,attache,durée/arrêt,ressource/variante et pixels non qualifiés. QWER/callbacks,mort/respawn,attribution/transport et provenance Mana restent ouverts. Tests hérités limités au niveau1 et aux trois profils. Limites V564 et échecs Nami conservés. Aucune acceptation gameplay supplémentaire.

## 6. Corrections et reprise

`corrections_and_restart.json` décrit quatre clauses sur IDs existants :politique seuil/dégâts ;application au vrai pipeline ;attribution réseau ;présentation/ressources. Chacune porte objectif,pré requis,critères de fin et entrée de reprise. Conserver les contrôles Rubis/Cape. Reprendre sur preuve native/capture précise,dérive ou autorisation distincte d’implémenter ;aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_poppy_passive_vfx_20261106`, evidence_review/coherence_review,gardes,journaux et corrections de méthode héritées. `next_lot.json` cible Quinn,ligne de couverture vérifiée. Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent,sans revue indépendante.
