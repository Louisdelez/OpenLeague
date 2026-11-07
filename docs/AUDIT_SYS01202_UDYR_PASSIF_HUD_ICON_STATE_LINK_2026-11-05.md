# SYS-01.2-02 — Udyr : Monkey's Agility et HUD, V1287

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-UDYR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Udyr-PASSIF-PRESENTATION-HUD`, `OLF-2cae9297-9441-5a59-8111-e5cf2680a2bf` : relier marqueur, bonus temporaire, icônes/textes et états aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-1792d528-71e3-51ae-bbae-288e62321cc3` ouverte. Six contrats et prérequis D06/D06-CH-Udyr consultés sans satisfaction revendiquée. SOURCE/SIMULATION/QWER et parent PRESENTATION restent distincts ; aucune posture déclarée terminée.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/udyr-passive-monkeys-agility-links-v644.json`, 3049492 octets/SHA `5dd530bb041507d5c4fdb0cd3edf49231947b79bdfa48796f89d79088247ae72`, UTC documentaire 2026-10-26T22:51:33.738875+00:00.

HUD enregistré : définition/CharScript et un catalogue. SOURCE :20 relations/15 identités/six sites ; V644 :13 frontières, union19 ancres/sept fichiers. Quinze fichiers directement reliés : sept INIBIN,trois Lua,trois preloads,DDF,font.78 autres fichiers de découverte et36 métadonnées Lua/22 limites littérales restent du contexte non promu. Aucune relecture native de ces payloads.

Définition : UdyrPassiveBuff, icône Udyr_MonkeysAgility.dds ; Passive1/Passive1Desc et six champs de niveaux non résolus. CharScript56 vide. UdyrMonkeyAgility déclare UdyrPassiveBuff, image BlindMonk_FistsOfFury, persistance/non-dissipation ; UdyrMonkeyAgilityBuff déclare son propre nom/image Udyr_MonkeysAgility. Trois chunks directs sans callbacks enfants ; flags du marqueur non promus en durée du bonus.

Font miroir d’identité native vérifiée :2826 décrit entrée en posture, +10 % vitesse d’attaque et +5 déplacement pendant5 secondes, maximum3 cumuls ;2825 décrit le bonus temporaire et SourceName ; nom4472/description4296 résolus. Priorité d’images, rafraîchissement, expiration commune/indépendante et mort non qualifiés.

MaxLevels=[5,5,5,5], y compris **Phoenix**. Coûts47/44/41/38/35, Cooldown1..5=6 secondes, champs de rang6 absents. Ces données ne prouvent pas le délai partagé ni les portes d’apprentissage. DDF Tiger : attackdamage×.15 et1.2/1.3/1.4/1.5/1.6, sans lien établi au bonus AS/MS. CharScript communautaire vide ; marqueurs de posture communautaires non producteurs du passif natif.

Trois DDS nécessaires,4224 octets chacun,64×64 DXT5 ; deux contenus : Udyr_MonkeysAgility propre/shared, SHA `4e59ff73417895a2a43b1e4eda4660f1b6a66cad8c479ebdf03672128e1c56be`, compteur brut de mips1, membres153/25 ; BlindMonk_FistsOfFury partagé, SHA `3aae5582034f193c0ab9220c473ecd68c2301e99b3d299f3c286ea9e204516b6`, compteur brut0, membre25. Projet RADS0.0.1.7, tailles/MD5 concordants ; sélection E avant trois stat/lectures SOURCE,12672 octets. Aucun DDS d’un autre répertoire de champion/particule lu. Provider/pixels ouverts ; aucun alias substitué automatiquement.

Quatre archives sélectionnées avant lecture F/OpenLeague-work :1666950 octets. Aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue le StatsJSON communautaire du hash INIBIN natif, sans réouverture des payloads.

## 3. Consommateurs actuels

19 ancres,27 fichiers code/configuration,16 entrées communes et15 identités comparables V644 inchangées. next_rank/cast/cast_at refusent Udyr ; statistiques et bonus génériques restent distincts d’un producteur Monkey's Agility.

Mana/PV disposent de consommateurs HUD génériques ; widget passif Ezreal spécifique. Maxima ne prend pas Udyr en charge. La seule occurrence nommée trouvée est le test native_hud_ranks.rs:82 vérifiant ce refus ; elle est conservée, sans être classée producteur.

native_hud_spells::player_states limite statiquement le slot3 à trois rangs. Le schéma natif Phoenix en décrit cinq : écart d’intégration à traiter lorsque les préconditions seront disponibles, sans échec de rendu avec rang4/5 actuellement reproduit. Aucun compteur, paramètre, choix de variante ou durée Udyr démontré par ces chargeurs.

## 4. Attendu, observé et contrôles

Attendu actuel : refus explicites sans mutation. Observé archivé aux niveaux1/18 :17 refus chacun, dont quatre Learn, quatre Cast, quatre CastAt et cinq frontières invalides. Deux paires complètes initial/final sont égales ; les34 refus individuels conservent des flags d’égalité de snapshots/statistiques, sans toutes leurs paires brutes.

Rangs0/0/0/0, statistique move_speed345, attack_cooldown_ticks46/32. **Statistiques calculées, pas cadence d’attaques ou déplacement mesuré.** Zéro tick Udyr ; aucune posture acceptée, aucun cumul, rafraîchissement ou délai du passif exercé. Un apport diagnostique100000 XP, pas une progression naturelle.

Témoin Garen Q : Learn/Cast publics, statistique345→455.600006→345, retour à45 sur46 ticks ; deux refus supplémentaires. Flags bonus_active dérivés de tick<45, pas preuve de suppression d’un objet buff. Ce témoin ne valide ni AS Udyr ni ses5 secondes natives.

RUN brut complet égal OBS ; BUILD/RUN hérités0. Binaire inerte 6010880 octets/SHA `16d599de2aae5df4d28cf3eb2e320ddb55e932acf653a3247b43c5c9e350f559`, identité non fraîchement rehashée.114/114 contrôles et76/76 cohérence séparée du même agent. Productions actuelles journalisées sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine. Snapshots privés V644 déjà archivés restent conservés ; aucune restauration ou migration exécutée.

## 5. Écarts et inconnues

Activation de posture indisponible, schéma de rangs non intégré, producteur/compteur autoritaire et présentation spécifique non établis. Réactivation identique, quatrième activation, rafraîchissement, GCD, ordre avec objets/ralentissements/plafonds, mort/purge/reconnexion et audiences restent ouverts. Marqueur persistant et bonus temporaire ne sont pas interchangeables. Aucune expiration d’un bonus non produit présentée comme testée.

## 6. Corrections et reprise

`COR-UDYR-STANCE-ADMISSION-01` : reprendre les tâches QWER pour une entrée en posture réelle. Fin : activation nominale et refus coût/délai/état vérifiés, sans exiger tout le kit avant le premier test du passif.

`COR-UDYR-STANCE-RANK-SCHEME-01` : relier le schéma4×5 aux consommateurs serveur/HUD. Fin : Phoenix4/5 et rang6 refusé vérifiés avec points/portes qualifiés ; aucun ultime3 ou20 points disponibles supposés.

`COR-UDYR-MONKEYS-AGILITY-POLICY-01` : qualifier cumul, horloges, réactivation, calcul et lifecycle. Fin : contrat sourcé séparant marqueur, bonus et règles reconstruites.

`COR-UDYR-MONKEYS-AGILITY-STATE-01` : produire l’état et ses contributions AS/MS. Fin :1→3, quatrième entrée, rafraîchissement/expiration et invalides vérifiés selon contrat, sans modifier globalement le catalogue partagé.

`COR-UDYR-MONKEYS-AGILITY-HUD-BINDINGS-01` : relier icônes/textes, cumuls/durée et audiences à l’état autoritaire. Fin : transitions, SourceName, transport, tooltip et pixels observés ; pas de preuve Udyr empruntée à Garen/Ezreal. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_udyr_passive_hud_20261105` : evidence_review/coherence_review, archives, DDS, resource_provenance.json, prérequis et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
