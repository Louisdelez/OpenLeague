# AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01 — payload du mode de capture

Date : 2026-10-31T09:51:35.669538+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Deux corps normaux : constructeur `831820` et frontière `7971E0`. Identifier noms, valeurs, sous-objet transmis et nature de l'opération, puis relier les receivers AS existants. La fin est documentaire, sans prétendre observer la livraison runtime. Base constructeur, méthodes virtuelles, allocation et consommateur de queue restent des frontières nommées. Relecture séparée avant clôture.

Audit : contrat et limites établis. Implémentation : aucun changement, route de capture actuelle non qualifiée. Vérification : statique ; preuves antérieures réutilisées. Acceptation humaine : non demandée. Parent, fonctionnalité et goal ouverts.

## R2 — Sources et provenance

PE original 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Corps `831820..8318DE` et `7971E0..79729C`, fins exclusives. Voisins et padding exclus selon les instructions et branches. Le voisin `8318E0` n'est pas qualifié dans ce lot ; seul son littéral `KeybindData` constitue une piste suivante. Export AS et précédentes preuves inchangés, aucun nouvel export ou profil exécuté.

## R3 — Construction et consommateur réel

`831820` appelle `785EA0` sur this+8 avec le contexte transmis par le caller et le littéral exact **SetKeybindInputMode**. Le helper de base reste opaque : l'insertion effective du champ target n'est pas déclarée observée. Un temporaire à this+40 reçoit le tag 2 et l'octet bas du second argument ; dans ce caller le booléen provient des branches littérales 0/1 déjà qualifiées. Une méthode virtuelle +14 reçoit le nom exact **value**, ce temporaire, la référence d'objet et un prédicat de type calculé. Son retour est immédiatement écrasé par EAX=this : cette demande d'écriture n'est pas un acquittement de présence du membre.

Le pointeur `10B6B40` est stocké à this+0 ; il n'est pas assimilé à un nom de méthode, conformément aux qualifications d'inspection précédentes. Le constructeur retourne avec nettoyage de 8 octets. Le calcul de pile du caller montre this=S+0Ch et l'adresse ensuite transmise=S+14h, donc le **sous-objet this+8**, pas le temporaire booléen this+40 ni toute l'enveloppe C++.

`7971E0` est un **ajout au conteneur** : begin/end/capacity, croissance via `7977C0` lorsque end==capacity, construction/copie via `79A4D0` et progression de end de **38h = 56 octets**. Si la source appartient à l'intervalle begin/end, un index est conservé et la source est recalculée après croissance. Les appels de croissance/copie et leurs échecs ne sont pas qualifiés. Le chemin de destination nulle saute la copie mais avance tout de même end ; ce n'est pas présenté comme un état valide ou un refus propre.

Ce corps ne traite pas un target AS, ne flush pas une frame et ne vérifie aucun acquittement. Le terme antérieur « interface de publication » désignait une frontière opaque ; sa nature est maintenant précisée comme insertion, **sans preuve de livraison**. Les hypothèses de validité, alignement, capacité et lifetime restent externes.

Les receivers AS déjà identifiés sont compatibles avec la demande nommée : FoundryOptionsModule enregistre SetKeybindInputMode, consomme value as Boolean, relaie à ViewApplication puis au setter du flag actif. Cette correspondance statique ne remplace pas l'observation du consommateur de queue. Le debug produit sa propre queue ; il ne vaut pas exécution native. Les sources Rust, les gates focus/repeat et la recherche bornée de routes de capture sont réutilisés sur les mêmes octets ; ils ne deviennent pas un éditeur Input actuel.

## R4 — Attendu et observé

130 instructions et 27 points fixes sur deux corps ; trois littéraux dérivés des opérandes réels. Les cas portent sur nom/valeur, retour d'écriture ignoré, sous-objet de pile, alias/croissance/stride, absence de livraison dans ce corps et receiver AS. Nature statique ou héritée explicitée pour chaque attendu/observé. Aucun test de copie/OOM/refus runtime inventé.

Corpus de 1168 sources, 25 fichiers protégés, cinq registres et Git vérifiés avant/après. Aucun jeu, x86, AS, Rust, GUI, OS/IME, input physique, réseau, installation, migration, loader productif, export ou scan d'archives exécuté.

## R5 — Manques et reprise

- `PAYLOAD-BASE-MEMBER` : champs de 785EA0, résultat et ownership de l'écriture virtuelle. Exiger un contrat existant correspondant ou un contexte d'objet/vtable déclaré ; ne pas inférer le succès du membre à partir d'un retour ignoré.
- `PAYLOAD-QUEUE-CONSUMER` : propriétaire de ce vecteur, boucle de mise à jour, flush et réception. Reprendre avec un producteur de frame/version ou une preuve existante correspondante ; ne pas réanalyser l'ajout déjà établi.
- `PAYLOAD-FAILURE-LIFETIME` : croissance, copie, allocation, alias, valeurs managed et concurrence. Reprendre sur un cas/contexte précis, sans exploration récursive de callees.
- `PAYLOAD-CURRENT` : raccord du payload à la capture et à l'éditeur actuels. Réutiliser les corrections existantes sous autorisation produit distincte.

Chaque manque a son impact et son entrée de reprise dans la preuve. Aucun champ présent, parcours complet ou post-état réel n'est affirmé sur ces éléments indirects.

## R6 — Corrections et suite

Les dix corrections bindings/modes et HUD-OPTIONS-ENTRY-01 restent proposées, non appliquées, avec leurs définitions conservées. Aucun doublon ni changement de critère normatif. Les qualifications de littéraux antérieures sont préservées ; les adresses de données imprimables ne servent pas de noms.

Prochain lot fini : `AUD-17.5-01-OPTIONS-KEYBIND-DATA-PAYLOAD-01`, constructeur voisin `8318E0` avec littéral **KeybindData**, puis une frontière de caller précise. Le receiver keys/localizedKeys et l'ajout au conteneur sont déjà identifiés. Pas de redécouverte du cache/filename, ni de récursion dans base/growth/copy.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01\capture-payload-proof.json`, SHA256 `914b46b3528ae45516e1342f8b9ed69b9144f13c4dd6ffc5ab18a3623a49b64c`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01\verify_capture_payload.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01\audit-unit.json` ; inspection et outil identifiés. Relecture `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-PAYLOAD-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Nouveaux artefacts documentaires isolés uniquement. Goal, critères, registres, code, assets, suivi, interface, bases et anciennes preuves inchangés. Aucun achèvement fonctionnel, du parent ou du goal global.
