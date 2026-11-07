# V1513 — Nautilus : contrat connu de Staggering Blow

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-NAUTILUS-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Nautilus-PASSIF-SIMULATION-CONTRAT ; exigence OLF-e6f58a6d-7bee-50fc-81ef-cdf156c49bc1 ; parent SYS-01.2-02. Audit de 42 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/nautilus-passive-staggering-blow-links-v608.json du 26 octobre 2026 : 2580470 octets, SHA256 c94e7360215086821b06ee04ed20dd1c8bfecd0b11f5170a7319a53fd2a7c48a. Rapport FIDELITY_NAUTILUS_PASSIVE_STAGGERING_BLOW_LINKS_V608.md : 21667 octets, SHA256 03ee242b6c62dc4b01b922c276f3b9686accccd7c397c4c4ab43f20b6aea4676. Candidat du cache retrouvé aux mêmes octets.

79 identités natives : 25 INIBIN, 33 Lua, 19 preloads, un DDF, un font ; 30 références communautaires distinctes. Lua parcourus historiquement : 23 initialisations littérales, 123 globals, aucun enfant ou exécution ; dix limites NEWTABLE sans corruption déduite. CharScript natif et communautaire vides, sans absence globale de serveur déduite.

Treize clés en_GB vérifiées, onze BuffData résolus une fois. Passive2340 décrit f1 dégâts physiques bonus, immobilisation f2 secondes et délai f3 pour une même cible. Check2341 décrit l’immunité temporaire, Root2342 l’impossibilité de bouger ; description4239 et nom4415. Valeurs et progression restent inconnues.

Passive1=9, niveaux bruts 3/7/11/15 puis deux absents : aucune progression acceptée. Anciens textes Jax/objets AD et mana40/60/80% conservés sans adoption. Les 45 champs SpellData sélectionnés des trois passifs sont absents, sans zéro inventé. Huit lignes DDF, deux non vides : W bonushealth×0,1 et Q @special.nautilusq×0,5 ; aucun f1/f2/f3 passif déduit.

Passive utilise Malady ; Backswing, LuxShield/LuxPrismaWrap. Root déclare Snared/persistance, Check des emplacements d’effets vides et persistance. Ces données ne produisent ni racine, dégâts ou délai, ni règle de respawn. Preload Root et noms lv1/lv6/lv11/lv16 ne fixent pas les paliers ; résolveur root, chargement et rendu restent non démontrés.

Cinq chemins candidats absents seulement ; ressources réelles dans Scripts et DATA/Spells. Aucun manque global d’assets déduit. Q communautaire applique Root0,5s sans hook/pull démontré ; W délègue à un buff6s, R utilise délai1s/zone300, E trois timers0,4s/Slow2s. Aucune politique native ou consommation Rust adoptée. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

30 entrées actuelles concordent avec V608 : 19 Rust, deux lecteurs Python, neuf JSON ; avec en_GB, 31 identités vérifiées. disabled_cast_rules.json, 335 octets SHA256 f5e3f647a7c68b7cbb4b7bb7786d645cb8c82439203dbf30af1ba5aaf0e57256, ajouté précisément pour son lecteur générique. 40 fenêtres dont 32 communes, quatre récapitulatif, AnnieQ45–94, occupation517–558/635–785 et stuns1–38. 32 ancres dont 31 frontières.

Attaques, AD/critique, dégâts physiques, vol de vie, soins, régénération et récapitulatif sont des acquis. grant_stun possède gardes, interruption du windup et expiration ; mouvement et attaques consultent cet état. allows_disabled possède douze règles locales et un refus explicite pour une politique inconnue. Ce contexte ne qualifie pas les autorisations sous racine native. Aucun stun n’a été injecté pour simuler le passif.

Learn/Cast/CastAt refusent Nautilus. Recherche bornée Nautilus/StaggeringBlow sur 19 Rust : zéro occurrence ; relevé de 639 fichiers hérité, sans recherche globale répétée ni relecture des 1158 dépendances. Aucun producteur complet de bonus/racine/immunité par couple source-cible démontré.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer premier impact, bonus, racine et délai propre à la cible. Observé : 146/146 contrôles documentaires, 146/146 cohérences du même agent ; quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V608 hérité : deux parties publiques Nautilus/Annie, base puis Épée1036+10AD. AD57.54399871826172/67.54399871826172 ; AP/vol de vie nuls, PVmax576.47998046875, mana284 pleine, rangs/recharges nuls, vivants niveau1 sans critique, bouclier, contrôle, mort ou victoire. Aucun état, position, dégât, soin ou contrôle injecté.

Six attaques mêlée, six physiques reçues, deux Q Annie raw80/coût60, 54 refus atomiques, 360 ticks d’attente et quatre trajets sans reprise. Sans objet : dégâts attendus48,267067, observés48,267059 ; Épée : attendus56,654922, observés56,654907–56,654938. Résidus sous0,002 après correction de régénération. Premier coup et répétitions restent ordinaires, sans bonus observé. Soin supplémentaire attendu0, résidu−0,0000100173 ; régénération distincte.

Après le premier impact tick2205, Nautilus est arrêté et Annie reçoit Move vers un point distant de100 unités. Ticks2206/2207/2208 : déplacement11,166504 unités, vitesse335/s, dans chaque cas. Six échantillons attestent sa mobilité à ces instants. Sans racine produite, ils ne mesurent pas f2. Sans marqueur actif, attendre90 ticks ne qualifie pas f3 ou son expiration. L’attaque déclencheuse a réellement été exercée ; le refus des sorts propres n’explique pas seul cet écart. Déficit historique non chiffré faute de f1/f2/f3.

Binaire uniquement identifié en données : 6131200 octets SHA256 e1a737e4baf424f18162e48f6955ecaff21a646ce5a5b7ee54afff93eeed5903. BUILD/RUN/inspection0 hérités ; chaîne, lock et 1158 entrées non requalifiés. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Valeurs/niveaux, identité source-cible, délai et réarmement, classes de cibles, contrôle distinct du stun, ténacité/déplacements forcés, ordonnancement, lifecycle, interactions QWER et présentation/réseau restent ouverts.

Propre OLU-d8a4ee84-128b-57c4-9ce9-b04d963e1420 distincte de SOURCE OLU-df1c7ce3-cb1e-5254-97ce-5d6ba2961784. Propriétaires/dépendances conservés ; aucune inconnue fermée. Quatre trajets réussis ne corrigent ni V564, ni les deux échecs Nami V606. Anciens échecs et Battle Training non requalifiés.

## 6. Corrections et reprise

42 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-NAUTILUS-STAGGERINGBLOW-, suffixe -01. Chaque fiche contient objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise. Elles séparent les trois paramètres, événements d’attaque, premier/répétition/expiration, alternance et propriétaires, racine et permissions, dégâts/interactions, lifecycle, attribution, réseau, HUD, animation, VFX et audio.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec vrai bonus, racine et marqueur sourcés ; aucun stun injecté ou délai arbitraire pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves E:/mapslol3v3/audit_sys01202_nautilus_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2499 entrées préexistantes conservées. Prochain Nidalee depuis 122 paires : 55 candidats hors 67 unités nommées, sans compte global.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF avec sauvegarde/relecture ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
