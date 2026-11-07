# Blitzcrank — sources anciennes des VFX et consommateur courant

2026-11-05 · V1324 · AUD-SYS-01.2-02-BLITZCRANK-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

SYS-01.2-02 ;CH-Blitzcrank-PASSIF-PRESENTATION-VFX,OLF-5dd7b42c-1f3a-5c70-a07d-046a5d0da3cc. Qualifier les vues Icon/Cooldown/active_chunk du reçu V544 non mappées par V1322,et les rapprocher des consumers nécessaires. Conserver le critère complet lancement/trajet/impact applicables,ses dépendances NETWORK,phases et lots ;aucun prérequis accepté implicitement.

Audit de ce lien borné clôturable après publication vérifiée. Implémentation non modifiée ;vérification documentaire/statique ;acceptation humaine non donnée. Nouvel inventaire exhaustif,lecture native,décodage,rendu exécuté et correction produit exclus. V1186SOURCE,V1200HUD et V544 restent des acquis distincts,non recomptés.

## 2. Sources, identités et portée

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Copie V1322 retenue :blitzcrank-passive-shield-links-v544.json,441186octets,SHA184e94afc243a8b725ce7b67a4cfa1a97cc37f48e8ac59bb4c6aa0f6a27468cf. Source inchangée,pas nouvel asset récupéré.

Deux cartes de littéraux explicites :native_metadata.icon,cinqchamps,ManaBarrierIcon.luaobj264octets/a7b50d65… ;cooldown,quatrechamps,ManaBarrierCooldown.luaobj232/87b32b71…. BuffName,icônes,PersistsThroughDeath,NonDispellable et priorité8 sont conservés,non callbacks exécutés. Le cooldown nomme BlitzcrankManaBarrierCD ;aucun alias appliqué implicitement.

Active_chunk ManaBarrier.luaobj365octets/SHAe7fa1d20de866343be74a8cb27847e846e1982597920ced97ab87151af36a6ae :21instructions,zéroprototypeenfant,lecture structurelle complète. Initialisation littérale non qualifiée :Unsupported control/data flow NEWTABLE atpc8 ;globals vide. Dixconstantes,dont AutoCooldownByLevel et DoOnPreDamageInExpirationOrder,ne deviennent pas des affectations ou règles. NEWTABLE est une limite du lecteur,pas une corruption ;aucune absence d’effet déduite.

Les textes20%PV/50%mana courant/10s/90s,préloads steamgolemshield/steamgolemshield_hit et anciennes identités restent hérités. Ni l’ordre d’activation ni une recette complète n’en découlent. Chaînes Alistar/tourelles/+PV/niveaux et fichiers NightmareBot non adoptés. Aucun accès D,analyse native ou comparaison de pixels nouvelle.

## 3. Consommateurs réels et réutilisation

Cinq fichiers courants inspectés :core lib,shields,damage,lifecycle et client projected_live. Identités concordantes avec les reçus HUD ou mécanismes communs ;14identités partagées V1315 inchangées. Dixancres exactes :Shield est déclaré dans shields.rs ;Champion transporte Vec<shields::Shield> ;grant_shield crée/rafraîchit,absorb_shields consomme les boucliers triés par expiration ;damage appelle l’absorption et retire effets/boucliers à la mort,lifecycle réinitialise les effets au retour. Ces voies génériques existent.

projected_live sélectionne explicitement Annie et sa ressource Q ;ce consumer ne devient pas un renderer Mana Barrier. Recherche nommée délimitée Blitzcrank/ManaBarrier/steamgolemshield :zérohit dans les cinq fichiers,pas une absence globale. Providers,attaches,spatial/owner et catalogues communs restent des briques,non une liaison d’état spécifique. Associations enregistrées conservées,sans nouvelle liaison de registre. Icônes HUD et récapitulatif de dégâts restent distincts du rendu en monde.

## 4. Attendu, observé et contrôles

Attendu :troisvues qualifiées avec valeurs/types/limites et consumers bornés,refus des extrapolations. Observé :38/38contrôles documentaires qualifiés ;42/42cohérence séparée du même agent sur le reçu original et cinqfichiers retenus. Neuflittéraux plats conservés ;active reste structurellement lu mais non qualifié littéralement. Nominal statique :création/absorption génériques identifiées. Limite :aucun producteur/rendu Mana Barrier établi dans ces corps.

Deux échecs de collecteurs conservés. inspect01 supposait un fichier blitzcrank_passive.rs inexistant ;inspect02 suit les preuves réelles. collect01 donnait34/38 :schéma attendu mal nommé,absorb_damage au lieu d’absorb_shields,Shield cherché dans lib plutôt que shields,orthographe de Default supposée. Quatre attentes corrigées depuis les octets retenus ;autres34prédicats et observations inchangés. Aucun produit ou qualificatif NEWTABLE changé pour passer.

Les deuxprofils V544 restent historiques :seuil franchi sans bouclier spécifique ;témoin100PV injecté par API générique,expiry300ticks distincte. Aucun replay,build,test Rust,jeu,GPU,réseau,REA ou sonde ce tour.

## 5. Écarts et inconnues

Recette visuelle,initialisation active,producteur d’état,timing,owner/skin,audience,ouverture/montage,attache,hit/retrait et rendu restent ouverts. Icon/Cooldown sans AutoBuff reconnu ne prouvent pas une absence native ;globals actif vide vient du lecteur. Priorité8 et flags de persistance ne donnent pas l’ordre serveur ou la mort. Déclenchement,égalité20%,échantillonnage/dépense du mana et timers ne sont pas qualifiés ici.

V1322 reste immuable ;ce supplément qualifie une vue ancienne partielle,non un inventaire complet. Aucun audit SOURCE complet,tâche VFX,feature,inconnue,acceptation ou goal clos. Empreintes vérifiées aux lectures,sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Blitzcrank-PASSIF-PRESENTATION-VFX :clauses secondary-recipe-source,state-owner-selection,resource-open-lifecycle-render. Préconditions,fin et reprise précises dans corrections_and_restart.json. Fin :sources/branches qualifiées sans confondre constantes et affectations ;état→consumer établi ou manque borné ;ressources/attaches/cycle/audiences observés avant acceptation visuelle. SOURCE/SIMULATION-CONTRAT/NETWORK et HUD conservent leurs périmètres. Aucune reconstruction de texture ne résout seule une recette inconnue.

Reprendre sur nouvelle capacité de lecteur vérifiée indépendamment,source/callsite/capture nommé,dérive ou anomalie pertinente ;pas de scan/replay inchangé. Prochain lot :CH-DrMundo-PASSIF-PRESENTATION-VFX,vue ancienne buff V542 et consumers nécessaires,à partir de la copie déjà retenue.

## 7. Livraison et cohérence

E:/mapslol3v3/audit_sys01202_blitzcrank_passive_vfx_20261105 :initial_scope,inspection,evidence_review original/qualified,evidence_qualification,coherence_review,corrections_and_restart,journaux/témoins. Relecture séparée du même agent,non indépendante ni acceptation humaine ;sept rubriques examinées.

Publication limitée au rapport et ajouts CURRENT/HANDOFF,sauvegardes exactes ;sept registres protégés identiques. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2311entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ;aucune installation,migration,relance,nettoyage ou mutation Git.
