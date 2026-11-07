# Brand — contrat connu de Blaze et écarts actuels

6 novembre 2026 · V1457 · AUD-SYS-01.2-02-BRAND-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Brand-PASSIF-SIMULATION-CONTRAT, OLF-985bef07-0df4-5d72-a081-d60fe08d74f5, parent SYS-01.2-02. Décrire les branches connues de Blaze, leurs consommateurs et les interactions QWER. **Audit borné terminé ; tâche complète et fonctionnalité ouvertes.** Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Prérequis SOURCE, phase et lot conservés sans satisfaction implicite.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct.

Le reçu docs/reference_requirement_trace_sources/brand-passive-blaze-links-v659.json associait déjà ce contrat : 2644194 octets, SHA e44391c586a76738181ab20744e41736b86c1b8ef4f158498ef5610b750f9ce7. Rapport V659 et SOURCE V1187 réutilisés avec publication et sous-reçus. Résultat SOURCE : 29355 octets, SHA 76827f28f9f4cf915991972f701e633f1b9e534c6b202a1d9e30b19413f734df ; ses 15 contrôles restent antérieurs.

Seize identités natives sélectionnées, distinctes des 19 chunks inspectés par V659. Dix vues littérales/16globals, neuf limites NEWTABLE conservées. Parmi les dix, six rôles passifs fournissent neuf globals ; les rôles auxiliaires ne deviennent pas la brûlure. Les projections limitées restent inconnues, globals=null/raw globals={} ; ni corruption ni programme vide déduits.

BrandAblaze.luaobj et .preload sont présents dans les preuves héritées. Le premier échec V659 d’absence supposée reste identifié,792octets/SHA8d30557f6f440152807e098d3fa49a6154e7fc6906d650a6dad999a9bbdcdf60, puis corrigé avant publication. Il n’est pas rejoué. Preloads frost/zombie/base, Runspeed/persistance et chunks Sound/Zombie vides ne prouvent ni vitesse, résurrection, rendu ou audio.

Neuf recherches exactes dans le miroir en_GB : huit chaînes présentes, une clé SpellData absente. Fichier2220957octets, SHA1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Présence lexicale, binding effectif et locale runtime distincts ; identité du fichier commun seulement, aucun transfert du gameplay Blitzcrank.

## 3. Branches et consommateurs

Dix-huit branches : identité/aliases ; sorts admissibles ; PVmax ; type/modificateurs ; cadence ; plafond monstre ; refresh/cumul ; état ; Q ; W ; E ; R ; mort/crédit ; lifecycle/réseau ; présentation ; SpellData ancien ; lecteur ; vérification historique.

**Blaze est le passif affiché, BrandPassive son alias déclaré, BrandAblaze l’état, BrandBlaze le Q/Sear.** Le texte indique8%PVmaximum en dégâts magiques sur4s ; état1740 : dégâts chaque seconde ; BuffData1741 : maximum80/s contre les monstres. Premier tick, bornes, capture PVmax, arrondis et ordre du plafond restent inconnus ;8/4 ne démontre pas un ordonnanceur.

Interactions écrites : Q étourdit2s une cible déjà embrasée ; W +25% aux unités embrasées ; E propage aux ennemis proches, rayon inconnu ; R privilégie les champions pour le **rebond suivant**. Aucun mécanisme explosif d’une version ultérieure importé.

BuffData BrandAblaze résout1740 ; SpellData demande game_spell_tooltip_BrandAblaze, absent du font exact. Aucune réécriture d’alias. Coefficient0,6499999761581421, dégâts80/120/160/200/240 et portée25000 restent des champs Q-like anciens, pas la formule ou portée de Blaze.

Vingt-trois ancres : catalogue et22frontières génériques, aucune promue en producteur Blaze.26entrées sélectionnées concordent avec V659/SOURCE :15Rust,9JSON,2lecteursPython.30fenêtres SOURCE réutilisées après identité et lignes exactes.

