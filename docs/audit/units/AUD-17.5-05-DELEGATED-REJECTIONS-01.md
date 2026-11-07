# AUD-17.5-05-DELEGATED-REJECTIONS-01

## Résultat et frontière de clôture

SYS-17.5-05 : dix délégations raccordées aux méthodes de production ; **six arbres de motifs Result audités par source**, quatre arbres de sorts encore ouverts. La relecture séparée qualifie cette portée documentaire uniquement. Aucun jeu, paquet, test Rust, calcul natif ou garde de simulation exécuté.

Les six arbres clos : Buy, Sell, UseItem, SwapItems, SwapItemsChecked, Learn. Ils utilisent le joueur lié à la requête et le catalogue/règles locaux. Cette classification ne démontre pas une non-interférence formelle ni la politique serveur4.20. Un littéral fixe peut encoder un état ; aucun motif n’est rendu confidentiel par sa seule forme textuelle.

Audit, implémentation, vérification et acceptation humaine restent indépendants. Aucun goal, critère normatif, code produit, Plan, UI, registre ou base modifié.

## Sources et preuves existantes

Tâche exacte et quatre prérequis D17-SYS-17-5 conservés ouverts. Trajet SessionGameplayRejected → diagnostic F3, effacement, témoin Attack et deux corrections du lot précédent réutilisés sans les refaire. Audits inventaire/apprentissage relus avec leurs observations et identités ; leurs anciens reçus autonomes d’exécution ne sont pas fournis, aucun code0 historique inventé.

Deux queries de définitions nommées exécutées une fois :25hits pour les dix racines (10méthodes publiques de production,15helpers de tests séparés),19hits pour leurs dépendances. Reçus exacts archivés par empreinte.23fenêtres actuelles conservées, dont des descendants de sorts examinés mais non clôturés.

## Arbres clos et motifs retournés

### Buy

Définition : buy_item ; fenêtres : Buy, shop_guard, quote, plan.

Motifs possibles dans les producteurs Result inspectés : `champion dead`, `insufficient gold`, `invalid recipe graph`, `invalid recipe price`, `inventory full`, `item behavior not implemented`, `item group already owned`, `item map availability not qualified`, `item stack limit reached`, `item unavailable on Map10`, `match ended`, `outside allied shop`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

### Sell

Définition : sell_item ; fenêtres : Sell, shop_guard.

Motifs possibles dans les producteurs Result inspectés : `champion dead`, `empty inventory slot`, `invalid inventory slot`, `invalid item sale value`, `item behavior not implemented`, `item sale value not qualified`, `match ended`, `outside allied shop`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

### UseItem

Définition : use_item ; fenêtres : UseItem, disabled.

Motifs possibles dans les producteurs Result inspectés : `champion dead`, `champion does not use mana`, `champion in forced movement`, `disabled cast policy not qualified`, `empty inventory slot`, `health already full`, `invalid inventory slot`, `item active not implemented`, `item behavior not implemented`, `item disabled while stunned`, `mana already full`, `match ended`, `potion queue full`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

### SwapItems

Définition : swap_items ; fenêtres : SwapItems.

Motifs possibles dans les producteurs Result inspectés : `invalid inventory slot`, `match ended`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

### SwapItemsChecked

Définition : swap_items_checked ; fenêtres : SwapItemsChecked, SwapItems.

Motifs possibles dans les producteurs Result inspectés : `invalid inventory slot`, `inventory changed`, `match ended`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

### Learn

Définition : learn ; fenêtres : Learn, next_rank.

Motifs possibles dans les producteurs Result inspectés : `champion skill progression not implemented`, `invalid skill slot`, `maximum skill rank`, `no skill points`, `skill requires a higher level`, `unknown player`.

Classification : état du joueur lié / catalogue fourni. Own inventory/resources/position/ranks/control state or embedded catalogue/rules. No foreign target identifier is accepted by these six command variants; this does not prove a formal absence of statistical,timing,crash or all-game side channels.

## Propagation et limites de la collecte

Arêtes fallibles relues : Buy→shop_guard/quote ; Sell→shop_guard ; UseItem→allows_disabled ; SwapItemsChecked→SwapItems ; Learn→next_rank ; quote→plan_in. plan_in inclut find,validate,credit et leurs récursions. Les lignes contenant ? sont inventoriées ; les retours Result de queue sont listés explicitement. La collecte de littéraux est confrontée à une liste attendue par fenêtre : elle ne remplace pas l’examen des producteurs propagés.

