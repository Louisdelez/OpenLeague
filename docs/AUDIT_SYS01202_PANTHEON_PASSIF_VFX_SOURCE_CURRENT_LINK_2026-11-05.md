# SYS-01.2-02 — Pantheon : sources et consommateurs VFX du passif, V1388

Lot ouvert le 5 novembre 2026 UTC ; livraison datée dans le reçu. Unité `AUD-SYS-01.2-02-PANTHEON-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, gameplay et acceptation humaine restent ouverts.

## 1. Exigence et frontières

`CH-Pantheon-PASSIF-PRESENTATION-VFX`, `OLF-9ea45f17-2b1f-53d0-9452-11a5af112504` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnue VFX `OLU-4948f59c-dd87-5ad5-a193-a8d5d2494ca3` et SOURCE `OLU-bb55debc-a7c7-59de-9c02-c2003226fb60` ouvertes. Phase et prérequis examinés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/pantheon-passive-aegis-protection-links-v614.json`,2525043octets, SHA `b572b4701b74f5d052ac53303c45679b5fb8030017ce2ee048434cfc5396767f`. UTC documentaire2026-10-26T12:56:12.023522+00:00, sans heure d’exécution déduite.

97 identités natives ;37Lua,29 initialisations littérales,69globals et huit limites NEWTABLE. Zéro prototype enfant selon les reçus ne qualifie pas le serveur original. Globals conservés par chemin complet :cinq paires de basenames d’attaque ont des SHA différents, sans priorité runtime établie. CharScript56 est vide.

Définition :`Pantheon Aegis` et Pantheon_AOZ.dds. Passive/Aegis211, Counter228 et Shield156/154 conservent leurs BuffName distincts :espaces/underscores ne sont pas des alias prouvés. Douze références BuffData :six correspondances, cinq clés distinctes, six non résolues. Anciens textes MasterYi, Certain Death de E, DDF et scripts communautaires restent des contextes séparés.

Description4254 :quatre attaques ou sorts préparent le blocage d’une attaque normale ou de tourelle. Counter2446 et Shield2447 décrivent charge/protection ; rafraîchissement W lié dans le reçu, politique d’événement/consommation non qualifiée. PersistsThroughDeath/NonDispellable ne qualifient pas mort/respawn.

25 preloads5598octets et69 références typées :21particules/48sorts. Discovery1152299octets/SHA57e796a169011c0dac4937edf8f849929be3d2e8e70b63a70b7f8aded5426cb8 retient le texte ; reconstruction CRLF exacte des25identités, sans lecture native.

La chaîne compacte Passive→Counter/Shield/riscasting mène au preload `pantheon_base_p_buf.troy`. La chaîne Aegis à underscores cite aegisshield2/aegisshield/aegis_counter et `pantheon_aoz_passive.troy`. `Pantheon_LeapBash.luaobj`288 porte l’unique AutoBuffActivateEffect reconnu, `pantheon_aegis_self.troy`, et précharge shield/counter. Ces liens ne suffisent pas à qualifier création, priorité, état prêt ou blocage rendus ; aucune substitution entre les trois particules.

Trois DDS E relus :4224octets chacun,64×64DXT5,mip1. Deux AOZ normaux SHA `50e1f29a6cef3a865aa917b610da0f1a7bcd9d0dfba50c983118d5469832a3c9` identiques ; Charging SHA `1450ada38d1556542d91c4350ba0068b2034829824c7d0ddcb38f7726b54a867` distinct. Membres0.0.0.25/0.0.0.107 hérités du projet0.0.1.7. Identité/en-tête ne prouvent ni lookup, variante ou pixels. Mana source_sha2a1ae507… correspond au JSON communautaire7402octets ; natif2659octets/SHA77dc4d23… distinct.

## 3. Consommateurs actuels

16 fichiers inspectés, dont14Rust/deux lecteurs Python ;30ancres SOURCE/frontières relues. Identités des15fichiers antérieurs et29contextes inchangées. Recherche nominative sans hit dans ces14Rust, sans absence globale revendiquée.

`damage.rs:91` conduit mitigation→absorb_shields→PV. `shields.rs:47` consomme des montants remaining par expiration. Ce bouclier générique ne démontre pas le blocage d’une attaque par Aegis. Aucun compteur/protection Pantheon retrouvé dans ces routes. Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ; ni recette passive, registration, clip ou pixels acceptés par ce seul lien.

## 4. Attendu et observé

Attendu :charge, état prêt, blocage/consommation et présentation attribuable. Hérité V614/HUDV1258 :deux cas niveau1, base/Armure1029+15, AD55,572/PVmax579,16 ;16attaques sortantes,18impacts physiques entrants,deuxQAnnie,54refus,quatretrajets aboutis.

Les18comptes antérieurs aux impacts sont recomparés aux ticks sortants :0/4/8, trois impacts par étape et par cas. Il s’agit de comptes observés, pas d’un compteur natif. Aucun impact enregistré bloqué ; tous restent positifs et concordent avec la mitigation générique à0,002 près. Armure27,652/42,652, dommages attendus39,49017715/35,33774185 :l’objet réduit les dégâts, quatre attaques ne produisent aucune protection observée. Arithmétique documentaire sur captures conservées ; moteur non rejoué.

QAnnie est un contrôle générique sans protection produite ; aucune conservation d’Aegis déduite. W, tourelles, sbires, monstres et simultanéité non exercés.

Actuel :40/40 documentaires et61/61 cohérence par le même agent. Sept opérations journalisées, six succès ; collect01 a échoué en compilation sur l’échappement du script généré, corrigé avant collect02. Script/logs/terminal préservés. `collector_failure_scope_clarification.json` rectifie la formulation initiale :le hook avait lu adaptateur/enveloppe, sans atteindre les preuves sélectionnées. Aucun asset modifié.

Trois JSON et deux reçus bruts anciens BUILD/RUN0 relus. Binaire6114816octets/SHA3182eb5debf3f6467330df3c70e3c415c0b7844bee0824ec4469f0ce80050b7d inerte, jamais ouvert. HUD67/67 et55/55 hérités ; son ancien échec de synthèse globals_by_name corrigé par reprise globals_by_path reste archivé et vérifié. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Événements de charge, sorts admissibles, consommation/réarmement/W, priorités des variantes et recettes ouvertes. Owner, attache, durée/arrêt, rendu, on-hit/boucliers/immunités, impacts simultanés, annulations, mort/respawn et réseau non qualifiés. Tests hérités limités au niveau1 et aux deux cas indiqués. Anciennes limites pré-impact/refus/NPC, V564 et échecs Nami conservées. Aucune acceptation gameplay supplémentaire.

## 6. Corrections et reprise

`corrections_and_restart.json` contient cinq clauses sur IDs existants :politique charge/blocage ; bindings/recettes et variantes ; compteur/prêt/blocage au vrai impact ; état réseau/lifecycle ; présentation/ressources. Chaque clause possède objectif, prérequis, critères de fin et entrée de reprise. Préserver le contrôle Armure. Reprendre sur preuve native/capture précise, dérive ou autorisation distincte d’implémenter ; aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_pantheon_passive_vfx_20261105`, evidence_review/coherence_review, gardes, journaux et échec conservé. `next_lot.json` cible Poppy, ligne de couverture vérifiée. Sept rubriques relues ; une unité de liaison bornée close, zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
