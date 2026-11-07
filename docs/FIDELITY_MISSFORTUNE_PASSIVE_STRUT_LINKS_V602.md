# SYS-01.2-02 — Miss Fortune : sources et consommateurs de Strut (V602)

Date UTC : 2026-10-26T09:11:41.548164+00:00. Projet : F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat et périmètre

Les trois fiches CH-MissFortune-PASSIF-SOURCE, CH-MissFortune-PASSIF-SIMULATION-CONTRAT et CH-MissFortune-PASSIF-SIMULATION reçoivent 62 sources natives (186 associations) et 25 points de code (50 liens sur les fiches de simulation). Les consommateurs sont des frontières ou du contexte actuel ; aucun consommateur complet de Strut n’est démontré.

Les deux cas publics montrent une vitesse constante de 325 sans objet et 350 avec bottes, malgré les fenêtres d’attente couvrant le délai et la montée décrits par le texte natif. Aucun bonus Strut n’apparaît. La réception d’un véritable dégât est vérifiée, mais elle ne prouve pas le reset de Strut puisque le bonus n’était pas actif. Ce lot améliore la traçabilité ; aucun gameplay ni asset modifié, aucun passif/champion/jeu déclaré terminé.

## Sources présentes, divergences et limites

- Le texte du personnage en_GB ligne 4233 décrit 5 secondes sans être attaquée, puis +25 de vitesse, augmentant de +8 par seconde jusqu’à +70. Le buff Strut indique une vitesse accrue jusqu’à un impact en combat ; le cooldown parle de dégâts reçus. Ces formulations ne résolvent pas à elles seules tous les événements qui interrompent le passif.
- MissFortune.inibin contient vitesse de base325, icône MissFortune_Strut.dds et clé de description correcte. Passive1LuaName vaut toutefois Draw a Bead : alias historique conservé, sans adopter le passif de Tristana. Passive1Desc, PassLev1Desc2..4 et les six Passive1Level sont absents ; aucune valeur par défaut inventée.
- MissFortuneStrut.luaobj définit le buff, l’icône et PersistsThroughDeath. StrutDebuff utilise l’icône grisée, NonDispellable et le nom espacé « Miss Fortune Strut Cooldown ». StrutStacks a son identité propre ; son tooltip est celui de Strut. Ces métadonnées ne fournissent pas l’algorithme du timer ou une règle de respawn.
- **MissFortunePassive et MissFortunePassiveStack correspondent à Impure Shots (W), pas à Strut.** Leurs icônes, description ViciousStrikes et métadonnées de dégâts/récapitulatif sont conservées comme contexte W. Le cooldown16, coût50, rayon210, portée600 et coefficient d’environ0,05 ne sont pas réutilisés comme paramètres de Strut.
- Les neuf clés BuffData sont résolues exactement une fois : IsPirateHunter, cooldown, BulletSound, Passive, PassiveStack, ScattershotSlow, Strut, StrutStacks et ViciousStrikes. Les clés Strut/Stacks se rejoignent sans fusionner les deux identités.
- 27 Lua sont entièrement parcourus, sans prototypes enfants. Dix-huit initialisations littérales sont lisibles et neuf s’arrêtent sur NEWTABLE : BasicAttack, BasicAttack2, BulletEMPTY, BulletTime, CritAttack, RicochetShot, RShotExtra, Scattershot et ViciousStrikes. Cette limite du lecteur ne prouve pas une corruption. CharScriptMissFortune ne contient pas de logique littérale de passif ; cette lecture n’exécute pas le serveur historique.
- Treize preloads relient les ressources : le CharScript charge séparément Strut et MissFortunePassive ; Strut charge debuff, stacks, missfortune_base_p_buff.troy et root. Le debuff référence Strut et lui-même. Une dépendance de chargement ne vaut pas exécution d’un effet ni qualification visuelle.
- Le DDF contient douze lignes Q/W/E/R, dont BulletTime f1=0,35 bonus AD et onze lignes vides. Il ne fournit pas la formule du passif de déplacement.
- Les 25 références communautaires sont présentes ; CharScriptMissFortune.cs est vide. Elles ne remplacent pas une preuve du comportement serveur d’origine.
- Six chemins candidats sont absents : CharScript sous Scripts, Strut.inibin et Strut.luaobj sous DATA/Spells, StrutDebuff.inibin, StrutStacks.preload et « Miss Fortune Strut Cooldown.luaobj ». Les vrais CharScript/Strut sont trouvés à la racine du personnage et dans son répertoire Spells. Aucune absence globale de modèles, textures, animations ou sons n’est déduite de ces six chemins.