La réunion des libellés est une opération sur le texte des sources, pas une émulation des branches du jeu. Aucune atteignabilité, atomicité, durée ou confidentialité réseau n’est déduite du nombre de littéraux. Unwrap du JSON de allows_disabled, autres panics/indexages et fonctions non-Result ne constituent pas des refus String audités. Learn ne prend actuellement en charge que les schémas Garen/Annie/Trundle/Ezreal ; l’audit de ses erreurs ne termine aucun champion.

## Quatre arbres restant ouverts

- **Summoner** — cast_summoner_on. Only the root and selected descendants are inspected; return/propagation closure,guard order and recipient knowledge for the complete tree are not yet qualified. Reprise : Use these exact roots,dependency locator rows and retained windows first;resolve nested Result producers and conditional hidden-target differences before claiming complete classification.

- **SummonerTarget** — stuns::allows_disabled, cast_ignite, cast_smite, cast_heal, cast_exhaust, grant_shield. Only the root and selected descendants are inspected; return/propagation closure,guard order and recipient knowledge for the complete tree are not yet qualified. Reprise : Use these exact roots,dependency locator rows and retained windows first;resolve nested Result producers and conditional hidden-target differences before claiming complete classification.

- **Cast** — cast_annie, cast_trundle_r, cast_trundle_q. Only the root and selected descendants are inspected; return/propagation closure,guard order and recipient knowledge for the complete tree are not yet qualified. Reprise : Use these exact roots,dependency locator rows and retained windows first;resolve nested Result producers and conditional hidden-target differences before claiming complete classification.

- **CastAt** — cast_ezreal_r_at, cast_ezreal_e_at, cast_ezreal_w_at, cast_ezreal_q_at, cast_trundle_w_at, cast_trundle_e_at, cast_tibbers. Only the root and selected descendants are inspected; return/propagation closure,guard order and recipient knowledge for the complete tree are not yet qualified. Reprise : Use these exact roots,dependency locator rows and retained windows first;resolve nested Result producers and conditional hidden-target differences before claiming complete classification.

Les fenêtres déjà lues cast_annie,cast_trundle_q,cast_trundle_r,cast_ignite,cast_smite,cast_heal,cast_exhaust,grant_shield sont conservées comme frontières inspectées, pas comme arbres complets. Les producteurs rules,validate_target,apply_damage,heal,grant_slow et autres propagations découvertes devront être résolus selon le chemin réel. Move/Stop,ClockAck/pause,SessionRejected et legacy restent en dehors de la clôture des six arbres.

## Corrections et conditions de reprise

The six inspected owner/catalogue trees add a source classification,not a newly proven privacy violation. Existing general player feedback correction already owns F3/persistence. The Attack disclosure correction remains Attack-only; other target-dependent trees stay open for their own findings.

Réutilisation sans application ni changement : HUD-ATTACK-REJECTION-DISCLOSURE-01 (Attack seulement) et HUD-REJECTION-PRESENTATION-01. Aucune nouvelle correction produit déduite des six arbres de joueur/catalogue.

- **DELEGATED-TARGETED-TREES** — Summoner,SummonerTarget,Cast,CastAt have named fallible descendants whose full error trees and target-knowledge decisions remain open. Selected source windows are preserved for reuse,not accepted as completed descendants. Reprise : Continue AUD-17.5-05-TARGETED-REJECTIONS-01 using the exact four roots and19dependency locator rows;trace each unresolved Result and do not re-query unchanged roots.

- **DELEGATED-NATIVE-AND-PRESENTATION** — Original4.20error wording/disclosure and normal player feedback are not qualified by these current local String producers. Panics,IO/OS faults,timing/noninterference and actual network/rendered refusals are not executed or accepted. Reprise : An identified historical error/disclosure policy or explicitly admitted local policy and separate authorized product verification; reuse existing presentation correction and previous native-policy gap,without broad repeated research.

## Contrôles et livraison

Fichiers nouveaux uniquement sous F:/OpenLeague-work/audit-units/AUD-17.5-05-DELEGATED-REJECTIONS-01/ et ce rapport. Producteur puis lecteur distinct : tâche, sources/pointeurs, six arbres, lignes de propagation, deux reçus de locators, limites et corrections. Les comptes et codes réellement obtenus sont dans producer-execution.json et reader-execution.json.

Les cinq registres,25fichiers protégés et1168sources sont comparés avant/après ; état Git antérieur conservé. Aucune installation,migration,reprise d’application,lecture de base,exécution originale/AS/Rust/jeu/GUI/réseau,émulation,export ou ancienne query/test/lecteur rejoué.

Sous-audit clos seulement après le lecteur. SYS-17.5-05 entier, les quatre arbres de sorts, les autres canaux et la confidentialité globale restent ouverts. Prochain lot : AUD-17.5-05-TARGETED-REJECTIONS-01.