Learn/Cast/CastAt ne fournissent pas de sort Brand accepté dans les dispatches inspectés. Attaques/projectiles, API Magical, mitigation/boucliers/PV, catégories Monster/Boss, maxPV, crédit et snapshot existent séparément. Ignite/True, Garen/Physical et AnnieQ/Magical ne sont pas des producteurs Blaze. Aucun état/ordonnanceur Brand qualifié dans ces corps ; aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : source, chemin courant, inconnue et correction par branche. Observé :18branches,30fenêtres,23ancres,30identités ; **48/48 contrôles documentaires et51/51 cohérences du même agent**.

Quatre opérations journalisées réussies : bootstrap01,contract01,coherence02,documentation01. coherence01 échoue sur named_Rust_files : le reçu utilise explicit_file_count/stdout/stderr. Script/journal conservés ; coherence_schema_qualification.json prouve le remplacement de cette seule expression. Recherche non relancée, autres contrôles et sources inchangés.

V659 hérité : Brand1/18 et Annie1/18, quatre attaques ordinaires, huit événements API40magiques, deux AnnieQ publics, six apports XP serveur,9239ticks.70refus publics/20API, snapshots historiquement conservés. Dix horizons silencieux151ticks ne testent aucun déclencheur Blaze : sorts Brand refusés ; aucune brûlure, refresh, plafond monstre ou interaction QWER exercée. Événements API/XP restent des diagnostics serveur.

Ancien binaire inerte :6102016octets, SHA2844634b7e74547ed7f0af68f758d3225de025061a1767f5871b80c2160d26b3. Aucun accès au payload, nouveau build/test Rust/runtime/probe/VM Lua/D/F-work/EXE/REA/réseau/GUI/GPU/capture. Recherche SOURCE15Rust et1158entrées historiques non rejouées ; concordance sélectionnée distincte de provenance complète de compilation.

## 5. Écarts et limites

Restent ouverts : admission/aliases/éligibilité ; application/lecture Ablaze ; PVmax capturés ou dynamiques ; cadence/échéances ; catégories/plafond80/s/mitigation ; refresh/cumul/multi-propriétaires ; immunités/boucliers/mort/crédit ; ordre Q/W/E/R, rayonE et algorithme du prochain rebond ; lifecycle, réplication et présentation.

Les noms client, constantes/preloads et références communautaires ne comblent pas le corps serveur manquant. Le premier défaut de présence est déjà corrigé dans les preuves ; aucune nouvelle enquête identique ni correction d’asset justifiée ici. Les champs absents de la définition ne deviennent pas zéro.

Inconnue propre OLU-3e0f2f11-212a-5cdf-9d3d-64400206d86b et inconnue SOURCE OLU-445a4e9f-c64b-541f-9174-670863dbc4bc conservées. Provenance JSON typé et INIBIN distincte, sans incident de hash inventé. Préparations/historiques SOURCE réutilisés avec leurs limites.

## 6. Corrections et reprise

corrections_and_restart.json conserve les trois rôles SOURCE existants et propose dix sous-objectifs COR-SYS-01.2-02-BRAND-BLAZE : SEMANTICS,TRIGGER,DAMAGE,SCHEDULER,Q-INTERACTION,W-INTERACTION,E-INTERACTION,R-INTERACTION,LIFECYCLE,VERIFICATION, suffixés-01. Chaque interaction possède sa fiche ; objectif, tâche liée, entrées, travail, fin et reprise explicites. Aucun registre modifié.

Reprendre sur source serveur, fournisseur, trace, callsite, dérive ou observation précise ; corrections produit sous autorisation adaptée. Vérifier le vrai trajet sortBrandadmissible→Ablaze→ticks→expiration, puis QWER séparément, maxPV variables, plafonds, cumul/multi-sources, refus sans mutation et provenance de build. Prochaine paire réelle : Braum SIMULATION-CONTRAT, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_brand_passive_simulation_contract_20261106 : contrat, branches, ancres, identités, cohérence, journaux dont échec conservé et corrections. Projection existante122paires réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2443entrées groupées conservées. Même agent, sans acceptation indépendante/humaine. Une unité bornée close ; aucune tâche complète, inconnue ou fonctionnalité fermée.
