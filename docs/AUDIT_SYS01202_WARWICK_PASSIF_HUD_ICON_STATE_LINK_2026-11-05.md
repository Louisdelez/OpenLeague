# SYS-01.2-02 — V1297 Warwick : Eternal Thirst, soin et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-WARWICK-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Warwick-PASSIF-PRESENTATION-HUD`, exigence `OLF-94a84a89-2b78-5695-845e-b8f3c63f3e8d`, inconnue `OLU-4b1e5c1d-4464-516e-ad30-adc3ed7cf800`. Audit documentaire borné terminé ; six contrats/questions conservés, HUD a_faire/implementation_complete=false/acceptance_complete=false, dépendance NETWORK ouverte. D06/D06-CH-Warwick et prérequis D01 dans phase_package_prerequisites.json ; aucune acceptation de phase présumée. Goal SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Aucun Plan/UI/base/registre/goal/code produit/asset modifié.

## 2. Sources et provenance native

[V539 conservé](reference_requirement_trace_sources/warwick-passive-healing-links-v539.json),369225octets/SHA `7b6b11491b136855af84bdcbdd2b328158bad53ab8e515502f2ef05bd9e8ed76`, UTC hérité `2026-10-25T16:40:29.824787+00:00`. SOURCE12relations/9IDs ; trois INIBIN,trois Lua,deux preload et font, memberships antérieurs concordants. Six fichiers WarwickBot restent exclus. Warwick.inibin3004octets/SHA `079c090e5e280436984cc7548636bbfc8f7d24581373f8312ff4a124e5828259`.

V539 n’a pas de clés native_metadata/phases : métadonnées récupérées depuis la découverte archivée ; phases/lots vérifiés dans le cache de contrats existant, sans relecture globale. Passive1=1, alias exact `Eternal Thirst`, icône Warwick_InnerHunger.dds ; description : soin croissant sur attaques successives contre la même cible. Font miroir exact : nom4483,liens INIBIN vers game_buff_tooltip_Eternal_Thirst1874 et EternalThirstBuff1876. Texte : dégâts magiques supplémentaires et soin égal,@f1@,cumul jusqu’à trois frappes. EternalThirsted1877 reste une clé voisine distincte.

Lua Buff159octets,Icon218,CharScript114 : tous sans callback enfant. CharScript contient une déclaration d’icône,donc n’est pas vide. Les trois désignent Wolfman_InnerHunger.dds ; Icon déclare BuffName="Eternal Thirst",persistance/non-dissipation. BuffName="EternalThirstBuff" et preloads sont des métadonnées,sans producteur serveur ou lifecycle démontré.

resource_provenance : deux DDS exacts,sélection E avant lectures SOURCE,8448octets,64×64 DXT5/mip0. Warwick propre Info4224octets,membre0.0.0.40,SHA `0af606058f72f1705827732cca08d8331418880b1a9a2c112f9f0f9feafb0ac4` ; Wolfman partagé4224,membre0.0.0.25,SHA `364deb386bd97b165a4d6a75fd1426b84eefffe4a337b3f18a92aca4457a971d`. Tailles/MD5/SHA/en-têtes concordants avec le manifeste choisi0.0.1.7. Contenus différents : aucune substitution automatique ou priorité d’alias déduite. Pas de métadonnée native relue,énumération D par root,pixels/GPU qualifiés.

## 3. Consommateurs actuels

Quatorze ancres héritées sur huit fichiers,28fichiers code/configuration ;16communs et16identités V539 inchangés. Attack→lib.rs→attacks.rs→lifesteal::basic_attack_hit ; celui-ci applique le physique,puis soigne de outcome.post_mitigation×stats.life_steal. progression.rs tire le taux des objets ; healing.rs applique gardes,modificateurs et plafond. Ces fonctions génériques existent et sont conservées.

L’ordre du tick dans lib.rs place advance_regeneration avant advance_attacks. Le plafonnement des PV intervient donc avant le dommage pour la cible initialement pleine. Aucun hook Warwick/EternalThirst identifié dans les seuls fichiers Rust examinés ; pas de preuve d’absence universelle. Barres natives et HPStat consomment health/max_health ; ressource locale Mana. La provenance source_sha256 des ressources reste distincte de l’INIBIN natif. Aucun binding spécifique f1,cumul ou présentation du passif qualifié.

## 4. Attendu, observé et vérifications

