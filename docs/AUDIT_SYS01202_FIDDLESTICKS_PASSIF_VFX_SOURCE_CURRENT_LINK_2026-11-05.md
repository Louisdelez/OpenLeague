# FiddleSticks — sources et consommateurs des VFX de Dread

2026-11-05 · V1340 · AUD-SYS-01.2-02-FIDDLESTICKS-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-FiddleSticks-PASSIF-PRESENTATION-VFX, OLF-12d5b9c3-5625-587f-a643-99f6390c5f72. Relier les déclarations visuelles aux consommateurs courants ; distinguer aura source/cibles, réduction de résistance magique, pénétration, dégâts diagnostiques, HUD et sorts. Contrat lancement/trajet/impact applicable, dépendance CH-FiddleSticks-PASSIF-NETWORK et prérequis D06/lot conservés sans satisfaction implicite.

Fin : provenance, déclarations, chemins réels ou manque borné, contrôles et corrections vérifiables. Après publication vérifiée, seul ce lien documentaire est clos. Tâche VFX, aura complète, inventaire et acceptation restent ouverts.

## 2. Sources, provenance et déclarations

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Reçu V1322 fiddlesticks-passive-dread-links-v568.json : 554399 octets, SHA2269775dff8405699a0bf5c5783cdd29a6c90d359c5f60ed07617d2e11c4d816. Source externe E vérifiée avant interprétation, cadrage47716 octets sans incorporation du document complet ; hook inchangé, accélération non mesurée.

V568 conserve neuf identités parmi dix candidats. Trois vues /native_metadata/client_lua entièrement lues structurellement/littéralement, six affectations, aucun prototype enfant ni exécution serveur. CharScript56 octets vide ; Paranoia214 déclare icône/nom/PersistsThroughDeath/NonDispellable ; ParanoiaMissChance157 déclare « Paranoia Aura », sans politique de raté déduite du nom. Aucun AutoBuff dans ces vues ne démontre une absence d’effet.

Fearmonger_marker218, BuffName=Drain et Fearmonger_cas.troy sont explicitement exclus de l’autorité Dread ; Nocturne/Paranoia et textes Doom restent séparés. Passive1LuaName=Paranoia, icône Fiddlesticks_Paranoia.dds. Passive1/Passive1Desc et six niveaux nuls conservés sans defaults ; description de personnage candidate, sans liaison de champ inventée.

Découverte V1213 capturée E :343484 octets, SHAb98411c817cd348784e366fbbdb961913082b749147efab743ee484446adaab7. Original F/OpenLeague-work inerte. Deux preloads332 octets/quatre références : trois sorts, dont paranoiamisschance/paranoia/apbonusdamagetotowers, et fiddlesticks_dreadwarning_tar.troy. Préchargement ne prouve ni invocation ni recette, pose ou audience. Deux bindings bruts Paranoia/Paranoia Aura vers les tooltips conservés, sans alias automatique. Huit références communautaires dont CharScript132 vide, sans politique native qualifiée.

Deux DDS hérités,8448 octets, un contenu SHA8d5275a2d4b3a7cfb435cb4f8eddcfcfdef47dbd7c9dfeb5c0134db14321917f :64×64 DXT5, champ mip brut0. Chemins Info/Spells, membres core0.0.0.172/0.0.0.25 du projet0.0.1.7. Identités, headers et membership hérités ; lookup, priorité, pixels et rendu ouverts ; mip0 non déclaré corrompu.

Quatre textes en_GB2449/2450/4185/4361 : Dread réduit de10 la résistance magique des ennemis proches, décrit la cible et laisse @SourceName@ non résolu. Réduction cible distincte de pénétration lanceur ; aucun rework moderne importé. Locale effective et parser/rendu non qualifiés.

## 3. Consommateurs actuels

