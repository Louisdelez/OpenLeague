# SYS-01.2-02 — V1307 Zyra : Rise of the Thorns, mort, tir et HUD

## 1. Périmètre et prérequis

2026-11-05,F:/OpenLeague. Unité `AUD-SYS-01.2-02-ZYRA-PASSIF-HUD-ICON-STATE-LINK-01`,tâche `CH-Zyra-PASSIF-PRESENTATION-HUD`,exigence `OLF-b60bf9c8-c7c5-59af-9895-4b0e81d46add`,inconnue `OLU-9f8e30ad-b57d-50ba-b797-f2cb5e913845`. Audit documentaire borné du lien HUD terminé ;six contrats/questions conservés,HUD a_faire,implémentation/acceptation false,NETWORK ouvert. D06/D06-CH-Zyra et prérequis dans phase_package_prerequisites.json,sans acceptation présumée. SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Goal/Plan/UI/bases/registres/produit conservés.

## 2. Sources et provenance native

[V658](reference_requirement_trace_sources/zyra-passive-rise_of_thorns-links-v658.json),4064403octets/SHA `0544dc4753ae5c3996d4e587d3425b8398b614fd1a7be51062f18c4f9947b735`,UTC hérité `2026-10-27T04:24:46.452268+00:00`. SOURCE42relations/39IDs :12INIBIN,15Lua,10preload,DDF,font ;memberships conservés concordants. Zyra.inibin2472octets/SHA `b96ea240a1c0b622ad98f2aba59e4a9b5f08571a4cc9820c5ff4bd77acc060ec` :ZyraPassiveDeathDisplay/ZyraP.dds ;Passive1/Desc/Level1..6 null,pas zéro.

Font miroir exact4497/4321/3007/3008/12069/12070 :forme après mort,tir par compétence vers curseur après2secondes,@f1@dégâts bruts aux ennemis traversés,durée8secondes. Fire!/0mana/0seconde ne qualifient pas la disponibilité/recharge native. Deux références Absolute_Zero_Slow ne trouvent pas de clé dans ce font exact,sans réécriture automatique.

56Lua entièrement consommés,sans fonctions enfants,21limites NEWTABLE. Quinze chunks sélectionnés par chemin complet ;les deux CharScriptZyraThornPlant56octets homonymes restent distincts. Huit dépendances de personnages conservées ;6PV/BaseDamage−2 de ZyraPassive ne démontrent ni spawn ni dégâts. DDF44lignes,seul ZyraSeed;f1=17/16/15/14/13 renseigné,distinct du passif. Coefficients legacy et références KogMaw/Akali/Morgana/Ezreal/Caitlyn non adoptés comme producteurs f1. Persistance/non-dispellable ne sont pas des callbacks.

resource_provenance :ZyraP.dds propreInfo et partagéSpells/Icons2D,2872octets chacun,64×64 DXT1/mip7,membre0.0.0.111,même SHA `0eb88fa1925807ac7b1d2a8c342b2c25276553a21213f12b6b76bddd23cef9a2`. Sélection E avant lectures SOURCE ;taille/MD5/en-têtes concordent au manifeste0.0.1.7. DeathDisplay/Sound déclarent KogMaw_IcathianSurprise :non résolu sous own/shared,seulement deux candidats KogMaw/KogMawDead HUD2872octets membres252/251,manifeste uniquement. Pas d’absence globale ni de substitution arbitraire. Métadonnées natives non relues ;montage/priorité/pixels/GPU ouverts.

## 3. Consommateurs actuels

28ancres sur14fichiers hérités ;34fichiers code/configuration,16communs et21identités V658 inchangés. command bloque le champion mort avant le dispatch ;apply_damage/heal,lifecycle::advance_respawns,base_death_ticks et régénération existent. Aucun hook Zyra/PQueen/RiseoftheThorns dans les seuls fichiers Rust examinés.

HP/Mana HUD conservés,ressource Mana. Consommateur réel native_hud_respawn::countdown,4926octets/SHA `9679823839140de95f06d109890ee970fe02e5c454360a2a2ff9c63e08e2892e`,inchangé :garde mort/fin de partie,respawn_at−tick saturé,arrondi supérieur en secondes ;connexion/session contrôlent visibilité. Cette voie ordinaire ne produit ni forme,tir,prêt après2s ou tooltip f1. Calcul dérivé statiquement,sans exécution Rust/Bevy/rendu ;parité horloge/formatter natifs ouverte.

