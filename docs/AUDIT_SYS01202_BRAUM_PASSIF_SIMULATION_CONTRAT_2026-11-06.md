# V1458 — Braum : contrat connu de Concussive Blows

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-BRAUM-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Braum-PASSIF-SIMULATION-CONTRAT, exigence OLF-a416e22a-8b72-5c04-8769-6f5460adcd80, parent SYS-01.2-02. Audit borné de seize branches connues et de leurs écarts face aux consommateurs sélectionnés. La tâche complète, l’implémentation et le goal restent ouverts. Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

## 2. Sources, provenance et limites

Reçu V660 docs/reference_requirement_trace_sources/braum-passive-concussive_blows-links-v660.json : 6 042 989 octets, SHA256 de13a54bff2c5c88e74f9417df842ca41254a9f45c3f4772927d99c6e868f94f. Audit SOURCE V1188 publié, résultat d0055a3588779fa6ccc511a99d3b3360bc18414b539420ca88be1941645ae68a, quinze contrôles, réutilisé avec sa préparation antérieure conservée.

Les 26 identités natives sélectionnées sont distinctes du relevé historique de 290 ressources, dont 181 Deprecated. Les 125 chunks Lua historiques comprennent 80 vues littérales qualifiées, 260 globals et 45 limites de lecteur. Parmi les dix Lua courants sélectionnés : neuf vues, 27 globals ; BraumBasicAttackPassiveOverride reste inconnu au NEWTABLE pc0, avec raw {} conservé. Cette limite ne prouve ni absence de code ni corruption. Six homonymes Q/E/W restent séparés par chemin complet, dont les chemins Deprecated.

Onze bindings en_GB représentent neuf clés distinctes : huit présentes, game_buff_tooltip_BraumMarkDiminish absente. L’identité du miroir F correspond à la preuve héritée ; lookup ne qualifie pas un fournisseur actif. DDF : 48 lignes, neuf renseignées, ancien lien MarkDamage non adopté. Kennen, Leona, Taric et Maokai restent des noms littéraux, sans import de leurs mécaniques. Disponibilité historique et corps serveur non qualifiés. Aucun accès natif nouveau ; les chemins historiques et l’identité de l’ancien EXE restent des données inertes.

## 3. Consommateurs réels

Trente-trois fenêtres SOURCE sont reprises avec lignes exactes. Vingt-huit entrées sélectionnées — seize Rust, dix JSON et deux lecteurs Python — concordent avec V660 et SOURCE. Trente-deux identités courantes sont gardées. Les 23 ancres enregistrées comprennent le catalogue et 22 frontières génériques ; elles ne constituent pas 23 producteurs du passif.

crates/core/src/lib.rs couvre état, commandes, tick et snapshot ; attacks.rs, lifesteal.rs, damage.rs, penetration.rs, stuns.rs, shields.rs, world.rs, lifecycle.rs et champion_kills.rs couvrent impacts, réceptions, protections et cycle de vie. spells.rs et annie_w.rs délimitent les casts inspectés ; progression.rs les statistiques. Aucun producteur Braum qualifié dans ce périmètre. La recherche nominative SOURCE sur seize fichiers, retour 1 sans sortie, est réutilisée sans nouveau recensement global.

## 4. Résultats attendus et observés

Attendu documentaire : mêmes identités, lignes, bindings et rôles que les preuves admises. Observé : 50/50 contrôles et 61/61 cohérences du même agent. Cinq opérations journalisées : quatre réussies, un échec conservé. contract01 comparait des métadonnées complètes à une projection d’identité ; contract02 corrige uniquement ce prédicat en comparant source_id/chemin/taille/SHA. Sources antérieures inchangées, qualification explicite.

V660 est hérité, non rejoué : quatre cas Braum/Garen, niveaux 1/18 ; 52 impacts ordinaires se répartissent en 26 Braum et 26 Garen. Huit quartets se répartissent en quatre et quatre, chacun sur 110 ticks. Seuls dégâts physiques et régénération sont observés, sans marque/proc natif qualifié. Les seize coups alliés négatifs ne sont pas tous Braum. Quatre témoins API Magical à 40, quatre stuns API à 60 ticks et dix gains XP restent distincts du passif. Total : 14 809 ticks, 92 refus publics, 28 refus API. Ces nombres ne sont pas des tests exécutés aujourd’hui. Q n’est pas exercé avec succès. Une attente de 121 ticks ne qualifie ni expiration ni immunité.

## 5. Contrat connu et écarts

Texte : attaque Braum ou Q pour initier ; alliés après première marque ; quatre marques, durée écrite quatre secondes, puis dégâts magiques et stun. Après proc, immunité aux nouvelles marques et bonus des attaques de Braum. Cette immunité concerne les marques ; elle ne vaut pas immunité générale aux contrôles.

Les fournisseurs de f1 dégâts, f2 stun, f3 immunité et f5 bonus restent inconnus. Le f1 du tooltip Q, associé à 2,5 % des PV maximum de Braum, ne résout pas le f1 du proc. Restent aussi ouverts : admission historique, catégories de cibles, multi-Braum, ordre simultané, refresh, égalités temporelles, refus/rollback, mitigation, mort/crédit, suppression du propriétaire, réplication et présentation. Les seize branches et leurs ancres figurent dans contract_review.json ; aucun paramètre inconnu n’est remplacé par zéro.

## 6. Corrections et reprise

Dix fiches documentaires dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-BRAUM-CB-, suffixe -01 :

- SEMANTICS : autorités, aliases et fournisseurs f1/f2/f3/f5.
- INITIATION : attaque/Q, cibles, impact et refus.
- ALLIES : contribution alliée, propriétaires, compteur et quatrième coup atomique.
- TIMING : début, refresh et bornes des quatre secondes.
- PROC-DAMAGE : montant, facteurs, arrondis et ordre des dégâts.
- PROC-STUN : durée, réduction, refus et application du stun.
- IMMUNITY : portée des marques, durée f3 et réarmement.
- POST-PROC-DAMAGE : bonus f5 et éligibilité des attaques du propriétaire.
- LIFECYCLE : mort, crédit, états, audiences et reconnexion.
- VERIFICATION : parcours sourcé complet et témoins séparés.

Chaque fiche relie la tâche existante pertinente, ses prérequis, travail, fin vérifiable et condition de reprise. Reprendre sur source précise nouvelle, dérive ou contradiction ; implémentation sous autorisation fonctionnelle distincte. Inconnues, trois corrections SOURCE et prérequis conservés. Aucun registre modifié. Prochaine sélection : Caitlyn, depuis la projection existante de 122 paires ; sélection ne signifie pas clôture.

## 7. Livrable et qualification

Preuves : E:/mapslol3v3/audit_sys01202_braum_passive_simulation_contract_20261106, reçus d’opérations, qualification du prédicat, matrices, identités et paquet figé. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2 444 entrées groupées modifiées préexistantes au resume, sans mutation Git.

Audit borné terminé après examen des sept rubriques ; tâche complète et fonctionnalité ouvertes, aucune inconnue fermée. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Relecture du même agent, sans acceptation humaine ni revue indépendante. Aucune compilation, exécution du jeu, analyse REA ou mesure de gain nouvelle. Publication limitée à ce rapport et aux ajouts exacts CURRENT/HANDOFF, avec sauvegardes et contrôles après publication. Goal, Plan, interface, bases, registres, produit et assets inchangés.
