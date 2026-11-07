# AUD-17.5-05-TARGETED-REJECTIONS-01

## Décision et portée

SYS-17.5-05 : les quatre arbres Summoner,SummonerTarget,Cast,CastAt sont raccordés à leurs producteurs Result et frontières identifiées. Avec les six arbres précédents,les dix délégations sont auditées sur ce périmètre de sources. **Les autres canaux et la confidentialité globale restent ouverts.**

Audit de sources ≠ implémentation ≠ recette réseau/rendu ≠ acceptation humaine. Aucun calcul de sort,garde native/x87,Rust,AS,jeu,GUI ou réseau exécuté ou émulé. L’examen du format de refus est statique ; aucune fuite/exploit réseau n’a été observé.

## Références et réutilisation

Tâche exacte et quatre prérequis D17-SYS-17-5conservés. Le trajet de rejet,les six arbres joueur/catalogue,19locators et13fenêtres sont réutilisés sans rejouer leurs programmes.39fenêtres complémentaires et deux queries de dépendances nommées (16et7hits) complètent les sources ; trois locators ponctuels servent uniquement aux nouveaux enfants.

La ressource native_spells_420.json fournit des données de build ; elle ne récupère pas les règles serveur de divulgation. serde_json1.0.151est identifié par Cargo.lock,archive dont le SHA égale le checksum,et membre error.rs identique à la source installée,lu en mémoire sans extraction. Display retourne une catégorie et éventuellement ligne/colonne ; ses variantes Message/IO empêchent de le traiter globalement comme une simple liste fixe. Aucune installation ou exécution de cette bibliothèque.

## Arbres Result et frontières

- **Summoner** — Summoner, SummonerTarget, apply_damage, cast_exhaust, cast_heal, cast_ignite, cast_smite, disabled, grant_shield, grant_slow, heal, penetrated_defenses, prepare_slow, record_ability_hit, validate_smite. Clôture : source seulement ; politique native et vérification runtime non qualifiées.

- **SummonerTarget** — SummonerTarget, apply_damage, cast_exhaust, cast_heal, cast_ignite, cast_smite, disabled, grant_shield, grant_slow, heal, penetrated_defenses, prepare_slow, record_ability_hit, validate_smite. Clôture : source seulement ; politique native et vérification runtime non qualifiées.

- **Cast** — Cast, apply_damage, cast_annie, cast_molten, cast_tibbers, cast_trundle_q, cast_trundle_r, guide_tibbers, penetrated_defenses, serde_json, trundle_q_rules, trundle_r_math, trundle_r_preflight, trundle_r_rules. Clôture : source seulement ; politique native et vérification runtime non qualifiées.

- **CastAt** — AD_components, CastAt, Shot_new, Shot_point, cast_ezreal_e, cast_ezreal_q, cast_ezreal_r, cast_ezreal_w, cast_tibbers, cast_trundle_e, cast_trundle_w, clamp_landing, ezreal_e_census, ezreal_e_landing, ezreal_e_rules, ezreal_q_rules, ezreal_r_circles, ezreal_r_rules, ezreal_w_rules, facing, guide_tibbers, serde_json, trundle_e_push, trundle_e_rules, trundle_w_rules, yaw. Clôture : source seulement ; politique native et vérification runtime non qualifiées.

Les50nœuds de producteurs sont tous raccordés aux quatre racines. Les parse/règles/closures numériques de chaque sort sont inclus dans leurs fenêtres composées. Les ? et conversions sont conservés par lignes exactes ; les retours de queue,sous-fonctions et frontières serde_json sont des arêtes explicites. Un inventaire lexical seul n’est pas une preuve de fermeture sémantique.

Shot::new ne diffuse via Debug que des variantes sans données : InvalidIdentity, InvalidPoint, InvalidParams, InvalidLimits, UndefinedDirection, CoordinateOverflow. Le constructeur ne rend pas les erreurs TargetCapacity/InvalidCircle des étapes ultérieures. Facing suit from_direction→entity_yaw::angle et from_yaw ; le code x87 est lu,seulement.

