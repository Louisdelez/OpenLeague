# SYS-01.2-02 — Maokai : liaison de Sap Magic au HUD, V1245

4 novembre 2026. Unité `AUD-SYS-01.2-02-MAOKAI-PASSIF-HUD-ICON-STATE-LINK-01`. Audit de liaison statique ; fonctionnement du passif et acceptation distincts.

## 1. Exigence et périmètre

`CH-Maokai-PASSIF-PRESENTATION-HUD`, `OLF-580df924-7bd9-5863-8d25-1d21ea0f16eb` : icône, texte, rang applicable, charges proches, Ready et soin. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. Inconnue `OLU-a6c50ec1-ceed-5ee7-aa79-ec85a1aee3fe` ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/maokai-passive-sap-magic-links-v600.json`,1465409 octets, SHA `e347ef72db3d40fa32658731ca5c27ce1509fe346a6b4468231f8e6629ff0d23`. UTC documentaire2026-10-26T08:27:50.567852+00:00 ; MD08:36:09.657879+00:00. Aucune date d’exécution déduite.

V600 :62 identités natives/186 associations/trois tâches,29 sites/58 liens. SOURCE :68 relations/62 identités. HUD :définition et CharScript client, pas un corps serveur. Métadonnées, INIBIN, Lua, preloads et font D réutilisés sans relecture ; historique Maokai ciblé copié sur E.

MaokaiSapMagicPass/Maokai_Passive.dds, six niveaux absents. Personnage4231 :charge par sort proche, cinq charges, prochain coup de base soignant7%PVmax. Buffs2267/2268/2269 distinguent Hot,Ready/Melee,Pass ; `@f1@`, rayon, lanceurs/sorts éligibles et ordre des événements non qualifiés. Pass PersistsThroughDeath ne démontre pas la conservation des charges au décès/respawn.

Pass SpellData conserve Bushwhack/Nidalee_Bushwhack, coût60/rayon600/portée900/coefficient0,4 ; ces champs ne définissent pas Sap Magic. Melee combine BuffData pertinent et tooltip JesterBasicAttack présent mais vide ; description MaokaiBasicAttack absente. Coefficients nuls≠soin nul ; textes mana40/60/80%≠progression du soin. PassiveReady et SapMagicReady sont des déclarations distinctes. HitSound/SwingSound/EAggroSound contiennent aussi des métadonnées d’effets main/yeux, sans audio exécuté.

Vingt-six Lua sans enfant :25 initialisations littérales, une limite NEWTABLE(pc10,QMissile), sans corruption ni callbacks serveur déduits. CharScriptMaokai et SapMagic vides. Quatorze preloads :SapMagic→Hot→Melee,global_heal et dépendances Sound, sans exécution/rendu/son qualifiés. Neuf bindings BuffData résolus ;26 références communautaires, CharScript seul établi vide. Six chemins candidats absents, dont Maokai.ddf ; fichiers réellement présents conservés, sans manque global d’assets déduit. Labels GlacialStorm/Cryophoenix,GemKnight,Bowmaster restent voisins.

Inventaire avant payload ; 3 chemins/7224 octets/3 contenus :

| Chemin lu | Octets | En-tête observé | Membre (lol_game_client0.0.1.7) |
|---|---:|---|---|
| DATA/Characters/Maokai/HUD/Icons2D/Maokai_Passive.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.1.7 |
| DATA/Characters/Maokai/HUD/Icons2D/Maokai_PassiveReady.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.1.7 |
| DATA/Characters/Maokai/HUD/Icons2D/Maokai_SapMagicReady.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.251 |

Trois identités dans Characters/Maokai/HUD/Icons2D :2176/2176/2872 octets,DXT1,64×64,mip brut0/0/7 ; membres0.0.1.7/0.0.1.7/0.0.0.251. Aucun alias runtime ni corruption déduit des en-têtes. Membership/MD5/SHA identifiés, sans lookup, pixels ou GPU qualifiés. Texte relié au témoin/mirror Ahri ; font D non relu, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :6 sites/3 fichiers, lecteurs INIBIN/Lua compris. V600 :29 sites/16 fichiers et deux lecteurs ; union18 fichiers/35 ancres. Initialisation, Action/Step/Snapshot, progression, dégâts, mêlée, régénération et Ruby examinés.

healing::heal/received_multiplier sont des API générales, sans appel artificiel ni producteur Maokai établi dans les chemins examinés. Les fonctions Annie Q/Pyromania/stun expliquent le contrôle opposant, pas le compteur Maokai. HUD/provider/barres/QWER restent partiels :4 enregistrements QWER/0 non résolus ne constituent pas charges/Ready/soin autoritaires.

## 4. Attendu, observé et contrôles

Attendu :cinq sorts proches admissibles, charge/Ready puis consommation et soin sur un vrai coup de base. Observé hérité :deux parties Map10, base/Ruby1028(+150PVmax), cinq Q ennemis Annie à150unités par cas(raw80/coût60), puis trois impacts de mêlée Maokai par cas. Dix Q/six coups/54 refus Maokai ; dégâts physiques/magiques et régénération contrôlés, résidus inférieurs à0,002.

PVmax572,200012/722,200012 ; avant premier coup294,53778/444,53778. Les277,66223PV manquants dépassent les références7%40,054/50,554, jamais présentées comme soins observés. Aucun supplément au-delà de la régénération, supplément0 au premier impact dans les deux cas. Le scénario proche/mêlée est réellement exercé malgré les refus de sorts propres ; rayon/éligibilité historiques et compteur restent ouverts.150 est une distance testée, pas le rayon maximal.

Cinquième Q étourdissant,38ticks de nettoyage avant mêlée ;432ticks d’attente de délais Q par cas, distincts des360ticks finaux(180/cas), sans durée de charges déduite. 202 frames conservent le résidu de soin0, pas tous les HP ; six impacts gardent leurs paires HP brutes. Les360 lignes finales contiennent les HP Maokai, delta0,057861328125.22 snapshots complets conservés. Refus :flags sans paires brutes. Gardes autorisant le stun pendant Q, puis stuns vides avant mêlée ; trajets limités au voyageur/winner, pas de garde universelle NPC. BUILD/RUN bruts0 ; inspection OBS passée, code numérique inconnu.

Sources93/93, relecture E210/210 ; consommateurs35/35, relecture E23/23. C158 courants/51 génération/union158 ; 102 fenêtres/35 ancres/21 configurations/63 chemins matériels. SOURCE :13 commandes enveloppées, un échec d’inventaire avant D(path générique erroné), correction bornée/deux parses E, producteur0. C :préflight[1,1,0](clé case/parenthèse AST), collecte/relecture uniques0 ; bootstrap exploratoire1 et lectures préparatoires erronées conservés séparément. 18 captures :13 anciens pins/5 origines supplémentaires. Resource SHA671e02af… désigne le JSON communautaire5405 octets, distinct du natifc4940698…/2395 octets. Les51 entrées de génération C sont déjà courantes.

Binaire historique6053888 octets, SHA `303b190c553d5adbce29ce7d94a7fd7afa4e0989da52d5606dd93e21f58f9b10`, inert ; ancien répertoire revision536_yasuo conservé. Aucun nouveau build, jeu, VM, REA, réseau, rendu, audio ou GPU.

## 5. Écarts et inconnues

Rayon/éligibilité/comptage, charges0..5/Ready/plafonnement, états initiaux et simultanéité restent ouverts. Consommation windup/impact/annulation, cibles disparues/immunisées, critiques et catégories de cibles non qualifiés. Producteur `@f1@`/7%PVmax, attribution, plafonnement/modificateurs, variation de PVmax et ordre dégâts/soin à établir. Plusieurs lanceurs/Maokai, lifecycle/persistance/nettoyage, HUD/icônes/animations/particules/son/réseau restent distincts.

## 6. Correction et reprise

Réutiliser `CH-Maokai-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Sourcer rayon et événements admissibles ; vérifier intérieur/frontière/extérieur, refus/interruptions/doublons et charges simultanées. Produire compteur/Ready et soin sur attaque réelle, avec montant, consommation et ordre qualifiés ; couvrir PVmax/objets/modificateurs/cibles/annulations/lifecycle. Relier l’état autoritaire au HUD, invalider données périmées/non autorisées. Séparer réseau/rendu/audio et acceptation humaine. Reprise sur preuve/mapping/producteur/consommateur nouveau ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_maokai_passive_hud_20261104`, sourceproof/current_consumer_review, manifestes, scripts, commandes, journaux, archives, result/finalpeer. Préparateur57f8545c/gate19cac4e4 byte-exacts V1244 ; inputs courants/génération/archives vérifiés. Publication après revue :rapport et ajouts CURRENT/HANDOFF, deux sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
