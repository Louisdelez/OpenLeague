# AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01 — données des touches capturées

Date : 2026-10-31T09:59:06.956169+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Qualifier le constructeur KeybindData `8318E0` et son caller direct à `82EA2F`. L'entrée effective du caller est **82E990**, avec fin exclusive **82EA8B**. La fiche préparatoire l'avait attribué à la routine voisine 82E8F0 avant validation des bornes ; `QUAL-KEYDATA-CALLER-ENTRY-01` conserve cette correction, son ancienne fiche et les octets de frontière. Le callsite et l'objectif restent les mêmes ; un seul caller est qualifié.

Le constructeur couvre `8318E0..8319D8`. Deux corps normaux seulement ; les helpers et les méthodes virtuelles sont des frontières opaques. Le producteur ne clôt pas sa propre portée ; relecture séparée. Audit : champs/gardes/source et limites établis. Implémentation : aucun changement. Vérification : statique et preuves héritées. Acceptation : non demandée. Parent, fonctionnalité et goal ouverts.

## R2 — Sources et provenance

PE original 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. La recherche exacte E8rel32 dans ses sections exécutables relève `82EA2F→8318E0`. Ce n'est pas un recensement des appels indirects. Le préfixe existant du constructeur est réutilisé ; sa suite commence au decoder stop 8319A0. L'autre fenêtre commence à 82E92E, termine l'instruction partielle conservée et révèle la nouvelle entrée 82E990 ; le suffixe de la routine précédente est exclu du corps qualifié.

Littéraux dérivés des opérandes : **KeybindData**, **keys**, **localizedKeys**. Les identités AS et les preuves de conteneur, mode et focus/repeat sont réutilisées sans export ni rejeu. Aucun nouveau fichier de jeu récupéré ou remplacé.

## R3 — Contrat et consommateurs

`8318E0` appelle la base `785EA0` avec this+8, le contexte et KeybindData. Deux carriers à this+40 et this+58 sont initialisés avec tag6 et chaîne vide. Les pointeurs C-string argC puis arg10 sont transmis, chacun avec son carrier, au service virtuel +90 ; les demandes d'écriture virtuelle +14 utilisent respectivement les noms **keys** et **localizedKeys**. Les retours d'écriture ne sont pas contrôlés. Le constructeur retourne this avec ret0Ch. Insertion de target, encodage complet, présence réelle des champs et ownership restent opaques.

Le caller `82E990` exige d'abord : global `2D788C8` non nul, owner+24 non nul et octet owner+30 non nul. Un échec va directement à l'épilogue. Le flag +30 n'est assimilé ni au flag AS ni au mode7, et son producteur reste à qualifier.

Après admission, `6D7520` prépare un SSO local EBP-28h. Le champ longueur +10h (EBP-18h) doit être non nul et le global `2D77E80` présent pour construire le payload. Sinon, construction/localisation/append sont sautés, mais l'appel `6D74E0` et la destruction du SSO brut sont conservés sur ce chemin admis. Le sens physique de 6D7520 et 6D74E0 n'est pas déduit de leurs noms ou de cet ordre ; aucun effacement/acquittement d'événement n'est affirmé.

`6D77E0` reçoit la sortie locale EBP-40h et la source EBP-28h. Son résultat fournit le second pointeur ; les capacités +14h, comparées à 10h, choisissent inline ou heap. Ces champs ne sont pas appelés longueurs. Le caller pousse le pointeur localisé, le brut, puis owner+1C : le constructeur reçoit contexte, keys, localizedKeys dans cet ordre logique.

L'enveloppe est construite à EBP-B0h ; le SSO localisé est détruit **avant** l'ajout. Le conteneur owner+24 reçoit EBP-A8h, donc this+8, selon le contrat d'append de 56 octets déjà qualifié. L'enveloppe est détruite après append, puis le service et le SSO brut sont nettoyés. Cette chronologie ne prouve pas que les imports/membres/copieurs possèdent correctement leurs chaînes ; le contrat managed reste ouvert. L'ajout n'est pas une preuve de livraison AS.

Le receiver AS enregistré KeybindData consomme `keys as String` et `localizedKeys as String`, les relaie via ViewApplication à KeyBindStateHandler, puis au modèle seulement si flag actif et grille présente. Esc précède applyBind dans doKeybindLogic ; les états succès/refus/annulation précédemment qualifiés sont réutilisés. Les consommateurs Rust actuels et leurs gardes QWER/focus/repeat sont inspectés par leurs preuves inchangées ; aucune capture configurable n'en découle.

## R4 — Attendu et observé

149 instructions et 37 points fixes sur les deux corps, trois littéraux, bornes et gardes contrôlés. Cas : trois refus d'entrée, chaîne vide/service absent avec cleanup, deux champs, capacité/longueur SSO, ordre de destruction et sous-objet ajouté, réception AS et correction de borne. Chaque attendu/observé porte sa nature statique ou héritée.

Corpus de 1168 fichiers, 25 fichiers protégés, cinq registres et Git identiques avant/après. Aucun jeu, x86, AS, Rust, GUI, OS/IME, input physique, réseau, loader productif, export, scan d'archives, installation ou migration exécuté. Aucun test d'ownership, d'erreur ou de clavier réel inventé.

## R5 — Manques et reprise

- `KEYDATA-RAW-PRODUCER` : source de 6D7520, setter +30, effet de 6D74E0, layout/répétition et événements réels. Reprendre avec une preuve correspondante ou un producteur/context précis ; les rôles SSO ne suffisent pas.
- `KEYDATA-MEMBER-LIFETIME` : base target, imports virtuels, écritures, encodage et ownership des temporaires. Exiger contrat/vtable ou cas précis ; pas de récursion dans les helpers.
- `KEYDATA-QUEUE-DELIVERY` : propriétaire/consommateur de queue, frame/flush et arrivée AS. Même entrée que PAYLOAD-QUEUE-CONSUMER, sans nouvelle correction doublon.
- `KEYDATA-CURRENT` : capture/édition/configuration actuelle complète et persistante. Reprendre les corrections existantes sous autorisation produit distincte.

Chaque manque précise impact et reprise dans la preuve. Les frontières sont explicitement ouvertes sans annuler les conditions statiques établies.

## R6 — Corrections et suite

Les dix corrections bindings/modes et HUD-OPTIONS-ENTRY-01 sont conservées avec leurs définitions, proposées et non appliquées. Aucun doublon, nouveau critère ou registre modifié. Les qualifications antérieures de capacité, copie, littéraux et absence lexicale restent à leur portée.

Prochain lot : `AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01`, consolidation des clauses de capture, des preuves et conditions de reprise, puis identification des autres clauses HUD du recensement existant. Aucun nouveau callee à analyser dans ce lot de consolidation ; aucune fermeture fonctionnelle par agrégation.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01\keybind-data-proof.json`, SHA256 `8c20c2355b937c486db6766723c5b8f7f35b0ce540080703fcdea2c9070f86b3`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01\verify_keybind_data.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01\audit-unit.json` ; qualification de portée et inspections identifiées. Relecture `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Nouveaux artefacts documentaires isolés uniquement. Goal, critères, registres, code, assets, suivi, interface, bases et preuves antérieures inchangés. Aucun achèvement fonctionnel, du parent ou du goal global.