apply_damage propage penetration/mitigation et ses gardes cible ; Heal,Exhaust et Smite conservent leur chemin réel. Ignite tick et le soin de Trundle R utilisent expect dans des fonctions non-Result ; leurs panics ne sont pas des refus GameplayRejection. Les erreurs optionnelles cast-ground/vertical d’Ezreal R deviennent des faults et ne rejettent pas automatiquement une commande acceptée.

## Comparaisons conditionnelles

### GAREN-R

Unknown target and invalid enemy checks precede visibility; range error is after visibility.

Condition/limite : A difference from private health/identity knowledge is conditional on same admitted public state; roster identities may already be public. No runtime witness executed.

### ANNIE-Q

Unknown/invalid target precede spell target not visible; range follows visibility.

Condition/limite : Current target may be a unit not in the public roster; decide source public knowledge before calling the distinction a prohibited disclosure.

### ANNIE-PET-REQUEST

Existing pet branch resolves target_info(target).position before guide; guide selects only visible attack candidates but can otherwise issue a point move or a point/path error.

Condition/limite : A requested hidden target position can influence point/range/path branches. No actual hidden-target order or private position received by a client is asserted.

### IGNITE-EXHAUST

Target existence,team/health/range checks precede the hidden-enemy error.

Condition/limite : In/out-of-range hidden enemies may produce different reasons if an otherwise identical public state is admitted; native or local policy still needed.

### SMITE

Target definition/native-tag/range validation occurs before visible_to; common damage errors are propagated afterwards.

Condition/limite : Fixed labels do not alone prove disclosure permission. Actor/resource and target predicates are kept distinct; no numeric health payload in these fixed labels claimed.

### TRUNDLE-R

Unknown target is separated; living/team/protection/visibility is a combined invalid-visible guard,then range/stats/damage checks follow.

Condition/limite : Do not falsely claim each health/protection cause has a separate public reason; visibility is before later stat-specific errors on this path.

### TRUNDLE-E-ID

trundle_e_targets enumerates healthy positioned players and eligible units without visible_to; push planning can return format!("Trundle E push has no legal terrain/other-pillar segment:{id}").

Condition/limite : An admitted caster,qualifying affected entity and a failing segment are required. A private entity ID can be included in the returned String if such a state is reachable; runtime reachability and a real packet leak remain unobserved.

### EZREAL-E-WORLD

Census and landing consider global targets/pillars,including occupancy,without a visibility filter.

Condition/limite : Feedback about physical blockage may be an allowed local game rule. Do not infer privacy equivalence or a vulnerability without the admitted public collision/feedback policy.

### EZREAL-R-CENSUS

Cast preflight validates global target census/identity/collision without visible_to. Optional presentation faults remain separate.

Condition/limite : Some census failures may be unreachable in admitted healthy states; aggregate-world diagnostic and public permission require a named policy,not a fabricated exploit.

### WORLD-CAPACITY

Global active-cast/pillar capacities can select fixed budget/capacity refusals.

Condition/limite : Legitimate reachable capacity bounds and which aggregate state is public are not proved by these checks; no leak based only on the presence of a defensive guard is claimed.

## Corrections proposées,non appliquées

### HUD-SPELL-REJECTION-DISCLOSURE-CONTRACT-01

Définir la projection publique des motifs pour les quatre routes de sorts auditées.

Écart : Contexte/longueur et littéraux fixes ne décident pas la divulgation des prédicats cible/monde ; dix cas nommés ont désormais une provenance source.

Travail : Pour chaque cas de cette matrice uniquement,nommer les connaissances publiques admises et la catégorie extérieure autorisée ; distinguer règles4.20 retrouvées et contrat local versionné. Décomposer l’implémentation ensuite par cas décidé,ne pas modifier les gardes de simulation sur une supposition.

Fin : Les dix cas nommés ont une décision source/politique et une catégorie publiable ou un refus explicite de qualification ; chaque inconnue restante a son entrée précise. Le contrat sépare détails internes et motif reçu/loggé côté client,sans permission native inventée.