68/68 contrôles documentaires ; seconde passe séparée du même agent 66/66. Cinq archives876167octets,RUN brut identique à OBS,BUILD/RUN0 hérités. Binaire historique5943808octets/SHA `7a117a4f96b37574cde33efb760f431f1177b2380d5bc958293e32fd563719b0`, non relu/rejoué ;1158dépendances non requalifiées. Aucun nouveau build,jeu,VM native,REA,réseau ou GPU.

Deux cas niveau1,sans objet/avec achat public1053. Quatre Move,Garen inflige trois blessures préparatoires puis s’arrête ; six attaques non critiques de Warwick sur la même cible,aux899/943/987/1031/1075/1119. Source vivante,blessée,non plafonnée ; cible vivante et sans cible/windup aux frappes. Pas d’injection directe. Douze attaques fournissent12pairesPV source et12cible,plus6paires de blessures et10relevés hors frappe. Les2238ticks ne sont pas tous des frames archivées.

Recalcul f32 depuis catalogues et snapshots : AD62,4300003 sans objet/72,4300003 avec Sceptre ; taux de vol de vie0/0,0799999982,armure Garen27,5359993. Physique après mitigation48,9508858/56,7918091 ; régénération Warwick1,6787999868PV/s. Le physique,le vol de vie et la régénération avant attaques expliquent exactement les PV des deux acteurs sur les douze frappes,avec plafond de la cible pleine avant la première.

Résidu de soin au-delà de la régénération : six fois0 sans objet,six fois4,5433349609375PV avec Sceptre. Cinq relevés hors frappe par cas donnent0. Solde825sans objet/25avec1053,et inventaires concordent avec prix800. Les six refus publics sont enregistrés :joueur inconnu,cible inconnue,cible propre ; pas de snapshots complets individuels d’invariance.

Le témoin de vol de vie ne qualifie pas Eternal Thirst. Les mesures sont compatibles avec le chemin physique actuel ; elles ne démontrent ni tous les chemins natifs,ni une formule magique/soin/cumul à partir de f1 inconnu.

## 5. Écarts et anomalies conservés

f1,producteurs de dégâts magiques/soin,cumul/expiration/changement de cible,mort et interactions restent ouverts. Aucun test de niveaux supérieurs,critique,surplus létal,bouclier,modificateur de soin ou synchronisation qualifié. Les variantes DDS différentes ne sont pas assimilées.

V539 décrit un premier refus d’inspection sur une chaîne d’appel incorrecte. Le script actuellement piné et conservé sur E contient déjà l’ancre réelle `self.basic_attack_hit(id, w.target, raw)` ; script/erreur bruts avant correction non récupérés à nouveau. Inspection qualifiée réutilisée ; aucune modification du code jeu pour satisfaire ce contrôle.

## 6. Corrections et conditions de reprise

- `COR-WARWICK-ETERNAL-THIRST-POLICY-01` :qualifier formule f1,niveaux,base du soin,expiration et changement de cible sur source/contrat versionné ; conserver les inconnues.
- `COR-WARWICK-ON-HIT-MAGIC-HEAL-01` :lier un impact ordinaire aux dégâts magiques et au soin qualifiés,en conservant le vol de vie des objets ; vérifier source/cible et témoins.
- `COR-WARWICK-STACK-STATE-01` :produire et synchroniser le cumul admissible,jusqu’à trois selon le texte ; vérifier transition,plafond,réinitialisation selon politique établie.
- `COR-WARWICK-ICON-PROVIDER-PATH-01` :établir priorité native des variantes Warwick/Wolfman sur preuve,sans substitution arbitraire.
- `COR-WARWICK-HUD-BINDINGS-01` :relier icône,f1,cumul et capacités réelles à l’état autoritaire ; vérifier rendu et transitions,en préservant les barres/HPStat.

Reprendre sur source primaire nouvelle,consommateur modifié ou test nécessaire autorisé. Prochain candidat :Wukong,identifiant interne MonkeyKing.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_warwick_passive_hud_20261105 :evidence_review,coherence_review,archives DDS/histoire,journaux,result/publication/postpublication. Journaux limités aux producteurs Python instrumentés ; contexte exploratoire,dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2284entrées sales groupées conservées. Zéro tâche complète,inconnue,feature ou acceptation close ; relecture du même agent,sans acceptation indépendante/humaine.
