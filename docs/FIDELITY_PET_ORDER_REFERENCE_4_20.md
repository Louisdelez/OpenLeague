# Familier : callbacks, ordres et consommateurs — référence 4.20

Cette étude concerne SYS-01.2-02/03/05/06. La référence reste le client PUBLIC 4.20.0.315, EUW/en_GB. Les autres objectifs du Goal restent ouverts selon leurs preuves propres.

## Sources et observation

`Pet.luaobj` provient du membre exact du manifeste RADS sélectionné. Ses 13 prototypes et leurs liaisons CLOSURE/SETGLOBAL sont conservés. Les observations Lua utilisent Lua 5.1 dans Lupa ; seule la taille des longueurs de chaînes passe de 32 à 64 bits, avec aller-retour exact et tableaux d’instructions identiques. Le jeu historique ne s’exécute pas.

Les neuf cas hérités portent sur OnCanMove, OnCanAttack et HaltAI. Dans les profils fournis hors HALTED, OnCanMove/OnCanAttack demandent NetSetState(IDLE), puis TimerFindEnemies. En HALTED ils ne demandent que GetState. HaltAI demande trois arrêts de timers, l’arrêt de l’attaque, puis HALTED. Ces fonctions ne renvoient aucune valeur Lua. Le vrai corps de TimerFindEnemies est remplacé par un observateur explicite et n’est pas exécuté.

Les 36 nouveaux profils appellent le corps complet de OnOrder (215 instructions), mais ne couvrent que ses gardes initiales : six états « hard » et trois états halted/taunted/feared, chacun avec quatre ordres ordinaires. Les états/ordres natifs sont des marqueurs symboliques ; leurs numéros historiques et la production des arguments restent inconnus.

| Profils | Lua original observé | Méthode CSharp observée | Portée |
|---|---|---|---|
| 24 états hard × ordres ordinaires | Une valeur `true` | `true` | Concordance littérale sur les profils déclarés |
| 12 halted/taunted/feared × ordres | Zéro valeur de retour | `true` | Forme de retour différente ; sens du dispatcher natif non établi |

La méthode CSharp OnOrder complète est extraite par Roslyn, puis comparée à la tranche UTF16 exacte du fichier source original non normalisé. Ses deux enums réels AIState/OrderType sont copiés sans modification. La méthode entière est compilée et exécutée sous .NET 8.0.25, avec des API et un hôte explicitement limités. Les 36 profils ne lisent que TargetUnit et GetAIState ; un cas distinct atteint RemoveBuff et est refusé, prouvant que les branches non qualifiées ne réussissent pas silencieusement. Il ne s’agit ni de la classe Pet complète, ni du serveur communautaire net6, ni de gameplay Rust.

## Consommateurs réels et rôles distincts

Douze ancres de source lient CreatePet, ses constructeurs, le chargeur d’instance AIScripts, OnActivate, OnUpdate et l’enregistrement OnOrder. Le ConditionDispatcher communautaire combine les booléens des callbacks ; UpdateMoveOrder abandonne la modification lorsque Publish renvoie false. Ce contrat CSharp est lu dans son consommateur réel. Son sens ne prouve pas le traitement des retours du dispatcher Lua historique.

CanMove et CanAttack de ObjAIBase sont des prédicats de permissions. Ils ne sont pas assimilés aux callbacks originaux OnCanMove et OnCanAttack sur la seule ressemblance des noms. IAIScript, les méthodes concernées et le consommateur Rust existant advance_pet_orders sont identifiés par chemin, emplacement et SHA ; la liaison événementielle et l’équivalence de gameplay Rust restent ouvertes.

Le dépôt communautaire est un instantané modifié basé sur b37c75483abf66048af7c914e7fab700efaa5e21. Les SHA des fichiers précis constituent leur version observée ; leurs octets ne sont pas attribués sans preuve au commit amont.

## Vérifications, corrections et limites

L’auditeur de référence relit les sources, manifestes, tableaux d’instructions, tranches UTF16, profils, retours et limites. Un interpréteur indépendant limité aux opcodes des gardes vérifie les 36 sorties sans rejouer l’expérience Lua. La qualification réussit 44 contrôles, dont 42 refus de données altérées et un contrôle positif de représentation numérique. Les booléens ne sont pas confondus avec le nombre 1.

Trois corrections préparatoires sont conservées : l’ancien découpage de corps CSharp utilisait des positions provenant d’un masquage qui supprimait des caractères ; les bonnes plages viennent de Roslyn et de la relecture UTF16. Le premier attendu OnOrder était false pour les états hard ; LOADBOOL à pc43 a B=1 et produit true. Enfin, une entrée de l’historique de correction ne contenait que SHA et chemin ; l’auditeur compare maintenant ce SHA explicitement puis relève son identité complète. Aucun de ces essais erronés n’a été intégré comme preuve qualifiée.

L’inconnue existante AIScripts/Pet.cs est affinée, sans doublon ni clôture. Sa résolution exige le dispatcher natif, les valeurs d’enum et arguments effectifs, les autres branches/API/TimerFindEnemies et une comparaison comportementale des consommateurs actuels. Les deux plafonds de maîtrises 4312/4313 et les autres inconnues du Goal ne sont pas résolus par cette étude.

Les registres et consignes du plan reçoivent cette preuve. Les identifiants stables, versions précédentes, cases, notes, révisions et historique manuels doivent rester inchangés. Aucun champion, serveur ni jeu complet n’est déclaré terminé.

Preuve de livraison : `docs/fidelity_registry_pet_order_revision_4_20.json`. Détails et journaux : `E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision41`.