Les fichiers sélectionnés sont reliés au registre et à l’appartenance RADS, taille et SHA-256 contrôlés. Les sources et leurs sélecteurs détaillés sont dans le reçu.

| Fichier | Source |
|---|---|
| MissFortune.inibin | OLS-68e97368-88d8-52cc-8502-ba37cbed09f2 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| MissFortune.ddf | OLS-0fb7612e-55ad-573b-8540-04afc0664769 |
| CharScriptMissFortune.luaobj | OLS-802de5ea-4976-59d0-92a0-551c3a408474 |
| CharScriptMissFortune.preload | OLS-2661b792-2141-54b1-822d-9b7ebee8cc23 |
| IsPirateHunter.inibin | OLS-fb0f23fb-09d5-5002-9dac-9fae0bf7544d |
| IsPirateHunter.luaobj | OLS-2b873978-a242-51f9-873c-e772bd7d271f |
| Miss Fortune Strut Cooldown.inibin | OLS-3bef48ed-8d41-5820-8d63-46335a7a4ccf |
| MissFortuneBasicAttack.inibin | OLS-3542def4-1c1e-5b7d-8aaf-093022a3728d |
| MissFortuneBasicAttack.luaobj | OLS-6bb5e669-16a1-5a6b-8569-4e66222bcc4b |
| MissFortuneBasicAttack2.inibin | OLS-3b5b2bc8-15e2-5452-b0e2-3cfc9f9c723e |
| MissFortuneBasicAttack2.luaobj | OLS-d6f47e29-d9e6-5eca-ba3a-951c7c28f96a |
| MissFortuneBulletEMPTY.inibin | OLS-73993cc3-034f-54f9-87c9-ca3c0584ddaf |
| MissFortuneBulletEMPTY.luaobj | OLS-c3130570-71a7-5db2-8514-04fd0022a3f8 |
| MissfortuneBulletHolder.luaobj | OLS-64e16d87-e859-57e6-854a-7e99754f2876 |
| MissFortuneBullets.inibin | OLS-04b5a67a-ed75-5d69-a2ef-f095a7b2b48e |
| MissFortuneBullets.luaobj | OLS-97282a21-9d8d-5b05-8c26-7698dee3fa62 |
| MissFortuneBullets.preload | OLS-57f06369-c67d-5761-a057-49d4915e297e |
| MissFortuneBulletsClone.inibin | OLS-ceb95e67-8bbf-531e-b208-948faea11b78 |
| MissFortuneBulletsClone.luaobj | OLS-8a11757d-12f2-5379-a5e7-ee5f20e60867 |
| MissFortuneBulletsClone.preload | OLS-701cfe92-bb3a-5073-90a1-e36d1258bf1c |
| MissFortuneBulletSound.inibin | OLS-f82d54ea-10d1-56da-8b7a-1c32e1be8474 |
| MissFortuneBulletSound.luaobj | OLS-2d06c051-69b2-5635-b0b1-6a4bc8411621 |
| MissFortuneBulletTime.inibin | OLS-21444380-d575-5efd-a098-d4111137ecf8 |
| MissFortuneBulletTime.luaobj | OLS-48401965-d2e5-5902-8ca6-c34d2699133b |
| MissFortuneBulletTime.preload | OLS-1e6f65a7-b25f-59b5-a20a-816178a8e4ce |
| MissFortuneCritAttack.inibin | OLS-1c2f4ce2-b3a9-50e2-9976-8702e29bde4e |
| MissFortuneCritAttack.luaobj | OLS-2cd1c205-4257-5a87-b4f4-8ae65816ba6d |
| MissFortunePassive.inibin | OLS-9b17df6a-3d52-5978-a4a8-69682287d74a |
| MissFortunePassive.luaobj | OLS-33164dc1-7615-5c3d-93fd-19bcbda6c950 |
| MissFortunePassive.preload | OLS-f42e0199-3340-5c90-b01e-f450ff24b684 |
| MissFortunePassiveStack.inibin | OLS-5e40587f-64cb-5cf1-9775-d36afb288fb7 |
| MissFortunePassiveStack.luaobj | OLS-e9099f25-cf10-5640-be71-14d8674d2fb6 |
| MissFortunePlaceholder.luaobj | OLS-cd1a633f-c124-5138-b5bc-91f8b4698bb0 |
| MissFortuneRicochetShot.inibin | OLS-e99ebf84-a4f8-5826-b1ba-56c059e7049e |
| MissFortuneRicochetShot.luaobj | OLS-cdbafab2-618a-5517-addc-294e0aebfda2 |
| MissFortuneRicochetShot.preload | OLS-d81a2248-75a7-5ec6-bd5c-c24b3f2c81df |
| MissFortuneRShotExtra.inibin | OLS-c3e9d7a2-6d25-56a0-ac45-3a660d72de7b |
| MissFortuneRShotExtra.luaobj | OLS-6a642cc3-f786-54b4-beaf-237cf5421411 |
| MissFortuneRShotExtra.preload | OLS-e037936b-f6cd-5421-b48d-ce8e729a8dd7 |
| MissFortuneRShotHolder.luaobj | OLS-436aefdb-4b2f-5407-a89b-fa3cf284a703 |
| MissFortuneScatterAoE.luaobj | OLS-2a385688-9ac9-5562-98c7-e1afb4695913 |
| MissFortuneScatterAoE.preload | OLS-44239c25-f07a-5fb0-8087-ced681ba310d |
| MissFortuneScatterParticle.luaobj | OLS-eb1ca9d7-30ec-5b01-97e5-19b16f746e50 |
| MissFortuneScatterParticle.preload | OLS-716e7cc7-8b6c-53c5-9871-3ed60b725adf |
| MissFortuneScattershot.inibin | OLS-b7a178a3-7ad7-5292-816d-035c1e1f7a0e |
| MissFortuneScattershot.luaobj | OLS-d2dad30e-0de0-5902-a029-ebe7fef59c32 |
| MissFortuneScattershot.preload | OLS-d2f8cae1-6e21-5f7a-8b92-fe15d7de9f50 |
| MissFortuneScattershotSlow.inibin | OLS-11ff1cc4-f132-5d41-bab1-25c80c7ae58b |
| MissFortuneScattershotSlow.luaobj | OLS-d03c1199-582f-5337-8711-999ae00bcf77 |
| MissFortuneStrut.inibin | OLS-de5adcf2-cd4c-59a0-b199-52935fdfede3 |
| MissFortuneStrut.luaobj | OLS-8ba78822-5377-5a91-9016-58b7267688eb |
| MissFortuneStrut.preload | OLS-69893ccc-1935-538c-b96a-cdea84717baa |
| MissFortuneStrutDebuff.luaobj | OLS-4051f471-59d1-5187-a313-02413457c644 |
| MissFortuneStrutDebuff.preload | OLS-a4fed0f2-de53-5317-98a4-f4465bd8b1b8 |
| MissFortuneStrutStacks.inibin | OLS-8007f15f-0134-5ab4-b655-2da424d1ae6e |
| MissFortuneStrutStacks.luaobj | OLS-de4cbb60-6f03-57d7-ae2e-7ada17dc759c |
| MissFortuneViciousStrikes.inibin | OLS-5dcb4202-bd85-5e87-aea5-1a41f4338e68 |
| MissFortuneViciousStrikes.luaobj | OLS-e8c8eb74-c52a-57de-aad4-22489d55024e |
| MissFortuneViciousStrikes.preload | OLS-3cc2e750-7bb8-52d0-9ec8-2de393ce5a5e |
| MissFortuneWaveHold.luaobj | OLS-f0b84b0a-d662-5c45-8360-85846e6769ec |
| MissFortuneWaves.luaobj | OLS-b03c1dd8-8a9f-5473-ba3a-b8603ce5be6b |

