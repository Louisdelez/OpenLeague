# SYS-01.2-02 — Swain : Carrion Renewal et HUD, V1277

4 novembre 2026. Unité `AUD-SYS-01.2-02-SWAIN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Swain-PASSIF-PRESENTATION-HUD`, `OLF-fe5b27a0-afae-5d3d-86e2-18a43cd6e649` : relier restitution, icône et texte aux producteurs de mana et au HUD. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-9eb15b0a-6b2b-5998-9424-0081aadce69c` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Swain consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/swain-passive-carrion_renewal-links-v634.json`, 2485039 octets, SHA `a7bc4894393ce1007694787689aa5f8f27ae664a96ce884c6c821b3c9867e195`, UTC documentaire 2026-10-26T19:22:37.886445+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE : 52 relations, 49 identités, six sites/trois fichiers. V634 : 49 membres, 31 sites/14 fichiers ; union 16 fichiers/37 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 16 INIBIN, 17 Lua, 15 preloads et font ; aucun DDF dans les candidats sélectionnés, aucune relecture native de ces données.

Passive1LuaName=SwainDampeningFieldMana ; icône SwainCarrionRenewal.dds. BaseMP chaîne "324.0", MPPerLevel chaîne "50", BaseStaticMPRegen numérique 1.2000000000000002. PARType/Passive1Desc/Passive1/niveaux absents. CharScript vide de 56 octets ; sorts dans DATA/Spells. Quatre candidats absents ne prouvent aucune corruption globale.

Font2735 : élimination d’un ennemi ordinaire, 9 + 1 par niveau ; élimination de champion ou assistance, **à la place 9% du mana maximum**. Description4284 moins précise, branche champion omise. Producteurs f1/f2, événements et arrondis non qualifiés. Six BuffData : cinq correspondances exactes, clé SwainDecrepify non résolue. SpellDamageRatio=1, persistance et non-dissipation ne définissent ni restitution ni lifecycle. Trois limites NEWTABLE MetaHeal/MetaHealTorment/MetaNuke ; pas de callback serveur exécuté. SpellToggleSlot=4.0 ne prouve pas une bascule effective.

21 références communautaires comparatives : cadence Q, délai/rayon W, Torment et forme R restent non autorité native. Producteurs SwainTorment/SwainRavenForm non retrouvés dans l’arbre sélectionné, aucune absence mondiale déduite.

Un DDS partagé nécessaire, `DATA/Spells/Icons2D/SwainCarrionRenewal.dds` : 2872 octets, 64×64 DXT1, sept mips, SHA `885bbf425b6a44d5c4636c42c40314839ef18599e1b5974af4ed3a30a53a16fe`. Projet RADS0.0.1.7/membre0.0.0.25, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun fichier étranger/particule lu. Lookup, provider et pixels ouverts. Font miroir et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie le StatsJSON communautaire, 5656 octets/SHA `c817239c1ac88ae154fe674d9c1ed09ffaa64b5ca4668aa9fabcadeec3f9acd0`, distinct de l’INIBIN natif 1721 octets/SHA `c29940bd44601e93e094a5c279d6adf07be67d06c538a2169303b2cc084980a0` ; voir resource_provenance.json.

## 3. Consommateurs actuels

37 ancres et 29 fichiers code/configuration vérifiés, avec 16 entrées communes inchangées. Aucun producteur nommé Swain/Carrion/DampeningField dans le périmètre Rust sélectionné ; absence bornée.

champion_kills.rs:26/32 enregistre contributions, élimination/assistances, scores, or, expérience et événement, sans mutation mana ni branche Swain. regeneration.rs fournit la régénération plafonnée ; progression.rs distingue croissance et niveau ; interactions.rs:79 traite la fontaine. shop.rs:248/314 augmente la capacité via Saphir sans remplir le mana courant. native_hud_bars.rs:11 expose une fraction Mana générique, sans qualifier la présentation du passif. Attribution support/soin/bouclier/pet non qualifiée.

## 4. Attendu, observé et contrôles

Quatre cas publics, base/Saphir × élimination/assistance : capacités 324/524. Deux achats Saphir1027 ajoutent 200 au maximum sans remplir les 324 courants ; aucune vente/rachat ni injection. Géométrie recalculée : achat admissible près du bord boutique, hors fontaine (>1050). Tous les acteurs restent niveau1 ; une élimination créditée à Swain ou une assistance, vérifiées dans chaque événement.

Attendu champion : 29,16 ou 47,16 mana selon capacité. Deux contrôles au plafond324 non discriminants. Avec Saphir, élimination tick2437 : mana381.8123474121094, déficit142.18765258789062 ; assistance tick2301 : mana376.3711853027344, déficit147.62881469726562. Les deux déficits dépassent47,16 ; observé seulement régénération, aucun bonus supplémentaire. Recalcul indépendant f32 à 1,2/s, 30ticks/s, plafonné, sur 2084 trames de combat et 124 après décès. Écart f32 47.160003662109375 conservé, politique historique d’arrondi ouverte.

48 impacts, 28 projectiles Swain/20 mêlées Garen, quatre morts, deux kills/deux assistances, 112 refus et 16 arrivées contrôlés. Chaque terme de régénération/clamp des PV cible n’est pas reconstitué ; soin non qualifié. Refus par flags, aucune garde NPC universelle. Refus des sorts Swain sans incidence sur l’exercice du déclencheur élimination/assistance. Branche ennemis ordinaires, niveaux2–18 et frontières non exercés.

Historique : 15 fichiers/13216822 octets, 13 empreintes anciennes concordantes/deux identités nouvelles. JSON brut RUN identique au relevé. Binaire 6191104 octets/SHA `e4ef2c64d2571b119277011e9969a23963a3b77f6a39c4e04d7c9b1e97f0fb43` conservé inerte, BUILD/RUN0 hérités. Contrôles91/91 et cohérence81/81 séparée du même agent ; productions actuelles journalisées sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau, ni revue indépendante/humaine.

## 5. Écarts et inconnues

Restitution champion manquante dans les deux cas discriminants. Contrat serveur, branche ordinaire, niveaux, cibles/assistances, ordre, arrondis, plafonnement, lifecycle, bindings, provider, transport et pixels ouverts. QWER, V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION/NETWORK/HUD. `COR-SWAIN-CARRION-POLICY-01` : qualifier les deux branches, éligibilité, f1/f2, niveaux, arrondis et ordre. Fin : contrat historique sourcé distinguant remplacement9% et montant ordinaire.

`COR-SWAIN-CARRION-MANA-RESTORE-01` : relier événement admissible et mana autoritaire. Fin : élimination, assistance, unités ordinaires, plafonds, refus, niveaux, événements multiples et lifecycle vérifiés selon contrat ; conserver régénération/Saphir/contrôles plafonnés. Les sorts propres ne sont pas un prérequis de ce déclencheur.

`COR-SWAIN-CARRION-HUD-BINDINGS-01` : relier icône, texte et restitution au bon événement/état. Fin : valeurs, transitions, transport et pixels observés. Reprendre sur preuve serveur/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit dans cet audit.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_swain_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés contrôlés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
