# Maokai — passif, buff prêt et applicabilité VFX, V1317

## 1. Exigence et décision bornée

Unité `AUD-SYS-01.2-02-MAOKAI-PASSIF-VFX-APPLICABILITY-LINK-01`, parent SYS-01.2-02 ; tâche `CH-Maokai-PASSIF-PRESENTATION-VFX`, exigence `OLF-7daf1a4e-7117-57a9-b21e-132b4da9bcc0`. Phase D06, lot D06-CH-Maokai, six prérequis et dépendance NETWORK examinés, sans satisfaction revendiquée. Contrat `a_faire`, implémentation/acceptation false ; inconnue `OLU-b8bde3fe-98c8-5851-9fb8-543a7318303b` conservée.

Audit documentaire borné de liaison et d’applicabilité terminable après sept rubriques et relecture. Implémentation spécifique non établie dans le périmètre inspecté ; helpers génériques conservés. Vérification statique seulement ; acceptation visuelle humaine à valider. Ni tâche VFX complète, ni champion, ni goal clos.

## 2. Sources : distinguer les deux groupes

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/maokai-passive-sap-magic-links-v600.json`, 1465409 octets, SHA256 `e347ef72db3d40fa32658731ca5c27ce1509fe346a6b4468231f8e6629ff0d23`. V669, `reference_requirement_trace_sources/passive-vfx-links-v669.json`, SHA `4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b`, réutilisé via V1314 vérifié. Audit HUD antérieur conservé.

La trace VFX contient huit relations/six IDs. V600 conserve 62 identités : 21 INIBIN, 26 Lua, 14 preloads et font ; une limite littérale Lua. Passive1LuaName=MaokaiSapMagicPass ; ce propriétaire déclare BuffName et PersistsThroughDeath, sans AutoBuffActivateEffect. CharScript vide. Les textes natifs décrivent cinq sorts proches puis un coup de base soignant 7%PV maximum ; rayon, éligibilité et producteur @f1@ restent ouverts.

Groupe primaire V669 : RapidFire_buf.troy/HaveAfterEffect="0", AnnieBasicAttack_mis.troy/HaveHitEffect="0", DarkWind_mis.troy sans indicateur associé qualifié. Préserver les chaînes littérales, sans conversion par vérité de chaîne ni activation déduite du nom. Trois champs nommés, un vide, un absent. Valeurs héritées de SpellData distinctes de la politique de Sap Magic ; les références Nidalee/Jester ne sont pas adoptées.

RapidFire Shared : 587 octets/SHA `f7c0624d4aaf0b091f0c631f77f93e9e6915401f9d5532f7954228e2890ff4f2`, membre .142. DarkWind DATA/Particles : 1498 octets/SHA `cc3cf08521a55df7b2515e03ebb825e2b8a46f5edb79e3b1fa4625b60e04e002`, .248 ; appartenance historique au projet .7, sans priorité/runtime qualifiés. Candidat Annie absent du scan borné antérieur, sans nécessité passive démontrée.

Groupe « prêt » supplémentaire, déjà documenté dans V600 : `maokaisapmagicmelee.luaobj`, 411 octets/SHA `7bc829eb6b20ff06df0f91cb71ab18d81689f588377fd0ee3dafcfe3d6fad5bd`, membre .7. Lecture intégrale, zéro prototype enfant, initialisation littérale qualifiée : Maokai_Base_P_cas.troy et Maokai_Base_P_active.troy, tous deux attachés à L_BUFFBONE_GLB_HAND_LOC. BuffName=MaokaiSapMagicMelee, icône Maokai_PassiveReady.dds distincte de Maokai_Passive.dds.

Source existante `OLS-c65afd5e-334e-55ff-9c26-3f382babc4d5`, association SOURCE V600 /native_inputs/41 ; absente du sous-ensemble primaire VFX. Les deux noms prêts n’étaient pas interrogés par l’ancien profil. Identités physiques et sélection de leurs Troy non qualifiées ici : aucune affirmation d’assets manquants. Les trois candidats primaires ne sont donc pas un inventaire exhaustif. Les comptes historiques V669/V1314 restent bornés à leurs sélecteurs, sans réécriture.

## 3. Consommateurs actuels

Trente-cinq ancres exactes, 26 fichiers inspectés, 24 comparaisons V600 concordantes. `map_resource_provider.rs` et son initialisation dans `main.rs` résolvent des noms. Sept anciennes requêtes : deux chemins logiques .troy, cinq sans résultat ; aucune ouverture Troybin ni sélection des deux effets prêts démontrée.

Champion.effects/Snapshot.players existent ; `spells.rs::Effects` ne porte aucun état Maokai/SapMagic nommé. Aucune route nommée dans le code sélectionné, sans exclusion de tout mécanisme générique/dynamique. `healing.rs::heal` fournit un soin générique ; `annie_passive.rs` filtre explicitement Annie et ne constitue pas un compteur Maokai de sorts proches.

Quatorze identités communes V1315 inchangées permettent la réutilisation des helpers spatiaux, matrices fournies par l’appelant, arrêt d’owner et route Annie. Relic expose des sous-catalogues DDS de 9/17 entrées, sans admission de ces cinq noms Troy ; refus dérivé statiquement. Le catalogue Map10 précis de 26 définitions ne contient pas leurs références : aucune absence globale d’assets prouvée.

## 4. Attendu, observé et contrôles

Attendu : préserver les indicateurs, retrouver les déclarations pertinentes dans SOURCE, distinguer métadonnée/activation et vérifier les consommateurs. Observé : 48/48 contrôles documentaires, 54/54 cohérence séparée du même agent, sans revue indépendante. Nominal : source prête, deux effets et bone reliés. Limites : indicateurs primaires "0", nom logique distinct d’une ouverture, déclaration prête distincte d’un déclenchement ou d’une image. Aucun échec matériel dans ce lot.

V600 hérité : deux cas base/rubis, dix Q Annie proches acceptés, six attaques Maokai, 54 refus et 360 ticks finaux. Aucun soin passif observé ; les 40,054/50,554PV de référence sont théoriques, non observés. Cela ne prouve aucune absence d’image VFX. Ancien binaire 6053888 octets/SHA `303b190c553d5adbce29ce7d94a7fd7afa4e0989da52d5606dd93e21f58f9b10`, identifié par le MD V600, non réouvert/exécuté. Aucun nouveau build, jeu, GPU, REA, accès D, scan global ou décodage.

## 5. Écarts ouverts

Compteur/éligibilité/rayon, état prêt/consommation, callbacks, identité/montage des deux Troy prêts, conversion, bones réels, propriétaire, cycle de vie, audience/skin et fidélité visuelle restent non qualifiés. PersistsThroughDeath du propriétaire ne définit pas le cycle graphique du buff prêt. HUD, QWER, mécanique, réseau et acceptation restent distincts.

## 6. Corrections et reprise

Réutiliser CH-Maokai-PASSIF-PRESENTATION-VFX ; propositions documentaires, aucun registre modifié :

- `COR-MAOKAI-PASSIF-VFX-READY-SOURCE-LINK-01` : relier le SOURCE existant aux deux déclarations prêtes dans le périmètre VFX ; vérifier IDs/provenance et conserver les candidats primaires séparés.
- `COR-MAOKAI-PASSIF-VFX-TRIGGER-01` : qualifier compteur, éligibilité, prêt/consommation ; vérifier cinq charges, charge insuffisante, coup valide/invalide et transitions avant projection.
- `COR-MAOKAI-PASSIF-VFX-READY-OPEN-01` : identifier et ouvrir les payloads prêts, montage/skin, groupes et textures ; vérifier ambiguïtés et refus sans fallback inventé.
- `COR-MAOKAI-PASSIF-VFX-ATTACH-LIFECYCLE-01` : qualifier bone/matrice, owner, démarrage/arrêt, mort et reconnexion ; vérifier retrait et absence de doublons.
- `COR-MAOKAI-PASSIF-VFX-RENDER-01` : comparer matériaux, courbes, temps et variantes sur preuve native identifiée ; nommer binaires/assets/captures, acceptation humaine séparée.
- `COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01` : examiner les buffs secondaires des reçus SOURCE avant une conclusion globale ; nommer individus/sélecteurs couverts, sans nouvelle clôture collective implicite.

Reprendre avec nouveau callsite, contrat autoritatif, identité d’asset, capture pertinente ou dérive d’entrée ; aucune répétition inchangée ni reconstruction fondée sur un simple nom.

## 7. Livraison et suite

Preuves datées : `E:/mapslol3v3/audit_sys01202_maokai_passive_vfx_20261105`, contrats, journaux avant lecture et reçus. Publication : ce rapport et ajouts sauvegardés à CURRENT/HANDOFF. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2304 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Quinn-PASSIF-PRESENTATION-VFX : examiner les buffs secondaires SOURCE avant les trois noms Annie et leurs indicateurs "0".
