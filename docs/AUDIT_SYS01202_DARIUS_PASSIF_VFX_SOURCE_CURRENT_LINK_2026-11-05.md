# Darius — sources et consommateurs des VFX d’Hemorrhage

2026-11-05 · V1335 · AUD-SYS-01.2-02-DARIUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Darius-PASSIF-PRESENTATION-VFX, OLF-11930406-0cb9-5e6b-8279-0c3a12761ee2. Relier les déclarations Hemorrhage et les consommateurs courants ; distinguer saignement, vitesse, cumuls, HUD et QWER. Contrat : lancement/trajet/impact applicables ; dépendance CH-Darius-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin de cet audit : identité/portée des sources, chemins actuels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos. Implémentation générique conservée ; déclencheur et rendu spécifiques non établis dans les chemins inspectés. Vérification statique ; acceptation humaine non donnée ; inventaire VFX complet exclu.

## 2. Sources, déclarations et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Reçu V1322 darius-passive-hemorrhage-bleed-speed-links-v562.json : 564365 octets, SHA 902daf8d92e263b089deeba3d6dd6ab61a0a68614a20e36560c3eae8291a83ef. Source externe retenue, vérifiée avant interprétation ; cadrage56822octets sans incorporation du document complet, hook inchangé, gain de temps non mesuré.

/native_metadata/client_lua conserve six vues entièrement lues structurellement/littéralement, sans prototype enfant ni code serveur exécuté. Douze globals qualifiés : Hemo quatre, Internal deux, Marker quatre, SpeedKuoManager un, Visual un ; CharScript à la racine vide56octets. Hemo déclare DoesntTriggerSpellCasts et IsDeathRecapSource ; Marker nom/icône, PersistsThroughDeath et NonDispellable ; Speed et Visual gardent leurs flags distincts. Aucun AutoBuff dans ces vues, sans absence native d’effet déduite.

Passive1LuaName=DariusHemoMarker, icône Darius_Icon_Hemorrhage.dds. Passive1 et six champs de rang absents, descriptions héritées +40/+60/+80% régénération mana non adoptées. Quatre INIBIN retenus distinguent noms/tooltip et références brutes DeadlyVenom_Internal ; aucun alias ou règle Twitch importé.

V1207 avait capturé la découverte exacte sur E : 284582octets, SHA a6f83dac0abe00d25a8c6a4c5658f7c2acd23609c10f48fa7ed769f8bd100c21. Cette copie est réutilisée ; original F/OpenLeague-work inerte, non rouvert. Deux preloads846/1509octets sont vérifiés contre cette copie : douze références mixtes et dix-sept particules Hemo. Compteurs01..05, variantes minion, overhead_max_stack et suffixe littéral bleed_trail_only6 conservés ; aucun renommage vers5, aucune allocation/audience déduite. Références R/skin04 du CharScript restent contexte QWER, pas sélection du passif.

Deux DDS V1207, Characters/HUD et Spells, partagent SHA788ff3c5583e36e9a298df68a994e0f0ee1032236e57234dca8ce175168237a6 : 5616octets,64×64 DXT5,sept mips ; membres0.0.0.172/0.0.0.95 du projet0.0.1.7. Identités/header/membership hérités, pas nouveaux pixels ou lecture D. Quatre textes en_GB1815/1816/4177/4353 nomment SourceName, dégâts magiques sur cinq secondes, cinq cumuls et5%vitesse par champion ennemi ensanglanté. f1/f2, cadence et fournisseur restent ouverts ; aucune règle moderne de saignement physique/NoxianMight adoptée.

## 3. Consommateurs actuels conservés

Huit Rust relus : crates/core/src/attacks.rs, lifesteal.rs, movement.rs, damage.rs, spells.rs, summoner_ignite.rs, summoners.rs ; crates/client/src/projected_live.rs. Dix-sept ancres exactes. Vingt entrées antérieures concordent : onze core, deux lecteurs SOURCE, sept auxiliaires ; quatorze identités communes VFX inchangées. Ce ne sont pas vingt nouveaux producteurs.

advance_attacks échantillonne AD puis appelle basic_attack_hit Physical. movement_speed ajoute les bonus d’objets, puis effets/caps génériques, sans compte de champions ensanglantés dans ce corps. Effects et dispatch Ignite sont distincts : Burn, application True et avance périodique ne produisent pas Hemorrhage magique. mitigate accepte Magical/MR ; apply_damage et commit_death_recap restent génériques.

damage est vérifié au-delà de l’annotation cfg(test) d’un helper précoce ; aucun corps de production tronqué. projected_live filtre Annie. Recherche Darius/Hemo/Hemorrhage/DeadlyVenom nulle dans les huit textes complets, sans absence globale. Le contexte HUD/récapitulatif V1207 est conservé, sans nouvelle qualification d’UI ou de rendu.

## 4. Attendu, observé et contrôles

Attendu statique : qualifier déclarations et frontières, conserver génériques et borner le manque visuel. Observé : 80/80 contrôles documentaires,55/55 cohérences séparées du même agent,17ancres et gardes20/14 concordantes. Gardes/cibles/refus lus, non invoqués. V1207 source49/consommateur37/intégration32 hérités, non rejoués ; anciennes corrections d’attentes11fichiers/1509octets préservées.

V562 conserve quatre cas,16impacts Physical,720ticks après Stop et60refus atomiques dont48sorts. Résidu physique maximal0.0000190735 ; aucun dégât inexpliqué après arrêt. Vitesse340/365 avec bottes1001 et MR32.1/57.1 avec cape1033 sont des contrôles ordinaires. Cinq attaques ne prouvent pas cinq cumuls ; mitigation MR d’un saignement absent et bonus5% non qualifiés. Aucun nouveau replay, build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou pixels.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, f1/f2/SourceName, cadence/refresh/expiration, cumuls effectifs, attaques/sorts/multi-cibles, vitesse, owner/skin/audiences, pose/attache, montage et cycle de rendu ouverts. Preload, flag, DDS, vitesse, Ignite ou récapitulatif ne clôturent pas ces clauses. Identifiants inconnus VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucune progression du jeu déduite ; vérifications aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Darius-PASSIF-PRESENTATION-VFX : hemo-visual-applicability-source, bleed-stacks-speed-world-state-link et resource-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises précis dans corrections_and_restart.json ; SOURCE/NETWORK/HUD gardent leurs critères distincts.

Reprise sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente. Pas de nouvelle recherche globale ou replay inchangé. Prochain lot CH-Diana-PASSIF-PRESENTATION-VFX : reçu V563 conservé ; compteur, troisième coup, zone, animations et rendu distincts, sans réexécuter sa découverte.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_darius_passive_vfx_20261105 : initial_scope, inspection, current_inspection, evidence_review, coherence_review, gardes et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF, après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
