# SYS-01.2-02 — Urgot : Zaun-Touched Bolt Augmenter et HUD, V1288

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-URGOT-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Urgot-PASSIF-PRESENTATION-HUD`, `OLF-945738d9-9033-5a06-83c4-854eb57c2300` : relier icônes, textes, application du debuff et dégâts sortants aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-6a4b83d8-6ea4-54c5-84c3-e40f30c2d6d7` ouverte. Six contrats et prérequis D06/D06-CH-Urgot consultés sans satisfaction revendiquée. SOURCE/SIMULATION/Q et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/urgot-passive-zaun-touched-links-v645.json`, 2652607 octets/SHA `c095731ed4adb6953b27d3fa9e3030d07557531ba56d21b799342d8a42ed9a58`, UTC documentaire 2026-10-26T23:10:47.006337+00:00.

HUD enregistré : définition/CharScript et un catalogue. SOURCE :18 relations/12 identités/six sites ; V645 :20 frontières, union26 ancres/12 fichiers. Douze fichiers directs : six INIBIN,deux Lua,deux preloads,DDF,font ;44 voisins non promus.19 Lua de contexte sans fonctions enfants et sept limites littérales ne sont pas des callbacks serveur. Aucune relecture native de ces payloads.

Définition1930 octets : Passive1LuaName=UrgotEntropyPassive, icône Urgot_Passive.dds, Passive1Desc littéral « Reduces damage of attack targets ». Passive1 et six niveaux non résolus. CharScript109 non vide, ancien BuffTextureName=Teemo_EagleEye.dds ; contexte sans binding passif, aucune corruption déduite. UrgotEntropyPassive225 déclare BuffName=UrgotEntropyDebuff et l’icône Urgot_Passive, sans callback enfant.

Font miroir d’identité native vérifiée :2844, Zaun-Touched Bolt Augmenter,15 % pendant2,5 secondes ;2845, Degenerative Bolt,15 % pendant3 secondes par attaques/Acid Hunters. Nom4474 et description4298 résolus, cette dernière indiquant2,5 secondes. **Priorité effective et durée non arbitrées**, malgré l’alias client ; aucune sélection par majorité de textes. Applicabilité aux dégâts bruts inconnue. DDF PlasmaGrenade;f1=bonusattackdamage×0.6 ne définit pas le passif. Q communautaire AP divergent du texte natif physique total, non promu en règle native.

Deux chemins DDS propre/shared Urgot_Passive, même contenu :2176 octets,64×64 DXT1,mip brut1, SHA `c079365606a53b1ef4db70f70479f1981d7a341668c3e4439016cc8fefb893f5`, membres174/25 du projet RADS0.0.1.7. Taille/MD5 concordants ; sélection E avant deux stat/lectures SOURCE,4352 octets. Trois alias Teemo inventoriés au manifeste seulement, aucun DDS Teemo/particule lu. Provider et pixels ouverts.

Quatre archives sélectionnées avant lecture F/OpenLeague-work :1866884 octets. Aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue le StatsJSON communautaire du hash INIBIN natif, sans réouverture des payloads.

## 3. Consommateurs actuels

26 ancres,32 fichiers code/configuration,16 entrées communes et20 identités comparables V645 inchangées. Le projectile passe par basic_attack_hit/apply_damage. Le chemin de dégâts actuel appelle exhaust_damage_multiplier : facteur0.6 physique/magique sous Épuisement,1 brut ; ce n’est pas un consommateur Urgot qualifié.

Mana/PV ont des chemins HUD génériques. Maxima ne prend pas Urgot en charge ; aucun Urgot/UrgotEntropy/Zaun-Touched nommé dans les sources Rust sélectionnées. Absence bornée, sans conclusion mondiale depuis un motif. Les chargeurs et widgets spécifiques d’autres champions ne prouvent ni producteur du debuff, ni durée/SourceName/icône affichés.

## 4. Attendu, observé et contrôles

V645 : un projectile ordinaire non critique touche Annie à chacun des niveaux1/18.23 paires PV adjacentes recalculées float32/régénération ; impact physique cohérent à0.002 PV près. Quatre déplacements publics, positions finales recalculées à moins d’une unité du but, sans réordre ;4207 ticks archivés. Deux apports diagnostiques100000 XP, pas de progression naturelle.

Les66 mesures suivantes appellent **apply_damage par API diagnostique**, source Annie vers Urgot ; aucune riposte ordinaire d’Annie exécutée. Résultats Outcome, dégâts attendus et valeurs retranchées vérifiés. Les ratios sont recalculés depuis post_mitigation et sa baseline, pas repris du champ factor fourni au collecteur.

Après impact, aux temps0/74/75/89/90/91 : ratio1 pour les trois types, aucune réduction supplémentaire observée dans ce parcours. Texte natif15 % conservé ; la politique par type reste à qualifier, particulièrement les dégâts bruts. L’absence d’effet à75/90 ne valide aucune expiration d’un debuff non établi.

Témoin Épuisement distinct : ratios mesurés0.6 physique/magique,1 brut aux temps0/74, puis1 à75/76. Sa durée et sa politique brute ne tranchent pas Urgot.62 refus avec flags snapshot_unchanged ; toutes les paires de snapshots ne sont pas archivées. Les66 appels conservent Outcome/health_removed, sans PV avant/après individuels : pas de recalcul indépendant de ces soustractions.

RUN brut complet égal OBS ; BUILD/RUN hérités0. Binaire inerte 6072832 octets/SHA `f31916c0b490114fd1149f3524da8a1f5d4ca939fd397f2b07b87d307bf3cf05`, identité non fraîchement rehashée.113/113 contrôles et86/86 cohérence corrigée séparée du même agent. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

coherence01 initial85/86 conservé : attente erronée cinq INIBIN/trois Lua. Qualification par douze noms exacts et ensemble des IDs SOURCE : six INIBIN/deux Lua ;85 autres contrôles strictement identiques. Une commande exploratoire mal formée a échoué à l’analyse PowerShell avant lecture/écriture projet ; requête corrigée ensuite. Aucun moteur modifié par ces corrections de contrôle.

## 5. Écarts et inconnues

Durée/callsite effectifs, application du debuff, types de dégâts, rafraîchissement, sources multiples, ordre avec Épuisement/boucliers/immunités, purge/mort/reconnexion, cibles non championnes et Q réel restent ouverts. Le parcours API n’est pas un parcours de riposte ordinaire ou multiclient. Interface, tooltip, animation, audio et rendu restent non qualifiés. Snapshots privés gzip conservés, sans restauration ou migration.

## 6. Corrections et reprise

`COR-URGOT-ZAUN-TOUCHED-POLICY-01` : relier alias/callsite à durée2,5/3, types, refresh/overlap et ordre. Fin : contrat historique sourcé ou reconstruction explicitement séparée ; aucune règle brute empruntée à Épuisement.

`COR-URGOT-ZAUN-TOUCHED-APPLY-01` : produire état victime/source et application à l’attaque ; Q dans sa tâche propre. Fin : statut et transitions effectifs, nominal/refus/expiration selon contrat ; pas de blocage de l’attaque sur tout QWER.

`COR-URGOT-ZAUN-TOUCHED-DAMAGE-01` : consommer le modificateur qualifié dans les vrais chemins de dégâts. Fin : API et ripostes ordinaires testées séparément,15 % où applicable, limites/ordre/invalides ; préserver Épuisement et les résistances existantes.

`COR-URGOT-ZAUN-TOUCHED-HUD-BINDINGS-01` : relier icône/nom/texte/durée/SourceName au statut autoritaire. Fin : bonnes audiences/variantes/transitions, transport, tooltip et pixels observés ; Teemo contextuel non substitué. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_urgot_passive_hud_20261105` : evidence_review/coherence_review_corrected, qualification, archives, DDS, resource_provenance.json, prérequis et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
