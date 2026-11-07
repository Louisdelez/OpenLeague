# Braum — sources et consommateurs des VFX du passif

2026-11-05 · V1332 · AUD-SYS-01.2-02-BRAUM-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Braum-PASSIF-PRESENTATION-VFX, OLF-0bba5663-fe02-503e-aa61-be9ce93eb593. Relier les déclarations visuelles disponibles aux consommateurs actuels, en distinguant marques, stun, immunité/bonus, HUD et QWER. Contrat : lancement/trajet/impact applicables ; dépendance CH-Braum-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du présent audit : source/identité/portée, chemin actuel ou manque borné, contrôles et corrections précis. Audit documentaire terminé après publication vérifiée ; chemins génériques existants conservés, rendu spécifique non établi dans ce périmètre ; vérification statique, acceptation humaine non donnée. Inventaire VFX complet et exécution graphique exclus. SOURCE/HUD et diagnostics anciens non recomptés.

## 2. Sources, champs et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Copie V1322 de braum-passive-concussive_blows-links-v660.json : 6042989 octets, SHA de13a54bff2c5c88e74f9417df842ca41254a9f45c3f4772927d99c6e868f94f, vérifiée avant lecture.

Sélection explicite hors Deprecated : neuf vues passif/CharScript et une vue Q contextuelle. Huit des neuf sont qualifiées ; Override, 115 octets/SHA 71ac483c97e007da8f721cb1948891adf59482b11306b807a383cc4651ca37d4, conserve NEWTABLEpc0 et globals non qualifiés. LeonaSkin04 est une constante, pas une règle de skin. CharScript vide qualifié n’est pas un corps serveur. Le corpus hérité de 125 Lua, 45 limites, 181 Deprecated et six basenames doubles n’est pas un inventaire de 125 effets passifs ; chemins complets conservés.

BraumStunDebuff : 439 octets, SHA 5f59ee16e0c871f14f3ef09fdf3b2104052ff22bda2ccddb5fb1df0108a4c797, lecture complète, zéro enfant, huit globals qualifiés. /native_metadata/client_lua/41/literal_initialization/globals donne AutoBuffActivateEffect=LOC_Stun.troy, AutoBuffActivateAttachBoneName=C_BUFFBONE_GLB_CENTER_LOC et PopupMessage1=game_floatingtext_Stunned, témoins PC11/13/15. Deux champs AutoBuff, un effet et une attache ; le popup n’est pas un événement AutoBuff. Cela ne prouve ni déclenchement au quatrième coup, ni pose, ni ouverture/rendu de la particule.

Les neuf vues sélectionnées contiennent vingt globals qualifiés au total. Mark/Reduction/Stun nomment Braum_Passive.dds ; Tracker/Counter/Diminish nomment Kennen_MarkOfStorm avec BuffName distincts KennenMarkOfStorm/KennenMoSDiminish ; BraumPassive conserve LeonaShieldOfDaybreak.DDS. Les chaînes sont préservées sans importer règles Kennen/Leona. Q/GemKnight_Shatter/MaokaiTrunkSmash restent contexte, non recette du passif.

Définition : BraumMarkDamageTracker/Braum_Passive.dds, niveaux absents non remplacés par zéro. Texte : quatre marques et quatre secondes annoncées ; f1/f2/f3/f5 sans fournisseurs qualifiés. Tooltip BraumMarkDiminish non retrouvé dans le binding retenu ; aucune réécriture. DDF ancien, preloads et DDS HUD identifiés V1202 ne démontrent pas un producteur ou un effet en monde. Aucun natif/DDS redécodé ce lot.

## 3. Consommateurs actuels conservés

Sept Rust relus : crates/core/src/stuns.rs, lifesteal.rs, attacks.rs, spells.rs ; crates/client/src/native_hud_spells.rs, native_hud_summoners.rs, projected_live.rs. Douze ancres exactes. Les 28 entrées SOURCE V1188 et 14 identités communes VFX concordent ; anciennes conclusions réutilisées sans nouveau census.

grant_stun existe : source/target/tag/durée, gardes, control_duration, interruption et expires_at. Structure/boss non qualifiés sont refusés ; dégâts Physical et réplique magique restent génériques. Aucun producteur marques→quatrième coup→proc Braum identifié dans les corps précédemment lus sous empreintes.

Chemin HUD réel : update→all_states→player_states lit stuns/expires_at, puis color sur l’overlay. Priorité conservée : indisponible→cooldown→rang0→!allowed→ressource ; stun n’implique donc pas toujours le code disabled. Ce chemin générique ne crée pas LOC_Stun ni marques/immunité. projected_live sélectionne Annie Q.

Recherche nommée nulle dans les sept textes complets retenus. Une découverte exploratoire de trois noms exacts dans le client n’a donné aucun chemin ; elle n’est pas un census matériel ni une preuve d’absence globale. Autres alias/consommateurs non globalement exclus. Les helpers d’attache à matrice fournie ne qualifient pas le producteur du bone nommé.

## 4. Attendu, observé et contrôles

Attendu nominal statique : qualifier effet/attache, conserver rôles de sources et chemins existants, borner le manque d’activation/rendu. Observé : 59/59 contrôles documentaires, 50/50 cohérences séparées du même agent, douze ancres et gardes 28/14 concordantes. Refus et ordre HUD lus, jamais invoqués ce lot.

V660 conserve quatre cas, deux Braum/deux Garen : 52 impacts/huit quartets, partagés également. Quartets de 110 ticks, APIs40 magiques et stuns60 diagnostiques restent distincts des paramètres/procs natifs. 92 refus publics, 28 API, 14809 ticks et attente121 hérités, non rejoués ; attente sans marque/proc ne prouve pas expiration/immunité. Aucun build, test Rust, jeu, natif D/stat/résolution, VM/décodeur, GPU, REA, réseau, pixels ou nouvelle acceptation. Opérations documentaires terminées sans échec ; recherche sans résultat code1 attendue, distincte d’un échec de test.

## 5. Écarts et inconnues

Applicabilité, inventaire secondaire exhaustif, recette complète, ouverture/montage, f1/f2/f3/f5, état propriétaire/cible, alliés/multi-Braum, Q, sélection, audiences, skins, pose/attache, cadence et cycle rendu restent ouverts. Champ d’effet et bone nommé ne résolvent pas ces clauses. Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; contrôles aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Braum-PASSIF-PRESENTATION-VFX : effect-resource-and-applicability-contract, mark-proc-owner-target-world-link, bone-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD gardent leurs critères distincts.

Reprendre sur source/copie attribuable, lecteur, appel, pose, capture ou dérive pertinente. Ne pas remplacer recette inconnue par texture générée. Prochain lot : CH-Caitlyn-PASSIF-PRESENTATION-VFX, reçu V560 conservé et consommateurs pertinents, sans nouveau recensement global.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_braum_passive_vfx_20261105 : initial_scope, inspection, current_inspection, hud_link_inspection, evidence_review, coherence_review, gardes et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2319 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
