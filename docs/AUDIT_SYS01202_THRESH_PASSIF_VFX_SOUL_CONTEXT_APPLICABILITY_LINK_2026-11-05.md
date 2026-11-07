# Thresh — Damnation, contexte des buffs et liaison VFX, V1319

## 1. Exigence et décision bornée

Unité `AUD-SYS-01.2-02-THRESH-PASSIF-VFX-APPLICABILITY-LINK-01`, parent SYS-01.2-02 ; tâche `CH-Thresh-PASSIF-PRESENTATION-VFX`, exigence `OLF-09f998c7-e672-58b2-87e9-c1b15f8ccff5`. Phase D06, lot D06-CH-Thresh, six prérequis et dépendance NETWORK examinés sans satisfaction revendiquée. Contrat `a_faire`, implémentation/acceptation false ; inconnue `OLU-8924f435-73d2-53da-b2f2-10659e30ba9f` conservée.

Audit documentaire borné terminable après sept rubriques et relecture. Liaison spécifique Damnation non établie dans le périmètre inspecté ; infrastructures génériques et autres passifs conservés. Vérification statique seulement ; acceptation visuelle humaine à valider. Ni tâche VFX complète, ni champion, ni goal clos.

## 2. Sources et applicabilité

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/thresh-passive-damnation-links-v639.json`, 5476417 octets, SHA256 `22b9c87cbc7c247b99bf80bd2285abd13fa6f9ea2e61ef807ba552ba5efb5bbc`. V669, `reference_requirement_trace_sources/passive-vfx-links-v669.json`, SHA `4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b`, réutilisé via V1314 vérifié. Ancien HUD conservé.

Trace VFX : six relations/cinq IDs. V639 conserve 164 identités : 49 INIBIN, 67 Lua, 46 preloads, DDF et font ; 14 limites littérales Lua. Texte natif : âmes d’ennemis morts proches, collecte de proximité et gains permanents armure/AP ; champions/grands sbires toujours, petits sbires parfois. Valeurs, taux et rayon ouverts. ArmorPerLevel="0" distinct du traitement des âmes ; anciens textes Jax/mana, marqueurs3/7/11/15, DDF Khazix et tooltips Ahri/Maokai non adoptés comme politique.

Propriétaire ThreshPassiveSouls : BuffTextureName=Thresh_Passive.dds, PersistsThroughDeath et flags déclaratifs, sans AutoBuff reconnu. Huit chunks nommés Souls n’exposent aucun AutoBuff reconnu ; Vlad a une initialisation non qualifiée. CharScript vide. Cela ne prouve pas l’absence de graphismes d’âmes ni l’exécution de callbacks serveur.

Groupe primaire V669 : Empower_buf.troy/HaveAfterEffect="0", GlobalHit_Yellow_tar.troy/HaveHitEffect="0", AnnieBasicAttack_mis.troy sans indicateur MissileEffect associé qualifié. Préserver les chaînes littérales sans conversion par vérité de chaîne. Trois champs nommés, un vide, un absent ; activation par Damnation non démontrée.

Deux candidats Shared historiquement membres du projet .7 : Empower, 646 octets/SHA `32919fa4a032b157076381011bbefe7e5370d3ccee72f68a308a387f50a6554b` ; globalhit_yellow_tar, 888 octets/SHA `40124b118147bab29434f2eda2764a8b5e203d114ba3d9e58062e91ad57ad96b`. Priorité/skin/runtime non qualifiés ; nom GlobalHit conservé distinct de la casse du chemin résolu. Candidat Annie absent de l’ancien scan borné, sans nécessité passive démontrée.

Relevé des globals AutoBuff reconnus dans les 67 Lua : quatre sources QWER/contextuelles, intégralement lues, sans prototype enfant et littérales qualifiées, déjà liées à SOURCE V639 :

- ThreshRSlow, `OLS-6ce9da74-7dbd-5e9c-acf0-f3253ab7445c` : GLOBAL_SLOW.TROY.
- ThreshWManager, `OLS-fb04ae7a-0e75-52df-9d24-25d76ed34097` : maokai_sapling_activated_indicator.troy, C_BUFFBONE_GLB_CHEST_LOC.
- ThreshWShield, `OLS-c3a1938c-af2a-52a4-a862-2eb146f3590d` : AutoBuffActivateEvent=DeathsCaress_buf.troy uniquement.
- ThreshWZoneBuff, `OLS-65c78cf4-777b-52e4-a733-10b5d2ab3049` : AutoBuffActivateAttachBoneName3=R_hand, sans Effect3 déclaré dans ce chunk. Source420octets/SHA `5f1b18f05a226a171014ca6118673c8701734e223c536806897eebb5d8e950b7`, membre .254 ; autres identités dans evidence_review.json.

Trois références d’activation et deux attaches, pas quatre effets de Damnation. Event n’est pas assimilé à Effect ; l’attache3 ne justifie ni effet inventé ni nom emprunté. Les quatre sources sont hors sous-ensemble primaire VFX. Identités physiques/sélection des payloads secondaires non qualifiées ici, sans récupération nouvelle ou affirmation d’absence. V669/V1314 restent bornés à leurs sélecteurs.

## 3. Consommateurs actuels

Vingt ancres exactes, 13 fichiers inspectés, 11 comparaisons V639 concordantes. `map_resource_provider.rs` et son initialisation dans `main.rs` résolvent des noms. Sept anciennes requêtes : deux chemins logiques .troy, cinq sans résultat ; aucune ouverture Troybin ni requête des noms secondaires. Ces cinq résultats vides ne sont pas un compte d’assets manquants.

Champion.effects et Snapshot.units/world::Unit existent ; `world.rs::spawn_unit` est une infrastructure générique. Aucun champ Thresh/Soul nommé dans Effects ; Kind comporte onze variantes génériques, sans Soul explicite. Cela n’exclut pas une représentation générique/dynamique d’une âme.

Chemins réels inspectés : damage.rs129–137 et world.rs355–414 conservent le traitement Trundle à la mort, les récompenses et le retrait des unités. Aucun producteur Damnation nommé identifié dans ces routes. Quatre hits larges «thresh» sont des lexèmes threshold ; le motif délimité les distingue, conformément à la discipline V639. Aucun recensement global rejoué.

Quatorze identités communes V1315 inchangées permettent de réutiliser helpers spatiaux, matrices fournies par l’appelant, arrêt d’owner et route Annie. Relic expose des sous-catalogues DDS de 9/17 entrées, pas les cinq noms Effect examinés ; refus dérivés statiquement, Event exclu. Le catalogue Map10 précis de 26 définitions ne contient pas ces noms : aucune absence globale prouvée.

## 4. Attendu, observé et contrôles

Attendu : relier source/route, distinguer contexts R/W et âmes, conserver Event et attache seule sans inventer. Observé : 51/51 contrôles documentaires, 50/50 cohérence séparée du même agent, sans revue indépendante. Nominal : sources existantes et routes de mort exactes. Limites : Event seul, attache3 sans nom, initialisation Vlad inconnue et métadonnée distincte d’un rendu. Aucun échec matériel dans ce lot.

V639 hérité : deux diagnostics Thresh/Annie, niveaux1–18 par XP API, 278 refus de commandes et dix refus XP, zéro tick simulé. Armure Thresh16 constante ; aucune mort, âme déposée/collectée ou image exercée. Ancien binaire5489152octets/SHA `2aa6a68fef42a6ad8254a9af20edfbac218bbee75a36c7524e4aad3cf50d4e75`, identifié par le MD V639, non réouvert/exécuté. Aucun nouveau build, jeu, GPU, REA, accès D, scan global ou décodage.

## 5. Écarts ouverts

Callbacks de mort/éligibilité/dépôt, objets d’âme, collecte, rayon/taux/valeurs, état/owner, source visuelle réelle, montage/skin, bones, Event, cycle de vie, audience et fidélité non qualifiés. Persistance du buff et armure sans croissance ne définissent pas le cycle graphique. HUD, QWER, mécanique, réseau et acceptation restent distincts.

## 6. Corrections et reprise

Réutiliser CH-Thresh-PASSIF-PRESENTATION-VFX ; propositions documentaires sans changement de registre :

- `COR-THRESH-PASSIF-VFX-SOURCE-SCOPE-01` : identifier la recette visuelle réelle des âmes et qualifier séparément candidats primaires et contextes R/W ; pas de liaison déduite du nom.
- `COR-THRESH-PASSIF-VFX-SOUL-PRODUCER-01` : qualifier événements autoritatifs de mort/dépôt et projection d’objet ; vérifier catégories admissibles/refusées, position/propriété et absence de doublons sans altérer Trundle.
- `COR-THRESH-PASSIF-VFX-EVENT-ATTACH-CONTRACT-01` : identifier lecteurs d’Event et d’attache3 ; vérifier champ seul, effet absent, valeurs invalides et sélection sans fallback inventé.
- `COR-THRESH-PASSIF-VFX-RESOURCE-RENDER-01` : identifier/ouvrir les ressources applicables, montage/skin et poses ; comparer le rendu à une preuve native avec binaires/assets/captures nommés, acceptation humaine séparée.
- `COR-THRESH-PASSIF-VFX-COLLECT-LIFECYCLE-01` : vérifier collecte autoritative, retrait, expiration, audiences/reconnexion et absence de double collecte ; gains mécaniques et HUD séparés.
- Réutiliser `COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01` : inclure Event seul, attache seule et limites de lecture, sans clôture collective implicite.

Reprendre avec nouveau callsite, contrat autoritatif, identité d’asset, capture pertinente ou dérive d’entrée ; aucune répétition inchangée.

## 7. Livraison et suite

Preuves datées : `E:/mapslol3v3/audit_sys01202_thresh_passive_vfx_20261105`, contrats, journaux avant lecture et reçus. Publication : ce rapport et ajouts sauvegardés à CURRENT/HANDOFF. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2306 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Yasuo-PASSIF-PRESENTATION-VFX : buffs secondaires et champs Event/attaches avant ChronoClock/SpiralBlade/DarkBinding et indicateurs "0".
