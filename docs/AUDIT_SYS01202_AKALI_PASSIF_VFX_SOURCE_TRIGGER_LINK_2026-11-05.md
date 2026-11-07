# Akali — Twin Disciplines, source, déclenchement et effets visuels

2026-11-05 · V1315 · AUD-SYS-01.2-02-AKALI-PASSIF-VFX-SOURCE-TRIGGER-LINK-01

## 1. Exigence et périmètre

CH-Akali-PASSIF-PRESENTATION-VFX ; OLF-6cbf2fa0-a1e6-5f8b-acb8-c1046e7a06f4 ; inconnue OLU-1f539d68-c1d5-54fe-9ccf-0a86697c91e2. Relier les deux effets déclarés DMG/L_hand et AP/R_hand aux états et consommateurs actuels. PhaseD06, lotD06-CH-Akali,six prérequis ;dépendance CH-Akali-PASSIF-NETWORK non déclarée satisfaite. Statut a_faire et implémentation/acceptation false conservés.

Audit documentaire clôturable pour cette liaison après publication vérifiée. Implémentation :briques génériques présentes, liaison spécifique non établie dans les routes examinées. Vérification :statique, observations antérieures héritées ;acceptation humaine non donnée. SOURCE/ACCEPTANCE et HUD V1195 existants ne sont pas fermés à nouveau ;ni tâche VFX complète, passif ou jeu terminé.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus ;catalogue4.20.1 distinct. V669,4434580octets,SHA4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b, fournit les deux mentions et candidats. V557 daté 2026-10-25T20:46:42.582936+00:00,568511octets,SHA657e9de21914225f53d11bf2e4b69d81e9d9f3f7be137dcf94fdf50d63e7b2af, fournit13identités natives,quatre Lua et les frontières de mécanique.

AkaliTwinDisciplines.luaobj déclare AutoBuffActivateEffect=akali_twinDisciplines_DMG_buf.troy,AutoBuffActivateAttachBoneName=L_hand ;AutoBuffActivateEffect2=akali_twinDisciplines_AP_buf.troy,AutoBuffActivateAttachBoneName2=R_hand. Les deux Troybin candidats sous DATA/Particles ont une appartenance RADS historiquement vérifiée ;leurs identités complètes restent dans initial_scope.json. Aucun fichier natif D relu/redécodé.

TwinAP/TwinDmg portent chacun leur déclaration correspondante et AkaliTwinDisciplines.dds ;le buff combiné porte33.dds. Graphies NonDispellable/Nondispellable conservées. Quatre initialisations littérales qualifiées sans fonction enfant ;elles ne fournissent ni callback serveur ni condition d'activation. PersistsThroughDeath ne détermine pas à lui seul la vie de l'effet de scène. Les paramètres f1/f2 et le modulo C# communautaire ne deviennent pas des règles natives.

## 3. Consommateurs réels

La trace VFX comporte cinq relations vers quatre IDs natifs, six consommateurs. Union avec les17frontières V557 :23ancres exactes. Trente fichiers courants inspectés ;14comparaisons V557 et14comparaisons sélectionnées V1314 concordent. Le grand census498fichiers et les gros blobs compilés restent des preuves datées réutilisées ;ils ne sont pas recopiés ou recherchés de nouveau ici.

Snapshot expose Champion.effects:spells::Effects et des états partiels nommés, dont Pyromania/Trundle et l'état propriétaire Ezreal. Aucun champ Twin/Akali spécifique identifié dans ces structures. Stats, attaques physiques et vol de vie d'objet existent ;ils ne sont pas un producteur d'état du passif qualifié.

Provider/SearchProvider insèrent et résolvent des noms. Les cinq requêtes Akali V669 sont héritées :quatre résolutions,une sans résultat ;les deux effets retournent des chemins logiques .troy, pas une ouverture .troybin. Aucun asset déclaré manquant sur cette base.

Le consommateur générique relic_recovered_catalog::source_from_provider traite les DDS de son sous-catalogue sélectionné. Deux constructeurs déclarent9puis17textures ;les deux requêtes Troy ne correspondent à aucune de ces constantes. Gardes réelles :requête absente/non résolue et canonique hors sous-catalogue refusés. Ces cas sont dérivés statiquement du code, pas exécutés en Rust.

