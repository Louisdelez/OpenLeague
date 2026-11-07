# Brand — Blaze : sources VFX et consommateurs actuels

6 novembre 2026 · V1439 · AUD-SYS-01.2-02-BRAND-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Brand-PASSIF-PRESENTATION-VFX, OLF-3bfe103c-3624-58b2-9e3f-4c24392e1a4b. Relier les effets applicables de lancement, trajet et impact aux sources, états et consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; CH-Brand-PASSIF-NETWORK reste requis. Statut a_faire, implémentation et acceptation conservés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques hérités ; acceptation humaine non donnée. SOURCE V1187 et HUD V1201 ne sont pas clôturés à nouveau. Ce lot ne termine ni Blaze, ni Brand, ni SYS-01.2-02.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. V659 fait2644194octets, SHAe44391c586a76738181ab20744e41736b86c1b8ef4f158498ef5610b750f9ce7. L’identité F concorde avec la copie figée. Seize memberships natifs hérités, distincts des19relations SOURCE et32identités liées non promues. Aucun chemin D rouvert.

Dix-neuf vues Lua consommées par le lecteur antérieur, sans prototype enfant : dix initialisations littérales/16globals et neuf limites NEWTABLE, sans corruption déduite. Les six vues directement rattachées aux16sources ne déclarent aucun AutoBuff reconnu. BrandPassive179 déclare icône/BuffName/persistance ; BrandAblaze247 déclare cinq flags dont IsDeathRecapSource. Runspeed90 ne porte qu’une persistance ; CharScript/Sound/ZombieResurrection56 sont vides. Ni vitesse, audio, résurrection, vie d’effet ou callback serveur prouvés.

Le contexte lié ScorchGround98 déclare un AutoBuffActivateEffect vide ; il n’est pas promu recette du passif. BrandBlaze désigne Q/Sear, Blaze le passif affiché et BrandAblaze l’état. Passive1/description/six niveaux absents restent absents. Les valeurs SpellData Ablaze25000/0.649999976/80…240 ressemblent au Q, sans définir portée ou formule du passif. Sa clé SpellData exacte reste introuvable dans le texte sélectionné, sans alias inventé.

Les compagnons BrandAblaze sont présents. L’ancien échec V659 d’absence supposée est conservé avec sa correction, non rejoué. Deux preloads479/358, total837octets, sont identifiés. Les rôles historiques décrivent six dépendances base/frost/zombie et des compagnons de personnage ; contenu brut/recette typée non disponibles dans les reçus sélectionnés. Préchargement ne prouve pas activation ou variante effective.

Deux DDS BrandBlaze2176octets/64×64 DXT1 ont le même contenu SHA8b86137e9316aa48fd92fa5d10547681fe4d76c5f44e1947b1d4d3c92752c381. Memberships hérités0.0.0.26 ; deux chemins, sans priorité ou pixels rendus qualifiés. Textes1740/1741/4167/4343 :8%PVmax magiques sur4s, plafond annoncé80/s contre monstres. Premier tick, cadence, arrondis, PVmax/refresh/cumul/mitigation inconnus. Q2s/W+25%/propagationE/rebondsuivantR sont des contextes textuels séparés ; aucune explosion ultérieure importée.

## 3. Consommateurs réels

17 Rust courants inspectés,22ancres V659 retrouvées. Learn/Cast/CastAt conservent les refus Brand. Attaque physique, API de dégâts, mitigation/pénétration, état/tick et autres effets génériques existent ; aucun producteur BrandAblaze qualifié n’est établi dans les corps examinés. API40magiques et AnnieQ ne remplacent pas un sort Brand éligible.

Les acquis partagés sont réutilisés : owner arrêtant huit handles existants, registre spatial alimenté par observations du caller, classes/résolveurs, animations ordinaires. HUD QWER/Ezreal et transport d’un Burn Ignite ne prouvent pas un trajet VFX Blaze. Le flag IsDeathRecapSource ne constitue pas un mapper ou renderer exécuté.

44comparaisons sur40fichiers concordent :14éléments partagés, deux animations,16contextes HUD, onze contextes V659 et le miroir en_GB. Streaming d’identité seulement. Recherche BrandPassive/BrandAblaze/BrandBlaze/Ablaze/Blaze dans les préfixes de production des17Rust : zéro hit. Conclusion bornée, sans exclure tout alias ou chargement dynamique ailleurs.

## 4. Attendu, observé et contrôles

Attendu : sort éligible → état Ablaze → ressource/variante → owner/cible/attache/temps → rendu, ou lacune précise. Observé : déclarations et briques génériques identifiées, chaîne spécifique non établie. **34/34contrôles documentaires,134/134de cohérence séparée du même agent.** HUD hérité :38source,24consommateur,20intégration,16postpublication, non rejoués.

V659 hérité : Brand/Annie niveaux1/18, quatre attaques ordinaires, huit API40magiques, deux AnnieQ publics, six XP serveur,70refus publics/20API et9239ticks. Dix horizons151ticks sans supplément ne testent pas un déclencheur Brand, ses sorts étant refusés. Ni brûlure4s, refresh/cumul, plafond monstre ou interactions QWER exercés. Résumés relus, sans snapshots bruts, nouveau calcul flottant ou runtime. Ancien EXE6102016/SHA2844634b et1158dépendances inertes.

Cinq productions Python journalisées réussies. Garde root initiale arrêtée sur une différence de schéma HUD : F_mirror_pin au lieu de F_text_identity. Le script initial et la qualification sont conservés ; une seule clé change, tous critères d’identité inchangés. Cache common.pyc optionnel absent distingué de common.py retenu. Recherche complémentaire AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, zéro candidat, résultat nominal borné. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Déclencheur/cibles/catégories, politique temporelle4s/80monstre/PVmax/refresh/cumul, ordre QWER, recette/base/frost/zombie/skins, owner/attache/arrêt, audiences/réseau et rendu restent ouverts. Métadonnées, noms, API et absence de DoT après des contrôles non éligibles ne les résolvent pas. Identifiants VFX/SOURCE intégralement conservés dans evidence_review. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire et applicabilité exhaustive non qualifiés. Aucun asset déclaré corrompu ou absent.

## 6. Corrections et reprise

corrections_and_restart.json sépare quatre objectifs : politique des déclarations/variantes/recettes, producteur sortBrand→Ablaze périodique, réseau owner/cible, intégration VFX. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche précise prérequis, fin et reprise. Un premier cas demande un vrai sortBrand accepté, sans exiger tout le kit.

Reprendre sur source/capture/callsite nouveau ou dérive, avec autorisation distincte pour implémenter. Ne pas rejouer les dix horizons ou les mêmes décodeurs sans déclencheur nouveau. next_lot.json sélectionne Cassiopeia, schéma exact lu dans son reçu figé ; aucun audit Cassiopeia réalisé ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_brand_passive_vfx_20261106 : scope, inspection, evidence_review, coherence_review, identités, qualification de schéma, corrections, reprise et journaux. Sept rubriques relues ; même agent, sans revue indépendante ou acceptation humaine nouvelle. Seul l’audit de liaison borné est clôturable.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2425entrées groupées conservées. Goal, Plan/UI, bases, code, assets et statuts inchangés.
