# SYS-01.2-02 — Master Yi : liaison de Double Strike au HUD, V1246

4 novembre 2026. Unité `AUD-SYS-01.2-02-MASTERYI-PASSIF-HUD-ICON-STATE-LINK-01`. Audit de liaison statique ; fonctionnement du passif et acceptation distincts.

## 1. Exigence et périmètre

`CH-MasterYi-PASSIF-PRESENTATION-HUD`, `OLF-e67d3163-8609-51c7-a60c-6de709bdf042` : icônes, texte, rang applicable, compteur consécutif, Ready et second coup. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. Inconnue `OLU-06d6faa4-817e-5df4-a53b-c30945d25798` ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/masteryi-passive-double-strike-links-v601.json`,1431982 octets, SHA `c4dea546a2e980b2728f61d0fad7d964fa4c7c86411a3b7ef1c6ece8bba38004`. UTC documentaire2026-10-26T08:42:51.603877+00:00 ; MD08:50:45.291619+00:00. Aucune date d’exécution déduite.

V601 :54 identités natives/162 associations/trois tâches,23 sites/46 liens. SOURCE :60 relations/54 identités. HUD :définition et CharScript client, pas un corps serveur. Métadonnées, INIBIN, Lua, DDF, preloads et font D réutilisés sans relecture ; historique MasterYi ciblé copié sur E.

Collect01 a lu annie_q_rules.json/annie_e_rules.json sans conserver leurs empreintes. Le supplément Root capture leur état actuel ; il ne prouve pas rétroactivement leurs hashes lors de l’échec.

MasterYiPassive/MasterYi_Passive1.dds/ExtraSpell1 MasterYiDoubleStrike, six niveaux absents. Personnage4232 reste vague(quelques coups) ; Buff2278 décrit la quatrième attaque de base consécutive avec second coup à50%. Stacks1841 précise la quatrième,Ready1840 le prochain coup double. Ancien texte probabiliste et mana40/60/80% conservés sans adoption. Dix bindings BuffData :neuf résolus, `game_buff_tooltip_DoubleStrike` absent, sans remplacement par Ready/Stacks.

MasterYiDoubleStrike SpellData :tooltip présent mais vide, description personnage, portée20/rayon100/coût-délai0/coefficients0,0 ; aucun dégât secondaire nul déduit. CanCrit/ApplyOnHitEffects absents(None) ne valent pas false. DoubleStrike.luaobj configure Ready/Passive1 ; Stacks utilise Passive2. Persistance/non-dissipation de Stacks/Passive restent des métadonnées, sans durée ou comportement mort/respawn qualifiés.

Vingt-trois Lua sans enfant :14 initialisations littérales/9 limites NEWTABLE, sans corruption ni callbacks serveur déduits ; CharScript vide. Onze preloads restent des dépendances. Seize lignes DDF QWER(AlphaStrike0,6AD/WujuStyle0,1–0,2AD) ne donnent pas la formule du passif. Vingt-trois références communautaires, CharScript seul établi vide ; six chemins candidats absents bornés, sans manque global d’assets déduit.

Inventaire avant payload ; 2 chemins/4352 octets/2 contenus :

| Chemin lu | Octets | En-tête observé | Membre (lol_game_client0.0.1.7) |
|---|---:|---|---|
| DATA/Characters/MasterYi/HUD/Icons2D/MasterYi_Passive1.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.172 |
| DATA/Characters/MasterYi/HUD/Icons2D/MasterYi_Passive2.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.172 |

Passive1/Passive2 distincts dans Characters/MasterYi/HUD/Icons2D :deux2176 octets,DXT1,64×64,mip brut0,membre0.0.0.172. Aucun alias runtime ni corruption déduit des en-têtes. Membership/MD5/SHA identifiés, sans lookup, pixels ou GPU qualifiés. Texte relié au témoin/mirror Ahri ; font D non relu, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :6 sites/3 fichiers, lecteurs INIBIN/Lua compris. V601 :23 sites/12 fichiers et deux lecteurs ; union14 fichiers/29 ancres. Initialisation, Action/Step/Snapshot, progression, attaques, dégâts, régénération et objets examinés.

basic_attack_hit et roll_critical traitent les contrôles ordinaires ; chance critique0 dans ces cas, sans règle de critique secondaire démontrée. Aucun producteur propre de compteur/Ready/second coup établi dans les chemins examinés ; aucune frappe secondaire artificielle injectée. HUD/provider/barres/QWER restent partiels :4 enregistrements QWER/0 non résolus ne constituent pas les charges/Ready autoritaires.

## 4. Attendu, observé et contrôles

Attendu :attaques admissibles comptées, Ready puis seconde frappe conforme au contrat sourcé. Observé hérité :trois parties Map10 MasterYi→Annie, base/LongSword/Dagger ; huit impacts de mêlée ordinaires chacun,24 au total. AD60,04/70,04/60,04 ; sept intervalles constants par cas44/44/38ticks. Épée+10AD et dague qualifient ces contrôles ordinaires, pas l’héritage ou le timing du second coup.

Dégâts physiques après armure/régénération, résidus inférieurs à0,002, aucun critique observé. Le premier candidat(quatrième attaque) et les huit coups restent ordinaires. Les attaques acceptées exercent le scénario malgré les sorts propres refusés ; l’auto-comptage du second coup étant inconnu, les coups4/8 ne fixent pas les cycles suivants.

81 refus,540ticks après Stop(180/cas), sans durée de reset déduite. 24 paires HP cible permettent le recalcul des impacts.917 trames et540 lignes finales omettent les HP :21 intervalles/3points finaux seulement recontrôlables, assertions/flags pour l’intérieur.18 snapshots complets,NPC18→42/42/34. Refus :flags sans paires brutes ; gardes de trajet limitées au voyageur/winner. BUILD/RUN bruts0 ; inspection OBS passée, code numérique inconnu.

Sources86/86, relecture E193/193 ; consommateurs21/21, relecture E23/23. C146 courants/58 génération/union146 ; 99 fenêtres/29 ancres/19 configurations/59 chemins matériels. SOURCE :10 commandes0/producteur unique0. C :collecte[1,0], attendu explicites=compilées corrigé ;19configs explicites/18noms compilés,collision conservée. Supplément12/12 :deux fichiers actuels identiques aux pinsV1245, refus volontaire après journalisation1 attendu/observé ; aucune identité collect01 reconstruite. Resource SHA36e9e758… désigne le JSON communautaire5236 octets, distinct du natif05916e9e…/1866 octets. Les58 inputs de génération C sont déjà courants.

Binaire historique6043136 octets, SHA `892df60cc21a59a4e5ed26d9fdb14cef1a0130d06c3f1e3abf79f4550873bbde`, inert ; ancien répertoire revision536_yasuo conservé. Aucun nouveau build, jeu, VM, REA, réseau, rendu, audio ou GPU.

## 5. Écarts et inconnues

Compteur/reset/auto-comptage, seconde frappe/timing/50%/AD, critique/onhit/protections/attribution, annulations/cibles/simultanéité, QWER/objets/lifecycle et présentation/réseau restent ouverts. Les hashes AnnieQ/E de collect01 sont inconnus ; aucun résultat abandonné ne soutient la conclusion. Les captures actuelles et leurs comparaisons antérieures ne remplacent pas un reçu brut daté de cette tentative.

## 6. Correction et reprise

Réutiliser `CH-MasterYi-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier compteur/Ready, premier cycle/suivants et auto-comptage, puis seconde frappe autoritaire ; couvrir interruptions/cibles/critique/onhit/interactions/lifecycle. Relier l’état fiable au HUD et résoudre le tooltip sans alias. Réseau/rendu/audio/acceptation distincts ; reprise sur preuve/mapping/code nouveau ou dérive.

Méthode `COR-SYS01202-AUDIT-INPUT-PREFLIGHT-PINS-01` :journal matériel avant assertion. Helper appliqué au supplément et testé par refus après sauvegarde ; adoption aux collecteurs futurs à faire. Pour affirmer les identités exactes collect01, exiger leur reçu historique daté ; sinon conserver l’inconnue.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_masteryi_passive_hud_20261104`, composants gelés, scripts/journaux/archives, result/finalpeer et root_supplement. Préparateur57f8545c/gate19cac4e4 byte-exacts V1245 :paquet réussi vérifié, pas toutes les lectures historiques. Supplément courant contrôlé séparément ; limite collect01 conservée. Publication après revue :rapport/CURRENT/HANDOFF, deux sauvegardes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
