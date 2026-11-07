# SYS-01.2-02 — Vayne : Night Hunter et consommateurs VFX, V1417

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VAYNE-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Vayne-PASSIF-PRESENTATION-VFX`, `OLF-6f742c1b-dfbb-5488-9dda-dc2d8e15fbfa` : relier SpeedPart normal/renforcé, dépendances et consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. SOURCE V647 et HUD V1290 réutilisés ; R, QWER complet, réseau et présentation complète restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/vayne-passive-night-hunter-links-v647.json`,2987012 octets,SHA `ebcda7172cd121d660d404fa667fc91ee74a3055f38d1845b4e546710c80d0bc`. UTC documentaire 2026-10-27T00:05:48.571315+00:00. Métadonnées et captures E réutilisées ; aucun accès D/F/OpenLeague-work renouvelé.

Treize ressources primaires : deux INIBIN,cinq Lua,quatre preloads,DDF,font ;38 identités voisines non promues. Cinq chunks directs parmi18 vues Lua sans prototype enfant :16 initialisations littérales,deux limites NEWTABLE,49 globals. CharScript et Hunted56 vides.

Vayne.inibin3333 : alias Focus,icône Vayne_NightHunter.dds,description brute Ashe/critique conservée ;Passive1 et six champs de niveau non résolus. Deux Focus identifiés sous Ashe ne prouvent pas un producteur Night Hunter. Recherche globale antérieure réutilisée,sans nouveau parcours des fichiers natifs.

SpeedPart et SpeedPartNormal98 déclarent chacun AutoBuffActivateEffect vide. Cela ne démontre aucune absence globale d’effet. Six vues portent19 champs AutoBuff : Q/Tumble,Silver et vitesse restent distincts. Global_Haste avec l_hnd/r_hnd et vayne_Q_buf avec l_hand/r_hand ne donnent pas les attaches du passif.

Nom4476/description4300 : +30 de déplacement vers les champions ennemis proches. R11989/Effect4=90 ;rangs1/2/3,durées8/10/12,AD30/50/70. Buff2861/SourceName concerne R. Rayon,angle,visibilité et activation restent inconnus. DDF12 lignes,Q totalAD.3/.35/.4/.45/.5 et E bonusAD.5 non politiques directionnelles. R communautaire fixe8s divergent. Miroir font vérifié par identité,sans reparcours sémantique.

Quatre identités preload,800 octets :Char495,Inquisition93,SpeedPart104/SHA `21f6a27fd71df33fc57ea961aa56984aaa5f1823465619e20093834d421d0a88`,Normal108/SHA `1f9f74d0c7784084fb178cf7d1bb9e0839dc14c4d317ff96058f8152983173ad`. Rôles hérités vayne_ult_speed_buf et vayne_passive_speed_buf distincts. Texte brut et références typées non présents dans les copies sélectionnées,donc inconnus ;ni création,owner,attache ou horloge déduits.

Icône présente sous `DATA/Characters/Vayne/Info/Vayne_NightHunter.dds`,hors ancien filtre HUD/Icons2D. Qualification Info conservée,identités des deux inventaires et échec initial vérifiés. Un DDS relu dans E :2176 octets,64×64 DXT1,mip brut1,SHA `f8a20962056ad37103f259da07544372ac2da056497344742f084e42b458934a`. Membership30/projet0.0.1.7 hérité ;provider,skin,pixels et Troy non qualifiés. StatsJSON communautaire distinct de l’INIBIN.

## 3. Consommateurs réels

Onze fichiers actuels,dix Rust et un lecteur Python ;24 ancres concordantes. Dix sources/frontières,32 contextes,14 entrées VFX communes,deux liens d’animation ordinaire et font inchangés.

movement.rs:37–56 compose base/objets,Garen,Heal,relique,Trundle et ralentissements ;entity_facing.rs:34–41 renseigne seulement Garen/Trundle. Orientation native Vayne non déduite des cosinus de déplacement. Aucun producteur nommé dans dix préfixes Rust inspectés ;ancienne recherche client réutilisée après garde,conclusion bornée.

Owner/projection/chargement,widget Ezreal et animations ordinaires ne constituent pas la présentation Night Hunter.

## 4. Attendu, observé et contrôles

Attendu : conserver déclarations,distinguer variantes,établir producteur ou manque borné et reprise. Observé : dépendances normale/renforcée identifiées,activation et rendu non établis.

32/32 contrôles documentaires qualifiés,53/53 de cohérence séparée du même agent. HUD128/128 et132/132 corrigés hérités. Diffs exacts revérifiés :attente du flag négatif corrigée,127 autres checks inchangés ;référence Focus de type identité qualifiée,131 autres inchangés. Script original14318/SHAa8c8a817 et assertion « assert not focus_matches » conservés,sans exécution.

Deux diagnostics L1/L18 :quatre trajets publics de préparation,six parcours vers/opposé/latéral,60 frames en mouvement et20 immobiles. Premières/dernières frames des six parcours relues ;vitesse330,sans bonus observé. Soixante métriques positions/cosinus et quinze Garen héritées,sans recalcul ni replay. Points300→190 et cosinus ne définissent pas le rayon/angle natifs. R refusé/non activé,aucun bonus90 mesuré.

Témoin Garen Q public distinct :345→455.6→345,expiration45 ;3960 ticks des cas +992 témoin =4952. Un XP diagnostique100000 ;60 refus flags,sans toutes les paires individuelles. Ni progression naturelle complète,mort ou fin de partie qualifiées.

Ancien RUN corrigé379374 avec dix lignes diagnostiques et premier RUN1 « destination unreachable » restent hérités ;branche initiale non attribuable. Aucun ancien log/dépendance/EXE relu. Binaire corrigé6086656/SHA `53a17239d46a747a0f6388ff89d5fac80fdd6f399d4a86eb7053ed00b02816be`,identité inerte.

Échecs actuels conservés :préparation partielle puis lecture de script absent ;collecteur31/32 attendait side au lieu du libellé archivé sideways. Qualification corrige uniquement ce prédicat,autres31 checks/fenêtres/trames inchangés. evidence_review_corrected.json fait autorité. Six productions réussies,deux échouées conservées. Préparation du paquet initiale échouée sur la lecture indisponible enregistrée ;adaptation bornée à cet unique FileNotFoundError,sans octets source inventés,original et journal conservés. Aucun nouveau build,jeu,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

Activation,rayon/angle/visibilité,cibles/pets/clones,ordre/caps,lifecycle,audiences,recette/owner/attache,lookup/provider/skin et pixels restent ouverts. **Le rendu des variantes de vitesse reste non qualifié.** AutoBuff vide,Focus/Ashe et témoin Garen ne remplacent pas Night Hunter. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json conserve quatre clauses :POLICY-01 qualifie condition directionnelle/variantes ;MOVEMENT-01 produit et consomme l’état ;NETWORK qualifie transitions/audiences ;VFX relie chaque variante au rendu. HUD-BINDINGS et correction Info existants préservés. Préconditions,fins et reprises précises,sans attendre tout QWER pour un cas normal.

Reprendre sur source/capture/callsite nouveau ou dérive ;implémentation sous autorisation distincte. next_lot.json vise Veigar :chercher ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_vayne_passive_vfx_20261106` :projections,fenêtres,témoins de déplacement,qualifications,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
