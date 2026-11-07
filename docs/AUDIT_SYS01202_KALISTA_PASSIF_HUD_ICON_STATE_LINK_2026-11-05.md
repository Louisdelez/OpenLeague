# Kalista — Martial Poise, icône et état vers le HUD

2026-11-05 · V1311 · AUD-SYS-01.2-02-KALISTA-PASSIF-HUD-ICON-STATE-LINK-01

## 1. Exigence et périmètre

CH-Kalista-PASSIF-PRESENTATION-HUD ; OLF-15c634e0-33f0-5244-925c-89b72eccb3a8 ; inconnue OLU-48bd2c94-49c4-5401-920c-9ee7e3b45bb5. Parent SYS-01.2-02 actif. Audit documentaire de liaison de l'icône, du texte et de l'état de Martial Poise aux consommateurs actuels ; conserver le verrou d'annulation déjà implémenté. Six contrats SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/PRESENTATION-HUD/ACCEPTANCE ouverts. Phase D06, lot D06-CH-Kalista, HUD dépend de NETWORK ; aucun prérequis déclaré accepté. Voir phase_package_prerequisites.json.

Audit : clôturable pour cette liaison après décision et publication vérifiée. Implémentation partielle ; vérification statique et historique bornée ; acceptation humaine non donnée. Aucun champion ou jeu terminé.

## 2. Sources, provenance et limites

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. V663 daté 2026-10-27T05:52:35.261747+00:00 : 4917535 octets, SHA-256 04c682946b734f5447451199cb88d51b6d7fffa2389deaf422ea54eab61a6572. Identités et recherches antérieures dans initial_scope.json.

25 ressources sélectionnées : 7 INIBIN, 11 Lua, 5 preloads, DDF et font. Alias KalistaPassiveBuff, icône Kalista_Passive.dds. PassLev1Desc1 absent : description de personnage présente mais non liée par ce champ. Passive1/Desc/Level1..6 absents restent inconnus. 114 Lua antérieurement lus, sans enfants ; 24 limites NEWTABLE conservées. Onze chunks nécessaires réutilisés, dont PassiveBuff avec texture/nom/PersistsThroughDeath. Ces métadonnées ne sont pas des callbacks serveur.

Textes en_GB du miroir F d'identité native vérifiée : nom ligne4385, buff2132, description non liée4209. Le texte fournit attaque non annulable, échec hors vision, commande pendant préparation d'attaque/Pierce, bond au lancement, paliers de bottes et bonus arrière25%. Distance/vitesse exactes inconnues. Huit lignes DDF vides ne fournissent pas de formule. Clé CardMasterBasicAttack absente du font exact ; ShenShadowDash présente ligne11842, étrangère au passif et non adoptée. Commander/Shen/Rumble littéraux et aliases de manifest restent contexte, sans priorité HUD automatique.

Une DDS propre au HUD Kalista, membre0.0.1.7 :2176 octets,64×64 DXT1,mipmap_count=0, SHA-256 db6ca23da81f605537944ac65f62feae13369e4c9b0aa305bd1eb43482fb1ea0. Sélection E avant unique stat/lecture native, taille/MD5 du manifest concordantes. Aucun INIBIN/Lua/font natif relu. Montage, priorité provider et rendu non prouvés.

## 3. Consommateurs réels

SOURCE :31relations/25IDs, six sites sur trois fichiers ; V663 :26frontières sur douze fichiers. Union32ancres/quatorze fichiers ;34fichiers code/configuration vérifiés. Les16communs et22identités V663 concordent. Les noms de champion seuls ne détectent pas les mécanismes génériques.

attack_contracts.json contient cant_cancel=true, période1.519760012626648s, préparation0.550000011920929s, ratio0.5 et missile2600. Les identités caractère/attaque correspondent aux ressources natives sélectionnées ; CantCancelWhileWindingUp=1 est hérité du décodage qualifié. attacks.rs charge ce profil et fixe cancelable=!cant_cancel ; cancel_windup refuse alors Stop/Move. lib.rs passe par cette garde avant p.destination=Some(point), donc ce chemin ne conserve pas d'ordre de bond.

HP/Mana sont affichables par native_hud_bars/widgets. Le catalogue QWER contient quatre InventoryIcon et deux variantes E, aucune Kalista_Passive. Buff0 d'Ezreal est spécifique. Aucun binding littéral MartialPoise dans les sept modules HUD inspectés ; recherche nommée bornée sans occurrence sur les fichiers Rust retenus, sans conclure à une absence globale de code générique.