## 4. Attendu, observé et vérifications

342/342 contrôles documentaires,310/310 cohérence séparée du même agent. Six archives6781239octets,RUN JSON intégral identique à OBS,BUILD/RUN0 hérités. Binaire6085120octets/SHA `9da4d1eaa170dd56cac37fcce3b5de325435b7e0220cf79a46da81d5f038cf43` hérité,non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

Quatre cas Zyra/Annie1/18 :huit paires PV fatales par API environnementale100000True,huit réapparitions ordinaires480/1110ticks (16/37secondes de la table actuelle),huitarrivées Move/Stop,six attributions XP diagnostiques. Première mort près de l’ennemi,seconde à la base. Les snapshots conservent PV0/respawn_at puis PVmax/retour à spawn ;cela n’active pas le passif.

Onze états conservés par mort,soit88 :offsets0/1/59/60/61/239/240/241/délai−1/délai/délai+1. Les88PV ennemis concordent avec la régénération f32 et le plafond,reconstruits entre points. Les listes de plantes sont vides aux points ;les contrôles chaque tick de plantes/projectiles restent des assertions héritées du collecteur,pas toutes les frames brutes ni une capture visuelle.

Sept fenêtres0/59/60/61/239/240/241 par mort :672refus publics «champion dead» ;48refus supplémentaires de sorts Zyra vivant.720flags d’invariance,sans toutes les paires de snapshots individuelles.16refus API sur morts et12refus True invalides donnent28flags API. Stop accepté après respawn est également une assertion conservée.

Quatre paires PV de contrôle API40True recalculées,sans mitigation,sans avance du tick ;ce trajet n’est ni une compétence publique ni le projectile natif. Total14076ticks=2904+4164+2874+4134,sans toutes les frames.

## 5. Écarts et limites

Restent f1/progression,origine/bornes des temporisations2s/8s,forme/entité,autorisation des slots après mort,direction au curseur,consommation du tir. Portée/vitesse/largeur/collisions/traversée,dégâts/boucliers/cibles,disponibilité et recharge non qualifiés. L’absence d’activation et une seconde mort ne prouvent pas la recharge. Rendu/animations/particules/audio/réseau restent séparés. Aucun échec nouveau des producteurs.

## 6. Corrections et conditions de reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/PRESENTATION-HUD/ACCEPTANCE existants ;sous-objectifs proposés,sans ajout au registre :

- `COR-ZYRA-NATIVE-PASSIVE-POLICY-01` :qualifier f1,niveaux,timers,bornes,cibles/disponibilité sur source4.20 ;conserver les inconnues.
- `COR-ZYRA-POSTDEATH-FORM-01` :produire l’état/entité qualifié ;vérifier mort,2s,8s,expiration et compatibilité avec le respawn ordinaire.
- `COR-ZYRA-POSTDEATH-INPUT-01` :autoriser précisément la commande qualifiée après mort ;vérifier slots,curseur,refus précoces/expirés et consommation unique.
- `COR-ZYRA-THORN-PROJECTILE-01` :relier origine/direction/trajectoire/collisions qualifiées ;vérifier témoins hors trajectoire et plusieurs cibles traversées.
- `COR-ZYRA-THORN-TRUE-DAMAGE-01` :appliquer f1 qualifié à l’impact ;vérifier PV,boucliers et immunités,sans adopter le contrôle API40 comme sort.
- `COR-ZYRA-PASSIVE-LIFECYCLE-01` :qualifier disponibilité,recharge,mort répétée,reconnexion/fin de partie ;vérifier avant/après activation.
- `COR-ZYRA-ICON-PROVIDER-PATH-01` :résoudre ZyraP/KogMaw et les références absentes avec provenance ;vérifier chemin réel sans remplacement supposé.
- `COR-ZYRA-HUD-BINDINGS-01` :lier icône/tooltip f1,états mort-prêt-tir-expiré à l’autorité ;vérifier transitions en préservant HP/Mana/compteur ordinaire.

Reprendre sur nouvelle source,consommateur modifié ou contrôle nécessaire autorisé. Suite :consolider les IDs d’audits HUD de passifs et choisir le prochain lien non audité,sans rejouer les lots clos.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF ;octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_zyra_passive_hud_20261105 :evidence_review,coherence_review,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2294entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ;même agent,sans acceptation indépendante/humaine.
