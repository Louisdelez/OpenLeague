# SYS-01.2-02 — Twitch : Deadly Venom et HUD, V1286

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TWITCH-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Twitch-PASSIF-PRESENTATION-HUD`, `OLF-3cb69121-6cd5-50fa-b4c2-a3f1dbd7826f` : relier icônes, textes et états de poison/cumuls aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-c02e4050-e06d-5106-8245-9845aa92f203` ouverte. Six contrats et prérequis D06/D06-CH-Twitch consultés sans satisfaction revendiquée. Acquis V642 conservés ; SOURCE, SIMULATION, QWER et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/twitch-passive-deadly-venom-links-v642.json`, 2572351 octets/SHA `1fcf9f9eb347d921f52206e1da1725b46678dcecc335c8a954b7391cac452c6e`, UTC documentaire 2026-10-26T21:55:06.702221+00:00.

HUD enregistré : définition/CharScript et un catalogue. SOURCE :60 relations/54 identités/six sites ; V642 ajoute20 frontières, union26 ancres/12 fichiers. Réutilisation sans relecture native :20 INIBIN,21 Lua,11 preloads,DDF,font. Quatre archives sélectionnées sur E avant lecture F/OpenLeague-work :2598280 octets ; aucun binaire ou1158 dépendances copié/rejoué.

Alias de définition TwitchDeadlyVenomMarker ; icône Twitch_Passive.dds. Passive1/Passive1Desc et six champs de niveaux non résolus, sans valeurs inventées. CharScript56 vide ;21 Lua sans fonction enfant, sept limites NEWTABLE. Deadly_Venom/TwitchDeadlyVenom partagent BuffName mais déclarent des images différentes ; interne nommé « Deadly Venom » avec espace. Priorité effective inconnue. Persistance du marqueur du champion ne prouve pas celle du poison victime.

Font miroir d’identité native vérifiée :2816 décrit dégâts bruts chaque seconde pendant six secondes, six cumuls maximum, montant @f1@ inconnu ;2815 décrit la victime empoisonnée avec SourceName. Nom4471/description4295 résolus. Neuf BuffData : huit correspondances, game_buff_tooltip_Hide absent ; aucune substitution HideInShadows. DDF :20 lignes, seule Expunge;f1=bonusattackdamage×0.25 renseignée, sans résolution de f1 du passif. Communauté : E magique/trois cumuls fixes malgré commentaire six ; non promue en politique native.

Trois DDS nécessaires,64×64 et sept mips, tailles/MD5 concordants au projet RADS0.0.1.7 :

| Image | Octets / format | Membre | SHA-256 |
|---|---|---|---|
| Twitch_Passive.dds | 2872 / DXT1 | 0.0.0.209 | `7def102aea2b1f57a87dd89ad3ea5b8b69f969f500e51c3ca17ec8e8bd141fbf` |
| Twitch_DeadlyVenom.dds | 5616 / DXT5 | 0.0.0.111 | `aac0c2bb2e2e2eb260bb80227c3ac3601bddd9343500923919e6e8aceadd4173` |
| Twitch_DeadlyVenom_temp.dds | 2872 / DXT1 | 0.0.0.25 | `00b7094e2058225a0d40a9389e2090771e805abb457dcab2796caa830ff2f55f` |

Sélection E avant trois stat/lectures SOURCE,11360 octets ; aucun DDS étranger/particule lu. Provider, variante et pixels ouverts. resource_provenance.json distingue StatsJSON communautaire du hash INIBIN natif ; aucune relecture de ces payloads pour cette comparaison.

## 3. Consommateurs actuels

26 ancres exactes,32 fichiers code/configuration,16 entrées communes et20 identités comparables V642 inchangées. attack→projectile→basic_attack_hit→apply_damage constitue ici le chemin physique ; tick/régénération et Ignite restent des frontières ou témoins, pas le producteur Twitch.

Mana et PV disposent de consommateurs HUD génériques ; le widget passif Ezreal et le libellé diagnostic Annie restent spécifiques. Maxima QWER de Twitch non intégrés. Aucun Twitch/DeadlyVenom nommé dans les sources Rust sélectionnées ; recherche bornée, pas une preuve d’absence mondiale. Aucun compteur/texte/paramètre f1 ou choix de variante Twitch démontré par les seuls chargeurs.

## 4. Attendu, observé et contrôles

Attendu : conserver sources/acquis, établir producteur ou absence bornée et limites de présentation. Observé V642 : niveaux1/18, sept impacts physiques chacun, sans poison supplémentaire observé dans ces scénarios.277/178 frames d’attaque, puis181 ticks après dernier impact par cas ;817 paires PV adjacentes recalculées avec float32 et régénération capturée. Attendus physiques reconstitués depuis projectile/armure ; résidus inférieurs à0.002 PV. Sept attaques ne qualifient pas la saturation d’un compteur à six.

Témoin Ignite séparé : cinq dégâts de14 aux temps0/30/60/90/120,70 total ; buff absent dès150.181 observations attendues/observées vérifiées, mais paires PV brutes non conservées pour chaque frame du témoin : pas de recalcul indépendant de tous ses termes de régénération.

Six déplacements publics,6818 ticks archivés ; deux apports diagnostiques100000 XP au cas18, aucune progression naturelle.58 refus avec flags snapshot_unchanged ; toutes les paires de snapshots ne sont pas archivées. Aucun garde NPC universel inféré. Source Rust sans injection directe, RUN brut complet égal OBS, BUILD/RUN hérités0.

Binaire hérité inerte 6076928 octets/SHA `6c937b15f0bedbc3a5dcb4f901fe9d7a9ea8cf4e9b11ecdc587f40436270b7cc`, identité non fraîchement rehashée ; commandes/chemin conservés dans les archives.112/112 contrôles et77/77 cohérence séparée du même agent. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

Bootstrap initial : nom Markdown hérité incorrect, échec avant extraction du graphe ; original/logs conservés, unique correction du chemin et bootstrap02 réussi. Lecture exploratoire d’un compteur XP comme liste corrigée après TypeError. Ancienne inspection V642 échouée sur Hide conservée par son reçu, sans nouvel alias.

## 5. Écarts et inconnues

f1/table par niveau, phase des ticks, rafraîchissement, ordre, propriétaires multiples, exceptions, cycle de vie, transport et pixels restent ouverts. Aucun dégât natif chiffré inventé. Les flags de marqueur et les six compteurs d’un preload ne constituent pas des callbacks ou une preuve de cap. E et ses différences communautaires restent une tâche distincte.

## 6. Corrections et reprise

`COR-TWITCH-DEADLY-VENOM-POLICY-01` : qualifier montant f1, temps, rafraîchissement, cumul et propriétaires. Fin : contrat historique sourcé, alias et règle E séparés.

`COR-TWITCH-DEADLY-VENOM-STATE-01` : produire poison autoritaire par victime/source, cumuls, dégâts et expiration selon contrat. Fin : applications, cap, frontières, rafraîchissements, morts/refus et interactions vérifiés ; ne pas bloquer l’attaque de base sur tout QWER.

`COR-TWITCH-DEADLY-VENOM-HUD-BINDINGS-01` : relier marqueur champion, buff victime, icônes, texte, f1/cumuls/durée et audiences à l’état réel. Fin : bonnes variantes/SourceName, transitions, transport, tooltip et pixels observés. Ne pas réutiliser Ignite ou Ezreal comme preuve Twitch. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_twitch_passive_hud_20261105` : evidence_review/coherence_review, archives, DDS, resource_provenance.json, prérequis, journaux et qualification bootstrap. Contrôle hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à la publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
