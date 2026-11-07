# SYS-01.2-02 — Twitch : Deadly Venom et consommateurs VFX, V1413

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TWITCH-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Twitch-PASSIF-PRESENTATION-VFX`, `OLF-34a846b9-116d-559c-bad3-233c747193c9` : relier marqueur champion, poison victime, compteurs visuels et consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. V642/HUD V1286 et leurs preuves restent acquis. QWER, présentation complète et goal demeurent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/twitch-passive-deadly-venom-links-v642.json`,2572351 octets,SHA `1fcf9f9eb347d921f52206e1da1725b46678dcecc335c8a954b7391cac452c6e`. Inspection et diagnostic retenus dans E ; aucun accès natif/F/OpenLeague-work renouvelé.

Cinquante-quatre ressources sélectionnées :20 INIBIN,21 Lua,11 preloads,DDF,font. Les21 vues Lua héritées indiquent une lecture complète sans prototype enfant ;14 initialisations littérales,sept limites NEWTABLE,40 globals. CharScript56 vide. Définition TwitchDeadlyVenomMarker/Twitch_Passive.dds ; Passive1/Desc/niveaux absents, sans zéro inventé.

Marker231 déclare Twitch_DeadlyVenom_temp.dds et persistance/non-dissipation. Cela ne qualifie pas le lifecycle du poison victime. Deadly_Venom158 et TwitchDeadlyVenom154 partagent BuffName TwitchDeadlyVenom mais utilisent respectivement Twitch_DeadlyVenom.dds et Twitch_Passive.dds. Internal185 garde le nom espacé Deadly Venom et le flag de death-recap ; priorité/alias et producteur des ticks inconnus.

Trois contextes AutoBuff/neuf champs : Expunge déclare twitch_ambush_buf.troy sur r_hand/l_hand ; Q Invisible utilise Effect2 sans Effect1 implicite ; Q Buff Hands utilise R_Hand/L_Hand. Casse et slots conservés, sans correspondance au squelette ou recette de poison déduite. Aucun AutoBuff reconnu dans les chunks poison sélectionnés ; aucune absence globale d’effet conclue.

Font2816 : dégâts bruts par seconde pendant six secondes, six cumuls maximum, f1 inconnu. Font2815 décrit la victime et SourceName ; nom4471/description4295 conservés. Neuf BuffData/huit correspondances ; game_buff_tooltip_Hide reste absent, sans substitution HideInShadows. DDF20 : seul Expunge;f1=bonusattackdamage×0.25, distinct du passif. E communautaire magique/trois cumuls malgré commentaire six reste séparé de la référence native.

Onze préchargements,3654 octets d’identités : rôle de chaîne de poison pour CharScript953 ; DamageMarker639 décrit **six dépendances visuelles de compteurs**. Identités/rôles hérités, sans texte brut ni nombre de références typées reconstitué dans ces copies. Cela ne prouve ni création d’effet ni cap serveur. Reprise précise : DamageMarker.preload639/SHA `d9cdecf2a08a5700c60f549afbb125b71aca7f68e21bdf60c4700f867fe1d9db` ou CharScript953/SHA `cce6eae97c0217b3444d767e4b24d5daee47f912461ea736577bf48cc612acd3` attribué.

Trois DDS HUD relus dans E,64×64/sept mips bruts : Passive2872/DXT1,DeadlyVenom5616/DXT5,temp2872/DXT1. SHA respectifs `7def102aea2b1f57a87dd89ad3ea5b8b69f969f500e51c3ca17ec8e8bd141fbf`, `aac0c2bb2e2e2eb260bb80227c3ac3601bddd9343500923919e6e8aceadd4173`, `00b7094e2058225a0d40a9389e2090771e805abb457dcab2796caa830ff2f55f`. Membership hérité ; ce sont des icônes, sans qualification de texture Troy/provider/pixels. Provenance StatsJSON distincte de l’INIBIN conservée.

## 3. Consommateurs réels

Treize fichiers actuels,dont onze Rust et deux lecteurs Python ;26 ancres. Douze sources/frontières et32 contextes inchangés ;14 entrées communes VFX et deux liens d’animation ordinaire concordants.

attacks.rs:157 transmet le projectile à basic_attack_hit ;lifesteal.rs:4 appelle apply_damage en Physical. Tick/régénération et summoner_ignite restent des chemins génériques ou témoins. Ignite possède un état et des ticks en True distincts ; il n’est pas le producteur Twitch. Aucun hit nommé Twitch/DeadlyVenom dans onze préfixes Rust de production ; conclusion bornée.

Les anciens consommateurs PV/Mana et recherches HUD sont conservés après garde d’identité. Widget Ezreal, diagnostic Annie, projection/owner/ressources et animations ordinaires ne qualifient pas le poison ni la sélection de ses compteurs.

## 4. Attendu, observé et contrôles

Attendu : sources/contextes liés, acquis conservés et manque de présentation borné. Observé : marqueurs/icônes et dépendances décrits ; état autoritaire, recette et rendu spécifiques non établis.

35/35 contrôles documentaires,50/50 de cohérence séparée du même agent. HUD112/112 et77/77 hérités. V642 :niveaux1/18,sept impacts physiques chacun,aucun DOT supplémentaire dans ces scénarios ;277/178 frames d’attaque puis181 ticks après dernier impact. Les817 calculs de paires PV antérieurs sont réutilisés sans recalcul ;résidus physiques antérieurs inférieurs à0.002 PV. Sept attaques ne prouvent pas une saturation à six ;poison non amorcé,attente181 ne prouve pas son expiration.

Témoin Ignite hérité :cinq dégâts de14 aux temps0/30/60/90/120,total70 ;absence dès150,181 observations vérifiées antérieurement. Toutes ses paires PV brutes ne sont pas conservées ;aucun recalcul complet de régénération prétendu.

Six déplacements publics,6818 ticks archivés,deux apports XP diagnostiques100000 et58 refus hérités ;progression naturelle et toutes les paires de snapshots non qualifiées. Ancien RUN complet/1158 entrées non relus. Binaire6076928 octets,SHA `6c937b15f0bedbc3a5dcb4f901fe9d7a9ea8cf4e9b11ecdc587f40436270b7cc`, identité inerte.

Ancien bootstrap échoué avant extraction :différence exacte d’un nom Markdown revérifiée entre original/v2. Reçu d’échec d’inspection Hide et ancienne erreur exploratoire conservés ;aucun rejeu ni réparation produit. Aucune production actuelle échouée.

## 5. Écarts et inconnues

f1/table,phase/refresh,multisources,lifecycle,alias/variantes,transport,owner/attache,recette et pixels restent ouverts. **Le rendu effectif des compteurs reste non qualifié.** Persistance du marqueur et dépendances visuelles ne remplacent pas l’état serveur ou l’observation du rendu.

Aucun nouveau jeu/build,test Rust,décodage natif,REA,GPU,réseau/audio/rendu ;aucune revue indépendante/humaine ni qualification de l’inventaire secondaire complet.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses :POLICY-01 qualifie règles/alias/applicabilité ;STATE-01 produit poison par victime/source ;NETWORK relie transitions/audiences ;VFX relie compteurs et présentation au consommateur réel. Chaque clause précise prérequis,fin et reprise. HUD-BINDINGS existant conservé ;QWER distinct,attaque physique préservée.

Reprendre sur source/capture/callsite nouveau ou dérive ;implémentation soumise à autorisation distincte. next_lot.json vise Udyr :consulter ses audits avant toute acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_twitch_passive_vfx_20261106` :projections,fenêtres,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,avec sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