Reprise : Source historique précise de divulgation,ou politique locale explicitement admise ; ne pas refaire une recherche générale sans piste nouvelle.

### HUD-TRUNDLE-E-PUSH-REJECTION-DISCLOSURE-01

Qualifier et corriger si nécessaire le motif de poussée refusée du pilier Trundle E.

Écart : Le format de refus contient {id},issu d’un recensement de cibles sans filtre de visibilité. Le trajet vers le client général est déjà établi.

Travail : Définir le motif public pour ce seul échec ; conserver les détails d’entité dans un diagnostic interne si approprié. Traiter la divulgation des causes de blocage selon le contrat admis,sans supprimer la validation physique.

Fin : Sur la paire admise contenant une unité non publique touchée par un segment invalide,le motif public et les logs accessibles au client ne divulguent pas son identifiant selon le contrat ; nominal,cible déjà publique,ancien/étranger et récupération vérifiés séparément.

Reprise : Politique de divulgation et scénario atteignable précis ; travail produit et exécution autorisés séparément.

Les deux corrections antérieures sont conservées : HUD-ATTACK-REJECTION-DISCLOSURE-01reste Attack-only ; HUD-REJECTION-PRESENTATION-01reste le canal utilisateur. Le contrat proposé ici est limité aux dix cas nommés de sorts ; il ne transforme aucune hypothèse en permission historique.

## Manques et reprise

- **SPELL-PUBLIC-DISCLOSURE-POLICY** — Les producteurs Result sont reliés,mais la politique4.20des causes de refus et du feedback de collision/agrégats n’est pas qualifiée. Dix cas ont des conditions de comparaison ; aucun n’est une fuite réseau observée. Reprise : Une source/observation historique nommée ou politique locale admise pour ces cas,avec l’état public et les conditions exactes. Aucune recherche inchangée ou exécution implicite.

- **SPELL-RUNTIME-AND-FAULTS** — Pas de recette réseau/rendu,de preuve formelle de non-interférence,d’atteignabilité de tous les défauts défensifs ou de tests de panic. Les Display de tiers sont des frontières identifiées,pas un vocabulaire complet inventorié. Reprise : Contrat de cas admis et autorisation d’exécution produit distincte ; conserver les identités de build/assets et le type de défaut réellement vérifié.

- **OTHER-REJECTION-CHANNELS** — Move/Stop,ClockAck/pause,SessionRejected et legacy restent à confronter avant de clôturer SYS-17.5-05entier. Reprise : Prochain lot des canaux restants,en réutilisant les audits session/pause et les trois racines command déjà identifiées ; ne pas refaire les dix délégations désormais raccordées.

## Livrables et contrôles

Premier producteur documentaire : code1,prédicat lexical défectueux (Point correspondait à InvalidPoint). Le programme et producer-execution.json sont conservés. Version2 : contrôle de13identifiants de variantes sans payload,critère inchangé ; le reçu effectif est producer-execution-v2.json. Aucun défaut du jeu déduit de cet échec.

Nouveaux fichiers uniquement sous F:/OpenLeague-work/audit-units/AUD-17.5-05-TARGETED-REJECTIONS-01/ et ce rapport. Producteur : empreintes,graphes,lignes,queries,archive/data et limites. Lecteur distinct : cohérence des sept rubriques,arêtes et racines,cas de divulgation,corrections et reçus. Codes/comptes réellement obtenus dans producer-execution.json et reader-execution.json.

Cinq registres,25fichiers protégés et1168sources comparés avant/après ; état Git antérieur conservé. Aucun goal,critère normatif,code produit,Plan,UI,registre ou base modifié ; aucune installation,migration,reprise d’application,émulation,export ou ancien test/query/lecteur rejoué.

Le sous-audit se clôt uniquement après relecture. SYS-17.5-05entier et le goal restent ouverts. Prochain lot : AUD-17.5-05-REMAINING-REJECTION-CHANNELS-01.
