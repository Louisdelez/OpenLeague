# V1460 — Cassiopeia : contrat connu d’Aspect of the Serpent

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-CASSIOPEIA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Cassiopeia-PASSIF-SIMULATION-CONTRAT, exigence OLF-9cff224c-4996-5896-92b5-ea169e6e732e, parent SYS-01.2-02. Audit borné de dix-huit branches connues et de leurs consommateurs sélectionnés. Tâche complète, passif et goal restent ouverts. SOURCE reste a_qualifier ; contexte de phase et de lot conservé.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Aspect of the Serpent conserve l’alias DeadlyCadence ; aucun passif ancien de réduction de mana ni passif moderne substitué.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/cassiopeia-passive-aspect_of_the_serpent-links-v661.json : 2 853 213 octets, SHA256 070af8e81ca39031051eff9725d9442e7055b1547583304191dcc629ffe865ed. Rapport V661 : SHA256 ee7db4fe3ca21f2f24d27375d88b2cfa5a737d65f44d24b40c4fdfaf0edc4f7b. Reçus réutilisés, sans republication de V661 ni nouveau lot SOURCE.

Les 31 ressources natives sélectionnées restent distinctes des 53 candidates, 22 références communautaires et 14 exclusions historiques. Dix-huit Lua entièrement parsés donnent 124 globals littéraux ; onze Lua sélectionnés donnent 79 globals. Aucun prototype enfant, aucune limite littérale recensée ; cela ne fournit pas les callbacks serveur.

Quatorze clés en_GB vérifiées dans le miroir F identifié : douze présentes, PoisonTickerLockout et PoisonParticleManager absentes. Ces deux chunks conservent BuffName CassiopeiaNoxiousBlastHaste ; aucun alias réécrit. Deux DDF de même nom restent séparés par chemin complet : quatre lignes à la racine, huit dans Localization. Seul lien renseigné : TwinFang f1→spelldamage, coefficient 0,55 ; il ne résout ni f2 du tooltip E ni les paliers.

Les champs et six niveaux absents restent inconnus. PersistsThroughDeath/NonDispellable et Global_Poison.troy sont des métadonnées, sans preuve d’exécution. Le hash de champion_resources renvoie au JSON communautaire Stats a08181…, distinct de l’INIBIN natif 3ac382… ; cette différence de contenu n’est pas une corruption. Identités conservées comme données inertes ; aucun accès D/F-work/EXE.

## 3. Consommateurs actuels

Vingt-cinq entrées — seize Rust, deux lecteurs Python et sept JSON — concordent avec V661 ; vingt-huit identités courantes gardées. Trente-et-une fenêtres : 28 communes réutilisées, trois nouvelles pour healing.rs, cooldown.rs et le témoin Annie Q. Vingt-six ancres enregistrées : catalogue et 25 frontières génériques, sans producteur Aspect qualifié.

lib.rs porte état, commandes, tick et snapshot ; progression.rs les stats ; attacks.rs/lifesteal.rs les attaques ; damage.rs/world.rs les dégâts et cibles ; healing.rs la réception des soins ; shop.rs et cooldown.rs les bonus et délais ; lifecycle.rs le cycle de vie. spells.rs/annie_w.rs délimitent les refus Cassiopeia. Lecteurs INIBIN/Lua inspectés séparément des producteurs de jeu.

Les recherches V661 sur 639 Rust et 799 sources communautaires sont héritées, non relancées. Zéro hit Rust historique ; trois références C# à CassPoison, sans définition retrouvée dans ce périmètre. Le doublement E communautaire n’est pas adopté. Ces recherches ne prouvent aucune absence globale ; seuls les 25 fichiers sélectionnés sont revalidés ici.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, bindings et rôles conformes aux preuves admises, écarts explicites. Observé : 54/54 contrôles et 60/60 cohérences du même agent. Cinq opérations journalisées : quatre réussies, échec contract01 conservé. Son prédicat exigeait f3 dans le tooltip principal ; contract02 vérifie sa présence dans les paliers et son absence dans ce texte principal. Un seul prédicat changé, sources et tableau des rôles inchangés.

V661 hérité, non rejoué : quatre cas, deux Cassiopeia et deux Annie, niveaux 1/18 ; quatre attaques ordinaires, huit témoins API magiques à 40, quatre achats Codex3108 et quatre contrôles de soin. Codex coûte 820 sur 825 or et apporte 30 AP/10% CDR ; ces valeurs viennent de l’objet. Soin API 25, puis 55 au plafond et zéro, sans qualification TwinFang.

Deux Annie Q produisent 104 bruts et cooldown 108 ticks ; six apports XP serveur, huit trajets publics, 9 274 ticks, 70 refus publics et 40 API. Aucun de ces témoins n’est un déclencheur natif Aspect. Sorts Cassiopeia refusés ; fenêtres calmes de 151 ticks sans poison ne testent pas les charges. Aucune nouvelle compilation, exécution du jeu, analyse native, REA, capture réseau/rendu/audio ou acceptation humaine.

## 5. Contrat connu et inconnues

Trois gains écrits : une charge par seconde de poison sur champion ennemi, par unité empoisonnée tuée et par touche TwinFang sur champion ennemi. Texte de cap, trois paliers, AP, soin TwinFang et CDR ; fournisseurs numériques non qualifiés.

Les paramètres sont propres au binding : f5 vaut seuil dans PoisonTicker et soin dans les suivants ; f7 vaut prochain seuil dans Ticker2 et CDR dans Ticker3/4. f3 est AP dans les paliers, absent du texte principal. Aucun seuil, cap ou pourcentage inventé.

Les dix-huit branches conservent ouvertes ownership du poison, cadence, cibles multiples, kill/crédit, impacts admis, compteur/concurrence, seuils, composition AP, soin/réduction reçue, CDR/plafond, lockout, persistance, audiences et présentation. La cible champion pour le gain TwinFang reste distincte de « enemy » dans le texte du soin. E décrit séparément 0,5 s sur cible empoisonnée et restitution coût+3% mana totale au kill ; ces dépendances ne sont pas les paliers du passif.

## 6. Corrections et reprise

Treize fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-CASSIOPEIA-ASPECT-, suffixe -01 :

- AUTHORITY : fournisseurs, bindings, niveaux et aliases.
- POISON-STATE : applications, propriétaires et éligibilité.
- POISON-TIME : cadence des charges sur champion.
- KILL-STACK : décès empoisonné et crédit unique.
- TWINFANG-STACK : impact champion et attribution.
- COUNTER-TIERS : compteur, cap et transitions.
- AP-BONUS : bases, composition et arrondis.
- TWINFANG-HEAL : déblocage, montant et réceptions.
- CDR-BONUS : palier, cumul et délais effectifs.
- TWINFANG-DEPENDENCIES : poison, délai E et restitution.
- LIFECYCLE : mort, dispel, équipes et reprise.
- PROJECTION : compteur/palier partagé et audiences.
- VERIFICATION : parcours réels et témoins séparés.

Chaque fiche référence une tâche présente dans V661, ses prérequis, travail, fin propre et reprise sur source précise, dérive ou contradiction. Correction fonctionnelle sous autorisation distincte. Inconnues et dépendances conservées. Prochaine sélection : Chogath dans la projection de 122 paires, sans assimilation à une clôture.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_cassiopeia_passive_simulation_contract_20261106, matrices, scripts, journaux, qualification du prédicat et identités. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2 446 entrées groupées modifiées au resume, conservées.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et inconnues ouvertes. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés.
