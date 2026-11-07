# Quinn — Harrier, buffs secondaires et applicabilité VFX, V1318

## 1. Exigence et décision bornée

Unité `AUD-SYS-01.2-02-QUINN-PASSIF-VFX-APPLICABILITY-LINK-01`, parent SYS-01.2-02 ; tâche `CH-Quinn-PASSIF-PRESENTATION-VFX`, exigence `OLF-6962230e-15b5-5c7c-824b-264954eeb18d`. Phase D06, lot D06-CH-Quinn, six prérequis et dépendance NETWORK examinés sans satisfaction revendiquée. Contrat `a_faire`, implémentation/acceptation false ; inconnue `OLU-a513b2b3-e200-5783-a4b6-11546f29664b` conservée.

Audit documentaire borné terminable après sept rubriques et relecture. Implémentation Harrier spécifique non établie dans le périmètre inspecté ; primitives génériques conservées. Vérification statique seulement ; acceptation visuelle humaine à valider. Ni tâche VFX complète, ni champion, ni goal clos.

## 2. Sources et frontières d’applicabilité

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/quinn-passive-harrier-links-v616.json`, 3022937 octets, SHA256 `ae8f61a03ad5e26718c2bda74af3ff25ab53205a05ffb2979dcdd2155e8183be`. V669, `reference_requirement_trace_sources/passive-vfx-links-v669.json`, SHA `4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b`, réutilisé via V1314 vérifié. Ancien HUD conservé.

La trace VFX contient six relations/quatre IDs. V616 conserve 101 identités : 32 INIBIN, 44 Lua, 22 preloads, deux DDF et font ; 14 limites littérales Lua. Passive1LuaName=QuinnPassive ; icône Quinn_Passive.dds, sans AutoBuff primaire déclaré. CharScript vide. Texte natif : marquage périodique par Valor et bonus physique au premier coup contre une cible Vulnérable ; période, sélection, f1/f2/f3 et propriété restent ouverts. « Attack Speed », champ candidat28s et données Khazix/Volibear ne deviennent pas une formule Harrier.

Groupe primaire V669 : trois champs distincts nomment AnnieBasicAttack_mis.troy ; HaveAfterEffect et HaveHitEffect sont les chaînes "0", sans indicateur MissileEffect associé qualifié. Trois champs nommés, un vide, un absent. Préserver les valeurs sans conversion par vérité de chaîne. Aucun candidat dans le scan borné historique ; cela ne prouve pas un asset nécessaire manquant.

Relevé secondaire des globals AutoBuff reconnus dans les 44 Lua : six sources, toutes intégralement lues, zéro prototype enfant et initialisation littérale qualifiée. Elles sont déjà liées à SOURCE V616, hors sous-ensemble primaire VFX :

- QuinnPassiveAmmo : `OLS-d03017c0-e368-5475-86aa-fd4421bc4af6`, 590 octets/SHA `bc69d63766c92315c308900193d105dd654382333571555cc50524eb4ed5f444`, membre .235. Quinn_Base_P_Buff.troy/Weapon_Top et Global_Haste.troy/Buffbone_Glb_Ground_Loc ; icône Quinn_W.dds, priorité3/ordre d’expiration déclaratifs, sans callback exécuté.
- QuinnPassiveVFX : `OLS-ea3ad689-20a7-5475-9ef2-b974fd9c921a`, 180 octets/SHA `cb18d483812fc692a40c4e13c0eca03cbd95a851e528008aaf9d4e299caa8382`, .235 ; même effet Buff/Weapon_Top, sans fusion des owners.
- QuinnPassiveInCombat : `OLS-0033c554-e5a8-59b0-b2dc-12ddec8f5dd1`, 304 octets/SHA `ba64fe3a08e8b9b073900dacae4daf418c2ceab0d78f73916e8fe59d1392eaee`, .150 ; AutoBuffActivateEvent=DeathsCaress_buf.troy uniquement.
- Contextes QuinnValorQ, QuinnWInFlight et QuinnWInFlight2 : GLOBAL_SLOW.TROY, Quinn_W_silver_large.troy et deux autres occurrences Event=DeathsCaress_buf.troy. IDs, empreintes et appartenances dans evidence_review.json ; liaison au passif non démontrée. QuinnWInFlight et InCombat ont les mêmes octets mais restent deux sources distinctes.

Total de ce relevé : quatre références de fichiers nommés Passive et quatre de contexte QWER/Valor ; ce sont des métadonnées, pas huit effets acceptés. Event reste distinct d’Effect : une extension .troy n’établit pas sa sémantique. Deux fichiers Event seuls auraient été omis par un filtre limité à Effect. Identités physiques et sélection des payloads secondaires non qualifiées ici ; aucune récupération nouvelle ni affirmation d’absence. V669/V1314 restent des comptes bornés à leurs sélecteurs primaires.

## 3. Consommateurs actuels

Trente ancres exactes, 22 fichiers inspectés, 20 comparaisons V616 concordantes. `map_resource_provider.rs` et son initialisation dans `main.rs` sont des frontières de noms. Huit anciennes requêtes, dont trois Annie répétées, sans résolution ; aucune ne couvre les noms secondaires. Ne pas compter huit assets manquants.

Champion.effects/Snapshot.players existent ; `spells.rs::Effects` ne porte aucun champ Quinn/Harrier/Valor nommé. Aucune route nommée identifiée dans le code sélectionné ; cela n’exclut pas tous les mécanismes génériques/dynamiques. Attaque physique et projectile génériques ne démontrent pas sélection, marquage ou consommation Harrier.

Quatorze identités communes V1315 inchangées permettent la réutilisation des helpers spatiaux, matrices fournies par l’appelant, arrêt d’owner et route Annie. Relic expose des sous-catalogues DDS de 9/17 entrées, pas les cinq requêtes de noms Effect examinées ; refus dérivés statiquement. Les valeurs Event sont exclues de cette assimilation. Le catalogue Map10 précis de 26 définitions ne contient pas ces noms Effect : aucune absence globale prouvée.

## 4. Attendu, observé et contrôles

Attendu : séparer candidats primaires, déclarations secondaires et Event ; conserver provenance et vérifier les routes. Observé : 47/47 contrôles documentaires, 52/52 cohérence séparée du même agent, sans revue indépendante. Nominal : sources existantes et bones exacts reliés. Limites : Event seul conservé, indicateur "0" distinct d’activation, déclaration distincte d’un callback/rendu. Aucun échec matériel dans ce lot.

V616 hérité : deux cas base/+10AD, 12 impacts à distance, 54 refus et 3604 ticks d’attente ; dommages ordinaires seulement. Les attentes901ticks ne qualifient pas le champ candidat28s ni l’absence d’une image. Valor non exercé. Ancien binaire 6061568 octets/SHA `323c52ecb31c1db3aa96b769e2c80c48ce7817591f717fcb953c7f9e5c787698`, identifié par le MD V616, non réouvert/exécuté. Aucun nouveau build, jeu, GPU, REA, accès D, scan global ou décodage.

## 5. Écarts ouverts

Rôle exact des six recettes secondaires, consommateur d’Event, marquage/période/cible/owner, activation et consommation, montage/skin, conversion, bones réels, cycle de vie, audience et fidélité visuelle non qualifiés. Les 14 limites Lua empêchent toute exhaustivité d’exécution ; persistance et priorité littérales ne définissent pas les callbacks. HUD, QWER, Valor, mécanique, réseau et acceptation restent distincts.

## 6. Corrections et reprise

Réutiliser CH-Quinn-PASSIF-PRESENTATION-VFX ; propositions documentaires sans changement de registre :

- `COR-QUINN-PASSIF-VFX-SOURCE-SCOPE-01` : relier sources secondaires/IDs aux clauses applicables ; qualifier chaque rôle, sans fusion par nom ou empreinte.
- `COR-QUINN-PASSIF-VFX-EVENT-CONTRACT-01` : identifier le consommateur original d’AutoBuffActivateEvent, son type et ses conditions ; vérifier Event seul, valeurs invalides et distinction avec Effect.
- `COR-QUINN-PASSIF-VFX-TRIGGER-01` : qualifier période, sélection, propriété, expiration et consommation ; vérifier cible valide/invalide, premier coup et projection sans doublon.
- `COR-QUINN-PASSIF-VFX-OPEN-ATTACH-01` : identifier/ouvrir les payloads applicables, montage/skin et matrices/bones ; vérifier ambiguïtés/refus, sans fallback inventé.
- `COR-QUINN-PASSIF-VFX-LIFECYCLE-RENDER-01` : vérifier owners, retrait, audiences/reconnexion et rendu sur référence native identifiée ; binaires/assets/captures nommés, acceptation humaine séparée.
- Réutiliser `COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01` : inclure les champs Event seuls et les limites de décodage dans l’examen individuel, sans clôture collective implicite.

Reprendre avec nouveau callsite, contrat autoritatif, identité d’asset, capture pertinente ou dérive d’entrée ; aucune répétition inchangée.

## 7. Livraison et suite

Preuves datées : `E:/mapslol3v3/audit_sys01202_quinn_passive_vfx_20261105`, contrats, journaux avant lecture et reçus. Publication : ce rapport et ajouts sauvegardés à CURRENT/HANDOFF. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2305 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Thresh-PASSIF-PRESENTATION-VFX : examiner les buffs secondaires et Event avant les noms Empower/GlobalHit/Annie et leurs indicateurs "0".