Neuf Rust relus : core damage.rs, penetration.rs, summoner_exhaust.rs, trundle_r.rs, world.rs, lib.rs, spells.rs, progression.rs ; client projected_live.rs. Vingt-deux ancres exactes. Vingt-deux comparaisons antérieures concordantes représentent18 chemins uniques, pas22 nouveaux consommateurs ;14 identités communes VFX et deux animations ordinaires inchangées.

Le producteur réel Simulation::stats est progression.rs:68 : base/croissance/objets, bonus Garen/Annie, Exhaust et ajustements Trundle R. Ces voies réelles ne sont pas Dread. penetrated_defenses lit les bonus des objets de la source ; apply_damage utilise stats, pénétration puis mitigation et boucliers, avec gardes source/cible/valeurs. Les unités portent leur MR séparément.

Exhaust possède sa durée et son modificateur ; Trundle R possède source/cible, transfert et retrait propres. Effects/advance/cast maintiennent leurs mécanismes existants ; cast retourne explicitement « champion spell not implemented » pour le chemin FiddleSticks inspecté. projected_live sélectionne Annie. Aucun producteur/événement Dread identifié dans ces corps ; recherche FiddleSticks/Paranoia/Dread nulle sur leurs neuf textes complets, sans absence globale.

Animation ordinaire V1336 réutilisée via les preuves V1339 et deux gardes exactes, sans nouvelle lecture sémantique ou pixels. Contexte HUD/transport antérieur conservé, sans nouvelle qualification UI/réseau.

## 4. Attendu, observé et contrôles

Attendu : déclarations/frontières qualifiées, acquis conservés et manque spécifique borné. Observé :74/74 contrôles documentaires,74/74 cohérences séparées du même agent,22 ancres ; gardes22/14/2 concordantes. V1213 source64/consommateur44/intégration36 hérités, non rejoués. Aucun test produit exécuté ici.

V568 : trois phases publiques à250 unités pendant300 ticks chacune ; cible Annie MR30/55 avec1033/30 près d’un témoin Garen,33 refus atomiques.250 est une distance d’essai, pas un rayon natif. Trois événements serveur diagnostiques apply_damage(100,Magical), séparés des phases publiques, donnent76.92308044/64.51612854/76.92308044 avec9 refus ; ni sorts ordinaires ni procs Dread.

Premier driver historique build0/run101 : mauvais chemin JSON bonuses.magic_resist ; driver qualified distinct build0/run0 conserve ce résultat initial. Ancien gate HUD42/43 et correction documentaire conservés. Aucun replay substitué. Une requête d’affichage actuelle a échoué en cherchant stats dans lib.rs ; root_context_failure.json la conserve, définition réelle progression.rs localisée et lue sous journal current02. Aucune ressource manquante déduite.

Sept opérations documentaires journalisées réussies. Aucun nouveau build, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, capture, réseau ou rendu.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, rayon/éligibilité, cumul/refresh/maintien, ordre avec modificateurs et résistances négatives, source/cibles/audiences, SourceName, owner/skin, pose/attache et cycle rendu ouverts. Mort/réapparition/reconnexion et mouvement V564 gardent leurs preuves séparées.

Inconnues VFX/SOURCE, consommateurs inscrits et V1322 conservés exactement. Zéro tâche complète, feature, inconnue, acceptation ou goal clos. Aucune garantie globale TOCTOU ni pourcentage du jeu déduit.

## 6. Corrections et reprise

Réutiliser CH-FiddleSticks-PASSIF-PRESENTATION-VFX : dread-warning-applicability-source, target-aura-producer-world-link et resource-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/animation restent distincts.

Reprendre sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale ou replay inchangé. Prochain lot CH-Fiora-PASSIF-PRESENTATION-VFX, à partir du candidat déjà retenu dans next_lot.json.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_vfx_20261105 : cadrage, inspections, gardes, evidence_review, coherence_review, requête de contexte échouée et journaux. Sept rubriques examinées ; relecture du même agent, ni revue indépendante ni acceptation humaine.

Publication : rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2327 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