## 4. Attendu, observé et contrôles

Attendu : chaîne source→consommateur identifiée, acquis partiel conservé, écarts/refus explicités. Observé :69/69 contrôles documentaires et63/63 cohérence séparée du même agent ; ancres, identités, textes/absences et DDS vérifiés. Aucun nouveau test Rust/Bevy, build, jeu, REA, VM, réseau ou GPU.

V663 réutilisé sans replay/recalcul : huit simulations Kalista/Annie × niveaux1/18 × sans/avec achat public1001 ;20attaques,24essais Stop/Move avant/arrière pendant windup. Kalista refuse les12commandes, tire et reste fixe jusqu'à lancement+30 ; Annie accepte les12, annule le tir et marche seulement. Ce diagnostic conserve le verrou partiel, sans bond ni ordre différé observé.

132refus publics au total, dont ces12refus de windup ;4achats,40trajets,12apports XP diagnostiques,16860ticks. Les bottes vérifient ici la marche, pas le bond absent. Ni injection directe d'état ni dégâts/soin API dans ce diagnostic hérité. Deux archives sélectionnées,2119797octets ; ancien probe7509876octets/RUN non ouverts. Binaire historique6100992octets, SHA ea5371890bf03abc400ee4384f1dbaf5157720c22bba20a63a695fb3e38a4de3, non relu/rejoué ;1158dépendances non requalifiées.

## 5. Écarts et inconnues

Mémorisation du bond, fenêtre de commande, lancement, paliers de bottes, distance/vitesse, direction/bonus arrière25%, collisions/terrain/contrôles, Pierce/Q, vision/cible et lifecycle non qualifiés. Oathsworn/W/R restent des exigences distinctes. Le C# communautaire non vide propose des callbacks mais porte speculative/TODO ; ni exécution Rust ni autorité du serveur historique. Texte présent et icône identifiée ne prouvent ni états ni rendu. Le source_sha256 embarqué de champion_resources est une provenance distincte de l'INIBIN sélectionné, sans corruption déduite.

## 6. Corrections et reprise

Réutiliser les contrats existants ; propositions documentaires, aucun registre modifié :

- COR-KALISTA-NATIVE-MARTIAL-POISE-POLICY-01 → SOURCE : qualifier source/mapping natif des fenêtres, paliers, formules et vision ; garder les TODO communautaires comme inconnues autrement.
- COR-KALISTA-LUNGE-ORDER-STATE-01 → SIMULATION-CONTRAT : définir capture de Move sans annuler le tir, ordre de lancement, cible et refus ; conserver cant_cancel.
- COR-KALISTA-LUNGE-EXECUTION-01 → SIMULATION : produire le bond selon contrat qualifié, bottes/direction/25%, collision et Pierce ; vérifier positions/tirs et contrôles sans remplacer les cas existants.
- COR-KALISTA-VISION-LIFECYCLE-01 → SIMULATION-CONTRAT : borner vision avant/après lancement, disparition/changement de cible, mort/réapparition et invalides ; fournir observations attendues/obtenues.
- COR-KALISTA-ICON-PROVIDER-PATH-01 → PRESENTATION-HUD : prouver resource_provenance, montage/chemin/identité et sélection de Kalista_Passive ; garder les aliases de dash/attaque distincts, puis vérifier le rendu.
- COR-KALISTA-HUD-BINDINGS-01 → PRESENTATION-HUD : après état NETWORK qualifié, lier icône, nom/texte et état autoritaire ; résoudre la description non liée explicitement ; vérifier absence de données/refus et parcours d'attaque/bond. ACCEPTANCE demeure distincte.

Reprendre sur source nouvelle, modification pertinente, anomalie ou binding précis manquant. Réutiliser V663 et16communs après identité ; pas de probe/compilation inchangés.

## 7. Livraison et cohérence

Preuves E:/mapslol3v3/audit_sys01202_kalista_passive_hud_20261105 : evidence_review.json,coherence_review.json,journaux et captures. Sept rubriques relues avant décision. Publication limitée à ce rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés à maintenir identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2298entrées sales groupées conservées. Goal/Plan/UI/bases/produit/assets inchangés. V1308 demeure historique ; cette liaison Kalista seule peut être close, pas le passif complet. Prochain lot unique : CH-TwistedFate-PASSIF-PRESENTATION-HUD, V643 à réutiliser.
