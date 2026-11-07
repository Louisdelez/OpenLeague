# Renekton — passif, applicabilité et liaison VFX, V1316

## 1. Exigence et décision bornée

Unité `AUD-SYS-01.2-02-RENEKTON-PASSIF-VFX-APPLICABILITY-LINK-01`, parent SYS-01.2-02 ; tâche `CH-Renekton-PASSIF-PRESENTATION-VFX`, exigence `OLF-f3f40a7f-4cd4-5b2a-9faa-34e7b92ff8f6`. Phase D06, lot D06-CH-Renekton, six prérequis et dépendance NETWORK examinés, sans satisfaction revendiquée. Contrat `a_faire`, implémentation/acceptation false ; inconnue `OLU-da6e1838-bd85-5555-968c-feaeef35feac` conservée.

Audit de liaison documentaire terminable après les sept rubriques et la relecture. Implémentation spécifique non établie dans le périmètre inspecté ; primitives génériques partielles conservées. Vérification statique seulement ; acceptation visuelle humaine à valider. Ni tâche VFX complète, ni champion, ni goal clos.

## 2. Sources et applicabilité

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/renekton-passive-reign-of-anger-links-v618.json`, 2482618 octets, SHA256 `8aafd895c1a6c93607108455d2babc4d2f00c1ace4b6cc75f0ee8fe7ca42f56f`. V669, `reference_requirement_trace_sources/passive-vfx-links-v669.json`, SHA `4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b`, réutilisé via V1314 vérifié. Ancien audit HUD conservé.

Trace VFX : neuf relations/sept IDs ; V618 : 59 identités natives. RenektonPredator.inibin : 1040 octets/SHA `ca0bc9444456a7a4f4e3c662a772516cc0275d75f079cd239e72b7adf2c205d0`, membre .248. Lua : 218 octets/SHA `b79a0060f566ec572e5a00d7c1f085dc4aea5ab7bdb13ce5f90f19e27da78d48`, membre .254 ; initialisation littérale de l’icône, BuffName, PersistsThroughDeath et NonDispellable, sans AutoBuffActivateEffect. CharScript vide ; 25 Lua/huit limites littérales hérités, sans nouveau décodage.

SpellData déclare globalhit_physical.troy/HaveAfterEffect=1, BloodSlash.troy/HaveHitEffect=1 et AnnieBasicAttack_mis.troy sans indicateur d’activation associé qualifié. Trois champs nommés, un vide, un absent : leur déclenchement par la Fureur n’est pas démontré. Ces noms ne constituent pas une liste obligatoire de ressources du passif.

BloodSlash : membres Darius/Skins/Base et Shared, 1497 octets chacun/SHA `141abad120800fab543ede23591b41cfcd28921fe9e6b9db6d8512a213bb6e39`, releases .248/.235. Globalhit Shared : 249 octets/SHA `c96eee7220437f94bde4a3ea46331b7f00463b92e8f203975a712213111fbb11`, .239. Appartenance historique au projet .7 ; priorité native/skin non qualifiée malgré les octets identiques. Les 112 questions antérieures de précédence Renekton restent distinctes et ouvertes.

## 3. Consommateurs actuels

Trente ancres exactes, 21 fichiers inspectés, 19 comparaisons V618 concordantes. `map_resource_provider.rs` et son initialisation dans `main.rs` sont des frontières de noms. Huit requêtes V669 : deux chemins Shared logiques .troy, six sans résultat ; aucune ouverture Troybin prouvée. Le candidat Annie absent de l’ancien scan ne prouve pas un asset nécessaire manquant.

`lib.rs` publie Champion.effects/Snapshot.players ; `spells.rs::Effects` conserve d’autres états, sans champ Renekton/Fury/Predator nommé. Aucune route de production nommée trouvée dans les fichiers sélectionnés ; une mention Renekton existe en test de régénération. Cela n’exclut pas tout mécanisme générique ou dynamique.

Rage, exclusion de la restauration Mana/Energy et remise à zéro au respawn sont conservées. Le source_sha256 du catalogue de ressources désigne une source communautaire, déjà distinguée du natif par l’audit HUD. Ni jauge ni persistance de métadonnée ne prouvent un producteur VFX.

Quatorze identités communes V1315 inchangées permettent de réutiliser helpers spatiaux, matrices d’attache fournies par l’appelant, arrêt d’owner et route Annie. Relic expose des sous-catalogues DDS de 9/17 entrées, pas ces Troy ; refus dérivé statiquement ici. Le catalogue Map10 précis de 26 définitions ne contient pas leurs références : aucune conclusion globale sur les assets.

## 4. Attendu, observé et contrôles

Attendu : conserver déclarations/indicateurs, distinguer identité/activation, vérifier les ancres et borner le manque. Observé : 47/47 contrôles qualifiés, 45/45 cohérence séparée du même agent, sans revue indépendante. Nominal : BloodSlash identiques et correctement membres. Limites : sélection historique inconnue, nom logique distinct d’une ouverture, candidat absent distinct d’une nécessité démontrée.

Premier collecteur 46/47, code1 conservé : deux mentions nommées attendues en test, une seule correspond au motif précis. Qualification sur octets E retenus, un seul prédicat corrigé ; les 46 autres et le reste du payload inchangés. Aucun replay des sources/probes.

V618 hérité : deux cas, 18 attaques, 50 coups entrants, deux morts/respawns, 54 refus et 1204 ticks d’attente ; aucune image VFX. Ancien binaire 6095872 octets/SHA `19b9b86aa8e3dfb8b95c4938510e0f07e4f40a5aa0f4f8a3344a09a9c58d716a`, identifié par le MD V618, non réouvert/exécuté. Aucun nouveau build, jeu, GPU, REA, accès D, scan global ou décodage.

## 5. Écarts ouverts

Applicabilité au passif, état/déclenchement autoritatif, montage/skin, conversion, attaches, propriétaire, cycle de vie, audience et fidélité visuelle non qualifiés. Les textes Fureur ne sont pas une exécution serveur. L’ancien texte bonus de dégâts sous 50%PV reste distinct. HUD, QWER, mécanique, réseau et anciennes priorités ne sont pas clos.

## 6. Corrections et reprise

Réutiliser CH-Renekton-PASSIF-PRESENTATION-VFX ; propositions documentaires sans changement de registre :

- `COR-RENEKTON-PASSIF-VFX-APPLICABILITY-01` : identifier consommateur historique/contrat autoritatif, conditions et événements de Predator ; conclure séparément pour chaque nom. Fin : déclenchement ou non-applicabilité démontrés, sans dessin inventé.
- `COR-RENEKTON-PASSIF-VFX-TRIGGER-01` : pour effets applicables, relier état autoritatif, événement et projection client ; vérifier activation, absence de condition, transitions et refus.
- `COR-RENEKTON-PASSIF-VFX-OPEN-01` : qualifier montage, namespace/skin, ouverture/conversion du payload ; vérifier candidat ambigu/introuvable, sans clore implicitement les 112 priorités.
- `COR-RENEKTON-PASSIF-VFX-LIFECYCLE-01` : préciser attache, propriétaire, création/arrêt, mort, consommation, audience/reconnexion ; vérifier retrait et absence de doublons.
- `COR-RENEKTON-PASSIF-VFX-RENDER-01` : comparer matériaux, textures, courbes, temps et variantes à une preuve native identifiée ; nommer binaires/assets/captures, garder validation humaine séparée.

Reprendre seulement avec nouveau callsite, artefact serveur, capture pertinente, contrat qualifié ou dérive d’entrée. Ne pas reconstruire sur un simple nom ni rescanner les ressources/probes inchangées.

## 7. Livraison et suite

Preuves datées : `E:/mapslol3v3/audit_sys01202_renekton_passive_vfx_20261105` ; contrats, journaux avant lecture, qualification, cohérence et packet vérifiable. Publication : ce rapport et ajouts sauvegardés à CURRENT/HANDOFF. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2303 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Maokai-PASSIF-PRESENTATION-VFX : examiner d’abord les deux indicateurs «0», RapidFire/Annie/DarkWind et leur applicabilité.
