# Diana — sources et consommateurs des VFX de Moonsilver

2026-11-05 · V1336 · AUD-SYS-01.2-02-DIANA-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Diana-PASSIF-PRESENTATION-VFX, OLF-8c1f3a69-086b-5741-a8a6-41cf596337a7. Relier les déclarations du passif et les consommateurs courants ; distinguer compteur/troisième coup, zone, AP/vitesse, animations et HUD. Contrat : lancement/trajet/impact applicables ; dépendance CH-Diana-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du lot : identité/portée des sources, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos. Chaîne ordinaire conservée ; passif et rendu spécifique non établis dans les corps inspectés. Vérification statique, acceptation humaine non donnée ; inventaire VFX complet exclu.

## 2. Sources, déclarations et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Reçu V1322 diana-passive-moonsilver-third-cleave-links-v563.json : 624539octets, SHA a386d23575c330e1d207b2e60df6e659f703173e0393fa34842102d22fbc3473. Source externe retenue vérifiée avant interprétation ; cadrage53481octets sans incorporation du document complet, hook inchangé, gain de temps non mesuré.

/native_metadata/client_lua conserve quatre vues entièrement lues structurellement/littéralement, sans prototype enfant ni serveur exécuté. CharScriptDiana racine et DianaCombatBuff :56octets, globals vides. Passive/DeathRecap :193octets chacun, SHA57ba35de03e9218887b6506ba97acb964b0a91071dd2a0e429a2987229532821, sept instructions, mêmes BuffName=DianaPassive, icône et PersistsThroughDeath. Six affectations au total ; aucune AutoBuff dans ces vues, sans absence native d’effet déduite. Égalité des Lua ne prouve pas dispatch du récapitulatif ou persistance.

Définition : DianaPassive/Diana_Passive_LunarBlade.dds ; Passive1/Passive1Desc absents. Rangs1/4/7 puis trois champs absents, sans progression adoptée. Deux bindings INIBIN gardent le même tooltip ; référence3091373677 absente dans DeathRecap reste absente.

Découverte exacte capturée V1208 sur E :291999octets, SHA0b87db19e7f1539c706e9b5552d50cec85500e1004184e316250c615af02b906 ; original F/OpenLeague-work inerte, non rouvert. Preloads283/510octets : quatre/sept références, dont dianaarcready, diana_base_p.troy et diana_base_ba_tar.troy ; E/skin01 restent contexte, pas sélection du passif. Trois BasicAttack retenus gardent le hash brut1746694807=Attack1/Attack2/Attack3, Diana_Base_BA_Tar.troy, BloodSlash.troy et R_hand. Ces sélecteurs bruts ne démontrent ni compteur, recette complète, alternance ou pose.

Sept références communautaires conservées ; leur CharScript1563octets contient OnActivate/OnUpdate/PlayAnimation de posture. Il n’est ni vide ni autorité serveur native du passif.

Un DDS V1208 Characters/HUD,2872octets,64×64 DXT1/sept mips, SHA61cd15569879c4776f2f85d7e43e23163243742c3a0a13a55ae671b9ea4cd281, membre0.0.0.191 du projet0.0.1.7. Identité/header/membership hérités, pas nouveaux pixels ou lecture D ; chemin Spells non inventorié ne devient pas asset manquant. Textes en_GB1838/4178/4354 : AS f3, chaque troisième coup supplément magique f1/f2 aux ennemis proches. Valeurs, fournisseur et géométrie non qualifiés.

## 3. Consommateurs actuels conservés

Huit Rust relus : crates/core/src/attacks.rs, lifesteal.rs, damage.rs, critical.rs, spells.rs ; crates/client/src/attack_animation.rs, animation.rs, projected_live.rs. Vingt ancres exactes. Quinze entrées antérieures concordent : douze core, deux lecteurs SOURCE, un auxiliaire ; quatorze identités communes VFX inchangées. Ce ne sont pas quinze nouveaux producteurs.

advance_attacks échantillonne AD et basic_attack_hit applique Physical. Magical/MR, apply_damage et récapitulatif restent génériques. Corps damage lu au-delà du cfg(test) précoce d’un helper, sans troncature de production.

attack_animation observe les faits et sélectionne attack/crit pour Basic/Critical. animation::animate appelle cette sélection, cherche le rôle puis transitions.play et seek à l’âge observé. Cette liaison réelle est statique : elle ne qualifie ni enregistrement/exécution du plugin, clip chargé, pixels, ni animation du troisième coup. Guards et fenêtres locales ne sont pas timing historique. projected_live filtre Annie. Recherche Diana/Moonsilver/DianaPassive/DianaArcReady nulle dans les huit textes complets, sans absence globale affirmée ; contexte HUD antérieur non recompté.

## 4. Attendu, observé et contrôles

Attendu statique : qualifier déclarations et frontières, identifier chaîne ordinaire et manque spécifique. Observé :85/85 contrôles documentaires,63/63 cohérences séparées du même agent,20ancres et gardes15/14 concordantes. Refus/gardes lus seulement. V1208 source50/consommateur38/intégration34 hérités, non rejoués.

V563 nearby :18impacts,48refus, AP0/20/0 et cadence48/48/42ticks ; troisième/sixième coups physiques, cible secondaire sans dégâts à141.421unités de Diana/144.141de la cible principale. Opposite273.589unités reste séparé ; aucune géométrie complète qualifiée. Tome/Dague sont contrôles ordinaires, pas bonus natif.

Trois essais blue-side build0/run101 avant combat et ancienne inspection visant un mauvais reçu sont conservés ; succès de l’autre équipe ne résout pas le mouvement. Un helper actuel de préparation a échoué sur substitution textuelle superflue, conservé dans root_preparation_failure.json puis qualifié sans changer les preuves ou prédicats. Aucun nouveau replay, build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou pixels.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, f1/f2/f3, compteur/reset/expiration/consommation, AP échantillonné, vitesse, géométrie/orientation/cibles, owner/skin/audiences, pose/attache, montage et cycle de rendu ouverts. Preload, BasicAttack3, posture, DDS, recap ou animation ordinaire ne clôturent pas ces clauses. Échecs de déplacement restent dans les tâches existantes, sans cause rayon/carte inventée.

Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement. V1322 immuable ; zéro tâche complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; pas de garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Diana-PASSIF-PRESENTATION-VFX : moonsilver-visual-applicability-source, third-hit-counter-cleave-world-link et resource-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/mouvement gardent leurs critères distincts.

Reprise sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale ou replay inchangé. Prochain lot CH-Draven-PASSIF-PRESENTATION-VFX : reçu V565 retenu, distinguer Adoration, gains d’or, HUD et effets.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_diana_passive_vfx_20261105 : cadrage, inspections, evidence_review, coherence_review, préparation échouée/correction, gardes et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
