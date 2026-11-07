# SYS-01.2-02 — Velkoz : Organic Deconstruction et HUD, V1292

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VELKOZ-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Velkoz-PASSIF-PRESENTATION-HUD`, `OLF-5d587afd-eab1-5de9-88ea-e7733e680258` : relier icônes/textes,marques de sorts,rafraîchissement,dégâts vrais et HUD aux consommateurs actuels. Contrat a_faire,implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-7fd6c769-36f0-5d28-96f1-9a3e5d7fd5ab` ouverte. Six contrats et prérequis D06/D06-CH-Velkoz consultés sans satisfaction revendiquée. SOURCE/SIMULATION,QWER et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/velkoz-passive-organic-deconstruction-links-v648.json`,3673934 octets/SHA `e301b5b29bc3890f442d9c0b952277874dd80a61a127a421b1d3475000cec81c`,UTC documentaire 2026-10-27T00:30:55.938741+00:00.

HUD enregistré : définition/CharScript et catalogue. SOURCE25 relations/19 identités/six sites ; V64823 frontières,union29 ancres/13 fichiers. Dix-neuf directs : cinq INIBIN,sept Lua,cinq preloads,DDF,font ;63 voisins non promus.36 Lua sans prototype enfant,12 limites littérales. Aucune relecture native des métadonnées.

Définition1188 octets : VelkozPassive,icône Velkoz_Passive.dds. Passive1/Desc/six niveaux non résolus. CharScript,ResearchApply et RResearchBuildup56 vides. Marqueur Passive→2.dds ; Stack→Velkoz_Passive.dds ; Proc→VelkozPassive.dds. Persistance littérale et dépendances Apply→Stack→Tracker/RBuildup→Apply ne prouvent ni lifecycle serveur,ni fréquence de R ou rendu.

Font2868 : sorts qui touchent,troisième touche,dégâts vrais @f1@,perte après7secondes sans touche. **Attaques ordinaires : rafraîchissent seulement,sans ajouter de marques.** Texte cible2871/SourceName emploie attacks,non promu contre la description précise. Nom4478/description4302 résolus. f1/variation par niveau inconnus ;36 lignes DDF sans coefficient/lien peuplé. Deux répertoires communautaires absents dans la sélection,19JSON non assimilés à des callbacks.

Deux DDS lus SOURCE après sélection E,4352 octets : VelKoz_Passive2176,membre200,SHA `16cb534ede7a9bc1014fb908b9d835e4e25999c27274d8c9e41574bc6e545426` ;2.dds2176,membre25,SHA `ce1936a371c8004390b8433281f3e099c16fe0180dc4c67a7aa34fba738ef576`.64×64 DXT1,mip brut0,tailles/MD5 concordants au projet RADS0.0.1.7. **Proc VelkozPassive.dds introuvable par basename exact insensible à la casse dans ce manifeste70286 membres.** Pas de réécriture vers Velkoz_Passive ; autre provider/alias/pixels ouverts.

Sept archives2579655 octets sélectionnées avant lecture F/OpenLeague-work. Scripts initial/corrigé et pilote conservés ; aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue StatsJSON communautaire et INIBIN natif.

## 3. Consommateurs actuels

29 ancres,36 fichiers code/configuration,16 entrées communes et24 identités V648 comparables inchangées. advance_attacks/basic_attack_hit/apply_damage portent les attaques physiques. Profil local MissileSpeed8000 lié au BasicAttack natif ; aucun faisceau visuel historique qualifié. DamageKind::True existe,distinct du producteur de marques.

Ignite charge ignite_rules.json hors tests ; native_summoners_420.json est un contexte de tests,non source runtime ajoutée. L’ancien KeyError d’inspection est conservé. PV/Mana ont un HUD générique ; maxima ne prend pas Velkoz en charge. Recherche Velkoz/Research/Organic Deconstruction vide dans les sources Rust sélectionnées : absence bornée,sans conclusion mondiale. Aucun widget/statut spécifique qualifié.

## 4. Attendu, observé et contrôles

Archives L1/L18 : **six impacts publics non critiques physiques**,trois par niveau.196 paires PV pendant les attaques et422 après =618 paires recalculées float32/régénération. Six pertes concordantes avec armure courante à0.002PV près ; aucun supplément inexpliqué.211ticks d’observation après chaque dernier impact, cible non marquée.

Ce résultat est compatible avec le texte natif : les attaques ne créent pas de marques. Ni génération par sorts,ni rafraîchissement d’une marque existante,ni troisième sort ou expiration7secondes exercés. Learn/Cast/CastAt refusés ; ne pas convertir211ticks en preuve d’expiration d’un statut absent.

Embrasement séparé : cinq applications14 aux0/30/60/90/120,statut absent dès150 ;181 frames conservent attendu/observé dérivés,sans paires PV brutes individuelles. Pas de recalcul indépendant de ces soustractions,ni de politique native/f1 déduite.58 refus flags, toutes les paires de snapshots complètes non archivées. Six trajets publics arrivés sans réordre ;6532ticks archivés,deux apports diagnostiques100000XP,pas progression naturelle,aucune mort/fin de partie.

RUN brut égal OBS,BUILD/RUN hérités0. Binaire inerte6077952 octets/SHA `77a57a995bc4dd9ff8772f95d6e02366eb5e72f1864465ebc4241b91597bff50`,identité non fraîchement rehashée.114/114 contrôles,107/107 cohérence séparée du même agent ; productions actuelles journalisées0. Aucun nouveau jeu/build/VM/REA/GPU/réseau ni revue indépendante/humaine.

Ancien pilote : en-tête erroné direction/movement-speed conservé ; corps Rust/observations concernent bien attaques/Embrasement. Une exploration E-only a supposé positive_control au lieu du vrai periodic_control et échoué ; requête corrigée,aucune production ou donnée de jeu modifiée.

## 5. Écarts et inconnues

f1/échelons,règles précises des touches multiples/cibles,cumuls/overlap/refresh,fréquence R,ordre avec boucliers/immunités,expiration et lifecycle ouverts. Icône Proc,provider/variantes,transport du compteur,HUD,tooltip,pixels,animation/audio non qualifiés. Attaques sans marque et témoin Ignite ne prouvent pas le passif complet.

## 6. Corrections et reprise

`COR-VELKOZ-DECONSTRUCTION-POLICY-01` : sourcer f1,échelons,touches,cibles,ordre et lifecycle. Fin : contrat historique établi ou reconstruction explicitement séparée.

`COR-VELKOZ-DECONSTRUCTION-SPELL-STACK-01` : produire compteur/consommation sur touches de sorts qualifiées et rafraîchir seulement sur attaque ordinaire. Fin :1/2/3 marques,bords de temps,refresh/overlap/invalides observés ; au moins un sort accepté pour le premier cas,sans exiger tout QWER.

`COR-VELKOZ-DECONSTRUCTION-TRUE-DAMAGE-01` : appliquer les dégâts qualifiés au déclenchement. Fin : valeurs,niveaux,cibles,boucliers/immunités/refus vérifiés ; préserver Embrasement et attaque physique.

`COR-VELKOZ-DECONSTRUCTION-PROC-ICON-SOURCE-01` : identifier le fichier/provider exact de VelkozPassive.dds. Fin : provenance/identité/binding qualifiés,ou manque borné maintenu ; aucune substitution automatique.

`COR-VELKOZ-DECONSTRUCTION-HUD-BINDINGS-01` : relier compteur,nom/textes,SourceName,durée et variantes aux bonnes audiences. Fin : transport,transitions,tooltip et pixels observés. Reprendre sur nouveau membre/règle de provider,source/callsite,dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_velkoz_passive_hud_20261105` : evidence_review,coherence_review,archives,DDS,Proc_icon_source_gap,resource_provenance.json,prérequis et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