effect_spatial_registry reçoit des observations/bounds du caller ;simple_attachment reçoit matrice système/position ;effect_owner arrête huit handles existants sans créer le propriétaire. Ces acquis ne nomment pas l'état ou l'os d'Akali. Le chemin projected_live inspecté sélectionne Annie et sa ressource Q ;AnnieReady et l'icône HUD Ezreal restent distincts. Le catalogue Map10 précis contient26définitions/52groupes et aucune référence Twin :cela ne prouve pas une absence globale d'assets ou de chargement dynamique.

## 4. Attendu, observé et contrôles

Attendu :source→déclencheur→résolution/ouverture→pose→renderer, ou manque délimité. Observé :49/49contrôles documentaires,53/53cohérence séparée du même agent ;identités,ancres,déclarations et gardes vérifiées. Les briques existent, mais cette chaîne spécifique n'est pas établie dans les structures et routes inspectées. Recherche nommée bornée sans occurrence de Twin dans ces fichiers ;pas conclusion de tout le moteur.

V557 hérité :quatre cas sans objet/1052/1036/1053,16coups entrants,12attaques,32refus publics,120ticks de suivi. Les impacts physiques et le soin du1053 sont des observations de mécanique, pas des observations VFX. Aucun sort qualifié, supplément magique ou SpellVamp natif accepté. Ni replay/recalcul des cas ni nouveau binaire ;l'ancien binaire et ses1158dépendances ne sont pas requalifiés.

Aucun nouveau build,testRust/Bevy,jeu,REA,VM,réseau,GPU,sonde provider,décodage Troy/DDS ou capture visuelle. Les témoins V1314 sont réutilisés ;seuls les fichiers sélectionnés sont rafraîchis.

## 5. Écarts et inconnues

Activation respective ou simultanée des deux déclarations, état autoritaire, seuils, skins, priorité du provider, ouverture/conversion, pose des mains, temporalité, audience et fidélité graphique restent indéterminés. L'absence d'un champ nommé dans le DTO n'exclut pas tout mécanisme générique ;aucune liaison alternative n'est démontrée par les chemins examinés. Ni os absent, ni texture corrompue, ni effet inutile déduits.

## 6. Corrections et reprise

Conserver la proposition COR-AKALI-PASSIF-VFX-SOURCE-TRIGGER-RENDER-01 liée à la tâche existante ;découpage documentaire sans changement de registre :

- COR-AKALI-PASSIF-VFX-TRIGGER-01 :qualifier événement/état et conditions pour chaque déclaration, depuis source primaire ou contrat explicitement reconstruit ;ne pas déduire l'activation d'un bonus statistique.
- COR-AKALI-PASSIF-VFX-OPEN-CONVERT-01 :prouver provider/montage/variante, ouvrir le Troybin exact, convertir groupes/textures en conservant identité et inconnues ;pas recréer arbitrairement les candidats déjà identifiés.
- COR-AKALI-PASSIF-VFX-ATTACH-01 :relier L_hand/R_hand à la pose du modèle sélectionné et à ses matrices ;vérifier axe/échelle/ordre et refus de pose ou d'os absent.
- COR-AKALI-PASSIF-VFX-LIFECYCLE-01 :propriétaire stable,création/retrait,consommation,mort/réapparition/session ;qualifier la relation avec PersistsThroughDeath au lieu de copier la garde d'Annie.
- COR-AKALI-PASSIF-VFX-AUDIENCE-01 :après NETWORK qualifié,définir propriétaires,visibilité,fraîcheur,reconnexion et doublons ;vérifier les refus sans exposer d'état caché.
- COR-AKALI-PASSIF-VFX-RENDER-01 :brancher le consommateur,qualifier matériau,UV,courbes,temps/skins et comparaison native ;produire reçus/binaire/assets identifiés puis acceptation distincte.

Reprendre sur nouvel artefact/callsite, changement pertinent ou contrat de déclenchement qualifié. Réutiliser V557/V669/V1195/V1314 ;ne pas rejouer les douze attaques ou le même scan de ressources sans raison nouvelle.

## 7. Livraison et cohérence

Preuves E:/mapslol3v3/audit_sys01202_akali_passive_vfx_20261105 :initial_scope,evidence_review,coherence_review,journaux. Sept rubriques relues ;relecture du même agent, pas acceptation indépendante/humaine. Publication limitée à ce rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept registres protégés identiques.

Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2302entrées sales groupées conservées. Goal/Plan/UI/bases/produit/assets inchangés ;aucune tâche,feature,inconnue ou acceptation close. Prochain lot :CH-Renekton-PASSIF-PRESENTATION-VFX ;réutiliser V669, vérifier indicateurs d'activation avant de traiter les deux candidats BloodSlash et leur priorité, sans les supposer indispensables. Goal actif.