## Contrôles réellement exécutés

Compilation Rust `--locked --offline`, core réel non compilé comme test, dépendances alignées sur Cargo.lock. Deux simulations Map10 via commandes publiques Join/Buy/Move/Stop et Annie Q, sans injection directe d’état. Miss Fortune et Annie restent vivantes au niveau1, sans victoire ou mort ; aucun sort Miss Fortune accepté, aucun rang appris et mana Miss Fortune pleine.

Chaque cas comprend une fenêtre de331 ticks sans dégât, deux trajets mesurés (aller/retour), un Q Annie réellement reçu, une seconde fenêtre de331 ticks, puis deux autres trajets mesurés. Les déplacements initiaux vers la zone contrôlée sont enregistrés séparément des huit trajets mesurés.

| Cas | Vitesse observée | Q reçus | Trajets | Pas mesurés | Pas à pleine vitesse | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| base | 325.0 | 1 | 4 | 112 | 108 | 27 | 662 |
| Boots_speed_control | 350.0 | 1 | 4 | 104 | 100 | 27 | 662 |

Attendu/observé ordinaire : les bottes1001 ajoutent25 à325 ; le déplacement avance dans le budget vitesse/30, tolérance0,003. Les208 pas complets correspondent à ce budget ; huit pas finaux sont partiels. Tous les trajets atteignent leur destination. Le Q Annie a80 dégâts magiques bruts et coûte60 mana ; les pertes de PV, après mitigation et correction de régénération, ont un résidu inférieur à0,002. Les deux observations de vitesse (API movement_speed et stats.move_speed) restent325/350 à chaque tick contrôlé.

