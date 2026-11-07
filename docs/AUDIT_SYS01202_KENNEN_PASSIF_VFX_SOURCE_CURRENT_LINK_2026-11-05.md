# Kennen — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1362 ; `AUD-SYS-01.2-02-KENNEN-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Kennen-PASSIF-PRESENTATION-VFX` ; `OLF-87d91932-6474-5c5a-a186-52eafa275d2a`. Relier déclarations applicables et consommateurs actuels, puis préciser les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète reste ouverte.

Audit : terminé pour ce périmètre. Implémentation : Mark of the Storm non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/kennen-passive-mark_of_storm-links-v588.json`, copie E immuable référencée dans initial_scope.json :1050254 octets, SHA-256 `4493b3d6b8e8bea4b641470006d00af2ff061f0b881814f977313d0c3bbe12d0`.32 identités et rôles, référence LoL4.20/EUW/en_GB héritée. Les chemins D restent des données, sans accès direct. V1233 source59/59, consommateurs63/63 et intégration40/40 restent historiques.

Onze Lua structurels, onze initialisations et32 affectations. CharScript109 déclare Teemo_EagleEye : non vide, contrairement au candidat communautaire ; MegaProc56 vide reste distinct. Mark/Diminish158 portent chacun deux champs nom/icône, sans flags de persistence. Indicator/Live/Proc, BringTheLight, missile Q, Rush et Storm conservent leurs rôles. Trois AutoBuff vides concernent Indicator/Proc/Rush ; ils n’établissent pas une absence globale d’effet. SpellToggleSlot3.0 n’est pas automatiquement R. Aucun callback serveur exécuté.

Passive1LuaName contient KennenMarkOfStorm.lua ; le chunk .luaobj ne prouve pas l’alias effectif. Description4215 liée : marques6.25s, trois marques pour un étourdissement1s et gain25 énergie, effet diminué si répété sous7s. Facteur de diminution, consommation, ordre et refresh restent ouverts. Ancien texte de dégâts du proc non adopté ; tooltip W11643 lie chaque cinquième attaque au W. Cinq candidats absents/DDF sont des constats historiques bornés, non répétés.

Neuf preloads,2295 octets/30 références : holder, mos2, mos_tar, diminish, W/Q/E/R et variantes de couleur. Ce sont des déclarations, pas des recettes ou activations prouvées. Captures E624441/788849 vérifiées. Deux DDS2176 octets identiques,64×64/DXT1/mip1, membres25 ; ni priorité de chargement ni pixels actuels qualifiés. Dix chaînes de locale et seize références communautaires secondaires conservées. Le lecteur Lua additionnel garde son identité, son absence d’exécution et son rôle non enregistré comme consommateur SOURCE.

## 3. Consommateurs réels

Quinze entrées complètes :14 Rust et champion_resources.json,37 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `annie.rs:45` ; `annie.rs:73` ; `regeneration.rs:10` ; `lifecycle.rs:16` ; `lifecycle.rs:24` ; `stuns.rs:6` ; `stuns.rs:15` ; `stuns.rs:37` ; `annie_passive.rs:9` ; `annie_passive.rs:20` ; `annie_passive.rs:3` ; `annie_passive.rs:11` ; `annie_passive.rs:23` ; `regeneration.rs:47` ; `progression.rs:112` ; `lifecycle.rs:83` ; `projected_live.rs:168` ; `stuns.rs:31` ; `progression.rs:164` ; `spells.rs:120`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, profil dans `data/4.20/`. Le profil local23018 octets contient Kennen/Energy et sa provenance ; il ne contient pas le montant du passif ni un PARMax natif. stats exclut les bonus mana d’objet pour cette ressource ; régénération bornée au maximum, stockage et restauration génériques existent.

Le contrôle générique stocke source/tag/date de fin, interrompt l’attaque et nettoie les étourdissements. Pyromania a une garde Annie, quatre charges et son tag propre ; ce mécanisme n’est pas Mark of the Storm. Sorts/rangs Kennen refusés dans les branches inspectées ; projection ciblant Annie. Attaques, dégâts, énergie et nettoyage génériques restent conservés.

Recherche bornée Kennen/MarkOfStorm/mos : zéro occurrence dans les14 corps Rust ; deux occurrences attendues dans le JSON de ressource. Pas d’absence globale déduite.23 comparaisons sélectionnées et92 contextuelles chevauchantes concordent ;14 mécanismes VFX et deux animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis et lacunes sans confondre contrôle Annie, régénération ou plafonnement avec le passif Kennen. Observé :119/119 contrôles documentaires et111/111 de cohérence séparée du même agent, sur témoins sauvegardés. Aucune relecture indépendante ou validation humaine.

V588 hérité, deux cas base/Sapphire :12 attaques ordinaires à distance non critiques, témoins source/cible,30 refus et360 ticks finaux. Kennen niveau1, W non appris, rangs/délais zéro, énergie constamment200, régénération10/s. Sapphire1027 apporte200 mana pour400 or, pas d’énergie supplémentaire. Sans sort éligible accepté, marque créée ou déficit d’énergie, ces cas ne mesurent pas le gain25 ni un échec isolé de remboursement.

Témoin Annie séparé : cinq Q magiques, quatre charges puis Pyromania au cinquième impact,38 ticks d’étourdissement, huit refus et424 ticks d’attente de cooldown ; déplacement accepté après expiration. Il vérifie le contrôle générique local1.25s arrondi à38, pas le Kennen1s ou l’effet diminué sous7s. Ne pas fusionner ces cas avec les essais de marques.

Binaire historique6081024 octets/SHA `ef3ef2b20a4254095280d718f6ca1516c463d0e1a20a28807894451f3df094af`, BUILD/RUN0 conservés comme données ; aucun binaire rouvert ou déclaré équivalent au courant. Dates documentaires et contrôle actuel distincts. Aucun nouveau build, jeu, décodage natif, GPU, REA, sonde, réseau, HUD, VFX ou audio exécuté.

## 5. Écarts et inconnues

Alias, éligibilité, rafraîchissement, durée exacte aux bornes, consommation, source multiple, ordre, facteur de diminution et remboursement depuis déficit restent ouverts. Recette, création, sélection effective, attache, pose et rendu non qualifiés. L’absence de marques dans les cas précédents ne prouve pas expiration ; les AutoBuff vides et icônes ne résolvent pas l’effet complet. Inconnues et V564 conservés ; anciens binaires/stockages inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : mark-diminish-resource-applicability ; qualified-mark-stun-energy-presentation-event ; qualified-mark-resource-attachment-render. Chacune possède objectif, prérequis, critères et conditions de reprise. Aucune correction produit implicite.

Prochain lot : CH-Khazix-PASSIF-PRESENTATION-VFX, identité et reçu dans next_lot.json. Reprendre sur source, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain temporel chiffré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_kennen_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2349 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
