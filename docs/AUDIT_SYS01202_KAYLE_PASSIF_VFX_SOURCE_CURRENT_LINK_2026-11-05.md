# Kayle — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1361 ; `AUD-SYS-01.2-02-KAYLE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Kayle-PASSIF-PRESENTATION-VFX` ; `OLF-d321ea9d-1239-5804-bd86-3d5952fbbd60`. Relier les déclarations applicables aux consommateurs actuels et décrire les corrections nécessaires. Seule cette liaison bornée est clôturée ; la tâche VFX complète reste ouverte.

Audit : terminé pour ce périmètre. Implémentation : Holy Fervor non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/kayle-passive-holy_fervor-links-v587.json`, copie E immuable référencée dans initial_scope.json :900010 octets, SHA-256 `47a42e98470c0b17f549dd4d069ee23d5742b9776bbbafc2d561beb877884d7d`. Quinze identités et rôles ; référence LoL4.20/EUW/en_GB héritée. Les chemins D restent des données, sans accès direct. V1232 source58/58, consommateurs65/65 et intégration40/40 restent historiques.

Cinq Lua structurels, trois initialisations/huit affectations. CharScript56 vide ; HolyFervor314 déclare DivineBlessing, JudicatorHolyFervor, deux AutoBuff explicitement vides, persistence et NonDispellable. Debuff161 déclare Kayle_Passive et JudicatorHolyFervorDebuff ; flags de persistence absents, pas false. Aucun transfert de cycle de vie entre propriétaire et cible. Reckoning473 et RighteousFury520 sont limités par NEWTABLEpc14/18 ; les deux enregistrements de limites sans path sont conservés tels quels. Pas de corruption ni callback serveur déduit.

Le texte2121 et la description4214 liée indiquent : attaque contre champion, perte de3% armure/MR pendant5s, maximum cinq cumuls. Base, calcul, ordre et rafraîchissement restent ouverts. Ancienne aura AS, mana40/60/80, rangs absents et huit lignes DDF Q/E avec coefficients AD ne deviennent pas des règles passives.

Trois preloads,976 octets/12 références : propriétaire/débuff, Q préchargeant le débuff, E avec quatre lumières skin07 et autres références. Ces déclarations ne prouvent ni éligibilité Q, ni acceptation de skin de base, ni effet exécuté. Trois candidats absents sont des observations historiques bornées, non répétées.

Captures E479588/660891 vérifiées. Une DDS2176 octets,64×64/DXT1/mipbrut0, membre0.0.0.200 : en-tête hérité, pas sélection ou pixels actuels. DivineBlessing non localisée dans les scopes antérieurs sélectionnés ; aucune absence globale, corruption ou substitution automatique déduite. Six chaînes de locale et dix références communautaires secondaires conservées.

## 3. Consommateurs réels

Quatorze fichiers Rust complets,31 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `damage.rs:38` ; `penetration.rs:4` ; `penetration.rs:9` ; `annie.rs:45` ; `annie.rs:73` ; `progression.rs:80` ; `trundle_r.rs:103` ; `trundle_r.rs:107` ; `damage.rs:91` ; `penetration.rs:6` ; `lifecycle.rs:83` ; `projected_live.rs:168` ; `progression.rs:164` ; `spells.rs:120`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`. stats combine base/croissance, objets, Garen et ajustement Trundle R. Celui-ci utilise ses propres états propriétaire/cible vivants ; ce mécanisme existant n’est pas Holy Fervor. La pénétration pourcentage puis fixe est calculée séparément et utilisée par les dégâts physiques/magiques. Ni ces corps ni la chaîne d’attaque inspectée n’établissent un producteur de cumuls Kayle.

Sorts/rangs Kayle refusés dans les branches inspectées ; projection sélectionnée pour Annie. Les défenses génériques, attaques, régénération, dégâts et nettoyage restent conservés. Recherche bornée Kayle/HolyFervor/Judicator : zéro occurrence dans ces14 textes, sans absence globale déduite.21 comparaisons sélectionnées et112 contextuelles chevauchantes concordent ;14 mécanismes VFX et deux animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis et lacunes sans confondre pénétration, Trundle R ou flags du propriétaire avec le débuff Kayle. Observé :89/89 contrôles documentaires et95/95 de cohérence séparée du même agent sur témoins sauvegardés. Aucune relecture indépendante ou validation humaine.

Deux cas V587 hérités :14 impacts Kayle MELEE avec témoins Windup.release et quatre projectiles AnnieQ attribués séparément ;34 refus,360 ticks finaux et334 ticks d’attente distincts. Cible Ahri : armure20.879999/MR30, puis35.879997/55 après Cloth1029 et Cloak1033. Les objets apportent15 armure/25MR ; défenses et dégâts restent ordinaires, Q/E Kayle refusés.

Dans chaque cas : six attaques Kayle, Q témoin puis14 ticks, attente167 ticks atteignant181 après le sixième impact, puis septième attaque et second Q. Les checkpoints149/150/151/181 sans débuff initial ne prouvent ni expiration à cinq secondes, ni plafond ou rafraîchissement. Tous restent vivants au niveau1 ; catégories supplémentaires et cycle de mort non exercés.

Binaire historique6059520 octets/SHA `5fb07c28ffd802f24856ea915cd548535b59e8a1c480f265c50a6f7a164e8cba`, BUILD/RUN0 conservés comme données, sans réouverture ni équivalence au binaire actuel. Dates documentaires et contrôle actuel distincts. Contexte V586 BUILD101 puis release qualifié conservé dans le reçu antérieur ; aucun replay. Aucun nouveau build, jeu, décodage natif, GPU, REA, sonde, réseau ou rendu.

## 5. Écarts et inconnues

Application, formule de cumul, base, ordre, éligibilité des compétences, rafraîchissement, expiration, sources multiples et cycle de vie restent ouverts. Deux AutoBuff vides ne prouvent pas une absence complète d’effet. Applicabilité visuelle, création, recette, sélection effective, attache, pose et rendu non qualifiés. Inconnues et V564 conservés ; anciens binaires/stockages inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : holy-fervor-owner-target-visual-applicability ; qualified-target-stack-defense-presentation-event ; qualified-debuff-resource-attachment-render. Chacune possède objectif, prérequis, critères et conditions de reprise. Aucune correction produit implicite.

Prochain lot : CH-Kennen-PASSIF-PRESENTATION-VFX, identité et reçu dans next_lot.json. Reprendre sur source, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain temporel chiffré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_kayle_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2348 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