Les21 offsets par fenêtre sont149/150/151,179/180/181,209/210/211,239/240/241,269/270/271,299/300/301,329/330/331. Ils entourent5 à11 secondes au pas actuel de30Hz. Le texte annonce un bonus après5 secondes et une montée ultérieure ; aucun bonus n’apparaît. Le diagnostic ne décide pas de l’ordre historique exact de la première incrémentation, de l’arrondi ou du tick de plafond.

Les54 refus sont atomiques : joueur inconnu, auto-ciblage, slot invalide, apprentissage et lancements ciblés/au sol Q/W/E/R avant et après les séquences. Les snapshots restent identiques pour chaque refus. Les1324 ticks d’attente et le dégât reçu sont de vrais contrôles, mais ne qualifient pas le retrait d’un bonus jamais généré. Les interactions avec ralentissements et soft caps restent ouvertes.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-missfortune-passive-strut-probe.exe` ; 6057472 octets ; SHA-256 `262a20e7cb4e690fa49c48767b82643cc83f83e52ab4e96efc3a9721774c197b`. BUILD/RUN et inspection corrigée renvoient0. Les1158 entrées du core/ressources et la chaîne de preuves antérieures sont revérifiées. Aucun serveur historique, rendu graphique ou transport réseau exécuté.

### Essais échoués conservés

Le premier générateur `prepare_revision602_missfortune_inspection.py` a renvoyé1 sur un libellé hérité « secondhit », avant création du script cible. Une commande dépendante de copie/exécution a ensuite renvoyé1 parce que ce fichier n’existait pas. Le générateur corrigé est un nouveau fichier `_qualified.py` ; il remplace le libellé sans retirer le garde-fou. La génération puis l’inspection réussissent avec0. Aucun registre ni base n’avait été modifié lors de ces échecs ; les deux générateurs sont conservés dans les scripts du lot. Les reçus de qualification ultérieurs ne présentent pas ces essais comme réussis.

## Code actuel et consommateurs

movement_speed combine vitesse de base, objets et modificateurs actuels. effective_speed_with_slow gère notamment Garen, Heal, relique, Trundle et ralentissements ; aucun producteur Strut n’est identifié dans le core inspecté. soft_cap est une politique locale dont la fidélité historique n’est pas acceptée par ce test. advance_allied_motion et fit_step sont réellement traversés ; cela ne résout pas le défaut V564 d’arrondi d’un pas sur cellule interdite.

Les frontières de commande, apprentissage, dégâts, régénération, inventaire et Q Annie sont reliées pour les cas exécutés. Les points de récapitulatif restent du contexte, sans validation de présentation du récapitulatif.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | current effective speed and target resistance |
| crates/core/src/progression.rs:150 | unsupported MissFortune learning |
| crates/core/src/progression.rs:159 | unsupported MissFortune rank policy |
| crates/core/src/spells.rs:101 | unsupported MissFortune cast |
| crates/core/src/annie_w.rs:29 | unsupported MissFortune ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | incoming Annie magicdamage boundary |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public boots25speed control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | incoming magic mitigation |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not Strut damage attribution |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted Strut attribution |
| crates/core/src/movement.rs:53 | actual effective speed325/350 before/after damage |
| crates/core/src/movement.rs:38 | current modifiers omit Strut producer;slow/haste combinations unqualified |
| crates/core/src/movement.rs:19 | current speed transform;Strut cap andstacking not exercised |
| crates/core/src/ally_occupancy.rs:635 | actual public path advancement,216sampled ticks |
| crates/core/src/ally_occupancy.rs:526 | stepbudget boundary;V564 rounding defect remains open |
| crates/core/src/annie.rs:45 | accepted incoming Q raw80cost60 |
| crates/core/src/annie.rs:73 | real damage before331tick wait |

## Livraison et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/missfortune-passive-strut-links-v602.json. Preuve : docs/fidelity_missfortune_passive_strut_links_v602.json. Les instructions copiables contiennent les sources, écarts et actions restantes ; SYS-01.2-02 reçoit la synthèse.

PREPARE/CHECK/PUBLISH/AUDIT renvoient0. Les contrôles rejettent72 associations altérées et quatre graphes invalides. Trois fragments de traçabilité changent,42212 restent identiques. Deux bases SQLite (projet et application installée) reçoivent quatre lignes ciblées :42603 autres lignes,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Identifiants, phases/lots et registre des inconnues restent identiques octet par octet ; trois questions propres et quatre dépendances conservées. Aucun statut, critère, propriétaire, note ni case fermé automatiquement.

Revue globale :99085 sources,4068 consommateurs,4068 ancres exactes et aucune divergence. source_hashes_verified=0 décrit la validation structurelle ; les fichiers sélectionnés et consommateurs sont hachés séparément. Aucun contrôle exhaustif des99085 fichiers sources n’est revendiqué.

docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont mis à jour avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision602_MissFortune_discovery/OBSERVATIONS.json ; revision602_MissFortune_passive_probe/OBSERVATIONS.json ; revision602_MissFortune_inspection_qualified/OBSERVATIONS.json ; revision602_MissFortune/DELIVERY_AUDIT.json ; revision603_trace_review/REVIEW.json. Les reçus des commandes enregistrent leurs résultats réels.

## Travail restant

1. Définir et implémenter le délai initial, l’événement de départ, la première incrémentation et l’ordre des événements au même tick.
2. Produire le bonus25, sa montée de8 par seconde et le plafonnement70 ; qualifier les arrondis et valeurs intermédiaires.
3. Qualifier les événements de remise à zéro : attaque, impact, dégâts, bouclier, immunité, dégâts périodiques et sources particulières.
4. Tester interruption, retrait du bonus, nouvelle attente et réactivation avec un bonus préalablement actif.
5. Qualifier bottes, accélérations, ralentissements, caps/planchers et changements d’objets/niveau pendant la montée.
6. Séparer les buffs de Strut des effets Impure Shots ; conserver alias et champs absents sans règles inventées.
7. Couvrir plusieurs propriétaires, mort/respawn, contrôles, déconnexion et fin de partie.
8. Vérifier icônes active/grisée, indicateur de charge, particule, animation, sons et rendu.
9. Vérifier séparément réplication réseau et autorité de l’état du passif.

Les lacunes Battle Training et le défaut V564 restent ouverts ; ce lot ne démontre pas un manque global d’assets.

Suite : Continuer SYS-01.2-02 depuis revision603_trace_review/REVIEW.json. MissFortune V602 intégré :62sources186associations25points50liens. 62 sources natives et 25 références communautaires : 27 Lua dont 9 limites NEWTABLE, 13 preloads, 9 clés de buff résolues et 12 lignes DDF QWER. Strut indique 5 secondes, bonus25 puis8 par seconde jusqu’à70. MissFortunePassive correspond à Impure Shots W, distinct de Strut ; alias Draw a Bead conservé. CharScript vides et six chemins candidats absents, sans absence globale d’assets déduite. Deux cas publics base/bottes25 :1324 ticks d’attente,2 Q Annie reçus,8 déplacements,216 pas dont208 à pleine vitesse,54 refus atomiques. Vitesse325/350 sans bonus Strut. Activation, montée et reset non qualifiés ; attaque/impact/dégât restent à distinguer. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus. Échecs préalables du générateur et fichier absent conservés. Préserver les preuves et le défaut V564. Prochain passif à inspecter réellement : MonkeyKing. Goal actif ; aucun statut/case/inconnue fermé.
