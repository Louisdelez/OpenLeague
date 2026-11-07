# SYS-01.2-02 — Urgot : débuff passif et consommateurs VFX, V1415

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-URGOT-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Urgot-PASSIF-PRESENTATION-VFX`, `OLF-8237900c-c4bb-55f1-995c-4529ea237e6c` : relier alias, débuff sur la victime, dépendances visuelles et consommateurs actuels. Ce débuff doit modifier les dégâts **sortants de la victime**. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. Sources V645 et HUD existant réutilisés ; QWER complet, réseau et présentation complète restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/urgot-passive-zaun-touched-links-v645.json`,2652607 octets,SHA `c095731ed4adb6953b27d3fa9e3030d07557531ba56d21b799342d8a42ed9a58`. Inspection du26octobre et diagnostic retenus dans E ; aucun accès D/F/OpenLeague-work renouvelé.

Douze ressources primaires :six INIBIN,deux Lua,deux preloads,DDF,font. Deux chunks directs parmi19 vues Lua héritées ;44 autres identités non promues. Lecture antérieure complète sans enfant,12 initialisations littérales,sept limites NEWTABLE,19 globals.

Définition1930 :UrgotEntropyPassive/Urgot_Passive.dds,description « Reduces damage of attack targets » ;Passive1 et six champs de niveau non résolus. CharScript109 déclare Teemo_EagleEye.dds :ni corruption ni substitution établies. UrgotEntropyPassive225 déclare BuffName=UrgotEntropyDebuff et Urgot_Passive.dds ;cet alias ne prouve pas un débuff appliqué.

Font2844 décrit15 % pendant2,5 secondes ;2845 décrit attaques/Acid Hunters,15 % pendant3 secondes. Nom4474/description4298 conservés. Les deux durées restent contradictoires,sans priorité choisie par alias ou majorité. Types de dégâts,refresh,cumul,lifecycle et horloge inconnus. Miroir font vérifié par identité,sans nouveau parcours sémantique.

Seul AutoBuff reconnu :UrgotSlow263 → Global_Slow.troy,contexte distinct du passif. Aucun inventaire complet ni absence globale d’effet déduits. DDF8 lignes,seul E bonusattackdamage×0.6 renseigné ;divergence Q communautaire AP/texte natif physique conservée,sans promotion en logique passive.

Deux preloads,330 octets :CharScript229/SHA `d694760262c2e593c1c5327c014f214f32802ed8b416e7d57a480c6ccda3f0af`,rôle urgotentropypassive ;EntropyPassive101/SHA `ed5820f39b5ef54187f64dffaebb94abee83568343d3356c63cb690808d86389`,rôle urgotentropy_buf. Identités/rôles hérités seulement :texte brut et références typées non présents dans les copies sélectionnées,donc inconnus ;dépendance non équivalente à création/owner/attache.

Deux DDS Urgot propre/shared relus dans E :2176 octets,64×64 DXT1,mip brut1,même SHA `c079365606a53b1ef4db70f70479f1981d7a341668c3e4439016cc8fefb893f5`. Membership hérité,membres174/25 du projet0.0.1.7. Aucun octet Teemo/Troy relu ;priorité provider,variante et pixels non qualifiés. Source communautaire StatsJSON distincte de l’INIBIN.

## 3. Consommateurs réels

Treize fichiers actuels,dont11 Rust et deux lecteurs Python ;26 ancres concordantes. Douze sources/frontières et32 contextes inchangés ;14 entrées communes VFX,deux liens d’animation ordinaire et font concordants.

attacks.rs:167 → basic_attack_hit ;lifesteal.rs:17 → apply_damage Physical ;damage.rs:79 multiplie les dégâts sortants par exhaust_damage_multiplier. summoner_exhaust.rs:38–54 utilise exhaust_until et distingue True. Ce chemin est celui d’Exhaust,aucun producteur Urgot nommé dans les11 préfixes Rust inspectés. Conclusion négative bornée ;réutilisation de l’ancienne recherche client après garde des identités,sans nouveau recensement global.

Les génériques owner/projection/chargement,widget Ezreal et animations ordinaires ne qualifient ni création ni rendu du débuff Urgot.

## 4. Attendu, observé et contrôles

Attendu :conserver sources/refus,établir producteur ou manque borné et reprise. Observé :alias et dépendances reliés ;application,politique exacte et présentation spécifiques non établies.

32/32 contrôles documentaires,52/52 de cohérence séparée du même agent. HUD113/113 hérité. Ancienne cohérence85/86 puis86/86 :diff exact revérifié,une seule attente de comptage corrigée5INIBIN/3Lua→6/2 ;autres85 objets inchangés,échec original conservé.

Deux cas hérités,niveaux1/18 :un projectile Urgot→Annie chacun,quatre déplacements publics,4207 ticks,deux apports XP diagnostiques. Vingt-trois calculs PV/régénération réutilisés,sans recalcul. Soixante-six échantillons API Annie→Urgot conservent Outcomes/health_removed,sans toutes les paires PV brutes. Après impact,ratios1 aux ticks relatifs0/74/75/89/90/91 ;aucune contre-attaque ordinaire effectuée. Une absence d’état actif ne démontre pas son expiration native.

Exhaust est un témoin distinct :0.6 physique/magique et1 vrai aux0/74,puis1 aux75/76 ;aucune règle Urgot dérivée. Soixante-deux refus avec flags d’immutabilité conservés,sans prétendre à62 paires brutes.

Ancien RUN189647 et dépendances non relus. Binaire6072832 octets,SHA `f31916c0b490114fd1149f3524da8a1f5d4ca939fd397f2b07b87d307bf3cf05`,identité inerte. Six productions actuelles réussies ;une erreur de nom de fichier pendant le repérage et un libellé générique de garde consignés dans root_context_notes.json. Aucun nouveau build,test Rust,jeu,décodage natif,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

Durée2,5/3s,triggers exacts,vrai dégât,refresh/cumul,lifecycle,audiences,recette/owner/attache,lookup/variante et pixels restent ouverts. **Le rendu du débuff reste non qualifié.** Slow,Exhaust et Teemo ne remplacent pas le passif. Aucune revue indépendante/humaine ni qualification de l’inventaire secondaire complet.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses :POLICY-01 qualifie contrat/présentation ;APPLY-01 produit l’état victime et consomme ses dégâts sortants ;NETWORK qualifie transitions/audiences ;VFX relie présentation et rendu. Dépendances DAMAGE-01 et HUD-BINDINGS-01 existantes conservées. Préconditions,fins et reprises précises ;aucun besoin de refaire tout QWER avant le premier cas d’attaque.

Reprendre sur source/capture/callsite nouveau ou dérive ;implémentation sous autorisation distincte. next_lot.json vise Varus :consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_urgot_passive_vfx_20261106` :projections,fenêtres,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,avec sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
